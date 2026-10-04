library TQuestSeekDestroy requires TQuestEngine, TUnit
// Side quest "Seek and Destroy", written for the quest engine (QuestEngine module, docs/QUEST_ENGINE.md).
// Clemydar, the last free member of the Seekers order, asks the party to kill three of its corrupted leaders.
// Made available by Clemydar, which calls QuestSeekDestroy_Available. Does not count toward the story.
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Quest_SeekDestroy_Count=null
    // The quest's number in the quest engine (0 until it is defined).
    integer QUEST_SEEK_DESTROY=0
endglobals

// Step 1 done (the party talked to Clemydar): Kelk, Kinoc and Mika appear in the mountains west of Kalm.
function QuestSeekDestroy_Started takes nothing returns nothing
    local location l_tempPoint
    set udg_QuestReq[7]=CreateQuestItemBJ(Quest_LogEntry(QUEST_SEEK_DESTROY),"Seekers killed: 0/3")
    // A random whole number from 1 through LoadIntegerBJ(4, 2, udg_SpawnDataHashRef).
    set l_tempPoint=GetRandomLocInRect(LoadRectHandleBJ(GetRandomInt(1,LoadIntegerBJ(4,2,udg_SpawnDataHashRef)),4,udg_SpawnRectHashRef))
    call CreateNUnitsAtLoc(1,'n0CJ',Player($B),l_tempPoint,bj_UNIT_FACING) // 'n0CJ': unit "Kelk"; $B = 11
    call RemoveLocation(l_tempPoint)
    call GroupAddUnitSimple(GetLastCreatedUnit(),udg_SeekerLeaders)
    call Unit_ScaleToLevel60(bj_lastCreatedUnit)
    call UnitAddAbilityBJ('A102',GetLastCreatedUnit()) // 'A102': ability "!Teleport"
    // A random whole number from 1 through LoadIntegerBJ(4, 2, udg_SpawnDataHashRef).
    set l_tempPoint=GetRandomLocInRect(LoadRectHandleBJ(GetRandomInt(1,LoadIntegerBJ(4,2,udg_SpawnDataHashRef)),4,udg_SpawnRectHashRef))
    call IssuePointOrderLocBJ(GetLastCreatedUnit(),"patrol",l_tempPoint)
    call RemoveLocation(l_tempPoint)
    // A random whole number from 1 through LoadIntegerBJ(4, 2, udg_SpawnDataHashRef).
    set l_tempPoint=GetRandomLocInRect(LoadRectHandleBJ(GetRandomInt(1,LoadIntegerBJ(4,2,udg_SpawnDataHashRef)),4,udg_SpawnRectHashRef))
    call CreateNUnitsAtLoc(1,'n0CA',Player($B),l_tempPoint,bj_UNIT_FACING) // 'n0CA': unit "Kinoc"; $B = 11
    call RemoveLocation(l_tempPoint)
    call GroupAddUnitSimple(GetLastCreatedUnit(),udg_SeekerLeaders)
    call Unit_ScaleToLevel60(bj_lastCreatedUnit)
    call UnitAddAbilityBJ('A102',GetLastCreatedUnit()) // 'A102': ability "!Teleport"
    // A random whole number from 1 through LoadIntegerBJ(4, 2, udg_SpawnDataHashRef).
    set l_tempPoint=GetRandomLocInRect(LoadRectHandleBJ(GetRandomInt(1,LoadIntegerBJ(4,2,udg_SpawnDataHashRef)),4,udg_SpawnRectHashRef))
    call IssuePointOrderLocBJ(GetLastCreatedUnit(),"patrol",l_tempPoint)
    call RemoveLocation(l_tempPoint)
    // A random whole number from 1 through LoadIntegerBJ(4, 2, udg_SpawnDataHashRef).
    set l_tempPoint=GetRandomLocInRect(LoadRectHandleBJ(GetRandomInt(1,LoadIntegerBJ(4,2,udg_SpawnDataHashRef)),4,udg_SpawnRectHashRef))
    call CreateNUnitsAtLoc(1,'n0CI',Player($B),l_tempPoint,bj_UNIT_FACING) // 'n0CI': unit "Mika"; $B = 11
    call RemoveLocation(l_tempPoint)
    call GroupAddUnitSimple(GetLastCreatedUnit(),udg_SeekerLeaders)
    call Unit_ScaleToLevel60(bj_lastCreatedUnit)
    call UnitAddAbilityBJ('A102',GetLastCreatedUnit()) // 'A102': ability "!Teleport"
    // A random whole number from 1 through LoadIntegerBJ(4, 2, udg_SpawnDataHashRef).
    set l_tempPoint=GetRandomLocInRect(LoadRectHandleBJ(GetRandomInt(1,LoadIntegerBJ(4,2,udg_SpawnDataHashRef)),4,udg_SpawnRectHashRef))
    call IssuePointOrderLocBJ(GetLastCreatedUnit(),"patrol",l_tempPoint)
    call RemoveLocation(l_tempPoint)
    call EnableTrigger(gg_trg_Seekers_TrackEngaged)
    call EnableTrigger(gg_trg_Quest_SeekDestroy_Count)
    set l_tempPoint=null
