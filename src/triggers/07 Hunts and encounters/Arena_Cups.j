library TArenaCups requires TForce, TLoc, TMusic
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Arena_Unlock=null
    trigger gg_trg_Arena_Cup_Won=null
    trigger gg_trg_Arena_UnlockCups=null
    trigger gg_trg_Arena_Omega_Absorbs=null
    trigger gg_trg_Arena_Shinryu_Absorbs=null
endglobals

function Trig_Arena_Unlock_CreateBpTag takes nothing returns nothing
    set udg_ArenaBpTag[GetConvertedPlayerId(GetEnumPlayer())]=CreateTextTagUnitBJ("Current BP: |cffffcc000|r",gg_unit_h02I_0167,0,$A,'d','d','d',0) // $A = 10
    call ShowTextTagForceBJ(false,GetLastCreatedTextTag(),GetPlayersAll())
endfunction

function Trig_Arena_Unlock_Actions takes nothing returns nothing
    call ShowUnitShow(gg_unit_h02T_0064)
    call ShowUnitShow(gg_unit_h02G_0160)
    call PauseUnitBJ(false,gg_unit_h02T_0064)
    call PauseUnitBJ(false,gg_unit_h02G_0160)
    call UnitAddAbilityBJ('A0GG',gg_unit_h02T_0064) // 'A0GG': ability "Teleport"
    call UnitAddAbilityBJ('A0GH',gg_unit_h02G_0160) // 'A0GH': ability "Teleport"
    set bj_forLoopAIndex=0
    set bj_forLoopAIndexEnd=udg_ArenaOrganizerLast
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        call UnitAddAbilityBJ('Ane2',udg_ArenaOrganizer[GetForLoopIndexA()]) // 'Ane2': object name not found in map data
        call PauseUnitBJ(false,udg_ArenaOrganizer[GetForLoopIndexA()])
        call ShowUnitShow(udg_ArenaOrganizer[GetForLoopIndexA()])
        call IssueImmediateOrderBJ(udg_ArenaOrganizer[GetForLoopIndexA()],"holdposition")
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    call AddUnitToStockBJ('n09A',udg_ArenaOrganizer[0],1,1) // 'n09A': unit "Arena: Guardia Forest Cup"
    call AddItemToStockBJ('I0IR',gg_unit_e01A_0252,1,1) // 'I0IR': item "Mega Potion (BP)"
    call AddItemToStockBJ('I0IS',gg_unit_e01A_0252,1,1) // 'I0IS': item "Mega Ether (BP)"
    call AddItemToStockBJ('I0IT',gg_unit_e01A_0252,1,1) // 'I0IT': item "Spirit of Lowtown (BP)"
    call ShowUnitHide(gg_unit_n0AX_0188)
    call EnableTrigger(gg_trg_Arena_LeoIntro)
    call EnableTrigger(gg_trg_Arena_GateOpen)
    set udg_ArenaIntroSeen=0
    set udg_SpecialEffect[64]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_h02I_0167,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call ForForce(udg_PlayingPlayers,function Trig_Arena_Unlock_CreateBpTag)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Arena_Cup_Won_IsDimensionCupEnd takes nothing returns boolean
    return(udg_ArenaCupId==$A)and(LoadIntegerBJ(2,7,udg_GameStateHash)>=2) // $A = 10
endfunction

function Trig_Arena_Cup_Won_GateIsOpen takes nothing returns boolean
    return(udg_ArenaGateOpened)
endfunction

function Trig_Arena_Cup_Won_IsRepeatWin takes nothing returns boolean
    return(udg_CupWins[udg_ArenaCupId]>=2)
endfunction

function Trig_Arena_Cup_Won_IsDemonCupWon takes nothing returns boolean
    return(udg_ArenaCupId==9)
endfunction

function Trig_Arena_Cup_Won_IsNormalCup takes nothing returns boolean
    return(udg_ArenaCupId<=9)
endfunction

function Trig_Arena_Cup_Won_IsSurvivalReward takes nothing returns boolean
    return(udg_ArenaSurvivalMode)
endfunction

function Trig_Arena_Cup_Won_HasBonusBP takes nothing returns boolean
    return(udg_EternityMode)
endfunction

