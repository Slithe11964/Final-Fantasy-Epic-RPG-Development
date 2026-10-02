library TLegendFreelancer requires TCam, TCine, TPlayerPart01, TText, TUnit
function Trig_Legend_Freelancer_Talk_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,udg_NpcUnit[22],true,true,true))
endfunction

function Trig_Legend_Freelancer_Talk_Cond_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Legend_Freelancer_Talk_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_LegendMarker[22])
    set udg_QuestStage[24]=2
    if(Trig_Legend_Freelancer_Talk_Cond_CinematicsEnabled())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(gg_unit_H00O_0259,"So then. Do you wish to hear about achieving Legendary Mastery as a Freelancer?",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"It's about time, isn't it?",false)
        call Text_Say(gg_unit_H00O_0259,"Very much so. But there is not much to add. The Freelancer is the culmination of all your hard work in mastering every other job in existence.",false)
        call Text_Say(gg_unit_H00O_0259,"I could have you maintain some high state of Momentum, but it would be a mere formality. Let's leave those by the wayside.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"So then what?",false)
        call Text_Say(gg_unit_H00O_0259,"Showing your Legendary Mastery in every single job is good enough for me. A Legendary Master in every job is worthy of being a Legendary Master Freelancer. That is all. Complete the ritual one last time, and you'll be all finished.",false)
        call Cine_ExitAction()
    endif
    call StartTimerBJ(udg_UnitUpdateTimer,false,1.)
endfunction

function InitTrig_Legend_Freelancer takes nothing returns nothing
endfunction

endlibrary
