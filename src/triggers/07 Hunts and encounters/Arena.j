library TArena requires optional TArenaAccess, optional TArenaBattleResults, optional TArenaBattleSetup, optional TArenaBoundaries, optional TArenaConfiguration, optional TArenaConquest, optional TArenaCups, optional TArenaDuel, optional TArenaIntroduction, optional TArenaPresentation, optional TArenaRewards, optional TArenaRounds, optional TArenaSpawning, optional TArenaTeamData, optional TArenaTeamSelection
function InitTrig_Arena takes nothing returns nothing
endfunction

// Startup registration, part 1 of 4: creates the triggers below, in this order. Called once from
// Startup_RegisterTriggers (MapBootstrap). Each Register_* function sits in the module that
// holds that trigger's code (search for its name).
// Registered in parts so triggers sharing an event with other modules keep their firing order.
function RegisterTriggers_Arena_Part1 takes nothing returns nothing
    static if LIBRARY_TArenaBoundaries then
        call Register_Arena_Leash()
    endif
endfunction

// Startup registration, part 2 of 4: creates the triggers below, in this order. Called once from
// Startup_RegisterTriggers (MapBootstrap). Each Register_* function sits in the module that
// holds that trigger's code (search for its name).
// Registered in parts so triggers sharing an event with other modules keep their firing order.
function RegisterTriggers_Arena_Part2 takes nothing returns nothing
    static if LIBRARY_TArenaPresentation then
        call Register_Arena_FreezeNpcs() // run by MapBootstrap
    endif
    static if LIBRARY_TArenaCups then
        call Register_Arena_Unlock() // starts off; run by Cid
    endif
    static if LIBRARY_TArenaIntroduction then
        call Register_Arena_LeoIntro() // enabled by Arena_Cups
    endif
    static if LIBRARY_TArenaTeamData then
        call Register_Arena_InitData()
        call Register_Arena_TeamData1()
        call Register_Arena_TeamData2()
    endif
    static if LIBRARY_TArenaTeamSelection then
        call Register_Arena_Team_Data_A()
        call Register_Arena_Team_Data_B()
    endif
    static if LIBRARY_TArenaSpawning then
        call Register_Arena_Unit_Data()
    endif
    static if LIBRARY_TArenaAccess then
        call Register_Arena_Lock_Controls() // starts off; enabled by Arena_BattleSetup
        call Register_Arena_Enter_Region() // starts off; enabled by Arena_BattleSetup; disabled by Arena_BattleResults, Arena_Cups; used by Arena_Access, AlmightyShinra
    endif
    static if LIBRARY_TArenaBattleSetup then
        call Register_Arena_Start_Cup() // enabled by Arena_BattleResults, Arena_Cups; disabled by Arena_BattleSetup
    endif
    static if LIBRARY_TArenaTeamSelection then
        call Register_Arena_Pick_Team() // starts off; run by Arena_BattleSetup
    endif
    static if LIBRARY_TArenaRounds then
        call Register_Arena_Round_Start() // starts off; run by Arena_Rounds, Arena_BattleSetup
    endif
    static if LIBRARY_TArenaSpawning then
        call Register_Arena_Spawn_Team() // run by Arena_Rounds
    endif
    static if LIBRARY_TArenaRounds then
        call Register_Arena_Round_End() // starts off; enabled by Arena_Rounds; disabled by Arena_BattleResults
    endif
    static if LIBRARY_TArenaCups then
        call Register_Arena_Cup_Won() // starts off; run by AlmightyShinra, Arena_Rounds
        call Register_Arena_UnlockCups() // starts off; run by Arena_Cups
    endif
    static if LIBRARY_TArenaTeamSelection then
        call Register_Arena_SyncTeams() // starts off; run by Arena_Cups
    endif
    static if LIBRARY_TArenaBattleSetup then
        call Register_Arena_StartBattle() // enabled by Arena_BattleResults, Arena_Cups; disabled by Arena_BattleSetup
    endif
    static if LIBRARY_TArenaBattleResults then
        call Register_Arena_FoeDeath() // starts off; enabled by Arena_BattleSetup; disabled by Arena_BattleResults
    endif
    static if LIBRARY_TArenaAccess then
        call Register_Arena_PlayerLeft() // starts off; enabled by Arena_BattleSetup; disabled by Arena_BattleResults, Arena_Cups
    endif
    static if LIBRARY_TArenaBattleResults then
        call Register_Arena_BattleLost() // starts off; run by Arena_Access, Arena_BattleSetup, Arena_Rounds
    endif
    static if LIBRARY_TArenaRewards then
        call Register_Arena_BuyPrize()
    endif
    static if LIBRARY_TArenaBoundaries then
        call Register_Arena_OutOfBounds() // starts off; enabled by Arena_BattleSetup, Arena_Rounds; disabled by Arena_BattleResults, Arena_Rounds
    endif
    static if LIBRARY_TArenaAccess then
        call Register_Arena_GateWrongSide() // disabled by Arena_Access, ArenaResources; destroyed by Arena_Access
        call Register_Arena_GateOpen() // starts off; enabled by Arena_Cups; disabled by ArenaResources
    endif
endfunction

// Startup registration, part 3 of 4: creates the triggers below, in this order. Called once from
// Startup_RegisterTriggers (MapBootstrap). Each Register_* function sits in the module that
// holds that trigger's code (search for its name).
// Registered in parts so triggers sharing an event with other modules keep their firing order.
function RegisterTriggers_Arena_Part3 takes nothing returns nothing
    static if LIBRARY_TArenaPresentation then
        call Register_Arena_ToggleShowcase()
    endif
    static if LIBRARY_TArenaConfiguration then
        call Register_Arena_ToggleCupMode()
    endif
    static if LIBRARY_TArenaRewards then
        call Register_Arena_ExchangeBP()
    endif
    static if LIBRARY_TArenaConquest then
        call Register_Arena_Conquest()
    endif
    static if LIBRARY_TArenaRewards then
        call Register_Arena_RefreshBPTags() // starts off
    endif
endfunction

// Startup registration, part 4 of 4: creates the triggers below, in this order. Called once from
// Startup_RegisterTriggers (MapBootstrap). Each Register_* function sits in the module that
// holds that trigger's code (search for its name).
// Registered in parts so triggers sharing an event with other modules keep their firing order.
function RegisterTriggers_Arena_Part4 takes nothing returns nothing
    static if LIBRARY_TArenaAccess then
        call Register_Arena_Enter_Eject() // starts off; enabled by Glyph
        call Register_Arena_Leave_Player() // starts off; enabled by Glyph
    endif
    static if LIBRARY_TArenaBattleResults then
        call Register_Arena_Abandoned_Reset() // starts off; enabled by Glyph
    endif
    static if LIBRARY_TArenaDuel then
        call Register_Arena_Duel_AI() // starts off; enabled by Boss_Shinryu; disabled by Arena_Duel, Arena_Cups
    endif
    static if LIBRARY_TArenaCups then
        call Register_Arena_Omega_Absorbs() // starts off; enabled by Boss_Shinryu; disabled by Arena_Cups, Arena_Duel
        call Register_Arena_Shinryu_Absorbs() // starts off; enabled by Boss_Shinryu; disabled by Arena_Cups, Arena_Duel
    endif
    static if LIBRARY_TArenaDuel then
        call Register_Arena_Duel_Ascend()
        call Register_Arena_Duel_Victory() // starts off; enabled by Arena_Cups; disabled by Arena_Duel
        call Register_Arena_Duel_Cleanup() // starts off; used by Boss_Shinryu
    endif
endfunction

endlibrary
