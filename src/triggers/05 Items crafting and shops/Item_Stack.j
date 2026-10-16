library TItemStack requires TPlayerHero, optional TBackpack, optional TEquip
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Item_Stack_Order=null
    trigger gg_trg_Item_Stack_Pickup=null
    item ItemStackGatherItem=null
    integer ItemStackGatherOwner=0
endglobals

// Shared item lookup; only the storage adapter differs between map profiles.
function Carry_Type takes item carried returns integer
    local integer raw=GetItemTypeId(carried)
    static if not LIBRARY_TBackpack then
        local integer original=LoadInteger(ForsakenGearTypes,4,raw)
        if original!=0 then
            return original
        endif
    endif
    return raw
endfunction

function Carry_Size takes unit holder returns integer
    static if LIBRARY_TBackpack then
        if Gear_IsPlayerHero(holder) then
            return 6+BACKPACK_PAGES*BACKPACK_SLOTS
        endif
        return 6
    else
        return 6+UnitExtendedInventorySize(holder)+9
    endif
endfunction

function Carry_At takes unit holder,integer slot returns item
    if slot<6 then
        return UnitItemInSlot(holder,slot)
    endif
    static if LIBRARY_TBackpack then
        set slot=slot-6
        return UnitItemInSlot(BackpackHolder[GetPlayerId(GetOwningPlayer(holder))*8+slot/BACKPACK_SLOTS],ModuloInteger(slot,BACKPACK_SLOTS))
    else
        set slot=slot-6
        if slot<UnitExtendedInventorySize(holder) then
            return UnitItemInBagSlot(holder,slot)
        endif
        return UnitItemInEquipmentSlot(holder,ConvertLoadoutSlot(slot-UnitExtendedInventorySize(holder)))
    endif
endfunction

function Carry_Find takes unit holder,integer raw returns item
    local integer slot=0
    local integer size=Carry_Size(holder)
    local item carried
    loop
        exitwhen slot>=size
        set carried=Carry_At(holder,slot)
        if carried!=null and Carry_Type(carried)==raw then
            return carried
        endif
        set slot=slot+1
    endloop
    return null
endfunction

function Carry_Has takes unit holder,integer raw returns boolean
    return Carry_Find(holder,raw)!=null
endfunction

function Carry_Worn takes unit holder,integer raw returns boolean
    static if LIBRARY_TBackpack then
        return Gear_WornOfType(holder,raw)!=null
    else
        local integer slot=0
        loop
            exitwhen slot>=9
            if Carry_Type(UnitItemInEquipmentSlot(holder,ConvertLoadoutSlot(slot)))==raw then
                return true
            endif
            set slot=slot+1
        endloop
        return false
    endif
endfunction

function ItemStack_Eligible takes item picked returns boolean
    return picked!=null and (GetItemType(picked)==ITEM_TYPE_CHARGED or GetItemTypeId(picked)=='I03Y') and GetItemLevel(picked)>=2 and GetItemCharges(picked)>0
endfunction

function ItemStack_MergePair takes item picked,item target,integer ownerId returns nothing
    local integer amount
    local integer bound=GetItemUserData(picked)
    local integer other=GetItemUserData(target)
    if picked==target or target==null or not ItemStack_Eligible(picked) or GetItemTypeId(picked)!=GetItemTypeId(target) or GetItemCharges(target)<=0 or GetItemCharges(target)>=99 then
        return
    endif
    if (bound!=0 and bound!=ownerId) or (other!=0 and other!=ownerId) then
        return
    endif
    set amount=IMinBJ(GetItemCharges(picked),99-GetItemCharges(target))
    call SetItemCharges(target,GetItemCharges(target)+amount)
    if bound!=0 and other==0 then
        call SetItemUserData(target,bound)
    endif
    if amount==GetItemCharges(picked) then
        call RemoveItem(picked)
    else
        call SetItemCharges(picked,GetItemCharges(picked)-amount)
        if other!=0 and bound==0 then
            call SetItemUserData(picked,other)
        endif
    endif
