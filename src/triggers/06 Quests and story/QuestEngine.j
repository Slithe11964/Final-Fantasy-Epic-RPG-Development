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
//     Quest_Hunt     the party kills N units of the types added with Quest_HuntTarget (hunt leaderboard)
//     Quest_Deliver  a hero walks up to the NPC carrying an item; hands over charges until N are delivered
//     Quest_Reach    a hero walks into a region
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
    constant integer QUEST_STEP_HUNT=6
    constant integer QUEST_STEP_REACH=7
    constant integer QUEST_MAX_STEPS=16           // steps per quest; step ids are quest*QUEST_MAX_STEPS+step
    constant integer QUEST_STATE_HIDDEN=0
    constant integer QUEST_STATE_AVAILABLE=1
    constant integer QUEST_STATE_ACTIVE=2
    constant integer QUEST_STATE_DONE=3
    constant integer QUEST_STATE_FAILED=4
    constant real QUEST_RETURN_RANGE=450.
    constant real QUEST_PING_PERIOD=15.
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
    string array QuestColor                      // colour code before the name in the quest log; "" = default
    boolean array QuestNoMarker                  // no "!" / "?" over NPCs
    effect array QuestAvailableMarker
    effect array QuestActiveMarker
    unit array QuestActiveMarkerUnit
    // steps
    integer array QuestStepType
    unit array QuestStepUnit
    string array QuestStepLog
    string array QuestStepMessage                // announcement when the step is done; "" = the step text
    string array QuestStepHook
    integer array QuestStepItem
    integer array QuestStepNeeded
    integer array QuestStepDelivered
    string array QuestStepLabel
    integer array QuestStepBoard                 // hunt leaderboard row (udg_HuntCounter index)
    rect array QuestStepRect                     // reach step: the region to walk into
    questitem array QuestStepRequirement
    integer array QuestStepFirstLine
    integer array QuestStepLines
    integer array QuestStepRewardAt              // reward after this many lines; -1 = no reward
    integer array QuestStepGold
    integer array QuestStepXP
    camerasetup array QuestStepCamera            // shown during the dialogue instead of panning to the NPC
    boolean array QuestStepPingUnit              // NPC pinged on the minimap (udg_BossUnits) while waiting
    boolean array QuestStepPingItem              // delivered item (or the NPC once it is carried) pinged
    string array QuestStepPickupNote
    string array QuestStepPickupHook
    trigger array QuestStepTrigger
    trigger array QuestStepPickupTrigger
    // dialogue lines (all quests share one list)
    integer QuestLineCount=0
    unit array QuestLineSpeaker
    string array QuestLineText
    string array QuestLineName                   // shown instead of the speaker's name; "" = speaker's name
    sound array QuestLineSound
    integer array QuestLineIfSideQuest           // > 0: only said if udg_SideQuest[n] is completed
    // which step a step trigger belongs to; hunt target types per step
    // created by the first Quest_Define, not here: see docs/BUGS.md #7
    hashtable QuestTriggerStep=null
    hashtable QuestHuntTargets=null
    // set while a step's custom code runs (Quest_OnDone functions read these)
    integer QuestDoneQuest=0
    player QuestDonePlayer=null
    unit QuestDoneUnit=null
    integer QuestPendingQuest=0
    camerasetup QuestDialogueCamera=null
    timer QuestPingTimer=null
    integer QuestPingType=0
    item QuestPingFound=null
endglobals

// ---- defining quests ----

function Quest_Define takes string l_name,integer l_logKind,integer l_logIndex,string l_icon returns integer
    if QuestTriggerStep==null then
        set QuestTriggerStep=InitHashtable()
        set QuestHuntTargets=InitHashtable()
    endif
    set QuestCount=QuestCount+1
    set QuestName[QuestCount]=l_name
    set QuestLogKind[QuestCount]=l_logKind
    set QuestLogIndex[QuestCount]=l_logIndex
    set QuestIcon[QuestCount]=l_icon
    set QuestSteps[QuestCount]=0
    set QuestCurrent[QuestCount]=0
    set QuestState[QuestCount]=QUEST_STATE_HIDDEN
    set QuestCountsStory[QuestCount]=true
    set QuestColor[QuestCount]=""
    set QuestNoMarker[QuestCount]=false
    return QuestCount
