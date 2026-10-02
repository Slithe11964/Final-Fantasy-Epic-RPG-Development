library TLegendProphet requires TCam, TCine, TForce, TPlayerHero, TText, TUnit
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Legend_Prophet_Talk=null
endglobals

function Trig_Legend_Prophet_Talk_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,udg_NpcUnit[18],true,true,true))
endfunction

function Trig_Legend_Prophet_Talk_Cond_WrongJobOrLevel takes nothing returns boolean
    return(GetUnitTypeId(Player_GetHero(GetTriggerPlayer()))!=udg_JobUnitType[udg_TempInteger])or(GetHeroLevel(Player_GetHero(GetTriggerPlayer()))<99)
endfunction

function Trig_Legend_Prophet_Talk_Cond_TaskLocked takes nothing returns boolean
    return(udg_QuestStage[udg_TempInteger]>=2)and(Trig_Legend_Prophet_Talk_Cond_WrongJobOrLevel())
endfunction

function Trig_Legend_Prophet_Talk_Cond_CinematicsOnTask takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Legend_Prophet_Talk_Cond_CinematicsOnIntro takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Legend_Prophet_Talk_Cond_FirstVisit takes nothing returns boolean
    return(udg_QuestStage[udg_TempInteger]==2)
endfunction

function Trig_Legend_Prophet_Talk_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    set udg_TempInteger=18
    if(Trig_Legend_Prophet_Talk_Cond_TaskLocked())then
        set udg_TempForce=Force_OfPlayer(GetTriggerPlayer())
        call DisplayTimedTextToForce(udg_TempForce,15.,((GetHeroProperName(GetTriggerUnit())+": You need to be |cffffcc00Ultimate Master ")+(udg_JobName[udg_TempInteger]+"|r to take on my task.")))
        call DestroyForce(udg_TempForce)
        return
    endif
    call DestroyEffectBJ(udg_LegendMarker[udg_TempInteger])
    set udg_QuestStage[udg_TempInteger]=(udg_QuestStage[udg_TempInteger]+1)
    if(Trig_Legend_Prophet_Talk_Cond_FirstVisit())then
        if(Trig_Legend_Prophet_Talk_Cond_CinematicsOnIntro())then
            call Cine_Enter()
            call Cam_PanToUnit(GetTriggerUnit(),0)
            call Text_Say(udg_NpcUnit[18],"Greetings, adventurers. I am Medivh, the last guardian, here in Elysium as the Legendary Prophet.",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"Hello Medivh. You're not originally from this world, are you?",false)
            call Text_Say(udg_NpcUnit[18],"Indeed I am not. But I did come to this plane at one point in the past when investigating the history of the Burning Legion. Regardless, that is a story for another time. You are here for advice, are you?",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"That would be definitely appreciated.",false)
            call Text_Say(udg_NpcUnit[18],"If you wish to be a powerful Prophet, you must consider that you are not a Priest. Your strengths and weaknesses are very different.",false)
            call Text_Say(udg_NpcUnit[18],"While a Priest can cast protective buffs and remove ailments, as Prophet you have no means of doing so. At best you can cast a protective shell on a single ally - or yourself - at the cost of your own MP. But your power lies not in prevention of damage, but in boosting, healing and enabling of large groups of allies.",false)
            call Text_Say(udg_NpcUnit[18],"You have the means to disable an enemy for short time. You have the means to increase the power and restore both health and magic to an indefinitely large group of allies. And of course, you have Infinity, the ultimate protective magic.",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"So you're saying our true strength lies in what we can do for a large group of allies rather than individuals?",false)
            call Text_Say(udg_NpcUnit[18],"It's most definitely the Prophet's specialty. But ultimately I'm only recommending that you consider what it is you need, and what works best with your allies. You are a supporter in the end. Don't forget that.",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"Well, that's true. I suppose there's no one size fits all solution.",false)
            call Cine_ExitAction()
        endif
    else
        if(Trig_Legend_Prophet_Talk_Cond_CinematicsOnTask())then
            call Cine_Enter()
            call Cam_PanToUnit(GetTriggerUnit(),0)
            call Text_Say(udg_NpcUnit[18],"Greetings once more. I presume you've come to gain my blessing, have you?",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"Yeah that's right. You have something for us to do?",false)
            call Text_Say(udg_NpcUnit[18],"As I mentioned last time, as a Prophet you need to consider your strengths and whether the class is even the right choice. So I'll simply have you find a situation where the Prophet's power shines the most.",false)
            call Text_Say(udg_NpcUnit[18],"The ultimate protective spell, Infinity. I want you to block over 500'000 total damage with a single usage of it.",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"That's... a lot.",false)
            call Text_Say(udg_NpcUnit[18],"It is, yes, but that's exactly what the spell allows you to do best - to protect without condition and without limit.",false)
            call Text_Say(udg_NpcUnit[18],"Now for purposes of this task, unit Armor and hero Magic Defense will not be considered, nor any other buffs or ailments. Only the pure raw power of the enemy's attacks counts. Find the perfect place to use your powers, and perform this feat.",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"I will. Even this daunting a task must be possible in the end.",false)
            call Cine_ExitAction()
        endif
    endif
    call StartTimerBJ(udg_UnitUpdateTimer,false,1.)
endfunction

function InitTrig_Legend_Prophet takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Legend (module Legend),
// which keeps the original registration order.

function Register_Legend_Prophet_Talk takes nothing returns nothing
    set gg_trg_Legend_Prophet_Talk=CreateTrigger()
    call DisableTrigger(gg_trg_Legend_Prophet_Talk)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Prophet_Talk,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Prophet_Talk,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Prophet_Talk,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Prophet_Talk,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Prophet_Talk,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Prophet_Talk,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Prophet_Talk,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Prophet_Talk,Player(7),true)
    call TriggerAddCondition(gg_trg_Legend_Prophet_Talk,Condition(function Trig_Legend_Prophet_Talk_Conditions))
    call TriggerAddAction(gg_trg_Legend_Prophet_Talk,function Trig_Legend_Prophet_Talk_Actions)
endfunction

endlibrary
