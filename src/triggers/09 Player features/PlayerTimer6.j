library TPlayerTimer6
function Trig_PlayerTimer6_Expire_Actions takes nothing returns nothing
    set udg_TempInteger=6
    call ConditionalTriggerExecute(gg_trg_Fishing_Tick)
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_PlayerTimer6 takes nothing returns nothing
endfunction
function RegisterR11_PlayerTimer6_Expire takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_PlayerTimer6_Expire=CreateTrigger()
    call TriggerRegisterTimerExpireEventBJ(gg_trg_PlayerTimer6_Expire,udg_FishingTimer[6])
    call TriggerAddAction(gg_trg_PlayerTimer6_Expire,function Trig_PlayerTimer6_Expire_Actions)
endfunction




endlibrary
