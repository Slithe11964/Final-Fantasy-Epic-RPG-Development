library TArenaBattleSetup requires TForce, TGroup, TLink, TMusic, TPlayerHero, TWait
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Arena_Start_Cup=null
    trigger gg_trg_Arena_StartBattle=null
    // Variables only this module uses.
    integer udg_ArenaFinalTeam=0
endglobals

function Trig_Arena_Start_Cup_Conditions takes nothing returns boolean
    return(GetTriggerUnit()==udg_ArenaOrganizer[0])
endfunction

function Trig_Arena_Start_Cup_IsValidCupID takes nothing returns boolean
    return(udg_ArenaCupId>=1)and(udg_ArenaCupId<=$A) // $A = 10
endfunction

function Trig_Arena_Start_Cup_IsIntermission takes nothing returns boolean
    return(udg_ArenaIntermission)
endfunction

function Trig_Arena_Start_Cup_IsHeroInArena takes nothing returns boolean
    return(RectContainsUnit(gg_rct_373,Player_GetHero(GetEnumPlayer())))
endfunction

function Trig_Arena_Start_Cup_AddArenaPlayer takes nothing returns nothing
    if(Trig_Arena_Start_Cup_IsHeroInArena())then
        call ForceAddPlayerSimple(GetEnumPlayer(),udg_CupArenaPlayers)
    endif
endfunction

function Trig_Arena_Start_Cup_NoArenaPlayers takes nothing returns boolean
    return(CountPlayersInForceBJ(udg_CupArenaPlayers)<=0)
endfunction

function Trig_Arena_Start_Cup_IsLevel99 takes nothing returns boolean
    return(GetHeroLevel(udg_SpiritOfGaya[GetConvertedPlayerId(GetOwningPlayer(GetSoldUnit()))])>=99)
endfunction

function Trig_Arena_Start_Cup_IsDimensionCup takes nothing returns boolean
    return(udg_ArenaCupId==$A) // $A = 10
endfunction

function Trig_Arena_Start_Cup_IsLevel50 takes nothing returns boolean
    return(GetHeroLevel(udg_SpiritOfGaya[GetConvertedPlayerId(GetOwningPlayer(GetSoldUnit()))])>=50)
endfunction

function Trig_Arena_Start_Cup_IsDemonCup takes nothing returns boolean
    return(udg_ArenaCupId==9)
endfunction

function Trig_Arena_Start_Cup_IsChocobo takes nothing returns boolean
    return(GetUnitName(GetFilterUnit())=="Chocobo")
endfunction

function Trig_Arena_Start_Cup_HasChocoboInArena takes nothing returns boolean
    return(IsUnitGroupEmptyBJ(udg_TempGroup)==false)
endfunction

function Trig_Arena_Start_Cup_IsChocoboCup takes nothing returns boolean
    return(udg_ArenaCupId==5)
endfunction

function Trig_Arena_Start_Cup_IsHighCup takes nothing returns boolean
    return(udg_ArenaCupId<=9)
endfunction

function Trig_Arena_Start_Cup_IsMidCup takes nothing returns boolean
    return(udg_ArenaCupId<=8)
endfunction

function Trig_Arena_Start_Cup_IsLowCup takes nothing returns boolean
    return(udg_ArenaCupId<=4)
endfunction

function Trig_Arena_Start_Cup_HasSpecialFinal takes nothing returns boolean
    return(LoadIntegerBJ(2,$8B,udg_GameStateHash)==2)or(udg_ArenaCupId==$A) // $8B = 139; $A = 10
endfunction

function Trig_Arena_Start_Cup_HasCustomFinalTeam takes nothing returns boolean
    return(udg_ArenaOwnerStreak>0)
endfunction

function Trig_Arena_Start_Cup_IsTeam7Unlocked takes nothing returns boolean
    return(LoadIntegerBJ(2,7,udg_GameStateHash)==2)
endfunction

