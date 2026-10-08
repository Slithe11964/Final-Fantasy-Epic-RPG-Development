function Forsaken_MoveSharedItem takes unit previous,unit current,item carried,boolean equipped returns nothing
    local integer charges=GetItemCharges(carried)
    if equipped then
        call UnitUnequipItem(previous,carried)
    endif
    call UnitRemoveItem(previous,carried)
    call SetItemCharges(carried,0)
    if UnitAddItem(current,carried) then
        call SetItemCharges(carried,charges)
        if equipped then
            call Forsaken_RestoreStoredItem(carried)
            call UnitEquipItem(current,carried)
        endif
        if UnitHasItemBagged(current,carried) then
            call Forsaken_SuspendStoredItem(carried)
        else
            call Forsaken_RestoreStoredItem(carried)
        endif
    else
        call Forsaken_RestoreStoredItem(carried)
        call SetItemCharges(carried,charges)
        call SetItemPosition(carried,GetUnitX(current),GetUnitY(current))
        call DisplayTimedTextToPlayer(GetOwningPlayer(current),0,0,15,"Your backpack is full. The remaining item is beside your hero.")
    endif
endfunction

function Forsaken_TransferSharedInventory takes unit previous,unit current returns nothing
    local integer slot=0
    local integer inventoryLevel
    local item carried
    if previous==null or current==null or previous==current then
        return
    endif
    call UnitAddAbility(current,'fBag')
    call UnitMakeAbilityPermanent(current,true,'fBag')
    call UnitAddAbility(current,'fGer')
    call UnitMakeAbilityPermanent(current,true,'fGer')
    call UnitAddAbility(current,'ASpc')
    call UnitMakeAbilityPermanent(current,true,'ASpc')
    set inventoryLevel=GetUnitAbilityLevel(current,'AInv')
    // The destination's six slots have been cleared; force additions into its native bag.
    if inventoryLevel>0 then
        call UnitRemoveAbility(current,'AInv')
    endif
    loop
        exitwhen slot>8
        set carried=UnitItemInEquipmentSlot(previous,ConvertLoadoutSlot(slot))
        if carried!=null then
            call Forsaken_MoveSharedItem(previous,current,carried,true)
        endif
        set slot=slot+1
    endloop
    set slot=0
    loop
        exitwhen slot>=UnitExtendedInventorySize(previous)
        set ForsakenSharedBag[slot]=UnitItemInBagSlot(previous,slot)
        set slot=slot+1
    endloop
    set slot=0
    loop
        exitwhen slot>=UnitExtendedInventorySize(previous)
        set carried=ForsakenSharedBag[slot]
        set ForsakenSharedBag[slot]=null
        if carried!=null then
            call Forsaken_MoveSharedItem(previous,current,carried,false)
        else
            // Temporary items hold empty positions until the entire sparse bag is transferred.
            set carried=CreateItem('fGap',GetUnitX(current),GetUnitY(current))
            if UnitAddItem(current,carried) then
                set ForsakenSharedBag[slot]=carried
            else
                call RemoveItem(carried)
            endif
        endif
        set slot=slot+1
    endloop
    set slot=0
    loop
        exitwhen slot>=UnitExtendedInventorySize(previous)
        if ForsakenSharedBag[slot]!=null then
            call RemoveItem(ForsakenSharedBag[slot])
            set ForsakenSharedBag[slot]=null
        endif
        set slot=slot+1
    endloop
    if inventoryLevel>0 then
        call UnitAddAbility(current,'AInv')
        call SetUnitAbilityLevel(current,'AInv',inventoryLevel)
        call UnitMakeAbilityPermanent(current,true,'AInv')
    endif
    set carried=null
endfunction
