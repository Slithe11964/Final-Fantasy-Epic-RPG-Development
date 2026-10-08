function Forsaken_ActiveGear takes unit holder,integer slot returns item
    if slot<6 then
        return UnitItemInSlot(holder,slot)
    endif
    return UnitItemInEquipmentSlot(holder,ConvertLoadoutSlot(slot-6))
endfunction

function Forsaken_ActiveGearBJ takes unit holder,integer slot returns item
    return Forsaken_ActiveGear(holder,slot-1)
endfunction
