library TMonstrum requires TLoc, TPlayerPart01, TWait
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Monstrum_Ambush_Arm=null
    trigger gg_trg_Monstrum_Tentacle_Ambush=null
    trigger gg_trg_Monstrum_Summon=null
    trigger gg_trg_Monstrum_Ambush_Rearm=null
    trigger gg_trg_Monstrum_Phase_Check=null
    trigger gg_trg_Monstrum_DepthCharge=null
    trigger gg_trg_Monstrum_Tentacle_Cleanup=null
    // Variables only this module uses.
    unit udg_NebraMonstrum=null
    unit array udg_MonstrumTentacle
    integer udg_MonstrumPhase=0
    real udg_MonstrumPhaseLife=0
endglobals

function Trig_Monstrum_Ambush_Arm_Conditions takes nothing returns boolean
    return(udg_BossDefeated[2])
endfunction

function Trig_Monstrum_Ambush_Arm_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call Wait_Polled(180.)
    call EnableTrigger(gg_trg_Monstrum_Tentacle_Ambush)
    call EnableTrigger(gg_trg_Monstrum_Ambush_Rearm)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Monstrum_Tentacle_Ambush_IsNightTime takes nothing returns boolean
    return(GetTimeOfDay()>18.)or(GetTimeOfDay()<6.)
endfunction

function Trig_Monstrum_Tentacle_Ambush_Conditions takes nothing returns boolean
    // A random whole number from 1 through 5.
    return((GetUnitUserData(GetTriggerUnit())==6)and(IsPlayerInForce(GetOwningPlayer(GetAttacker()),udg_PlayingPlayers))and(IsUnitType(GetAttacker(),UNIT_TYPE_HERO))and(GetRandomInt(1,5)==1)and(Trig_Monstrum_Tentacle_Ambush_IsNightTime()))!=null
endfunction

function Trig_Monstrum_Tentacle_Ambush_UnpauseTentacle takes nothing returns nothing
    call PauseUnitBJ(false,GetEnumUnit())
endfunction

function Trig_Monstrum_Tentacle_Ambush_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    set udg_TempPoint=GetUnitLoc(GetAttacker())
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=8
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        // (45) times (loop counter A treated as a decimal-capable number).
        set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,300.,(45.*I2R(GetForLoopIndexA())))
        call CreateNUnitsAtLocFacingLocBJ(1,'n0MP',Player($B),udg_TempPoint2,udg_TempPoint) // 'n0MP': object name not found in map data; $B = 11
        call PauseUnitBJ(true,GetLastCreatedUnit())
        call SetUnitAnimation(GetLastCreatedUnit(),"birth")
        call QueueUnitAnimationBJ(GetLastCreatedUnit(),"stand")
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_TentacleGroup)
        call RemoveLocation(udg_TempPoint2)
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    call RemoveLocation(udg_TempPoint)
    call EnableTrigger(gg_trg_Monstrum_Summon)
    call Wait_Polled(.5)
    call ForGroupBJ(udg_TentacleGroup,function Trig_Monstrum_Tentacle_Ambush_UnpauseTentacle)
    call StartTimerBJ(udg_TentacleTimer,false,20.)
endfunction

function Trig_Monstrum_Summon_Conditions takes nothing returns boolean
    return(IsUnitInGroup(GetTriggerUnit(),udg_TentacleGroup))and(GetKillingUnitBJ()!=null)
endfunction

function Trig_Monstrum_Summon_KillTentacle takes nothing returns nothing
    call KillUnit(GetEnumUnit())
endfunction

function Trig_Monstrum_Summon_HeroHasCharm takes nothing returns boolean
    return(UnitHasItemOfTypeBJ(Player_GetHero(GetOwningPlayer(GetKillingUnitBJ())),'I0BO'))or(UnitHasItemOfTypeBJ(udg_SpiritOfGaya[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))],'I0BO')) // 'I0BO': item "Grattheos Charm"
endfunction

function Trig_Monstrum_Summon_MonstrumNotSpawned takes nothing returns boolean
    return(udg_NebraMonstrum==null)
endfunction

function Trig_Monstrum_Summon_AmbushAllowed takes nothing returns boolean
    return(Trig_Monstrum_Summon_HeroHasCharm())
endfunction

