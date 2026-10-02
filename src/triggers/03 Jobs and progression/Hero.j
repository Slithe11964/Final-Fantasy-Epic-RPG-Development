library THero requires THeroDeath, THeroEndlessGrowth, THeroLevelUp, THeroMedicineEvents, THeroOrder, THeroSelect
function InitTrig_Hero takes nothing returns nothing
endfunction

// Startup registration, part 1 of 4: creates the triggers below, in this order. Called once from
// Startup_RegisterTriggers (MapBootstrap). Each Register_* function sits in the module that
// holds that trigger's code (search for its name).
// Registered in parts so triggers sharing an event with other modules keep their firing order.
function RegisterTriggers_Hero_Part1 takes nothing returns nothing
    call Register_Hero_LevelUp()
    call Register_Hero_EndlessGrowth() // starts off; run by Job
endfunction

// Startup registration, part 2 of 4: creates the triggers below, in this order. Called once from
// Startup_RegisterTriggers (MapBootstrap). Each Register_* function sits in the module that
// holds that trigger's code (search for its name).
// Registered in parts so triggers sharing an event with other modules keep their firing order.
function RegisterTriggers_Hero_Part2 takes nothing returns nothing
    call Register_Hero_Death_Revive()
    call Register_Hero_Order_Cooldown()
endfunction

// Startup registration, part 3 of 4: creates the triggers below, in this order. Called once from
// Startup_RegisterTriggers (MapBootstrap). Each Register_* function sits in the module that
// holds that trigger's code (search for its name).
// Registered in parts so triggers sharing an event with other modules keep their firing order.
function RegisterTriggers_Hero_Part3 takes nothing returns nothing
    call Register_Hero_Medicine_Pickup() // enabled by HeroMedicine
endfunction

// Startup registration, part 4 of 4: creates the triggers below, in this order. Called once from
// Startup_RegisterTriggers (MapBootstrap). Each Register_* function sits in the module that
// holds that trigger's code (search for its name).
// Registered in parts so triggers sharing an event with other modules keep their firing order.
function RegisterTriggers_Hero_Part4 takes nothing returns nothing
    call Register_Hero_Select_Redirect()
endfunction

endlibrary
