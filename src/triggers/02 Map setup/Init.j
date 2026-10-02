library TInit
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Init_AbilityLevelShift=null
    trigger gg_trg_Init_JobTables=null
    trigger gg_trg_Init_PlayerForces=null
    trigger gg_trg_Init_PlayerColors=null
    trigger gg_trg_Init_RevealStartArea=null
    trigger gg_trg_Init_HideScoreScreen=null
    trigger gg_trg_Init_NeutralPlayer8=null
    trigger gg_trg_Init_AllyPlayer9=null
    trigger gg_trg_Init_AllyPlayer10=null
    trigger gg_trg_Init_RemoveGuards=null
    trigger gg_trg_Init_FoodCap=null
    trigger gg_trg_Init_EnemyUpgrades=null
    trigger gg_trg_Init_InvulnerableGates=null
    trigger gg_trg_Init_TimeOfDay=null
    trigger gg_trg_Init_LockTrading=null
    trigger gg_trg_Init_HideUiAbilities=null
    trigger gg_trg_Init_InfoQuest=null
    trigger gg_trg_Init_QuestLog=null
    trigger gg_trg_Init_VoteOptionText=null
    trigger gg_trg_Init_SkyAndSubtitles=null
    trigger gg_trg_Init_AncientForestNpcs=null
    trigger gg_trg_Init_ZaleraChapter=null
    // Variables only this module uses (MapBootstrap sets some starting values).
    quest udg_InfoQuest=null
    group udg_unused_group_01=null
    group udg_unused_group_02=null
    timer udg_unused_timer_01=null
    force udg_unused_force_01=null
    group udg_unused_group_03=null
    group udg_unused_group_04=null
    timer udg_unused_timer_02=null
    integer array udg_BombAbility
    timer udg_unused_timer_03=null
    force udg_unused_force_02=null
    string array udg_unused_string_01
    string array udg_unused_string_02
    integer array udg_unused_integer_01
    timer udg_unused_timer_04=null
    group udg_unused_group_05=null
    group udg_unused_group_06=null
endglobals

function ModuleLongText_1 takes nothing returns string
    local string text = ""
    set text = text + "You can save your char using loading codes. \r\n\r\nJob levels, gold, upgrades and gaya/hero/house items are saved. Crystal Shards are not saved but converted to gold. You can load only once and save anytime. You can load only during the first 15 minutes of the game. And don't worry about mistyping your code - there's an automatic protection that will not allow your game to be ruined.\r\nUse \"-save\" command to get a loading code and type \"-load loading code\" to restore your character.\r\nQuest items and regular loot are not saved.\r\n\r\nThere are also other Save-Load-Commands, which save/load on the hard disk. Read in 'File Saving and Loading' for more informations.\r\n\r\nHere's a usef"
    set text = text + "ul hint that may help you: when you get a loading code press Print Screen button. You will get a game screenshoot with the loading code that will be saved in the Screenshots folder in your Warcraft III directory. You can then type it in notepad, copy to clipboard (Ctrl+C) and then paste it in Warcraft (Ctrl+V)."
    return text
endfunction

function ModuleLongText_2 takes nothing returns string
    local string text = ""
    set text = text + "To simplify the saving and loading process you can also use files directly. Use the command \"-savef [filename]\" to save on your hard disk. If you don't provide a filename, your name and lvl will be used instead. Also a \"Last save\" file is always saved.\r\nThese files show up as Text Files in your \"Documents - Warcraft III - CustomMapData - FFERPG\" folder. If you open these text files you will see your code among the lines, allowing you to copy it. Warcraft III can also load your code from these files directly with the command \"-loadf [filename]\". This requires that Warcraft III has the \"Allow Local Files\" permission (google it if you don't know what that is).\r\nUsing \"-loadf\" in"
    set text = text + " single player will make it impossible to view the game's replay for anyone who doesn't have the same code file on your local computer. If you wish to avoid this, use the command \"-loadx [filename]\" instead. It will use a syncing operation that ensures the game's replay will remain viewable for anyone. In multiplayer this same syncing operation is used to avoid desyncing the game."
    return text
endfunction

function ModuleLongText_3 takes nothing returns string
    local string text = ""
    set text = text + "Each character may equip only one |cffff0000weapon|r, |cffff8040offhand|r (shield, ammunition or book),  |cffffff00helmet|r, |cffff00ffarmor|r and |cff00ffffaccessory|r. If a hero has the |cffffcc00Dual Wield|r ability, they may exchange their offhand for a second weapon.\r\n|cff00ff00Artifacts|r are unique items. They are usually more powerful that normal ones and have some unique attributes or abilities, but not always.\r\nAll equippable gear has a |cffffcc00Level Requirement|r. It shows what Spirit of Gaya level the player must have in order to equip the item.\r\nEquipment is not job specific (meaning even wizard may use sword) but some items are better for certain jobs (wizard will benef"
    set text = text + "it more from carrying a wand rather than sword).\r\n\r\nMaterias are unique items which allow to cast spells. Don't be afraid of using them too often - when their stack reaches 0, they level up!!\r\n\r\nItems are bound to a player after either saving with them, putting them in the armory and taking them back out, or loading them from a saved code. Bound items can still be used by other players, but cannot be saved by them. Additionally, you may use the command \"-claim\" to instantly teleport items bound to you that are stuck in any ally's hero/spirit/house inventory back to your House."
    return text
endfunction

function ModuleLongText_4 takes nothing returns string
    local string text = ""
    set text = text + "There are six prime elements in FFERPG: Fire, Ice, Thunder, Water, Earth and Wind. Fire and Ice are opposed; if you are facing a Fire-elemental enemy, Fire attacks and spells will be ineffective but Ice will deal high damage. Thunder and Water are also opposed the same way as Fire and Ice, and Earth and Wind are also opposed. Certain weapons will make all your attacks take on a particular element's properties, and spells often have a particular element attached to them. Use the right element on the right enemy to be super effective!\r\n\r\nFor each element there is a particular status effect that makes damage of that element deal major Technical damage, increasing damage by 120%. For Fire, "
    set text = text + "for example, this is Oil - enemies in Oil status will take 120% additional damage from Fire attacks and spells. The other elements also have respective ailments with the same effect. This Technical damage is irrespective of elemental resistance, so if an enemy is immune to Fire damage, putting Oil on them will not change that, but if the enemy is instead weak to Fire, then putting Oil on them on top of that will make Fire just melt them. Technical damage bonus stacks additively with other elemental power boosters."
    return text
endfunction

function ModuleLongText_5 takes nothing returns string
    local string text = ""
    set text = text + "\"-save\": create a save code and shows it on screen (color coded by character type)\r\n\"-load [code]\": loads your saved char from \"-save\"\r\n\"-loada [(extra)]\": when loading a code with armory that exceeds the chat length limit, use load without the (brackets) part and then this command with the (extra) part of your code to load in your armory after your char.\r\n\"-savef [filename]\": save to file\r\n\"-loadf [filename]\": try to load from file\r\n\"-loadx [filename]\": same as loadf but forces using syncing in singleplayer to keep the replay viewable\r\n\"-autosave (on/off)\": toggle autosaving on/off\r\n\"-text [#/instant/skip]\": change text speed, #=(1...9), 9 is fastest, 1 is sl"
    set text = text + "owest. instant skips text, skip skips all cinematics\r\n\"-instant\": skips cinematic text\r\n\"-skip\": skip cinematics completely\r\n\"-suicide\": kills your hero\r\n\"-levels\": reports what levels in all jobs your character has\r\n\"-roll\": rolls a random number between 1 and 100\r\n\"-handicap\": reports handicap applied to enemy\r\n\"-magdef\": displays your current magic defense and reduction %\r\n\"-atkspd\": displays your attack speed (not including temporary buffs)\r\n\"-claim\": teleport all items in other player's inventories that belong to you back to your House\r\n\"-teleporters\": pings all teleporters\r\n\"-abilitytext (on/off)\": toggle ability floating text on/off\r\n\"-d"
    set text = text + "amagetext (on/off)\": toggle damage floating text on/off\r\n\"-battlelog (on/off)\": toggle display on battle log on/off\r\n\"-clear\": clear the screen of text messages\r\n\"-unstuck\": activates and deactivates cinematic mode, use this command if something breaks.\r\n\"-number\": displays your player number\r\n\"-cam # (250-3000)\": Changes the camera distance.\r\n\r\nPVP\r\n\"-pvp\" (only Player 1 Red): Enables PvP mode. Heroes can not gain any EXP, but the commands below are enabled in PvP mode.\r\n\"-war #\": Declare war on the chosen player. (number is 1-8 depending on player slot)\r\n\"-peace #\": Disallow yourself to attack the chosen player. (He still can attack you unless he types "
    set text = text + "-peace, you can't attack him)"
    return text
endfunction

function ModuleLongText_6 takes nothing returns string
    local string text = ""
    set text = text + "This map allows for usage of local mp3 files to play during gameplay. By default the system will autoplay native warcraft 3 music but it also includes support for autoplaying custom music at certain events or quests, or simply playing local music files at your leisure.\r\n\r\nCommands:\r\n\"-music path X\": set the path to find custom music tracks in. must be an ABSOLUTE path.\r\n\"-music native\": use native warcraft music instead of custom music. (on by default)\r\n\"-music autoplay [on/off]\": turns music autoplay at certain quests or events on or off (on by default).\r\n\"-music prelude\": plays the Final Fantasy Prelude.\r\n\"-music play [native/custom] X\": plays the specified track (e"
    set text = text + "xample: \"-music play native HumanX1\"), playing custom music requires setting a path first.\r\n\"-music reset\": stops playing a specific track and resumes autoplayed music.\r\n\"-music tracknames [on/off]\": shows the track filename whenever a track is played (only in custom music mode).\r\n\r\nTo set up a custom list of music to automatically play during gameplay, it is recommended that you turn showing track names on and then create music files that correspond to each track name. These will then be autoplayed when called upon."
    return text
endfunction

function Trig_Init_AbilityLevelShift_IsAbilityLevelShifted takes nothing returns boolean
    return(BlzGetAbilityManaCost('A0ZT',1)==2) // 'A0ZT': ability "Ability Level Shift Checker"
endfunction

