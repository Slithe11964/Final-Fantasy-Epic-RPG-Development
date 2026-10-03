library TQuest requires optional TQuestAnnoyingMonster, optional TQuestAoMadoushi, optional TQuestArachnophobia, optional TQuestArcanium, optional TQuestBeastslayer, optional TQuestBlazingDemon, optional TQuestBrothers, optional TQuestCaravan, optional TQuestCooking, optional TQuestCorruptedOrcs, optional TQuestCrossbow, optional TQuestDarkKnight, optional TQuestDeliverLetter, optional TQuestDivineOrder, optional TQuestDwarfDisappearance, optional TQuestEidolonChallenge, optional TQuestEngineer, optional TQuestEyeOfJenova, optional TQuestFallenRanger, optional TQuestFieryWings, optional TQuestFireGolem, optional TQuestFishyDeals, optional TQuestFountain, optional TQuestGodDragon, optional TQuestGreedIsGood, optional TQuestHarpyHunt, optional TQuestHolyKnight, optional TQuestIllusions, optional TQuestImperviousBeast, optional TQuestKillElmdor, optional TQuestKillSetag, optional TQuestKingOfSea, optional TQuestLadyNashj, optional TQuestLastRites, optional TQuestLightOfJudgment, optional TQuestLog, optional TQuestLostMemories, optional TQuestMonstrum, optional TQuestNebraAngler, optional TQuestNightElves, optional TQuestNorthernGod, optional TQuestOgreHunt, optional TQuestOmegaWeapon, optional TQuestOreSupplies, optional TQuestPhantomDiary, optional TQuestPhoenix, optional TQuestRematch, optional TQuestSaveTimmy, optional TQuestScorchedEarth, optional TQuestScorchingTravel, optional TQuestSeekDestroy, optional TQuestShimmerweed, optional TQuestSpiritHunt, optional TQuestSpiritOfWater, optional TQuestStrongestEidolon, optional TQuestTargetPractice, optional TQuestTowerSummoning, optional TQuestTrialByFire, optional TQuestUltimaWeapon, optional TQuestWolfFangs, optional TQuestWorldLiberation, optional TQuestYoungEngineer, optional TQuestZodiacAge
function InitTrig_Quest takes nothing returns nothing
endfunction

// Startup registration, part 1 of 21: creates the triggers below, in this order. Called once from
// Startup_RegisterTriggers (MapBootstrap). Each Register_* function sits in the module that
// holds that trigger's code (search for its name).
// Registered in parts so triggers sharing an event with other modules keep their firing order.
function RegisterTriggers_Quest_Part1 takes nothing returns nothing
    static if LIBRARY_TQuestLog then
        call Register_Quest_Log_Update()
    endif
endfunction

// Startup registration, part 2 of 21: creates the triggers below, in this order. Called once from
// Startup_RegisterTriggers (MapBootstrap). Each Register_* function sits in the module that
// holds that trigger's code (search for its name).
// Registered in parts so triggers sharing an event with other modules keep their firing order.
function RegisterTriggers_Quest_Part2 takes nothing returns nothing
    static if LIBRARY_TQuestAoMadoushi then
        call Register_Quest_AoMadoushi_Talk() // starts off; enabled by AoMadoushi
        call Register_Quest_AoMadoushi_Report() // starts off; enabled by Cine
    endif
    static if LIBRARY_TQuestEyeOfJenova then
        call Register_Quest_EyeOfJenova_PickUp() // starts off; enabled by Loot
        call Register_Quest_EyeOfJenova_Deliver() // starts off; enabled by Quest_EyeOfJenova
    endif
    static if LIBRARY_TQuestNightElves then
        call Register_Quest_NightElves_Start() // starts off; enabled by Quest_EyeOfJenova
    endif
endfunction

// Startup registration, part 3 of 21: creates the triggers below, in this order. Called once from
// Startup_RegisterTriggers (MapBootstrap). Each Register_* function sits in the module that
// holds that trigger's code (search for its name).
// Registered in parts so triggers sharing an event with other modules keep their firing order.
function RegisterTriggers_Quest_Part3 takes nothing returns nothing
    static if LIBRARY_TQuestNightElves then
        call Register_Quest_NightElves_Complete() // starts off; enabled by Quest_NightElves
    endif
endfunction

