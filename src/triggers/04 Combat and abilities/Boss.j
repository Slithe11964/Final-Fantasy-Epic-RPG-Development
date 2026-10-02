library TBoss requires TBossAgrias, TBossBelias, TBossBlackDevil, TBossChaos, TBossDarkFact, TBossDarkRanger, TBossDefeat, TBossDemesne, TBossDemiFiend, TBossDrop, TBossEchele, TBossExodus, TBossFamfrit, TBossGafgarion, TBossGilgamesh, TBossGodDragon, TBossHashmalum, TBossJudges, TBossLilith, TBossMateus, TBossOdin, TBossOrcChieftain, TBossOzma, TBossPenance, TBossShemhazai, TBossShinryu, TBossUltima, TBossYukale, TBossZalera
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Boss_Gafgarion_Intro=null
    trigger gg_trg_Boss_Gafgarion_Death=null
    trigger gg_trg_Boss_Zalera_Intro=null
    trigger gg_trg_Boss_Gafgarion_Guard_Death=null
    trigger gg_trg_Boss_Zalera_Death=null
    trigger gg_trg_Boss_Chaos_Death=null
    trigger gg_trg_Boss_OrcChieftain_Death=null
    trigger gg_trg_Boss_Shemhazai_Death=null
    trigger gg_trg_Boss_Exodus_Death=null
    trigger gg_trg_Boss_Famfrit_Death=null
    trigger gg_trg_Boss_Ultima_Death=null
    trigger gg_trg_Boss_GodDragon_Death=null
    trigger gg_trg_Boss_Mateus_Intro=null
    trigger gg_trg_Boss_Mateus_CoverSwap=null
    trigger gg_trg_Boss_Demesne_CoverSwap=null
    trigger gg_trg_Boss_Demesne_Death_Revive=null
    trigger gg_trg_Boss_Demesne_Revived=null
    trigger gg_trg_Boss_Mateus_Death=null
    trigger gg_trg_Boss_Hashmalum_Intro=null
    trigger gg_trg_Boss_Hashmalum_Revive_Belias=null
    trigger gg_trg_Boss_Hashmalum_Revive_Loop=null
    trigger gg_trg_Boss_Belias_Rescue_Mateus=null
    trigger gg_trg_Boss_Belias_Revive_Loop=null
    trigger gg_trg_Boss_Mateus_Death_Final=null
    trigger gg_trg_Boss_Belias_Rescue_Gafgarion=null
    trigger gg_trg_Boss_Belias_Gafgarion_Death=null
    trigger gg_trg_Boss_Belias_Death_Final=null
    trigger gg_trg_Boss_Hashmalum_Death_Final=null
    trigger gg_trg_Boss_Echele_Start=null
    trigger gg_trg_Boss_Echele_SpawnForm=null
    trigger gg_trg_Boss_Echele_FormChange=null
    trigger gg_trg_Boss_Echele_KillMinions=null
    trigger gg_trg_Boss_Echele_Leash=null
    trigger gg_trg_Boss_Yukale_Death_Revive=null
    trigger gg_trg_Boss_DarkRanger_Death=null
    trigger gg_trg_Boss_Agrias_Intro=null
    trigger gg_trg_Boss_Agrias_Death_Lilith=null
    trigger gg_trg_Boss_Lilith_Death=null
    trigger gg_trg_Boss_Odin_Intro=null
    trigger gg_trg_Boss_Odin_Escort_AI=null
    trigger gg_trg_Boss_Odin_Death=null
    trigger gg_trg_Boss_Drop_TomeOfLife=null
    trigger gg_trg_Boss_Drop_CrushersMace=null
    trigger gg_trg_Boss_Drop_FurArmor=null
    trigger gg_trg_Boss_Penance_Summon=null
    trigger gg_trg_Boss_Penance_Judgment_Loop=null
    trigger gg_trg_Boss_Penance_JudgmentDay_Cast=null
    trigger gg_trg_Boss_Penance_JudgmentDay_Damage=null
    trigger gg_trg_Boss_Penance_Arm_Death=null
    trigger gg_trg_Boss_Penance_Death=null
    trigger gg_trg_Boss_Penance_Cleanup=null
    trigger gg_trg_Boss_Gilgamesh_Summon=null
    trigger gg_trg_Boss_Gilgamesh_NextSword=null
    trigger gg_trg_Boss_Gilgamesh_Death=null
    trigger gg_trg_Boss_Gilgamesh_Cleanup=null
    trigger gg_trg_Boss_Judges_Summon=null
    trigger gg_trg_Boss_Judges_Ultimates=null
    trigger gg_trg_Boss_Judges_Ghis_AI=null
    trigger gg_trg_Boss_Judges_Gabranth_AI=null
    trigger gg_trg_Boss_Judges_Zargabaath_AI=null
    trigger gg_trg_Boss_Judges_Drace_AI=null
    trigger gg_trg_Boss_Judges_Death=null
    trigger gg_trg_Boss_Judges_UseMegalixir=null
    trigger gg_trg_Boss_Judge_ImperialRage=null
    trigger gg_trg_Boss_Judge_Sentence=null
    trigger gg_trg_Boss_Judge_ChainMagick=null
    trigger gg_trg_Boss_Judges_Cleanup=null
    trigger gg_trg_Boss_BlackDevil_Summon=null
    trigger gg_trg_Boss_BlackDevil_Death=null
    trigger gg_trg_Boss_BlackDevil_Cleanup=null
    trigger gg_trg_Boss_DemiFiend_Summon=null
    trigger gg_trg_Boss_DemiFiend_Demon1_Death=null
    trigger gg_trg_Boss_DemiFiend_Demon2_Death=null
    trigger gg_trg_Boss_DemiFiend_Demon1_Spawn=null
    trigger gg_trg_Boss_DemiFiend_Demon2_Spawn=null
    trigger gg_trg_Boss_DemiFiend_Mediarahan=null
    trigger gg_trg_Boss_DemiFiend_Death=null
    trigger gg_trg_Boss_DemiFiend_Cleanup=null
    trigger gg_trg_Boss_DarkFact_Summon=null
    trigger gg_trg_Boss_DarkFact_Death=null
    trigger gg_trg_Boss_DarkFact_FactStrike=null
    trigger gg_trg_Boss_DarkFact_PingPong=null
    trigger gg_trg_Boss_DarkFact_Orb_Bounce=null
    trigger gg_trg_Boss_DarkFact_Orb_Attack=null
    trigger gg_trg_Boss_DarkFact_Cleanup=null
    trigger gg_trg_Boss_Shinryu_Warmech_Summon=null
    trigger gg_trg_Boss_Ozma_Spawn=null
    trigger gg_trg_Boss_Ozma_Barrier=null
    trigger gg_trg_Boss_Ozma_Death=null
    trigger gg_trg_Boss_Ozma_Cleanup=null
    trigger gg_trg_Boss_Defeat_Announce=null
endglobals

function InitTrig_Boss takes nothing returns nothing
endfunction

function Register_Boss_Agrias_Intro takes nothing returns nothing
    set gg_trg_Boss_Agrias_Intro=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_Agrias_Intro)
    call TriggerRegisterUnitInRangeSimple(gg_trg_Boss_Agrias_Intro,250.,gg_unit_Ewrd_0120)
    call TriggerRegisterUnitInRangeSimple(gg_trg_Boss_Agrias_Intro,450.,gg_unit_Ewrd_0120)
    call TriggerRegisterUnitInRangeSimple(gg_trg_Boss_Agrias_Intro,700.,gg_unit_Ewrd_0120)
    call TriggerAddCondition(gg_trg_Boss_Agrias_Intro,Condition(function Trig_Boss_Agrias_Intro_Conditions))
    call TriggerAddAction(gg_trg_Boss_Agrias_Intro,function Trig_Boss_Agrias_Intro_Actions)
endfunction