endfunction

function ItemStack_MergeUnit takes unit holder,item picked returns nothing
    local integer slot=0
    local integer size=Carry_Size(holder)
    loop
        exitwhen slot>=size or GetItemTypeId(picked)==0
        call ItemStack_MergePair(picked,Carry_At(holder,slot),GetPlayerId(GetOwningPlayer(holder))+1)
        set slot=slot+1
    endloop
endfunction

function ItemStack_ConsolidateUnit takes unit holder returns nothing
    local integer slot=0
    local integer size=Carry_Size(holder)
    local item picked
    loop
        exitwhen slot>=size
        set picked=Carry_At(holder,slot)
        if ItemStack_Eligible(picked) then
            call ItemStack_MergeUnit(holder,picked)
        endif
        set slot=slot+1
    endloop
    set picked=null
endfunction

function ItemStack_GroundMatch takes nothing returns nothing
    local item target=GetEnumItem()
    if IsItemVisible(target) and not IsItemOwned(target) then
        call ItemStack_MergePair(ItemStackGatherItem,target,ItemStackGatherOwner)
        if GetItemTypeId(ItemStackGatherItem)==0 then
            set ItemStackGatherItem=target
        endif
    endif
    set target=null
endfunction

function ItemStack_MergeGround takes item picked,rect area,integer ownerId returns nothing
    local item previous=ItemStackGatherItem
    local integer previousOwner=ItemStackGatherOwner
    set ItemStackGatherItem=picked
    set ItemStackGatherOwner=ownerId
    call EnumItemsInRect(area,null,function ItemStack_GroundMatch)
    set ItemStackGatherItem=previous
    set ItemStackGatherOwner=previousOwner
    set previous=null
endfunction

function Trig_Item_Stack_Order_Conditions takes nothing returns boolean
    return GetIssuedOrderId()>=$D0022 and GetIssuedOrderId()<=$D0027 and IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers) // $D0022 = 852002; $D0027 = 852007
endfunction

function Trig_Item_Stack_Order_Actions takes nothing returns nothing
    local unit a=GetOrderedUnit()
    local item b=GetOrderTargetItem()
    local item c=UnitItemInSlot(a,(GetIssuedOrderId()-$D0022)) // $D0022 = 852002
    local integer d=GetItemCharges(b)
    local integer e=GetItemLevel(b)
    local integer f=GetItemCharges(c)
    local integer g=GetItemUserData(b)
    local integer h=GetItemUserData(c)
    if d!=0 and c!=null and f!=0 and e!=0 and GetItemType(b)==ITEM_TYPE_CHARGED then
        if b==c then
            if d>1 then
                call DisableTrigger(gg_trg_Item_Stack_Pickup)
                set c=CreateItem(GetItemTypeId(b),0,0)
                call UnitAddItem(a,c)
                if(not IsItemOwned(c))then
                    call RemoveItem(c)
                else
                    set e=R2I(d/ 2)
                    set f=d-e
                    call SetItemCharges(c,e)
                    call SetItemCharges(b,f)
                    call SetItemUserData(c,g)
                endif
                call EnableTrigger(gg_trg_Item_Stack_Pickup)
            endif
        else
            if GetItemTypeId(c)==GetItemTypeId(b)then
                if g==h or g==0 or h==0 then
                    if(d+f<=e)then
                        call RemoveItem(b)
                        call SetItemCharges(c,d+f)
                        if(g!=0)then
                            call SetItemUserData(c,g)
                        endif
                    elseif(d<e and f<e)then
                        call SetItemCharges(c,e)
                        call SetItemCharges(b,d+f-e)
                        if h==0 then
                            call SetItemUserData(c,g)
                        elseif g==0 then
                            call SetItemUserData(b,h)
                        endif
                    endif
                else
                    call DisplayTimedTextToPlayer(GetOwningPlayer(a),0,0,$A,"|cFFFF0000These 2 items belong to different players and cannot be stacked!|r") // $A = 10
                endif
            endif
        endif
    endif
    set a=null
    set b=null
    set c=null
