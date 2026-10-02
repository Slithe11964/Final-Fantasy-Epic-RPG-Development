library TReminder
function Trig_Reminder_Periodic_Actions takes nothing returns nothing
    call DisplayTimedTextToForce(udg_PlayingPlayers,60.,"|cffb9d1eaLooking for help or discussion related to this map?|r\r\n|cffb9d1eaCheck out the Wiki:|r |cff0000cdfferpg.wikia.com|r\r\n|cffb9d1eaTalk about it in the Forums:|r |cff0000cdfferpg.forumotion.com|r\r\n|cffb9d1eaJoin our Discord:|r |cff0000cddiscord.gg/jXA8DHv|r")
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Reminder takes nothing returns nothing
endfunction

function RegisterR11_Reminder_Periodic takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Reminder_Periodic=CreateTrigger()

call TriggerRegisterTimerEventPeriodic(gg_trg_Reminder_Periodic,2700.)

call TriggerAddAction(gg_trg_Reminder_Periodic,function Trig_Reminder_Periodic_Actions)

endfunction




endlibrary
