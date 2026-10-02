library TLegendSamurai requires TCam, TCine, TForce, TPlayerHero, TText, TUnit
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Legend_Samurai_Talk=null
endglobals

function Trig_Legend_Samurai_Talk_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,udg_NpcUnit[6],true,true,true))
endfunction

function Trig_Legend_Samurai_Talk_Cond_WrongJobOrLevel takes nothing returns boolean
    return(GetUnitTypeId(Player_GetHero(GetTriggerPlayer()))!=udg_JobUnitType[udg_TempInteger])or(GetHeroLevel(Player_GetHero(GetTriggerPlayer()))<99)
endfunction

function Trig_Legend_Samurai_Talk_Cond_TaskLocked takes nothing returns boolean
    return(udg_QuestStage[udg_TempInteger]>=2)and(Trig_Legend_Samurai_Talk_Cond_WrongJobOrLevel())
endfunction

function Trig_Legend_Samurai_Talk_Cond_CinematicsOnTask takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Legend_Samurai_Talk_Cond_CinematicsOnIntro takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Legend_Samurai_Talk_Cond_FirstVisit takes nothing returns boolean
    return(udg_QuestStage[udg_TempInteger]==2)
endfunction

function Trig_Legend_Samurai_Talk_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    set udg_TempInteger=6
    if(Trig_Legend_Samurai_Talk_Cond_TaskLocked())then
        set udg_TempForce=Force_OfPlayer(GetTriggerPlayer())
        call DisplayTimedTextToForce(udg_TempForce,15.,((GetHeroProperName(GetTriggerUnit())+": You need to be |cffffcc00Ultimate Master ")+(udg_JobName[udg_TempInteger]+"|r to take on my task.")))
        call DestroyForce(udg_TempForce)
        return
    endif
    call DestroyEffectBJ(udg_LegendMarker[udg_TempInteger])
    set udg_QuestStage[udg_TempInteger]=(udg_QuestStage[udg_TempInteger]+1)
    if(Trig_Legend_Samurai_Talk_Cond_FirstVisit())then
        if(Trig_Legend_Samurai_Talk_Cond_CinematicsOnIntro())then
            call Cine_Enter()
            call Cam_PanToUnit(GetTriggerUnit(),0)
            call Text_Say(udg_NpcUnit[6],"Hoy! My name be Kildor and I be here known as this here Legendary Samurai!",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"Kildor is it? I don't think I've heard of you before.",false)
            call Text_Say(udg_NpcUnit[6],"That not be surprising. Kildor not be fighting alongside human or elvenkind. Plus Kildor be already dead. His legacy be only among his people.",false)
            call Text_Say(udg_NpcUnit[6],"Trained a few samurai in his time, Kildor did. But alas, Kildor died before could pass on the way of the samurai truly. So now let Kildor impart his experience to you!",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"What advice does the Legendary Samurai have to give me?",false)
            call Text_Say(udg_NpcUnit[6],"Samurai be a duelist at the core! Tatsumaki jutsu be handy for dispatching groups but core of Samurai strength lies in one versus one battle.",false)
            call Text_Say(udg_NpcUnit[6],"Disable protection and open up an opportunity with Mineuchi jutsu! Then unleash Renzokuken jutsu and finish off with Iainuki jutsu! Clean rotation, dead enemy.",false)
            call Text_Say(udg_NpcUnit[6],"Renzokuken jutsu be more effective when close to death yourself! If feel daring enough, drop low then use Mirage for a bit of security, then stun enemy and finish off with a good combo. Only use when enemy close to death, else be on death's door yourself!",false)
            call Text_Say(udg_NpcUnit[6],"Also Samurai lifeblood be the katana. Make good use of katana to get powerful combos!",false)
            call Text_Say(udg_NpcUnit[6],"Master your techniques, master your blade, master your enemy! Never relent!",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"Well that's simple enough. Still, thanks for the advice, Legendary Samurai.",false)
            call Cine_ExitAction()
        endif
    else
        if(Trig_Legend_Samurai_Talk_Cond_CinematicsOnTask())then
            call Cine_Enter()
            call Cam_PanToUnit(GetTriggerUnit(),0)
            call Text_Say(udg_NpcUnit[6],"So you be here to gain blessing of Legendary Samurai, be you?",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"Yes, I am. What do I need to do to ascend to your level?",false)
            call Text_Say(udg_NpcUnit[6],"Remember what I say: master your technique, master your blade, master your enemy. Kildor have simple task for you.",false)
            call Text_Say(udg_NpcUnit[6],"Task be simple: perform a 20 hit Renzokuken, then land a Iainuki jutsu finisher to kill the enemy! Will take good mastery of your skills. If you can do this, you are declared worthy successor to the title of Legendary Samurai.",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"Perform a Renzokuken with 20 hits, then finish with a Iainuki, killing the enemy with it... alright, I can do this.",false)
            call Cine_ExitAction()
        endif
    endif
    call StartTimerBJ(udg_UnitUpdateTimer,false,1.)
endfunction

function InitTrig_Legend_Samurai takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Legend (module Legend),
// which keeps the original registration order.

function Register_Legend_Samurai_Talk takes nothing returns nothing
    set gg_trg_Legend_Samurai_Talk=CreateTrigger()
    call DisableTrigger(gg_trg_Legend_Samurai_Talk)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Samurai_Talk,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Samurai_Talk,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Samurai_Talk,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Samurai_Talk,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Samurai_Talk,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Samurai_Talk,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Samurai_Talk,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Samurai_Talk,Player(7),true)
    call TriggerAddCondition(gg_trg_Legend_Samurai_Talk,Condition(function Trig_Legend_Samurai_Talk_Conditions))
    call TriggerAddAction(gg_trg_Legend_Samurai_Talk,function Trig_Legend_Samurai_Talk_Actions)
endfunction

endlibrary
