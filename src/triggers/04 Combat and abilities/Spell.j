library TSpell requires TSpellAero, TSpellDemi, TSpellDewall, TSpellFlamesOfJudgment, TSpellGayaRage, TSpellHeatWave, TSpellHellhounds, TSpellHoming, TSpellIncandescentHellfire, TSpellInfernoRipple, TSpellJavelinRain, TSpellLivingFlame, TSpellMeteor, TSpellOzmeteor, TSpellQuake, TSpellSatellite, TSpellTables, TSpellTerraBreak, TSpellWater, TSpellWave, TSpellXerosBeat
function InitTrig_Spell takes nothing returns nothing
endfunction

// Startup registration, part 1 of 6: creates the triggers below, in this order. Called once from
// Startup_RegisterTriggers (MapBootstrap). Each Register_* function sits in the module that
// holds that trigger's code (search for its name).
// Registered in parts so triggers sharing an event with other modules keep their firing order.
function RegisterTriggers_Spell_Part1 takes nothing returns nothing
    call Register_Spell_Tables_Init()
endfunction

// Startup registration, part 2 of 6: creates the triggers below, in this order. Called once from
// Startup_RegisterTriggers (MapBootstrap). Each Register_* function sits in the module that
// holds that trigger's code (search for its name).
// Registered in parts so triggers sharing an event with other modules keep their firing order.
function RegisterTriggers_Spell_Part2 takes nothing returns nothing
    call Register_Spell_Dewall_Apply()
endfunction

// Startup registration, part 3 of 6: creates the triggers below, in this order. Called once from
// Startup_RegisterTriggers (MapBootstrap). Each Register_* function sits in the module that
// holds that trigger's code (search for its name).
// Registered in parts so triggers sharing an event with other modules keep their firing order.
function RegisterTriggers_Spell_Part3 takes nothing returns nothing
    call Register_Spell_InfernoRipple()
endfunction

// Startup registration, part 4 of 6: creates the triggers below, in this order. Called once from
// Startup_RegisterTriggers (MapBootstrap). Each Register_* function sits in the module that
// holds that trigger's code (search for its name).
// Registered in parts so triggers sharing an event with other modules keep their firing order.
function RegisterTriggers_Spell_Part4 takes nothing returns nothing
    call Register_Spell_TerraBreak()
    call Register_Spell_FlamesOfJudgment()
    call Register_Spell_Hellhounds()
    call Register_Spell_LivingFlame_Apply()
    call Register_Spell_LivingFlame_Tick()
    call Register_Spell_LivingFlame_Spread() // starts off; run by Spell_LivingFlame
    call Register_Spell_IncandescentHellfire()
endfunction

// Startup registration, part 5 of 6: creates the triggers below, in this order. Called once from
// Startup_RegisterTriggers (MapBootstrap). Each Register_* function sits in the module that
// holds that trigger's code (search for its name).
// Registered in parts so triggers sharing an event with other modules keep their firing order.
function RegisterTriggers_Spell_Part5 takes nothing returns nothing
    call Register_Spell_HeatWave_Cast()
    call Register_Spell_JavelinRain_Cast()
    call Register_Spell_XerosBeat_Cast()
    call Register_Spell_GayaRage_Start() // starts off; enabled by Spell_GayaRage, Boss_DemiFiend
    call Register_Spell_GayaRage_Ring()
    call Register_Spell_GayaRage_Damage()
endfunction

// Startup registration, part 6 of 6: creates the triggers below, in this order. Called once from
// Startup_RegisterTriggers (MapBootstrap). Each Register_* function sits in the module that
// holds that trigger's code (search for its name).
// Registered in parts so triggers sharing an event with other modules keep their firing order.
function RegisterTriggers_Spell_Part6 takes nothing returns nothing
    call Register_Spell_Homing_Rockets()
    call Register_Spell_Satellite_Beam()
    call Register_Spell_Satellite_Beam_InGroup()
    call Register_Spell_Satellite_Beam_Death()
    call Register_Spell_Wave_Cannon()
    call Register_Spell_Meteor_Wide()
    call Register_Spell_Ozmeteor()
    call Register_Spell_Water()
    call Register_Spell_Quake()
    call Register_Spell_Aero()
    call Register_Spell_Demi()
endfunction

endlibrary