// Startup registration, part 4 of 21: creates the triggers below, in this order. Called once from
// Startup_RegisterTriggers (MapBootstrap). Each Register_* function sits in the module that
// holds that trigger's code (search for its name).
// Registered in parts so triggers sharing an event with other modules keep their firing order.
function RegisterTriggers_Quest_Part4 takes nothing returns nothing
    static if LIBRARY_TQuestNightElves then
        call Register_Quest_NightElves_Report() // starts off; enabled by Quest_NightElves
    endif
    static if LIBRARY_TQuestDarkKnight then
        call Register_Quest_DarkKnight_Start() // starts off; run by Cine
    endif
    static if LIBRARY_TQuestWorldLiberation then
        call Register_Quest_WorldLiberation_Count() // starts off; run by Boss_Belias, Boss_Chaos, Boss_Exodus +9 more
        call Register_Quest_WorldLiberation_Reward()
    endif
endfunction

// Startup registration, part 5 of 21: creates the triggers below, in this order. Called once from
// Startup_RegisterTriggers (MapBootstrap). Each Register_* function sits in the module that
// holds that trigger's code (search for its name).
// Registered in parts so triggers sharing an event with other modules keep their firing order.
function RegisterTriggers_Quest_Part5 takes nothing returns nothing
    static if LIBRARY_TQuestCorruptedOrcs then
        call Register_Quest_CorruptedOrcs_Start() // starts off; enabled by Meliadoul; disabled by OrcBase; destroyed by Meliadoul, OrcBase
    endif
endfunction

// Startup registration, part 6 of 21: creates the triggers below, in this order. Called once from
// Startup_RegisterTriggers (MapBootstrap). Each Register_* function sits in the module that
// holds that trigger's code (search for its name).
// Registered in parts so triggers sharing an event with other modules keep their firing order.
function RegisterTriggers_Quest_Part6 takes nothing returns nothing
    static if LIBRARY_TQuestLastRites then
        call Register_Quest_LastRites_Start() // starts off; enabled by PriestX; disabled by TrueIceAge
    endif
endfunction

// Startup registration, part 7 of 21: creates the triggers below, in this order. Called once from
// Startup_RegisterTriggers (MapBootstrap). Each Register_* function sits in the module that
// holds that trigger's code (search for its name).
// Registered in parts so triggers sharing an event with other modules keep their firing order.
function RegisterTriggers_Quest_Part7 takes nothing returns nothing
    static if LIBRARY_TQuestIllusions then
        call Register_Quest_Illusions_Start() // starts off; enabled by Dana, Quest_ZodiacAge; disabled by Quest_ZodiacAge, TrueIceAge
    endif
    static if LIBRARY_TQuestLightOfJudgment then
        call Register_Quest_LightOfJudgment_Start() // starts off; enabled by Alma
    endif
endfunction

// Startup registration, part 8 of 21: creates the triggers below, in this order. Called once from
// Startup_RegisterTriggers (MapBootstrap). Each Register_* function sits in the module that
// holds that trigger's code (search for its name).
// Registered in parts so triggers sharing an event with other modules keep their firing order.
function RegisterTriggers_Quest_Part8 takes nothing returns nothing
    static if LIBRARY_TQuestGodDragon then
        call Register_Quest_GodDragon_Start() // starts off; enabled by Montblanc
    endif
    static if LIBRARY_TQuestZodiacAge then
        call Register_Quest_ZodiacAge_Start() // starts off; enabled by Celeborn
        call Register_Quest_ZodiacAge_GateBlocked()
        call Register_Quest_ZodiacAge_AskCeleborn() // starts off; enabled by Quest_ZodiacAge; disabled by Gate; destroyed by Gate
        call Register_Quest_ZodiacAge_AskTalon() // starts off; enabled by Quest_ZodiacAge; disabled by Gate; destroyed by Gate
        call Register_Quest_ZodiacAge_GetPendant() // starts off; enabled by Quest_ZodiacAge, Dana; disabled by Gate; destroyed by Gate
        call Register_Quest_ZodiacAge_ShowPendant() // starts off; enabled by Quest_ZodiacAge; disabled by Gate; destroyed by Gate
        call Register_Quest_ZodiacAge_TalonOpensGate() // starts off; enabled by Quest_ZodiacAge; disabled by Gate; destroyed by Gate
    endif
    static if LIBRARY_TQuestShimmerweed then
        call Register_Quest_Shimmerweed_Offer() // starts off; run by Cid, Mid
    endif
