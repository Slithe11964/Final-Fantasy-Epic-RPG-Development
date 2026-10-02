library TLegendSorcerer requires TCam, TCine, TForce, TPlayerPart01, TText, TUnit
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Legend_Sorcerer_Talk=null
endglobals

function Trig_Legend_Sorcerer_Talk_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,udg_NpcUnit[19],true,true,true))
endfunction

function Trig_Legend_Sorcerer_Talk_Cond_WrongJobOrLevel takes nothing returns boolean
    return(GetUnitTypeId(Player_GetHero(GetTriggerPlayer()))!=udg_JobUnitType[udg_TempInteger])or(GetHeroLevel(Player_GetHero(GetTriggerPlayer()))<99)
endfunction

function Trig_Legend_Sorcerer_Talk_Cond_TaskLocked takes nothing returns boolean
    return(udg_QuestStage[udg_TempInteger]>=2)and(Trig_Legend_Sorcerer_Talk_Cond_WrongJobOrLevel())
endfunction

function Trig_Legend_Sorcerer_Talk_Cond_CinematicsOnTask takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Legend_Sorcerer_Talk_Cond_MetHugoFact takes nothing returns boolean
    return(udg_MateusDefeated)
endfunction

function Trig_Legend_Sorcerer_Talk_Cond_KnowsHugoAlias takes nothing returns boolean
    return(udg_MateusDefeated)
endfunction

function Trig_Legend_Sorcerer_Talk_Cond_CinematicsOnIntro takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Legend_Sorcerer_Talk_Cond_FirstVisit takes nothing returns boolean
    return(udg_QuestStage[udg_TempInteger]==2)
endfunction

