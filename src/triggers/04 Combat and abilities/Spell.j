library TSpell requires optional TSpellAero, optional TSpellDemi, optional TSpellDewall, optional TSpellFlamesOfJudgment, optional TSpellGayaRage, optional TSpellHeatWave, optional TSpellHellhounds, optional TSpellHoming, optional TSpellIncandescentHellfire, optional TSpellInfernoRipple, optional TSpellJavelinRain, optional TSpellLivingFlame, optional TSpellMeteor, optional TSpellOzmeteor, optional TSpellQuake, optional TSpellSatellite, optional TSpellTables, optional TSpellTerraBreak, optional TSpellWater, optional TSpellWave, optional TSpellXerosBeat
function InitTrig_Spell takes nothing returns nothing
endfunction

// Startup registration, part 1 of 6: creates the triggers below, in this order. Called once from
// Startup_RegisterTriggers (MapBootstrap). Each Register_* function sits in the module that
// holds that trigger's code (search for its name).
// Registered in parts so triggers sharing an event with other modules keep their firing order.
function RegisterTriggers_Spell_Part1 takes nothing returns nothing
    static if LIBRARY_TSpellTables then
        call Register_Spell_Tables_Init()
    endif
endfunction

// Startup registration, part 2 of 6: creates the triggers below, in this order. Called once from
// Startup_RegisterTriggers (MapBootstrap). Each Register_* function sits in the module that
// holds that trigger's code (search for its name).
// Registered in parts so triggers sharing an event with other modules keep their firing order.
function RegisterTriggers_Spell_Part2 takes nothing returns nothing
    static if LIBRARY_TSpellDewall then
        call Register_Spell_Dewall_Apply()
    endif
endfunction

// Startup registration, part 3 of 6: creates the triggers below, in this order. Called once from
// Startup_RegisterTriggers (MapBootstrap). Each Register_* function sits in the module that
// holds that trigger's code (search for its name).
// Registered in parts so triggers sharing an event with other modules keep their firing order.
function RegisterTriggers_Spell_Part3 takes nothing returns nothing
    static if LIBRARY_TSpellInfernoRipple then
        call Register_Spell_InfernoRipple()
    endif
endfunction

// Startup registration, part 4 of 6: creates the triggers below, in this order. Called once from
// Startup_RegisterTriggers (MapBootstrap). Each Register_* function sits in the module that
// holds that trigger's code (search for its name).
// Registered in parts so triggers sharing an event with other modules keep their firing order.
function RegisterTriggers_Spell_Part4 takes nothing returns nothing
    static if LIBRARY_TSpellTerraBreak then
        call Register_Spell_TerraBreak()
    endif
    static if LIBRARY_TSpellFlamesOfJudgment then
        call Register_Spell_FlamesOfJudgment()
    endif
    static if LIBRARY_TSpellHellhounds then
        call Register_Spell_Hellhounds()
    endif
    static if LIBRARY_TSpellLivingFlame then
        call Register_Spell_LivingFlame_Apply()
        call Register_Spell_LivingFlame_Tick()
        call Register_Spell_LivingFlame_Spread() // starts off; run by Spell_LivingFlame
    endif
    static if LIBRARY_TSpellIncandescentHellfire then
        call Register_Spell_IncandescentHellfire()
    endif
endfunction

// Startup registration, part 5 of 6: creates the triggers below, in this order. Called once from
// Startup_RegisterTriggers (MapBootstrap). Each Register_* function sits in the module that
// holds that trigger's code (search for its name).
// Registered in parts so triggers sharing an event with other modules keep their firing order.
function RegisterTriggers_Spell_Part5 takes nothing returns nothing
    static if LIBRARY_TSpellHeatWave then
        call Register_Spell_HeatWave_Cast()
    endif
    static if LIBRARY_TSpellJavelinRain then
        call Register_Spell_JavelinRain_Cast()
    endif
    static if LIBRARY_TSpellXerosBeat then
        call Register_Spell_XerosBeat_Cast()
    endif
    static if LIBRARY_TSpellGayaRage then
        call Register_Spell_GayaRage_Start() // starts off; enabled by Spell_GayaRage, Boss_DemiFiend
        call Register_Spell_GayaRage_Ring()
        call Register_Spell_GayaRage_Damage()
    endif
endfunction

// Startup registration, part 6 of 6: creates the triggers below, in this order. Called once from
// Startup_RegisterTriggers (MapBootstrap). Each Register_* function sits in the module that
// holds that trigger's code (search for its name).
// Registered in parts so triggers sharing an event with other modules keep their firing order.
function RegisterTriggers_Spell_Part6 takes nothing returns nothing
    static if LIBRARY_TSpellHoming then
        call Register_Spell_Homing_Rockets()
    endif
    static if LIBRARY_TSpellSatellite then
        call Register_Spell_Satellite_Beam()
        call Register_Spell_Satellite_Beam_InGroup()
        call Register_Spell_Satellite_Beam_Death()
    endif
    static if LIBRARY_TSpellWave then
        call Register_Spell_Wave_Cannon()
    endif
    static if LIBRARY_TSpellMeteor then
        call Register_Spell_Meteor_Wide()
    endif
    static if LIBRARY_TSpellOzmeteor then
        call Register_Spell_Ozmeteor()
    endif
    static if LIBRARY_TSpellWater then
        call Register_Spell_Water()
    endif
    static if LIBRARY_TSpellQuake then
        call Register_Spell_Quake()
    endif
    static if LIBRARY_TSpellAero then
        call Register_Spell_Aero()
    endif
    static if LIBRARY_TSpellDemi then
        call Register_Spell_Demi()
    endif
endfunction

endlibrary
