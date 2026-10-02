library TQuestSeekDestroy requires TCam, TCine, TPlayerPart01, TReward, TText, TUnit
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Quest_SeekDestroy_Start=null
    trigger gg_trg_Quest_SeekDestroy_Count=null
    trigger gg_trg_Quest_SeekDestroy_Complete=null
endglobals

function Trig_Quest_SeekDestroy_Start_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_nemi_0078,true,true,true))
endfunction

function Trig_Quest_SeekDestroy_Start_Cond_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_SeekDestroy_Start_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[83])
    if(Trig_Quest_SeekDestroy_Start_Cond_CinematicsEnabled())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(gg_unit_nemi_0078,"Greetings to you. Let me introduce myself - I am Clemydar the Magnificent, Lord Commander of the Seekers Order.... and the only member of the order who didn't sumbit to the will of evil.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"The Seekers order... you're quite notorious aren't you?",false)
        call Text_Say(gg_unit_nemi_0078,"Unfortunately, yes. And there's a reason for that. I'll explain the situation.",false)
        call Text_Say(gg_unit_nemi_0078,"We, members of the Seekers Order, are all wizards. We seek knowledge everywhere we can. We came to this land some time ago through a magical portal from another plane.",false)
        call Text_Say(gg_unit_nemi_0078,"Our leader, Supreme Lord Commander Gwanlleawg, was the one who chanelled the Dimension Door Spell and couldn't join us - he had to stay in our world. If only he came with us he surely wouldn't fail as I did...",false)
        call Text_Say(gg_unit_nemi_0078,"Being second in command in Truth Searchers Order - or Seekers for short - I became the head of the order in this world. We started researching this lands and found many interesting facts about inhabitans of this world. Knowledge is what we Seekers value above all.",false)
        call Text_Say(gg_unit_nemi_0078,"At one point, however, our founder, Trema, who had retired but still travelled with us, ordered all the books and notes about what we had found out to himself. He vanished the same night.",false)
        call Text_Say(gg_unit_nemi_0078,"The complete eradication of all the knowledge we had acquired and written down caused severe depression among my friends. Maybe that made their wills easier to break...",false)
        call Text_Say(gg_unit_nemi_0078,"My fellow wizards grew less interested in gaining knowledge. They acted strangely. And one day I heard a voice in my head.  The voice ... that voice makes you desire to submit to his will and do what he commands.",false)
        call Text_Say(gg_unit_nemi_0078,"Through enourmous effort I managed to break the spell and get back to my senses. But the other members of the Order were not as strong as me. They all became loyal servants of that spellweaver. Now they are but a part of his army along with bandits, ogres, kobolds and other evil creatures.",false)
        call Text_Say(gg_unit_nemi_0078,"I tried to save them but was not able to. I barely survived when they together attacked me. And now I am afraid that there is no salvation for them ... save for death.",false)
        call Text_Say(gg_unit_nemi_0078,"It is hard for me to do but I ask you to kill my brethren who turned evil. There are many of them, but it should be enough if you kill off three of their former leaders. And maybe someday I'll find they way to cure the rest of the Seekers members I failed to protect.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"You are right. They are not the wizards you knew but servants of evil now. Who are those leaders you wish us to kill?",false)
        call Text_Say(gg_unit_nemi_0078,"Kinoc, Kelk and Mika. Formerly high-ranking Seekers and my friends. They are still some of the more powerful members among their ranks. Beware as they know some truly dangerous magic.",false)
        call Cine_ExitAction()
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_DISCOVERED,"New Quest Received: |cffffcc00Seek and Destroy|r")
    set udg_SideQuest[25]=CreateQuestBJ(bj_QUESTTYPE_REQ_DISCOVERED,(udg_QuestNamePrefix+"Seek and Destroy"),"Clemydar, wizard from the Mountains, asked you to slay three leaders of the evil corrupted Seekers order who may be found in the mountain west from Kalm. Beware their magic!","ReplaceableTextures\\CommandButtons\\BTNBanditMage.blp")
    set udg_QuestReq[7]=CreateQuestItemBJ(GetLastCreatedQuestBJ(),"Seekers killed: 0/3")
    set udg_SpecialEffect[83]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_nemi_0078,"Objects\\RandomObject\\RandomObject.mdl")
    // A random whole number from 1 through LoadIntegerBJ(4, 2, udg_SpawnDataHashRef).
    set udg_TempPoint=GetRandomLocInRect(LoadRectHandleBJ(GetRandomInt(1,LoadIntegerBJ(4,2,udg_SpawnDataHashRef)),4,udg_SpawnRectHashRef))
    call CreateNUnitsAtLoc(1,'n0CJ',Player($B),udg_TempPoint,bj_UNIT_FACING) // 'n0CJ': unit "Kelk"; $B = 11
    call RemoveLocation(udg_TempPoint)
    call GroupAddUnitSimple(GetLastCreatedUnit(),udg_SeekerLeaders)
    call Unit_ScaleToLevel60(bj_lastCreatedUnit)
    call UnitAddAbilityBJ('A102',GetLastCreatedUnit()) // 'A102': ability "!Teleport"
    // A random whole number from 1 through LoadIntegerBJ(4, 2, udg_SpawnDataHashRef).
    set udg_TempPoint=GetRandomLocInRect(LoadRectHandleBJ(GetRandomInt(1,LoadIntegerBJ(4,2,udg_SpawnDataHashRef)),4,udg_SpawnRectHashRef))
    call IssuePointOrderLocBJ(GetLastCreatedUnit(),"patrol",udg_TempPoint)
    call RemoveLocation(udg_TempPoint)
    // A random whole number from 1 through LoadIntegerBJ(4, 2, udg_SpawnDataHashRef).
    set udg_TempPoint=GetRandomLocInRect(LoadRectHandleBJ(GetRandomInt(1,LoadIntegerBJ(4,2,udg_SpawnDataHashRef)),4,udg_SpawnRectHashRef))
    call CreateNUnitsAtLoc(1,'n0CA',Player($B),udg_TempPoint,bj_UNIT_FACING) // 'n0CA': unit "Kinoc"; $B = 11
    call RemoveLocation(udg_TempPoint)
    call GroupAddUnitSimple(GetLastCreatedUnit(),udg_SeekerLeaders)
    call Unit_ScaleToLevel60(bj_lastCreatedUnit)
    call UnitAddAbilityBJ('A102',GetLastCreatedUnit()) // 'A102': ability "!Teleport"
    // A random whole number from 1 through LoadIntegerBJ(4, 2, udg_SpawnDataHashRef).
    set udg_TempPoint=GetRandomLocInRect(LoadRectHandleBJ(GetRandomInt(1,LoadIntegerBJ(4,2,udg_SpawnDataHashRef)),4,udg_SpawnRectHashRef))
    call IssuePointOrderLocBJ(GetLastCreatedUnit(),"patrol",udg_TempPoint)
    call RemoveLocation(udg_TempPoint)
    // A random whole number from 1 through LoadIntegerBJ(4, 2, udg_SpawnDataHashRef).
    set udg_TempPoint=GetRandomLocInRect(LoadRectHandleBJ(GetRandomInt(1,LoadIntegerBJ(4,2,udg_SpawnDataHashRef)),4,udg_SpawnRectHashRef))
    call CreateNUnitsAtLoc(1,'n0CI',Player($B),udg_TempPoint,bj_UNIT_FACING) // 'n0CI': unit "Mika"; $B = 11
    call RemoveLocation(udg_TempPoint)
    call GroupAddUnitSimple(GetLastCreatedUnit(),udg_SeekerLeaders)
    call Unit_ScaleToLevel60(bj_lastCreatedUnit)
    call UnitAddAbilityBJ('A102',GetLastCreatedUnit()) // 'A102': ability "!Teleport"
    // A random whole number from 1 through LoadIntegerBJ(4, 2, udg_SpawnDataHashRef).
    set udg_TempPoint=GetRandomLocInRect(LoadRectHandleBJ(GetRandomInt(1,LoadIntegerBJ(4,2,udg_SpawnDataHashRef)),4,udg_SpawnRectHashRef))
    call IssuePointOrderLocBJ(GetLastCreatedUnit(),"patrol",udg_TempPoint)
    call RemoveLocation(udg_TempPoint)
    call EnableTrigger(gg_trg_Seekers_TrackEngaged)
    call EnableTrigger(gg_trg_Quest_SeekDestroy_Count)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Quest_SeekDestroy_Count_Conditions takes nothing returns boolean
    return(IsUnitInGroup(GetTriggerUnit(),udg_SeekerLeaders))
