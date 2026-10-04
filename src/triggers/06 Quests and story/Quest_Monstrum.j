library TQuestMonstrum requires TQuestEngine, TReward
// Side quest "Monstrum of the Sea", run by the quest engine (QuestEngine module, docs/QUEST_ENGINE.md).
// The Nebra Monstrum (Monstrum module) ambushes a hero carrying the Grattheos Charm; the quest starts then
// and is done when the Monstrum dies. Does not count toward the story.
globals
    // The quest's number in the quest engine (0 until it is defined).
    integer QUEST_MONSTRUM=0
endglobals

function QuestMonstrum_KillRemainingTentacle takes nothing returns nothing
    call KillUnit(GetEnumUnit())
endfunction

// Quest done (the Monstrum is dead): its fight ends, it drops the Slither Shield and takes the charm along.
function QuestMonstrum_Slain takes nothing returns nothing
    local location l_tempPoint
    call DisableTrigger(gg_trg_Monstrum_Phase_Check)
    call DestroyTrigger(gg_trg_Monstrum_Phase_Check)
    call DisableTrigger(gg_trg_Monstrum_Ambush_Rearm)
    call DestroyTrigger(gg_trg_Monstrum_Ambush_Rearm)
    if udg_SpeedrunMode then
        set udg_BossUnit=udg_NebraMonstrum
        call ConditionalTriggerExecute(gg_trg_Speedrun_Accolade)
    endif
    call GroupRemoveUnitSimple(udg_NebraMonstrum,udg_BossUnits)
    set l_tempPoint=GetUnitLoc(udg_NebraMonstrum)
    call CreateItemLoc('I0BF',l_tempPoint) // 'I0BF': item "Slither Shield"
    call RemoveLocation(l_tempPoint)
    call ForGroupBJ(udg_TentacleGroup,function QuestMonstrum_KillRemainingTentacle)
    call GroupClear(udg_TentacleGroup)
    call DisplayTimedTextToForce(GetPlayersAll(),10.," ")
    call DisplayTimedTextToForce(GetPlayersAll(),10.,"As the Monstrum sinks below the sea lifelessly, it drags the |cffffcc00Grattheos Charm|r down with it.")
    call RemoveItem(udg_QuestItem[27])
    call Reward_Give(0,8000,udg_NarratorUnit)
    if IsQuestCompleted(udg_SideQuest[48]) then
        // King of the Sea is done too: a bonus arena battle
        set udg_ArenaBonusBattle[0]=udg_ArenaBonusBattle[0]+1
        set udg_ArenaBonusBattle[udg_ArenaBonusBattle[0]]=186
    endif
    set l_tempPoint=null
endfunction

// Called by Monstrum_Summon (through ExecuteFunc) right after the Monstrum (udg_NebraMonstrum) is created.
function QuestMonstrum_Start takes nothing returns nothing
    local integer q
    if QUEST_MONSTRUM==0 then
        set q=Quest_Define("Monstrum of the Sea",QUEST_SIDE,71,"ReplaceableTextures\\CommandButtons\\BTNForgottenOne.blp")
        set QUEST_MONSTRUM=q
        call Quest_NotStory(q)
        call Quest_NoMarker(q)
        // 1. The Monstrum ambushes the party
        call Quest_Custom(q,"A monstrum from the abyss of the sea ambushed you. Kill it!")
        // 2. Kill it
        call Quest_Kill(q,udg_NebraMonstrum,"")
        call Quest_OnDone(q,"QuestMonstrum_Slain")
    endif
    call Quest_Start(QUEST_MONSTRUM,null,null)
endfunction

// Called by Monstrum_Summon (through ExecuteFunc) when the Monstrum surfaces again.
function QuestMonstrum_Reappeared takes nothing returns nothing
    // the log text and the announcement differ, so the announcement is shown here
    call Quest_SetLog(QUEST_MONSTRUM,"The Nebra Monstrum has reappeared! Kill it!",false)
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_UPDATED,"Kill the Nebra Monstrum.")
endfunction

// Called by Monstrum_Phase_Check (through ExecuteFunc) when the Monstrum dives away.
function QuestMonstrum_Dived takes nothing returns nothing
    call Quest_SetLog(QUEST_MONSTRUM,"The Nebra Monstrum has dived down under! Find it again!",false)
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_UPDATED,"Find the Nebra Monstrum again.")
endfunction

// World Editor calls InitTrig_Quest_Monstrum automatically; it is intentionally empty (the quest engine
// creates the trigger this quest waits on).
function InitTrig_Quest_Monstrum takes nothing returns nothing
endfunction

endlibrary