function Register_Boss_Agrias_Death_Lilith takes nothing returns nothing
    set gg_trg_Boss_Agrias_Death_Lilith=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_Agrias_Death_Lilith)
    call TriggerRegisterUnitEvent(gg_trg_Boss_Agrias_Death_Lilith,gg_unit_Ewrd_0120,EVENT_UNIT_DEATH)
    call TriggerAddAction(gg_trg_Boss_Agrias_Death_Lilith,function Trig_Boss_Agrias_Death_Lilith_Actions)
endfunction

function Register_Boss_Belias_Rescue_Mateus takes nothing returns nothing
    set gg_trg_Boss_Belias_Rescue_Mateus=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_Belias_Rescue_Mateus)
    call TriggerRegisterUnitEvent(gg_trg_Boss_Belias_Rescue_Mateus,gg_unit_Uwar_0192,EVENT_UNIT_DEATH)
    call TriggerAddCondition(gg_trg_Boss_Belias_Rescue_Mateus,Condition(function Trig_Boss_Belias_Rescue_Mateus_Conditions))
    call TriggerAddAction(gg_trg_Boss_Belias_Rescue_Mateus,function Trig_Boss_Belias_Rescue_Mateus_Actions)
endfunction

function Register_Boss_Belias_Revive_Loop takes nothing returns nothing
    set gg_trg_Boss_Belias_Revive_Loop=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_Belias_Revive_Loop)
    call TriggerRegisterUnitEvent(gg_trg_Boss_Belias_Revive_Loop,gg_unit_Uwar_0192,EVENT_UNIT_DEATH)
    call TriggerAddCondition(gg_trg_Boss_Belias_Revive_Loop,Condition(function Trig_Boss_Belias_Revive_Loop_Conditions))
    call TriggerAddAction(gg_trg_Boss_Belias_Revive_Loop,function Trig_Boss_Belias_Revive_Loop_Actions)
endfunction

function Register_Boss_Belias_Rescue_Gafgarion takes nothing returns nothing
    set gg_trg_Boss_Belias_Rescue_Gafgarion=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_Belias_Rescue_Gafgarion)
    call TriggerRegisterUnitEvent(gg_trg_Boss_Belias_Rescue_Gafgarion,gg_unit_Uwar_0192,EVENT_UNIT_DEATH)
    call TriggerAddCondition(gg_trg_Boss_Belias_Rescue_Gafgarion,Condition(function Trig_Boss_Belias_Rescue_Gafgarion_Conditions))
    call TriggerAddAction(gg_trg_Boss_Belias_Rescue_Gafgarion,function Trig_Boss_Belias_Rescue_Gafgarion_Actions)
endfunction

function Register_Boss_Belias_Gafgarion_Death takes nothing returns nothing
    set gg_trg_Boss_Belias_Gafgarion_Death=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_Belias_Gafgarion_Death)
    call TriggerAddAction(gg_trg_Boss_Belias_Gafgarion_Death,function Trig_Boss_Belias_Gafgarion_Death_Actions)
endfunction

function Register_Boss_Belias_Death_Final takes nothing returns nothing
    set gg_trg_Boss_Belias_Death_Final=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_Belias_Death_Final)
    call TriggerRegisterUnitEvent(gg_trg_Boss_Belias_Death_Final,gg_unit_Uwar_0192,EVENT_UNIT_DEATH)
    call TriggerAddAction(gg_trg_Boss_Belias_Death_Final,function Trig_Boss_Belias_Death_Final_Actions)
endfunction

function Register_Boss_BlackDevil_Summon takes nothing returns nothing
    set gg_trg_Boss_BlackDevil_Summon=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_BlackDevil_Summon)
    call TriggerAddAction(gg_trg_Boss_BlackDevil_Summon,function Trig_Boss_BlackDevil_Summon_Actions)
endfunction

function Register_Boss_BlackDevil_Death takes nothing returns nothing
    set gg_trg_Boss_BlackDevil_Death=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_BlackDevil_Death)
    call TriggerAddCondition(gg_trg_Boss_BlackDevil_Death,Condition(function Trig_Boss_BlackDevil_Death_Conditions))
    call TriggerAddAction(gg_trg_Boss_BlackDevil_Death,function Trig_Boss_BlackDevil_Death_Actions)
endfunction

function Register_Boss_BlackDevil_Cleanup takes nothing returns nothing
    set gg_trg_Boss_BlackDevil_Cleanup=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_BlackDevil_Cleanup)
    call TriggerAddAction(gg_trg_Boss_BlackDevil_Cleanup,function Trig_Boss_BlackDevil_Cleanup_Actions)
endfunction

function Register_Boss_Chaos_Death takes nothing returns nothing
    set gg_trg_Boss_Chaos_Death=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_Chaos_Death)
    call TriggerRegisterUnitEvent(gg_trg_Boss_Chaos_Death,gg_unit_U00O_0191,EVENT_UNIT_DEATH)
    call TriggerAddAction(gg_trg_Boss_Chaos_Death,function Trig_Boss_Chaos_Death_Actions)
endfunction

function Register_Boss_DarkFact_Summon takes nothing returns nothing
    set gg_trg_Boss_DarkFact_Summon=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_DarkFact_Summon)
    call TriggerAddAction(gg_trg_Boss_DarkFact_Summon,function Trig_Boss_DarkFact_Summon_Actions)
endfunction

function Register_Boss_DarkFact_Death takes nothing returns nothing
    set gg_trg_Boss_DarkFact_Death=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_DarkFact_Death)
    call TriggerAddCondition(gg_trg_Boss_DarkFact_Death,Condition(function Trig_Boss_DarkFact_Death_Conditions))
    call TriggerAddAction(gg_trg_Boss_DarkFact_Death,function Trig_Boss_DarkFact_Death_Actions)
endfunction

function Register_Boss_DarkFact_FactStrike takes nothing returns nothing
    set gg_trg_Boss_DarkFact_FactStrike=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_DarkFact_FactStrike)
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Boss_DarkFact_FactStrike,EVENT_PLAYER_UNIT_SPELL_CAST)
    call TriggerAddCondition(gg_trg_Boss_DarkFact_FactStrike,Condition(function Trig_Boss_DarkFact_FactStrike_Conditions))
    call TriggerAddAction(gg_trg_Boss_DarkFact_FactStrike,function Trig_Boss_DarkFact_FactStrike_Actions)
endfunction

function Register_Boss_DarkFact_PingPong takes nothing returns nothing
    set gg_trg_Boss_DarkFact_PingPong=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Boss_DarkFact_PingPong,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Boss_DarkFact_PingPong,Condition(function Trig_Boss_DarkFact_PingPong_Conditions))
    call TriggerAddAction(gg_trg_Boss_DarkFact_PingPong,function Trig_Boss_DarkFact_PingPong_Actions)
endfunction

function Register_Boss_DarkFact_Orb_Bounce takes nothing returns nothing
    set gg_trg_Boss_DarkFact_Orb_Bounce=CreateTrigger()
    call TriggerAddCondition(gg_trg_Boss_DarkFact_Orb_Bounce,Condition(function Trig_Boss_DarkFact_Orb_Bounce_Conditions))
    call TriggerAddAction(gg_trg_Boss_DarkFact_Orb_Bounce,function Trig_Boss_DarkFact_Orb_Bounce_Actions)
endfunction

function Register_Boss_DarkFact_Orb_Attack takes nothing returns nothing
    set gg_trg_Boss_DarkFact_Orb_Attack=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Boss_DarkFact_Orb_Attack,EVENT_PLAYER_UNIT_ATTACKED)
    call TriggerAddCondition(gg_trg_Boss_DarkFact_Orb_Attack,Condition(function Trig_Boss_DarkFact_Orb_Attack_Conditions))
    call TriggerAddAction(gg_trg_Boss_DarkFact_Orb_Attack,function Trig_Boss_DarkFact_Orb_Attack_Actions)
endfunction

