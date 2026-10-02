library TLegendDarkKnight requires TCam, TCine, TForce, TJob, TPlayerPart01, TText, TUnit
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Legend_DarkKnight_Talk=null
endglobals

function Trig_Legend_DarkKnight_Talk_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,udg_NpcUnit[20],true,true,true))
endfunction

function Trig_Legend_DarkKnight_Talk_Cond_WrongJobOrLevel takes nothing returns boolean
    return(GetUnitTypeId(Player_GetHero(GetTriggerPlayer()))!=udg_JobUnitType[udg_TempInteger])or(GetHeroLevel(Player_GetHero(GetTriggerPlayer()))<99)
endfunction

function Trig_Legend_DarkKnight_Talk_Cond_TaskLocked takes nothing returns boolean
    return(udg_QuestStage[udg_TempInteger]>=2)and(Trig_Legend_DarkKnight_Talk_Cond_WrongJobOrLevel())
endfunction

function Trig_Legend_DarkKnight_Talk_Cond_CinematicsOnTask takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Legend_DarkKnight_Talk_Cond_PlayerIsDarkKnight takes nothing returns boolean
    return(Job_GetSavedLevel(GetTriggerPlayer(),'H02X')>0) // 'H02X': unit "Dark Knight"
endfunction

function Trig_Legend_DarkKnight_Talk_Cond_HolySwordLegendMet takes nothing returns boolean
    return(udg_QuestStage[9]>=2)
endfunction

function Trig_Legend_DarkKnight_Talk_Cond_CinematicsOnIntro takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Legend_DarkKnight_Talk_Cond_FirstVisit takes nothing returns boolean
    return(udg_QuestStage[udg_TempInteger]==2)
endfunction