function Trig_Monstrum_Summon_Actions takes nothing returns nothing
    call ForGroupBJ(udg_TentacleGroup,function Trig_Monstrum_Summon_KillTentacle)
    call GroupClear(udg_TentacleGroup)
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    if(Trig_Monstrum_Summon_AmbushAllowed())then
        call DisableTrigger(GetTriggeringTrigger())
        call PauseTimerBJ(true,udg_TentacleTimer)
        call Wait_Polled(.5)
        set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
        if(Trig_Monstrum_Summon_MonstrumNotSpawned())then
            call CreateNUnitsAtLoc(1,'E01M',Player($B),udg_TempPoint,bj_UNIT_FACING) // 'E01M': unit "Nebra Monstrum"; $B = 11
            call SetUnitColor(GetLastCreatedUnit(),PLAYER_COLOR_PURPLE)
            call SetHeroLevelBJ(GetLastCreatedUnit(),65,false)
            set udg_NebraMonstrum=GetLastCreatedUnit()
            call TriggerRegisterUnitEvent(gg_trg_Quest_Monstrum_Complete,GetLastCreatedUnit(),EVENT_UNIT_DEATH)
            call EnableTrigger(gg_trg_Quest_Monstrum_Complete)
            call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_DISCOVERED,"New Quest Received: |cffffcc00Monstrum of the Sea|r")
            set udg_SideQuest[71]=CreateQuestBJ(bj_QUESTTYPE_REQ_DISCOVERED,(udg_QuestNamePrefix+"Monstrum of the Sea"),"A monstrum from the abyss of the sea ambushed you. Kill it!","ReplaceableTextures\\CommandButtons\\BTNForgottenOne.blp")
            set udg_MonstrumPhase=0
        else
            call SetUnitPositionLocFacingBJ(udg_NebraMonstrum,udg_TempPoint,bj_UNIT_FACING)
            // ((4) minus (udg_MonstrumPhase) treated as a decimal-capable number) times (25).
            call SetUnitLifePercentBJ(udg_NebraMonstrum,(I2R((4-udg_MonstrumPhase))*25.))
            call ShowUnitShow(udg_NebraMonstrum)
            call SetUnitInvulnerable(udg_NebraMonstrum,false)
            call PauseUnitBJ(false,udg_NebraMonstrum)
            call QuestSetDescriptionBJ(udg_SideQuest[71],"The Nebra Monstrum has reappeared! Kill it!")
            call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_UPDATED,"Kill the Nebra Monstrum.")
        endif
        call RemoveLocation(udg_TempPoint)
        call SetUnitManaPercentBJ(udg_NebraMonstrum,'d')
        // Result 1: (maximum health of udg_NebraMonstrum) times (0.25).
        // Result 2: (3) minus (udg_MonstrumPhase).
        // Result 3: result 2 treated as a decimal-capable number.
        // Result 4: (result 1) times (result 3).
        set udg_MonstrumPhaseLife=((GetUnitStateSwap(UNIT_STATE_MAX_LIFE,udg_NebraMonstrum)*.25)*I2R((3-udg_MonstrumPhase)))
        call GroupAddUnitSimple(udg_NebraMonstrum,udg_BossUnits)
        call SetUnitAnimation(udg_NebraMonstrum,"birth")
        call QueueUnitAnimationBJ(udg_NebraMonstrum,"stand")
        call EnableTrigger(gg_trg_Monstrum_Phase_Check)
        call EnableTrigger(gg_trg_Monstrum_Tentacle_Cleanup)
    endif
endfunction

function Trig_Monstrum_Ambush_Rearm_KillLeftoverTentacle takes nothing returns nothing
    call KillUnit(GetEnumUnit())
endfunction

function Trig_Monstrum_Ambush_Rearm_TentaclesRemain takes nothing returns boolean
    return(IsUnitGroupEmptyBJ(udg_TentacleGroup)==false)
endfunction

function Trig_Monstrum_Ambush_Rearm_Actions takes nothing returns nothing
    if(Trig_Monstrum_Ambush_Rearm_TentaclesRemain())then
        call DisableTrigger(gg_trg_Monstrum_Summon)
        call ForGroupBJ(udg_TentacleGroup,function Trig_Monstrum_Ambush_Rearm_KillLeftoverTentacle)
        call GroupClear(udg_TentacleGroup)
        call Wait_Polled(5.)
    endif
    call EnableTrigger(gg_trg_Monstrum_Tentacle_Ambush)
endfunction

function Trig_Monstrum_Phase_Check_KillTentacleOnDive takes nothing returns nothing
    call KillUnit(GetEnumUnit())
endfunction

function Trig_Monstrum_Phase_Check_KillTentacleAfterDive takes nothing returns nothing
    call KillUnit(GetEnumUnit())
