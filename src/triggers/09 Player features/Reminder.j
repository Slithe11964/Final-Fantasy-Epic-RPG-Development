library TReminder
function Trig_Reminder_Periodic_Actions takes nothing returns nothing
    call DisplayTimedTextToForce(udg_PlayingPlayers,60.,"|cffb9d1eaLooking for help or discussion related to this map?|r\r\n|cffb9d1eaCheck out the Wiki:|r |cff0000cdfferpg.wikia.com|r\r\n|cffb9d1eaTalk about it in the Forums:|r |cff0000cdfferpg.forumotion.com|r\r\n|cffb9d1eaJoin our Discord:|r |cff0000cddiscord.gg/jXA8DHv|r")
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
