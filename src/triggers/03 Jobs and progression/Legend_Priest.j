library TLegendPriest requires TCam, TCine, TForce, TPlayerPart01, TText, TUnit
function Trig_Legend_Priest_Talk_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,udg_NpcUnit[$C],true,true,true)) // $C = 12
endfunction

function Trig_Legend_Priest_Talk_Cond_WrongJobOrLevel takes nothing returns boolean
    return(GetUnitTypeId(Player_GetHero(GetTriggerPlayer()))!=udg_JobUnitType[udg_TempInteger])or(GetHeroLevel(Player_GetHero(GetTriggerPlayer()))<99)
endfunction

function Trig_Legend_Priest_Talk_Cond_TaskLocked takes nothing returns boolean
    return(udg_QuestStage[udg_TempInteger]>=2)and(Trig_Legend_Priest_Talk_Cond_WrongJobOrLevel())
endfunction

function Trig_Legend_Priest_Talk_Cond_CinematicsOnTask takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Legend_Priest_Talk_Cond_KnowsExodus takes nothing returns boolean
    return(udg_ExodusQuestStage>=6)
endfunction

function Trig_Legend_Priest_Talk_Cond_KnowsExodusReply takes nothing returns boolean
    return(udg_ExodusQuestStage>=6)
endfunction

function Trig_Legend_Priest_Talk_Cond_CinematicsOnIntro takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Legend_Priest_Talk_Cond_FirstVisit takes nothing returns boolean
    return(udg_QuestStage[udg_TempInteger]==2)
endfunction

function Trig_Legend_Priest_Talk_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    set udg_TempInteger=$C // $C = 12
    if(Trig_Legend_Priest_Talk_Cond_TaskLocked())then
        set udg_TempForce=Force_OfPlayer(GetTriggerPlayer())
        call DisplayTimedTextToForce(udg_TempForce,15.,((GetHeroProperName(GetTriggerUnit())+": You need to be |cffffcc00Ultimate Master ")+(udg_JobName[udg_TempInteger]+"|r to take on my task.")))
        call DestroyForce(udg_TempForce)
        return
    endif
    call DestroyEffectBJ(udg_LegendMarker[udg_TempInteger])
    set udg_QuestStage[udg_TempInteger]=(udg_QuestStage[udg_TempInteger]+1)
    if(Trig_Legend_Priest_Talk_Cond_FirstVisit())then
        if(Trig_Legend_Priest_Talk_Cond_CinematicsOnIntro())then
            call Cine_Enter()
            call Cam_PanToUnit(GetTriggerUnit(),0)
            call Text_Say(udg_NpcUnit[$C],"Greetings to you, fledgling Priests. My name is Minwu, and I am here as the Legendary Priest.",false) // $C = 12
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"Minwu, is it? I haven't heard of you before. Were you a high elf?",false)
            call Text_Say(udg_NpcUnit[$C],"No, I was a Priest of the Galbados Church when it was still the major power in this world. It has been over a century since then, so I am not surprised if you never heard of me. However, my junior maester, Exodus, should still be around.",false) // $C = 12
            if(Trig_Legend_Priest_Talk_Cond_KnowsExodus())then
                call Text_Say(Player_GetHero(GetTriggerPlayer()),"Exodus!? Yeah that name does ring a bell, but ... no it must be a coincidence.",false)
            endif
            call Text_Say(udg_NpcUnit[$C],"There's more to being a Priest than simply healing and protecting. We priests of the church had a duty on us to bring peace to the minds and hearts of the people. I taught him to always do the same.",false) // $C = 12
            if(Trig_Legend_Priest_Talk_Cond_KnowsExodusReply())then
                call Text_Say(Player_GetHero(GetTriggerPlayer()),"Okay, certainly a coincidence then. Maybe that demon simply took on the name of a reknown Priest to fool those farmers then... what a despicable being.",false)
            endif
            call Text_Say(udg_NpcUnit[$C],"But enough talk about my previous junior. I'm afraid in this form in Elysium I won't be able to take on any new disciples.",false) // $C = 12
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"No, no, I'm an adventurer. I'm not looking to join some kind of clergy.",false)
            call Text_Say(udg_NpcUnit[$C],"Oh is that so? Such a shame. But I can see where you're coming from, doubtlessly the powers of a Priest can be most useful for an adventurer.",false) // $C = 12
            call Text_Say(udg_NpcUnit[$C],"But alone you won't be doing much as a Priest. Your job is not to stand on the front lines, it's to enable your more powerful allies to do their own jobs without the threat of death looming over them.",false) // $C = 12
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"I understand that. Not a single offensive skill makes taking down enemies yourself an arduous task. Well, except for casting Cure on the undead perhaps.",false)
            call Text_Say(udg_NpcUnit[$C],"Indeed, you can Cure the undead. But a lot of undead are also very resistant to magic in general, so it may turn out less effective than you would hope. If there is one particularly dangerous thing about this it's when you face enemies that use the Zombie ailment on you.",false) // $C = 12
            call Text_Say(udg_NpcUnit[$C],"Zombified allies will take damage when you cure them, so always be careful and make sure to cast Esuna first. Then you can heal them as normal. Similarly, Disease will also get in the way of your healing, and it can be tricky since you won't even realize your allies are close to dying unless you pay close attention.",false) // $C = 12
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"I see, yes. I'll make sure to watch out for that.",false)
            call Text_Say(udg_NpcUnit[$C],"That's all for now. Good luck on your journeys.",false) // $C = 12
            call Cine_ExitAction()
        endif
    else
        if(Trig_Legend_Priest_Talk_Cond_CinematicsOnTask())then
            call Cine_Enter()
            call Cam_PanToUnit(GetTriggerUnit(),0)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"Alright Minwu. We need to clear a task of yours to be able to ascend. What have you got for us?",false)
            call Text_Say(udg_NpcUnit[$C],"A task to prove yourself worthy of the title of Legendary Priest... well, the Priest remains a rather straightforward class in direct combat. But there is one special skill that only the best Priests can do right - and that is properly using the Cure spell.",false) // $C = 12
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"Properly using the Cure spell? What do you mean?",false)
            call Text_Say(udg_NpcUnit[$C],"As I'm sure you're aware, the Cure spell is not merely a spell to heal a target. It is not the same as Curaga. The spell sends out an orb that flies towards your target and will hit units on its path as well. Using this well, you can heal a lot more HP with every single cast than you would otherwise.",false) // $C = 12
            call Text_Say(udg_NpcUnit[$C],"To show your proficiency with this spell, my task for you is this: heal over 50'000 HP in total with a single usage of Cure.",false) // $C = 12
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"Over 50'000!? That's a lot.",false)
            call Text_Say(udg_NpcUnit[$C],"It is, but you'll be able to do it if you do as I told you. To keep this reasonable as well, it does not matter if the targets you heal with your spell are not actually hurt enough to add up to 50'000. Even if they are fully healed, so long as they are hit by the orb, the HP they would be healed for counts.",false) // $C = 12
            call Text_Say(udg_NpcUnit[$C],"Of course, don't forget to use a powerful Staff. Life spells depend on it. The rest is up to you.",false) // $C = 12
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"Alright. I'll find a way to accomplish this goal.",false)
            call Cine_ExitAction()
        endif
    endif
    call StartTimerBJ(udg_UnitUpdateTimer,false,1.)
endfunction

function InitTrig_Legend_Priest takes nothing returns nothing
endfunction

endlibrary