function Trig_Init_AbilityLevelShift_Actions takes nothing returns nothing
    if(Trig_Init_AbilityLevelShift_IsAbilityLevelShifted())then
        set udg_AbilityLevelShift=true
        set udg_AbilityLevelIndex=0
    else
        set udg_AbilityLevelShift=false
        set udg_AbilityLevelIndex=1
    endif
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Init_JobTables_Actions takes nothing returns nothing
    set udg_JobCount=22
    set udg_JobUnitType[0]='H000' // 'H000': unit "Squire"
    set udg_JobUnitType[1]='H003' // 'H003': unit "Knight"
    set udg_JobUnitType[2]='H001' // 'H001': unit "Archer"
    set udg_JobUnitType[3]='H00A' // 'H00A': unit "Monk"
    set udg_JobUnitType[4]='H00B' // 'H00B': unit "Thief"
    set udg_JobUnitType[5]='H00D' // 'H00D': unit "Geomancer"
    set udg_JobUnitType[6]='H00E' // 'H00E': unit "Samurai"
    set udg_JobUnitType[7]='H00C' // 'H00C': unit "Lancer"
    set udg_JobUnitType[8]='H00F' // 'H00F': unit "Ninja"
    set udg_JobUnitType[9]='H00M' // 'H00M': unit "Holy Swordsman"
    set udg_JobUnitType[$A]='H002' // $A = 10; 'H002': unit "Chemist"
    set udg_JobUnitType[$B]='H004' // $B = 11; 'H004': unit "Wizard"
    set udg_JobUnitType[$C]='H005' // $C = 12; 'H005': unit "Priest"
    set udg_JobUnitType[$D]='H009' // $D = 13; 'H009': unit "Summoner"
    set udg_JobUnitType[$E]='H008' // $E = 14; 'H008': unit "Time Mage"
    set udg_JobUnitType[$F]='H00G' // $F = 15; 'H00G': unit "Mediator"
    set udg_JobUnitType[16]='H00I' // 'H00I': unit "Oracle"
    set udg_JobUnitType[17]='H00H' // 'H00H': unit "Calculator"
    set udg_JobUnitType[18]='H00J' // 'H00J': unit "Prophet"
    set udg_JobUnitType[19]='H00L' // 'H00L': unit "Sorcerer"
    set udg_JobUnitType[20]='H02X' // 'H02X': unit "Dark Knight"
    set udg_JobUnitType[21]='H02Y' // 'H02Y': unit "Necromancer"
    set udg_JobName[0]="Squire"
    set udg_JobName[1]="Knight"
    set udg_JobName[2]="Archer"
    set udg_JobName[3]="Monk"
    set udg_JobName[4]="Thief"
    set udg_JobName[5]="Geomancer"
    set udg_JobName[6]="Samurai"
    set udg_JobName[7]="Lancer"
    set udg_JobName[8]="Ninja"
    set udg_JobName[9]="Holy Swordsman"
    set udg_JobName[$A]="Chemist" // $A = 10
    set udg_JobName[$B]="Wizard" // $B = 11
    set udg_JobName[$C]="Priest" // $C = 12
    set udg_JobName[$D]="Summoner" // $D = 13
    set udg_JobName[$E]="Time Mage" // $E = 14
    set udg_JobName[$F]="Mediator" // $F = 15
    set udg_JobName[16]="Oracle"
    set udg_JobName[17]="Calculator"
    set udg_JobName[18]="Prophet"
    set udg_JobName[19]="Sorcerer"
    set udg_JobName[20]="Dark Knight"
    set udg_JobName[21]="Necromancer"
    set udg_JobSkill[1]='A17D' // 'A17D': ability "Knot of Rust"
    set udg_JobSkill[2]='A023' // 'A023': ability "Cover"
    set udg_JobSkill[3]='A003' // 'A003': ability "Accumulate"
    set udg_JobSkill[4]='A1E7' // 'A1E7': ability "Move Burst"
    set udg_JobSkill[5]='A0ON' // 'A0ON': ability "!Sentinel"
    set udg_JobSkill[6]='A0P7' // 'A0P7': ability "Armor Breaker"
    set udg_JobSkill[7]='A17P' // 'A17P': ability "Runic Shield"
    set udg_JobSkill[8]='A13K' // 'A13K': ability "Shock"
    set udg_JobSkill[9]='A1E4' // 'A1E4': ability "Damage Burst"
    set udg_JobSkill[$A]='A14L' // $A = 10; 'A14L': ability "!Assault"
    set udg_JobSkill[$B]='A0AE' // $B = 11; 'A0AE': ability "Rapid Fire"
    set udg_JobSkill[$C]='A0QQ' // $C = 12; 'A0QQ': ability "Arrowwave"
    set udg_JobSkill[$D]='A14H' // $D = 13; 'A14H': ability "Animal Companion"
    set udg_JobSkill[$E]='A14B' // $E = 14; 'A14B': ability "Aim"
    set udg_JobSkill[$F]='A0R0' // $F = 15; 'A0R0': ability "!Myriad Arrows"
    set udg_JobSkill[16]='A01L' // 'A01L': ability "Wave Fist"
    set udg_JobSkill[17]='A01M' // 'A01M': ability "Chakra"
    set udg_JobSkill[18]='A0QO' // 'A0QO': ability "Rave Kick"
    set udg_JobSkill[19]='A1C8' // 'A1C8': ability "Strength Burst"
    set udg_JobSkill[20]='A1BK' // 'A1BK': ability "!Inner Fire"
    set udg_JobSkill[21]='A0MR' // 'A0MR': ability "Steal"
    set udg_JobSkill[22]='A0QS' // 'A0QS': ability "Fan of Knives"
    set udg_JobSkill[23]='A01I' // 'A01I': ability "Stealth"
    set udg_JobSkill[24]='A1C9' // 'A1C9': ability "Agility Burst"
    set udg_JobSkill[25]='A0KY' // 'A0KY': ability "Thievery"
    set udg_JobSkill[26]='A0S8' // 'A0S8': ability "Enfire"
    set udg_JobSkill[27]='A05P' // 'A05P': ability "Gaya Rage"
    set udg_JobSkill[28]='A01Z' // 'A01Z': ability "Blitz"
    set udg_JobSkill[29]='A1E5' // 'A1E5': ability "Defense Burst"
    set udg_JobSkill[30]='A0TK' // 'A0TK': ability "MP Attack"
    set udg_JobSkill[31]='A02E' // 'A02E': ability "Mineuchi"
    set udg_JobSkill[32]='A18H' // 'A18H': ability "Tatsumaki"
    set udg_JobSkill[33]='A0IG' // 'A0IG': ability "Mirage"
    set udg_JobSkill[34]='A16J' // 'A16J': ability "Renzokuken"
    set udg_JobSkill[35]='A18P' // 'A18P': ability "!Iainuki"
    set udg_JobSkill[36]='A11R' // 'A11R': ability "Dragon Breath"
    set udg_JobSkill[37]='A03M' // 'A03M': ability "Dragon Slam"
    set udg_JobSkill[38]='A14G' // 'A14G': ability "Dragon Ally"
    set udg_JobSkill[39]='A1E6' // 'A1E6': ability "Attack Speed Burst"
    set udg_JobSkill[40]='A14D' // 'A14D': ability "!Jump"
    set udg_JobSkill[41]='A156' // 'A156': ability "Ambush"
    set udg_JobSkill[42]='A07V' // 'A07V': ability "Battle Ward"
    set udg_JobSkill[43]='A0AD' // 'A0AD': ability "Yuffie's Shuriken"
    set udg_JobSkill[44]='A070' // 'A070': ability "Rage"
    set udg_JobSkill[45]='A14N' // 'A14N': ability "!Trance"
    set udg_JobSkill[46]='A04O' // 'A04O': ability "Curaga"
    set udg_JobSkill[47]='A0QH' // 'A0QH': ability "Liquid Steel"
    set udg_JobSkill[48]='A0QJ' // 'A0QJ': ability "Eclipse"
    set udg_JobSkill[49]='A0HN' // 'A0HN': ability "Finisher"
    set udg_JobSkill[50]='A05W' // 'A05W': ability "!Holy Power"
    set udg_JobSkill[51]='A1AK' // 'A1AK': ability "Alchemy"
    set udg_JobSkill[52]='A0GZ' // 'A0GZ': ability "Noxious Mixture"
    set udg_JobSkill[53]='A0ZZ' // 'A0ZZ': ability "Molotov Cocktail"
    set udg_JobSkill[54]='A00E' // 'A00E': ability "Oil Barrel"
    set udg_JobSkill[55]='A18G' // 'A18G': ability "!Goliath Tonic"
    set udg_JobSkill[56]='A00O' // 'A00O': ability "Bolt"
    set udg_JobSkill[57]='A0Q7' // 'A0Q7': ability "Ice"
    set udg_JobSkill[58]='A0PU' // 'A0PU': ability "Fire"
    set udg_JobSkill[59]='A1CA' // 'A1CA': ability "Intelligence Burst"
    set udg_JobSkill[60]='A149' // 'A149': ability "!Tornado"
    set udg_JobSkill[61]='A00M' // 'A00M': ability "Cure"
    set udg_JobSkill[62]='A00L' // 'A00L': ability "Regen"
    set udg_JobSkill[63]='A00G' // 'A00G': ability "Protect"
    set udg_JobSkill[64]='A0TZ' // 'A0TZ': ability "Shell"
    set udg_JobSkill[65]='A0OM' // 'A0OM': ability "!Tranquility"
    set udg_JobSkill[66]='A0V5' // 'A0V5': ability "Shiva"
    set udg_JobSkill[67]='A1FP' // 'A1FP': ability "Ifrit"
    set udg_JobSkill[68]='A0V6' // 'A0V6': ability "Golem"
    set udg_JobSkill[69]='A067' // 'A067': ability "Cyclops"
    set udg_JobSkill[70]='A146' // 'A146': ability "!Bahamut"
    set udg_JobSkill[71]='A01D' // 'A01D': ability "Haste"
    set udg_JobSkill[72]='A01E' // 'A01E': ability "Slow"
    set udg_JobSkill[73]='A0QM' // 'A0QM': ability "Meteor"
    set udg_JobSkill[74]='A1EG' // 'A1EG': ability "Immobilize"
    set udg_JobSkill[75]='A0HO' // 'A0HO': ability "!Quick"
    set udg_JobSkill[76]='A171' // 'A171': ability "Spell Shot"
    set udg_JobSkill[77]='A02T' // 'A02T': ability "Invitation"
    set udg_JobSkill[78]='A11I' // 'A11I': ability "Sharp Eye"
    set udg_JobSkill[79]='A16X' // 'A16X': ability "Balance"
    set udg_JobSkill[80]='A16W' // 'A16W': ability "!Mark for Death"
    set udg_JobSkill[81]='A02O' // 'A02O': ability "Blind"
    set udg_JobSkill[82]='A0L5' // 'A0L5': ability "Predict Strength"
    set udg_JobSkill[83]='A0L6' // 'A0L6': ability "Predict Magic"
    set udg_JobSkill[84]='A0VM' // 'A0VM': ability "Scourge"
    set udg_JobSkill[85]='A147' // 'A147': ability "!Neo Bahamut"
    set udg_JobSkill[86]='A0QD' // 'A0QD': ability "Firaga"
    set udg_JobSkill[87]='A0QF' // 'A0QF': ability "Thundaga"
    set udg_JobSkill[88]='A17S' // 'A17S': ability "Blizzaga"
    set udg_JobSkill[89]='A00Q' // 'A00Q': ability "Frog"
    set udg_JobSkill[90]='A0I4' // 'A0I4': ability "!Imperil"
    set udg_JobSkill[91]='A039' // 'A039': ability "Holy Blast"
    set udg_JobSkill[92]='A089' // 'A089': ability "Blessing of Light"
    set udg_JobSkill[93]='A03B' // 'A03B': ability "Blessing of Might"
    set udg_JobSkill[94]='A0RY' // 'A0RY': ability "Divine Shield"
    set udg_JobSkill[95]='A0RD' // 'A0RD': ability "!Infinity"
    set udg_JobSkill[96]='A0TB' // 'A0TB': ability "Flare"
    set udg_JobSkill[97]='A01V' // 'A01V': ability "Holy"
    set udg_JobSkill[98]='A08Y' // 'A08Y': ability "Mass Cripple"
    set udg_JobSkill[99]='A1E9' // 'A1E9': ability "MP Regeneration Burst"
    set udg_JobSkill['d']='A148' // 'A148': ability "!Bahamut Zero"
    set udg_JobSkill['e']='A0KS' // 'A0KS': ability "Darkness"
    set udg_JobSkill['f']='A0Z5' // 'A0Z5': ability "Minus Strike"
    set udg_JobSkill['g']='A0R1' // 'A0R1': ability "Drain Attack"
    set udg_JobSkill['h']='A1E8' // 'A1E8': ability "HP Regeneration Burst"
    set udg_JobSkill['i']='A1AA' // 'A1AA': ability "!Dark Power"
    set udg_JobSkill['j']='A0Z2' // 'A0Z2': ability "Raise Dead"
    set udg_JobSkill['k']='A12Y' // 'A12Y': ability "Death Screech"
    set udg_JobSkill['l']='A0Z4' // 'A0Z4': ability "Drain"
    set udg_JobSkill['m']='A0Z3' // 'A0Z3': ability "Osmose"
    set udg_JobSkill['n']='A0ZV' // 'A0ZV': ability "!Oblivion"
    set udg_JobExtraAbility[$A]='A19C' // $A = 10; 'A19C': ability "Pharmacology"
    set udg_JobExtraAbility[$B]='A06D' // $B = 11; 'A06D': ability "Mana Spring"
    set udg_JobExtraAbility[$C]='A0W9' // $C = 12; 'A0W9': ability "Esuna"
    set udg_JobExtraAbility[$D]='A0HY' // $D = 13; 'A0HY': ability "Transfusion"
    set udg_JobExtraAbility[$E]='A007' // $E = 14; 'A007': ability "Virus"
    set udg_JobExtraAbility[$F]='A175' // $F = 15; 'A175': ability "Clone"
    set udg_JobExtraAbility[16]='A14A' // 'A14A': ability "Jinx"
    set udg_JobExtraAbility[17]='A10T' // 'A10T': ability "Mind Charge"
    set udg_JobExtraAbility[18]='A0PC' // 'A0PC': ability "Pray"
    set udg_JobExtraAbility[19]='A1ED' // 'A1ED': ability "Sleep"
    set udg_JobExtraAbility[22]='A197' // 'A197': ability "Momentum"
    set udg_BombAbility[1]='A0UI' // 'A0UI': ability "Bomb"
    set udg_BombAbility[2]='A0UJ' // 'A0UJ': ability "Bomb"
    set udg_BombAbility[3]='A0UK' // 'A0UK': ability "Bomb"
    set udg_BombAbility[4]='A0UL' // 'A0UL': ability "Bomb"
    set udg_BombAbility[5]='A0UM' // 'A0UM': ability "Bomb"
    set udg_BombAbility[6]='A0UN' // 'A0UN': ability "Bomb"
    set udg_BombAbility[7]='A0UO' // 'A0UO': ability "Bomb"
    set udg_BombAbility[8]='A0UP' // 'A0UP': ability "Bomb"
    call TriggerExecute(gg_trg_Elysium_AssignLegends)
    call TriggerExecute(gg_trg_Player_Init)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Init_PlayerForces_IsPlayingUser takes nothing returns boolean
    return(GetPlayerController(ConvertedPlayer(GetForLoopIndexA()))==MAP_CONTROL_USER)and(GetPlayerSlotState(ConvertedPlayer(GetForLoopIndexA()))==PLAYER_SLOT_STATE_PLAYING)