function Register_Boss_DarkFact_Cleanup takes nothing returns nothing
    set gg_trg_Boss_DarkFact_Cleanup=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_DarkFact_Cleanup)
    call TriggerAddAction(gg_trg_Boss_DarkFact_Cleanup,function Trig_Boss_DarkFact_Cleanup_Actions)
endfunction

function Register_Boss_DarkRanger_Death takes nothing returns nothing
    set gg_trg_Boss_DarkRanger_Death=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_DarkRanger_Death)
    call TriggerRegisterUnitEvent(gg_trg_Boss_DarkRanger_Death,gg_unit_H00Y_0022,EVENT_UNIT_DEATH)
    call TriggerAddAction(gg_trg_Boss_DarkRanger_Death,function Trig_Boss_DarkRanger_Death_Actions)
endfunction

function Register_Boss_Defeat_Announce takes nothing returns nothing
    set gg_trg_Boss_Defeat_Announce=CreateTrigger()
    call TriggerRegisterUnitEvent(gg_trg_Boss_Defeat_Announce,gg_unit_Hvsh_0145,EVENT_UNIT_DEATH)
    call TriggerRegisterUnitEvent(gg_trg_Boss_Defeat_Announce,gg_unit_H00Y_0022,EVENT_UNIT_DEATH)
    call TriggerRegisterUnitEvent(gg_trg_Boss_Defeat_Announce,gg_unit_Nbbc_0006,EVENT_UNIT_DEATH)
    call TriggerRegisterUnitEvent(gg_trg_Boss_Defeat_Announce,gg_unit_n00F_0139,EVENT_UNIT_DEATH)
    call TriggerRegisterUnitEvent(gg_trg_Boss_Defeat_Announce,gg_unit_Hgam_0060,EVENT_UNIT_DEATH)
    call TriggerRegisterUnitEvent(gg_trg_Boss_Defeat_Announce,gg_unit_n00H_0005,EVENT_UNIT_DEATH)
    call TriggerRegisterUnitEvent(gg_trg_Boss_Defeat_Announce,gg_unit_n014_0174,EVENT_UNIT_DEATH)
    call TriggerRegisterUnitEvent(gg_trg_Boss_Defeat_Announce,gg_unit_n01Z_0127,EVENT_UNIT_DEATH)
    call TriggerRegisterUnitEvent(gg_trg_Boss_Defeat_Announce,gg_unit_Uvng_0076,EVENT_UNIT_DEATH)
    call TriggerRegisterUnitEvent(gg_trg_Boss_Defeat_Announce,gg_unit_U006_0077,EVENT_UNIT_DEATH)
    call TriggerRegisterUnitEvent(gg_trg_Boss_Defeat_Announce,gg_unit_H00W_0079,EVENT_UNIT_DEATH)
    call TriggerRegisterUnitEvent(gg_trg_Boss_Defeat_Announce,gg_unit_e009_0118,EVENT_UNIT_DEATH)
    call TriggerRegisterUnitEvent(gg_trg_Boss_Defeat_Announce,gg_unit_H01I_0070,EVENT_UNIT_DEATH)
    call TriggerRegisterUnitEvent(gg_trg_Boss_Defeat_Announce,gg_unit_H01J_0069,EVENT_UNIT_DEATH)
    call TriggerRegisterUnitEvent(gg_trg_Boss_Defeat_Announce,gg_unit_H01K_0068,EVENT_UNIT_DEATH)
    call TriggerRegisterUnitEvent(gg_trg_Boss_Defeat_Announce,gg_unit_H01L_0067,EVENT_UNIT_DEATH)
    call TriggerRegisterUnitEvent(gg_trg_Boss_Defeat_Announce,gg_unit_Nman_0151,EVENT_UNIT_DEATH)
    call TriggerRegisterUnitEvent(gg_trg_Boss_Defeat_Announce,gg_unit_N022_0125,EVENT_UNIT_DEATH)
    call TriggerRegisterUnitEvent(gg_trg_Boss_Defeat_Announce,gg_unit_U00C_0024,EVENT_UNIT_DEATH)
    call TriggerRegisterUnitEvent(gg_trg_Boss_Defeat_Announce,gg_unit_O00I_0239,EVENT_UNIT_DEATH)
    call TriggerRegisterUnitEvent(gg_trg_Boss_Defeat_Announce,gg_unit_H02W_0246,EVENT_UNIT_DEATH)
    call TriggerAddCondition(gg_trg_Boss_Defeat_Announce,Condition(function Trig_Boss_Defeat_Announce_Conditions))
    call TriggerAddAction(gg_trg_Boss_Defeat_Announce,function Trig_Boss_Defeat_Announce_Actions)
endfunction

function Register_Boss_Demesne_CoverSwap takes nothing returns nothing
    set gg_trg_Boss_Demesne_CoverSwap=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_Demesne_CoverSwap)
    call TriggerRegisterUnitEvent(gg_trg_Boss_Demesne_CoverSwap,gg_unit_U00M_0206,EVENT_UNIT_DAMAGED)
    call TriggerAddCondition(gg_trg_Boss_Demesne_CoverSwap,Condition(function Trig_Boss_Demesne_CoverSwap_Conditions))
    call TriggerAddAction(gg_trg_Boss_Demesne_CoverSwap,function Trig_Boss_Demesne_CoverSwap_Actions)
endfunction

function Register_Boss_Demesne_Death_Revive takes nothing returns nothing
    set gg_trg_Boss_Demesne_Death_Revive=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_Demesne_Death_Revive)
    call TriggerRegisterUnitEvent(gg_trg_Boss_Demesne_Death_Revive,gg_unit_U00M_0206,EVENT_UNIT_DEATH)
    call TriggerAddAction(gg_trg_Boss_Demesne_Death_Revive,function Trig_Boss_Demesne_Death_Revive_Actions)
endfunction

function Register_Boss_Demesne_Revived takes nothing returns nothing
    set gg_trg_Boss_Demesne_Revived=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_Demesne_Revived)
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Boss_Demesne_Revived,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Boss_Demesne_Revived,Condition(function Trig_Boss_Demesne_Revived_Conditions))
    call TriggerAddAction(gg_trg_Boss_Demesne_Revived,function Trig_Boss_Demesne_Revived_Actions)
endfunction

function Register_Boss_DemiFiend_Summon takes nothing returns nothing
    set gg_trg_Boss_DemiFiend_Summon=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_DemiFiend_Summon)
    call TriggerAddAction(gg_trg_Boss_DemiFiend_Summon,function Trig_Boss_DemiFiend_Summon_Actions)
endfunction

function Register_Boss_DemiFiend_Demon1_Death takes nothing returns nothing
    set gg_trg_Boss_DemiFiend_Demon1_Death=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_DemiFiend_Demon1_Death)
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_Boss_DemiFiend_Demon1_Death,Player($B),EVENT_PLAYER_UNIT_DEATH) // $B = 11
    call TriggerAddCondition(gg_trg_Boss_DemiFiend_Demon1_Death,Condition(function Trig_Boss_DemiFiend_Demon1_Death_Conditions))
    call TriggerAddAction(gg_trg_Boss_DemiFiend_Demon1_Death,function Trig_Boss_DemiFiend_Demon1_Death_Actions)
endfunction

function Register_Boss_DemiFiend_Demon2_Death takes nothing returns nothing
    set gg_trg_Boss_DemiFiend_Demon2_Death=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_DemiFiend_Demon2_Death)
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_Boss_DemiFiend_Demon2_Death,Player($B),EVENT_PLAYER_UNIT_DEATH) // $B = 11
    call TriggerAddCondition(gg_trg_Boss_DemiFiend_Demon2_Death,Condition(function Trig_Boss_DemiFiend_Demon2_Death_Conditions))
    call TriggerAddAction(gg_trg_Boss_DemiFiend_Demon2_Death,function Trig_Boss_DemiFiend_Demon2_Death_Actions)
endfunction

