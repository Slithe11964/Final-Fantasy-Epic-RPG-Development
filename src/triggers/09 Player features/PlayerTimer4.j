library TPlayerTimer4
function Trig_PlayerTimer4_Expire_Actions takes nothing returns nothing
    set udg_TempInteger=4
    call ConditionalTriggerExecute(gg_trg_Fishing_Tick)
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_PlayerTimer4 takes nothing returns nothing
endfunction

function RegisterR11_PlayerTimer4_Expire takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_PlayerTimer4_Expire=CreateTrigger()

call TriggerRegisterTimerExpireEventBJ(gg_trg_PlayerTimer4_Expire,udg_FishingTimer[4])

call TriggerAddAction(gg_trg_PlayerTimer4_Expire,function Trig_PlayerTimer4_Expire_Actions)

endfunction




endlibrary
