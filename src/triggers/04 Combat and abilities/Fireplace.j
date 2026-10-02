library TFireplace
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Fireplace_Init=null
endglobals

function Trig_Fireplace_Init_Actions takes nothing returns nothing
    call UnitRemoveAbilityBJ('Aneu',gg_unit_n0KG_0263) // 'Aneu': standard ability reference "Neutral Building"
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_Fireplace automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Fireplace (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Fireplace takes nothing returns nothing
endfunction

function Register_Fireplace_Init takes nothing returns nothing
    set gg_trg_Fireplace_Init=CreateTrigger()
    call TriggerAddAction(gg_trg_Fireplace_Init,function Trig_Fireplace_Init_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Fireplace takes nothing returns nothing
    call Register_Fireplace_Init()
endfunction

endlibrary