endfunction

function Trig_Monstrum_Phase_Check_LifeAbovePhaseCap takes nothing returns boolean
    // Calculation 1:
    // Result 1: current health divided by maximum health for udg_NebraMonstrum, times 100 (or 0 if the unit is
    // missing or its maximum is 0).
    // Calculation 2:
    // ((4) minus (udg_MonstrumPhase) treated as a decimal-capable number) times (25).
    return(udg_MonstrumPhase>0)and(GetUnitLifePercent(udg_NebraMonstrum)>(I2R((4-udg_MonstrumPhase))*25.))and(UnitHasBuffBJ(udg_NebraMonstrum,'B05V')==false) // 'B05V': buff tooltip "Disease"
endfunction

function Trig_Monstrum_Phase_Check_LifeBelowPhaseCut takes nothing returns boolean
    // Calculation 1:
    // Result 1: current health divided by maximum health for udg_NebraMonstrum, times 100 (or 0 if the unit is
    // missing or its maximum is 0).
    // Calculation 2:
    // ((3) minus (udg_MonstrumPhase) treated as a decimal-capable number) times (25).
    return(GetUnitStateSwap(UNIT_STATE_LIFE,udg_NebraMonstrum)<udg_MonstrumPhaseLife)or(GetUnitLifePercent(udg_NebraMonstrum)<(I2R((3-udg_MonstrumPhase))*25.))
endfunction

function Trig_Monstrum_Phase_Check_ShouldDive takes nothing returns boolean
    return(udg_MonstrumPhase<3)and(Trig_Monstrum_Phase_Check_LifeBelowPhaseCut())
endfunction

function Trig_Monstrum_Phase_Check_Actions takes nothing returns nothing
    if(Trig_Monstrum_Phase_Check_ShouldDive())then
        call DisableTrigger(GetTriggeringTrigger())
        call DisableTrigger(gg_trg_Monstrum_Tentacle_Cleanup)
        set udg_MonstrumPhase=(udg_MonstrumPhase+1)
        call SetUnitInvulnerable(udg_NebraMonstrum,true)
        call PauseUnitBJ(true,udg_NebraMonstrum)
        call ForGroupBJ(udg_TentacleGroup,function Trig_Monstrum_Phase_Check_KillTentacleOnDive)
        call GroupClear(udg_TentacleGroup)
        set udg_TempPoint=GetUnitLoc(udg_NebraMonstrum)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Objects\\Spawnmodels\\Naga\\NagaDeath\\NagaDeath.mdl")
        call BlzSetSpecialEffectScale(GetLastCreatedEffectBJ(),3.)
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        set bj_forLoopAIndex=1
        set bj_forLoopAIndexEnd=$A // $A = 10
        loop
            exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
            // (loop counter A treated as a decimal-capable number) times (36).
            set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,256,(I2R(GetForLoopIndexA())*36.))
            call AddSpecialEffectLocBJ(udg_TempPoint2,"Objects\\Spawnmodels\\Naga\\NagaDeath\\NagaDeath.mdl")
            call DestroyEffectBJ(GetLastCreatedEffectBJ())
            call RemoveLocation(udg_TempPoint2)
            set bj_forLoopAIndex=bj_forLoopAIndex+1
        endloop
        call RemoveLocation(udg_TempPoint)
        call Wait_Polled(.5)
        call ForGroupBJ(udg_TentacleGroup,function Trig_Monstrum_Phase_Check_KillTentacleAfterDive)
        call GroupClear(udg_TentacleGroup)
        call ShowUnitHide(udg_NebraMonstrum)
        call GroupRemoveUnitSimple(udg_NebraMonstrum,udg_BossUnits)
        call QuestSetDescriptionBJ(udg_SideQuest[71],"The Nebra Monstrum has dived down under! Find it again!")
        call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_UPDATED,"Find the Nebra Monstrum again.")
        call StartTimerBJ(udg_TentacleTimer,false,20.)
        set udg_DispelTarget=udg_NebraMonstrum
        call ConditionalTriggerExecute(gg_trg_Remove_Debuffs)
        call ConditionalTriggerExecute(gg_trg_Remove_Buffs)
    else
        if(Trig_Monstrum_Phase_Check_LifeAbovePhaseCap())then
            call UnitRemoveBuffBJ('B04O',udg_NebraMonstrum) // 'B04O': buff tooltip "Recovering"
            // ((4) minus (udg_MonstrumPhase) treated as a decimal-capable number) times (25).
            call SetUnitLifePercentBJ(udg_NebraMonstrum,(I2R((4-udg_MonstrumPhase))*25.))
        endif
    endif
