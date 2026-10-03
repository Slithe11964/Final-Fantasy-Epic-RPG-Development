library TQuestEngine requires TCam, TCine, TPlayerHero, TReward, TText, TUnit, optional TQuestCount
// Quest engine: a quest is a list of steps written as data (see docs/QUEST_ENGINE.md).
//
// Defining a quest (usually inside the quest's own module, the first time it becomes available):
//     set q=Quest_Define("Kill Elmdor",QUEST_SIDE,6,"ReplaceableTextures\\CommandButtons\\BTNChaosBlademaster.blp")
//     call Quest_Talk(q,gg_unit_h007_0089,"Biggs, captain in Kalm, promised reward for killing Elmdor.")
//     call Quest_Say(q,gg_unit_h007_0089,"Greetings. My name is Biggs and I am the captain here.")
//     call Quest_Say(q,null,"His life is forfeit.")           // null speaker = the hero of the player who did the step
//     call Quest_Kill(q,gg_unit_Nbbc_0006,"Come back to Biggs for reward.")
//     call Quest_Return(q,gg_unit_h007_0089,"")
//     call Quest_Reward(q,1500,1500)                          // given at this point of the step's dialogue
//     call Quest_OnDone(q,"QuestKillElmdor_Done")             // custom code run when the step is done
// Then `call Quest_MakeAvailable(q)` shows the "!" over the first NPC and waits for the first step.
//
// Step types:
//     Quest_Talk     select the NPC while a hero stands near it (udg_TalkRange)
//     Quest_Return   a hero walks up to the NPC (450 range)
//     Quest_Kill     a unit dies
//     Quest_Deliver  a hero walks up to the NPC carrying an item; hands over charges until N are delivered
//     Quest_Custom   the quest's own code calls Quest_StepDone(q) when the step is done
// Each step's text is the quest-log description after that step (the first step's text is the quest's
// first description). When the last step is done the quest is completed, rewarded and counted.
// The quest-log entry is still udg_SideQuest[n] / udg_MainQuest[n], so other code that checks
// IsQuestCompleted(udg_SideQuest[n]) keeps working.

globals
    constant integer QUEST_SIDE=0
    constant integer QUEST_MAIN=1
    constant integer QUEST_STEP_TALK=1
    constant integer QUEST_STEP_RETURN=2
    constant integer QUEST_STEP_KILL=3
    constant integer QUEST_STEP_DELIVER=4
    constant integer QUEST_STEP_CUSTOM=5
    constant integer QUEST_MAX_STEPS=16           // steps per quest; step ids are quest*QUEST_MAX_STEPS+step
    constant integer QUEST_STATE_HIDDEN=0
    constant integer QUEST_STATE_AVAILABLE=1
    constant integer QUEST_STATE_ACTIVE=2
    constant integer QUEST_STATE_DONE=3
    constant real QUEST_RETURN_RANGE=450.
    // quests
    integer QuestCount=0
    string array QuestName
    string array QuestIcon
    integer array QuestLogKind
    integer array QuestLogIndex
    integer array QuestSteps
    integer array QuestCurrent
    integer array QuestState
    boolean array QuestCountsStory
    effect array QuestAvailableMarker
    effect array QuestActiveMarker
    // steps
    integer array QuestStepType
    unit array QuestStepUnit
    string array QuestStepLog
    string array QuestStepHook
    integer array QuestStepItem
    integer array QuestStepNeeded
    integer array QuestStepDelivered
    string array QuestStepLabel
    questitem array QuestStepRequirement
    integer array QuestStepFirstLine
    integer array QuestStepLines
    integer array QuestStepRewardAt              // reward after this many lines; -1 = no reward
    integer array QuestStepGold
    integer array QuestStepXP
    trigger array QuestStepTrigger
    // dialogue lines (all quests share one list)
    integer QuestLineCount=0
    unit array QuestLineSpeaker
    string array QuestLineText
    // which step a step trigger belongs to
    hashtable QuestTriggerStep=InitHashtable()
    // set while a step's custom code runs (Quest_OnDone functions read these)
    integer QuestDoneQuest=0
    player QuestDonePlayer=null
    unit QuestDoneUnit=null
    integer QuestPendingQuest=0
