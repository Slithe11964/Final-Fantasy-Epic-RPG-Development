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
    // The help entries are the "Create Quest" actions of the GUI trigger QuestLog_Entries
    // (folder 02 Map setup). Edit their text there: World Editor keeps GUI text in the map's
    // string table, which native save/load needs for long text.
    call TriggerExecute(gg_trg_QuestLog_Entries)
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
    call Register_Init_AbilityLevelShift() // run by MapBootstrap
    call Register_Init_JobTables()
    call Register_Init_PlayerForces() // run by MapBootstrap
    call Register_Init_PlayerColors()
    call Register_Init_RevealStartArea() // run by Init
    call Register_Init_HideScoreScreen() // run by Init
    call Register_Init_NeutralPlayer8() // run by Init, Pvp
    call Register_Init_AllyPlayer9() // run by Init, Pvp
    call Register_Init_AllyPlayer10() // run by Init, Pvp
    call Register_Init_RemoveGuards()
    call Register_Init_FoodCap() // run by Init
    call Register_Init_EnemyUpgrades()
    call Register_Init_InvulnerableGates()
    call Register_Init_TimeOfDay() // run by MapBootstrap
    call Register_Init_LockTrading() // run by MapBootstrap
    call Register_Init_HideUiAbilities() // run by Init
    call Register_Init_InfoQuest() // run by MapBootstrap
    call Register_Init_QuestLog()
    call Register_Init_VoteOptionText() // run by MapBootstrap
endfunction

// Creates part 2 of 2 of this module's triggers. Called once at startup from
// Startup_RegisterTriggers (MapBootstrap). The parts are registered at different points so that
// triggers sharing an event with other modules keep their original firing order.
function RegisterTriggers_Init_Part2 takes nothing returns nothing
    call Register_Init_SkyAndSubtitles() // run by MapBootstrap
    call Register_Init_AncientForestNpcs() // run by MapBootstrap
    call Register_Init_ZaleraChapter() // run by MapBootstrap
endfunction

endlibrary
