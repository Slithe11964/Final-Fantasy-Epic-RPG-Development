library TSpartacus requires TLoc
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Spartacus_Summon=null
endglobals

function Trig_Spartacus_Summon_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A1DV') // 'A1DV': ability "Summon Spartacus"
endfunction

function Trig_Spartacus_Summon_Actions takes nothing returns nothing
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,128.,GetUnitFacing(GetTriggerUnit()))
    call RemoveLocation(udg_TempPoint)
    call CreateNUnitsAtLoc(1,'u01V',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint2,GetUnitFacing(GetTriggerUnit())) // 'u01V': unit "Spartacus"
    call RemoveLocation(udg_TempPoint2)
    call UnitApplyTimedLifeBJ(30.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call AddSpecialEffectTargetUnitBJ("origin",GetLastCreatedUnit(),"Abilities\\Spells\\Undead\\RaiseSkeletonWarrior\\RaiseSkeleton.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call IssueTargetOrderBJ(GetLastCreatedUnit(),"drunkenhaze",GetTriggerUnit())
endfunction

// World Editor calls InitTrig_Spartacus automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Spartacus (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Spartacus takes nothing returns nothing
endfunction

function Register_Spartacus_Summon takes nothing returns nothing
    set gg_trg_Spartacus_Summon=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Spartacus_Summon,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Spartacus_Summon,Condition(function Trig_Spartacus_Summon_Conditions))
    call TriggerAddAction(gg_trg_Spartacus_Summon,function Trig_Spartacus_Summon_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Spartacus takes nothing returns nothing
    call Register_Spartacus_Summon()
endfunction

endlibrary
