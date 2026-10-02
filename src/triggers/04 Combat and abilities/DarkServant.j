library TDarkServant
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_DarkServant_Cleanup=null
endglobals

function Trig_DarkServant_Cleanup_Conditions takes nothing returns boolean
    return(IsUnitInGroup(GetTriggerUnit(),udg_DarkServants))
endfunction

function Trig_DarkServant_Cleanup_Actions takes nothing returns nothing
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_DarkServants)
endfunction

// World Editor calls InitTrig_DarkServant automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_DarkServant (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_DarkServant takes nothing returns nothing
endfunction

function Register_DarkServant_Cleanup takes nothing returns nothing
    set gg_trg_DarkServant_Cleanup=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_DarkServant_Cleanup,EVENT_PLAYER_UNIT_DEATH)
    call TriggerAddCondition(gg_trg_DarkServant_Cleanup,Condition(function Trig_DarkServant_Cleanup_Conditions))
    call TriggerAddAction(gg_trg_DarkServant_Cleanup,function Trig_DarkServant_Cleanup_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_DarkServant takes nothing returns nothing
    call Register_DarkServant_Cleanup()
endfunction

endlibrary