function Trig_Arena_Cup_Won_HasDoubleBpReward takes nothing returns boolean
    return(IsPlayerInForce(GetEnumPlayer(),udg_TitleForce[22]))
endfunction

function Trig_Arena_Cup_Won_IsBpOverLimit takes nothing returns boolean
    return(udg_BattlePoints[GetConvertedPlayerId(GetEnumPlayer())]>$F423F) // $F423F = 999999
endfunction

function Trig_Arena_Cup_Won_GiveCupReward takes nothing returns nothing
    local force l_tempForce
    set udg_BeltStacks[GetConvertedPlayerId(GetEnumPlayer())]=(udg_BeltStacks[GetConvertedPlayerId(GetEnumPlayer())]+1)
    set l_tempForce=Force_OfPlayer(GetEnumPlayer())
    if(Trig_Arena_Cup_Won_HasDoubleBpReward())then
        // Result 1: (udg_BattlePoints at position 0) times (2).
        // Result 2: (udg_BattlePoints at position GetConvertedPlayerId(the player being visited)) plus (result 1).
        set udg_BattlePoints[GetConvertedPlayerId(GetEnumPlayer())]=(udg_BattlePoints[GetConvertedPlayerId(GetEnumPlayer())]+(udg_BattlePoints[0]*2))
        // (udg_BattlePoints at position 0) times (2).
        call DisplayTimedTextToForce(l_tempForce,10.,(("|cff00ff00You get "+I2S((udg_BattlePoints[0]*2)))+" Battle Points for winning the cup.|r"))
    else
        // (udg_BattlePoints at position GetConvertedPlayerId(the player being visited)) plus (udg_BattlePoints at
        // position 0).
        set udg_BattlePoints[GetConvertedPlayerId(GetEnumPlayer())]=(udg_BattlePoints[GetConvertedPlayerId(GetEnumPlayer())]+udg_BattlePoints[0])
        call DisplayTimedTextToForce(l_tempForce,10.,(("|cff00ff00You get "+I2S(udg_BattlePoints[0]))+" Battle Points for winning the cup.|r"))
    endif
    if(Trig_Arena_Cup_Won_IsBpOverLimit())then
        set udg_BattlePoints[GetConvertedPlayerId(GetEnumPlayer())]=$F423F // $F423F = 999999
    endif
    call DestroyTextTagBJ(udg_ArenaBpTag[GetConvertedPlayerId(GetEnumPlayer())])
    set udg_ArenaBpTag[GetConvertedPlayerId(GetEnumPlayer())]=CreateTextTagUnitBJ(("Current BP: |cffffcc00"+(I2S(udg_BattlePoints[GetConvertedPlayerId(GetEnumPlayer())])+"|r")),gg_unit_h02I_0167,0,$A,'d','d','d',0) // $A = 10
    call ShowTextTagForceBJ(false,GetLastCreatedTextTag(),GetPlayersAll())
    call ShowTextTagForceBJ(true,GetLastCreatedTextTag(),l_tempForce)
    call DestroyForce(l_tempForce)
    set l_tempForce=null
endfunction

