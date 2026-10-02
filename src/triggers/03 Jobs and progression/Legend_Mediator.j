library TLegendMediator requires TCam, TCine, TForce, TPlayerPart01, TText, TUnit
function Trig_Legend_Mediator_Talk_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,udg_NpcUnit[$F],true,true,true)) // $F = 15
endfunction

function Trig_Legend_Mediator_Talk_Cond_WrongJobOrLevel takes nothing returns boolean
    return(GetUnitTypeId(Player_GetHero(GetTriggerPlayer()))!=udg_JobUnitType[udg_TempInteger])or(GetHeroLevel(Player_GetHero(GetTriggerPlayer()))<99)
endfunction

function Trig_Legend_Mediator_Talk_Cond_TaskLocked takes nothing returns boolean
    return(udg_QuestStage[udg_TempInteger]>=2)and(Trig_Legend_Mediator_Talk_Cond_WrongJobOrLevel())
endfunction

function Trig_Legend_Mediator_Talk_Cond_CinematicsOnTask takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Legend_Mediator_Talk_Cond_ForgeAlberichMet takes nothing returns boolean
    return(udg_KalmTechLevel==1)or(udg_KalmTechLevel>=3)
endfunction

function Trig_Legend_Mediator_Talk_Cond_KnowsAlberich takes nothing returns boolean
    return(Trig_Legend_Mediator_Talk_Cond_ForgeAlberichMet())
endfunction

function Trig_Legend_Mediator_Talk_Cond_CinematicsOnIntro takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Legend_Mediator_Talk_Cond_FirstVisit takes nothing returns boolean
    return(udg_QuestStage[udg_TempInteger]==2)
endfunction

function Trig_Legend_Mediator_Talk_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    set udg_TempInteger=$F // $F = 15
    if(Trig_Legend_Mediator_Talk_Cond_TaskLocked())then
        set udg_TempForce=Force_OfPlayer(GetTriggerPlayer())
        call DisplayTimedTextToForce(udg_TempForce,15.,((GetHeroProperName(GetTriggerUnit())+": You need to be |cffffcc00Ultimate Master ")+(udg_JobName[udg_TempInteger]+"|r to take on my task.")))
        call DestroyForce(udg_TempForce)
        return
    endif
    call DestroyEffectBJ(udg_LegendMarker[udg_TempInteger])
    set udg_QuestStage[udg_TempInteger]=(udg_QuestStage[udg_TempInteger]+1)
    if(Trig_Legend_Mediator_Talk_Cond_FirstVisit())then
        if(Trig_Legend_Mediator_Talk_Cond_CinematicsOnIntro())then
            call Cine_Enter()
            call Cam_PanToUnit(GetTriggerUnit(),0)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"You are the Legendary Mediator, correct?",false)
            call Text_Say(udg_NpcUnit[$F],"Lali-ho, adventurers. Indeed that would be me, Alberich.",false) // $F = 15
            if(Trig_Legend_Mediator_Talk_Cond_KnowsAlberich())then
                call Text_Say(Player_GetHero(GetTriggerPlayer()),"Wait, I know you. You're one of the dwarves at the Barrens forge!",false)
                call Text_Say(udg_NpcUnit[$F],"That would be the current me, yes. But his time as the Legendary Mediator is long since past. I no longer have the accuracy or taming skills I once had. This me is but the preservation of who I was at my peak. That's the kind of place this is.",false) // $F = 15
                call Text_Say(Player_GetHero(GetTriggerPlayer()),"I see... so you retired, essentially.",false)
            endif
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"Hmm, well you surely have some advice to share, no?",false)
            call Text_Say(udg_NpcUnit[$F],"Certainly. The Mediator is quite unlike all other classes you could choose, really. You can be the most versatile of them all who breaks through any defense. Or you could be nothing but grossly ineffective. It comes down to your taming and combination skills.",false) // $F = 15
            call Text_Say(udg_NpcUnit[$F],"At your core you are nothing but a simple mage stretching himself thin. But choose the right monsters to tame and you can raise a powerful army. The key lies in your Spell Shot.",false) // $F = 15
            call Text_Say(udg_NpcUnit[$F],"Tame monsters with powerful buffs and your Spell Shot can propagate them very fast while also keeping your newfound temporary allies in good shape. Don't forget that if they need healing you can always quickly cast a Balance spell on them just before healing them as well. Also use your Clone spell wisely to keep enemy attacks off more important targets.",false) // $F = 15
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"The Invitation spell does appear to be the core of making things click into place. How do I know which enemies to recruit?",false)
            call Text_Say(udg_NpcUnit[$F],"You are adventurous are you not? You can figure it out simply by trying and seeing what works. But in general keep your army balanced. You cannot Spell Shot yourself, so make sure to have a tank in front, a hopefully wide array of buffers to keep your army powered up, and as many ranged attackers as you can fit behind your front line.",false) // $F = 15
            call Text_Say(udg_NpcUnit[$F],"One more piece of advice. You may be a mage, but as a Mediator you are not particularly reliant on your Intelligence stat, as only your Spell Shot truly relies on it. You can equip yourself with far more gunshot focused or armor focused gear and may end up more effective for it.",false) // $F = 15
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"That's a good point. Thanks and lali-ho, Alberich.",false)
            call Cine_ExitAction()
        endif
    else
        if(Trig_Legend_Mediator_Talk_Cond_CinematicsOnTask())then
            call Cine_Enter()
            call Cam_PanToUnit(GetTriggerUnit(),0)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"Lali-ho again, Alberich. We're prepared to take on whatever task you may have for us.",false)
            call Text_Say(udg_NpcUnit[$F],"You wish to earn the title of Legendary Master do you. Well my task for you is a very simple one that puts your experimentation to the test.",false) // $F = 15
            call Text_Say(udg_NpcUnit[$F],"Simply use your Spell Shot to propagate no fewer than 6 buffs to a target ally. That is all.",false) // $F = 15
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"I see. A simple but effective task requiring a bit of knowledge of your options. I like it.",false)
            call Text_Say(udg_NpcUnit[$F],"I'm sure it won't be very difficult for you. Still, good luck and never stop learning.",false) // $F = 15
            call Cine_ExitAction()
        endif
    endif
    call StartTimerBJ(udg_UnitUpdateTimer,false,1.)
endfunction

function InitTrig_Legend_Mediator takes nothing returns nothing
endfunction

endlibrary
