function Forsaken_CarryReplacement takes unit holder,item original,integer quickSlot returns item
    local integer raw=LoadInteger(ForsakenGearTypes,4,GetItemTypeId(original))
    local integer charges=GetItemCharges(original)
    local boolean wasEquipped=false
    local item replacement
    if raw==0 or original==null or ForsakenConvertingGear then
        return original
    endif
    set ForsakenConvertingGear=true
    set replacement=CreateItem(raw,GetItemX(original),GetItemY(original))
    if replacement==null then
        set ForsakenConvertingGear=false
        return original
    endif
    call SaveBoolean(ForsakenGearTypes,51,GetHandleId(replacement),true)
    call SetItemCharges(replacement,0)
    call SetItemUserData(replacement,GetItemUserData(original))
    call SetWidgetLife(replacement,GetWidgetLife(original))
    call SetItemPlayer(replacement,GetItemPlayer(original),false)
    if holder!=null then
        set wasEquipped=UnitHasItemEquipped(holder,original)
        if wasEquipped then
            call UnitUnequipItem(holder,original)
        endif
        call UnitRemoveItem(holder,original)
        call UnitAddItem(holder,replacement)
        if not Forsaken_HoldsItem(holder,replacement) then
            call RemoveItem(replacement)
            call RemoveSavedBoolean(ForsakenGearTypes,51,GetHandleId(replacement))
            call UnitAddItem(holder,original)
            if wasEquipped then
                call UnitEquipItem(holder,original)
            endif
            set ForsakenConvertingGear=false
            return original
        endif
        if quickSlot>=0 then
            call UnitDropItemSlot(holder,replacement,quickSlot)
            if UnitItemInSlot(holder,quickSlot)!=replacement then
                call RemoveItem(replacement)
                call RemoveSavedBoolean(ForsakenGearTypes,51,GetHandleId(replacement))
                call UnitAddItem(holder,original)
                if wasEquipped then
                    call UnitEquipItem(holder,original)
                endif
                set ForsakenConvertingGear=false
                return original
            endif
        endif
    endif
    call SetItemCharges(replacement,charges)
    call RemoveSavedBoolean(ForsakenGearTypes,50,GetHandleId(original))
    call RemoveSavedBoolean(ForsakenGearTypes,51,GetHandleId(original))
    call FlushChildHashtable(ForsakenBagAbilities,GetHandleId(original))
    call RemoveItem(original)
    set ForsakenConvertingGear=false
    return replacement
endfunction

function Forsaken_CarryDrop takes nothing returns nothing
    local timer clock=GetExpiredTimer()
    local integer key=GetHandleId(clock)
    local item gear=LoadItemHandle(ForsakenGearTypes,60,key)
    local unit recipient=LoadUnitHandle(ForsakenGearTypes,61,key)
    local item replacement
    if gear!=null and GetItemTypeId(gear)!=0 then
        if not IsItemOwned(gear) then
            set replacement=Forsaken_CarryReplacement(null,gear,-1)
            if recipient!=null and replacement!=gear then
                call UnitAddItem(recipient,replacement)
            endif
        elseif recipient!=null and Forsaken_HoldsItem(recipient,gear) then
            set replacement=Forsaken_CarryReplacement(recipient,gear,-1)
        endif
    endif
    call RemoveSavedHandle(ForsakenGearTypes,60,key)
    call RemoveSavedHandle(ForsakenGearTypes,61,key)
    call DestroyTimer(clock)
    set clock=null
    set gear=null
    set recipient=null
    set replacement=null
endfunction

function Forsaken_CarryOrder takes unit holder returns nothing
    local integer order=GetIssuedOrderId()
    local item gear=GetOrderTargetItem()
    local unit recipient=GetOrderTargetUnit()
    local item replacement
    call RemoveSavedHandle(ForsakenGearTypes,62,GetHandleId(holder))
    if order==852001 and recipient!=null and GetOwningPlayer(recipient)==GetOwningPlayer(holder) and (recipient==Player_GetHero(GetOwningPlayer(holder)) or GetUnitTypeId(recipient)=='H01D') then
        call SaveUnitHandle(ForsakenGearTypes,62,GetHandleId(holder),recipient)
    elseif gear!=null and LoadInteger(ForsakenGearTypes,4,GetItemTypeId(gear))!=0 then
        if (order==OrderId("smart") or order==OrderId("getitem")) and not IsItemOwned(gear) and (holder==Player_GetHero(GetOwningPlayer(holder)) or GetUnitTypeId(holder)=='H01D') then
            set replacement=Forsaken_CarryReplacement(null,gear,-1)
            if replacement!=gear then
                set ForsakenConvertingGear=true
                call IssueTargetOrderById(holder,order,replacement)
                set ForsakenConvertingGear=false
            endif
        endif
    endif
    set gear=null
    set recipient=null
    set replacement=null
endfunction

function Forsaken_CarryEvent takes unit holder returns nothing
    local item gear=GetManipulatedItem()
    local item replacement
    local unit recipient
    local timer clock
    if GetTriggerEventId()==EVENT_PLAYER_UNIT_PICKUP_ITEM and GetUnitTypeId(holder)=='H01D' and LoadInteger(ForsakenGearTypes,0,GetItemTypeId(gear))!=0 then
        call SaveBoolean(ForsakenGearTypes,51,GetHandleId(gear),true)
    endif
    if GetTriggerEventId()==EVENT_PLAYER_UNIT_ISSUED_TARGET_ORDER or GetTriggerEventId()==EVENT_PLAYER_UNIT_ISSUED_POINT_ORDER or GetTriggerEventId()==EVENT_PLAYER_UNIT_ISSUED_ORDER then
        call Forsaken_CarryOrder(holder)
    elseif gear!=null and LoadInteger(ForsakenGearTypes,4,GetItemTypeId(gear))!=0 then
        if GetTriggerEventId()==EVENT_PLAYER_UNIT_PICKUP_ITEM and GetUnitTypeId(holder)=='H01D' then
            set replacement=Forsaken_CarryReplacement(holder,gear,-1)
        elseif GetTriggerEventId()==EVENT_PLAYER_UNIT_DROP_ITEM then
            set recipient=LoadUnitHandle(ForsakenGearTypes,62,GetHandleId(holder))
            set clock=CreateTimer()
            call SaveItemHandle(ForsakenGearTypes,60,GetHandleId(clock),gear)
            call SaveUnitHandle(ForsakenGearTypes,61,GetHandleId(clock),recipient)
            call TimerStart(clock,0.,false,function Forsaken_CarryDrop)
        endif
    endif
    set gear=null
    set replacement=null
    set recipient=null
    set clock=null
endfunction