function Register_Boss_DemiFiend_Demon1_Spawn takes nothing returns nothing
    set gg_trg_Boss_DemiFiend_Demon1_Spawn=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_DemiFiend_Demon1_Spawn)
    call TriggerRegisterTimerExpireEventBJ(gg_trg_Boss_DemiFiend_Demon1_Spawn,udg_DemiFiendDemon1Timer)
    call TriggerAddAction(gg_trg_Boss_DemiFiend_Demon1_Spawn,function Trig_Boss_DemiFiend_Demon1_Spawn_Actions)
endfunction

function Register_Boss_DemiFiend_Demon2_Spawn takes nothing returns nothing
    set gg_trg_Boss_DemiFiend_Demon2_Spawn=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_DemiFiend_Demon2_Spawn)
    call TriggerRegisterTimerExpireEventBJ(gg_trg_Boss_DemiFiend_Demon2_Spawn,udg_DemiFiendDemon2Timer)
    call TriggerAddAction(gg_trg_Boss_DemiFiend_Demon2_Spawn,function Trig_Boss_DemiFiend_Demon2_Spawn_Actions)
endfunction

function Register_Boss_DemiFiend_Mediarahan takes nothing returns nothing
    set gg_trg_Boss_DemiFiend_Mediarahan=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_DemiFiend_Mediarahan)
    call TriggerAddCondition(gg_trg_Boss_DemiFiend_Mediarahan,Condition(function Trig_Boss_DemiFiend_Mediarahan_Conditions))
    call TriggerAddAction(gg_trg_Boss_DemiFiend_Mediarahan,function Trig_Boss_DemiFiend_Mediarahan_Actions)
endfunction

function Register_Boss_DemiFiend_Death takes nothing returns nothing
    set gg_trg_Boss_DemiFiend_Death=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_DemiFiend_Death)
    call TriggerAddCondition(gg_trg_Boss_DemiFiend_Death,Condition(function Trig_Boss_DemiFiend_Death_Conditions))
    call TriggerAddAction(gg_trg_Boss_DemiFiend_Death,function Trig_Boss_DemiFiend_Death_Actions)
endfunction

function Register_Boss_DemiFiend_Cleanup takes nothing returns nothing
    set gg_trg_Boss_DemiFiend_Cleanup=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_DemiFiend_Cleanup)
    call TriggerAddAction(gg_trg_Boss_DemiFiend_Cleanup,function Trig_Boss_DemiFiend_Cleanup_Actions)
endfunction

function Register_Boss_Drop_TomeOfLife takes nothing returns nothing
    set gg_trg_Boss_Drop_TomeOfLife=CreateTrigger()
    call TriggerRegisterUnitEvent(gg_trg_Boss_Drop_TomeOfLife,gg_unit_U006_0077,EVENT_UNIT_DEATH)
    call TriggerAddAction(gg_trg_Boss_Drop_TomeOfLife,function Trig_Boss_Drop_TomeOfLife_Actions)
endfunction

function Register_Boss_Drop_CrushersMace takes nothing returns nothing
    set gg_trg_Boss_Drop_CrushersMace=CreateTrigger()
    call TriggerRegisterUnitEvent(gg_trg_Boss_Drop_CrushersMace,gg_unit_H00W_0079,EVENT_UNIT_DEATH)
    call TriggerAddAction(gg_trg_Boss_Drop_CrushersMace,function Trig_Boss_Drop_CrushersMace_Actions)
endfunction

function Register_Boss_Drop_FurArmor takes nothing returns nothing
    set gg_trg_Boss_Drop_FurArmor=CreateTrigger()
    call TriggerRegisterUnitEvent(gg_trg_Boss_Drop_FurArmor,gg_unit_n014_0174,EVENT_UNIT_DEATH)
    call TriggerAddAction(gg_trg_Boss_Drop_FurArmor,function Trig_Boss_Drop_FurArmor_Actions)
endfunction

function Register_Boss_Echele_Start takes nothing returns nothing
    set gg_trg_Boss_Echele_Start=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_Echele_Start)
    call TriggerRegisterEnterRectSimple(gg_trg_Boss_Echele_Start,gg_rct_657)
    call TriggerAddCondition(gg_trg_Boss_Echele_Start,Condition(function Trig_Boss_Echele_Start_Conditions))
    call TriggerAddAction(gg_trg_Boss_Echele_Start,function Trig_Boss_Echele_Start_Actions)
endfunction

function Register_Boss_Echele_SpawnForm takes nothing returns nothing
    set gg_trg_Boss_Echele_SpawnForm=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_Echele_SpawnForm)
    call TriggerAddAction(gg_trg_Boss_Echele_SpawnForm,function Trig_Boss_Echele_SpawnForm_Actions)
endfunction

function Register_Boss_Echele_FormChange takes nothing returns nothing
    set gg_trg_Boss_Echele_FormChange=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_Echele_FormChange)
    call TriggerAddCondition(gg_trg_Boss_Echele_FormChange,Condition(function Trig_Boss_Echele_FormChange_Conditions))
    call TriggerAddAction(gg_trg_Boss_Echele_FormChange,function Trig_Boss_Echele_FormChange_Actions)
endfunction

function Register_Boss_Echele_KillMinions takes nothing returns nothing
    set gg_trg_Boss_Echele_KillMinions=CreateTrigger()
    call TriggerRegisterTimerExpireEventBJ(gg_trg_Boss_Echele_KillMinions,udg_EcheleMinionKillTimer)
    call TriggerAddAction(gg_trg_Boss_Echele_KillMinions,function Trig_Boss_Echele_KillMinions_Actions)
endfunction

function Register_Boss_Echele_Leash takes nothing returns nothing
    set gg_trg_Boss_Echele_Leash=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_Echele_Leash)
    call TriggerRegisterEnterRectSimple(gg_trg_Boss_Echele_Leash,gg_rct_660)
    call TriggerAddCondition(gg_trg_Boss_Echele_Leash,Condition(function Trig_Boss_Echele_Leash_Conditions))
    call TriggerAddAction(gg_trg_Boss_Echele_Leash,function Trig_Boss_Echele_Leash_Actions)
endfunction

function Register_Boss_Exodus_Death takes nothing returns nothing
    set gg_trg_Boss_Exodus_Death=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_Exodus_Death)
    call TriggerRegisterUnitEvent(gg_trg_Boss_Exodus_Death,gg_unit_U00K_0208,EVENT_UNIT_DEATH)
    call TriggerAddAction(gg_trg_Boss_Exodus_Death,function Trig_Boss_Exodus_Death_Actions)
endfunction

function Register_Boss_Famfrit_Death takes nothing returns nothing
    set gg_trg_Boss_Famfrit_Death=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_Famfrit_Death)
    call TriggerRegisterUnitEvent(gg_trg_Boss_Famfrit_Death,gg_unit_U00N_0205,EVENT_UNIT_DEATH)
    call TriggerAddAction(gg_trg_Boss_Famfrit_Death,function Trig_Boss_Famfrit_Death_Actions)
endfunction

function Register_Boss_Gafgarion_Intro takes nothing returns nothing
    set gg_trg_Boss_Gafgarion_Intro=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_Gafgarion_Intro)
    call TriggerAddCondition(gg_trg_Boss_Gafgarion_Intro,Condition(function Trig_Boss_Gafgarion_Intro_Conditions))
    call TriggerAddAction(gg_trg_Boss_Gafgarion_Intro,function Trig_Boss_Gafgarion_Intro_Actions)
endfunction

function Register_Boss_Gafgarion_Death takes nothing returns nothing
    set gg_trg_Boss_Gafgarion_Death=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_Gafgarion_Death)
    call TriggerAddAction(gg_trg_Boss_Gafgarion_Death,function Trig_Boss_Gafgarion_Death_Actions)
endfunction

function Register_Boss_Gafgarion_Guard_Death takes nothing returns nothing
    set gg_trg_Boss_Gafgarion_Guard_Death=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_Gafgarion_Guard_Death)
    call TriggerAddAction(gg_trg_Boss_Gafgarion_Guard_Death,function Trig_Boss_Gafgarion_Guard_Death_Actions)
