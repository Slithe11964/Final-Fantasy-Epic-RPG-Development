library TLegend requires TLegendArcher, TLegendCalculator, TLegendChemist, TLegendDarkKnight, TLegendFreelancer, TLegendGeomancer, TLegendHolySwordsman, TLegendKnight, TLegendLancer, TLegendMediator, TLegendMonk, TLegendNecromancer, TLegendNinja, TLegendOracle, TLegendPriest, TLegendProphet, TLegendSamurai, TLegendSorcerer, TLegendSquire, TLegendSummoner, TLegendThief, TLegendTimeMage, TLegendWizard
function InitTrig_Legend takes nothing returns nothing
endfunction

// Startup registration: creates the triggers below, in this order. Called once from
// Startup_RegisterTriggers (MapBootstrap). Each Register_* function sits in the module that
// holds that trigger's code (search for its name).
function RegisterTriggers_Legend takes nothing returns nothing
    call Register_Legend_Squire_Talk() // starts off; used by Elysium
    call Register_Legend_Knight_Talk() // starts off; used by Elysium
    call Register_Legend_Archer_Talk() // starts off; used by Elysium
    call Register_Legend_Monk_Talk() // starts off; used by Elysium
    call Register_Legend_Thief_Talk() // starts off; used by Elysium
    call Register_Legend_Geomancer_Talk() // starts off; used by Elysium
    call Register_Legend_Samurai_Talk() // starts off; used by Elysium
    call Register_Legend_Lancer_Talk() // starts off; used by Elysium
    call Register_Legend_Ninja_Talk() // starts off; used by Elysium
    call Register_Legend_HolySwordsman_Talk() // starts off; used by Elysium
    call Register_Legend_Chemist_Talk() // starts off; used by Elysium
    call Register_Legend_Wizard_Talk() // starts off; used by Elysium
    call Register_Legend_Priest_Talk() // starts off; used by Elysium
    call Register_Legend_Summoner_Talk() // starts off; used by Elysium
    call Register_Legend_TimeMage_Talk() // starts off; used by Elysium
    call Register_Legend_Mediator_Talk() // starts off; used by Elysium
    call Register_Legend_Oracle_Talk() // starts off; used by Elysium
    call Register_Legend_Calculator_Talk() // starts off; used by Elysium
    call Register_Legend_Prophet_Talk() // starts off; used by Elysium
    call Register_Legend_Sorcerer_Talk() // starts off; used by Elysium
    call Register_Legend_DarkKnight_Talk() // starts off; used by Elysium
    call Register_Legend_Necromancer_Talk() // starts off; used by Elysium
    call Register_Legend_Freelancer_Talk() // starts off; used by Elysium
endfunction

endlibrary