endfunction

function Quest_AddStep takes integer q,integer l_type,unit u,string l_log returns integer
    local integer s
    set QuestSteps[q]=QuestSteps[q]+1
    set s=q*QUEST_MAX_STEPS+QuestSteps[q]
    set QuestStepType[s]=l_type
    set QuestStepUnit[s]=u
    set QuestStepLog[s]=l_log
    set QuestStepMessage[s]=""
    set QuestStepHook[s]=""
    set QuestStepLabel[s]=""
    set QuestStepPickupNote[s]=""
    set QuestStepPickupHook[s]=""
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

// Hunt: the party must kill l_needed units (types added with Quest_HuntTarget). The count is shown on the
// hunt leaderboard in row l_board (udg_HuntCounter[l_board], the row of Player(l_board-1)).
function Quest_Hunt takes integer q,integer l_board,integer l_needed,string l_label,string l_log returns nothing
    local integer s=Quest_AddStep(q,QUEST_STEP_HUNT,null,l_log)
    set QuestStepBoard[s]=l_board
    set QuestStepNeeded[s]=l_needed
    set QuestStepLabel[s]=l_label
endfunction

// A unit type that counts for the hunt step just added.
function Quest_HuntTarget takes integer q,integer l_unitType returns nothing
    call SaveBoolean(QuestHuntTargets,q*QUEST_MAX_STEPS+QuestSteps[q],l_unitType,true)
endfunction

// Deliver: l_label "" = a single hand-in with no "label: x/n" counter.
function Quest_Deliver takes integer q,unit l_npc,integer l_itemType,integer l_needed,string l_label,string l_log returns nothing
    local integer s=Quest_AddStep(q,QUEST_STEP_DELIVER,l_npc,l_log)
    set QuestStepItem[s]=l_itemType
    set QuestStepNeeded[s]=l_needed
    set QuestStepDelivered[s]=0
    set QuestStepLabel[s]=l_label
endfunction

// Reach: a hero (not the Spirit of Gaya) walks into the region.
function Quest_Reach takes integer q,rect l_region,string l_log returns nothing
    local integer s=Quest_AddStep(q,QUEST_STEP_REACH,null,l_log)
    set QuestStepRect[s]=l_region
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
    set QuestLineName[QuestLineCount]=""
    set QuestLineSound[QuestLineCount]=null
    set QuestLineIfSideQuest[QuestLineCount]=0
    set QuestStepLines[s]=QuestStepLines[s]+1
endfunction

// A line with the speaker shown under another name, and an optional sound (null = none).
function Quest_SayAs takes integer q,unit l_speaker,string l_name,sound l_sound,string l_text returns nothing
    call Quest_Say(q,l_speaker,l_text)
    set QuestLineName[QuestLineCount]=l_name
    set QuestLineSound[QuestLineCount]=l_sound
endfunction

// A line that is only said if side quest n (udg_SideQuest[n]) is completed.
function Quest_SayIfSideQuestDone takes integer q,integer n,unit l_speaker,string l_text returns nothing
    call Quest_Say(q,l_speaker,l_text)
    set QuestLineIfSideQuest[QuestLineCount]=n
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

// The announcement when the step just defined is done, if it should differ from the step's log text.
function Quest_Message takes integer q,string l_text returns nothing
    set QuestStepMessage[q*QUEST_MAX_STEPS+QuestSteps[q]]=l_text
endfunction

// The step's dialogue uses this camera (for all playing players) instead of panning to the NPC.
function Quest_Camera takes integer q,camerasetup l_camera returns nothing
    set QuestStepCamera[q*QUEST_MAX_STEPS+QuestSteps[q]]=l_camera
endfunction

