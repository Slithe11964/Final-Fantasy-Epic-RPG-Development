library TQuestYoungEngineer requires TQuestEngine, TCam, TCine, TPlayerHero, TReward, TText, TWait
// Side quest "Young Engineer", written for the quest engine (QuestEngine module, docs/QUEST_ENGINE.md).
// Mid asks the party to test his prototype crossbow (module Quest_Crossbow) and get advice from the dwarves
// in the Barrens (module Quest_Engineer), then turns the prototype into the Auto-Crossbow. Made available by
// Mid, which calls QuestYoungEngineer_Available. Does not count toward the story.
// The report to Mid (two tasks, a lost prototype replaced, lines that count dots) stays a trigger of this
// module; it finishes the quest (custom step).
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Quest_YoungEngineer_Ping=null
    trigger gg_trg_Quest_YoungEngineer_Complete=null
    // The quest's number in the quest engine (0 until it is defined).
    integer QUEST_YOUNG_ENGINEER=0
endglobals

// 15 seconds after the talk: Mid starts listening for the party's report.
function QuestYoungEngineer_EnableReport takes nothing returns nothing
    call DestroyTimer(GetExpiredTimer())
    call EnableTrigger(gg_trg_Quest_YoungEngineer_Complete)
endfunction

// Step 1 done (the party talked to Mid): the talking hero gets the prototype crossbow, and Giott in the
// Barrens can give advice. Mid takes the results back after 15 seconds at the earliest.
function QuestYoungEngineer_Started takes nothing returns nothing
    set udg_QuestItem[28]=UnitAddItemByIdSwapped('I0BQ',QuestDoneUnit) // 'I0BQ': item "Prototype Crossbow"
    call SetItemInvulnerableBJ(GetLastCreatedItem(),true)
    set udg_QuestReq[9]=CreateQuestItemBJ(Quest_LogEntry(QUEST_YOUNG_ENGINEER),"Use the Prototype Crossbow 15 times.")
    set udg_QuestReq[$A]=CreateQuestItemBJ(Quest_LogEntry(QUEST_YOUNG_ENGINEER),"Ask the dwarves in the Barrens for advice.") // $A = 10
    set udg_SpecialEffect[87]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_h00R_0256,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call EnableTrigger(gg_trg_Quest_Crossbow_NeedEnemies)
    call EnableTrigger(gg_trg_Quest_Crossbow_Tested)
    call EnableTrigger(gg_trg_Quest_Engineer_GetAdvice)
    call EnableTrigger(gg_trg_Quest_YoungEngineer_Ping)
    call TriggerRegisterUnitInRangeSimple(gg_trg_Quest_YoungEngineer_Complete,450.,udg_Mid)
    call TimerStart(CreateTimer(),15.,false,function QuestYoungEngineer_EnableReport)
endfunction

function QuestYoungEngineer_Define takes nothing returns nothing
    local integer q=Quest_Define("Young Engineer",QUEST_SIDE,72,"ReplaceableTextures\\CommandButtons\\BTNCrossbow_03.blp")
    set QUEST_YOUNG_ENGINEER=q
    call Quest_NotStory(q)
    // 1. Talk to Mid
    call Quest_Talk(q,udg_Mid,"Mid has asked you to test his prototype crossbow and ask the dwarves in the Barrens for further potential advice. Help him complete his vision!")
    call Quest_Say(q,udg_Mid,"Hello again, adventurers. Looks like you're hanging in okay. There's something I'd like your help with.")
    call Quest_Say(q,null,"You seem different. Something wrong?")
    call Quest_Say(q,udg_Mid,"No, not quite. With the recent monster attacks on Kalm I decided to try my hand at inventing a new kind of weapon that can take out lots of monsters at once. With my uncle's help I managed to make a prototype but it's not finished yet.")
    call Quest_Say(q,udg_Mid,"I need some feedback from in-combat use, as well as some advice from the dwarves in the Barrens on how to properly implement the trigger. Think I can count on you for this?")
    call Quest_Say(q,null,"That doesn't sound too difficult. What kind of weapon is it?")
    call Quest_Say(q,udg_Mid,"It's a special mechanical crossbow. Here, I need you to use the prototype of it and report the results to me.")
    call Quest_Say(q,null,"Right, and ask the dwarves for advice was it?")
    call Quest_Say(q,udg_Mid,"Exactly. Good luck and thank you.")
    call Quest_OnDone(q,"QuestYoungEngineer_Started")
    // 2. Test the crossbow, get the dwarves' advice and report to Mid (gg_trg_Quest_YoungEngineer_Complete)
    call Quest_Custom(q,"")
