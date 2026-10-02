library TPlayerTimer1
function Trig_PlayerTimer1_Expire_Actions takes nothing returns nothing
    set udg_TempInteger=1
    call ConditionalTriggerExecute(gg_trg_Fishing_Tick)
endfunction

// World Editor calls InitTrig_PlayerTimer1 automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_PlayerTimer1 (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_PlayerTimer1 takes nothing returns nothing
endfunction

function Register_PlayerTimer1_Expire takes nothing returns nothing
    set gg_trg_PlayerTimer1_Expire=CreateTrigger()
    call TriggerRegisterTimerExpireEventBJ(gg_trg_PlayerTimer1_Expire,udg_FishingTimer[1])
    call TriggerAddAction(gg_trg_PlayerTimer1_Expire,function Trig_PlayerTimer1_Expire_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_PlayerTimer1 takes nothing returns nothing
    call Register_PlayerTimer1_Expire()
endfunction

endlibrary
