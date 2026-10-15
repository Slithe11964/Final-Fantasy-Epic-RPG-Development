library TCurse requires TCraft, TPlayerHero, TBackpack
globals
    // Variables only this module uses (MapBootstrap sets some starting values).
    trigger udg_CurseItemTrigger=null
endglobals

function Curse_CondIsCurseItem takes nothing returns boolean
    return SubString(GetItemName(GetManipulatedItem()),0,7)=="Curse: "
endfunction

// This scans one known holder; Curse_FindHolder enumerates the hero, every page and Gaya.
function Curse_ItemOn takes unit holder,integer raw returns item
    local integer slot=0
    local item carried
    if holder==null then
        return null
    endif
    loop
        exitwhen slot>=6
        set carried=UnitItemInSlot(holder,slot)
        if carried!=null and GetItemTypeId(carried)==raw then
            return carried
        endif
        set slot=slot+1
    endloop
    set carried=null
    return null
endfunction

function Curse_FindHolder takes player owner,integer raw returns unit
    local unit holder=Player_GetHero(owner)
    local integer pid=GetPlayerId(owner)
    local integer page=0
    if Curse_ItemOn(holder,raw)!=null then
        return holder
    endif
    loop
        exitwhen page>=BACKPACK_PAGES
        set holder=BackpackHolder[pid*8+page]
        if holder!=null and Curse_ItemOn(holder,raw)!=null then
            return holder
        endif
        set page=page+1
    endloop
    set holder=udg_SpiritOfGaya[pid+1]
    if holder!=null and Curse_ItemOn(holder,raw)!=null then
        return holder
    endif
    set holder=null
    return null
endfunction

function Curse_Replace takes unit holder,item original,integer result returns boolean
    local integer pid=GetPlayerId(GetOwningPlayer(holder))
    local integer page=Backpack_PageOf(pid,holder)
    local item replacement=CreateItem(result,GetUnitX(holder),GetUnitY(holder))
    local boolean success=false
    if replacement!=null then
        call SetItemPlayer(replacement,GetOwningPlayer(holder),false)
        set BackpackMoving[pid]=true
        call UnitRemoveItem(holder,original)
        if page>=0 and page<BACKPACK_EQUIPMENT_PAGES then
            set BackpackMoving[pid]=false
            // Recheck kind, level and mastery: a curse can change which slot the result uses.
            set success=Backpack_TryEquipPickup(pid,null,replacement)
            if not success then
                set success=Backpack_Store(pid,null,replacement)
            endif
            set BackpackMoving[pid]=true
        else
            call UnitAddItem(holder,replacement)
            set success=UnitHasItem(holder,replacement)
        endif
        if success then
            call RemoveItem(original)
        else
            call RemoveItem(replacement)
            call UnitAddItem(holder,original)
        endif
        set BackpackMoving[pid]=false
        call Backpack_ApplyBonuses(pid)
    endif
    set replacement=null
    return success
endfunction

function Curse_Make takes string name,unit user returns boolean
    local integer recipe=1
    local unit holder=null
    local item original=null
    local boolean success=false
    loop
        exitwhen udg_RecipeName[recipe]==null or udg_RecipeName[recipe]==name
        set recipe=recipe+1
    endloop
    // Curse scrolls transform one gear item; ordinary multi-ingredient crafting stays in Craft.
    if udg_RecipeName[recipe]==name and udg_RecipeItem1[recipe]!=0 and udg_RecipeItem2[recipe]==0 and udg_RecipeItem3[recipe]==0 and udg_RecipeItem4[recipe]==0 and udg_RecipeItem5[recipe]==0 and udg_RecipeItem6[recipe]==0 and udg_RecipeResult[recipe]!=0 then
        set holder=Curse_FindHolder(GetOwningPlayer(user),udg_RecipeItem1[recipe])
        if holder!=null then
            set original=Curse_ItemOn(holder,udg_RecipeItem1[recipe])
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
    if BackpackMoving[GetPlayerId(GetOwningPlayer(u))] then
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