endfunction

// Startup registration, part 9 of 21: creates the triggers below, in this order. Called once from
// Startup_RegisterTriggers (MapBootstrap). Each Register_* function sits in the module that
// holds that trigger's code (search for its name).
// Registered in parts so triggers sharing an event with other modules keep their firing order.
function RegisterTriggers_Quest_Part9 takes nothing returns nothing
    static if LIBRARY_TQuestShimmerweed then
        call Register_Quest_Shimmerweed_Start() // starts off; enabled by Quest_Shimmerweed
        call Register_Quest_Shimmerweed_Ping() // starts off; enabled by Quest_Shimmerweed; disabled by Quest_Shimmerweed; destroyed by Quest_Shimmerweed
        call Register_Quest_Shimmerweed_Pickup() // starts off; enabled by Quest_Shimmerweed; disabled by Quest_Shimmerweed; destroyed by Quest_Shimmerweed
        call Register_Quest_Shimmerweed_Deliver() // starts off; enabled by Quest_Shimmerweed
    endif
    static if LIBRARY_TQuestArachnophobia then
        call Register_Quest_Arachnophobia_Offer() // starts off; run by Cid, Mid
        call Register_Quest_Arachnophobia_Start() // starts off; enabled by Quest_Arachnophobia
        call Register_Quest_Arachnophobia_Count() // starts off; enabled by Quest_Arachnophobia
        call Register_Quest_Arachnophobia_Reward() // starts off; enabled by Quest_Arachnophobia
    endif
    static if LIBRARY_TQuestKillSetag then
        call Register_Quest_KillSetag_Hide() // run by MapBootstrap
        call Register_Quest_KillSetag_Offer() // starts off; run by Cid, Epilogue
        call Register_Quest_KillSetag_Start() // starts off; enabled by Quest_KillSetag
        call Register_Quest_KillSetag_Ambush() // starts off; enabled by Quest_KillSetag
        call Register_Quest_KillSetag_Failed() // starts off; enabled by Quest_KillSetag; destroyed by Quest_KillSetag
        call Register_Quest_KillSetag_Complete() // starts off; enabled by Quest_KillSetag; disabled by Quest_KillSetag; destroyed by Quest_KillSetag
    endif
    static if LIBRARY_TQuestPhoenix then
        call Register_Quest_Phoenix_Available() // starts off; run by QuestCount
        call Register_Quest_Phoenix_Start() // starts off; enabled by Quest_Phoenix
        call Register_Quest_Phoenix_Ping() // starts off; enabled by Quest_Phoenix; disabled by Quest_Phoenix; destroyed by Quest_Phoenix
        call Register_Quest_Phoenix_EggTaken() // starts off; enabled by Quest_Phoenix
        call Register_Quest_Phoenix_Complete() // starts off; enabled by Quest_Phoenix
    endif
    static if LIBRARY_TQuestCaravan then
        call Register_Quest_Caravan_SamAvailable() // starts off; run by Cid, Epilogue
        call Register_Quest_Caravan_SamRequest() // starts off; enabled by Quest_Caravan; disabled by Quest_Caravan; destroyed by Quest_Caravan
        call Register_Quest_Caravan_DioRefuses() // starts off; enabled by Quest_Caravan; disabled by Quest_Caravan; destroyed by Quest_Caravan
        call Register_Quest_Caravan_Enable() // starts off; run by Quest_SaveTimmy
        call Register_Quest_Caravan_Start() // starts off; enabled by Quest_Caravan
        call Register_Quest_Caravan_HorsesVulnerable() // starts off; enabled by Quest_Caravan
        call Register_Quest_Caravan_Deliver() // starts off; enabled by Quest_Caravan; disabled by Quest_Caravan
        call Register_Quest_Caravan_Failed() // starts off; enabled by Quest_Caravan
        call Register_Quest_Caravan_Ping() // starts off; enabled by Quest_Caravan; disabled by Quest_Caravan
        call Register_Quest_Caravan_Complete() // starts off; enabled by Quest_Caravan
    endif
    static if LIBRARY_TQuestKillElmdor then
        call Register_Quest_KillElmdor_Init() // run by MapBootstrap
        call Register_Quest_KillElmdor_Available() // starts off; run by Cid, Epilogue
    endif
    static if LIBRARY_TQuestFireGolem then
        call Register_Quest_FireGolem_Init() // run by MapBootstrap
        call Register_Quest_FireGolem_Alert() // starts off; enabled by Quest_Phoenix
        call Register_Quest_FireGolem_Start() // starts off; enabled by Quest_FireGolem
        call Register_Quest_FireGolem_HeartDropped() // starts off; enabled by Quest_FireGolem
        call Register_Quest_FireGolem_Ping() // starts off; enabled by Quest_FireGolem; disabled by Quest_FireGolem
        call Register_Quest_FireGolem_HeartTaken() // starts off; enabled by Quest_FireGolem
        call Register_Quest_FireGolem_Complete() // starts off; enabled by Quest_FireGolem
    endif
    static if LIBRARY_TQuestBrothers then
        call Register_Quest_Brothers_Init() // run by MapBootstrap
        call Register_Quest_Brothers_Available() // starts off; run by Quest_KillElmdor
        call Register_Quest_Brothers_Start() // starts off; enabled by Quest_Brothers
        call Register_Quest_Brothers_Defeated() // starts off; enabled by Quest_Brothers
        call Register_Quest_Brothers_Complete() // starts off; enabled by Quest_Brothers
    endif
    static if LIBRARY_TQuestSaveTimmy then
        call Register_Quest_SaveTimmy_Init() // run by MapBootstrap
        call Register_Quest_SaveTimmy_Start() // disabled by Quest_SaveTimmy; destroyed by Quest_SaveTimmy
        call Register_Quest_SaveTimmy_Ping() // starts off; enabled by Quest_SaveTimmy; disabled by Quest_SaveTimmy, Ending; destroyed by Quest_SaveTimmy
        call Register_Quest_SaveTimmy_GateRefused() // disabled by Quest_SaveTimmy; destroyed by Quest_SaveTimmy
        call Register_Quest_SaveTimmy_GateAsk() // starts off; enabled by Quest_SaveTimmy; disabled by Quest_SaveTimmy; destroyed by Quest_SaveTimmy
        call Register_Quest_SaveTimmy_GateOpen() // starts off; run by Quest_SaveTimmy
        call Register_Quest_SaveTimmy_CampFlank() // disabled by Quest_SaveTimmy
        call Register_Quest_SaveTimmy_CampAlerted()
        call Register_Quest_SaveTimmy_CampCleared()
        call Register_Quest_SaveTimmy_Freed()
        call Register_Quest_SaveTimmy_TimmyReturns() // starts off; enabled by Quest_SaveTimmy; destroyed by Quest_SaveTimmy
        call Register_Quest_SaveTimmy_RescueFirst() // disabled by Quest_SaveTimmy; destroyed by Quest_SaveTimmy
        call Register_Quest_SaveTimmy_Complete() // starts off; enabled by Quest_SaveTimmy; destroyed by Quest_SaveTimmy
        call Register_Quest_SaveTimmy_CompleteAlt() // starts off; enabled by Quest_SaveTimmy; destroyed by Quest_SaveTimmy
    endif
    static if LIBRARY_TQuestDeliverLetter then
        call Register_Quest_DeliverLetter_Init() // run by MapBootstrap
        call Register_Quest_DeliverLetter_Available() // starts off; run by Cid, Epilogue
        call Register_Quest_DeliverLetter_Start() // starts off; enabled by Quest_DeliverLetter
        call Register_Quest_DeliverLetter_PingZack() // starts off; enabled by Quest_DeliverLetter; disabled by Quest_DeliverLetter
        call Register_Quest_DeliverLetter_PingWedge() // starts off; enabled by Quest_DeliverLetter; disabled by Quest_DeliverLetter
        call Register_Quest_DeliverLetter_GiveZack() // starts off; enabled by Quest_DeliverLetter
        call Register_Quest_DeliverLetter_Complete() // starts off; enabled by Quest_DeliverLetter
    endif
    static if LIBRARY_TQuestBeastslayer then
        call Register_Quest_Beastslayer_Available() // starts off; run by Cid, Epilogue
        call Register_Quest_Beastslayer_Start() // starts off; enabled by Quest_Beastslayer
        call Register_Quest_Beastslayer_ArrowDropped() // starts off; enabled by Quest_Beastslayer
        call Register_Quest_Beastslayer_Ping() // starts off; enabled by Quest_Beastslayer; disabled by Quest_Beastslayer
        call Register_Quest_Beastslayer_ArrowTaken() // starts off; enabled by Quest_Beastslayer
        call Register_Quest_Beastslayer_Complete() // starts off; enabled by Quest_Beastslayer
    endif
    static if LIBRARY_TQuestLadyNashj then
        call Register_Quest_LadyNashj_Init() // run by MapBootstrap
        call Register_Quest_LadyNashj_Available() // starts off; run by Epilogue, Quest_NightElves, Talk
        call Register_Quest_LadyNashj_Start() // starts off; enabled by Quest_LadyNashj
        call Register_Quest_LadyNashj_Slain() // starts off; enabled by Quest_LadyNashj
        call Register_Quest_LadyNashj_Complete() // starts off; enabled by Quest_LadyNashj
    endif
    static if LIBRARY_TQuestArcanium then
        call Register_Quest_Arcanium_Start() // starts off; enabled by Forge
        call Register_Quest_Arcanium_Taken() // starts off; enabled by Quest_Arcanium
        call Register_Quest_Arcanium_Complete() // starts off; enabled by Quest_Arcanium
    endif
    static if LIBRARY_TQuestTargetPractice then
        call Register_Quest_TargetPractice_Start() // starts off; enabled by TargetPractice
    endif