endfunction

function Register_Boss_Gilgamesh_Summon takes nothing returns nothing
    set gg_trg_Boss_Gilgamesh_Summon=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_Gilgamesh_Summon)
    call TriggerAddAction(gg_trg_Boss_Gilgamesh_Summon,function Trig_Boss_Gilgamesh_Summon_Actions)
endfunction

function Register_Boss_Gilgamesh_NextSword takes nothing returns nothing
    set gg_trg_Boss_Gilgamesh_NextSword=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_Gilgamesh_NextSword)
    call TriggerAddCondition(gg_trg_Boss_Gilgamesh_NextSword,Condition(function Trig_Boss_Gilgamesh_NextSword_Conditions))
    call TriggerAddAction(gg_trg_Boss_Gilgamesh_NextSword,function Trig_Boss_Gilgamesh_NextSword_Actions)
endfunction

function Register_Boss_Gilgamesh_Death takes nothing returns nothing
    set gg_trg_Boss_Gilgamesh_Death=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_Gilgamesh_Death)
    call TriggerAddCondition(gg_trg_Boss_Gilgamesh_Death,Condition(function Trig_Boss_Gilgamesh_Death_Conditions))
    call TriggerAddAction(gg_trg_Boss_Gilgamesh_Death,function Trig_Boss_Gilgamesh_Death_Actions)
endfunction

function Register_Boss_Gilgamesh_Cleanup takes nothing returns nothing
    set gg_trg_Boss_Gilgamesh_Cleanup=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_Gilgamesh_Cleanup)
    call TriggerAddAction(gg_trg_Boss_Gilgamesh_Cleanup,function Trig_Boss_Gilgamesh_Cleanup_Actions)
endfunction

function Register_Boss_GodDragon_Death takes nothing returns nothing
    set gg_trg_Boss_GodDragon_Death=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_GodDragon_Death)
    call TriggerRegisterUnitEvent(gg_trg_Boss_GodDragon_Death,gg_unit_U00H_0211,EVENT_UNIT_DEATH)
    call TriggerAddAction(gg_trg_Boss_GodDragon_Death,function Trig_Boss_GodDragon_Death_Actions)
endfunction

function Register_Boss_Hashmalum_Intro takes nothing returns nothing
    set gg_trg_Boss_Hashmalum_Intro=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_Hashmalum_Intro)
    call TriggerRegisterUnitInRangeSimple(gg_trg_Boss_Hashmalum_Intro,700.,gg_unit_E002_0075)
    call TriggerAddCondition(gg_trg_Boss_Hashmalum_Intro,Condition(function Trig_Boss_Hashmalum_Intro_Conditions))
    call TriggerAddAction(gg_trg_Boss_Hashmalum_Intro,function Trig_Boss_Hashmalum_Intro_Actions)
endfunction

function Register_Boss_Hashmalum_Revive_Belias takes nothing returns nothing
    set gg_trg_Boss_Hashmalum_Revive_Belias=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_Hashmalum_Revive_Belias)
    call TriggerRegisterUnitEvent(gg_trg_Boss_Hashmalum_Revive_Belias,gg_unit_E002_0075,EVENT_UNIT_DEATH)
    call TriggerAddAction(gg_trg_Boss_Hashmalum_Revive_Belias,function Trig_Boss_Hashmalum_Revive_Belias_Actions)
endfunction

function Register_Boss_Hashmalum_Revive_Loop takes nothing returns nothing
    set gg_trg_Boss_Hashmalum_Revive_Loop=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_Hashmalum_Revive_Loop)
    call TriggerRegisterUnitEvent(gg_trg_Boss_Hashmalum_Revive_Loop,gg_unit_E002_0075,EVENT_UNIT_DEATH)
    call TriggerAddAction(gg_trg_Boss_Hashmalum_Revive_Loop,function Trig_Boss_Hashmalum_Revive_Loop_Actions)
endfunction

function Register_Boss_Hashmalum_Death_Final takes nothing returns nothing
    set gg_trg_Boss_Hashmalum_Death_Final=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_Hashmalum_Death_Final)
    call TriggerRegisterUnitEvent(gg_trg_Boss_Hashmalum_Death_Final,gg_unit_E002_0075,EVENT_UNIT_DEATH)
    call TriggerAddAction(gg_trg_Boss_Hashmalum_Death_Final,function Trig_Boss_Hashmalum_Death_Final_Actions)
endfunction

function Register_Boss_Judges_Summon takes nothing returns nothing
    set gg_trg_Boss_Judges_Summon=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_Judges_Summon)
    call TriggerAddAction(gg_trg_Boss_Judges_Summon,function Trig_Boss_Judges_Summon_Actions)
endfunction

function Register_Boss_Judges_Ultimates takes nothing returns nothing
    set gg_trg_Boss_Judges_Ultimates=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_Judges_Ultimates)
    call TriggerAddAction(gg_trg_Boss_Judges_Ultimates,function Trig_Boss_Judges_Ultimates_Actions)
endfunction

function Register_Boss_Judges_Ghis_AI takes nothing returns nothing
    set gg_trg_Boss_Judges_Ghis_AI=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_Judges_Ghis_AI)
    call TriggerRegisterTimerExpireEventBJ(gg_trg_Boss_Judges_Ghis_AI,udg_JudgeTimer[1])
    call TriggerAddCondition(gg_trg_Boss_Judges_Ghis_AI,Condition(function Trig_Boss_Judges_Ghis_AI_Conditions))
    call TriggerAddAction(gg_trg_Boss_Judges_Ghis_AI,function Trig_Boss_Judges_Ghis_AI_Actions)
endfunction

function Register_Boss_Judges_Gabranth_AI takes nothing returns nothing
    set gg_trg_Boss_Judges_Gabranth_AI=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_Judges_Gabranth_AI)
    call TriggerRegisterTimerExpireEventBJ(gg_trg_Boss_Judges_Gabranth_AI,udg_JudgeTimer[2])
    call TriggerAddCondition(gg_trg_Boss_Judges_Gabranth_AI,Condition(function Trig_Boss_Judges_Gabranth_AI_Conditions))
    call TriggerAddAction(gg_trg_Boss_Judges_Gabranth_AI,function Trig_Boss_Judges_Gabranth_AI_Actions)
endfunction

function Register_Boss_Judges_Zargabaath_AI takes nothing returns nothing
    set gg_trg_Boss_Judges_Zargabaath_AI=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_Judges_Zargabaath_AI)
    call TriggerRegisterTimerExpireEventBJ(gg_trg_Boss_Judges_Zargabaath_AI,udg_JudgeTimer[3])
    call TriggerAddCondition(gg_trg_Boss_Judges_Zargabaath_AI,Condition(function Trig_Boss_Judges_Zargabaath_AI_Conditions))
    call TriggerAddAction(gg_trg_Boss_Judges_Zargabaath_AI,function Trig_Boss_Judges_Zargabaath_AI_Actions)
endfunction

function Register_Boss_Judges_Drace_AI takes nothing returns nothing
    set gg_trg_Boss_Judges_Drace_AI=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_Judges_Drace_AI)
    call TriggerRegisterTimerExpireEventBJ(gg_trg_Boss_Judges_Drace_AI,udg_JudgeTimer[4])
    call TriggerAddCondition(gg_trg_Boss_Judges_Drace_AI,Condition(function Trig_Boss_Judges_Drace_AI_Conditions))
    call TriggerAddAction(gg_trg_Boss_Judges_Drace_AI,function Trig_Boss_Judges_Drace_AI_Actions)
endfunction

function Register_Boss_Judges_Death takes nothing returns nothing
    set gg_trg_Boss_Judges_Death=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_Judges_Death)
    call TriggerAddCondition(gg_trg_Boss_Judges_Death,Condition(function Trig_Boss_Judges_Death_Conditions))
    call TriggerAddAction(gg_trg_Boss_Judges_Death,function Trig_Boss_Judges_Death_Actions)