// While the party works on the step just defined, its NPC is pinged on the minimap (as a boss).
function Quest_PingUnit takes integer q returns nothing
    set QuestStepPingUnit[q*QUEST_MAX_STEPS+QuestSteps[q]]=true
endfunction

// Deliver step: every 15 s, ping the item while it lies on the ground, else the NPC.
function Quest_PingItem takes integer q returns nothing
    set QuestStepPingItem[q*QUEST_MAX_STEPS+QuestSteps[q]]=true
endfunction

// Deliver step: the first time any unit picks up the item, tell its player l_note (also the new log text)
// and run l_function ("" = none).
function Quest_OnPickup takes integer q,string l_note,string l_function returns nothing
    local integer s=q*QUEST_MAX_STEPS+QuestSteps[q]
    set QuestStepPickupNote[s]=l_note
    set QuestStepPickupHook[s]=l_function
endfunction

// The colour code put before the quest's name in the quest log (default: cyan for side quests, gold for
// main quests). Some quests use udg_QuestTitleColor ("|cffff8040") or udg_QuestTitleRed.
function Quest_Color takes integer q,string l_color returns nothing
    set QuestColor[q]=l_color
endfunction

// No "!" / "?" markers for this quest (its module shows its own, or none).
function Quest_NoMarker takes integer q returns nothing
    set QuestNoMarker[q]=true
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

function Quest_IsFailed takes integer q returns boolean
    return QuestState[q]==QUEST_STATE_FAILED
endfunction

// The step the quest is waiting for (1 = first); 0 before it is available.
function Quest_CurrentStep takes integer q returns integer
    return QuestCurrent[q]
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

function QuestEngine_IsHero takes unit u returns boolean
    return IsUnitType(u,UNIT_TYPE_HERO) and IsPlayerInForce(GetOwningPlayer(u),udg_PlayingPlayers) and udg_InCinematicMode==false
endfunction

function QuestEngine_IsQuestHero takes unit u returns boolean
    return QuestEngine_IsHero(u) and GetUnitTypeId(u)!='H01D' // 'H01D': unit "Spirit of Gaya"
endfunction

function QuestEngine_StepCondition takes nothing returns boolean
    local integer s=QuestEngine_StepOf(GetTriggeringTrigger())
    local integer l_type=QuestStepType[s]
    if l_type==QUEST_STEP_TALK then
        return Unit_PlayersNearby(udg_TalkRange,QuestStepUnit[s],true,true,true)
    elseif l_type==QUEST_STEP_RETURN then
        return IsUnitHidden(QuestStepUnit[s])==false and QuestEngine_IsQuestHero(GetTriggerUnit())
    elseif l_type==QUEST_STEP_DELIVER then
        // the Spirit of Gaya may hand in items too
        return IsUnitHidden(QuestStepUnit[s])==false and QuestEngine_IsHero(GetTriggerUnit()) and UnitHasItemOfTypeBJ(GetTriggerUnit(),QuestStepItem[s])
    elseif l_type==QUEST_STEP_REACH then
        return QuestEngine_IsQuestHero(GetTriggerUnit())
    elseif l_type==QUEST_STEP_HUNT then
        return IsPlayerInForce(GetOwningPlayer(GetKillingUnit()),udg_ActivePlayers) and HaveSavedBoolean(QuestHuntTargets,s,GetUnitTypeId(GetTriggerUnit()))
    endif
    return true
endfunction

function QuestEngine_ApplyCamera takes nothing returns nothing
    call CameraSetupApplyForPlayer(true,QuestDialogueCamera,GetEnumPlayer(),1.)
endfunction

