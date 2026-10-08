function Forsaken_RestoreStoredItem takes item carried returns nothing
    local integer key=GetHandleId(carried)
    local integer index=1
    local integer count=LoadInteger(ForsakenBagAbilities,key,0)
    if carried==null or not LoadBoolean(ForsakenBagAbilities,key,-1) then
        return
    endif
    loop
        exitwhen index>count
        call BlzItemAddAbility(carried,LoadInteger(ForsakenBagAbilities,key,index))
        set index=index+1
    endloop
    call FlushChildHashtable(ForsakenBagAbilities,key)
endfunction

function Forsaken_SuspendStoredItem takes item carried returns nothing
    local integer key=GetHandleId(carried)
    local integer index=0
    local integer count=0
    local integer raw
    local ability itemAbility
    if carried==null or LoadBoolean(ForsakenBagAbilities,key,-1) then
        return
    endif
    // Snapshot first: removing an ability changes the remaining item ability indexes.
    loop
        set itemAbility=BlzGetItemAbilityByIndex(carried,index)
        exitwhen itemAbility==null
        set raw=BlzGetAbilityId(itemAbility)
        if LoadBoolean(ForsakenBagPassiveTypes,0,raw) then
            set count=count+1
            call SaveInteger(ForsakenBagAbilities,key,count,raw)
        endif
        set index=index+1
    endloop
    if count==0 then
        set itemAbility=null
        return
    endif
    call SaveInteger(ForsakenBagAbilities,key,0,count)
    call SaveBoolean(ForsakenBagAbilities,key,-1,true)
    set index=1
    loop
        exitwhen index>count
        call BlzItemRemoveAbility(carried,LoadInteger(ForsakenBagAbilities,key,index))
        set index=index+1
    endloop
    set itemAbility=null
endfunction

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
