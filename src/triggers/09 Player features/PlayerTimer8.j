library TPlayerTimer8
function Trig_PlayerTimer8_Expire_Actions takes nothing returns nothing
    set udg_TempInteger=8
    call ConditionalTriggerExecute(gg_trg_Fishing_Tick)
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_PlayerTimer8 takes nothing returns nothing
endfunction

function RegisterR11_PlayerTimer8_Expire takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_PlayerTimer8_Expire=CreateTrigger()

call TriggerRegisterTimerExpireEventBJ(gg_trg_PlayerTimer8_Expire,udg_FishingTimer[8])

call TriggerAddAction(gg_trg_PlayerTimer8_Expire,function Trig_PlayerTimer8_Expire_Actions)

endfunction




endlibrary
