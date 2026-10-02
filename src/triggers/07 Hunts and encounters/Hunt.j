library THunt requires optional THuntBoard, optional THuntContracts, optional THuntEncounters, optional THuntRewards, optional THuntShop
function InitTrig_Hunt takes nothing returns nothing
endfunction

// Startup registration: creates the triggers below, in this order. Called once from
// Startup_RegisterTriggers (MapBootstrap). Each Register_* function sits in the module that
// holds that trigger's code (search for its name).
function RegisterTriggers_Hunt takes nothing returns nothing
    static if LIBRARY_THuntBoard then
        call Register_Hunt_Setup()
        call Register_Hunt_Board_Markers() // starts off; run by AdamantHunt, AncientHunt, ArenaResources +26 more
    endif
    static if LIBRARY_THuntContracts then
        call Register_Hunt_Accept()
        call Register_Hunt_Complete() // used by Hunt_Contracts, Mephorash
    endif
    static if LIBRARY_THuntShop then
        call Register_Hunt_Shop_Unlock() // starts off; enabled by Makenroh; run by Makenroh
    endif
    static if LIBRARY_THuntEncounters then
        call Register_Hunt_Thextera_Escort() // starts off; used by Hunt_Board
    endif
    static if LIBRARY_THuntRewards then
        call Register_Hunt_Shard_Register() // starts off; run by Hunt_Encounters; used by Hunt_Board
        call Register_Hunt_Shard_Drop() // used by Hunt_Rewards
    endif
    static if LIBRARY_THuntEncounters then
        call Register_Hunt_Tonberry_Setup() // starts off; used by Hunt_Board
        call Register_Hunt_Demon_Setup() // starts off; run by Hunt_Encounters; used by Hunt_Board
        call Register_Hunt_Parvati_Setup() // starts off; used by Hunt_Board
        call Register_Hunt_PhantomDancer_Setup() // starts off; used by Hunt_Board
        call Register_Hunt_Exdeath_Setup() // starts off; used by Hunt_Board
        call Register_Hunt_Mephorash_Setup() // starts off; used by Hunt_Board
        call Register_Hunt_Trickster_Unlock()
        call Register_Hunt_Melaiduma_Setup() // starts off; used by Hunt_Board
        call Register_Hunt_BlackPearl_Setup() // starts off; used by Hunt_Board
        call Register_Hunt_Rabite_Setup() // starts off; used by Hunt_Board
        call Register_Hunt_Verci_Setup() // starts off; used by Hunt_Board
        call Register_Hunt_Okuu_Setup() // starts off; used by Hunt_Board
    endif
endfunction

endlibrary
