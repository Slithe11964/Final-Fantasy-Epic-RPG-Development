library TRamuh
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Ramuh_Setup=null
endglobals

function Trig_Ramuh_Setup_Actions takes nothing returns nothing
    set udg_SpecialEffect[48]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_n020_0129,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call SetUnitInvulnerable(gg_unit_n020_0129,true)
    call ShowUnitHide(gg_unit_n01Z_0127)
    call PauseUnitBJ(true,gg_unit_n01Z_0127)
    call SetUnitInvulnerable(gg_unit_n01Z_0127,true)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_Ramuh automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Ramuh (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Ramuh takes nothing returns nothing
endfunction

function Register_Ramuh_Setup takes nothing returns nothing
    set gg_trg_Ramuh_Setup=CreateTrigger()
    call TriggerAddAction(gg_trg_Ramuh_Setup,function Trig_Ramuh_Setup_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Ramuh takes nothing returns nothing
    call Register_Ramuh_Setup()
endfunction

endlibrary