function Trig_Arena_Cup_Won_Actions takes nothing returns nothing
    local location l_tempPoint2
    if(Trig_Arena_Cup_Won_IsDimensionCupEnd())then
        call ConditionalTriggerExecute(gg_trg_AlmightyShinra_Defeat)
        set l_tempPoint2=null
        return
    endif
    set l_tempPoint2=GetRectCenter(gg_rct_046)
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=$C // $C = 12
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        // (30) times (loop counter A treated as a decimal-capable number).
        set udg_TempPoint=Loc_PolarOffset(l_tempPoint2,256,(30.*I2R(GetForLoopIndexA())))
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Other\\Awaken\\Awaken.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    call RemoveLocation(l_tempPoint2)
    call DisplayTimedTextToForce(GetPlayersAll(),10.,"|cff00ff00Arena:|r Congratulations! You are the winner!")
    set bj_forLoopAIndex=0
    set bj_forLoopAIndexEnd=udg_ArenaOrganizerLast
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        call UnitAddAbilityBJ('Ane2',udg_ArenaOrganizer[GetForLoopIndexA()]) // 'Ane2': object name not found in map data
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    call DisableTrigger(gg_trg_Arena_Enter_Region)
    call DisableTrigger(gg_trg_Arena_PlayerLeft)
    call EnableTrigger(gg_trg_Arena_Start_Cup)
    call EnableTrigger(gg_trg_Arena_StartBattle)
    call BlzUnitDisableAbility(gg_unit_h02I_0167,'A14R',false,false) // 'A14R': ability "Arena Cup Toggle"
    call UnitAddAbilityBJ('A0GG',gg_unit_h02T_0064) // 'A0GG': ability "Teleport"
    if(Trig_Arena_Cup_Won_GateIsOpen())then
        call ModifyGateBJ(bj_GATEOPERATION_OPEN,gg_dest_ZTsg_0025)
    endif
    set udg_CupWins[udg_ArenaCupId]=(udg_CupWins[udg_ArenaCupId]+1)
    if(Trig_Arena_Cup_Won_IsRepeatWin())then
        call DisplayTimedTextToForce(GetPlayersAll(),10.,("|cff00ff00Arena:|r This cup has now been beaten "+(I2S(udg_CupWins[udg_ArenaCupId])+" times.")))
    endif
    if(Trig_Arena_Cup_Won_IsNormalCup())then
        if(Trig_Arena_Cup_Won_IsDemonCupWon())then
            call Music_ClearTrack(44)
        else
            call Music_ClearTrack(42)
            call Music_ClearTrack(43)
        endif
        call PlayThematicMusicBJ("FF7-Victory Fanfare.mp3")
    else
        call Music_ClearTrack(44)
        call Music_ClearTrack(45)
        call PlayThematicMusicBJ("FF8TheWinnerShort.mp3")
    endif
    if(Trig_Arena_Cup_Won_IsSurvivalReward())then
        // (udg_ArenaCupId) times (750).
        set udg_BattlePoints[0]=(udg_ArenaCupId*750)
    else
        // (udg_ArenaCupId) times (500).
        set udg_BattlePoints[0]=(udg_ArenaCupId*500)
    endif
    if(Trig_Arena_Cup_Won_HasBonusBP())then
        // Increase udg_BattlePoints at position 0 by 5000.
        set udg_BattlePoints[0]=(udg_BattlePoints[0]+5000)
    endif
    call ForForce(udg_CupArenaPlayers,function Trig_Arena_Cup_Won_GiveCupReward)
    call ForceClear(udg_CupArenaPlayers)
    call ConditionalTriggerExecute(gg_trg_Arena_UnlockCups)
    call ConditionalTriggerExecute(gg_trg_Arena_SyncTeams)
    set udg_ArenaCupId=0
    set l_tempPoint2=null
endfunction

function Trig_Arena_UnlockCups_Conditions takes nothing returns boolean
    return(udg_ArenaRank<2)
endfunction

function Trig_Arena_UnlockCups_CanUnlockBarrens takes nothing returns boolean
    return(udg_ArenaCupId==1)and(udg_CupWins[1]==1)
endfunction

function Trig_Arena_UnlockCups_IsChapter1Or2 takes nothing returns boolean
    return(udg_ArenaCupId==1)or(udg_ArenaCupId==2)
endfunction

function Trig_Arena_UnlockCups_CanUnlockMountains takes nothing returns boolean
    // (udg_CupWins at position 1) plus (udg_CupWins at position 2).
    return(Trig_Arena_UnlockCups_IsChapter1Or2())and((udg_CupWins[1]+udg_CupWins[2])==3)
endfunction

function Trig_Arena_UnlockCups_IsChapter2Or3 takes nothing returns boolean
    return(udg_ArenaCupId==2)or(udg_ArenaCupId==3)
endfunction

function Trig_Arena_UnlockCups_CanUnlockIslands takes nothing returns boolean
    return(Trig_Arena_UnlockCups_IsChapter2Or3())and(udg_CupWins[2]>=1)and(udg_CupWins[3]>=1)and(udg_CupWins[udg_ArenaCupId]==1)
endfunction

function Trig_Arena_UnlockCups_ChocoboCupPending takes nothing returns boolean
    return(udg_ChocoboCupStage==1)
endfunction

