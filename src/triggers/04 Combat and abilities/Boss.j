library TBoss requires optional TBossAgrias, optional TBossBelias, optional TBossBlackDevil, optional TBossChaos, optional TBossDarkFact, optional TBossDarkRanger, optional TBossDefeat, optional TBossDemesne, optional TBossDemiFiend, optional TBossDrop, optional TBossEchele, optional TBossExodus, optional TBossFamfrit, optional TBossGafgarion, optional TBossGilgamesh, optional TBossGodDragon, optional TBossHashmalum, optional TBossJudges, optional TBossLilith, optional TBossMateus, optional TBossOdin, optional TBossOrcChieftain, optional TBossOzma, optional TBossPenance, optional TBossShemhazai, optional TBossShinryu, optional TBossUltima, optional TBossYukale, optional TBossZalera
function InitTrig_Boss takes nothing returns nothing
endfunction

// Startup registration, part 1 of 14: creates the triggers below, in this order. Called once from
// Startup_RegisterTriggers (MapBootstrap). Each Register_* function sits in the module that
// holds that trigger's code (search for its name).
// Registered in parts so triggers sharing an event with other modules keep their firing order.
function RegisterTriggers_Boss_Part1 takes nothing returns nothing
    static if LIBRARY_TBossGafgarion then
        call Register_Boss_Gafgarion_Intro() // starts off; enabled by Quest_DarkKnight; disabled by Boss_Gafgarion
        call Register_Boss_Gafgarion_Death() // starts off; enabled by Quest_DarkKnight
    endif
    static if LIBRARY_TBossZalera then
        call Register_Boss_Zalera_Intro() // starts off; enabled by Boss_Gafgarion, Cine
    endif
    static if LIBRARY_TBossGafgarion then
        call Register_Boss_Gafgarion_Guard_Death() // starts off; enabled by Boss_Zalera
    endif
    static if LIBRARY_TBossZalera then
        call Register_Boss_Zalera_Death() // starts off; enabled by Boss_Zalera, Boss_Gafgarion
    endif
endfunction

// Startup registration, part 2 of 14: creates the triggers below, in this order. Called once from
// Startup_RegisterTriggers (MapBootstrap). Each Register_* function sits in the module that
// holds that trigger's code (search for its name).
// Registered in parts so triggers sharing an event with other modules keep their firing order.
function RegisterTriggers_Boss_Part2 takes nothing returns nothing
    static if LIBRARY_TBossChaos then
        call Register_Boss_Chaos_Death() // starts off; enabled by VoiceOfForest
    endif
endfunction

// Startup registration, part 3 of 14: creates the triggers below, in this order. Called once from
// Startup_RegisterTriggers (MapBootstrap). Each Register_* function sits in the module that
// holds that trigger's code (search for its name).
// Registered in parts so triggers sharing an event with other modules keep their firing order.
function RegisterTriggers_Boss_Part3 takes nothing returns nothing
    static if LIBRARY_TBossOrcChieftain then
        call Register_Boss_OrcChieftain_Death()
    endif
endfunction

// Startup registration, part 4 of 14: creates the triggers below, in this order. Called once from
// Startup_RegisterTriggers (MapBootstrap). Each Register_* function sits in the module that
// holds that trigger's code (search for its name).
// Registered in parts so triggers sharing an event with other modules keep their firing order.
function RegisterTriggers_Boss_Part4 takes nothing returns nothing
    static if LIBRARY_TBossShemhazai then
        call Register_Boss_Shemhazai_Death() // starts off; enabled by Cuchulainn; disabled by TrueIceAge
    endif
    static if LIBRARY_TBossExodus then
        call Register_Boss_Exodus_Death() // starts off; enabled by Exodus; disabled by TrueIceAge
    endif
endfunction

// Startup registration, part 5 of 14: creates the triggers below, in this order. Called once from
// Startup_RegisterTriggers (MapBootstrap). Each Register_* function sits in the module that
// holds that trigger's code (search for its name).
// Registered in parts so triggers sharing an event with other modules keep their firing order.
function RegisterTriggers_Boss_Part5 takes nothing returns nothing
    static if LIBRARY_TBossFamfrit then
        call Register_Boss_Famfrit_Death() // starts off; enabled by Famfrit; disabled by TrueIceAge
    endif
    static if LIBRARY_TBossUltima then
        call Register_Boss_Ultima_Death() // starts off; enabled by Ultima
    endif
    static if LIBRARY_TBossGodDragon then
        call Register_Boss_GodDragon_Death() // starts off; enabled by GodDragon
    endif
    static if LIBRARY_TBossMateus then
        call Register_Boss_Mateus_Intro() // disabled by Boss_Belias, TrueIceAge
        call Register_Boss_Mateus_CoverSwap() // starts off; enabled by Boss_Mateus, Boss_Belias
    endif
    static if LIBRARY_TBossDemesne then
        call Register_Boss_Demesne_CoverSwap() // starts off; enabled by Boss_Belias, Boss_Mateus
    endif
