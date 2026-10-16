// Shared item lookup; only the storage adapter differs between map profiles.
function Carry_Type takes item carried returns integer
    local integer raw=GetItemTypeId(carried)
    static if not LIBRARY_TBackpack then
        local integer original=LoadInteger(ForsakenGearTypes,4,raw)
        if original!=0 then
            return original
        endif
    endif
    return raw
endfunction

function Carry_Size takes unit holder returns integer
    static if LIBRARY_TBackpack then
        if Gear_IsPlayerHero(holder) then
            return 6+BACKPACK_PAGES*BACKPACK_SLOTS
        endif
        return 6
    else
        return 6+UnitExtendedInventorySize(holder)+9
    endif
endfunction

function Carry_At takes unit holder,integer slot returns item
    if slot<6 then
        return UnitItemInSlot(holder,slot)
    endif
    static if LIBRARY_TBackpack then
        set slot=slot-6
        return UnitItemInSlot(BackpackHolder[GetPlayerId(GetOwningPlayer(holder))*8+slot/BACKPACK_SLOTS],ModuloInteger(slot,BACKPACK_SLOTS))
    else
        set slot=slot-6
        if slot<UnitExtendedInventorySize(holder) then
            return UnitItemInBagSlot(holder,slot)
        endif
        return UnitItemInEquipmentSlot(holder,ConvertLoadoutSlot(slot-UnitExtendedInventorySize(holder)))
    endif
endfunction

function Carry_Find takes unit holder,integer raw returns item
    local integer slot=0
    local integer size=Carry_Size(holder)
    local item carried
    loop
        exitwhen slot>=size
        set carried=Carry_At(holder,slot)
        if carried!=null and Carry_Type(carried)==raw then
            return carried
        endif
        set slot=slot+1
    endloop
    return null
endfunction

function Carry_Has takes unit holder,integer raw returns boolean
    return Carry_Find(holder,raw)!=null
endfunction

function Carry_Worn takes unit holder,integer raw returns boolean
    static if LIBRARY_TBackpack then
        return Gear_WornOfType(holder,raw)!=null
    else
        local integer slot=0
        loop
            exitwhen slot>=9
            if Carry_Type(UnitItemInEquipmentSlot(holder,ConvertLoadoutSlot(slot)))==raw then
                return true
            endif
            set slot=slot+1
        endloop
        return false
    endif
endfunction

function ItemStack_Eligible takes item picked returns boolean
    return picked!=null and (GetItemType(picked)==ITEM_TYPE_CHARGED or GetItemTypeId(picked)=='I03Y') and GetItemLevel(picked)>=2 and GetItemCharges(picked)>0
endfunction

function ItemStack_MergePair takes item picked,item target,integer ownerId returns nothing
    local integer amount
    local integer bound=GetItemUserData(picked)
    local integer other=GetItemUserData(target)
    if picked==target or target==null or not ItemStack_Eligible(picked) or GetItemTypeId(picked)!=GetItemTypeId(target) or GetItemCharges(target)<=0 or GetItemCharges(target)>=99 then
        return
    endif
    if (bound!=0 and bound!=ownerId) or (other!=0 and other!=ownerId) then
        return
    endif
    set amount=IMinBJ(GetItemCharges(picked),99-GetItemCharges(target))
    call SetItemCharges(target,GetItemCharges(target)+amount)
    if bound!=0 and other==0 then
        call SetItemUserData(target,bound)
    endif
    if amount==GetItemCharges(picked) then
        call RemoveItem(picked)
    else
        call SetItemCharges(picked,GetItemCharges(picked)-amount)
        if other!=0 and bound==0 then
            call SetItemUserData(picked,other)
        endif
    endif
endfunction

function ItemStack_MergeUnit takes unit holder,item picked returns nothing
    local integer slot=0
    local integer size=Carry_Size(holder)
    loop
        exitwhen slot>=size or GetItemTypeId(picked)==0
        call ItemStack_MergePair(picked,Carry_At(holder,slot),GetPlayerId(GetOwningPlayer(holder))+1)
        set slot=slot+1
    endloop
endfunction

function ItemStack_ConsolidateUnit takes unit holder returns nothing
    local integer slot=0
    local integer size=Carry_Size(holder)
    local item picked
    loop
        exitwhen slot>=size
        set picked=Carry_At(holder,slot)
        if ItemStack_Eligible(picked) then
            call ItemStack_MergeUnit(holder,picked)
        endif
        set slot=slot+1
    endloop
    set picked=null
endfunction

function ItemStack_GroundMatch takes nothing returns nothing
    local item target=GetEnumItem()
    if IsItemVisible(target) and not IsItemOwned(target) then
        call ItemStack_MergePair(ItemStackGatherItem,target,ItemStackGatherOwner)
        if GetItemTypeId(ItemStackGatherItem)==0 then
            set ItemStackGatherItem=target
        endif
    endif
    set target=null
endfunction

function ItemStack_MergeGround takes item picked,rect area,integer ownerId returns nothing
    local item previous=ItemStackGatherItem
    local integer previousOwner=ItemStackGatherOwner
    set ItemStackGatherItem=picked
    set ItemStackGatherOwner=ownerId
    call EnumItemsInRect(area,null,function ItemStack_GroundMatch)
    set ItemStackGatherItem=previous
    set ItemStackGatherOwner=previousOwner
    set previous=null
endfunction
