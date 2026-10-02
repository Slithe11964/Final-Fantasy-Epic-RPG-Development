library TItemStack
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Item_Stack_Order=null
    trigger gg_trg_Item_Stack_Pickup=null
endglobals

function Trig_Item_Stack_Order_Conditions takes nothing returns boolean
    return GetIssuedOrderId()>=$D0022 and GetIssuedOrderId()<=$D0027 and IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers) // $D0022 = 852002; $D0027 = 852007
endfunction

function Trig_Item_Stack_Order_Actions takes nothing returns nothing
    local unit a=GetOrderedUnit()
    local item b=GetOrderTargetItem()
    // Starting value for c:
    // (GetIssuedOrderId()) minus (852002).
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
                    // ((d) divided by (2); drop the remainder) with its decimal part removed.
                    set e=R2I(d/ 2)
                    // (d) minus (e).
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
                    // (d) plus (f).
                    if(d+f<=e)then
                        call RemoveItem(b)
                        // (d) plus (f).
                        call SetItemCharges(c,d+f)
                        if(g!=0)then
                            call SetItemUserData(c,g)
                        endif
                    elseif(d<e and f<e)then
                        call SetItemCharges(c,e)
                        // ((d) plus (f)) minus (e).
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
    return(GetManipulatedItem()!=null)and(Trig_Item_Stack_Pickup_IsStackable())and(GetItemLevel(GetManipulatedItem())>=2)and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(GetItemCharges(GetManipulatedItem())!=0)and(GetItemCharges(GetManipulatedItem())<99)and(Trig_Item_Stack_Pickup_PickedIsMine())
endfunction

function Trig_Item_Stack_Pickup_PickedFreeSlotMine takes nothing returns boolean
    return(GetItemUserData(GetManipulatedItem())==0)and(GetItemUserData(UnitItemInSlotBJ(GetTriggerUnit(),udg_SlotIndex))==GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit())))
endfunction

function Trig_Item_Stack_Pickup_FitsInStack takes nothing returns boolean
    // Result 1: (item charges of the item being used or moved) plus (item charges of UnitItemInSlotBJ(the
    // triggering unit, udg_SlotIndex)).
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
    set udg_SlotIndex=1
    loop
        exitwhen udg_SlotIndex>6
        if(Trig_Item_Stack_Pickup_SlotStackable())then
            if(Trig_Item_Stack_Pickup_FitsInStack())then
                // Result 1: (item charges of UnitItemInSlotBJ(the triggering unit, udg_SlotIndex)) plus (item charges of the
                // item being used or moved).
                call SetItemCharges(UnitItemInSlotBJ(GetTriggerUnit(),udg_SlotIndex),(GetItemCharges(UnitItemInSlotBJ(GetTriggerUnit(),udg_SlotIndex))+GetItemCharges(GetManipulatedItem())))
                call RemoveItem(GetManipulatedItem())
            else
                // Result 1: (99) minus (item charges of UnitItemInSlotBJ(the triggering unit, udg_SlotIndex)).
                // Result 2: (item charges of the item being used or moved) minus (result 1).
                call SetItemCharges(GetManipulatedItem(),(GetItemCharges(GetManipulatedItem())-(99-GetItemCharges(UnitItemInSlotBJ(GetTriggerUnit(),udg_SlotIndex)))))
                call SetItemCharges(UnitItemInSlotBJ(GetTriggerUnit(),udg_SlotIndex),99)
                if(Trig_Item_Stack_Pickup_PickedFreeSlotMine())then
                    call SetItemUserData(GetManipulatedItem(),GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit())))
                endif
            endif
            if(Trig_Item_Stack_Pickup_PickedMineSlotFree())then
                call SetItemUserData(UnitItemInSlotBJ(GetTriggerUnit(),udg_SlotIndex),GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit())))
            endif
        endif
        set udg_SlotIndex=udg_SlotIndex+1
    endloop
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
