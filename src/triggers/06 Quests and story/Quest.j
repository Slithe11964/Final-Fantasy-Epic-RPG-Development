library TQuest requires TQuestAnnoyingMonster, TQuestAoMadoushi, TQuestArachnophobia, TQuestArcanium, TQuestBeastslayer, TQuestBlazingDemon, TQuestBrothers, TQuestCaravan, TQuestCooking, TQuestCorruptedOrcs, TQuestCrossbow, TQuestDarkKnight, TQuestDeliverLetter, TQuestDivineOrder, TQuestDwarfDisappearance, TQuestEidolonChallenge, TQuestEngineer, TQuestEyeOfJenova, TQuestFallenRanger, TQuestFieryWings, TQuestFireGolem, TQuestFishyDeals, TQuestFountain, TQuestGodDragon, TQuestGreedIsGood, TQuestHarpyHunt, TQuestHolyKnight, TQuestIllusions, TQuestImperviousBeast, TQuestKillElmdor, TQuestKillSetag, TQuestKingOfSea, TQuestLadyNashj, TQuestLastRites, TQuestLightOfJudgment, TQuestLog, TQuestLostMemories, TQuestMonstrum, TQuestNebraAngler, TQuestNightElves, TQuestNorthernGod, TQuestOgreHunt, TQuestOmegaWeapon, TQuestOreSupplies, TQuestPhantomDiary, TQuestPhoenix, TQuestRematch, TQuestSaveTimmy, TQuestScorchedEarth, TQuestScorchingTravel, TQuestSeekDestroy, TQuestShimmerweed, TQuestSpiritHunt, TQuestSpiritOfWater, TQuestStrongestEidolon, TQuestTargetPractice, TQuestTowerSummoning, TQuestTrialByFire, TQuestUltimaWeapon, TQuestWolfFangs, TQuestWorldLiberation, TQuestYoungEngineer, TQuestZodiacAge
function InitTrig_Quest takes nothing returns nothing
endfunction

function RegisterR11_Quest_AnnoyingMonster_Start takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_AnnoyingMonster_Start=CreateTrigger()

call DisableTrigger(gg_trg_Quest_AnnoyingMonster_Start)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_AnnoyingMonster_Start,Player(0),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_AnnoyingMonster_Start,Player(1),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_AnnoyingMonster_Start,Player(2),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_AnnoyingMonster_Start,Player(3),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_AnnoyingMonster_Start,Player(4),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_AnnoyingMonster_Start,Player(5),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_AnnoyingMonster_Start,Player(6),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_AnnoyingMonster_Start,Player(7),true)

call TriggerAddCondition(gg_trg_Quest_AnnoyingMonster_Start,Condition(function Trig_Quest_AnnoyingMonster_Start_Conditions))

call TriggerAddAction(gg_trg_Quest_AnnoyingMonster_Start,function Trig_Quest_AnnoyingMonster_Start_Actions)

endfunction





function RegisterR11_Quest_AoMadoushi_Talk takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_AoMadoushi_Talk=CreateTrigger()

call DisableTrigger(gg_trg_Quest_AoMadoushi_Talk)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_AoMadoushi_Talk,Player(0),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_AoMadoushi_Talk,Player(1),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_AoMadoushi_Talk,Player(2),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_AoMadoushi_Talk,Player(3),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_AoMadoushi_Talk,Player(4),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_AoMadoushi_Talk,Player(5),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_AoMadoushi_Talk,Player(6),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_AoMadoushi_Talk,Player(7),true)

call TriggerAddCondition(gg_trg_Quest_AoMadoushi_Talk,Condition(function Trig_Quest_AoMadoushi_Talk_Conditions))

call TriggerAddAction(gg_trg_Quest_AoMadoushi_Talk,function Trig_Quest_AoMadoushi_Talk_Actions)

endfunction





function RegisterR11_Quest_AoMadoushi_Report takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_AoMadoushi_Report=CreateTrigger()

call DisableTrigger(gg_trg_Quest_AoMadoushi_Report)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_AoMadoushi_Report,Player(0),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_AoMadoushi_Report,Player(1),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_AoMadoushi_Report,Player(2),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_AoMadoushi_Report,Player(3),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_AoMadoushi_Report,Player(4),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_AoMadoushi_Report,Player(5),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_AoMadoushi_Report,Player(6),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_AoMadoushi_Report,Player(7),true)

call TriggerAddCondition(gg_trg_Quest_AoMadoushi_Report,Condition(function Trig_Quest_AoMadoushi_Report_Conditions))

call TriggerAddAction(gg_trg_Quest_AoMadoushi_Report,function Trig_Quest_AoMadoushi_Report_Actions)

endfunction





function RegisterR11_Quest_Arachnophobia_Offer takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_Arachnophobia_Offer=CreateTrigger()

call DisableTrigger(gg_trg_Quest_Arachnophobia_Offer)

call TriggerAddAction(gg_trg_Quest_Arachnophobia_Offer,function Trig_Quest_Arachnophobia_Offer_Actions)

endfunction





function RegisterR11_Quest_Arachnophobia_Start takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_Arachnophobia_Start=CreateTrigger()

call DisableTrigger(gg_trg_Quest_Arachnophobia_Start)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Arachnophobia_Start,Player(0),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Arachnophobia_Start,Player(1),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Arachnophobia_Start,Player(2),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Arachnophobia_Start,Player(3),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Arachnophobia_Start,Player(4),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Arachnophobia_Start,Player(5),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Arachnophobia_Start,Player(6),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Arachnophobia_Start,Player(7),true)

call TriggerAddCondition(gg_trg_Quest_Arachnophobia_Start,Condition(function Trig_Quest_Arachnophobia_Start_Conditions))

call TriggerAddAction(gg_trg_Quest_Arachnophobia_Start,function Trig_Quest_Arachnophobia_Start_Actions)

endfunction





function RegisterR11_Quest_Arachnophobia_Count takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_Arachnophobia_Count=CreateTrigger()

call DisableTrigger(gg_trg_Quest_Arachnophobia_Count)

call TriggerRegisterAnyUnitEventBJ(gg_trg_Quest_Arachnophobia_Count,EVENT_PLAYER_UNIT_DEATH)

call TriggerAddCondition(gg_trg_Quest_Arachnophobia_Count,Condition(function Trig_Quest_Arachnophobia_Count_Conditions))

call TriggerAddAction(gg_trg_Quest_Arachnophobia_Count,function Trig_Quest_Arachnophobia_Count_Actions)

endfunction





function RegisterR11_Quest_Arachnophobia_Reward takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_Arachnophobia_Reward=CreateTrigger()

call DisableTrigger(gg_trg_Quest_Arachnophobia_Reward)

call TriggerRegisterUnitInRangeSimple(gg_trg_Quest_Arachnophobia_Reward,450.,gg_unit_n009_0051)

call TriggerAddCondition(gg_trg_Quest_Arachnophobia_Reward,Condition(function Trig_Quest_Arachnophobia_Reward_Conditions))

call TriggerAddAction(gg_trg_Quest_Arachnophobia_Reward,function Trig_Quest_Arachnophobia_Reward_Actions)

endfunction





function RegisterR11_Quest_Arcanium_Start takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_Arcanium_Start=CreateTrigger()

call DisableTrigger(gg_trg_Quest_Arcanium_Start)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Arcanium_Start,Player(0),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Arcanium_Start,Player(1),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Arcanium_Start,Player(2),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Arcanium_Start,Player(3),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Arcanium_Start,Player(4),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Arcanium_Start,Player(5),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Arcanium_Start,Player(6),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Arcanium_Start,Player(7),true)

call TriggerAddCondition(gg_trg_Quest_Arcanium_Start,Condition(function Trig_Quest_Arcanium_Start_Conditions))

call TriggerAddAction(gg_trg_Quest_Arcanium_Start,function Trig_Quest_Arcanium_Start_Actions)

endfunction





function RegisterR11_Quest_Arcanium_Taken takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_Arcanium_Taken=CreateTrigger()

call DisableTrigger(gg_trg_Quest_Arcanium_Taken)

call TriggerRegisterAnyUnitEventBJ(gg_trg_Quest_Arcanium_Taken,EVENT_PLAYER_UNIT_PICKUP_ITEM)

call TriggerAddCondition(gg_trg_Quest_Arcanium_Taken,Condition(function Trig_Quest_Arcanium_Taken_Conditions))

call TriggerAddAction(gg_trg_Quest_Arcanium_Taken,function Trig_Quest_Arcanium_Taken_Actions)

endfunction





function RegisterR11_Quest_Arcanium_Complete takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_Arcanium_Complete=CreateTrigger()

call DisableTrigger(gg_trg_Quest_Arcanium_Complete)

call TriggerRegisterUnitInRangeSimple(gg_trg_Quest_Arcanium_Complete,450.,gg_unit_Hmbr_0140)

call TriggerAddCondition(gg_trg_Quest_Arcanium_Complete,Condition(function Trig_Quest_Arcanium_Complete_Conditions))

call TriggerAddAction(gg_trg_Quest_Arcanium_Complete,function Trig_Quest_Arcanium_Complete_Actions)

endfunction





function RegisterR11_Quest_Beastslayer_Available takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_Beastslayer_Available=CreateTrigger()

call DisableTrigger(gg_trg_Quest_Beastslayer_Available)

call TriggerAddAction(gg_trg_Quest_Beastslayer_Available,function Trig_Quest_Beastslayer_Available_Actions)

endfunction





function RegisterR11_Quest_Beastslayer_Start takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_Beastslayer_Start=CreateTrigger()

call DisableTrigger(gg_trg_Quest_Beastslayer_Start)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Beastslayer_Start,Player(0),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Beastslayer_Start,Player(1),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Beastslayer_Start,Player(2),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Beastslayer_Start,Player(3),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Beastslayer_Start,Player(4),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Beastslayer_Start,Player(5),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Beastslayer_Start,Player(6),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Beastslayer_Start,Player(7),true)

call TriggerAddCondition(gg_trg_Quest_Beastslayer_Start,Condition(function Trig_Quest_Beastslayer_Start_Conditions))

call TriggerAddAction(gg_trg_Quest_Beastslayer_Start,function Trig_Quest_Beastslayer_Start_Actions)

endfunction





function RegisterR11_Quest_Beastslayer_ArrowDropped takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_Beastslayer_ArrowDropped=CreateTrigger()

call DisableTrigger(gg_trg_Quest_Beastslayer_ArrowDropped)

call TriggerAddAction(gg_trg_Quest_Beastslayer_ArrowDropped,function Trig_Quest_Beastslayer_ArrowDropped_Actions)

endfunction





function RegisterR11_Quest_Beastslayer_Ping takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_Beastslayer_Ping=CreateTrigger()

call DisableTrigger(gg_trg_Quest_Beastslayer_Ping)

call TriggerRegisterTimerEventPeriodic(gg_trg_Quest_Beastslayer_Ping,15.)

call TriggerAddCondition(gg_trg_Quest_Beastslayer_Ping,Condition(function Trig_Quest_Beastslayer_Ping_Conditions))

call TriggerAddAction(gg_trg_Quest_Beastslayer_Ping,function Trig_Quest_Beastslayer_Ping_Actions)

endfunction





function RegisterR11_Quest_Beastslayer_ArrowTaken takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_Beastslayer_ArrowTaken=CreateTrigger()

call DisableTrigger(gg_trg_Quest_Beastslayer_ArrowTaken)

call TriggerRegisterAnyUnitEventBJ(gg_trg_Quest_Beastslayer_ArrowTaken,EVENT_PLAYER_UNIT_PICKUP_ITEM)

call TriggerAddCondition(gg_trg_Quest_Beastslayer_ArrowTaken,Condition(function Trig_Quest_Beastslayer_ArrowTaken_Conditions))

call TriggerAddAction(gg_trg_Quest_Beastslayer_ArrowTaken,function Trig_Quest_Beastslayer_ArrowTaken_Actions)

endfunction





function RegisterR11_Quest_Beastslayer_Complete takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_Beastslayer_Complete=CreateTrigger()

call DisableTrigger(gg_trg_Quest_Beastslayer_Complete)

call TriggerRegisterUnitInRangeSimple(gg_trg_Quest_Beastslayer_Complete,450.,gg_unit_n00D_0091)

call TriggerAddCondition(gg_trg_Quest_Beastslayer_Complete,Condition(function Trig_Quest_Beastslayer_Complete_Conditions))

call TriggerAddAction(gg_trg_Quest_Beastslayer_Complete,function Trig_Quest_Beastslayer_Complete_Actions)

endfunction





function RegisterR11_Quest_BlazingDemon_Start takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_BlazingDemon_Start=CreateTrigger()

call DisableTrigger(gg_trg_Quest_BlazingDemon_Start)

call TriggerAddAction(gg_trg_Quest_BlazingDemon_Start,function Trig_Quest_BlazingDemon_Start_Actions)

endfunction





function RegisterR11_Quest_BlazingDemon_EndWeak takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_BlazingDemon_EndWeak=CreateTrigger()

call DisableTrigger(gg_trg_Quest_BlazingDemon_EndWeak)

call TriggerRegisterUnitEvent(gg_trg_Quest_BlazingDemon_EndWeak,gg_unit_U00G_0220,EVENT_UNIT_DEATH)

call TriggerAddAction(gg_trg_Quest_BlazingDemon_EndWeak,function Trig_Quest_BlazingDemon_EndWeak_Actions)

endfunction





function RegisterR11_Quest_BlazingDemon_End takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_BlazingDemon_End=CreateTrigger()

call DisableTrigger(gg_trg_Quest_BlazingDemon_End)

call TriggerRegisterUnitEvent(gg_trg_Quest_BlazingDemon_End,gg_unit_U00G_0220,EVENT_UNIT_DEATH)

call TriggerAddAction(gg_trg_Quest_BlazingDemon_End,function Trig_Quest_BlazingDemon_End_Actions)

endfunction





function RegisterR11_Quest_BlazingDemon_Escape takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_BlazingDemon_Escape=CreateTrigger()

call DisableTrigger(gg_trg_Quest_BlazingDemon_Escape)

call TriggerRegisterUnitEvent(gg_trg_Quest_BlazingDemon_Escape,gg_unit_U00G_0220,EVENT_UNIT_DEATH)

call TriggerAddAction(gg_trg_Quest_BlazingDemon_Escape,function Trig_Quest_BlazingDemon_Escape_Actions)

endfunction





function RegisterR11_Quest_Brothers_Init takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_Brothers_Init=CreateTrigger()

call TriggerAddAction(gg_trg_Quest_Brothers_Init,function Trig_Quest_Brothers_Init_Actions)

endfunction





function RegisterR11_Quest_Brothers_Available takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_Brothers_Available=CreateTrigger()

call DisableTrigger(gg_trg_Quest_Brothers_Available)

call TriggerAddAction(gg_trg_Quest_Brothers_Available,function Trig_Quest_Brothers_Available_Actions)

endfunction





function RegisterR11_Quest_Brothers_Start takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_Brothers_Start=CreateTrigger()

call DisableTrigger(gg_trg_Quest_Brothers_Start)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Brothers_Start,Player(0),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Brothers_Start,Player(1),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Brothers_Start,Player(2),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Brothers_Start,Player(3),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Brothers_Start,Player(4),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Brothers_Start,Player(5),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Brothers_Start,Player(6),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Brothers_Start,Player(7),true)

call TriggerAddCondition(gg_trg_Quest_Brothers_Start,Condition(function Trig_Quest_Brothers_Start_Conditions))

call TriggerAddAction(gg_trg_Quest_Brothers_Start,function Trig_Quest_Brothers_Start_Actions)

endfunction





