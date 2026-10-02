library TManaRefund requires TPlayerPart01, TSpellShared
function Trig_ManaRefund_Cast_Conditions takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A03D',GetTriggerUnit())>0)and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(GetTriggerUnit()==Player_GetHero(GetOwningPlayer(GetTriggerUnit()))) // 'A03D': ability "Refund Mana"
endfunction

function Trig_ManaRefund_Cast_Cond_HasManaCost takes nothing returns boolean
    return(udg_SpellManaCost>0)
endfunction

function Trig_ManaRefund_Cast_Actions takes nothing returns nothing
    call Spell_StoreManaCost()
    if(Trig_ManaRefund_Cast_Cond_HasManaCost())then
        // Result 1: the smaller of (udg_SpellManaCost) and (GetPlayerState(GetOwningPlayer(the triggering unit),
        // PLAYER_STATE_RESOURCE_GOLD)).
        set udg_TempInteger=IMinBJ(udg_SpellManaCost,GetPlayerState(GetOwningPlayer(GetTriggerUnit()),PLAYER_STATE_RESOURCE_GOLD))
        // (-1) times (udg_TempInteger).
        call AdjustPlayerStateBJ((-1*udg_TempInteger),GetOwningPlayer(GetTriggerUnit()),PLAYER_STATE_RESOURCE_GOLD)
        // Udg_TempInteger treated as a decimal-capable number.
        set udg_ManaRefundGold=I2R(udg_TempInteger)
        set udg_ManaRefundUnit=GetTriggerUnit()
        call EnableTrigger(gg_trg_Mana_Restore_Delayed)
        call StartTimerBJ(udg_ManaRefundTimer,false,.01)
    endif
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_ManaRefund takes nothing returns nothing
endfunction
function RegisterR11_ManaRefund_Cast takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_ManaRefund_Cast=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_ManaRefund_Cast,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_ManaRefund_Cast,Condition(function Trig_ManaRefund_Cast_Conditions))
    call TriggerAddAction(gg_trg_ManaRefund_Cast,function Trig_ManaRefund_Cast_Actions)
endfunction




endlibrary