function Trig_Arena_Start_Cup_IsDimensionCupFinal takes nothing returns boolean
    return(udg_ArenaCupId==$A) // $A = 10
endfunction

function Trig_Arena_Start_Cup_NeedsShiftDown takes nothing returns boolean
    return(udg_ArenaPickedTeam<udg_ArenaBracketTeam[GetForLoopIndexA()])
endfunction

function Trig_Arena_Start_Cup_NotPlacedYet takes nothing returns boolean
    return(udg_ArenaCheckFlag==false)
endfunction

function Trig_Arena_Start_Cup_CheckSpecialFinal takes nothing returns boolean
    return(Trig_Arena_Start_Cup_HasSpecialFinal())
endfunction

function Trig_Arena_Start_Cup_IsGateOpen takes nothing returns boolean
    return(udg_ArenaGateOpened)
endfunction

function Trig_Arena_Start_Cup_Actions takes nothing returns nothing
    set udg_ArenaCupId=GetUnitPointValue(GetSoldUnit())
    call ShowUnitHide(GetSoldUnit())
    call UnitApplyTimedLifeBJ(.21,'BTLF',GetSoldUnit()) // 'BTLF': object name not found in map data
    if(Trig_Arena_Start_Cup_IsValidCupID())then
    else
        set udg_ArenaCupId=0
        return
    endif
    if(Trig_Arena_Start_Cup_IsIntermission())then
        set udg_TempForce=Force_OfPlayer(GetOwningPlayer(GetSoldUnit()))
        call DisplayTimedTextToForce(udg_TempForce,5.,"|cff00ff00Arena:|r DEBUG! Tried starting cup during Arena Intermission. Should not be possible. Please report to the dev how this happened.")
        call DestroyForce(udg_TempForce)
        set udg_ArenaCupId=0
        return
    endif
    call ForceClear(udg_CupArenaPlayers)
    call ForForce(udg_PlayingPlayers,function Trig_Arena_Start_Cup_AddArenaPlayer)
    if(Trig_Arena_Start_Cup_NoArenaPlayers())then
        set udg_TempForce=Force_OfPlayer(GetOwningPlayer(GetSoldUnit()))
        call DisplayTimedTextToForce(udg_TempForce,5.,"|cff00ff00Arena:|r There must be a player inside the arena to start a cup!")
        call DestroyForce(udg_TempForce)
        set udg_ArenaCupId=0
        return
    endif
    if(Trig_Arena_Start_Cup_IsDimensionCup())then
        if(Trig_Arena_Start_Cup_IsLevel99())then
        else
            set udg_TempForce=Force_OfPlayer(GetOwningPlayer(GetSoldUnit()))
            call DisplayTimedTextToForce(udg_TempForce,5.,"|cff00ff00Arena:|r To enter Dimension Cup you must be Level 99!")
            call DestroyForce(udg_TempForce)
            set udg_ArenaCupId=0
            return
        endif
    endif
    if(Trig_Arena_Start_Cup_IsDemonCup())then
        if(Trig_Arena_Start_Cup_IsLevel50())then
        else
            set udg_TempForce=Force_OfPlayer(GetOwningPlayer(GetSoldUnit()))
            call DisplayTimedTextToForce(udg_TempForce,5.,"|cff00ff00Arena:|r To enter Demon Cup you must be at least Level 50!")
            call DestroyForce(udg_TempForce)
            set udg_ArenaCupId=0
            return
        endif
    endif
    if(Trig_Arena_Start_Cup_IsChocoboCup())then
        set udg_TempGroup=Group_UnitsInRect(gg_rct_373,Condition(function Trig_Arena_Start_Cup_IsChocobo))
        if(Trig_Arena_Start_Cup_HasChocoboInArena())then
        else
            call DestroyGroup(udg_TempGroup)
            set udg_TempForce=Force_OfPlayer(GetOwningPlayer(GetSoldUnit()))
            call DisplayTimedTextToForce(udg_TempForce,5.,"|cff00ff00Arena:|r To enter Chocobo Cup you must have a chocobo in the battle arena!")
            call DestroyForce(udg_TempForce)
            set udg_ArenaCupId=0
            return
        endif
        call DestroyGroup(udg_TempGroup)
    endif
    call DisableTrigger(GetTriggeringTrigger())
    call DisableTrigger(gg_trg_Arena_StartBattle)
    if(Trig_Arena_Start_Cup_IsLowCup())then
        call Music_SetTrack(42)
    else
        if(Trig_Arena_Start_Cup_IsMidCup())then
            call Music_SetTrack(43)
        else
            if(Trig_Arena_Start_Cup_IsHighCup())then
                call Music_SetTrack(44)
            endif
        endif
    endif
    set udg_ArenaRound=1
    set udg_ArenaIntermission=true
    call EnableTrigger(gg_trg_Arena_PlayerLeft)
    call EnableTrigger(gg_trg_Arena_Enter_Region)
    set bj_forLoopAIndex=2
    set bj_forLoopAIndexEnd=8
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        set udg_ArenaBracketSlot[GetForLoopIndexA()]=0
        set udg_ArenaBracketTeam[GetForLoopIndexA()]=(LoadIntegerBJ(2,0,udg_GameStateHash)+1)
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    if(Trig_Arena_Start_Cup_CheckSpecialFinal())then
        if(Trig_Arena_Start_Cup_IsDimensionCupFinal())then
            if(Trig_Arena_Start_Cup_IsTeam7Unlocked())then
                set udg_ArenaFinalTeam=7
                call Music_SetTrack(45)
            else
                if(Trig_Arena_Start_Cup_HasCustomFinalTeam())then
                    set udg_ArenaFinalTeam=($A5+udg_ArenaOwnerStreak) // $A5 = 165
                else
                    // A random whole number from 1 through udg_ArenaBonusBattle at position 0.
                    set udg_ArenaFinalTeam=udg_ArenaBonusBattle[GetRandomInt(1,udg_ArenaBonusBattle[0])]
                endif
                call Music_SetTrack(44)
            endif
        else
            set udg_ArenaFinalTeam=$8B // $8B = 139
        endif
        set bj_forLoopBIndex=2
        set bj_forLoopBIndexEnd=7
        loop
            exitwhen bj_forLoopBIndex>bj_forLoopBIndexEnd
            call ConditionalTriggerExecute(gg_trg_Arena_Pick_Team)
            set bj_forLoopBIndex=bj_forLoopBIndex+1
        endloop
        set udg_ArenaPickedTeam=udg_ArenaFinalTeam
        set udg_ArenaBracketSlot[8]=udg_ArenaPickedTeam
        set udg_ArenaCheckFlag=false
        set bj_forLoopAIndex=2
        set bj_forLoopAIndexEnd=8
        loop
            exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
            if(Trig_Arena_Start_Cup_NotPlacedYet())then
                if(Trig_Arena_Start_Cup_NeedsShiftDown())then
                    set udg_ArenaCheckFlag=true
                    set udg_ArenaSwapTemp=udg_ArenaBracketTeam[(GetForLoopIndexA()+1)]
                    set udg_ArenaBracketTeam[(GetForLoopIndexA()+1)]=udg_ArenaBracketTeam[GetForLoopIndexA()]
                    set udg_ArenaBracketTeam[GetForLoopIndexA()]=udg_ArenaPickedTeam
                endif
            else
                set udg_ArenaSwapTemp2=udg_ArenaBracketTeam[(GetForLoopIndexA()+1)]
                set udg_ArenaBracketTeam[(GetForLoopIndexA()+1)]=udg_ArenaSwapTemp
                set udg_ArenaSwapTemp=udg_ArenaSwapTemp2
            endif
            set bj_forLoopAIndex=bj_forLoopAIndex+1
        endloop
    else
        set bj_forLoopBIndex=2
        set bj_forLoopBIndexEnd=8
        loop
            exitwhen bj_forLoopBIndex>bj_forLoopBIndexEnd
            call ConditionalTriggerExecute(gg_trg_Arena_Pick_Team)
            set bj_forLoopBIndex=bj_forLoopBIndex+1
        endloop
    endif
    call EnableTrigger(gg_trg_Arena_Lock_Controls)
    call StartTimerBJ(udg_ArenaLockTimer,false,.0)
    call BlzUnitDisableAbility(gg_unit_h02I_0167,'A14R',true,false) // 'A14R': ability "Arena Cup Toggle"
    call DisplayTimedTextToForce(GetPlayersAll(),10.,("|cff00ff00Arena:|r Player "+(udg_PlayerName[GetConvertedPlayerId(GetOwningPlayer(GetSoldUnit()))]+(" has started the "+(SubStringBJ(GetUnitName(GetSoldUnit()),8,StringLength(GetUnitName(GetSoldUnit())))+"!")))))
    if(Trig_Arena_Start_Cup_IsGateOpen())then
        call ModifyGateBJ(bj_GATEOPERATION_CLOSE,gg_dest_ZTsg_0025)
    endif
    call ConditionalTriggerExecute(gg_trg_Arena_Round_Start)
