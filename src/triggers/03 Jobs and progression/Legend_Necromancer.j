library TLegendNecromancer requires TCam, TCine, TForce, TPlayerPart01, TText, TUnit
function Trig_Legend_Necromancer_Talk_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,udg_NpcUnit[21],true,true,true))
endfunction

function Trig_Legend_Necromancer_Talk_Cond_WrongJobOrLevel takes nothing returns boolean
    return(GetUnitTypeId(Player_GetHero(GetTriggerPlayer()))!=udg_JobUnitType[udg_TempInteger])or(GetHeroLevel(Player_GetHero(GetTriggerPlayer()))<99)
endfunction

function Trig_Legend_Necromancer_Talk_Cond_TaskLocked takes nothing returns boolean
    return(udg_QuestStage[udg_TempInteger]>=2)and(Trig_Legend_Necromancer_Talk_Cond_WrongJobOrLevel())
endfunction

function Trig_Legend_Necromancer_Talk_Cond_CinematicsOnTask takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Legend_Necromancer_Talk_Cond_CinematicsOnIntro takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Legend_Necromancer_Talk_Cond_FirstVisit takes nothing returns boolean
    return(udg_QuestStage[udg_TempInteger]==2)
endfunction

function Trig_Legend_Necromancer_Talk_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    set udg_TempInteger=21
    if(Trig_Legend_Necromancer_Talk_Cond_TaskLocked())then
        set udg_TempForce=Force_OfPlayer(GetTriggerPlayer())
        call DisplayTimedTextToForce(udg_TempForce,15.,((GetHeroProperName(GetTriggerUnit())+": You need to be |cffffcc00Ultimate Master ")+(udg_JobName[udg_TempInteger]+"|r to take on my task.")))
        call DestroyForce(udg_TempForce)
        return
    endif
    call DestroyEffectBJ(udg_LegendMarker[udg_TempInteger])
    set udg_QuestStage[udg_TempInteger]=(udg_QuestStage[udg_TempInteger]+1)
    if(Trig_Legend_Necromancer_Talk_Cond_FirstVisit())then
        if(Trig_Legend_Necromancer_Talk_Cond_CinematicsOnIntro())then
            call Cine_Enter()
            call Cam_PanToUnit(GetTriggerUnit(),0)
            call Text_Say(udg_NpcUnit[21],"Quiet, mortal. You dare speak to me?",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"... but I haven't said anything yet!",false)
            call Text_Say(udg_NpcUnit[21],"I concern myself not with such trivial details. I am the great Enuo, the strongest Necromancer who ever lived, and summoner of the void itself.",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"Oh so you're the Legendary Necromancer. Figured as much.",false)
            call Text_Say(udg_NpcUnit[21],"Legendary Necromancer... yes that's a fitting title indeed. I like it. You pass the test.",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"Uhm... thank you, I guess?",false)
            call Text_Say(udg_NpcUnit[21],"Unfortunately for you I have no need for a successor. You may excuse yourself from my presence now.",false)
            call Text_Say(gg_unit_H00O_0259,"Come now, Enuo, won't you humor them at least a bit?",false)
            call Text_Say(udg_NpcUnit[21],"Mind your own business, Freelancer. Does someone as uncommittal as you even understand the intricacies of necromancy at all?",false)
            call Text_Say(udg_NpcUnit[21],"Keeping your own HP and MP in check through clever usage of every skill in your arsenal. Using Osmose to leave powerful foes without any MP to use their own spells. And healing an entire army of skeletons as well as yourself by sacrificing your zombies at just the right times.",false)
            call Text_Say(udg_NpcUnit[21],"The path of necromancy is a hard but rewarding task. It is not to be taken lightly!",false)
            call Text_Say(gg_unit_H00O_0259,"Well, there you go. I think that's as much as you're going to get out of him.",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"Well... thanks.",false)
            call Cine_ExitAction()
        endif
    else
        if(Trig_Legend_Necromancer_Talk_Cond_CinematicsOnTask())then
            call Cine_Enter()
            call Cam_PanToUnit(GetTriggerUnit(),0)
            call Text_Say(udg_NpcUnit[21],"You again? What do you want this time.",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"Uh, so yes. Sir Legendary Necromancer Enuo, I hope to become a Legendary Master Necromancer myself and I'm supposed to get a task from you so...",false)
            call Text_Say(udg_NpcUnit[21],"I don't care. Ask that nosy Freelancer over there.",false)
            call Cine_ExitAction()
        endif
    endif
    call StartTimerBJ(udg_UnitUpdateTimer,false,1.)
endfunction

function InitTrig_Legend_Necromancer takes nothing returns nothing
endfunction

endlibrary
