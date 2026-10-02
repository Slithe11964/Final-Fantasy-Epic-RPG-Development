library TLegendNinja requires TCam, TCine, TForce, TPlayerPart01, TText, TUnit
function Trig_Legend_Ninja_Talk_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,udg_NpcUnit[8],true,true,true))
endfunction

function Trig_Legend_Ninja_Talk_Cond_WrongJobOrLevel takes nothing returns boolean
    return(GetUnitTypeId(Player_GetHero(GetTriggerPlayer()))!=udg_JobUnitType[udg_TempInteger])or(GetHeroLevel(Player_GetHero(GetTriggerPlayer()))<99)
endfunction

function Trig_Legend_Ninja_Talk_Cond_TaskLocked takes nothing returns boolean
    return(udg_QuestStage[udg_TempInteger]>=2)and(Trig_Legend_Ninja_Talk_Cond_WrongJobOrLevel())
endfunction

function Trig_Legend_Ninja_Talk_Cond_CinematicsOnTask takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Legend_Ninja_Talk_Cond_MetDana takes nothing returns boolean
    return(udg_DanaQuestStage>0)
endfunction

function Trig_Legend_Ninja_Talk_Cond_CinematicsOnIntro takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Legend_Ninja_Talk_Cond_FirstVisit takes nothing returns boolean
    return(udg_QuestStage[udg_TempInteger]==2)
endfunction

function Trig_Legend_Ninja_Talk_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    set udg_TempInteger=8
    if(Trig_Legend_Ninja_Talk_Cond_TaskLocked())then
        set udg_TempForce=Force_OfPlayer(GetTriggerPlayer())
        call DisplayTimedTextToForce(udg_TempForce,15.,((GetHeroProperName(GetTriggerUnit())+": You need to be |cffffcc00Ultimate Master ")+(udg_JobName[udg_TempInteger]+"|r to take on my task.")))
        call DestroyForce(udg_TempForce)
        return
    endif
    call DestroyEffectBJ(udg_LegendMarker[udg_TempInteger])
    set udg_QuestStage[udg_TempInteger]=(udg_QuestStage[udg_TempInteger]+1)
    if(Trig_Legend_Ninja_Talk_Cond_FirstVisit())then
        if(Trig_Legend_Ninja_Talk_Cond_CinematicsOnIntro())then
            call Cine_Enter()
            call Cam_PanToUnit(GetTriggerUnit(),0)
            call Text_Say(udg_NpcUnit[8],"Greetings to you. I am Dana, here to represent the Legendary Ninja.",false)
            if(Trig_Legend_Ninja_Talk_Cond_MetDana())then
                call Text_Say(Player_GetHero(GetTriggerPlayer()),"Wait, did you say Dana? As in from the Phantom Village? You look so different.",false)
                call Text_Say(udg_NpcUnit[8],"This was how I used to look back when I was still a fighter myself. In actuality, us Night Elves us never had a dedicated Ninja class. But I am the closest to that in concept. And I did wield these twin moon blades myself.",false)
            else
                call Text_Say(Player_GetHero(GetTriggerPlayer()),"Wait, you're a girl? You almost looked like a guy to me.",false)
                call Text_Say(udg_NpcUnit[8],"Maybe you just need to get your eyes checked.",false)
            endif
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"So you are the Legendary Ninja. Any advice you could share?",false)
            call Text_Say(udg_NpcUnit[8],"The class of Ninja is ultimately about one thing only - hit fast, hit hard, more than anybody else. Place your own life on the line to become an even more devastating force.",false)
            call Text_Say(udg_NpcUnit[8],"So do not to limit yourself to a single path. Remember your end goal is always the same - strike as devastatingly as possible.",false)
            call Text_Say(udg_NpcUnit[8],"The Ninja's natural weapons may be Daggers, and they certainly work well, but you need not limit yourself to that either. Consider using a Rosetta Stone with a pair of entirely different weapons.",false)
            call Text_Say(udg_NpcUnit[8],"There is but one natural strength of the Ninja, and that is your speed. No matter what brand of weapons you choose, you can use it swiftly. But speed is only one dimension of effective strength.",false)
            call Text_Say(udg_NpcUnit[8],"Raw damage, agility, critical strike, elemental enchantments, backstabbing and so much more. There are so many ways to push your power even further.",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"So you're saying to not limit myself to Daggers?",false)
            call Text_Say(udg_NpcUnit[8],"Exactly. Make no mistake, a Ninja wielding Daggers is a force to be reckoned with in its own right. But your versatility in achieving your goal is your strength. Don't underestimate it.",false)
            call Text_Say(udg_NpcUnit[8],"Oh and if you really love taking risks, remember to use a Steel Gorget. There is nothing sweeter than feeling its power activate as you dance around the battlefield in a Trance.",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"Very true. Thanks, Miss Dana.",false)
            call Cine_ExitAction()
        endif
    else
        if(Trig_Legend_Ninja_Talk_Cond_CinematicsOnTask())then
            call Cine_Enter()
            call Cam_PanToUnit(GetTriggerUnit(),0)
            call Text_Say(udg_NpcUnit[8],"Greetings again. You wish to ascend to Legendary Ninja yourself, I take it?",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"Most definitely. What do I need to do?",false)
            call Text_Say(udg_NpcUnit[8],"Recall what I told you before - there's no need to limit yourself to one path. With that in mind, the task before you is a brutally simplistic one.",false)
            call Text_Say(udg_NpcUnit[8],"Simply achieve a DPS rating of over 99999 while fighting for at least 5 seconds. Whatever weapons, whatever methods, whatever you choose, it's all up to you. Be as effective as you can be. The means towards that end are all up to you.",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"DPS of over 99999 in a fight of at least 5 seconds. No further instructions. That's a very broad goal indeed.",false)
            call Text_Say(udg_NpcUnit[8],"As is the very essence of fighting towards an end. Don't let yourself get bogged down by self-imposed rules. Just keep looking towards your goal.",false)
            call Cine_ExitAction()
        endif
    endif
    call StartTimerBJ(udg_UnitUpdateTimer,false,1.)
endfunction

function InitTrig_Legend_Ninja takes nothing returns nothing
endfunction

endlibrary
