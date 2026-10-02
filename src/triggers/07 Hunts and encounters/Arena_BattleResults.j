library TArenaBattleResults requires TForce, TGroup, TJob, TMusic, TPlayerPart01
function Trig_Arena_FoeDeath_Conditions takes nothing returns boolean
    return(IsUnitInGroup(GetTriggerUnit(),udg_CupArenaUnits))
endfunction

function Trig_Arena_FoeDeath_RollDrop takes nothing returns boolean
    // Calculation 1:
    // A random whole number from 1 through 100.
    // Calculation 2:
    // (10) plus ((2) times (loop counter A)).
    // Calculation 3:
    // (GetUnitUserData(the triggering unit)) minus (10).
    return(GetRandomInt(1,'d')<=LoadIntegerBJ(($A+(2*GetForLoopIndexA())),(GetUnitUserData(GetTriggerUnit())-$A),udg_GameStateHash)) // $A = 10
endfunction

function Trig_Arena_FoeDeath_HasLootTable takes nothing returns boolean
    // (GetUnitUserData(the triggering unit)) minus (10).
    return(IsUnitDeadBJ(GetTriggerUnit()))and(GetUnitUserData(GetTriggerUnit())>=$A)and(LoadIntegerBJ($A,(GetUnitUserData(GetTriggerUnit())-$A),udg_GameStateHash)>=1) // $A = 10
endfunction

function Trig_Arena_FoeDeath_RemoveCover takes nothing returns nothing
    call UnitRemoveAbilityBJ('A0X2',GetEnumUnit()) // 'A0X2': ability "Perma Cover"
    call UnitRemoveBuffBJ('B064',GetEnumUnit()) // 'B064': buff "Perma Cover"
endfunction

function Trig_Arena_FoeDeath_RemoveCoverBoss takes nothing returns nothing
    call UnitRemoveAbilityBJ('A0X2',GetEnumUnit()) // 'A0X2': ability "Perma Cover"
    call UnitRemoveBuffBJ('B064',GetEnumUnit()) // 'B064': buff "Perma Cover"
endfunction

function Trig_Arena_FoeDeath_HasBossFoes takes nothing returns boolean
    return(IsUnitGroupEmptyBJ(udg_ArenaSummonGroup)==false)
endfunction

function Trig_Arena_FoeDeath_IsCoverSource takes nothing returns boolean
    return(GetTriggerUnit()==udg_ArenaLeaderUnit)
endfunction