endfunction

function Trig_Init_PlayerForces_Actions takes nothing returns nothing
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=8
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        if(Trig_Init_PlayerForces_IsPlayingUser())then
            call ForceAddPlayerSimple(ConvertedPlayer(GetForLoopIndexA()),udg_PlayingPlayers)
            call ForceAddPlayerSimple(ConvertedPlayer(GetForLoopIndexA()),udg_ActivePlayers)
        endif
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    call ForceAddPlayerSimple(Player($A),udg_ActivePlayers) // $A = 10
    call TriggerExecute(gg_trg_Init_HideScoreScreen)
    call TriggerExecute(gg_trg_Init_RevealStartArea)
    call TriggerExecute(gg_trg_Init_FoodCap)
    call TriggerExecute(gg_trg_Init_HideUiAbilities)
    call TriggerExecute(gg_trg_Cheat_Detect_Init)
    call TriggerExecute(gg_trg_Init_NeutralPlayer8)
    call TriggerExecute(gg_trg_Init_AllyPlayer9)
    call TriggerExecute(gg_trg_Init_AllyPlayer10)
    call TriggerExecute(gg_trg_Titles_Init)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Init_PlayerColors_Actions takes nothing returns nothing
    if(CountPlayersInForceBJ(udg_PlayingPlayers)>1)then
        set udg_PlayerColorCode[1]="|cffff0000"
        set udg_PlayerColorCode[2]="|cff0000ff"
        set udg_PlayerColorCode[3]="|cff00ffff"
        set udg_PlayerColorCode[4]="|cffac05a6"
        set udg_PlayerColorCode[5]="|cfff9f914"
        set udg_PlayerColorCode[6]="|cffFF7D40"
        set udg_PlayerColorCode[7]="|cff00ff00"
        set udg_PlayerColorCode[8]="|cffff06f0"
    endif
    set udg_PlayerColorCode[9]="|cff7d7d7d"
    set udg_PlayerColorCode[$A]="|cff99FFFF" // $A = 10
    set udg_PlayerColorCode[$B]="|cff006666" // $B = 11
    set udg_PlayerColorCode[$C]="|cff660000" // $C = 12
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Init_RevealStartArea_RevealForPlayer takes nothing returns nothing
    call CreateFogModifierRadiusLocBJ(true,GetEnumPlayer(),FOG_OF_WAR_VISIBLE,udg_TempPoint,256.)
    call CreateFogModifierRadiusLocBJ(true,GetEnumPlayer(),FOG_OF_WAR_VISIBLE,udg_TempPoint2,256.)
endfunction

function Trig_Init_RevealStartArea_Actions takes nothing returns nothing
    set udg_TempPoint=GetUnitLoc(gg_unit_n006_0063)
    set udg_TempPoint2=GetUnitLoc(gg_unit_n000_0010)
    call ForForce(udg_PlayingPlayers,function Trig_Init_RevealStartArea_RevealForPlayer)
    call RemoveLocation(udg_TempPoint)
    call RemoveLocation(udg_TempPoint2)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Init_HideScoreScreen_HideScoreScreenForPlayer takes nothing returns nothing
    call SetPlayerOnScoreScreenBJ(false,GetEnumPlayer())
endfunction

function Trig_Init_HideScoreScreen_Actions takes nothing returns nothing
    call ForForce(udg_PlayingPlayers,function Trig_Init_HideScoreScreen_HideScoreScreenForPlayer)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Init_NeutralPlayer8_SetNeutralWithPlayer8 takes nothing returns nothing
    call SetPlayerAllianceStateBJ(Player(8),GetEnumPlayer(),bj_ALLIANCE_NEUTRAL)
    call SetPlayerAllianceStateBJ(GetEnumPlayer(),Player(8),bj_ALLIANCE_NEUTRAL)
endfunction

function Trig_Init_NeutralPlayer8_Actions takes nothing returns nothing
    call SetPlayerAllianceStateBJ(Player(8),Player($B),bj_ALLIANCE_NEUTRAL) // $B = 11
    call SetPlayerAllianceStateBJ(Player($B),Player(8),bj_ALLIANCE_NEUTRAL) // $B = 11
    call SetPlayerAllianceStateBJ(Player(8),Player($A),bj_ALLIANCE_NEUTRAL) // $A = 10
    call SetPlayerAllianceStateBJ(Player($A),Player(8),bj_ALLIANCE_NEUTRAL) // $A = 10
    call SetPlayerAllianceStateBJ(Player(8),Player(9),bj_ALLIANCE_NEUTRAL)
    call SetPlayerAllianceStateBJ(Player(9),Player(8),bj_ALLIANCE_NEUTRAL)
    call ForForce(udg_PlayingPlayers,function Trig_Init_NeutralPlayer8_SetNeutralWithPlayer8)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Init_AllyPlayer9_AllyWithPlayer9 takes nothing returns nothing
    call SetPlayerAllianceStateBJ(Player(9),GetEnumPlayer(),bj_ALLIANCE_ALLIED)
    call SetPlayerAllianceStateBJ(GetEnumPlayer(),Player(9),bj_ALLIANCE_ALLIED_VISION)
endfunction

function Trig_Init_AllyPlayer9_Actions takes nothing returns nothing
    call SetPlayerAllianceStateBJ(Player(9),Player($B),bj_ALLIANCE_UNALLIED) // $B = 11
    call SetPlayerAllianceStateBJ(Player($B),Player(9),bj_ALLIANCE_UNALLIED) // $B = 11
    call SetPlayerAllianceStateBJ(Player(9),Player($A),bj_ALLIANCE_ALLIED) // $A = 10
    call ForForce(udg_PlayingPlayers,function Trig_Init_AllyPlayer9_AllyWithPlayer9)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Init_AllyPlayer10_AllyWithPlayer10 takes nothing returns nothing
    call SetPlayerAllianceStateBJ(Player($A),GetEnumPlayer(),bj_ALLIANCE_ALLIED_UNITS) // $A = 10
    call SetPlayerAllianceStateBJ(GetEnumPlayer(),Player($A),bj_ALLIANCE_ALLIED_UNITS) // $A = 10
endfunction

function Trig_Init_AllyPlayer10_Actions takes nothing returns nothing
    call SetPlayerAllianceStateBJ(Player($A),Player($B),bj_ALLIANCE_UNALLIED) // $A = 10; $B = 11
    call SetPlayerAllianceStateBJ(Player($B),Player($A),bj_ALLIANCE_UNALLIED) // $B = 11; $A = 10
    call SetPlayerAllianceStateBJ(Player($A),Player(9),bj_ALLIANCE_ALLIED) // $A = 10
    call ForForce(udg_PlayingPlayers,function Trig_Init_AllyPlayer10_AllyWithPlayer10)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Init_RemoveGuards_Actions takes nothing returns nothing
    call RemoveAllGuardPositions(Player($A)) // $A = 10
    call RemoveGuardPosition(gg_unit_ensh_0057)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Init_FoodCap_SetFoodCap takes nothing returns nothing
    call SetPlayerStateBJ(GetEnumPlayer(),PLAYER_STATE_RESOURCE_FOOD_CAP,20)
