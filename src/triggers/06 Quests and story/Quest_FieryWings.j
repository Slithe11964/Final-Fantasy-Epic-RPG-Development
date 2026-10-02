library TQuestFieryWings requires TCam, TCine, TPlayerPart01, TReward, TText, TUnit
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Quest_FieryWings_Start=null
    trigger gg_trg_Quest_FieryWings_Matriarch_Dead=null
    trigger gg_trg_Quest_FieryWings_Complete=null
endglobals

function Trig_Quest_FieryWings_Start_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_h00Q_0255,true,true,true))
endfunction

function Trig_Quest_FieryWings_Start_PlayHarpyScene takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_FieryWings_Start_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[91])
    if(Trig_Quest_FieryWings_Start_PlayHarpyScene())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(gg_unit_h00Q_0255,"Lali-ho to ye! If ye're adventurers, we got a job for ye to take on.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Sure, what've you got for us?",false)
        call Text_Say(gg_unit_h00Q_0255,"See we heard from our pals in Kalm that monster activity has been on the rise and it's been kinda scary. We're in this remote corner but the monsters be leavin' us alone entirely.",false)
        call Text_Say(gg_unit_h00Q_0255,"We hired the striker over there to protect us if it's necessary, but not even a single attack has hit us so far.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"That's strange. The monsters have certainly been aggressive lately. Why would they just leave you alone entirely?",false)
        call Text_Say(gg_unit_h00Q_0255,"Well we been thinkin', what if they are gathering their forces for one big strike? Maybe they be scoutin' our defenses and aim to overwhelm us all at once.",false)
        call Text_Say(gg_unit_h00Q_0255,"So the lads been lookin' around and saw that there's a big harpy uniting the harpy tribes all at once underneath her. It's right in the middle of the Barrens on a hill, ye can't miss it.",false)
        call Text_Say(gg_unit_h00Q_0255,"If ye think ye're strong enough to take it on, kill it for us, will ye? We don' mind harpies too much but they can be seriously scheming and dangerous. If they be gearin' up for a big attack, losin' their leader should throw them in disorder an' keep us all safe.",false)
        call Text_Say(gg_unit_h00Q_0255,"Careful though. Like I said, she's their leader, she'll call for aid when she's attacked. Might be wiser to take down the little ones all over the place first, lest ye get swarmed. But that's up to ye to decide.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Worry not. We will take down this Harpy so you may feel safe once more.",false)
        call Cine_ExitAction()
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_DISCOVERED,"New Quest Received: |cffffcc00Fiery Wings|r")
    set udg_SideQuest[68]=CreateQuestBJ(bj_QUESTTYPE_REQ_DISCOVERED,(udg_QuestNamePrefix+"Fiery Wings"),"Zone and Watts, a duo of dwarves in the Barrens, tasked you with taking down the Harpy Matriarch in the center of the Barrens that united the harpy clans.","ReplaceableTextures\\CommandButtons\\BTNHarpy.blp")
    set udg_SpecialEffect[91]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_h00Q_0255,"Objects\\RandomObject\\RandomObject.mdl")
    set udg_TempPoint=GetRectCenter(gg_rct_569)
    call CreateNUnitsAtLoc(1,'n0KZ',Player($B),udg_TempPoint,255.) // 'n0KZ': unit "Harpy Matriarch"; $B = 11
    call Unit_ScaleToLevel60(bj_lastCreatedUnit)
    call RemoveLocation(udg_TempPoint)
    set udg_HarpyMatriarch=GetLastCreatedUnit()
    call GroupAddUnitSimple(GetLastCreatedUnit(),udg_BossUnits)
    call TriggerRegisterUnitEvent(gg_trg_Quest_FieryWings_Matriarch_Dead,GetLastCreatedUnit(),EVENT_UNIT_DEATH)
    call EnableTrigger(gg_trg_Quest_FieryWings_Matriarch_Dead)
    call EnableTrigger(gg_trg_Harpy_Matriarch_CallAid)
    call EnableTrigger(gg_trg_Harpy_Trickster_Cleanup)
    set udg_TempPoint=GetRectCenter(gg_rct_111)
    call CreateNUnitsAtLoc(1,'n0L0',Player($B),udg_TempPoint,bj_UNIT_FACING) // 'n0L0': unit "Harpy Trickster"; $B = 11
    call Unit_ScaleToLevel60(bj_lastCreatedUnit)
    call RemoveLocation(udg_TempPoint)
    call GroupAddUnitSimple(GetLastCreatedUnit(),udg_HarpyTricksters)
    set udg_TempPoint=GetRectCenter(gg_rct_087)
    call CreateNUnitsAtLoc(1,'n0L0',Player($B),udg_TempPoint,bj_UNIT_FACING) // 'n0L0': unit "Harpy Trickster"; $B = 11
    call Unit_ScaleToLevel60(bj_lastCreatedUnit)
    call RemoveLocation(udg_TempPoint)
    call GroupAddUnitSimple(GetLastCreatedUnit(),udg_HarpyTricksters)
    set udg_TempPoint=GetRectCenter(gg_rct_108)
    call CreateNUnitsAtLoc(1,'n0L0',Player($B),udg_TempPoint,bj_UNIT_FACING) // 'n0L0': unit "Harpy Trickster"; $B = 11
    call Unit_ScaleToLevel60(bj_lastCreatedUnit)
    call RemoveLocation(udg_TempPoint)
    call GroupAddUnitSimple(GetLastCreatedUnit(),udg_HarpyTricksters)
    set udg_TempPoint=GetRectCenter(gg_rct_096)
    call CreateNUnitsAtLoc(1,'n0L0',Player($B),udg_TempPoint,bj_UNIT_FACING) // 'n0L0': unit "Harpy Trickster"; $B = 11
    call Unit_ScaleToLevel60(bj_lastCreatedUnit)
    call RemoveLocation(udg_TempPoint)
    call GroupAddUnitSimple(GetLastCreatedUnit(),udg_HarpyTricksters)
    set udg_TempPoint=GetRectCenter(gg_rct_062)
    call CreateNUnitsAtLoc(1,'n0L0',Player($B),udg_TempPoint,bj_UNIT_FACING) // 'n0L0': unit "Harpy Trickster"; $B = 11
    call Unit_ScaleToLevel60(bj_lastCreatedUnit)
    call RemoveLocation(udg_TempPoint)
    call GroupAddUnitSimple(GetLastCreatedUnit(),udg_HarpyTricksters)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Quest_FieryWings_Matriarch_Dead_Conditions takes nothing returns boolean
    return(GetTriggerUnit()==udg_HarpyMatriarch)