function Trig_Arena_UnlockCups_CanUnlockUniqueEnemy takes nothing returns boolean
    return(udg_ArenaCupId==4)and(udg_CrystalShardCount==3)
endfunction

function Trig_Arena_UnlockCups_IsChapter4Or7 takes nothing returns boolean
    return(udg_ArenaCupId==4)or(udg_ArenaCupId==7)
endfunction

function Trig_Arena_UnlockCups_CanUnlockNingen takes nothing returns boolean
    return(Trig_Arena_UnlockCups_IsChapter4Or7())and(udg_CupWins[4]>=1)and(udg_CupWins[7]>=1)and(udg_CupWins[udg_ArenaCupId]==1)
endfunction

function Trig_Arena_UnlockCups_CanUnlockDemon takes nothing returns boolean
    return(udg_ArenaCupId==7)and(udg_CupWins[7]==3)
endfunction

function Trig_Arena_UnlockCups_IsChapter5To9 takes nothing returns boolean
    return(udg_ArenaCupId==5)or(udg_ArenaCupId==6)or(udg_ArenaCupId==8)or(udg_ArenaCupId==9)
endfunction

function Trig_Arena_UnlockCups_ArenaAbilityAllowed takes nothing returns boolean
    return(udg_HardcoreOff==false)
endfunction

function Trig_Arena_UnlockCups_MissingQuest21 takes nothing returns boolean
    return(IsPlayerInForce(GetEnumPlayer(),udg_TitleForce[21])==false)
endfunction

function Trig_Arena_UnlockCups_GrantQuest21 takes nothing returns nothing
    if(Trig_Arena_UnlockCups_MissingQuest21())then
        set udg_TempPlayer=GetEnumPlayer()
        set udg_TempInteger=21
        if(Trig_Arena_UnlockCups_ArenaAbilityAllowed())then
            call SetUnitAbilityLevelSwapped(udg_ChronicleAbility[udg_TitleChronicleIndex[udg_TempInteger]],udg_SpiritOfGaya[GetConvertedPlayerId(udg_TempPlayer)],$A) // $A = 10
        endif
        call ConditionalTriggerExecute(gg_trg_Title_Grant)
    endif
endfunction

function Trig_Arena_UnlockCups_CanUnlockDimension takes nothing returns boolean
    return(Trig_Arena_UnlockCups_IsChapter5To9())and(udg_CupWins[5]>=1)and(udg_CupWins[6]>=1)and(udg_CupWins[8]>=1)and(udg_CupWins[9]>=1)and(udg_CupWins[udg_ArenaCupId]==1)
endfunction

