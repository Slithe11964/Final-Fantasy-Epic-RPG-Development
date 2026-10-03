library TCraft requires TJob, TPlayerHero
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Craft_Recipe=null
    // Variables only this module uses.
    integer array udg_RecipeItem3
    integer array udg_RecipeItem4
    integer array udg_RecipeItem5
    integer array udg_RecipeItem6
    integer array udg_RecipeCount3
    integer array udg_RecipeCount4
    integer array udg_RecipeCount5
    integer array udg_RecipeCount6
endglobals

function Trig_Craft_Recipe_RemoveChar takes string l_str,string l_chr returns string
    local integer i=1
    loop
        exitwhen i>StringLength(l_str)
        if SubString(l_str,i-1,i)==l_chr then
            return SubString(l_str,0,i-1)+SubString(l_str,i,StringLength(l_str))
        endif
        set i=i+1
    endloop
    return l_str
endfunction

function Trig_Craft_Recipe_ConsumeIngredients takes unit l_buyer,integer l_recipeId returns boolean
    local string l_slots="012345"
    local integer i=1
    local integer l_slot
    local integer array l_reqItem
    local integer array l_reqCharges
    local boolean array l_found
    local integer l_si
    local item array l_matched
    local item ti
    set l_reqItem[1]=udg_RecipeItem1[l_recipeId]
    set l_reqItem[2]=udg_RecipeItem2[l_recipeId]
    set l_reqItem[3]=udg_RecipeItem3[l_recipeId]
    set l_reqItem[4]=udg_RecipeItem4[l_recipeId]
    set l_reqItem[5]=udg_RecipeItem5[l_recipeId]
    set l_reqItem[6]=udg_RecipeItem6[l_recipeId]
    set l_reqCharges[1]=udg_RecipeCharges1[l_recipeId]
    set l_reqCharges[2]=udg_RecipeCharges2[l_recipeId]
    set l_reqCharges[3]=udg_RecipeCount3[l_recipeId]
    set l_reqCharges[4]=udg_RecipeCount4[l_recipeId]
    set l_reqCharges[5]=udg_RecipeCount5[l_recipeId]
    set l_reqCharges[6]=udg_RecipeCount6[l_recipeId]
    loop
        exitwhen i>6
        set l_found[i]=false
        set l_matched[i]=null
        if l_reqItem[i]=='0000' or l_reqItem[i]==0 then // '0000': object name not found in map data
            set l_found[i]=true
        else
            set l_si=1
            loop
                exitwhen l_si>StringLength(l_slots)
                set l_slot=S2I(SubString(l_slots,l_si-1,l_si))
                set ti=UnitItemInSlot(l_buyer,l_slot)
                if l_reqItem[i]==GetItemTypeId(ti)and l_reqCharges[i]<=GetItemCharges(ti)then
                    set l_matched[i]=ti
                    set l_found[i]=true
                    set l_slots=Trig_Craft_Recipe_RemoveChar(l_slots,I2S(l_slot))
                    exitwhen true
                endif
                set l_si=l_si+1
            endloop
        endif
        set i=i+1
    endloop
    set ti=null
    set i=1
    loop
        exitwhen i>6
        if l_found[i]==false then
            call DisplayTimedTextToPlayer(GetOwningPlayer(l_buyer),0,0,30,"You don't have the required items in your inventory!")
            return false
        endif
        set i=i+1
    endloop
    set i=1
    loop
        exitwhen i>6
        if l_matched[i]!=null then
            if GetItemCharges(l_matched[i])>l_reqCharges[i]then
                call SetItemCharges(l_matched[i],GetItemCharges(l_matched[i])-l_reqCharges[i])
            else
                call RemoveItem(l_matched[i])
            endif
            set l_matched[i]=null
        endif
        set i=i+1
    endloop
    return true
endfunction

function Trig_Craft_Recipe_MakeRecipe takes string l_recipeName,unit l_crafter returns boolean
    local integer i=1
    local item l_made
    local player owningPlayer=GetOwningPlayer(l_crafter)
    local boolean l_success=false
    loop
        exitwhen(l_success or udg_RecipeName[i]==null)
        if l_recipeName==udg_RecipeName[i]then
            if Trig_Craft_Recipe_ConsumeIngredients(l_crafter,i)then
                set l_made=CreateItem(udg_RecipeResult[i],GetUnitX(l_crafter),GetUnitY(l_crafter))
                if(GetItemType(l_made)==ITEM_TYPE_CHARGED)then
                    if(IsPlayerInForce(owningPlayer,udg_TitleForce[55]))then
                        call SetItemCharges(l_made,5)
                    else
                        call SetItemCharges(l_made,3)
                    endif
                endif
                call UnitAddItem(l_crafter,l_made)
                set l_success=true
            endif
        endif
        set i=i+1
    endloop
    set l_made=null
    if(l_success and i>=30)then
        if(Job_GetSavedLevel(owningPlayer,'H002')==99 and not IsPlayerInForce(owningPlayer,udg_JobMasterForce[$A]))then // 'H002': unit "Chemist"; $A = 10
            call ForceAddPlayer(udg_JobMasterForce[$A],owningPlayer) // $A = 10
            if(GetUnitTypeId(l_crafter)=='H002')then // 'H002': unit "Chemist"
                call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Levelup\\LevelupCaster.mdl",l_crafter,"origin"))
            endif
        endif
        if(not IsPlayerInForce(owningPlayer,udg_TitleForce[55]))then
            set udg_TempPlayer=owningPlayer
            set udg_TempInteger=55
            call ConditionalTriggerExecute(gg_trg_Title_Grant)
        endif
    endif
    set owningPlayer=null
    return l_success
endfunction

function Trig_Craft_Recipe_Conditions takes nothing returns boolean
    return SubString(GetItemName(GetSoldItem()),0,8)=="Recipe: "
endfunction

function Trig_Craft_Recipe_Actions takes nothing returns nothing
    local unit u=GetBuyingUnit()
    local item i=GetSoldItem()
    local string l_itemName=GetItemName(i)
    local string l_recipeName=SubString(l_itemName,8,StringLength(l_itemName))
    if Trig_Craft_Recipe_MakeRecipe(l_recipeName,u)then
        call DisplayTimedTextToPlayer(GetOwningPlayer(u),0,0,$F,"You made |cffffcc00"+l_recipeName+"|r!") // $F = 15
        set udg_CinematicActor=Player_GetHero(GetOwningPlayer(u))
        call TimerStart(udg_ShortDelayTimer,.01,false,null)
    endif
    call RemoveItem(i)
    set u=null
    set i=null
    set l_itemName=""
    set l_recipeName=""
endfunction

// World Editor calls InitTrig_Craft automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Craft (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Craft takes nothing returns nothing
endfunction

function Register_Craft_Recipe takes nothing returns nothing
    set gg_trg_Craft_Recipe=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Craft_Recipe,EVENT_PLAYER_UNIT_SELL_ITEM)
    call TriggerAddCondition(gg_trg_Craft_Recipe,Condition(function Trig_Craft_Recipe_Conditions))
    call TriggerAddAction(gg_trg_Craft_Recipe,function Trig_Craft_Recipe_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Craft takes nothing returns nothing
    call Register_Craft_Recipe() // run by MapBootstrap
endfunction

endlibrary
