library TStats
function Trig_Stats_RefreshOnEvent_Actions takes nothing returns nothing
    call StartTimerBJ(udg_StatsRefreshTimer,false,.01)
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Stats takes nothing returns nothing
endfunction

function RegisterR11_Stats_RefreshOnEvent takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Stats_RefreshOnEvent=CreateTrigger()

call TriggerRegisterAnyUnitEventBJ(gg_trg_Stats_RefreshOnEvent,EVENT_PLAYER_HERO_LEVEL)

call TriggerRegisterAnyUnitEventBJ(gg_trg_Stats_RefreshOnEvent,EVENT_PLAYER_UNIT_SELL)

call TriggerRegisterAnyUnitEventBJ(gg_trg_Stats_RefreshOnEvent,EVENT_PLAYER_HERO_SKILL)

call TriggerRegisterAnyUnitEventBJ(gg_trg_Stats_RefreshOnEvent,EVENT_PLAYER_UNIT_PICKUP_ITEM)

call TriggerRegisterAnyUnitEventBJ(gg_trg_Stats_RefreshOnEvent,EVENT_PLAYER_UNIT_DROP_ITEM)

call TriggerRegisterAnyUnitEventBJ(gg_trg_Stats_RefreshOnEvent,EVENT_PLAYER_UNIT_SPELL_EFFECT)

call TriggerAddAction(gg_trg_Stats_RefreshOnEvent,function Trig_Stats_RefreshOnEvent_Actions)

endfunction




endlibrary