function RegisterR11_Quest_Brothers_Defeated takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_Brothers_Defeated=CreateTrigger()

call DisableTrigger(gg_trg_Quest_Brothers_Defeated)

call TriggerRegisterUnitEvent(gg_trg_Quest_Brothers_Defeated,gg_unit_Ocb2_0147,EVENT_UNIT_DEATH)

call TriggerRegisterUnitEvent(gg_trg_Quest_Brothers_Defeated,gg_unit_Ocbh_0148,EVENT_UNIT_DEATH)

call TriggerAddAction(gg_trg_Quest_Brothers_Defeated,function Trig_Quest_Brothers_Defeated_Actions)

endfunction





function RegisterR11_Quest_Brothers_Complete takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_Brothers_Complete=CreateTrigger()

call DisableTrigger(gg_trg_Quest_Brothers_Complete)

call TriggerRegisterUnitInRangeSimple(gg_trg_Quest_Brothers_Complete,450.,gg_unit_Hdgo_0097)

call TriggerAddCondition(gg_trg_Quest_Brothers_Complete,Condition(function Trig_Quest_Brothers_Complete_Conditions))

call TriggerAddAction(gg_trg_Quest_Brothers_Complete,function Trig_Quest_Brothers_Complete_Actions)

endfunction





function RegisterR11_Quest_Caravan_SamAvailable takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_Caravan_SamAvailable=CreateTrigger()

call DisableTrigger(gg_trg_Quest_Caravan_SamAvailable)

call TriggerAddAction(gg_trg_Quest_Caravan_SamAvailable,function Trig_Quest_Caravan_SamAvailable_Actions)

endfunction





function RegisterR11_Quest_Caravan_SamRequest takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_Caravan_SamRequest=CreateTrigger()

call DisableTrigger(gg_trg_Quest_Caravan_SamRequest)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Caravan_SamRequest,Player(0),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Caravan_SamRequest,Player(1),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Caravan_SamRequest,Player(2),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Caravan_SamRequest,Player(3),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Caravan_SamRequest,Player(4),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Caravan_SamRequest,Player(5),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Caravan_SamRequest,Player(6),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Caravan_SamRequest,Player(7),true)

call TriggerAddCondition(gg_trg_Quest_Caravan_SamRequest,Condition(function Trig_Quest_Caravan_SamRequest_Conditions))

call TriggerAddAction(gg_trg_Quest_Caravan_SamRequest,function Trig_Quest_Caravan_SamRequest_Actions)

endfunction





function RegisterR11_Quest_Caravan_DioRefuses takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_Caravan_DioRefuses=CreateTrigger()

call DisableTrigger(gg_trg_Quest_Caravan_DioRefuses)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Caravan_DioRefuses,Player(0),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Caravan_DioRefuses,Player(1),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Caravan_DioRefuses,Player(2),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Caravan_DioRefuses,Player(3),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Caravan_DioRefuses,Player(4),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Caravan_DioRefuses,Player(5),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Caravan_DioRefuses,Player(6),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Caravan_DioRefuses,Player(7),true)

call TriggerAddCondition(gg_trg_Quest_Caravan_DioRefuses,Condition(function Trig_Quest_Caravan_DioRefuses_Conditions))

call TriggerAddAction(gg_trg_Quest_Caravan_DioRefuses,function Trig_Quest_Caravan_DioRefuses_Actions)

endfunction





function RegisterR11_Quest_Caravan_Enable takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_Caravan_Enable=CreateTrigger()

call DisableTrigger(gg_trg_Quest_Caravan_Enable)

call TriggerAddAction(gg_trg_Quest_Caravan_Enable,function Trig_Quest_Caravan_Enable_Actions)

endfunction





function RegisterR11_Quest_Caravan_Start takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_Caravan_Start=CreateTrigger()

call DisableTrigger(gg_trg_Quest_Caravan_Start)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Caravan_Start,Player(0),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Caravan_Start,Player(1),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Caravan_Start,Player(2),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Caravan_Start,Player(3),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Caravan_Start,Player(4),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Caravan_Start,Player(5),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Caravan_Start,Player(6),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Caravan_Start,Player(7),true)

call TriggerAddCondition(gg_trg_Quest_Caravan_Start,Condition(function Trig_Quest_Caravan_Start_Conditions))

call TriggerAddAction(gg_trg_Quest_Caravan_Start,function Trig_Quest_Caravan_Start_Actions)

endfunction





function RegisterR11_Quest_Caravan_HorsesVulnerable takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_Caravan_HorsesVulnerable=CreateTrigger()

call DisableTrigger(gg_trg_Quest_Caravan_HorsesVulnerable)

call TriggerRegisterLeaveRectSimple(gg_trg_Quest_Caravan_HorsesVulnerable,gg_rct_498)

call TriggerAddCondition(gg_trg_Quest_Caravan_HorsesVulnerable,Condition(function Trig_Quest_Caravan_HorsesVulnerable_Conditions))

call TriggerAddAction(gg_trg_Quest_Caravan_HorsesVulnerable,function Trig_Quest_Caravan_HorsesVulnerable_Actions)

endfunction





function RegisterR11_Quest_Caravan_Deliver takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_Caravan_Deliver=CreateTrigger()

call DisableTrigger(gg_trg_Quest_Caravan_Deliver)

call TriggerRegisterUnitInRangeSimple(gg_trg_Quest_Caravan_Deliver,450.,gg_unit_n00B_0054)

call TriggerAddCondition(gg_trg_Quest_Caravan_Deliver,Condition(function Trig_Quest_Caravan_Deliver_Conditions))

call TriggerAddAction(gg_trg_Quest_Caravan_Deliver,function Trig_Quest_Caravan_Deliver_Actions)

endfunction





function RegisterR11_Quest_Caravan_Failed takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_Caravan_Failed=CreateTrigger()

call DisableTrigger(gg_trg_Quest_Caravan_Failed)

call TriggerRegisterUnitEvent(gg_trg_Quest_Caravan_Failed,gg_unit_hrdh_0102,EVENT_UNIT_DEATH)

call TriggerRegisterUnitEvent(gg_trg_Quest_Caravan_Failed,gg_unit_hrdh_0103,EVENT_UNIT_DEATH)

call TriggerRegisterUnitEvent(gg_trg_Quest_Caravan_Failed,gg_unit_hrdh_0104,EVENT_UNIT_DEATH)

call TriggerAddCondition(gg_trg_Quest_Caravan_Failed,Condition(function Trig_Quest_Caravan_Failed_Conditions))

call TriggerAddAction(gg_trg_Quest_Caravan_Failed,function Trig_Quest_Caravan_Failed_Actions)

endfunction





function RegisterR11_Quest_Caravan_Ping takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_Caravan_Ping=CreateTrigger()

call DisableTrigger(gg_trg_Quest_Caravan_Ping)

call TriggerRegisterTimerEventPeriodic(gg_trg_Quest_Caravan_Ping,15.)

call TriggerAddCondition(gg_trg_Quest_Caravan_Ping,Condition(function Trig_Quest_Caravan_Ping_Conditions))

call TriggerAddAction(gg_trg_Quest_Caravan_Ping,function Trig_Quest_Caravan_Ping_Actions)

endfunction





function RegisterR11_Quest_Caravan_Complete takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_Caravan_Complete=CreateTrigger()

call DisableTrigger(gg_trg_Quest_Caravan_Complete)

call TriggerRegisterUnitInRangeSimple(gg_trg_Quest_Caravan_Complete,450.,gg_unit_n00A_0101)

call TriggerAddCondition(gg_trg_Quest_Caravan_Complete,Condition(function Trig_Quest_Caravan_Complete_Conditions))

call TriggerAddAction(gg_trg_Quest_Caravan_Complete,function Trig_Quest_Caravan_Complete_Actions)

endfunction





function RegisterR11_Quest_Cooking_Start takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_Cooking_Start=CreateTrigger()

call TriggerRegisterUnitInRangeSimple(gg_trg_Quest_Cooking_Start,450.,gg_unit_n0KG_0263)

call TriggerAddCondition(gg_trg_Quest_Cooking_Start,Condition(function Trig_Quest_Cooking_Start_Conditions))

call TriggerAddAction(gg_trg_Quest_Cooking_Start,function Trig_Quest_Cooking_Start_Actions)

endfunction





function RegisterR11_Quest_Cooking_Complete takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_Cooking_Complete=CreateTrigger()

call DisableTrigger(gg_trg_Quest_Cooking_Complete)

call TriggerRegisterTimerExpireEventBJ(gg_trg_Quest_Cooking_Complete,udg_ShortDelayTimer)

call TriggerAddAction(gg_trg_Quest_Cooking_Complete,function Trig_Quest_Cooking_Complete_Actions)

endfunction





function RegisterR11_Quest_CorruptedOrcs_Start takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_CorruptedOrcs_Start=CreateTrigger()

call DisableTrigger(gg_trg_Quest_CorruptedOrcs_Start)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_CorruptedOrcs_Start,Player(0),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_CorruptedOrcs_Start,Player(1),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_CorruptedOrcs_Start,Player(2),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_CorruptedOrcs_Start,Player(3),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_CorruptedOrcs_Start,Player(4),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_CorruptedOrcs_Start,Player(5),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_CorruptedOrcs_Start,Player(6),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_CorruptedOrcs_Start,Player(7),true)

call TriggerAddCondition(gg_trg_Quest_CorruptedOrcs_Start,Condition(function Trig_Quest_CorruptedOrcs_Start_Conditions))

call TriggerAddAction(gg_trg_Quest_CorruptedOrcs_Start,function Trig_Quest_CorruptedOrcs_Start_Actions)

endfunction





function RegisterR11_Quest_Crossbow_NeedEnemies takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_Crossbow_NeedEnemies=CreateTrigger()

call DisableTrigger(gg_trg_Quest_Crossbow_NeedEnemies)

call TriggerRegisterAnyUnitEventBJ(gg_trg_Quest_Crossbow_NeedEnemies,EVENT_PLAYER_UNIT_SPELL_CHANNEL)

call TriggerAddCondition(gg_trg_Quest_Crossbow_NeedEnemies,Condition(function Trig_Quest_Crossbow_NeedEnemies_Conditions))

call TriggerAddAction(gg_trg_Quest_Crossbow_NeedEnemies,function Trig_Quest_Crossbow_NeedEnemies_Actions)

endfunction





function RegisterR11_Quest_Crossbow_Tested takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_Crossbow_Tested=CreateTrigger()

call DisableTrigger(gg_trg_Quest_Crossbow_Tested)

call TriggerRegisterAnyUnitEventBJ(gg_trg_Quest_Crossbow_Tested,EVENT_PLAYER_UNIT_USE_ITEM)

call TriggerAddCondition(gg_trg_Quest_Crossbow_Tested,Condition(function Trig_Quest_Crossbow_Tested_Conditions))

call TriggerAddAction(gg_trg_Quest_Crossbow_Tested,function Trig_Quest_Crossbow_Tested_Actions)

endfunction





function RegisterR11_Quest_DarkKnight_Start takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_DarkKnight_Start=CreateTrigger()

call DisableTrigger(gg_trg_Quest_DarkKnight_Start)

call TriggerAddAction(gg_trg_Quest_DarkKnight_Start,function Trig_Quest_DarkKnight_Start_Actions)

endfunction





function RegisterR11_Quest_DeliverLetter_Init takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_DeliverLetter_Init=CreateTrigger()

call TriggerAddAction(gg_trg_Quest_DeliverLetter_Init,function Trig_Quest_DeliverLetter_Init_Actions)

endfunction





function RegisterR11_Quest_DeliverLetter_Available takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_DeliverLetter_Available=CreateTrigger()

call DisableTrigger(gg_trg_Quest_DeliverLetter_Available)

call TriggerAddAction(gg_trg_Quest_DeliverLetter_Available,function Trig_Quest_DeliverLetter_Available_Actions)

endfunction





function RegisterR11_Quest_DeliverLetter_Start takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_DeliverLetter_Start=CreateTrigger()

call DisableTrigger(gg_trg_Quest_DeliverLetter_Start)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_DeliverLetter_Start,Player(0),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_DeliverLetter_Start,Player(1),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_DeliverLetter_Start,Player(2),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_DeliverLetter_Start,Player(3),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_DeliverLetter_Start,Player(4),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_DeliverLetter_Start,Player(5),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_DeliverLetter_Start,Player(6),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_DeliverLetter_Start,Player(7),true)

call TriggerAddCondition(gg_trg_Quest_DeliverLetter_Start,Condition(function Trig_Quest_DeliverLetter_Start_Conditions))

call TriggerAddAction(gg_trg_Quest_DeliverLetter_Start,function Trig_Quest_DeliverLetter_Start_Actions)

endfunction





function RegisterR11_Quest_DeliverLetter_PingZack takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_DeliverLetter_PingZack=CreateTrigger()

call DisableTrigger(gg_trg_Quest_DeliverLetter_PingZack)

call TriggerRegisterTimerEventPeriodic(gg_trg_Quest_DeliverLetter_PingZack,15.)

call TriggerAddCondition(gg_trg_Quest_DeliverLetter_PingZack,Condition(function Trig_Quest_DeliverLetter_PingZack_Conditions))

call TriggerAddAction(gg_trg_Quest_DeliverLetter_PingZack,function Trig_Quest_DeliverLetter_PingZack_Actions)

endfunction





function RegisterR11_Quest_DeliverLetter_PingWedge takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_DeliverLetter_PingWedge=CreateTrigger()

call DisableTrigger(gg_trg_Quest_DeliverLetter_PingWedge)

call TriggerRegisterTimerEventPeriodic(gg_trg_Quest_DeliverLetter_PingWedge,15.)

call TriggerAddCondition(gg_trg_Quest_DeliverLetter_PingWedge,Condition(function Trig_Quest_DeliverLetter_PingWedge_Conditions))

call TriggerAddAction(gg_trg_Quest_DeliverLetter_PingWedge,function Trig_Quest_DeliverLetter_PingWedge_Actions)

endfunction





function RegisterR11_Quest_DeliverLetter_GiveZack takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_DeliverLetter_GiveZack=CreateTrigger()

call DisableTrigger(gg_trg_Quest_DeliverLetter_GiveZack)

call TriggerRegisterUnitInRangeSimple(gg_trg_Quest_DeliverLetter_GiveZack,450.,gg_unit_n00K_0150)

call TriggerAddCondition(gg_trg_Quest_DeliverLetter_GiveZack,Condition(function Trig_Quest_DeliverLetter_GiveZack_Conditions))

call TriggerAddAction(gg_trg_Quest_DeliverLetter_GiveZack,function Trig_Quest_DeliverLetter_GiveZack_Actions)

endfunction





function RegisterR11_Quest_DeliverLetter_Complete takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_DeliverLetter_Complete=CreateTrigger()

call DisableTrigger(gg_trg_Quest_DeliverLetter_Complete)

call TriggerRegisterUnitInRangeSimple(gg_trg_Quest_DeliverLetter_Complete,450.,gg_unit_h00K_0137)

call TriggerAddCondition(gg_trg_Quest_DeliverLetter_Complete,Condition(function Trig_Quest_DeliverLetter_Complete_Conditions))

call TriggerAddAction(gg_trg_Quest_DeliverLetter_Complete,function Trig_Quest_DeliverLetter_Complete_Actions)

endfunction





function RegisterR11_Quest_DivineOrder_Start takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_DivineOrder_Start=CreateTrigger()

call DisableTrigger(gg_trg_Quest_DivineOrder_Start)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_DivineOrder_Start,Player(0),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_DivineOrder_Start,Player(1),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_DivineOrder_Start,Player(2),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_DivineOrder_Start,Player(3),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_DivineOrder_Start,Player(4),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_DivineOrder_Start,Player(5),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_DivineOrder_Start,Player(6),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_DivineOrder_Start,Player(7),true)