endfunction

// Startup registration, part 10 of 21: creates the triggers below, in this order. Called once from
// Startup_RegisterTriggers (MapBootstrap). Each Register_* function sits in the module that
// holds that trigger's code (search for its name).
// Registered in parts so triggers sharing an event with other modules keep their firing order.
function RegisterTriggers_Quest_Part10 takes nothing returns nothing
    static if LIBRARY_TQuestFountain then
        call Register_Quest_Fountain_Bulb() // starts off; enabled by DefiledFountain
        call Register_Quest_Fountain_Complete() // starts off; enabled by Quest_Fountain
    endif
    static if LIBRARY_TQuestOgreHunt then
        call Register_Quest_OgreHunt_Start() // starts off; enabled by Monica
        call Register_Quest_OgreHunt_Count() // starts off; enabled by Quest_OgreHunt
        call Register_Quest_OgreHunt_Complete() // starts off; enabled by Quest_OgreHunt
    endif
    static if LIBRARY_TQuestSeekDestroy then
        call Register_Quest_SeekDestroy_Start() // starts off; enabled by Clemydar
        call Register_Quest_SeekDestroy_Count() // starts off; enabled by Quest_SeekDestroy
        call Register_Quest_SeekDestroy_Complete() // starts off; enabled by Quest_SeekDestroy
    endif
    static if LIBRARY_TQuestGreedIsGood then
        call Register_Quest_GreedIsGood_Start()
        call Register_Quest_GreedIsGood_Complete() // starts off; enabled by PortalStone
    endif
    static if LIBRARY_TQuestFallenRanger then
        call Register_Quest_FallenRanger_Start() // starts off; enabled by Liniel
        call Register_Quest_FallenRanger_Complete() // starts off; enabled by Boss_DarkRanger
    endif
    static if LIBRARY_TQuestSpiritOfWater then
        call Register_Quest_SpiritOfWater_Start() // starts off; enabled by Priscilla
        call Register_Quest_SpiritOfWater_WaterGem() // starts off; enabled by Quest_SpiritOfWater
        call Register_Quest_SpiritOfWater_Complete() // starts off; enabled by Vodyan
    endif
    static if LIBRARY_TQuestTowerSummoning then
        call Register_Quest_TowerSummoning_Start()
    endif
