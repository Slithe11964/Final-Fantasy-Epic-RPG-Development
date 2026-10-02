library TPlayerTimer5
function Trig_PlayerTimer5_Expire_Actions takes nothing returns nothing
    set udg_TempInteger=5
    call ConditionalTriggerExecute(gg_trg_Fishing_Tick)
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_PlayerTimer5 takes nothing returns nothing
endfunction
function RegisterR11_PlayerTimer5_Expire takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_PlayerTimer5_Expire=CreateTrigger()
    call TriggerRegisterTimerExpireEventBJ(gg_trg_PlayerTimer5_Expire,udg_FishingTimer[5])
    call TriggerAddAction(gg_trg_PlayerTimer5_Expire,function Trig_PlayerTimer5_Expire_Actions)
endfunction




endlibrary