endfunction

// Quest done: the Seekers' notes can drop, and Quincy has something to say.
function QuestSeekDestroy_Done takes nothing returns nothing
    call EnableTrigger(gg_trg_FadingNotes_DropCultist)
    call EnableTrigger(gg_trg_FadingNotes_DropWizard)
    set udg_QuestMarkerEffect[26]=AddSpecialEffectTargetUnitBJ("head",gg_unit_h031_0114,"Abilities\\Spells\\Other\\Silence\\SilenceTarget.mdl")
    call EnableTrigger(gg_trg_Npc_Talk_Quincy)
endfunction

function QuestSeekDestroy_Define takes nothing returns nothing
    local integer q=Quest_Define("Seek and Destroy",QUEST_SIDE,25,"ReplaceableTextures\\CommandButtons\\BTNBanditMage.blp")
    set QUEST_SEEK_DESTROY=q
    call Quest_NotStory(q)
    // 1. Talk to Clemydar
    call Quest_Talk(q,gg_unit_nemi_0078,"Clemydar, wizard from the Mountains, asked you to slay three leaders of the evil corrupted Seekers order who may be found in the mountain west from Kalm. Beware their magic!")
    call Quest_Say(q,gg_unit_nemi_0078,"Greetings to you. Let me introduce myself - I am Clemydar the Magnificent, Lord Commander of the Seekers Order.... and the only member of the order who didn't sumbit to the will of evil.")
    call Quest_Say(q,null,"The Seekers order... you're quite notorious aren't you?")
    call Quest_Say(q,gg_unit_nemi_0078,"Unfortunately, yes. And there's a reason for that. I'll explain the situation.")
    call Quest_Say(q,gg_unit_nemi_0078,"We, members of the Seekers Order, are all wizards. We seek knowledge everywhere we can. We came to this land some time ago through a magical portal from another plane.")
    call Quest_Say(q,gg_unit_nemi_0078,"Our leader, Supreme Lord Commander Gwanlleawg, was the one who chanelled the Dimension Door Spell and couldn't join us - he had to stay in our world. If only he came with us he surely wouldn't fail as I did...")
    call Quest_Say(q,gg_unit_nemi_0078,"Being second in command in Truth Searchers Order - or Seekers for short - I became the head of the order in this world. We started researching this lands and found many interesting facts about inhabitans of this world. Knowledge is what we Seekers value above all.")
    call Quest_Say(q,gg_unit_nemi_0078,"At one point, however, our founder, Trema, who had retired but still travelled with us, ordered all the books and notes about what we had found out to himself. He vanished the same night.")
    call Quest_Say(q,gg_unit_nemi_0078,"The complete eradication of all the knowledge we had acquired and written down caused severe depression among my friends. Maybe that made their wills easier to break...")
    call Quest_Say(q,gg_unit_nemi_0078,"My fellow wizards grew less interested in gaining knowledge. They acted strangely. And one day I heard a voice in my head.  The voice ... that voice makes you desire to submit to his will and do what he commands.")
    call Quest_Say(q,gg_unit_nemi_0078,"Through enourmous effort I managed to break the spell and get back to my senses. But the other members of the Order were not as strong as me. They all became loyal servants of that spellweaver. Now they are but a part of his army along with bandits, ogres, kobolds and other evil creatures.")
    call Quest_Say(q,gg_unit_nemi_0078,"I tried to save them but was not able to. I barely survived when they together attacked me. And now I am afraid that there is no salvation for them ... save for death.")
    call Quest_Say(q,gg_unit_nemi_0078,"It is hard for me to do but I ask you to kill my brethren who turned evil. There are many of them, but it should be enough if you kill off three of their former leaders. And maybe someday I'll find they way to cure the rest of the Seekers members I failed to protect.")
    call Quest_Say(q,null,"You are right. They are not the wizards you knew but servants of evil now. Who are those leaders you wish us to kill?")
    call Quest_Say(q,gg_unit_nemi_0078,"Kinoc, Kelk and Mika. Formerly high-ranking Seekers and my friends. They are still some of the more powerful members among their ranks. Beware as they know some truly dangerous magic.")
    call Quest_OnDone(q,"QuestSeekDestroy_Started")
    // 2. Kill the three Seeker leaders (counted by the Count trigger below)
    call Quest_Custom(q,"Return to Clemydar.")
    // 3. Report back to Clemydar
    call Quest_Return(q,gg_unit_nemi_0078,"")
    call Quest_PingUnit(q)
    call Quest_Say(q,gg_unit_nemi_0078,"Thank you. I hope their souls wiil find rest now that they are free from their service to evil. And maybe I'll eventually find the way to free the others from domination.")
    call Quest_Reward(q,2500,2500)
    call Quest_Say(q,gg_unit_nemi_0078,"I suppose the only remains of our once so great collection of knowledge about this land are the notes of my bretheren...")
    call Quest_OnDone(q,"QuestSeekDestroy_Done")