endfunction

// Startup registration, part 11 of 21: creates the triggers below, in this order. Called once from
// Startup_RegisterTriggers (MapBootstrap). Each Register_* function sits in the module that
// holds that trigger's code (search for its name).
// Registered in parts so triggers sharing an event with other modules keep their firing order.
function RegisterTriggers_Quest_Part11 takes nothing returns nothing
    static if LIBRARY_TQuestTowerSummoning then
        call Register_Quest_TowerSummoning_Complete() // starts off; enabled by Quest_TowerSummoning
    endif
    static if LIBRARY_TQuestHolyKnight then
        call Register_Quest_HolyKnight_Start() // starts off; enabled by Agrias
        call Register_Quest_HolyKnight_AskRamza() // starts off; enabled by Quest_HolyKnight
    endif
    static if LIBRARY_TQuestEidolonChallenge then
        call Register_Quest_EidolonChallenge_Start() // starts off; enabled by Brothers
    endif
endfunction

// Startup registration, part 12 of 21: creates the triggers below, in this order. Called once from
// Startup_RegisterTriggers (MapBootstrap). Each Register_* function sits in the module that
// holds that trigger's code (search for its name).
// Registered in parts so triggers sharing an event with other modules keep their firing order.
function RegisterTriggers_Quest_Part12 takes nothing returns nothing
    static if LIBRARY_TQuestEidolonChallenge then
        call Register_Quest_EidolonChallenge_Count() // starts off; enabled by Quest_EidolonChallenge
        call Register_Quest_EidolonChallenge_Complete() // starts off; enabled by Quest_EidolonChallenge
    endif
    static if LIBRARY_TQuestStrongestEidolon then
        call Register_Quest_StrongestEidolon_Start() // starts off; enabled by Priscilla
        call Register_Quest_StrongestEidolon_Complete() // starts off; enabled by Eden; disabled by Eden
    endif
    static if LIBRARY_TQuestRematch then
        call Register_Quest_Rematch_Start() // starts off; enabled by Brothers
        call Register_Quest_Rematch_Begin() // starts off; enabled by Quest_Rematch
        call Register_Quest_Rematch_Complete() // starts off; enabled by Quest_Rematch
    endif
    static if LIBRARY_TQuestPhantomDiary then
        call Register_Quest_PhantomDiary_ShowAlberich() // starts off; enabled by PhantomDiary
    endif