endfunction

function Register_Boss_Judges_UseMegalixir takes nothing returns nothing
    set gg_trg_Boss_Judges_UseMegalixir=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_Judges_UseMegalixir)
    call TriggerAddCondition(gg_trg_Boss_Judges_UseMegalixir,Condition(function Trig_Boss_Judges_UseMegalixir_Conditions))
    call TriggerAddAction(gg_trg_Boss_Judges_UseMegalixir,function Trig_Boss_Judges_UseMegalixir_Actions)
endfunction

function Register_Boss_Judge_ImperialRage takes nothing returns nothing
    set gg_trg_Boss_Judge_ImperialRage=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Boss_Judge_ImperialRage,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Boss_Judge_ImperialRage,Condition(function Trig_Boss_Judge_ImperialRage_Conditions))
    call TriggerAddAction(gg_trg_Boss_Judge_ImperialRage,function Trig_Boss_Judge_ImperialRage_Actions)
endfunction

function Register_Boss_Judge_Sentence takes nothing returns nothing
    set gg_trg_Boss_Judge_Sentence=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Boss_Judge_Sentence,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Boss_Judge_Sentence,Condition(function Trig_Boss_Judge_Sentence_Conditions))
    call TriggerAddAction(gg_trg_Boss_Judge_Sentence,function Trig_Boss_Judge_Sentence_Actions)
endfunction

function Register_Boss_Judge_ChainMagick takes nothing returns nothing
    set gg_trg_Boss_Judge_ChainMagick=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Boss_Judge_ChainMagick,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Boss_Judge_ChainMagick,Condition(function Trig_Boss_Judge_ChainMagick_Conditions))
    call TriggerAddAction(gg_trg_Boss_Judge_ChainMagick,function Trig_Boss_Judge_ChainMagick_Actions)
endfunction

function Register_Boss_Judges_Cleanup takes nothing returns nothing
    set gg_trg_Boss_Judges_Cleanup=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_Judges_Cleanup)
    call TriggerAddAction(gg_trg_Boss_Judges_Cleanup,function Trig_Boss_Judges_Cleanup_Actions)
endfunction

function Register_Boss_Lilith_Death takes nothing returns nothing
    set gg_trg_Boss_Lilith_Death=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_Lilith_Death)
    call TriggerRegisterUnitEvent(gg_trg_Boss_Lilith_Death,gg_unit_e009_0118,EVENT_UNIT_DEATH)
    call TriggerAddAction(gg_trg_Boss_Lilith_Death,function Trig_Boss_Lilith_Death_Actions)
endfunction

function Register_Boss_Mateus_Intro takes nothing returns nothing
    set gg_trg_Boss_Mateus_Intro=CreateTrigger()
    call TriggerRegisterUnitInRangeSimple(gg_trg_Boss_Mateus_Intro,800.,gg_unit_U00L_0207)
    call TriggerRegisterUnitInRangeSimple(gg_trg_Boss_Mateus_Intro,800.,gg_unit_U00M_0206)
    call TriggerAddCondition(gg_trg_Boss_Mateus_Intro,Condition(function Trig_Boss_Mateus_Intro_Conditions))
    call TriggerAddAction(gg_trg_Boss_Mateus_Intro,function Trig_Boss_Mateus_Intro_Actions)
endfunction

function Register_Boss_Mateus_CoverSwap takes nothing returns nothing
    set gg_trg_Boss_Mateus_CoverSwap=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_Mateus_CoverSwap)
    call TriggerRegisterUnitEvent(gg_trg_Boss_Mateus_CoverSwap,gg_unit_U00L_0207,EVENT_UNIT_DAMAGED)
    call TriggerAddCondition(gg_trg_Boss_Mateus_CoverSwap,Condition(function Trig_Boss_Mateus_CoverSwap_Conditions))
    call TriggerAddAction(gg_trg_Boss_Mateus_CoverSwap,function Trig_Boss_Mateus_CoverSwap_Actions)
endfunction

function Register_Boss_Mateus_Death takes nothing returns nothing
    set gg_trg_Boss_Mateus_Death=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_Mateus_Death)
    call TriggerRegisterUnitEvent(gg_trg_Boss_Mateus_Death,gg_unit_U00L_0207,EVENT_UNIT_DEATH)
    call TriggerAddAction(gg_trg_Boss_Mateus_Death,function Trig_Boss_Mateus_Death_Actions)
endfunction

function Register_Boss_Mateus_Death_Final takes nothing returns nothing
    set gg_trg_Boss_Mateus_Death_Final=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_Mateus_Death_Final)
    call TriggerRegisterUnitEvent(gg_trg_Boss_Mateus_Death_Final,gg_unit_U00L_0207,EVENT_UNIT_DEATH)
    call TriggerAddAction(gg_trg_Boss_Mateus_Death_Final,function Trig_Boss_Mateus_Death_Final_Actions)
endfunction

function Register_Boss_Odin_Intro takes nothing returns nothing
    set gg_trg_Boss_Odin_Intro=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_Odin_Intro)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Boss_Odin_Intro,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Boss_Odin_Intro,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Boss_Odin_Intro,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Boss_Odin_Intro,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Boss_Odin_Intro,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Boss_Odin_Intro,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Boss_Odin_Intro,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Boss_Odin_Intro,Player(7),true)
    call TriggerAddCondition(gg_trg_Boss_Odin_Intro,Condition(function Trig_Boss_Odin_Intro_Conditions))
    call TriggerAddAction(gg_trg_Boss_Odin_Intro,function Trig_Boss_Odin_Intro_Actions)
endfunction

function Register_Boss_Odin_Escort_AI takes nothing returns nothing
    set gg_trg_Boss_Odin_Escort_AI=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_Odin_Escort_AI)
    call TriggerRegisterTimerEventPeriodic(gg_trg_Boss_Odin_Escort_AI,10.)
    call TriggerAddAction(gg_trg_Boss_Odin_Escort_AI,function Trig_Boss_Odin_Escort_AI_Actions)
endfunction

function Register_Boss_Odin_Death takes nothing returns nothing
    set gg_trg_Boss_Odin_Death=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_Odin_Death)
    call TriggerRegisterUnitEvent(gg_trg_Boss_Odin_Death,gg_unit_H01M_0071,EVENT_UNIT_DEATH)
    call TriggerAddAction(gg_trg_Boss_Odin_Death,function Trig_Boss_Odin_Death_Actions)
endfunction

function Register_Boss_OrcChieftain_Death takes nothing returns nothing
    set gg_trg_Boss_OrcChieftain_Death=CreateTrigger()
    call TriggerRegisterUnitEvent(gg_trg_Boss_OrcChieftain_Death,gg_unit_Opgh_0169,EVENT_UNIT_DEATH)
    call TriggerAddAction(gg_trg_Boss_OrcChieftain_Death,function Trig_Boss_OrcChieftain_Death_Actions)
endfunction

function Register_Boss_Ozma_Spawn takes nothing returns nothing
    set gg_trg_Boss_Ozma_Spawn=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_Ozma_Spawn)
    call TriggerAddAction(gg_trg_Boss_Ozma_Spawn,function Trig_Boss_Ozma_Spawn_Actions)
endfunction

function Register_Boss_Ozma_Barrier takes nothing returns nothing
    set gg_trg_Boss_Ozma_Barrier=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_Ozma_Barrier)
    call TriggerRegisterTimerEventPeriodic(gg_trg_Boss_Ozma_Barrier,1.)
    call TriggerAddAction(gg_trg_Boss_Ozma_Barrier,function Trig_Boss_Ozma_Barrier_Actions)
endfunction

function Register_Boss_Ozma_Death takes nothing returns nothing
    set gg_trg_Boss_Ozma_Death=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_Ozma_Death)
    call TriggerAddCondition(gg_trg_Boss_Ozma_Death,Condition(function Trig_Boss_Ozma_Death_Conditions))
    call TriggerAddAction(gg_trg_Boss_Ozma_Death,function Trig_Boss_Ozma_Death_Actions)