function Trig_Arena_FoeDeath_IsHighLevelHero takes nothing returns boolean
    return((IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(udg_ArenaSoloPlayer!=Player($B))and(GetHeroLevel(GetTriggerUnit())>=90))!=null // $B = 11
endfunction

function Trig_Arena_FoeDeath_AllFoesDead takes nothing returns boolean
    return(IsUnitGroupEmptyBJ(udg_CupArenaUnits))
endfunction

function Trig_Arena_FoeDeath_CanGrantMastery takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A02F',Player_GetHero(udg_ArenaSoloPlayer))==3)and(IsPlayerInForce(udg_ArenaSoloPlayer,udg_QuestForce[udg_TempInteger])==false) // 'A02F': ability "Mastery"
endfunction

function Trig_Arena_FoeDeath_MasteryPending takes nothing returns boolean
    return(udg_ArenaEliteKilled)
endfunction

function Trig_Arena_FoeDeath_IsTeam183Or184 takes nothing returns boolean
    return(udg_ArenaBracketSlot[2]==$B7)or(udg_ArenaBracketSlot[2]==$B8) // $B7 = 183; $B8 = 184
endfunction

function Trig_Arena_FoeDeath_MissingQuest54 takes nothing returns boolean
    return(IsPlayerInForce(GetEnumPlayer(),udg_TitleForce[54])==false)
endfunction

function Trig_Arena_FoeDeath_GrantQuest54 takes nothing returns nothing
    if(Trig_Arena_FoeDeath_MissingQuest54())then
        set udg_TempPlayer=GetEnumPlayer()
        set udg_TempInteger=54
        call ConditionalTriggerExecute(gg_trg_Title_Grant)
    endif
endfunction

function Trig_Arena_FoeDeath_ShouldGrantQuest54 takes nothing returns boolean
    return(Trig_Arena_FoeDeath_IsTeam183Or184())
endfunction

function Trig_Arena_FoeDeath_MissingQuest49 takes nothing returns boolean
    return(IsPlayerInForce(GetEnumPlayer(),udg_TitleForce[49])==false)and(IsPlayerInForce(GetEnumPlayer(),udg_TitleForce[33]))
endfunction

function Trig_Arena_FoeDeath_GrantQuest49 takes nothing returns nothing
    if(Trig_Arena_FoeDeath_MissingQuest49())then
        set udg_TempPlayer=GetEnumPlayer()
        set udg_TempInteger=49
        call ConditionalTriggerExecute(gg_trg_Title_Grant)
    endif
endfunction

function Trig_Arena_FoeDeath_ShouldGrantQuest49 takes nothing returns boolean
    return(udg_ArenaBracketSlot[2]=='x')and(udg_PenanceArmsActive)
endfunction

function Trig_Arena_FoeDeath_MissingQuest34 takes nothing returns boolean
    return(IsPlayerInForce(GetEnumPlayer(),udg_TitleForce[34])==false)
endfunction

function Trig_Arena_FoeDeath_GrantQuest34 takes nothing returns nothing
    if(Trig_Arena_FoeDeath_MissingQuest34())then
        set udg_TempPlayer=GetEnumPlayer()
        set udg_TempInteger=34
        call ConditionalTriggerExecute(gg_trg_Title_Grant)
    endif
endfunction

function Trig_Arena_FoeDeath_ShouldGrantQuest34 takes nothing returns boolean
    return(udg_ArenaBracketSlot[2]==$92) // $92 = 146
endfunction

function Trig_Arena_FoeDeath_MissingQuest28 takes nothing returns boolean
    return(IsPlayerInForce(GetEnumPlayer(),udg_TitleForce[28])==false)and(IsPlayerInForce(GetEnumPlayer(),udg_TitleForce[27]))
endfunction

function Trig_Arena_FoeDeath_GrantQuest28 takes nothing returns nothing
    if(Trig_Arena_FoeDeath_MissingQuest28())then
        set udg_TempPlayer=GetEnumPlayer()
        set udg_TempInteger=28
        call ConditionalTriggerExecute(gg_trg_Title_Grant)
    endif
endfunction

function Trig_Arena_FoeDeath_ShouldGrantQuest28 takes nothing returns boolean
    return(udg_ArenaBracketSlot[2]==$AB) // $AB = 171
endfunction

function Trig_Arena_FoeDeath_MissingQuest24 takes nothing returns boolean
    return(IsPlayerInForce(GetEnumPlayer(),udg_TitleForce[24])==false)and(IsPlayerInForce(GetEnumPlayer(),udg_TitleForce[23]))
endfunction

function Trig_Arena_FoeDeath_GrantQuest24 takes nothing returns nothing
    if(Trig_Arena_FoeDeath_MissingQuest24())then
        set udg_TempPlayer=GetEnumPlayer()
        set udg_TempInteger=24
        call ConditionalTriggerExecute(gg_trg_Title_Grant)
    endif
endfunction

function Trig_Arena_FoeDeath_ShouldGrantQuest24 takes nothing returns boolean
    return(udg_ArenaBracketSlot[2]==$9A) // $9A = 154
endfunction

function Trig_Arena_FoeDeath_RemoveBossFoe takes nothing returns nothing
    call UnitRemoveAbilityBJ('A0ZR',GetEnumUnit()) // 'A0ZR': ability "Immortal"
    call KillUnit(GetEnumUnit())
    call RemoveUnit(GetEnumUnit())
endfunction

function Trig_Arena_FoeDeath_IsBonusBPActive takes nothing returns boolean
    return(udg_EternityMode)
endfunction

function Trig_Arena_FoeDeath_HasDoubleBP takes nothing returns boolean
    return(IsPlayerInForce(GetEnumPlayer(),udg_TitleForce[22]))
endfunction

function Trig_Arena_FoeDeath_IsBPOverCap takes nothing returns boolean
    return(udg_BattlePoints[GetConvertedPlayerId(GetEnumPlayer())]>$F423F) // $F423F = 999999
endfunction

function Trig_Arena_FoeDeath_AwardBattlePoints takes nothing returns nothing
    set udg_TempForce=Force_OfPlayer(GetEnumPlayer())
    if(Trig_Arena_FoeDeath_HasDoubleBP())then
        // Result 1: (udg_BattlePoints at position 0) times (2).
        // Result 2: (udg_BattlePoints at position GetConvertedPlayerId(the player being visited)) plus (result 1).
        set udg_BattlePoints[GetConvertedPlayerId(GetEnumPlayer())]=(udg_BattlePoints[GetConvertedPlayerId(GetEnumPlayer())]+(udg_BattlePoints[0]*2))
        // (udg_BattlePoints at position 0) times (2).
        call DisplayTimedTextToForce(udg_TempForce,10.,(("|cffffcc00You get "+I2S((udg_BattlePoints[0]*2)))+" Battle Points.|r"))
    else
        // (udg_BattlePoints at position GetConvertedPlayerId(the player being visited)) plus (udg_BattlePoints at
        // position 0).
        set udg_BattlePoints[GetConvertedPlayerId(GetEnumPlayer())]=(udg_BattlePoints[GetConvertedPlayerId(GetEnumPlayer())]+udg_BattlePoints[0])
        call DisplayTimedTextToForce(udg_TempForce,10.,(("|cffffcc00You get "+I2S(udg_BattlePoints[0]))+" Battle Points.|r"))
    endif
    if(Trig_Arena_FoeDeath_IsBPOverCap())then
        set udg_BattlePoints[GetConvertedPlayerId(GetEnumPlayer())]=$F423F // $F423F = 999999
    endif
    call DestroyTextTagBJ(udg_ArenaBpTag[GetConvertedPlayerId(GetEnumPlayer())])
    set udg_ArenaBpTag[GetConvertedPlayerId(GetEnumPlayer())]=CreateTextTagUnitBJ(("Current BP: |cffffcc00"+(I2S(udg_BattlePoints[GetConvertedPlayerId(GetEnumPlayer())])+"|r")),gg_unit_h02I_0167,0,$A,'d','d','d',0) // $A = 10
    call ShowTextTagForceBJ(false,GetLastCreatedTextTag(),GetPlayersAll())
    call ShowTextTagForceBJ(true,GetLastCreatedTextTag(),udg_TempForce)
    call DestroyForce(udg_TempForce)
endfunction

function Trig_Arena_FoeDeath_GateWasOpened takes nothing returns boolean
    return(udg_ArenaGateOpened)
endfunction

function Trig_Arena_FoeDeath_Actions takes nothing returns nothing
    if(Trig_Arena_FoeDeath_HasLootTable())then
        set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
        set bj_forLoopAIndex=1
        // (GetUnitUserData(the triggering unit)) minus (10).
        set bj_forLoopAIndexEnd=LoadIntegerBJ($A,(GetUnitUserData(GetTriggerUnit())-$A),udg_GameStateHash) // $A = 10
        loop
            exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
            if(Trig_Arena_FoeDeath_RollDrop())then
                // Calculation 1:
                // (9) plus ((2) times (loop counter A)).
                // Calculation 2:
                // (GetUnitUserData(the triggering unit)) minus (10).
                call CreateItemLoc(udg_ItemIdTable[LoadIntegerBJ((9+(2*GetForLoopIndexA())),(GetUnitUserData(GetTriggerUnit())-$A),udg_GameStateHash)],udg_TempPoint) // $A = 10
            endif
            set bj_forLoopAIndex=bj_forLoopAIndex+1
        endloop
        call RemoveLocation(udg_TempPoint)
    endif
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_CupArenaUnits)
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_BossGroup)
    if(Trig_Arena_FoeDeath_IsCoverSource())then
        call ForGroupBJ(udg_CupArenaUnits,function Trig_Arena_FoeDeath_RemoveCover)
        if(Trig_Arena_FoeDeath_HasBossFoes())then
            call ForGroupBJ(udg_ArenaSummonGroup,function Trig_Arena_FoeDeath_RemoveCoverBoss)
        endif
    endif
    if(Trig_Arena_FoeDeath_IsHighLevelHero())then
        set udg_ArenaEliteKilled=true
    endif
    if(Trig_Arena_FoeDeath_AllFoesDead())then
    else
        return
    endif
    call DisableTrigger(GetTriggeringTrigger())
    call DisplayTimedTextToForce(GetPlayersAll(),10.,("|cff00ff00Arena:|r Team |cffff0000"+(LoadStringBJ(1,udg_ArenaBracketSlot[2],udg_GameStateHash)+"|r has been defeated!")))
    call Music_ClearTrack(41)
    if(Trig_Arena_FoeDeath_MasteryPending())then
        set udg_TempInteger=Job_GetIndex(Player_GetHero(udg_ArenaSoloPlayer))
        if(Trig_Arena_FoeDeath_CanGrantMastery())then
            call ForceAddPlayerSimple(udg_ArenaSoloPlayer,udg_QuestForce[udg_TempInteger])
            call AddSpecialEffectTargetUnitBJ("origin",Player_GetHero(udg_ArenaSoloPlayer),"Abilities\\Spells\\Other\\Levelup\\LevelupCaster.mdl")
            call DestroyEffectBJ(GetLastCreatedEffectBJ())
        endif
    endif
    if(Trig_Arena_FoeDeath_ShouldGrantQuest24())then
        call ForForce(udg_PlayingPlayers,function Trig_Arena_FoeDeath_GrantQuest24)
    else
        if(Trig_Arena_FoeDeath_ShouldGrantQuest28())then
            call ForForce(udg_PlayingPlayers,function Trig_Arena_FoeDeath_GrantQuest28)
        else
            if(Trig_Arena_FoeDeath_ShouldGrantQuest34())then
                call ForceAddPlayerSimple(Player($A),udg_TitleForce[34]) // $A = 10
                call ForForce(udg_PlayingPlayers,function Trig_Arena_FoeDeath_GrantQuest34)
            else
                if(Trig_Arena_FoeDeath_ShouldGrantQuest49())then
                    call ForceAddPlayerSimple(Player($A),udg_TitleForce[49]) // $A = 10
                    call ForForce(udg_PlayingPlayers,function Trig_Arena_FoeDeath_GrantQuest49)
                else
                    if(Trig_Arena_FoeDeath_ShouldGrantQuest54())then
                        call ForForce(udg_PlayingPlayers,function Trig_Arena_FoeDeath_GrantQuest54)
                    endif
                endif
            endif
        endif
    endif
    call DisableTrigger(gg_trg_Arena_Enter_Region)
    call DisableTrigger(gg_trg_Arena_PlayerLeft)
    call DestroyLightningBJ(udg_ArenaLightning[1])
    call DestroyLightningBJ(udg_ArenaLightning[2])
    call DestroyLightningBJ(udg_ArenaLightning[3])
    call DestroyLightningBJ(udg_ArenaLightning[4])
    call DisableTrigger(gg_trg_Arena_OutOfBounds)
    call GroupClear(udg_CupArenaUnits)
    call ForGroupBJ(udg_ArenaSummonGroup,function Trig_Arena_FoeDeath_RemoveBossFoe)
    call GroupClear(udg_ArenaSummonGroup)
    // (LoadIntegerBJ(5, udg_ArenaBracketSlot at position 2, udg_GameStateHash)) plus (2).
    set udg_BattlePoints[0]=(LoadIntegerBJ(5,udg_ArenaBracketSlot[2],udg_GameStateHash)+2)
    if(Trig_Arena_FoeDeath_IsBonusBPActive())then
        // Increase udg_BattlePoints at position 0 by 60.
        set udg_BattlePoints[0]=(udg_BattlePoints[0]+60)
    endif
    // Multiply base battle points by 10 x (elapsed seconds + 30) / (2 x elapsed seconds + 30), then drop decimals.
    // At 0 seconds the multiplier is 10; at 30 seconds it is about 6.67. Longer fights move it toward 5.
    set udg_BattlePoints[0]=R2I(((I2R(udg_BattlePoints[0])*10.)*((TimerGetElapsed(udg_ArenaRoundTimer)+30.)/((TimerGetElapsed(udg_ArenaRoundTimer)*2.)+30.))))
    call ForForce(udg_CupArenaPlayers,function Trig_Arena_FoeDeath_AwardBattlePoints)
    call ForceClear(udg_CupArenaPlayers)
    call GroupClear(udg_ArenaSpawnGroup)
    set bj_forLoopAIndex=0
    set bj_forLoopAIndexEnd=udg_ArenaOrganizerLast
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        call UnitAddAbilityBJ('Ane2',udg_ArenaOrganizer[GetForLoopIndexA()]) // 'Ane2': object name not found in map data
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    call EnableTrigger(gg_trg_Arena_Start_Cup)
    call EnableTrigger(gg_trg_Arena_StartBattle)
    call UnitAddAbilityBJ('A0GG',gg_unit_h02T_0064) // 'A0GG': ability "Teleport"
    if(Trig_Arena_FoeDeath_GateWasOpened())then
        call ModifyGateBJ(bj_GATEOPERATION_OPEN,gg_dest_ZTsg_0025)
    endif
