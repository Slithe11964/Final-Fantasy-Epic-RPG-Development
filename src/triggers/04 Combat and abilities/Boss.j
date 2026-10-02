library TBoss requires TBossAgrias, TBossBelias, TBossBlackDevil, TBossChaos, TBossDarkFact, TBossDarkRanger, TBossDefeat, TBossDemesne, TBossDemiFiend, TBossDrop, TBossEchele, TBossExodus, TBossFamfrit, TBossGafgarion, TBossGilgamesh, TBossGodDragon, TBossHashmalum, TBossJudges, TBossLilith, TBossMateus, TBossOdin, TBossOrcChieftain, TBossOzma, TBossPenance, TBossShemhazai, TBossShinryu, TBossUltima, TBossYukale, TBossZalera
function InitTrig_Boss takes nothing returns nothing
endfunction

// Startup registration, part 1 of 14: creates the triggers below, in this order. Called once from
// Startup_RegisterTriggers (MapBootstrap). Each Register_* function sits in the module that
// holds that trigger's code (search for its name).
// Registered in parts so triggers sharing an event with other modules keep their firing order.
function RegisterTriggers_Boss_Part1 takes nothing returns nothing
    call Register_Boss_Gafgarion_Intro() // starts off; enabled by Quest_DarkKnight; disabled by Boss_Gafgarion
    call Register_Boss_Gafgarion_Death() // starts off; enabled by Quest_DarkKnight
    call Register_Boss_Zalera_Intro() // starts off; enabled by Boss_Gafgarion, Cine
    call Register_Boss_Gafgarion_Guard_Death() // starts off; enabled by Boss_Zalera
    call Register_Boss_Zalera_Death() // starts off; enabled by Boss_Zalera, Boss_Gafgarion
endfunction

// Startup registration, part 2 of 14: creates the triggers below, in this order. Called once from
// Startup_RegisterTriggers (MapBootstrap). Each Register_* function sits in the module that
// holds that trigger's code (search for its name).
// Registered in parts so triggers sharing an event with other modules keep their firing order.
function RegisterTriggers_Boss_Part2 takes nothing returns nothing
    call Register_Boss_Chaos_Death() // starts off; enabled by VoiceOfForest
endfunction

// Startup registration, part 3 of 14: creates the triggers below, in this order. Called once from
// Startup_RegisterTriggers (MapBootstrap). Each Register_* function sits in the module that
// holds that trigger's code (search for its name).
// Registered in parts so triggers sharing an event with other modules keep their firing order.
function RegisterTriggers_Boss_Part3 takes nothing returns nothing
    call Register_Boss_OrcChieftain_Death()
endfunction

// Startup registration, part 4 of 14: creates the triggers below, in this order. Called once from
// Startup_RegisterTriggers (MapBootstrap). Each Register_* function sits in the module that
// holds that trigger's code (search for its name).
// Registered in parts so triggers sharing an event with other modules keep their firing order.
function RegisterTriggers_Boss_Part4 takes nothing returns nothing
    call Register_Boss_Shemhazai_Death() // starts off; enabled by Cuchulainn; disabled by TrueIceAge
    call Register_Boss_Exodus_Death() // starts off; enabled by Exodus; disabled by TrueIceAge
endfunction

// Startup registration, part 5 of 14: creates the triggers below, in this order. Called once from
// Startup_RegisterTriggers (MapBootstrap). Each Register_* function sits in the module that
// holds that trigger's code (search for its name).
// Registered in parts so triggers sharing an event with other modules keep their firing order.
function RegisterTriggers_Boss_Part5 takes nothing returns nothing
    call Register_Boss_Famfrit_Death() // starts off; enabled by Famfrit; disabled by TrueIceAge
    call Register_Boss_Ultima_Death() // starts off; enabled by Ultima
    call Register_Boss_GodDragon_Death() // starts off; enabled by GodDragon
    call Register_Boss_Mateus_Intro() // disabled by Boss_Belias, TrueIceAge
    call Register_Boss_Mateus_CoverSwap() // starts off; enabled by Boss_Mateus, Boss_Belias
    call Register_Boss_Demesne_CoverSwap() // starts off; enabled by Boss_Belias, Boss_Mateus
endfunction

