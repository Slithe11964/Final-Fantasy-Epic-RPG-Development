library TFirewood requires TForce, TGroup
function Trig_Firewood_Light_Fireplace_Conditions takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='I0BE') // 'I0BE': item "Firewood"
endfunction

function Trig_Firewood_Light_Fireplace_FilterUnlitFireplace takes nothing returns boolean
    return(GetUnitTypeId(GetFilterUnit())=='n0M1') // 'n0M1': unit "Fireplace"
endfunction

function Trig_Firewood_Light_Fireplace_NoFireplaceNearby takes nothing returns boolean
    return(IsUnitGroupEmptyBJ(udg_TempGroup))
endfunction

function Trig_Firewood_Light_Fireplace_RecipeRank3 takes nothing returns boolean
    return(udg_CookingStage>=3)
endfunction

function Trig_Firewood_Light_Fireplace_RecipeRank2 takes nothing returns boolean
    return(udg_CookingStage>=2)
endfunction

function Trig_Firewood_Light_Fireplace_FirewoodSpent takes nothing returns boolean
    return(GetItemCharges(GetManipulatedItem())<1)
endfunction

function Trig_Firewood_Light_Fireplace_Actions takes nothing returns nothing
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    set udg_TempGroup=Group_UnitsInRangeOfLoc(400.,udg_TempPoint,Condition(function Trig_Firewood_Light_Fireplace_FilterUnlitFireplace))
    call RemoveLocation(udg_TempPoint)
    if(Trig_Firewood_Light_Fireplace_NoFireplaceNearby())then
        call DestroyGroup(udg_TempGroup)
        // (item charges of the item being used or moved) plus (1).
        call SetItemCharges(GetManipulatedItem(),(GetItemCharges(GetManipulatedItem())+1))
        set udg_TempForce=Force_OfPlayer(GetOwningPlayer(GetTriggerUnit()))
        call DisplayTimedTextToForce(udg_TempForce,10.,"There is no lightable fireplace nearby.")
        call DestroyForce(udg_TempForce)
        return
    endif
    call ReplaceUnitBJ(GroupPickRandomUnit(udg_TempGroup),'n0KG',bj_UNIT_STATE_METHOD_MAXIMUM) // 'n0KG': unit "Fireplace"
    call DestroyGroup(udg_TempGroup)
    call AddItemToStockBJ('I0B9',GetLastReplacedUnitBJ(),1,1) // 'I0B9': item "Recipe: Wild Bowl"
    call AddItemToStockBJ('I0CA',GetLastReplacedUnitBJ(),1,1) // 'I0CA': item "Recipe: Triton Pot"
    call AddItemToStockBJ('I0CB',GetLastReplacedUnitBJ(),1,1) // 'I0CB': item "Recipe: Tropical Dish"
    call AddItemToStockBJ('I0CC',GetLastReplacedUnitBJ(),1,1) // 'I0CC': item "Recipe: Fish Soup"
    call AddItemToStockBJ('I0CD',GetLastReplacedUnitBJ(),1,1) // 'I0CD': item "Recipe: Energy Brew"
    call AddItemToStockBJ('I0CE',GetLastReplacedUnitBJ(),1,1) // 'I0CE': item "Recipe: Swift Drink"
    if(Trig_Firewood_Light_Fireplace_RecipeRank2())then
        call AddItemToStockBJ('I0CF',GetLastReplacedUnitBJ(),1,1) // 'I0CF': item "Recipe: Spiced Salad"
        call AddItemToStockBJ('I0CG',GetLastReplacedUnitBJ(),1,1) // 'I0CG': item "Recipe: Nebra Bread"
        if(Trig_Firewood_Light_Fireplace_RecipeRank3())then
            call AddItemToStockBJ('I0CH',GetLastReplacedUnitBJ(),1,1) // 'I0CH': item "Recipe: First Class Meat Plate"
            call AddItemToStockBJ('I0CI',GetLastReplacedUnitBJ(),1,1) // 'I0CI': item "Recipe: Adamant Stew"
        endif
    endif
    if(Trig_Firewood_Light_Fireplace_FirewoodSpent())then
        call RemoveItem(GetManipulatedItem())
        call DestroyTrigger(GetTriggeringTrigger())
    endif
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Firewood takes nothing returns nothing
endfunction
function RegisterR11_Firewood_Light_Fireplace takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Firewood_Light_Fireplace=CreateTrigger()
    call DisableTrigger(gg_trg_Firewood_Light_Fireplace)
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Firewood_Light_Fireplace,EVENT_PLAYER_UNIT_USE_ITEM)
    call TriggerAddCondition(gg_trg_Firewood_Light_Fireplace,Condition(function Trig_Firewood_Light_Fireplace_Conditions))
    call TriggerAddAction(gg_trg_Firewood_Light_Fireplace,function Trig_Firewood_Light_Fireplace_Actions)
endfunction




endlibrary
