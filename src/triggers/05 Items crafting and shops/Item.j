library TItem requires optional TItemCooldown, optional TItemStack, optional TItemUpgrade
function InitTrig_Item takes nothing returns nothing
endfunction

// Startup registration, part 1 of 3: creates the triggers below, in this order. Called once from
// Startup_RegisterTriggers (MapBootstrap). Each Register_* function sits in the module that
// holds that trigger's code (search for its name).
// Registered in parts so triggers sharing an event with other modules keep their firing order.
function RegisterTriggers_Item_Part1 takes nothing returns nothing
    static if LIBRARY_TItemStack then
        call Register_Item_Stack_Order()
        call Register_Item_Stack_Pickup() // enabled by Item_Stack, Cmd, Item_Shared; disabled by Item_Stack, Cmd, Item_Shared
    endif
endfunction

// Startup registration, part 2 of 3: creates the triggers below, in this order. Called once from
// Startup_RegisterTriggers (MapBootstrap). Each Register_* function sits in the module that
// holds that trigger's code (search for its name).
// Registered in parts so triggers sharing an event with other modules keep their firing order.
function RegisterTriggers_Item_Part2 takes nothing returns nothing
    static if LIBRARY_TItemCooldown then
        call Register_Item_Cooldown_Start()
    endif
endfunction

// Startup registration, part 3 of 3: creates the triggers below, in this order. Called once from
// Startup_RegisterTriggers (MapBootstrap). Each Register_* function sits in the module that
// holds that trigger's code (search for its name).
// Registered in parts so triggers sharing an event with other modules keep their firing order.
function RegisterTriggers_Item_Part3 takes nothing returns nothing
    static if LIBRARY_TItemUpgrade then
        call Register_Item_Upgrade_Watera()
        call Register_Item_Upgrade_Wateraga()
        call Register_Item_Upgrade_Quakera()
        call Register_Item_Upgrade_Quakeraga()
        call Register_Item_Upgrade_Demira()
        call Register_Item_Upgrade_Demiga()
        call Register_Item_Upgrade_Aerora()
        call Register_Item_Upgrade_Aeroga()
    endif
endfunction

endlibrary
