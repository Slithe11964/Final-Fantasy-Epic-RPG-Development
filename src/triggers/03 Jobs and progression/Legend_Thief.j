library TLegendThief requires TCam, TCine, TForce, TPlayerPart01, TText, TUnit
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Legend_Thief_Talk=null
endglobals

function Trig_Legend_Thief_Talk_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,udg_NpcUnit[4],true,true,true))
endfunction

function Trig_Legend_Thief_Talk_Cond_WrongJobOrLevel takes nothing returns boolean
    return(GetUnitTypeId(Player_GetHero(GetTriggerPlayer()))!=udg_JobUnitType[udg_TempInteger])or(GetHeroLevel(Player_GetHero(GetTriggerPlayer()))<99)
endfunction

function Trig_Legend_Thief_Talk_Cond_TaskLocked takes nothing returns boolean
    return(udg_QuestStage[udg_TempInteger]>=2)and(Trig_Legend_Thief_Talk_Cond_WrongJobOrLevel())
endfunction

function Trig_Legend_Thief_Talk_Cond_CinematicsOnTask takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Legend_Thief_Talk_Cond_CinematicsOnIntro takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Legend_Thief_Talk_Cond_FirstVisit takes nothing returns boolean
    return(udg_QuestStage[udg_TempInteger]==2)
endfunction

function Trig_Legend_Thief_Talk_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    set udg_TempInteger=4
    if(Trig_Legend_Thief_Talk_Cond_TaskLocked())then
        set udg_TempForce=Force_OfPlayer(GetTriggerPlayer())
        call DisplayTimedTextToForce(udg_TempForce,15.,((GetHeroProperName(GetTriggerUnit())+": You need to be |cffffcc00Ultimate Master ")+(udg_JobName[udg_TempInteger]+"|r to take on my task.")))
        call DestroyForce(udg_TempForce)
        return
    endif
    call DestroyEffectBJ(udg_LegendMarker[udg_TempInteger])
    set udg_QuestStage[udg_TempInteger]=(udg_QuestStage[udg_TempInteger]+1)
    if(Trig_Legend_Thief_Talk_Cond_FirstVisit())then
        if(Trig_Legend_Thief_Talk_Cond_CinematicsOnIntro())then
            call Cine_Enter()
            call Cam_PanToUnit(GetTriggerUnit(),0)
            call Text_Say(udg_NpcUnit[4],"Hello there! I'm Rikku, here as the Legendary Thief.",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"Hello there, Rikku. You seem chipper.",false)
            call Text_Say(udg_NpcUnit[4],"Can't lie it feels a bit strange, me being here. But I didn't have a choice in the matter either.",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"The Spring manifested you here as the Legendary Thief. You must be very skilled then. Do you have any advice you can share with us?",false)
            call Text_Say(udg_NpcUnit[4],"Hmm, well why not. First off, there's two very different reasons to be Thief; you can either be a gatherer or a fighter, and they don't really go well together.",false)
            call Text_Say(udg_NpcUnit[4],"Steal has no combat use at all. If you want to be a fighter, you should replace it. But if you want to be a gatherer, it's your most important skill, of course.",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"Makes sense. Steal does seem exceptionally good for gathering loot.",false)
            call Text_Say(udg_NpcUnit[4],"It is, yes. If you're trying to gather ingredients or materials, it's not even a competition, a Thief will outpace everyone else. But as a fighter you have your own niche as well.",false)
            call Text_Say(udg_NpcUnit[4],"Let's make it clear from the start; as a Thief you want to be backstabbing your enemy. If you have allies around you, have them take the heat and position yourself behind the enemy. Between Daggers, your Thievery stance and your generally high Agility this will allow you to do a lot of damage very fast.",false)
            call Text_Say(udg_NpcUnit[4],"But if for one reason or another you can't backstab the enemy, your damage output suffers badly. You'll struggle to keep up with any other fighter.",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"I see, so the Thief class isn't very good on its own as a fighter.",false)
            call Text_Say(udg_NpcUnit[4],"That's not true either - don't underestimate the skill Evade & Counter. If timed right, you will evade any evadeable attack no matter what. That alone makes it a force to be reckoned with and makes it possible as Thief to take on enemies all by yourself simply by dodging well.",false)
            call Text_Say(udg_NpcUnit[4],"But Evade & Counter becomes very hard to keep up when you deal with multiple enemies or enemies that can Stun you, so be mindful of that.",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"That's a good point. Thanks, Rikku.",false)
            call Text_Say(udg_NpcUnit[4],"Don't mention it!",false)
            call Cine_ExitAction()
        endif
    else
        if(Trig_Legend_Thief_Talk_Cond_CinematicsOnTask())then
            call Cine_Enter()
            call Cam_PanToUnit(GetTriggerUnit(),0)
            call Text_Say(udg_NpcUnit[4],"You need a task from me, is that right?",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"Yep. What do you need us to do?",false)
            call Text_Say(udg_NpcUnit[4],"Let's make it something simple. You recall what I told you about Evade & Counter? It's very situational, but I want you to show you understand it and are capable of using it well when it's at its strongest.",false)
            call Text_Say(udg_NpcUnit[4],"I want you to evade and counter 20 enemy attacks in a row. You can't get hit, and you can't take a break to let the MP cost of the skill drop back down.",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"Evading 20 attacks in a row, that's quite a task.",false)
            call Text_Say(udg_NpcUnit[4],"Maybe so, but you can do it if you try I'm sure.",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"Thanks. I'll give it a shot.",false)
            call Cine_ExitAction()
        endif
    endif
    call StartTimerBJ(udg_UnitUpdateTimer,false,1.)
endfunction

function InitTrig_Legend_Thief takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Legend (module Legend),
// which keeps the original registration order.

function Register_Legend_Thief_Talk takes nothing returns nothing
    set gg_trg_Legend_Thief_Talk=CreateTrigger()
    call DisableTrigger(gg_trg_Legend_Thief_Talk)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Thief_Talk,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Thief_Talk,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Thief_Talk,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Thief_Talk,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Thief_Talk,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Thief_Talk,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Thief_Talk,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Thief_Talk,Player(7),true)
    call TriggerAddCondition(gg_trg_Legend_Thief_Talk,Condition(function Trig_Legend_Thief_Talk_Conditions))
    call TriggerAddAction(gg_trg_Legend_Thief_Talk,function Trig_Legend_Thief_Talk_Actions)
endfunction

endlibrary
