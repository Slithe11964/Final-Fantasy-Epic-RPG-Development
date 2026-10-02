library TEidolonChallenge
function Trig_EidolonChallenge_Setup_Actions takes nothing returns nothing
    call ShowUnitHide(gg_unit_H01I_0070)
    call PauseUnitBJ(true,gg_unit_H01I_0070)
    call SetUnitInvulnerable(gg_unit_H01I_0070,true)
    call ShowUnitHide(gg_unit_H01J_0069)
    call PauseUnitBJ(true,gg_unit_H01J_0069)
    call SetUnitInvulnerable(gg_unit_H01J_0069,true)
    call ShowUnitHide(gg_unit_H01K_0068)
    call PauseUnitBJ(true,gg_unit_H01K_0068)
    call SetUnitInvulnerable(gg_unit_H01K_0068,true)
    call ShowUnitHide(gg_unit_H01L_0067)
    call PauseUnitBJ(true,gg_unit_H01L_0067)
    call SetUnitInvulnerable(gg_unit_H01L_0067,true)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_EidolonChallenge automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_EidolonChallenge (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_EidolonChallenge takes nothing returns nothing
endfunction

function Register_EidolonChallenge_Setup takes nothing returns nothing
    set gg_trg_EidolonChallenge_Setup=CreateTrigger()
    call TriggerAddAction(gg_trg_EidolonChallenge_Setup,function Trig_EidolonChallenge_Setup_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_EidolonChallenge takes nothing returns nothing
    call Register_EidolonChallenge_Setup()
endfunction

endlibrary
