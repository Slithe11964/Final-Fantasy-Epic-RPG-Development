library TChocobo requires optional TChocoboBreeding, optional TChocoboBribing, optional TChocoboDigging, optional TChocoboPopulation, optional TChocoboTaming, optional TChocoboTechCopy, optional TChocoboUpgrades, optional TChocoboWildBehavior
function InitTrig_Chocobo takes nothing returns nothing
endfunction

// Startup registration, part 1 of 2: creates the triggers below, in this order. Called once from
// Startup_RegisterTriggers (MapBootstrap). Each Register_* function sits in the module that
// holds that trigger's code (search for its name).
// Registered in parts so triggers sharing an event with other modules keep their firing order.
function RegisterTriggers_Chocobo_Part1 takes nothing returns nothing
    static if LIBRARY_TChocoboPopulation then
        call Register_Chocobo_Init()
        call Register_Chocobo_Spawn_Periodic()
    endif
    static if LIBRARY_TChocoboWildBehavior then
        call Register_Chocobo_Wild_Death()
    endif
    static if LIBRARY_TChocoboTaming then
        call Register_Chocobo_Tame_Limit()
        call Register_Chocobo_Tame_Breed()
    endif
    static if LIBRARY_TChocoboWildBehavior then
        call Register_Chocobo_Wild_Retaliate()
    endif
    static if LIBRARY_TChocoboBreeding then
        call Register_Chocobo_Breed_Score() // starts off; run by Chocobo_Taming
    endif
    static if LIBRARY_TChocoboDigging then
        call Register_Chocobo_DeadPepper_Dig()
    endif
    static if LIBRARY_TChocoboUpgrades then
        call Register_Chocobo_Gysahl_Upgrade()
        call Register_Chocobo_Mimett_Upgrade()
        call Register_Chocobo_Silkis_Upgrade()
    endif
    static if LIBRARY_TChocoboDigging then
        call Register_Chocobo_DigSpot_Nearest() // run by Chocobo_Digging
    endif
    static if LIBRARY_TChocoboBribing then
        call Register_Chocobo_Bribe()
    endif
    static if LIBRARY_TChocoboUpgrades then
        call Register_Chocobo_Defend_Upgrade()
    endif
    static if LIBRARY_TChocoboTechCopy then
        call Register_Chocobo_TechCopy()
    endif
    static if LIBRARY_TChocoboWildBehavior then
        call Register_Chocobo_Wild_AI()
    endif
endfunction

// Startup registration, part 2 of 2: creates the triggers below, in this order. Called once from
// Startup_RegisterTriggers (MapBootstrap). Each Register_* function sits in the module that
// holds that trigger's code (search for its name).
// Registered in parts so triggers sharing an event with other modules keep their firing order.
function RegisterTriggers_Chocobo_Part2 takes nothing returns nothing
    static if LIBRARY_TChocoboPopulation then
        call Register_Chocobo_Respawn()
    endif
    static if LIBRARY_TChocoboDigging then
        call Register_Chocobo_Drop_Nut() // starts off; enabled by Chocobo_Population
    endif
endfunction

endlibrary