call TriggerAddCondition(gg_trg_Quest_DivineOrder_Start,Condition(function Trig_Quest_DivineOrder_Start_Conditions))

call TriggerAddAction(gg_trg_Quest_DivineOrder_Start,function Trig_Quest_DivineOrder_Start_Actions)

endfunction





function RegisterR11_Quest_DivineOrder_Complete takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_DivineOrder_Complete=CreateTrigger()

call DisableTrigger(gg_trg_Quest_DivineOrder_Complete)

call TriggerRegisterUnitEvent(gg_trg_Quest_DivineOrder_Complete,gg_unit_H036_0254,EVENT_UNIT_DEATH)

call TriggerAddAction(gg_trg_Quest_DivineOrder_Complete,function Trig_Quest_DivineOrder_Complete_Actions)

endfunction





function RegisterR11_Quest_DwarfDisappearance_Start takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_DwarfDisappearance_Start=CreateTrigger()

call DisableTrigger(gg_trg_Quest_DwarfDisappearance_Start)

call TriggerRegisterEnterRectSimple(gg_trg_Quest_DwarfDisappearance_Start,gg_rct_696)

call TriggerAddCondition(gg_trg_Quest_DwarfDisappearance_Start,Condition(function Trig_Quest_DwarfDisappearance_Start_Conditions))

call TriggerAddAction(gg_trg_Quest_DwarfDisappearance_Start,function Trig_Quest_DwarfDisappearance_Start_Actions)

endfunction





function RegisterR11_Quest_EidolonChallenge_Start takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_EidolonChallenge_Start=CreateTrigger()

call DisableTrigger(gg_trg_Quest_EidolonChallenge_Start)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_EidolonChallenge_Start,Player(0),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_EidolonChallenge_Start,Player(1),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_EidolonChallenge_Start,Player(2),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_EidolonChallenge_Start,Player(3),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_EidolonChallenge_Start,Player(4),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_EidolonChallenge_Start,Player(5),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_EidolonChallenge_Start,Player(6),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_EidolonChallenge_Start,Player(7),true)

call TriggerAddCondition(gg_trg_Quest_EidolonChallenge_Start,Condition(function Trig_Quest_EidolonChallenge_Start_Conditions))

call TriggerAddAction(gg_trg_Quest_EidolonChallenge_Start,function Trig_Quest_EidolonChallenge_Start_Actions)

endfunction





function RegisterR11_Quest_EidolonChallenge_Count takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_EidolonChallenge_Count=CreateTrigger()

call DisableTrigger(gg_trg_Quest_EidolonChallenge_Count)

call TriggerRegisterUnitEvent(gg_trg_Quest_EidolonChallenge_Count,gg_unit_H01I_0070,EVENT_UNIT_DEATH)

call TriggerRegisterUnitEvent(gg_trg_Quest_EidolonChallenge_Count,gg_unit_H01J_0069,EVENT_UNIT_DEATH)

call TriggerRegisterUnitEvent(gg_trg_Quest_EidolonChallenge_Count,gg_unit_H01K_0068,EVENT_UNIT_DEATH)

call TriggerRegisterUnitEvent(gg_trg_Quest_EidolonChallenge_Count,gg_unit_H01L_0067,EVENT_UNIT_DEATH)

call TriggerAddAction(gg_trg_Quest_EidolonChallenge_Count,function Trig_Quest_EidolonChallenge_Count_Actions)

endfunction





function RegisterR11_Quest_EidolonChallenge_Complete takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_EidolonChallenge_Complete=CreateTrigger()

call DisableTrigger(gg_trg_Quest_EidolonChallenge_Complete)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_EidolonChallenge_Complete,Player(0),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_EidolonChallenge_Complete,Player(1),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_EidolonChallenge_Complete,Player(2),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_EidolonChallenge_Complete,Player(3),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_EidolonChallenge_Complete,Player(4),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_EidolonChallenge_Complete,Player(5),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_EidolonChallenge_Complete,Player(6),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_EidolonChallenge_Complete,Player(7),true)

call TriggerAddCondition(gg_trg_Quest_EidolonChallenge_Complete,Condition(function Trig_Quest_EidolonChallenge_Complete_Conditions))

call TriggerAddAction(gg_trg_Quest_EidolonChallenge_Complete,function Trig_Quest_EidolonChallenge_Complete_Actions)

endfunction





function RegisterR11_Quest_Engineer_GetAdvice takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_Engineer_GetAdvice=CreateTrigger()

call DisableTrigger(gg_trg_Quest_Engineer_GetAdvice)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Engineer_GetAdvice,Player(0),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Engineer_GetAdvice,Player(1),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Engineer_GetAdvice,Player(2),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Engineer_GetAdvice,Player(3),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Engineer_GetAdvice,Player(4),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Engineer_GetAdvice,Player(5),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Engineer_GetAdvice,Player(6),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Engineer_GetAdvice,Player(7),true)

call TriggerAddCondition(gg_trg_Quest_Engineer_GetAdvice,Condition(function Trig_Quest_Engineer_GetAdvice_Conditions))

call TriggerAddAction(gg_trg_Quest_Engineer_GetAdvice,function Trig_Quest_Engineer_GetAdvice_Actions)

endfunction





function RegisterR11_Quest_EyeOfJenova_PickUp takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_EyeOfJenova_PickUp=CreateTrigger()

call DisableTrigger(gg_trg_Quest_EyeOfJenova_PickUp)

call TriggerRegisterAnyUnitEventBJ(gg_trg_Quest_EyeOfJenova_PickUp,EVENT_PLAYER_UNIT_PICKUP_ITEM)

call TriggerAddCondition(gg_trg_Quest_EyeOfJenova_PickUp,Condition(function Trig_Quest_EyeOfJenova_PickUp_Conditions))

call TriggerAddAction(gg_trg_Quest_EyeOfJenova_PickUp,function Trig_Quest_EyeOfJenova_PickUp_Actions)

endfunction





function RegisterR11_Quest_EyeOfJenova_Deliver takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_EyeOfJenova_Deliver=CreateTrigger()

call DisableTrigger(gg_trg_Quest_EyeOfJenova_Deliver)

call TriggerRegisterUnitInRangeSimple(gg_trg_Quest_EyeOfJenova_Deliver,450.,gg_unit_Othr_0106)

call TriggerAddCondition(gg_trg_Quest_EyeOfJenova_Deliver,Condition(function Trig_Quest_EyeOfJenova_Deliver_Conditions))

call TriggerAddAction(gg_trg_Quest_EyeOfJenova_Deliver,function Trig_Quest_EyeOfJenova_Deliver_Actions)

endfunction





function RegisterR11_Quest_FallenRanger_Start takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_FallenRanger_Start=CreateTrigger()

call DisableTrigger(gg_trg_Quest_FallenRanger_Start)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_FallenRanger_Start,Player(0),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_FallenRanger_Start,Player(1),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_FallenRanger_Start,Player(2),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_FallenRanger_Start,Player(3),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_FallenRanger_Start,Player(4),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_FallenRanger_Start,Player(5),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_FallenRanger_Start,Player(6),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_FallenRanger_Start,Player(7),true)

call TriggerAddCondition(gg_trg_Quest_FallenRanger_Start,Condition(function Trig_Quest_FallenRanger_Start_Conditions))

call TriggerAddAction(gg_trg_Quest_FallenRanger_Start,function Trig_Quest_FallenRanger_Start_Actions)

endfunction





function RegisterR11_Quest_FallenRanger_Complete takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_FallenRanger_Complete=CreateTrigger()

call DisableTrigger(gg_trg_Quest_FallenRanger_Complete)

call TriggerRegisterUnitInRangeSimple(gg_trg_Quest_FallenRanger_Complete,450.,gg_unit_n01Y_0131)

call TriggerAddCondition(gg_trg_Quest_FallenRanger_Complete,Condition(function Trig_Quest_FallenRanger_Complete_Conditions))

call TriggerAddAction(gg_trg_Quest_FallenRanger_Complete,function Trig_Quest_FallenRanger_Complete_Actions)

endfunction





function RegisterR11_Quest_FieryWings_Start takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_FieryWings_Start=CreateTrigger()

call DisableTrigger(gg_trg_Quest_FieryWings_Start)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_FieryWings_Start,Player(0),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_FieryWings_Start,Player(1),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_FieryWings_Start,Player(2),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_FieryWings_Start,Player(3),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_FieryWings_Start,Player(4),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_FieryWings_Start,Player(5),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_FieryWings_Start,Player(6),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_FieryWings_Start,Player(7),true)

call TriggerAddCondition(gg_trg_Quest_FieryWings_Start,Condition(function Trig_Quest_FieryWings_Start_Conditions))

call TriggerAddAction(gg_trg_Quest_FieryWings_Start,function Trig_Quest_FieryWings_Start_Actions)

endfunction





function RegisterR11_Quest_FieryWings_Matriarch_Dead takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_FieryWings_Matriarch_Dead=CreateTrigger()

call DisableTrigger(gg_trg_Quest_FieryWings_Matriarch_Dead)

call TriggerAddCondition(gg_trg_Quest_FieryWings_Matriarch_Dead,Condition(function Trig_Quest_FieryWings_Matriarch_Dead_Conditions))

call TriggerAddAction(gg_trg_Quest_FieryWings_Matriarch_Dead,function Trig_Quest_FieryWings_Matriarch_Dead_Actions)

endfunction





function RegisterR11_Quest_FieryWings_Complete takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_FieryWings_Complete=CreateTrigger()

call DisableTrigger(gg_trg_Quest_FieryWings_Complete)

call TriggerRegisterUnitInRangeSimple(gg_trg_Quest_FieryWings_Complete,450.,gg_unit_h00Q_0255)

call TriggerAddCondition(gg_trg_Quest_FieryWings_Complete,Condition(function Trig_Quest_FieryWings_Complete_Conditions))

call TriggerAddAction(gg_trg_Quest_FieryWings_Complete,function Trig_Quest_FieryWings_Complete_Actions)

endfunction





function RegisterR11_Quest_FireGolem_Init takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_FireGolem_Init=CreateTrigger()

call TriggerAddAction(gg_trg_Quest_FireGolem_Init,function Trig_Quest_FireGolem_Init_Actions)

endfunction





function RegisterR11_Quest_FireGolem_Alert takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_FireGolem_Alert=CreateTrigger()

call DisableTrigger(gg_trg_Quest_FireGolem_Alert)

call TriggerRegisterTimerExpireEventBJ(gg_trg_Quest_FireGolem_Alert,udg_SharedDelayTimer1)

call TriggerAddAction(gg_trg_Quest_FireGolem_Alert,function Trig_Quest_FireGolem_Alert_Actions)

endfunction





function RegisterR11_Quest_FireGolem_Start takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_FireGolem_Start=CreateTrigger()

call DisableTrigger(gg_trg_Quest_FireGolem_Start)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_FireGolem_Start,Player(0),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_FireGolem_Start,Player(1),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_FireGolem_Start,Player(2),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_FireGolem_Start,Player(3),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_FireGolem_Start,Player(4),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_FireGolem_Start,Player(5),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_FireGolem_Start,Player(6),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_FireGolem_Start,Player(7),true)

call TriggerAddCondition(gg_trg_Quest_FireGolem_Start,Condition(function Trig_Quest_FireGolem_Start_Conditions))

call TriggerAddAction(gg_trg_Quest_FireGolem_Start,function Trig_Quest_FireGolem_Start_Actions)

endfunction





function RegisterR11_Quest_FireGolem_HeartDropped takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_FireGolem_HeartDropped=CreateTrigger()

call DisableTrigger(gg_trg_Quest_FireGolem_HeartDropped)

call TriggerRegisterUnitEvent(gg_trg_Quest_FireGolem_HeartDropped,gg_unit_n00F_0139,EVENT_UNIT_DEATH)

call TriggerAddAction(gg_trg_Quest_FireGolem_HeartDropped,function Trig_Quest_FireGolem_HeartDropped_Actions)

endfunction





function RegisterR11_Quest_FireGolem_Ping takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_FireGolem_Ping=CreateTrigger()

call DisableTrigger(gg_trg_Quest_FireGolem_Ping)

call TriggerRegisterTimerEventPeriodic(gg_trg_Quest_FireGolem_Ping,15.)

call TriggerAddCondition(gg_trg_Quest_FireGolem_Ping,Condition(function Trig_Quest_FireGolem_Ping_Conditions))

call TriggerAddAction(gg_trg_Quest_FireGolem_Ping,function Trig_Quest_FireGolem_Ping_Actions)

endfunction





function RegisterR11_Quest_FireGolem_HeartTaken takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_FireGolem_HeartTaken=CreateTrigger()

call DisableTrigger(gg_trg_Quest_FireGolem_HeartTaken)

call TriggerRegisterAnyUnitEventBJ(gg_trg_Quest_FireGolem_HeartTaken,EVENT_PLAYER_UNIT_PICKUP_ITEM)

call TriggerAddCondition(gg_trg_Quest_FireGolem_HeartTaken,Condition(function Trig_Quest_FireGolem_HeartTaken_Conditions))

call TriggerAddAction(gg_trg_Quest_FireGolem_HeartTaken,function Trig_Quest_FireGolem_HeartTaken_Actions)

endfunction





function RegisterR11_Quest_FireGolem_Complete takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_FireGolem_Complete=CreateTrigger()

call DisableTrigger(gg_trg_Quest_FireGolem_Complete)

call TriggerRegisterUnitInRangeSimple(gg_trg_Quest_FireGolem_Complete,450.,gg_unit_Hjai_0093)

call TriggerAddCondition(gg_trg_Quest_FireGolem_Complete,Condition(function Trig_Quest_FireGolem_Complete_Conditions))

call TriggerAddAction(gg_trg_Quest_FireGolem_Complete,function Trig_Quest_FireGolem_Complete_Actions)

endfunction





function RegisterR11_Quest_FishyDeals_Start takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_FishyDeals_Start=CreateTrigger()

call DisableTrigger(gg_trg_Quest_FishyDeals_Start)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_FishyDeals_Start,Player(0),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_FishyDeals_Start,Player(1),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_FishyDeals_Start,Player(2),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_FishyDeals_Start,Player(3),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_FishyDeals_Start,Player(4),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_FishyDeals_Start,Player(5),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_FishyDeals_Start,Player(6),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_FishyDeals_Start,Player(7),true)

call TriggerAddCondition(gg_trg_Quest_FishyDeals_Start,Condition(function Trig_Quest_FishyDeals_Start_Conditions))

call TriggerAddAction(gg_trg_Quest_FishyDeals_Start,function Trig_Quest_FishyDeals_Start_Actions)

endfunction





function RegisterR11_Quest_FishyDeals_Complete takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_FishyDeals_Complete=CreateTrigger()

call DisableTrigger(gg_trg_Quest_FishyDeals_Complete)

call TriggerRegisterUnitInRangeSimple(gg_trg_Quest_FishyDeals_Complete,200.,gg_unit_n0AW_0223)

call TriggerRegisterUnitInRangeSimple(gg_trg_Quest_FishyDeals_Complete,450.,gg_unit_n0AW_0223)

call TriggerAddCondition(gg_trg_Quest_FishyDeals_Complete,Condition(function Trig_Quest_FishyDeals_Complete_Conditions))

call TriggerAddAction(gg_trg_Quest_FishyDeals_Complete,function Trig_Quest_FishyDeals_Complete_Actions)

endfunction





function RegisterR11_Quest_Fountain_Bulb takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_Fountain_Bulb=CreateTrigger()