endfunction

function Trig_Arena_StartBattle_IsArenaShop takes nothing returns boolean
    return(GetTriggerUnit()==udg_ArenaOrganizer[1])or(GetTriggerUnit()==udg_ArenaOrganizer[2])or(GetTriggerUnit()==udg_ArenaOrganizer[3])or(GetTriggerUnit()==udg_ArenaOrganizer[4])or(GetTriggerUnit()==udg_ArenaOrganizer[5])or(GetTriggerUnit()==udg_ArenaOrganizer[6])
endfunction

function Trig_Arena_StartBattle_Conditions takes nothing returns boolean
    return(Trig_Arena_StartBattle_IsArenaShop())
endfunction

function Trig_Arena_StartBattle_IsIntermission takes nothing returns boolean
    return(udg_ArenaIntermission)
endfunction

function Trig_Arena_StartBattle_HeroInArena takes nothing returns boolean
    return(RectContainsUnit(gg_rct_373,Player_GetHero(GetEnumPlayer())))
endfunction

function Trig_Arena_StartBattle_AddArenaPlayer takes nothing returns nothing
    if(Trig_Arena_StartBattle_HeroInArena())then
        call ForceAddPlayerSimple(GetEnumPlayer(),udg_CupArenaPlayers)
    endif
endfunction