function QuestEngine_Dialogue takes integer s,player p returns nothing
    local integer i=0
    local integer k
    local unit l_speaker
    if udg_CinematicsDisabled or QuestStepLines[s]==0 then
        if QuestStepRewardAt[s]>=0 then
            call Reward_Give(QuestStepGold[s],QuestStepXP[s],QuestStepUnit[s])
        endif
        return
    endif
    call Cine_Enter()
    if QuestStepCamera[s]!=null then
        set QuestDialogueCamera=QuestStepCamera[s]
        call ForForce(udg_PlayingPlayers,function QuestEngine_ApplyCamera)
    elseif QuestStepUnit[s]!=null then
        call Cam_PanToUnit(QuestStepUnit[s],0)
    endif
    loop
        if i==QuestStepRewardAt[s] then
            call Reward_Give(QuestStepGold[s],QuestStepXP[s],QuestStepUnit[s])
        endif
        exitwhen i>=QuestStepLines[s]
        set k=QuestStepFirstLine[s]+i
        set l_speaker=QuestLineSpeaker[k]
        if l_speaker==null then
            set l_speaker=Player_GetHero(p)
        endif
        if QuestLineIfSideQuest[k]>0 and not IsQuestCompleted(udg_SideQuest[QuestLineIfSideQuest[k]]) then
            // condition not met: line skipped
        elseif QuestLineName[k]!="" then
            call Text_Transmission(l_speaker,QuestLineName[k],QuestLineText[k],"(null)",QuestLineSound[k],0,false)
        else
            call Text_Say(l_speaker,QuestLineText[k],false)
        endif
        set i=i+1
    endloop
    call Cine_ExitAction()
    set l_speaker=null
endfunction

// Put the "?" over unit u (nothing if it is already there).
function QuestEngine_MoveMarker takes integer q,unit u returns nothing
    if u==null or u==QuestActiveMarkerUnit[q] or QuestNoMarker[q] then
        return
    endif
    if QuestActiveMarker[q]!=null then
        call DestroyEffect(QuestActiveMarker[q])
    endif
    set QuestActiveMarker[q]=AddSpecialEffectTarget("Objects\\RandomObject\\RandomObject.mdl",u,"overhead")
    set QuestActiveMarkerUnit[q]=u
endfunction

