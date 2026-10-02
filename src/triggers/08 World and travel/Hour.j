library THour
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Hour_Timer_Rollover=null
endglobals

function Trig_Hour_Timer_Rollover_Actions takes nothing returns nothing
    call StartTimerBJ(udg_GameClock,false,3600.)
    set udg_GameHours=(udg_GameHours+1)
endfunction

// World Editor calls InitTrig_Hour automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Hour (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Hour takes nothing returns nothing
endfunction

function Register_Hour_Timer_Rollover takes nothing returns nothing
    set gg_trg_Hour_Timer_Rollover=CreateTrigger()
    call TriggerRegisterTimerExpireEventBJ(gg_trg_Hour_Timer_Rollover,udg_GameClock)
    call TriggerAddAction(gg_trg_Hour_Timer_Rollover,function Trig_Hour_Timer_Rollover_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Hour takes nothing returns nothing
    call Register_Hour_Timer_Rollover()
endfunction

endlibrary
