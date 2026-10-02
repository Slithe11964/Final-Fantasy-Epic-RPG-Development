library TPlayerTimer7
function Trig_PlayerTimer7_Expire_Actions takes nothing returns nothing
    set udg_TempInteger=7
    call ConditionalTriggerExecute(gg_trg_Fishing_Tick)
endfunction

// World Editor calls InitTrig_PlayerTimer7 automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_PlayerTimer7 (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_PlayerTimer7 takes nothing returns nothing
endfunction

function Register_PlayerTimer7_Expire takes nothing returns nothing
    set gg_trg_PlayerTimer7_Expire=CreateTrigger()
    call TriggerRegisterTimerExpireEventBJ(gg_trg_PlayerTimer7_Expire,udg_FishingTimer[7])
    call TriggerAddAction(gg_trg_PlayerTimer7_Expire,function Trig_PlayerTimer7_Expire_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_PlayerTimer7 takes nothing returns nothing
    call Register_PlayerTimer7_Expire()
endfunction

endlibrary