// Startup registration, part 6 of 14: creates the triggers below, in this order. Called once from
// Startup_RegisterTriggers (MapBootstrap). Each Register_* function sits in the module that
// holds that trigger's code (search for its name).
// Registered in parts so triggers sharing an event with other modules keep their firing order.
function RegisterTriggers_Boss_Part6 takes nothing returns nothing
    call Register_Boss_Demesne_Death_Revive() // starts off; enabled by Boss_Demesne, Boss_Mateus; disabled by Boss_Mateus
    call Register_Boss_Demesne_Revived() // starts off; enabled by Boss_Demesne; disabled by Boss_Mateus
    call Register_Boss_Mateus_Death() // starts off; enabled by Boss_Mateus; disabled by Boss_Belias, TrueIceAge
    call Register_Boss_Hashmalum_Intro() // starts off; enabled by World
    call Register_Boss_Hashmalum_Revive_Belias() // starts off; enabled by Boss_Hashmalum
    call Register_Boss_Hashmalum_Revive_Loop() // starts off; enabled by Boss_Hashmalum; disabled by Boss_Belias; destroyed by Boss_Belias
    call Register_Boss_Belias_Rescue_Mateus() // starts off; enabled by Boss_Hashmalum
    call Register_Boss_Belias_Revive_Loop() // starts off; enabled by Boss_Belias
    call Register_Boss_Mateus_Death_Final() // starts off; enabled by Boss_Belias
    call Register_Boss_Belias_Rescue_Gafgarion() // starts off; enabled by Boss_Hashmalum
    call Register_Boss_Belias_Gafgarion_Death() // starts off; enabled by Boss_Belias
    call Register_Boss_Belias_Death_Final() // starts off; enabled by Boss_Belias
    call Register_Boss_Hashmalum_Death_Final() // starts off; enabled by Boss_Belias
endfunction

// Startup registration, part 7 of 14: creates the triggers below, in this order. Called once from
// Startup_RegisterTriggers (MapBootstrap). Each Register_* function sits in the module that
// holds that trigger's code (search for its name).
// Registered in parts so triggers sharing an event with other modules keep their firing order.
function RegisterTriggers_Boss_Part7 takes nothing returns nothing
    call Register_Boss_Echele_Start() // starts off; enabled by Gafgarion, IceAge
    call Register_Boss_Echele_SpawnForm() // starts off; run by Boss_Echele, TrueIceAge
    call Register_Boss_Echele_FormChange() // starts off; enabled by Boss_Echele; disabled by IceAge, TrueIceAge
    call Register_Boss_Echele_KillMinions()
    call Register_Boss_Echele_Leash() // starts off; enabled by Boss_Echele, TrueIceAge; disabled by IceAge, TrueIceAge
endfunction

// Startup registration, part 8 of 14: creates the triggers below, in this order. Called once from
// Startup_RegisterTriggers (MapBootstrap). Each Register_* function sits in the module that
// holds that trigger's code (search for its name).
// Registered in parts so triggers sharing an event with other modules keep their firing order.
function RegisterTriggers_Boss_Part8 takes nothing returns nothing
    call Register_Boss_Yukale_Death_Revive() // starts off; enabled by Quest_FallenRanger
    call Register_Boss_DarkRanger_Death() // starts off; enabled by Boss_Yukale
    call Register_Boss_Agrias_Intro() // starts off; enabled by Quest_HolyKnight
endfunction

// Startup registration, part 9 of 14: creates the triggers below, in this order. Called once from
// Startup_RegisterTriggers (MapBootstrap). Each Register_* function sits in the module that
// holds that trigger's code (search for its name).
// Registered in parts so triggers sharing an event with other modules keep their firing order.
function RegisterTriggers_Boss_Part9 takes nothing returns nothing
    call Register_Boss_Agrias_Death_Lilith() // starts off; enabled by Boss_Agrias
    call Register_Boss_Lilith_Death() // starts off; enabled by Boss_Agrias
endfunction

// Startup registration, part 10 of 14: creates the triggers below, in this order. Called once from
// Startup_RegisterTriggers (MapBootstrap). Each Register_* function sits in the module that
// holds that trigger's code (search for its name).
// Registered in parts so triggers sharing an event with other modules keep their firing order.
function RegisterTriggers_Boss_Part10 takes nothing returns nothing
    call Register_Boss_Odin_Intro() // starts off; enabled by Judgment
    call Register_Boss_Odin_Escort_AI() // starts off; enabled by Boss_Odin; disabled by Boss_Odin; destroyed by Boss_Odin
    call Register_Boss_Odin_Death() // starts off; enabled by Boss_Odin
endfunction

// Startup registration, part 11 of 14: creates the triggers below, in this order. Called once from
// Startup_RegisterTriggers (MapBootstrap). Each Register_* function sits in the module that
// holds that trigger's code (search for its name).
// Registered in parts so triggers sharing an event with other modules keep their firing order.
function RegisterTriggers_Boss_Part11 takes nothing returns nothing
    call Register_Boss_Drop_TomeOfLife()
    call Register_Boss_Drop_CrushersMace()
    call Register_Boss_Drop_FurArmor()
    call Register_Boss_Penance_Summon() // starts off; enabled by DarkEidolons; run by Summon_Items
    call Register_Boss_Penance_Judgment_Loop() // starts off; enabled by Damage; disabled by Boss_Penance
    call Register_Boss_Penance_JudgmentDay_Cast()