endfunction

// Startup registration, part 6 of 14: creates the triggers below, in this order. Called once from
// Startup_RegisterTriggers (MapBootstrap). Each Register_* function sits in the module that
// holds that trigger's code (search for its name).
// Registered in parts so triggers sharing an event with other modules keep their firing order.
function RegisterTriggers_Boss_Part6 takes nothing returns nothing
    static if LIBRARY_TBossDemesne then
        call Register_Boss_Demesne_Death_Revive() // starts off; enabled by Boss_Demesne, Boss_Mateus; disabled by Boss_Mateus
        call Register_Boss_Demesne_Revived() // starts off; enabled by Boss_Demesne; disabled by Boss_Mateus
    endif
    static if LIBRARY_TBossMateus then
        call Register_Boss_Mateus_Death() // starts off; enabled by Boss_Mateus; disabled by Boss_Belias, TrueIceAge
    endif
    static if LIBRARY_TBossHashmalum then
        call Register_Boss_Hashmalum_Intro() // starts off; enabled by World
        call Register_Boss_Hashmalum_Revive_Belias() // starts off; enabled by Boss_Hashmalum
        call Register_Boss_Hashmalum_Revive_Loop() // starts off; enabled by Boss_Hashmalum; disabled by Boss_Belias; destroyed by Boss_Belias
    endif
    static if LIBRARY_TBossBelias then
        call Register_Boss_Belias_Rescue_Mateus() // starts off; enabled by Boss_Hashmalum
        call Register_Boss_Belias_Revive_Loop() // starts off; enabled by Boss_Belias
    endif
    static if LIBRARY_TBossMateus then
        call Register_Boss_Mateus_Death_Final() // starts off; enabled by Boss_Belias
    endif
    static if LIBRARY_TBossBelias then
        call Register_Boss_Belias_Rescue_Gafgarion() // starts off; enabled by Boss_Hashmalum
        call Register_Boss_Belias_Gafgarion_Death() // starts off; enabled by Boss_Belias
        call Register_Boss_Belias_Death_Final() // starts off; enabled by Boss_Belias
    endif
    static if LIBRARY_TBossHashmalum then
        call Register_Boss_Hashmalum_Death_Final() // starts off; enabled by Boss_Belias
    endif
endfunction

// Startup registration, part 7 of 14: creates the triggers below, in this order. Called once from
// Startup_RegisterTriggers (MapBootstrap). Each Register_* function sits in the module that
// holds that trigger's code (search for its name).
// Registered in parts so triggers sharing an event with other modules keep their firing order.
function RegisterTriggers_Boss_Part7 takes nothing returns nothing
    static if LIBRARY_TBossEchele then
        call Register_Boss_Echele_Start() // starts off; enabled by Gafgarion, IceAge
        call Register_Boss_Echele_SpawnForm() // starts off; run by Boss_Echele, TrueIceAge
        call Register_Boss_Echele_FormChange() // starts off; enabled by Boss_Echele; disabled by IceAge, TrueIceAge
        call Register_Boss_Echele_KillMinions()
        call Register_Boss_Echele_Leash() // starts off; enabled by Boss_Echele, TrueIceAge; disabled by IceAge, TrueIceAge
    endif
endfunction

// Startup registration, part 8 of 14: creates the triggers below, in this order. Called once from
// Startup_RegisterTriggers (MapBootstrap). Each Register_* function sits in the module that
// holds that trigger's code (search for its name).
// Registered in parts so triggers sharing an event with other modules keep their firing order.
function RegisterTriggers_Boss_Part8 takes nothing returns nothing
    static if LIBRARY_TBossYukale then
        call Register_Boss_Yukale_Death_Revive() // starts off; enabled by Quest_FallenRanger
    endif
    static if LIBRARY_TBossDarkRanger then
        call Register_Boss_DarkRanger_Death() // starts off; enabled by Boss_Yukale
    endif
    static if LIBRARY_TBossAgrias then
        call Register_Boss_Agrias_Intro() // starts off; enabled by Quest_HolyKnight
    endif
