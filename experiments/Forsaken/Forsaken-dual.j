function Forsaken_PrepareWeaponHand takes unit holder,item original,integer bagSlot returns nothing
    local integer raw=GetItemTypeId(original)
    local integer alternate=LoadInteger(ForsakenGearTypes,6,raw)
    local integer target=raw
    local integer slot=0
    local integer charges=GetItemCharges(original)
    local item spacer
    local item replacement
    local boolean dual=GetUnitAbilityLevel(holder,'A0HP')>0 and UnitItemInEquipmentSlot(holder,EQUIPMENT_LOADOUT_SLOT_PRIMARY)!=null
    if alternate==0 then
        set alternate=raw
    endif
    if dual and LoadInteger(ForsakenGearTypes,5,alternate)!=0 then
        set target=LoadInteger(ForsakenGearTypes,5,alternate)
    elseif LoadInteger(ForsakenGearTypes,6,raw)!=0 then
        set target=alternate
    endif
    if target==raw or ForsakenConvertingGear then
        return
    endif
    set ForsakenConvertingGear=true
    set replacement=CreateItem(target,GetUnitX(holder),GetUnitY(holder))
    if replacement==null then
        set ForsakenConvertingGear=false
        return
    endif
    call SetItemCharges(replacement,0)
    call SetItemUserData(replacement,GetItemUserData(original))
    call SetWidgetLife(replacement,GetWidgetLife(original))
    call SetItemPlayer(replacement,GetItemPlayer(original),false)
    loop
        exitwhen slot>=6+bagSlot
        if (slot<6 and UnitItemInSlot(holder,slot)==null) or (slot>=6 and UnitItemInBagSlot(holder,slot-6)==null) then
            set spacer=CreateItem('fGap',GetUnitX(holder),GetUnitY(holder))
            if UnitAddItem(holder,spacer) then
                set ForsakenHandSpacers[slot]=spacer
            else
                call RemoveItem(spacer)
            endif
        endif
        set slot=slot+1
    endloop
    call UnitRemoveItem(holder,original)
    call UnitAddItem(holder,replacement)
    if UnitItemInBagSlot(holder,bagSlot)==replacement then
        call SetItemCharges(replacement,charges)
        call RemoveItem(original)
    else
        call RemoveItem(replacement)
        call SetItemCharges(original,0)
        call UnitAddItem(holder,original)
        call SetItemCharges(original,charges)
    endif
    set slot=0
    loop
        exitwhen slot>=6+bagSlot
        if ForsakenHandSpacers[slot]!=null then
            call RemoveItem(ForsakenHandSpacers[slot])
            set ForsakenHandSpacers[slot]=null
        endif
        set slot=slot+1
    endloop
    set ForsakenConvertingGear=false
    set spacer=null
    set replacement=null
endfunction

function Forsaken_PrepareDualWield takes unit holder returns nothing
    local integer slot=0
    local item carried=UnitItemInEquipmentSlot(holder,EQUIPMENT_LOADOUT_SLOT_OFFHAND)
    if LoadInteger(ForsakenGearTypes,6,GetItemTypeId(carried))!=0 and GetUnitAbilityLevel(holder,'A0HP')==0 then
        call UnitUnequipItem(holder,carried)
    endif
    loop
        exitwhen slot>=UnitExtendedInventorySize(holder)
        set carried=UnitItemInBagSlot(holder,slot)
        if carried!=null then
            call Forsaken_PrepareWeaponHand(holder,carried,slot)
        endif
        set slot=slot+1
    endloop
    set carried=null
endfunction