function Trig_Arena_UnlockCups_Actions takes nothing returns nothing
    if(Trig_Arena_UnlockCups_CanUnlockBarrens())then
        call AddUnitToStockBJ('n08P',udg_ArenaOrganizer[0],1,1) // 'n08P': unit "Arena: Barrens Cup"
        call AddItemToStockBJ('I0IU',gg_unit_e01A_0252,1,1) // 'I0IU': item "Crusher's Belt (BP)"
        call AddItemToStockBJ('I0IV',gg_unit_e01A_0252,1,1) // 'I0IV': item "Germinas Boots (BP)"
        call AddItemToStockBJ('I0IW',gg_unit_e01A_0252,1,1) // 'I0IW': item "Necklace of the Sorcerer (BP)"
        call DisplayTimedTextToForce(GetPlayersAll(),15.,"|cff00ff00Arena:|r |cffffcc00Barrens Cup|r has been unlocked!")
        call DisplayTextToForce(GetPlayersAll(),"|cff00ffffThe Outfitters have new prizes for sale !!|r")
    endif
    if(Trig_Arena_UnlockCups_CanUnlockMountains())then
        call AddUnitToStockBJ('n09L',udg_ArenaOrganizer[0],1,1) // 'n09L': unit "Arena: Mountains Cup"
        call AddItemToStockBJ('I0IX',gg_unit_e01A_0252,1,1) // 'I0IX': item "Thunder Wand (BP)"
        call AddItemToStockBJ('I0IY',gg_unit_e01A_0252,1,1) // 'I0IY': item "Fire Wand (BP)"
        call AddItemToStockBJ('I0IZ',gg_unit_e01A_0252,1,1) // 'I0IZ': item "Ice Wand (BP)"
        call DisplayTimedTextToForce(GetPlayersAll(),15.,"|cff00ff00Arena:|r |cffffcc00Mountains Cup|r has been unlocked!")
        call DisplayTextToForce(GetPlayersAll(),"|cff00ffffThe Outfitters have new prizes for sale !!|r")
    endif
    if(Trig_Arena_UnlockCups_CanUnlockIslands())then
        call AddUnitToStockBJ('n09D',udg_ArenaOrganizer[0],1,1) // 'n09D': unit "Arena: Island Cup"
        call AddItemToStockBJ('I0J3',gg_unit_e01B_0028,1,1) // 'I0J3': item "Staff of Light (BP)"
        call AddItemToStockBJ('I0J4',gg_unit_e01B_0028,1,1) // 'I0J4': item "Barbarian's Helmet (BP)"
        call AddItemToStockBJ('I0J5',gg_unit_e01B_0028,1,1) // 'I0J5': item "Grandmasterwork Leather (BP)"
        call DisplayTimedTextToForce(GetPlayersAll(),15.,"|cff00ff00Arena:|r |cffffcc00Islands Cup|r has been unlocked!")
        call DisplayTextToForce(GetPlayersAll(),"|cff00ffffThe Outfitters have new prizes for sale !!|r")
    endif
    if(Trig_Arena_UnlockCups_ChocoboCupPending())then
        set udg_ChocoboCupStage=2
        call AddUnitToStockBJ('n08W',udg_ArenaOrganizer[0],1,1) // 'n08W': unit "Arena: Chocobo Cup"
        call AddItemToStockBJ('I0J0',gg_unit_e01B_0028,1,1) // 'I0J0': item "X-Potion (BP)"
        call AddItemToStockBJ('I0J1',gg_unit_e01B_0028,1,1) // 'I0J1': item "Turbo Ether (BP)"
        call AddItemToStockBJ('I0J2',gg_unit_e01B_0028,1,1) // 'I0J2': item "Luchil Nut (BP)"
        call DisplayTimedTextToForce(GetPlayersAll(),15.,"|cff00ff00Arena:|r |cffffcc00Chocobo Cup|r has been unlocked!")
        call DisplayTextToForce(GetPlayersAll(),"|cff00ffffThe Outfitters have new prizes for sale !!|r")
    endif
    if(Trig_Arena_UnlockCups_CanUnlockUniqueEnemy())then
        set udg_CrystalShardCount=4
        call AddUnitToStockBJ('n0A2',udg_ArenaOrganizer[0],1,1) // 'n0A2': unit "Arena: Unique Enemy Cup"
        call AddItemToStockBJ('I0J6',gg_unit_e01B_0028,1,1) // 'I0J6': item "Spirit Potion (BP)"
        call AddItemToStockBJ('I0J7',gg_unit_e01B_0028,1,1) // 'I0J7': item "Blood Ether (BP)"
        call AddItemToStockBJ('I0J8',gg_unit_e01B_0028,1,1) // 'I0J8': item "Champion's Belt (BP)"
        call DisplayTimedTextToForce(GetPlayersAll(),15.,"|cff00ff00Arena:|r |cffffcc00Unique Enemy Cup|r has been unlocked!")
        call DisplayTextToForce(GetPlayersAll(),"|cff00ffffThe Outfitters have new prizes for sale !!|r")
    endif
    if(Trig_Arena_UnlockCups_CanUnlockNingen())then
        call AddUnitToStockBJ('n09N',udg_ArenaOrganizer[0],1,1) // 'n09N': unit "Arena: Ningen Cup"
        call AddItemToStockBJ('I0JC',gg_unit_e01C_0027,1,1) // 'I0JC': item "Gladiator's Blade (BP)"
        call AddItemToStockBJ('I0JD',gg_unit_e01C_0027,1,1) // 'I0JD': item "Muramasa (BP)"
        call AddItemToStockBJ('I0JE',gg_unit_e01C_0027,1,1) // 'I0JE': item "Heady Pipe (BP)"
        call DisplayTimedTextToForce(GetPlayersAll(),15.,"|cff00ff00Arena:|r |cffffcc00Ningen Cup|r has been unlocked!")
        call DisplayTextToForce(GetPlayersAll(),"|cff00ffffThe Outfitters have new prizes for sale !!|r")
    endif
    if(Trig_Arena_UnlockCups_CanUnlockDemon())then
        call AddUnitToStockBJ('n090',udg_ArenaOrganizer[0],1,1) // 'n090': unit "Arena: Demon Cup"
        call AddItemToStockBJ('I0JF',gg_unit_e01C_0027,1,1) // 'I0JF': item "Assassin's Dagger (BP)"
        call AddItemToStockBJ('I0JG',gg_unit_e01C_0027,1,1) // 'I0JG': item "Helm of the Necromancer (BP)"
        call AddItemToStockBJ('I0JH',gg_unit_e01C_0027,1,1) // 'I0JH': item "Zodiac Helmet (BP)"
        call DisplayTimedTextToForce(GetPlayersAll(),15.,"|cff00ff00Arena:|r |cffffcc00Demon Cup|r has been unlocked!")
        call DisplayTextToForce(GetPlayersAll(),"|cff00ffffThe Outfitters have new prizes for sale !!|r")
        call SaveIntegerBJ(1,2,89,udg_GameStateHash)
    endif
    if(Trig_Arena_UnlockCups_CanUnlockDimension())then
        call AddUnitToStockBJ('n094',udg_ArenaOrganizer[0],1,1) // 'n094': unit "Arena: Dimension Cup"
        call AddItemToStockBJ('I0JI',gg_unit_e01D_0026,1,1) // 'I0JI': item "Zodiac Escutcheon (BP)"
        call AddItemToStockBJ('I0JJ',gg_unit_e01D_0026,1,1) // 'I0JJ': item "Robe of Lords (BP)"
        call AddItemToStockBJ('I0JK',gg_unit_e01D_0026,1,1) // 'I0JK': item "Circlet (BP)"
        call AddItemToStockBJ('I0K5',gg_unit_e01D_0026,1,1) // 'I0K5': item "Golden Skull (BP)"
        call AddItemToStockBJ('I0K6',gg_unit_e01D_0026,1,1) // 'I0K6': item "Crystal Skull (BP)"
        call DisplayTimedTextToForce(GetPlayersAll(),15.,"|cff00ff00Arena:|r |cffffcc00Dimension Cup|r has been unlocked!")
        call DisplayTextToForce(GetPlayersAll(),"|cff00ffffThe Outfitters have new prizes for sale !!|r")
        set udg_ArenaRank=2
        call ForForce(udg_PlayingPlayers,function Trig_Arena_UnlockCups_GrantQuest21)
    endif
