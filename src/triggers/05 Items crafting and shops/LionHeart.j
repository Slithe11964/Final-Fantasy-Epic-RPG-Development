library TLionHeart
function Trig_LionHeart_LowLifeBonus_Conditions takes nothing returns boolean
    // Result 1: current health divided by maximum health for GetAttacker(), times 100 (or 0 if the unit is missing
    // or its maximum is 0).
    return((IsUnitIllusionBJ(GetAttacker())==false)and(IsUnitType(GetAttacker(),UNIT_TYPE_HERO))and(UnitHasItemOfTypeBJ(GetAttacker(),'I066'))and(GetUnitStateSwap(UNIT_STATE_MANA,GetAttacker())>=.0)and(GetUnitLifePercent(GetAttacker())<=30.))!=null // 'I066': item "Lion Heart"
endfunction

function Trig_LionHeart_LowLifeBonus_Actions takes nothing returns nothing
    call UnitAddItemByIdSwapped('I0F1',GetAttacker()) // 'I0F1': item "Lion Heart Bonus"
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_LionHeart takes nothing returns nothing
endfunction

function RegisterR11_LionHeart_LowLifeBonus takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_LionHeart_LowLifeBonus=CreateTrigger()

call TriggerRegisterAnyUnitEventBJ(gg_trg_LionHeart_LowLifeBonus,EVENT_PLAYER_UNIT_ATTACKED)

call TriggerAddCondition(gg_trg_LionHeart_LowLifeBonus,Condition(function Trig_LionHeart_LowLifeBonus_Conditions))

call TriggerAddAction(gg_trg_LionHeart_LowLifeBonus,function Trig_LionHeart_LowLifeBonus_Actions)

endfunction




endlibrary
