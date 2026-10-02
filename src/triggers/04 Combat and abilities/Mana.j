library TMana
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Mana_Restore_Delayed=null
    trigger gg_trg_Mana_Spring_Register=null
endglobals

function Trig_Mana_Restore_Delayed_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    // (current mana of udg_ManaRefundUnit) plus (udg_ManaRefundGold).
    call SetUnitManaBJ(udg_ManaRefundUnit,(GetUnitStateSwap(UNIT_STATE_MANA,udg_ManaRefundUnit)+udg_ManaRefundGold))
endfunction

function Trig_Mana_Spring_Register_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A06D') // 'A06D': ability "Mana Spring"
endfunction

function Trig_Mana_Spring_Register_Actions takes nothing returns nothing
    call GroupAddUnitSimple(GetTriggerUnit(),udg_RegenGroup)
endfunction

// World Editor calls InitTrig_Mana automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Mana_Part1 / RegisterTriggers_Mana_Part2 (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Mana takes nothing returns nothing
endfunction

function Register_Mana_Restore_Delayed takes nothing returns nothing
    set gg_trg_Mana_Restore_Delayed=CreateTrigger()
    call DisableTrigger(gg_trg_Mana_Restore_Delayed)
    call TriggerRegisterTimerExpireEventBJ(gg_trg_Mana_Restore_Delayed,udg_ManaRefundTimer)
    call TriggerAddAction(gg_trg_Mana_Restore_Delayed,function Trig_Mana_Restore_Delayed_Actions)
endfunction

function Register_Mana_Spring_Register takes nothing returns nothing
    set gg_trg_Mana_Spring_Register=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Mana_Spring_Register,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Mana_Spring_Register,Condition(function Trig_Mana_Spring_Register_Conditions))
    call TriggerAddAction(gg_trg_Mana_Spring_Register,function Trig_Mana_Spring_Register_Actions)
endfunction

// Creates part 1 of 2 of this module's triggers. Called once at startup from
// Startup_RegisterTriggers (MapBootstrap). The parts are registered at different points so that
// triggers sharing an event with other modules keep their original firing order.
function RegisterTriggers_Mana_Part1 takes nothing returns nothing
    call Register_Mana_Restore_Delayed() // starts off; enabled by ManaRefund
endfunction

// Creates part 2 of 2 of this module's triggers. Called once at startup from
// Startup_RegisterTriggers (MapBootstrap). The parts are registered at different points so that
// triggers sharing an event with other modules keep their original firing order.
function RegisterTriggers_Mana_Part2 takes nothing returns nothing
    call Register_Mana_Spring_Register()
endfunction

endlibrary