endfunction

// Startup registration, part 13 of 21: creates the triggers below, in this order. Called once from
// Startup_RegisterTriggers (MapBootstrap). Each Register_* function sits in the module that
// holds that trigger's code (search for its name).
// Registered in parts so triggers sharing an event with other modules keep their firing order.
function RegisterTriggers_Quest_Part13 takes nothing returns nothing
    static if LIBRARY_TQuestNorthernGod then
        call Register_Quest_NorthernGod_Judgment() // starts off; enabled by Quest_PhantomDiary
    endif
endfunction

// Startup registration, part 14 of 21: creates the triggers below, in this order. Called once from
// Startup_RegisterTriggers (MapBootstrap). Each Register_* function sits in the module that
// holds that trigger's code (search for its name).
// Registered in parts so triggers sharing an event with other modules keep their firing order.
function RegisterTriggers_Quest_Part14 takes nothing returns nothing
    static if LIBRARY_TQuestAnnoyingMonster then
        call Register_Quest_AnnoyingMonster_Start() // starts off; enabled by LadyCurse
    endif
endfunction

// Startup registration, part 15 of 21: creates the triggers below, in this order. Called once from
// Startup_RegisterTriggers (MapBootstrap). Each Register_* function sits in the module that
// holds that trigger's code (search for its name).
// Registered in parts so triggers sharing an event with other modules keep their firing order.
function RegisterTriggers_Quest_Part15 takes nothing returns nothing
    static if LIBRARY_TQuestLostMemories then
        call Register_Quest_LostMemories_Start() // starts off; enabled by NightElf
        call Register_Quest_LostMemories_RingFade() // starts off; enabled by Quest_LostMemories; disabled by Quest_LostMemories; run by Quest_LostMemories, Shadow_Lifecycle
        call Register_Quest_LostMemories_Fail() // starts off; enabled by Quest_LostMemories
        call Register_Quest_LostMemories_Pickup() // starts off; enabled by Quest_LostMemories; disabled by Quest_LostMemories; destroyed by Quest_LostMemories
        call Register_Quest_LostMemories_ShadowLie() // starts off; enabled by Quest_LostMemories; disabled by Quest_LostMemories; destroyed by Quest_LostMemories
        call Register_Quest_LostMemories_ShadowTruth() // starts off; enabled by Quest_LostMemories
        call Register_Quest_LostMemories_Reunion() // starts off; enabled by Quest_LostMemories
    endif
    static if LIBRARY_TQuestHarpyHunt then
        call Register_Quest_HarpyHunt_Start() // starts off; enabled by Quest_Arachnophobia
        call Register_Quest_HarpyHunt_Count() // starts off; enabled by Quest_HarpyHunt
        call Register_Quest_HarpyHunt_Reward() // starts off; enabled by Quest_HarpyHunt
    endif
    static if LIBRARY_TQuestUltimaWeapon then
        call Register_Quest_UltimaWeapon_Start() // starts off; enabled by Tonberry
        call Register_Quest_UltimaWeapon_Slain() // starts off; enabled by Quest_UltimaWeapon
    endif
    static if LIBRARY_TQuestOmegaWeapon then
        call Register_Quest_OmegaWeapon_Start() // starts off; enabled by Quest_UltimaWeapon
        call Register_Quest_OmegaWeapon_Slain() // starts off; enabled by Quest_OmegaWeapon
    endif
    static if LIBRARY_TQuestKingOfSea then
        call Register_Quest_KingOfSea_Slain() // starts off; enabled by NebraKing
        call Register_Quest_KingOfSea_Reward() // starts off; enabled by Quest_NebraAngler
    endif
    static if LIBRARY_TQuestNebraAngler then
        call Register_Quest_NebraAngler_Start() // starts off; enabled by Anabel
        call Register_Quest_NebraAngler_Reward() // starts off; enabled by Quest_NebraAngler
    endif
    static if LIBRARY_TQuestTrialByFire then
        call Register_Quest_TrialByFire_Start() // starts off; enabled by McBurn
        call Register_Quest_TrialByFire_Begin() // starts off; enabled by Quest_TrialByFire
        call Register_Quest_TrialByFire_Countdown() // starts off; enabled by Arena_BattleSetup; disabled by Quest_TrialByFire; destroyed by Quest_TrialByFire
        call Register_Quest_TrialByFire_Fail() // starts off; run by Arena_BattleResults; destroyed by Quest_TrialByFire
        call Register_Quest_TrialByFire_Survive() // starts off; run by Quest_TrialByFire; destroyed by Quest_TrialByFire
    endif
    static if LIBRARY_TQuestBlazingDemon then
        call Register_Quest_BlazingDemon_Start() // starts off; run by BlazingDemon, DarkIfrit, DarkPhoenix
        call Register_Quest_BlazingDemon_EndWeak() // starts off; enabled by Quest_BlazingDemon; destroyed by Quest_BlazingDemon
    endif
