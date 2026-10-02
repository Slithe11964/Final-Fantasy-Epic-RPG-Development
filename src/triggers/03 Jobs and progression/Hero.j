library THero requires optional THeroDeath, optional THeroEndlessGrowth, optional THeroLevelUp, optional THeroMedicineEvents, optional THeroOrder, optional THeroSelect
function InitTrig_Hero takes nothing returns nothing
endfunction

// Startup registration, part 1 of 4: creates the triggers below, in this order. Called once from
// Startup_RegisterTriggers (MapBootstrap). Each Register_* function sits in the module that
// holds that trigger's code (search for its name).
// Registered in parts so triggers sharing an event with other modules keep their firing order.
function RegisterTriggers_Hero_Part1 takes nothing returns nothing
    static if LIBRARY_THeroLevelUp then
        call Register_Hero_LevelUp()
    endif
    static if LIBRARY_THeroEndlessGrowth then
        call Register_Hero_EndlessGrowth() // starts off; run by Job
    endif
endfunction

// Startup registration, part 2 of 4: creates the triggers below, in this order. Called once from
// Startup_RegisterTriggers (MapBootstrap). Each Register_* function sits in the module that
// holds that trigger's code (search for its name).
// Registered in parts so triggers sharing an event with other modules keep their firing order.
function RegisterTriggers_Hero_Part2 takes nothing returns nothing
    static if LIBRARY_THeroDeath then
        call Register_Hero_Death_Revive()
    endif
    static if LIBRARY_THeroOrder then
        call Register_Hero_Order_Cooldown()
    endif
endfunction

// Startup registration, part 3 of 4: creates the triggers below, in this order. Called once from
// Startup_RegisterTriggers (MapBootstrap). Each Register_* function sits in the module that
// holds that trigger's code (search for its name).
// Registered in parts so triggers sharing an event with other modules keep their firing order.
function RegisterTriggers_Hero_Part3 takes nothing returns nothing
    static if LIBRARY_THeroMedicineEvents then
        call Register_Hero_Medicine_Pickup() // enabled by HeroMedicine
    endif
endfunction

// Startup registration, part 4 of 4: creates the triggers below, in this order. Called once from
// Startup_RegisterTriggers (MapBootstrap). Each Register_* function sits in the module that
// holds that trigger's code (search for its name).
// Registered in parts so triggers sharing an event with other modules keep their firing order.
function RegisterTriggers_Hero_Part4 takes nothing returns nothing
    static if LIBRARY_THeroSelect then
        call Register_Hero_Select_Redirect()
    endif
endfunction

endlibrary