function Trig_Arena_StartBattle_NoArenaPlayers takes nothing returns boolean
    return(CountPlayersInForceBJ(udg_CupArenaPlayers)<=0)
endfunction

function Trig_Arena_StartBattle_ArenaGateOpened takes nothing returns boolean
    return(udg_ArenaGateOpened)
endfunction

function Trig_Arena_StartBattle_HasPlayersTick4 takes nothing returns boolean
    return(CountPlayersInForceBJ(udg_CupArenaPlayers)>0)
endfunction

function Trig_Arena_StartBattle_HasPlayersTick3 takes nothing returns boolean
    return(CountPlayersInForceBJ(udg_CupArenaPlayers)>0)
endfunction

function Trig_Arena_StartBattle_HasPlayersTick2 takes nothing returns boolean
    return(CountPlayersInForceBJ(udg_CupArenaPlayers)>0)
endfunction

function Trig_Arena_StartBattle_HasPlayersTick1 takes nothing returns boolean
    return(CountPlayersInForceBJ(udg_CupArenaPlayers)>0)
endfunction

function Trig_Arena_StartBattle_HasPlayersReady takes nothing returns boolean
    return(CountPlayersInForceBJ(udg_CupArenaPlayers)>0)
endfunction

function Trig_Arena_StartBattle_IsTeam120 takes nothing returns boolean
    return(udg_ArenaBracketSlot[2]=='x')