endfunction

// Startup registration, part 16 of 21: creates the triggers below, in this order. Called once from
// Startup_RegisterTriggers (MapBootstrap). Each Register_* function sits in the module that
// holds that trigger's code (search for its name).
// Registered in parts so triggers sharing an event with other modules keep their firing order.
function RegisterTriggers_Quest_Part16 takes nothing returns nothing
    static if LIBRARY_TQuestBlazingDemon then
        call Register_Quest_BlazingDemon_End() // starts off; enabled by BlazingDemon; destroyed by Quest_BlazingDemon, BlazingDemon
        call Register_Quest_BlazingDemon_Escape() // starts off; enabled by BlazingDemon; destroyed by Quest_BlazingDemon, BlazingDemon
    endif
    static if LIBRARY_TQuestScorchingTravel then
        call Register_Quest_52_Scorching() // starts off; run by ScorchedEarth
    endif
    static if LIBRARY_TQuestScorchedEarth then
        call Register_Quest_ScorchedEarth_Start() // starts off; run by ScorchedEarth
        call Register_Quest_ScorchedEarth_End() // starts off; enabled by McBurn
    endif
endfunction

// Startup registration, part 17 of 21: creates the triggers below, in this order. Called once from
// Startup_RegisterTriggers (MapBootstrap). Each Register_* function sits in the module that
// holds that trigger's code (search for its name).
// Registered in parts so triggers sharing an event with other modules keep their firing order.
function RegisterTriggers_Quest_Part17 takes nothing returns nothing
    static if LIBRARY_TQuestImperviousBeast then
        call Register_Quest_ImperviousBeast_Start() // starts off; enabled by Ziegfried
        call Register_Quest_ImperviousBeast_Complete() // starts off; enabled by Fafnir
    endif
    static if LIBRARY_TQuestDwarfDisappearance then
        call Register_Quest_DwarfDisappearance_Start() // starts off; enabled by Dwarves
    endif
endfunction

