library TStats
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Stats_RefreshOnEvent=null
endglobals

function Trig_Stats_RefreshOnEvent_Actions takes nothing returns nothing
    call StartTimerBJ(udg_StatsRefreshTimer,false,.01)
endfunction

// World Editor calls InitTrig_Stats automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Stats (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Stats takes nothing returns nothing
endfunction

function Register_Stats_RefreshOnEvent takes nothing returns nothing
    set gg_trg_Stats_RefreshOnEvent=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Stats_RefreshOnEvent,EVENT_PLAYER_HERO_LEVEL)
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Stats_RefreshOnEvent,EVENT_PLAYER_UNIT_SELL)
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Stats_RefreshOnEvent,EVENT_PLAYER_HERO_SKILL)
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Stats_RefreshOnEvent,EVENT_PLAYER_UNIT_PICKUP_ITEM)
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Stats_RefreshOnEvent,EVENT_PLAYER_UNIT_DROP_ITEM)
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Stats_RefreshOnEvent,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddAction(gg_trg_Stats_RefreshOnEvent,function Trig_Stats_RefreshOnEvent_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Stats takes nothing returns nothing
    call Register_Stats_RefreshOnEvent()
endfunction

endlibrary
