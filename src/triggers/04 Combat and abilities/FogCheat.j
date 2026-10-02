library TFogCheat
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_FogCheat_Reset=null
endglobals

function Trig_FogCheat_Reset_Actions takes nothing returns nothing
    set udg_FogDisabled=false
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_FogCheat automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_FogCheat (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_FogCheat takes nothing returns nothing
endfunction

function Register_FogCheat_Reset takes nothing returns nothing
    set gg_trg_FogCheat_Reset=CreateTrigger()
    call TriggerRegisterTimerEventSingle(gg_trg_FogCheat_Reset,5)
    call TriggerAddAction(gg_trg_FogCheat_Reset,function Trig_FogCheat_Reset_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_FogCheat takes nothing returns nothing
    call Register_FogCheat_Reset()
endfunction

endlibrary
