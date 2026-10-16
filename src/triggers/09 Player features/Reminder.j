library TReminder
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Reminder_Periodic=null
endglobals

function Trig_Reminder_Periodic_Actions takes nothing returns nothing
    call DisplayTimedTextToForce(udg_PlayingPlayers,60.,"Looking for help related to this map?|r\r\n|Check out the Wiki: fferpg.wikia.com|r\r\n|Join our Discord:discord.gg/gYR4t3m3hK|r")
endfunction

// World Editor calls InitTrig_Reminder automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Reminder (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Reminder takes nothing returns nothing
endfunction

function Register_Reminder_Periodic takes nothing returns nothing
    set gg_trg_Reminder_Periodic=CreateTrigger()
    call TriggerRegisterTimerEventPeriodic(gg_trg_Reminder_Periodic,2700.)
    call TriggerAddAction(gg_trg_Reminder_Periodic,function Trig_Reminder_Periodic_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Reminder takes nothing returns nothing
    call Register_Reminder_Periodic()
endfunction

endlibrary
