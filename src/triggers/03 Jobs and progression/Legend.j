library TLegend requires optional TLegendArcher, optional TLegendCalculator, optional TLegendChemist, optional TLegendDarkKnight, optional TLegendFreelancer, optional TLegendGeomancer, optional TLegendHolySwordsman, optional TLegendKnight, optional TLegendLancer, optional TLegendMediator, optional TLegendMonk, optional TLegendNecromancer, optional TLegendNinja, optional TLegendOracle, optional TLegendPriest, optional TLegendProphet, optional TLegendSamurai, optional TLegendSorcerer, optional TLegendSquire, optional TLegendSummoner, optional TLegendThief, optional TLegendTimeMage, optional TLegendWizard
function InitTrig_Legend takes nothing returns nothing
endfunction

// Startup registration: creates the triggers below, in this order. Called once from
// Startup_RegisterTriggers (MapBootstrap). Each Register_* function sits in the module that
// holds that trigger's code (search for its name).
function RegisterTriggers_Legend takes nothing returns nothing
    static if LIBRARY_TLegendSquire then
        call Register_Legend_Squire_Talk() // starts off; used by Elysium
    endif
    static if LIBRARY_TLegendKnight then
        call Register_Legend_Knight_Talk() // starts off; used by Elysium
    endif
    static if LIBRARY_TLegendArcher then
        call Register_Legend_Archer_Talk() // starts off; used by Elysium
    endif
    static if LIBRARY_TLegendMonk then
        call Register_Legend_Monk_Talk() // starts off; used by Elysium
    endif
    static if LIBRARY_TLegendThief then
        call Register_Legend_Thief_Talk() // starts off; used by Elysium
    endif
    static if LIBRARY_TLegendGeomancer then
        call Register_Legend_Geomancer_Talk() // starts off; used by Elysium
    endif
    static if LIBRARY_TLegendSamurai then
        call Register_Legend_Samurai_Talk() // starts off; used by Elysium
    endif
    static if LIBRARY_TLegendLancer then
        call Register_Legend_Lancer_Talk() // starts off; used by Elysium
    endif
    static if LIBRARY_TLegendNinja then
        call Register_Legend_Ninja_Talk() // starts off; used by Elysium
    endif
    static if LIBRARY_TLegendHolySwordsman then
        call Register_Legend_HolySwordsman_Talk() // starts off; used by Elysium
    endif
    static if LIBRARY_TLegendChemist then
        call Register_Legend_Chemist_Talk() // starts off; used by Elysium
    endif
    static if LIBRARY_TLegendWizard then
        call Register_Legend_Wizard_Talk() // starts off; used by Elysium
    endif
    static if LIBRARY_TLegendPriest then
        call Register_Legend_Priest_Talk() // starts off; used by Elysium
    endif
    static if LIBRARY_TLegendSummoner then
        call Register_Legend_Summoner_Talk() // starts off; used by Elysium
    endif
    static if LIBRARY_TLegendTimeMage then
        call Register_Legend_TimeMage_Talk() // starts off; used by Elysium
    endif
    static if LIBRARY_TLegendMediator then
        call Register_Legend_Mediator_Talk() // starts off; used by Elysium
    endif
    static if LIBRARY_TLegendOracle then
        call Register_Legend_Oracle_Talk() // starts off; used by Elysium
    endif
    static if LIBRARY_TLegendCalculator then
        call Register_Legend_Calculator_Talk() // starts off; used by Elysium
    endif
    static if LIBRARY_TLegendProphet then
        call Register_Legend_Prophet_Talk() // starts off; used by Elysium
    endif
    static if LIBRARY_TLegendSorcerer then
        call Register_Legend_Sorcerer_Talk() // starts off; used by Elysium
    endif
    static if LIBRARY_TLegendDarkKnight then
        call Register_Legend_DarkKnight_Talk() // starts off; used by Elysium
    endif
    static if LIBRARY_TLegendNecromancer then
        call Register_Legend_Necromancer_Talk() // starts off; used by Elysium
    endif
    static if LIBRARY_TLegendFreelancer then
        call Register_Legend_Freelancer_Talk() // starts off; used by Elysium
    endif
endfunction

endlibrary
