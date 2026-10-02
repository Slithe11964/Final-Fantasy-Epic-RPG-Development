library TCooking requires TGroup
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Cooking_Recipes_UnlockAll=null
endglobals

function Trig_Cooking_Recipes_UnlockAll_AddTopRecipes takes nothing returns nothing
    call AddItemToStockBJ('I0CH',GetEnumUnit(),1,1) // 'I0CH': item "Recipe: First Class Meat Plate"
    call AddItemToStockBJ('I0CI',GetEnumUnit(),1,1) // 'I0CI': item "Recipe: Adamant Stew"
endfunction

function Trig_Cooking_Recipes_UnlockAll_RecipeRankIs2 takes nothing returns boolean
    return(udg_CookingStage==2)
endfunction

function Trig_Cooking_Recipes_UnlockAll_AddAdvancedRecipes takes nothing returns nothing
    call AddItemToStockBJ('I0CF',GetEnumUnit(),1,1) // 'I0CF': item "Recipe: Spiced Salad"
    call AddItemToStockBJ('I0CG',GetEnumUnit(),1,1) // 'I0CG': item "Recipe: Nebra Bread"
    call AddItemToStockBJ('I0CH',GetEnumUnit(),1,1) // 'I0CH': item "Recipe: First Class Meat Plate"
    call AddItemToStockBJ('I0CI',GetEnumUnit(),1,1) // 'I0CI': item "Recipe: Adamant Stew"
endfunction

function Trig_Cooking_Recipes_UnlockAll_RecipeRankIs1 takes nothing returns boolean
    return(udg_CookingStage==1)
endfunction

function Trig_Cooking_Recipes_UnlockAll_AddAllRecipes takes nothing returns nothing
    call AddItemToStockBJ('I0CA',GetEnumUnit(),1,1) // 'I0CA': item "Recipe: Triton Pot"
    call AddItemToStockBJ('I0CB',GetEnumUnit(),1,1) // 'I0CB': item "Recipe: Tropical Dish"
    call AddItemToStockBJ('I0CC',GetEnumUnit(),1,1) // 'I0CC': item "Recipe: Fish Soup"
    call AddItemToStockBJ('I0CD',GetEnumUnit(),1,1) // 'I0CD': item "Recipe: Energy Brew"
    call AddItemToStockBJ('I0CE',GetEnumUnit(),1,1) // 'I0CE': item "Recipe: Swift Drink"
    call AddItemToStockBJ('I0CF',GetEnumUnit(),1,1) // 'I0CF': item "Recipe: Spiced Salad"
    call AddItemToStockBJ('I0CG',GetEnumUnit(),1,1) // 'I0CG': item "Recipe: Nebra Bread"
    call AddItemToStockBJ('I0CH',GetEnumUnit(),1,1) // 'I0CH': item "Recipe: First Class Meat Plate"
    call AddItemToStockBJ('I0CI',GetEnumUnit(),1,1) // 'I0CI': item "Recipe: Adamant Stew"
endfunction

function Trig_Cooking_Recipes_UnlockAll_RecipeRankIs0 takes nothing returns boolean
    return(udg_CookingStage==0)
endfunction

function Trig_Cooking_Recipes_UnlockAll_FireplaceLit takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('Aneu',gg_unit_n0KG_0263)>0) // 'Aneu': standard ability reference "Neutral Building"
endfunction

function Trig_Cooking_Recipes_UnlockAll_Actions takes nothing returns nothing
    if(Trig_Cooking_Recipes_UnlockAll_FireplaceLit())then
        set udg_TempGroup=Group_UnitsOfType('n0KG') // 'n0KG': unit "Fireplace"
        if(Trig_Cooking_Recipes_UnlockAll_RecipeRankIs0())then
            call ForGroupBJ(udg_TempGroup,function Trig_Cooking_Recipes_UnlockAll_AddAllRecipes)
        else
            if(Trig_Cooking_Recipes_UnlockAll_RecipeRankIs1())then
                call ForGroupBJ(udg_TempGroup,function Trig_Cooking_Recipes_UnlockAll_AddAdvancedRecipes)
            else
                if(Trig_Cooking_Recipes_UnlockAll_RecipeRankIs2())then
                    call ForGroupBJ(udg_TempGroup,function Trig_Cooking_Recipes_UnlockAll_AddTopRecipes)
                endif
            endif
        endif
        call DestroyGroup(udg_TempGroup)
    endif
    set udg_CookingStage=3
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_Cooking automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Cooking (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Cooking takes nothing returns nothing
endfunction

function Register_Cooking_Recipes_UnlockAll takes nothing returns nothing
    set gg_trg_Cooking_Recipes_UnlockAll=CreateTrigger()
    call DisableTrigger(gg_trg_Cooking_Recipes_UnlockAll)
    call TriggerAddAction(gg_trg_Cooking_Recipes_UnlockAll,function Trig_Cooking_Recipes_UnlockAll_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Cooking takes nothing returns nothing
    call Register_Cooking_Recipes_UnlockAll()
endfunction

endlibrary