endfunction

function Trig_Quest_SeekDestroy_Count_Cond_AllSeekersDead takes nothing returns boolean
    return(IsUnitGroupEmptyBJ(udg_SeekerLeaders))
endfunction

function Trig_Quest_SeekDestroy_Count_Actions takes nothing returns nothing
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_SeekerLeaders)
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_BossUnits)
    // (3) minus (CountUnitsInGroup(udg_SeekerLeaders)).
    call QuestItemSetDescriptionBJ(udg_QuestReq[7],(("Seekers killed: "+I2S((3-CountUnitsInGroup(udg_SeekerLeaders))))+"/3"))
    if(Trig_Quest_SeekDestroy_Count_Cond_AllSeekersDead())then
        call DisableTrigger(GetTriggeringTrigger())
        set udg_TempPoint3=GetUnitLoc(GetTriggerUnit())
        call CreateItemLoc('I0HZ',udg_TempPoint3) // 'I0HZ': item "Tome of Time"
        call RemoveLocation(udg_TempPoint3)
        call QuestItemSetCompletedBJ(udg_QuestReq[7],true)
        call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_UPDATED,"Return to Clemydar.")
        call QuestSetDescriptionBJ(udg_SideQuest[25],"Return to Clemydar.")
        call GroupAddUnitSimple(gg_unit_nemi_0078,udg_BossUnits)
        call EnableTrigger(gg_trg_Quest_SeekDestroy_Complete)
        call DestroyTrigger(GetTriggeringTrigger())
    endif
