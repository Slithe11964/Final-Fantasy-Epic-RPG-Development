library TGhoul requires TLoc, TUnit
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Ghoul_Group_Cleanup=null
    trigger gg_trg_Ghoul_Master_Decay=null
    trigger gg_trg_Ghoul_Master_Spawn=null
endglobals

function Trig_Ghoul_Group_Cleanup_Conditions takes nothing returns boolean
    return(IsUnitInGroup(GetTriggerUnit(),udg_GhoulGroup))
endfunction

function Trig_Ghoul_Group_Cleanup_Actions takes nothing returns nothing
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_GhoulGroup)
endfunction

function Trig_Ghoul_Master_Decay_Conditions takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0RB',gg_unit_Uvng_0076)>1)and(CountUnitsInGroup(udg_GhoulGroup)<5) // 'A0RB': ability "Ghoul Master"
endfunction

function Trig_Ghoul_Master_Decay_Actions takes nothing returns nothing
    call DecUnitAbilityLevelSwapped('A0RB',gg_unit_Uvng_0076) // 'A0RB': ability "Ghoul Master"
endfunction

function Trig_Ghoul_Master_Spawn_Conditions takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0RB',GetTriggerUnit())>0)and(GetUnitAbilityLevelSwapped('A0RB',GetTriggerUnit())<=5) // 'A0RB': ability "Ghoul Master"
endfunction

function Trig_Ghoul_Master_Spawn_Cond_IsGrandVampire takes nothing returns boolean
    return(GetTriggerUnit()==gg_unit_Uvng_0076)
endfunction

function Trig_Ghoul_Master_Spawn_Cond_InSecondArenaGroup takes nothing returns boolean
    return(IsUnitInGroup(GetTriggerUnit(),udg_SummonedUnits))
endfunction

function Trig_Ghoul_Master_Spawn_Cond_InFirstArenaGroup takes nothing returns boolean
    return(IsUnitInGroup(GetTriggerUnit(),udg_SpecialUnits))
endfunction

function Trig_Ghoul_Master_Spawn_Actions takes nothing returns nothing
    local location l_tempPoint
    local location l_tempPoint2
    call IncUnitAbilityLevelSwapped('A0RB',GetTriggerUnit()) // 'A0RB': ability "Ghoul Master"
    set l_tempPoint=GetUnitLoc(GetAttacker())
    // A random decimal number between 64 and 96.
    set l_tempPoint2=Loc_PolarOffset(l_tempPoint,GetRandomReal(64.,96.),GetRandomDirectionDeg())
    call CreateNUnitsAtLocFacingLocBJ(1,'ugho',Player($B),l_tempPoint2,l_tempPoint) // 'ugho': object name not found in map data; $B = 11
    call RemoveLocation(l_tempPoint2)
    call RemoveLocation(l_tempPoint)
    call Unit_ScaleToLevel60(bj_lastCreatedUnit)
    call UnitAddTypeBJ(UNIT_TYPE_SUMMONED,GetLastCreatedUnit())
    if(Trig_Ghoul_Master_Spawn_Cond_IsGrandVampire())then
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_GhoulGroup)
    endif
    if(Trig_Ghoul_Master_Spawn_Cond_InFirstArenaGroup())then
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_SpecialUnits)
    else
        if(Trig_Ghoul_Master_Spawn_Cond_InSecondArenaGroup())then
            call GroupAddUnitSimple(GetLastCreatedUnit(),udg_SummonedUnits)
        endif
    endif
    call AddSpecialEffectTargetUnitBJ("origin",GetLastCreatedUnit(),"Abilities\\Spells\\Undead\\AnimateDead\\AnimateDeadTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    set l_tempPoint=null
    set l_tempPoint2=null
endfunction

// World Editor calls InitTrig_Ghoul automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Ghoul (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Ghoul takes nothing returns nothing
endfunction

function Register_Ghoul_Group_Cleanup takes nothing returns nothing
    set gg_trg_Ghoul_Group_Cleanup=CreateTrigger()
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_Ghoul_Group_Cleanup,Player($B),EVENT_PLAYER_UNIT_DEATH) // $B = 11
    call TriggerAddCondition(gg_trg_Ghoul_Group_Cleanup,Condition(function Trig_Ghoul_Group_Cleanup_Conditions))
    call TriggerAddAction(gg_trg_Ghoul_Group_Cleanup,function Trig_Ghoul_Group_Cleanup_Actions)
endfunction

function Register_Ghoul_Master_Decay takes nothing returns nothing
    set gg_trg_Ghoul_Master_Decay=CreateTrigger()
    call DisableTrigger(gg_trg_Ghoul_Master_Decay)
    call TriggerRegisterTimerEventPeriodic(gg_trg_Ghoul_Master_Decay,3.)
    call TriggerAddCondition(gg_trg_Ghoul_Master_Decay,Condition(function Trig_Ghoul_Master_Decay_Conditions))
    call TriggerAddAction(gg_trg_Ghoul_Master_Decay,function Trig_Ghoul_Master_Decay_Actions)
endfunction

function Register_Ghoul_Master_Spawn takes nothing returns nothing
    set gg_trg_Ghoul_Master_Spawn=CreateTrigger()
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_Ghoul_Master_Spawn,Player($B),EVENT_PLAYER_UNIT_ATTACKED) // $B = 11
    call TriggerAddCondition(gg_trg_Ghoul_Master_Spawn,Condition(function Trig_Ghoul_Master_Spawn_Conditions))
    call TriggerAddAction(gg_trg_Ghoul_Master_Spawn,function Trig_Ghoul_Master_Spawn_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Ghoul takes nothing returns nothing
    call Register_Ghoul_Group_Cleanup()
    call Register_Ghoul_Master_Decay() // starts off; enabled by GrandVampire; disabled by GrandVampire; destroyed by GrandVampire
    call Register_Ghoul_Master_Spawn()
endfunction

endlibrary