// Finish step s of quest q, done by player p (unit u).
function QuestEngine_Finish takes integer q,integer s,player p,unit u returns nothing
    local integer l_step=s-q*QUEST_MAX_STEPS
    local integer k
    local integer l_nextType
    local quest l_quest
    local trigger t=QuestStepTrigger[s]
    // stop listening right away, but destroy the trigger only at the end: the dialogue below waits, and
    // this code may be running inside that very trigger
    if t!=null then
        call DisableTrigger(t)
        set QuestStepTrigger[s]=null
    endif
    if QuestStepPickupTrigger[s]!=null then
        call FlushChildHashtable(QuestTriggerStep,GetHandleId(QuestStepPickupTrigger[s]))
        call DestroyTrigger(QuestStepPickupTrigger[s])
        set QuestStepPickupTrigger[s]=null
    endif
    if QuestStepPingUnit[s] then
        call GroupRemoveUnit(udg_BossUnits,QuestStepUnit[s])
    endif
    if l_step==1 and QuestAvailableMarker[q]!=null then
        call DestroyEffect(QuestAvailableMarker[q])
        set QuestAvailableMarker[q]=null
    endif
    call QuestEngine_Dialogue(s,p)
    if l_step==1 then
        set QuestState[q]=QUEST_STATE_ACTIVE
        call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_DISCOVERED,"New Quest Received: |cffffcc00"+QuestName[q]+"|r")
        if QuestColor[q]=="" and QuestLogKind[q]==QUEST_MAIN then
            set QuestColor[q]=udg_ColorGold
        elseif QuestColor[q]=="" then
            set QuestColor[q]="|cff00ffff"
        endif
        if QuestLogKind[q]==QUEST_MAIN then
            set udg_MainQuest[QuestLogIndex[q]]=CreateQuestBJ(bj_QUESTTYPE_REQ_DISCOVERED,QuestColor[q]+QuestName[q],QuestStepLog[s],QuestIcon[q])
        else
            set udg_SideQuest[QuestLogIndex[q]]=CreateQuestBJ(bj_QUESTTYPE_REQ_DISCOVERED,QuestColor[q]+QuestName[q],QuestStepLog[s],QuestIcon[q])
        endif
    elseif l_step<QuestSteps[q] then
        if QuestStepMessage[s]!="" then
            call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_UPDATED,QuestStepMessage[s])
        elseif QuestStepLog[s]!="" then
            call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_UPDATED,QuestStepLog[s])
        endif
        if QuestStepLog[s]!="" then
            call QuestSetDescriptionBJ(Quest_LogEntry(q),QuestStepLog[s])
        endif
    endif
    if l_step<QuestSteps[q] then
        // the "?" goes over the NPC of the next step (or stays where it is, e.g. during a kill step)
        set l_nextType=QuestStepType[s+1]
        if l_nextType==QUEST_STEP_TALK or l_nextType==QUEST_STEP_RETURN or l_nextType==QUEST_STEP_DELIVER then
            call QuestEngine_MoveMarker(q,QuestStepUnit[s+1])
        elseif QuestActiveMarkerUnit[q]==null then
            call QuestEngine_MoveMarker(q,QuestStepUnit[s])
        endif
    else
        set QuestState[q]=QUEST_STATE_DONE
        if QuestActiveMarker[q]!=null then
            call DestroyEffect(QuestActiveMarker[q])
            set QuestActiveMarker[q]=null
            set QuestActiveMarkerUnit[q]=null
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
    local integer b
    local unit u=GetTriggerUnit()
    local player p
    local item l_item
    local integer l_given
    if QuestStepType[s]==QUEST_STEP_TALK then
        set p=GetTriggerPlayer()
        set u=Player_GetHero(p)
    elseif QuestStepType[s]==QUEST_STEP_KILL or QuestStepType[s]==QUEST_STEP_HUNT then
        set u=GetKillingUnitBJ()
        set p=GetOwningPlayer(u)
    else
        set p=GetOwningPlayer(u)
    endif
    if QuestStepType[s]==QUEST_STEP_HUNT then
        set b=QuestStepBoard[s]
        set udg_HuntCounter[b]=udg_HuntCounter[b]-1
        call LeaderboardSetPlayerItemValueBJ(Player(b-1),udg_HuntLeaderboard,udg_HuntCounter[b])
        call LeaderboardSortItemsBJ(udg_HuntLeaderboard,bj_SORTTYPE_SORTBYVALUE,false)
        if udg_HuntCounter[b]>0 then
            set u=null
            set p=null
            return
        endif
        call LeaderboardRemovePlayerItemBJ(Player(b-1),udg_HuntLeaderboard)
        set udg_HuntCounter[0]=udg_HuntCounter[0]-1
        if udg_HuntCounter[0]<=0 then
            call LeaderboardDisplayBJ(false,udg_HuntLeaderboard)
        endif
    elseif QuestStepType[s]==QUEST_STEP_DELIVER then
        set l_item=GetItemOfTypeFromUnitBJ(u,QuestStepItem[s])
        set l_given=IMinBJ(QuestStepNeeded[s]-QuestStepDelivered[s],IMaxBJ(GetItemCharges(l_item),1))
        if GetItemCharges(l_item)>l_given then
            call SetItemCharges(l_item,GetItemCharges(l_item)-l_given)
        else
            call RemoveItem(l_item)
        endif
        set QuestStepDelivered[s]=QuestStepDelivered[s]+l_given
        if QuestStepLabel[s]!="" then
            call DisplayTextToForce(GetPlayersAll(),QuestStepLabel[s]+": "+I2S(QuestStepDelivered[s])+"/"+I2S(QuestStepNeeded[s]))
            call QuestItemSetDescriptionBJ(QuestStepRequirement[s],QuestStepLabel[s]+": "+I2S(QuestStepDelivered[s])+"/"+I2S(QuestStepNeeded[s]))
        endif
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

// A unit picked up the item of a deliver step that has a pickup note.
function QuestEngine_PickupCondition takes nothing returns boolean
    return GetItemTypeId(GetManipulatedItem())==QuestStepItem[QuestEngine_StepOf(GetTriggeringTrigger())]
endfunction

