library TLegendMonk requires TCam, TCine, TForce, TPlayerPart01, TText, TUnit
function Trig_Legend_Monk_Talk_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,udg_NpcUnit[3],true,true,true))
endfunction

function Trig_Legend_Monk_Talk_Cond_WrongJobOrLevel takes nothing returns boolean
    return(GetUnitTypeId(Player_GetHero(GetTriggerPlayer()))!=udg_JobUnitType[udg_TempInteger])or(GetHeroLevel(Player_GetHero(GetTriggerPlayer()))<99)
endfunction

function Trig_Legend_Monk_Talk_Cond_TaskLocked takes nothing returns boolean
    return(udg_QuestStage[udg_TempInteger]>=2)and(Trig_Legend_Monk_Talk_Cond_WrongJobOrLevel())
endfunction

function Trig_Legend_Monk_Talk_Cond_CinematicsOnTask takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Legend_Monk_Talk_Cond_CinematicsOnIntro takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Legend_Monk_Talk_Cond_FirstVisit takes nothing returns boolean
    return(udg_QuestStage[udg_TempInteger]==2)
endfunction

function Trig_Legend_Monk_Talk_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    set udg_TempInteger=3
    if(Trig_Legend_Monk_Talk_Cond_TaskLocked())then
        set udg_TempForce=Force_OfPlayer(GetTriggerPlayer())
        call DisplayTimedTextToForce(udg_TempForce,15.,((GetHeroProperName(GetTriggerUnit())+": You need to be |cffffcc00Ultimate Master ")+(udg_JobName[udg_TempInteger]+"|r to take on my task.")))
        call DestroyForce(udg_TempForce)
        return
    endif
    call DestroyEffectBJ(udg_LegendMarker[udg_TempInteger])
    set udg_QuestStage[udg_TempInteger]=(udg_QuestStage[udg_TempInteger]+1)
    if(Trig_Legend_Monk_Talk_Cond_FirstVisit())then
        if(Trig_Legend_Monk_Talk_Cond_CinematicsOnIntro())then
            call Cine_Enter()
            call Cam_PanToUnit(GetTriggerUnit(),0)
            call Text_Say(udg_NpcUnit[3],"Most rare to see visitors in this place, it is.",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"You must be the Legendary Monk. What's your name?",false)
            call Text_Say(udg_NpcUnit[3],"I used to go by the name Trema. When I was still alive, I used to be a Monk in the world of Spira, until I brought the Seekers into this world.",false)
            call Text_Say(udg_NpcUnit[3],"But enough about me. In this place, the past does not exist. You will only surpass yourself if you forget your past and move into the future alone.",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"Is that your advice for growing stronger as a Monk?",false)
            call Text_Say(udg_NpcUnit[3],"You will understand what I mean eventually. For Monk specifically, do not forget that you are at your strongest when you knock an enemy right into a wall. And do not bother using weapons other than your fists. You will be lagging behind every other class if you do.",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"Indeed it seems to be the core of the Monk's power.",false)
            call Text_Say(udg_NpcUnit[3],"Very much. However do get yourself a good Barehanded weapon. It makes a large difference whether you have one or not. Also never forget that while you will lose your Brawler bonus if you carry a Tome in your hand, you can always still have one in your Spirit of Gaya and use its spell from there. Having an extra buff makes a large difference.",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"Good point. Thanks, Trema.",false)
            call Cine_ExitAction()
        endif
    else
        if(Trig_Legend_Monk_Talk_Cond_CinematicsOnTask())then
            call Cine_Enter()
            call Cam_PanToUnit(GetTriggerUnit(),0)
            call Text_Say(udg_NpcUnit[3],"So your quest has brought you back to me.",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"Indeed, you know what we need your blessing for. What would you have us do?",false)
            call Text_Say(udg_NpcUnit[3],"My task for you will not be some particular process. Instead I would simply have you show you've reached a particular milestone befitting of a Monk.",false)
            call Text_Say(udg_NpcUnit[3],"And that is: reach 1000 or more Strength during your Strength Burst.",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"Hmm, simple indeed, but far from trivial.",false)
            call Text_Say(udg_NpcUnit[3],"Indeed. There are a number of ways to achieve this goal. Strength is the cornerstone of your entire set of abilities, so being in control of it is vital.",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"Yeah, I'll manage.",false)
            call Cine_ExitAction()
        endif
    endif
    call StartTimerBJ(udg_UnitUpdateTimer,false,1.)
endfunction

function InitTrig_Legend_Monk takes nothing returns nothing
endfunction

endlibrary
