function Forsaken_StatAbilityLevel takes unit hero,integer raw returns integer
    local integer level=GetUnitAbilityLevel(hero,raw)
    local integer slot=0
    local integer index
    local ability itemAbility
    local item gear
    if LoadBoolean(ForsakenElementSources,0,raw) then
        return Forsaken_ElementAbilityLevel(hero,raw)
    endif
    if level>0 then
        return level
    endif
    loop
        exitwhen slot>=15
        set gear=Forsaken_ActiveGear(hero,slot)
        set index=0
        loop
            exitwhen gear==null
            set itemAbility=BlzGetItemAbilityByIndex(gear,index)
            exitwhen itemAbility==null
            if BlzGetAbilityId(itemAbility)==raw then
                set level=1
            endif
            set index=index+1
        endloop
        set slot=slot+1
    endloop
    set gear=null
    set itemAbility=null
    return level
endfunction
