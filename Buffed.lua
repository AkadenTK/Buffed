_addon.name = 'Buffed'
_addon.version = '0.8'
_addon.author = 'Akaden'
_addon.commands = { 'buffed', 'bf' }

require('pack')
require('tables')
require('coroutine')
local config = require('config')
local packets = require('packets')
local images = require('images')
local texts = require('texts')
local res = require('resources')
local icon_extractor = require('icon_extractor')

local timer_format = {
    text = { size=9,font='Consolas',stroke={width=1,alpha=255,red=0,green=0,blue=0}},
    flags = {bold=false,draggable=false,italic=true},
    bg = {visible=false}
}
local counter_format = {
    text = { size=11,font='Consolas',stroke={width=1,alpha=255,red=0,green=0,blue=0}},
    flags = {bold=true,draggable=false,italic=true},
    bg = {visible=false}
}
local demo_format = {
    text = { size=13,font='Consolas',stroke={width=1,alpha=255,red=0,green=0,blue=0}},
    flags = {bold=true,draggable=false,italic=true},
    bg = {visible=false}
}

-- avatar favors, geomancy 
local always_aura_statuses = S{422, 423, 424, 425, 426, 427, 428, 429, 430, 431, 539, 540, 541, 542, 543, 544, 545, 546, 547, 548, 549, 550, 551, 552, 553, 554, 555, 556, 557, 558, 559, 560, 561, 562, 563, 564, 565, 566, 567, 580}
-- debuffs that restrict movement and/or turning, buffs that change behaviors of spells or enable spells in the menu MUST fall through.
local forced_fall_through_statuses = S{0, 2, 7, 10, 11, 19, 284, 358, 359, 377, 401, 402, 409, 485, 505}

local defaults = {
    theme = 'classic',
    block = 'none', -- all: hide every status effect in vanilla client, none: don't hide anything, captured: hide only statuses captured in separate groups
    stack_statuses = true,
    right_click_cancel = false,
    hover_highlight = { r = 255, g = 170, b = 0, a = 128},
    groups = {
        {
            name = 'job',
            pos = {x = 1415, y = 100},
            order = 'given',
            direction = 'left-to-right',
            size = 22,
            columns = 10,
            flash_at = 15,
            show_background = false,
            max_seconds = 60,
        },
        {
            name = 'debuffs',
            pos = {x = 885, y = 100},
            order = 'given',
            direction = 'left-to-right',
            size = 22,
            columns = 10,
            flash_at = 15,
            show_background = false,
            max_seconds = 60,
        },
        {
            name = 'power buffs',
            pos = {x = 1415, y = 50},
            order = 'given',
            direction = 'left-to-right',
            size = 22,
            columns = 10,
            flash_at = 15,
            show_background = false,
            max_seconds = 60,
        },
        {
            name = 'defensive buffs',
            pos = {x = 885, y = 50},
            order = 'given',
            direction = 'left-to-right',
            size = 22,
            columns = 10,
            flash_at = 15,
            show_background = false,
            max_seconds = 60,
        },
    },
}
local settings = config.load(defaults)

local windower_settings = windower.get_windower_settings()
for _, group in ipairs(settings.groups) do
    local w, h = group.size * group.columns + (4 * (group.columns - 1)) + 12, group.size + 4
    local left = group.pos.x
    if group.direction == 'right-to-left' then
        left = left - w
    end
    if group.pos.x + w > windower_settings.ui_x_res then
        if group.direction == 'right-to-left' then
            group.pos.x = windower_settings.ui_x_res
        else
            group.pos.x = windower_settings.ui_x_res - w
        end
    end
    if group.pos.y + h > windower_settings.ui_y_res then
        group.pos.y = windower_settings.ui_y_res - h
    end
end

settings:save()

local status_map = require('data/status_map')

function buff_offset()
    local vana_time = os.time() - 1009810800

    return math.floor(os.time() - (vana_time * 60 % 0x100000000) / 60)
end

local state = {
    --statuses = T{},
    groups = {},
    backgrounds = {},
    demo_titles = {},
    demo = false,
    offset = buff_offset(),
}

local ensure_icon_image = function(id)
    local icon_path = string.format('%sicons/%s/%s.bmp', windower.addon_path, settings.theme, id)
    if not windower.file_exists(icon_path) then
        icon_extractor.buff_by_id(id, icon_path)
    end
    return icon_path
end