endfunction

function Trig_Monstrum_DepthCharge_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A0IE') // 'A0IE': ability "Depth Charge"
endfunction

function Trig_Monstrum_DepthCharge_SlotFree takes nothing returns boolean
    return(IsUnitInGroup(udg_MonstrumTentacle[udg_TempInteger],udg_TentacleGroup)==false)
endfunction

function Trig_Monstrum_DepthCharge_UnpauseSpawnedTentacle takes nothing returns nothing
    call PauseUnitBJ(false,GetEnumUnit())
endfunction

function Trig_Monstrum_DepthCharge_Actions takes nothing returns nothing
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    set udg_TempInteger=0
    loop
        exitwhen udg_TempInteger>3
        if(Trig_Monstrum_DepthCharge_SlotFree())then
            // (udg_TempInteger treated as a decimal-capable number) times (90).
            set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,256,(I2R(udg_TempInteger)*90.))
            call CreateNUnitsAtLoc(1,'n0MP',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint2,bj_UNIT_FACING) // 'n0MP': object name not found in map data
            call RemoveLocation(udg_TempPoint2)
            set udg_MonstrumTentacle[udg_TempInteger]=GetLastCreatedUnit()
            call PauseUnitBJ(true,GetLastCreatedUnit())
            call SetUnitAnimation(GetLastCreatedUnit(),"birth")
            call QueueUnitAnimationBJ(GetLastCreatedUnit(),"stand")
            call GroupAddUnitSimple(GetLastCreatedUnit(),udg_TentacleGroup)
        endif
        set udg_TempInteger=udg_TempInteger+1
    endloop
    call RemoveLocation(udg_TempPoint)
    set udg_TempPoint=GetUnitLoc(GetSpellTargetUnit())
    set udg_TempPoint2=OffsetLocation(udg_TempPoint,-256.,0)
    call CreateNUnitsAtLoc(1,'n0MP',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint2,bj_UNIT_FACING) // 'n0MP': object name not found in map data
    call RemoveLocation(udg_TempPoint2)
    set udg_MonstrumTentacle[udg_TempInteger]=GetLastCreatedUnit()
    call PauseUnitBJ(true,GetLastCreatedUnit())
    call SetUnitAnimation(GetLastCreatedUnit(),"birth")
    call QueueUnitAnimationBJ(GetLastCreatedUnit(),"stand")
    call GroupAddUnitSimple(GetLastCreatedUnit(),udg_TentacleGroup)
    // (20) plus ((5) times (udg_Difficulty treated as a decimal-capable number)).
    call UnitApplyTimedLifeBJ((20.+(5.*I2R(udg_Difficulty))),'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    set udg_TempPoint2=OffsetLocation(udg_TempPoint,256.,0)
    call CreateNUnitsAtLoc(1,'n0MP',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint2,bj_UNIT_FACING) // 'n0MP': object name not found in map data
    call RemoveLocation(udg_TempPoint2)
    set udg_MonstrumTentacle[udg_TempInteger]=GetLastCreatedUnit()
    call PauseUnitBJ(true,GetLastCreatedUnit())
    call SetUnitAnimation(GetLastCreatedUnit(),"birth")
    call QueueUnitAnimationBJ(GetLastCreatedUnit(),"stand")
    call GroupAddUnitSimple(GetLastCreatedUnit(),udg_TentacleGroup)
    // (20) plus ((5) times (udg_Difficulty treated as a decimal-capable number)).
    call UnitApplyTimedLifeBJ((20.+(5.*I2R(udg_Difficulty))),'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call RemoveLocation(udg_TempPoint)
    call Wait_Polled(.5)
    call ForGroupBJ(udg_TentacleGroup,function Trig_Monstrum_DepthCharge_UnpauseSpawnedTentacle)
endfunction

function Trig_Monstrum_Tentacle_Cleanup_Conditions takes nothing returns boolean
    return(IsUnitInGroup(GetTriggerUnit(),udg_TentacleGroup))
endfunction

function Trig_Monstrum_Tentacle_Cleanup_Actions takes nothing returns nothing
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_TentacleGroup)
endfunction

// World Editor calls InitTrig_Monstrum automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Monstrum (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Monstrum takes nothing returns nothing
endfunction

function Register_Monstrum_Ambush_Arm takes nothing returns nothing
    set gg_trg_Monstrum_Ambush_Arm=CreateTrigger()
    call DisableTrigger(gg_trg_Monstrum_Ambush_Arm)
    call TriggerRegisterTimerEventPeriodic(gg_trg_Monstrum_Ambush_Arm,30.)
    call TriggerAddCondition(gg_trg_Monstrum_Ambush_Arm,Condition(function Trig_Monstrum_Ambush_Arm_Conditions))
    call TriggerAddAction(gg_trg_Monstrum_Ambush_Arm,function Trig_Monstrum_Ambush_Arm_Actions)
endfunction

function Register_Monstrum_Tentacle_Ambush takes nothing returns nothing
    set gg_trg_Monstrum_Tentacle_Ambush=CreateTrigger()
    call DisableTrigger(gg_trg_Monstrum_Tentacle_Ambush)
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_Monstrum_Tentacle_Ambush,Player($B),EVENT_PLAYER_UNIT_ATTACKED) // $B = 11
    call TriggerAddCondition(gg_trg_Monstrum_Tentacle_Ambush,Condition(function Trig_Monstrum_Tentacle_Ambush_Conditions))
    call TriggerAddAction(gg_trg_Monstrum_Tentacle_Ambush,function Trig_Monstrum_Tentacle_Ambush_Actions)