function QuestEngine_PickupAction takes nothing returns nothing
    local trigger t=GetTriggeringTrigger()
    local integer s=QuestEngine_StepOf(t)
    local integer q=s/QUEST_MAX_STEPS
    local player p=GetOwningPlayer(GetManipulatingUnit())
    set QuestStepPickupTrigger[s]=null
    call QuestMessageBJ(bj_FORCE_PLAYER[GetPlayerId(p)],bj_QUESTMESSAGE_UPDATED,QuestStepPickupNote[s])
    call QuestSetDescriptionBJ(Quest_LogEntry(q),QuestStepPickupNote[s])
    if QuestStepPickupHook[s]!="" then
        set QuestDoneQuest=q
        set QuestDonePlayer=p
        set QuestDoneUnit=GetManipulatingUnit()
        call ExecuteFunc(QuestStepPickupHook[s])
    endif
    call FlushChildHashtable(QuestTriggerStep,GetHandleId(t))
    call DestroyTrigger(t)
    set t=null
    set p=null
endfunction

function QuestEngine_FindGroundItem takes nothing returns nothing
    if QuestPingFound==null and GetItemTypeId(GetEnumItem())==QuestPingType and not IsItemOwned(GetEnumItem()) and GetWidgetLife(GetEnumItem())>0 then
        set QuestPingFound=GetEnumItem()
    endif
endfunction

// Every 15 s: for each waiting deliver step with Quest_PingItem, ping its item if it lies on the ground,
// else its NPC.
function QuestEngine_PingTick takes nothing returns nothing
    local integer q=1
    local integer s
    loop
        exitwhen q>QuestCount
        set s=q*QUEST_MAX_STEPS+QuestCurrent[q]
        if QuestState[q]==QUEST_STATE_ACTIVE and QuestStepPingItem[s] and QuestStepTrigger[s]!=null then
            set QuestPingType=QuestStepItem[s]
            set QuestPingFound=null
            call EnumItemsInRect(bj_mapInitialPlayableArea,null,function QuestEngine_FindGroundItem)
            if QuestPingFound!=null then
                call PingMinimap(GetItemX(QuestPingFound),GetItemY(QuestPingFound),2.)
            else
                call PingMinimap(GetUnitX(QuestStepUnit[s]),GetUnitY(QuestStepUnit[s]),2.)
            endif
        endif
        set q=q+1
    endloop
    set QuestPingFound=null
endfunction

function QuestEngine_BeginStep takes integer q returns nothing
    local integer s
    local integer l_type
    local integer b
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
    elseif l_type==QUEST_STEP_REACH then
        call TriggerRegisterEnterRectSimple(t,QuestStepRect[s])
    elseif l_type==QUEST_STEP_HUNT then
        call TriggerRegisterAnyUnitEventBJ(t,EVENT_PLAYER_UNIT_DEATH)
        set b=QuestStepBoard[s]
        set udg_HuntCounter[0]=udg_HuntCounter[0]+1
        if udg_HuntCounter[0]==1 then
            call LeaderboardDisplayBJ(true,udg_HuntLeaderboard)
        endif
        set udg_HuntCounter[b]=QuestStepNeeded[s]
        set udg_HuntBoardLabel[b]=QuestStepLabel[s]
        call LeaderboardAddItemBJ(Player(b-1),udg_HuntLeaderboard,udg_HuntBoardLabel[b],udg_HuntCounter[b])
        call LeaderboardSetPlayerItemLabelColorBJ(Player(b-1),udg_HuntLeaderboard,65.,75.,40.,0)
        call LeaderboardSetPlayerItemValueColorBJ(Player(b-1),udg_HuntLeaderboard,80.,20.,20,0)
        call LeaderboardSortItemsBJ(udg_HuntLeaderboard,bj_SORTTYPE_SORTBYVALUE,false)
    else
        call TriggerRegisterUnitInRangeSimple(t,QUEST_RETURN_RANGE,QuestStepUnit[s])
    endif
    if l_type==QUEST_STEP_DELIVER then
        if QuestStepLabel[s]!="" then
            set QuestStepRequirement[s]=CreateQuestItemBJ(Quest_LogEntry(q),QuestStepLabel[s]+": 0/"+I2S(QuestStepNeeded[s]))
        endif
        if QuestStepPickupNote[s]!="" then
            set QuestStepPickupTrigger[s]=CreateTrigger()
            call SaveInteger(QuestTriggerStep,GetHandleId(QuestStepPickupTrigger[s]),0,s)
            call TriggerRegisterAnyUnitEventBJ(QuestStepPickupTrigger[s],EVENT_PLAYER_UNIT_PICKUP_ITEM)
            call TriggerAddCondition(QuestStepPickupTrigger[s],Condition(function QuestEngine_PickupCondition))
            call TriggerAddAction(QuestStepPickupTrigger[s],function QuestEngine_PickupAction)
        endif
        if QuestStepPingItem[s] and QuestPingTimer==null then
            set QuestPingTimer=CreateTimer()
            call TimerStart(QuestPingTimer,QUEST_PING_PERIOD,true,function QuestEngine_PingTick)
        endif
    endif
    if QuestStepPingUnit[s] then
        call GroupAddUnit(udg_BossUnits,QuestStepUnit[s])
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
    if QuestStepUnit[s]!=null and not QuestNoMarker[q] then
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