endfunction

function Trig_Item_Stack_Pickup_IsStackable takes nothing returns boolean
    return(GetItemType(GetManipulatedItem())==ITEM_TYPE_CHARGED)or(GetItemTypeId(GetManipulatedItem())=='I03Y') // 'I03Y': item "Exotic Stone"
endfunction

function Trig_Item_Stack_Pickup_PickedIsMine takes nothing returns boolean
    return(GetItemUserData(GetManipulatedItem())==0)or(GetItemUserData(GetManipulatedItem())==GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit())))
endfunction

function Trig_Item_Stack_Pickup_Conditions takes nothing returns boolean
    return ItemStack_Eligible(GetManipulatedItem()) and IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers) and Trig_Item_Stack_Pickup_PickedIsMine()
endfunction

function Trig_Item_Stack_Pickup_PickedFreeSlotMine takes nothing returns boolean
    return(GetItemUserData(GetManipulatedItem())==0)and(GetItemUserData(UnitItemInSlotBJ(GetTriggerUnit(),udg_SlotIndex))==GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit())))
endfunction

function Trig_Item_Stack_Pickup_FitsInStack takes nothing returns boolean
    return((GetItemCharges(GetManipulatedItem())+GetItemCharges(UnitItemInSlotBJ(GetTriggerUnit(),udg_SlotIndex)))<=99)
endfunction

function Trig_Item_Stack_Pickup_PickedMineSlotFree takes nothing returns boolean
    return(GetItemUserData(GetManipulatedItem())==GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit())))and(GetItemUserData(UnitItemInSlotBJ(GetTriggerUnit(),udg_SlotIndex))==0)
endfunction

function Trig_Item_Stack_Pickup_SlotIsMine takes nothing returns boolean
    return(GetItemUserData(UnitItemInSlotBJ(GetTriggerUnit(),udg_SlotIndex))==0)or(GetItemUserData(UnitItemInSlotBJ(GetTriggerUnit(),udg_SlotIndex))==GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit())))
endfunction

function Trig_Item_Stack_Pickup_SlotStackable takes nothing returns boolean
    return(GetItemTypeId(UnitItemInSlotBJ(GetTriggerUnit(),udg_SlotIndex))==GetItemTypeId(GetManipulatedItem()))and(GetManipulatedItem()!=UnitItemInSlotBJ(GetTriggerUnit(),udg_SlotIndex))and(GetItemCharges(UnitItemInSlotBJ(GetTriggerUnit(),udg_SlotIndex))<99)and(GetItemCharges(UnitItemInSlotBJ(GetTriggerUnit(),udg_SlotIndex))!=0)and(Trig_Item_Stack_Pickup_SlotIsMine())
endfunction

function Trig_Item_Stack_Pickup_Actions takes nothing returns nothing
    call ItemStack_MergeUnit(GetTriggerUnit(),GetManipulatedItem())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Item_Stack takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Item_Part1 (module Item),
// which keeps the original registration order.

function Register_Item_Stack_Order takes nothing returns nothing
    set gg_trg_Item_Stack_Order=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Item_Stack_Order,EVENT_PLAYER_UNIT_ISSUED_TARGET_ORDER)
    call TriggerAddCondition(gg_trg_Item_Stack_Order,Condition(function Trig_Item_Stack_Order_Conditions))
    call TriggerAddAction(gg_trg_Item_Stack_Order,function Trig_Item_Stack_Order_Actions)
endfunction

function Register_Item_Stack_Pickup takes nothing returns nothing
    set gg_trg_Item_Stack_Pickup=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Item_Stack_Pickup,EVENT_PLAYER_UNIT_PICKUP_ITEM)
    call TriggerAddCondition(gg_trg_Item_Stack_Pickup,Condition(function Trig_Item_Stack_Pickup_Conditions))
    call TriggerAddAction(gg_trg_Item_Stack_Pickup,function Trig_Item_Stack_Pickup_Actions)
endfunction

endlibrary