endfunction

function Trig_Arena_BattleLost_Conditions takes nothing returns boolean
    return(CountPlayersInForceBJ(udg_CupArenaPlayers)<=0)and(udg_ArenaIntermission==false)
endfunction

function Trig_Arena_BattleLost_IsCampaignActive takes nothing returns boolean
    return(udg_ArenaCupId>0)
endfunction

function Trig_Arena_BattleLost_ChocoboCupUnclaimed takes nothing returns boolean
    return(udg_ChocoboCupStage==1)
endfunction

function Trig_Arena_BattleLost_WasBossTeam takes nothing returns boolean
    return(udg_ArenaBracketSlot[2]==$A5) // $A5 = 165
endfunction

function Trig_Arena_BattleLost_RemoveFoe takes nothing returns nothing
    call RemoveUnit(GetEnumUnit())
endfunction

function Trig_Arena_BattleLost_ClearBossFoe takes nothing returns nothing
    call UnitRemoveAbilityBJ('A0ZR',GetEnumUnit()) // 'A0ZR': ability "Immortal"
    call KillUnit(GetEnumUnit())
    call RemoveUnit(GetEnumUnit())
endfunction

function Trig_Arena_BattleLost_GateIsOpened takes nothing returns boolean
    return(udg_ArenaGateOpened)
