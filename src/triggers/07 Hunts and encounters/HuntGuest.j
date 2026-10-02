library THuntGuest
function Trig_HuntGuest_DefaultKrjn_Actions takes nothing returns nothing
    set udg_NaishaTownUnit=gg_unit_e012_0227
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_HuntGuest takes nothing returns nothing
endfunction

function RegisterR11_HuntGuest_DefaultKrjn takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_HuntGuest_DefaultKrjn=CreateTrigger()

call TriggerRegisterTimerEventSingle(gg_trg_HuntGuest_DefaultKrjn,12.)

call TriggerAddAction(gg_trg_HuntGuest_DefaultKrjn,function Trig_HuntGuest_DefaultKrjn_Actions)

endfunction




endlibrary