endfunction

function Trig_Init_FoodCap_Actions takes nothing returns nothing
    call ForForce(udg_PlayingPlayers,function Trig_Init_FoodCap_SetFoodCap)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Init_EnemyUpgrades_Actions takes nothing returns nothing
    call SetPlayerAbilityAvailableBJ(false,'Ashm',Player($B)) // 'Ashm': object name not found in map data; $B = 11
    call SetPlayerTechResearchedSwap('R011',1,Player($B)) // 'R011': upgrade "Enemy Summons"; $B = 11
    call SetPlayerTechResearchedSwap('R001',5,Player($B)) // 'R001': upgrade "Sword"; $B = 11
    call SetPlayerTechResearchedSwap('R002',5,Player($B)) // 'R002': upgrade "Bow"; $B = 11
    call SetPlayerTechResearchedSwap('R003',5,Player($B)) // 'R003': upgrade "Rod"; $B = 11
    call SetPlayerTechResearchedSwap('R004',5,Player($B)) // 'R004': upgrade "Staff"; $B = 11
    call SetPlayerTechResearchedSwap('R006',5,Player($B)) // 'R006': upgrade "Leather Armor"; $B = 11
    call SetPlayerTechResearchedSwap('R005',5,Player($B)) // 'R005': upgrade "Plate Armor"; $B = 11
    call SetPlayerTechResearchedSwap('R007',5,Player($B)) // 'R007': upgrade "Mystic Armor"; $B = 11
    call SetPlayerTechResearchedSwap('R01S',1,Player($B)) // 'R01S': upgrade "Attack Speed +100%"; $B = 11
    call SetPlayerTechResearchedSwap('R01T',1,Player($B)) // 'R01T': upgrade "Attack Speed +200%"; $B = 11
    call SetPlayerTechResearchedSwap('R01V',1,Player($B)) // 'R01V': upgrade "Attack Speed +300%"; $B = 11
    call SetPlayerTechResearchedSwap('R01U',1,Player($B)) // 'R01U': upgrade "Attack Speed +400%"; $B = 11
    call SetPlayerTechResearchedSwap('R01W',1,Player($B)) // 'R01W': upgrade "Command AI: thunderbolt"; $B = 11
    call SetPlayerTechResearchedSwap('R01X',1,Player($B)) // 'R01X': upgrade "Command AI: flamestrike"; $B = 11
    call SetPlayerTechResearchedSwap('R01Y',1,Player($B)) // 'R01Y': upgrade "Command AI: frostnova"; $B = 11
    call SetPlayerTechResearchedSwap('R01Z',1,Player($B)) // 'R01Z': upgrade "Command AI: shockwave"; $B = 11
    call SetPlayerTechResearchedSwap('R020',1,Player($B)) // 'R020': upgrade "Command AI: stomp and thunderclap"; $B = 11
    call SetPlayerHandicapXPBJ(Player(8),.0)
    call SetPlayerHandicapXPBJ(Player(9),.0)
    call SetPlayerHandicapXPBJ(Player($A),.0) // $A = 10
    call SetPlayerHandicapXPBJ(Player($B),.0) // $B = 11
    call SetPlayerTechResearchedSwap('R000',$A,Player(9)) // 'R000': upgrade "Tools"; $A = 10
    call SetPlayerTechResearchedSwap('R001',$A,Player(9)) // 'R001': upgrade "Sword"; $A = 10
    call SetPlayerTechResearchedSwap('R002',$A,Player(9)) // 'R002': upgrade "Bow"; $A = 10
    call SetPlayerTechResearchedSwap('R00B',$A,Player(9)) // 'R00B': upgrade "Dagger"; $A = 10
    call SetPlayerTechResearchedSwap('R008',$A,Player(9)) // 'R008': upgrade "Axe"; $A = 10
    call SetPlayerTechResearchedSwap('R00A',$A,Player(9)) // 'R00A': upgrade "Katana"; $A = 10
    call SetPlayerTechResearchedSwap('R009',$A,Player(9)) // 'R009': upgrade "Spear"; $A = 10
    call SetPlayerTechResearchedSwap('R00N',$A,Player(9)) // 'R00N': upgrade "Greatsword"; $A = 10
    call SetPlayerTechResearchedSwap('R003',$A,Player(9)) // 'R003': upgrade "Rod"; $A = 10
    call SetPlayerTechResearchedSwap('R004',$A,Player(9)) // 'R004': upgrade "Staff"; $A = 10
    call SetPlayerTechResearchedSwap('R00M',$A,Player(9)) // 'R00M': upgrade "Gun"; $A = 10
    call SetPlayerTechResearchedSwap('R00L',$A,Player(9)) // 'R00L': upgrade "Inner Mana"; $A = 10
    call SetPlayerTechResearchedSwap('R006',$A,Player(9)) // 'R006': upgrade "Leather Armor"; $A = 10
    call SetPlayerTechResearchedSwap('R005',$A,Player(9)) // 'R005': upgrade "Plate Armor"; $A = 10
    call SetPlayerTechResearchedSwap('R007',$A,Player(9)) // 'R007': upgrade "Mystic Armor"; $A = 10
endfunction

function Trig_Init_InvulnerableGates_Actions takes nothing returns nothing
    call SetDestructableInvulnerableBJ(gg_dest_LTg4_0005,true)
    call SetDestructableInvulnerableBJ(gg_dest_DTg8_0028,true)
    call SetDestructableInvulnerableBJ(gg_dest_LTe2_0020,true)
    call SetDestructableInvulnerableBJ(gg_dest_DTg6_0052,true)
    call SetDestructableInvulnerableBJ(gg_dest_DTg7_0013,true)
    call SetDestructableInvulnerableBJ(gg_dest_LTg2_0021,true)
    call SetDestructableInvulnerableBJ(gg_dest_ATg3_0012,true)
    call SetDestructableInvulnerableBJ(gg_dest_ITig_0030,true)
    call SetDestructableInvulnerableBJ(gg_dest_LTt1_0014,true)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Init_TimeOfDay_Actions takes nothing returns nothing
    call SetTimeOfDay(6.)
    call SetTimeOfDayScalePercentBJ(35.)
    call UseTimeOfDayBJ(false)
    set udg_GameDay=1
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Init_LockTrading_Actions takes nothing returns nothing
    call SetMapFlag(MAP_LOCK_RESOURCE_TRADING,true)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Init_HideUiAbilities_DisableUiAbilities takes nothing returns nothing
    call SetPlayerAbilityAvailableBJ(false,'A0KH',GetEnumPlayer()) // 'A0KH': ability "Hero Modifier Container"
    call SetPlayerAbilityAvailableBJ(false,'A10F',GetEnumPlayer()) // 'A10F': ability "Spiritual Power"
    call SetPlayerAbilityAvailableBJ(false,'A11U',GetEnumPlayer()) // 'A11U': ability "Scan"
    call SetPlayerAbilityAvailableBJ(false,'A0MW',GetEnumPlayer()) // 'A0MW': ability "Armory"
endfunction

