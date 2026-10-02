library TPlayerTimer6
function Trig_PlayerTimer6_Expire_Actions takes nothing returns nothing
    set udg_TempInteger=6
    call ConditionalTriggerExecute(gg_trg_Fishing_Tick)
endfunction

// World Editor calls InitTrig_PlayerTimer6 automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_PlayerTimer6 (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_PlayerTimer6 takes nothing returns nothing
endfunction

function Register_PlayerTimer6_Expire takes nothing returns nothing
    set gg_trg_PlayerTimer6_Expire=CreateTrigger()
    call TriggerRegisterTimerExpireEventBJ(gg_trg_PlayerTimer6_Expire,udg_FishingTimer[6])
    call TriggerAddAction(gg_trg_PlayerTimer6_Expire,function Trig_PlayerTimer6_Expire_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_PlayerTimer6 takes nothing returns nothing
    call Register_PlayerTimer6_Expire()
endfunction

endlibrary
