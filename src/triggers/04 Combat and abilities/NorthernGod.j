library TNorthernGod
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_NorthernGod_Setup=null
endglobals

function Trig_NorthernGod_Setup_Actions takes nothing returns nothing
    call ShowUnitHide(gg_unit_H01M_0071)
    call PauseUnitBJ(true,gg_unit_H01M_0071)
    call SetUnitInvulnerable(gg_unit_H01M_0071,true)
    call ShowUnitHide(gg_unit_E01O_0268)
    call PauseUnitBJ(true,gg_unit_E01O_0268)
    call SetUnitInvulnerable(gg_unit_E01O_0268,true)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_NorthernGod automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_NorthernGod (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_NorthernGod takes nothing returns nothing
endfunction

function Register_NorthernGod_Setup takes nothing returns nothing
    set gg_trg_NorthernGod_Setup=CreateTrigger()
    call TriggerAddAction(gg_trg_NorthernGod_Setup,function Trig_NorthernGod_Setup_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_NorthernGod takes nothing returns nothing
    call Register_NorthernGod_Setup() // run by MapBootstrap
endfunction

endlibrary
