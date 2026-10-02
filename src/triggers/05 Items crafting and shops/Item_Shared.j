library TItemShared requires TFix, TPlayerHero, TSound, TUnit
function Item_FindSlotForType takes unit u,itemtype l_slotType returns integer
    local integer i=0
    local integer l_freeSlot=-2
    local boolean l_isConsumable=(l_slotType==ITEM_TYPE_CAMPAIGN or l_slotType==ITEM_TYPE_CHARGED)
    local boolean l_dualWield=(l_slotType==ITEM_TYPE_POWERUP and GetUnitAbilityLevel(u,'A0HP')>0) // 'A0HP': ability "Dual Wield"
    local item l_firstPermanent=null
    local item l_itm
    loop
        set l_itm=UnitItemInSlot(u,i)
        if(l_freeSlot==-2 and(l_itm==null or(GetItemType(l_itm)==ITEM_TYPE_CAMPAIGN or GetItemType(l_itm)==ITEM_TYPE_CHARGED)))then
            if l_itm==null then
                set l_freeSlot=-1
            else
                set l_freeSlot=i
            endif
            if l_isConsumable then
                set l_itm=null
                set u=null
                return l_freeSlot
            endif
        elseif(GetItemType(l_itm)==l_slotType)then
            set l_itm=null
            set u=null
            return i
        elseif(l_dualWield and GetItemType(l_itm)==ITEM_TYPE_PERMANENT)then
            if(l_firstPermanent==null)then
                set l_firstPermanent=l_itm
            else
                set l_firstPermanent=null
                set l_itm=null
                set u=null
                return i
            endif
        endif
        set i=i+1
        exitwhen i>=bj_MAX_INVENTORY
    endloop
    set l_itm=null
    set u=null
    return l_freeSlot
endfunction

function Item_UseFromOtherUnit takes unit l_holder,integer l_slotIdx,integer l_orderType returns nothing
    local player p
    local unit l_hero
    local unit targetUnit
    local item l_swapped
    local item l_itm=UnitItemInSlot(l_holder,l_slotIdx)
    local boolean l_used
    local boolean l_used2
    local integer l_charges
    local integer l_swapSlot
    local real x
    local real y
    if(GetItemType(l_itm)==ITEM_TYPE_CAMPAIGN)then
        set l_itm=null
        return
    endif
    set p=GetOwningPlayer(l_holder)
    set l_hero=Player_GetHero(p)
    if(l_orderType==1)then
        set x=GetOrderPointX()
        set y=GetOrderPointY()
    elseif(l_orderType==2)then
        set targetUnit=GetOrderTargetUnit()
        set x=GetUnitX(targetUnit)
        set y=GetUnitY(targetUnit)
    endif
    set udg_ItemUseReplacement=null
    set l_charges=GetItemCharges(l_itm)
    call PauseUnit(l_holder,true)
    call IssueImmediateOrderById(l_holder,$D0004) // $D0004 = 851972
    call PauseUnit(l_holder,false)
    set l_swapSlot=Item_FindSlotForType(l_hero,GetItemType(l_itm))
    if(l_swapSlot>=0)then
        set l_swapped=UnitRemoveItemFromSlot(l_hero,l_swapSlot)
        call SetItemVisible(l_swapped,false)
    endif
    call DisableTrigger(gg_trg_Item_Stack_Pickup)
    call UnitAddItem(l_hero,l_itm)
    if(l_orderType==0)then
        set l_used=UnitUseItem(l_hero,l_itm)
    else
        if(l_orderType==1 or GetOrderTargetUnit()!=l_hero)then
            call SetUnitFacingTimed(l_hero,Unit_AngleToPoint(l_hero,x,y),0)
        endif
        if(l_orderType==1)then
            set l_used=UnitUseItemPoint(l_hero,l_itm,x,y)
        elseif(l_orderType==2)then
            set l_used=UnitUseItemTarget(l_hero,l_itm,targetUnit)
            set l_used2=UnitUseItemTarget(l_hero,l_itm,targetUnit)
            if(l_used==l_used2)then
                set l_used=false
            endif
        endif
    endif
    if(not l_used)then
        if(l_orderType!=1)then
            call Sound_PlayError(p,"Couldn't use "+GetItemName(l_itm))
        endif
        call IssueImmediateOrderById(l_hero,$D0004) // $D0004 = 851972
    endif
    if(udg_ItemUseReplacement!=null)then
        set l_itm=udg_ItemUseReplacement
        set l_charges=0
    endif
    if(GetItemCharges(l_itm)!=0 or l_charges==0)then
        set l_charges=GetItemCharges(l_itm)
        if(l_charges>0)then
            call SetItemCharges(l_itm,0)
            call Fix_ItemSlot_Add(l_holder,l_itm,l_slotIdx)
            call SetItemCharges(l_itm,l_charges)
        else
            call Fix_ItemSlot_Add(l_holder,l_itm,l_slotIdx)
        endif
    endif
    if(l_swapSlot>=0)then
        call SetItemVisible(l_swapped,true)
        call Fix_ItemSlot_Add(l_hero,l_swapped,l_swapSlot)
    endif
    call EnableTrigger(gg_trg_Item_Stack_Pickup)
    set p=null
    set targetUnit=null
    set l_hero=null
    set l_holder=null
    set l_swapped=null
    set l_itm=null
endfunction

function Item_IdFromIndex takes integer i returns integer
    if(i<$3E8)then // $3E8 = 1000
        return udg_DropItemIdTable[i]
    elseif(i<$7D0)then // $7D0 = 2000
        // (i) minus (1000).
        return udg_ItemIdTable[i-$3E8] // $3E8 = 1000
    elseif(i<$BB8)then // $BB8 = 3000
        // (i) minus (2000).
        return udg_LevelItemIdTable[i-$7D0] // $7D0 = 2000
    endif
    return 0
endfunction

function Item_ExpireDrop takes nothing returns nothing
    local timer expiredTimer=GetExpiredTimer()
    local item l_dropped=LoadItemHandle(udg_DropItemHash,GetHandleId(expiredTimer),2)
    call FlushChildHashtable(udg_DropItemHash,GetHandleId(expiredTimer))
    call FlushChildHashtable(udg_DropItemHash,GetHandleId(l_dropped))
    call SetItemVisible(l_dropped,false)
    call RemoveItem(l_dropped)
    call DestroyTimer(expiredTimer)
    set expiredTimer=null
    set l_dropped=null
endfunction

function InitTrig_Item_Shared takes nothing returns nothing
endfunction

endlibrary
