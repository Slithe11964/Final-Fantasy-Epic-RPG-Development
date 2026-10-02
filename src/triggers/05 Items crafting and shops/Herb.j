library THerb
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Herb_Spawn_Start=null
endglobals

function Trig_Herb_Spawn_Start_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call StartTimerBJ(udg_HerbRespawnTimer[0],false,1.)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_Herb automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Herb (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Herb takes nothing returns nothing
endfunction

function Register_Herb_Spawn_Start takes nothing returns nothing
    set gg_trg_Herb_Spawn_Start=CreateTrigger()
    call TriggerRegisterTimerEventSingle(gg_trg_Herb_Spawn_Start,10.)
    call TriggerAddAction(gg_trg_Herb_Spawn_Start,function Trig_Herb_Spawn_Start_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Herb takes nothing returns nothing
    call Register_Herb_Spawn_Start()
endfunction

endlibrary
