library TLegendKnight requires TCam, TCine, TForce, TPlayerPart01, TText, TUnit
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Legend_Knight_Talk=null
endglobals

function Trig_Legend_Knight_Talk_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,udg_NpcUnit[1],true,true,true))
endfunction

function Trig_Legend_Knight_Talk_Cond_WrongJobOrLevel takes nothing returns boolean
    return(GetUnitTypeId(Player_GetHero(GetTriggerPlayer()))!=udg_JobUnitType[udg_TempInteger])or(GetHeroLevel(Player_GetHero(GetTriggerPlayer()))<99)
endfunction

function Trig_Legend_Knight_Talk_Cond_TaskLocked takes nothing returns boolean
    return(udg_QuestStage[udg_TempInteger]>=2)and(Trig_Legend_Knight_Talk_Cond_WrongJobOrLevel())
endfunction

function Trig_Legend_Knight_Talk_Cond_CinematicsOnTask takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Legend_Knight_Talk_Cond_MetSiegfried takes nothing returns boolean
    return(IsQuestDiscovered(udg_SideQuest[70]))
endfunction

function Trig_Legend_Knight_Talk_Cond_CinematicsOnIntro takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Legend_Knight_Talk_Cond_FirstVisit takes nothing returns boolean
    return(udg_QuestStage[udg_TempInteger]==2)
endfunction

function Trig_Legend_Knight_Talk_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    set udg_TempInteger=1
    if(Trig_Legend_Knight_Talk_Cond_TaskLocked())then
        set udg_TempForce=Force_OfPlayer(GetTriggerPlayer())
        call DisplayTimedTextToForce(udg_TempForce,15.,((GetHeroProperName(GetTriggerUnit())+": You need to be |cffffcc00Ultimate Master ")+(udg_JobName[udg_TempInteger]+"|r to take on my task.")))
        call DestroyForce(udg_TempForce)
        return
    endif
    call DestroyEffectBJ(udg_LegendMarker[udg_TempInteger])
    set udg_QuestStage[udg_TempInteger]=(udg_QuestStage[udg_TempInteger]+1)
    if(Trig_Legend_Knight_Talk_Cond_FirstVisit())then
        if(Trig_Legend_Knight_Talk_Cond_CinematicsOnIntro())then
            call Cine_Enter()
            call Cam_PanToUnit(GetTriggerUnit(),0)
            call Text_Say(udg_NpcUnit[1],"Ah you must be the adventurers. So you've come to me.",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"You are the Legendary Knight, I presume?",false)
            call Text_Say(udg_NpcUnit[1],"You presume correctly. Siegfried is my name and I was granted this prestigious title a long time ago.",false)
            if(Trig_Legend_Knight_Talk_Cond_MetSiegfried())then
                call Text_Say(Player_GetHero(GetTriggerPlayer()),"Siegfried... I've met you, actually. You can be very intimidating.",false)
                call Text_Say(udg_NpcUnit[1],"Well I did ascend to the position of divine knight. I do not know what has transpired between the real me and you, but I know I do not take my duties lightly.",false)
                call Text_Say(Player_GetHero(GetTriggerPlayer()),"I guess the 'you' here wouldn't know. Well better use this opportunity still.",false)
            endif
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"Is there any wisdom or advice you would have to share as the Legendary Knight for matching up to your level?",false)
            call Text_Say(udg_NpcUnit[1],"But of course. A good Knight brings a strong balance of both offense and defense. The core thing to remember, however, is that the role you excel at the most is that of a supporter.",false)
            call Text_Say(udg_NpcUnit[1],"Breaking enemy armor, giving a protective and vengeful shield, opening the enemy up to being hit by powerful techniques, and of course giving an Assault Command; you yourself are of course a force to be reckoned with yourself, but all of these skills work just as well on companions as yourself, if not even better.",false)
            call Text_Say(udg_NpcUnit[1],"There is no better class to support an even stronger technique user than a Knight. You will be better off if you don't merely try to hog the glory. You are a Knight, remember this well.",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"You are right, of course. Knight skills work just as well in a supporting role as in a primary front line fighter role.",false)
            call Text_Say(udg_NpcUnit[1],"Very much. Also, don't underestimate the value of a good shield. A proper Knight can block magic even using just a physical shield, and during the Revenge period of your Runic Shield, the more opportunity you have to block enemy attacks the better. A good defense begets a good offense.",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"Wise words indeed. Thanks.",false)
            call Cine_ExitAction()
        endif
    else
        if(Trig_Legend_Knight_Talk_Cond_CinematicsOnTask())then
            call Cine_Enter()
            call Cam_PanToUnit(GetTriggerUnit(),0)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"We've returned. Do you have a task for us?",false)
            call Text_Say(udg_NpcUnit[1],"Of course. I already made clear how well a Knight can support others just as well as himself. But even a Knight alone should be a force to be reckoned with. I will test your capabilities in this matter.",false)
            call Text_Say(udg_NpcUnit[1],"The task is simple: first, use Armor Breaker to break an enemy's armor completely. As I'm sure you're aware, this will incapacitate the enemy for 4 seconds.",false)
            call Text_Say(udg_NpcUnit[1],"Within these 4 seconds, I want you to deal no less than 200'000 damage. Any means will do. It doesn't all have to be just on the target you broke the armor of either. But I want you to hit as hard as you can, within that very short timeframe.",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"That's not going to be easy. Let me go over this again. Break an enemy's armor and stun them for 4 seconds, then within those four seconds, deal a total of 200'000 damage?",false)
            call Text_Say(udg_NpcUnit[1],"Exactly that. It's not trivial but as a proper Knight you should be able to pull your weight at least this much. You can't be falling too far behind your allies now, can you?",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"Well I've no intention of being a dead weight. I'll get this done and prove to you I'm a worthy Knight myself.",false)
            call Text_Say(udg_NpcUnit[1],"That's what I want to hear. Godspeed to you.",false)
            call Cine_ExitAction()
        endif
    endif
    call StartTimerBJ(udg_UnitUpdateTimer,false,1.)
endfunction

function InitTrig_Legend_Knight takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Legend (module Legend),
// which keeps the original registration order.

function Register_Legend_Knight_Talk takes nothing returns nothing
    set gg_trg_Legend_Knight_Talk=CreateTrigger()
    call DisableTrigger(gg_trg_Legend_Knight_Talk)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Knight_Talk,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Knight_Talk,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Knight_Talk,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Knight_Talk,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Knight_Talk,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Knight_Talk,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Knight_Talk,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Knight_Talk,Player(7),true)
    call TriggerAddCondition(gg_trg_Legend_Knight_Talk,Condition(function Trig_Legend_Knight_Talk_Conditions))
    call TriggerAddAction(gg_trg_Legend_Knight_Talk,function Trig_Legend_Knight_Talk_Actions)
endfunction

endlibrary