endfunction

function Trig_Quest_SeekDestroy_Complete_Conditions takes nothing returns boolean
    return((IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(GetUnitTypeId(GetTriggerUnit())!='H01D')and(udg_InCinematicMode==false))!=null // 'H01D': unit "Spirit of Gaya"
endfunction

function Trig_Quest_SeekDestroy_Complete_Cond_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_SeekDestroy_Complete_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call GroupRemoveUnitSimple(gg_unit_nemi_0078,udg_BossUnits)
    call DestroyEffectBJ(udg_SpecialEffect[83])
    if(Trig_Quest_SeekDestroy_Complete_Cond_CinematicsEnabled())then
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_nemi_0078,0)
        call Text_Say(gg_unit_nemi_0078,"Thank you. I hope their souls wiil find rest now that they are free from their service to evil. And maybe I'll eventually find the way to free the others from domination.",false)
        call Reward_Give($9C4,$9C4,gg_unit_nemi_0078) // $9C4 = 2500
        call Text_Say(gg_unit_nemi_0078,"I suppose the only remains of our once so great collection of knowledge about this land are the notes of my bretheren...",false)
        call Cine_ExitAction()
    else
        call Reward_Give($9C4,$9C4,gg_unit_nemi_0078) // $9C4 = 2500
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_COMPLETED,"Quest Completed: |cffffcc00Seek and Destroy|r")
    call QuestSetCompletedBJ(udg_SideQuest[25],true)
    set udg_QuestsCompleted=(udg_QuestsCompleted+1)
    call EnableTrigger(gg_trg_FadingNotes_DropCultist)
    call EnableTrigger(gg_trg_FadingNotes_DropWizard)
    set udg_QuestMarkerEffect[26]=AddSpecialEffectTargetUnitBJ("head",gg_unit_h031_0114,"Abilities\\Spells\\Other\\Silence\\SilenceTarget.mdl")
    call EnableTrigger(gg_trg_Npc_Talk_Quincy)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function InitTrig_Quest_SeekDestroy takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Quest_Part10 (module Quest),
// which keeps the original registration order.

function Register_Quest_SeekDestroy_Start takes nothing returns nothing
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

function Register_Quest_SeekDestroy_Count takes nothing returns nothing
    set gg_trg_Quest_SeekDestroy_Count=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_SeekDestroy_Count)
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_Quest_SeekDestroy_Count,Player($B),EVENT_PLAYER_UNIT_DEATH) // $B = 11
    call TriggerAddCondition(gg_trg_Quest_SeekDestroy_Count,Condition(function Trig_Quest_SeekDestroy_Count_Conditions))
    call TriggerAddAction(gg_trg_Quest_SeekDestroy_Count,function Trig_Quest_SeekDestroy_Count_Actions)
endfunction

function Register_Quest_SeekDestroy_Complete takes nothing returns nothing
    set gg_trg_Quest_SeekDestroy_Complete=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_SeekDestroy_Complete)
    call TriggerRegisterUnitInRangeSimple(gg_trg_Quest_SeekDestroy_Complete,450.,gg_unit_nemi_0078)
    call TriggerAddCondition(gg_trg_Quest_SeekDestroy_Complete,Condition(function Trig_Quest_SeekDestroy_Complete_Conditions))
    call TriggerAddAction(gg_trg_Quest_SeekDestroy_Complete,function Trig_Quest_SeekDestroy_Complete_Actions)
endfunction

endlibrary
