library TGaya requires optional TGayaAppearance, optional TGayaChanneling, optional TGayaInventory, optional TGayaMovement, optional TGayaOrders, optional TGayaScan, optional TGayaStats, optional TGayaSupport
function InitTrig_Gaya takes nothing returns nothing
endfunction

// Startup registration: creates the triggers below, in this order. Called once from
// Startup_RegisterTriggers (MapBootstrap). Each Register_* function sits in the module that
// holds that trigger's code (search for its name).
function RegisterTriggers_Gaya takes nothing returns nothing
    static if LIBRARY_TGayaMovement then
        call Register_Gaya_Follow() // starts off; enabled by Game
    endif
    static if LIBRARY_TGayaChanneling then
        call Register_Gaya_ChannelStart()
        call Register_Gaya_ChannelEnd()
    endif
    static if LIBRARY_TGayaAppearance then
        call Register_Gaya_SetTint()
    endif
    static if LIBRARY_TGayaInventory then
        call Register_Gaya_ShopPurchase()
    endif
    static if LIBRARY_TGayaStats then
        call Register_Gaya_RefreshStats()
    endif
    static if LIBRARY_TGayaInventory then
        call Register_Gaya_ItemChanged()
    endif
    static if LIBRARY_TGayaMovement then
        call Register_Gaya_HousePortal()
    endif
    static if LIBRARY_TGayaSupport then
        call Register_Gaya_BreakStun()
        call Register_Gaya_ManaTransfer()
        call Register_Gaya_MegaHeal()
    endif
    static if LIBRARY_TGayaScan then
        call Register_Gaya_Scan()
    endif
    static if LIBRARY_TGayaInventory then
        call Register_Gaya_GatherItems()
    endif
    static if LIBRARY_TGayaOrders then
        call Register_Gaya_OrderImmediate()
        call Register_Gaya_OrderPoint()
        call Register_Gaya_OrderTarget()
    endif
endfunction

endlibrary