call DisableTrigger(gg_trg_Quest_Fountain_Bulb)

call TriggerRegisterUnitInRangeSimple(gg_trg_Quest_Fountain_Bulb,450.,gg_unit_e007_0154)

call TriggerAddCondition(gg_trg_Quest_Fountain_Bulb,Condition(function Trig_Quest_Fountain_Bulb_Conditions))

call TriggerAddAction(gg_trg_Quest_Fountain_Bulb,function Trig_Quest_Fountain_Bulb_Actions)

endfunction





function RegisterR11_Quest_Fountain_Complete takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_Fountain_Complete=CreateTrigger()

call DisableTrigger(gg_trg_Quest_Fountain_Complete)

call TriggerRegisterUnitInRangeSimple(gg_trg_Quest_Fountain_Complete,450.,gg_unit_e007_0154)

call TriggerAddCondition(gg_trg_Quest_Fountain_Complete,Condition(function Trig_Quest_Fountain_Complete_Conditions))

call TriggerAddAction(gg_trg_Quest_Fountain_Complete,function Trig_Quest_Fountain_Complete_Actions)

endfunction





function RegisterR11_Quest_GodDragon_Start takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_GodDragon_Start=CreateTrigger()

call DisableTrigger(gg_trg_Quest_GodDragon_Start)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_GodDragon_Start,Player(0),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_GodDragon_Start,Player(1),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_GodDragon_Start,Player(2),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_GodDragon_Start,Player(3),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_GodDragon_Start,Player(4),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_GodDragon_Start,Player(5),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_GodDragon_Start,Player(6),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_GodDragon_Start,Player(7),true)

call TriggerAddCondition(gg_trg_Quest_GodDragon_Start,Condition(function Trig_Quest_GodDragon_Start_Conditions))

call TriggerAddAction(gg_trg_Quest_GodDragon_Start,function Trig_Quest_GodDragon_Start_Actions)

endfunction





function RegisterR11_Quest_GreedIsGood_Start takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_GreedIsGood_Start=CreateTrigger()

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_GreedIsGood_Start,Player(0),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_GreedIsGood_Start,Player(1),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_GreedIsGood_Start,Player(2),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_GreedIsGood_Start,Player(3),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_GreedIsGood_Start,Player(4),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_GreedIsGood_Start,Player(5),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_GreedIsGood_Start,Player(6),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_GreedIsGood_Start,Player(7),true)

call TriggerAddCondition(gg_trg_Quest_GreedIsGood_Start,Condition(function Trig_Quest_GreedIsGood_Start_Conditions))

call TriggerAddAction(gg_trg_Quest_GreedIsGood_Start,function Trig_Quest_GreedIsGood_Start_Actions)

endfunction





function RegisterR11_Quest_GreedIsGood_Complete takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_GreedIsGood_Complete=CreateTrigger()

call DisableTrigger(gg_trg_Quest_GreedIsGood_Complete)

call TriggerRegisterUnitInRangeSimple(gg_trg_Quest_GreedIsGood_Complete,450.,gg_unit_n01S_0082)

call TriggerAddCondition(gg_trg_Quest_GreedIsGood_Complete,Condition(function Trig_Quest_GreedIsGood_Complete_Conditions))

call TriggerAddAction(gg_trg_Quest_GreedIsGood_Complete,function Trig_Quest_GreedIsGood_Complete_Actions)

endfunction





function RegisterR11_Quest_HarpyHunt_Start takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_HarpyHunt_Start=CreateTrigger()

call DisableTrigger(gg_trg_Quest_HarpyHunt_Start)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_HarpyHunt_Start,Player(0),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_HarpyHunt_Start,Player(1),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_HarpyHunt_Start,Player(2),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_HarpyHunt_Start,Player(3),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_HarpyHunt_Start,Player(4),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_HarpyHunt_Start,Player(5),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_HarpyHunt_Start,Player(6),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_HarpyHunt_Start,Player(7),true)

call TriggerAddCondition(gg_trg_Quest_HarpyHunt_Start,Condition(function Trig_Quest_HarpyHunt_Start_Conditions))

call TriggerAddAction(gg_trg_Quest_HarpyHunt_Start,function Trig_Quest_HarpyHunt_Start_Actions)

endfunction





function RegisterR11_Quest_HarpyHunt_Count takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_HarpyHunt_Count=CreateTrigger()

call DisableTrigger(gg_trg_Quest_HarpyHunt_Count)

call TriggerRegisterAnyUnitEventBJ(gg_trg_Quest_HarpyHunt_Count,EVENT_PLAYER_UNIT_DEATH)

call TriggerAddCondition(gg_trg_Quest_HarpyHunt_Count,Condition(function Trig_Quest_HarpyHunt_Count_Conditions))

call TriggerAddAction(gg_trg_Quest_HarpyHunt_Count,function Trig_Quest_HarpyHunt_Count_Actions)

endfunction





function RegisterR11_Quest_HarpyHunt_Reward takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_HarpyHunt_Reward=CreateTrigger()

call DisableTrigger(gg_trg_Quest_HarpyHunt_Reward)

call TriggerRegisterUnitInRangeSimple(gg_trg_Quest_HarpyHunt_Reward,450.,gg_unit_n0B3_0049)

call TriggerAddCondition(gg_trg_Quest_HarpyHunt_Reward,Condition(function Trig_Quest_HarpyHunt_Reward_Conditions))

call TriggerAddAction(gg_trg_Quest_HarpyHunt_Reward,function Trig_Quest_HarpyHunt_Reward_Actions)

endfunction





function RegisterR11_Quest_HolyKnight_Start takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_HolyKnight_Start=CreateTrigger()

call DisableTrigger(gg_trg_Quest_HolyKnight_Start)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_HolyKnight_Start,Player(0),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_HolyKnight_Start,Player(1),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_HolyKnight_Start,Player(2),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_HolyKnight_Start,Player(3),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_HolyKnight_Start,Player(4),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_HolyKnight_Start,Player(5),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_HolyKnight_Start,Player(6),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_HolyKnight_Start,Player(7),true)

call TriggerAddCondition(gg_trg_Quest_HolyKnight_Start,Condition(function Trig_Quest_HolyKnight_Start_Conditions))

call TriggerAddAction(gg_trg_Quest_HolyKnight_Start,function Trig_Quest_HolyKnight_Start_Actions)

endfunction





function RegisterR11_Quest_HolyKnight_AskRamza takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_HolyKnight_AskRamza=CreateTrigger()

call DisableTrigger(gg_trg_Quest_HolyKnight_AskRamza)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_HolyKnight_AskRamza,Player(0),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_HolyKnight_AskRamza,Player(1),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_HolyKnight_AskRamza,Player(2),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_HolyKnight_AskRamza,Player(3),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_HolyKnight_AskRamza,Player(4),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_HolyKnight_AskRamza,Player(5),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_HolyKnight_AskRamza,Player(6),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_HolyKnight_AskRamza,Player(7),true)

call TriggerAddCondition(gg_trg_Quest_HolyKnight_AskRamza,Condition(function Trig_Quest_HolyKnight_AskRamza_Conditions))

call TriggerAddAction(gg_trg_Quest_HolyKnight_AskRamza,function Trig_Quest_HolyKnight_AskRamza_Actions)

endfunction





function RegisterR11_Quest_Illusions_Start takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_Illusions_Start=CreateTrigger()

call DisableTrigger(gg_trg_Quest_Illusions_Start)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Illusions_Start,Player(0),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Illusions_Start,Player(1),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Illusions_Start,Player(2),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Illusions_Start,Player(3),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Illusions_Start,Player(4),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Illusions_Start,Player(5),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Illusions_Start,Player(6),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Illusions_Start,Player(7),true)

call TriggerAddCondition(gg_trg_Quest_Illusions_Start,Condition(function Trig_Quest_Illusions_Start_Conditions))

call TriggerAddAction(gg_trg_Quest_Illusions_Start,function Trig_Quest_Illusions_Start_Actions)

endfunction





function RegisterR11_Quest_ImperviousBeast_Start takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_ImperviousBeast_Start=CreateTrigger()

call DisableTrigger(gg_trg_Quest_ImperviousBeast_Start)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_ImperviousBeast_Start,Player(0),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_ImperviousBeast_Start,Player(1),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_ImperviousBeast_Start,Player(2),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_ImperviousBeast_Start,Player(3),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_ImperviousBeast_Start,Player(4),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_ImperviousBeast_Start,Player(5),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_ImperviousBeast_Start,Player(6),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_ImperviousBeast_Start,Player(7),true)

call TriggerAddCondition(gg_trg_Quest_ImperviousBeast_Start,Condition(function Trig_Quest_ImperviousBeast_Start_Conditions))

call TriggerAddAction(gg_trg_Quest_ImperviousBeast_Start,function Trig_Quest_ImperviousBeast_Start_Actions)

endfunction





function RegisterR11_Quest_ImperviousBeast_Complete takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_ImperviousBeast_Complete=CreateTrigger()

call DisableTrigger(gg_trg_Quest_ImperviousBeast_Complete)

call TriggerAddCondition(gg_trg_Quest_ImperviousBeast_Complete,Condition(function Trig_Quest_ImperviousBeast_Complete_Conditions))

call TriggerAddAction(gg_trg_Quest_ImperviousBeast_Complete,function Trig_Quest_ImperviousBeast_Complete_Actions)

endfunction





function RegisterR11_Quest_KillElmdor_Init takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_KillElmdor_Init=CreateTrigger()

call TriggerAddAction(gg_trg_Quest_KillElmdor_Init,function Trig_Quest_KillElmdor_Init_Actions)

endfunction





function RegisterR11_Quest_KillElmdor_Available takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_KillElmdor_Available=CreateTrigger()

call DisableTrigger(gg_trg_Quest_KillElmdor_Available)

call TriggerAddAction(gg_trg_Quest_KillElmdor_Available,function Trig_Quest_KillElmdor_Available_Actions)

endfunction





function RegisterR11_Quest_KillElmdor_Start takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_KillElmdor_Start=CreateTrigger()

call DisableTrigger(gg_trg_Quest_KillElmdor_Start)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_KillElmdor_Start,Player(0),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_KillElmdor_Start,Player(1),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_KillElmdor_Start,Player(2),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_KillElmdor_Start,Player(3),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_KillElmdor_Start,Player(4),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_KillElmdor_Start,Player(5),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_KillElmdor_Start,Player(6),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_KillElmdor_Start,Player(7),true)

call TriggerAddCondition(gg_trg_Quest_KillElmdor_Start,Condition(function Trig_Quest_KillElmdor_Start_Conditions))

call TriggerAddAction(gg_trg_Quest_KillElmdor_Start,function Trig_Quest_KillElmdor_Start_Actions)

endfunction





function RegisterR11_Quest_KillElmdor_Slain takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_KillElmdor_Slain=CreateTrigger()

call DisableTrigger(gg_trg_Quest_KillElmdor_Slain)

call TriggerRegisterUnitEvent(gg_trg_Quest_KillElmdor_Slain,gg_unit_Nbbc_0006,EVENT_UNIT_DEATH)

call TriggerAddAction(gg_trg_Quest_KillElmdor_Slain,function Trig_Quest_KillElmdor_Slain_Actions)

endfunction





function RegisterR11_Quest_KillElmdor_Complete takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_KillElmdor_Complete=CreateTrigger()

call DisableTrigger(gg_trg_Quest_KillElmdor_Complete)

call TriggerRegisterUnitInRangeSimple(gg_trg_Quest_KillElmdor_Complete,450.,gg_unit_h007_0089)

call TriggerAddCondition(gg_trg_Quest_KillElmdor_Complete,Condition(function Trig_Quest_KillElmdor_Complete_Conditions))

call TriggerAddAction(gg_trg_Quest_KillElmdor_Complete,function Trig_Quest_KillElmdor_Complete_Actions)

endfunction





function RegisterR11_Quest_KillSetag_Hide takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_KillSetag_Hide=CreateTrigger()

call TriggerAddAction(gg_trg_Quest_KillSetag_Hide,function Trig_Quest_KillSetag_Hide_Actions)

endfunction





function RegisterR11_Quest_KillSetag_Offer takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_KillSetag_Offer=CreateTrigger()

call DisableTrigger(gg_trg_Quest_KillSetag_Offer)

call TriggerAddAction(gg_trg_Quest_KillSetag_Offer,function Trig_Quest_KillSetag_Offer_Actions)

endfunction





function RegisterR11_Quest_KillSetag_Start takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_KillSetag_Start=CreateTrigger()

call DisableTrigger(gg_trg_Quest_KillSetag_Start)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_KillSetag_Start,Player(0),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_KillSetag_Start,Player(1),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_KillSetag_Start,Player(2),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_KillSetag_Start,Player(3),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_KillSetag_Start,Player(4),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_KillSetag_Start,Player(5),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_KillSetag_Start,Player(6),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_KillSetag_Start,Player(7),true)

call TriggerAddCondition(gg_trg_Quest_KillSetag_Start,Condition(function Trig_Quest_KillSetag_Start_Conditions))

call TriggerAddAction(gg_trg_Quest_KillSetag_Start,function Trig_Quest_KillSetag_Start_Actions)

endfunction





function RegisterR11_Quest_KillSetag_Ambush takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_KillSetag_Ambush=CreateTrigger()

call DisableTrigger(gg_trg_Quest_KillSetag_Ambush)

call TriggerRegisterUnitEvent(gg_trg_Quest_KillSetag_Ambush,gg_unit_Hgam_0060,EVENT_UNIT_DAMAGED)

call TriggerRegisterUnitEvent(gg_trg_Quest_KillSetag_Ambush,gg_unit_Hgam_0060,EVENT_UNIT_ATTACKED)

call TriggerRegisterUnitEvent(gg_trg_Quest_KillSetag_Ambush,gg_unit_uabo_0061,EVENT_UNIT_ATTACKED)

call TriggerRegisterUnitEvent(gg_trg_Quest_KillSetag_Ambush,gg_unit_uabo_0062,EVENT_UNIT_ATTACKED)

call TriggerRegisterUnitEvent(gg_trg_Quest_KillSetag_Ambush,gg_unit_uabo_0002,EVENT_UNIT_ATTACKED)

call TriggerAddCondition(gg_trg_Quest_KillSetag_Ambush,Condition(function Trig_Quest_KillSetag_Ambush_Conditions))

call TriggerAddAction(gg_trg_Quest_KillSetag_Ambush,function Trig_Quest_KillSetag_Ambush_Actions)

endfunction





function RegisterR11_Quest_KillSetag_Failed takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_KillSetag_Failed=CreateTrigger()

call DisableTrigger(gg_trg_Quest_KillSetag_Failed)

call TriggerRegisterUnitEvent(gg_trg_Quest_KillSetag_Failed,gg_unit_Hant_0059,EVENT_UNIT_DEATH)

call TriggerAddAction(gg_trg_Quest_KillSetag_Failed,function Trig_Quest_KillSetag_Failed_Actions)

endfunction





function RegisterR11_Quest_KillSetag_Complete takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_KillSetag_Complete=CreateTrigger()

call DisableTrigger(gg_trg_Quest_KillSetag_Complete)

call TriggerRegisterUnitEvent(gg_trg_Quest_KillSetag_Complete,gg_unit_Hgam_0060,EVENT_UNIT_DEATH)

call TriggerAddAction(gg_trg_Quest_KillSetag_Complete,function Trig_Quest_KillSetag_Complete_Actions)

endfunction





function RegisterR11_Quest_KingOfSea_Slain takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_KingOfSea_Slain=CreateTrigger()

call DisableTrigger(gg_trg_Quest_KingOfSea_Slain)

