library TGaya requires TGayaAppearance, TGayaChanneling, TGayaInventory, TGayaMovement, TGayaOrders, TGayaScan, TGayaStats, TGayaSupport
function InitTrig_Gaya takes nothing returns nothing
endfunction

// Startup registration: creates the triggers below, in this order. Called once from
// Startup_RegisterTriggers (MapBootstrap). Each Register_* function sits in the module that
// holds that trigger's code (search for its name).
function RegisterTriggers_Gaya takes nothing returns nothing
    call Register_Gaya_Follow() // starts off; enabled by Game
    call Register_Gaya_ChannelStart()
    call Register_Gaya_ChannelEnd()
    call Register_Gaya_SetTint()
    call Register_Gaya_ShopPurchase()
    call Register_Gaya_RefreshStats()
    call Register_Gaya_ItemChanged()
    call Register_Gaya_HousePortal()
    call Register_Gaya_BreakStun()
    call Register_Gaya_ManaTransfer()
    call Register_Gaya_MegaHeal()
    call Register_Gaya_Scan()
    call Register_Gaya_GatherItems()
    call Register_Gaya_OrderImmediate()
    call Register_Gaya_OrderPoint()
    call Register_Gaya_OrderTarget()
endfunction

endlibrary
