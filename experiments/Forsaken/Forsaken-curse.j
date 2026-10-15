library TCurse requires TCraft, TPlayerHero, TEquip
globals
    // Variables only this module uses (MapBootstrap sets some starting values).
    trigger udg_CurseItemTrigger=null
endglobals

function Curse_CondIsCurseItem takes nothing returns boolean
    return SubString(GetItemName(GetManipulatedItem()),0,7)=="Curse: "
endfunction

function Curse_BaseType takes item carried returns integer
    local integer raw=LoadInteger(ForsakenGearTypes,4,GetItemTypeId(carried))
    if raw==0 then
        set raw=GetItemTypeId(carried)
    endif
    return raw
endfunction

function Curse_FindItem takes unit holder,integer raw returns item
    local integer slot=0
    local item carried
    if holder==null then
        return null
    endif
    loop
        exitwhen slot>=6+UnitExtendedInventorySize(holder)+9
        if slot<6 then
            set carried=UnitItemInSlot(holder,slot)
        elseif slot<6+UnitExtendedInventorySize(holder) then
            set carried=UnitItemInBagSlot(holder,slot-6)
        else
            set carried=UnitItemInEquipmentSlot(holder,ConvertLoadoutSlot(slot-6-UnitExtendedInventorySize(holder)))
        endif
        if carried!=null and Curse_BaseType(carried)==raw then
            return carried
        endif
        set slot=slot+1
    endloop
    set carried=null
    return null
endfunction

function Curse_Replace takes unit holder,item original,integer result returns boolean
    local item replacement
    local integer raw=result
    local integer alternate
    local boolean equipped=UnitHasItemEquipped(holder,original)
    local boolean success=false
    if holder==Player_GetHero(GetOwningPlayer(holder)) then
        set alternate=LoadInteger(ForsakenGearTypes,0,result)
        if alternate!=0 then
            set raw=alternate
            if LoadInteger(ForsakenGearTypes,6,GetItemTypeId(original))!=0 then
                set alternate=LoadInteger(ForsakenGearTypes,5,raw)
                if alternate!=0 then
                    set raw=alternate
                endif
            endif
        endif
    endif
    set replacement=CreateItem(raw,GetUnitX(holder),GetUnitY(holder))
    if replacement!=null then
        call SetItemPlayer(replacement,GetOwningPlayer(holder),false)
        // Keep native carry conversion from replacing handles during the transaction.
        set ForsakenConvertingGear=true
        if equipped then
            call UnitUnequipItem(holder,original)
        endif
        call UnitRemoveItem(holder,original)
        call UnitAddItem(holder,replacement)
        set success=UnitHasItem(holder,replacement) or UnitHasItemBagged(holder,replacement) or UnitHasItemEquipped(holder,replacement)
        if success then
            call FlushChildHashtable(ForsakenBagAbilities,GetHandleId(original))
            call RemoveSavedBoolean(ForsakenGearTypes,50,GetHandleId(original))
            call RemoveSavedBoolean(ForsakenGearTypes,51,GetHandleId(original))
            call RemoveItem(original)
        else
            call RemoveItem(replacement)
            call UnitAddItem(holder,original)
        endif
        set ForsakenConvertingGear=false
        if equipped then
            if success then
                call UnitEquipItem(holder,replacement)
            else
                call UnitEquipItem(holder,original)
            endif
        endif
        if holder==Player_GetHero(GetOwningPlayer(holder)) then
            call Forsaken_StoreHeroGear(holder)
            call Forsaken_SyncStoredEffects(holder)
            call Forsaken_QueueBagRebind(holder)
            call Forsaken_UpdatePanels(holder)
        endif
    endif
    set replacement=null
    return success
endfunction

function Curse_Make takes string name,unit user returns boolean
    local integer recipe=1
    local unit holder=Player_GetHero(GetOwningPlayer(user))
    local item original=null
    local boolean success=false
    loop
        exitwhen udg_RecipeName[recipe]==null or udg_RecipeName[recipe]==name
        set recipe=recipe+1
    endloop
    // Curse scrolls transform one gear item; ordinary multi-ingredient crafting stays in Craft.
    if udg_RecipeName[recipe]==name and udg_RecipeItem1[recipe]!=0 and udg_RecipeItem2[recipe]==0 and udg_RecipeItem3[recipe]==0 and udg_RecipeItem4[recipe]==0 and udg_RecipeItem5[recipe]==0 and udg_RecipeItem6[recipe]==0 and udg_RecipeResult[recipe]!=0 then
        set original=Curse_FindItem(holder,udg_RecipeItem1[recipe])
        if original==null then
            set holder=udg_SpiritOfGaya[GetConvertedPlayerId(GetOwningPlayer(user))]
            set original=Curse_FindItem(holder,udg_RecipeItem1[recipe])
        endif
        if original!=null then
            set success=Curse_Replace(holder,original,udg_RecipeResult[recipe])
        endif
    endif
    set holder=null
    set original=null
    return success
endfunction

function Curse_UseItem takes nothing returns nothing
    local unit u=GetManipulatingUnit()
    local item i=GetManipulatedItem()
    local string l_itemName=GetItemName(i)
    local string l_curseName=SubString(l_itemName,7,StringLength(l_itemName))
    if u!=Player_GetHero(GetOwningPlayer(u)) and u!=udg_SpiritOfGaya[GetConvertedPlayerId(GetOwningPlayer(u))] then
        set u=null
        set i=null
        return
    endif
    if not IsUnitInRangeXY(u,GetRectCenterX(gg_rct_227),GetRectCenterY(gg_rct_227),300)then
        call DisplayTimedTextToPlayer(GetOwningPlayer(u),0,0,8,"|cFFFF0000You have to go to Lady Curse to curse an item!|r")
        set u=null
        set i=null
        return
    endif
    if ForsakenConvertingGear then
        call DisplayTimedTextToPlayer(GetOwningPlayer(u),0,0,8,"Your inventory is busy; try the curse scroll again.")
    elseif Curse_Make(l_curseName,u)then
        call RemoveItem(i)
        call DisplayTimedTextToPlayer(GetOwningPlayer(u),0,0,$F,"You cursed "+l_curseName+"!") // $F = 15
    else
        call DisplayTimedTextToPlayer(GetOwningPlayer(u),0,0,15,"Unable to curse "+l_curseName+". Keep the matching item in your hero's or Gaya's bags or equipment, with room for the result. Your scroll was kept.")
    endif
    set u=null
    set i=null
    set l_itemName=null
    set l_curseName=null
endfunction

function Curse_Init takes nothing returns nothing
    local integer i=0
    set udg_CurseItemTrigger=CreateTrigger()
    loop
        call TriggerRegisterPlayerUnitEvent(udg_CurseItemTrigger,Player(i),EVENT_PLAYER_UNIT_USE_ITEM,null)
        exitwhen i==7
        set i=i+1
    endloop
    call TriggerAddCondition(udg_CurseItemTrigger,Condition(function Curse_CondIsCurseItem))
    call TriggerAddAction(udg_CurseItemTrigger,function Curse_UseItem)
endfunction

function InitTrig_Curse takes nothing returns nothing
endfunction

endlibrary