call TriggerRegisterUnitEvent(gg_trg_Quest_KingOfSea_Slain,gg_unit_H02W_0246,EVENT_UNIT_DEATH)

call TriggerAddAction(gg_trg_Quest_KingOfSea_Slain,function Trig_Quest_KingOfSea_Slain_Actions)

endfunction





function RegisterR11_Quest_KingOfSea_Reward takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_KingOfSea_Reward=CreateTrigger()

call DisableTrigger(gg_trg_Quest_KingOfSea_Reward)

call TriggerRegisterUnitInRangeSimple(gg_trg_Quest_KingOfSea_Reward,450.,gg_unit_n0AV_0247)

call TriggerAddCondition(gg_trg_Quest_KingOfSea_Reward,Condition(function Trig_Quest_KingOfSea_Reward_Conditions))

call TriggerAddAction(gg_trg_Quest_KingOfSea_Reward,function Trig_Quest_KingOfSea_Reward_Actions)

endfunction





function RegisterR11_Quest_LadyNashj_Init takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_LadyNashj_Init=CreateTrigger()

call TriggerAddAction(gg_trg_Quest_LadyNashj_Init,function Trig_Quest_LadyNashj_Init_Actions)

endfunction





function RegisterR11_Quest_LadyNashj_Available takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_LadyNashj_Available=CreateTrigger()

call DisableTrigger(gg_trg_Quest_LadyNashj_Available)

call TriggerAddAction(gg_trg_Quest_LadyNashj_Available,function Trig_Quest_LadyNashj_Available_Actions)

endfunction





function RegisterR11_Quest_LadyNashj_Start takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_LadyNashj_Start=CreateTrigger()

call DisableTrigger(gg_trg_Quest_LadyNashj_Start)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_LadyNashj_Start,Player(0),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_LadyNashj_Start,Player(1),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_LadyNashj_Start,Player(2),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_LadyNashj_Start,Player(3),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_LadyNashj_Start,Player(4),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_LadyNashj_Start,Player(5),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_LadyNashj_Start,Player(6),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_LadyNashj_Start,Player(7),true)

call TriggerAddCondition(gg_trg_Quest_LadyNashj_Start,Condition(function Trig_Quest_LadyNashj_Start_Conditions))

call TriggerAddAction(gg_trg_Quest_LadyNashj_Start,function Trig_Quest_LadyNashj_Start_Actions)

endfunction





function RegisterR11_Quest_LadyNashj_Slain takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_LadyNashj_Slain=CreateTrigger()

call DisableTrigger(gg_trg_Quest_LadyNashj_Slain)

call TriggerRegisterUnitEvent(gg_trg_Quest_LadyNashj_Slain,gg_unit_Hvsh_0145,EVENT_UNIT_DEATH)

call TriggerAddAction(gg_trg_Quest_LadyNashj_Slain,function Trig_Quest_LadyNashj_Slain_Actions)

endfunction





function RegisterR11_Quest_LadyNashj_Complete takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_LadyNashj_Complete=CreateTrigger()

call DisableTrigger(gg_trg_Quest_LadyNashj_Complete)

call TriggerRegisterUnitInRangeSimple(gg_trg_Quest_LadyNashj_Complete,450.,gg_unit_eshd_0143)

call TriggerAddCondition(gg_trg_Quest_LadyNashj_Complete,Condition(function Trig_Quest_LadyNashj_Complete_Conditions))

call TriggerAddAction(gg_trg_Quest_LadyNashj_Complete,function Trig_Quest_LadyNashj_Complete_Actions)

endfunction





function RegisterR11_Quest_LastRites_Start takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_LastRites_Start=CreateTrigger()

call DisableTrigger(gg_trg_Quest_LastRites_Start)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_LastRites_Start,Player(0),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_LastRites_Start,Player(1),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_LastRites_Start,Player(2),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_LastRites_Start,Player(3),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_LastRites_Start,Player(4),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_LastRites_Start,Player(5),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_LastRites_Start,Player(6),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_LastRites_Start,Player(7),true)

call TriggerAddCondition(gg_trg_Quest_LastRites_Start,Condition(function Trig_Quest_LastRites_Start_Conditions))

call TriggerAddAction(gg_trg_Quest_LastRites_Start,function Trig_Quest_LastRites_Start_Actions)

endfunction





function RegisterR11_Quest_LightOfJudgment_Start takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_LightOfJudgment_Start=CreateTrigger()

call DisableTrigger(gg_trg_Quest_LightOfJudgment_Start)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_LightOfJudgment_Start,Player(0),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_LightOfJudgment_Start,Player(1),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_LightOfJudgment_Start,Player(2),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_LightOfJudgment_Start,Player(3),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_LightOfJudgment_Start,Player(4),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_LightOfJudgment_Start,Player(5),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_LightOfJudgment_Start,Player(6),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_LightOfJudgment_Start,Player(7),true)

call TriggerAddCondition(gg_trg_Quest_LightOfJudgment_Start,Condition(function Trig_Quest_LightOfJudgment_Start_Conditions))

call TriggerAddAction(gg_trg_Quest_LightOfJudgment_Start,function Trig_Quest_LightOfJudgment_Start_Actions)

endfunction





function RegisterR11_Quest_Log_Update takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_Log_Update=CreateTrigger()

call TriggerRegisterTimerEvent(gg_trg_Quest_Log_Update,4.,true)

call TriggerAddAction(gg_trg_Quest_Log_Update,function Trig_Quest_Log_Update_Actions)

endfunction





function RegisterR11_Quest_LostMemories_Start takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_LostMemories_Start=CreateTrigger()

call DisableTrigger(gg_trg_Quest_LostMemories_Start)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_LostMemories_Start,Player(0),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_LostMemories_Start,Player(1),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_LostMemories_Start,Player(2),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_LostMemories_Start,Player(3),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_LostMemories_Start,Player(4),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_LostMemories_Start,Player(5),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_LostMemories_Start,Player(6),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_LostMemories_Start,Player(7),true)

call TriggerAddCondition(gg_trg_Quest_LostMemories_Start,Condition(function Trig_Quest_LostMemories_Start_Conditions))

call TriggerAddAction(gg_trg_Quest_LostMemories_Start,function Trig_Quest_LostMemories_Start_Actions)

endfunction





function RegisterR11_Quest_LostMemories_RingFade takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_LostMemories_RingFade=CreateTrigger()

call DisableTrigger(gg_trg_Quest_LostMemories_RingFade)

call TriggerAddCondition(gg_trg_Quest_LostMemories_RingFade,Condition(function Trig_Quest_LostMemories_RingFade_Conditions))

call TriggerAddAction(gg_trg_Quest_LostMemories_RingFade,function Trig_Quest_LostMemories_RingFade_Actions)

endfunction





function RegisterR11_Quest_LostMemories_Fail takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_LostMemories_Fail=CreateTrigger()

call DisableTrigger(gg_trg_Quest_LostMemories_Fail)

call TriggerRegisterUnitInRangeSimple(gg_trg_Quest_LostMemories_Fail,450.,gg_unit_e00V_0009)

call TriggerAddCondition(gg_trg_Quest_LostMemories_Fail,Condition(function Trig_Quest_LostMemories_Fail_Conditions))

call TriggerAddAction(gg_trg_Quest_LostMemories_Fail,function Trig_Quest_LostMemories_Fail_Actions)

endfunction





function RegisterR11_Quest_LostMemories_Pickup takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_LostMemories_Pickup=CreateTrigger()

call DisableTrigger(gg_trg_Quest_LostMemories_Pickup)

call TriggerRegisterAnyUnitEventBJ(gg_trg_Quest_LostMemories_Pickup,EVENT_PLAYER_UNIT_PICKUP_ITEM)

call TriggerAddCondition(gg_trg_Quest_LostMemories_Pickup,Condition(function Trig_Quest_LostMemories_Pickup_Conditions))

call TriggerAddAction(gg_trg_Quest_LostMemories_Pickup,function Trig_Quest_LostMemories_Pickup_Actions)

endfunction





function RegisterR11_Quest_LostMemories_ShadowLie takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_LostMemories_ShadowLie=CreateTrigger()

call DisableTrigger(gg_trg_Quest_LostMemories_ShadowLie)

call TriggerRegisterPlayerUnitEventSimple(gg_trg_Quest_LostMemories_ShadowLie,Player($A),EVENT_PLAYER_UNIT_PICKUP_ITEM) // $A = 10

call TriggerAddCondition(gg_trg_Quest_LostMemories_ShadowLie,Condition(function Trig_Quest_LostMemories_ShadowLie_Conditions))

call TriggerAddAction(gg_trg_Quest_LostMemories_ShadowLie,function Trig_Quest_LostMemories_ShadowLie_Actions)

endfunction





function RegisterR11_Quest_LostMemories_ShadowTruth takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_LostMemories_ShadowTruth=CreateTrigger()

call DisableTrigger(gg_trg_Quest_LostMemories_ShadowTruth)

call TriggerRegisterPlayerUnitEventSimple(gg_trg_Quest_LostMemories_ShadowTruth,Player($A),EVENT_PLAYER_UNIT_PICKUP_ITEM) // $A = 10

call TriggerAddCondition(gg_trg_Quest_LostMemories_ShadowTruth,Condition(function Trig_Quest_LostMemories_ShadowTruth_Conditions))

call TriggerAddAction(gg_trg_Quest_LostMemories_ShadowTruth,function Trig_Quest_LostMemories_ShadowTruth_Actions)

endfunction





function RegisterR11_Quest_LostMemories_Reunion takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_LostMemories_Reunion=CreateTrigger()

call DisableTrigger(gg_trg_Quest_LostMemories_Reunion)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_LostMemories_Reunion,Player(0),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_LostMemories_Reunion,Player(1),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_LostMemories_Reunion,Player(2),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_LostMemories_Reunion,Player(3),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_LostMemories_Reunion,Player(4),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_LostMemories_Reunion,Player(5),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_LostMemories_Reunion,Player(6),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_LostMemories_Reunion,Player(7),true)

call TriggerAddCondition(gg_trg_Quest_LostMemories_Reunion,Condition(function Trig_Quest_LostMemories_Reunion_Conditions))

call TriggerAddAction(gg_trg_Quest_LostMemories_Reunion,function Trig_Quest_LostMemories_Reunion_Actions)

endfunction





function RegisterR11_Quest_Monstrum_Complete takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_Monstrum_Complete=CreateTrigger()

call DisableTrigger(gg_trg_Quest_Monstrum_Complete)

call TriggerAddAction(gg_trg_Quest_Monstrum_Complete,function Trig_Quest_Monstrum_Complete_Actions)

endfunction





function RegisterR11_Quest_NebraAngler_Start takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_NebraAngler_Start=CreateTrigger()

call DisableTrigger(gg_trg_Quest_NebraAngler_Start)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_NebraAngler_Start,Player(0),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_NebraAngler_Start,Player(1),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_NebraAngler_Start,Player(2),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_NebraAngler_Start,Player(3),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_NebraAngler_Start,Player(4),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_NebraAngler_Start,Player(5),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_NebraAngler_Start,Player(6),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_NebraAngler_Start,Player(7),true)

call TriggerAddCondition(gg_trg_Quest_NebraAngler_Start,Condition(function Trig_Quest_NebraAngler_Start_Conditions))

call TriggerAddAction(gg_trg_Quest_NebraAngler_Start,function Trig_Quest_NebraAngler_Start_Actions)

endfunction





function RegisterR11_Quest_NebraAngler_Reward takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_NebraAngler_Reward=CreateTrigger()

call DisableTrigger(gg_trg_Quest_NebraAngler_Reward)

call TriggerRegisterUnitInRangeSimple(gg_trg_Quest_NebraAngler_Reward,450.,gg_unit_n0AV_0247)

call TriggerAddCondition(gg_trg_Quest_NebraAngler_Reward,Condition(function Trig_Quest_NebraAngler_Reward_Conditions))

call TriggerAddAction(gg_trg_Quest_NebraAngler_Reward,function Trig_Quest_NebraAngler_Reward_Actions)

endfunction





function RegisterR11_Quest_NightElves_Start takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_NightElves_Start=CreateTrigger()

call DisableTrigger(gg_trg_Quest_NightElves_Start)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_NightElves_Start,Player(0),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_NightElves_Start,Player(1),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_NightElves_Start,Player(2),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_NightElves_Start,Player(3),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_NightElves_Start,Player(4),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_NightElves_Start,Player(5),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_NightElves_Start,Player(6),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_NightElves_Start,Player(7),true)

call TriggerAddCondition(gg_trg_Quest_NightElves_Start,Condition(function Trig_Quest_NightElves_Start_Conditions))

call TriggerAddAction(gg_trg_Quest_NightElves_Start,function Trig_Quest_NightElves_Start_Actions)

endfunction





function RegisterR11_Quest_NightElves_Complete takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_NightElves_Complete=CreateTrigger()

call DisableTrigger(gg_trg_Quest_NightElves_Complete)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_NightElves_Complete,Player(0),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_NightElves_Complete,Player(1),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_NightElves_Complete,Player(2),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_NightElves_Complete,Player(3),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_NightElves_Complete,Player(4),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_NightElves_Complete,Player(5),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_NightElves_Complete,Player(6),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_NightElves_Complete,Player(7),true)

call TriggerAddCondition(gg_trg_Quest_NightElves_Complete,Condition(function Trig_Quest_NightElves_Complete_Conditions))

call TriggerAddAction(gg_trg_Quest_NightElves_Complete,function Trig_Quest_NightElves_Complete_Actions)

endfunction





function RegisterR11_Quest_NightElves_Report takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_NightElves_Report=CreateTrigger()

call DisableTrigger(gg_trg_Quest_NightElves_Report)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_NightElves_Report,Player(0),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_NightElves_Report,Player(1),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_NightElves_Report,Player(2),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_NightElves_Report,Player(3),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_NightElves_Report,Player(4),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_NightElves_Report,Player(5),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_NightElves_Report,Player(6),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_NightElves_Report,Player(7),true)

call TriggerAddCondition(gg_trg_Quest_NightElves_Report,Condition(function Trig_Quest_NightElves_Report_Conditions))

call TriggerAddAction(gg_trg_Quest_NightElves_Report,function Trig_Quest_NightElves_Report_Actions)

endfunction





function RegisterR11_Quest_NorthernGod_Judgment takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_NorthernGod_Judgment=CreateTrigger()

call DisableTrigger(gg_trg_Quest_NorthernGod_Judgment)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_NorthernGod_Judgment,Player(0),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_NorthernGod_Judgment,Player(1),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_NorthernGod_Judgment,Player(2),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_NorthernGod_Judgment,Player(3),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_NorthernGod_Judgment,Player(4),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_NorthernGod_Judgment,Player(5),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_NorthernGod_Judgment,Player(6),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_NorthernGod_Judgment,Player(7),true)

call TriggerAddCondition(gg_trg_Quest_NorthernGod_Judgment,Condition(function Trig_Quest_NorthernGod_Judgment_Conditions))

call TriggerAddAction(gg_trg_Quest_NorthernGod_Judgment,function Trig_Quest_NorthernGod_Judgment_Actions)

endfunction





function RegisterR11_Quest_OgreHunt_Start takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_OgreHunt_Start=CreateTrigger()

call DisableTrigger(gg_trg_Quest_OgreHunt_Start)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_OgreHunt_Start,Player(0),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_OgreHunt_Start,Player(1),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_OgreHunt_Start,Player(2),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_OgreHunt_Start,Player(3),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_OgreHunt_Start,Player(4),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_OgreHunt_Start,Player(5),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_OgreHunt_Start,Player(6),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_OgreHunt_Start,Player(7),true)

