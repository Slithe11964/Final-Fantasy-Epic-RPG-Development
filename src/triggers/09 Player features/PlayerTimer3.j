library TPlayerTimer3
function Trig_PlayerTimer3_Expire_Actions takes nothing returns nothing
    set udg_TempInteger=3
    call ConditionalTriggerExecute(gg_trg_Fishing_Tick)
endfunction

// World Editor calls InitTrig_PlayerTimer3 automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_PlayerTimer3 (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_PlayerTimer3 takes nothing returns nothing
endfunction

function Register_PlayerTimer3_Expire takes nothing returns nothing
    set gg_trg_PlayerTimer3_Expire=CreateTrigger()
    call TriggerRegisterTimerExpireEventBJ(gg_trg_PlayerTimer3_Expire,udg_FishingTimer[3])
    call TriggerAddAction(gg_trg_PlayerTimer3_Expire,function Trig_PlayerTimer3_Expire_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_PlayerTimer3 takes nothing returns nothing
    call Register_PlayerTimer3_Expire()
endfunction

endlibrary
