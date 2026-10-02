library TShadowSupport
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Shadow_HeroDrink=null
endglobals

function Trig_Shadow_HeroDrink_Conditions takes nothing returns boolean
    return(GetSpellTargetUnit()==udg_ShadowUnit)and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(GetSpellAbilityId()=='A0FZ') // 'A0FZ': ability "Toss Hero Drink"
endfunction

function Trig_Shadow_HeroDrink_Actions takes nothing returns nothing
    // Increase udg_ShadowLoyalty by 3.
    set udg_ShadowLoyalty=(udg_ShadowLoyalty+3)
endfunction

function InitTrig_Shadow_Support takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Shadow (module Shadow),
// which keeps the original registration order.

function Register_Shadow_HeroDrink takes nothing returns nothing
    set gg_trg_Shadow_HeroDrink=CreateTrigger()
    call DisableTrigger(gg_trg_Shadow_HeroDrink)
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Shadow_HeroDrink,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Shadow_HeroDrink,Condition(function Trig_Shadow_HeroDrink_Conditions))
    call TriggerAddAction(gg_trg_Shadow_HeroDrink,function Trig_Shadow_HeroDrink_Actions)
endfunction

endlibrary