endfunction

function Register_Boss_Ozma_Cleanup takes nothing returns nothing
    set gg_trg_Boss_Ozma_Cleanup=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_Ozma_Cleanup)
    call TriggerAddAction(gg_trg_Boss_Ozma_Cleanup,function Trig_Boss_Ozma_Cleanup_Actions)
endfunction

function Register_Boss_Penance_Summon takes nothing returns nothing
    set gg_trg_Boss_Penance_Summon=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_Penance_Summon)
    call TriggerAddAction(gg_trg_Boss_Penance_Summon,function Trig_Boss_Penance_Summon_Actions)
endfunction

function Register_Boss_Penance_Judgment_Loop takes nothing returns nothing
    set gg_trg_Boss_Penance_Judgment_Loop=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_Penance_Judgment_Loop)
    call TriggerRegisterTimerEventPeriodic(gg_trg_Boss_Penance_Judgment_Loop,2)
    call TriggerAddCondition(gg_trg_Boss_Penance_Judgment_Loop,Condition(function Trig_Boss_Penance_Judgment_Loop_Conditions))
    call TriggerAddAction(gg_trg_Boss_Penance_Judgment_Loop,function Trig_Boss_Penance_Judgment_Loop_Actions)
endfunction

function Register_Boss_Penance_JudgmentDay_Cast takes nothing returns nothing
    set gg_trg_Boss_Penance_JudgmentDay_Cast=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Boss_Penance_JudgmentDay_Cast,EVENT_PLAYER_UNIT_SPELL_CAST)
    call TriggerAddCondition(gg_trg_Boss_Penance_JudgmentDay_Cast,Condition(function Trig_Boss_Penance_JudgmentDay_Cast_Conditions))
    call TriggerAddAction(gg_trg_Boss_Penance_JudgmentDay_Cast,function Trig_Boss_Penance_JudgmentDay_Cast_Actions)
endfunction

function Register_Boss_Penance_JudgmentDay_Damage takes nothing returns nothing
    set gg_trg_Boss_Penance_JudgmentDay_Damage=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Boss_Penance_JudgmentDay_Damage,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Boss_Penance_JudgmentDay_Damage,Condition(function Trig_Boss_Penance_JudgmentDay_Damage_Conditions))
    call TriggerAddAction(gg_trg_Boss_Penance_JudgmentDay_Damage,function Trig_Boss_Penance_JudgmentDay_Damage_Actions)
endfunction

function Register_Boss_Penance_Arm_Death takes nothing returns nothing
    set gg_trg_Boss_Penance_Arm_Death=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_Penance_Arm_Death)
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Boss_Penance_Arm_Death,EVENT_PLAYER_UNIT_DEATH)
    call TriggerAddCondition(gg_trg_Boss_Penance_Arm_Death,Condition(function Trig_Boss_Penance_Arm_Death_Conditions))
    call TriggerAddAction(gg_trg_Boss_Penance_Arm_Death,function Trig_Boss_Penance_Arm_Death_Actions)
endfunction

function Register_Boss_Penance_Death takes nothing returns nothing
    set gg_trg_Boss_Penance_Death=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_Penance_Death)
    call TriggerAddCondition(gg_trg_Boss_Penance_Death,Condition(function Trig_Boss_Penance_Death_Conditions))
    call TriggerAddAction(gg_trg_Boss_Penance_Death,function Trig_Boss_Penance_Death_Actions)
endfunction

function Register_Boss_Penance_Cleanup takes nothing returns nothing
    set gg_trg_Boss_Penance_Cleanup=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_Penance_Cleanup)
    call TriggerAddAction(gg_trg_Boss_Penance_Cleanup,function Trig_Boss_Penance_Cleanup_Actions)
endfunction

function Register_Boss_Shemhazai_Death takes nothing returns nothing
    set gg_trg_Boss_Shemhazai_Death=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_Shemhazai_Death)
    call TriggerRegisterUnitEvent(gg_trg_Boss_Shemhazai_Death,gg_unit_U00I_0210,EVENT_UNIT_DEATH)
    call TriggerAddAction(gg_trg_Boss_Shemhazai_Death,function Trig_Boss_Shemhazai_Death_Actions)
endfunction

function Register_Boss_Shinryu_Warmech_Summon takes nothing returns nothing
    set gg_trg_Boss_Shinryu_Warmech_Summon=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_Shinryu_Warmech_Summon)
    call TriggerAddAction(gg_trg_Boss_Shinryu_Warmech_Summon,function Trig_Boss_Shinryu_Warmech_Summon_Actions)
endfunction

function Register_Boss_Ultima_Death takes nothing returns nothing
    set gg_trg_Boss_Ultima_Death=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_Ultima_Death)
    call TriggerRegisterUnitEvent(gg_trg_Boss_Ultima_Death,gg_unit_U00F_0221,EVENT_UNIT_DEATH)
    call TriggerAddAction(gg_trg_Boss_Ultima_Death,function Trig_Boss_Ultima_Death_Actions)
endfunction

function Register_Boss_Yukale_Death_Revive takes nothing returns nothing
    set gg_trg_Boss_Yukale_Death_Revive=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_Yukale_Death_Revive)
    call TriggerRegisterUnitEvent(gg_trg_Boss_Yukale_Death_Revive,gg_unit_H00X_0133,EVENT_UNIT_DEATH)
    call TriggerAddAction(gg_trg_Boss_Yukale_Death_Revive,function Trig_Boss_Yukale_Death_Revive_Actions)
endfunction

function Register_Boss_Zalera_Intro takes nothing returns nothing
    set gg_trg_Boss_Zalera_Intro=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_Zalera_Intro)
    call TriggerRegisterUnitInRangeSimple(gg_trg_Boss_Zalera_Intro,200.,gg_unit_U000_0248)
    call TriggerRegisterUnitInRangeSimple(gg_trg_Boss_Zalera_Intro,500.,gg_unit_U000_0248)
    call TriggerRegisterUnitInRangeSimple(gg_trg_Boss_Zalera_Intro,700.,gg_unit_U000_0248)
    call TriggerAddCondition(gg_trg_Boss_Zalera_Intro,Condition(function Trig_Boss_Zalera_Intro_Conditions))
    call TriggerAddAction(gg_trg_Boss_Zalera_Intro,function Trig_Boss_Zalera_Intro_Actions)
endfunction

function Register_Boss_Zalera_Death takes nothing returns nothing
    set gg_trg_Boss_Zalera_Death=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_Zalera_Death)
    call TriggerRegisterUnitEvent(gg_trg_Boss_Zalera_Death,gg_unit_U000_0248,EVENT_UNIT_DEATH)
    call TriggerAddAction(gg_trg_Boss_Zalera_Death,function Trig_Boss_Zalera_Death_Actions)
endfunction

// Creates part 1 of 14 of this module's triggers. Called once at startup from
// Startup_RegisterTriggers (MapBootstrap). The parts are registered at different points so that
// triggers sharing an event with other modules keep their original firing order.
function RegisterTriggers_Boss_Part1 takes nothing returns nothing
    call Register_Boss_Gafgarion_Intro()
    call Register_Boss_Gafgarion_Death()
    call Register_Boss_Zalera_Intro()
    call Register_Boss_Gafgarion_Guard_Death()
    call Register_Boss_Zalera_Death()
endfunction

// Creates part 2 of 14 of this module's triggers. Called once at startup from
// Startup_RegisterTriggers (MapBootstrap). The parts are registered at different points so that
// triggers sharing an event with other modules keep their original firing order.
function RegisterTriggers_Boss_Part2 takes nothing returns nothing
    call Register_Boss_Chaos_Death()
endfunction