// Start the quest now, without a "!": for quests that begin with an event rather than a talk. If the
// first step is a custom step it is done at once (the quest-log entry appears, its hook runs).
function Quest_Start takes integer q,player p,unit u returns nothing
    if q<=0 or QuestState[q]!=QUEST_STATE_HIDDEN then
        return
    endif
    set QuestState[q]=QUEST_STATE_AVAILABLE
    call QuestEngine_BeginStep(q)
    if QuestStepType[q*QUEST_MAX_STEPS+1]==QUEST_STEP_CUSTOM then
        call QuestEngine_Finish(q,q*QUEST_MAX_STEPS+1,p,u)
    endif
endfunction

// Change the quest-log text now; l_announce also shows it as a quest update to all players.
function Quest_SetLog takes integer q,string l_text,boolean l_announce returns nothing
    if QuestState[q]!=QUEST_STATE_ACTIVE then
        return
    endif
    if l_announce then
        call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_UPDATED,l_text)
    endif
    call QuestSetDescriptionBJ(Quest_LogEntry(q),l_text)
endfunction

// Fail the quest: it stops waiting, its markers go, and the log shows it as failed.
function Quest_Fail takes integer q returns nothing
    local integer s=q*QUEST_MAX_STEPS+QuestCurrent[q]
    if QuestState[q]!=QUEST_STATE_ACTIVE then
        return
    endif
    set QuestState[q]=QUEST_STATE_FAILED
    if QuestStepTrigger[s]!=null then
        call FlushChildHashtable(QuestTriggerStep,GetHandleId(QuestStepTrigger[s]))
        call DestroyTrigger(QuestStepTrigger[s])
        set QuestStepTrigger[s]=null
    endif
    if QuestStepPickupTrigger[s]!=null then
        call FlushChildHashtable(QuestTriggerStep,GetHandleId(QuestStepPickupTrigger[s]))
        call DestroyTrigger(QuestStepPickupTrigger[s])
        set QuestStepPickupTrigger[s]=null
    endif
    if QuestStepPingUnit[s] then
        call GroupRemoveUnit(udg_BossUnits,QuestStepUnit[s])
    endif
    if QuestActiveMarker[q]!=null then
        call DestroyEffect(QuestActiveMarker[q])
        set QuestActiveMarker[q]=null
        set QuestActiveMarkerUnit[q]=null
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_FAILED,"Quest Failed: |cffffcc00"+QuestName[q]+"|r")
    call QuestSetFailedBJ(Quest_LogEntry(q),true)
endfunction

// World Editor calls InitTrig_QuestEngine automatically; the engine has no triggers of its own: each step
// creates (and destroys) the trigger it waits on.
function InitTrig_QuestEngine takes nothing returns nothing
endfunction

endlibrary