function Trig_Init_HideUiAbilities_Actions takes nothing returns nothing
    call ForForce(udg_ActivePlayers,function Trig_Init_HideUiAbilities_DisableUiAbilities)
    call SetPlayerAbilityAvailableBJ(false,'S00K',Player($A)) // 'S00K': ability "Channel Summon"; $A = 10
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Init_InfoQuest_Actions takes nothing returns nothing
    set udg_InfoQuest=CreateQuestBJ(bj_QUESTTYPE_OPT_DISCOVERED,"Game Information","This is the information about current game.","ReplaceableTextures\\CommandButtons\\BTNManaShield.blp")
    set udg_ColorCyan="|cff00ffff"
    set udg_ColorGreen="|cff00ff00"
    set udg_ColorOrange="|cffff8040"
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=4
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        set udg_InfoQuestItem[GetForLoopIndexA()]=CreateQuestItemBJ(udg_InfoQuest,I2S(GetForLoopIndexA()))
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Init_QuestLog_Actions takes nothing returns nothing
    set udg_DifficultyQuest=CreateQuestBJ(bj_QUESTTYPE_OPT_DISCOVERED,"Difficulty","(null)","ReplaceableTextures\\CommandButtons\\BTNCrystalBall.blp")
    call CreateQuestBJ(bj_QUESTTYPE_OPT_DISCOVERED,"New in Version 0.9.7.3","- Some rebalancing of buffs and debuffs.\r\n- Ability cooldowns have been adjusted.\r\n- Nerfed attack cooldown of Strength heroes.\r\n- New secret boss has been added.\r\n- Fixed several bugs including some potential crashes.","ReplaceableTextures\\CommandButtons\\BTNBansheeMaster.blp")
    call CreateQuestBJ(bj_QUESTTYPE_OPT_DISCOVERED,"Code Saving and Loading",ModuleLongText_1(),"ReplaceableTextures\\CommandButtons\\BTNLamp.blp")
    call CreateQuestBJ(bj_QUESTTYPE_OPT_DISCOVERED,"File Saving and Loading",ModuleLongText_2(),"ReplaceableTextures\\CommandButtons\\BTNLamp.blp")
    call CreateQuestBJ(bj_QUESTTYPE_OPT_DISCOVERED,"Job System","This game uses a job system where you can select one of many different job to gain different appearance, stats and abilities. The jobs in this map are mainly from Final Fantasy Tactics. Each of your jobs has its own level, but can equip gear up to your Spirit of Gaya's level. To progress to higher tier jobs you must meet certain requirments. Change Job using Shrines of Battle and Magic (found in upper part of Kalm). Higher tier jobs are not strictly stronger choices, they have higher base stats but lower stat growth, in the highest levels all jobs are viable choices.","ReplaceableTextures\\CommandButtons\\BTNShadowmeld.blp")
    call CreateQuestBJ(bj_QUESTTYPE_OPT_DISCOVERED,"Spirit of Gaya","Spirit of Gaya is a mystical creature that follows you everywhere and has some special abilities that make your life easier. Some of abilities are innate while others are have to be bought and upgraded at the Pandaren Spiritualist.\r\n\r\nYou can use items with your Spirit of Gaya's inventory to have your hero use them. Cooldowns for consumable items will not show up on your Spirit but still prevent usage. Equipment abilities can also be used this way.\r\n\r\nSpirit of Gaya gains slightly less EXP than your hero. Your Spirit of Gaya's level determines whether or not you can use certain equipment.","ReplaceableTextures\\CommandButtons\\BTNFaerieDragon.blp")
    call CreateQuestBJ(bj_QUESTTYPE_OPT_DISCOVERED,"Damage vs. Armor","This map uses a rock-paper-scissors styled damage type system, with Pierce, Slash and Strike. Pierce (Pierce attack, Small defense) beats Slash (Normal attack, Medium defense) beats Strike (Siege attack, Heavy defense) beats Pierce. A Pierce unit will do 150% damage to a Slash unit but only 50% to a Strike unit, and so on.\r\n\r\nSpell casters have Magic attack type which does reduced damage to all enemy types and Unarmored armor type which takes extra damage from all regular attack types. Some enemies and structures have Fortified or Demon defense which takes reduced damage from all regular attack types. Flans and other ethereal enemies have Impenetrable armor which takes minimal damage from regular attack types. Finally, Demon and Holy attack types deal regular damage to all types (and no increased damage to Unarmored either), except Holy attack also deals extra damage to Demons.","ReplaceableTextures\\CommandButtons\\BTNChime.blp")
    call CreateQuestBJ(bj_QUESTTYPE_OPT_DISCOVERED,"Item System",ModuleLongText_3(),"ReplaceableTextures\\CommandButtons\\BTNGoldRing.blp")
    call CreateQuestBJ(bj_QUESTTYPE_OPT_DISCOVERED,"Techniques","Techniques are abilities used by Warrior jobs. They deal physical damage scaling with their MP cost as well as the hero's attributes and deal extra damage if the hero is using a weapon of a matching type - for example, Sword techniques are stronger when using a Sword type weapon; in addition, the level of the Sword House upgrade will also increase their damage.\r\n\r\nIf a technique deals the killing blow to an enemy, a 'Tech Finish' is achieved and they will give 40% more EXP than normal.","ReplaceableTextures\\CommandButtons\\BTNFlamingArrows.blp")
    call CreateQuestBJ(bj_QUESTTYPE_OPT_DISCOVERED,"Spells","Spells form the majority of mage jobs' abilities. Their damage scales with the amount of MP they use along with the caster's Intelligence stat.\r\n\r\nThere are Elemental spells that deal damage and can be particularly effective or ineffective depending on the enemy (see also below: Elements) and their power can be amplified further in a number of ways. Rod users are masters of this school of magic.\r\n\r\nThere are Life spells that manipulate the life of the caster or enemy in some way, restoring health or draining it. Staff users are the masters of this school of magic.\r\n\r\nFinally there are Non-elemental spells that draw on the caster's inner power to deal devastating damage to any kind of enemy. Inner Mana users are the masters of this school of magic.\r\n\r\nSpells are generally more powerful when cast with high or full MP and lose some of their power when the caster has low MP. "+"It is therefore recommended to keep a high amount of MP as much as possible.","ReplaceableTextures\\CommandButtons\\BTNWitchDoctorAdept.blp")
    call CreateQuestBJ(bj_QUESTTYPE_OPT_DISCOVERED,"Elements",ModuleLongText_4(),"ReplaceableTextures\\CommandButtons\\BTNElementFury.blp")
    call CreateQuestBJ(bj_QUESTTYPE_OPT_DISCOVERED,"Eidolons","Eidolons are unique summoned monsters called from other dimensions. Summoner, Calculator and Sorcerer may summon Eidolons. Archer's animal companions and Lancer's dragons are not Eidolons, rules described below do not apply to them.\r\nAll Eidolons are unique. Here's an example how it works. You can not summon two Ifrits because only one Ifrit exists in the universe. If you summoned Ifrit (or any other Eidolon) and another Summoner summons Ifrit then Ifrit will go back to his home plane and then will be summoned for the Summoner who last summoned him. That's why having two Summoners in one party is not a great idea.","ReplaceableTextures\\CommandButtons\\BTNArcaneObservatory.blp")
    call CreateQuestBJ(bj_QUESTTYPE_OPT_DISCOVERED,"Mastery of Jobs","When your character reaches |cffffcc00Level 50|r you become Master in this job. Mastering a job gives you +20 to all base stats for the mastered job and allows swapping one of its abilities with an ability of the same slot of any other mastered job. The Freelancer can also use any abilities of mastered jobs.\r\nWhen you reach |cffffcc00Level 99|r you become Ultimate Master and get +50 to all base stats instead. Additionally, your Freelancer's base stats will increase.\r\n\r\nThere may yet be a level of mastery beyond Ultimate Master...","ReplaceableTextures\\CommandButtons\\BTNOrb.blp")
    call CreateQuestBJ(bj_QUESTTYPE_OPT_DISCOVERED,"Text Speed","To change text speed in cinematics type \"-text #\" where # ranges from 1 (slowest) to 9 (fastest). Improper use of this command will result in text speed being reset to default (5).\r\nType  \"-text instant\" or \"-instant\" to activate instant text speed.\r\nType \"-text skip\" or \"-skip\" to activate cinematic skip mode.","ReplaceableTextures\\CommandButtons\\BTNBookOfSummoning.blp")
    call CreateQuestBJ(bj_QUESTTYPE_OPT_DISCOVERED,"Dueling","Players are able to fight each other using the following commands:\r\n\"-war #\" - declares war on another player, you can both attack each other.\r\n\"-peace #\" - suggests peace to another player, prevents you from attacking them.\r\n# stands for the Player Number of the player, so 1 for Red, 2 for Blue, etc. You can also use the \"-number\" command to find out your own Player Number.\r\nTo prevent PvP trolls, Player 1 (Red) can use the command \"-pvp\" to deactivate it entirely. The same command can also reactivate it.","ReplaceableTextures\\CommandButtons\\BTNBerserk.blp")
    call CreateQuestBJ(bj_QUESTTYPE_OPT_DISCOVERED,"Commands",ModuleLongText_5(),"ReplaceableTextures\\CommandButtons\\BTNBarrel.blp")
    call CreateQuestBJ(bj_QUESTTYPE_OPT_DISCOVERED,"Custom Music",ModuleLongText_6(),"ReplaceableTextures\\CommandButtons\\BTNAlleriaFlute.blp")
    call CreateQuestBJ(bj_QUESTTYPE_OPT_DISCOVERED,"Credits","This map was created by |cff4080ffI|cff5080ffL|cff6080ffY|cff7080ffA|cff8080ffS|r\r\nIt is now edited by Karifean.\r\nYou can post your suggestions at fferpg.forumotion.com.\r\n\r\nMost custom icons are from Blizzard's World of Warcraft game. Credits for others goes to Darky29, Clan TDG, wc3sear.ch, Darkfang, Blood Raven, PrinceOfFame, Mc !, Darkminnion, ragingspeedhorn, Static, The_Silent, Hemske, PeeKay, stonneash, The Panda, Edge45, LifeguardLeroy, tee.dubs, TurtleRacingCar, Golden-Drake, Mobilize, KelThuzad and Goblinounours.\r\n\r\nP.S. If you see your skin or model or spell or icon created by you used in my map and you have not been given proper credit - contact me on the forums and I will fix that issue.","ReplaceableTextures\\CommandButtons\\BTNStormEarth&Fire.blp")
    call CreateQuestBJ(bj_QUESTTYPE_OPT_DISCOVERED,"Thanks to...","Thanks goes to psxlover, Pfeffer, Andrenden, Fommels, Eldar, Zelune, Terrian, Clavitz, Blaze, Darkvengeance, Wizarddum, Loesil, Nazzov, prime_genx and ZerglingMan who helped in making this map or gave useful ideas.\r\nThanks to ILYAS for creating the idea!","ReplaceableTextures\\CommandButtons\\BTNDenOfWonders.blp")
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Init_VoteOptionText_Actions takes nothing returns nothing
    set udg_VoteOptionText[0]="Very Slow"
    set udg_VoteOptionText[1]="Slow"
    set udg_VoteOptionText[2]="Normal"
    set udg_VoteOptionText[3]="Fast"
    set udg_VoteOptionText[4]="Very Fast"
    set udg_VoteOptionText[5]="Skip (Text Only)"
    set udg_VoteOptionText[6]="Skip (All Scenes)"
    set udg_VoteOptionText[7]="|cff00ff00Simple|r"
    set udg_VoteOptionText[8]="|cff22cc22Easy|r"
    set udg_VoteOptionText[9]="|cffffff00Normal|r"
    set udg_VoteOptionText[$A]="|cffcc2222Hard|r" // $A = 10
    set udg_VoteOptionText[$B]="|cffdd0000Inferno|r" // $B = 11
    set udg_VoteOptionText[$C]="|cff330000Nightmare|r" // $C = 12
    set udg_VoteOptionText[$D]="|cffffcc00Normal|r" // $D = 13
    set udg_VoteOptionText[$E]="|cff3fff3fEternity (High Level)|r" // $E = 14
    set udg_VoteOptionText[$F]="|cff7f7fffSpeedrun|r" // $F = 15
    set udg_VoteOptionText[16]="|cffff0000Hardcore (One Life)|r"
    set udg_VoteOptionText[17]="|cff4444ddScenario|r"
endfunction