// Creates part 3 of 14 of this module's triggers. Called once at startup from
// Startup_RegisterTriggers (MapBootstrap). The parts are registered at different points so that
// triggers sharing an event with other modules keep their original firing order.
function RegisterTriggers_Boss_Part3 takes nothing returns nothing
    call Register_Boss_OrcChieftain_Death()
endfunction

// Creates part 4 of 14 of this module's triggers. Called once at startup from
// Startup_RegisterTriggers (MapBootstrap). The parts are registered at different points so that
// triggers sharing an event with other modules keep their original firing order.
function RegisterTriggers_Boss_Part4 takes nothing returns nothing
    call Register_Boss_Shemhazai_Death()
    call Register_Boss_Exodus_Death()
endfunction

// Creates part 5 of 14 of this module's triggers. Called once at startup from
// Startup_RegisterTriggers (MapBootstrap). The parts are registered at different points so that
// triggers sharing an event with other modules keep their original firing order.
function RegisterTriggers_Boss_Part5 takes nothing returns nothing
    call Register_Boss_Famfrit_Death()
    call Register_Boss_Ultima_Death()
    call Register_Boss_GodDragon_Death()
    call Register_Boss_Mateus_Intro()
    call Register_Boss_Mateus_CoverSwap()
    call Register_Boss_Demesne_CoverSwap()
endfunction

// Creates part 6 of 14 of this module's triggers. Called once at startup from
// Startup_RegisterTriggers (MapBootstrap). The parts are registered at different points so that
// triggers sharing an event with other modules keep their original firing order.
function RegisterTriggers_Boss_Part6 takes nothing returns nothing
    call Register_Boss_Demesne_Death_Revive()
    call Register_Boss_Demesne_Revived()
    call Register_Boss_Mateus_Death()
    call Register_Boss_Hashmalum_Intro()
    call Register_Boss_Hashmalum_Revive_Belias()
    call Register_Boss_Hashmalum_Revive_Loop()
    call Register_Boss_Belias_Rescue_Mateus()
    call Register_Boss_Belias_Revive_Loop()
    call Register_Boss_Mateus_Death_Final()
    call Register_Boss_Belias_Rescue_Gafgarion()
    call Register_Boss_Belias_Gafgarion_Death()
    call Register_Boss_Belias_Death_Final()
    call Register_Boss_Hashmalum_Death_Final()
endfunction

// Creates part 7 of 14 of this module's triggers. Called once at startup from
// Startup_RegisterTriggers (MapBootstrap). The parts are registered at different points so that
// triggers sharing an event with other modules keep their original firing order.
function RegisterTriggers_Boss_Part7 takes nothing returns nothing
    call Register_Boss_Echele_Start()
    call Register_Boss_Echele_SpawnForm()
    call Register_Boss_Echele_FormChange()
    call Register_Boss_Echele_KillMinions()
    call Register_Boss_Echele_Leash()
endfunction

// Creates part 8 of 14 of this module's triggers. Called once at startup from
// Startup_RegisterTriggers (MapBootstrap). The parts are registered at different points so that
// triggers sharing an event with other modules keep their original firing order.
function RegisterTriggers_Boss_Part8 takes nothing returns nothing
    call Register_Boss_Yukale_Death_Revive()
    call Register_Boss_DarkRanger_Death()
    call Register_Boss_Agrias_Intro()
endfunction

// Creates part 9 of 14 of this module's triggers. Called once at startup from
// Startup_RegisterTriggers (MapBootstrap). The parts are registered at different points so that
// triggers sharing an event with other modules keep their original firing order.
function RegisterTriggers_Boss_Part9 takes nothing returns nothing
    call Register_Boss_Agrias_Death_Lilith()
    call Register_Boss_Lilith_Death()
endfunction

// Creates part 10 of 14 of this module's triggers. Called once at startup from
// Startup_RegisterTriggers (MapBootstrap). The parts are registered at different points so that
// triggers sharing an event with other modules keep their original firing order.
function RegisterTriggers_Boss_Part10 takes nothing returns nothing
    call Register_Boss_Odin_Intro()
    call Register_Boss_Odin_Escort_AI()
    call Register_Boss_Odin_Death()
endfunction

// Creates part 11 of 14 of this module's triggers. Called once at startup from
// Startup_RegisterTriggers (MapBootstrap). The parts are registered at different points so that
// triggers sharing an event with other modules keep their original firing order.
function RegisterTriggers_Boss_Part11 takes nothing returns nothing
    call Register_Boss_Drop_TomeOfLife()
    call Register_Boss_Drop_CrushersMace()
    call Register_Boss_Drop_FurArmor()
    call Register_Boss_Penance_Summon()
    call Register_Boss_Penance_Judgment_Loop()
    call Register_Boss_Penance_JudgmentDay_Cast()
endfunction

// Creates part 12 of 14 of this module's triggers. Called once at startup from
// Startup_RegisterTriggers (MapBootstrap). The parts are registered at different points so that
// triggers sharing an event with other modules keep their original firing order.
function RegisterTriggers_Boss_Part12 takes nothing returns nothing
    call Register_Boss_Penance_JudgmentDay_Damage()
    call Register_Boss_Penance_Arm_Death()
    call Register_Boss_Penance_Death()
    call Register_Boss_Penance_Cleanup()
    call Register_Boss_Gilgamesh_Summon()
    call Register_Boss_Gilgamesh_NextSword()
    call Register_Boss_Gilgamesh_Death()
    call Register_Boss_Gilgamesh_Cleanup()
    call Register_Boss_Judges_Summon()
    call Register_Boss_Judges_Ultimates()
    call Register_Boss_Judges_Ghis_AI()
    call Register_Boss_Judges_Gabranth_AI()
    call Register_Boss_Judges_Zargabaath_AI()
    call Register_Boss_Judges_Drace_AI()
    call Register_Boss_Judges_Death()
    call Register_Boss_Judges_UseMegalixir()
    call Register_Boss_Judge_ImperialRage()
    call Register_Boss_Judge_Sentence()
    call Register_Boss_Judge_ChainMagick()
    call Register_Boss_Judges_Cleanup()
    call Register_Boss_BlackDevil_Summon()
    call Register_Boss_BlackDevil_Death()
    call Register_Boss_BlackDevil_Cleanup()
    call Register_Boss_DemiFiend_Summon()
    call Register_Boss_DemiFiend_Demon1_Death()
    call Register_Boss_DemiFiend_Demon2_Death()
    call Register_Boss_DemiFiend_Demon1_Spawn()
    call Register_Boss_DemiFiend_Demon2_Spawn()
    call Register_Boss_DemiFiend_Mediarahan()
    call Register_Boss_DemiFiend_Death()
    call Register_Boss_DemiFiend_Cleanup()
    call Register_Boss_DarkFact_Summon()
    call Register_Boss_DarkFact_Death()
    call Register_Boss_DarkFact_FactStrike()
endfunction

// Creates part 13 of 14 of this module's triggers. Called once at startup from
// Startup_RegisterTriggers (MapBootstrap). The parts are registered at different points so that
// triggers sharing an event with other modules keep their original firing order.
function RegisterTriggers_Boss_Part13 takes nothing returns nothing
    call Register_Boss_DarkFact_PingPong()
    call Register_Boss_DarkFact_Orb_Bounce()
    call Register_Boss_DarkFact_Orb_Attack()
    call Register_Boss_DarkFact_Cleanup()
    call Register_Boss_Shinryu_Warmech_Summon()
    call Register_Boss_Ozma_Spawn()
    call Register_Boss_Ozma_Barrier()
    call Register_Boss_Ozma_Death()
    call Register_Boss_Ozma_Cleanup()
endfunction

// Creates part 14 of 14 of this module's triggers. Called once at startup from
// Startup_RegisterTriggers (MapBootstrap). The parts are registered at different points so that
// triggers sharing an event with other modules keep their original firing order.
function RegisterTriggers_Boss_Part14 takes nothing returns nothing
    call Register_Boss_Defeat_Announce()
endfunction

endlibrary