endfunction

function Trig_Arena_StartBattle_IsSoloBattle takes nothing returns boolean
    return(CountPlayersInForceBJ(udg_CupArenaPlayers)==1)
endfunction

function Trig_Arena_StartBattle_IsValidFoe takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0RQ',GetEnumUnit())<=0) // 'A0RQ': ability "Invalid Arena Summon"
endfunction

function Trig_Arena_StartBattle_TeamHasDetection takes nothing returns boolean
    return(LoadIntegerBJ(4,udg_ArenaBracketSlot[2],udg_GameStateHash)>=1)
endfunction

function Trig_Arena_StartBattle_TeamHasCover takes nothing returns boolean
    return(LoadIntegerBJ(20,udg_ArenaBracketSlot[2],udg_GameStateHash)>=1)and(GetEnumUnit()!=udg_ArenaLeaderUnit)
endfunction

function Trig_Arena_StartBattle_IsBossTeam takes nothing returns boolean
    return(udg_ArenaBracketSlot[2]==$A5) // $A5 = 165
endfunction

function Trig_Arena_StartBattle_CanUnpauseFoes takes nothing returns boolean
    return(udg_InCinematicMode==false)
endfunction

function Trig_Arena_StartBattle_SetupFoe takes nothing returns nothing
    call SetUnitInvulnerable(GetEnumUnit(),false)
    call UnitRemoveAbilityBJ('Abun',GetEnumUnit()) // 'Abun': object name not found in map data
    call SetUnitAcquireRangeBJ(GetEnumUnit(),1792.)
    if(Trig_Arena_StartBattle_IsValidFoe())then
        call GroupAddUnitSimple(GetEnumUnit(),udg_CupArenaUnits)
    else
        call GroupAddUnitSimple(GetEnumUnit(),udg_ArenaSummonGroup)
    endif
    if(Trig_Arena_StartBattle_TeamHasDetection())then
        call GroupAddUnitSimple(GetEnumUnit(),udg_BossGroup)
        call UnitAddAbilityBJ('Agyv',GetEnumUnit()) // 'Agyv': editor label "True Sight"
    endif
    if(Trig_Arena_StartBattle_TeamHasCover())then
        call UnitAddAbilityBJ('A0X2',GetEnumUnit()) // 'A0X2': ability "Perma Cover"
        call Link_SaveCaster(udg_ArenaLeaderUnit,GetEnumUnit(),.0)
    endif
    if(Trig_Arena_StartBattle_IsBossTeam())then
        set udg_ScriptedBossUnit=GetEnumUnit()
        call UnitAddAbilityBJ('A0ZR',GetEnumUnit()) // 'A0ZR': ability "Immortal"
        call EnableTrigger(gg_trg_Quest_TrialByFire_Countdown)
    endif
    if(Trig_Arena_StartBattle_CanUnpauseFoes())then
        call PauseUnitBJ(false,GetEnumUnit())
    endif
endfunction

function Trig_Arena_StartBattle_CanAttackGround takes nothing returns boolean
    return(IsUnitType(GetEnumUnit(),UNIT_TYPE_ATTACKS_GROUND))!=null
endfunction

function Trig_Arena_StartBattle_OrderFoeAttack takes nothing returns nothing
    if(Trig_Arena_StartBattle_CanAttackGround())then
        set udg_TempPoint=GetUnitLoc(Player_GetHero(ForcePickRandomPlayer(udg_CupArenaPlayers)))
        call IssuePointOrderLocBJ(GetEnumUnit(),"attack",udg_TempPoint)
        call RemoveLocation(udg_TempPoint)
    endif
endfunction