endfunction

function Register_Monstrum_Summon takes nothing returns nothing
    set gg_trg_Monstrum_Summon=CreateTrigger()
    call DisableTrigger(gg_trg_Monstrum_Summon)
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_Monstrum_Summon,Player($B),EVENT_PLAYER_UNIT_DEATH) // $B = 11
    call TriggerAddCondition(gg_trg_Monstrum_Summon,Condition(function Trig_Monstrum_Summon_Conditions))
    call TriggerAddAction(gg_trg_Monstrum_Summon,function Trig_Monstrum_Summon_Actions)
endfunction

function Register_Monstrum_Ambush_Rearm takes nothing returns nothing
    set gg_trg_Monstrum_Ambush_Rearm=CreateTrigger()
    call DisableTrigger(gg_trg_Monstrum_Ambush_Rearm)
    call TriggerRegisterTimerExpireEventBJ(gg_trg_Monstrum_Ambush_Rearm,udg_TentacleTimer)
    call TriggerAddAction(gg_trg_Monstrum_Ambush_Rearm,function Trig_Monstrum_Ambush_Rearm_Actions)
endfunction

function Register_Monstrum_Phase_Check takes nothing returns nothing
    set gg_trg_Monstrum_Phase_Check=CreateTrigger()
    call DisableTrigger(gg_trg_Monstrum_Phase_Check)
    call TriggerRegisterTimerEventPeriodic(gg_trg_Monstrum_Phase_Check,2)
    call TriggerAddAction(gg_trg_Monstrum_Phase_Check,function Trig_Monstrum_Phase_Check_Actions)
endfunction

function Register_Monstrum_DepthCharge takes nothing returns nothing
    set gg_trg_Monstrum_DepthCharge=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Monstrum_DepthCharge,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Monstrum_DepthCharge,Condition(function Trig_Monstrum_DepthCharge_Conditions))
    call TriggerAddAction(gg_trg_Monstrum_DepthCharge,function Trig_Monstrum_DepthCharge_Actions)
endfunction

function Register_Monstrum_Tentacle_Cleanup takes nothing returns nothing
    set gg_trg_Monstrum_Tentacle_Cleanup=CreateTrigger()
    call DisableTrigger(gg_trg_Monstrum_Tentacle_Cleanup)
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_Monstrum_Tentacle_Cleanup,Player($B),EVENT_PLAYER_UNIT_DEATH) // $B = 11
    call TriggerAddCondition(gg_trg_Monstrum_Tentacle_Cleanup,Condition(function Trig_Monstrum_Tentacle_Cleanup_Conditions))
    call TriggerAddAction(gg_trg_Monstrum_Tentacle_Cleanup,function Trig_Monstrum_Tentacle_Cleanup_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Monstrum takes nothing returns nothing
    call Register_Monstrum_Ambush_Arm()
    call Register_Monstrum_Tentacle_Ambush()
    call Register_Monstrum_Summon()
    call Register_Monstrum_Ambush_Rearm()
    call Register_Monstrum_Phase_Check()
    call Register_Monstrum_DepthCharge()
    call Register_Monstrum_Tentacle_Cleanup()
endfunction

endlibrary