endfunction

function Trig_Arena_BattleLost_Actions takes nothing returns nothing
    call DisplayTimedTextToForce(GetPlayersAll(),10.,("|cff00ff00Arena:|r You lost to Team |cffff0000"+(LoadStringBJ(1,udg_ArenaBracketSlot[2],udg_GameStateHash)+"|r!")))
    if(Trig_Arena_BattleLost_IsCampaignActive())then
        call BlzUnitDisableAbility(gg_unit_h02I_0167,'A14R',false,false) // 'A14R': ability "Arena Cup Toggle"
        set udg_ArenaCupId=0
        call Music_ClearTrack(42)
        call Music_ClearTrack(43)
        call Music_ClearTrack(44)
        call Music_ClearTrack(45)
    else
        call Music_ClearTrack(41)
    endif
    call DestroyLightningBJ(udg_ArenaLightning[1])
    call DestroyLightningBJ(udg_ArenaLightning[2])
    call DestroyLightningBJ(udg_ArenaLightning[3])
    call DestroyLightningBJ(udg_ArenaLightning[4])
    call DisableTrigger(gg_trg_Arena_OutOfBounds)
    call DisableTrigger(gg_trg_Arena_Round_End)
    call DisableTrigger(gg_trg_Arena_FoeDeath)
    call DisableTrigger(gg_trg_Arena_PlayerLeft)
    call DisableTrigger(gg_trg_Arena_Enter_Region)
    if(Trig_Arena_BattleLost_ChocoboCupUnclaimed())then
        set udg_ChocoboCupStage=0
    endif
    if(Trig_Arena_BattleLost_WasBossTeam())then
        call ConditionalTriggerExecute(gg_trg_Quest_TrialByFire_Fail)
    endif
    call ForGroupBJ(udg_CupArenaUnits,function Trig_Arena_BattleLost_RemoveFoe)
    call GroupClear(udg_CupArenaUnits)
    call ForGroupBJ(udg_ArenaSummonGroup,function Trig_Arena_BattleLost_ClearBossFoe)
    call GroupClear(udg_ArenaSummonGroup)
    set bj_forLoopAIndex=0
    set bj_forLoopAIndexEnd=udg_ArenaOrganizerLast
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        call UnitAddAbilityBJ('Ane2',udg_ArenaOrganizer[GetForLoopIndexA()]) // 'Ane2': object name not found in map data
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    call EnableTrigger(gg_trg_Arena_Start_Cup)
    call EnableTrigger(gg_trg_Arena_StartBattle)
    call UnitAddAbilityBJ('A0GG',gg_unit_h02T_0064) // 'A0GG': ability "Teleport"
    if(Trig_Arena_BattleLost_GateIsOpened())then
        call ModifyGateBJ(bj_GATEOPERATION_OPEN,gg_dest_ZTsg_0025)
    endif