function Trig_Arena_StartBattle_Actions takes nothing returns nothing
    local location l_tempPoint2
    call ShowUnitHide(GetSoldUnit())
    call UnitApplyTimedLifeBJ(.21,'BTLF',GetSoldUnit()) // 'BTLF': object name not found in map data
    if(Trig_Arena_StartBattle_IsIntermission())then
        set udg_TempForce=Force_OfPlayer(GetOwningPlayer(GetSoldUnit()))
        call DisplayTimedTextToForce(udg_TempForce,5.,"|cff00ff00Arena:|r DEBUG! Tried starting battle during Arena Intermission. Should not be possible. Please report to the dev how this happened.")
        call DestroyForce(udg_TempForce)
        set l_tempPoint2=null
        return
    endif
    call ForceClear(udg_CupArenaPlayers)
    call ForForce(udg_PlayingPlayers,function Trig_Arena_StartBattle_AddArenaPlayer)
    if(Trig_Arena_StartBattle_NoArenaPlayers())then
        set udg_TempForce=Force_OfPlayer(GetOwningPlayer(GetSoldUnit()))
        call DisplayTimedTextToForce(udg_TempForce,5.,"|cff00ff00Arena:|r There must be a player inside the arena to start a battle!")
        call DestroyForce(udg_TempForce)
        set l_tempPoint2=null
        return
    endif
    call DisableTrigger(GetTriggeringTrigger())
    call DisableTrigger(gg_trg_Arena_Start_Cup)
    if(Trig_Arena_StartBattle_ArenaGateOpened())then
        call ModifyGateBJ(bj_GATEOPERATION_CLOSE,gg_dest_ZTsg_0025)
    endif
    call EnableTrigger(gg_trg_Arena_Lock_Controls)
    call StartTimerBJ(udg_ArenaLockTimer,false,.0)
    set udg_ArenaIntermission=true
    call EnableTrigger(gg_trg_Arena_PlayerLeft)
    call EnableTrigger(gg_trg_Arena_Enter_Region)
    call Music_SetTrack(41)
    set udg_ArenaBracketSlot[2]=GetUnitPointValue(GetSoldUnit())
    set udg_ArenaSpawnLoc=GetRectCenter(gg_rct_045)
    set udg_ArenaSpawnTeam=udg_ArenaBracketSlot[2]
    set udg_ArenaTextTag[2]=CreateTextTagLocBJ(LoadStringBJ(1,udg_ArenaSpawnTeam,udg_GameStateHash),udg_ArenaSpawnLoc,0,$A,'d','d','d',0) // $A = 10
    set udg_ArenaSpawnFacing=90.
    call StartTimerBJ(udg_ArenaSpawnTimer,false,.0)
    call Wait_Polled(1.)
    if(Trig_Arena_StartBattle_HasPlayersTick1())then
        call Wait_Polled(1.)
        if(Trig_Arena_StartBattle_HasPlayersTick2())then
            call Wait_Polled(1.)
            if(Trig_Arena_StartBattle_HasPlayersTick3())then
                call Wait_Polled(1.)
                if(Trig_Arena_StartBattle_HasPlayersTick4())then
                    call Wait_Polled(1.)
                endif
            endif
        endif
    endif
    call DestroyTextTagBJ(udg_ArenaTextTag[2])
    set udg_TempPoint=GetRectCenter(gg_rct_047)
    set l_tempPoint2=GetRectCenter(gg_rct_048)
    set udg_ArenaLightning[1]=AddLightningLoc("FORK",udg_TempPoint,l_tempPoint2)
    call RemoveLocation(l_tempPoint2)
    set l_tempPoint2=GetRectCenter(gg_rct_049)
    set udg_ArenaLightning[2]=AddLightningLoc("FORK",udg_TempPoint,l_tempPoint2)
    call RemoveLocation(udg_TempPoint)
    set udg_TempPoint=GetRectCenter(gg_rct_050)
    set udg_ArenaLightning[3]=AddLightningLoc("FORK",udg_TempPoint,l_tempPoint2)
    call RemoveLocation(l_tempPoint2)
    set l_tempPoint2=GetRectCenter(gg_rct_048)
    set udg_ArenaLightning[4]=AddLightningLoc("FORK",udg_TempPoint,l_tempPoint2)
    call RemoveLocation(udg_TempPoint)
    call RemoveLocation(l_tempPoint2)
    set udg_TempPoint=GetRectCenter(gg_rct_046)
    call CreateTextTagLocBJ("Ready?",udg_TempPoint,0,$A,'d',90.,10.,0) // $A = 10
    call RemoveLocation(udg_TempPoint)
    call SetTextTagPermanentBJ(GetLastCreatedTextTag(),false)
    call SetTextTagLifespanBJ(GetLastCreatedTextTag(),1.)
    call Wait_Polled(1.)
    if(Trig_Arena_StartBattle_HasPlayersReady())then
        set udg_TempPoint=GetRectCenter(gg_rct_046)
        call CreateTextTagLocBJ("Ready?",udg_TempPoint,0,$A,'d',45.,5.,0) // $A = 10
        call RemoveLocation(udg_TempPoint)
        call SetTextTagPermanentBJ(GetLastCreatedTextTag(),false)
        call SetTextTagLifespanBJ(GetLastCreatedTextTag(),1.)
        call Wait_Polled(1.)
    endif
    set udg_TempPoint=GetRectCenter(gg_rct_046)
    call CreateTextTagLocBJ("FIGHT!",udg_TempPoint,0,$A,'d',.0,.0,0) // $A = 10
    call SetTextTagPermanentBJ(GetLastCreatedTextTag(),false)
    call SetTextTagLifespanBJ(GetLastCreatedTextTag(),1.)
    call RemoveLocation(udg_TempPoint)
    if(Trig_Arena_StartBattle_IsTeam120())then
        set udg_PenanceArmsActive=true
    endif
    set udg_ArenaEliteKilled=false
    if(Trig_Arena_StartBattle_IsSoloBattle())then
        set udg_ArenaSoloPlayer=ForcePickRandomPlayer(udg_CupArenaPlayers)
    else
        set udg_ArenaSoloPlayer=Player($B) // $B = 11
    endif
    call ForGroupBJ(udg_ArenaSpawnGroup,function Trig_Arena_StartBattle_SetupFoe)
    call GroupClear(udg_ArenaSpawnGroup)
    set udg_ArenaStallTicks=0
    set udg_ArenaIntermission=false
    call ForGroupBJ(udg_CupArenaUnits,function Trig_Arena_StartBattle_OrderFoeAttack)
    call StartTimerBJ(udg_ArenaRoundTimer,false,300.)
    call EnableTrigger(gg_trg_Arena_FoeDeath)
    call EnableTrigger(gg_trg_Arena_OutOfBounds)
    call ConditionalTriggerExecute(gg_trg_Arena_BattleLost)
    set l_tempPoint2=null
endfunction

function InitTrig_Arena_BattleSetup takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Arena_Part2 (module Arena),
// which keeps the original registration order.

function Register_Arena_Start_Cup takes nothing returns nothing
    set gg_trg_Arena_Start_Cup=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Arena_Start_Cup,EVENT_PLAYER_UNIT_SELL)
    call TriggerAddCondition(gg_trg_Arena_Start_Cup,Condition(function Trig_Arena_Start_Cup_Conditions))
    call TriggerAddAction(gg_trg_Arena_Start_Cup,function Trig_Arena_Start_Cup_Actions)
endfunction

function Register_Arena_StartBattle takes nothing returns nothing
    set gg_trg_Arena_StartBattle=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Arena_StartBattle,EVENT_PLAYER_UNIT_SELL)
    call TriggerAddCondition(gg_trg_Arena_StartBattle,Condition(function Trig_Arena_StartBattle_Conditions))
    call TriggerAddAction(gg_trg_Arena_StartBattle,function Trig_Arena_StartBattle_Actions)
endfunction

endlibrary