call TriggerAddCondition(gg_trg_Quest_OgreHunt_Start,Condition(function Trig_Quest_OgreHunt_Start_Conditions))

call TriggerAddAction(gg_trg_Quest_OgreHunt_Start,function Trig_Quest_OgreHunt_Start_Actions)

endfunction





function RegisterR11_Quest_OgreHunt_Count takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_OgreHunt_Count=CreateTrigger()

call DisableTrigger(gg_trg_Quest_OgreHunt_Count)

call TriggerRegisterAnyUnitEventBJ(gg_trg_Quest_OgreHunt_Count,EVENT_PLAYER_UNIT_DEATH)

call TriggerAddCondition(gg_trg_Quest_OgreHunt_Count,Condition(function Trig_Quest_OgreHunt_Count_Conditions))

call TriggerAddAction(gg_trg_Quest_OgreHunt_Count,function Trig_Quest_OgreHunt_Count_Actions)

endfunction





function RegisterR11_Quest_OgreHunt_Complete takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_OgreHunt_Complete=CreateTrigger()

call DisableTrigger(gg_trg_Quest_OgreHunt_Complete)

call TriggerRegisterUnitInRangeSimple(gg_trg_Quest_OgreHunt_Complete,450.,gg_unit_n0BW_0094)

call TriggerAddCondition(gg_trg_Quest_OgreHunt_Complete,Condition(function Trig_Quest_OgreHunt_Complete_Conditions))

call TriggerAddAction(gg_trg_Quest_OgreHunt_Complete,function Trig_Quest_OgreHunt_Complete_Actions)

endfunction





function RegisterR11_Quest_OmegaWeapon_Start takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_OmegaWeapon_Start=CreateTrigger()

call DisableTrigger(gg_trg_Quest_OmegaWeapon_Start)

call TriggerRegisterUnitEvent(gg_trg_Quest_OmegaWeapon_Start,gg_unit_N022_0125,EVENT_UNIT_ATTACKED)

call TriggerRegisterUnitEvent(gg_trg_Quest_OmegaWeapon_Start,gg_unit_N022_0125,EVENT_UNIT_DAMAGED)

call TriggerAddAction(gg_trg_Quest_OmegaWeapon_Start,function Trig_Quest_OmegaWeapon_Start_Actions)

endfunction





function RegisterR11_Quest_OmegaWeapon_Slain takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_OmegaWeapon_Slain=CreateTrigger()

call DisableTrigger(gg_trg_Quest_OmegaWeapon_Slain)

call TriggerRegisterUnitEvent(gg_trg_Quest_OmegaWeapon_Slain,gg_unit_N022_0125,EVENT_UNIT_DEATH)

call TriggerAddAction(gg_trg_Quest_OmegaWeapon_Slain,function Trig_Quest_OmegaWeapon_Slain_Actions)

endfunction





function RegisterR11_Quest_OreSupplies_Start takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_OreSupplies_Start=CreateTrigger()

call DisableTrigger(gg_trg_Quest_OreSupplies_Start)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_OreSupplies_Start,Player(0),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_OreSupplies_Start,Player(1),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_OreSupplies_Start,Player(2),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_OreSupplies_Start,Player(3),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_OreSupplies_Start,Player(4),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_OreSupplies_Start,Player(5),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_OreSupplies_Start,Player(6),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_OreSupplies_Start,Player(7),true)

call TriggerAddCondition(gg_trg_Quest_OreSupplies_Start,Condition(function Trig_Quest_OreSupplies_Start_Conditions))

call TriggerAddAction(gg_trg_Quest_OreSupplies_Start,function Trig_Quest_OreSupplies_Start_Actions)

endfunction





function RegisterR11_Quest_OreSupplies_Deliver takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_OreSupplies_Deliver=CreateTrigger()

call DisableTrigger(gg_trg_Quest_OreSupplies_Deliver)

call TriggerRegisterUnitInRangeSimple(gg_trg_Quest_OreSupplies_Deliver,450.,gg_unit_H00P_0260)

call TriggerAddCondition(gg_trg_Quest_OreSupplies_Deliver,Condition(function Trig_Quest_OreSupplies_Deliver_Conditions))

call TriggerAddAction(gg_trg_Quest_OreSupplies_Deliver,function Trig_Quest_OreSupplies_Deliver_Actions)

endfunction





function RegisterR11_Quest_PhantomDiary_ShowAlberich takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_PhantomDiary_ShowAlberich=CreateTrigger()

call DisableTrigger(gg_trg_Quest_PhantomDiary_ShowAlberich)

call TriggerRegisterUnitInRangeSimple(gg_trg_Quest_PhantomDiary_ShowAlberich,300.,gg_unit_h037_0257)

call TriggerAddCondition(gg_trg_Quest_PhantomDiary_ShowAlberich,Condition(function Trig_Quest_PhantomDiary_ShowAlberich_Conditions))

call TriggerAddAction(gg_trg_Quest_PhantomDiary_ShowAlberich,function Trig_Quest_PhantomDiary_ShowAlberich_Actions)

endfunction





function RegisterR11_Quest_Phoenix_Available takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_Phoenix_Available=CreateTrigger()

call DisableTrigger(gg_trg_Quest_Phoenix_Available)

call TriggerAddAction(gg_trg_Quest_Phoenix_Available,function Trig_Quest_Phoenix_Available_Actions)

endfunction





function RegisterR11_Quest_Phoenix_Start takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_Phoenix_Start=CreateTrigger()

call DisableTrigger(gg_trg_Quest_Phoenix_Start)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Phoenix_Start,Player(0),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Phoenix_Start,Player(1),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Phoenix_Start,Player(2),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Phoenix_Start,Player(3),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Phoenix_Start,Player(4),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Phoenix_Start,Player(5),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Phoenix_Start,Player(6),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Phoenix_Start,Player(7),true)

call TriggerAddCondition(gg_trg_Quest_Phoenix_Start,Condition(function Trig_Quest_Phoenix_Start_Conditions))

call TriggerAddAction(gg_trg_Quest_Phoenix_Start,function Trig_Quest_Phoenix_Start_Actions)

endfunction





function RegisterR11_Quest_Phoenix_Ping takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_Phoenix_Ping=CreateTrigger()

call DisableTrigger(gg_trg_Quest_Phoenix_Ping)

call TriggerRegisterTimerEventPeriodic(gg_trg_Quest_Phoenix_Ping,15.)

call TriggerAddCondition(gg_trg_Quest_Phoenix_Ping,Condition(function Trig_Quest_Phoenix_Ping_Conditions))

call TriggerAddAction(gg_trg_Quest_Phoenix_Ping,function Trig_Quest_Phoenix_Ping_Actions)

endfunction





function RegisterR11_Quest_Phoenix_EggTaken takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_Phoenix_EggTaken=CreateTrigger()

call DisableTrigger(gg_trg_Quest_Phoenix_EggTaken)

call TriggerRegisterAnyUnitEventBJ(gg_trg_Quest_Phoenix_EggTaken,EVENT_PLAYER_UNIT_PICKUP_ITEM)

call TriggerAddCondition(gg_trg_Quest_Phoenix_EggTaken,Condition(function Trig_Quest_Phoenix_EggTaken_Conditions))

call TriggerAddAction(gg_trg_Quest_Phoenix_EggTaken,function Trig_Quest_Phoenix_EggTaken_Actions)

endfunction





function RegisterR11_Quest_Phoenix_Complete takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_Phoenix_Complete=CreateTrigger()

call DisableTrigger(gg_trg_Quest_Phoenix_Complete)

call TriggerRegisterUnitInRangeSimple(gg_trg_Quest_Phoenix_Complete,450.,gg_unit_Hjai_0093)

call TriggerAddCondition(gg_trg_Quest_Phoenix_Complete,Condition(function Trig_Quest_Phoenix_Complete_Conditions))

call TriggerAddAction(gg_trg_Quest_Phoenix_Complete,function Trig_Quest_Phoenix_Complete_Actions)

endfunction





function RegisterR11_Quest_Rematch_Start takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_Rematch_Start=CreateTrigger()

call DisableTrigger(gg_trg_Quest_Rematch_Start)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Rematch_Start,Player(0),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Rematch_Start,Player(1),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Rematch_Start,Player(2),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Rematch_Start,Player(3),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Rematch_Start,Player(4),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Rematch_Start,Player(5),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Rematch_Start,Player(6),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Rematch_Start,Player(7),true)

call TriggerAddCondition(gg_trg_Quest_Rematch_Start,Condition(function Trig_Quest_Rematch_Start_Conditions))

call TriggerAddAction(gg_trg_Quest_Rematch_Start,function Trig_Quest_Rematch_Start_Actions)

endfunction





function RegisterR11_Quest_Rematch_Begin takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_Rematch_Begin=CreateTrigger()

call DisableTrigger(gg_trg_Quest_Rematch_Begin)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Rematch_Begin,Player(0),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Rematch_Begin,Player(1),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Rematch_Begin,Player(2),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Rematch_Begin,Player(3),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Rematch_Begin,Player(4),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Rematch_Begin,Player(5),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Rematch_Begin,Player(6),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Rematch_Begin,Player(7),true)

call TriggerAddCondition(gg_trg_Quest_Rematch_Begin,Condition(function Trig_Quest_Rematch_Begin_Conditions))

call TriggerAddAction(gg_trg_Quest_Rematch_Begin,function Trig_Quest_Rematch_Begin_Actions)

endfunction





function RegisterR11_Quest_Rematch_Complete takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_Rematch_Complete=CreateTrigger()

call DisableTrigger(gg_trg_Quest_Rematch_Complete)

call TriggerRegisterUnitEvent(gg_trg_Quest_Rematch_Complete,gg_unit_Ocb2_0147,EVENT_UNIT_DEATH)

call TriggerRegisterUnitEvent(gg_trg_Quest_Rematch_Complete,gg_unit_Ocbh_0148,EVENT_UNIT_DEATH)

call TriggerAddAction(gg_trg_Quest_Rematch_Complete,function Trig_Quest_Rematch_Complete_Actions)

endfunction





function RegisterR11_Quest_SaveTimmy_Init takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_SaveTimmy_Init=CreateTrigger()

call TriggerAddAction(gg_trg_Quest_SaveTimmy_Init,function Trig_Quest_SaveTimmy_Init_Actions)

endfunction





function RegisterR11_Quest_SaveTimmy_Start takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_SaveTimmy_Start=CreateTrigger()

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_SaveTimmy_Start,Player(0),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_SaveTimmy_Start,Player(1),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_SaveTimmy_Start,Player(2),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_SaveTimmy_Start,Player(3),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_SaveTimmy_Start,Player(4),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_SaveTimmy_Start,Player(5),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_SaveTimmy_Start,Player(6),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_SaveTimmy_Start,Player(7),true)

call TriggerAddCondition(gg_trg_Quest_SaveTimmy_Start,Condition(function Trig_Quest_SaveTimmy_Start_Conditions))

call TriggerAddAction(gg_trg_Quest_SaveTimmy_Start,function Trig_Quest_SaveTimmy_Start_Actions)

endfunction





function RegisterR11_Quest_SaveTimmy_Ping takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_SaveTimmy_Ping=CreateTrigger()

call DisableTrigger(gg_trg_Quest_SaveTimmy_Ping)

call TriggerRegisterTimerEventPeriodic(gg_trg_Quest_SaveTimmy_Ping,15.)

call TriggerAddAction(gg_trg_Quest_SaveTimmy_Ping,function Trig_Quest_SaveTimmy_Ping_Actions)

endfunction





function RegisterR11_Quest_SaveTimmy_GateRefused takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_SaveTimmy_GateRefused=CreateTrigger()

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_SaveTimmy_GateRefused,Player(0),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_SaveTimmy_GateRefused,Player(1),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_SaveTimmy_GateRefused,Player(2),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_SaveTimmy_GateRefused,Player(3),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_SaveTimmy_GateRefused,Player(4),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_SaveTimmy_GateRefused,Player(5),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_SaveTimmy_GateRefused,Player(6),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_SaveTimmy_GateRefused,Player(7),true)

call TriggerAddCondition(gg_trg_Quest_SaveTimmy_GateRefused,Condition(function Trig_Quest_SaveTimmy_GateRefused_Conditions))

call TriggerAddAction(gg_trg_Quest_SaveTimmy_GateRefused,function Trig_Quest_SaveTimmy_GateRefused_Actions)

endfunction





function RegisterR11_Quest_SaveTimmy_GateAsk takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_SaveTimmy_GateAsk=CreateTrigger()

call DisableTrigger(gg_trg_Quest_SaveTimmy_GateAsk)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_SaveTimmy_GateAsk,Player(0),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_SaveTimmy_GateAsk,Player(1),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_SaveTimmy_GateAsk,Player(2),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_SaveTimmy_GateAsk,Player(3),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_SaveTimmy_GateAsk,Player(4),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_SaveTimmy_GateAsk,Player(5),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_SaveTimmy_GateAsk,Player(6),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_SaveTimmy_GateAsk,Player(7),true)

call TriggerAddCondition(gg_trg_Quest_SaveTimmy_GateAsk,Condition(function Trig_Quest_SaveTimmy_GateAsk_Conditions))

call TriggerAddAction(gg_trg_Quest_SaveTimmy_GateAsk,function Trig_Quest_SaveTimmy_GateAsk_Actions)

endfunction





function RegisterR11_Quest_SaveTimmy_GateOpen takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_SaveTimmy_GateOpen=CreateTrigger()

call DisableTrigger(gg_trg_Quest_SaveTimmy_GateOpen)

call TriggerAddAction(gg_trg_Quest_SaveTimmy_GateOpen,function Trig_Quest_SaveTimmy_GateOpen_Actions)

endfunction





function RegisterR11_Quest_SaveTimmy_CampFlank takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_SaveTimmy_CampFlank=CreateTrigger()

call TriggerRegisterEnterRectSimple(gg_trg_Quest_SaveTimmy_CampFlank,gg_rct_487)

call TriggerAddCondition(gg_trg_Quest_SaveTimmy_CampFlank,Condition(function Trig_Quest_SaveTimmy_CampFlank_Conditions))

call TriggerAddAction(gg_trg_Quest_SaveTimmy_CampFlank,function Trig_Quest_SaveTimmy_CampFlank_Actions)

endfunction





function RegisterR11_Quest_SaveTimmy_CampAlerted takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_SaveTimmy_CampAlerted=CreateTrigger()

call TriggerRegisterAnyUnitEventBJ(gg_trg_Quest_SaveTimmy_CampAlerted,EVENT_PLAYER_UNIT_ATTACKED)

call TriggerAddCondition(gg_trg_Quest_SaveTimmy_CampAlerted,Condition(function Trig_Quest_SaveTimmy_CampAlerted_Conditions))

call TriggerAddAction(gg_trg_Quest_SaveTimmy_CampAlerted,function Trig_Quest_SaveTimmy_CampAlerted_Actions)

endfunction





function RegisterR11_Quest_SaveTimmy_CampCleared takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_SaveTimmy_CampCleared=CreateTrigger()

call TriggerRegisterAnyUnitEventBJ(gg_trg_Quest_SaveTimmy_CampCleared,EVENT_PLAYER_UNIT_DEATH)

call TriggerAddCondition(gg_trg_Quest_SaveTimmy_CampCleared,Condition(function Trig_Quest_SaveTimmy_CampCleared_Conditions))

call TriggerAddAction(gg_trg_Quest_SaveTimmy_CampCleared,function Trig_Quest_SaveTimmy_CampCleared_Actions)

endfunction





function RegisterR11_Quest_SaveTimmy_Freed takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_SaveTimmy_Freed=CreateTrigger()

call TriggerRegisterDeathEvent(gg_trg_Quest_SaveTimmy_Freed,gg_dest_LOcg_0024)

