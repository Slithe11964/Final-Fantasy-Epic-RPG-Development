function Forsaken_GearClass takes item gear returns itemtype
    local integer category=LoadInteger(ForsakenElementSources,3,GetItemTypeId(gear))
    if category>0 then
        return ConvertItemType(category-1)
    endif
    return GetItemType(gear)
endfunction

function Forsaken_ActiveGear takes unit holder,integer slot returns item
    local item gear
    if slot<6 then
        set gear=UnitItemInSlot(holder,slot)
        if holder==Player_GetHero(GetOwningPlayer(holder)) and LoadBoolean(ForsakenElementSources,2,GetItemTypeId(gear)) then
            set gear=null
            return null
        endif
        return gear
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

function Forsaken_ElementAbilityLevel takes unit holder,integer raw returns integer
    local integer rank=GetUnitAbilityLevel(holder,raw)
    local integer slot=0
    local integer index
    local item gear
    local ability itemAbility
    if holder!=Player_GetHero(GetOwningPlayer(holder)) or not LoadBoolean(ForsakenElementSources,0,raw) then
        return Forsaken_ActiveAbilityLevel(holder,raw)
    endif
    // Native unit queries can retain item abilities after unequipping; only genuine innate abilities bypass the gear scan.
    if LoadBoolean(ForsakenElementSources,GetUnitTypeId(holder),raw) then
        return rank
    endif
    set rank=0
    loop
        exitwhen slot>=15
        set gear=Forsaken_ActiveGear(holder,slot)
        if slot>=6 or GetItemEquipmentType(gear)==EQUIPMENT_TYPE_NONE then
            set index=0
            loop
                exitwhen gear==null
                set itemAbility=BlzGetItemAbilityByIndex(gear,index)
                exitwhen itemAbility==null
                if BlzGetAbilityId(itemAbility)==raw then
                    set rank=1
                endif
                set index=index+1
            endloop
        endif
        set slot=slot+1
    endloop
    set gear=null
    set itemAbility=null
    return rank
endfunction

function Forsaken_TwoHandedWeapon takes unit holder returns item
    local integer slot=0
    local item gear
    local item weapon=null
    if UnitItemInEquipmentSlot(holder,EQUIPMENT_LOADOUT_SLOT_OFFHAND)!=null then
        return null
    endif
    loop
        exitwhen slot>=15
        set gear=Forsaken_ActiveGear(holder,slot)
        if gear!=null and (Forsaken_GearClass(gear)==ITEM_TYPE_PERMANENT or Forsaken_GearClass(gear)==ITEM_TYPE_POWERUP) then
            if weapon!=null or Forsaken_GearClass(gear)==ITEM_TYPE_POWERUP then
                set gear=null
                set weapon=null
                return null
            endif
            set weapon=gear
        endif
        set slot=slot+1
    endloop
    set gear=null
    return weapon
endfunction