endfunction

function Trig_Arena_Abandoned_Reset_Conditions takes nothing returns boolean
    return(CountPlayersInForceBJ(udg_DuelArenaPlayers)<=0)
endfunction

function Trig_Arena_Abandoned_Reset_IsWaygateOpen takes nothing returns boolean
    return(udg_HolyAnkhUsed)
endfunction

function Trig_Arena_Abandoned_Reset_FilterAlive takes nothing returns boolean
    return(IsUnitAliveBJ(GetFilterUnit()))
endfunction

function Trig_Arena_Abandoned_Reset_FilterIsPlayerUnit takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetFilterUnit()),udg_ActivePlayers))
endfunction

function Trig_Arena_Abandoned_Reset_FilterAlivePlayerUnit takes nothing returns boolean
    return GetBooleanAnd(Trig_Arena_Abandoned_Reset_FilterAlive(),Trig_Arena_Abandoned_Reset_FilterIsPlayerUnit())
endfunction

function Trig_Arena_Abandoned_Reset_FilterNotInvulnerable takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('Avul',GetFilterUnit())<=0) // 'Avul': standard ability reference "Invulnerable"
endfunction

function Trig_Arena_Abandoned_Reset_FilterTarget takes nothing returns boolean
    return GetBooleanAnd(Trig_Arena_Abandoned_Reset_FilterAlivePlayerUnit(),Trig_Arena_Abandoned_Reset_FilterNotInvulnerable())
