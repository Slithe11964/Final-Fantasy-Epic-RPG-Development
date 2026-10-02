library TLegendLancer requires TCam, TCine, TForce, TPlayerPart01, TText, TUnit
function Trig_Legend_Lancer_Talk_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,udg_NpcUnit[7],true,true,true))
endfunction

function Trig_Legend_Lancer_Talk_Cond_WrongJobOrLevel takes nothing returns boolean
    return(GetUnitTypeId(Player_GetHero(GetTriggerPlayer()))!=udg_JobUnitType[udg_TempInteger])or(GetHeroLevel(Player_GetHero(GetTriggerPlayer()))<99)
endfunction

function Trig_Legend_Lancer_Talk_Cond_TaskLocked takes nothing returns boolean
    return(udg_QuestStage[udg_TempInteger]>=2)and(Trig_Legend_Lancer_Talk_Cond_WrongJobOrLevel())
endfunction

function Trig_Legend_Lancer_Talk_Cond_CinematicsOnTask takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Legend_Lancer_Talk_Cond_CinematicsOnIntro takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Legend_Lancer_Talk_Cond_FirstVisit takes nothing returns boolean
    return(udg_QuestStage[udg_TempInteger]==2)
endfunction

function Trig_Legend_Lancer_Talk_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    set udg_TempInteger=7
    if(Trig_Legend_Lancer_Talk_Cond_TaskLocked())then
        set udg_TempForce=Force_OfPlayer(GetTriggerPlayer())
        call DisplayTimedTextToForce(udg_TempForce,15.,((GetHeroProperName(GetTriggerUnit())+": You need to be |cffffcc00Ultimate Master ")+(udg_JobName[udg_TempInteger]+"|r to take on my task.")))
        call DestroyForce(udg_TempForce)
        return
    endif
    call DestroyEffectBJ(udg_LegendMarker[udg_TempInteger])
    set udg_QuestStage[udg_TempInteger]=(udg_QuestStage[udg_TempInteger]+1)
    if(Trig_Legend_Lancer_Talk_Cond_FirstVisit())then
        if(Trig_Legend_Lancer_Talk_Cond_CinematicsOnIntro())then
            call Cine_Enter()
            call Cam_PanToUnit(GetTriggerUnit(),0)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"Hello. You're the Legendary Lancer?",false)
            call Text_Say(udg_NpcUnit[7],"Greetings. Indeed I am the manifestation of the Legendary Lancer. The name Highwind has been carried by and passed down to many powerful Lancers in many worlds, and I am here as the representative of all Highwinds.",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"So you're many people at once? Damn this spring does some insane things.",false)
            call Text_Say(udg_NpcUnit[7],"The material people you see here are not true reality. They are merely a surface to interact with the concepts and spirits gathered at this spring. But do not fret over it too much. If you're here to learn new things about your own classes, there is a wealth of experience to draw from here. Do not pass up the opportunity.",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"You're right. So what about you? What kind of techniques did the Legendary Lancers employ?",false)
            call Text_Say(udg_NpcUnit[7],"Certainly. One of the biggest commonalities among strong Lancers is using the Jump ability to avoid enemy attacks. During a Jump you will avoid any and all area attacks so if you time it well you can dodge even lethal attacks without a scratch.",false)
            call Text_Say(udg_NpcUnit[7],"It remains a very situational technique, however. Far more generally important is that as Lancer, you must keep your distance from the enemy to be truly effective. If the enemy is right in your face, you will do but a fraction of your true potential damage.",false)
            call Text_Say(udg_NpcUnit[7],"You do have ways to keep your enemies at bay though. Your Slam can knock away enemies, your Breath can take care of small fry as you focus on a larger distant target, and of course, your summoned dragon ally can serve as an alternative target.",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"Very true. So what about Jump then?",false)
            call Text_Say(udg_NpcUnit[7],"Jumping will also do more damage the further away from the enemy you begin, but of course, you will always be on top of your enemy right after. If they aren't dead, a quick Dragon Slam followup should help set up some distance between you once more.",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"I see. One more question, what do I need to make my Dragon techniques most effective?",false)
            call Text_Say(udg_NpcUnit[7],"Dragon Techniques take all your attributes into account but also depend very strongly on your prowess with the Spear. In general, despite giving no attributes on their own, good Spears will be the key to making them as strong as possible.",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"Oh that's simple enough then. Thanks for the advice.",false)
            call Cine_ExitAction()
        endif
    else
        if(Trig_Legend_Lancer_Talk_Cond_CinematicsOnTask())then
            call Cine_Enter()
            call Cam_PanToUnit(GetTriggerUnit(),0)
            call Text_Say(udg_NpcUnit[7],"Good to see you once more. Do you intend to take on the mantle of the Highwinds yourself then?",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"I am looking to reach the status of Legendary Mastery on the Lancer class, yes. How would you have me prove myself?",false)
            call Text_Say(udg_NpcUnit[7],"Lancers have always been in close relation with dragons. Of course in this world it is no different. The Dragon Eye effect that makes our attacks more effective at higher distances also stems from them, after all.",false)
            call Text_Say(udg_NpcUnit[7],"So just prove your dominance over Dragons to me. Kill 10 dragons in the span of a single minute.",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"Just kill them? Nothing else?",false)
            call Text_Say(udg_NpcUnit[7],"Yes that's all. I do not intend to be an obstacle in your road. If you master dragons, you are worthy of the title of Legendary Master. There's nothing more than that to it.",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"Alright, I'll do it then.",false)
            call Cine_ExitAction()
        endif
    endif
    call StartTimerBJ(udg_UnitUpdateTimer,false,1.)
endfunction

function InitTrig_Legend_Lancer takes nothing returns nothing
endfunction

endlibrary
