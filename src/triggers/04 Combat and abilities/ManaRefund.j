library TManaRefund requires TPlayerHero, TSpellShared
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_ManaRefund_Cast=null
endglobals

function Trig_ManaRefund_Cast_Conditions takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A03D',GetTriggerUnit())>0)and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(GetTriggerUnit()==Player_GetHero(GetOwningPlayer(GetTriggerUnit()))) // 'A03D': ability "Refund Mana"
endfunction

function Trig_ManaRefund_Cast_Cond_HasManaCost takes nothing returns boolean
    return(udg_SpellManaCost>0)
endfunction

function Trig_ManaRefund_Cast_Actions takes nothing returns nothing
    call Spell_StoreManaCost()
    if(Trig_ManaRefund_Cast_Cond_HasManaCost())then
        set udg_TempInteger=IMinBJ(udg_SpellManaCost,GetPlayerState(GetOwningPlayer(GetTriggerUnit()),PLAYER_STATE_RESOURCE_GOLD))
        call AdjustPlayerStateBJ((-1*udg_TempInteger),GetOwningPlayer(GetTriggerUnit()),PLAYER_STATE_RESOURCE_GOLD)
        set udg_ManaRefundGold=I2R(udg_TempInteger)
        set udg_ManaRefundUnit=GetTriggerUnit()
        call EnableTrigger(gg_trg_Mana_Restore_Delayed)
        call StartTimerBJ(udg_ManaRefundTimer,false,.01)
    endif
endfunction

// World Editor calls InitTrig_ManaRefund automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_ManaRefund (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_ManaRefund takes nothing returns nothing
endfunction

function Register_ManaRefund_Cast takes nothing returns nothing
    set gg_trg_ManaRefund_Cast=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_ManaRefund_Cast,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_ManaRefund_Cast,Condition(function Trig_ManaRefund_Cast_Conditions))
    call TriggerAddAction(gg_trg_ManaRefund_Cast,function Trig_ManaRefund_Cast_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_ManaRefund takes nothing returns nothing
    call Register_ManaRefund_Cast()
endfunction

endlibrary
