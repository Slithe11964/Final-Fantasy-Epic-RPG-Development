library TMana
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

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Mana takes nothing returns nothing
endfunction
function RegisterR11_Mana_Restore_Delayed takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Mana_Restore_Delayed=CreateTrigger()
    call DisableTrigger(gg_trg_Mana_Restore_Delayed)
    call TriggerRegisterTimerExpireEventBJ(gg_trg_Mana_Restore_Delayed,udg_ManaRefundTimer)
    call TriggerAddAction(gg_trg_Mana_Restore_Delayed,function Trig_Mana_Restore_Delayed_Actions)
endfunction
function RegisterR11_Mana_Spring_Register takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Mana_Spring_Register=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Mana_Spring_Register,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Mana_Spring_Register,Condition(function Trig_Mana_Spring_Register_Conditions))
    call TriggerAddAction(gg_trg_Mana_Spring_Register,function Trig_Mana_Spring_Register_Actions)
endfunction




endlibrary
