library TCowKing
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_CowKing_Hide=null
endglobals

function Trig_CowKing_Hide_Actions takes nothing returns nothing
    set udg_PortalRitualActive=false
    call ShowUnitHide(gg_unit_O00I_0239)
    call PauseUnitBJ(true,gg_unit_O00I_0239)
    call SetUnitInvulnerable(gg_unit_O00I_0239,true)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_CowKing automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_CowKing (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_CowKing takes nothing returns nothing
endfunction

function Register_CowKing_Hide takes nothing returns nothing
    set gg_trg_CowKing_Hide=CreateTrigger()
    call TriggerAddAction(gg_trg_CowKing_Hide,function Trig_CowKing_Hide_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_CowKing takes nothing returns nothing
    call Register_CowKing_Hide()
endfunction

endlibrary
