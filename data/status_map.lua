return {
    job = {
        stack_blacklist = T{},
        statuses_by_job = { -- prioritize main/sub to main
            ['war_nin'] = T{
                'Copy Image (3)', 'Copy Image (2)', 'Copy Image', 
                'Mighty Strikes', 'Brazen Rush', 'Restraint', 'Berserk', 'Warcry', 'Blood Rage', 'Aggressor', 'Retaliation', 'Warrior\'s Charge', 
            },
            ['war_sam'] = T{'Mighty Strikes', 'Brazen Rush', 'Restraint', 'Hasso', 'Berserk', 'Warcry', 'Blood Rage', 'Aggressor', 'Retaliation', 'Warrior\'s Charge', },
            ['war'] = T{'Mighty Strikes', 'Brazen Rush', 'Restraint', 'Berserk', 'Warcry', 'Blood Rage', 'Aggressor', 'Retaliation', 'Warrior\'s Charge', },
            ['mnk'] = T{'Counterstance', 'Perfect Counter', 'Formless Strikes', 'Boost', 'Impetus', 'Focus', 'Footwork', },
            ['whm'] = T{'Reraise', 'Afflatus Solace', 'Afflatus Misery', 'Divine Seal', 'Aquaveil', 'Stoneskin'},
            ['whm_sch'] = T{'Reraise', 'Afflatus Solace', 'Afflatus Misery', 'Sublimation: Activated', 'Sublimation: Complete', 'Aurorastorm', 'Divine Seal', 'Aquaveil', 'Stoneskin'},
            ['blm'] = T{'Manafont', 'Subtle Sorcery', 'Mana Wall', 'Firestorm', 'Hailstorm', 'Windstorm', 'Sandstorm', 'Thunderstorm', 'Rainstorm', 'Aurorastorm', 'Voidstorm', 'Manawell', 'Cascade'},
            ['blm_sch'] = T{'Manafont', 'Subtle Sorcery', 'Mana Wall', 'Sublimation: Activated', 'Sublimation: Complete', 'Firestorm', 'Hailstorm', 'Windstorm', 'Sandstorm', 'Thunderstorm', 'Rainstorm', 'Aurorastorm', 'Voidstorm', 'Manawell', 'Cascade'},
            ['blm_rdm'] = T{'Manafont', 'Subtle Sorcery', 'Mana Wall', 'Refresh', 'Firestorm', 'Hailstorm', 'Windstorm', 'Sandstorm', 'Thunderstorm', 'Rainstorm', 'Aurorastorm', 'Voidstorm', 'Manawell', 'Cascade'},
            ['rdm_nin'] = T{
                'Copy Image (3)', 'Copy Image (2)', 'Copy Image', 
                'Composure', 'Chainspell', 'Stymie', 'Saboteur', 
                'Haste', 'Multi Strikes', 
                'STR Boost', 'DEX Boost', 'VIT Boost', 'AGI Boost', 'INT Boost', 'MND Boost', 'CHR Boost', 
                'Enfire', 'Enblizzard', 'Enaero', 'Enstone', 'Enthunder', 'Enwater', 'Enlight', 'Endark', 'Enfire II', 'Enblizzard II', 'Enaero II', 'Enstone II', 'Enthunder II', 'Enwater II', 
            }, 
            ['rdm'] = T{
                'Composure', 'Chainspell', 'Stymie', 'Saboteur', 
                'Haste', 'Multi Strikes', 
                'STR Boost', 'DEX Boost', 'VIT Boost', 'AGI Boost', 'INT Boost', 'MND Boost', 'CHR Boost', 
                'Enfire', 'Enblizzard', 'Enaero', 'Enstone', 'Enthunder', 'Enwater', 'Enlight', 'Endark', 'Enfire II', 'Enblizzard II', 'Enaero II', 'Enstone II', 'Enthunder II', 'Enwater II', 
            }, 
            ['thf'] = T{'Perfect Dodge', 'Sneak Attack', 'Trick Attack', 'Assassin\'s Charge'},
            ['thf_nin'] = T{
                'Copy Image (3)', 'Copy Image (2)', 'Copy Image', 
                'Perfect Dodge', 'Sneak Attack', 'Trick Attack', 'Assassin\'s Charge',
            },
            ['pld'] = T{'Invincible', 'Fealty', 'Cover', 'Enmity Boost','Sentinel', 'Palisade', 'Reprisal', 'Rampart'},
            ['pld_blu'] = T{'Invincible', 'Fealty', 'Cover', 'Enmity Boost', 'Defense Boost', 'Sentinel', 'Palisade', 'Reprisal', 'Rampart'},
            ['pld_war'] = T{'Invincible', 'Fealty', 'Cover', 'Enmity Boost', 'Defender', 'Sentinel', 'Palisade', 'Reprisal', 'Rampart'},
            ['drk'] = T{'Blood Weapon', 'Soul Enslavement', 'Last Resort', 'Souleater', 'Scarlet Delirium', 'Dread Spikes', 'Nether Void', 'Diabolic Eye', 'Dark Seal', 'Consume Mana',},
            ['drk_sam'] = T{'Blood Weapon', 'Soul Enslavement', 'Last Resort', 'Souleater', 'Hasso', 'Scarlet Delirium', 'Dread Spikes', 'Nether Void', 'Diabolic Eye', 'Dark Seal', 'Consume Mana',},
            ['bst'] = T{'Unleash'},
            ['bst_nin'] = T{'Copy Image (3)', 'Copy Image (2)', 'Copy Image', 'Unleash'},
            ['brd'] = T{'Soul Voice', 'Clarion Call', 'Pianissimo', 'Nightingale', 'Troubadour',  'Tenuto', 'Marcato',},
            ['brd_whm'] = T{'Reraise', 'Soul Voice', 'Clarion Call', 'Pianissimo', 'Nightingale', 'Troubadour',  'Tenuto', 'Marcato',},
            ['brd_nin'] = T{'Copy Image (3)', 'Copy Image (2)', 'Copy Image', 'Soul Voice', 'Clarion Call', 'Pianissimo', 'Nightingale', 'Troubadour',  'Tenuto', 'Marcato',},
            ['rng'] = T{'Overkill', 'Velocity Shot', 'Double Shot', 'Decoy Shot', 'Camouflage', 'Sharpshot', 'Unlimited Shot', 'Barrage', },
            ['rng_nin'] = T{'Copy Image (3)', 'Copy Image (2)', 'Copy Image', 'Overkill', 'Velocity Shot', 'Double Shot', 'Decoy Shot', 'Camouflage', 'Sharpshot', 'Unlimited Shot', 'Barrage', },
            ['smn'] = T{'Astral Flow', 'Astral Conduit', 'Carbuncle\'s Favor', 'Cait Sith\'s Favor', 'Siren\'s Favor', 'Ifrit\'s Favor', 'Shiva\'s Favor', 'Garuda\'s Favor', 'Titan\'s Favor', 'Ramuh\'s Favor', 'Leviathan\'s Favor', 'Fenrir\'s Favor', 'Diabolos\'s Favor', 'Apogee'},
            ['smn_sch'] = T{'Astral Flow', 'Astral Conduit', 'Sublimation: Activated', 'Sublimation: Complete', 'Carbuncle\'s Favor', 'Cait Sith\'s Favor', 'Siren\'s Favor', 'Ifrit\'s Favor', 'Shiva\'s Favor', 'Garuda\'s Favor', 'Titan\'s Favor', 'Ramuh\'s Favor', 'Leviathan\'s Favor', 'Fenrir\'s Favor', 'Diabolos\'s Favor', 'Apogee'},
            ['smn_rdm'] = T{'Astral Flow', 'Astral Conduit', 'Refresh', 'Carbuncle\'s Favor', 'Cait Sith\'s Favor', 'Siren\'s Favor', 'Ifrit\'s Favor', 'Shiva\'s Favor', 'Garuda\'s Favor', 'Titan\'s Favor', 'Ramuh\'s Favor', 'Leviathan\'s Favor', 'Fenrir\'s Favor', 'Diabolos\'s Favor', 'Apogee'},
            ['sam'] = T{'Meikyo Shisui', 'Yaegasumi', 'Third Eye', 'Seigan', 'Hasso', 'Sekkanoki', 'Sengikori', 'Hagakure', },
            ['nin'] = T{'Mikage', 'Migawari', 'Innin', 'Yonin', 'Issekigan', 'Sange', 'Futae', 'Subtle Blow Plus', },
            ['drg'] = T{'Spirit Surge'},
            ['drg_sam'] = T{'Hasso', 'Spirit Surge'},
            ['blu'] = T{'Azure Lore', 'Unbridled Wisdom', 'Mighty Guard', 'Blink', 'Attack Boost', 'Magic Atk. Boost', 'Haste', 'Diffusion', 'Unbridled Learning', 'Chain Affinity', 'Burst Affinity',}, 
            ['blu_nin'] = T{'Azure Lore', 'Unbridled Wisdom', 'Mighty Guard', 'Blink', 'Copy Image (3)', 'Copy Image (2)', 'Copy Image', 'Attack Boost', 'Magic Atk. Boost', 'Haste', 'Diffusion', 'Unbridled Learning', 'Chain Affinity', 'Burst Affinity',}, 
            ['cor_nin'] = T{
                'Copy Image (3)', 'Copy Image (2)', 'Copy Image', 
                'Triple Shot', 'Double-Up Chance', 'Snake Eye', 'Bust',
            },
            ['cor'] = T{'Triple Shot', 'Double-Up Chance', 'Snake Eye', 'Bust'},
            ['pup'] = T{'Overdrive', 'Dark Maneuver', 'Light Maneuver', 'Earth Maneuver', 'Wind Maneuver', 'Fire Maneuver', 'Ice Maneuver', 'Thunder Maneuver', 'Water Maneuver',},
            ['dnc'] = T{
                'Trance', 'Grand Pas', 'Contradance', 'Saber Dance', 'Fan Dance', 'Haste Samba', 'Drain Samba', 'Aspir Samba', 
                'Building Flourish', 'Climactic Flourish', 'Striking Flourish', 'Ternary Flourish', 
                'Finishing Move 1', 'Finishing Move 2', 'Finishing Move 3', 'Finishing Move 4', 'Finishing Move 5', 'Finishing Move (6+)', 
                'Presto', 
            },
            ['sch'] = T{
                'Reraise', 
                'Firestorm', 'Hailstorm', 'Windstorm', 'Sandstorm', 'Thunderstorm', 'Rainstorm', 'Aurorastorm', 'Voidstorm', 
                'Sublimation: Activated', 'Sublimation: Complete',
            },
            ['geo'] = T{ 'Bolster', 'Widened Compass', 'Colure Active', 'Dematerialize', 'Collimated Fervor', 'Blaze of Glory', 'Entrust', 'Theurgic Focus', },
            ['run'] = T{
                'Embolden', 'Elemental Sforzo', 'Battuta',
                'Phalanx', 'Aquaveil', 'Enmity Boost',
                'Ignis', 'Gelus', 'Flabra', 'Tellus', 'Sulpor', 'Unda', 'Lux', 'Tenebrae',
            },
            ['run_blu'] = T{
                'Embolden', 'Elemental Sforzo', 'Battuta',
                'Phalanx', 'Aquaveil', 'Enmity Boost',
                'Haste', 'Defense Boost',
                'Ignis', 'Gelus', 'Flabra', 'Tellus', 'Sulpor', 'Unda', 'Lux', 'Tenebrae',
            },
        },
    },
    debuffs = {
        stack_blacklist = T{},
        statuses = T{
            'doom', 'charm', 'terror', 'petrification', 'gradual petrification', 'silence', 'mute', 'amnesia', 'sleep', 'stun', 'Lullaby',
            'weakness',
            'Attack Down', 'Inhibit TP', 'Magic Atk. Down', 'Max TP Down', 'Bio', 'Accuracy Down', 'Magic Acc. Down',
            'paralysis', 'intimidate', 'slow', 'curse', 'bane', 'poison', 'Kaustra', 'Helix', 'blindness', 'disease', 'plague', 'addle', 'bind', 'weight',
            'Dia', 'Defense Down', 'Evasion Down', 'Magic Def. Down', 'Magic Evasion Down', 'Max HP Down', 'Max MP Down',
            'STR Down', 'INT Down', 'AGI Down', 'DEX Down', 'VIT Down', 'MND Down', 'CHR Down',
            'Elegy', 'Nocturne', 'Requiem', 'Threnody',
            'Burn', 'Choke', 'Drown', 'Frost', 'Rasp', 'Shock',
        },
    },
    ['power buffs'] = {
        stack_blacklist = T{'March', 'Minuet', 'Madrigal', 'Prelude', },
        statuses = T{
            'Aftermath: Lv.1', 'Aftermath: Lv.2', 'Aftermath: Lv.3',
            'Haste', 'Attack Boost', 'Magic Atk. Boost', 'Multi Strikes', 'Flurry', 'Accuracy Boost', 'Magic Acc. Boost',
            'Regain', 'Store TP',
            'March', 'Minuet', 'Madrigal', 'Prelude',
            'Enmity Boost', 'Fast Cast',
            'STR Boost', 'DEX Boost', 'VIT Boost', 'AGI Boost', 'INT Boost', 'MND Boost', 'CHR Boost', 
            'Enfire', 'Enblizzard', 'Enaero', 'Enstone', 'Enthunder', 'Enwater', 'Enlight', 'Endark', 'Enfire II', 'Enblizzard II', 'Enaero II', 'Enstone II', 'Enthunder II', 'Enwater II', 
            -- pure damage, speed/multi/storetp, ws, accuracy, pet
            "Chaos Roll", "Wizard's Roll", "Rogue's Roll", "Fighter's Roll", "Samurai Roll", "Tactician's Roll", "Blitzer's Roll", "Courser's Roll", "Caster's Roll", "Miser's Roll", "Allies' Roll", "Warlock's Roll", "Hunter's Roll", "Beast Roll", "Drachen Roll", "Puppet Roll", "Companion's Roll", 
            'Firestorm', 'Hailstorm', 'Windstorm', 'Sandstorm', 'Thunderstorm', 'Rainstorm', 'Aurorastorm', 'Voidstorm', 
            'Ifrit\'s Favor', 'Shiva\'s Favor', 'Ramuh\'s Favor', 'Leviathan\'s Favor', 
            --war
            'Mighty Strikes', 'Brazen Rush', 'Restraint', 'Berserk', 'Warcry', 'Blood Rage', 'Aggressor', 'Warrior\'s Charge', 
            --mnk
            'Formless Strikes', 'Boost', 'Focus', 'Footwork', 'Impetus',
            --blm
            'Manafont', 'Manawell', 'Elemental Seal', 'Cascade', 
            --rdm
            'Chainspell', 'Stymie', 'Saboteur', 'Spontaneity',
            --thf
            'Sneak Attack', 'Trick Attack', 'Assassin\'s Charge', 'Feint', 
            --pld
            'Divine Emblem', 'Majesty', 
            --drk
            'Soul Enslavement', 'Last Resort', 'Souleater', 'Scarlet Delirium', 'Nether Void', 'Diabolic Eye', 'Dark Seal', 'Consume Mana',
            --bst
            'Unleash', 'Killer Instinct',
            --brd
            'Soul Voice', 'Clarion Call', 'Pianissimo', 'Nightingale', 'Troubadour',  'Tenuto', 'Marcato',
            --rng
            'Overkill', 'Velocity Shot', 'Double Shot', 'Sharpshot', 'Unlimited Shot', 'Barrage', 'Flashy Shot', 'Stealth Shot',
            --smn
            'Astral Flow', 'Astral Conduit', 'Apogee',
            --sam
            'Meikyo Shisui', 'Hasso', 'Sekkanoki', 'Sengikori', 'Hagakure', 
            --nin
            'Mikage', 'Innin', 'Sange', 'Futae', 
            --drg
            'Spirit Surge',
            --blu
            'Azure Lore', 'Unbridled Wisdom', 'Diffusion', 'Unbridled Learning', 'Chain Affinity', 'Burst Affinity', 'Efflux', 'Convergence',
            --pup
            'Overdrive', 'Dark Maneuver', 'Light Maneuver', 'Earth Maneuver', 'Wind Maneuver', 'Fire Maneuver', 'Ice Maneuver', 'Thunder Maneuver', 'Water Maneuver',
            --dnc
            'Trance', 'Grand Pas', 'Contradance', 'Saber Dance', 'Presto', 'Haste Samba', 'Building Flourish', 'Climactic Flourish', 'Striking Flourish', 'Ternary Flourish', 'Finishing Move 1', 'Finishing Move 2', 'Finishing Move 3', 'Finishing Move 4', 'Finishing Move 5', 'Finishing Move (6+)', 
            --sch
            'Tabula Rasa', 
            'Penury', 'Parsimony', 'Celerity', 'Alacrity', 'Accession', 'Manifestation', 'Rapture', 'Ebullience', 'Altruism', 'Focalization', 'Tranquility', 'Equanimity', 'Perpetuance', 'Immanence',
            --geo
             'Bolster', 'Widened Compass', 'Collimated Fervor', 'Blaze of Glory', 'Entrust', 'Theurgic Focus', 
            --run
            'Swordplay', 
        },
    },
    ['defensive buffs'] = {
        stack_blacklist = T{'Scherzo', 'Minne', 'Paeon', 'Ballad', 'Carol', 'Mambo', 'Etude', 'Capriccio', 'Fantasia', 'Gavotte', 'Round', 'Virelai', 'Dirge', 'Sirvente', 'Aubade', 'Operetta', 'Pastoral',},
        statuses = T{
            'Reraise', 'Hymnus', 'Protect', 'Shell', 'Evasion Boost', 'Defense Boost', 'Physical Shield', 'Magic Def. Boost', 'Magic Evasion Boost',
            'Copy Image (4+)', 'Copy Image (3)', 'Copy Image (2)', 'Copy Image', 
            'Regen', 'Refresh', 'Stoneskin', 'Aquaveil', 'Blink', 'Phalanx',
            'Scherzo', 'Minne', 'Paeon', 'Ballad', 'Carol', 'Mambo', 'Etude', 'Capriccio', 'Fantasia', 'Gavotte', 'Round', 'Virelai', 'Dirge', 'Sirvente', 'Aubade', 'Operetta', 'Pastoral',
            'Barfire', 'Barblizzard', 'Baraero', 'Barstone', 'Barthunder', 'Barwater', 'Barsleep', 'Barpoison', 'Barparalyze', 'Barblind', 'Barsilence', 'Barpetrify', 'Barvirus', 'Baramnesia','Sublimation: Activated', 'Sublimation: Complete', 
            'Max HP Boost', 'Max MP Boost', 'Enmity Down', 
            'Negate Petrify', 'Negate Terror', 'Negate Amnesia', 'Negate Doom', 'Negate Poison', 'Negate Virus', 'Negate Curse', 'Negate Charm', 'Negate Sleep', 
            'Blaze Spikes', 'Ice Spikes', 'Shock Spikes', 'Damage Spikes', 'Dread Spikes', 'Deluge Spikes', 'Gale Spikes', 'Clod Spikes', 'Glint Spikes', 
            "Gallant's Roll", "Ninja Roll", "Magus's Roll", "Avenger's Roll", "Evoker's Roll", "Dancer's Roll", "Monk's Roll", "Healer's Roll", "Choral Roll", "Naturalist's Roll", 
            'Carbuncle\'s Favor', 'Cait Sith\'s Favor', 'Siren\'s Favor', 'Garuda\'s Favor', 'Titan\'s Favor', 'Fenrir\'s Favor', 'Diabolos\'s Favor',
            -- non-important rolls: "Corsair's Roll", "Scholar's Roll", "Bolter's Roll", 

            --war
            'Retaliation', 'Defender',
            --mnk
            'Inner Strength', 'Dodge', 'Perfect Counter', 'Counterstance', 
            --whm
            'Asylum', 'Sacrosanctity', 'Divine Caress', 'Divine Seal',
            --blm
            'Subtle Sorcery', 'Mana Wall', 
            --thf
            'Perfect Dodge', 'Hide',
            --pld
            'Invincible', 'Fealty', 'Cover', 'Sentinel', 'Palisade', 'Reprisal', 'Rampart', 'Holy Circle',
            --drk
            'Blood Weapon', 'Arcane Circle',
            --rng
            'Decoy Shot', 'Camouflage', 
            --sam
            'Yaegasumi', 'Third Eye', 'Seigan', 'Warding Circle',
            --nin
            'Yonin', 'Issekigan', 'Subtle Blow Plus', 'Migawari', 
            --drg
            'Spirit Bond', 'Ancient Circle',
            --blu
            'Mighty Guard', 
            --dnc
            'Fan Dance', 'Drain Samba', 'Aspir Samba', 
            --sch
            'Light Arts', 'Dark Arts', 'Addendum: White', 'Addendum: Black', 'Enlightenment',
            --geo
            'Colure Active', 'Dematerialize', 
            --run
            'Battuta', 'One for All', 'Pflug', 'Liement', 'Vallation', 'Valiance', 'Foil',
            'Ignis', 'Gelus', 'Flabra', 'Tellus', 'Sulpor', 'Unda', 'Lux', 'Tenebrae',
        },
    },
}