library TQuestMonstrum requires TReward
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Quest_Monstrum_Complete=null
endglobals

function Trig_Quest_Monstrum_Complete_HuntLogEnabled takes nothing returns boolean
    return(udg_SpeedrunMode)
endfunction

function Trig_Quest_Monstrum_Complete_KillRemainingTentacle takes nothing returns nothing
    call KillUnit(GetEnumUnit())
endfunction

function Trig_Quest_Monstrum_Complete_CharmQuestDone takes nothing returns boolean
    return(IsQuestCompleted(udg_SideQuest[48]))
endfunction

function Trig_Quest_Monstrum_Complete_Actions takes nothing returns nothing
    local location l_tempPoint
    call DisableTrigger(GetTriggeringTrigger())
    call DisableTrigger(gg_trg_Monstrum_Phase_Check)
    call DestroyTrigger(gg_trg_Monstrum_Phase_Check)
    call DisableTrigger(gg_trg_Monstrum_Ambush_Rearm)
    call DestroyTrigger(gg_trg_Monstrum_Ambush_Rearm)
    if(Trig_Quest_Monstrum_Complete_HuntLogEnabled())then
        set udg_BossUnit=GetTriggerUnit()
        call ConditionalTriggerExecute(gg_trg_Speedrun_Accolade)
    endif
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_BossUnits)
    set l_tempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateItemLoc('I0BF',l_tempPoint) // 'I0BF': item "Slither Shield"
    call RemoveLocation(l_tempPoint)
    call ForGroupBJ(udg_TentacleGroup,function Trig_Quest_Monstrum_Complete_KillRemainingTentacle)
    call GroupClear(udg_TentacleGroup)
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_COMPLETED,"Quest Completed: |cffffcc00Monstrum of the Sea|r")
    call QuestSetCompletedBJ(udg_SideQuest[71],true)
    set udg_QuestsCompleted=(udg_QuestsCompleted+1)
    call DisplayTimedTextToForce(GetPlayersAll(),10.," ")
    call DisplayTimedTextToForce(GetPlayersAll(),10.,"As the Monstrum sinks below the sea lifelessly, it drags the |cffffcc00Grattheos Charm|r down with it.")
    call RemoveItem(udg_QuestItem[27])
    call Reward_Give(0,8000,udg_NarratorUnit)
    if(Trig_Quest_Monstrum_Complete_CharmQuestDone())then
        set udg_ArenaBonusBattle[0]=(udg_ArenaBonusBattle[0]+1)
        set udg_ArenaBonusBattle[udg_ArenaBonusBattle[0]]=$BA // $BA = 186
    endif
    call DestroyTrigger(GetTriggeringTrigger())
    set l_tempPoint=null
endfunction

function InitTrig_Quest_Monstrum takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Quest_Part20 (module Quest),
// which keeps the original registration order.

function Register_Quest_Monstrum_Complete takes nothing returns nothing
    set gg_trg_Quest_Monstrum_Complete=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_Monstrum_Complete)
    call TriggerAddAction(gg_trg_Quest_Monstrum_Complete,function Trig_Quest_Monstrum_Complete_Actions)
endfunction

endlibrary