endfunction

function Trig_Arena_Omega_Absorbs_Conditions takes nothing returns boolean
    return(GetTriggerUnit()==udg_ShinryuUnit)
endfunction

function Trig_Arena_Omega_Absorbs_Actions takes nothing returns nothing
    local location l_tempPoint
    call DisableTrigger(gg_trg_Arena_Shinryu_Absorbs)
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_BossGroup)
    call TriggerRegisterUnitEvent(gg_trg_Arena_Duel_Victory,udg_WarmechUnit,EVENT_UNIT_DEATH)
    call EnableTrigger(gg_trg_Arena_Duel_Victory)
    call SetUnitOwner(udg_WarmechUnit,Player($B),false) // $B = 11
    call UnitRemoveAbilityBJ('A0T9',udg_WarmechUnit) // 'A0T9': ability "Last Stand"
    call UnitAddAbilityBJ('A0ZU',udg_WarmechUnit) // 'A0ZU': ability "Double Vulnerable"
    call UnitAddAbilityBJ('A01C',udg_WarmechUnit) // 'A01C': ability "!Absorb Enemy"
    call AddSpecialEffectTargetUnitBJ("origin",udg_WarmechUnit,"Abilities\\Spells\\Other\\Doom\\DoomTarget.mdl")
    call DisableTrigger(gg_trg_Arena_Duel_AI)
    call PauseTimerBJ(true,udg_DragonBattleTimer)
    set l_tempPoint=GetUnitLoc(GetTriggerUnit())
    call IssuePointOrderLocBJ(udg_WarmechUnit,"shockwave",l_tempPoint)
    call RemoveLocation(l_tempPoint)
    set l_tempPoint=null