endfunction

// Called by Mid when he is ready to ask for help with his crossbow.
function QuestYoungEngineer_Available takes nothing returns nothing
    if QUEST_YOUNG_ENGINEER==0 then
        call QuestYoungEngineer_Define()
    endif
    call Quest_MakeAvailable(QUEST_YOUNG_ENGINEER)
endfunction

function Trig_Quest_YoungEngineer_Ping_Conditions takes nothing returns boolean
    return(IsUnitHiddenBJ(udg_Mid)==false)
endfunction

function Trig_Quest_YoungEngineer_Ping_Cond_AdviceOnGround takes nothing returns boolean
    return(IsItemOwned(udg_QuestItem[29])==false)
endfunction

function Trig_Quest_YoungEngineer_Ping_Cond_GiottVisible takes nothing returns boolean
    return(IsUnitHiddenBJ(gg_unit_h00R_0256)==false)
endfunction

function Trig_Quest_YoungEngineer_Ping_Cond_NoAdviceItem takes nothing returns boolean
    return(udg_QuestItem[29]==null)
endfunction

function Trig_Quest_YoungEngineer_Ping_Cond_AdviceStepOpen takes nothing returns boolean
    return(IsQuestItemCompleted(udg_QuestReq[$A])==false) // $A = 10
endfunction

function Trig_Quest_YoungEngineer_Ping_Cond_ReturnToMidReady takes nothing returns boolean
    return(IsQuestItemCompleted(udg_QuestReq[$A]))and(IsUnitHiddenBJ(udg_Mid)==false) // $A = 10
endfunction

function Trig_Quest_YoungEngineer_Ping_Cond_CrossbowOnGround takes nothing returns boolean
    return(IsItemOwned(udg_QuestItem[28])==false)
endfunction

function Trig_Quest_YoungEngineer_Ping_Cond_MidVisible takes nothing returns boolean
    return(IsUnitHiddenBJ(udg_Mid)==false)
endfunction

function Trig_Quest_YoungEngineer_Ping_Cond_NoCrossbowItem takes nothing returns boolean
    return(udg_QuestItem[28]==null)
endfunction

function Trig_Quest_YoungEngineer_Ping_Cond_TestStepOpen takes nothing returns boolean
    return(IsQuestItemCompleted(udg_QuestReq[9])==false)
endfunction

// Every 15 seconds: ping what the party still needs - Giott or the advice, the crossbow or Mid.
function Trig_Quest_YoungEngineer_Ping_Actions takes nothing returns nothing
    if(Trig_Quest_YoungEngineer_Ping_Cond_AdviceStepOpen())then
        if(Trig_Quest_YoungEngineer_Ping_Cond_NoAdviceItem())then
            if(Trig_Quest_YoungEngineer_Ping_Cond_GiottVisible())then
                set udg_TempPoint=GetUnitLoc(gg_unit_h00R_0256)
                call PingMinimapLocForForce(GetPlayersAll(),udg_TempPoint,2.)
                call RemoveLocation(udg_TempPoint)
            endif
        else
            if(Trig_Quest_YoungEngineer_Ping_Cond_AdviceOnGround())then
                set udg_TempPoint=GetItemLoc(udg_QuestItem[29])
                call PingMinimapLocForForce(GetPlayersAll(),udg_TempPoint,2.)
                call RemoveLocation(udg_TempPoint)
            endif
        endif
    endif
    if(Trig_Quest_YoungEngineer_Ping_Cond_TestStepOpen())then
        if(Trig_Quest_YoungEngineer_Ping_Cond_NoCrossbowItem())then
            if(Trig_Quest_YoungEngineer_Ping_Cond_MidVisible())then
                set udg_TempPoint=GetUnitLoc(udg_Mid)
                call PingMinimapLocForForce(GetPlayersAll(),udg_TempPoint,2.)
                call RemoveLocation(udg_TempPoint)
            endif
        else
            if(Trig_Quest_YoungEngineer_Ping_Cond_CrossbowOnGround())then
                set udg_TempPoint=GetItemLoc(udg_QuestItem[28])
                call PingMinimapLocForForce(GetPlayersAll(),udg_TempPoint,2.)
                call RemoveLocation(udg_TempPoint)
            endif
        endif
    else
        if(Trig_Quest_YoungEngineer_Ping_Cond_ReturnToMidReady())then
            set udg_TempPoint=GetUnitLoc(udg_Mid)
            call PingMinimapLocForForce(GetPlayersAll(),udg_TempPoint,2.)
            call RemoveLocation(udg_TempPoint)
        endif
    endif
