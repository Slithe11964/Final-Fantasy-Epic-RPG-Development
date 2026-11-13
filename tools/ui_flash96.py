"""Gear transition cleanup must not run on ordinary move/attack orders."""
from jtok import functions
from performance_runtime import put

def refresh(source):
 fs=functions(source)
 if 'Forsaken_OnEquip' not in fs:return source
 n='Forsaken_OnEquip';b=fs[n]
 anchor='    call Inventory94_Changed(holder)'
 assert b.count(anchor)==1
 b=b.replace(anchor,'''    // This trigger also observes movement/attack orders for item transfers.
    // Only actual item changes may suspend and clear the inventory UI.
    if GetTriggerEventId()==EVENT_PLAYER_UNIT_EQUIP_ITEM or GetTriggerEventId()==EVENT_PLAYER_UNIT_UNEQUIP_ITEM or GetTriggerEventId()==EVENT_PLAYER_UNIT_PICKUP_ITEM or GetTriggerEventId()==EVENT_PLAYER_UNIT_DROP_ITEM then
        call Inventory94_Changed(holder)
    elseif (GetTriggerEventId()==EVENT_PLAYER_UNIT_ISSUED_TARGET_ORDER or GetTriggerEventId()==EVENT_PLAYER_UNIT_ISSUED_POINT_ORDER or GetTriggerEventId()==EVENT_PLAYER_UNIT_ISSUED_ORDER) and GetIssuedOrderId()>=852002 and GetIssuedOrderId()<=852007 and GetOrderTargetItem()!=null then
        call Inventory94_Changed(holder)
    endif''',1)
 source=put(source,n,b)
 n='Inventory94_ClearLocal';b=fs[n]
 anchor=' call BlzFrameSetVisible(CarryUIRoot,false)';assert anchor in b
 b=b.replace(anchor,' call CarryUI_Close()',1)
 source=put(source,n,b)
 n='CarryUI_Init';b=fs[n]
 anchor='    call BlzFrameSetSize(CarryUIButton,.085,.025)';assert anchor in b
 b=b.replace(anchor,anchor+'\n    call BlzFrameSetLevel(CarryUIButton,60)',1)
 source=put(source,n,b)
 return source
