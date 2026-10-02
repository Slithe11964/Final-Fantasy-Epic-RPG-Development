library TUltimaWeapon
function Trig_UltimaWeapon_Hide_Actions takes nothing returns nothing
    call ShowUnitHide(gg_unit_Nman_0151)
    call SetUnitInvulnerable(gg_unit_Nman_0151,true)
    call PauseUnitBJ(true,gg_unit_Nman_0151)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_UltimaWeapon takes nothing returns nothing
endfunction
function RegisterR11_UltimaWeapon_Hide takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_UltimaWeapon_Hide=CreateTrigger()
    call TriggerAddAction(gg_trg_UltimaWeapon_Hide,function Trig_UltimaWeapon_Hide_Actions)
endfunction




endlibrary
