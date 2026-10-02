globals
    timer udg_KnockTimer=CreateTimer()
    integer udg_KnockActiveCount=0
    integer array udg_KnockList
    rect udg_KnockTreeRect=Rect(.0,.0,.0,.0)
    boolexpr udg_KillTreeFilter
    real udg_PathProbeX=.0
    real udg_PathProbeY=.0
    rect gg_rct_001
    item udg_PathProbeItem
    item array udg_PathHiddenItem
    integer udg_PathHiddenCount=0
    hashtable udg_JobHeroHash
    hashtable udg_JobLevelHash
    integer udg_MusicZoneTrack=0
    integer udg_MusicSpecialTrack=0
    boolean array udg_HasLoadedCode
    integer array udg_ArmoryCodeSegment
    boolean udg_IsAutosave
    constant integer udg_MaxChatCodeLength=$79 // $79 = 121
    constant boolean udg_SaveToFileEnabled=TRUE
    constant string udg_AllowLocalFilesPath=".\\FFERPG\\"+"Allow Local Files"+".txt"
    hashtable udg_CodeCharIndex
    sound gg_snd_001
    constant integer udg_ProfIdUnarmed=$D // $D = 13
    hashtable udg_SpawnRectHash=InitHashtable()
    hashtable udg_SpawnTimerHash=InitHashtable()
    hashtable udg_SpawnDataHash=InitHashtable()
    string array udg_TravelName
    integer array udg_TravelHotkey
    boolean array udg_WarpUnlocked
    real array udg_TravelX
    real array udg_TravelY
    region array udg_TravelRegion
    button array udg_TravelButton
    effect array udg_WarpEffect
    integer udg_TravelCount
    dialog udg_WarpDialog=DialogCreate()
    integer udg_TravelPointIndex=9
    constant real udg_TextSpeedFast=300
    boolexpr udg_CinematicUnitFilter
    group udg_CinematicPausedUnits
    boolean udg_CinematicSkipped=false
    string array udg_RecipeName
    integer array udg_RecipeResult
    integer array udg_RecipeItem1
    integer array udg_RecipeItem2
    integer array udg_RecipeItem3
    integer array udg_RecipeItem4
    integer array udg_RecipeItem5
    integer array udg_RecipeItem6
    integer array udg_RecipeCharges1
    integer array udg_RecipeCharges2
    integer array udg_RecipeCount3
    integer array udg_RecipeCount4
    integer array udg_RecipeCount5
    integer array udg_RecipeCount6
    integer array udg_ElementOpposite
    integer array udg_ElementWeaknessAbil
    integer array udg_ElementResistAbil
    integer array udg_ElementImmunityAbil
    integer array udg_ElementAbsorbAbil
    integer array udg_ElementDamageAbil
    integer array udg_ElementAttackAbil
    integer array udg_ElementKnowledgeAbil
    integer array udg_ElementBoostAbil
    integer array udg_ElementSpellAmpAbil
    integer array udg_ElementOrbAmpAbil
    integer array udg_ElementBoostBuff
    integer array udg_ElementEnchantBuff
    integer array udg_ElementAilmentBuff
    integer array udg_ElementAilmentBuff2
    string array udg_IntStringCache
    integer array udg_SaveLoadBuffer
    integer udg_SaveLoadBufferMax
    trigger udg_ZoneEnterTrigger
    group udg_ZoneAliveGroup
    integer udg_CurrentZoneId
    timer udg_MissileTimer=CreateTimer()
    integer udg_MissileActiveCount=0
    integer array udg_MissileList
    boolexpr udg_MissileFilter
    real udg_MissileDamageDealt
    boolexpr udg_KillDestFilter
    rect gg_rct_002
    item udg_DummyItem
    item array udg_HiddenItem
    integer udg_HiddenItemCount=0
    unit udg_CodeInputUnit
    trigger udg_LoadCodeOwnerTrig
    trigger udg_LoadCodeSpellTrig
    string udg_LoadCodeBuffer
    integer udg_LoadCharValue
    boolean udg_LoadBracketOpened
    boolean udg_LoadHasHighBits
    unit array udg_PlayerHero
    integer udg_TempInteger2=0
    integer udg_MonsterTypeID=0
    real udg_SavedLifePercent=0
    real udg_SavedManaPercent=0
    unit udg_NewHero=null
    boolean udg_JobUnlocked=false
    string udg_JobRequirementText=""
    location udg_HeroLoc=null
    integer udg_TempInteger=0
    player udg_TempPlayer=null
    unit array udg_SpiritOfGaya
    item array udg_SavedItem
    integer udg_BoardRowIndex=0
    unit udg_Mid=null
    quest array udg_MainQuest
    unit array udg_GolemUnit
    integer array udg_PlayerKillCount
    multiboard udg_ScoreBoard=null
    player array udg_BoardPlayer
    force udg_PlayingPlayers=null
    unit udg_ZodiacStone=null
    effect array udg_SpecialEffect
    quest array udg_SideQuest
    item array udg_QuestItem
    leaderboard udg_HuntLeaderboard=null
    questitem array udg_QuestReq
    real udg_EnemyHandicap=0
    timer udg_CidResearchTimer=null
    timer udg_SharedDelayTimer1=null
    unit udg_TempUnit=null
    real udg_StoneTint=0
    unit udg_CinematicActor=null
    real udg_StoneScale=0
    real udg_AoMadoushiFacing=0
    integer array udg_ItemIdTable
    location udg_AoMadoushiLoc=null
    unit udg_TimmyUnit=null
    integer udg_TempItemId=0
    boolean udg_InCinematicMode=false
    location udg_TempPoint=null
    group udg_TempGroup=null
    effect array udg_QuestMarkerEffect
    texttag array udg_FloatingText
    string udg_TempString=""
    integer udg_SaveFlagCount=0
    questitem array udg_InfoQuestItem
    quest udg_InfoQuest=null
    string udg_ColorCyan=""
    string udg_ColorGreen=""
    unit array udg_PlayerHouse
    real udg_ExpRate=0
    integer udg_QuestsTotal=0
    integer udg_QuestsCompleted=0
    string udg_ColorOrange=""
    real udg_TalkRange=0
    integer udg_AllianceTargetSlot=0
    real udg_EnemyHpPerPlayer=0
    quest udg_DifficultyQuest=null
    rect array udg_PlayerStartRect
    real udg_AlmaSavedFacing=0
    integer array udg_TotalJobLevel
    integer udg_CurseLiar=0
    unit udg_NarratorUnit=null
    integer array udg_HighestJobLevel
    string udg_QuestNamePrefix="|cff00ffff"
    string udg_QuestTitleColor="|cffff8040"
    timer udg_KalmSiegeTimer=null
    unit array udg_CurseUnit
    integer udg_FangsRemaining=0
    group udg_HideoutGuards=null
    string array udg_PlayerColorCode
    boolean udg_AbilityTextEnabled=false
    real udg_SavedFacing=0
    timer udg_EdenTimer=null
    timerdialog udg_EdenTimerDialog=null
    integer array udg_FirePotionCount
    integer udg_GameDay=0
    integer udg_EidolonsDefeated=0
    string array udg_NewsText
    boolean array udg_StoryFlag
    unit array udg_KalmNpc
    integer udg_ExoticStonesReturned=0
    boolean udg_TempBoolean=false
    boolean udg_NewsTextAllSpaces=false
    string array udg_NewsTitle
    string array udg_NewsEntry
    boolean array udg_NewsEntryCooldown
    lightning udg_ExecutionLightning=null
    group udg_unused_group_01=null
    hashtable udg_SpawnRectHashRef=null
    hashtable udg_SpawnDataHashRef=null
    group udg_unused_group_02=null
    timer udg_VoteTimer=null
    unit udg_KeshaShop=null
    boolean array udg_QuestFlag
    integer udg_CurseStage=0
    string array udg_CurseHintLine
    lightning udg_AbsorbLightning=null
    hashtable udg_BazaarRecipeHash=null
    integer udg_MaterialTypeCount=0
    integer udg_BazaarGoodCount=0
    integer array udg_DropItemIdTable
    integer array udg_BazaarGoodItem
    integer array udg_BazaarResultItem
    integer array udg_MaterialOwnedCount
    boolean udg_RecipeAffordable=false
    integer udg_BazaarStockedCount=0
    unit udg_LastBazaarShop=null
    unit udg_SupplyShip=null
    group udg_ArenaNpcGroup=null
    timer udg_SharedDelayTimer2=null
    integer array udg_ArenaMonsterType
    unit array udg_ArenaOrganizer
    hashtable udg_GameStateHash=null
    integer udg_ArenaCupId=0
    integer udg_ArenaRound=0
    integer array udg_ArenaBracketSlot
    integer udg_ArenaPickedTeam=0
    boolean udg_ArenaCheckFlag=false
    group udg_ArenaSpawnGroup=null
    texttag array udg_ArenaTextTag
    lightning array udg_ArenaLightning
    integer array udg_CupWins
    integer udg_GuideBookSearches=0
    lightning array udg_QuDrainLightning
    location udg_QuFrogLoc=null
    unit udg_BreedPartnerChocobo=null
    integer array udg_ChocoboAbility
    unit udg_BreedTargetChocobo=null
    boolean array udg_MateriaAltarDone
    integer udg_ChocoboAbilityIndex=0
    location array udg_ChocoboDigSpot
    integer array udg_ChocoboDigItem
    integer array udg_ChocoboDigItemCharges
    location udg_ChocoboNearestDigSpot=null
    integer udg_ChocoboDigSpotIndex=0
    timer udg_SharedDelayTimer3=null
    timer udg_StoryEventTimer=null
    boolean udg_MonographDropped=false
    timer array udg_JudgeTimer
    group udg_JudgeGroup=null
    integer array udg_ZoneKillStreak
    integer array udg_ZoneStreakID
    boolean array udg_WandererSpawned
    integer array udg_WandererUnitType
    integer array udg_WandererWantedItem
    integer array udg_WandererReward
    integer udg_WandererChainCount=0
    integer array udg_LastKillZoneID
    integer udg_ArenaEscortReward=0
    integer udg_ChocoboRegionIndex=0
    integer udg_GuardiansKilled=0
    boolean array udg_AutoBrewEnabled
    group udg_NpcTrioGroup=null
    boolean array udg_QuFrogDraining
    effect array udg_QuDrainEffect
    integer udg_SpiralAngle=0
    timer udg_SharedDelayTimer4=null
    boolean udg_SceneBusy=false
    group udg_CupArenaUnits=null
    timer udg_ArenaLockTimer=null
    integer udg_ChocoboCupStage=0
    integer array udg_ArenaBracketTeam
    integer udg_ArenaSwapTemp=0
    integer udg_ArenaSwapTemp2=0
    force udg_CupArenaPlayers=null
    boolean udg_ArenaShowcaseOn=false
    integer udg_MonographCount=0
    integer array udg_RewardItem
    item udg_NoteFromCultist=null
    boolean udg_ShowDamageText=false
    unit array udg_PlayerTransport
    boolean udg_ArenaGateOpened=false
    group udg_GnollCampUnits=null
    integer udg_QuFrogDrainCount=0
    integer udg_SlotIndex=0
    boolean udg_ShipUndamaged=false
    location udg_TempPoint2=null
    integer udg_ArenaUnitsUnlocked=0
    integer udg_ArenaIntroSeen=0
    unit udg_TricksterDecoy=null
    string array udg_SpeciesName
    boolean udg_RingHintsReady=false
    item udg_SummonItem=null
    real udg_TextSpeed=0
    unit array udg_FreelancerHero
    integer array udg_AbilitySlot1
    integer array udg_AbilitySlot2
    integer array udg_AbilitySlot3
    integer array udg_AbilitySlot4
    integer array udg_JobUnitType
    force udg_ActivePlayers=null
    boolean array udg_GayaReady
    integer udg_ArenaFinalTeam=0
    unit array udg_ShrineMenuUnit
    integer array udg_JobSkill
    unit udg_TempUnit2=null
    boolean udg_BeliasArrived=false
    integer udg_ShadowLoyalty=0
    location array udg_ShadowSpawnPoint
    real array udg_ShadowSpawnFacing
    integer array udg_ShadowHireOffer
    timer udg_ShadowTimer=null
    unit udg_ShadowUnit=null
    integer udg_ShadowOfferTier=0
    force udg_ShadowLevelPool=null
    integer udg_ShadowKills=0
    integer array udg_ShadowKatana
    integer array udg_ShadowDagger
    integer array udg_ShadowHelmet
    integer array udg_ShadowArmor
    integer array udg_ShadowPotion
    string array udg_VoteOptionText
    dialog udg_VoteDialog=null
    button array udg_VoteButton
    integer udg_VotesCast=0
    real udg_VoteSum=0
    timer udg_unused_timer_01=null
    force udg_TempForce=null
    integer udg_Difficulty=0
    boolean udg_PatrolAllowed=false
    integer udg_PendingEventCount=0
    integer udg_CrystalShardCount=0
    unit udg_MementoRingHero=null
    unit udg_FluteHolder=null
    timer udg_WorldEventTimer=null
    string array udg_JobName
    integer udg_CaravanReward=0
    integer udg_ChocoboDigSpotCount=0
    real array udg_CameraDistance
    integer udg_ChocoboGreensStage=0
    item udg_NoteFromWizard=null
    unit udg_CurrentHero=null
    hashtable udg_ChannelDrainHash=null
    unit udg_StoryBoss=null
    integer udg_StatCalcValue=0
    boolean udg_PortalGuardianMet=false
    integer udg_ResearchReqLevel=0
    integer udg_StoryProgress=0
    integer array udg_DancingDaggersAbility
    integer array udg_MetaFragments
    real udg_ExpAmount=0
    real udg_ExpShareRange=0
    item udg_ShimmerweedItem=null
    item udg_ThunderbloomItem=null
    location array udg_SpiritPoint
    unit array udg_SpiritUnit
    boolean array udg_SpiritCalm
    integer array udg_SpiritWanderTick
    group udg_BossGroup=null
    boolean udg_HardcoreOff=false
    boolean udg_SuppressDeathMessages=false
    integer udg_DamageElement=0
    boolean udg_IsPhysicalAttack=false
    hashtable udg_RunicHash=null
    hashtable udg_ProxyDamageHash=null
    real udg_LastDamageDealt=0
    integer udg_TempHandleId=0
    unit udg_ProxyDamageTarget=null
    group udg_PrayingUnits=null
    group udg_PendingEffectGroup=null
    unit udg_CurrentEffectUnit=null
    location udg_RetreatPoint=null
    force udg_unused_force_01=null
    location udg_TempPoint3=null
    location udg_TempPoint4=null
    integer udg_DmgFlagUnavoidable=0
    timer array udg_RangedShotTimer
    real udg_TempReal=0
    boolean udg_DmgFlagPure=false
    timer udg_NaishaHealTimer=null
    integer array udg_MiracleStage
    unit udg_BlueGirl=null
    timer udg_BlueGirlTimer=null
    real udg_DexterityBonus=0
    boolean udg_FarmGateOpen=false
    boolean udg_GateGuardTalked=false
    timer udg_GafgarionReviveTimer=null
    group udg_GhoulGroup=null
    hashtable udg_DivineShieldHash=null
    group udg_KalmGuards=null
    group udg_BerserkGuards=null
    integer array udg_ZoneEssenceItem
    group udg_unused_group_03=null
    real udg_DmgFlagNoCrit=0
    real udg_DexterityCritMult=0
    boolean udg_IsPureDamage=false
    group udg_ArenaSummonGroup=null
    group udg_PenanceArms=null
    group udg_unused_group_04=null
    unit gg_unit_n08D_0001=null
    group udg_FarmWorkingVillagers=null
    group udg_FarmGatheredVillagers=null
    boolean udg_VillagerEffectActive=false
    string array udg_EffectModelPath
    unit udg_EnchantCycleCaster=null
    timer udg_EnchantCycleTimer=null
    group udg_ImmolationAuraGroup=null
    unit udg_NaishaUnit=null
    group udg_SplashGroup=null
    unit udg_SplashSource=null
    timer udg_SplashTimer=null
    real udg_SplashDamage=0
    location udg_TempPoint5=null
    group udg_FarmCorpses=null
    location array udg_ElementalTargetLoc
    unit array udg_ZoneBoss
    integer array udg_ElementalMoveTimer
    boolean array udg_ElementalAlive
    integer array udg_AreaSpawnUnitA
    group udg_QuestNpcUnits=null
    integer array udg_ArenaBattleOffer
    playercolor array udg_ZoneColor
    integer array udg_GolemUnitType
    integer array udg_ShivaUnitType
    integer array udg_IfritUnitType
    integer array udg_CyclopsUnitType
    hashtable udg_UnusedHash=null
    unit udg_DemiFiendUnit=null
    integer array udg_GlyphDemonType
    unit udg_DemiFiendDemon1=null
    unit udg_DemiFiendDemon2=null
    integer udg_DemiFiendDemonIndex=0
    timer udg_DemiFiendDemon1Timer=null
    timer udg_DemiFiendDemon2Timer=null
    timer udg_unused_timer_02=null
    boolean udg_DemiFiendHealed=false
    item udg_ForgeMaterialSlot=null
    texttag udg_ForgeText=null
    integer udg_CaravanStage=0
    boolean udg_PortalRitualActive=false
    unit udg_CowPortal=null
    timer udg_CowSpawnTimer=null
    integer udg_CowSpawnCount=0
    group udg_CowGroup=null
    integer array udg_MonographItem
    unit udg_BazaarShopUnit=null
    integer array udg_AreaSpawnUnitB
    integer array udg_ElementalKillStreak
    unit udg_ElementRecordUnit=null
    integer array udg_ElementRecord
    integer array udg_BombAbility
    integer array udg_ArenaMonsterItem
    real udg_ExpBase=0
    boolean udg_ExcaliburRockHidden=false
    boolean udg_DmgArmorProbe=false
    boolean udg_IgnoresReduction=false
    real udg_DmgArmorProbeResult=0
    integer udg_PlayerIndex=0
    unit udg_DodgeUnit=null
    unit udg_DodgeAttacker=null
    timer array udg_DodgeFaceTimer
    boolean array udg_GlyphActivated
    timer udg_GayaRageTimer=null
    real udg_GayaRageRadius=0
    location udg_GayaRageLoc=null
    effect udg_GayaRageEffect=null
    boolean udg_DmgFlagManaDamage=false
    boolean udg_GafgarionRevived=false
    texttag array udg_FishingText
    integer array udg_GatherState
    item array udg_GatherItem
    unit array udg_FishingControls
    timer array udg_FishingTimer
    unit array udg_PlayerFishSpot
    effect array udg_FishingBubbles
    location array udg_FishingBobberLoc
    integer array udg_FishReleaseAbil
    integer array udg_FishPullAbil
    integer array udg_FishLeftAbil
    integer array udg_FishRightAbil
    integer array udg_FishLoot
    timer udg_JobLevelTimer=null
    hashtable udg_MaxHpBuffHash=null
    group udg_BerserkGroup=null
    timer udg_MaxHpDrainTimer=null
    group udg_VirusImmuneGroup=null
    item udg_TwoHandedItem=null
    unit udg_FishedGilgamesh=null
    boolean udg_GilgameshDefeated=false
    integer udg_GilgameshGift=0
    force udg_LuShangPending=null
    integer array udg_FishMonster
    unit udg_NebraKingSpot=null
    real udg_NebraKingLife=0
    timer udg_NebraKingTimer=null
    boolean udg_SeaKingQuestStarted=false
    integer udg_GlyphDropCounter=0
    force udg_AutosaveForce=null
    force udg_AbilityTextForce=null
    force udg_TrackedPlayers=null
    real udg_DifficultyScale=0
    hashtable udg_LinkedCasterHash=null
    boolean udg_DmgFlagMelee=false
    group udg_TownNpcUnits=null
    unit udg_ArenaLeaderUnit=null
    boolean udg_DmgFlagRedirected=false
    group udg_BossUnits=null
    integer udg_GilgameshSwordStage=0
    force udg_EliminatedPlayers=null
    integer udg_BravesDefeated=0
    group udg_QuestUnits=null
    group udg_HuntMonsters=null
    string udg_ColorGold="|cffffcc00"
    timerdialog udg_SiegeTimerWindow=null
    timer udg_SiegeTimer=null
    unit udg_RangerHero=null
    unit udg_EngineerHero=null
    group udg_AllyBrothersGroup=null
    group udg_AllyRangerGroup=null
    group udg_SpecialUnits=null
    unit udg_ClericAlly=null
    unit udg_HighPriestAlly=null
    group udg_InactiveUnits=null
    group udg_RecruitedAllies=null
    integer array udg_SiegeNorthUnitType
    group udg_ShockAuraUnitGroup=null
    group udg_PrimaryQuestUnits=null
    unit udg_BladeKnightAlly=null
    group udg_SiegeSummonGroup=null
    integer udg_ArenaOrganizerLast=0
    integer udg_TrialByFireSeconds=0
    boolean udg_GhoulMasterDisabled=false
    group udg_ArenaBoundUnits=null
    group udg_SummonedUnits=null
    group udg_LivingFlameUnits=null
    unit udg_ScriptedBossUnit=null
    integer array udg_HuntCounter
    hashtable udg_HuntData=null
    integer udg_RareHuntsDone=0
    group udg_DarkEidolonGroup=null
    timer udg_ScorchedEarthTimer=null
    integer udg_JobCount=0
    group udg_DrainChannelGroup=null
    timer udg_PostReviveTimer=null
    force udg_HuntSlots=null
    destructable array udg_HiddenDest
    integer udg_HiddenDestCount=0
    group udg_DeathExplodeGroup=null
    timer udg_DeathExplodeTimer=null
    hashtable udg_HealOverTimeHash=null
    group udg_RegenGroup=null
    integer udg_CommonHuntsDone=0
    boolean udg_HardMode=false
    integer udg_DanaQuestStage=0
    unit udg_JudgeGabranth=null
    unit udg_JudgeGhis=null
    unit udg_JudgeZargabaath=null
    unit udg_JudgeDrace=null
    unit udg_JudgeBergan=null
    unit udg_BlackDevilUnit=null
    unit udg_PenanceUnit=null
    unit udg_GilgameshUnit=null
    group udg_DuelArenaUnits=null
    boolean udg_HolyAnkhUsed=false
    trigger udg_BossCleanupTrigger=null
    integer array udg_SiegeSouthUnitType
    group udg_AllyEngineerGroup=null
    boolean udg_DemonRetreated=false
    group udg_VortexVictims=null
    timer udg_VortexTimer=null
    string array udg_DiaryEntry
    integer udg_DiaryNameCount=0
    timer udg_unused_timer_03=null
    integer udg_HashmalumStage=0
    integer udg_ZodiacQuestStage=0
    boolean udg_AbilityLevelShift=false
    group udg_TentacleGroup=null
    integer udg_TentacleCount=0
    timer udg_TentacleTimer=null
    group udg_RedBeastGroup=null
    boolean udg_HellSpawnsActive=false
    unit udg_TricksterReal=null
    group udg_TargetPracticeDummies=null
    group udg_TargetsRemaining=null
    player udg_TargetPracticePlayer=null
    boolean udg_MontblancHasNews=false
    integer udg_MapRewardStage=0
    integer array udg_MapRewardTier
    timer udg_TargetPracticeTimer=null
    real udg_MapExploredPct=0
    unit udg_TalonUnit=null
    group udg_SeekerLeaders=null
    leaderboard udg_HuntFestivalBoard=null
    group udg_FestivalHunters=null
    integer array udg_FestivalScore
    timer udg_FestivalTimer=null
    timerdialog udg_FestivalTimerDialog=null
    timerdialog udg_TargetPracticeDialog=null
    real array udg_TargetRecordTime
    string array udg_TargetRecordName
    timer udg_SpiritSpawnTimer=null
    group array udg_NecroCorpseGroup
    unit udg_AlmaUnit=null
    timer udg_AlmaDisappearTimer=null
    unit udg_PossessedChieftain=null
    boolean udg_DarkJobsUnlocked=false
    group udg_DarkFactMinions=null
    integer udg_PhantomVillagersMet=0
    weathereffect array udg_SnowEffect
    integer udg_TargetPracticeAreaId=0
    integer array udg_NewGamePlusLevel
    force udg_CheaterForce=null
    force udg_unused_force_02=null
    timer udg_LoadRefreshTimer=null
    timerdialog udg_VoteTimerDialog=null
    boolean udg_CinematicsDisabled=false
    boolean udg_HashmalumEncountered=false
    integer array udg_ChronicleAbility
    integer array udg_TitleChroniclePoints
    force array udg_TitleForce
    boolean array udg_TitleStatsBlocked
    integer array udg_BonusValue
    string array udg_BonusText
    integer array udg_TitleChronicleIndex
    string array udg_TitleName
    integer udg_JobLevelTier1=0
    integer udg_HuntShopStock=0
    integer array udg_HuntRewardItem
    integer udg_DemonKillCount=0
    hashtable udg_DropItemHash=null
    unit udg_DarkFactUnit=null
    item udg_ItemUseReplacement=null
    group udg_ShemhazaiSoulClones=null
    hashtable udg_MonsterDataHash=null
    destructable gg_dest_Dofv_0001=null
    boolean udg_NashjDead=false
    integer udg_LootItemID=0
    integer udg_DropTempInt=0
    integer udg_SpiritsCleansed=0
    real udg_SecondaryXPRate=0
    boolean array udg_RingHintUsed
    group udg_ChaosElementalGroup=null
    unit udg_ChaosBoss=null
    timer udg_ShiftElementsTimer=null
    integer array udg_ElementSpellPrimary
    integer array udg_ElementSpellSecondary
    group udg_PenanceUnits=null
    timer udg_TimmyQuestTimer=null
    integer array udg_LevelItemIdTable
    boolean udg_FogDisabled=false
    timer udg_GagnrathTimer=null
    group udg_GagnrathCasters=null
    integer array udg_ArenaBonusBattle
    integer array udg_JobExtraAbility
    integer udg_ZaleraStage=0
    boolean udg_NecrophobeStarted=false
    integer udg_ArenaOwnerStreak=0
    integer udg_CidQuestStage=0
    integer array udg_BattlePoints
    integer array udg_BeltStacks
    timer udg_ArenaRoundTimer=null
    integer udg_ArenaRank=0
    unit udg_ArtifactCarrier=null
    boolean udg_MateusDefeated=false
    unit udg_GodDragonUnit=null
    group udg_MirrorCloneGroup=null
    timer udg_SharedDelayTimer6=null
    unit udg_FestivalBansat=null
    unit udg_FestivalMonica=null
    unit udg_FestivalWard=null
    unit udg_FestivalGuest=null
    player udg_FestivalWinner=null
    unit udg_NaishaTownUnit=null
    timer udg_JobChangeTimer=null
    group udg_MeteoriteRocks=null
    texttag array udg_ArenaBpTag
    integer udg_DarkFireStage=0
    boolean udg_TalonGone=false
    unit udg_EcheleBoss=null
    integer udg_EchelePhase=0
    boolean array udg_BossDefeated
    integer udg_EcheleFormsKilled=0
    timer udg_WorldFreezeTimer=null
    timerdialog udg_WorldFreezeDialog=null
    integer array udg_ZonePowerupItem
    force array udg_SaveFlagForce
    integer array udg_SaveFlagUnitID
    unit array udg_ArmoryUnit
    integer udg_ItemIndex=0
    integer udg_ArmoryStockMax=0
    integer array udg_ArmoryParentCategory
    integer array udg_ArmoryItemCount
    group udg_AbsorbShieldGroup=null
    hashtable udg_AbsorbShieldHash=null
    string array udg_HuntBoardLabel
    unit array udg_HuntTarget
    timer udg_ReviveCleanupTimer=null
    group udg_RevivedHeroes=null
    string array udg_LoreText
    timer udg_GameClock=null
    integer udg_GameHours=0
    integer udg_DropRollSeed=0
    boolean udg_SecretDigSpotRevealed=false
    string array udg_unused_string_01
    string array udg_unused_string_02
    integer array udg_unused_integer_01
    group udg_BossSummons=null
    integer array udg_ZodiacBraveType
    timer udg_EcheleMinionKillTimer=null
    group udg_EcheleMinionsToKill=null
    timer udg_DpsTimer=null
    hashtable udg_DpsHash=null
    boolean udg_DpsActive=false
    timer udg_AishaTalkTimer=null
    group udg_BagOfTricksTargets=null
    string udg_QuestTitleRed="|cffff0000"
    timer udg_ArenaCheckTimer=null
    integer udg_FadingNoteIndex=0
    timer udg_LiberationRewardTimer=null
    player udg_TargetRecordHolder=null
    group array udg_BonusGroup
    integer udg_ExodusQuestStage=0
    unit udg_Cuchulainn=null
    group udg_DarkEidolonIllusions=null
    integer array udg_OversoulKillsNeeded
    integer array udg_SpeciesKillCount
    group udg_FishingSpots=null
    group udg_MephorashClones=null
    timer udg_unused_timer_04=null
    hashtable udg_ComboHash=null
    integer udg_ShemhazaiPhase=0
    boolean udg_DanaAvailable=false
    boolean udg_ModeFlag=false
    string array udg_PlayerName
    integer udg_SelectedJobId=0
    unit udg_ShinraSpellTarget=null
    boolean udg_ShinraFinaleArmed=false
    timer udg_BazaarUpdateTimer=null
    integer array udg_MaterialSpentCount
    boolean udg_CidQuestOnHold=false
    integer array udg_VoteCount
    integer udg_TopVoteCount=0
    integer udg_WinningOption=0
    unit udg_GolemSummon=null
    unit udg_Eidolon1=null
    unit udg_Eidolon2=null
    unit udg_Eidolon3=null
    unit udg_BahamutSummon=null
    unit udg_NeoBahamutSummon=null
    unit udg_BahamutZeroSummon=null
    real udg_ManaRefundGold=0
    unit udg_ManaRefundUnit=null
    timer udg_ManaRefundTimer=null
    boolean udg_ArenaIntermission=false
    boolean udg_SpeedrunMode=false
    boolean array udg_SpeedrunFlag
    integer array udg_SubSkillSlot
    integer array udg_MainSkillSlot
    boolean udg_ShrineUnlocked=false
    unit array udg_PetUnit
    integer array udg_AnimalCompanionUnit
    integer array udg_DragonSummonUnit
    group udg_unused_group_05=null
    group udg_RengekiGroup=null
    unit udg_BossUnit=null
    integer udg_ActivePlayerCount=0
    string udg_DifficultyName=""
    unit udg_DispelTarget=null
    integer udg_FireflyDestCount=0
    group udg_UndyingGroup=null
    boolean udg_ArenaSurvivalMode=false
    boolean udg_MonographBonusDrop=false
    integer array udg_CodeDifficulty
    integer udg_RaidPowerLevel=0
    group udg_EscortUnits=null
    group udg_TownTargetGroup=null
    group udg_DarkShopGroup=null
    weathereffect udg_ElysiumWeather=null
    group udg_OblivionDummyGroup=null
    unit array udg_NpcUnit
    effect array udg_LegendMarker
    boolean udg_DarkShopsVisible=false
    group udg_SecondShrineUnits=null
    integer array udg_QuestStage
    timer udg_UnitUpdateTimer=null
    trigger array udg_LegendTrigger
    timer udg_FafnirPatrolTimer=null
    integer udg_FafnirPatrolIndex=0
    location array udg_FafnirPatrolPoint
    unit udg_Fafnir=null
    timer array udg_HerbRespawnTimer
    integer udg_KalmTechLevel=0
    integer udg_OreSuppliesRemaining=0
    integer udg_ShadowForcedSpawn=0
    force udg_DuelArenaPlayers=null
    force array udg_JobMasterForce
    hashtable udg_MolotovHash=null
    integer array udg_MolotovCooldown
    boolean udg_LegendaryUnlocked=false
    integer array udg_MasteryBonusAbility
    boolean udg_SpeedrunStarted=false
    timer udg_SharedDelayTimer5=null
    integer udg_ChocoboDigCount=0
    boolean udg_PenanceArmsActive=false
    boolean udg_GameRunning=false
    unit udg_VikingBoat=null
    group udg_HarpyTricksters=null
    unit udg_HarpyMatriarch=null
    unit udg_ShinryuUnit=null
    unit udg_WarmechUnit=null
    timer udg_DragonBattleTimer=null
    integer udg_DragonBattlePhase=0
    rect array udg_GlyphRect
    integer udg_SpellManaCost=0
    item udg_LokiReforgeItem=null
    texttag udg_LokiForgeText=null
    group udg_DarkServants=null
    integer udg_ReforgeResultType=0
    group udg_unused_group_06=null
    force udg_BattleLogForce=null
    boolean udg_EternityMode=false
    group udg_NeutralPassiveUnits=null
    group udg_RabiteAreaUnits=null
    group udg_GoliathTonicGroup=null
    integer array udg_MomentumCharges
    timer udg_MomentumTimer=null
    timer array udg_SpellCooldownTimer
    timer array udg_DodgeSaveTimer
    item udg_ChemistItem=null
    integer udg_MeteorDummyIndex=0
    integer array udg_MeteorDummyAbility
    unit udg_SpellTargetUnit=null
    unit array udg_SummonUnit
    timer udg_ShrineReselectTimer=null
    integer udg_NightmareZone=0
    unit udg_SummonedBoss=null
    player udg_SummonerPlayer=null
    player udg_ArenaSoloPlayer=null
    timer udg_AccoladeTimer=null
    force array udg_QuestForce
    integer array udg_BrewAbility
    integer array udg_EnchantAbility
    boolean udg_ArenaEliteKilled=false
    group udg_DefendingUnits=null
    group udg_RunicGroup=null
    boolean udg_LothlorienOpen=false
    item udg_ForgeGearSlot=null
    integer array udg_ForgeRecipeResult
    integer array udg_ForgeRecipeBase
    integer array udg_ForgeRecipeMaterial
    integer array udg_CelestialWeapon
    integer udg_ForgeRecipeCount=0
    timer udg_ForgeTextTimer=null
    location udg_ForgeDropPoint=null
    timer udg_ShortDelayTimer=null
    boolean udg_DmgFlagHealUndead=false
    location udg_LokiForgeSpot=null
    timer udg_LokiForgeTextTimer=null
    group udg_ValigarmandaMinions=null
    integer udg_ValigarmandaWaveIndex=0
    timer udg_ValigarmandaWaveTimer=null
    integer array udg_BlindSpotCount
    boolean udg_HandicapHPScaling=false
    unit array udg_HuntBoard
    integer array udg_HuntStock
    group udg_HuntBoardMarked=null
    effect array udg_HuntMarkerEffect
    integer array udg_SpeedrunLevel
    unit array udg_SpeedrunBoss
    real array udg_SpeedrunTimeLimit
    integer udg_SpeedrunTitleBase=0
    real array udg_AdaptElementTotal
    real udg_AdaptPhysTotal=0
    real udg_AdaptMagicTotal=0
    unit udg_OzmaBoss=null
    integer udg_OzmaBarrierTimer=0
    boolean array udg_ElementalKilledOnce
    force array udg_NullElementForce
    timer udg_StunReapplyTimer=null
    integer array udg_NullElementCount
    force array udg_WeakElementForce
    integer array udg_WeakElementCount
    unit udg_KoboldMerchant=null
    integer udg_KoboldKillCount=0
    integer array udg_MerchantPotion
    integer array udg_MerchantAccessory
    integer array udg_MerchantRod
    integer array udg_MerchantRareGear
    boolean udg_SpawnsPaused=false
    group udg_FrozenUnits=null
    group udg_WorldUnits=null
    timer udg_StatsRefreshTimer=null
    force udg_LegendaryGuardianForce=null
    integer array udg_LegendTaskAbility
    integer array udg_MagicDefense
    integer array udg_DodgeStreak
    integer udg_VerciPhaseTimer=0
    real udg_VerciPhaseLife=0
    unit udg_Vercingetorix=null
    timer array udg_AxeChargeTimer
    group udg_BurningBuildings=null
    integer udg_CookingStage=0
    real udg_NecroReleaseHealTotal=0
    timer udg_GeomancerAwardTimer=null
    real udg_SplashTally=0
    timer array udg_ArmorBreakerTimer
    real array udg_DamageTally
    real udg_FoodHealAmount=0
    integer udg_FoodBuffAbility=0
    string udg_FoodEffectString=""
    boolean udg_DeathbringerDropped=false
    group udg_ActiveHeroGroup=null
    timer udg_HeroRefreshTimer=null
    unit udg_NebraMonstrum=null
    unit array udg_MonstrumTentacle
    integer udg_MonstrumPhase=0
    real udg_MonstrumPhaseLife=0
    timer udg_StoryDelayTimer=null
    boolean udg_CrossbowAdviceGiven=false
    timer udg_ComboTimer=null
    integer udg_ComboCount=0
    unit udg_ComboUnit=null
    integer array udg_OracleMasteryCount
    timer array udg_SleepWakeTimer
    unit array udg_SleepTarget
    real array udg_InfinityAbsorbed
    integer array udg_CoverAwardCount
    boolean udg_ComboAwarded=false
    integer udg_GenjiGiftStage=0
    real udg_GolemBaseArmor=0
    real udg_ShivaBaseArmor=0
    real udg_IfritBaseArmor=0
    real udg_CyclopsBaseArmor=0
    real udg_BahamutBaseArmor=0
    real udg_BahamutZeroBaseArmor=0
    real udg_NeoBahamutBaseArmor=0
    force array udg_EidolonAwardForce
    boolean udg_DpsRefresh=false
    boolean udg_ChocoboGreensFed=false
    unit udg_PhantomDiaryUnit=null
    integer array udg_DragonKillCount
    group udg_EnduranceAwardGroup=null
    integer array udg_EnduranceManaCount
    integer array udg_EnduranceDamageCount
    integer udg_HealCreditPlayer=0
    real array udg_HealingTotal
    real array udg_BankedXP
    integer udg_UrnBossDeaths=0
    integer udg_CountedItemTotal=0
    integer array udg_CountedItemIndex
    timer udg_ElementRecordTimer=null
    boolean udg_FrakirLoreHeard=false
    player udg_JudgePlayer=null
    real udg_ArenaHpMultiplier=0
    integer udg_AbilityLevelIndex=0
    integer udg_FishCatchCount=0
    real udg_ImmortalDamage=0
    real udg_ImmortalLife=0
    timer array udg_ExpBankTimer
    boolean udg_FireCastToggle=false
    timer udg_ArenaSpawnTimer=null
    integer udg_ArenaSpawnTeam=0
    real udg_ArenaSpawnFacing=0
    location udg_ArenaSpawnLoc=null
    timer array udg_NinjaImmortalTimer
    unit udg_ImmortalUnit=null
    unit udg_ImmortalSource=null
    boolean array udg_TitlePrimaryStatOnly
    boolean array udg_ItemCounted
    item udg_WirtsLegItem=null
    integer udg_OkuuStage=0
    boolean udg_RukselHintShown=false
    boolean udg_QuestCountLocked=false
    string udg_GameModeName=""
    unit udg_MimicUnit=null
    unit udg_JinxTarget=null
    integer udg_ArenaStallTicks=0
    timer array udg_LastCritTimer
    boolean udg_SaveDebug=false
    string udg_AbilityNameMarker="!"
    string udg_ColorEnd="|r"
    timer udg_VisionShareTimer=null
    string udg_BoardLevelSeparator="/"
    string udg_BoardTitlePrefix="Final Fantasy Epic RPG 0.9.7.3 - "
    string udg_BoardTitleMid=" / "
    string udg_BoardTimeLabel=" - "
    string udg_TextUses="uses "
    sound gg_snd_BlinkTarget=null
    sound gg_snd_ChickenWhat=null
    sound gg_snd_Flare2=null
    sound gg_snd_ImpaleHit=null
    sound gg_snd_CaptainPissed=null
    sound gg_snd_DarkRangerYesAttack=null
    sound gg_snd_FootmanWhat=null
    sound gg_snd_FurionWarcry=null
    sound gg_snd_H01VillagerF27=null
    sound gg_snd_H01VillagerF42=null
    sound gg_snd_HeroTaurenChieftainYesAttack=null
    sound gg_snd_HeroPitLordWhat=null
    sound gg_snd_JainaWhat=null
    sound gg_snd_O04Mannoroth38=null
    sound gg_snd_NaishaReady=null
    sound gg_snd_NewTournament=null
    sound gg_snd_ChaosWarlordYesAttack=null
    sound gg_snd_PandarenBrewmasterReady=null
    sound gg_snd_StormPandarenBrewmasterYesAttack=null
    sound gg_snd_U08Archimonde19=null
    sound gg_snd_UtherTaunt2=null
    sound gg_snd_VillagerKidWhat=null
    sound gg_snd_VillagerKidWhat_2=null
    sound gg_snd_VillagerKidWhat_3=null
    sound gg_snd_VillagerWomanWhat=null
    sound gg_snd_VillagerWomanWhat_2=null
    sound gg_snd_VillagerManWhat=null
    sound gg_snd_VillagerMan2What=null
    sound gg_snd_VillagerMan2What_2=null
    sound gg_snd_VillagerMan2What_3=null
    sound gg_snd_InterfaceError=null
    sound gg_snd_GargoyleWhat=null
    sound gg_snd_ArtilleryExplodeDeath=null
    sound gg_snd_PandarenBrewmasterYes=null
    sound gg_snd_SargerasLaugh=null
    sound gg_snd_LoadUnload=null
    sound gg_snd_LightningBolt=null
    sound gg_snd_SargerasRoar=null
    sound gg_snd_SacrificeUnit=null
    sound gg_snd_002=null
    sound gg_snd_003=null
    sound gg_snd_HornOfCenariusSound=null
    sound gg_snd_ArrangedTeamInvitation=null
    string udg_PreludeMusic="war3mapImported\\FF7Prelude.mp3"
    sound gg_snd_004=null
    trigger gg_trg_Music_Prelude=null
    trigger gg_trg_Init_AbilityLevelShift=null
    trigger gg_trg_Init_JobTables=null
    trigger gg_trg_Init_PlayerForces=null
    trigger gg_trg_Init_PlayerColors=null
    trigger gg_trg_Init_RevealStartArea=null
    trigger gg_trg_Init_HideScoreScreen=null
    trigger gg_trg_Init_NeutralPlayer8=null
    trigger gg_trg_Init_AllyPlayer9=null
    trigger gg_trg_Init_AllyPlayer10=null
    trigger gg_trg_Init_RemoveGuards=null
    trigger gg_trg_Init_FoodCap=null
    trigger gg_trg_Init_EnemyUpgrades=null
    trigger gg_trg_Init_InvulnerableGates=null
    trigger gg_trg_Init_TimeOfDay=null
    trigger gg_trg_Init_LockTrading=null
    trigger gg_trg_Init_HideUiAbilities=null
    trigger gg_trg_Speedrun_Announce=null
    trigger gg_trg_Speedrun_FirstCast=null
    trigger gg_trg_Init_InfoQuest=null
    trigger gg_trg_Init_QuestLog=null
    trigger gg_trg_Preload_HeroChronicles=null
    trigger gg_trg_Preload_DrinkPowerup=null
    trigger gg_trg_Preload_AgiAttackSpeed=null
    trigger gg_trg_Preload_JobUnits=null
    trigger gg_trg_Intro_LockPlayers=null
    trigger gg_trg_Intro_StartGameModeVote=null
    trigger gg_trg_Intro_WelcomeMessages=null
    trigger gg_trg_Reminder_Periodic=null
    trigger gg_trg_Intro_FadeToBlack=null
    trigger gg_trg_Init_VoteOptionText=null
    trigger gg_trg_Vote_TextSpeed_Show=null
    trigger gg_trg_Vote_TextSpeed_Click=null
    trigger gg_trg_Vote_TextSpeed_Result=null
    trigger gg_trg_Vote_Difficulty_Show=null
    trigger gg_trg_Vote_Difficulty_Click=null
    trigger gg_trg_Vote_Difficulty_Result=null
    trigger gg_trg_Vote_GameMode_Show=null
    trigger gg_trg_Vote_GameMode_Click=null
    trigger gg_trg_GameMode_Apply=null
    trigger gg_trg_Game_Start=null
    trigger gg_trg_Player_Init=null
    trigger gg_trg_Spirit_Create=null
    trigger gg_trg_Job_Change=null
    trigger gg_trg_Freelancer_Stats=null
    trigger gg_trg_JobLevels_Update=null
    trigger gg_trg_JobLevels_Init=null
    trigger gg_trg_Shrine_Create=null
    trigger gg_trg_Shrine_AbilitySwap=null
    trigger gg_trg_Shrine_SelectEnable=null
    trigger gg_trg_Shrine_SelectMenu=null
    trigger gg_trg_Shrine_Unlock=null
    trigger gg_trg_Shrine_Reveal=null
    trigger gg_trg_Legendary_Unlock=null
    trigger gg_trg_DarkJobs_Unlock=null
    trigger gg_trg_DarkJobs_Reveal=null
    trigger gg_trg_Weapon_Research=null
    trigger gg_trg_Stats_RefreshOnEvent=null
    trigger gg_trg_Passive_Bonus_Sync=null
    trigger gg_trg_AttackSpeed_Update=null
    trigger gg_trg_MagicDefense_Calc=null
    trigger gg_trg_Unit_ApplyUpgradeBonuses=null
    trigger gg_trg_Titles_Init=null
    trigger gg_trg_Title_Grant=null
    trigger gg_trg_Title_UnlockEffects=null
    trigger gg_trg_Title_ApplyStats=null
    trigger gg_trg_Titles_CheckAll=null
    trigger gg_trg_Title_ArmsCollection=null
    trigger gg_trg_Titles_CheckBasic=null
    trigger gg_trg_Title_JuniorAdventurer=null
    trigger gg_trg_Title_RumoredAdventurer=null
    trigger gg_trg_Title_SeniorAdventurer=null
    trigger gg_trg_Title_HeroicSpirit=null
    trigger gg_trg_Summon_Detect=null
    trigger gg_trg_Summon_Powerup=null
    trigger gg_trg_GameLoad_RestoreTitles=null
    trigger gg_trg_Debug_ImmortalDeath=null
    trigger gg_trg_Damage_Init=null
    trigger gg_trg_Damage_RegisterEnter=null
    trigger gg_trg_Damage_RegisterAttacked=null
    trigger gg_trg_Damage_Engine=null
    trigger gg_trg_Damage_ProxyCleanup=null
    trigger gg_trg_Damage_Splash=null
    trigger gg_trg_Dps_Start=null
    trigger gg_trg_Dps_Tick=null
    trigger gg_trg_Combo_CancelOnAttack=null
    trigger gg_trg_Combo_CancelOnCast=null
    trigger udg_AbilityTextTrigger=null
    trigger udg_BattleLogTrigger=null
    trigger gg_trg_Status_AutoCleanse=null
    trigger gg_trg_MaxHp_DrainTick=null
    trigger gg_trg_Death_Watch_Group1=null
    trigger gg_trg_Death_Watch_Group2=null
    trigger gg_trg_Death_Watch_Group3=null
    trigger gg_trg_Hour_Timer_Rollover=null
    trigger gg_trg_Hero_Death_Revive=null
    trigger gg_trg_Revive_Item_Cleanup=null
    trigger gg_trg_Dead_Hero_Item_Drop=null
    trigger gg_trg_Job_XP_Handicap=null
    trigger gg_trg_Exp_Distribution=null
    trigger gg_trg_Hero_Order_Cooldown=null
    trigger gg_trg_Research_Requirements=null
    trigger gg_trg_Gold_Cap=null
    trigger gg_trg_Lumber_Cap=null
    trigger gg_trg_Patrol_Disabled=null
    trigger gg_trg_House_Options_Switch=null
    trigger gg_trg_Quest_Log_Update=null
    trigger gg_trg_Help_Unit_Sold=null
    trigger gg_trg_Help_Unit_Death_Drop=null
    trigger gg_trg_Zone7_Leash=null
    trigger gg_trg_Zone6_Leash=null
    trigger gg_trg_Zone1_Leash=null
    trigger gg_trg_Zone4_Leash=null
    trigger gg_trg_Zone4_Leash_North=null
    trigger gg_trg_Zone4_Leash_Mid=null
    trigger gg_trg_Zone6_Leash_West=null
    trigger gg_trg_Arena_Leash=null
    trigger gg_trg_Buy_Kesha_Brew=null
    trigger gg_trg_Rabbit_Wander=null
    trigger gg_trg_Player_Leaves_Game=null
    trigger gg_trg_Stop_Friendly_Attack=null
    trigger gg_trg_Elements_Init=null
    trigger gg_trg_Shift_Elements_Start=null
    trigger gg_trg_Shift_Elements_Roll=null
    trigger gg_trg_Speedrun_Accolade=null
    trigger gg_trg_Speedrun_Record=null
    trigger gg_trg_Lumber_Harvest_Start=null
    trigger gg_trg_Statue_Keeper_Anim=null
    trigger gg_trg_Statue_Guardian_Anim=null
    trigger gg_trg_Weather_Snow_Init=null
    trigger udg_WarpEnterTrigger=null
    trigger gg_trg_Travel_Dialog_Click=null
    trigger gg_trg_Zone_Rects_Init=null
    trigger gg_trg_Spawn_Pools_Init=null
    trigger gg_trg_Zone_Spawn_System=null
    trigger gg_trg_Zone8_Heal_Assist=null
    trigger gg_trg_Enemy_Summon_Setup=null
    trigger gg_trg_MonsterData_Init_1=null
    trigger gg_trg_MonsterData_Init_2=null
    trigger gg_trg_MonsterData_Init_3=null
    trigger gg_trg_MonsterData_Init_4=null
    trigger gg_trg_Loot_MonsterDrop=null
    trigger gg_trg_Loot_CancelDespawn=null
    trigger gg_trg_Loot_Tables_Init=null
    trigger gg_trg_Loot_EssenceDrop=null
    trigger gg_trg_Oversoul_Tables_Init=null
    trigger gg_trg_Oversoul_OnMonsterDeath=null
    trigger gg_trg_Oversoul_Activate=null
    trigger gg_trg_Merchant_Stock_Init=null
    trigger gg_trg_Merchant_Spawn_Night=null
    trigger gg_trg_Merchant_Reveal=null
    trigger gg_trg_Merchant_Leave_Dawn=null
    trigger gg_trg_Merchant_Leave_OnSale=null
    trigger gg_trg_Merchant_Stock_Shrink=null
    trigger gg_trg_Loot_BlockLeaverItems=null
    trigger gg_trg_Equip_Restrictions=null
    trigger gg_trg_Block_Item_Destroy=null
    trigger gg_trg_Armory_Item_List=null
    trigger gg_trg_Armory_Item_Hash=null
    trigger udg_unused_trigger_01=null
    trigger udg_CurseItemTrigger=null
    trigger gg_trg_Craft_Recipe=null
    trigger gg_trg_Herb_Spawn_Start=null
    trigger gg_trg_Shimmerweed_Spawn=null
    trigger gg_trg_Shimmerweed_Pickup=null
    trigger gg_trg_Thunderbloom_Spawn=null
    trigger gg_trg_Thunderbloom_Pickup=null
    trigger gg_trg_Item_Stack_Order=null
    trigger gg_trg_Item_Stack_Pickup=null
    trigger gg_trg_Armory_Init=null
    trigger gg_trg_Armory_Open=null
    trigger gg_trg_Armory_Select=null
    trigger gg_trg_Armory_Back=null
    trigger gg_trg_Armory_Closed=null
    trigger gg_trg_Armory_Store_Item=null
    trigger gg_trg_Potion_Use=null
    trigger gg_trg_HeroDrink_Cast=null
    trigger gg_trg_Toss_Potion=null
    trigger gg_trg_Toss_HeroDrink=null
    trigger gg_trg_Remedy_Use=null
    trigger gg_trg_Food_Effects=null
    trigger gg_trg_Auto_Potion_AI=null
    trigger gg_trg_Gold_Pickup=null
    trigger gg_trg_Gold_Share_Pickup=null
    trigger gg_trg_Rune_Pickup=null
    trigger gg_trg_Monograph_Drop=null
    trigger gg_trg_Item_Cooldown_Start=null
    trigger gg_trg_Hero_Medicine_Pickup=null
    trigger gg_trg_HeroMedicine_Refill=null
    trigger gg_trg_HeroMedicine_Pickup=null
    trigger gg_trg_Cloak_Equip=null
    trigger gg_trg_Cloak_UpdateStats=null
    trigger gg_trg_Cloak_Drop=null
    trigger gg_trg_ExcaliburII_HideRock=null
    trigger gg_trg_ExcaliburII_ShowRock=null
    trigger gg_trg_ExcaliburII_Drop=null
    trigger gg_trg_MagicVault_Dim=null
    trigger gg_trg_MagicVault_Death=null
    trigger gg_trg_Book_TransformGem=null
    trigger gg_trg_ManaRefund_Cast=null
    trigger gg_trg_Recharge_OnKill=null
    trigger gg_trg_LionHeart_LowLifeBonus=null
    trigger gg_trg_Angbar_Pickup=null
    trigger gg_trg_Angbar_Drop=null
    trigger gg_trg_MetaFragment_Pickup=null
    trigger gg_trg_Masakados_Drop=null
    trigger gg_trg_BagOfTricks_Setup=null
    trigger gg_trg_BagOfTricks_Progress=null
    trigger gg_trg_Firefly_Drops=null
    trigger gg_trg_Firefly_Redeem=null
    trigger gg_trg_Deathbringer_Warning=null
    trigger gg_trg_Gaya_Follow=null
    trigger gg_trg_Transport_HeroLoaded=null
    trigger gg_trg_Gaya_ChannelStart=null
    trigger gg_trg_Gaya_ChannelEnd=null
    trigger gg_trg_Gaya_SetTint=null
    trigger gg_trg_Gaya_ShopPurchase=null
    trigger gg_trg_Gaya_RefreshStats=null
    trigger gg_trg_Gaya_ItemChanged=null
    trigger gg_trg_Gaya_HousePortal=null
    trigger gg_trg_Gaya_BreakStun=null
    trigger gg_trg_Gaya_ManaTransfer=null
    trigger gg_trg_Gaya_MegaHeal=null
    trigger gg_trg_Gaya_GatherItems=null
    trigger gg_trg_Gaya_OrderImmediate=null
    trigger gg_trg_Gaya_OrderPoint=null
    trigger gg_trg_Gaya_OrderTarget=null
    trigger gg_trg_Cam_Command=null
    trigger gg_trg_TextSpeed_Command=null
    trigger gg_trg_Claim_Command=null
    trigger gg_trg_MagDef_Command=null
    trigger gg_trg_AtkSpd_Command=null
    trigger gg_trg_Roll_Command=null
    trigger gg_trg_TextInstant_Command=null
    trigger gg_trg_TextSkip_Command=null
    trigger gg_trg_Suicide_Command=null
    trigger gg_trg_SaveDebug_Command=null
    trigger gg_trg_Levels_Command=null
    trigger gg_trg_Handicap_Command=null
    trigger gg_trg_Teleporters_Command=null
    trigger gg_trg_Unstuck_Command=null
    trigger gg_trg_Autosave_Command=null
    trigger gg_trg_Battlelog_Command=null
    trigger gg_trg_AbilityText_Command=null
    trigger gg_trg_DamageText_Command=null
    trigger gg_trg_Clear_Command=null
    trigger gg_trg_Pvp_Command=null
    trigger gg_trg_Number_Command=null
    trigger gg_trg_War_Command=null
    trigger gg_trg_Peace_Command=null
    trigger gg_trg_Chemist_TakeItem=null
    trigger gg_trg_Chemist_Pharmacology=null
    trigger gg_trg_Chemist_LearnAlchemy=null
    trigger gg_trg_Chemist_Brew=null
    trigger gg_trg_Chemist_NoxiousMixture=null
    trigger gg_trg_Chemist_Molotov=null
    trigger gg_trg_Molotov_DamageOnAttack=null
    trigger gg_trg_Goliath_Tonic=null
    trigger gg_trg_Spell_Tables_Init=null
    trigger gg_trg_Cooldown_Scaling=null
    trigger gg_trg_Bio_Cast=null
    trigger gg_trg_Ultima_Cast=null
    trigger gg_trg_Death_Explosion_Queue=null
    trigger gg_trg_Death_Explosion_Start=null
    trigger gg_trg_Death_Explosion_Blast=null
    trigger gg_trg_Teleport_Spell=null
    trigger gg_trg_Mana_Restore_Delayed=null
    trigger gg_trg_Dispel_Cast=null
    trigger gg_trg_Remove_Debuffs=null
    trigger gg_trg_Remove_Buffs=null
    trigger gg_trg_Dismantle_Cast=null
    trigger gg_trg_Wirts_Leg_Club=null
    trigger gg_trg_Auto_Crossbow_Volley=null
    trigger gg_trg_Mechanical_Drill=null
    trigger gg_trg_Chainsaw_Saw=null
    trigger gg_trg_Momentum_Cast=null
    trigger gg_trg_Momentum_Apply=null
    trigger gg_trg_Momentum_Decay=null
    trigger gg_trg_Defend_Toggle=null
    trigger gg_trg_Knot_Of_Rust=null
    trigger gg_trg_Cover_Cast=null
    trigger gg_trg_Accumulate_Cast=null
    trigger gg_trg_Sentinel_Cast=null
    trigger gg_trg_Armor_Breaker=null
    trigger gg_trg_Runic_Shield=null
    trigger gg_trg_Shock_Cast=null
    trigger gg_trg_Assault_Cast=null
    trigger gg_trg_Arrowwave_Cast=null
    trigger gg_trg_Animal_Companion=null
    trigger gg_trg_Aim_Cast=null
    trigger gg_trg_Myriad_Arrows=null
    trigger gg_trg_Mana_Spring_Register=null
    trigger gg_trg_Fire_Cast=null
    trigger gg_trg_Ice_Cast=null
    trigger gg_trg_Tornado_Cast=null
    trigger gg_trg_Esuna_Cast=null
    trigger gg_trg_Regen_Cast=null
    trigger gg_trg_Protect_Cast=null
    trigger gg_trg_Shell_Cast=null
    trigger gg_trg_Shell_AI_Cast=null
    trigger gg_trg_Virus_Cast=null
    trigger gg_trg_Haste_Slow_Cast=null
    trigger gg_trg_Meteor_Cast=null
    trigger gg_trg_Immobilize_Cast=null
    trigger gg_trg_Quick_Cast=null
    trigger gg_trg_Wave_Fist=null
    trigger gg_trg_Chakra_Cast=null
    trigger gg_trg_Rave_Kick=null
    trigger gg_trg_Inner_Fire=null
    trigger gg_trg_Steal_Cast=null
    trigger gg_trg_Fan_Of_Knives=null
    trigger gg_trg_Stealth_Break_OnAttack=null
    trigger gg_trg_Evade_Counter_Cost=null
    trigger gg_trg_Evade_Counter_Decay=null
    trigger gg_trg_Counter_Attack_Strike=null
    trigger gg_trg_Evade_Counter_Reset_P1=null
    trigger gg_trg_Evade_Counter_Reset_P2=null
    trigger gg_trg_Evade_Counter_Reset_P3=null
    trigger gg_trg_Evade_Counter_Reset_P4=null
    trigger gg_trg_Evade_Counter_Reset_P5=null
    trigger gg_trg_Evade_Counter_Reset_P6=null
    trigger gg_trg_Evade_Counter_Reset_P7=null
    trigger gg_trg_Evade_Counter_Reset_P8=null
    trigger gg_trg_Transfusion_Cast=null
    trigger gg_trg_Living_Wall=null
    trigger gg_trg_Shiva_DiamondDust=null
    trigger gg_trg_Ifrit_Hellfire=null
    trigger gg_trg_Cyclops_FinalSmash=null
    trigger gg_trg_Bahamut_MegaFlare=null
    trigger gg_trg_Summon_Transfusion_Consume=null
    trigger gg_trg_Summon_Death_Cleanup=null
    trigger gg_trg_Lancer_DragonBreath=null
    trigger gg_trg_Lancer_DragonSlam=null
    trigger gg_trg_Lancer_DragonAlly=null
    trigger gg_trg_Lancer_Jump_RangeCheck=null
    trigger gg_trg_Lancer_Jump=null
    trigger gg_trg_Geomancer_Enchant_Cycle=null
    trigger gg_trg_Geomancer_Enchant_Apply=null
    trigger gg_trg_Geomancer_Enchant_ClearBuffs=null
    trigger gg_trg_Geomancer_GayaRage=null
    trigger gg_trg_Mediator_Clone_Reject=null
    trigger gg_trg_Mediator_Clone=null
    trigger gg_trg_Mediator_SpellShot=null
    trigger gg_trg_Mediator_Invitation=null
    trigger gg_trg_Mediator_Balance=null
    trigger gg_trg_Mediator_MarkForDeath=null
    trigger gg_trg_Oracle_Jinx=null
    trigger gg_trg_Bravery_Caster_Cleanup=null
    trigger gg_trg_Oracle_Blind=null
    trigger gg_trg_Bravery_Target_Cleanup=null
    trigger gg_trg_Faith_Target_Cleanup=null
    trigger gg_trg_Oracle_PredictStrength=null
    trigger gg_trg_Oracle_PredictMagic=null
    trigger gg_trg_Oracle_Scourge=null
    trigger gg_trg_Oracle_NeoBahamut=null
    trigger gg_trg_Samurai_Mineuchi=null
    trigger gg_trg_Samurai_Renzokuken=null
    trigger gg_trg_Samurai_Iainuki=null
    trigger gg_trg_Ninja_Ambush=null
    trigger gg_trg_BattleWard_Enter=null
    trigger gg_trg_BattleWard_Death=null
    trigger gg_trg_Ninja_Rage_ClearBuffs=null
    trigger gg_trg_Ninja_Trance=null
    trigger gg_trg_Calculator_Firaga=null
    trigger gg_trg_Calculator_Thundaga=null
    trigger gg_trg_Calculator_Imperil=null
    trigger gg_trg_Prophet_Pray_Start=null
    trigger gg_trg_Prophet_Pray_Stop=null
    trigger gg_trg_Prophet_Pray_Tick=null
    trigger gg_trg_Prophet_Pray_Heal=null
    trigger gg_trg_Prophet_BlessingOfLight=null
    trigger gg_trg_Prophet_DivineShield=null
    trigger gg_trg_Prophet_Infinity=null
    trigger gg_trg_TwoHanded_Check=null
    trigger gg_trg_Heal_Spell_Apply=null
    trigger gg_trg_HolySwordsman_Eclipse=null
    trigger gg_trg_HolySwordsman_Finisher=null
    trigger gg_trg_HolyPower_Mastery_Track=null
    trigger gg_trg_HolyPower_Mastery_Start=null
    trigger gg_trg_Sleep_Cast=null
    trigger gg_trg_Sorcerer_Flare=null
    trigger gg_trg_Sorcerer_Holy=null
    trigger gg_trg_Sorcerer_MassCripple=null
    trigger gg_trg_Sorcerer_BahamutZero=null
    trigger gg_trg_Darkness_LowHP_Cancel=null
    trigger gg_trg_Darkness_Cast=null
    trigger gg_trg_MinusStrike_Cast=null
    trigger gg_trg_DrainAttack_LevelSync=null
    trigger gg_trg_Necro_RaiseDead_Reset=null
    trigger gg_trg_Necro_Release=null
    trigger gg_trg_Necro_DeathScreech=null
    trigger gg_trg_Necro_Drain_Start=null
    trigger gg_trg_Necro_Drain_End=null
    trigger gg_trg_Necro_Drain_Tick=null
    trigger gg_trg_Osmose_Cancel_NoMP=null
    trigger gg_trg_Osmose_Cast=null
    trigger gg_trg_Oblivion_Cast=null
    trigger gg_trg_Oblivion_Pulse_Start=null
    trigger gg_trg_Oblivion_Pulse=null
    trigger gg_trg_Oblivion_Dummy_Death=null
    trigger gg_trg_Regen_Periodic=null
    trigger gg_trg_Blizzard_Cast=null
    trigger gg_trg_Aqualung_Cast=null
    trigger gg_trg_Gust_Cast=null
    trigger gg_trg_Tremor_Cast=null
    trigger gg_trg_EarthSmash_Cast=null
    trigger gg_trg_ShockSmash_Cast=null
    trigger gg_trg_Manablow_Cast=null
    trigger gg_trg_Berserk_RemoveBuffs=null
    trigger gg_trg_Devour_Absorb=null
    trigger gg_trg_EveryonesGrudge_Cast=null
    trigger gg_trg_Needles_Cast=null
    trigger gg_trg_Needles_99999_Cast=null
    trigger gg_trg_Cactuar_Haste_Cast=null
    trigger gg_trg_BadBreath_Cast=null
    trigger gg_trg_FireUnit_Enter=null
    trigger gg_trg_FireUnit_Death=null
    trigger gg_trg_FireAura_Pulse_Start=null
    trigger gg_trg_FireAura_Pulse=null
    trigger gg_trg_ShockAura_Pulse_Start=null
    trigger gg_trg_ShockAura_Pulse=null
    trigger gg_trg_Chocobo_Init=null
    trigger gg_trg_Chocobo_Spawn_Periodic=null
    trigger gg_trg_Chocobo_Wild_Death=null
    trigger gg_trg_Chocobo_Tame_Limit=null
    trigger gg_trg_Chocobo_Tame_Breed=null
    trigger gg_trg_Chocobo_Wild_Retaliate=null
    trigger gg_trg_Chocobo_Breed_Score=null
    trigger gg_trg_Chocobo_DeadPepper_Dig=null
    trigger gg_trg_Chocobo_Gysahl_Upgrade=null
    trigger gg_trg_Chocobo_Mimett_Upgrade=null
    trigger gg_trg_Chocobo_Silkis_Upgrade=null
    trigger gg_trg_Chocobo_DigSpot_Nearest=null
    trigger gg_trg_Chocobo_Bribe=null
    trigger gg_trg_Chocobo_Defend_Upgrade=null
    trigger gg_trg_Chocobo_Wild_AI=null
    trigger gg_trg_Kalm_News_Init=null
    trigger gg_trg_Kalm_News_Read=null
    trigger gg_trg_News_Morning=null
    trigger gg_trg_News_Evening=null
    trigger gg_trg_Sale_MithrilSword=null
    trigger gg_trg_Sale_MithrilAxe=null
    trigger gg_trg_Sale_MithrilShield=null
    trigger gg_trg_Sale_MithrilMail=null
    trigger gg_trg_Sale_MithrilHelmet=null
    trigger gg_trg_Sale_Nectar=null
    trigger gg_trg_News_SetTitle=null
    trigger gg_trg_News_SetEntry=null
    trigger gg_trg_News_SubmitEntry=null
    trigger gg_trg_Shadow_Init=null
    trigger gg_trg_Shadow_FirstAppear=null
    trigger gg_trg_Shadow_Intro=null
    trigger gg_trg_Shadow_Respawn=null
    trigger gg_trg_Shadow_Leave=null
    trigger gg_trg_Shadow_NearbyDelay=null
    trigger gg_trg_Shadow_Hire=null
    trigger gg_trg_Shadow_Death=null
    trigger gg_trg_Shadow_LoyaltyTick=null
    trigger gg_trg_Shadow_KillCount=null
    trigger gg_trg_Shadow_AttackedByParty=null
    trigger gg_trg_Shadow_HealedBonus=null
    trigger gg_trg_Shadow_HeroDrink=null
    trigger gg_trg_Shadow_Disband=null
    trigger gg_trg_Shadow_FumaShuriken=null
    trigger gg_trg_Arena_FreezeNpcs=null
    trigger gg_trg_Arena_Unlock=null
    trigger gg_trg_Arena_LeoIntro=null
    trigger gg_trg_Arena_InitData=null
    trigger gg_trg_Arena_TeamData1=null
    trigger gg_trg_Arena_TeamData2=null
    trigger gg_trg_Arena_Team_Data_A=null
    trigger gg_trg_Arena_Team_Data_B=null
    trigger gg_trg_Arena_Unit_Data=null
    trigger gg_trg_Arena_Lock_Controls=null
    trigger gg_trg_Arena_Enter_Region=null
    trigger gg_trg_Arena_Start_Cup=null
    trigger gg_trg_Arena_Pick_Team=null
    trigger gg_trg_Arena_Round_Start=null
    trigger gg_trg_Arena_Spawn_Team=null
    trigger gg_trg_Arena_Round_End=null
    trigger gg_trg_Arena_Cup_Won=null
    trigger gg_trg_Arena_UnlockCups=null
    trigger gg_trg_Arena_SyncTeams=null
    trigger gg_trg_Arena_StartBattle=null
    trigger gg_trg_Arena_FoeDeath=null
    trigger gg_trg_Arena_PlayerLeft=null
    trigger gg_trg_Arena_BattleLost=null
    trigger gg_trg_Arena_BuyPrize=null
    trigger gg_trg_Arena_OutOfBounds=null
    trigger gg_trg_Arena_GateWrongSide=null
    trigger gg_trg_Arena_GateOpen=null
    trigger gg_trg_Teleport_ToKalm=null
    trigger gg_trg_Teleport_ToArena=null
    trigger gg_trg_Arena_ToggleShowcase=null
    trigger gg_trg_Arena_ToggleCupMode=null
    trigger gg_trg_Arena_ExchangeBP=null
    trigger gg_trg_Arena_RefreshBPTags=null
    trigger gg_trg_Valfodr_SummonSetup=null
    trigger gg_trg_Valfodr_Gagnrath=null
    trigger gg_trg_Valfodr_GagnrathEnd=null
    trigger gg_trg_Valfodr_GagnrathPulse=null
    trigger gg_trg_Valfodr_GagnrathWave=null
    trigger gg_trg_Valfodr_Bolverk=null
    trigger gg_trg_Numerus_ChargeCommand=null
    trigger gg_trg_FadingNotes_Init=null
    trigger gg_trg_FadingNotes_DropCultist=null
    trigger gg_trg_FadingNotes_DropWizard=null
    trigger gg_trg_Bazaar_Init=null
    trigger gg_trg_Bazaar_Recipes=null
    trigger gg_trg_Bazaar_PawnMaterial=null
    trigger gg_trg_Bazaar_UpdateStock=null
    trigger gg_trg_Bazaar_Sell_Bundle=null
    trigger gg_trg_DeathSeeker_Give=null
    trigger gg_trg_Materia_Altar_Ritual=null
    trigger gg_trg_Hunt_Setup=null
    trigger gg_trg_Hunt_Board_Markers=null
    trigger gg_trg_Hunt_Accept=null
    trigger gg_trg_Hunt_Complete=null
    trigger gg_trg_Hunt_Shop_Unlock=null
    trigger gg_trg_Makenroh_Greet=null
    trigger gg_trg_Hunt_Thextera_Escort=null
    trigger gg_trg_Hunt_Shard_Register=null
    trigger gg_trg_Hunt_Shard_Drop=null
    trigger gg_trg_Hunt_Tonberry_Setup=null
    trigger gg_trg_Tonberry_Gate_Open=null
    trigger gg_trg_Hunt_Demon_Setup=null
    trigger gg_trg_Demon_Drop_Magatama=null
    trigger gg_trg_Provoke_Cast=null
    trigger gg_trg_Hunt_Parvati_Setup=null
    trigger gg_trg_Malboro_BadBreath=null
    trigger gg_trg_Hunt_PhantomDancer_Setup=null
    trigger gg_trg_PhantomDancer_Blink=null
    trigger gg_trg_PhantomDancer_Berserk=null
    trigger gg_trg_Hunt_Exdeath_Setup=null
    trigger gg_trg_Exdeath_Drop_Scroll=null
    trigger gg_trg_Hunt_Mephorash_Setup=null
    trigger gg_trg_Mephorash_Split=null
    trigger gg_trg_Mephorash_Clone_Death=null
    trigger gg_trg_Vendetta_Stance=null
    trigger gg_trg_Vendetta_Release=null
    trigger gg_trg_Vendetta_Cancel=null
    trigger gg_trg_Hunt_Trickster_Unlock=null
    trigger gg_trg_Trickster_Decoy_Spawn=null
    trigger gg_trg_Trickster_Reveal=null
    trigger gg_trg_Hunt_Melaiduma_Setup=null
    trigger gg_trg_Melaiduma_Death=null
    trigger gg_trg_ThunderRush_Cast=null
    trigger gg_trg_ThunderRush_Cleanup=null
    trigger gg_trg_Vortex_Warning=null
    trigger gg_trg_Vortex_Suck=null
    trigger gg_trg_Vortex_Drain=null
    trigger gg_trg_Chocobo_Respawn=null
    trigger gg_trg_Chocobo_Drop_Nut=null
    trigger gg_trg_Hunt_BlackPearl_Setup=null
    trigger gg_trg_GatherServants_Cast=null
    trigger gg_trg_DarkServant_Cleanup=null
    trigger gg_trg_BlackPearl_Death=null
    trigger gg_trg_Rabite_Area_Init=null
    trigger gg_trg_Rabite_Hunt_Unlock=null
    trigger gg_trg_Hunt_Rabite_Setup=null
    trigger gg_trg_Rabite_Death=null
    trigger gg_trg_Hunt_Verci_Setup=null
    trigger gg_trg_Verci_Awaken=null
    trigger gg_trg_Verci_Phases=null
    trigger gg_trg_WindShear_Cast=null
    trigger gg_trg_Spartacus_Summon=null
    trigger gg_trg_Verci_Death=null
    trigger gg_trg_Hunt_Okuu_Setup=null
    trigger gg_trg_Okuu_Leash=null
    trigger gg_trg_Hypernova_Cast=null
    trigger gg_trg_Okuu_Death=null
    trigger gg_trg_Fishing_Pole_Found=null
    trigger gg_trg_Fishing_Unlock=null
    trigger gg_trg_Fishing_Cast=null
    trigger gg_trg_Fishing_Tick=null
    trigger gg_trg_Fishing_Input=null
    trigger gg_trg_Fishing_Catch=null
    trigger gg_trg_Fishing_End=null
    trigger gg_trg_Gilgamesh_Gift=null
    trigger gg_trg_Fishing_Monster_Spawn=null
    trigger gg_trg_AbilityTags_Show=null
    trigger gg_trg_Hero_Select_Redirect=null
    trigger gg_trg_PlayerTimer1_Expire=null
    trigger gg_trg_PlayerTimer2_Expire=null
    trigger gg_trg_PlayerTimer3_Expire=null
    trigger gg_trg_PlayerTimer4_Expire=null
    trigger gg_trg_PlayerTimer5_Expire=null
    trigger gg_trg_PlayerTimer6_Expire=null
    trigger gg_trg_PlayerTimer7_Expire=null
    trigger gg_trg_PlayerTimer8_Expire=null
    trigger gg_trg_DarkEidolons_Init=null
    trigger gg_trg_DarkEidolons_SpawnGhosts=null
    trigger gg_trg_DarkEidolons_Unlock=null
    trigger gg_trg_DarkEidolon_Death=null
    trigger gg_trg_DarkShiva_Appear=null
    trigger gg_trg_DarkShiva_Phase2=null
    trigger gg_trg_DarkShiva_Death=null
    trigger gg_trg_DarkIfrit_Appear=null
    trigger gg_trg_DarkIfrit_Death=null
    trigger gg_trg_DarkGolem_Appear=null
    trigger gg_trg_DarkCyclops_Appear=null
    trigger gg_trg_DarkTitan_Appear=null
    trigger gg_trg_DarkBahamut_Riddle=null
    trigger gg_trg_DarkBahamut_DragonDeath=null
    trigger gg_trg_DarkBahamut_Phase2=null
    trigger gg_trg_DarkBahamut_Phase3=null
    trigger gg_trg_DarkBahamut_Phase4=null
    trigger gg_trg_DarkLeviathan_Appear=null
    trigger gg_trg_DarkQuezacotl_Appear=null
    trigger gg_trg_DarkQuezacotl_Death=null
    trigger gg_trg_DarkPhoenix_Appear=null
    trigger gg_trg_DarkPhoenix_Death=null
    trigger gg_trg_DarkBrothers_Appear=null
    trigger gg_trg_DarkEden_Appear=null
    trigger gg_trg_DarkEden_Death=null
    trigger gg_trg_DarkEden_LightningColor=null
    trigger gg_trg_Init_SkyAndSubtitles=null
    trigger gg_trg_QuestUnits_Ping=null
    trigger gg_trg_QuestTotal_Add=null
    trigger gg_trg_Kalm_Init=null
    trigger gg_trg_Cid_Talk_FindMid=null
    trigger gg_trg_Mid_Cage_Ping=null
    trigger gg_trg_BanditLord_Death=null
    trigger gg_trg_Mid_Freed=null
    trigger gg_trg_Cid_Talk_MidReturned=null
    trigger gg_trg_GoblinChief_Death=null
    trigger gg_trg_Artifact_Ping=null
    trigger gg_trg_Artifact_PickedUp=null
    trigger gg_trg_Artifact_Carrier=null
    trigger gg_trg_Cid_Berserk_Start=null
    trigger gg_trg_Cid_Talk_Hashmalum=null
    trigger gg_trg_Cid_Berserk_Aggro=null
    trigger gg_trg_BerserkGuard_Decay=null
    trigger gg_trg_Cid_Berserk_End=null
    trigger gg_trg_Cid_Berserk_Revive=null
    trigger gg_trg_Cid_Berserk_Aftermath=null
    trigger gg_trg_AoMadoushi_Hide=null
    trigger gg_trg_Cid_Research_Done=null
    trigger gg_trg_Cid_Talk_AoMadoushi=null
    trigger gg_trg_Turks_Give_Flute=null
    trigger gg_trg_AoMadoushi_Summon=null
    trigger gg_trg_Quest_AoMadoushi_Talk=null
    trigger gg_trg_Cine_StoneBreaks=null
    trigger gg_trg_World_AfterDemonAppears=null
    trigger gg_trg_Quest_AoMadoushi_Report=null
    trigger gg_trg_Ping_ArenaTarget=null
    trigger gg_trg_Loot_Cuchulainn_EyeDrop=null
    trigger gg_trg_Ping_EyeOfJenova=null
    trigger gg_trg_Quest_EyeOfJenova_PickUp=null
    trigger gg_trg_Quest_EyeOfJenova_Deliver=null
    trigger gg_trg_Loop_MadoushiChanneling=null
    trigger gg_trg_Init_AncientForestNpcs=null
    trigger gg_trg_Quest_NightElves_Start=null
    trigger gg_trg_Portal_Reveal=null
    trigger gg_trg_Talk_PortalGuardian=null
    trigger gg_trg_Talk_ForestGuardian=null
    trigger gg_trg_Quest_NightElves_Complete=null
    trigger gg_trg_Talk_Lothlorien_Greet=null
    trigger gg_trg_Quest_NightElves_Report=null
    trigger gg_trg_Spawn_Gafgarion=null
    trigger gg_trg_Init_ZaleraChapter=null
    trigger gg_trg_Cine_ScryingVision=null
    trigger gg_trg_Cine_Belias_Gafgarion=null
    trigger gg_trg_Quest_DarkKnight_Start=null
    trigger gg_trg_Boss_Gafgarion_Intro=null
    trigger gg_trg_Boss_Gafgarion_Death=null
    trigger gg_trg_Ghost_Despawn=null
    trigger gg_trg_Boss_Zalera_Intro=null
    trigger gg_trg_Boss_Gafgarion_Guard_Death=null
    trigger gg_trg_Boss_Zalera_Death=null
    trigger gg_trg_Quest_WorldLiberation_Count=null
    trigger gg_trg_Quest_WorldLiberation_Reward=null
    trigger gg_trg_Cine_StoneBreaks_Alt=null
    trigger gg_trg_Spawn_KalmDefenders=null
    trigger gg_trg_Ally_Death_Cleanup=null
    trigger gg_trg_KalmSiege_AITick=null
    trigger gg_trg_KalmSiege_LeaderRetreat=null
    trigger gg_trg_KalmSiege_FailRespawn=null
    trigger gg_trg_KalmSiege_DemonRecover=null
    trigger gg_trg_KalmSiege_Init=null
    trigger gg_trg_KalmSiege1_Start=null
    trigger gg_trg_KalmSiege1_Briefing=null
    trigger gg_trg_KalmSiege1_Begin=null
    trigger gg_trg_KalmSiege1_Defeat=null
    trigger gg_trg_KalmSiege1_TrackDeaths=null
    trigger gg_trg_KalmSiege1_Complete=null
    trigger gg_trg_KalmSiege1_Fail=null
    trigger gg_trg_KalmSiege2_Call=null
    trigger gg_trg_KalmSiege2_Start=null
    trigger gg_trg_KalmSiege2_Restart=null
    trigger gg_trg_KalmSiege2_Begin=null
    trigger gg_trg_KalmSiege2_SouthWave=null
    trigger gg_trg_KalmSiege2_DemonSpotted=null
    trigger gg_trg_KalmSiege2_DemonFlee=null
    trigger gg_trg_KalmSiege2_Defeat=null
    trigger gg_trg_KalmSiege2_TrackDeaths=null
    trigger gg_trg_KalmSiege2_Complete=null
    trigger gg_trg_KalmSiege2_Fail=null
    trigger gg_trg_KalmSiege3_Call=null
    trigger gg_trg_KalmSiege3_CidTalk=null
    trigger gg_trg_KalmSiege3_Start=null
    trigger gg_trg_KalmSiege3_Restart=null
    trigger gg_trg_KalmSiege3_Begin=null
    trigger gg_trg_KalmSiege3_DemonArrive=null
    trigger gg_trg_KalmSiege3_DemonSummon=null
    trigger gg_trg_KalmSiege3_ChiefGuard=null
    trigger gg_trg_KalmSiege3_TrackDeaths=null
    trigger gg_trg_KalmSiege3_Defeat=null
    trigger gg_trg_KalmSiege3_Complete=null
    trigger gg_trg_KalmSiege3_Fail=null
    trigger gg_trg_Chaos_Init=null
    trigger gg_trg_ForestSpirit_Spawn=null
    trigger gg_trg_ForestSpirit_Wander=null
    trigger gg_trg_ForestSpirit_Flee=null
    trigger gg_trg_SpiritScroll_Pickup=null
    trigger gg_trg_SpiritScroll_Cleanse=null
    trigger gg_trg_VoiceOfForest_Start=null
    trigger gg_trg_VoiceOfForest_PingCrystal=null
    trigger gg_trg_VoiceOfForest_SummonChaos=null
    trigger gg_trg_Chaos_Spawn_Chaosjets=null
    trigger gg_trg_Chaosjet_Death=null
    trigger gg_trg_Chaos_Revive_Chaosjets=null
    trigger gg_trg_Chaos_Recall_Chaosjets=null
    trigger gg_trg_Boss_Chaos_Death=null
    trigger gg_trg_Shemhazai_Prepare=null
    trigger gg_trg_Meliadoul_Hint_Timer=null
    trigger gg_trg_Quest_CorruptedOrcs_Start=null
    trigger gg_trg_OrcBase_GateGuard_Death=null
    trigger gg_trg_Boss_OrcChieftain_Death=null
    trigger gg_trg_OrcBase_Units_Cleared=null
    trigger gg_trg_Shemhazai_Appears=null
    trigger gg_trg_Shemhazai_Spawn_SoulClones=null
    trigger gg_trg_Shemhazai_SurpriseMechanic=null
    trigger gg_trg_Shemhazai_Phase2_Cuchulainn=null
    trigger gg_trg_Cuchulainn_Soul_Death=null
    trigger gg_trg_Shemhazai_SoulSplit=null
    trigger gg_trg_SoulSplit_Clone_Death=null
    trigger gg_trg_Boss_Shemhazai_Death=null
    trigger gg_trg_Exodus_Prepare=null
    trigger gg_trg_PriestX_Appear=null
    trigger gg_trg_PriestX_Talk1=null
    trigger gg_trg_PriestX_Talk2=null
    trigger gg_trg_Quest_LastRites_Start=null
    trigger gg_trg_Exodus_Reveal=null
    trigger gg_trg_Exodus_Stomp=null
    trigger gg_trg_Exodus_SummonTrees=null
    trigger gg_trg_Exodus_Cometeorite=null
    trigger gg_trg_Boss_Exodus_Death=null
    trigger gg_trg_Cometeorite_Rocks_Cleanup=null
    trigger gg_trg_Famfrit_Prepare=null
    trigger gg_trg_Dana_Prepare=null
    trigger gg_trg_Dana_Talk1=null
    trigger gg_trg_Dana_Talk2_Enable=null
    trigger gg_trg_Quest_Illusions_Start=null
    trigger gg_trg_Dana_Receive_Eye=null
    trigger gg_trg_Dana_Death=null
    trigger gg_trg_Famfrit_Encounter=null
    trigger gg_trg_Famfrit_TidalWave=null
    trigger gg_trg_Boss_Famfrit_Death=null
    trigger gg_trg_Ultima_Prepare=null
    trigger gg_trg_Alma_Disappear=null
    trigger gg_trg_Alma_Missing_Notice=null
    trigger gg_trg_Quest_LightOfJudgment_Start=null
    trigger gg_trg_Ultima_Possession=null
    trigger gg_trg_Ultima_Holyja=null
    trigger gg_trg_Boss_Ultima_Death=null
    trigger gg_trg_Zodiark_Prepare=null
    trigger gg_trg_Montblanc_Hint_Timer=null
    trigger gg_trg_Quest_GodDragon_Start=null
    trigger gg_trg_Zodiark_Encounter=null
    trigger gg_trg_GodDragon_Transfusion=null
    trigger gg_trg_GodDragon_Death=null
    trigger gg_trg_Spell_Dewall_Apply=null
    trigger gg_trg_Zodiark_BanishRay=null
    trigger gg_trg_Zodiark_Darkja=null
    trigger gg_trg_Boss_GodDragon_Death=null
    trigger gg_trg_IcyRealm_Init=null
    trigger gg_trg_Celeborn_Summon_Alert=null
    trigger gg_trg_Quest_ZodiacAge_Start=null
    trigger gg_trg_Quest_ZodiacAge_GateBlocked=null
    trigger gg_trg_Quest_ZodiacAge_AskCeleborn=null
    trigger gg_trg_Quest_ZodiacAge_AskTalon=null
    trigger gg_trg_Quest_ZodiacAge_GetPendant=null
    trigger gg_trg_Quest_ZodiacAge_ShowPendant=null
    trigger gg_trg_Quest_ZodiacAge_TalonOpensGate=null
    trigger gg_trg_Talon_Leash_Gate=null
    trigger gg_trg_Talon_Death=null
    trigger gg_trg_Gate_Codeword_Demesne=null
    trigger gg_trg_IcyRealm_GateOpened_Setup=null
    trigger gg_trg_Boss_Mateus_Intro=null
    trigger gg_trg_Boss_Mateus_CoverSwap=null
    trigger gg_trg_Boss_Demesne_CoverSwap=null
    trigger gg_trg_Boss_Demesne_Death_Revive=null
    trigger gg_trg_Boss_Demesne_Revived=null
    trigger gg_trg_Boss_Mateus_Death=null
    trigger gg_trg_Gate_WinterKey_Unlock=null
    trigger gg_trg_Ambush_Skeletons_1=null
    trigger gg_trg_Ambush_Skeletons_2=null
    trigger gg_trg_Ambush_Skeletons_3=null
    trigger gg_trg_Ambush_Skeletons_4=null
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
    trigger gg_trg_Gafgarion_Join_Party=null
    trigger gg_trg_Gafgarion_Leash=null
    trigger gg_trg_Gafgarion_Death_Timer=null
    trigger gg_trg_Gafgarion_Revive=null
    trigger gg_trg_Gafgarion_Block_Portal_Scroll=null
    trigger gg_trg_Gafgarion_Join_Summit=null
    trigger gg_trg_Gafgarion_RegenBurst=null
    trigger gg_trg_Boss_Echele_Start=null
    trigger gg_trg_Boss_Echele_SpawnForm=null
    trigger gg_trg_Boss_Echele_FormChange=null
    trigger gg_trg_Boss_Echele_KillMinions=null
    trigger gg_trg_Boss_Echele_Leash=null
    trigger gg_trg_IceAge_FreezeTimeout=null
    trigger gg_trg_Ending_FrozenWorld=null
    trigger gg_trg_Ending_Wasteland=null
    trigger gg_trg_Ending_ReturnToStart=null
    trigger gg_trg_IceAge_Victory=null
    trigger gg_trg_TrueIceAge_GateUnlock=null
    trigger gg_trg_TrueIceAge_Summon=null
    trigger gg_trg_TrueIceAge_SpawnBrave=null
    trigger gg_trg_TrueIceAge_BossIntro=null
    trigger gg_trg_TrueIceAge_FreezeTimeout=null
    trigger gg_trg_TrueIceAge_Victory=null
    trigger gg_trg_Epilogue_WaitForCid=null
    trigger gg_trg_Epilogue_Kalm=null
    trigger gg_trg_Epilogue_Lothlorien=null
    trigger gg_trg_Epilogue_BlueMage=null
    trigger gg_trg_Epilogue_DarkKnight=null
    trigger gg_trg_Epilogue_Dana=null
    trigger gg_trg_QuestTotal_Add71=null
    trigger gg_trg_QuestCount_Milestones=null
    trigger gg_trg_Quest_Shimmerweed_Offer=null
    trigger gg_trg_Quest_Shimmerweed_Start=null
    trigger gg_trg_Quest_Shimmerweed_Ping=null
    trigger gg_trg_Quest_Shimmerweed_Pickup=null
    trigger gg_trg_Quest_Shimmerweed_Deliver=null
    trigger gg_trg_Quest_Arachnophobia_Offer=null
    trigger gg_trg_Quest_Arachnophobia_Start=null
    trigger gg_trg_Quest_Arachnophobia_Count=null
    trigger gg_trg_Quest_Arachnophobia_Reward=null
    trigger gg_trg_Quest_KillSetag_Hide=null
    trigger gg_trg_Quest_KillSetag_Offer=null
    trigger gg_trg_Quest_KillSetag_Start=null
    trigger gg_trg_Quest_KillSetag_Ambush=null
    trigger gg_trg_Quest_KillSetag_Failed=null
    trigger gg_trg_Quest_KillSetag_Complete=null
    trigger gg_trg_Quest_Phoenix_Available=null
    trigger gg_trg_Quest_Phoenix_Start=null
    trigger gg_trg_Quest_Phoenix_Ping=null
    trigger gg_trg_Quest_Phoenix_EggTaken=null
    trigger gg_trg_Quest_Phoenix_Complete=null
    trigger gg_trg_Caravan_Init=null
    trigger gg_trg_Quest_Caravan_SamAvailable=null
    trigger gg_trg_Quest_Caravan_SamRequest=null
    trigger gg_trg_Quest_Caravan_DioRefuses=null
    trigger gg_trg_Quest_Caravan_Enable=null
    trigger gg_trg_Quest_Caravan_Start=null
    trigger gg_trg_Quest_Caravan_HorsesVulnerable=null
    trigger gg_trg_Quest_Caravan_Deliver=null
    trigger gg_trg_Quest_Caravan_Failed=null
    trigger gg_trg_Quest_Caravan_Ping=null
    trigger gg_trg_Quest_Caravan_Complete=null
    trigger gg_trg_Quest_KillElmdor_Init=null
    trigger gg_trg_Quest_KillElmdor_Available=null
    trigger gg_trg_Quest_KillElmdor_Start=null
    trigger gg_trg_Quest_KillElmdor_Slain=null
    trigger gg_trg_Quest_KillElmdor_Complete=null
    trigger gg_trg_Quest_FireGolem_Init=null
    trigger gg_trg_Quest_FireGolem_Alert=null
    trigger gg_trg_Quest_FireGolem_Start=null
    trigger gg_trg_Quest_FireGolem_HeartDropped=null
    trigger gg_trg_Quest_FireGolem_Ping=null
    trigger gg_trg_Quest_FireGolem_HeartTaken=null
    trigger gg_trg_Quest_FireGolem_Complete=null
    trigger gg_trg_Quest_Brothers_Init=null
    trigger gg_trg_Quest_Brothers_Available=null
    trigger gg_trg_Quest_Brothers_Start=null
    trigger gg_trg_Quest_Brothers_Defeated=null
    trigger gg_trg_Quest_Brothers_Complete=null
    trigger gg_trg_Quest_SaveTimmy_Init=null
    trigger gg_trg_Quest_SaveTimmy_Start=null
    trigger gg_trg_Quest_SaveTimmy_Ping=null
    trigger gg_trg_Quest_SaveTimmy_GateRefused=null
    trigger gg_trg_Quest_SaveTimmy_GateAsk=null
    trigger gg_trg_Quest_SaveTimmy_GateOpen=null
    trigger gg_trg_Quest_SaveTimmy_CampFlank=null
    trigger gg_trg_Quest_SaveTimmy_CampAlerted=null
    trigger gg_trg_Quest_SaveTimmy_CampCleared=null
    trigger gg_trg_Quest_SaveTimmy_Freed=null
    trigger gg_trg_Quest_SaveTimmy_TimmyReturns=null
    trigger gg_trg_Quest_SaveTimmy_RescueFirst=null
    trigger gg_trg_Quest_SaveTimmy_Complete=null
    trigger gg_trg_Quest_SaveTimmy_CompleteAlt=null
    trigger gg_trg_Quest_DeliverLetter_Init=null
    trigger gg_trg_Quest_DeliverLetter_Available=null
    trigger gg_trg_Quest_DeliverLetter_Start=null
    trigger gg_trg_Quest_DeliverLetter_PingZack=null
    trigger gg_trg_Quest_DeliverLetter_PingWedge=null
    trigger gg_trg_Quest_DeliverLetter_GiveZack=null
    trigger gg_trg_Quest_DeliverLetter_Complete=null
    trigger gg_trg_Quest_Beastslayer_Available=null
    trigger gg_trg_Quest_Beastslayer_Start=null
    trigger gg_trg_Quest_Beastslayer_ArrowDropped=null
    trigger gg_trg_Quest_Beastslayer_Ping=null
    trigger gg_trg_Quest_Beastslayer_ArrowTaken=null
    trigger gg_trg_Quest_Beastslayer_Complete=null
    trigger gg_trg_Quest_LadyNashj_Init=null
    trigger gg_trg_Quest_LadyNashj_Available=null
    trigger gg_trg_Quest_LadyNashj_Start=null
    trigger gg_trg_Quest_LadyNashj_Slain=null
    trigger gg_trg_Quest_LadyNashj_Complete=null
    trigger gg_trg_Forge_Bali_Init=null
    trigger gg_trg_Quest_Arcanium_Start=null
    trigger gg_trg_Quest_Arcanium_Taken=null
    trigger gg_trg_Quest_Arcanium_Complete=null
    trigger gg_trg_Forge_Bali_ItemGiven=null
    trigger gg_trg_Forge_Bali_ItemTaken=null
    trigger gg_trg_Forge_Bali_Refresh=null
    trigger gg_trg_Forge_Bali_ClearText=null
    trigger gg_trg_Forge_Bali_Craft=null
    trigger gg_trg_Forge_Bali_PsypherTalk=null
    trigger gg_trg_TargetPractice_Init=null
    trigger gg_trg_Quest_TargetPractice_Start=null
    trigger gg_trg_TargetPractice_Begin=null
    trigger gg_trg_TargetPractice_PingTargets=null
    trigger gg_trg_TargetPractice_TargetHit=null
    trigger gg_trg_TargetPractice_Timeout=null
    trigger gg_trg_TargetPractice_Fail=null
    trigger gg_trg_TargetPractice_Reward=null
    trigger gg_trg_Aisha_ArtemisTalk_Prepare=null
    trigger gg_trg_Aisha_ArtemisTale=null
    trigger gg_trg_HealingWaters_HideFamily=null
    trigger gg_trg_HealingWaters_Prepare=null
    trigger gg_trg_HealingWaters_Start=null
    trigger gg_trg_HealingWaters_PingVial=null
    trigger gg_trg_FillVial_Cast=null
    trigger gg_trg_Vial_EmptyOnUse=null
    trigger gg_trg_HealingWaters_DefiledVial=null
    trigger gg_trg_HealingWaters_Cure=null
    trigger gg_trg_HealingWaters_CureBlood=null
    trigger gg_trg_MithrilGolem_Prepare=null
    trigger gg_trg_MithrilGolem_Start=null
    trigger gg_trg_StrangeKey_Drop=null
    trigger gg_trg_StrangeKey_Ping=null
    trigger gg_trg_StrangeCage_Unlock=null
    trigger gg_trg_MithrilGolem_Death=null
    trigger gg_trg_GolemHeart_Ping=null
    trigger gg_trg_GolemHeart_Pickup=null
    trigger gg_trg_MithrilGolem_Activate=null
    trigger gg_trg_Naisha_Init=null
    trigger gg_trg_Naisha_Prepare=null
    trigger gg_trg_Naisha_Recruit=null
    trigger gg_trg_Naisha_Wounded=null
    trigger gg_trg_Naisha_AttackedRetreat=null
    trigger gg_trg_Naisha_Heal=null
    trigger gg_trg_Naisha_Death=null
    trigger gg_trg_Naisha_ArriveLothlorien=null
    trigger gg_trg_Naisha_Whirl=null
    trigger gg_trg_HydraEgg_Prepare=null
    trigger gg_trg_HydraEgg_Start=null
    trigger gg_trg_HydraEgg_Drop=null
    trigger gg_trg_HydraEgg_Pickup=null
    trigger gg_trg_HydraEgg_Ping=null
    trigger gg_trg_HydraEgg_Deliver=null
    trigger gg_trg_Elixir_Prepare=null
    trigger gg_trg_Elixir_Start=null
    trigger gg_trg_Elixir_Deliver=null
    trigger gg_trg_MysticalGlyph_Prepare=null
    trigger gg_trg_Storm_Greet=null
    trigger gg_trg_MysticalGlyph_Drop=null
    trigger gg_trg_MysticalGlyph_Pickup=null
    trigger gg_trg_MysticalGlyph_Ping=null
    trigger gg_trg_MysticalGlyph_Deliver=null
    trigger gg_trg_MysticalGlyph_Result=null
    trigger gg_trg_Nimphrodel_Start=null
    trigger gg_trg_Nimphrodel_Meet=null
    trigger gg_trg_Nimphrodel_Undomiel=null
    trigger gg_trg_CrystalBall_Drop=null
    trigger gg_trg_CrystalBall_Ping=null
    trigger gg_trg_CrystalBall_Pickup=null
    trigger gg_trg_Nimphrodel_Complete=null
    trigger gg_trg_MysteriousCurse_Init=null
    trigger gg_trg_MysteriousCurse_Link=null
    trigger gg_trg_MysteriousCurse_Adria=null
    trigger gg_trg_MysteriousCurse_Confront=null
    trigger gg_trg_MysteriousCurse_Witness=null
    trigger gg_trg_MysteriousCurse_AttackLink=null
    trigger gg_trg_MysteriousCurse_AttackAdria=null
    trigger gg_trg_MysteriousCurse_LinkDies=null
    trigger gg_trg_MysteriousCurse_AdriaWitchDead=null
    trigger gg_trg_MysteriousCurse_BabaYagaAppears=null
    trigger gg_trg_MysteriousCurse_AdriaRestored=null
    trigger gg_trg_MysteriousCurse_AdriaReturn=null
    trigger gg_trg_MysteriousCurse_LinkRestored=null
    trigger gg_trg_MysteriousCurse_LinkReturn=null
    trigger gg_trg_MysteriousCurse_AdriaDies=null
    trigger gg_trg_MysteriousCurse_BabaYagaDead=null
    trigger gg_trg_DefiledFountain_Prepare=null
    trigger gg_trg_DefiledFountain_Start=null
    trigger gg_trg_DefiledFountain_Hoof=null
    trigger gg_trg_DefiledFountain_PingBulb=null
    trigger gg_trg_DefiledFountain_BulbPickup=null
    trigger gg_trg_Quest_Fountain_Bulb=null
    trigger gg_trg_Quest_Fountain_Complete=null
    trigger gg_trg_Monica_ShowMarker=null
    trigger gg_trg_Quest_OgreHunt_Start=null
    trigger gg_trg_Quest_OgreHunt_Count=null
    trigger gg_trg_Quest_OgreHunt_Complete=null
    trigger gg_trg_Clemydar_ShowMarker=null
    trigger gg_trg_Quest_SeekDestroy_Start=null
    trigger gg_trg_Seekers_TrackEngaged=null
    trigger gg_trg_Seeker_Teleport_Cast=null
    trigger gg_trg_Quest_SeekDestroy_Count=null
    trigger gg_trg_Quest_SeekDestroy_Complete=null
    trigger gg_trg_Valera_ShowMarker=null
    trigger gg_trg_Quest_WolfFangs_Start=null
    trigger gg_trg_Quest_WolfFangs_TurnIn=null
    trigger gg_trg_Melaniya_Setup=null
    trigger gg_trg_Quest_GreedIsGood_Start=null
    trigger gg_trg_GreedIsGood_DropStone=null
    trigger gg_trg_PortalStone_Ping=null
    trigger gg_trg_PortalStone_PickedUp=null
    trigger gg_trg_Quest_GreedIsGood_Complete=null
    trigger gg_trg_FallenRanger_Setup=null
    trigger gg_trg_Liniel_ShowMarker=null
    trigger gg_trg_Quest_FallenRanger_Start=null
    trigger gg_trg_Boss_Yukale_Death_Revive=null
    trigger gg_trg_Boss_DarkRanger_Death=null
    trigger gg_trg_Quest_FallenRanger_Complete=null
    trigger gg_trg_Priscilla_Setup=null
    trigger gg_trg_Priscilla_ShowMarker=null
    trigger gg_trg_Quest_SpiritOfWater_Start=null
    trigger gg_trg_Quest_SpiritOfWater_WaterGem=null
    trigger gg_trg_Vodyan_Death_DropTiara=null
    trigger gg_trg_Tiara_Ping=null
    trigger gg_trg_Quest_SpiritOfWater_Complete=null
    trigger gg_trg_Ramuh_Setup=null
    trigger gg_trg_Quest_TowerSummoning_Start=null
    trigger gg_trg_Quest_TowerSummoning_Complete=null
    trigger gg_trg_Tower_Summon_Register=null
    trigger gg_trg_Tower_Quezacotl_Unregister=null
    trigger gg_trg_Tower_Buy_RestoreMP=null
    trigger gg_trg_Tower_Summon_Brothers=null
    trigger gg_trg_Tower_Summon_Eden=null
    trigger gg_trg_Tower_Eden_Expire=null
    trigger gg_trg_Tower_Upgrade_Credit=null
    trigger gg_trg_HolyKnight_Setup=null
    trigger gg_trg_Agrias_ShowMarker=null
    trigger gg_trg_Quest_HolyKnight_Start=null
    trigger gg_trg_Quest_HolyKnight_AskRamza=null
    trigger gg_trg_Boss_Agrias_Intro=null
    trigger gg_trg_Boss_Agrias_Death_Lilith=null
    trigger gg_trg_Boss_Lilith_Death=null
    trigger gg_trg_EidolonChallenge_Setup=null
    trigger gg_trg_Brothers_Alert_Eidolons=null
    trigger gg_trg_Quest_EidolonChallenge_Start=null
    trigger gg_trg_Eidolon_Found_Reveal=null
    trigger gg_trg_Eidolon_Leviathan_Ambush=null
    trigger gg_trg_Quest_EidolonChallenge_Count=null
    trigger gg_trg_Quest_EidolonChallenge_Complete=null
    trigger gg_trg_Eden_Setup=null
    trigger gg_trg_Priscilla_ShowMarker_Eden=null
    trigger gg_trg_Quest_StrongestEidolon_Start=null
    trigger gg_trg_Eden_Summon=null
    trigger gg_trg_Eden_Despawn=null
    trigger gg_trg_Quest_StrongestEidolon_Complete=null
    trigger gg_trg_Brothers_Alert_Rematch=null
    trigger gg_trg_Quest_Rematch_Start=null
    trigger gg_trg_Quest_Rematch_Begin=null
    trigger gg_trg_Quest_Rematch_Complete=null
    trigger gg_trg_NorthernGod_Setup=null
    trigger gg_trg_PhantomDiary_Open=null
    trigger gg_trg_Quest_PhantomDiary_ShowAlberich=null
    trigger gg_trg_Quest_NorthernGod_Judgment=null
    trigger gg_trg_Judgment_Attack_Alberich=null
    trigger gg_trg_Judgment_Spare_Alberich=null
    trigger gg_trg_Boss_Odin_Intro=null
    trigger gg_trg_Boss_Odin_Escort_AI=null
    trigger gg_trg_Odin_Escort_Teleport=null
    trigger gg_trg_Odin_Leash_Arena=null
    trigger gg_trg_Boss_Odin_Death=null
    trigger gg_trg_LadyCurse_ShowMarker=null
    trigger gg_trg_Quest_AnnoyingMonster_Start=null
    trigger gg_trg_AnnoyingMonster_DropBelongings=null
    trigger gg_trg_Belongings_Ping=null
    trigger gg_trg_Belongings_PickedUp=null
    trigger gg_trg_LadyCurse_ReturnBelongings=null
    trigger gg_trg_ArenaResources_Prepare=null
    trigger gg_trg_ArenaResources_Start=null
    trigger gg_trg_ArenaResources_Escort=null
    trigger gg_trg_ArenaResources_ShipMove=null
    trigger gg_trg_ArenaResources_ShipDamaged=null
    trigger gg_trg_ArenaResources_ShipLost=null
    trigger gg_trg_ArenaResources_Complete=null
    trigger gg_trg_ArenaExpansion_Prepare=null
    trigger gg_trg_ArenaExpansion_Start=null
    trigger gg_trg_ArenaExpansion_ShadowStoneSpawn=null
    trigger gg_trg_ArenaExpansion_ShadowStoneTurnIn=null
    trigger gg_trg_ArenaExpansion_GatherDust=null
    trigger gg_trg_ArenaExpansion_PingDust=null
    trigger gg_trg_ArenaExpansion_Complete=null
    trigger gg_trg_HauntedTree_Init=null
    trigger gg_trg_HauntedTree_Prepare=null
    trigger gg_trg_HauntedTree_Start=null
    trigger gg_trg_HauntedTree_GhostRoam=null
    trigger gg_trg_HauntedTree_CaptureSpirit=null
    trigger gg_trg_HauntedTree_Complete=null
    trigger gg_trg_OakaIV_CutTrees=null
    trigger gg_trg_OakaIV_ReachNorthTree=null
    trigger gg_trg_OakaIV_ReachSouthTree=null
    trigger gg_trg_OakaIV_NorthTreeFelled=null
    trigger gg_trg_OakaIV_SouthTreeFelled=null
    trigger gg_trg_IceCache_Open=null
    trigger gg_trg_IceCache_SpearClaimed=null
    trigger gg_trg_DimensionalBoundary_Init=null
    trigger gg_trg_Shinra_TalkPrepare=null
    trigger gg_trg_DimensionalBoundary_Start=null
    trigger gg_trg_GuideBook_Search1=null
    trigger gg_trg_GuideBook_Search2=null
    trigger gg_trg_GuideBook_Search3=null
    trigger gg_trg_GuideBook_Search4=null
    trigger gg_trg_GuideBook_Search5=null
    trigger gg_trg_GuideBook_Search6=null
    trigger gg_trg_GuideBook_TurnIn=null
    trigger gg_trg_TropicalEssence_TurnIn=null
    trigger gg_trg_DeathSeeker_TurnIn=null
    trigger gg_trg_QuFrog_DrainTick=null
    trigger gg_trg_QuFrog_Death=null
    trigger gg_trg_FrogHead_TurnIn=null
    trigger gg_trg_DimensionalBoundary_OpenPortal=null
    trigger gg_trg_Zeromus_Encounter=null
    trigger gg_trg_Zeromus_Death=null
    trigger gg_trg_DimensionalBoundary_EmptyEnd=null
    trigger gg_trg_SkeletalDefense_MarkAttacker=null
    trigger gg_trg_SkeletalDefense_ClearDead=null
    trigger gg_trg_SkeletalDefense_Spawn=null
    trigger gg_trg_Maelstrom_Cast=null
    trigger gg_trg_Gilgamesh_Init=null
    trigger gg_trg_BridgeBattle_Prepare=null
    trigger gg_trg_BridgeBattle_Start=null
    trigger gg_trg_Gilgamesh_Appear=null
    trigger gg_trg_Gilgamesh_Phase2=null
    trigger gg_trg_Gilgamesh_Defeat=null
    trigger gg_trg_BridgeBattle_Complete=null
    trigger gg_trg_ShinrasPlan_Prepare=null
    trigger gg_trg_ShinrasPlan_Start=null
    trigger gg_trg_ShinrasPlan_WaterTurnIn=null
    trigger gg_trg_ShinrasPlan_ShardTurnIn=null
    trigger gg_trg_ShinrasPlan_Complete=null
    trigger gg_trg_AlmightyShinra_Arm=null
    trigger gg_trg_AlmightyShinra_Cinematic=null
    trigger gg_trg_AlmightyShinra_Spiral=null
    trigger gg_trg_AlmightyShinra_Defeat=null
    trigger gg_trg_FinalImpact_Cast=null
    trigger gg_trg_NightElf_TalkPrepare=null
    trigger gg_trg_Quest_LostMemories_Start=null
    trigger gg_trg_Quest_LostMemories_RingFade=null
    trigger gg_trg_Quest_LostMemories_Fail=null
    trigger gg_trg_Quest_LostMemories_Pickup=null
    trigger gg_trg_Quest_LostMemories_ShadowLie=null
    trigger gg_trg_Quest_LostMemories_ShadowTruth=null
    trigger gg_trg_Quest_LostMemories_Reunion=null
    trigger gg_trg_Memento_Ring_Compass=null
    trigger gg_trg_Quest_HarpyHunt_Start=null
    trigger gg_trg_Quest_HarpyHunt_Count=null
    trigger gg_trg_Quest_HarpyHunt_Reward=null
    trigger gg_trg_UltimaWeapon_Hide=null
    trigger gg_trg_Quest_UltimaWeapon_Start=null
    trigger gg_trg_Quest_UltimaWeapon_Slain=null
    trigger gg_trg_OmegaWeapon_Hide=null
    trigger gg_trg_Quest_OmegaWeapon_Start=null
    trigger gg_trg_OmegaWeapon_SpellRotation=null
    trigger gg_trg_Quest_OmegaWeapon_Slain=null
    trigger gg_trg_NebraKing_Hide=null
    trigger gg_trg_NebraKing_Summon=null
    trigger gg_trg_NebraKing_Escape=null
    trigger gg_trg_Quest_KingOfSea_Slain=null
    trigger gg_trg_Quest_KingOfSea_Reward=null
    trigger gg_trg_Anabel_Appear=null
    trigger gg_trg_Quest_NebraAngler_Start=null
    trigger gg_trg_Quest_NebraAngler_Reward=null
    trigger gg_trg_McBurn_Arena_Hide=null
    trigger gg_trg_McBurn_Arena_Appear=null
    trigger gg_trg_Quest_TrialByFire_Start=null
    trigger gg_trg_Quest_TrialByFire_Begin=null
    trigger gg_trg_Quest_TrialByFire_Countdown=null
    trigger gg_trg_Quest_TrialByFire_Fail=null
    trigger gg_trg_Quest_TrialByFire_Survive=null
    trigger gg_trg_McBurn_Heat_Color=null
    trigger gg_trg_Spell_LivingFlame_Apply=null
    trigger gg_trg_Spell_LivingFlame_Tick=null
    trigger gg_trg_Spell_LivingFlame_Spread=null
    trigger gg_trg_BlazingDemon_Hide=null
    trigger gg_trg_BlazingDemon_Appear=null
    trigger gg_trg_Quest_BlazingDemon_Start=null
    trigger gg_trg_Quest_BlazingDemon_EndWeak=null
    trigger gg_trg_BlazingDemon_FullHeat=null
    trigger gg_trg_Quest_BlazingDemon_End=null
    trigger gg_trg_Quest_BlazingDemon_Escape=null
    trigger gg_trg_InfernalMountain_Hide=null
    trigger gg_trg_ScorchedEarth_Omen=null
    trigger gg_trg_Quest_52_Scorching=null
    trigger gg_trg_ScorchedEarth_EnterRegion=null
    trigger gg_trg_ScorchedEarth_TowerAttack=null
    trigger gg_trg_Quest_ScorchedEarth_Start=null
    trigger gg_trg_ScorchedEarth_HeatFade=null
    trigger gg_trg_ScorchedEarth_Barrier=null
    trigger gg_trg_McBurn_TrueForm_Reveal=null
    trigger gg_trg_McBurn_Arena_Return=null
    trigger gg_trg_McBurn_Volcano=null
    trigger gg_trg_Quest_ScorchedEarth_End=null
    trigger gg_trg_IcyRealm_Restore=null
    trigger gg_trg_Bansat_ShowTalkIcon=null
    trigger gg_trg_AdamantHunt_Start=null
    trigger gg_trg_AdamantHunt_Count=null
    trigger gg_trg_AdamantHunt_Reward=null
    trigger gg_trg_Kiros_Hide=null
    trigger gg_trg_Kiros_ShowTalkIcon=null
    trigger gg_trg_GnollHunt_Start=null
    trigger gg_trg_GnollHunt_Count=null
    trigger gg_trg_GnollHunt_Reward=null
    trigger gg_trg_Olga_ShowTalkIcon=null
    trigger gg_trg_FlanHunt_Start=null
    trigger gg_trg_FlanHunt_Count=null
    trigger gg_trg_FlanHunt_Fail=null
    trigger gg_trg_FlanHunt_Reward=null
    trigger gg_trg_Krjn_ShowTalkIcon=null
    trigger gg_trg_AncientHunt_Start=null
    trigger gg_trg_AncientHunt_Count=null
    trigger gg_trg_AncientHunt_Reward=null
    trigger gg_trg_Ward_ShowTalkIcon=null
    trigger gg_trg_WendigoHunt_Start=null
    trigger gg_trg_WendigoHunt_Count=null
    trigger gg_trg_WendigoHunt_Reward=null
    trigger gg_trg_Sarai_ShowTalkIcon=null
    trigger gg_trg_Tentacles_Start=null
    trigger gg_trg_Tentacles_Ambush=null
    trigger gg_trg_Tentacles_Yelp=null
    trigger gg_trg_Tentacles_Despawn=null
    trigger gg_trg_Ultros_Spawn=null
    trigger gg_trg_Ultros_SummonTentacle=null
    trigger gg_trg_Ultros_TentacleDeath=null
    trigger gg_trg_Ultros_Death=null
    trigger gg_trg_Tentacles_Fail=null
    trigger gg_trg_Tentacles_Reward=null
    trigger gg_trg_Kiemarl_ShowTalkIcon=null
    trigger gg_trg_DragonEgg_Start=null
    trigger gg_trg_DragonEgg_Ping=null
    trigger gg_trg_DragonEgg_PickUp=null
    trigger gg_trg_DragonEgg_Fail=null
    trigger gg_trg_DragonEgg_Reward=null
    trigger gg_trg_NameDiary_Prepare=null
    trigger gg_trg_NameDiary_Start=null
    trigger gg_trg_NameDiary_Ping=null
    trigger gg_trg_NameDiary_Chronicle=null
    trigger gg_trg_NameDiary_Reward=null
    trigger gg_trg_FogCheat_Reset=null
    trigger gg_trg_Cartographer_Prepare=null
    trigger gg_trg_Cartographer_Start=null
    trigger gg_trg_Cartographer_Update=null
    trigger gg_trg_Cartographer_Report=null
    trigger gg_trg_Cartographer_Fail=null
    trigger gg_trg_HuntGuest_DefaultKrjn=null
    trigger gg_trg_HuntFestival_Announce=null
    trigger gg_trg_HuntFestival_Invite=null
    trigger gg_trg_HuntFestival_Begin=null
    trigger gg_trg_HuntFestival_Teleport=null
    trigger gg_trg_HuntFestival_KeepAway=null
    trigger gg_trg_HuntFestival_Reorder=null
    trigger gg_trg_HuntFestival_Respawn=null
    trigger gg_trg_HuntFestival_Score=null
    trigger gg_trg_HuntFestival_End=null
    trigger gg_trg_Makenroh_ShowTalkIcon=null
    trigger gg_trg_DragonHunt_Start=null
    trigger gg_trg_DragonHunt_Count=null
    trigger gg_trg_DragonHunt_Reward=null
    trigger gg_trg_Billy_ShowTalkIcon=null
    trigger gg_trg_ChocoboRider_Start=null
    trigger gg_trg_ChocoboRider_StartWithChocobo=null
    trigger gg_trg_ChocoboRider_Progress=null
    trigger gg_trg_ChocoboRider_FoundTreasure=null
    trigger gg_trg_ChocoboRider_Reward=null
    trigger gg_trg_Graves_Reveal=null
    trigger gg_trg_Fafnir_Spawn=null
    trigger gg_trg_Fafnir_Patrol_Move=null
    trigger gg_trg_Fafnir_Patrol_Waypoint1=null
    trigger gg_trg_Fafnir_Patrol_Waypoint2=null
    trigger gg_trg_Fafnir_Patrol_Waypoint3=null
    trigger gg_trg_Fafnir_Patrol_Waypoint0=null
    trigger gg_trg_Fafnir_Attack_Delay=null
    trigger gg_trg_Fafnir_LowLife_Credit=null
    trigger gg_trg_Mimic_Reveal=null
    trigger gg_trg_Mimic_Death_Loot=null
    trigger gg_trg_Ziegfried_Mine_Arrive=null
    trigger gg_trg_Quest_ImperviousBeast_Start=null
    trigger gg_trg_Ziegfried_Advance_Order=null
    trigger gg_trg_Ziegfried_Attack_Fafnir=null
    trigger gg_trg_Fafnir_Battle_Begin=null
    trigger gg_trg_Ziegfried_Meltdown=null
    trigger gg_trg_Quest_ImperviousBeast_Complete=null
    trigger gg_trg_Barrens_Forge_Setup=null
    trigger gg_trg_Giott_FirstTalk=null
    trigger gg_trg_Mid_Letter_Give=null
    trigger gg_trg_Mid_Letter_Ping=null
    trigger gg_trg_Giott_Letter_Deliver=null
    trigger gg_trg_Dwarves_Disappear=null
    trigger gg_trg_Quest_DwarfDisappearance_Start=null
    trigger gg_trg_Valigarmanda_Confront=null
    trigger gg_trg_Valigarmanda_Wave_Cleared=null
    trigger gg_trg_Valigarmanda_Wave_Spawn=null
    trigger gg_trg_Valigarmanda_Wave_Reset=null
    trigger gg_trg_Valigarmanda_Death=null
    trigger gg_trg_Loki_Talk_Enable=null
    trigger gg_trg_Quest_OreSupplies_Start=null
    trigger gg_trg_Quest_OreSupplies_Deliver=null
    trigger gg_trg_Loki_Reforge_Unlock=null
    trigger gg_trg_Loki_Reforge_Offer=null
    trigger gg_trg_Loki_Reforge_Drop=null
    trigger gg_trg_Loki_Forge_Text_Clear=null
    trigger gg_trg_Loki_Reforge_Confirm=null
    trigger gg_trg_Watts_Talk_Enable=null
    trigger gg_trg_Quest_FieryWings_Start=null
    trigger gg_trg_Harpy_Matriarch_CallAid=null
    trigger gg_trg_Harpy_Trickster_Cleanup=null
    trigger gg_trg_Quest_FieryWings_Matriarch_Dead=null
    trigger gg_trg_Quest_FieryWings_Complete=null
    trigger gg_trg_Fireplace_Init=null
    trigger gg_trg_Quest_Cooking_Start=null
    trigger gg_trg_Quest_Cooking_Complete=null
    trigger gg_trg_Firewood_Light_Fireplace=null
    trigger gg_trg_Cooking_Recipes_UnlockAll=null
    trigger gg_trg_Siegfried_Hide_Init=null
    trigger gg_trg_Siegfried_Appear=null
    trigger gg_trg_Quest_DivineOrder_Start=null
    trigger gg_trg_Ziegfried_Confront=null
    trigger gg_trg_Ziegfried_Arena_Leash=null
    trigger gg_trg_Quest_DivineOrder_Complete=null
    trigger gg_trg_Monstrum_Ambush_Arm=null
    trigger gg_trg_Monstrum_Tentacle_Ambush=null
    trigger gg_trg_Monstrum_Summon=null
    trigger gg_trg_Monstrum_Ambush_Rearm=null
    trigger gg_trg_Monstrum_Phase_Check=null
    trigger gg_trg_Monstrum_DepthCharge=null
    trigger gg_trg_Monstrum_Tentacle_Cleanup=null
    trigger gg_trg_Quest_Monstrum_Complete=null
    trigger gg_trg_Mid_Crossbow_Talk_Enable=null
    trigger gg_trg_Quest_YoungEngineer_Start=null
    trigger gg_trg_Quest_YoungEngineer_Ping=null
    trigger gg_trg_Quest_Crossbow_NeedEnemies=null
    trigger gg_trg_Quest_Crossbow_Tested=null
    trigger gg_trg_Quest_Engineer_GetAdvice=null
    trigger gg_trg_Quest_YoungEngineer_Complete=null
    trigger gg_trg_Frakir_ShowMarker=null
    trigger gg_trg_Frakir_Lore_Talk=null
    trigger gg_trg_Frakir_NextMarker=null
    trigger gg_trg_Quest_SpiritHunt_Start=null
    trigger gg_trg_Quest_SpiritHunt_Count=null
    trigger gg_trg_Quest_SpiritHunt_Complete=null
    trigger gg_trg_Quest_FishyDeals_Start=null
    trigger gg_trg_Quest_FishyDeals_Complete=null
    trigger gg_trg_Elysium_Prepare=null
    trigger gg_trg_Elysium_AssignLegends=null
    trigger gg_trg_Andre_Elysium_Reveal=null
    trigger gg_trg_Andre_Legendary_Rules=null
    trigger gg_trg_Elysium_MarkerTick=null
    trigger gg_trg_Legend_Squire_Talk=null
    trigger gg_trg_Legend_Knight_Talk=null
    trigger gg_trg_Legend_Archer_Talk=null
    trigger gg_trg_Legend_Monk_Talk=null
    trigger gg_trg_Legend_Thief_Talk=null
    trigger gg_trg_Legend_Geomancer_Talk=null
    trigger gg_trg_Legend_Samurai_Talk=null
    trigger gg_trg_Legend_Lancer_Talk=null
    trigger gg_trg_Legend_Ninja_Talk=null
    trigger gg_trg_Legend_HolySwordsman_Talk=null
    trigger gg_trg_Legend_Chemist_Talk=null
    trigger gg_trg_Legend_Wizard_Talk=null
    trigger gg_trg_Legend_Priest_Talk=null
    trigger gg_trg_Legend_Summoner_Talk=null
    trigger gg_trg_Legend_TimeMage_Talk=null
    trigger gg_trg_Legend_Mediator_Talk=null
    trigger gg_trg_Legend_Oracle_Talk=null
    trigger gg_trg_Legend_Calculator_Talk=null
    trigger gg_trg_Legend_Prophet_Talk=null
    trigger gg_trg_Legend_Sorcerer_Talk=null
    trigger gg_trg_Legend_DarkKnight_Talk=null
    trigger gg_trg_Legend_Necromancer_Talk=null
    trigger gg_trg_Legend_Freelancer_Talk=null
    trigger gg_trg_Spring_Of_Life_Ritual=null
    trigger gg_trg_Promotion_Award_Random=null
    trigger gg_trg_Celestium_Trade=null
    trigger gg_trg_Lancer_Task_Dragons=null
    trigger gg_trg_Maechen_Lore_Init=null
    trigger gg_trg_Info_Item_Show_Lore=null
    trigger gg_trg_Kesha_Stones_Spawn=null
    trigger gg_trg_Kesha_Return_Stones=null
    trigger gg_trg_Kesha_Subscription_Toggle=null
    trigger gg_trg_Boco_Feed_Greens=null
    trigger gg_trg_Boco_Meet_Again=null
    trigger gg_trg_Fire_Pawn_Nectar=null
    trigger gg_trg_Fire_Pawn_SpiritPotion=null
    trigger gg_trg_Fire_Pawn_BloodEther=null
    trigger gg_trg_Fire_Pawn_HeroDrink=null
    trigger gg_trg_Fire_Reward_Megalixir=null
    trigger gg_trg_Megalixir_Remove_Stock=null
    trigger gg_trg_Wanderer_Quest_Init=null
    trigger gg_trg_Wanderer_Spawn=null
    trigger gg_trg_Wanderer_Request=null
    trigger gg_trg_Wanderer_Give_Item=null
    trigger gg_trg_NpcTrio_Group_Init=null
    trigger gg_trg_NpcTrio_Turn_Face=null
    trigger gg_trg_Elemental_Setup=null
    trigger gg_trg_Elemental_Spawn=null
    trigger gg_trg_Elemental_Wander=null
    trigger gg_trg_Elemental_Aggro=null
    trigger gg_trg_Elemental_Assist_Attack=null
    trigger gg_trg_Elemental_Death=null
    trigger gg_trg_CowKing_Hide=null
    trigger gg_trg_CowPortal_Open=null
    trigger gg_trg_CowPortal_Spawn_Cows=null
    trigger gg_trg_Bernkastel_State_Reset=null
    trigger gg_trg_Bernkastel_Try_Spawn=null
    trigger gg_trg_Bernkastel_First_Talk=null
    trigger gg_trg_Bernkastel_Second_Talk=null
    trigger gg_trg_Bernkastel_Hint_Talk=null
    trigger gg_trg_Bernkastel_Final_Talk=null
    trigger gg_trg_Bernkastel_Despawn=null
    trigger gg_trg_Miracle_Piece_Use=null
    trigger gg_trg_Npc_Hints_Create=null
    trigger gg_trg_Npc_Talk_Woman=null
    trigger gg_trg_Npc_Talk_Reno=null
    trigger gg_trg_Npc_Talk_Rude=null
    trigger gg_trg_Npc_Talk_Footman=null
    trigger gg_trg_Npc_Talk_Swordsman=null
    trigger gg_trg_Npc_Talk_Child=null
    trigger gg_trg_Npc_Talk_Archer=null
    trigger gg_trg_Npc_Talk_Knight=null
    trigger gg_trg_Npc_Talk_ChildChocobo=null
    trigger gg_trg_Npc_Talk_Kenarius=null
    trigger gg_trg_Npc_Talk_Nimphrodel=null
    trigger gg_trg_Npc_Talk_Sentry=null
    trigger gg_trg_Npc_Talk_Kesha=null
    trigger gg_trg_Npc_Talk_Peasant=null
    trigger gg_trg_Npc_Talk_PeasantHarvest=null
    trigger gg_trg_Npc_Talk_MineStory=null
    trigger gg_trg_Npc_Fire_WantMore=null
    trigger gg_trg_Npc_Fire_Thanks=null
    trigger gg_trg_Npc_Priscilla_SummonEden=null
    trigger gg_trg_Npc_Talk_LinkGuard=null
    trigger gg_trg_Npc_Talk_Jack=null
    trigger gg_trg_Npc_Talk_ArcherWall=null
    trigger gg_trg_Npc_Talk_Ruksel=null
    trigger gg_trg_Npc_Thorn_BattleWait=null
    trigger gg_trg_Npc_Talk_Sigroon=null
    trigger gg_trg_Npc_Talk_Quincy=null
    trigger gg_trg_Npc_Talk_Gravedigger=null
    trigger gg_trg_GrandVampire_Hide=null
    trigger gg_trg_GrandVampire_Awaken=null
    trigger gg_trg_Ghoul_Group_Cleanup=null
    trigger gg_trg_Ghoul_Master_Decay=null
    trigger gg_trg_GrandVampire_Death=null
    trigger gg_trg_Ghoul_Master_Spawn=null
    trigger gg_trg_Boss_Drop_TomeOfLife=null
    trigger gg_trg_Boss_Drop_CrushersMace=null
    trigger gg_trg_Boss_Drop_FurArmor=null
    trigger gg_trg_MagicUrn_Setup=null
    trigger gg_trg_Urn_Guardians_Count=null
    trigger gg_trg_MagicUrn_Drop=null
    trigger gg_trg_MagicUrn_Open=null
    trigger gg_trg_Hades_BlackCauldron=null
    trigger gg_trg_MagicUrn_Boss_Death=null
    trigger gg_trg_Nightmare_Spawn=null
    trigger gg_trg_Nightmare_Despawn=null
    trigger gg_trg_Nightmare_Death_Charge=null
    trigger gg_trg_Nightmare_Roam=null
    trigger gg_trg_Nightmare_Death=null
    trigger gg_trg_Ripper_Charge_Buffs=null
    trigger gg_trg_Ripper_Mass_Dispel=null
    trigger gg_trg_Ripper_Condemnation=null
    trigger gg_trg_Ripper_Death_Circle=null
    trigger gg_trg_MagicGodToken_Use=null
    trigger gg_trg_WarringTriad_Freeze=null
    trigger gg_trg_RingOfDarkness_Init=null
    trigger gg_trg_HolyAnkh_Waygate=null
    trigger gg_trg_Glyph_Area_Enter=null
    trigger gg_trg_Summon_Item_Dropped=null
    trigger gg_trg_Arena_Enter_Eject=null
    trigger gg_trg_Arena_Leave_Player=null
    trigger gg_trg_Arena_Abandoned_Reset=null
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
    trigger gg_trg_Spell_HeatWave_Cast=null
    trigger gg_trg_Spell_JavelinRain_Cast=null
    trigger gg_trg_Spell_XerosBeat_Cast=null
    trigger gg_trg_Spell_GayaRage_Start=null
    trigger gg_trg_Spell_GayaRage_Ring=null
    trigger gg_trg_Spell_GayaRage_Damage=null
    trigger gg_trg_Boss_DemiFiend_Cleanup=null
    trigger gg_trg_Boss_DarkFact_Summon=null
    trigger gg_trg_Boss_DarkFact_Death=null
    trigger gg_trg_Boss_DarkFact_FactStrike=null
    trigger gg_trg_Boss_DarkFact_PingPong=null
    trigger gg_trg_Boss_DarkFact_Orb_Bounce=null
    trigger gg_trg_Boss_DarkFact_Orb_Attack=null
    trigger gg_trg_Boss_DarkFact_Cleanup=null
    trigger gg_trg_Boss_Shinryu_Warmech_Summon=null
    trigger gg_trg_Arena_Duel_AI=null
    trigger gg_trg_Spell_Homing_Rockets=null
    trigger gg_trg_Spell_Satellite_Beam=null
    trigger gg_trg_Spell_Satellite_Beam_InGroup=null
    trigger gg_trg_Spell_Satellite_Beam_Death=null
    trigger gg_trg_Spell_Wave_Cannon=null
    trigger gg_trg_Spell_Meteor_Wide=null
    trigger gg_trg_Arena_Omega_Absorbs=null
    trigger gg_trg_Arena_Shinryu_Absorbs=null
    trigger gg_trg_Arena_Duel_Ascend=null
    trigger gg_trg_Arena_Duel_Victory=null
    trigger gg_trg_Arena_Duel_Cleanup=null
    trigger gg_trg_Boss_Ozma_Spawn=null
    trigger gg_trg_Boss_Ozma_Barrier=null
    trigger gg_trg_Boss_Ozma_Death=null
    trigger gg_trg_Boss_Ozma_Cleanup=null
    trigger gg_trg_Item_Upgrade_Watera=null
    trigger gg_trg_Item_Upgrade_Wateraga=null
    trigger gg_trg_Item_Upgrade_Quakera=null
    trigger gg_trg_Item_Upgrade_Quakeraga=null
    trigger gg_trg_Item_Upgrade_Demira=null
    trigger gg_trg_Item_Upgrade_Demiga=null
    trigger gg_trg_Item_Upgrade_Aerora=null
    trigger gg_trg_Item_Upgrade_Aeroga=null
    trigger gg_trg_Cmd_Music=null
    trigger gg_trg_Boss_Defeat_Announce=null
    trigger gg_trg_Multiboard_Create=null
    trigger gg_trg_Multiboard_Refresh=null
    trigger gg_trg_Multiboard_Title=null
    trigger gg_trg_Cheat_Detect_Init=null
    trigger gg_trg_Cheat_Detect_Fog=null
    trigger gg_trg_Cheat_Detect_Invuln=null
    trigger gg_trg_Cheat_Detect_Resources=null
    trigger gg_trg_Cheat_Detect_Mana=null
    trigger gg_trg_Cheat_Punish=null
    trigger gg_trg_Cmd_Load_Code=null
    trigger udg_LoadFileTrigger=null
    trigger gg_trg_Cmd_Load_Armory=null
    trigger udg_SaveCommandTrig=null
    trigger gg_trg_Load_Warn_5Min=null
    trigger gg_trg_Load_Disable=null
    destructable gg_dest_LTcr_0002=null
    destructable gg_dest_LTcr_0003=null
    destructable gg_dest_LTbx_0004=null
    destructable gg_dest_LTg4_0005=null
    destructable gg_dest_LTbs_0006=null
    destructable gg_dest_LTlt_0007=null
    destructable gg_dest_LTbx_0008=null
    destructable gg_dest_LTbr_0009=null
    destructable gg_dest_LOcg_0010=null
    destructable gg_dest_BTrx_0011=null
    destructable gg_dest_ATg3_0012=null
    destructable gg_dest_DTg7_0013=null
    destructable gg_dest_LTt1_0014=null
    destructable gg_dest_LTbx_0015=null
    destructable gg_dest_Dofw_0016=null
    destructable gg_dest_LTbx_0017=null
    destructable gg_dest_ITtw_0018=null
    destructable gg_dest_LTcr_0019=null
    destructable gg_dest_LTe2_0020=null
    destructable gg_dest_LTg2_0021=null
    destructable gg_dest_ITx1_0022=null
    destructable gg_dest_LTbs_0023=null
    destructable gg_dest_LOcg_0024=null
    destructable gg_dest_ZTsg_0025=null
    destructable gg_dest_B002_0026=null
    destructable gg_dest_LTcr_0027=null
    destructable gg_dest_DTg8_0028=null
    destructable gg_dest_LOcg_0029=null
    destructable gg_dest_ITig_0030=null
    destructable gg_dest_LOcg_0031=null
    destructable gg_dest_LOcg_0032=null
    destructable gg_dest_ITx3_0033=null
    destructable gg_dest_ITtw_0034=null
    destructable gg_dest_ITtw_0035=null
    destructable gg_dest_ITtw_0036=null
    destructable gg_dest_ITtw_0037=null
    destructable gg_dest_LTbx_0038=null
    destructable gg_dest_ITtw_0039=null
    destructable gg_dest_B002_0040=null
    destructable gg_dest_ITtw_0041=null
    destructable gg_dest_LOcg_0042=null
    destructable gg_dest_ITtw_0043=null
    destructable gg_dest_LTba_0044=null
    destructable gg_dest_LTba_0045=null
    destructable gg_dest_LTbs_0046=null
    destructable gg_dest_B001_0047=null
    destructable gg_dest_B001_0048=null
    destructable gg_dest_B001_0049=null
    destructable gg_dest_B001_0050=null
    destructable gg_dest_B001_0051=null
    destructable gg_dest_DTg6_0052=null
    destructable gg_dest_B001_0053=null
    destructable gg_dest_B001_0054=null
    destructable gg_dest_B001_0055=null
    destructable gg_dest_B001_0056=null
    destructable gg_dest_B001_0057=null
    destructable gg_dest_LTcr_0058=null
    destructable gg_dest_ITtw_0059=null
    destructable gg_dest_LTbs_0060=null
    destructable gg_dest_LTcr_0061=null
    destructable gg_dest_LTcr_0062=null
    destructable gg_dest_LTbs_0063=null
    destructable gg_dest_LTcr_0064=null
    destructable gg_dest_LTcr_0065=null
    destructable gg_dest_LTcr_0066=null
    destructable gg_dest_LTcr_0067=null
    destructable gg_dest_DTsb_0068=null
    destructable gg_dest_LOcg_0069=null
    destructable gg_dest_LOcg_0070=null
    destructable gg_dest_LOcg_0071=null
    hashtable udg_ItemSaveID
    constant integer udg_BoltRingCount=$A // $A = 10
    timer udg_BlizzagaTimer=CreateTimer()
    integer udg_BlizzagaActiveCount=0
    integer array udg_BlizzagaList
    boolexpr udg_BlizzagaFilter
    timer udg_RapidFireTimer=CreateTimer()
    integer udg_RapidFireActiveCount=0
    group udg_RapidFireGroup=CreateGroup()
    integer array udg_RapidFireList
    timer udg_ShurikenTimer=CreateTimer()
    integer udg_ShurikenActiveCount=0
    integer array udg_ShurikenList
    boolexpr udg_ShurikenFilter
    constant real udg_TatsumakiDuration=25
    timer udg_TatsumakiTimer=CreateTimer()
    integer udg_TatsumakiActiveCount=0
    integer array udg_TatsumakiList
    boolexpr udg_TatsumakiFilter
    timer udg_LiquidSteelTimer=CreateTimer()
    integer udg_LiquidSteelActiveCount=0
    integer array udg_LiquidSteelList
    boolexpr udg_LiquidSteelFilter
    player udg_FilterOwner
    constant integer udg_WickedWhirlDuration=$85 // $85 = 133
    timer udg_WickedWhirlTimer=CreateTimer()
    integer udg_WickedWhirlActiveCount=0
    integer array udg_WickedWhirlList
    boolexpr udg_WickedWhirlFilter
    constant integer udg_ClioneDuration=$A // $A = 10
    timer udg_ClioneTimer=CreateTimer()
    integer udg_ClioneActiveCount=0
    integer array udg_ClioneList
    constant integer udg_AutosavePlayerCount=$A // $A = 10
    integer udg_AutosaveNextPlayer=0
    trigger udg_SaveToFileTrig
    trigger udg_AutosaveTimerTrig
    trigger udg_NewGamePlusTrig
    trigger udg_NewGameMinusTrig
    integer udg_KnockFreeHead=0
    integer udg_KnockCount=0
    integer array udg_KnockNext
    unit array udg_KnockUnit
    real array udg_KnockSpeed
    real array udg_KnockDecay
    real array udg_KnockCosA
    real array udg_KnockSinA
    real array udg_KnockX
    real array udg_KnockY
    real array udg_KnockTreeRadius
    real array udg_KnockDamage
    unit array udg_KnockSource
    string array udg_KnockEffect
    integer array udg_KnockIndex
    integer udg_SaveBufferFreeHead=0
    integer udg_SaveBufferCount=0
    integer array udg_SaveBufferNext
    integer array udg_SaveVersion
    player array udg_SavePlayer
    string array udg_SaveCodePlain
    integer array udg_CodeKey
    integer array udg_CodeBuffer
    integer array udg_CodeBits
    string array udg_SaveCodeChunk
    integer array udg_SaveChunkBase
    integer udg_SaveSlotCount=0
    integer udg_SaveSlotFreeCount=0
    integer array udg_CodeSlot
    integer array udg_CodeSlotStack
    integer array udg_SaveChunkIndex
    integer array udg_SaveLevelValue
    integer array udg_SaveLevelBase
    integer array udg_SaveLevelCount
    integer array udg_SaveLevelMinCount
    integer array udg_SaveLevelMaxCount
    integer array udg_SaveTechValue
    integer array udg_SaveTechBase
    integer array udg_SaveTechCount
    integer array udg_SaveTechMinCount
    integer array udg_SaveTechMaxCount
    integer array udg_SaveExtraCount
    string array udg_CodeFormat
    integer array udg_CodeReadPos
    integer array udg_CodeArmoryPos
    boolean array udg_CodeCapFlag
    integer array udg_CodeChecksum
    string array udg_CodeFormatRead
    integer udg_MissileFreeHead=0
    integer udg_MissileCount=0
    integer array udg_MissileNext
    unit array udg_MissileCaster
    unit array udg_MissileTarget
    unit array gg_unit_h020_0269
    real array udg_MissileSpeed
    real array udg_MissileCosA
    real array udg_MissileSinA
    real array udg_MissileRange
    real array udg_MissileCollisionRange
    real array udg_MissileX
    real array udg_MissileY
    real array udg_MissileSplashRadius
    real array udg_MissileImpactDamage
    real array udg_MissileAoE
    real array udg_MissileTravelDamage
    boolean array udg_MissileFalloff
    boolean array udg_MissileKnockback
    integer array udg_MissileElement
    attacktype array udg_MissileAttackType
    boolean array udg_MissileIsMagic
    boolean array udg_MissileIsPure
    boolean array udg_MissileTrueDamage
    integer array udg_MissileHealCredit
    boolean array udg_MissileHoming
    effect array udg_MissileModelEffect
    effect array udg_MissileTrailEffect
    string array udg_MissileImpactEffect
    string array udg_MissileImpactEffect2
    string array udg_MissileHitEffect
    integer array udg_MissileIndex
    boolean array udg_MissileHitOnce
    group array udg_MissileHitGroup
    group udg_MissileEnumGroup=CreateGroup()
    real udg_MissileDX
    real udg_MissileDY
    real udg_MissileDistance
    integer udg_BlizzagaRecycle=0
    integer udg_BlizzagaCount=0
    integer array udg_BlizzagaNext
    unit array udg_BlizzagaCaster
    boolean array udg_BlizzagaSplits
    real array udg_BlizzagaAngle
    real array udg_BlizzagaDist
    real array udg_BlizzagaX
    real array udg_BlizzagaY
    real array udg_BlizzagaDmg
    real array udg_BlizzagaShardDmg
    player array udg_BlizzagaOwner
    integer array udg_BlizzagaIndex
    group udg_BlizzagaGroup=CreateGroup()
    unit gg_unit_h01B_0270
    integer udg_RapidFireRecycle=0
    integer udg_RapidFireCount=0
    integer array udg_RapidFireNext
    unit array udg_RapidFireShooter
    real array udg_RapidFireDmg
    integer array udg_RapidFireElement
    string array udg_RapidFireMissileFx
    string array udg_RapidFireImpactFx
    integer array udg_RapidFireShots
    integer array udg_RapidFireIndex
    integer udg_ShurikenRecycle=0
    integer udg_ShurikenCount=0
    integer array udg_ShurikenNext
    unit array udg_ShurikenCaster
    unit array gg_unit_h020_0271
    boolean array udg_ShurikenReturning
    integer array udg_ShurikenSide
    real array udg_ShurikenDamage
    real array udg_ShurikenAngle
    real array udg_ShurikenX
    real array udg_ShurikenY
    real array udg_ShurikenRadius
    effect array udg_ShurikenEffect
    player array udg_ShurikenOwner
    group array udg_ShurikenHitGroupA
    group array udg_ShurikenHitGroupB
    integer array udg_ShurikenIndex
    group udg_ShurikenEnumGroup=CreateGroup()
    integer udg_TatsumakiRecycle=0
    integer udg_TatsumakiCount=0
    integer array udg_TatsumakiNext
    unit array udg_TatsumakiCaster
    real array udg_TatsumakiTickDamage
    real array udg_TatsumakiStompDamage
    integer array udg_TatsumakiTicks
    boolean array udg_TatsumakiHitTick
    player array udg_TatsumakiOwner
    integer array udg_TatsumakiIndex
    group udg_TatsumakiGroup=CreateGroup()
    integer udg_LiquidSteelRecycle=0
    integer udg_LiquidSteelCount=0
    integer array udg_LiquidSteelNext
    unit array udg_LiquidSteelCaster
    unit array gg_unit_h020_0272
    unit array udg_LiquidSteelTarget
    unit array udg_LiquidSteelPrevTarget
    real array udg_LiquidSteelDmg
    real array udg_LiquidSteelX
    real array udg_LiquidSteelY
    integer array udg_LiquidSteelBounces
    integer array udg_LiquidSteelDelay
    effect array udg_LiquidSteelEffect
    player array udg_LiquidSteelOwner
    integer array udg_LiquidSteelIndex
    group udg_LiquidSteelGroup=CreateGroup()
    integer udg_WickedWhirlRecycle=0
    integer udg_WickedWhirlCount=0
    integer array udg_WickedWhirlNext
    unit array udg_WickedWhirlCaster
    unit array udg_WickedWhirlTarget
    unit array gg_unit_h020_0273
    integer array udg_WickedWhirlTicks
    real array udg_WickedWhirlAngle
    effect array udg_WickedWhirlEffect
    integer array udg_WickedWhirlIndex
    group udg_WickedWhirlGroup=CreateGroup()
    integer udg_ClioneRecycle=0
    integer udg_ClioneCount=0
    integer array udg_ClioneNext
    unit array udg_ClioneCaster
    real array udg_ClioneDmg
    integer array udg_ClioneTicks
    integer array udg_ClioneIndex
    string array udg_MusicPlayingFile
    boolean array udg_MusicEnabled
    boolean array udg_MusicUseCustom
    boolean array udg_MusicAnnounce
    string array udg_MusicPathPrefix
    string array udg_MusicBlizzTrack
    string array udg_MusicCustomTrack
    integer array udg_Pow2
    integer array udg_SaveStructKind
    trigger array udg_CodeFreeTrig
    trigger udg_KnockRemoveTrig
    trigger udg_CodeCreateTrig
    trigger udg_CodeWriteIntTrig
    trigger udg_CodeReadIntTrig
    trigger udg_MissileCollisionTrig
    trigger udg_MissileDamageTrig
    trigger udg_MissileImpactTrig
    trigger udg_BlizzagaDamageTrig
    trigger udg_BlizzagaRemoveTrig
    trigger udg_RapidFireRemoveTrig
    trigger udg_ShurikenDamageTrig
    trigger udg_ShurikenRemoveTrig
    trigger udg_TatsumakiPullTrig
    trigger udg_TatsumakiStompTrig
    trigger udg_TatsumakiRemoveTrig
    trigger udg_LiquidSteelRemoveTrig
    trigger udg_WickedWhirlDamageTrig
    trigger udg_WickedWhirlRemoveTrig
    trigger udg_ClioneRemoveTrig
    integer udg_ArgInt
    integer udg_ArgBits
    player udg_ArgPlayer
    unit udg_ArgUnit
    real udg_ArgReal
    real udg_ArgRadius
    integer udg_ArgIndex
    integer udg_RetInt
    timer udg_PolledWaitTimer=null
    real udg_EnumDestX=.0
    real udg_EnumDestY=.0
    group udg_EnumGroup=null
    force udg_EnumForce=null
    boolexpr udg_FilterTrue=null
    item udg_LastLootItem=null
    hashtable udg_FixChemistItemHash=null
    item array udg_FixItemSlotDummy
endglobals







