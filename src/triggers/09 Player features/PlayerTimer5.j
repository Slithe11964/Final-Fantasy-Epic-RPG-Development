library TPlayerTimer5
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_PlayerTimer5_Expire=null
endglobals

function Trig_PlayerTimer5_Expire_Actions takes nothing returns nothing
    set udg_TempInteger=5
    call ConditionalTriggerExecute(gg_trg_Fishing_Tick)
endfunction

// World Editor calls InitTrig_PlayerTimer5 automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_PlayerTimer5 (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_PlayerTimer5 takes nothing returns nothing
endfunction

function Register_PlayerTimer5_Expire takes nothing returns nothing
    set gg_trg_PlayerTimer5_Expire=CreateTrigger()
    call TriggerRegisterTimerExpireEventBJ(gg_trg_PlayerTimer5_Expire,udg_FishingTimer[5])
    call TriggerAddAction(gg_trg_PlayerTimer5_Expire,function Trig_PlayerTimer5_Expire_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_PlayerTimer5 takes nothing returns nothing
    call Register_PlayerTimer5_Expire()
endfunction

endlibrary
