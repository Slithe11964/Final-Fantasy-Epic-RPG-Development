library TPlayerTimer3
function Trig_PlayerTimer3_Expire_Actions takes nothing returns nothing
    set udg_TempInteger=3
    call ConditionalTriggerExecute(gg_trg_Fishing_Tick)
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_PlayerTimer3 takes nothing returns nothing
endfunction
function RegisterR11_PlayerTimer3_Expire takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_PlayerTimer3_Expire=CreateTrigger()
    call TriggerRegisterTimerExpireEventBJ(gg_trg_PlayerTimer3_Expire,udg_FishingTimer[3])
    call TriggerAddAction(gg_trg_PlayerTimer3_Expire,function Trig_PlayerTimer3_Expire_Actions)
endfunction




endlibrary