endfunction

// Startup registration, part 12 of 14: creates the triggers below, in this order. Called once from
// Startup_RegisterTriggers (MapBootstrap). Each Register_* function sits in the module that
// holds that trigger's code (search for its name).
// Registered in parts so triggers sharing an event with other modules keep their firing order.
function RegisterTriggers_Boss_Part12 takes nothing returns nothing
    call Register_Boss_Penance_JudgmentDay_Damage()
    call Register_Boss_Penance_Arm_Death() // starts off; enabled by Damage; disabled by Boss_Penance
    call Register_Boss_Penance_Death() // starts off; enabled by Boss_Penance; disabled by Boss_Penance
    call Register_Boss_Penance_Cleanup() // starts off; used by Boss_Penance
    call Register_Boss_Gilgamesh_Summon() // starts off; run by Summon_Items
    call Register_Boss_Gilgamesh_NextSword() // starts off; enabled by Boss_Gilgamesh; disabled by Boss_Gilgamesh
    call Register_Boss_Gilgamesh_Death() // starts off; enabled by Boss_Gilgamesh; disabled by Boss_Gilgamesh
    call Register_Boss_Gilgamesh_Cleanup() // starts off; used by Boss_Gilgamesh
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
    call Register_Boss_BlackDevil_Summon() // starts off; run by Summon_Items
    call Register_Boss_BlackDevil_Death() // starts off; enabled by Boss_BlackDevil; disabled by Boss_BlackDevil
    call Register_Boss_BlackDevil_Cleanup() // starts off; used by Boss_BlackDevil
    call Register_Boss_DemiFiend_Summon() // starts off; run by Summon_Items
    call Register_Boss_DemiFiend_Demon1_Death() // starts off; enabled by Boss_DemiFiend; disabled by Boss_DemiFiend
    call Register_Boss_DemiFiend_Demon2_Death() // starts off; enabled by Boss_DemiFiend; disabled by Boss_DemiFiend
    call Register_Boss_DemiFiend_Demon1_Spawn() // starts off; enabled by Boss_DemiFiend; disabled by Boss_DemiFiend
    call Register_Boss_DemiFiend_Demon2_Spawn() // starts off; enabled by Boss_DemiFiend; disabled by Boss_DemiFiend
    call Register_Boss_DemiFiend_Mediarahan() // starts off; enabled by Boss_DemiFiend; disabled by Boss_DemiFiend
    call Register_Boss_DemiFiend_Death() // starts off; enabled by Boss_DemiFiend; disabled by Boss_DemiFiend
    call Register_Boss_DemiFiend_Cleanup() // starts off; used by Boss_DemiFiend
    call Register_Boss_DarkFact_Summon() // starts off; run by Summon_Items
    call Register_Boss_DarkFact_Death() // starts off; enabled by Boss_DarkFact; disabled by Boss_DarkFact
    call Register_Boss_DarkFact_FactStrike() // starts off; enabled by Boss_DarkFact; disabled by Boss_DarkFact
endfunction

// Startup registration, part 13 of 14: creates the triggers below, in this order. Called once from
// Startup_RegisterTriggers (MapBootstrap). Each Register_* function sits in the module that
// holds that trigger's code (search for its name).
// Registered in parts so triggers sharing an event with other modules keep their firing order.
function RegisterTriggers_Boss_Part13 takes nothing returns nothing
    call Register_Boss_DarkFact_PingPong()
    call Register_Boss_DarkFact_Orb_Bounce() // used by Boss_DarkFact
    call Register_Boss_DarkFact_Orb_Attack()
    call Register_Boss_DarkFact_Cleanup() // starts off; used by Boss_DarkFact
    call Register_Boss_Shinryu_Warmech_Summon() // starts off; run by Summon_Items
    call Register_Boss_Ozma_Spawn() // starts off; run by Summon_Items
    call Register_Boss_Ozma_Barrier() // starts off; enabled by Boss_Ozma; disabled by Boss_Ozma
    call Register_Boss_Ozma_Death() // starts off; enabled by Boss_Ozma; disabled by Boss_Ozma
    call Register_Boss_Ozma_Cleanup() // starts off; used by Boss_Ozma
endfunction

// Startup registration, part 14 of 14: creates the triggers below, in this order. Called once from
// Startup_RegisterTriggers (MapBootstrap). Each Register_* function sits in the module that
// holds that trigger's code (search for its name).
// Registered in parts so triggers sharing an event with other modules keep their firing order.
function RegisterTriggers_Boss_Part14 takes nothing returns nothing
    call Register_Boss_Defeat_Announce()
endfunction

endlibrary
