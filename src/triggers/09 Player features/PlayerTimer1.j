library TPlayerTimer1
function Trig_PlayerTimer1_Expire_Actions takes nothing returns nothing
    set udg_TempInteger=1
    call ConditionalTriggerExecute(gg_trg_Fishing_Tick)
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_PlayerTimer1 takes nothing returns nothing
endfunction
function RegisterR11_PlayerTimer1_Expire takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_PlayerTimer1_Expire=CreateTrigger()
    call TriggerRegisterTimerExpireEventBJ(gg_trg_PlayerTimer1_Expire,udg_FishingTimer[1])
    call TriggerAddAction(gg_trg_PlayerTimer1_Expire,function Trig_PlayerTimer1_Expire_Actions)
endfunction




endlibrary