call TriggerAddAction(gg_trg_Quest_SaveTimmy_Freed,function Trig_Quest_SaveTimmy_Freed_Actions)

endfunction





function RegisterR11_Quest_SaveTimmy_TimmyReturns takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_SaveTimmy_TimmyReturns=CreateTrigger()

call DisableTrigger(gg_trg_Quest_SaveTimmy_TimmyReturns)

call TriggerRegisterTimerExpireEventBJ(gg_trg_Quest_SaveTimmy_TimmyReturns,udg_TimmyQuestTimer)

call TriggerAddAction(gg_trg_Quest_SaveTimmy_TimmyReturns,function Trig_Quest_SaveTimmy_TimmyReturns_Actions)

endfunction





function RegisterR11_Quest_SaveTimmy_RescueFirst takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_SaveTimmy_RescueFirst=CreateTrigger()

call TriggerRegisterTimerExpireEventBJ(gg_trg_Quest_SaveTimmy_RescueFirst,udg_TimmyQuestTimer)

call TriggerAddAction(gg_trg_Quest_SaveTimmy_RescueFirst,function Trig_Quest_SaveTimmy_RescueFirst_Actions)

endfunction





function RegisterR11_Quest_SaveTimmy_Complete takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_SaveTimmy_Complete=CreateTrigger()

call DisableTrigger(gg_trg_Quest_SaveTimmy_Complete)

call TriggerRegisterUnitInRangeSimple(gg_trg_Quest_SaveTimmy_Complete,450.,gg_unit_n00I_0011)

call TriggerAddCondition(gg_trg_Quest_SaveTimmy_Complete,Condition(function Trig_Quest_SaveTimmy_Complete_Conditions))

call TriggerAddAction(gg_trg_Quest_SaveTimmy_Complete,function Trig_Quest_SaveTimmy_Complete_Actions)

endfunction





function RegisterR11_Quest_SaveTimmy_CompleteAlt takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_SaveTimmy_CompleteAlt=CreateTrigger()

call DisableTrigger(gg_trg_Quest_SaveTimmy_CompleteAlt)

call TriggerRegisterUnitInRangeSimple(gg_trg_Quest_SaveTimmy_CompleteAlt,450.,gg_unit_n00I_0011)

call TriggerAddCondition(gg_trg_Quest_SaveTimmy_CompleteAlt,Condition(function Trig_Quest_SaveTimmy_CompleteAlt_Conditions))

call TriggerAddAction(gg_trg_Quest_SaveTimmy_CompleteAlt,function Trig_Quest_SaveTimmy_CompleteAlt_Actions)

endfunction





function RegisterR11_Quest_ScorchedEarth_Start takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_ScorchedEarth_Start=CreateTrigger()

call DisableTrigger(gg_trg_Quest_ScorchedEarth_Start)

call TriggerAddCondition(gg_trg_Quest_ScorchedEarth_Start,Condition(function Trig_Quest_ScorchedEarth_Start_Conditions))

call TriggerAddAction(gg_trg_Quest_ScorchedEarth_Start,function Trig_Quest_ScorchedEarth_Start_Actions)

endfunction





function RegisterR11_Quest_ScorchedEarth_End takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_ScorchedEarth_End=CreateTrigger()

call DisableTrigger(gg_trg_Quest_ScorchedEarth_End)

call TriggerRegisterUnitEvent(gg_trg_Quest_ScorchedEarth_End,gg_unit_U00Q_0023,EVENT_UNIT_DEATH)

call TriggerAddAction(gg_trg_Quest_ScorchedEarth_End,function Trig_Quest_ScorchedEarth_End_Actions)

endfunction





function RegisterR11_Quest_52_Scorching takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_52_Scorching=CreateTrigger()

call DisableTrigger(gg_trg_Quest_52_Scorching)

call TriggerAddAction(gg_trg_Quest_52_Scorching,function Trig_Quest_52_Scorching_Actions)

endfunction





function RegisterR11_Quest_SeekDestroy_Start takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_SeekDestroy_Start=CreateTrigger()

call DisableTrigger(gg_trg_Quest_SeekDestroy_Start)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_SeekDestroy_Start,Player(0),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_SeekDestroy_Start,Player(1),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_SeekDestroy_Start,Player(2),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_SeekDestroy_Start,Player(3),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_SeekDestroy_Start,Player(4),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_SeekDestroy_Start,Player(5),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_SeekDestroy_Start,Player(6),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_SeekDestroy_Start,Player(7),true)

call TriggerAddCondition(gg_trg_Quest_SeekDestroy_Start,Condition(function Trig_Quest_SeekDestroy_Start_Conditions))

call TriggerAddAction(gg_trg_Quest_SeekDestroy_Start,function Trig_Quest_SeekDestroy_Start_Actions)

endfunction





function RegisterR11_Quest_SeekDestroy_Count takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_SeekDestroy_Count=CreateTrigger()

call DisableTrigger(gg_trg_Quest_SeekDestroy_Count)

call TriggerRegisterPlayerUnitEventSimple(gg_trg_Quest_SeekDestroy_Count,Player($B),EVENT_PLAYER_UNIT_DEATH) // $B = 11

call TriggerAddCondition(gg_trg_Quest_SeekDestroy_Count,Condition(function Trig_Quest_SeekDestroy_Count_Conditions))

call TriggerAddAction(gg_trg_Quest_SeekDestroy_Count,function Trig_Quest_SeekDestroy_Count_Actions)

endfunction





function RegisterR11_Quest_SeekDestroy_Complete takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_SeekDestroy_Complete=CreateTrigger()

call DisableTrigger(gg_trg_Quest_SeekDestroy_Complete)

call TriggerRegisterUnitInRangeSimple(gg_trg_Quest_SeekDestroy_Complete,450.,gg_unit_nemi_0078)

call TriggerAddCondition(gg_trg_Quest_SeekDestroy_Complete,Condition(function Trig_Quest_SeekDestroy_Complete_Conditions))

call TriggerAddAction(gg_trg_Quest_SeekDestroy_Complete,function Trig_Quest_SeekDestroy_Complete_Actions)

endfunction





function RegisterR11_Quest_Shimmerweed_Offer takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_Shimmerweed_Offer=CreateTrigger()

call DisableTrigger(gg_trg_Quest_Shimmerweed_Offer)

call TriggerAddAction(gg_trg_Quest_Shimmerweed_Offer,function Trig_Quest_Shimmerweed_Offer_Actions)

endfunction





function RegisterR11_Quest_Shimmerweed_Start takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_Shimmerweed_Start=CreateTrigger()

call DisableTrigger(gg_trg_Quest_Shimmerweed_Start)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Shimmerweed_Start,Player(0),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Shimmerweed_Start,Player(1),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Shimmerweed_Start,Player(2),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Shimmerweed_Start,Player(3),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Shimmerweed_Start,Player(4),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Shimmerweed_Start,Player(5),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Shimmerweed_Start,Player(6),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Shimmerweed_Start,Player(7),true)

call TriggerAddCondition(gg_trg_Quest_Shimmerweed_Start,Condition(function Trig_Quest_Shimmerweed_Start_Conditions))

call TriggerAddAction(gg_trg_Quest_Shimmerweed_Start,function Trig_Quest_Shimmerweed_Start_Actions)

endfunction





function RegisterR11_Quest_Shimmerweed_Ping takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_Shimmerweed_Ping=CreateTrigger()

call DisableTrigger(gg_trg_Quest_Shimmerweed_Ping)

call TriggerRegisterTimerEventPeriodic(gg_trg_Quest_Shimmerweed_Ping,15.)

call TriggerAddCondition(gg_trg_Quest_Shimmerweed_Ping,Condition(function Trig_Quest_Shimmerweed_Ping_Conditions))

call TriggerAddAction(gg_trg_Quest_Shimmerweed_Ping,function Trig_Quest_Shimmerweed_Ping_Actions)

endfunction





function RegisterR11_Quest_Shimmerweed_Pickup takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_Shimmerweed_Pickup=CreateTrigger()

call DisableTrigger(gg_trg_Quest_Shimmerweed_Pickup)

call TriggerRegisterAnyUnitEventBJ(gg_trg_Quest_Shimmerweed_Pickup,EVENT_PLAYER_UNIT_PICKUP_ITEM)

call TriggerAddCondition(gg_trg_Quest_Shimmerweed_Pickup,Condition(function Trig_Quest_Shimmerweed_Pickup_Conditions))

call TriggerAddAction(gg_trg_Quest_Shimmerweed_Pickup,function Trig_Quest_Shimmerweed_Pickup_Actions)

endfunction





function RegisterR11_Quest_Shimmerweed_Deliver takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_Shimmerweed_Deliver=CreateTrigger()

call DisableTrigger(gg_trg_Quest_Shimmerweed_Deliver)

call TriggerRegisterUnitInRangeSimple(gg_trg_Quest_Shimmerweed_Deliver,450.,gg_unit_n008_0050)

call TriggerAddCondition(gg_trg_Quest_Shimmerweed_Deliver,Condition(function Trig_Quest_Shimmerweed_Deliver_Conditions))

call TriggerAddAction(gg_trg_Quest_Shimmerweed_Deliver,function Trig_Quest_Shimmerweed_Deliver_Actions)

endfunction





function RegisterR11_Quest_SpiritHunt_Start takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_SpiritHunt_Start=CreateTrigger()

call DisableTrigger(gg_trg_Quest_SpiritHunt_Start)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_SpiritHunt_Start,Player(0),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_SpiritHunt_Start,Player(1),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_SpiritHunt_Start,Player(2),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_SpiritHunt_Start,Player(3),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_SpiritHunt_Start,Player(4),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_SpiritHunt_Start,Player(5),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_SpiritHunt_Start,Player(6),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_SpiritHunt_Start,Player(7),true)

call TriggerAddCondition(gg_trg_Quest_SpiritHunt_Start,Condition(function Trig_Quest_SpiritHunt_Start_Conditions))

call TriggerAddAction(gg_trg_Quest_SpiritHunt_Start,function Trig_Quest_SpiritHunt_Start_Actions)

endfunction





function RegisterR11_Quest_SpiritHunt_Count takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_SpiritHunt_Count=CreateTrigger()

call DisableTrigger(gg_trg_Quest_SpiritHunt_Count)

call TriggerRegisterAnyUnitEventBJ(gg_trg_Quest_SpiritHunt_Count,EVENT_PLAYER_UNIT_DEATH)

call TriggerAddCondition(gg_trg_Quest_SpiritHunt_Count,Condition(function Trig_Quest_SpiritHunt_Count_Conditions))

call TriggerAddAction(gg_trg_Quest_SpiritHunt_Count,function Trig_Quest_SpiritHunt_Count_Actions)

endfunction





function RegisterR11_Quest_SpiritHunt_Complete takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_SpiritHunt_Complete=CreateTrigger()

call DisableTrigger(gg_trg_Quest_SpiritHunt_Complete)

call TriggerRegisterUnitInRangeSimple(gg_trg_Quest_SpiritHunt_Complete,450.,gg_unit_nsw2_0056)

call TriggerAddCondition(gg_trg_Quest_SpiritHunt_Complete,Condition(function Trig_Quest_SpiritHunt_Complete_Conditions))

call TriggerAddAction(gg_trg_Quest_SpiritHunt_Complete,function Trig_Quest_SpiritHunt_Complete_Actions)

endfunction





function RegisterR11_Quest_SpiritOfWater_Start takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_SpiritOfWater_Start=CreateTrigger()

call DisableTrigger(gg_trg_Quest_SpiritOfWater_Start)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_SpiritOfWater_Start,Player(0),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_SpiritOfWater_Start,Player(1),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_SpiritOfWater_Start,Player(2),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_SpiritOfWater_Start,Player(3),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_SpiritOfWater_Start,Player(4),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_SpiritOfWater_Start,Player(5),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_SpiritOfWater_Start,Player(6),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_SpiritOfWater_Start,Player(7),true)

call TriggerAddCondition(gg_trg_Quest_SpiritOfWater_Start,Condition(function Trig_Quest_SpiritOfWater_Start_Conditions))

call TriggerAddAction(gg_trg_Quest_SpiritOfWater_Start,function Trig_Quest_SpiritOfWater_Start_Actions)

endfunction





function RegisterR11_Quest_SpiritOfWater_WaterGem takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_SpiritOfWater_WaterGem=CreateTrigger()

call DisableTrigger(gg_trg_Quest_SpiritOfWater_WaterGem)

call TriggerRegisterUnitInRangeSimple(gg_trg_Quest_SpiritOfWater_WaterGem,450.,gg_unit_u007_0128)

call TriggerAddCondition(gg_trg_Quest_SpiritOfWater_WaterGem,Condition(function Trig_Quest_SpiritOfWater_WaterGem_Conditions))

call TriggerAddAction(gg_trg_Quest_SpiritOfWater_WaterGem,function Trig_Quest_SpiritOfWater_WaterGem_Actions)

endfunction





function RegisterR11_Quest_SpiritOfWater_Complete takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_SpiritOfWater_Complete=CreateTrigger()

call DisableTrigger(gg_trg_Quest_SpiritOfWater_Complete)

call TriggerRegisterUnitInRangeSimple(gg_trg_Quest_SpiritOfWater_Complete,450.,gg_unit_u007_0128)

call TriggerAddCondition(gg_trg_Quest_SpiritOfWater_Complete,Condition(function Trig_Quest_SpiritOfWater_Complete_Conditions))

call TriggerAddAction(gg_trg_Quest_SpiritOfWater_Complete,function Trig_Quest_SpiritOfWater_Complete_Actions)

endfunction





function RegisterR11_Quest_StrongestEidolon_Start takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_StrongestEidolon_Start=CreateTrigger()

call DisableTrigger(gg_trg_Quest_StrongestEidolon_Start)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_StrongestEidolon_Start,Player(0),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_StrongestEidolon_Start,Player(1),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_StrongestEidolon_Start,Player(2),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_StrongestEidolon_Start,Player(3),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_StrongestEidolon_Start,Player(4),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_StrongestEidolon_Start,Player(5),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_StrongestEidolon_Start,Player(6),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_StrongestEidolon_Start,Player(7),true)

call TriggerAddCondition(gg_trg_Quest_StrongestEidolon_Start,Condition(function Trig_Quest_StrongestEidolon_Start_Conditions))

call TriggerAddAction(gg_trg_Quest_StrongestEidolon_Start,function Trig_Quest_StrongestEidolon_Start_Actions)

endfunction





function RegisterR11_Quest_StrongestEidolon_Complete takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_StrongestEidolon_Complete=CreateTrigger()

call DisableTrigger(gg_trg_Quest_StrongestEidolon_Complete)

call TriggerRegisterUnitEvent(gg_trg_Quest_StrongestEidolon_Complete,gg_unit_N02I_0074,EVENT_UNIT_DEATH)

call TriggerAddAction(gg_trg_Quest_StrongestEidolon_Complete,function Trig_Quest_StrongestEidolon_Complete_Actions)

endfunction





function RegisterR11_Quest_TargetPractice_Start takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_TargetPractice_Start=CreateTrigger()

call DisableTrigger(gg_trg_Quest_TargetPractice_Start)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_TargetPractice_Start,Player(0),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_TargetPractice_Start,Player(1),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_TargetPractice_Start,Player(2),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_TargetPractice_Start,Player(3),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_TargetPractice_Start,Player(4),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_TargetPractice_Start,Player(5),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_TargetPractice_Start,Player(6),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_TargetPractice_Start,Player(7),true)

call TriggerAddCondition(gg_trg_Quest_TargetPractice_Start,Condition(function Trig_Quest_TargetPractice_Start_Conditions))