endfunction

// Startup registration, part 9 of 14: creates the triggers below, in this order. Called once from
// Startup_RegisterTriggers (MapBootstrap). Each Register_* function sits in the module that
// holds that trigger's code (search for its name).
// Registered in parts so triggers sharing an event with other modules keep their firing order.
function RegisterTriggers_Boss_Part9 takes nothing returns nothing
    static if LIBRARY_TBossAgrias then
        call Register_Boss_Agrias_Death_Lilith() // starts off; enabled by Boss_Agrias
    endif
    static if LIBRARY_TBossLilith then
        call Register_Boss_Lilith_Death() // starts off; enabled by Boss_Agrias
    endif
endfunction

// Startup registration, part 10 of 14: creates the triggers below, in this order. Called once from
// Startup_RegisterTriggers (MapBootstrap). Each Register_* function sits in the module that
// holds that trigger's code (search for its name).
// Registered in parts so triggers sharing an event with other modules keep their firing order.
function RegisterTriggers_Boss_Part10 takes nothing returns nothing
    static if LIBRARY_TBossOdin then
        call Register_Boss_Odin_Intro() // starts off; enabled by Judgment
        call Register_Boss_Odin_Escort_AI() // starts off; enabled by Boss_Odin; disabled by Boss_Odin; destroyed by Boss_Odin
        call Register_Boss_Odin_Death() // starts off; enabled by Boss_Odin
    endif
endfunction

// Startup registration, part 11 of 14: creates the triggers below, in this order. Called once from
// Startup_RegisterTriggers (MapBootstrap). Each Register_* function sits in the module that
// holds that trigger's code (search for its name).
// Registered in parts so triggers sharing an event with other modules keep their firing order.
function RegisterTriggers_Boss_Part11 takes nothing returns nothing
    static if LIBRARY_TBossDrop then
        call Register_Boss_Drop_TomeOfLife()
        call Register_Boss_Drop_CrushersMace()
        call Register_Boss_Drop_FurArmor()
    endif
    static if LIBRARY_TBossPenance then
        call Register_Boss_Penance_Summon() // starts off; enabled by DarkEidolons; run by Summon_Items
        call Register_Boss_Penance_Judgment_Loop() // starts off; enabled by Damage; disabled by Boss_Penance
        call Register_Boss_Penance_JudgmentDay_Cast()
    endif
endfunction