function Trig_Legend_Sorcerer_Talk_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    set udg_TempInteger=19
    if(Trig_Legend_Sorcerer_Talk_Cond_TaskLocked())then
        set udg_TempForce=Force_OfPlayer(GetTriggerPlayer())
        call DisplayTimedTextToForce(udg_TempForce,15.,((GetHeroProperName(GetTriggerUnit())+": You need to be |cffffcc00Ultimate Master ")+(udg_JobName[udg_TempInteger]+"|r to take on my task.")))
        call DestroyForce(udg_TempForce)
        return
    endif
    call DestroyEffectBJ(udg_LegendMarker[udg_TempInteger])
    set udg_QuestStage[udg_TempInteger]=(udg_QuestStage[udg_TempInteger]+1)
    if(Trig_Legend_Sorcerer_Talk_Cond_FirstVisit())then
        if(Trig_Legend_Sorcerer_Talk_Cond_CinematicsOnIntro())then
            call Cine_Enter()
            call Cam_PanToUnit(GetTriggerUnit(),0)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"You must be the Legendary Sorcerer.",false)
            if(Trig_Legend_Sorcerer_Talk_Cond_MetHugoFact())then
                call Text_Say(Player_GetHero(GetTriggerPlayer()),"You look kind of familiar...",false)
                call Text_Say(udg_NpcUnit[19],"It's not surprising. You may have met me before.",false)
            endif
            call Text_Say(udg_NpcUnit[19],"Well met, adventurers. My name is Hugo Fact, and my home world is no other than this here plane itself, Gaya.",false)
            call Text_Say(udg_NpcUnit[19],"I was once a promising young Sorcerer, heir to the Fact family line. But I ended up sacrificing most of my powers and even yet untapped talent to seal away my father, Cain Fact, who had grown drunk on Dark powers.",false)
            call Text_Say(udg_NpcUnit[19],"The powers I used that day are long gone, but they live on in this Elysium as me, the manifestation of the Legendary Sorcerer that could have been, Hugo Fact.",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"I see, so even theoretical existences from the past can end up here.",false)
            call Text_Say(udg_NpcUnit[19],"Indeed. And the real Hugo Fact is still alive as well.",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"Wow this gets real confusing.",false)
            if(Trig_Legend_Sorcerer_Talk_Cond_KnowsHugoAlias())then
                call Text_Transmission(Player_GetHero(GetTriggerPlayer()),udg_PlayerName[GetConvertedPlayerId(GetTriggerPlayer())],"Wow this gets real confusing.\r\nWait, now I remember.","Wow this gets real confusing.",null,0,false)
                call Text_Transmission(Player_GetHero(GetTriggerPlayer()),udg_PlayerName[GetConvertedPlayerId(GetTriggerPlayer())],"Wow this gets real confusing.\r\nWait, now I remember.\r\nYou look exactly like the Zodiac Brave of Ice, Mateus!","Wow this gets real confusing.\r\nWait, now I remember.",null,0,false)
                call Text_Say(udg_NpcUnit[19],"You're quite right. That is the name the real me now goes by. Are you surprised?",false)
                call Text_Say(Player_GetHero(GetTriggerPlayer()),"I don't know what to think. I never expected to find so many links to the Zodiac Braves here.",false)
            endif
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"Still, regardless, you are here as the Legendary Sorcerer. Your powers must have been incredible at their height.",false)
            call Text_Say(udg_NpcUnit[19],"The Fact family has always produced mages of incredible powers. And we also create wands capable of wielding all our inner mana. Perhaps you need one yourself.",false)
            call Text_Say(udg_NpcUnit[19],"But we only passed them down by hand. You won't just find them laying around.",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"So I'd have to pry them from the real you's dead body, would I?",false)
            call Text_Say(udg_NpcUnit[19],"No, even the real me no longer has any of our artifact wands. The last and most powerful we ever made was wielded by my father and is now sealed away alongside him.",false)
            call Text_Say(udg_NpcUnit[19],"Still, as important as a strong wand is, the Sorcerers' real power lies in versatility. You can benefit a lot from broadening your abilities instead of specializing too hard.",false)
            call Text_Say(udg_NpcUnit[19],"Remember that you also carry quite a bit of power to debilitate enemies with you. Sleeping and Crippling enemies can leave otherwise daunting groups of enemies very helpless. Even when it's tempting to break Sleep for a huge hit, you may very well be better off just keeping an enemy disabled. Keep that in mind.",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"I will, thanks.",false)
            call Cine_ExitAction()
        endif
    else
        if(Trig_Legend_Sorcerer_Talk_Cond_CinematicsOnTask())then
            call Cine_Enter()
            call Cam_PanToUnit(GetTriggerUnit(),0)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"Well, we've returned.",false)
            call Text_Say(udg_NpcUnit[19],"So you want to ascend beyond your current limitations, do you? Certainly I can give you a task.",false)
            call Text_Say(udg_NpcUnit[19],"As a trained Sorcerer by now I'm sure you're aware that your capacity for burst damage is truly fearsome. Single instant hits, not giving the enemy any room to breathe.",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"The innate skills do seem geared towards that.",false)
            call Text_Say(udg_NpcUnit[19],"Indeed, it's far from your only option as Sorcerer of course. But at the very least I would have you show me you've mastered this aspect yourself.",false)
            call Text_Say(udg_NpcUnit[19],"So here's what I'll have you do: Find an enemy with 30000 HP or higher, and put them to Sleep. Make any last preparations and then assault them all at once with your strongest spells and abilities to kill them instantly after awakening them. We'll have the goal be to have them dead less than half a second after hitting them out of their Sleep. In that short timespan, kill them.",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"That's... a bit complicated. But the crucial points are - enemy with 30000 HP or more put to Sleep. Then, kill them in less than half a second of waking them up?",false)
            call Text_Say(udg_NpcUnit[19],"Precisely. With a good selection of spells this should be no trouble at all. You need only get the timing right.",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"Alright, it does sound manageable. We'll get it done.",false)
            call Cine_ExitAction()
        endif
    endif
    call StartTimerBJ(udg_UnitUpdateTimer,false,1.)
endfunction

function InitTrig_Legend_Sorcerer takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Legend (module Legend),
// which keeps the original registration order.

function Register_Legend_Sorcerer_Talk takes nothing returns nothing
    set gg_trg_Legend_Sorcerer_Talk=CreateTrigger()
    call DisableTrigger(gg_trg_Legend_Sorcerer_Talk)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Sorcerer_Talk,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Sorcerer_Talk,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Sorcerer_Talk,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Sorcerer_Talk,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Sorcerer_Talk,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Sorcerer_Talk,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Sorcerer_Talk,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Sorcerer_Talk,Player(7),true)
    call TriggerAddCondition(gg_trg_Legend_Sorcerer_Talk,Condition(function Trig_Legend_Sorcerer_Talk_Conditions))
    call TriggerAddAction(gg_trg_Legend_Sorcerer_Talk,function Trig_Legend_Sorcerer_Talk_Actions)
endfunction

endlibrary
