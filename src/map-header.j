// ==========================================================================================
// FINAL FANTASY EPIC RPG - developer guide (full docs: FFERPG/docs in the developer workspace)
//
// Trigger folders
//   01 Shared helpers        small utilities used everywhere: waits, groups, missiles, knockback
//   02 Map setup             world creation, pre-placed unit setup, Init_* startup triggers
//   03 Jobs and progression  jobs, job-change shrines, heroes, levels, legendary jobs
//   04 Combat and abilities  damage engine, spells, passives, bosses, summons, Gaya spirit
//   05 Items crafting shops  items, loot, armory, crafting, forge, materia, potions
//   06 Quests and story      quests, NPCs, story chapters, sieges, Kalm
//   07 Hunts and encounters  spawns, monster data, hunts, arena
//   08 World and travel      zones, teleports, gates, camera and cinematics, weather
//   09 Player features       chat commands, save/load codes, titles, chocobos, fishing, music
//   10 Startup coordinator   MapBootstrap: main_old, the startup sequence
//
// Conventions
//   * Each code module is a vJass library (T<Module>): keep JassHelper and vJass enabled.
//   * Trigger X: its code is Trig_X_* ; it is created by Register_X ; the module's
//     RegisterTriggers_* lists its triggers in startup order (called from MapBootstrap).
//   * A module's own variables are in the globals block at its top; shared ones are below.
//   * Object ids such as 'A0B3' carry a comment with the object's name.
//   * New triggers: just create them in World Editor (see docs/STARTUP.md for caveats).
//   * Long text (quest log help, etc.) belongs in GUI actions such as QuestLog_Entries: World
//     Editor keeps GUI text in the string table. Very long strings typed in custom script make
//     loading a saved game crash.
//   * Modules can be switched off (untick Enabled); run tools/disable_check.py first.
// ==========================================================================================
globals
    // ======================================================================================
    // Map-wide variables that several modules share.
    // * Most of them are in the Variable Editor (Ctrl+B), in the "Shared variables" folder of
    //   the Trigger Editor, so GUI triggers can use them. Code uses them with the udg_ prefix.
    // * The ones below stay here because World Editor cannot hold them the same way: groups,
    //   timers, forces, dialogs and hashtables (it would create them automatically), string
    //   arrays, constants and variables with a starting value.
    // * Variables used by only one module are declared at the top of that module, and trigger
    //   variables (gg_trg_*) live in the module that creates the trigger.
    // docs/GLOBALS.md lists every variable with where it is declared and who uses it.
    // ======================================================================================

    // ---- Shared by modules in "01 Shared helpers" ----
    boolexpr udg_KillTreeFilter // used by: Knock, Path

    // ---- Shared by modules in "04 Combat and abilities" ----
    hashtable udg_RunicHash=null // used by: Armor, Damage, Runic, Spell_Tables
    unit gg_unit_n08D_0001=null // used by: Damage, Summon_Lifecycle
    hashtable udg_MaxHpBuffHash=null // used by 6 modules
    hashtable udg_AbsorbShieldHash=null // used by: Damage, Spell_Tables, Vendetta
    boolexpr udg_TatsumakiFilter // used by: MapBootstrap, Spell_Tatsumaki, Tatsumaki
    group udg_BlizzagaGroup=CreateGroup() // used by: Blizzaga, Spell_Blizzaga
    unit array gg_unit_h020_0271 // used by: Shuriken, Spell_Shuriken
    group array udg_ShurikenHitGroupA // used by: Shuriken, Spell_Shuriken
    group array udg_ShurikenHitGroupB // used by: Shuriken, Spell_Shuriken
    group udg_ShurikenEnumGroup=CreateGroup() // used by: Shuriken, Spell_Shuriken
    unit array gg_unit_h020_0272 // used by: LiquidSteel, Spell_LiquidSteel
    unit array gg_unit_h020_0273 // used by: Boss_Verc, WickedWhirl
    group udg_WickedWhirlGroup=CreateGroup() // used by: Boss_Verc, WickedWhirl

    // ---- Shared by modules in "05 Items crafting and shops" ----
    string array udg_RecipeName // used by: Craft, Recipe
    destructable gg_dest_B001_0047=null // used by: Drop, MapBootstrap, Monograph
    destructable gg_dest_B001_0048=null // used by: Drop, MapBootstrap, Monograph
    destructable gg_dest_B001_0049=null // used by: Drop, MapBootstrap, Monograph
    destructable gg_dest_B001_0050=null // used by: Drop, MapBootstrap, Monograph
    destructable gg_dest_B001_0051=null // used by: Drop, MapBootstrap, Monograph
    destructable gg_dest_B001_0053=null // used by: Drop, MapBootstrap, Monograph
    destructable gg_dest_B001_0054=null // used by: Drop, MapBootstrap, Monograph
    destructable gg_dest_B001_0055=null // used by: Drop, MapBootstrap, Monograph
    destructable gg_dest_B001_0056=null // used by: Drop, MapBootstrap, Monograph
    destructable gg_dest_B001_0057=null // used by: Drop, MapBootstrap, Monograph

    // ---- Shared by modules in "06 Quests and story" ----
    integer udg_TravelPointIndex=9 // used by: IcyRealm, Quest_ScorchingTravel
    timerdialog udg_EdenTimerDialog=null // used by: Eden, Quest_StrongestEidolon
    timerdialog udg_SiegeTimerWindow=null // used by: KalmSiege1, KalmSiege2, KalmSiege3
    string udg_QuestTitleRed="|cffff0000" // used by: AlmightyShinra, Judgment, Quest_ScorchedEarth, TrueIceAge
    sound gg_snd_JainaWhat=null // used by: MapBootstrap, MithrilGolem, Quest_FireGolem
    sound gg_snd_UtherTaunt2=null // used by: Cid, KalmSiege3, MapBootstrap

    // ---- Shared by modules in "08 World and travel" ----
    region array udg_TravelRegion // used by: Travel, Warp

    // ---- Shared by modules in "09 Player features" ----
    constant string udg_AllowLocalFilesPath=".\\FFERPG\\"+"Allow Local Files"+".txt" // used by: Load, Save
    hashtable udg_CodeCharIndex // used by: Cmd, Save
    timerdialog udg_VoteTimerDialog=null // used by: Game, Vote
    string udg_AbilityNameMarker="!" // used by: AbilityText, BattleLog
    string array udg_MusicPathPrefix // used by: Cmd, Music
    string array udg_MusicBlizzTrack // used by: Cmd, Music
    string array udg_MusicCustomTrack // used by: Cmd, Music

    // ---- Shared across folders, mostly by "01 Shared helpers" ----
    string array udg_SaveCodeChunk // used by: Code, Save
    string array udg_CodeFormat // used by: Code, Save
    string array udg_CodeFormatRead // used by: Cmd, Code
    attacktype array udg_MissileAttackType // used by: Missile, Spell_HolyBlast
    string array udg_MissileHitEffect // used by: Missile, Spell_Cure
    group array udg_MissileHitGroup // used by: Missile, Spell_HolyBlast
    group udg_EnumGroup=null // used by: Ending, Group
    boolexpr udg_FilterTrue=null // used by: Ending, Group, MapBootstrap, Stock

    // ---- Shared across folders, mostly by "02 Map setup" ----
    timer udg_KalmSiegeTimer=null // used by: Boss_Zalera, Celeborn, Init, MapBootstrap
    group udg_HideoutGuards=null // used by: Init, MapBootstrap, Melaniya, Quest_GreedIsGood
    string array udg_NewsTitle // used by: Init, MapBootstrap, News
    string array udg_NewsEntry // used by: Init, MapBootstrap, News
    string array udg_CurseHintLine // used by: Init, MapBootstrap, MysteriousCurse
    group udg_ArenaNpcGroup=null // used by: Arena_Presentation, Init, MapBootstrap
    group udg_JudgeGroup=null // used by: Boss_Judges, Init, MapBootstrap
    group udg_NpcTrioGroup=null // used by: Init, MapBootstrap, NpcTrio
    group udg_GnollCampUnits=null // used by: Init, MapBootstrap, Quest_SaveTimmy
    string array udg_SpeciesName // used by: Gaya_Scan, Init, MapBootstrap, Oversoul
    force udg_ShadowLevelPool=null // used by: Init, MapBootstrap, Shadow_Hiring
    string array udg_VoteOptionText // used by: Init, MapBootstrap, Quest_Log, Vote
    timer udg_WorldEventTimer=null // used by: ExcaliburII, Game, Init, MapBootstrap
    group udg_PrayingUnits=null // used by: Init, MapBootstrap, Prophet
    timer array udg_RangedShotTimer // used by 5 modules
    timer udg_NaishaHealTimer=null // used by: Init, MapBootstrap, Naisha
    group udg_GhoulGroup=null // used by: Ghoul, Init, MapBootstrap
    group udg_BerserkGuards=null // used by: BerserkGuard, Cid, Init, MapBootstrap
    group udg_PenanceArms=null // used by: Boss_Penance, Init, MapBootstrap
    group udg_FarmWorkingVillagers=null // used by: Init, MapBootstrap, Quest_SaveTimmy
    group udg_FarmGatheredVillagers=null // used by: Init, MapBootstrap, Quest_SaveTimmy
    timer udg_EnchantCycleTimer=null // used by: Geomancer, Init, MapBootstrap
    group udg_SplashGroup=null // used by: Damage, Init, MapBootstrap
    timer udg_SplashTimer=null // used by: Damage, Init, MapBootstrap
    timer udg_CowSpawnTimer=null // used by: CowPortal, Init, MapBootstrap
    group udg_CowGroup=null // used by: CowPortal, Init, MapBootstrap
    force udg_LuShangPending=null // used by: Boss_Gilgamesh, Gilgamesh, Init, MapBootstrap
    force udg_EliminatedPlayers=null // used by: Ending, Hero_Death, Init, MapBootstrap
    group udg_LivingFlameUnits=null // used by: Hero_Death, Init, MapBootstrap, Spell_LivingFlame
    group udg_DrainChannelGroup=null // used by: Init, MapBootstrap, Necro
    timer udg_DeathExplodeTimer=null // used by: Death, Init, MapBootstrap
    group udg_DuelArenaUnits=null // used by: Init, MapBootstrap, Summon_Items
    group udg_VortexVictims=null // used by: Init, MapBootstrap, Vortex
    timer udg_VortexTimer=null // used by: Init, MapBootstrap, Vortex
    string array udg_DiaryEntry // used by: Init, MapBootstrap, NameDiary
    group udg_TargetPracticeDummies=null // used by: Init, MapBootstrap, TargetPractice
    group udg_TargetsRemaining=null // used by: Init, MapBootstrap, TargetPractice
    timer udg_TargetPracticeTimer=null // used by: Init, MapBootstrap, TargetPractice
    group udg_SeekerLeaders=null // used by: Init, MapBootstrap, Quest_SeekDestroy, Seekers
    group udg_FestivalHunters=null // used by: HuntFestival, Init, MapBootstrap
    timer udg_FestivalTimer=null // used by: HuntFestival, Init, MapBootstrap
    string array udg_TargetRecordName // used by: Init, MapBootstrap, TargetPractice
    timer udg_SpiritSpawnTimer=null // used by: Init, MapBootstrap, Player, Spirit
    group array udg_NecroCorpseGroup // used by: Init, MapBootstrap, Necro
    group udg_DarkFactMinions=null // used by: Boss_DarkFact, Init, MapBootstrap
    timer udg_GagnrathTimer=null // used by: Init, MapBootstrap, Valfodr
    group udg_GagnrathCasters=null // used by: Init, MapBootstrap, Valfodr
    timer udg_SharedDelayTimer6=null // used by: Ending, Init, MapBootstrap
    timer udg_JobChangeTimer=null // used by: Cloak, Init, Job, MapBootstrap
    group udg_MeteoriteRocks=null // used by: Cometeorite, Exodus, Init, MapBootstrap
    timer udg_ReviveCleanupTimer=null // used by: Hero_Death, Init, MapBootstrap, Revive
    group udg_RevivedHeroes=null // used by: Hero_Death, Init, MapBootstrap, Revive
    timer udg_DpsTimer=null // used by: Dps, Init, MapBootstrap
    group udg_BagOfTricksTargets=null // used by: BagOfTricks, Init, MapBootstrap
    group udg_MephorashClones=null // used by: Init, MapBootstrap, Mephorash
    timer udg_BazaarUpdateTimer=null // used by: Bazaar, Init, MapBootstrap
    group udg_RengekiGroup=null // used by: Damage, Init, MapBootstrap
    group udg_UndyingGroup=null // used by: Damage, Init, MapBootstrap
    group udg_OblivionDummyGroup=null // used by: Init, MapBootstrap, Oblivion
    timer udg_FafnirPatrolTimer=null // used by: Fafnir, Init, MapBootstrap
    group udg_HarpyTricksters=null // used by: Harpy, Init, MapBootstrap, Quest_FieryWings
    force udg_BattleLogForce=null // used by: BattleLog, Init, MapBootstrap
    group udg_NeutralPassiveUnits=null // used by: Init, MapBootstrap, Rabite
    group udg_RabiteAreaUnits=null // used by: Init, MapBootstrap, Rabite
    timer udg_MomentumTimer=null // used by: Init, MapBootstrap, Momentum
    timer array udg_DodgeSaveTimer // used by: Damage, Hero_Order, Init, MapBootstrap
    timer udg_ShrineReselectTimer=null // used by: Init, MapBootstrap, Shrine
    timer udg_AccoladeTimer=null // used by: Init, MapBootstrap, Speedrun
    timer udg_ForgeTextTimer=null // used by: Forge, Init, MapBootstrap
    timer udg_LokiForgeTextTimer=null // used by: Init, Loki, MapBootstrap
    group udg_ValigarmandaMinions=null // used by: Init, MapBootstrap, Valigarmanda
    timer udg_ValigarmandaWaveTimer=null // used by: Init, MapBootstrap, Valigarmanda
    group udg_HuntBoardMarked=null // used by: Hunt_Board, Init, MapBootstrap
    force array udg_NullElementForce // used by: Damage, Elysium, Init, MapBootstrap
    timer udg_StunReapplyTimer=null // used by: Damage, Init, MapBootstrap
    force array udg_WeakElementForce // used by: Damage, Elysium, Init, MapBootstrap
    group udg_FrozenUnits=null // used by: Ending, Init, MapBootstrap
    group udg_WorldUnits=null // used by: Ending, Init, MapBootstrap
    timer array udg_AxeChargeTimer // used by: Damage, Init, MapBootstrap
    group udg_BurningBuildings=null // used by: Ending, Init, MapBootstrap
    timer udg_GeomancerAwardTimer=null // used by: Damage, Init, MapBootstrap
    timer array udg_ArmorBreakerTimer // used by: Armor, Init, MapBootstrap
    timer array udg_SleepWakeTimer // used by: Damage, Init, MapBootstrap
    force array udg_EidolonAwardForce // used by: Damage, Init, MapBootstrap
    timer udg_ElementRecordTimer=null // used by: Damage, Elemental, Init, MapBootstrap
    timer array udg_ExpBankTimer // used by: Exp, Firefly, Init, MapBootstrap
    timer array udg_NinjaImmortalTimer // used by: Debug, Init, MapBootstrap, Ninja
    timer array udg_LastCritTimer // used by: Damage, Init, MapBootstrap
    timer udg_VisionShareTimer=null // used by: Damage, Init, MapBootstrap

    // ---- Shared across folders, mostly by "03 Jobs and progression" ----
    hashtable udg_JobHeroHash // used by: Cmd, Job, JobHero
    hashtable udg_JobLevelHash // used by: Cmd, Job, JobHero
    force udg_TempForce=null // used by 102 modules
    string array udg_JobName // used by 24 modules
    hashtable udg_ChannelDrainHash=null // used by: Necro, Spell_Tables
    hashtable udg_DivineShieldHash=null // used by: Damage, Job, Prophet, Spell_Tables
    string array udg_EffectModelPath // used by 5 modules
    group udg_RegenGroup=null // used by 7 modules
    force udg_CheaterForce=null // used by 11 modules
    group array udg_BonusGroup // used by 5 modules
    group udg_SecondShrineUnits=null // used by 6 modules
    timer udg_UnitUpdateTimer=null // used by 29 modules
    timer udg_ComboTimer=null // used by: Exp, Init, MapBootstrap, Samurai

    // ---- Shared across folders, mostly by "04 Combat and abilities" ----
    group udg_TempGroup=null // used by 77 modules
    string udg_QuestTitleColor="|cffff8040" // used by: Boss_Hashmalum, Boss_Zalera, Quest_ZodiacAge
    timer array udg_JudgeTimer // used by: Boss, Boss_Judges, Init, MapBootstrap
    group udg_BossGroup=null // used by 56 modules
    hashtable udg_ProxyDamageHash=null // used by 59 modules
    group udg_PendingEffectGroup=null // used by 11 modules
    group udg_ImmolationAuraGroup=null // used by 8 modules
    timer udg_DemiFiendDemon1Timer=null // used by: Boss, Boss_DemiFiend, Init, MapBootstrap
    timer udg_DemiFiendDemon2Timer=null // used by: Boss, Boss_DemiFiend, Init, MapBootstrap
    timer array udg_DodgeFaceTimer // used by 6 modules
    timer udg_GayaRageTimer=null // used by: Init, MapBootstrap, Spell, Spell_GayaRage
    timer udg_JobLevelTimer=null // used by 10 modules
    group udg_BerserkGroup=null // used by 7 modules
    timer udg_MaxHpDrainTimer=null // used by: Damage, Init, MapBootstrap, MaxHp
    group udg_VirusImmuneGroup=null // used by 5 modules
    force udg_AbilityTextForce=null // used by 16 modules
    hashtable udg_LinkedCasterHash=null // used by: Damage, Link, Spell_Tables
    group udg_DarkEidolonGroup=null // used by 11 modules
    group udg_DeathExplodeGroup=null // used by: Death, Init, MapBootstrap, Spell_Satellite
    hashtable udg_HealOverTimeHash=null // used by 6 modules
    timer udg_LoadRefreshTimer=null // used by 7 modules
    hashtable udg_MonsterDataHash=null // used by 7 modules
    group udg_ChaosElementalGroup=null // used by 6 modules
    timer udg_ShiftElementsTimer=null // used by 5 modules
    group udg_PenanceUnits=null // used by: Boss_Penance, Damage, Init, MapBootstrap
    group udg_MirrorCloneGroup=null // used by 5 modules
    group udg_AbsorbShieldGroup=null // used by: Damage, Init, MapBootstrap, Vendetta
    string array udg_LoreText // used by: Info, Init, Maechen, MapBootstrap
    timer udg_EcheleMinionKillTimer=null // used by 6 modules
    hashtable udg_DpsHash=null // used by: Damage, Dps, Multiboard
    hashtable udg_ComboHash=null // used by: Combo, Damage, Samurai
    timer udg_ManaRefundTimer=null // used by: Init, Mana, ManaRefund, MapBootstrap
    force udg_DuelArenaPlayers=null // used by 14 modules
    force array udg_JobMasterForce // used by 19 modules
    hashtable udg_MolotovHash=null // used by 5 modules
    group udg_DarkServants=null // used by: DarkServant, GatherServants, Init, MapBootstrap
    group udg_GoliathTonicGroup=null // used by 5 modules
    force array udg_QuestForce // used by 12 modules
    group udg_DefendingUnits=null // used by: Damage, Defend, Init, MapBootstrap
    group udg_RunicGroup=null // used by: Death, Init, MapBootstrap, Runic
    timer udg_StatsRefreshTimer=null // used by 5 modules
    group udg_ActiveHeroGroup=null // used by 11 modules
    timer udg_HeroRefreshTimer=null // used by 11 modules
    group udg_EnduranceAwardGroup=null // used by: Damage, HolyPower, Init, MapBootstrap

    // ---- Shared across folders, mostly by "05 Items crafting and shops" ----
    hashtable udg_DropItemHash=null // used by: Item_Shared, Loot, MonsterData, Oversoul
    timer array udg_SpellCooldownTimer // used by 6 modules

    // ---- Shared across folders, mostly by "06 Quests and story" ----
    hashtable udg_SpawnRectHash=InitHashtable() // used by: Ending, Zone
    hashtable udg_SpawnDataHash=InitHashtable() // used by: Ending, Spawn, Zeromus, Zone
    string array udg_TravelName // used by: IcyRealm, Quest_ScorchingTravel, Travel
    force udg_PlayingPlayers=null // used by 250 modules
    leaderboard udg_HuntLeaderboard=null // used by 15 modules
    timer udg_CidResearchTimer=null // used by 6 modules
    timer udg_SharedDelayTimer1=null // used by 7 modules
    string udg_QuestNamePrefix="|cff00ffff" // used by 55 modules
    timer udg_EdenTimer=null // used by: Eden, Init, MapBootstrap, Quest_StrongestEidolon
    string array udg_NewsText // used by 20 modules
    hashtable udg_SpawnRectHashRef=null // used by 21 modules
    hashtable udg_SpawnDataHashRef=null // used by 21 modules
    timer udg_SharedDelayTimer2=null // used by 5 modules
    hashtable udg_GameStateHash=null // used by 50 modules
    timer udg_SharedDelayTimer3=null // used by: AlmightyShinra, Ending, Init, MapBootstrap
    timer udg_StoryEventTimer=null // used by 5 modules
    timer udg_SharedDelayTimer4=null // used by 6 modules
    force udg_ActivePlayers=null // used by 40 modules
    timer udg_ShadowTimer=null // used by 6 modules
    timer udg_BlueGirlTimer=null // used by: Bernkastel, Ending, Init, MapBootstrap
    timer udg_GafgarionReviveTimer=null // used by: Gafgarion, IceAge, Init, MapBootstrap
    group udg_KalmGuards=null // used by 5 modules
    group udg_FarmCorpses=null // used by 5 modules
    group udg_QuestNpcUnits=null // used by 7 modules
    playercolor array udg_ZoneColor // used by: Boss_Ozma, Elemental, IcyRealm, Quest_ScorchingTravel
    timer udg_NebraKingTimer=null // used by: Init, MapBootstrap, NebraKing, Quest_KingOfSea
    group udg_BossUnits=null // used by 99 modules
    group udg_QuestUnits=null // used by 26 modules
    group udg_HuntMonsters=null // used by 8 modules
    string udg_ColorGold="|cffffcc00" // used by 11 modules
    timer udg_SiegeTimer=null // used by 7 modules
    group udg_AllyBrothersGroup=null // used by 8 modules
    group udg_AllyRangerGroup=null // used by 11 modules
    group udg_SpecialUnits=null // used by 9 modules
    group udg_InactiveUnits=null // used by 8 modules
    group udg_RecruitedAllies=null // used by 16 modules
    group udg_ShockAuraUnitGroup=null // used by 9 modules
    group udg_PrimaryQuestUnits=null // used by: Ending, Init, MapBootstrap, QuestUnits
    group udg_SiegeSummonGroup=null // used by 5 modules
    group udg_SummonedUnits=null // used by 8 modules
    timer udg_ScorchedEarthTimer=null // used by: Init, MapBootstrap, Quest_BlazingDemon, ScorchedEarth
    timer udg_PostReviveTimer=null // used by 6 modules
    group udg_AllyEngineerGroup=null // used by 6 modules
    group udg_TentacleGroup=null // used by 6 modules
    timer udg_TentacleTimer=null // used by: Init, MapBootstrap, Monstrum, Tentacles
    group udg_RedBeastGroup=null // used by 5 modules
    leaderboard udg_HuntFestivalBoard=null // used by: Ending, HuntFestival
    timer udg_AlmaDisappearTimer=null // used by 5 modules
    force array udg_TitleForce // used by 46 modules
    group udg_ShemhazaiSoulClones=null // used by: Init, MapBootstrap, Shemhazai, TrueIceAge
    timer udg_TimmyQuestTimer=null // used by 5 modules
    timer udg_WorldFreezeTimer=null // used by 6 modules
    timerdialog udg_WorldFreezeDialog=null // used by: Boss_Echele, IceAge, TrueIceAge
    string array udg_HuntBoardLabel // used by 13 modules
    group udg_BossSummons=null // used by 9 modules
    group udg_EcheleMinionsToKill=null // used by 5 modules
    timer udg_AishaTalkTimer=null // used by: Aisha, Init, MapBootstrap, TargetPractice
    timer udg_LiberationRewardTimer=null // used by: Init, MapBootstrap, Quest, Quest_WorldLiberation
    group udg_DarkEidolonIllusions=null // used by: DarkEidolons, Ending, Init, MapBootstrap
    string array udg_PlayerName // used by 45 modules
    group udg_EscortUnits=null // used by 8 modules
    group udg_TownTargetGroup=null // used by 6 modules
    group udg_DarkShopGroup=null // used by 5 modules
    timer array udg_HerbRespawnTimer // used by 6 modules
    timer udg_SharedDelayTimer5=null // used by 9 modules
    timer udg_ShortDelayTimer=null // used by 5 modules
    timer udg_StoryDelayTimer=null // used by 6 modules

    // ---- Shared across folders, mostly by "07 Hunts and encounters" ----
    hashtable udg_SpawnTimerHash=InitHashtable() // used by: Spawn, Zone
    group udg_ArenaSpawnGroup=null // used by 6 modules
    group udg_CupArenaUnits=null // used by 10 modules
    timer udg_ArenaLockTimer=null // used by: Arena, Arena_BattleSetup, Init, MapBootstrap
    force udg_CupArenaPlayers=null // used by 11 modules
    group udg_ArenaSummonGroup=null // used by 7 modules
    group udg_ArenaBoundUnits=null // used by 5 modules
    hashtable udg_HuntData=null // used by: HuntFestival, Hunt_Board, Hunt_Contracts, Quest_ScorchedEarth
    force udg_HuntSlots=null // used by 5 modules
    timer udg_ArenaRoundTimer=null // used by 5 modules
    timer udg_ArenaCheckTimer=null // used by: Arena, Arena_Access, Init, MapBootstrap
    timer udg_DragonBattleTimer=null // used by 6 modules
    timer udg_ArenaSpawnTimer=null // used by 5 modules

    // ---- Shared across folders, mostly by "08 World and travel" ----
    dialog udg_WarpDialog=DialogCreate() // used by: Hero_Death, Quest_ScorchingTravel, Travel, Warp
    timer udg_GameClock=null // used by 7 modules

    // ---- Shared across folders, mostly by "09 Player features" ----
    string array udg_PlayerColorCode // used by: AbilityText, BattleLog, Init, MapBootstrap
    timer udg_VoteTimer=null // used by: GameMode, Init, MapBootstrap, Vote
    dialog udg_VoteDialog=null // used by 5 modules
    timer array udg_FishingTimer // used by 13 modules
    force udg_AutosaveForce=null // used by 5 modules
    force udg_TrackedPlayers=null // used by 5 modules
    group udg_TownNpcUnits=null // used by 7 modules
    string array udg_BonusText // used by 5 modules
    string array udg_TitleName // used by: Init, MapBootstrap, Title, Titles
    force array udg_SaveFlagForce // used by 7 modules
    group udg_FishingSpots=null // used by 5 modules
    force udg_LegendaryGuardianForce=null // used by 6 modules
    hashtable udg_ItemSaveID // used by: Armory, Save, Title
    string array udg_SaveCodePlain // used by: Cmd, Code, Save

    // ---- Script-created world objects (destructables, sounds, units) used by several modules ----
    sound gg_snd_SargerasLaugh=null // used by: MagicUrn, MapBootstrap, McBurn, ScorchedEarth
    sound gg_snd_002=null // used by: Gilgamesh, Hero_LevelUp, MapBootstrap
    sound gg_snd_003=null // used by: Hero_LevelUp, MapBootstrap, Spring
    sound gg_snd_HornOfCenariusSound=null // used by: Boss_Zalera, KalmSiege2, MapBootstrap
    destructable gg_dest_LTcr_0002=null // used by: Drop, Firefly, MapBootstrap
    destructable gg_dest_LTcr_0003=null // used by: Drop, Firefly, MapBootstrap
    destructable gg_dest_LTbx_0004=null // used by: Drop, Firefly, MapBootstrap
    destructable gg_dest_LTg4_0005=null // used by 5 modules
    destructable gg_dest_LTbs_0006=null // used by: Drop, Firefly, MapBootstrap
    destructable gg_dest_LTlt_0007=null // used by: Drop, Lumber, MapBootstrap
    destructable gg_dest_LTbx_0008=null // used by: Drop, Firefly, MapBootstrap
    destructable gg_dest_LTbr_0009=null // used by: Drop, Firefly, MapBootstrap
    destructable gg_dest_LOcg_0010=null // used by 5 modules
    destructable gg_dest_BTrx_0011=null // used by 5 modules
    destructable gg_dest_ATg3_0012=null // used by: Drop, Init, MapBootstrap, Tonberry
    destructable gg_dest_DTg7_0013=null // used by 5 modules
    destructable gg_dest_LTt1_0014=null // used by: Drop, Init, MapBootstrap
    destructable gg_dest_LTbx_0015=null // used by: Drop, Firefly, MapBootstrap
    destructable gg_dest_Dofw_0016=null // used by: Drop, MapBootstrap, Tonberry
    destructable gg_dest_LTbx_0017=null // used by: Drop, Firefly, MapBootstrap
    destructable gg_dest_ITtw_0018=null // used by: Drop, MapBootstrap, OakaIV
    destructable gg_dest_LTcr_0019=null // used by 5 modules
    destructable gg_dest_LTe2_0020=null // used by 5 modules
    destructable gg_dest_LTg2_0021=null // used by 6 modules
    destructable gg_dest_ITx1_0022=null // used by: Barrens, Drop, MapBootstrap, Quest_DwarfDisappearance
    destructable gg_dest_LTbs_0023=null // used by: Drop, IceCache, MapBootstrap
    destructable gg_dest_LOcg_0024=null // used by: Drop, MapBootstrap, Quest, Quest_SaveTimmy
    destructable gg_dest_ZTsg_0025=null // used by 8 modules
    destructable gg_dest_B002_0026=null // used by: Drop, HauntedTree, MapBootstrap, OakaIV
    destructable gg_dest_LTcr_0027=null // used by: Drop, IceCache, MapBootstrap
    destructable gg_dest_DTg8_0028=null // used by: Drop, Init, MapBootstrap, OrcBase
    destructable gg_dest_LOcg_0029=null // used by 5 modules
    destructable gg_dest_ITig_0030=null // used by: Drop, Init, MapBootstrap
    destructable gg_dest_LOcg_0031=null // used by 5 modules
    destructable gg_dest_LOcg_0032=null // used by 5 modules
    destructable gg_dest_ITx3_0033=null // used by: Barrens, Drop, MapBootstrap, Quest_DwarfDisappearance
    destructable gg_dest_ITtw_0034=null // used by: Drop, MapBootstrap, OakaIV
    destructable gg_dest_ITtw_0035=null // used by: Drop, MapBootstrap, OakaIV
    destructable gg_dest_ITtw_0036=null // used by: Drop, MapBootstrap, OakaIV
    destructable gg_dest_ITtw_0037=null // used by: Drop, MapBootstrap, OakaIV
    destructable gg_dest_LTbx_0038=null // used by: Drop, HauntedTree, IceCache, MapBootstrap
    destructable gg_dest_ITtw_0039=null // used by: Drop, MapBootstrap, OakaIV
    destructable gg_dest_B002_0040=null // used by: Drop, HauntedTree, MapBootstrap, OakaIV
    destructable gg_dest_ITtw_0041=null // used by: Drop, MapBootstrap, OakaIV
    destructable gg_dest_LOcg_0042=null // used by 5 modules
    destructable gg_dest_ITtw_0043=null // used by: Drop, MapBootstrap, OakaIV
    destructable gg_dest_LTba_0044=null // used by: Drop, IceCache, MapBootstrap
    destructable gg_dest_LTba_0045=null // used by: Drop, IceCache, MapBootstrap
    destructable gg_dest_LTbs_0046=null // used by: Drop, IceCache, MapBootstrap
    destructable gg_dest_DTg6_0052=null // used by: Drop, Init, MapBootstrap, Quest_SaveTimmy
    destructable gg_dest_LTcr_0058=null // used by: Drop, Fishing_Setup, MapBootstrap
    destructable gg_dest_ITtw_0059=null // used by: Drop, MapBootstrap, OakaIV
    destructable gg_dest_LTbs_0060=null // used by: Drop, Firefly, MapBootstrap
    destructable gg_dest_LTcr_0061=null // used by: Drop, Firefly, MapBootstrap
    destructable gg_dest_LTcr_0062=null // used by: Drop, Firefly, MapBootstrap
    destructable gg_dest_LTbs_0063=null // used by: Drop, Firefly, MapBootstrap
    destructable gg_dest_LTcr_0064=null // used by: Drop, Firefly, MapBootstrap
    destructable gg_dest_LTcr_0065=null // used by: Drop, Firefly, MapBootstrap
    destructable gg_dest_LTcr_0066=null // used by: Drop, Firefly, MapBootstrap
    destructable gg_dest_LTcr_0067=null // used by: Drop, Firefly, MapBootstrap
    destructable gg_dest_DTsb_0068=null // used by: Andre, Drop, Elysium, MapBootstrap
    destructable gg_dest_LOcg_0069=null // used by: Barrens, Drop, MapBootstrap, Valigarmanda
    destructable gg_dest_LOcg_0070=null // used by 5 modules
    destructable gg_dest_LOcg_0071=null // used by 5 modules
    unit array gg_unit_h020_0269 // used by: Missile, Spell_HolyBlast
endglobals