local get_group_statuses = function(group)
    if status_map[group.name].statuses then
        return status_map[group.name].statuses
    elseif status_map[group.name].statuses_by_job then
        local player = windower.ffxi.get_player()
        local job_string = player.main_job:lower()..'_'..player.sub_job:lower()
        if status_map[group.name].statuses_by_job[job_string] then
            return status_map[group.name].statuses_by_job[job_string]
        end

        job_string = player.main_job:lower()
        if status_map[group.name].statuses_by_job[job_string] then
            return status_map[group.name].statuses_by_job[job_string]
        end
    end
end

local group_match = function(group, map)
    local statuses = get_group_statuses(group)
    if statuses and (statuses:contains(map.en) or statuses:contains(map.enl)) then
        return true
    end
end

local from_server_time = function(t)
    return t / 60 + state.offset
end

local to_server_time = function(t)
    return (t - state.offset) * 60
end

local build_unhandled_buffs_packet = function(data, unhandled)
    local r = data:sub(1, 8)

    for i = 1, 32 do
        r = r..'H':pack(unhandled[i] and unhandled[i].id or 255)
    end
    for i = 1, 32 do
        r = r..'i':pack(unhandled[i] and to_server_time(unhandled[i].endtime) or 0)
    end

    return r
end

local build_unhandled_pc_packet = function(data, unhandled)
    local r = data:sub(1, 4)

    for i = 1, 31 do
        r = r..'b8':pack(unhandled[i] and (unhandled[i].id % 256) or 255)
    end

    r = r..data:sub(0x24, 0x4C)

    for i = 1, 29, 4 do
        r = r..'b2b2b2b2':pack(unhandled[i]   and math.floor(unhandled[i].id / 256)   or 0, 
                               unhandled[i+1] and math.floor(unhandled[i+1].id / 256) or 0,
                               unhandled[i+2] and math.floor(unhandled[i+2].id / 256) or 0,
                               unhandled[i+3] and math.floor(unhandled[i+3].id / 256) or 0)
    end

    r = r..data:sub(0x55)

    --print(#r..' '..#data)

    return r
end



local index_of = function(haystack, needle)
    for i, v in ipairs(haystack) do
        if v == needle then
            return i
        end
    end
end

local sort_statuses = function(group)
    local fn
    local statuses = get_group_statuses(group)

    local order_tokens = group.order:split('|')
    local order = order_tokens[1]
    local reverse = order_tokens[2] or false

    if order == 'given' then
        fn = function(i)
            return index_of(statuses, i.map.en)
        end
    elseif order == 'endtime' then
        fn = function(i)
            return i.endtime
        end
    elseif order == 'byid' then
        fn = function(i)
            return i.id
        end
    end

    table.sort(state.groups[group.name].statuses, function(a, b)
        local va, vb = fn(a), fn(b)
        if va == vb then
            va, vb = a.endtime, b.endtime
        end
        if reverse then
            return vb < va
        else
            return va < vb
        end
    end)
end

local filter_buffs = function(read_statuses, apply)
    local unhandled_statuses = T{}
    local counters = T{}

    local old_statuses = T{}
    -- parse it out.
    for _, group in ipairs(settings.groups) do
        if apply and state.groups[group.name] then
            for i, s in ipairs(state.groups[group.name].statuses) do
                old_statuses[s.id] = s
            end
            state.groups[group.name].statuses:clear()
        end
    end
    for i = 1, #read_statuses do
        local s = read_statuses[i]
        if s then
            local filtered = false
            for _, group in ipairs(settings.groups) do
                if not filtered then
                    local map = res.buffs[s.id]
                    if group_match(group, map) then
                        if apply then
                            if not state.groups[group.name] then
                                state.groups[group.name] = { statuses = T{}, images = T{}, timers = T{}, counters = T{}, highlights = T{}, }
                            end

                            local new_s = { id = s.id, map = map, endtime = s.endtime}
                            -- if (old_statuses[s.id] and old_statuses[s.id].aura) or (not old_statuses[s.id] and s.endtime - os.time() <= 5) then
                            if always_aura_statuses:contains(s.id) then
                                new_s.aura = true
                            end
                            state.groups[group.name].statuses:append(new_s)
                        end
                        --filtered = true 
                        filtered = not forced_fall_through_statuses:contains(s.id) and s.id ~= 0
                    end
                end
            end 
            if not filtered then
                unhandled_statuses:append(s)
            end
        end
    end
    if apply then
        for _, group in ipairs(settings.groups) do
            local g = state.groups[group.name]
            if g then
                sort_statuses(group)
            end
        end
    end

    return unhandled_statuses
end

function has_bit(data, x)
  return data:unpack('q', math.floor(x/8)+1, x%8+1)
end

local handle_incoming = function(id, data, modified, injected)
    if injected then return end
    if id == 0x063 then
        local order = data:unpack('H',0x05)
        if order == 9 then
            local read_statuses = {}

            -- read ids
            for i = 1, 32 do
                local index = 0x09 + ((i-1) * 0x02)
                local status_i = data:unpack('H', index)

                if status_i ~= 255 then
                    read_statuses[i] = { id = status_i }
                end
            end
            -- read times
            for i = 1, 32 do
                if read_statuses[i] then
                    local index = 0x49 + ((i-1) * 0x04)
                    local endtime = data:unpack('I', index)

                    read_statuses[i].endtime = from_server_time(endtime)
                end
            end

            local unhandled_statuses = filter_buffs(read_statuses, true)

            if settings.block == 'all' then
                return build_unhandled_buffs_packet(data, {})
            elseif settings.block == 'captured' then
                return build_unhandled_buffs_packet(data, unhandled_statuses)
            end
        end
    elseif id == 0x037 then
        local p = packets.parse('incoming', data)
        if p['Timestamp'] and p['Time offset?'] then
            local vana_time = p['Timestamp'] * 60 - math.floor(p['Time offset?'])
            state.offset = math.floor(os.time() - vana_time % 0x100000000 / 60)
        end
        local read_statuses = {}
        for i = 1, 32 do
            local index = 0x05 + (i-1)
            local status_i = data:unpack('b8', index)

            if status_i ~= 255 then
                read_statuses[i] = { id = status_i }
            end
        end

        for i = 1, 32 do
            local index = 0x04C * 8 + (i-1)*2
            local n = has_bit(data, index) and 1 or 0
            n = n + (has_bit(data, index + 1) and 2 or 0)
            if read_statuses[i] then
                read_statuses[i].id = read_statuses[i].id + n*256
            end
        end

        local unhandled_statuses = filter_buffs(read_statuses)

        if settings.block == 'all' then
            return build_unhandled_pc_packet(modified, {})
        elseif settings.block == 'captured' then
            return build_unhandled_pc_packet(modified, unhandled_statuses)
        end
    end
end

windower.register_event('incoming chunk', handle_incoming)

local get_time_string = function(seconds, max_seconds)
    if seconds < 0 or seconds > 99 * 60 * 60 then
        return ""
    elseif seconds <= max_seconds - 1 then
        return string.format("%i", math.ceil(seconds))
    elseif seconds < 60 * 60 then
        return string.format("%im", math.max(1, seconds / 60))
    else
        return string.format("%ih", math.max(1, seconds / 60 / 60))
    end
end

local get_stacked_statuses = function(group, statuses)
    local counters = T{}
    local index_map = T{}
    local stacked = T{}

    for i, s in ipairs(statuses) do
        if s then
            counters[s.id] = counters[s.id] and counters[s.id] + 1 or 1

            if counters[s.id] > 1 and settings.stack_statuses and (not status_map[group.name].stack_blacklist or not status_map[group.name].stack_blacklist:contains(s.map.en)) then
                stacked[index_map[s.id]].count = counters[s.id]
                stacked[index_map[s.id]].endtime = math.min(s.endtime, stacked[index_map[s.id]].endtime)
            else
                stacked:append({id = s.id, endtime = s.endtime, count = 1, aura = s.aura})
                index_map[s.id] = #stacked
            end
        end
    end

    return stacked
end

windower.register_event('prerender', function()
    local flash_point = (math.sin(os.clock() % 1 * math.pi * 2) + 1) / 3 + 0.333
    for _, group in ipairs(settings.groups) do
        local g = state.groups[group.name]
        local stacked_statuses 
        if (state.demo or (group.show_background and g)) and not state.in_cs then
            if g then
                stacked_statuses = get_stacked_statuses(group, g.statuses)
            end
            local rows = (state.demo and 2 or math.ceil(#(stacked_statuses) / group.columns)) -- demo 2 rows, 3 is unlikely but 2 is possible.
            local cols = (state.demo and group.columns or math.min(group.columns, #stacked_statuses))
            local w, h = group.size * cols + (4 * (cols - 1)) + 8, group.size * rows + (4 * (rows - 1)) + 12
            local x, y = group.pos.x - 4, group.pos.y - 4
            if group.direction == 'right-to-left' then
                x = x - w
            end
            if not state.backgrounds[group.name] then
                --print(x..', '..y)
                state.backgrounds[group.name] = images.new({draggable = true, visible = false,})
                state.backgrounds[group.name]:pos(x, y)
                state.backgrounds[group.name]:path(windower.addon_path..'background.png')
                state.backgrounds[group.name]:color(0, 0, 0)
                state.backgrounds[group.name]:alpha(128)
                state.backgrounds[group.name]:repeat_xy(100, 100)
            end 
            state.backgrounds[group.name]:size(w, h)
            state.backgrounds[group.name]:show()

            x, y = state.backgrounds[group.name]:pos()
            group.pos.x, group.pos.y = x + 4, y + 4
            if group.direction == 'right-to-left' then
                group.pos.x = group.pos.x + w
            end

            if state.demo then 
                if not state.demo_titles[group.name] then
                    demo_format.pos = {x=x, y=y}
                    state.demo_titles[group.name] = texts.new('', demo_format)
                end 
                state.demo_titles[group.name]:pos(x, y)
                state.demo_titles[group.name]:text(state.demo and group.name or '')
                state.demo_titles[group.name]:show()
            end
        else
            if state.backgrounds[group.name] then 
                state.backgrounds[group.name]:hide()
            end
            if state.demo_titles[group.name] then 
                state.demo_titles[group.name]:hide()
            end
        end
        if g then
            if state.in_cs then
                for _, hgh in ipairs(state.groups[group.name].highlights) do
                    hgh:hide()
                end
                for _, img in ipairs(state.groups[group.name].images) do
                    img:hide()
                end
                for _, timer in ipairs(state.groups[group.name].timers) do
                    timer:hide()
                end
                for _, counter in ipairs(state.groups[group.name].counters) do
                    counter:hide()
                end
            else
                local x, y = group.pos.x, group.pos.y
                if group.direction == 'right-to-left' then
                    x = x - group.size
                end
                local col1 = x
                if not stacked_statuses then 
                    stacked_statuses = get_stacked_statuses(group, g.statuses)
                end
                --print(group.name..':  #'..#g.statuses)
                for i, s in ipairs(stacked_statuses) do
                    if not g.highlights[i] then
                        g.highlights[i] = images.new({draggable = false, visible = false})
                        g.highlights[i]:path(windower.addon_path..'background.png')
                        g.highlights[i]:color(settings.hover_highlight.r, settings.hover_highlight.g, settings.hover_highlight.b)
                        g.highlights[i]:alpha(settings.hover_highlight.a)
                        g.highlights[i]:hide()
                    end
                    g.highlights[i]:pos(x, y)
                    g.highlights[i]:fit(true)
                    g.highlights[i]:size(group.size, group.size)

                    if not g.images[i] then
                        g.images[i] = images.new({ draggable = false, visible = false })
                        g.images[i]:hide()
                    end

                    local icon_path = ensure_icon_image(s.id)

                    local loaded_path = false
                    if g.images[i]:path() ~= icon_path then
                        if windower.file_exists(icon_path) then
                            g.images[i]:path(icon_path)
                            loaded_path = true
                        end
                    else
                        loaded_path = true
                    end

                    g.images[i]:pos(x, y)
                    g.images[i]:fit(true)
                    g.images[i]:size(group.size, group.size)

                    if loaded_path then
                        g.images[i]:show()
                    else
                        g.images[i]:hide()
                    end

                    local seconds = s.endtime - os.time()

                    if seconds > 0 and seconds < group.flash_at and not s.aura then
                        g.images[i]:alpha(flash_point * 255)
                    else
                        g.images[i]:alpha(255)
                    end

                    local time_string = get_time_string(seconds, group.max_seconds)

                    if not g.timers[i] then
                        g.timers[i] = texts.new(time_string, timer_format)
                    else
                        g.timers[i]:text(time_string)
                    end

                    g.timers[i]:pos(math.floor(x + (group.size / 2 - (time_string:length() * 7 / 2))), math.floor(y + (group.size * 2 / 3)))

                    if seconds > 0 and not s.aura then
                        g.timers[i]:show()
                    else
                        g.timers[i]:hide()
                    end      

                    if not g.counters[i] then
                        g.counters[i] = texts.new("${buff_count||%i}", counter_format)
                    end

                    g.counters[i]:pos(x + (group.size - 7), y - 7)
                    g.counters[i].buff_count = s.count

                    if s.count > 1 then
                        g.counters[i]:show()
                    else
                        g.counters[i]:hide()
                    end                

                    if i % group.columns == 0 then
                        y = y + group.size + 4
                        x = col1
                    else
                        if group.direction == 'left-to-right' then
                            x = x + group.size + 4
                        else
                            x = x - group.size - 4
                        end
                    end
                end
                if #g.highlights > #stacked_statuses then
                    for i = #stacked_statuses + 1, #g.highlights do
                        if g.highlights[i] then
                            g.highlights[i]:hide()
                        end
                    end
                end
                if #g.images > #stacked_statuses then
                    for i = #stacked_statuses + 1, #g.images do
                        if g.images[i] then
                            g.images[i]:hide()
                        end
                    end
                end
                if #g.timers > #stacked_statuses then
                    for i = #stacked_statuses + 1, #g.timers do
                        if g.timers[i] then
                            g.timers[i]:hide()
                        end
                    end
                end
                if #g.counters > #stacked_statuses then
                    for i = #stacked_statuses + 1, #g.counters do
                        if g.counters[i] then
                            g.counters[i]:hide()
                        end
                    end
                end
            end
        end
    end
end)
windower.register_event('status change', function(new_status_id)
    if new_status_id == 4 then
        state.in_cs = true
    else
        state.in_cs = false
    end
end)
windower.register_event('zone change', 'job change', function()
    for _, group in pairs(state.groups) do
        group.statuses:clear()
        for _, hgh in ipairs(group.highlights) do
            hgh:destroy()
        end
        for _, img in ipairs(group.images) do
            img:destroy()
        end
        for _, timer in ipairs(group.timers) do
            timer:destroy()
        end
        for _, counter in ipairs(group.counters) do
            counter:destroy()
        end
    end
    state.groups = T{}
end)

windower.register_event('addon command', function(...)
    local args = T{...}
    if #args == 0 then 
        print('Buffed: invalid number of arguments')
        return
    end
    local cmd = args[1]
    args:remove(1)
    
    if S{'demo','test','setup','move','layout'}:contains(cmd:lower()) then
        state.demo = not state.demo
        if state.demo then
            print('Buffed: Layout mode active')
        else
            settings:save()
            print('Buffed: Layout mode disabled')
        end
    elseif S{'theme'}:contains(cmd:lower()) then
        local new_theme = args:concat(' ')
            if windower.dir_exists(string.format("%sicons/%s", windower.addon_path, new_theme)) then
            settings.theme = new_theme
            settings:save()
            print('Buffed: New theme: '..new_theme)
        else
            print('Buffed: Theme not found: '..new_theme)
        end
    elseif S{'block'}:contains(cmd:lower()) and #args > 0 and S{'all', 'none', 'captured'}:contains(args[1]:lower()) then
        settings.block = args[1]:lower()
        settings:save()
        print('Buffed: Will now block status these effects: '..settings.block)
    end
end)

local get_debuff_from_pos = function(x, y)
    for _, group in ipairs(settings.groups) do
        local g = state.groups[group.name]
        if g then
            for i = 1, #g.statuses do
                if g.images[i] and g.images[i]:hover(x, y) then
                    return g.statuses[i].id, group.name, i
                end
            end
        end
    end
end

windower.register_event('mouse', function(m, x, y, delta, blocked)
    if not settings.right_click_cancel then return end

    if m == 0 then
        local id, group, i = get_debuff_from_pos(x, y)
        for n, g in pairs(state.groups) do
            for i = 1, #g.statuses do
                if g.highlights[i] then
                    g.highlights[i]:hide()
                end
            end
        end

        if id and state.groups[group] and state.groups[group].highlights[i] then
            state.groups[group].highlights[i]:show()
            state.last_highlight = { group = group, i = i}
        end
    elseif m == 4 then -- right down
        local d, group, i = get_debuff_from_pos(x, y)
        state.dragged = nil
        if delta and d then
            --print('dragged')
            state.dragged = d
        end
        if d then

            return true
        end
    elseif m == 5 then -- right release
        local d = get_debuff_from_pos(x, y)
        if d then
            if state.dragged == d then
                windower.send_command('cancel '..d)
                --print('cancel '..d)
                return true
            elseif state.dragged ~= nil then
                state.dragged = nil
                return true
            else
                state.dragged = nil
                return false

            end
        end

        if state.dragged then
            state.dragged = nil
            return true
        end
        state.dragged = nil
    end 
end)

windower.register_event('load', function()
    local info = windower.ffxi.get_info()
    if not info.logged_in then return end 

    local p = windower.packets.last_incoming(0x37)
    local m = handle_incoming(0x37, p, p)
    if m then
        packets.inject(packets.parse('incoming', m))
    end
    local p = windower.packets.last_incoming(0x63)
    local m = handle_incoming(0x63, p, p)
    if m then
        packets.inject(packets.parse('incoming', m))
    end
end)

windower.register_event('unload', function()
    local info = windower.ffxi.get_info()
    if not info.logged_in then return end 

    local p = windower.packets.last_incoming(0x63)
    packets.inject(packets.parse('incoming', p))

    local p = windower.packets.last_incoming(0x37)
    packets.inject(packets.parse('incoming', p))
    
end)