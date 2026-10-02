library TFix
globals
    // Variables only this module uses (MapBootstrap sets some starting values).
    hashtable udg_FixChemistItemHash=null
    item array udg_FixItemSlotDummy
endglobals

function Fix_ItemSlot_Add takes unit u,item it,integer slot returns nothing
    local integer i=0
    if(slot<0 or slot>=bj_MAX_INVENTORY or UnitItemInSlot(u,slot)!=null)then
        call UnitAddItem(u,it)
        return
    endif
    call DisableTrigger(gg_trg_Equip_Restrictions)
    loop
        exitwhen i>=slot
        if(UnitItemInSlot(u,i)==null)then
            set udg_FixItemSlotDummy[i]=UnitAddItemByIdSwapped('I0ZB',u) // 'I0ZB': item "Fix slot filler"
        else
            set udg_FixItemSlotDummy[i]=null
        endif
        set i=i+1
    endloop
    call UnitAddItem(u,it)
    set i=0
    loop
        exitwhen i>=slot
        if(udg_FixItemSlotDummy[i]!=null)then
            call RemoveItem(udg_FixItemSlotDummy[i])
            set udg_FixItemSlotDummy[i]=null
        endif
        set i=i+1
    endloop
    call EnableTrigger(gg_trg_Equip_Restrictions)
endfunction

function Fix_ChemistItem_RemoveLater_Expire takes nothing returns nothing
    local timer expiredTimer=GetExpiredTimer()
    local item i=LoadItemHandle(udg_FixChemistItemHash,GetHandleId(expiredTimer),0)
    if(i!=null and GetItemTypeId(i)!=0)then
        call RemoveItem(i)
    endif
    call FlushChildHashtable(udg_FixChemistItemHash,GetHandleId(expiredTimer))
    call DestroyTimer(expiredTimer)
    set expiredTimer=null
    set i=null
endfunction

function Fix_ChemistItem_RemoveLater takes item i returns nothing
    local timer effectTimer=CreateTimer()
    call SetItemCharges(i,0)
    call SaveItemHandle(udg_FixChemistItemHash,GetHandleId(effectTimer),0,i)
    call TimerStart(effectTimer,0.,false,function Fix_ChemistItem_RemoveLater_Expire)
    set effectTimer=null
endfunction

function InitTrig_Fix takes nothing returns nothing
endfunction

endlibrary