endglobals

// ---- defining quests ----

function Quest_Define takes string l_name,integer l_logKind,integer l_logIndex,string l_icon returns integer
    set QuestCount=QuestCount+1
    set QuestName[QuestCount]=l_name
    set QuestLogKind[QuestCount]=l_logKind
    set QuestLogIndex[QuestCount]=l_logIndex
    set QuestIcon[QuestCount]=l_icon
    set QuestSteps[QuestCount]=0
    set QuestCurrent[QuestCount]=0
    set QuestState[QuestCount]=QUEST_STATE_HIDDEN
    set QuestCountsStory[QuestCount]=true
    return QuestCount
endfunction

function Quest_AddStep takes integer q,integer l_type,unit u,string l_log returns integer
    local integer s
    set QuestSteps[q]=QuestSteps[q]+1
    set s=q*QUEST_MAX_STEPS+QuestSteps[q]
    set QuestStepType[s]=l_type
    set QuestStepUnit[s]=u
    set QuestStepLog[s]=l_log
    set QuestStepHook[s]=""
    set QuestStepFirstLine[s]=QuestLineCount+1
    set QuestStepLines[s]=0
    set QuestStepRewardAt[s]=-1
    return s
endfunction

function Quest_Talk takes integer q,unit l_npc,string l_log returns nothing
    call Quest_AddStep(q,QUEST_STEP_TALK,l_npc,l_log)
endfunction

function Quest_Return takes integer q,unit l_npc,string l_log returns nothing
    call Quest_AddStep(q,QUEST_STEP_RETURN,l_npc,l_log)
endfunction

function Quest_Kill takes integer q,unit l_target,string l_log returns nothing
    call Quest_AddStep(q,QUEST_STEP_KILL,l_target,l_log)
endfunction

function Quest_Deliver takes integer q,unit l_npc,integer l_itemType,integer l_needed,string l_label,string l_log returns nothing
    local integer s=Quest_AddStep(q,QUEST_STEP_DELIVER,l_npc,l_log)
    set QuestStepItem[s]=l_itemType
    set QuestStepNeeded[s]=l_needed
    set QuestStepDelivered[s]=0
    set QuestStepLabel[s]=l_label
endfunction

function Quest_Custom takes integer q,string l_log returns nothing
    call Quest_AddStep(q,QUEST_STEP_CUSTOM,null,l_log)
endfunction

// A dialogue line said when the step is done (only shown when cinematics are on). Speaker null = the hero.
function Quest_Say takes integer q,unit l_speaker,string l_text returns nothing
    local integer s=q*QUEST_MAX_STEPS+QuestSteps[q]
    set QuestLineCount=QuestLineCount+1
    set QuestLineSpeaker[QuestLineCount]=l_speaker
    set QuestLineText[QuestLineCount]=l_text
    set QuestStepLines[s]=QuestStepLines[s]+1
endfunction

// Gold and experience for the step just defined, given after the dialogue lines defined so far.
function Quest_Reward takes integer q,integer l_gold,integer xp returns nothing
    local integer s=q*QUEST_MAX_STEPS+QuestSteps[q]
    set QuestStepGold[s]=l_gold
    set QuestStepXP[s]=xp
    set QuestStepRewardAt[s]=QuestStepLines[s]
endfunction

// Name of a function (no arguments) to run when the step just defined is done.
function Quest_OnDone takes integer q,string l_function returns nothing
    set QuestStepHook[q*QUEST_MAX_STEPS+QuestSteps[q]]=l_function
endfunction

