library TChaos requires TLoc, TUnit, TWait
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Chaos_Init=null
    trigger gg_trg_Chaos_Spawn_Chaosjets=null
    trigger gg_trg_Chaos_Revive_Chaosjets=null
    trigger gg_trg_Chaos_Recall_Chaosjets=null
endglobals

function Trig_Chaos_Init_Actions takes nothing returns nothing
    call ShowUnitHide(gg_unit_U00O_0191)
    call PauseUnitBJ(true,gg_unit_U00O_0191)
    call SetUnitInvulnerable(gg_unit_U00O_0191,true)
    call UnitRemoveAbilityBJ('A11C',gg_unit_U00O_0191) // 'A11C': ability "!Revive Chaosjets"
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Chaos_Spawn_Chaosjets_Actions takes nothing returns nothing
    set udg_TempPoint=GetUnitLoc(gg_unit_U00O_0191)
    set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,256,0)
    call CreateNUnitsAtLoc(1,'n0CT',Player($B),udg_TempPoint2,bj_UNIT_FACING) // 'n0CT': unit "Earth Chaosjet"; $B = 11
    call RemoveLocation(udg_TempPoint2)
    call SetUnitColor(GetLastCreatedUnit(),PLAYER_COLOR_ORANGE)
    call Unit_ScaleToLevel60(bj_lastCreatedUnit)
    call GroupAddUnitSimple(GetLastCreatedUnit(),udg_ChaosElementalGroup)
    call PauseUnitBJ(true,GetLastCreatedUnit())
    call SetUnitInvulnerable(GetLastCreatedUnit(),true)
    call AddSpecialEffectTargetUnitBJ("origin",GetLastCreatedUnit(),"Abilities\\Spells\\Items\\TomeOfRetraining\\TomeOfRetrainingCaster.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,256,60.)
    call CreateNUnitsAtLoc(1,'n0CO',Player($B),udg_TempPoint2,bj_UNIT_FACING) // 'n0CO': unit "Fire Chaosjet"; $B = 11
    call RemoveLocation(udg_TempPoint2)
    call SetUnitColor(GetLastCreatedUnit(),PLAYER_COLOR_RED)
    call Unit_ScaleToLevel60(bj_lastCreatedUnit)
    call GroupAddUnitSimple(GetLastCreatedUnit(),udg_ChaosElementalGroup)
    call PauseUnitBJ(true,GetLastCreatedUnit())
    call SetUnitInvulnerable(GetLastCreatedUnit(),true)
    call AddSpecialEffectTargetUnitBJ("origin",GetLastCreatedUnit(),"Abilities\\Spells\\Items\\TomeOfRetraining\\TomeOfRetrainingCaster.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,256,240.)
    call CreateNUnitsAtLoc(1,'n0CP',Player($B),udg_TempPoint2,bj_UNIT_FACING) // 'n0CP': unit "Ice Chaosjet"; $B = 11
    call RemoveLocation(udg_TempPoint2)
    call SetUnitColor(GetLastCreatedUnit(),PLAYER_COLOR_LIGHT_BLUE)
    call Unit_ScaleToLevel60(bj_lastCreatedUnit)
    call GroupAddUnitSimple(GetLastCreatedUnit(),udg_ChaosElementalGroup)
    call PauseUnitBJ(true,GetLastCreatedUnit())
    call SetUnitInvulnerable(GetLastCreatedUnit(),true)
    call AddSpecialEffectTargetUnitBJ("origin",GetLastCreatedUnit(),"Abilities\\Spells\\Items\\TomeOfRetraining\\TomeOfRetrainingCaster.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,256,120.)
    call CreateNUnitsAtLoc(1,'n0CQ',Player($B),udg_TempPoint2,bj_UNIT_FACING) // 'n0CQ': unit "Thunder Chaosjet"; $B = 11
    call RemoveLocation(udg_TempPoint2)
    call SetUnitColor(GetLastCreatedUnit(),PLAYER_COLOR_YELLOW)
    call Unit_ScaleToLevel60(bj_lastCreatedUnit)
    call GroupAddUnitSimple(GetLastCreatedUnit(),udg_ChaosElementalGroup)
    call PauseUnitBJ(true,GetLastCreatedUnit())
    call SetUnitInvulnerable(GetLastCreatedUnit(),true)
    call AddSpecialEffectTargetUnitBJ("origin",GetLastCreatedUnit(),"Abilities\\Spells\\Items\\TomeOfRetraining\\TomeOfRetrainingCaster.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,256,300.)
    call CreateNUnitsAtLoc(1,'n0CR',Player($B),udg_TempPoint2,bj_UNIT_FACING) // 'n0CR': unit "Water Chaosjet"; $B = 11
    call RemoveLocation(udg_TempPoint2)
    call SetUnitColor(GetLastCreatedUnit(),PLAYER_COLOR_BLUE)
    call Unit_ScaleToLevel60(bj_lastCreatedUnit)
    call GroupAddUnitSimple(GetLastCreatedUnit(),udg_ChaosElementalGroup)
    call PauseUnitBJ(true,GetLastCreatedUnit())
    call SetUnitInvulnerable(GetLastCreatedUnit(),true)
    call AddSpecialEffectTargetUnitBJ("origin",GetLastCreatedUnit(),"Abilities\\Spells\\Items\\TomeOfRetraining\\TomeOfRetrainingCaster.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,256,180.)
    call CreateNUnitsAtLoc(1,'n0CS',Player($B),udg_TempPoint2,bj_UNIT_FACING) // 'n0CS': unit "Wind Chaosjet"; $B = 11
    call RemoveLocation(udg_TempPoint2)
    call SetUnitColor(GetLastCreatedUnit(),PLAYER_COLOR_GREEN)
    call Unit_ScaleToLevel60(bj_lastCreatedUnit)
    call GroupAddUnitSimple(GetLastCreatedUnit(),udg_ChaosElementalGroup)
    call PauseUnitBJ(true,GetLastCreatedUnit())
    call SetUnitInvulnerable(GetLastCreatedUnit(),true)
    call AddSpecialEffectTargetUnitBJ("origin",GetLastCreatedUnit(),"Abilities\\Spells\\Items\\TomeOfRetraining\\TomeOfRetrainingCaster.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(udg_TempPoint)
endfunction

function Trig_Chaos_Revive_Chaosjets_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A11C') // 'A11C': ability "!Revive Chaosjets"
endfunction

function Trig_Chaos_Revive_Chaosjets_TrackedCaster_Earth takes nothing returns boolean
    return(GetTriggerUnit()==udg_EcheleBoss)
endfunction

function Trig_Chaos_Revive_Chaosjets_TrackedCaster_Fire takes nothing returns boolean
    return(GetTriggerUnit()==udg_EcheleBoss)
endfunction

function Trig_Chaos_Revive_Chaosjets_TrackedCaster_Ice takes nothing returns boolean
    return(GetTriggerUnit()==udg_EcheleBoss)
endfunction

function Trig_Chaos_Revive_Chaosjets_TrackedCaster_Thunder takes nothing returns boolean
    return(GetTriggerUnit()==udg_EcheleBoss)
endfunction

function Trig_Chaos_Revive_Chaosjets_TrackedCaster_Water takes nothing returns boolean
    return(GetTriggerUnit()==udg_EcheleBoss)
endfunction

function Trig_Chaos_Revive_Chaosjets_TrackedCaster_Wind takes nothing returns boolean
    return(GetTriggerUnit()==udg_EcheleBoss)
endfunction

function Trig_Chaos_Revive_Chaosjets_Actions takes nothing returns nothing
    call DisableTrigger(gg_trg_Chaos_Recall_Chaosjets)
    set udg_ChaosBoss=GetTriggerUnit()
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,128.,0)
    call CreateNUnitsAtLoc(1,'n0CT',Player($B),udg_TempPoint2,bj_UNIT_FACING) // 'n0CT': unit "Earth Chaosjet"; $B = 11
    call RemoveLocation(udg_TempPoint2)
    call SetUnitColor(GetLastCreatedUnit(),PLAYER_COLOR_ORANGE)
    call Unit_ScaleToLevel60(bj_lastCreatedUnit)
    call GroupAddUnitSimple(GetLastCreatedUnit(),udg_ChaosElementalGroup)
    if(Trig_Chaos_Revive_Chaosjets_TrackedCaster_Earth())then
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_BossSummons)
    endif
    call AddSpecialEffectTargetUnitBJ("origin",GetLastCreatedUnit(),"Abilities\\Spells\\Items\\TomeOfRetraining\\TomeOfRetrainingCaster.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,128.,60.)
    call CreateNUnitsAtLoc(1,'n0CO',Player($B),udg_TempPoint2,bj_UNIT_FACING) // 'n0CO': unit "Fire Chaosjet"; $B = 11
    call RemoveLocation(udg_TempPoint2)
    call SetUnitColor(GetLastCreatedUnit(),PLAYER_COLOR_RED)
    call Unit_ScaleToLevel60(bj_lastCreatedUnit)
    call GroupAddUnitSimple(GetLastCreatedUnit(),udg_ChaosElementalGroup)
    if(Trig_Chaos_Revive_Chaosjets_TrackedCaster_Fire())then
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_BossSummons)
    endif
    call AddSpecialEffectTargetUnitBJ("origin",GetLastCreatedUnit(),"Abilities\\Spells\\Items\\TomeOfRetraining\\TomeOfRetrainingCaster.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,128.,240.)
    call CreateNUnitsAtLoc(1,'n0CP',Player($B),udg_TempPoint2,bj_UNIT_FACING) // 'n0CP': unit "Ice Chaosjet"; $B = 11
    call RemoveLocation(udg_TempPoint2)
    call SetUnitColor(GetLastCreatedUnit(),PLAYER_COLOR_LIGHT_BLUE)
    call Unit_ScaleToLevel60(bj_lastCreatedUnit)
    call GroupAddUnitSimple(GetLastCreatedUnit(),udg_ChaosElementalGroup)
    if(Trig_Chaos_Revive_Chaosjets_TrackedCaster_Ice())then
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_BossSummons)
    endif
    call AddSpecialEffectTargetUnitBJ("origin",GetLastCreatedUnit(),"Abilities\\Spells\\Items\\TomeOfRetraining\\TomeOfRetrainingCaster.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,128.,120.)
    call CreateNUnitsAtLoc(1,'n0CQ',Player($B),udg_TempPoint2,bj_UNIT_FACING) // 'n0CQ': unit "Thunder Chaosjet"; $B = 11
    call RemoveLocation(udg_TempPoint2)
    call SetUnitColor(GetLastCreatedUnit(),PLAYER_COLOR_YELLOW)
    call Unit_ScaleToLevel60(bj_lastCreatedUnit)
    call GroupAddUnitSimple(GetLastCreatedUnit(),udg_ChaosElementalGroup)
    if(Trig_Chaos_Revive_Chaosjets_TrackedCaster_Thunder())then
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_BossSummons)
    endif
    call AddSpecialEffectTargetUnitBJ("origin",GetLastCreatedUnit(),"Abilities\\Spells\\Items\\TomeOfRetraining\\TomeOfRetrainingCaster.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,128.,300.)
    call CreateNUnitsAtLoc(1,'n0CR',Player($B),udg_TempPoint2,bj_UNIT_FACING) // 'n0CR': unit "Water Chaosjet"; $B = 11
    call RemoveLocation(udg_TempPoint2)
    call SetUnitColor(GetLastCreatedUnit(),PLAYER_COLOR_BLUE)
    call Unit_ScaleToLevel60(bj_lastCreatedUnit)
    call GroupAddUnitSimple(GetLastCreatedUnit(),udg_ChaosElementalGroup)
    if(Trig_Chaos_Revive_Chaosjets_TrackedCaster_Water())then
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_BossSummons)
    endif
    call AddSpecialEffectTargetUnitBJ("origin",GetLastCreatedUnit(),"Abilities\\Spells\\Items\\TomeOfRetraining\\TomeOfRetrainingCaster.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,128.,180.)
    call CreateNUnitsAtLoc(1,'n0CS',Player($B),udg_TempPoint2,bj_UNIT_FACING) // 'n0CS': unit "Wind Chaosjet"; $B = 11
    call RemoveLocation(udg_TempPoint2)
    call SetUnitColor(GetLastCreatedUnit(),PLAYER_COLOR_GREEN)
    call Unit_ScaleToLevel60(bj_lastCreatedUnit)
    call GroupAddUnitSimple(GetLastCreatedUnit(),udg_ChaosElementalGroup)
    if(Trig_Chaos_Revive_Chaosjets_TrackedCaster_Wind())then
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_BossSummons)
    endif
    call AddSpecialEffectTargetUnitBJ("origin",GetLastCreatedUnit(),"Abilities\\Spells\\Items\\TomeOfRetraining\\TomeOfRetrainingCaster.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(udg_TempPoint)
    call Wait_Polled(2)
    call UnitRemoveAbilityBJ('A11C',GetTriggerUnit()) // 'A11C': ability "!Revive Chaosjets"
    call EnableTrigger(gg_trg_Chaos_Recall_Chaosjets)
endfunction

function Trig_Chaos_Recall_Chaosjets_Conditions takes nothing returns boolean
    return(GetTriggerUnit()==udg_ChaosBoss)and(UnitHasBuffBJ(GetTriggerUnit(),'B06R')==false)and(IsUnitGroupEmptyBJ(udg_ChaosElementalGroup)==false) // 'B06R': buff tooltip "Spiritual Guard"
endfunction

function Trig_Chaos_Recall_Chaosjets_BlinkJetToChaos takes nothing returns nothing
    set udg_TempPoint2=GetUnitLoc(GetEnumUnit())
    call AddSpecialEffectLocBJ(udg_TempPoint2,"Abilities\\Spells\\NightElf\\Blink\\BlinkCaster.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(udg_TempPoint2)
    call AddSpecialEffectTargetUnitBJ("origin",GetEnumUnit(),"Abilities\\Spells\\NightElf\\Blink\\BlinkTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call SetUnitPositionLoc(GetEnumUnit(),udg_TempPoint)
endfunction

function Trig_Chaos_Recall_Chaosjets_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call ForGroupBJ(udg_ChaosElementalGroup,function Trig_Chaos_Recall_Chaosjets_BlinkJetToChaos)
    call RemoveLocation(udg_TempPoint)
    call Wait_Polled(5.)
    call EnableTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_Chaos automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Chaos_Part1 / RegisterTriggers_Chaos_Part2 (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Chaos takes nothing returns nothing
endfunction

function Register_Chaos_Init takes nothing returns nothing
    set gg_trg_Chaos_Init=CreateTrigger()
    call TriggerAddAction(gg_trg_Chaos_Init,function Trig_Chaos_Init_Actions)
endfunction

function Register_Chaos_Spawn_Chaosjets takes nothing returns nothing
    set gg_trg_Chaos_Spawn_Chaosjets=CreateTrigger()
    call DisableTrigger(gg_trg_Chaos_Spawn_Chaosjets)
    call TriggerAddAction(gg_trg_Chaos_Spawn_Chaosjets,function Trig_Chaos_Spawn_Chaosjets_Actions)
endfunction

function Register_Chaos_Revive_Chaosjets takes nothing returns nothing
    set gg_trg_Chaos_Revive_Chaosjets=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Chaos_Revive_Chaosjets,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Chaos_Revive_Chaosjets,Condition(function Trig_Chaos_Revive_Chaosjets_Conditions))
    call TriggerAddAction(gg_trg_Chaos_Revive_Chaosjets,function Trig_Chaos_Revive_Chaosjets_Actions)
endfunction

function Register_Chaos_Recall_Chaosjets takes nothing returns nothing
    set gg_trg_Chaos_Recall_Chaosjets=CreateTrigger()
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_Chaos_Recall_Chaosjets,Player($B),EVENT_PLAYER_UNIT_ATTACKED) // $B = 11
    call TriggerAddCondition(gg_trg_Chaos_Recall_Chaosjets,Condition(function Trig_Chaos_Recall_Chaosjets_Conditions))
    call TriggerAddAction(gg_trg_Chaos_Recall_Chaosjets,function Trig_Chaos_Recall_Chaosjets_Actions)
endfunction

// Creates part 1 of 2 of this module's triggers. Called once at startup from
// Startup_RegisterTriggers (MapBootstrap). The parts are registered at different points so that
// triggers sharing an event with other modules keep their original firing order.
function RegisterTriggers_Chaos_Part1 takes nothing returns nothing
    call Register_Chaos_Init() // run by MapBootstrap
    call Register_Chaos_Spawn_Chaosjets() // starts off; run by VoiceOfForest
endfunction

// Creates part 2 of 2 of this module's triggers. Called once at startup from
// Startup_RegisterTriggers (MapBootstrap). The parts are registered at different points so that
// triggers sharing an event with other modules keep their original firing order.
function RegisterTriggers_Chaos_Part2 takes nothing returns nothing
    call Register_Chaos_Revive_Chaosjets()
    call Register_Chaos_Recall_Chaosjets() // enabled by Chaos; disabled by Chaos
endfunction

endlibrary
