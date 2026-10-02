library TLegendArcher requires TCam, TCine, TForce, TPlayerPart01, TText, TUnit
function Trig_Legend_Archer_Talk_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,udg_NpcUnit[2],true,true,true))
endfunction

function Trig_Legend_Archer_Talk_Cond_WrongJobOrLevel takes nothing returns boolean
    return(GetUnitTypeId(Player_GetHero(GetTriggerPlayer()))!=udg_JobUnitType[udg_TempInteger])or(GetHeroLevel(Player_GetHero(GetTriggerPlayer()))<99)
endfunction

function Trig_Legend_Archer_Talk_Cond_TaskLocked takes nothing returns boolean
    return(udg_QuestStage[udg_TempInteger]>=2)and(Trig_Legend_Archer_Talk_Cond_WrongJobOrLevel())
endfunction

function Trig_Legend_Archer_Talk_Cond_CinematicsOnTask takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Legend_Archer_Talk_Cond_CinematicsOnIntro takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Legend_Archer_Talk_Cond_FirstVisit takes nothing returns boolean
    return(udg_QuestStage[udg_TempInteger]==2)
endfunction

function Trig_Legend_Archer_Talk_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    set udg_TempInteger=2
    if(Trig_Legend_Archer_Talk_Cond_TaskLocked())then
        set udg_TempForce=Force_OfPlayer(GetTriggerPlayer())
        call DisplayTimedTextToForce(udg_TempForce,15.,((GetHeroProperName(GetTriggerUnit())+": You need to be |cffffcc00Ultimate Master ")+(udg_JobName[udg_TempInteger]+"|r to take on my task.")))
        call DestroyForce(udg_TempForce)
        return
    endif
    call DestroyEffectBJ(udg_LegendMarker[udg_TempInteger])
    set udg_QuestStage[udg_TempInteger]=(udg_QuestStage[udg_TempInteger]+1)
    if(Trig_Legend_Archer_Talk_Cond_FirstVisit())then
        if(Trig_Legend_Archer_Talk_Cond_CinematicsOnIntro())then
            call Cine_Enter()
            call Cam_PanToUnit(GetTriggerUnit(),0)
            call Text_Say(udg_NpcUnit[2],"Greetings. I am Nevius, the holder of the title of Legendary Archer.",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"Hmm, Nevius is it? Apologies, I was under the impression the Legendary Archer was somebody else.",false)
            call Text_Say(udg_NpcUnit[2],"That used to be the case, yes. The former Legendary Archer left quite a bar to clear. But then a competition was held, and I beat her as well as the other competitors. Earning me this title.",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"I see. Do you have any advice to share with a novice such as myself?",false)
            call Text_Say(udg_NpcUnit[2],"Why not. You know as Archer your main objective is to shoot a lot, and make every single shot count. Individually they may be weak shots, but a professional Archer powers up every single one of those shots until they are a barrage of death.",false)
            call Text_Say(udg_NpcUnit[2],"Rapid Fire, Arrowwave, Myriad Arrows, techniques with a great number of shots released at your target. And every single one, gaining power through setting yourself up right.",false)
            call Text_Say(udg_NpcUnit[2],"Make good use of your Animal Companion, ideally more than one, striking the enemy in good alternance, to hit the enemy's Blind Spot. Find the enemy's weakness and equip the matching quiver of arrows. Your Rapid Fire technique is normally Fire based, but will change element depending on your arrows.",false)
            call Text_Say(udg_NpcUnit[2],"And of course, Aim your shots properly. Aiming takes time out of your normal shots, but your techniques are no slower than before, and all benefit from being aimed properly.",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"It does seem like there's a lot to be aware of to truly get the most out of every shot.",false)
            call Text_Say(udg_NpcUnit[2],"There is, but don't underestimate your versatility either. Remember that you can switch arrows with ease, and even double down on the enemy's weakness by powering it up further with mystic gear or elemental orbs. At other times you may need to push the endurance of your Animal Companions with a Summoner's Horn. Study your enemies and prepare just what you need.",false)
            call Text_Say(udg_NpcUnit[2],"But don't forget that you are an Archer. You are not a Knight, you are not a Lancer. You are not the best at taking an enemy's strikes head on, and unlike a Lancer your techniques are better suited to taking down a melee attacker than a ranged attacker. Play to your strengths.",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"I'll keep it in mind. Thanks.",false)
            call Cine_ExitAction()
        endif
    else
        if(Trig_Legend_Archer_Talk_Cond_CinematicsOnTask())then
            call Cine_Enter()
            call Cam_PanToUnit(GetTriggerUnit(),0)
            call Text_Say(udg_NpcUnit[2],"You've come back. I take it you wish to know how to ascend to Legendary Archer yourself?",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"Indeed. Show us your trial.",false)
            call Text_Say(udg_NpcUnit[2],"This is a trial to test your mastery of one of the core tenets of optimizing your shots - your Blind Spot trait. Only those who use it well deserve my title.",false)
            call Text_Say(udg_NpcUnit[2],"My task to you is to hit enemies' Blind Spots no less than 60 times in the duration of a single usage of Aim.",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"Hitting their Blind Spot 60 times... in a single Aim!?",false)
            call Text_Say(udg_NpcUnit[2],"It shouldn't be too hard a task for you. Make good use of companions and techniques and you'll get it done I'm sure.",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"It sounds tough... but I'll overcome this.",false)
            call Cine_ExitAction()
        endif
    endif
    call StartTimerBJ(udg_UnitUpdateTimer,false,1.)
endfunction

function InitTrig_Legend_Archer takes nothing returns nothing
endfunction

endlibrary