function Trig_Legend_DarkKnight_Talk_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    set udg_TempInteger=20
    if(Trig_Legend_DarkKnight_Talk_Cond_TaskLocked())then
        set udg_TempForce=Force_OfPlayer(GetTriggerPlayer())
        call DisplayTimedTextToForce(udg_TempForce,15.,((GetHeroProperName(GetTriggerUnit())+": You need to be |cffffcc00Ultimate Master ")+(udg_JobName[udg_TempInteger]+"|r to take on my task.")))
        call DestroyForce(udg_TempForce)
        return
    endif
    call DestroyEffectBJ(udg_LegendMarker[udg_TempInteger])
    set udg_QuestStage[udg_TempInteger]=(udg_QuestStage[udg_TempInteger]+1)
    if(Trig_Legend_DarkKnight_Talk_Cond_FirstVisit())then
        if(Trig_Legend_DarkKnight_Talk_Cond_CinematicsOnIntro())then
            call Cine_Enter()
            call Cam_PanToUnit(GetTriggerUnit(),0)
            call Text_Say(udg_NpcUnit[20],"Good day, adventurers. I am Cecil, here in Elysium as the representative Legendary Dark Knight.",false)
            if(Trig_Legend_DarkKnight_Talk_Cond_HolySwordLegendMet())then
                call Text_Say(Player_GetHero(GetTriggerPlayer()),"Good day... wait, Cecil? That's the same name as the Holy Swordsman just next to you.",false)
                call Text_Say(udg_NpcUnit[9],"Yes, we're both the same Cecil. Though I am older than that me by a few years.",false)
                call Text_Say(Player_GetHero(GetTriggerPlayer()),"Okay now that's just surreal. There can even be two of the same person at once here, from different periods of their life?",false)
                call Text_Say(udg_NpcUnit[20],"I am but a snapshot of Cecil as a powerful Dark Knight. I do not know the path of future me... but I admit I am glad to see this future version of myself.",false)
                call Text_Say(udg_NpcUnit[9],"It's a long story. Just know that ultimately, you have more than one road to follow. You can choose to embrace light, or darkness.",false)
                call Text_Say(Player_GetHero(GetTriggerPlayer()),"You went from being the Legendary Dark Knight to being the Legendary Holy Swordsman of all things... that's quite a job change.",false)
                if(Trig_Legend_DarkKnight_Talk_Cond_PlayerIsDarkKnight())then
                    call Text_Say(udg_NpcUnit[9],"You went from Holy Swordsman to Dark Knight yourself, did you not? Do not mistake the color of the arts you employ to be the color of your own self. It's what you use your skills for that determines who you are.",false)
                else
                    call Text_Say(udg_NpcUnit[9],"It's not that black and white. Do not mistake the color of the arts you employ to be the color of your own self. It's what you use your skills for that determines who you are.",false)
                endif
                call Text_Say(udg_NpcUnit[20],"Well now, apologies for our rambling. Let us return to the matter at hand.",false)
            else
                call Text_Say(Player_GetHero(GetTriggerPlayer()),"Good day. Your skills as a Dark Knight must be most impressive then. Mind sharing some advice?",false)
            endif
            call Text_Say(udg_NpcUnit[20],"As Dark Knight, your resilience is next to no one else's. To truly excel you need to take control of death itself. Even if you toy with the line dividing life and death, you can deal with it.",false)
            call Text_Say(udg_NpcUnit[20],"You are well equipped to make good use of effects such as Adrenaline or Last Stand. Even Spellbreaker will easily activate and make your Darkness spell a formidable force to be reckoned with.",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"During Dark Power I can see that, but you think the same for outside of it?",false)
            call Text_Say(udg_NpcUnit[20],"Dark Power is your trump card. You still have powerful regeneration and draining attacks that works in tandem with a skill that grows in power as you get closer to death. Still, do not hesitate to make use of Dark Power liberally; it does not cost any MP to activate after all and will quickly restore enough to make use of your other skills.",false)
            call Text_Say(udg_NpcUnit[20],"More than anything, remember that you are not an Undead. You are a Swordfighter playing with life and death. Consider you can even make use of something like the Armor Breaker skill and more easily drain life from foes. Or you could use a powerful Holy spell as well. Your offense and defense go hand in hand. So long as you keep up with your enemy on one, you will keep up on the other.",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"There's many possible approaches I see... thanks.",false)
            call Cine_ExitAction()
        endif
    else
        if(Trig_Legend_DarkKnight_Talk_Cond_CinematicsOnTask())then
            call Cine_Enter()
            call Cam_PanToUnit(GetTriggerUnit(),0)
            call Text_Say(udg_NpcUnit[20],"Good day once more. I believe you have come to receive a task for your ascension?",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"Exactly. What kind of task do you have to propose to attain the title of Legendary Dark Knight?",false)
            call Text_Say(udg_NpcUnit[20],"I have for you a rather straightforward task. Nonetheless, it strikes close to the heart of being a Dark Knight. It should do fine to put your skills to a test.",false)
            call Text_Say(udg_NpcUnit[20],"I want you to use Drain Attack to recover over 30'000 HP in a single strike. That is all.",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"Draining over 30'000 HP in one strike... I see what you mean. Of course it's not hard to guess what it is you want me to do to achieve this.",false)
            call Text_Say(udg_NpcUnit[20],"I would think not. Nonetheless, you are free to tackle this problem however you wish. Good luck to you.",false)
            call Cine_ExitAction()
        endif
    endif
    call StartTimerBJ(udg_UnitUpdateTimer,false,1.)
endfunction

function InitTrig_Legend_DarkKnight takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Legend (module Legend),
// which keeps the original registration order.

function Register_Legend_DarkKnight_Talk takes nothing returns nothing
    set gg_trg_Legend_DarkKnight_Talk=CreateTrigger()
    call DisableTrigger(gg_trg_Legend_DarkKnight_Talk)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_DarkKnight_Talk,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_DarkKnight_Talk,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_DarkKnight_Talk,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_DarkKnight_Talk,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_DarkKnight_Talk,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_DarkKnight_Talk,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_DarkKnight_Talk,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_DarkKnight_Talk,Player(7),true)
    call TriggerAddCondition(gg_trg_Legend_DarkKnight_Talk,Condition(function Trig_Legend_DarkKnight_Talk_Conditions))
    call TriggerAddAction(gg_trg_Legend_DarkKnight_Talk,function Trig_Legend_DarkKnight_Talk_Actions)
endfunction

endlibrary
