library TLegendSummoner requires TCam, TCine, TForce, TPlayerPart01, TText, TUnit
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Legend_Summoner_Talk=null
endglobals

function Trig_Legend_Summoner_Talk_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,udg_NpcUnit[$D],true,true,true)) // $D = 13
endfunction

function Trig_Legend_Summoner_Talk_Cond_WrongJobOrLevel takes nothing returns boolean
    return(GetUnitTypeId(Player_GetHero(GetTriggerPlayer()))!=udg_JobUnitType[udg_TempInteger])or(GetHeroLevel(Player_GetHero(GetTriggerPlayer()))<99)
endfunction

function Trig_Legend_Summoner_Talk_Cond_TaskLocked takes nothing returns boolean
    return(udg_QuestStage[udg_TempInteger]>=2)and(Trig_Legend_Summoner_Talk_Cond_WrongJobOrLevel())
endfunction

function Trig_Legend_Summoner_Talk_Cond_CinematicsOnTask takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Legend_Summoner_Talk_Cond_CinematicsOnIntro takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Legend_Summoner_Talk_Cond_FirstVisit takes nothing returns boolean
    return(udg_QuestStage[udg_TempInteger]==2)
endfunction

function Trig_Legend_Summoner_Talk_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    set udg_TempInteger=$D // $D = 13
    if(Trig_Legend_Summoner_Talk_Cond_TaskLocked())then
        set udg_TempForce=Force_OfPlayer(GetTriggerPlayer())
        call DisplayTimedTextToForce(udg_TempForce,15.,((GetHeroProperName(GetTriggerUnit())+": You need to be |cffffcc00Ultimate Master ")+(udg_JobName[udg_TempInteger]+"|r to take on my task.")))
        call DestroyForce(udg_TempForce)
        return
    endif
    call DestroyEffectBJ(udg_LegendMarker[udg_TempInteger])
    set udg_QuestStage[udg_TempInteger]=(udg_QuestStage[udg_TempInteger]+1)
    if(Trig_Legend_Summoner_Talk_Cond_FirstVisit())then
        if(Trig_Legend_Summoner_Talk_Cond_CinematicsOnIntro())then
            call Cine_Enter()
            call Cam_PanToUnit(GetTriggerUnit(),0)
            call Text_Say(udg_NpcUnit[$D],"Why hello there.",false) // $D = 13
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"Wait, don't I know you?",false)
            call Text_Say(udg_NpcUnit[$D],"I live just on the outskirts of Kalm. We may have met before.",false) // $D = 13
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"Just from seeing you I wouldn't have imagined you to be a Legendary Summoner.",false)
            call Text_Say(udg_NpcUnit[$D],"I've been close friends with Eidolons since I was little. I was granted title of Legendary Summoner when I managed to call forth the Strongest Eidolon itself.",false) // $D = 13
            call Text_Say(udg_NpcUnit[$D],"Anyways, I hope you realize already that as a Summoner, some of your own traits are passed down to your Eidolons.",false) // $D = 13
            call Text_Say(udg_NpcUnit[$D],"Your own elemental affinities, as well as full or low health surges, to be precise. So if you want to have a very powerful Ifrit, make sure you wear gear that boosts Fire a lot.",false) // $D = 13
            call Text_Say(udg_NpcUnit[$D],"Or besides that you can also get your hands on some Blazer Gloves and make your Golem cover your entire roster of Eidolons, keeping them all Focused and dealing increased damage. There are many different avenues to potentially take. You had best adapt to what you're up against.",false) // $D = 13
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"Hmm, very true. Thanks for the advice.",false)
            call Cine_ExitAction()
        endif
    else
        if(Trig_Legend_Summoner_Talk_Cond_CinematicsOnTask())then
            call Cine_Enter()
            call Cam_PanToUnit(GetTriggerUnit(),0)
            call Text_Say(udg_NpcUnit[$D],"Why hello again. You wish to ascend, is that right?",false) // $D = 13
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"Very much so. What have you got for us?",false)
            call Text_Say(udg_NpcUnit[$D],"There are many different ways to be a truly effective Summoner. I want you to show me that you are not just a one trick pony.",false) // $D = 13
            call Text_Say(udg_NpcUnit[$D],"Shiva, Ifrit and Cyclops - I want you to push them so far as to deal over 10000 damage with a normal attack from each of them.",false) // $D = 13
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"A normal attack dealing over 10000 damage with all three of them, is it. All at once or one at a time?",false)
            call Text_Say(udg_NpcUnit[$D],"One at a time is fine. You can take all the time in the world so long as you get that big hit with each of them. You can - and should - even switch your entire loadout around to achieve this goal.",false) // $D = 13
            call Text_Say(udg_NpcUnit[$D],"The exact how is, of course, up to you. Simply prove yourself. That's all there is to it. Just don't forget that your elemental powers as well as full and critical HP power boosts will propagate onto your summoned Eidolons, and this should be no problem.",false) // $D = 13
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"Alright, shouldn't be too difficult.",false)
            call Cine_ExitAction()
        endif
    endif
    call StartTimerBJ(udg_UnitUpdateTimer,false,1.)
endfunction

function InitTrig_Legend_Summoner takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Legend (module Legend),
// which keeps the original registration order.

function Register_Legend_Summoner_Talk takes nothing returns nothing
    set gg_trg_Legend_Summoner_Talk=CreateTrigger()
    call DisableTrigger(gg_trg_Legend_Summoner_Talk)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Summoner_Talk,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Summoner_Talk,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Summoner_Talk,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Summoner_Talk,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Summoner_Talk,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Summoner_Talk,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Summoner_Talk,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Summoner_Talk,Player(7),true)
    call TriggerAddCondition(gg_trg_Legend_Summoner_Talk,Condition(function Trig_Legend_Summoner_Talk_Conditions))
    call TriggerAddAction(gg_trg_Legend_Summoner_Talk,function Trig_Legend_Summoner_Talk_Actions)
endfunction

endlibrary
