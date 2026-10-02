library TCowKing
function Trig_CowKing_Hide_Actions takes nothing returns nothing
    set udg_PortalRitualActive=false
    call ShowUnitHide(gg_unit_O00I_0239)
    call PauseUnitBJ(true,gg_unit_O00I_0239)
    call SetUnitInvulnerable(gg_unit_O00I_0239,true)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_CowKing takes nothing returns nothing
endfunction
function RegisterR11_CowKing_Hide takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_CowKing_Hide=CreateTrigger()
    call TriggerAddAction(gg_trg_CowKing_Hide,function Trig_CowKing_Hide_Actions)
endfunction




endlibrary
