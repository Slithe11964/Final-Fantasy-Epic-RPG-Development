library TSummon requires TSummonBahamut, TSummonCyclops, TSummonGolem, TSummonIfrit, TSummonItems, TSummonLifecycle, TSummonScaling, TSummonShiva, TSummonTransfusion
function InitTrig_Summon takes nothing returns nothing
endfunction

// Startup registration, part 1 of 4: creates the triggers below, in this order. Called once from
// Startup_RegisterTriggers (MapBootstrap). Each Register_* function sits in the module that
// holds that trigger's code (search for its name).
// Registered in parts so triggers sharing an event with other modules keep their firing order.
function RegisterTriggers_Summon_Part1 takes nothing returns nothing
    call Register_Summon_Detect()
    call Register_Summon_Powerup() // starts off; run by Animal, BattleWard, Lancer +10 more
endfunction

// Startup registration, part 2 of 4: creates the triggers below, in this order. Called once from
// Startup_RegisterTriggers (MapBootstrap). Each Register_* function sits in the module that
// holds that trigger's code (search for its name).
// Registered in parts so triggers sharing an event with other modules keep their firing order.
function RegisterTriggers_Summon_Part2 takes nothing returns nothing
    call Register_Summon_Shiva()
    call Register_Summon_Ifrit()
    call Register_Summon_Golem()
    call Register_Summon_Cyclops()
    call Register_Summon_Bahamut()
endfunction

// Startup registration, part 3 of 4: creates the triggers below, in this order. Called once from
// Startup_RegisterTriggers (MapBootstrap). Each Register_* function sits in the module that
// holds that trigger's code (search for its name).
// Registered in parts so triggers sharing an event with other modules keep their firing order.
function RegisterTriggers_Summon_Part3 takes nothing returns nothing
    call Register_Summon_Transfusion_Consume()
    call Register_Summon_Death_Cleanup()
endfunction

// Startup registration, part 4 of 4: creates the triggers below, in this order. Called once from
// Startup_RegisterTriggers (MapBootstrap). Each Register_* function sits in the module that
// holds that trigger's code (search for its name).
// Registered in parts so triggers sharing an event with other modules keep their firing order.
function RegisterTriggers_Summon_Part4 takes nothing returns nothing
    call Register_Summon_Item_Dropped() // starts off; enabled by Glyph
endfunction

endlibrary
