library THour
function Trig_Hour_Timer_Rollover_Actions takes nothing returns nothing
    call StartTimerBJ(udg_GameClock,false,3600.)
    set udg_GameHours=(udg_GameHours+1)
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Hour takes nothing returns nothing
endfunction
function RegisterR11_Hour_Timer_Rollover takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Hour_Timer_Rollover=CreateTrigger()
    call TriggerRegisterTimerExpireEventBJ(gg_trg_Hour_Timer_Rollover,udg_GameClock)
    call TriggerAddAction(gg_trg_Hour_Timer_Rollover,function Trig_Hour_Timer_Rollover_Actions)
endfunction




endlibrary
