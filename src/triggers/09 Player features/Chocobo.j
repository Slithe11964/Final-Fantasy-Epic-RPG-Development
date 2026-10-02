library TChocobo requires TChocoboBreeding, TChocoboBribing, TChocoboDigging, TChocoboPopulation, TChocoboTaming, TChocoboTechCopy, TChocoboUpgrades, TChocoboWildBehavior
function InitTrig_Chocobo takes nothing returns nothing
endfunction

// Startup registration, part 1 of 2: creates the triggers below, in this order. Called once from
// Startup_RegisterTriggers (MapBootstrap). Each Register_* function sits in the module that
// holds that trigger's code (search for its name).
// Registered in parts so triggers sharing an event with other modules keep their firing order.
function RegisterTriggers_Chocobo_Part1 takes nothing returns nothing
    call Register_Chocobo_Init()
    call Register_Chocobo_Spawn_Periodic()
    call Register_Chocobo_Wild_Death()
    call Register_Chocobo_Tame_Limit()
    call Register_Chocobo_Tame_Breed()
    call Register_Chocobo_Wild_Retaliate()
    call Register_Chocobo_Breed_Score() // starts off; run by Chocobo_Taming
    call Register_Chocobo_DeadPepper_Dig()
    call Register_Chocobo_Gysahl_Upgrade()
    call Register_Chocobo_Mimett_Upgrade()
    call Register_Chocobo_Silkis_Upgrade()
    call Register_Chocobo_DigSpot_Nearest() // run by Chocobo_Digging
    call Register_Chocobo_Bribe()
    call Register_Chocobo_Defend_Upgrade()
    call Register_Chocobo_TechCopy()
    call Register_Chocobo_Wild_AI()
endfunction

// Startup registration, part 2 of 2: creates the triggers below, in this order. Called once from
// Startup_RegisterTriggers (MapBootstrap). Each Register_* function sits in the module that
// holds that trigger's code (search for its name).
// Registered in parts so triggers sharing an event with other modules keep their firing order.
function RegisterTriggers_Chocobo_Part2 takes nothing returns nothing
    call Register_Chocobo_Respawn()
    call Register_Chocobo_Drop_Nut() // starts off; enabled by Chocobo_Population
endfunction

endlibrary