endfunction

// Called by Clemydar shortly after the game starts.
function QuestSeekDestroy_Available takes nothing returns nothing
    if QUEST_SEEK_DESTROY==0 then
        call QuestSeekDestroy_Define()
    endif
    call Quest_MakeAvailable(QUEST_SEEK_DESTROY)
endfunction

function Trig_Quest_SeekDestroy_Count_Conditions takes nothing returns boolean
    return(IsUnitInGroup(GetTriggerUnit(),udg_SeekerLeaders))
endfunction

function Trig_Quest_SeekDestroy_Count_Cond_AllSeekersDead takes nothing returns boolean
    return(IsUnitGroupEmptyBJ(udg_SeekerLeaders))
endfunction

// A Seeker leader died. When all three are dead, the last one drops the Tome of Time and step 2 is done.
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
        call Quest_StepDone(QUEST_SEEK_DESTROY,GetOwningPlayer(GetKillingUnit()),GetKillingUnit())
        call DestroyTrigger(GetTriggeringTrigger())
    endif
endfunction

function InitTrig_Quest_SeekDestroy takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Quest_Part10 (module Quest),
// which keeps the original registration order.

function Register_Quest_SeekDestroy_Count takes nothing returns nothing
    set gg_trg_Quest_SeekDestroy_Count=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_SeekDestroy_Count)
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_Quest_SeekDestroy_Count,Player($B),EVENT_PLAYER_UNIT_DEATH) // $B = 11
    call TriggerAddCondition(gg_trg_Quest_SeekDestroy_Count,Condition(function Trig_Quest_SeekDestroy_Count_Conditions))
    call TriggerAddAction(gg_trg_Quest_SeekDestroy_Count,function Trig_Quest_SeekDestroy_Count_Actions)
endfunction

endlibrary
