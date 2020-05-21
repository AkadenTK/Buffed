# buffed

NOTE: This is still in early beta, there will be issues. Please submit them in the issue tracker on Github.

This is an addon for Windower4 for FFXI. It allows separating status icons out into separate groups and allows you to position them however you like. There are additional QoL features for this.

This addon can block the client from "seeing" that a status effect is active based on the settings. By default, no status effects are blocked. My personal choice is to block "captured" status effects so that they are not in two places on screen.

This addon uses Rubenator and Trv's lib for reading icons from the game client's DAT files. However, there are two themes included: Jeanpaul's workshop icons (my favorite), and XIView.

This addon also defaults to collapsing multiple buffs of the same type into one icon, with a counter. I plan on having a setting to disable this.

With an option turned on, the user can right-click a buff icon to cancel it. This option is off by default, but can be found in ./data/settings.xml under "right_click_cancel"

### Commands:

| Command | Action |
| --- | --- |
| //bf layout  | Enable or exit Layout mode. Enables you to organize the frames of status effects by dragging them around. |
| //bf block [all/none/captured]  | Select which status effects to block from the game client. "all" will block all status effects. "none" will not block any status effects from the client (they will be in two places on screen). And "captured" will block all status effects captured by any frames through buffed. Any status effects not captured by a frame will fall through to the client and be displayed in the usual place. |
| //bf theme [name] | Switches themes to the given theme name. Note that a folder in the ./icons/ folder must exist for this to work. Any new icons not present in the theme folder will be pulled from the game's DAT files. |