library TFallenRanger
function Trig_FallenRanger_Setup_Actions takes nothing returns nothing
    call ShowUnitHide(gg_unit_H00X_0133)
    call PauseUnitBJ(true,gg_unit_H00X_0133)
    call SetUnitInvulnerable(gg_unit_H00X_0133,true)
    call ShowUnitHide(gg_unit_H00Y_0022)
    call PauseUnitBJ(true,gg_unit_H00Y_0022)
    call SetUnitInvulnerable(gg_unit_H00Y_0022,true)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_FallenRanger takes nothing returns nothing
endfunction

function RegisterR11_FallenRanger_Setup takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_FallenRanger_Setup=CreateTrigger()

call TriggerAddAction(gg_trg_FallenRanger_Setup,function Trig_FallenRanger_Setup_Actions)

endfunction




endlibrary