endfunction

function Trig_Quest_YoungEngineer_Complete_Conditions takes nothing returns boolean
    return((IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(IsUnitHiddenBJ(udg_Mid)==false)and(udg_InCinematicMode==false))!=null
endfunction

function Trig_Quest_YoungEngineer_Complete_Cond_HasAdvice takes nothing returns boolean
    return(UnitHasItemOfTypeBJ(GetTriggerUnit(),'I042')) // 'I042': item "Engineering Advice"
endfunction

function Trig_Quest_YoungEngineer_Complete_Cond_CrossbowExists takes nothing returns boolean
    return(udg_QuestItem[28]!=null)
endfunction

function Trig_Quest_YoungEngineer_Complete_Cond_CrossbowHeldOrGone takes nothing returns boolean
    return(UnitHasItemOfTypeBJ(GetTriggerUnit(),'I0BQ'))or(udg_QuestItem[28]==null) // 'I0BQ': item "Prototype Crossbow"
endfunction

function Trig_Quest_YoungEngineer_Complete_Cond_CrossbowSettled takes nothing returns boolean
    return(Trig_Quest_YoungEngineer_Complete_Cond_CrossbowHeldOrGone())
endfunction

function Trig_Quest_YoungEngineer_Complete_Cond_CrossbowLost takes nothing returns boolean
    return(udg_QuestItem[28]==null)or(IsItemOwned(udg_QuestItem[28])==false)
endfunction

function Trig_Quest_YoungEngineer_Complete_Cond_NoCrossbowItem takes nothing returns boolean
    return(udg_QuestItem[28]==null)
endfunction

function Trig_Quest_YoungEngineer_Complete_Cond_CrossbowLostCheck takes nothing returns boolean
    return(Trig_Quest_YoungEngineer_Complete_Cond_CrossbowLost())
endfunction

function Trig_Quest_YoungEngineer_Complete_Cond_TestDone takes nothing returns boolean
    return(udg_CrossbowAdviceGiven)
endfunction

function Trig_Quest_YoungEngineer_Complete_Cond_TestStepOpen takes nothing returns boolean
    return(IsQuestItemCompleted(udg_QuestReq[9])==false)
endfunction

function Trig_Quest_YoungEngineer_Complete_Cond_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_YoungEngineer_Complete_Cond_BothStepsDone takes nothing returns boolean
    return(IsQuestItemCompleted(udg_QuestReq[9]))and(IsQuestItemCompleted(udg_QuestReq[$A])) // $A = 10
endfunction

// Step 2: a hero came to Mid. Hands in the advice and the test results; replaces a lost prototype; when
// both tasks are done, Mid finishes the Auto-Crossbow.
function Trig_Quest_YoungEngineer_Complete_Actions takes nothing returns nothing
    if(Trig_Quest_YoungEngineer_Complete_Cond_HasAdvice())then
        call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I042')) // 'I042': item "Engineering Advice"
        call QuestItemSetCompletedBJ(udg_QuestReq[$A],true) // $A = 10
    endif
    if(Trig_Quest_YoungEngineer_Complete_Cond_TestStepOpen())then
        if(Trig_Quest_YoungEngineer_Complete_Cond_TestDone())then
            if(Trig_Quest_YoungEngineer_Complete_Cond_CrossbowSettled())then
                call QuestItemSetCompletedBJ(udg_QuestReq[9],true)
                if(Trig_Quest_YoungEngineer_Complete_Cond_CrossbowExists())then
                    call RemoveItem(udg_QuestItem[28])
                endif
            endif
        else
            if(Trig_Quest_YoungEngineer_Complete_Cond_CrossbowLostCheck())then
                call DisableTrigger(GetTriggeringTrigger())
                if(Trig_Quest_YoungEngineer_Complete_Cond_NoCrossbowItem())then
                    set udg_QuestItem[28]=UnitAddItemByIdSwapped('I0BQ',GetTriggerUnit()) // 'I0BQ': item "Prototype Crossbow"
                    call SetItemInvulnerableBJ(GetLastCreatedItem(),true)
                else
                    call UnitAddItemSwapped(udg_QuestItem[28],GetTriggerUnit())
                endif
                set udg_FloatingText[28]=CreateTextTagUnitBJ("|cffffcc00Mid|r: Oh you lost the Prototype? Here I have a new one for you.",udg_Mid,0,12.,'d','d','d',0)
                call Wait_Polled(10.)
                call DestroyTextTagBJ(udg_FloatingText[28])
                call EnableTrigger(GetTriggeringTrigger())
                return
            endif
        endif
    endif
    if(Trig_Quest_YoungEngineer_Complete_Cond_BothStepsDone())then
        call DisableTrigger(GetTriggeringTrigger())
        call DisableTrigger(gg_trg_Quest_YoungEngineer_Ping)
        call DestroyTrigger(gg_trg_Quest_YoungEngineer_Ping)
        if(Trig_Quest_YoungEngineer_Complete_Cond_CinematicsEnabled())then
            call Cine_Enter()
            call Cam_PanToUnit(GetTriggerUnit(),0)
            call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"Here you go Mid. All the things you needed from us. Are you going to be fine now?",false)
            call Text_Say(udg_Mid,"Thanks! Yes, this is good information. I should be able to fulfill this project of mine now.",false)
            call Text_Say(udg_Mid,"Let me just quickly make these adjustments...",false)
            call Text_Transmission(udg_Mid,"Mid","Let me just quickly make these adjustments... ...","Let me just quickly make these adjustments...",null,0,false)
            call Text_Transmission(udg_Mid,"Mid","Let me just quickly make these adjustments... ... ... there we go!","Let me just quickly make these adjustments... ...",null,0,false)
            call Text_Say(udg_Mid,"My masterwork is now complete, thanks to your help!",false)
            call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"That's great. So will you be using it?",false)
            call Text_Say(udg_Mid,"No, I'm no good at fighting. I still lack experience. You are a skilled fighter yourself. You should be the one to wield it. I hope it is of good use to you. And here, take this gold as well for all you've done.",false)
            call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"It does look much improved from before. Many thanks, Mid.",false)
            call Reward_Give(5000,$FA0,udg_Mid) // $FA0 = 4000
            call Cine_ExitAction()
        else
            call Reward_Give(5000,$FA0,udg_Mid) // $FA0 = 4000
        endif
        call UnitAddItemByIdSwapped('I061',GetTriggerUnit()) // 'I061': item "Auto-Crossbow"
        call Quest_StepDone(QUEST_YOUNG_ENGINEER,GetOwningPlayer(GetTriggerUnit()),GetTriggerUnit())
        call DestroyTrigger(GetTriggeringTrigger())
    endif
endfunction

function InitTrig_Quest_YoungEngineer takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Quest_Part20 (module Quest),
// which keeps the original registration order.

function Register_Quest_YoungEngineer_Ping takes nothing returns nothing
    set gg_trg_Quest_YoungEngineer_Ping=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_YoungEngineer_Ping)
    call TriggerRegisterTimerEventPeriodic(gg_trg_Quest_YoungEngineer_Ping,15.)
    call TriggerAddCondition(gg_trg_Quest_YoungEngineer_Ping,Condition(function Trig_Quest_YoungEngineer_Ping_Conditions))
    call TriggerAddAction(gg_trg_Quest_YoungEngineer_Ping,function Trig_Quest_YoungEngineer_Ping_Actions)
endfunction

function Register_Quest_YoungEngineer_Complete takes nothing returns nothing
    set gg_trg_Quest_YoungEngineer_Complete=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_YoungEngineer_Complete)
    call TriggerAddCondition(gg_trg_Quest_YoungEngineer_Complete,Condition(function Trig_Quest_YoungEngineer_Complete_Conditions))
    call TriggerAddAction(gg_trg_Quest_YoungEngineer_Complete,function Trig_Quest_YoungEngineer_Complete_Actions)
endfunction

endlibrary
