function Forsaken_ActiveGear takes unit holder,integer slot returns item
    if slot<6 then
        return UnitItemInSlot(holder,slot)
    endif
    return UnitItemInEquipmentSlot(holder,ConvertLoadoutSlot(slot-6))
endfunction

function Forsaken_ActiveGearBJ takes unit holder,integer slot returns item
    return Forsaken_ActiveGear(holder,slot-1)
endfunction

function Forsaken_ActiveAbilityLevel takes unit holder,integer raw returns integer
    local integer rank=GetUnitAbilityLevel(holder,raw)
    local integer slot=0
    local integer index
    local item carried
    local ability itemAbility
    if rank>0 then
        return rank
    endif
    loop
        exitwhen slot>=15
        set carried=Forsaken_ActiveGear(holder,slot)
        set index=0
        loop
            exitwhen carried==null
            set itemAbility=BlzGetItemAbilityByIndex(carried,index)
            exitwhen itemAbility==null
            if BlzGetAbilityId(itemAbility)==raw then
                set rank=1
            endif
            set index=index+1
        endloop
        set slot=slot+1
    endloop
    set carried=null
    set itemAbility=null
    return rank
endfunction