// Completing this quest does not add to udg_StoryProgress / the quest-count milestones.
function Quest_NotStory takes integer q returns nothing
    set QuestCountsStory[q]=false
endfunction

// ---- state ----

function Quest_IsActive takes integer q returns boolean
    return QuestState[q]==QUEST_STATE_ACTIVE
endfunction

function Quest_IsDone takes integer q returns boolean
    return QuestState[q]==QUEST_STATE_DONE
endfunction

function Quest_LogEntry takes integer q returns quest
    if QuestLogKind[q]==QUEST_MAIN then
        return udg_MainQuest[QuestLogIndex[q]]
    endif
    return udg_SideQuest[QuestLogIndex[q]]
endfunction

// ---- running steps ----

function QuestEngine_StepOf takes trigger t returns integer
    return LoadInteger(QuestTriggerStep,GetHandleId(t),0)
endfunction

function QuestEngine_IsQuestHero takes unit u returns boolean
    return IsUnitType(u,UNIT_TYPE_HERO) and IsPlayerInForce(GetOwningPlayer(u),udg_PlayingPlayers) and GetUnitTypeId(u)!='H01D' and udg_InCinematicMode==false // 'H01D': unit "Spirit of Gaya"
endfunction

function QuestEngine_StepCondition takes nothing returns boolean
    local integer s=QuestEngine_StepOf(GetTriggeringTrigger())
    local integer l_type=QuestStepType[s]
    if l_type==QUEST_STEP_TALK then
        return Unit_PlayersNearby(udg_TalkRange,QuestStepUnit[s],true,true,true)
    elseif l_type==QUEST_STEP_RETURN then
        return IsUnitHidden(QuestStepUnit[s])==false and QuestEngine_IsQuestHero(GetTriggerUnit())
    elseif l_type==QUEST_STEP_DELIVER then
        return IsUnitHidden(QuestStepUnit[s])==false and QuestEngine_IsQuestHero(GetTriggerUnit()) and UnitHasItemOfTypeBJ(GetTriggerUnit(),QuestStepItem[s])
    endif
    return true
endfunction

function QuestEngine_Dialogue takes integer s,player p returns nothing
    local integer i=0
    local unit l_speaker
    if udg_CinematicsDisabled or QuestStepLines[s]==0 then
        if QuestStepRewardAt[s]>=0 then
            call Reward_Give(QuestStepGold[s],QuestStepXP[s],QuestStepUnit[s])
        endif
        return
    endif
    call Cine_Enter()
    if QuestStepUnit[s]!=null then
        call Cam_PanToUnit(QuestStepUnit[s],0)
    endif
    loop
        if i==QuestStepRewardAt[s] then
            call Reward_Give(QuestStepGold[s],QuestStepXP[s],QuestStepUnit[s])
        endif
        exitwhen i>=QuestStepLines[s]
        set l_speaker=QuestLineSpeaker[QuestStepFirstLine[s]+i]
        if l_speaker==null then
            set l_speaker=Player_GetHero(p)
        endif
        call Text_Say(l_speaker,QuestLineText[QuestStepFirstLine[s]+i],false)
        set i=i+1
    endloop
    call Cine_ExitAction()
    set l_speaker=null
endfunction

