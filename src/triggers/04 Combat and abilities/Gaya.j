library TGaya requires TGayaAppearance, TGayaChanneling, TGayaInventory, TGayaMovement, TGayaOrders, TGayaScan, TGayaStats, TGayaSupport
function InitTrig_Gaya takes nothing returns nothing
endfunction

function RegisterR11_Gaya_SetTint takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Gaya_SetTint=CreateTrigger()

call TriggerRegisterTimerEvent(gg_trg_Gaya_SetTint,5,false)

call TriggerAddAction(gg_trg_Gaya_SetTint,function Trig_Gaya_SetTint_Actions)

endfunction





function RegisterR11_Gaya_ChannelStart takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Gaya_ChannelStart=CreateTrigger()

call TriggerRegisterAnyUnitEventBJ(gg_trg_Gaya_ChannelStart,EVENT_PLAYER_UNIT_SPELL_CHANNEL)

call TriggerAddCondition(gg_trg_Gaya_ChannelStart,Condition(function Trig_Gaya_ChannelStart_Conditions))

call TriggerAddAction(gg_trg_Gaya_ChannelStart,function Trig_Gaya_ChannelStart_Actions)

endfunction





function RegisterR11_Gaya_ChannelEnd takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Gaya_ChannelEnd=CreateTrigger()

call TriggerRegisterAnyUnitEventBJ(gg_trg_Gaya_ChannelEnd,EVENT_PLAYER_UNIT_SPELL_ENDCAST)

call TriggerAddCondition(gg_trg_Gaya_ChannelEnd,Condition(function Trig_Gaya_ChannelEnd_Conditions))

call TriggerAddAction(gg_trg_Gaya_ChannelEnd,function Trig_Gaya_ChannelEnd_Actions)

endfunction





function RegisterR11_Gaya_ShopPurchase takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Gaya_ShopPurchase=CreateTrigger()

call TriggerRegisterAnyUnitEventBJ(gg_trg_Gaya_ShopPurchase,EVENT_PLAYER_UNIT_SELL_ITEM)

call TriggerAddCondition(gg_trg_Gaya_ShopPurchase,Condition(function Trig_Gaya_ShopPurchase_Conditions))

call TriggerAddAction(gg_trg_Gaya_ShopPurchase,function Trig_Gaya_ShopPurchase_Actions)

endfunction





function RegisterR11_Gaya_ItemChanged takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Gaya_ItemChanged=CreateTrigger()

call TriggerRegisterAnyUnitEventBJ(gg_trg_Gaya_ItemChanged,EVENT_PLAYER_UNIT_PICKUP_ITEM)

call TriggerRegisterAnyUnitEventBJ(gg_trg_Gaya_ItemChanged,EVENT_PLAYER_UNIT_DROP_ITEM)

call TriggerAddCondition(gg_trg_Gaya_ItemChanged,Condition(function Trig_Gaya_ItemChanged_Conditions))

call TriggerAddAction(gg_trg_Gaya_ItemChanged,function Trig_Gaya_ItemChanged_Actions)

endfunction





function RegisterR11_Gaya_GatherItems takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Gaya_GatherItems=CreateTrigger()

call TriggerRegisterAnyUnitEventBJ(gg_trg_Gaya_GatherItems,EVENT_PLAYER_UNIT_SPELL_EFFECT)

call TriggerAddCondition(gg_trg_Gaya_GatherItems,Condition(function Trig_Gaya_GatherItems_Conditions))

call TriggerAddAction(gg_trg_Gaya_GatherItems,function Trig_Gaya_GatherItems_Actions)

endfunction





function RegisterR11_Gaya_Follow takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Gaya_Follow=CreateTrigger()

call DisableTrigger(gg_trg_Gaya_Follow)

call TriggerRegisterTimerEvent(gg_trg_Gaya_Follow,1.,true)

call TriggerAddAction(gg_trg_Gaya_Follow,function Trig_Gaya_Follow_Actions)

endfunction





function RegisterR11_Gaya_HousePortal takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Gaya_HousePortal=CreateTrigger()

call TriggerRegisterAnyUnitEventBJ(gg_trg_Gaya_HousePortal,EVENT_PLAYER_UNIT_SPELL_CAST)

call TriggerAddCondition(gg_trg_Gaya_HousePortal,Condition(function Trig_Gaya_HousePortal_Conditions))

