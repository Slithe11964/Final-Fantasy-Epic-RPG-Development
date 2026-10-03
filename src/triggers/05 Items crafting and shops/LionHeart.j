library TLionHeart
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_LionHeart_LowLifeBonus=null
endglobals

function Trig_LionHeart_LowLifeBonus_Conditions takes nothing returns boolean
    return((IsUnitIllusionBJ(GetAttacker())==false)and(IsUnitType(GetAttacker(),UNIT_TYPE_HERO))and(UnitHasItemOfTypeBJ(GetAttacker(),'I066'))and(GetUnitStateSwap(UNIT_STATE_MANA,GetAttacker())>=.0)and(GetUnitLifePercent(GetAttacker())<=30.))!=null // 'I066': item "Lion Heart"
endfunction

function Trig_LionHeart_LowLifeBonus_Actions takes nothing returns nothing
    call UnitAddItemByIdSwapped('I0F1',GetAttacker()) // 'I0F1': item "Lion Heart Bonus"
endfunction

// World Editor calls InitTrig_LionHeart automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_LionHeart (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_LionHeart takes nothing returns nothing
endfunction

function Register_LionHeart_LowLifeBonus takes nothing returns nothing
    set gg_trg_LionHeart_LowLifeBonus=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_LionHeart_LowLifeBonus,EVENT_PLAYER_UNIT_ATTACKED)
    call TriggerAddCondition(gg_trg_LionHeart_LowLifeBonus,Condition(function Trig_LionHeart_LowLifeBonus_Conditions))
    call TriggerAddAction(gg_trg_LionHeart_LowLifeBonus,function Trig_LionHeart_LowLifeBonus_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_LionHeart takes nothing returns nothing
    call Register_LionHeart_LowLifeBonus()
endfunction

endlibrary