endfunction

function Trig_Arena_Shinryu_Absorbs_Conditions takes nothing returns boolean
    return(GetTriggerUnit()==udg_WarmechUnit)
endfunction

function Trig_Arena_Shinryu_Absorbs_Actions takes nothing returns nothing
    local location l_tempPoint
    call DisableTrigger(gg_trg_Arena_Omega_Absorbs)
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_BossGroup)
    call TriggerRegisterUnitEvent(gg_trg_Arena_Duel_Victory,udg_ShinryuUnit,EVENT_UNIT_DEATH)
    call EnableTrigger(gg_trg_Arena_Duel_Victory)
    call SetUnitOwner(udg_ShinryuUnit,Player($B),false) // $B = 11
    call UnitRemoveAbilityBJ('A0T9',udg_ShinryuUnit) // 'A0T9': ability "Last Stand"
    call UnitAddAbilityBJ('A0ZU',udg_ShinryuUnit) // 'A0ZU': ability "Double Vulnerable"
    call UnitAddAbilityBJ('A01C',udg_ShinryuUnit) // 'A01C': ability "!Absorb Enemy"
    call AddSpecialEffectTargetUnitBJ("origin",udg_ShinryuUnit,"Abilities\\Spells\\Other\\Doom\\DoomTarget.mdl")
    call DisableTrigger(gg_trg_Arena_Duel_AI)
    call PauseTimerBJ(true,udg_DragonBattleTimer)
    set l_tempPoint=GetUnitLoc(GetTriggerUnit())
    call IssuePointOrderLocBJ(udg_ShinryuUnit,"shockwave",l_tempPoint)
    call RemoveLocation(l_tempPoint)
    set l_tempPoint=null
endfunction

function InitTrig_Arena_Cups takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Arena_Part2, RegisterTriggers_Arena_Part4 (module Arena),
// which keeps the original registration order.

function Register_Arena_Unlock takes nothing returns nothing
    set gg_trg_Arena_Unlock=CreateTrigger()
    call DisableTrigger(gg_trg_Arena_Unlock)
    call TriggerAddAction(gg_trg_Arena_Unlock,function Trig_Arena_Unlock_Actions)
endfunction

function Register_Arena_Cup_Won takes nothing returns nothing
    set gg_trg_Arena_Cup_Won=CreateTrigger()
    call DisableTrigger(gg_trg_Arena_Cup_Won)
    call TriggerAddAction(gg_trg_Arena_Cup_Won,function Trig_Arena_Cup_Won_Actions)
endfunction

function Register_Arena_UnlockCups takes nothing returns nothing
    set gg_trg_Arena_UnlockCups=CreateTrigger()
    call DisableTrigger(gg_trg_Arena_UnlockCups)
    call TriggerAddCondition(gg_trg_Arena_UnlockCups,Condition(function Trig_Arena_UnlockCups_Conditions))
    call TriggerAddAction(gg_trg_Arena_UnlockCups,function Trig_Arena_UnlockCups_Actions)
endfunction

function Register_Arena_Omega_Absorbs takes nothing returns nothing
    set gg_trg_Arena_Omega_Absorbs=CreateTrigger()
    call DisableTrigger(gg_trg_Arena_Omega_Absorbs)
    call TriggerAddCondition(gg_trg_Arena_Omega_Absorbs,Condition(function Trig_Arena_Omega_Absorbs_Conditions))
    call TriggerAddAction(gg_trg_Arena_Omega_Absorbs,function Trig_Arena_Omega_Absorbs_Actions)
endfunction

function Register_Arena_Shinryu_Absorbs takes nothing returns nothing
    set gg_trg_Arena_Shinryu_Absorbs=CreateTrigger()
    call DisableTrigger(gg_trg_Arena_Shinryu_Absorbs)
    call TriggerAddCondition(gg_trg_Arena_Shinryu_Absorbs,Condition(function Trig_Arena_Shinryu_Absorbs_Conditions))
    call TriggerAddAction(gg_trg_Arena_Shinryu_Absorbs,function Trig_Arena_Shinryu_Absorbs_Actions)
endfunction

endlibrary
