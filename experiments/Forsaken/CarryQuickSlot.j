// Allocate directly into the requested quick slot. UnitAddItem first routes
// native equipment into the bag, where UnitDropItemSlot can refuse the move.
function Integrity_CarryIntoSlot takes unit holder,item original,integer slot,integer raw returns item
    local item replacement
    if holder==null or slot<0 or slot>5 or not Forsaken_HoldsItem(holder,original) then
        return original
    endif
    if UnitItemInSlot(holder,slot)==original then
        return original
    endif
    if UnitItemInSlot(holder,slot)!=null then
        return original
    endif
    if LoadInteger(ForsakenGearTypes,67,raw)!=0 then
        set raw=LoadInteger(ForsakenGearTypes,67,raw)
    endif
    set ForsakenConvertingGear=true
    if not UnitAddItemToSlotById(holder,raw,slot) then
        set ForsakenConvertingGear=false
        return original
    endif
    set replacement=UnitItemInSlot(holder,slot)
    if replacement==null or GetItemTypeId(replacement)!=raw then
        set ForsakenConvertingGear=false
        return original
    endif
    call SaveBoolean(ForsakenGearTypes,51,GetHandleId(replacement),true)
    call SetItemUserData(replacement,GetItemUserData(original))
    call SetWidgetLife(replacement,GetWidgetLife(original))
    call SetItemPlayer(replacement,GetItemPlayer(original),false)
    call SetItemCharges(replacement,GetItemCharges(original))
    call UnitRemoveItem(holder,original)
    call RemoveSavedBoolean(ForsakenGearTypes,50,GetHandleId(original))
    call RemoveSavedBoolean(ForsakenGearTypes,51,GetHandleId(original))
    call FlushChildHashtable(ForsakenBagAbilities,GetHandleId(original))
    call RemoveItem(original)
    call Forsaken_SyncStoredEffects(holder)
    set ForsakenConvertingGear=false
    return replacement
endfunction