// Startup registration, part 18 of 21: creates the triggers below, in this order. Called once from
// Startup_RegisterTriggers (MapBootstrap). Each Register_* function sits in the module that
// holds that trigger's code (search for its name).
// Registered in parts so triggers sharing an event with other modules keep their firing order.
function RegisterTriggers_Quest_Part18 takes nothing returns nothing
    static if LIBRARY_TQuestOreSupplies then
        call Register_Quest_OreSupplies_Start() // starts off; enabled by Loki
        call Register_Quest_OreSupplies_Deliver() // starts off; enabled by Quest_OreSupplies
    endif
endfunction

// Startup registration, part 19 of 21: creates the triggers below, in this order. Called once from
// Startup_RegisterTriggers (MapBootstrap). Each Register_* function sits in the module that
// holds that trigger's code (search for its name).
// Registered in parts so triggers sharing an event with other modules keep their firing order.
function RegisterTriggers_Quest_Part19 takes nothing returns nothing
    static if LIBRARY_TQuestFieryWings then
        call Register_Quest_FieryWings_Start() // starts off; enabled by Watts
        call Register_Quest_FieryWings_Matriarch_Dead() // starts off; enabled by Quest_FieryWings
        call Register_Quest_FieryWings_Complete() // starts off; enabled by Quest_FieryWings
    endif
    static if LIBRARY_TQuestCooking then
        call Register_Quest_Cooking_Start()
        call Register_Quest_Cooking_Complete() // starts off; enabled by Quest_Cooking
    endif
    static if LIBRARY_TQuestDivineOrder then
        call Register_Quest_DivineOrder_Start() // starts off; enabled by Siegfried
    endif
endfunction

// Startup registration, part 20 of 21: creates the triggers below, in this order. Called once from
// Startup_RegisterTriggers (MapBootstrap). Each Register_* function sits in the module that
// holds that trigger's code (search for its name).
// Registered in parts so triggers sharing an event with other modules keep their firing order.
function RegisterTriggers_Quest_Part20 takes nothing returns nothing
    static if LIBRARY_TQuestDivineOrder then
        call Register_Quest_DivineOrder_Complete() // starts off; enabled by Ziegfried
    endif
    static if LIBRARY_TQuestMonstrum then
        call Register_Quest_Monstrum_Complete() // starts off; enabled by Monstrum
    endif
    static if LIBRARY_TQuestYoungEngineer then
        call Register_Quest_YoungEngineer_Start() // starts off; enabled by Mid
        call Register_Quest_YoungEngineer_Ping() // starts off; enabled by Quest_YoungEngineer; disabled by Quest_YoungEngineer; destroyed by Quest_YoungEngineer
    endif
    static if LIBRARY_TQuestCrossbow then
        call Register_Quest_Crossbow_NeedEnemies() // starts off; enabled by Quest_YoungEngineer; disabled by Quest_Crossbow; destroyed by Quest_Crossbow
        call Register_Quest_Crossbow_Tested() // starts off; enabled by Quest_YoungEngineer
    endif
    static if LIBRARY_TQuestEngineer then
        call Register_Quest_Engineer_GetAdvice() // starts off; enabled by Quest_YoungEngineer
    endif
    static if LIBRARY_TQuestYoungEngineer then
        call Register_Quest_YoungEngineer_Complete() // starts off; enabled by Quest_YoungEngineer
    endif
endfunction

// Startup registration, part 21 of 21: creates the triggers below, in this order. Called once from
// Startup_RegisterTriggers (MapBootstrap). Each Register_* function sits in the module that
// holds that trigger's code (search for its name).
// Registered in parts so triggers sharing an event with other modules keep their firing order.
function RegisterTriggers_Quest_Part21 takes nothing returns nothing
    static if LIBRARY_TQuestSpiritHunt then
        call Register_Quest_SpiritHunt_Start() // starts off; enabled by Frakir
        call Register_Quest_SpiritHunt_Count() // starts off; enabled by Quest_SpiritHunt
        call Register_Quest_SpiritHunt_Complete() // starts off; enabled by Quest_SpiritHunt
    endif
    static if LIBRARY_TQuestFishyDeals then
        call Register_Quest_FishyDeals_Start() // starts off; enabled by Fishing_Setup
        call Register_Quest_FishyDeals_Complete() // starts off; enabled by Quest_FishyDeals
    endif
endfunction

endlibrary
