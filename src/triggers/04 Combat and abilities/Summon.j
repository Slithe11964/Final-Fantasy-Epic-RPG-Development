library TSummon requires optional TSummonBahamut, optional TSummonCyclops, optional TSummonGolem, optional TSummonIfrit, optional TSummonItems, optional TSummonLifecycle, optional TSummonScaling, optional TSummonShiva, optional TSummonTransfusion
function InitTrig_Summon takes nothing returns nothing
endfunction

// Startup registration, part 1 of 4: creates the triggers below, in this order. Called once from
// Startup_RegisterTriggers (MapBootstrap). Each Register_* function sits in the module that
// holds that trigger's code (search for its name).
// Registered in parts so triggers sharing an event with other modules keep their firing order.
function RegisterTriggers_Summon_Part1 takes nothing returns nothing
    static if LIBRARY_TSummonLifecycle then
        call Register_Summon_Detect()
    endif
    static if LIBRARY_TSummonScaling then
        call Register_Summon_Powerup() // starts off; run by Animal, BattleWard, Lancer +10 more
    endif
endfunction

// Startup registration, part 2 of 4: creates the triggers below, in this order. Called once from
// Startup_RegisterTriggers (MapBootstrap). Each Register_* function sits in the module that
// holds that trigger's code (search for its name).
// Registered in parts so triggers sharing an event with other modules keep their firing order.
function RegisterTriggers_Summon_Part2 takes nothing returns nothing
    static if LIBRARY_TSummonShiva then
        call Register_Summon_Shiva()
    endif
    static if LIBRARY_TSummonIfrit then
        call Register_Summon_Ifrit()
    endif
    static if LIBRARY_TSummonGolem then
        call Register_Summon_Golem()
    endif
    static if LIBRARY_TSummonCyclops then
        call Register_Summon_Cyclops()
    endif
    static if LIBRARY_TSummonBahamut then
        call Register_Summon_Bahamut()
    endif
endfunction

// Startup registration, part 3 of 4: creates the triggers below, in this order. Called once from
// Startup_RegisterTriggers (MapBootstrap). Each Register_* function sits in the module that
// holds that trigger's code (search for its name).
// Registered in parts so triggers sharing an event with other modules keep their firing order.
function RegisterTriggers_Summon_Part3 takes nothing returns nothing
    static if LIBRARY_TSummonTransfusion then
        call Register_Summon_Transfusion_Consume()
    endif
    static if LIBRARY_TSummonLifecycle then
        call Register_Summon_Death_Cleanup()
    endif
endfunction

// Startup registration, part 4 of 4: creates the triggers below, in this order. Called once from
// Startup_RegisterTriggers (MapBootstrap). Each Register_* function sits in the module that
// holds that trigger's code (search for its name).
// Registered in parts so triggers sharing an event with other modules keep their firing order.
function RegisterTriggers_Summon_Part4 takes nothing returns nothing
    static if LIBRARY_TSummonItems then
        call Register_Summon_Item_Dropped() // starts off; enabled by Glyph
    endif
endfunction

endlibrary
