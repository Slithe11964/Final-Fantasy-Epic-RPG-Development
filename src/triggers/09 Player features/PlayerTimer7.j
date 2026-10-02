library TPlayerTimer7
function Trig_PlayerTimer7_Expire_Actions takes nothing returns nothing
    set udg_TempInteger=7
    call ConditionalTriggerExecute(gg_trg_Fishing_Tick)
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_PlayerTimer7 takes nothing returns nothing
endfunction

function RegisterR11_PlayerTimer7_Expire takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_PlayerTimer7_Expire=CreateTrigger()

call TriggerRegisterTimerExpireEventBJ(gg_trg_PlayerTimer7_Expire,udg_FishingTimer[7])

call TriggerAddAction(gg_trg_PlayerTimer7_Expire,function Trig_PlayerTimer7_Expire_Actions)

endfunction




endlibrary
