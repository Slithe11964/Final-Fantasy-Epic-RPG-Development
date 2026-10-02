library TFallenRanger
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_FallenRanger_Setup=null
endglobals

function Trig_FallenRanger_Setup_Actions takes nothing returns nothing
    call ShowUnitHide(gg_unit_H00X_0133)
    call PauseUnitBJ(true,gg_unit_H00X_0133)
    call SetUnitInvulnerable(gg_unit_H00X_0133,true)
    call ShowUnitHide(gg_unit_H00Y_0022)
    call PauseUnitBJ(true,gg_unit_H00Y_0022)
    call SetUnitInvulnerable(gg_unit_H00Y_0022,true)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_FallenRanger automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_FallenRanger (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_FallenRanger takes nothing returns nothing
endfunction

function Register_FallenRanger_Setup takes nothing returns nothing
    set gg_trg_FallenRanger_Setup=CreateTrigger()
    call TriggerAddAction(gg_trg_FallenRanger_Setup,function Trig_FallenRanger_Setup_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_FallenRanger takes nothing returns nothing
    call Register_FallenRanger_Setup() // run by MapBootstrap
endfunction

endlibrary
