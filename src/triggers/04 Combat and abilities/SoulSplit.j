library TSoulSplit
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_SoulSplit_Clone_Death=null
endglobals

function Trig_SoulSplit_Clone_Death_Conditions takes nothing returns boolean
    return(IsUnitInGroup(GetTriggerUnit(),udg_MirrorCloneGroup))
endfunction

function Trig_SoulSplit_Clone_Death_Actions takes nothing returns nothing
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_MirrorCloneGroup)
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Orc\\MirrorImage\\MirrorImageDeathCaster.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(udg_TempPoint)
    call RemoveUnit(GetTriggerUnit())
endfunction

// World Editor calls InitTrig_SoulSplit automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_SoulSplit (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_SoulSplit takes nothing returns nothing
endfunction

function Register_SoulSplit_Clone_Death takes nothing returns nothing
    set gg_trg_SoulSplit_Clone_Death=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_SoulSplit_Clone_Death,EVENT_PLAYER_UNIT_DEATH)
    call TriggerAddCondition(gg_trg_SoulSplit_Clone_Death,Condition(function Trig_SoulSplit_Clone_Death_Conditions))
    call TriggerAddAction(gg_trg_SoulSplit_Clone_Death,function Trig_SoulSplit_Clone_Death_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_SoulSplit takes nothing returns nothing
    call Register_SoulSplit_Clone_Death()
endfunction

endlibrary
