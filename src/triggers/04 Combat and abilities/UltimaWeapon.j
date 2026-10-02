library TUltimaWeapon
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_UltimaWeapon_Hide=null
endglobals

function Trig_UltimaWeapon_Hide_Actions takes nothing returns nothing
    call ShowUnitHide(gg_unit_Nman_0151)
    call SetUnitInvulnerable(gg_unit_Nman_0151,true)
    call PauseUnitBJ(true,gg_unit_Nman_0151)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_UltimaWeapon automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_UltimaWeapon (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_UltimaWeapon takes nothing returns nothing
endfunction

function Register_UltimaWeapon_Hide takes nothing returns nothing
    set gg_trg_UltimaWeapon_Hide=CreateTrigger()
    call TriggerAddAction(gg_trg_UltimaWeapon_Hide,function Trig_UltimaWeapon_Hide_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_UltimaWeapon takes nothing returns nothing
    call Register_UltimaWeapon_Hide()
endfunction

endlibrary