endfunction

function Trig_Quest_FieryWings_Matriarch_Dead_ReleaseHiddenHarpy takes nothing returns nothing
    call ShowUnitShow(GetEnumUnit())
    call PauseUnitBJ(false,GetEnumUnit())
endfunction

function Trig_Quest_FieryWings_Matriarch_Dead_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_BossUnits)
    call DisableTrigger(gg_trg_Harpy_Matriarch_CallAid)
    call DisableTrigger(gg_trg_Harpy_Trickster_Cleanup)
    call ForGroupBJ(udg_HarpyTricksters,function Trig_Quest_FieryWings_Matriarch_Dead_ReleaseHiddenHarpy)
    call GroupClear(udg_HarpyTricksters)
    call GroupAddUnitSimple(gg_unit_h00Q_0255,udg_BossUnits)
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_UPDATED,"Return to Zone and Watts.")
    call QuestSetDescriptionBJ(udg_SideQuest[68],"Return to Zone and Watts.")
    call StartTimerBJ(udg_HerbRespawnTimer[1],false,.5)
    call EnableTrigger(gg_trg_Quest_FieryWings_Complete)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Quest_FieryWings_Complete_Conditions takes nothing returns boolean
    return((IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(GetUnitTypeId(GetTriggerUnit())!='H01D')and(IsUnitHiddenBJ(gg_unit_h00Q_0255)==false)and(udg_InCinematicMode==false))!=null // 'H01D': unit "Spirit of Gaya"
endfunction

function Trig_Quest_FieryWings_Complete_PlayThanksScene takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_FieryWings_Complete_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call GroupRemoveUnitSimple(gg_unit_h00Q_0255,udg_BossUnits)
    call DestroyEffectBJ(udg_SpecialEffect[91])
    if(Trig_Quest_FieryWings_Complete_PlayThanksScene())then
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_h00Q_0255,0)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"We have taken down the Harpy Matriarch. These harpies will bother you no longer.",false)
        call Text_Say(gg_unit_h00Q_0255,"Aye many thanks. This'll help us sleep better at night.",false)
        call Reward_Give($FA0,$7D0,gg_unit_h00Q_0255) // $FA0 = 4000; $7D0 = 2000
        call Cine_ExitAction()
    else
        call Reward_Give($FA0,$7D0,gg_unit_h00Q_0255) // $FA0 = 4000; $7D0 = 2000
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_COMPLETED,"Quest Completed: |cffffcc00Fiery Wings|r")
    call QuestSetCompletedBJ(udg_SideQuest[68],true)
    set udg_QuestsCompleted=(udg_QuestsCompleted+1)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function InitTrig_Quest_FieryWings takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Quest_Part19 (module Quest),
// which keeps the original registration order.

function Register_Quest_FieryWings_Start takes nothing returns nothing
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

function Register_Quest_FieryWings_Matriarch_Dead takes nothing returns nothing
    set gg_trg_Quest_FieryWings_Matriarch_Dead=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_FieryWings_Matriarch_Dead)
    call TriggerAddCondition(gg_trg_Quest_FieryWings_Matriarch_Dead,Condition(function Trig_Quest_FieryWings_Matriarch_Dead_Conditions))
    call TriggerAddAction(gg_trg_Quest_FieryWings_Matriarch_Dead,function Trig_Quest_FieryWings_Matriarch_Dead_Actions)
endfunction

function Register_Quest_FieryWings_Complete takes nothing returns nothing
    set gg_trg_Quest_FieryWings_Complete=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_FieryWings_Complete)
    call TriggerRegisterUnitInRangeSimple(gg_trg_Quest_FieryWings_Complete,450.,gg_unit_h00Q_0255)
    call TriggerAddCondition(gg_trg_Quest_FieryWings_Complete,Condition(function Trig_Quest_FieryWings_Complete_Conditions))
    call TriggerAddAction(gg_trg_Quest_FieryWings_Complete,function Trig_Quest_FieryWings_Complete_Actions)
endfunction

endlibrary
