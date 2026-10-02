globals
    // ======================================================================================
    // Map-wide variables that several modules share.
    // Variables used by only one module are declared at the top of that module instead,
    // and trigger variables (gg_trg_*) live in the module that creates the trigger.
    // docs/GLOBALS.md lists every variable with where it is declared and who uses it.
    // ======================================================================================

    // ---- Shared by modules in "01 Shared helpers" ----
    boolexpr udg_KillTreeFilter // used by: Knock, Path
    trigger udg_KnockRemoveTrig // used by: Knock, Wrap
    trigger udg_MissileCollisionTrig // used by: Missile, Wrap
    trigger udg_MissileDamageTrig // used by: Missile, Wrap
    trigger udg_MissileImpactTrig // used by: Missile, Wrap

    // ---- Shared by modules in "03 Jobs and progression" ----
    string udg_JobRequirementText="" // used by: Job, Research
    unit array udg_ShrineMenuUnit // used by: DarkJobs, Legendary, Shrine
    integer array udg_MasteryBonusAbility // used by: Job, Shrine
    integer udg_ComboCount=0 // used by: Exp, Samurai
    unit udg_ComboUnit=null // used by: Exp, Samurai
    boolean udg_ComboAwarded=false // used by: Exp, Samurai

    // ---- Shared by modules in "04 Combat and abilities" ----
    integer array udg_ElementOpposite // used by: Damage, Element
    integer array udg_ElementWeaknessAbil // used by: Damage, Element
    integer array udg_ElementResistAbil // used by: Damage, Element
    integer array udg_ElementImmunityAbil // used by: Damage, Element
    integer array udg_ElementAbsorbAbil // used by: Damage, Element
    integer array udg_ElementAttackAbil // used by: Damage, Element
    integer array udg_ElementKnowledgeAbil // used by: Damage, Element
    integer array udg_ElementBoostAbil // used by: Damage, Element
    integer array udg_ElementSpellAmpAbil // used by: Damage, Element
    integer array udg_ElementOrbAmpAbil // used by: Damage, Element
    integer array udg_ElementEnchantBuff // used by: Damage, Element
    integer array udg_ElementAilmentBuff // used by: Damage, Element
    integer array udg_ElementAilmentBuff2 // used by: Damage, Element
    integer udg_AllianceTargetSlot=0 // used by: Peace, War
    hashtable udg_RunicHash=null // used by: Armor, Damage, Runic, Spell_Tables
    unit gg_unit_n08D_0001=null // used by: Damage, Summon_Lifecycle
    integer array udg_GolemUnitType // used by: Spell_Tables, Summon_Golem
    integer array udg_ShivaUnitType // used by: Spell_Tables, Summon_Shiva
    integer array udg_IfritUnitType // used by: Spell_Tables, Summon_Ifrit
    integer array udg_CyclopsUnitType // used by: Spell_Tables, Summon_Cyclops
    integer array udg_GlyphDemonType // used by: Boss_DemiFiend, RingOfDarkness
    unit udg_DodgeUnit=null // used by: Counter, Damage
    unit udg_DodgeAttacker=null // used by: Counter, Damage
    location udg_GayaRageLoc=null // used by: Boss_DemiFiend, Spell_GayaRage
    hashtable udg_MaxHpBuffHash=null // used by 6 modules
    integer array udg_ElementSpellPrimary // used by: Elements, Shift
    integer array udg_ElementSpellSecondary // used by: Elements, Shift
    hashtable udg_AbsorbShieldHash=null // used by: Damage, Spell_Tables, Vendetta
    unit udg_GolemSummon=null // used by: Summon_Golem, Summon_Lifecycle, Summon_Transfusion, Transfusion
    unit udg_Eidolon1=null // used by 5 modules
    unit udg_Eidolon2=null // used by 5 modules
    unit udg_Eidolon3=null // used by 5 modules
    unit udg_BahamutSummon=null // used by: Summon_Bahamut, Summon_Lifecycle, Transfusion
    unit udg_NeoBahamutSummon=null // used by: Oracle, Summon_Lifecycle, Transfusion
    real udg_ManaRefundGold=0 // used by: Mana, ManaRefund
    unit udg_ManaRefundUnit=null // used by: Mana, ManaRefund
    integer array udg_AnimalCompanionUnit // used by: Animal, Spell_Tables
    integer udg_SpellManaCost=0 // used by: HolyPower, ManaRefund, Manablow, Spell_Shared
    integer udg_MeteorDummyIndex=0 // used by: Meteor, Spell_Tables
    integer array udg_MeteorDummyAbility // used by: Meteor, Spell_Tables
    boolean udg_DmgFlagHealUndead=false // used by: Damage, Devour
    real udg_AdaptPhysTotal=0 // used by: Boss_Ozma, Damage
    real udg_AdaptMagicTotal=0 // used by: Boss_Ozma, Damage
    unit array udg_SleepTarget // used by: Damage, Sleep
    real udg_GolemBaseArmor=0 // used by: Summon_Golem, Summon_Transfusion, Transfusion
    real udg_ShivaBaseArmor=0 // used by: Summon_Shiva, Summon_Transfusion, Transfusion
    real udg_IfritBaseArmor=0 // used by: Summon_Ifrit, Summon_Transfusion, Transfusion
    real udg_CyclopsBaseArmor=0 // used by: Summon_Cyclops, Summon_Transfusion, Transfusion
    real udg_BahamutBaseArmor=0 // used by: Summon_Bahamut, Transfusion
    real udg_NeoBahamutBaseArmor=0 // used by: Oracle, Transfusion
    integer udg_BlizzagaActiveCount=0 // used by: Blizzaga, Spell_Blizzaga
    integer array udg_BlizzagaList // used by: Blizzaga, Spell_Blizzaga
    integer udg_RapidFireActiveCount=0 // used by: RapidFire, Spell_RapidFire
    integer array udg_RapidFireList // used by: RapidFire, Spell_RapidFire
    integer udg_ShurikenActiveCount=0 // used by: Shuriken, Spell_Shuriken
    integer array udg_ShurikenList // used by: Shuriken, Spell_Shuriken
    integer udg_TatsumakiActiveCount=0 // used by: Spell_Tatsumaki, Tatsumaki
    integer array udg_TatsumakiList // used by: Spell_Tatsumaki, Tatsumaki
    boolexpr udg_TatsumakiFilter // used by: MapBootstrap, Spell_Tatsumaki, Tatsumaki
    integer udg_LiquidSteelActiveCount=0 // used by: LiquidSteel, Spell_LiquidSteel
    integer array udg_LiquidSteelList // used by: LiquidSteel, Spell_LiquidSteel
    integer udg_WickedWhirlActiveCount=0 // used by: Boss_Verc, WickedWhirl
    integer array udg_WickedWhirlList // used by: Boss_Verc, WickedWhirl
    integer udg_ClioneActiveCount=0 // used by: Boss_Shinra, Clione
    integer array udg_ClioneList // used by: Boss_Shinra, Clione
    unit array udg_BlizzagaCaster // used by: Blizzaga, Spell_Blizzaga
    player array udg_BlizzagaOwner // used by: Blizzaga, Spell_Blizzaga
    integer array udg_BlizzagaIndex // used by: Blizzaga, Spell_Blizzaga
    group udg_BlizzagaGroup=CreateGroup() // used by: Blizzaga, Spell_Blizzaga
    unit array udg_RapidFireShooter // used by: RapidFire, Spell_RapidFire
    integer array udg_RapidFireIndex // used by: RapidFire, Spell_RapidFire
    unit array udg_ShurikenCaster // used by: Shuriken, Spell_Shuriken
    unit array gg_unit_h020_0271 // used by: Shuriken, Spell_Shuriken
    real array udg_ShurikenDamage // used by: Shuriken, Spell_Shuriken
    real array udg_ShurikenAngle // used by: Shuriken, Spell_Shuriken
    real array udg_ShurikenX // used by: Shuriken, Spell_Shuriken
    real array udg_ShurikenY // used by: Shuriken, Spell_Shuriken
    effect array udg_ShurikenEffect // used by: Shuriken, Spell_Shuriken
    player array udg_ShurikenOwner // used by: Shuriken, Spell_Shuriken
    group array udg_ShurikenHitGroupA // used by: Shuriken, Spell_Shuriken
    group array udg_ShurikenHitGroupB // used by: Shuriken, Spell_Shuriken
    integer array udg_ShurikenIndex // used by: Shuriken, Spell_Shuriken
    group udg_ShurikenEnumGroup=CreateGroup() // used by: Shuriken, Spell_Shuriken
    unit array udg_TatsumakiCaster // used by: Spell_Tatsumaki, Tatsumaki
    real array udg_TatsumakiTickDamage // used by: Spell_Tatsumaki, Tatsumaki
    real array udg_TatsumakiStompDamage // used by: Spell_Tatsumaki, Tatsumaki
    boolean array udg_TatsumakiHitTick // used by: Spell_Tatsumaki, Tatsumaki
    player array udg_TatsumakiOwner // used by: Spell_Tatsumaki, Tatsumaki
    integer array udg_TatsumakiIndex // used by: Spell_Tatsumaki, Tatsumaki
    unit array gg_unit_h020_0272 // used by: LiquidSteel, Spell_LiquidSteel
    effect array udg_LiquidSteelEffect // used by: LiquidSteel, Spell_LiquidSteel
    integer array udg_LiquidSteelIndex // used by: LiquidSteel, Spell_LiquidSteel
    unit array udg_WickedWhirlCaster // used by: Boss_Verc, WickedWhirl
    unit array gg_unit_h020_0273 // used by: Boss_Verc, WickedWhirl
    effect array udg_WickedWhirlEffect // used by: Boss_Verc, WickedWhirl
    integer array udg_WickedWhirlIndex // used by: Boss_Verc, WickedWhirl
    group udg_WickedWhirlGroup=CreateGroup() // used by: Boss_Verc, WickedWhirl
    integer array udg_ClioneIndex // used by: Boss_Shinra, Clione

    // ---- Shared by modules in "05 Items crafting and shops" ----
    string array udg_RecipeName // used by: Craft, Recipe
    integer array udg_RecipeResult // used by: Craft, Recipe
    integer array udg_RecipeItem1 // used by: Craft, Recipe
    integer array udg_RecipeItem2 // used by: Craft, Recipe
    integer array udg_RecipeCharges1 // used by: Craft, Recipe
    integer array udg_RecipeCharges2 // used by: Craft, Recipe
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
    real udg_AoMadoushiFacing=0 // used by: AoMadoushi, Epilogue, Quest_AoMadoushi, Quest_EyeOfJenova
    location udg_AoMadoushiLoc=null // used by: AoMadoushi, Epilogue, Quest_AoMadoushi, Quest_EyeOfJenova
    unit udg_TimmyUnit=null // used by: NameDiary, Quest_SaveTimmy
    texttag array udg_FloatingText // used by: Npc, Quest_YoungEngineer
    timerdialog udg_EdenTimerDialog=null // used by: Eden, Quest_StrongestEidolon
    integer array udg_ShadowHireOffer // used by: Shadow_Hiring, Shadow_Lifecycle
    integer udg_ShadowOfferTier=0 // used by: Shadow_Hiring, Shadow_Lifecycle
    integer udg_ShadowKills=0 // used by: Shadow_Hiring, Shadow_Lifecycle, Shadow_Loyalty
    integer array udg_ShadowKatana // used by: Shadow_Hiring, Shadow_Lifecycle
    integer array udg_ShadowDagger // used by: Shadow_Hiring, Shadow_Lifecycle
    integer array udg_ShadowHelmet // used by: Shadow_Hiring, Shadow_Lifecycle
    integer array udg_ShadowArmor // used by: Shadow_Hiring, Shadow_Lifecycle
    integer array udg_ShadowPotion // used by: Shadow_Hiring, Shadow_Lifecycle
    unit udg_FluteHolder=null // used by: TrueIceAge, Turks
    integer array udg_DancingDaggersAbility // used by: Shadow_Hiring, Shadow_Lifecycle
    item udg_ShimmerweedItem=null // used by: Ending, Quest_Shimmerweed, Shimmerweed
    unit udg_BlueGirl=null // used by: Bernkastel, Ending
    boolean udg_VillagerEffectActive=false // used by: Npc, Quest_SaveTimmy
    unit array udg_ZoneBoss // used by: Elemental, IcyRealm, Quest_ScorchingTravel
    timerdialog udg_SiegeTimerWindow=null // used by: KalmSiege1, KalmSiege2, KalmSiege3
    integer array udg_SiegeNorthUnitType // used by: KalmSiege, KalmSiege1, KalmSiege2, KalmSiege3
    boolean udg_GhoulMasterDisabled=false // used by: GrandVampire, KalmSiege1, KalmSiege2, KalmSiege3
    destructable array udg_HiddenDest // used by: IcyRealm, Quest_ScorchingTravel
    integer udg_HiddenDestCount=0 // used by: IcyRealm, Quest_ScorchingTravel
    integer array udg_SiegeSouthUnitType // used by: KalmSiege, KalmSiege2, KalmSiege3, OrcBase
    integer udg_PhantomVillagersMet=0 // used by 5 modules
    integer udg_DarkFireStage=0 // used by 5 modules
    string udg_QuestTitleRed="|cffff0000" // used by: AlmightyShinra, Judgment, Quest_ScorchedEarth, TrueIceAge
    boolean udg_ShinraFinaleArmed=false // used by: AlmightyShinra, DimensionalBoundary
    boolean udg_CidQuestOnHold=false // used by: Cid, Epilogue, TrueIceAge
    integer udg_RaidPowerLevel=0 // used by: KalmSiege, KalmSiege1, KalmSiege2, KalmSiege3
    location array udg_FafnirPatrolPoint // used by: Fafnir, Ziegfried
    unit udg_Fafnir=null // used by: Fafnir, Quest_ImperviousBeast, Ziegfried
    unit udg_VikingBoat=null // used by: Fafnir, Ziegfried
    item udg_LokiReforgeItem=null // used by: Dwarves, Loki
    texttag udg_LokiForgeText=null // used by: Loki, Quest_OreSupplies
    location udg_LokiForgeSpot=null // used by: Dwarves, Loki, Quest_OreSupplies
    boolean udg_CrossbowAdviceGiven=false // used by: Mid, Quest_Crossbow, Quest_YoungEngineer
    unit udg_PhantomDiaryUnit=null // used by: PhantomDiary, Quest_DivineOrder
    sound gg_snd_JainaWhat=null // used by: MapBootstrap, MithrilGolem, Quest_FireGolem
    sound gg_snd_UtherTaunt2=null // used by: Cid, KalmSiege3, MapBootstrap

    // ---- Shared by modules in "07 Hunts and encounters" ----
    integer array udg_ArenaMonsterType // used by: Arena_Spawning, Arena_TeamData
    integer udg_ArenaRound=0 // used by: Arena_BattleSetup, Arena_Rounds
    integer udg_ArenaPickedTeam=0 // used by: Arena_BattleSetup, Arena_TeamSelection
    boolean udg_ArenaCheckFlag=false // used by: Arena_BattleSetup, Arena_TeamSelection
    texttag array udg_ArenaTextTag // used by: Arena_BattleSetup, Arena_Rounds
    lightning array udg_ArenaLightning // used by: Arena_BattleResults, Arena_BattleSetup, Arena_Rounds
    integer udg_ChocoboCupStage=0 // used by: Arena_BattleResults, Arena_Conquest, Arena_Cups, Arena_Rounds
    integer udg_ArenaSwapTemp=0 // used by: Arena_BattleSetup, Arena_TeamSelection
    integer udg_ArenaSwapTemp2=0 // used by: Arena_BattleSetup, Arena_TeamSelection
    boolean udg_ArenaShowcaseOn=false // used by: Arena_Presentation, Arena_Rounds, Arena_TeamData
    integer udg_ArenaUnitsUnlocked=0 // used by: Arena_Conquest, Arena_Rounds, Arena_TeamSelection
    integer udg_ArenaIntroSeen=0 // used by: Arena_Cups, Arena_Introduction
    integer udg_CrystalShardCount=0 // used by: Arena_Cups, Arena_TeamData, Hunt_Rewards
    integer array udg_ArenaBattleOffer // used by: Arena_Conquest, Arena_Rounds, Arena_TeamData
    integer array udg_ArenaMonsterItem // used by: Arena_Spawning, Arena_TeamData
    unit udg_ArenaLeaderUnit=null // used by: Arena_BattleResults, Arena_BattleSetup, Arena_Rounds, Arena_Spawning
    integer udg_HuntShopStock=0 // used by: Hunt_Board, Hunt_Shop
    integer array udg_HuntRewardItem // used by: Hunt_Board, Hunt_Shop
    integer udg_ArenaOwnerStreak=0 // used by: Arena_BattleSetup, Arena_Conquest, Arena_TeamData, Arena_TeamSelection
    texttag array udg_ArenaBpTag // used by: Arena_BattleResults, Arena_Cups, Arena_Rewards, Arena_Rounds
    boolean udg_ArenaIntermission=false // used by: Arena_BattleResults, Arena_BattleSetup, Arena_Rounds
    boolean udg_ArenaSurvivalMode=false // used by: Arena_Configuration, Arena_Cups, Arena_Rounds
    player udg_ArenaSoloPlayer=null // used by: Arena_BattleResults, Arena_BattleSetup, Arena_Rounds
    boolean udg_ArenaEliteKilled=false // used by: Arena_BattleResults, Arena_BattleSetup, Arena_Rounds
    unit array udg_HuntBoard // used by: Hunt_Board, Hunt_Contracts
    integer udg_ArenaSpawnTeam=0 // used by: Arena_BattleSetup, Arena_Rounds, Arena_Spawning
    real udg_ArenaSpawnFacing=0 // used by: Arena_BattleSetup, Arena_Rounds, Arena_Spawning
    location udg_ArenaSpawnLoc=null // used by: Arena_BattleSetup, Arena_Rounds, Arena_Spawning
    integer udg_ArenaStallTicks=0 // used by: Arena_BattleSetup, Arena_Boundaries, Arena_Rounds

    // ---- Shared by modules in "08 World and travel" ----
    real array udg_TravelX // used by: Travel, Warp
    real array udg_TravelY // used by: Travel, Warp
    region array udg_TravelRegion // used by: Travel, Warp
    trigger udg_WarpEnterTrigger=null // used by: Travel, Warp

    // ---- Shared by modules in "09 Player features" ----
    integer udg_MusicZoneTrack=0 // used by: Cmd, Music
    integer udg_MusicSpecialTrack=0 // used by: Cmd, Music
    boolean array udg_HasLoadedCode // used by: Cmd, Load, Save
    constant string udg_AllowLocalFilesPath=".\\FFERPG\\"+"Allow Local Files"+".txt" // used by: Load, Save
    hashtable udg_CodeCharIndex // used by: Cmd, Save
    real udg_EnemyHpPerPlayer=0 // used by: Difficulty, Vote
    unit udg_BreedPartnerChocobo=null // used by: Chocobo_Breeding, Chocobo_Taming
    integer array udg_ChocoboAbility // used by 5 modules
    unit udg_BreedTargetChocobo=null // used by: Chocobo_Breeding, Chocobo_Taming
    integer udg_ChocoboAbilityIndex=0 // used by 5 modules
    location array udg_ChocoboDigSpot // used by: Chocobo_Digging, Chocobo_Population
    integer array udg_ChocoboDigItem // used by: Chocobo_Digging, Chocobo_Population
    integer udg_ChocoboRegionIndex=0 // used by: Chocobo_Digging, Chocobo_Population
    integer udg_VotesCast=0 // used by: GameMode, Vote
    integer udg_PendingEventCount=0 // used by: Multiboard, Player
    integer udg_ChocoboDigSpotCount=0 // used by: Chocobo_Digging, Chocobo_Population
    integer array udg_FishMonster // used by: Fishing_Encounters, Fishing_Setup
    timerdialog udg_VoteTimerDialog=null // used by: Game, Vote
    integer udg_TopVoteCount=0 // used by: GameMode, Vote
    integer udg_WinningOption=0 // used by: GameMode, Vote
    integer udg_ActivePlayerCount=0 // used by: GameMode, Speedrun
    string udg_DifficultyName="" // used by: Multiboard, Speedrun, Vote
    boolean udg_GameRunning=false // used by: Cheat, Game, Save
    integer udg_SpeedrunTitleBase=0 // used by: Speedrun, Titles
    string udg_GameModeName="" // used by: GameMode, Multiboard
    boolean udg_SaveDebug=false // used by: Save, SaveDebug
    string udg_AbilityNameMarker="!" // used by: AbilityText, BattleLog
    trigger udg_AutosaveTimerTrig // used by: Load, Save
    trigger udg_NewGamePlusTrig // used by: Save, Title
    trigger udg_NewGameMinusTrig // used by: Save, Title
    integer udg_SaveBufferFreeHead=0 // used by: Cmd, Save
    integer array udg_SaveBufferNext // used by: Cmd, Save
    boolean array udg_MusicEnabled // used by: Cmd, Music
    boolean array udg_MusicUseCustom // used by: Cmd, Music
    boolean array udg_MusicAnnounce // used by: Cmd, Music
    string array udg_MusicPathPrefix // used by: Cmd, Music
    string array udg_MusicBlizzTrack // used by: Cmd, Music
    string array udg_MusicCustomTrack // used by: Cmd, Music
    integer array udg_SaveStructKind // used by: Cmd, Save

    // ---- Shared across folders, mostly by "01 Shared helpers" ----
    integer udg_HealCreditPlayer=0 // used by: Damage, Missile
    player udg_FilterOwner // used by: Filter, Spell_LiquidSteel
    real array udg_KnockSpeed // used by: Knock, Wave
    real array udg_KnockDecay // used by: Knock, Wave
    real array udg_KnockCosA // used by: Knock, Wave
    real array udg_KnockSinA // used by: Knock, Wave
    real array udg_KnockX // used by: Knock, Wave
    real array udg_KnockY // used by: Knock, Wave
    real array udg_KnockDamage // used by: Knock, Wave
    unit array udg_KnockSource // used by: Knock, Wave
    string array udg_SaveCodeChunk // used by: Code, Save
    integer array udg_SaveChunkBase // used by: Code, Save
    integer udg_SaveSlotFreeCount=0 // used by: Code, Save
    integer array udg_CodeSlot // used by: Code, Save
    integer array udg_CodeSlotStack // used by: Code, Save
    integer array udg_SaveChunkIndex // used by: Code, Save
    string array udg_CodeFormat // used by: Code, Save
    integer array udg_CodeReadPos // used by: Cmd, Code
    string array udg_CodeFormatRead // used by: Cmd, Code
    unit array udg_MissileCaster // used by: Missile, Spell_HolyBlast
    unit array udg_MissileTarget // used by: Missile, Spell_HolyBlast
    real array udg_MissileCosA // used by: Missile, Spell_HolyBlast
    real array udg_MissileSinA // used by: Missile, Spell_HolyBlast
    real array udg_MissileX // used by: Missile, Spell_HolyBlast
    real array udg_MissileY // used by: Missile, Spell_HolyBlast
    integer array udg_MissileElement // used by: Missile, Spell_HolyBlast
    attacktype array udg_MissileAttackType // used by: Missile, Spell_HolyBlast
    boolean array udg_MissileIsPure // used by: Missile, Spell_Cure
    boolean array udg_MissileTrueDamage // used by: Missile, Spell_HolyBlast
    integer array udg_MissileHealCredit // used by: Missile, Spell_Cure
    effect array udg_MissileModelEffect // used by: Missile, Spell_HolyBlast
    effect array udg_MissileTrailEffect // used by: Missile, Spell_HolyBlast
    string array udg_MissileHitEffect // used by: Missile, Spell_Cure
    group array udg_MissileHitGroup // used by: Missile, Spell_HolyBlast
    trigger array udg_CodeFreeTrig // used by: Cmd, Wrap
    trigger udg_CodeCreateTrig // used by: Cmd, Wrap
    trigger udg_CodeWriteIntTrig // used by: Save, Wrap
    trigger udg_CodeReadIntTrig // used by: Cmd, Wrap
    trigger udg_BlizzagaRemoveTrig // used by: Spell_Blizzaga, Wrap
    trigger udg_RapidFireRemoveTrig // used by: Spell_RapidFire, Wrap
    trigger udg_ShurikenDamageTrig // used by: Spell_Shuriken, Wrap
    trigger udg_ShurikenRemoveTrig // used by: Spell_Shuriken, Wrap
    trigger udg_TatsumakiPullTrig // used by: Spell_Tatsumaki, Wrap
    trigger udg_TatsumakiStompTrig // used by: Spell_Tatsumaki, Wrap
    trigger udg_TatsumakiRemoveTrig // used by: Spell_Tatsumaki, Wrap
    trigger udg_LiquidSteelRemoveTrig // used by: Spell_LiquidSteel, Wrap
    trigger udg_WickedWhirlRemoveTrig // used by: Boss_Verc, Wrap
    trigger udg_ClioneRemoveTrig // used by: Boss_Shinra, Wrap
    integer udg_ArgBits // used by: Code, Save
    player udg_ArgPlayer // used by: Cmd, Code
    real udg_ArgReal // used by: Blizzaga, Missile
    integer udg_RetInt // used by: Cmd, Code
    group udg_EnumGroup=null // used by: Ending, Group
    boolexpr udg_FilterTrue=null // used by: Ending, Group, MapBootstrap, Stock

    // ---- Shared across folders, mostly by "02 Map setup" ----
    integer array udg_PlayerKillCount // used by 6 modules
    questitem array udg_InfoQuestItem // used by: Init, Quest_Log
    string udg_ColorCyan="" // used by: Init, Quest_Log
    string udg_ColorGreen="" // used by: Init, Quest_Log
    real udg_ExpRate=0 // used by: Init, Job, MapBootstrap, Vote
    string udg_ColorOrange="" // used by: Init, Quest_Log
    quest udg_DifficultyQuest=null // used by: Init, Vote
    timer udg_KalmSiegeTimer=null // used by: Boss_Zalera, Celeborn, Init, MapBootstrap
    group udg_HideoutGuards=null // used by: Init, MapBootstrap, Melaniya, Quest_GreedIsGood
    boolean udg_AbilityTextEnabled=false // used by: AbilityText, Init, MapBootstrap
    integer array udg_FirePotionCount // used by: Fire, Init, MapBootstrap
    integer udg_GameDay=0 // used by 5 modules
    boolean array udg_StoryFlag // used by 5 modules
    string array udg_NewsTitle // used by: Init, MapBootstrap, News
    string array udg_NewsEntry // used by: Init, MapBootstrap, News
    boolean array udg_NewsEntryCooldown // used by: Init, MapBootstrap, News
    string array udg_CurseHintLine // used by: Init, MapBootstrap, MysteriousCurse
    integer array udg_MaterialOwnedCount // used by: Bazaar, Init, MapBootstrap, Quest_WolfFangs
    group udg_ArenaNpcGroup=null // used by: Arena_Presentation, Init, MapBootstrap
    boolean array udg_MateriaAltarDone // used by: Init, MapBootstrap, Materia
    group udg_JudgeGroup=null // used by: Boss_Judges, Init, MapBootstrap
    integer array udg_ZoneKillStreak // used by: Init, Loot, MapBootstrap, Wanderer
    integer array udg_ZoneStreakID // used by: Init, Loot, MapBootstrap, Wanderer
    boolean array udg_WandererSpawned // used by: Init, MapBootstrap, Wanderer
    integer array udg_LastKillZoneID // used by: Init, Loot, MapBootstrap
    boolean array udg_AutoBrewEnabled // used by: Hero_Death, Init, Kesha, MapBootstrap
    group udg_NpcTrioGroup=null // used by: Init, MapBootstrap, NpcTrio
    boolean array udg_QuFrogDraining // used by: Init, MapBootstrap, QuFrog
    boolean udg_ShowDamageText=false // used by: Init, MapBootstrap, Text
    group udg_GnollCampUnits=null // used by: Init, MapBootstrap, Quest_SaveTimmy
    string array udg_SpeciesName // used by: Gaya_Scan, Init, MapBootstrap, Oversoul
    boolean array udg_GayaReady // used by: Gaya_Channeling, Init, MapBootstrap
    real array udg_ShadowSpawnFacing // used by: Init, MapBootstrap, Shadow_Lifecycle
    force udg_ShadowLevelPool=null // used by: Init, MapBootstrap, Shadow_Hiring
    string array udg_VoteOptionText // used by: Init, MapBootstrap, Quest_Log, Vote
    timer udg_WorldEventTimer=null // used by: ExcaliburII, Game, Init, MapBootstrap
    real udg_ExpShareRange=0 // used by: Exp, Init, MapBootstrap
    boolean array udg_SpiritCalm // used by: ForestSpirit, Init, MapBootstrap
    integer array udg_SpiritWanderTick // used by: ForestSpirit, Init, MapBootstrap
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
    integer array udg_ElementalMoveTimer // used by: Elemental, Init, MapBootstrap
    boolean array udg_ElementalAlive // used by: Elemental, Init, MapBootstrap
    timer udg_CowSpawnTimer=null // used by: CowPortal, Init, MapBootstrap
    group udg_CowGroup=null // used by: CowPortal, Init, MapBootstrap
    integer array udg_ElementalKillStreak // used by: Elemental, Init, MapBootstrap
    boolean udg_GafgarionRevived=false // used by: Boss_Hashmalum, Init, Spawn, TrueIceAge
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
    integer array udg_MapRewardTier // used by: Cartographer, Init, MapBootstrap
    timer udg_TargetPracticeTimer=null // used by: Init, MapBootstrap, TargetPractice
    group udg_SeekerLeaders=null // used by: Init, MapBootstrap, Quest_SeekDestroy, Seekers
    group udg_FestivalHunters=null // used by: HuntFestival, Init, MapBootstrap
    integer array udg_FestivalScore // used by: HuntFestival, Init, MapBootstrap
    timer udg_FestivalTimer=null // used by: HuntFestival, Init, MapBootstrap
    real array udg_TargetRecordTime // used by: Init, MapBootstrap, TargetPractice
    string array udg_TargetRecordName // used by: Init, MapBootstrap, TargetPractice
    timer udg_SpiritSpawnTimer=null // used by: Init, MapBootstrap, Player, Spirit
    group array udg_NecroCorpseGroup // used by: Init, MapBootstrap, Necro
    group udg_DarkFactMinions=null // used by: Boss_DarkFact, Init, MapBootstrap
    boolean array udg_TitleStatsBlocked // used by: Hero_EndlessGrowth, Init, MapBootstrap
    integer udg_JobLevelTier1=0 // used by: Init, MapBootstrap, Titles
    real udg_SecondaryXPRate=0 // used by 6 modules
    timer udg_GagnrathTimer=null // used by: Init, MapBootstrap, Valfodr
    group udg_GagnrathCasters=null // used by: Init, MapBootstrap, Valfodr
    integer array udg_JobExtraAbility // used by: Init, Quick
    boolean udg_NecrophobeStarted=false // used by: Cine, Init
    integer array udg_BeltStacks // used by: Arena_Cups, Cloak, Init, MapBootstrap
    timer udg_SharedDelayTimer6=null // used by: Ending, Init, MapBootstrap
    timer udg_JobChangeTimer=null // used by: Cloak, Init, Job, MapBootstrap
    group udg_MeteoriteRocks=null // used by: Cometeorite, Exodus, Init, MapBootstrap
    integer array udg_ArmoryParentCategory // used by: Armory, Init, MapBootstrap
    timer udg_ReviveCleanupTimer=null // used by: Hero_Death, Init, MapBootstrap, Revive
    group udg_RevivedHeroes=null // used by: Hero_Death, Init, MapBootstrap, Revive
    timer udg_DpsTimer=null // used by: Dps, Init, MapBootstrap
    group udg_BagOfTricksTargets=null // used by: BagOfTricks, Init, MapBootstrap
    integer array udg_OversoulKillsNeeded // used by: Init, MapBootstrap, Oversoul
    integer array udg_SpeciesKillCount // used by: Init, MapBootstrap, Oversoul
    group udg_MephorashClones=null // used by: Init, MapBootstrap, Mephorash
    timer udg_BazaarUpdateTimer=null // used by: Bazaar, Init, MapBootstrap
    integer array udg_MaterialSpentCount // used by: Bazaar, Init, MapBootstrap
    group udg_RengekiGroup=null // used by: Damage, Init, MapBootstrap
    group udg_UndyingGroup=null // used by: Damage, Init, MapBootstrap
    group udg_OblivionDummyGroup=null // used by: Init, MapBootstrap, Oblivion
    timer udg_FafnirPatrolTimer=null // used by: Fafnir, Init, MapBootstrap
    integer array udg_MolotovCooldown // used by: Damage, Init, MapBootstrap
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
    boolean array udg_ElementalKilledOnce // used by: Elemental, Init, MapBootstrap
    force array udg_NullElementForce // used by: Damage, Elysium, Init, MapBootstrap
    timer udg_StunReapplyTimer=null // used by: Damage, Init, MapBootstrap
    integer array udg_NullElementCount // used by: Damage, Init, MapBootstrap
    force array udg_WeakElementForce // used by: Damage, Elysium, Init, MapBootstrap
    integer array udg_WeakElementCount // used by: Damage, Init, MapBootstrap
    group udg_FrozenUnits=null // used by: Ending, Init, MapBootstrap
    group udg_WorldUnits=null // used by: Ending, Init, MapBootstrap
    timer array udg_AxeChargeTimer // used by: Damage, Init, MapBootstrap
    group udg_BurningBuildings=null // used by: Ending, Init, MapBootstrap
    timer udg_GeomancerAwardTimer=null // used by: Damage, Init, MapBootstrap
    real udg_SplashTally=0 // used by: Damage, Init, MapBootstrap
    timer array udg_ArmorBreakerTimer // used by: Armor, Init, MapBootstrap
    integer array udg_OracleMasteryCount // used by: Init, MapBootstrap, Oracle
    timer array udg_SleepWakeTimer // used by: Damage, Init, MapBootstrap
    real array udg_InfinityAbsorbed // used by: Damage, Init, MapBootstrap, Prophet
    force array udg_EidolonAwardForce // used by: Damage, Init, MapBootstrap
    boolean udg_DpsRefresh=false // used by: Dps, Init, MapBootstrap, Multiboard
    integer array udg_DragonKillCount // used by: Init, Lancer, MapBootstrap
    real array udg_BankedXP // used by 5 modules
    integer array udg_CountedItemIndex // used by: Init, MapBootstrap, Title
    timer udg_ElementRecordTimer=null // used by: Damage, Elemental, Init, MapBootstrap
    timer array udg_ExpBankTimer // used by: Exp, Firefly, Init, MapBootstrap
    timer array udg_NinjaImmortalTimer // used by: Debug, Init, MapBootstrap, Ninja
    boolean array udg_ItemCounted // used by: Init, MapBootstrap, Title
    timer array udg_LastCritTimer // used by: Damage, Init, MapBootstrap
    timer udg_VisionShareTimer=null // used by: Damage, Init, MapBootstrap

    // ---- Shared across folders, mostly by "03 Jobs and progression" ----
    hashtable udg_JobHeroHash // used by: Cmd, Job, JobHero
    hashtable udg_JobLevelHash // used by: Cmd, Job, JobHero
    integer udg_TempInteger2=0 // used by: Cam, Chocobo_Bribing, Mediator
    integer udg_TempItemId=0 // used by: Book, Chemist, Cooldown, Gold
    unit array udg_FreelancerHero // used by 7 modules
    integer array udg_AbilitySlot1 // used by: Init, Job, MapBootstrap, Shrine
    integer array udg_AbilitySlot2 // used by: Init, Job, MapBootstrap, Shrine
    integer array udg_AbilitySlot3 // used by: Init, Job, MapBootstrap, Shrine
    integer array udg_AbilitySlot4 // used by: Init, Job, MapBootstrap, Shrine
    integer array udg_JobUnitType // used by 31 modules
    integer array udg_JobSkill // used by 6 modules
    force udg_TempForce=null // used by 102 modules
    string array udg_JobName // used by 24 modules
    hashtable udg_ChannelDrainHash=null // used by: Necro, Spell_Tables
    hashtable udg_DivineShieldHash=null // used by: Damage, Job, Prophet, Spell_Tables
    string array udg_EffectModelPath // used by 5 modules
    unit array udg_FishingControls // used by: Fishing_ReelingAndCatch, Hero_Select
    integer udg_JobCount=0 // used by 9 modules
    group udg_RegenGroup=null // used by 7 modules
    boolean udg_DarkJobsUnlocked=false // used by 6 modules
    force udg_CheaterForce=null // used by 11 modules
    group array udg_BonusGroup // used by 5 modules
    boolean array udg_SpeedrunFlag // used by 10 modules
    integer array udg_SubSkillSlot // used by 6 modules
    integer array udg_MainSkillSlot // used by: Init, Job, MapBootstrap, Shrine
    boolean udg_ShrineUnlocked=false // used by 5 modules
    unit array udg_PetUnit // used by: Animal, Lancer, Shrine, Summon_Lifecycle
    integer array udg_DragonSummonUnit // used by: Lancer, Spell_Tables
    unit array udg_NpcUnit // used by 25 modules
    effect array udg_LegendMarker // used by 25 modules
    boolean udg_DarkShopsVisible=false // used by: Andre, DarkJobs
    group udg_SecondShrineUnits=null // used by 6 modules
    integer array udg_QuestStage // used by 29 modules
    timer udg_UnitUpdateTimer=null // used by 29 modules
    boolean udg_LegendaryUnlocked=false // used by: Legendary, Levels, Title
    unit array udg_SummonUnit // used by: Job, Mediator, Shrine, Summon_Lifecycle
    integer array udg_BrewAbility // used by 5 modules
    integer array udg_EnchantAbility // used by 6 modules
    integer udg_CookingStage=0 // used by 5 modules
    timer udg_ComboTimer=null // used by: Exp, Init, MapBootstrap, Samurai
    real udg_BahamutZeroBaseArmor=0 // used by: Sorcerer, Transfusion
    boolean udg_ChocoboGreensFed=false // used by: ChocoboRider, Chocobo_Upgrades

    // ---- Shared across folders, mostly by "04 Combat and abilities" ----
    integer udg_TempInteger=0 // used by 175 modules
    unit array udg_SpiritOfGaya // used by 42 modules
    unit array udg_GolemUnit // used by: MithrilGolem, StrangeCage
    real udg_EnemyHandicap=0 // used by 11 modules
    location udg_TempPoint=null // used by 350 modules
    group udg_TempGroup=null // used by 77 modules
    string udg_TempString="" // used by 9 modules
    rect array udg_PlayerStartRect // used by 7 modules
    string udg_QuestTitleColor="|cffff8040" // used by: Boss_Hashmalum, Boss_Zalera, Quest_ZodiacAge
    boolean udg_TempBoolean=false // used by 13 modules
    location udg_QuFrogLoc=null // used by: DimensionalBoundary, QuFrog
    boolean udg_MonographDropped=false // used by: BagOfTricks, Firefly, IceCache, Monograph
    timer array udg_JudgeTimer // used by: Boss, Boss_Judges, Init, MapBootstrap
    integer array udg_RewardItem // used by: FadingNotes, GameMode
    integer udg_QuFrogDrainCount=0 // used by: DimensionalBoundary, QuFrog
    integer udg_SlotIndex=0 // used by 5 modules
    location udg_TempPoint2=null // used by 109 modules
    boolean udg_RingHintsReady=false // used by 13 modules
    item udg_SummonItem=null // used by 10 modules
    unit udg_TempUnit2=null // used by 18 modules
    integer udg_ChocoboGreensStage=0 // used by: Boco, Chocobo_Digging
    unit udg_CurrentHero=null // used by 13 modules
    unit udg_StoryBoss=null // used by 13 modules
    integer udg_StatCalcValue=0 // used by 6 modules
    group udg_BossGroup=null // used by 56 modules
    integer udg_DamageElement=0 // used by 23 modules
    boolean udg_IsPhysicalAttack=false // used by 21 modules
    hashtable udg_ProxyDamageHash=null // used by 59 modules
    real udg_LastDamageDealt=0 // used by: Damage, Debug, Necro, Osmose
    integer udg_TempHandleId=0 // used by 54 modules
    group udg_PendingEffectGroup=null // used by 11 modules
    unit udg_CurrentEffectUnit=null // used by 7 modules
    integer udg_DmgFlagUnavoidable=0 // used by 17 modules
    real udg_TempReal=0 // used by 80 modules
    boolean udg_DmgFlagPure=false // used by 20 modules
    real udg_DexterityBonus=0 // used by: Damage, Shadow_Hiring
    real udg_DmgFlagNoCrit=0 // used by: Cyclops, Damage, EarthSmash, Geomancer
    real udg_DexterityCritMult=0 // used by: Damage, Shadow_Hiring
    boolean udg_IsPureDamage=false // used by 18 modules
    group udg_ImmolationAuraGroup=null // used by 8 modules
    location udg_TempPoint5=null // used by: Eidolon, Elemental
    timer udg_DemiFiendDemon1Timer=null // used by: Boss, Boss_DemiFiend, Init, MapBootstrap
    timer udg_DemiFiendDemon2Timer=null // used by: Boss, Boss_DemiFiend, Init, MapBootstrap
    integer udg_CaravanStage=0 // used by: Caravan, Quest_Caravan
    boolean udg_PortalRitualActive=false // used by: CowKing, CowPortal, Wirts
    unit udg_ElementRecordUnit=null // used by: Damage, Elemental
    boolean udg_ExcaliburRockHidden=false // used by: ExcaliburII, Gafgarion
    boolean udg_IgnoresReduction=false // used by 12 modules
    timer array udg_DodgeFaceTimer // used by 6 modules
    boolean array udg_GlyphActivated // used by: Boss_Judges, Init, MapBootstrap, RingOfDarkness
    timer udg_GayaRageTimer=null // used by: Init, MapBootstrap, Spell, Spell_GayaRage
    boolean udg_DmgFlagManaDamage=false // used by 13 modules
    integer array udg_GatherState // used by 8 modules
    item array udg_GatherItem // used by: Damage, Fishing_Casting, Fishing_ReelingAndCatch, Suicide
    location array udg_FishingBobberLoc // used by: AbilityTags, Fishing_ReelingAndCatch
    integer array udg_FishPullAbil // used by: AbilityTags, Fishing_ReelingAndCatch
    integer array udg_FishLeftAbil // used by: AbilityTags, Fishing_ReelingAndCatch
    integer array udg_FishRightAbil // used by: AbilityTags, Fishing_ReelingAndCatch
    timer udg_JobLevelTimer=null // used by 10 modules
    group udg_BerserkGroup=null // used by 7 modules
    timer udg_MaxHpDrainTimer=null // used by: Damage, Init, MapBootstrap, MaxHp
    group udg_VirusImmuneGroup=null // used by 5 modules
    force udg_AbilityTextForce=null // used by 16 modules
    real udg_DifficultyScale=0 // used by 7 modules
    hashtable udg_LinkedCasterHash=null // used by: Damage, Link, Spell_Tables
    integer udg_BravesDefeated=0 // used by: Boss_GodDragon, Boss_Zalera, Quest_WorldLiberation
    group udg_DarkEidolonGroup=null // used by 11 modules
    group udg_DeathExplodeGroup=null // used by: Death, Init, MapBootstrap, Spell_Satellite
    hashtable udg_HealOverTimeHash=null // used by 6 modules
    boolean udg_HolyAnkhUsed=false // used by 11 modules
    trigger udg_BossCleanupTrigger=null // used by 9 modules
    boolean udg_AbilityLevelShift=false // used by 16 modules
    boolean udg_HellSpawnsActive=false // used by 5 modules
    unit udg_TalonUnit=null // used by: Boss_Mateus, IceAge, Quest_ZodiacAge, Talon
    timer udg_LoadRefreshTimer=null // used by 7 modules
    hashtable udg_MonsterDataHash=null // used by 7 modules
    integer udg_LootItemID=0 // used by: Chocobo_Bribing, Loot, Steal
    boolean array udg_RingHintUsed // used by 11 modules
    group udg_ChaosElementalGroup=null // used by 6 modules
    unit udg_ChaosBoss=null // used by: Chaos, Chaosjet, VoiceOfForest
    timer udg_ShiftElementsTimer=null // used by 5 modules
    group udg_PenanceUnits=null // used by: Boss_Penance, Damage, Init, MapBootstrap
    boolean udg_FogDisabled=false // used by: Cartographer, Cheat, FogCheat
    integer array udg_ArenaBonusBattle // used by 17 modules
    integer udg_ZaleraStage=0 // used by 6 modules
    boolean udg_MateusDefeated=false // used by 6 modules
    group udg_MirrorCloneGroup=null // used by 5 modules
    integer udg_EchelePhase=0 // used by: Boss_Echele, SkeletalDefense, TrueIceAge
    boolean array udg_BossDefeated // used by 18 modules
    integer udg_EcheleFormsKilled=0 // used by: Boss_Echele, TrueIceAge
    group udg_AbsorbShieldGroup=null // used by: Damage, Init, MapBootstrap, Vendetta
    string array udg_LoreText // used by: Info, Init, Maechen, MapBootstrap
    integer udg_DropRollSeed=0 // used by: Loot, Steal
    timer udg_EcheleMinionKillTimer=null // used by 6 modules
    hashtable udg_DpsHash=null // used by: Damage, Dps, Multiboard
    hashtable udg_ComboHash=null // used by: Combo, Damage, Samurai
    integer udg_ShemhazaiPhase=0 // used by: Boss_Shemhazai, Cuchulainn, Shemhazai, TrueIceAge
    unit udg_BahamutZeroSummon=null // used by: Sorcerer, Summon_Lifecycle, Transfusion
    timer udg_ManaRefundTimer=null // used by: Init, Mana, ManaRefund, MapBootstrap
    boolean udg_SpeedrunMode=false // used by 44 modules
    unit udg_BossUnit=null // used by 39 modules
    unit udg_DispelTarget=null // used by 21 modules
    force udg_DuelArenaPlayers=null // used by 14 modules
    force array udg_JobMasterForce // used by 19 modules
    hashtable udg_MolotovHash=null // used by 5 modules
    unit udg_HarpyMatriarch=null // used by: Harpy, Quest_FieryWings
    unit udg_ShinryuUnit=null // used by: Arena_Cups, Arena_Duel, Boss_Shinryu, Spell_Satellite
    unit udg_WarmechUnit=null // used by: Arena_Cups, Arena_Duel, Boss_Shinryu, Spell_Satellite
    integer udg_DragonBattlePhase=0 // used by: Arena_Duel, Boss_Shinryu
    rect array udg_GlyphRect // used by: Arena_Duel, RingOfDarkness
    group udg_DarkServants=null // used by: DarkServant, GatherServants, Init, MapBootstrap
    group udg_GoliathTonicGroup=null // used by 5 modules
    integer array udg_MomentumCharges // used by: Damage, Init, MapBootstrap, Momentum
    unit udg_SummonedBoss=null // used by: Damage, Naisha, Nightmare
    player udg_SummonerPlayer=null // used by 6 modules
    force array udg_QuestForce // used by 12 modules
    group udg_DefendingUnits=null // used by: Damage, Defend, Init, MapBootstrap
    group udg_RunicGroup=null // used by: Death, Init, MapBootstrap, Runic
    integer array udg_BlindSpotCount // used by: Aim, Damage, Init, MapBootstrap
    real array udg_AdaptElementTotal // used by: Boss_Ozma, Damage, Init, MapBootstrap
    timer udg_StatsRefreshTimer=null // used by 5 modules
    integer array udg_MagicDefense // used by 5 modules
    integer array udg_DodgeStreak // used by: Damage, Evade, Init, MapBootstrap
    unit udg_Vercingetorix=null // used by: Hunt_Encounters, Verci
    real array udg_DamageTally // used by: Armor, Damage, Init, MapBootstrap
    group udg_ActiveHeroGroup=null // used by 11 modules
    timer udg_HeroRefreshTimer=null // used by 11 modules
    integer array udg_CoverAwardCount // used by: Cover, Damage, Init, MapBootstrap
    group udg_EnduranceAwardGroup=null // used by: Damage, HolyPower, Init, MapBootstrap
    integer array udg_EnduranceManaCount // used by: Damage, HolyPower, Init, MapBootstrap
    integer array udg_EnduranceDamageCount // used by: Damage, HolyPower, Init, MapBootstrap
    real array udg_HealingTotal // used by: Damage, Init, MapBootstrap, Spell_Cure
    integer udg_UrnBossDeaths=0 // used by: Boss_BlackDevil, MagicUrn
    integer udg_AbilityLevelIndex=0 // used by 5 modules
    real udg_ImmortalDamage=0 // used by: Damage, Debug
    real udg_ImmortalLife=0 // used by: Damage, Debug
    unit udg_ImmortalUnit=null // used by: Damage, Debug
    unit udg_ImmortalSource=null // used by: Damage, Debug
    item udg_WirtsLegItem=null // used by: CowPortal, Wirts
    integer udg_OkuuStage=0 // used by: Hunt_Encounters, Okuu, Quest_ScorchedEarth
    real array udg_MissileSpeed // used by: Missile, Spell_Cure, Spell_HolyBlast
    real array udg_MissileRange // used by: Missile, Spell_Cure, Spell_HolyBlast
    real array udg_MissileImpactDamage // used by: Missile, Spell_Cure, Spell_HolyBlast
    real array udg_MissileAoE // used by: Missile, Spell_Cure, Spell_HolyBlast
    real array udg_MissileTravelDamage // used by: Missile, Spell_Cure, Spell_HolyBlast
    boolean array udg_MissileFalloff // used by: Missile, Spell_Cure, Spell_HolyBlast
    boolean array udg_MissileIsMagic // used by: Missile, Spell_Cure, Spell_HolyBlast
    boolean array udg_MissileHoming // used by: Missile, Spell_Cure, Spell_HolyBlast
    boolean array udg_MissileHitOnce // used by: Missile, Spell_Cure, Spell_HolyBlast
    integer udg_ArgIndex // used by 19 modules

    // ---- Shared across folders, mostly by "05 Items crafting and shops" ----
    integer array udg_ArmoryCodeSegment // used by: Armory, Cmd
    integer array udg_DropItemIdTable // used by: Bazaar, DarkEidolon, Hunt_Contracts, Item_Shared
    unit udg_LastBazaarShop=null // used by: Bazaar, Quest_WolfFangs
    item udg_ForgeMaterialSlot=null // used by: Dwarves, Forge
    texttag udg_ForgeText=null // used by: Forge, Quest_Arcanium
    hashtable udg_DropItemHash=null // used by: Item_Shared, Loot, MonsterData, Oversoul
    item udg_ItemUseReplacement=null // used by: Item_Shared, Item_Upgrade, Quest_Crossbow
    integer udg_DropTempInt=0 // used by: Loot, Oversoul
    integer array udg_LevelItemIdTable // used by 5 modules
    unit udg_ArtifactCarrier=null // used by: Artifact, Cine
    integer udg_ItemIndex=0 // used by: Armory, Title
    timer array udg_SpellCooldownTimer // used by 6 modules
    item udg_ForgeGearSlot=null // used by: Dwarves, Forge
    location udg_ForgeDropPoint=null // used by: Dwarves, Forge

    // ---- Shared across folders, mostly by "06 Quests and story" ----
    hashtable udg_SpawnRectHash=InitHashtable() // used by: Ending, Zone
    hashtable udg_SpawnDataHash=InitHashtable() // used by: Ending, Spawn, Zeromus, Zone
    string array udg_TravelName // used by: IcyRealm, Quest_ScorchingTravel, Travel
    integer array udg_TravelHotkey // used by: Quest_ScorchingTravel, Travel
    button array udg_TravelButton // used by: Quest_ScorchingTravel, Travel
    effect array udg_WarpEffect // used by: Quest_ScorchingTravel, Warp
    player udg_TempPlayer=null // used by 46 modules
    unit udg_Mid=null // used by 9 modules
    quest array udg_MainQuest // used by 70 modules
    force udg_PlayingPlayers=null // used by 250 modules
    unit udg_ZodiacStone=null // used by 5 modules
    effect array udg_SpecialEffect // used by 166 modules
    quest array udg_SideQuest // used by 122 modules
    item array udg_QuestItem // used by 43 modules
    leaderboard udg_HuntLeaderboard=null // used by 15 modules
    questitem array udg_QuestReq // used by 13 modules
    timer udg_CidResearchTimer=null // used by 6 modules
    timer udg_SharedDelayTimer1=null // used by 7 modules
    unit udg_TempUnit=null // used by: AlmightyShinra, Arena_Rounds, MithrilGolem
    unit udg_CinematicActor=null // used by 32 modules
    boolean udg_InCinematicMode=false // used by 131 modules
    effect array udg_QuestMarkerEffect // used by 17 modules
    integer udg_QuestsTotal=0 // used by 14 modules
    integer udg_QuestsCompleted=0 // used by 98 modules
    real udg_TalkRange=0 // used by 127 modules
    unit udg_NarratorUnit=null // used by 6 modules
    string udg_QuestNamePrefix="|cff00ffff" // used by 55 modules
    timer udg_EdenTimer=null // used by: Eden, Init, MapBootstrap, Quest_StrongestEidolon
    string array udg_NewsText // used by 20 modules
    unit array udg_KalmNpc // used by: Kalm, News
    hashtable udg_SpawnRectHashRef=null // used by 21 modules
    hashtable udg_SpawnDataHashRef=null // used by 21 modules
    boolean array udg_QuestFlag // used by 8 modules
    timer udg_SharedDelayTimer2=null // used by 5 modules
    hashtable udg_GameStateHash=null // used by 50 modules
    integer array udg_CupWins // used by 7 modules
    timer udg_SharedDelayTimer3=null // used by: AlmightyShinra, Ending, Init, MapBootstrap
    timer udg_StoryEventTimer=null // used by 5 modules
    timer udg_SharedDelayTimer4=null // used by 6 modules
    boolean udg_SceneBusy=false // used by: AlmightyShinra, Cine, ScorchedEarth
    force udg_ActivePlayers=null // used by 40 modules
    integer udg_ShadowLoyalty=0 // used by 10 modules
    timer udg_ShadowTimer=null // used by 6 modules
    unit udg_ShadowUnit=null // used by 11 modules
    integer udg_Difficulty=0 // used by 21 modules
    boolean udg_PortalGuardianMet=false // used by 5 modules
    integer udg_StoryProgress=0 // used by 31 modules
    item udg_ThunderbloomItem=null // used by: DefiledFountain, Ending, Thunderbloom
    unit array udg_SpiritUnit // used by: ForestSpirit, VoiceOfForest
    boolean udg_HardcoreOff=false // used by 21 modules
    location udg_RetreatPoint=null // used by 5 modules
    location udg_TempPoint3=null // used by 15 modules
    timer udg_BlueGirlTimer=null // used by: Bernkastel, Ending, Init, MapBootstrap
    timer udg_GafgarionReviveTimer=null // used by: Gafgarion, IceAge, Init, MapBootstrap
    group udg_KalmGuards=null // used by 5 modules
    integer array udg_ZoneEssenceItem // used by: IcyRealm, Loot, Quest_ScorchingTravel
    unit udg_NaishaUnit=null // used by: HuntFestival, Naisha
    group udg_FarmCorpses=null // used by 5 modules
    integer array udg_AreaSpawnUnitA // used by 5 modules
    group udg_QuestNpcUnits=null // used by 7 modules
    playercolor array udg_ZoneColor // used by: Boss_Ozma, Elemental, IcyRealm, Quest_ScorchingTravel
    integer array udg_AreaSpawnUnitB // used by 5 modules
    integer array udg_ElementRecord // used by 6 modules
    unit udg_FishedGilgamesh=null // used by: Fishing_ReelingAndCatch, Gilgamesh
    unit udg_NebraKingSpot=null // used by: Fishing_Casting, NebraKing
    timer udg_NebraKingTimer=null // used by: Init, MapBootstrap, NebraKing, Quest_KingOfSea
    group udg_BossUnits=null // used by 99 modules
    group udg_QuestUnits=null // used by 26 modules
    group udg_HuntMonsters=null // used by 8 modules
    string udg_ColorGold="|cffffcc00" // used by 11 modules
    timer udg_SiegeTimer=null // used by 7 modules
    unit udg_RangerHero=null // used by 5 modules
    unit udg_EngineerHero=null // used by: KalmSiege, KalmSiege2, KalmSiege3, Spawn
    group udg_AllyBrothersGroup=null // used by 8 modules
    group udg_AllyRangerGroup=null // used by 11 modules
    group udg_SpecialUnits=null // used by 9 modules
    unit udg_ClericAlly=null // used by: KalmSiege, Spawn
    unit udg_HighPriestAlly=null // used by: KalmSiege, Spawn
    group udg_InactiveUnits=null // used by 8 modules
    group udg_RecruitedAllies=null // used by 16 modules
    group udg_ShockAuraUnitGroup=null // used by 9 modules
    group udg_PrimaryQuestUnits=null // used by: Ending, Init, MapBootstrap, QuestUnits
    unit udg_BladeKnightAlly=null // used by: KalmSiege, Spawn
    group udg_SiegeSummonGroup=null // used by 5 modules
    group udg_SummonedUnits=null // used by 8 modules
    unit udg_ScriptedBossUnit=null // used by 5 modules
    integer array udg_HuntCounter // used by 15 modules
    timer udg_ScorchedEarthTimer=null // used by: Init, MapBootstrap, Quest_BlazingDemon, ScorchedEarth
    timer udg_PostReviveTimer=null // used by 6 modules
    integer udg_CommonHuntsDone=0 // used by 14 modules
    boolean udg_HardMode=false // used by: Boss_Zalera, IcyRealm, Quest_ZodiacAge
    integer udg_DanaQuestStage=0 // used by 6 modules
    group udg_AllyEngineerGroup=null // used by 6 modules
    integer udg_HashmalumStage=0 // used by 13 modules
    integer udg_ZodiacQuestStage=0 // used by 6 modules
    group udg_TentacleGroup=null // used by 6 modules
    integer udg_TentacleCount=0 // used by: Sarai, Tentacles, Ultros
    timer udg_TentacleTimer=null // used by: Init, MapBootstrap, Monstrum, Tentacles
    group udg_RedBeastGroup=null // used by 5 modules
    boolean udg_MontblancHasNews=false // used by: Cartographer, HuntFestival, Montblanc, Quest_GodDragon
    leaderboard udg_HuntFestivalBoard=null // used by: Ending, HuntFestival
    unit udg_AlmaUnit=null // used by: Boss_Ultima, Quest_LightOfJudgment, Ultima
    timer udg_AlmaDisappearTimer=null // used by 5 modules
    weathereffect array udg_SnowEffect // used by: IcyRealm, Quest_ScorchingTravel, Weather
    boolean udg_CinematicsDisabled=false // used by 182 modules
    boolean udg_HashmalumEncountered=false // used by 6 modules
    force array udg_TitleForce // used by 46 modules
    group udg_ShemhazaiSoulClones=null // used by: Init, MapBootstrap, Shemhazai, TrueIceAge
    integer udg_SpiritsCleansed=0 // used by: ForestSpirit, SpiritScroll
    timer udg_TimmyQuestTimer=null // used by 5 modules
    integer udg_CidQuestStage=0 // used by 10 modules
    unit udg_GodDragonUnit=null // used by: GodDragon, Quest_GodDragon, Zodiark
    unit udg_NaishaTownUnit=null // used by 5 modules
    boolean udg_TalonGone=false // used by 6 modules
    unit udg_EcheleBoss=null // used by 7 modules
    timer udg_WorldFreezeTimer=null // used by 6 modules
    timerdialog udg_WorldFreezeDialog=null // used by: Boss_Echele, IceAge, TrueIceAge
    string array udg_HuntBoardLabel // used by 13 modules
    boolean udg_SecretDigSpotRevealed=false // used by: Chocobo_Digging, Exodus, Graves
    group udg_BossSummons=null // used by 9 modules
    group udg_EcheleMinionsToKill=null // used by 5 modules
    timer udg_AishaTalkTimer=null // used by: Aisha, Init, MapBootstrap, TargetPractice
    timer udg_LiberationRewardTimer=null // used by: Init, MapBootstrap, Quest, Quest_WorldLiberation
    integer udg_ExodusQuestStage=0 // used by 6 modules
    group udg_DarkEidolonIllusions=null // used by: DarkEidolons, Ending, Init, MapBootstrap
    string array udg_PlayerName // used by 45 modules
    group udg_EscortUnits=null // used by 8 modules
    group udg_TownTargetGroup=null // used by 6 modules
    group udg_DarkShopGroup=null // used by 5 modules
    timer array udg_HerbRespawnTimer // used by 6 modules
    integer udg_KalmTechLevel=0 // used by 7 modules
    integer udg_ShadowForcedSpawn=0 // used by 7 modules
    boolean udg_SpeedrunStarted=false // used by: Cid, Speedrun
    timer udg_SharedDelayTimer5=null // used by 9 modules
    boolean udg_EternityMode=false // used by 18 modules
    boolean udg_LothlorienOpen=false // used by 6 modules
    timer udg_ShortDelayTimer=null // used by 5 modules
    integer array udg_HuntStock // used by 32 modules
    boolean udg_SpawnsPaused=false // used by 5 modules
    timer udg_StoryDelayTimer=null // used by 6 modules
    integer udg_GenjiGiftStage=0 // used by: Fishing_Setup, Gilgamesh
    player udg_JudgePlayer=null // used by: Boss_Odin, Judgment, Quest_NorthernGod
    boolean udg_RukselHintShown=false // used by: Fishing_Setup, Npc

    // ---- Shared across folders, mostly by "07 Hunts and encounters" ----
    hashtable udg_SpawnTimerHash=InitHashtable() // used by: Spawn, Zone
    integer array udg_ItemIdTable // used by 8 modules
    unit array udg_ArenaOrganizer // used by 12 modules
    integer udg_ArenaCupId=0 // used by 7 modules
    integer array udg_ArenaBracketSlot // used by 7 modules
    group udg_ArenaSpawnGroup=null // used by 6 modules
    group udg_CupArenaUnits=null // used by 10 modules
    timer udg_ArenaLockTimer=null // used by: Arena, Arena_BattleSetup, Init, MapBootstrap
    integer array udg_ArenaBracketTeam // used by: Arena_BattleSetup, Arena_TeamSelection, Init, MapBootstrap
    force udg_CupArenaPlayers=null // used by 11 modules
    boolean udg_ArenaGateOpened=false // used by 5 modules
    group udg_ArenaSummonGroup=null // used by 7 modules
    integer udg_ArenaOrganizerLast=0 // used by 6 modules
    group udg_ArenaBoundUnits=null // used by 5 modules
    hashtable udg_HuntData=null // used by: HuntFestival, Hunt_Board, Hunt_Contracts, Quest_ScorchedEarth
    integer udg_RareHuntsDone=0 // used by 5 modules
    force udg_HuntSlots=null // used by 5 modules
    integer array udg_BattlePoints // used by 6 modules
    timer udg_ArenaRoundTimer=null // used by 5 modules
    integer udg_ArenaRank=0 // used by 7 modules
    unit array udg_HuntTarget // used by: HuntFestival, Hunt_Contracts, Okuu, Quest_ScorchedEarth
    timer udg_ArenaCheckTimer=null // used by: Arena, Arena_Access, Init, MapBootstrap
    boolean udg_PenanceArmsActive=false // used by 5 modules
    timer udg_DragonBattleTimer=null // used by 6 modules
    timer udg_ArenaSpawnTimer=null // used by 5 modules

    // ---- Shared across folders, mostly by "08 World and travel" ----
    boolean array udg_WarpUnlocked // used by: Quest_ScorchingTravel, Travel, Warp
    integer udg_TravelCount // used by: Quest_ScorchingTravel, Travel, Warp
    dialog udg_WarpDialog=DialogCreate() // used by: Hero_Death, Quest_ScorchingTravel, Travel, Warp
    boolean udg_CinematicSkipped=false // used by: Cine, Text
    unit array udg_PlayerTransport // used by: Cine, Gaya_Movement, Transport
    real array udg_CameraDistance // used by: Cam, Cine, Init, MapBootstrap
    timer udg_GameClock=null // used by 7 modules
    integer udg_GameHours=0 // used by: Hour, Intro, Speedrun, Time
    boolean udg_HandicapHPScaling=false // used by: GameMode, Zone

    // ---- Shared across folders, mostly by "09 Player features" ----
    unit array udg_PlayerHero // used by: DarkBahamut, Job, Player, Player_Part01
    integer udg_SaveFlagCount=0 // used by: Armory, Cmd, Save, Title
    unit array udg_PlayerHouse // used by 12 modules
    integer array udg_TotalJobLevel // used by 7 modules
    integer array udg_HighestJobLevel // used by 6 modules
    string array udg_PlayerColorCode // used by: AbilityText, BattleLog, Init, MapBootstrap
    timer udg_VoteTimer=null // used by: GameMode, Init, MapBootstrap, Vote
    integer array udg_ChocoboDigItemCharges // used by: Chocobo_Digging, Chocobo_Population, Init, MapBootstrap
    real udg_TextSpeed=0 // used by 8 modules
    dialog udg_VoteDialog=null // used by 5 modules
    integer array udg_MetaFragments // used by 6 modules
    integer array udg_MiracleStage // used by 6 modules
    timer array udg_FishingTimer // used by 13 modules
    unit array udg_PlayerFishSpot // used by: Fishing_Casting, Fishing_ReelingAndCatch, NebraKing
    integer array udg_FishLoot // used by: Fishing_Casting, Fishing_Setup, Quest_KingOfSea
    boolean udg_GilgameshDefeated=false // used by 5 modules
    boolean udg_SeaKingQuestStarted=false // used by: Anabel, Fishing_ReelingAndCatch, Fishing_Setup
    force udg_AutosaveForce=null // used by 5 modules
    force udg_TrackedPlayers=null // used by 5 modules
    group udg_TownNpcUnits=null // used by 7 modules
    integer array udg_NewGamePlusLevel // used by 11 modules
    integer array udg_ChronicleAbility // used by 5 modules
    integer array udg_TitleChroniclePoints // used by 5 modules
    integer array udg_BonusValue // used by 6 modules
    string array udg_BonusText // used by 5 modules
    integer array udg_TitleChronicleIndex // used by 6 modules
    string array udg_TitleName // used by: Init, MapBootstrap, Title, Titles
    force array udg_SaveFlagForce // used by 7 modules
    integer array udg_SaveFlagUnitID // used by 5 modules
    integer array udg_ArmoryItemCount // used by 6 modules
    group udg_FishingSpots=null // used by 5 modules
    integer array udg_VoteCount // used by: GameMode, Init, MapBootstrap, Vote
    integer array udg_CodeDifficulty // used by 5 modules
    integer array udg_SpeedrunLevel // used by 7 modules
    unit array udg_SpeedrunBoss // used by: Boss_Echele, Speedrun, Titles
    real array udg_SpeedrunTimeLimit // used by: Init, MapBootstrap, Speedrun, Titles
    force udg_LegendaryGuardianForce=null // used by 6 modules
    boolean array udg_TitlePrimaryStatOnly // used by: Init, MapBootstrap, Title, Titles
    hashtable udg_ItemSaveID // used by: Armory, Save, Title
    integer array udg_SaveVersion // used by: Cmd, Code, Save
    player array udg_SavePlayer // used by: Cmd, Code, Save
    string array udg_SaveCodePlain // used by: Cmd, Code, Save
    integer array udg_CodeKey // used by: Cmd, Code, Save
    integer array udg_CodeBuffer // used by: Cmd, Code, Save
    integer array udg_CodeBits // used by: Cmd, Code, Save
    integer array udg_Pow2 // used by: Cmd, Code, Save
    integer udg_ArgInt // used by: Cmd, Code, Save

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