// Startup registration, part 12 of 14: creates the triggers below, in this order. Called once from
// Startup_RegisterTriggers (MapBootstrap). Each Register_* function sits in the module that
// holds that trigger's code (search for its name).
// Registered in parts so triggers sharing an event with other modules keep their firing order.
function RegisterTriggers_Boss_Part12 takes nothing returns nothing
    static if LIBRARY_TBossPenance then
        call Register_Boss_Penance_JudgmentDay_Damage()
        call Register_Boss_Penance_Arm_Death() // starts off; enabled by Damage; disabled by Boss_Penance
        call Register_Boss_Penance_Death() // starts off; enabled by Boss_Penance; disabled by Boss_Penance
        call Register_Boss_Penance_Cleanup() // starts off; used by Boss_Penance
    endif
    static if LIBRARY_TBossGilgamesh then
        call Register_Boss_Gilgamesh_Summon() // starts off; run by Summon_Items
        call Register_Boss_Gilgamesh_NextSword() // starts off; enabled by Boss_Gilgamesh; disabled by Boss_Gilgamesh
        call Register_Boss_Gilgamesh_Death() // starts off; enabled by Boss_Gilgamesh; disabled by Boss_Gilgamesh
        call Register_Boss_Gilgamesh_Cleanup() // starts off; used by Boss_Gilgamesh
    endif
    static if LIBRARY_TBossJudges then
        call Register_Boss_Judges_Summon() // starts off; run by Summon_Items
        call Register_Boss_Judges_Ultimates() // starts off; run by Boss_Judges
        call Register_Boss_Judges_Ghis_AI() // starts off; enabled by Boss_Judges
        call Register_Boss_Judges_Gabranth_AI() // starts off; enabled by Boss_Judges
        call Register_Boss_Judges_Zargabaath_AI() // starts off; enabled by Boss_Judges
        call Register_Boss_Judges_Drace_AI() // starts off; enabled by Boss_Judges
        call Register_Boss_Judges_Death() // starts off; enabled by Boss_Judges; disabled by Boss_Judges
        call Register_Boss_Judges_UseMegalixir() // starts off; enabled by Boss_Judges
        call Register_Boss_Judge_ImperialRage()
        call Register_Boss_Judge_Sentence()
        call Register_Boss_Judge_ChainMagick()
        call Register_Boss_Judges_Cleanup() // starts off; used by Boss_Judges
    endif
    static if LIBRARY_TBossBlackDevil then
        call Register_Boss_BlackDevil_Summon() // starts off; run by Summon_Items
        call Register_Boss_BlackDevil_Death() // starts off; enabled by Boss_BlackDevil; disabled by Boss_BlackDevil
        call Register_Boss_BlackDevil_Cleanup() // starts off; used by Boss_BlackDevil
    endif
    static if LIBRARY_TBossDemiFiend then
        call Register_Boss_DemiFiend_Summon() // starts off; run by Summon_Items
        call Register_Boss_DemiFiend_Demon1_Death() // starts off; enabled by Boss_DemiFiend; disabled by Boss_DemiFiend
        call Register_Boss_DemiFiend_Demon2_Death() // starts off; enabled by Boss_DemiFiend; disabled by Boss_DemiFiend
        call Register_Boss_DemiFiend_Demon1_Spawn() // starts off; enabled by Boss_DemiFiend; disabled by Boss_DemiFiend
        call Register_Boss_DemiFiend_Demon2_Spawn() // starts off; enabled by Boss_DemiFiend; disabled by Boss_DemiFiend
        call Register_Boss_DemiFiend_Mediarahan() // starts off; enabled by Boss_DemiFiend; disabled by Boss_DemiFiend
        call Register_Boss_DemiFiend_Death() // starts off; enabled by Boss_DemiFiend; disabled by Boss_DemiFiend
        call Register_Boss_DemiFiend_Cleanup() // starts off; used by Boss_DemiFiend
    endif
    static if LIBRARY_TBossDarkFact then
        call Register_Boss_DarkFact_Summon() // starts off; run by Summon_Items
        call Register_Boss_DarkFact_Death() // starts off; enabled by Boss_DarkFact; disabled by Boss_DarkFact
        call Register_Boss_DarkFact_FactStrike() // starts off; enabled by Boss_DarkFact; disabled by Boss_DarkFact
    endif
endfunction

// Startup registration, part 13 of 14: creates the triggers below, in this order. Called once from
// Startup_RegisterTriggers (MapBootstrap). Each Register_* function sits in the module that
// holds that trigger's code (search for its name).
// Registered in parts so triggers sharing an event with other modules keep their firing order.
function RegisterTriggers_Boss_Part13 takes nothing returns nothing
    static if LIBRARY_TBossDarkFact then
        call Register_Boss_DarkFact_PingPong()
        call Register_Boss_DarkFact_Orb_Bounce() // used by Boss_DarkFact
        call Register_Boss_DarkFact_Orb_Attack()
        call Register_Boss_DarkFact_Cleanup() // starts off; used by Boss_DarkFact
    endif
    static if LIBRARY_TBossShinryu then
        call Register_Boss_Shinryu_Warmech_Summon() // starts off; run by Summon_Items
    endif
    static if LIBRARY_TBossOzma then
        call Register_Boss_Ozma_Spawn() // starts off; run by Summon_Items
        call Register_Boss_Ozma_Barrier() // starts off; enabled by Boss_Ozma; disabled by Boss_Ozma
        call Register_Boss_Ozma_Death() // starts off; enabled by Boss_Ozma; disabled by Boss_Ozma
        call Register_Boss_Ozma_Cleanup() // starts off; used by Boss_Ozma
    endif
endfunction

// Startup registration, part 14 of 14: creates the triggers below, in this order. Called once from
// Startup_RegisterTriggers (MapBootstrap). Each Register_* function sits in the module that
// holds that trigger's code (search for its name).
// Registered in parts so triggers sharing an event with other modules keep their firing order.
function RegisterTriggers_Boss_Part14 takes nothing returns nothing
    static if LIBRARY_TBossDefeat then
        call Register_Boss_Defeat_Announce()
    endif
endfunction

endlibrary
