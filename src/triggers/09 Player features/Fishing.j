library TFishing requires TFishingCasting, TFishingEncounters, TFishingReelingAndCatch, TFishingSetup
function InitTrig_Fishing takes nothing returns nothing
endfunction

// Startup registration, part 1 of 2: creates the triggers below, in this order. Called once from
// Startup_RegisterTriggers (MapBootstrap). Each Register_* function sits in the module that
// holds that trigger's code (search for its name).
// Registered in parts so triggers sharing an event with other modules keep their firing order.
function RegisterTriggers_Fishing_Part1 takes nothing returns nothing
    call Register_Fishing_Setup()
    call Register_Fishing_Pole_Found()
    call Register_Fishing_Unlock()
    call Register_Fishing_Cast() // starts off; enabled by Fishing_Setup
    call Register_Fishing_Tick() // starts off; run by PlayerTimer1, PlayerTimer2, PlayerTimer3 +5 more
    call Register_Fishing_Input()
    call Register_Fishing_Catch() // starts off; run by Fishing_ReelingAndCatch
    call Register_Fishing_End() // starts off; run by Fishing_ReelingAndCatch, Suicide
endfunction

// Startup registration, part 2 of 2: creates the triggers below, in this order. Called once from
// Startup_RegisterTriggers (MapBootstrap). Each Register_* function sits in the module that
// holds that trigger's code (search for its name).
// Registered in parts so triggers sharing an event with other modules keep their firing order.
function RegisterTriggers_Fishing_Part2 takes nothing returns nothing
    call Register_Fishing_Monster_Spawn()
endfunction

endlibrary