// Finish step s of quest q, done by player p (unit u).
function QuestEngine_Finish takes integer q,integer s,player p,unit u returns nothing
    local integer l_step=s-q*QUEST_MAX_STEPS
    local integer k
    local quest l_quest
    local trigger t=QuestStepTrigger[s]
    // stop listening right away, but destroy the trigger only at the end: the dialogue below waits, and
    // this code may be running inside that very trigger
    if t!=null then
        call DisableTrigger(t)
        set QuestStepTrigger[s]=null
    endif
    if l_step==1 and QuestAvailableMarker[q]!=null then
        call DestroyEffect(QuestAvailableMarker[q])
        set QuestAvailableMarker[q]=null
    endif
    call QuestEngine_Dialogue(s,p)
    if l_step==1 then
        set QuestState[q]=QUEST_STATE_ACTIVE
        call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_DISCOVERED,"New Quest Received: |cffffcc00"+QuestName[q]+"|r")
        if QuestLogKind[q]==QUEST_MAIN then
            set udg_MainQuest[QuestLogIndex[q]]=CreateQuestBJ(bj_QUESTTYPE_REQ_DISCOVERED,udg_ColorGold+QuestName[q],QuestStepLog[s],QuestIcon[q])
        else
            set udg_SideQuest[QuestLogIndex[q]]=CreateQuestBJ(bj_QUESTTYPE_REQ_DISCOVERED,"|cff00ffff"+QuestName[q],QuestStepLog[s],QuestIcon[q])
        endif
        set QuestActiveMarker[q]=AddSpecialEffectTarget("Objects\\RandomObject\\RandomObject.mdl",QuestStepUnit[s],"overhead")
    elseif l_step<QuestSteps[q] and QuestStepLog[s]!="" then
        call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_UPDATED,QuestStepLog[s])
        call QuestSetDescriptionBJ(Quest_LogEntry(q),QuestStepLog[s])
    endif
    if l_step>=QuestSteps[q] then
        set QuestState[q]=QUEST_STATE_DONE
        if QuestActiveMarker[q]!=null then
            call DestroyEffect(QuestActiveMarker[q])
            set QuestActiveMarker[q]=null
        endif
        set k=q*QUEST_MAX_STEPS+1
        loop
            exitwhen k>s
            if QuestStepRequirement[k]!=null then
                call QuestItemSetCompletedBJ(QuestStepRequirement[k],true)
            endif
            set k=k+1
        endloop
        set l_quest=Quest_LogEntry(q)
        call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_COMPLETED,"Quest Completed: |cffffcc00"+QuestName[q]+"|r")
        call QuestSetCompletedBJ(l_quest,true)
        set udg_QuestsCompleted=udg_QuestsCompleted+1
    endif
    if QuestStepHook[s]!="" then
        set QuestDoneQuest=q
        set QuestDonePlayer=p
        set QuestDoneUnit=u
        call ExecuteFunc(QuestStepHook[s])
    endif
    if l_step>=QuestSteps[q] then
        if QuestCountsStory[q] then
            set udg_StoryProgress=udg_StoryProgress+1
            static if LIBRARY_TQuestCount then
                call ConditionalTriggerExecute(gg_trg_QuestCount_Milestones)
            endif
        endif
    else
        // JASS can't call a function defined further down, and BeginStep refers to StepAction (below),
        // so the next step is started through ExecuteFunc
        set QuestPendingQuest=q
        call ExecuteFunc("QuestEngine_BeginPending")
    endif
    if t!=null then
        call FlushChildHashtable(QuestTriggerStep,GetHandleId(t))
        call DestroyTrigger(t)
    endif
    set l_quest=null
    set t=null
endfunction

function QuestEngine_StepAction takes nothing returns nothing
    local integer s=QuestEngine_StepOf(GetTriggeringTrigger())
    local integer q=s/QUEST_MAX_STEPS
    local unit u=GetTriggerUnit()
    local player p
    local item l_item
    local integer l_given
    if QuestStepType[s]==QUEST_STEP_TALK then
        set p=GetTriggerPlayer()
        set u=Player_GetHero(p)
    elseif QuestStepType[s]==QUEST_STEP_KILL then
        set u=GetKillingUnitBJ()
        set p=GetOwningPlayer(u)
    else
        set p=GetOwningPlayer(u)
    endif
    if QuestStepType[s]==QUEST_STEP_DELIVER then
        set l_item=GetItemOfTypeFromUnitBJ(u,QuestStepItem[s])
        set l_given=IMinBJ(QuestStepNeeded[s]-QuestStepDelivered[s],IMaxBJ(GetItemCharges(l_item),1))
        if GetItemCharges(l_item)>l_given then
            call SetItemCharges(l_item,GetItemCharges(l_item)-l_given)
        else
            call RemoveItem(l_item)
        endif
        set QuestStepDelivered[s]=QuestStepDelivered[s]+l_given
        call DisplayTextToForce(GetPlayersAll(),QuestStepLabel[s]+": "+I2S(QuestStepDelivered[s])+"/"+I2S(QuestStepNeeded[s]))
        call QuestItemSetDescriptionBJ(QuestStepRequirement[s],QuestStepLabel[s]+": "+I2S(QuestStepDelivered[s])+"/"+I2S(QuestStepNeeded[s]))
        set l_item=null
        if QuestStepDelivered[s]<QuestStepNeeded[s] then
            set u=null
            set p=null
            return
        endif
    endif
    call QuestEngine_Finish(q,s,p,u)
    set u=null
    set p=null
