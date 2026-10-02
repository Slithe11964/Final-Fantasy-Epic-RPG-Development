library TTonberry
function Trig_Tonberry_Gate_Open_Actions takes nothing returns nothing
    call ModifyGateBJ(bj_GATEOPERATION_OPEN,gg_dest_ATg3_0012)
    call RemoveDestructable(gg_dest_Dofw_0016)
    call ShowUnitShow(gg_unit_Nman_0151)
    call PauseUnitBJ(false,gg_unit_Nman_0151)
    call SetUnitInvulnerable(gg_unit_Nman_0151,false)
    call EnableTrigger(gg_trg_Quest_UltimaWeapon_Start)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Tonberry takes nothing returns nothing
endfunction
function RegisterR11_Tonberry_Gate_Open takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Tonberry_Gate_Open=CreateTrigger()
    call TriggerAddAction(gg_trg_Tonberry_Gate_Open,function Trig_Tonberry_Gate_Open_Actions)
endfunction




endlibrary
