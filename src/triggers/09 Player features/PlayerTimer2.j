library TPlayerTimer2
function Trig_PlayerTimer2_Expire_Actions takes nothing returns nothing
    set udg_TempInteger=2
    call ConditionalTriggerExecute(gg_trg_Fishing_Tick)
endfunction

// World Editor calls InitTrig_PlayerTimer2 automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_PlayerTimer2 (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_PlayerTimer2 takes nothing returns nothing
endfunction

function Register_PlayerTimer2_Expire takes nothing returns nothing
    set gg_trg_PlayerTimer2_Expire=CreateTrigger()
    call TriggerRegisterTimerExpireEventBJ(gg_trg_PlayerTimer2_Expire,udg_FishingTimer[2])
    call TriggerAddAction(gg_trg_PlayerTimer2_Expire,function Trig_PlayerTimer2_Expire_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_PlayerTimer2 takes nothing returns nothing
    call Register_PlayerTimer2_Expire()
endfunction

endlibrary
