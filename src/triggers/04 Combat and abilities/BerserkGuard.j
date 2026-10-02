library TBerserkGuard
function Trig_BerserkGuard_Decay_Conditions takes nothing returns boolean
    return(IsUnitInGroup(GetTriggerUnit(),udg_BerserkGuards))
endfunction

function Trig_BerserkGuard_Decay_Actions takes nothing returns nothing
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_BerserkGuards)
    call RemoveUnit(GetTriggerUnit())
endfunction

// World Editor calls InitTrig_BerserkGuard automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_BerserkGuard (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_BerserkGuard takes nothing returns nothing
endfunction

function Register_BerserkGuard_Decay takes nothing returns nothing
    set gg_trg_BerserkGuard_Decay=CreateTrigger()
    call DisableTrigger(gg_trg_BerserkGuard_Decay)
    call TriggerAddCondition(gg_trg_BerserkGuard_Decay,Condition(function Trig_BerserkGuard_Decay_Conditions))
    call TriggerAddAction(gg_trg_BerserkGuard_Decay,function Trig_BerserkGuard_Decay_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_BerserkGuard takes nothing returns nothing
    call Register_BerserkGuard_Decay()
endfunction

endlibrary