call TriggerAddAction(gg_trg_Gaya_HousePortal,function Trig_Gaya_HousePortal_Actions)

endfunction





function RegisterR11_Gaya_OrderImmediate takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Gaya_OrderImmediate=CreateTrigger()

call TriggerRegisterAnyUnitEventBJ(gg_trg_Gaya_OrderImmediate,EVENT_PLAYER_UNIT_ISSUED_ORDER)

call TriggerAddCondition(gg_trg_Gaya_OrderImmediate,Condition(function Trig_Gaya_OrderImmediate_Conditions))

call TriggerAddAction(gg_trg_Gaya_OrderImmediate,function Trig_Gaya_OrderImmediate_Actions)

endfunction





function RegisterR11_Gaya_OrderPoint takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Gaya_OrderPoint=CreateTrigger()

call TriggerRegisterAnyUnitEventBJ(gg_trg_Gaya_OrderPoint,EVENT_PLAYER_UNIT_ISSUED_POINT_ORDER)

call TriggerAddCondition(gg_trg_Gaya_OrderPoint,Condition(function Trig_Gaya_OrderPoint_Conditions))

call TriggerAddAction(gg_trg_Gaya_OrderPoint,function Trig_Gaya_OrderPoint_Actions)

endfunction





function RegisterR11_Gaya_OrderTarget takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Gaya_OrderTarget=CreateTrigger()

call TriggerRegisterAnyUnitEventBJ(gg_trg_Gaya_OrderTarget,EVENT_PLAYER_UNIT_ISSUED_TARGET_ORDER)

call TriggerAddCondition(gg_trg_Gaya_OrderTarget,Condition(function Trig_Gaya_OrderTarget_Conditions))

call TriggerAddAction(gg_trg_Gaya_OrderTarget,function Trig_Gaya_OrderTarget_Actions)

endfunction





function RegisterR11_Gaya_Scan takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Gaya_Scan=CreateTrigger()

call TriggerRegisterAnyUnitEventBJ(gg_trg_Gaya_Scan,EVENT_PLAYER_UNIT_SPELL_EFFECT)

call TriggerAddCondition(gg_trg_Gaya_Scan,Condition(function Trig_Gaya_Scan_Conditions))

call TriggerAddAction(gg_trg_Gaya_Scan,function Trig_Gaya_Scan_Actions)

endfunction





function RegisterR11_Gaya_RefreshStats takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Gaya_RefreshStats=CreateTrigger()

call TriggerRegisterTimerExpireEventBJ(gg_trg_Gaya_RefreshStats,udg_LoadRefreshTimer)

call TriggerAddAction(gg_trg_Gaya_RefreshStats,function Trig_Gaya_RefreshStats_Actions)

endfunction





function RegisterR11_Gaya_BreakStun takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Gaya_BreakStun=CreateTrigger()

call TriggerRegisterAnyUnitEventBJ(gg_trg_Gaya_BreakStun,EVENT_PLAYER_UNIT_SPELL_EFFECT)

call TriggerAddCondition(gg_trg_Gaya_BreakStun,Condition(function Trig_Gaya_BreakStun_Conditions))

call TriggerAddAction(gg_trg_Gaya_BreakStun,function Trig_Gaya_BreakStun_Actions)

endfunction





function RegisterR11_Gaya_ManaTransfer takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Gaya_ManaTransfer=CreateTrigger()

call TriggerRegisterAnyUnitEventBJ(gg_trg_Gaya_ManaTransfer,EVENT_PLAYER_UNIT_SPELL_EFFECT)

call TriggerAddCondition(gg_trg_Gaya_ManaTransfer,Condition(function Trig_Gaya_ManaTransfer_Conditions))

call TriggerAddAction(gg_trg_Gaya_ManaTransfer,function Trig_Gaya_ManaTransfer_Actions)

endfunction





function RegisterR11_Gaya_MegaHeal takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Gaya_MegaHeal=CreateTrigger()

call TriggerRegisterAnyUnitEventBJ(gg_trg_Gaya_MegaHeal,EVENT_PLAYER_UNIT_SPELL_EFFECT)

call TriggerAddCondition(gg_trg_Gaya_MegaHeal,Condition(function Trig_Gaya_MegaHeal_Conditions))

call TriggerAddAction(gg_trg_Gaya_MegaHeal,function Trig_Gaya_MegaHeal_Actions)

endfunction





endlibrary
