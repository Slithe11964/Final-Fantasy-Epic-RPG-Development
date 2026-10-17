
function Forsaken_SyncStoredEffects takes unit holder returns nothing
    local integer slot=0
    loop
        exitwhen slot>=6
        call Forsaken_RestoreStoredItem(UnitItemInSlot(holder,slot))
        set slot=slot+1
    endloop
    set slot=0
    loop
        exitwhen slot>=9
        call Forsaken_RestoreStoredItem(UnitItemInEquipmentSlot(holder,ConvertLoadoutSlot(slot)))
        set slot=slot+1
    endloop
    set slot=0
    loop
        exitwhen slot>=UnitExtendedInventorySize(holder)
        call Forsaken_SuspendStoredItem(UnitItemInBagSlot(holder,slot))
        set slot=slot+1
    endloop
endfunction
