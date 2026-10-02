library THolyKnight
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_HolyKnight_Setup=null
endglobals

function Trig_HolyKnight_Setup_Actions takes nothing returns nothing
    call SetUnitInvulnerable(gg_unit_Eill_0119,true)
    call ShowUnitHide(gg_unit_Ewrd_0120)
    call PauseUnitBJ(true,gg_unit_Ewrd_0120)
    call SetUnitInvulnerable(gg_unit_Ewrd_0120,true)
    call UnitAddAbilityBJ('A0VJ',gg_unit_Ewrd_0120) // 'A0VJ': ability "Unaffected by Cinematics"
    call ShowUnitHide(gg_unit_e009_0118)
    call PauseUnitBJ(true,gg_unit_e009_0118)
    call SetUnitInvulnerable(gg_unit_e009_0118,true)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_HolyKnight automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_HolyKnight (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_HolyKnight takes nothing returns nothing
endfunction

function Register_HolyKnight_Setup takes nothing returns nothing
    set gg_trg_HolyKnight_Setup=CreateTrigger()
    call TriggerAddAction(gg_trg_HolyKnight_Setup,function Trig_HolyKnight_Setup_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_HolyKnight takes nothing returns nothing
    call Register_HolyKnight_Setup() // run by MapBootstrap
endfunction

endlibrary
