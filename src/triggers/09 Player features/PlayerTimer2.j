library TPlayerTimer2
function Trig_PlayerTimer2_Expire_Actions takes nothing returns nothing
    set udg_TempInteger=2
    call ConditionalTriggerExecute(gg_trg_Fishing_Tick)
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_PlayerTimer2 takes nothing returns nothing
endfunction
function RegisterR11_PlayerTimer2_Expire takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_PlayerTimer2_Expire=CreateTrigger()
    call TriggerRegisterTimerExpireEventBJ(gg_trg_PlayerTimer2_Expire,udg_FishingTimer[2])
    call TriggerAddAction(gg_trg_PlayerTimer2_Expire,function Trig_PlayerTimer2_Expire_Actions)
endfunction




endlibrary