function Trig_Init_SkyAndSubtitles_Actions takes nothing returns nothing
    call ForceCinematicSubtitlesBJ(true)
    call SetSkyModel("Environment\\Sky\\LordaeronSummerSky\\LordaeronSummerSky.mdl")
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Init_AncientForestNpcs_Actions takes nothing returns nothing
    call ShowUnitHide(gg_unit_nwgt_0142)
    call ShowUnitHide(gg_unit_nwgt_0141)
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=6
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        call SetItemDroppableBJ(UnitItemInSlotBJ(gg_unit_Ecen_0180,GetForLoopIndexA()),false)
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    set udg_SpecialEffect[37]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_Ecen_0180,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    set udg_SpecialEffect[30]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_Emns_0156,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Init_ZaleraChapter_Actions takes nothing returns nothing
    set udg_GafgarionRevived=false
    set udg_NecrophobeStarted=false
    set udg_ZaleraStage=0
    call ShowUnitHide(gg_unit_Uwar_0192)
    call PauseUnitBJ(true,gg_unit_Uwar_0192)
    call SetUnitInvulnerable(gg_unit_Uwar_0192,true)
    call ShowUnitHide(gg_unit_U000_0248)
    call PauseUnitBJ(true,gg_unit_U000_0248)
    call SetUnitInvulnerable(gg_unit_U000_0248,true)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_Init automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Init_Part1 / RegisterTriggers_Init_Part2 (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
// Owned setup helpers; bootstrap controls their original execution order.
function Init_InitializeDiaryEntryArray takes nothing returns nothing
    local integer setupIndex
    set setupIndex=0
    loop
        exitwhen(setupIndex>27)
        set udg_DiaryEntry[setupIndex]=""
        set setupIndex=setupIndex+1
    endloop
endfunction

function Init_InitializeFestivalScoreArray takes nothing returns nothing
    local integer setupIndex
    set setupIndex=0
    loop
        exitwhen(setupIndex>$D) // $D = 13
        set udg_FestivalScore[setupIndex]=0
        set udg_NecroCorpseGroup[setupIndex]=CreateGroup()
        set setupIndex=setupIndex+1
    endloop
endfunction

function Init_InitializeBossDefeatedArray takes nothing returns nothing
    local integer setupIndex
    set setupIndex=0
    loop
        exitwhen(setupIndex>$E) // $E = 14
        set udg_BossDefeated[setupIndex]=false
        set setupIndex=setupIndex+1
    endloop
endfunction

function Init_InitializeSaveFlagForceArray takes nothing returns nothing
    local integer setupIndex
    set setupIndex=0
    loop
        exitwhen(setupIndex>600)
        set udg_SaveFlagForce[setupIndex]=CreateForce()
        set setupIndex=setupIndex+1
    endloop
endfunction

function Init_InitializeJobMasterForceArray takes nothing returns nothing
    local integer setupIndex
    set setupIndex=0
    loop
        exitwhen(setupIndex>24)
        set udg_JobMasterForce[setupIndex]=CreateForce()
        set udg_QuestForce[setupIndex]=CreateForce()
        set setupIndex=setupIndex+1
    endloop
endfunction

function Init_InitializeSpeedrunTimeLimitArray takes nothing returns nothing
    local integer setupIndex
    set setupIndex=0
    loop
        exitwhen(setupIndex>16)
        set udg_SpeedrunTimeLimit[setupIndex]=0
        set setupIndex=setupIndex+1
    endloop
endfunction

function Init_InitializeEidolonAwardForceArray takes nothing returns nothing
    local integer setupIndex
    set setupIndex=0
    loop
        exitwhen(setupIndex>3)
        set udg_EidolonAwardForce[setupIndex]=CreateForce()
        set setupIndex=setupIndex+1
    endloop
endfunction

function Init_InitializeItemCountedArray takes nothing returns nothing
    local integer setupIndex
    set setupIndex=0
    loop
        exitwhen(setupIndex>500)
        set udg_ItemCounted[setupIndex]=false
        set setupIndex=setupIndex+1
    endloop
endfunction

function Init_InitializeQuFrogDrainingArray takes nothing returns nothing
    local integer setupIndex
    set setupIndex=0
    loop
        exitwhen(setupIndex>4)
        set udg_QuFrogDraining[setupIndex]=false
        set udg_SpiritCalm[setupIndex]=false
        set udg_SpiritWanderTick[setupIndex]=0
        set setupIndex=setupIndex+1
    endloop
endfunction

function Init_InitializeSpeciesNameArray takes nothing returns nothing
    local integer setupIndex
    set setupIndex=0
    loop
        exitwhen(setupIndex>30)
        set udg_SpeciesName[setupIndex]=""
        set udg_ArmoryParentCategory[setupIndex]=0
        set udg_LoreText[setupIndex]=""
        set udg_OversoulKillsNeeded[setupIndex]=0
        set udg_SpeciesKillCount[setupIndex]=0
        set setupIndex=setupIndex+1
    endloop
endfunction

function Init_InitializeShadowSpawnFacingArray takes nothing returns nothing
    local integer setupIndex
    set setupIndex=0
    loop
        exitwhen(setupIndex>51)
        set udg_ShadowSpawnFacing[setupIndex]=0
        set setupIndex=setupIndex+1
    endloop
endfunction

function Init_InitializeVoteOptionTextArray takes nothing returns nothing
    local integer setupIndex
    set setupIndex=0
    loop
        exitwhen(setupIndex>$F) // $F = 15
        set udg_VoteOptionText[setupIndex]=""
        set udg_VoteCount[setupIndex]=0
        set setupIndex=setupIndex+1
    endloop
endfunction

function Init_InitializeJobNameArray takes nothing returns nothing
    local integer setupIndex
    set setupIndex=0
    loop
        exitwhen(setupIndex>23)
        set udg_JobName[setupIndex]=""
        set udg_QuestStage[setupIndex]=0
        set setupIndex=setupIndex+1
    endloop
endfunction

function Init_InitializePlayerKillCountArray takes nothing returns nothing
    local integer setupIndex
    set setupIndex=0
    loop
        exitwhen(setupIndex>20)
        set udg_PlayerKillCount[setupIndex]=0
        set udg_CountedItemIndex[setupIndex]=0
        set setupIndex=setupIndex+1
    endloop
endfunction

function Init_InitializeTotalJobLevelArray takes nothing returns nothing
    local integer setupIndex
    set setupIndex=0
    loop
        exitwhen(setupIndex>9)
        set udg_TotalJobLevel[setupIndex]=0
        set udg_HighestJobLevel[setupIndex]=0
        set udg_NewsTitle[setupIndex]="no"
        set udg_NewsEntry[setupIndex]="no"
        set udg_NewsEntryCooldown[setupIndex]=false
        set udg_ZoneKillStreak[setupIndex]=0
        set udg_ZoneStreakID[setupIndex]=0
        set udg_LastKillZoneID[setupIndex]=0
        set udg_AutoBrewEnabled[setupIndex]=false
        set udg_ArenaBracketTeam[setupIndex]=0
        set udg_AbilitySlot1[setupIndex]=0
        set udg_AbilitySlot2[setupIndex]=0
        set udg_AbilitySlot3[setupIndex]=0
        set udg_AbilitySlot4[setupIndex]=0
        set udg_GayaReady[setupIndex]=true
        set udg_CameraDistance[setupIndex]=0
        set udg_MetaFragments[setupIndex]=0
        set udg_RangedShotTimer[setupIndex]=CreateTimer()
        set udg_MiracleStage[setupIndex]=0
        set udg_DodgeFaceTimer[setupIndex]=CreateTimer()
        set udg_GatherState[setupIndex]=0
        set udg_FishingTimer[setupIndex]=CreateTimer()
        set udg_NewGamePlusLevel[setupIndex]=0
        set udg_BattlePoints[setupIndex]=0
        set udg_BeltStacks[setupIndex]=0
        set udg_ArmoryItemCount[setupIndex]=0
        set udg_unused_string_01[setupIndex]=""
        set udg_unused_string_02[setupIndex]=""
        set udg_unused_integer_01[setupIndex]=0
        set udg_PlayerName[setupIndex]=""
        set udg_SubSkillSlot[setupIndex]=0
        set udg_MainSkillSlot[setupIndex]=0
        set udg_CodeDifficulty[setupIndex]=0
        set udg_MolotovCooldown[setupIndex]=0
        set udg_MomentumCharges[setupIndex]=0
        set udg_SpellCooldownTimer[setupIndex]=CreateTimer()
        set udg_DodgeSaveTimer[setupIndex]=CreateTimer()
        set udg_BlindSpotCount[setupIndex]=0
        set udg_SpeedrunLevel[setupIndex]=0
        set udg_MagicDefense[setupIndex]=0
        set udg_AxeChargeTimer[setupIndex]=CreateTimer()
        set udg_ArmorBreakerTimer[setupIndex]=CreateTimer()
        set udg_DamageTally[setupIndex]=0
        set udg_OracleMasteryCount[setupIndex]=0
        set udg_SleepWakeTimer[setupIndex]=CreateTimer()
        set udg_InfinityAbsorbed[setupIndex]=0
        set udg_CoverAwardCount[setupIndex]=0
        set udg_DragonKillCount[setupIndex]=0
        set udg_EnduranceManaCount[setupIndex]=0
        set udg_EnduranceDamageCount[setupIndex]=0
        set udg_HealingTotal[setupIndex]=0
        set udg_BankedXP[setupIndex]=0
        set udg_ExpBankTimer[setupIndex]=CreateTimer()
        set udg_NinjaImmortalTimer[setupIndex]=CreateTimer()
        set udg_LastCritTimer[setupIndex]=CreateTimer()
        set setupIndex=setupIndex+1
    endloop
endfunction

function Init_InitializePlayerColorCodeArray takes nothing returns nothing
    local integer setupIndex
    set setupIndex=0
    loop
        exitwhen(setupIndex>$C) // $C = 12
        set udg_PlayerColorCode[setupIndex]="|cffffcc00"
        set setupIndex=setupIndex+1
    endloop
endfunction

function Init_InitializeFirePotionCountArray takes nothing returns nothing
    local integer setupIndex
    set setupIndex=0
    loop
        exitwhen(setupIndex>6)
        set udg_FirePotionCount[setupIndex]=0
        set udg_TargetRecordTime[setupIndex]=0
        set udg_TargetRecordName[setupIndex]=""
        set setupIndex=setupIndex+1
    endloop
endfunction

function Init_InitializeNewsTextArray takes nothing returns nothing
    local integer setupIndex
    set setupIndex=0
    loop
        exitwhen(setupIndex>7)
        set udg_NewsText[setupIndex]=""
        set udg_MapRewardTier[setupIndex]=0
        set setupIndex=setupIndex+1
    endloop
endfunction

function Init_InitializeStoryFlagArray takes nothing returns nothing
    local integer setupIndex
    set setupIndex=0
    loop
        exitwhen(setupIndex>$A) // $A = 10
        set udg_StoryFlag[setupIndex]=false
        set udg_WandererSpawned[setupIndex]=false
        set udg_ElementalMoveTimer[setupIndex]=0
        set udg_ElementalKillStreak[setupIndex]=0
        set udg_HuntCounter[setupIndex]=0
        set udg_ArenaBonusBattle[setupIndex]=0
        set udg_HuntBoardLabel[setupIndex]=""
        set udg_SpeedrunFlag[setupIndex]=false
        set udg_HuntStock[setupIndex]=0
        set setupIndex=setupIndex+1
    endloop
endfunction

function Init_InitializeQuestFlagArray takes nothing returns nothing
    local integer setupIndex
    set setupIndex=0
    loop
        exitwhen(setupIndex>1)
        set udg_QuestFlag[setupIndex]=false
        set udg_ElementalAlive[setupIndex]=false
        set udg_GlyphActivated[setupIndex]=false
        set udg_ElementalKilledOnce[setupIndex]=false
        set setupIndex=setupIndex+1
    endloop
endfunction

function Init_InitializeCurseHintLineArray takes nothing returns nothing
    local integer setupIndex
    set setupIndex=0
    loop
        exitwhen(setupIndex>8)
        set udg_CurseHintLine[setupIndex]=""
        set udg_ArenaBracketSlot[setupIndex]=0
        set udg_EffectModelPath[setupIndex]=""
        set udg_ElementRecord[setupIndex]=0
        set udg_RingHintUsed[setupIndex]=false
        set udg_AdaptElementTotal[setupIndex]=0
        set udg_NullElementForce[setupIndex]=CreateForce()
        set udg_NullElementCount[setupIndex]=0
        set udg_WeakElementForce[setupIndex]=CreateForce()
        set udg_WeakElementCount[setupIndex]=0
        set udg_DodgeStreak[setupIndex]=0
        set setupIndex=setupIndex+1
    endloop
endfunction

function Init_InitializeMaterialOwnedCountArray takes nothing returns nothing
    local integer setupIndex
    set setupIndex=0
    loop
        exitwhen(setupIndex>'d')
        set udg_MaterialOwnedCount[setupIndex]=0
        set udg_TitleChroniclePoints[setupIndex]=0
        set udg_TitleForce[setupIndex]=CreateForce()
        set udg_TitleStatsBlocked[setupIndex]=false
        set udg_BonusValue[setupIndex]=0
        set udg_BonusText[setupIndex]=""
        set udg_TitleChronicleIndex[setupIndex]=0
        set udg_TitleName[setupIndex]=""
        set udg_BonusGroup[setupIndex]=CreateGroup()
        set udg_MaterialSpentCount[setupIndex]=0
        set udg_TitlePrimaryStatOnly[setupIndex]=false
        set setupIndex=setupIndex+1
    endloop
endfunction

function Init_InitializeCupWinsArray takes nothing returns nothing
    local integer setupIndex
    set setupIndex=0
    loop
        exitwhen(setupIndex>$B) // $B = 11
        set udg_CupWins[setupIndex]=0
        set setupIndex=setupIndex+1
    endloop
endfunction

function Init_InitializeMateriaAltarDoneArray takes nothing returns nothing
    local integer setupIndex
    set setupIndex=0
    loop
        exitwhen(setupIndex>5)
        set udg_MateriaAltarDone[setupIndex]=false
        set udg_JudgeTimer[setupIndex]=CreateTimer()
        set udg_HerbRespawnTimer[setupIndex]=CreateTimer()
        set setupIndex=setupIndex+1
    endloop
endfunction

function Init_InitializeChocoboDigItemChargesArray takes nothing returns nothing
    local integer setupIndex
    set setupIndex=0
    loop
        exitwhen(setupIndex>35)
        set udg_ChocoboDigItemCharges[setupIndex]=0
        set setupIndex=setupIndex+1
    endloop
endfunction

function Init_InitializeProgressArrays takes nothing returns nothing
    local integer setupIndex
    set setupIndex=0
    call Init_InitializePlayerKillCountArray()
    set udg_PlayingPlayers=CreateForce()
    set udg_CidResearchTimer=CreateTimer()
    set udg_SharedDelayTimer1=CreateTimer()
    set udg_TempGroup=CreateGroup()
    set udg_ExpRate=100.
    set udg_TalkRange=450.
    call Init_InitializeTotalJobLevelArray()
    set udg_KalmSiegeTimer=CreateTimer()
    set udg_HideoutGuards=CreateGroup()
    call Init_InitializePlayerColorCodeArray()
    set udg_AbilityTextEnabled=true
    set udg_EdenTimer=CreateTimer()
    call Init_InitializeFirePotionCountArray()
    call Init_InitializeNewsTextArray()
    call Init_InitializeStoryFlagArray()
    set udg_unused_group_01=CreateGroup()
    set udg_unused_group_02=CreateGroup()
    set udg_VoteTimer=CreateTimer()
    call Init_InitializeQuestFlagArray()
    call Init_InitializeCurseHintLineArray()
    call Init_InitializeMaterialOwnedCountArray()
    set udg_ArenaNpcGroup=CreateGroup()
    set udg_SharedDelayTimer2=CreateTimer()
    set udg_ArenaSpawnGroup=CreateGroup()
    call Init_InitializeCupWinsArray()
    call Init_InitializeMateriaAltarDoneArray()
    call Init_InitializeChocoboDigItemChargesArray()
endfunction

function Init_InitializeArenaAndPresentation takes nothing returns nothing
    set udg_SharedDelayTimer3=CreateTimer()
    set udg_StoryEventTimer=CreateTimer()
    set udg_JudgeGroup=CreateGroup()
    set udg_NpcTrioGroup=CreateGroup()
    call Init_InitializeQuFrogDrainingArray()
    set udg_SharedDelayTimer4=CreateTimer()
    set udg_CupArenaUnits=CreateGroup()
    set udg_ArenaLockTimer=CreateTimer()
    set udg_CupArenaPlayers=CreateForce()
    set udg_ShowDamageText=true
    set udg_GnollCampUnits=CreateGroup()
    call Init_InitializeSpeciesNameArray()
    set udg_TextSpeed=250.
    set udg_ActivePlayers=CreateForce()
    call Init_InitializeShadowSpawnFacingArray()
    set udg_ShadowTimer=CreateTimer()
    set udg_ShadowLevelPool=CreateForce()
    call Init_InitializeVoteOptionTextArray()
    set udg_VoteDialog=DialogCreate()
    set udg_unused_timer_01=CreateTimer()
    set udg_TempForce=bj_FORCE_PLAYER[0]
    set udg_WorldEventTimer=CreateTimer()
    call Init_InitializeJobNameArray()
endfunction

function Init_InitializeGameplayServices takes nothing returns nothing
    set udg_ExpShareRange=1280.
    set udg_BossGroup=CreateGroup()
    set udg_HardcoreOff=true
    set udg_PrayingUnits=CreateGroup()
    set udg_PendingEffectGroup=CreateGroup()
    set udg_unused_force_01=CreateForce()
    set udg_NaishaHealTimer=CreateTimer()
    set udg_BlueGirlTimer=CreateTimer()
    set udg_GafgarionReviveTimer=CreateTimer()
    set udg_GhoulGroup=CreateGroup()
    set udg_KalmGuards=CreateGroup()
    set udg_BerserkGuards=CreateGroup()
    set udg_unused_group_03=CreateGroup()
    set udg_ArenaSummonGroup=CreateGroup()
    set udg_PenanceArms=CreateGroup()
    set udg_unused_group_04=CreateGroup()
    set udg_FarmWorkingVillagers=CreateGroup()
    set udg_FarmGatheredVillagers=CreateGroup()
    set udg_EnchantCycleTimer=CreateTimer()
    set udg_ImmolationAuraGroup=CreateGroup()
    set udg_SplashGroup=CreateGroup()
    set udg_SplashTimer=CreateTimer()
    set udg_FarmCorpses=CreateGroup()
    set udg_QuestNpcUnits=CreateGroup()
    set udg_DemiFiendDemon1Timer=CreateTimer()
    set udg_DemiFiendDemon2Timer=CreateTimer()
    set udg_unused_timer_02=CreateTimer()
    set udg_CowSpawnTimer=CreateTimer()
    set udg_CowGroup=CreateGroup()
    set udg_GayaRageTimer=CreateTimer()
    set udg_JobLevelTimer=CreateTimer()
    set udg_BerserkGroup=CreateGroup()
    set udg_MaxHpDrainTimer=CreateTimer()
    set udg_VirusImmuneGroup=CreateGroup()
    set udg_LuShangPending=CreateForce()
    set udg_NebraKingTimer=CreateTimer()
    set udg_AutosaveForce=CreateForce()
    set udg_AbilityTextForce=CreateForce()
    set udg_TrackedPlayers=CreateForce()
    set udg_DifficultyScale=1.
    set udg_TownNpcUnits=CreateGroup()
    set udg_BossUnits=CreateGroup()
    set udg_EliminatedPlayers=CreateForce()
    set udg_QuestUnits=CreateGroup()
    set udg_HuntMonsters=CreateGroup()
    set udg_SiegeTimer=CreateTimer()
    set udg_AllyBrothersGroup=CreateGroup()
    set udg_AllyRangerGroup=CreateGroup()
    set udg_SpecialUnits=CreateGroup()
    set udg_InactiveUnits=CreateGroup()
    set udg_RecruitedAllies=CreateGroup()
    set udg_ShockAuraUnitGroup=CreateGroup()
    set udg_PrimaryQuestUnits=CreateGroup()
    set udg_SiegeSummonGroup=CreateGroup()
    set udg_ArenaBoundUnits=CreateGroup()
    set udg_SummonedUnits=CreateGroup()
    set udg_LivingFlameUnits=CreateGroup()
    set udg_DarkEidolonGroup=CreateGroup()
    set udg_ScorchedEarthTimer=CreateTimer()
    set udg_DrainChannelGroup=CreateGroup()
    set udg_PostReviveTimer=CreateTimer()
    set udg_HuntSlots=CreateForce()
    set udg_DeathExplodeGroup=CreateGroup()
    set udg_DeathExplodeTimer=CreateTimer()
    set udg_RegenGroup=CreateGroup()
    set udg_DuelArenaUnits=CreateGroup()
    set udg_AllyEngineerGroup=CreateGroup()
    set udg_VortexVictims=CreateGroup()
    set udg_VortexTimer=CreateTimer()
    call Init_InitializeDiaryEntryArray()
    set udg_unused_timer_03=CreateTimer()
    set udg_TentacleGroup=CreateGroup()
    set udg_TentacleTimer=CreateTimer()
    set udg_RedBeastGroup=CreateGroup()
    set udg_TargetPracticeDummies=CreateGroup()
    set udg_TargetsRemaining=CreateGroup()
    set udg_TargetPracticeTimer=CreateTimer()
    set udg_SeekerLeaders=CreateGroup()
    set udg_FestivalHunters=CreateGroup()
    call Init_InitializeFestivalScoreArray()
    set udg_FestivalTimer=CreateTimer()
    set udg_SpiritSpawnTimer=CreateTimer()
    set udg_AlmaDisappearTimer=CreateTimer()
    set udg_DarkFactMinions=CreateGroup()
    set udg_CheaterForce=CreateForce()
    set udg_unused_force_02=CreateForce()
    set udg_LoadRefreshTimer=CreateTimer()
    set udg_JobLevelTier1=$F // $F = 15
    set udg_ShemhazaiSoulClones=CreateGroup()
    set udg_SecondaryXPRate=.75
    set udg_ChaosElementalGroup=CreateGroup()
    set udg_ShiftElementsTimer=CreateTimer()
    set udg_PenanceUnits=CreateGroup()
    set udg_TimmyQuestTimer=CreateTimer()
    set udg_GagnrathTimer=CreateTimer()
    set udg_GagnrathCasters=CreateGroup()
    set udg_ArenaRoundTimer=CreateTimer()
    set udg_MirrorCloneGroup=CreateGroup()
    set udg_SharedDelayTimer6=CreateTimer()
    set udg_JobChangeTimer=CreateTimer()
    set udg_MeteoriteRocks=CreateGroup()
    call Init_InitializeBossDefeatedArray()
    set udg_WorldFreezeTimer=CreateTimer()
    call Init_InitializeSaveFlagForceArray()
    set udg_AbsorbShieldGroup=CreateGroup()
    set udg_ReviveCleanupTimer=CreateTimer()
    set udg_RevivedHeroes=CreateGroup()
    set udg_GameClock=CreateTimer()
    set udg_BossSummons=CreateGroup()
    set udg_EcheleMinionKillTimer=CreateTimer()
    set udg_EcheleMinionsToKill=CreateGroup()
    set udg_DpsTimer=CreateTimer()
    set udg_AishaTalkTimer=CreateTimer()
    set udg_BagOfTricksTargets=CreateGroup()
    set udg_ArenaCheckTimer=CreateTimer()
    set udg_LiberationRewardTimer=CreateTimer()
    set udg_DarkEidolonIllusions=CreateGroup()
    set udg_FishingSpots=CreateGroup()
    set udg_MephorashClones=CreateGroup()
    set udg_unused_timer_04=CreateTimer()
    set udg_BazaarUpdateTimer=CreateTimer()
    set udg_ManaRefundTimer=CreateTimer()
    set udg_unused_group_05=CreateGroup()
    set udg_RengekiGroup=CreateGroup()
    set udg_UndyingGroup=CreateGroup()
    set udg_EscortUnits=CreateGroup()
    set udg_TownTargetGroup=CreateGroup()
    set udg_DarkShopGroup=CreateGroup()
    set udg_OblivionDummyGroup=CreateGroup()
    set udg_SecondShrineUnits=CreateGroup()
    set udg_UnitUpdateTimer=CreateTimer()
    set udg_FafnirPatrolTimer=CreateTimer()
    set udg_DuelArenaPlayers=CreateForce()
    call Init_InitializeJobMasterForceArray()
    set udg_SharedDelayTimer5=CreateTimer()
    set udg_HarpyTricksters=CreateGroup()
    set udg_DragonBattleTimer=CreateTimer()
    set udg_DarkServants=CreateGroup()
    set udg_unused_group_06=CreateGroup()
    set udg_BattleLogForce=CreateForce()
    set udg_NeutralPassiveUnits=CreateGroup()
    set udg_RabiteAreaUnits=CreateGroup()
    set udg_GoliathTonicGroup=CreateGroup()
    set udg_MomentumTimer=CreateTimer()
    set udg_ShrineReselectTimer=CreateTimer()
    set udg_AccoladeTimer=CreateTimer()
    set udg_DefendingUnits=CreateGroup()
    set udg_RunicGroup=CreateGroup()
    set udg_ForgeTextTimer=CreateTimer()
    set udg_ShortDelayTimer=CreateTimer()
    set udg_LokiForgeTextTimer=CreateTimer()
    set udg_ValigarmandaMinions=CreateGroup()
    set udg_ValigarmandaWaveTimer=CreateTimer()
    set udg_HuntBoardMarked=CreateGroup()
    call Init_InitializeSpeedrunTimeLimitArray()
    set udg_StunReapplyTimer=CreateTimer()
    set udg_FrozenUnits=CreateGroup()
    set udg_WorldUnits=CreateGroup()
    set udg_StatsRefreshTimer=CreateTimer()
    set udg_LegendaryGuardianForce=CreateForce()
    set udg_BurningBuildings=CreateGroup()
    set udg_GeomancerAwardTimer=CreateTimer()
    set udg_SplashTally=-1.
    set udg_ActiveHeroGroup=CreateGroup()
    set udg_HeroRefreshTimer=CreateTimer()
    set udg_StoryDelayTimer=CreateTimer()
    set udg_ComboTimer=CreateTimer()
    call Init_InitializeEidolonAwardForceArray()
    set udg_DpsRefresh=true
    set udg_EnduranceAwardGroup=CreateGroup()
    set udg_ElementRecordTimer=CreateTimer()
    set udg_ArenaSpawnTimer=CreateTimer()
    call Init_InitializeItemCountedArray()
    set udg_VisionShareTimer=CreateTimer()
endfunction

function InitTrig_Init takes nothing returns nothing
endfunction

function Register_Init_AbilityLevelShift takes nothing returns nothing
    set gg_trg_Init_AbilityLevelShift=CreateTrigger()
    call TriggerAddAction(gg_trg_Init_AbilityLevelShift,function Trig_Init_AbilityLevelShift_Actions)
endfunction

function Register_Init_JobTables takes nothing returns nothing
    set gg_trg_Init_JobTables=CreateTrigger()
    call TriggerRegisterTimerEventSingle(gg_trg_Init_JobTables,7.)
    call TriggerAddAction(gg_trg_Init_JobTables,function Trig_Init_JobTables_Actions)
endfunction

function Register_Init_PlayerForces takes nothing returns nothing
    set gg_trg_Init_PlayerForces=CreateTrigger()
    call TriggerAddAction(gg_trg_Init_PlayerForces,function Trig_Init_PlayerForces_Actions)
endfunction

function Register_Init_PlayerColors takes nothing returns nothing
    set gg_trg_Init_PlayerColors=CreateTrigger()
    call TriggerRegisterTimerEvent(gg_trg_Init_PlayerColors,6,false)
    call TriggerAddAction(gg_trg_Init_PlayerColors,function Trig_Init_PlayerColors_Actions)
endfunction

function Register_Init_RevealStartArea takes nothing returns nothing
    set gg_trg_Init_RevealStartArea=CreateTrigger()
    call TriggerAddAction(gg_trg_Init_RevealStartArea,function Trig_Init_RevealStartArea_Actions)
endfunction

function Register_Init_HideScoreScreen takes nothing returns nothing
    set gg_trg_Init_HideScoreScreen=CreateTrigger()
    call TriggerAddAction(gg_trg_Init_HideScoreScreen,function Trig_Init_HideScoreScreen_Actions)
endfunction

function Register_Init_NeutralPlayer8 takes nothing returns nothing
    set gg_trg_Init_NeutralPlayer8=CreateTrigger()
    call TriggerAddAction(gg_trg_Init_NeutralPlayer8,function Trig_Init_NeutralPlayer8_Actions)
endfunction

function Register_Init_AllyPlayer9 takes nothing returns nothing
    set gg_trg_Init_AllyPlayer9=CreateTrigger()
    call TriggerAddAction(gg_trg_Init_AllyPlayer9,function Trig_Init_AllyPlayer9_Actions)
endfunction

function Register_Init_AllyPlayer10 takes nothing returns nothing
    set gg_trg_Init_AllyPlayer10=CreateTrigger()
    call TriggerAddAction(gg_trg_Init_AllyPlayer10,function Trig_Init_AllyPlayer10_Actions)
endfunction

function Register_Init_RemoveGuards takes nothing returns nothing
    set gg_trg_Init_RemoveGuards=CreateTrigger()
    call TriggerRegisterTimerEventSingle(gg_trg_Init_RemoveGuards,1.2)
    call TriggerAddAction(gg_trg_Init_RemoveGuards,function Trig_Init_RemoveGuards_Actions)
endfunction

function Register_Init_FoodCap takes nothing returns nothing
    set gg_trg_Init_FoodCap=CreateTrigger()
    call TriggerAddAction(gg_trg_Init_FoodCap,function Trig_Init_FoodCap_Actions)
endfunction

function Register_Init_EnemyUpgrades takes nothing returns nothing
    set gg_trg_Init_EnemyUpgrades=CreateTrigger()
    call TriggerRegisterTimerEventSingle(gg_trg_Init_EnemyUpgrades,8.)
    call TriggerAddAction(gg_trg_Init_EnemyUpgrades,function Trig_Init_EnemyUpgrades_Actions)
endfunction

function Register_Init_InvulnerableGates takes nothing returns nothing
    set gg_trg_Init_InvulnerableGates=CreateTrigger()
    call TriggerRegisterTimerEventSingle(gg_trg_Init_InvulnerableGates,2.)
    call TriggerAddAction(gg_trg_Init_InvulnerableGates,function Trig_Init_InvulnerableGates_Actions)
endfunction

function Register_Init_TimeOfDay takes nothing returns nothing
    set gg_trg_Init_TimeOfDay=CreateTrigger()
    call TriggerAddAction(gg_trg_Init_TimeOfDay,function Trig_Init_TimeOfDay_Actions)
endfunction

function Register_Init_LockTrading takes nothing returns nothing
    set gg_trg_Init_LockTrading=CreateTrigger()
    call TriggerAddAction(gg_trg_Init_LockTrading,function Trig_Init_LockTrading_Actions)
endfunction

function Register_Init_HideUiAbilities takes nothing returns nothing
    set gg_trg_Init_HideUiAbilities=CreateTrigger()
    call TriggerAddAction(gg_trg_Init_HideUiAbilities,function Trig_Init_HideUiAbilities_Actions)
endfunction

function Register_Init_InfoQuest takes nothing returns nothing
    set gg_trg_Init_InfoQuest=CreateTrigger()
    call TriggerAddAction(gg_trg_Init_InfoQuest,function Trig_Init_InfoQuest_Actions)
endfunction

function Register_Init_QuestLog takes nothing returns nothing
    set gg_trg_Init_QuestLog=CreateTrigger()
    call TriggerRegisterTimerEventSingle(gg_trg_Init_QuestLog,7.)
    call TriggerAddAction(gg_trg_Init_QuestLog,function Trig_Init_QuestLog_Actions)
endfunction

function Register_Init_VoteOptionText takes nothing returns nothing
    set gg_trg_Init_VoteOptionText=CreateTrigger()
    call TriggerAddAction(gg_trg_Init_VoteOptionText,function Trig_Init_VoteOptionText_Actions)
endfunction

function Register_Init_SkyAndSubtitles takes nothing returns nothing
    set gg_trg_Init_SkyAndSubtitles=CreateTrigger()
    call TriggerAddAction(gg_trg_Init_SkyAndSubtitles,function Trig_Init_SkyAndSubtitles_Actions)
endfunction

function Register_Init_AncientForestNpcs takes nothing returns nothing
    set gg_trg_Init_AncientForestNpcs=CreateTrigger()
    call TriggerAddAction(gg_trg_Init_AncientForestNpcs,function Trig_Init_AncientForestNpcs_Actions)
endfunction

function Register_Init_ZaleraChapter takes nothing returns nothing
    set gg_trg_Init_ZaleraChapter=CreateTrigger()
    call TriggerAddAction(gg_trg_Init_ZaleraChapter,function Trig_Init_ZaleraChapter_Actions)
endfunction

// Creates part 1 of 2 of this module's triggers. Called once at startup from
// Startup_RegisterTriggers (MapBootstrap). The parts are registered at different points so that
// triggers sharing an event with other modules keep their original firing order.
function RegisterTriggers_Init_Part1 takes nothing returns nothing
    call Register_Init_AbilityLevelShift()
    call Register_Init_JobTables()
    call Register_Init_PlayerForces()
    call Register_Init_PlayerColors()
    call Register_Init_RevealStartArea()
    call Register_Init_HideScoreScreen()
    call Register_Init_NeutralPlayer8()
    call Register_Init_AllyPlayer9()
    call Register_Init_AllyPlayer10()
    call Register_Init_RemoveGuards()
    call Register_Init_FoodCap()
    call Register_Init_EnemyUpgrades()
    call Register_Init_InvulnerableGates()
    call Register_Init_TimeOfDay()
    call Register_Init_LockTrading()
    call Register_Init_HideUiAbilities()
    call Register_Init_InfoQuest()
    call Register_Init_QuestLog()
    call Register_Init_VoteOptionText()
endfunction

// Creates part 2 of 2 of this module's triggers. Called once at startup from
// Startup_RegisterTriggers (MapBootstrap). The parts are registered at different points so that
// triggers sharing an event with other modules keep their original firing order.
function RegisterTriggers_Init_Part2 takes nothing returns nothing
    call Register_Init_SkyAndSubtitles()
    call Register_Init_AncientForestNpcs()
    call Register_Init_ZaleraChapter()
endfunction

endlibrary