endfunction

function QuestEngine_BeginStep takes integer q returns nothing
    local integer s
    local integer l_type
    local trigger t
    local integer i=0
    set QuestCurrent[q]=QuestCurrent[q]+1
    set s=q*QUEST_MAX_STEPS+QuestCurrent[q]
    set l_type=QuestStepType[s]
    if l_type==QUEST_STEP_CUSTOM then
        return
    endif
    set t=CreateTrigger()
    call SaveInteger(QuestTriggerStep,GetHandleId(t),0,s)
    if l_type==QUEST_STEP_TALK then
        loop
            exitwhen i>7
            call TriggerRegisterPlayerSelectionEventBJ(t,Player(i),true)
            set i=i+1
        endloop
    elseif l_type==QUEST_STEP_KILL then
        call TriggerRegisterUnitEvent(t,QuestStepUnit[s],EVENT_UNIT_DEATH)
    else
        call TriggerRegisterUnitInRangeSimple(t,QUEST_RETURN_RANGE,QuestStepUnit[s])
    endif
    if l_type==QUEST_STEP_DELIVER then
        set QuestStepRequirement[s]=CreateQuestItemBJ(Quest_LogEntry(q),QuestStepLabel[s]+": 0/"+I2S(QuestStepNeeded[s]))
    endif
    call TriggerAddCondition(t,Condition(function QuestEngine_StepCondition))
    call TriggerAddAction(t,function QuestEngine_StepAction)
    set QuestStepTrigger[s]=t
    set t=null
endfunction

function QuestEngine_BeginPending takes nothing returns nothing
    call QuestEngine_BeginStep(QuestPendingQuest)
endfunction

// ---- starting quests and custom steps ----

// Show the "!" over the first step's NPC and wait for the first step. Does nothing if already started.
function Quest_MakeAvailable takes integer q returns nothing
    local integer s=q*QUEST_MAX_STEPS+1
    if q<=0 or QuestState[q]!=QUEST_STATE_HIDDEN then
        return
    endif
    set QuestState[q]=QUEST_STATE_AVAILABLE
    if QuestStepUnit[s]!=null then
        set QuestAvailableMarker[q]=AddSpecialEffectTarget("Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl",QuestStepUnit[s],"overhead")
    endif
    call QuestEngine_BeginStep(q)
endfunction

// For a Quest_Custom step: the quest's own code calls this when the step is done.
function Quest_StepDone takes integer q,player p,unit u returns nothing
    local integer s=q*QUEST_MAX_STEPS+QuestCurrent[q]
    if QuestState[q]==QUEST_STATE_DONE or QuestCurrent[q]==0 or QuestStepType[s]!=QUEST_STEP_CUSTOM then
        return
    endif
    call QuestEngine_Finish(q,s,p,u)
endfunction

// World Editor calls InitTrig_QuestEngine automatically; the engine has no triggers of its own: each step
// creates (and destroys) the trigger it waits on.
function InitTrig_QuestEngine takes nothing returns nothing
endfunction

endlibrary
