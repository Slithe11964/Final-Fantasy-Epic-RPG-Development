library TPlayerTimer8
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_PlayerTimer8_Expire=null
endglobals

function Trig_PlayerTimer8_Expire_Actions takes nothing returns nothing
    set udg_TempInteger=8
    call ConditionalTriggerExecute(gg_trg_Fishing_Tick)
endfunction

// World Editor calls InitTrig_PlayerTimer8 automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_PlayerTimer8 (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_PlayerTimer8 takes nothing returns nothing
endfunction

function Register_PlayerTimer8_Expire takes nothing returns nothing
    set gg_trg_PlayerTimer8_Expire=CreateTrigger()
    call TriggerRegisterTimerExpireEventBJ(gg_trg_PlayerTimer8_Expire,udg_FishingTimer[8])
    call TriggerAddAction(gg_trg_PlayerTimer8_Expire,function Trig_PlayerTimer8_Expire_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_PlayerTimer8 takes nothing returns nothing
    call Register_PlayerTimer8_Expire()
endfunction

endlibrary