endfunction

function Trig_Arena_Abandoned_Reset_KillArenaHero takes nothing returns nothing
    call UnitRemoveBuffBJ('B052',GetEnumUnit()) // 'B052': buff "Infinity"
    call UnitRemoveBuffBJ('B063',GetEnumUnit()) // 'B063': buff "Cover"
    set udg_DmgFlagPure=true
    set udg_IgnoresReduction=true
    call UnitDamageTargetBJ(gg_unit_n03T_0008,GetEnumUnit(),6666666.,ATTACK_TYPE_CHAOS,DAMAGE_TYPE_UNIVERSAL)
endfunction

function Trig_Arena_Abandoned_Reset_Actions takes nothing returns nothing
    if(Trig_Arena_Abandoned_Reset_IsWaygateOpen())then
        call WaygateActivateBJ(true,gg_unit_n0AP_0240)
        set udg_SpecialEffect[78]=AddSpecialEffectTargetUnitBJ("origin",gg_unit_n0AP_0240,"Abilities\\Spells\\Human\\Brilliance\\Brilliance.mdl")
    endif
    call SetItemVisibleBJ(true,udg_SummonItem)
    set udg_RingHintsReady=true
    call UnitAddAbilityBJ('Ane2',gg_unit_n03T_0008) // 'Ane2': object name not found in map data
    set udg_TempGroup=Group_UnitsInRect(gg_rct_496,Condition(function Trig_Arena_Abandoned_Reset_FilterTarget))
    call ForGroupBJ(udg_TempGroup,function Trig_Arena_Abandoned_Reset_KillArenaHero)
    call DestroyGroup(udg_TempGroup)
    call ConditionalTriggerExecute(udg_BossCleanupTrigger)
    call PlayThematicMusicBJ("war3mapImported\\FF7GameOver.mp3")
endfunction

function InitTrig_Arena_BattleResults takes nothing returns nothing
endfunction

endlibrary
