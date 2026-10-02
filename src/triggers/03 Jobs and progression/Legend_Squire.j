library TLegendSquire requires TCam, TCine, TForce, TPlayerPart01, TText, TUnit
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Legend_Squire_Talk=null
endglobals

function Trig_Legend_Squire_Talk_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,udg_NpcUnit[0],true,true,true))
endfunction

function Trig_Legend_Squire_Talk_Cond_WrongJobOrLevel takes nothing returns boolean
    return(GetUnitTypeId(Player_GetHero(GetTriggerPlayer()))!=udg_JobUnitType[udg_TempInteger])or(GetHeroLevel(Player_GetHero(GetTriggerPlayer()))<99)
endfunction

function Trig_Legend_Squire_Talk_Cond_TaskLocked takes nothing returns boolean
    return(udg_QuestStage[udg_TempInteger]>=2)and(Trig_Legend_Squire_Talk_Cond_WrongJobOrLevel())
endfunction

function Trig_Legend_Squire_Talk_Cond_CinematicsOnTask takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Legend_Squire_Talk_Cond_CinematicsOnIntro takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Legend_Squire_Talk_Cond_FirstVisit takes nothing returns boolean
    return(udg_QuestStage[udg_TempInteger]==2)
endfunction

function Trig_Legend_Squire_Talk_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    set udg_TempInteger=0
    if(Trig_Legend_Squire_Talk_Cond_TaskLocked())then
        set udg_TempForce=Force_OfPlayer(GetTriggerPlayer())
        call DisplayTimedTextToForce(udg_TempForce,15.,((GetHeroProperName(GetTriggerUnit())+": You need to be |cffffcc00Ultimate Master ")+(udg_JobName[udg_TempInteger]+"|r to take on my task.")))
        call DestroyForce(udg_TempForce)
        return
    endif
    call DestroyEffectBJ(udg_LegendMarker[udg_TempInteger])
    set udg_QuestStage[udg_TempInteger]=(udg_QuestStage[udg_TempInteger]+1)
    if(Trig_Legend_Squire_Talk_Cond_FirstVisit())then
        if(Trig_Legend_Squire_Talk_Cond_CinematicsOnIntro())then
            call Cine_Enter()
            call Cam_PanToUnit(GetTriggerUnit(),0)
            call Text_Say(udg_NpcUnit[0],"Hello there, aspiring adventurers! My name is Max.",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"You're quite a young one. That's surprising.",false)
            call Text_Say(udg_NpcUnit[0],"I may be young, but I certainly know my way around Tools. But if there's one thing you must realize as a Squire first, it's that your specialty is in supporting and being of utility to others. It's not your job to be the one doing all the hard hits.",false)
            call Text_Say(udg_NpcUnit[0],"Keeping enemies' attention away from your allies and making sure you can keep them all in top form is an important task.",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"Hmm, you can cover them quite effectively.",false)
            call Text_Say(udg_NpcUnit[0],"Indeed, and something you might not realize, but heroes at a Legendary level can grow exceptionally powerful when either in complete health or near death.",false)
            call Text_Say(udg_NpcUnit[0],"Of course remaining in either of those states is far from easy. But you as a Squire can do wonders there to enable those surges in your allies!",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"That's very true. Thanks for the tip.",false)
            call Cine_ExitAction()
        endif
    else
        if(Trig_Legend_Squire_Talk_Cond_CinematicsOnTask())then
            call Cine_Enter()
            call Cam_PanToUnit(GetTriggerUnit(),0)
            call Text_Say(udg_NpcUnit[0],"Hello again, fellow Squire. So you wish to attain the title of a Legendary Squire, do you?",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"Indeed I do. Tell me what I need to do.",false)
            call Text_Say(udg_NpcUnit[0],"I already told you what your main strength as a Squire is, right? Well, simply put, just put that to use.",false)
            call Text_Say(udg_NpcUnit[0],"Cover an ally with Focus or Serenity and have them take advantage of those full HP benefits for 30 hits or more before Cover expires. That's all you need to do.",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"I see. Yeah that's a simple application of what you taught us.",false)
            call Text_Say(udg_NpcUnit[0],"I know, no need to overcomplicate things. I just want you to see the actual effectiveness of using this strategy. And if you don't have an ally with full HP effects, just make one yourself.",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"Gotcha. I'll pass this trial with ease.",false)
            call Cine_ExitAction()
        endif
    endif
    call StartTimerBJ(udg_UnitUpdateTimer,false,1.)
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Legend_Squire takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Legend (module Legend),
// which keeps the original registration order.

function Register_Legend_Squire_Talk takes nothing returns nothing
    set gg_trg_Legend_Squire_Talk=CreateTrigger()
    call DisableTrigger(gg_trg_Legend_Squire_Talk)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Squire_Talk,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Squire_Talk,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Squire_Talk,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Squire_Talk,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Squire_Talk,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Squire_Talk,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Squire_Talk,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Squire_Talk,Player(7),true)
    call TriggerAddCondition(gg_trg_Legend_Squire_Talk,Condition(function Trig_Legend_Squire_Talk_Conditions))
    call TriggerAddAction(gg_trg_Legend_Squire_Talk,function Trig_Legend_Squire_Talk_Actions)
endfunction

endlibrary