call TriggerAddAction(gg_trg_Quest_TargetPractice_Start,function Trig_Quest_TargetPractice_Start_Actions)

endfunction





function RegisterR11_Quest_TowerSummoning_Start takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_TowerSummoning_Start=CreateTrigger()

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_TowerSummoning_Start,Player(0),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_TowerSummoning_Start,Player(1),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_TowerSummoning_Start,Player(2),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_TowerSummoning_Start,Player(3),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_TowerSummoning_Start,Player(4),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_TowerSummoning_Start,Player(5),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_TowerSummoning_Start,Player(6),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_TowerSummoning_Start,Player(7),true)

call TriggerAddCondition(gg_trg_Quest_TowerSummoning_Start,Condition(function Trig_Quest_TowerSummoning_Start_Conditions))

call TriggerAddAction(gg_trg_Quest_TowerSummoning_Start,function Trig_Quest_TowerSummoning_Start_Actions)

endfunction





function RegisterR11_Quest_TowerSummoning_Complete takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_TowerSummoning_Complete=CreateTrigger()

call DisableTrigger(gg_trg_Quest_TowerSummoning_Complete)

call TriggerRegisterUnitEvent(gg_trg_Quest_TowerSummoning_Complete,gg_unit_n01Z_0127,EVENT_UNIT_DEATH)

call TriggerAddAction(gg_trg_Quest_TowerSummoning_Complete,function Trig_Quest_TowerSummoning_Complete_Actions)

endfunction





function RegisterR11_Quest_TrialByFire_Start takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_TrialByFire_Start=CreateTrigger()

call DisableTrigger(gg_trg_Quest_TrialByFire_Start)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_TrialByFire_Start,Player(0),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_TrialByFire_Start,Player(1),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_TrialByFire_Start,Player(2),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_TrialByFire_Start,Player(3),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_TrialByFire_Start,Player(4),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_TrialByFire_Start,Player(5),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_TrialByFire_Start,Player(6),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_TrialByFire_Start,Player(7),true)

call TriggerAddCondition(gg_trg_Quest_TrialByFire_Start,Condition(function Trig_Quest_TrialByFire_Start_Conditions))

call TriggerAddAction(gg_trg_Quest_TrialByFire_Start,function Trig_Quest_TrialByFire_Start_Actions)

endfunction





function RegisterR11_Quest_TrialByFire_Begin takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_TrialByFire_Begin=CreateTrigger()

call DisableTrigger(gg_trg_Quest_TrialByFire_Begin)

call TriggerRegisterPlayerUnitEventSimple(gg_trg_Quest_TrialByFire_Begin,Player(8),EVENT_PLAYER_UNIT_SELL)

call TriggerAddCondition(gg_trg_Quest_TrialByFire_Begin,Condition(function Trig_Quest_TrialByFire_Begin_Conditions))

call TriggerAddAction(gg_trg_Quest_TrialByFire_Begin,function Trig_Quest_TrialByFire_Begin_Actions)

endfunction





function RegisterR11_Quest_TrialByFire_Countdown takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_TrialByFire_Countdown=CreateTrigger()

call DisableTrigger(gg_trg_Quest_TrialByFire_Countdown)

call TriggerRegisterTimerEventPeriodic(gg_trg_Quest_TrialByFire_Countdown,1.)

call TriggerAddAction(gg_trg_Quest_TrialByFire_Countdown,function Trig_Quest_TrialByFire_Countdown_Actions)

endfunction





function RegisterR11_Quest_TrialByFire_Fail takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_TrialByFire_Fail=CreateTrigger()

call DisableTrigger(gg_trg_Quest_TrialByFire_Fail)

call TriggerAddAction(gg_trg_Quest_TrialByFire_Fail,function Trig_Quest_TrialByFire_Fail_Actions)

endfunction





function RegisterR11_Quest_TrialByFire_Survive takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_TrialByFire_Survive=CreateTrigger()

call DisableTrigger(gg_trg_Quest_TrialByFire_Survive)

call TriggerAddAction(gg_trg_Quest_TrialByFire_Survive,function Trig_Quest_TrialByFire_Survive_Actions)

endfunction





function RegisterR11_Quest_UltimaWeapon_Start takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_UltimaWeapon_Start=CreateTrigger()

call DisableTrigger(gg_trg_Quest_UltimaWeapon_Start)

call TriggerRegisterUnitEvent(gg_trg_Quest_UltimaWeapon_Start,gg_unit_Nman_0151,EVENT_UNIT_DAMAGED)

call TriggerRegisterUnitEvent(gg_trg_Quest_UltimaWeapon_Start,gg_unit_Nman_0151,EVENT_UNIT_ATTACKED)

call TriggerAddAction(gg_trg_Quest_UltimaWeapon_Start,function Trig_Quest_UltimaWeapon_Start_Actions)

endfunction





function RegisterR11_Quest_UltimaWeapon_Slain takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_UltimaWeapon_Slain=CreateTrigger()

call DisableTrigger(gg_trg_Quest_UltimaWeapon_Slain)

call TriggerRegisterUnitEvent(gg_trg_Quest_UltimaWeapon_Slain,gg_unit_Nman_0151,EVENT_UNIT_DEATH)

call TriggerAddAction(gg_trg_Quest_UltimaWeapon_Slain,function Trig_Quest_UltimaWeapon_Slain_Actions)

endfunction





function RegisterR11_Quest_WolfFangs_Start takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_WolfFangs_Start=CreateTrigger()

call DisableTrigger(gg_trg_Quest_WolfFangs_Start)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_WolfFangs_Start,Player(0),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_WolfFangs_Start,Player(1),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_WolfFangs_Start,Player(2),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_WolfFangs_Start,Player(3),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_WolfFangs_Start,Player(4),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_WolfFangs_Start,Player(5),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_WolfFangs_Start,Player(6),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_WolfFangs_Start,Player(7),true)

call TriggerAddCondition(gg_trg_Quest_WolfFangs_Start,Condition(function Trig_Quest_WolfFangs_Start_Conditions))

call TriggerAddAction(gg_trg_Quest_WolfFangs_Start,function Trig_Quest_WolfFangs_Start_Actions)

endfunction





function RegisterR11_Quest_WolfFangs_TurnIn takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_WolfFangs_TurnIn=CreateTrigger()

call DisableTrigger(gg_trg_Quest_WolfFangs_TurnIn)

call TriggerRegisterUnitInRangeSimple(gg_trg_Quest_WolfFangs_TurnIn,450.,gg_unit_n01R_0081)

call TriggerAddCondition(gg_trg_Quest_WolfFangs_TurnIn,Condition(function Trig_Quest_WolfFangs_TurnIn_Conditions))

call TriggerAddAction(gg_trg_Quest_WolfFangs_TurnIn,function Trig_Quest_WolfFangs_TurnIn_Actions)

endfunction





function RegisterR11_Quest_WorldLiberation_Count takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_WorldLiberation_Count=CreateTrigger()

call DisableTrigger(gg_trg_Quest_WorldLiberation_Count)

call TriggerAddAction(gg_trg_Quest_WorldLiberation_Count,function Trig_Quest_WorldLiberation_Count_Actions)

endfunction





function RegisterR11_Quest_WorldLiberation_Reward takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_WorldLiberation_Reward=CreateTrigger()

call TriggerRegisterTimerExpireEventBJ(gg_trg_Quest_WorldLiberation_Reward,udg_LiberationRewardTimer)

call TriggerAddAction(gg_trg_Quest_WorldLiberation_Reward,function Trig_Quest_WorldLiberation_Reward_Actions)

endfunction





function RegisterR11_Quest_YoungEngineer_Start takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_YoungEngineer_Start=CreateTrigger()

call DisableTrigger(gg_trg_Quest_YoungEngineer_Start)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_YoungEngineer_Start,Player(0),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_YoungEngineer_Start,Player(1),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_YoungEngineer_Start,Player(2),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_YoungEngineer_Start,Player(3),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_YoungEngineer_Start,Player(4),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_YoungEngineer_Start,Player(5),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_YoungEngineer_Start,Player(6),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_YoungEngineer_Start,Player(7),true)

call TriggerAddCondition(gg_trg_Quest_YoungEngineer_Start,Condition(function Trig_Quest_YoungEngineer_Start_Conditions))

call TriggerAddAction(gg_trg_Quest_YoungEngineer_Start,function Trig_Quest_YoungEngineer_Start_Actions)

endfunction





function RegisterR11_Quest_YoungEngineer_Ping takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_YoungEngineer_Ping=CreateTrigger()

call DisableTrigger(gg_trg_Quest_YoungEngineer_Ping)

call TriggerRegisterTimerEventPeriodic(gg_trg_Quest_YoungEngineer_Ping,15.)

call TriggerAddCondition(gg_trg_Quest_YoungEngineer_Ping,Condition(function Trig_Quest_YoungEngineer_Ping_Conditions))

call TriggerAddAction(gg_trg_Quest_YoungEngineer_Ping,function Trig_Quest_YoungEngineer_Ping_Actions)

endfunction





function RegisterR11_Quest_YoungEngineer_Complete takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_YoungEngineer_Complete=CreateTrigger()

call DisableTrigger(gg_trg_Quest_YoungEngineer_Complete)

call TriggerAddCondition(gg_trg_Quest_YoungEngineer_Complete,Condition(function Trig_Quest_YoungEngineer_Complete_Conditions))

call TriggerAddAction(gg_trg_Quest_YoungEngineer_Complete,function Trig_Quest_YoungEngineer_Complete_Actions)

endfunction





function RegisterR11_Quest_ZodiacAge_Start takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_ZodiacAge_Start=CreateTrigger()

call DisableTrigger(gg_trg_Quest_ZodiacAge_Start)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_ZodiacAge_Start,Player(0),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_ZodiacAge_Start,Player(1),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_ZodiacAge_Start,Player(2),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_ZodiacAge_Start,Player(3),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_ZodiacAge_Start,Player(4),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_ZodiacAge_Start,Player(5),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_ZodiacAge_Start,Player(6),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_ZodiacAge_Start,Player(7),true)

call TriggerAddCondition(gg_trg_Quest_ZodiacAge_Start,Condition(function Trig_Quest_ZodiacAge_Start_Conditions))

call TriggerAddAction(gg_trg_Quest_ZodiacAge_Start,function Trig_Quest_ZodiacAge_Start_Actions)

endfunction





function RegisterR11_Quest_ZodiacAge_GateBlocked takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_ZodiacAge_GateBlocked=CreateTrigger()

call TriggerRegisterEnterRectSimple(gg_trg_Quest_ZodiacAge_GateBlocked,gg_rct_630)

call TriggerAddCondition(gg_trg_Quest_ZodiacAge_GateBlocked,Condition(function Trig_Quest_ZodiacAge_GateBlocked_Conditions))

call TriggerAddAction(gg_trg_Quest_ZodiacAge_GateBlocked,function Trig_Quest_ZodiacAge_GateBlocked_Actions)

endfunction





function RegisterR11_Quest_ZodiacAge_AskCeleborn takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_ZodiacAge_AskCeleborn=CreateTrigger()

call DisableTrigger(gg_trg_Quest_ZodiacAge_AskCeleborn)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_ZodiacAge_AskCeleborn,Player(0),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_ZodiacAge_AskCeleborn,Player(1),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_ZodiacAge_AskCeleborn,Player(2),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_ZodiacAge_AskCeleborn,Player(3),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_ZodiacAge_AskCeleborn,Player(4),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_ZodiacAge_AskCeleborn,Player(5),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_ZodiacAge_AskCeleborn,Player(6),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_ZodiacAge_AskCeleborn,Player(7),true)

call TriggerAddCondition(gg_trg_Quest_ZodiacAge_AskCeleborn,Condition(function Trig_Quest_ZodiacAge_AskCeleborn_Conditions))

call TriggerAddAction(gg_trg_Quest_ZodiacAge_AskCeleborn,function Trig_Quest_ZodiacAge_AskCeleborn_Actions)

endfunction





function RegisterR11_Quest_ZodiacAge_AskTalon takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_ZodiacAge_AskTalon=CreateTrigger()

call DisableTrigger(gg_trg_Quest_ZodiacAge_AskTalon)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_ZodiacAge_AskTalon,Player(0),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_ZodiacAge_AskTalon,Player(1),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_ZodiacAge_AskTalon,Player(2),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_ZodiacAge_AskTalon,Player(3),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_ZodiacAge_AskTalon,Player(4),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_ZodiacAge_AskTalon,Player(5),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_ZodiacAge_AskTalon,Player(6),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_ZodiacAge_AskTalon,Player(7),true)

call TriggerAddCondition(gg_trg_Quest_ZodiacAge_AskTalon,Condition(function Trig_Quest_ZodiacAge_AskTalon_Conditions))

call TriggerAddAction(gg_trg_Quest_ZodiacAge_AskTalon,function Trig_Quest_ZodiacAge_AskTalon_Actions)

endfunction





function RegisterR11_Quest_ZodiacAge_GetPendant takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_ZodiacAge_GetPendant=CreateTrigger()

call DisableTrigger(gg_trg_Quest_ZodiacAge_GetPendant)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_ZodiacAge_GetPendant,Player(0),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_ZodiacAge_GetPendant,Player(1),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_ZodiacAge_GetPendant,Player(2),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_ZodiacAge_GetPendant,Player(3),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_ZodiacAge_GetPendant,Player(4),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_ZodiacAge_GetPendant,Player(5),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_ZodiacAge_GetPendant,Player(6),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_ZodiacAge_GetPendant,Player(7),true)

call TriggerAddCondition(gg_trg_Quest_ZodiacAge_GetPendant,Condition(function Trig_Quest_ZodiacAge_GetPendant_Conditions))

call TriggerAddAction(gg_trg_Quest_ZodiacAge_GetPendant,function Trig_Quest_ZodiacAge_GetPendant_Actions)

endfunction





function RegisterR11_Quest_ZodiacAge_ShowPendant takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_ZodiacAge_ShowPendant=CreateTrigger()

call DisableTrigger(gg_trg_Quest_ZodiacAge_ShowPendant)

call TriggerRegisterUnitInRangeSimple(gg_trg_Quest_ZodiacAge_ShowPendant,450.,gg_unit_e015_0238)

call TriggerAddCondition(gg_trg_Quest_ZodiacAge_ShowPendant,Condition(function Trig_Quest_ZodiacAge_ShowPendant_Conditions))

call TriggerAddAction(gg_trg_Quest_ZodiacAge_ShowPendant,function Trig_Quest_ZodiacAge_ShowPendant_Actions)

endfunction





function RegisterR11_Quest_ZodiacAge_TalonOpensGate takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Quest_ZodiacAge_TalonOpensGate=CreateTrigger()

call DisableTrigger(gg_trg_Quest_ZodiacAge_TalonOpensGate)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_ZodiacAge_TalonOpensGate,Player(0),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_ZodiacAge_TalonOpensGate,Player(1),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_ZodiacAge_TalonOpensGate,Player(2),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_ZodiacAge_TalonOpensGate,Player(3),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_ZodiacAge_TalonOpensGate,Player(4),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_ZodiacAge_TalonOpensGate,Player(5),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_ZodiacAge_TalonOpensGate,Player(6),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_ZodiacAge_TalonOpensGate,Player(7),true)

call TriggerAddCondition(gg_trg_Quest_ZodiacAge_TalonOpensGate,Condition(function Trig_Quest_ZodiacAge_TalonOpensGate_Conditions))

call TriggerAddAction(gg_trg_Quest_ZodiacAge_TalonOpensGate,function Trig_Quest_ZodiacAge_TalonOpensGate_Actions)

endfunction





endlibrary
