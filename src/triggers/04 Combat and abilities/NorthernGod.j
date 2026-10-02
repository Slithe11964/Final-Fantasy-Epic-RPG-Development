library TNorthernGod
function Trig_NorthernGod_Setup_Actions takes nothing returns nothing
    call ShowUnitHide(gg_unit_H01M_0071)
    call PauseUnitBJ(true,gg_unit_H01M_0071)
    call SetUnitInvulnerable(gg_unit_H01M_0071,true)
    call ShowUnitHide(gg_unit_E01O_0268)
    call PauseUnitBJ(true,gg_unit_E01O_0268)
    call SetUnitInvulnerable(gg_unit_E01O_0268,true)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_NorthernGod takes nothing returns nothing
endfunction

function RegisterR11_NorthernGod_Setup takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_NorthernGod_Setup=CreateTrigger()

call TriggerAddAction(gg_trg_NorthernGod_Setup,function Trig_NorthernGod_Setup_Actions)

endfunction




endlibrary
