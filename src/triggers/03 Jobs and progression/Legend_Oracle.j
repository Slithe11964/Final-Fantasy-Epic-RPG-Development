library TLegendOracle requires TCam, TCine, TForce, TPlayerHero, TText, TUnit
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Legend_Oracle_Talk=null
endglobals

function Trig_Legend_Oracle_Talk_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,udg_NpcUnit[16],true,true,true))
endfunction

function Trig_Legend_Oracle_Talk_Cond_WrongJobOrLevel takes nothing returns boolean
    return(GetUnitTypeId(Player_GetHero(GetTriggerPlayer()))!=udg_JobUnitType[udg_TempInteger])or(GetHeroLevel(Player_GetHero(GetTriggerPlayer()))<99)
endfunction

function Trig_Legend_Oracle_Talk_Cond_TaskLocked takes nothing returns boolean
    return(udg_QuestStage[udg_TempInteger]>=2)and(Trig_Legend_Oracle_Talk_Cond_WrongJobOrLevel())
endfunction

function Trig_Legend_Oracle_Talk_Cond_CinematicsOnTask takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Legend_Oracle_Talk_Cond_CinematicsOnIntro takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Legend_Oracle_Talk_Cond_FirstVisit takes nothing returns boolean
    return(udg_QuestStage[udg_TempInteger]==2)
endfunction

function Trig_Legend_Oracle_Talk_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    set udg_TempInteger=16
    if(Trig_Legend_Oracle_Talk_Cond_TaskLocked())then
        set udg_TempForce=Force_OfPlayer(GetTriggerPlayer())
        call DisplayTimedTextToForce(udg_TempForce,15.,((GetHeroProperName(GetTriggerUnit())+": You need to be |cffffcc00Ultimate Master ")+(udg_JobName[udg_TempInteger]+"|r to take on my task.")))
        call DestroyForce(udg_TempForce)
        return
    endif
    call DestroyEffectBJ(udg_LegendMarker[udg_TempInteger])
    set udg_QuestStage[udg_TempInteger]=(udg_QuestStage[udg_TempInteger]+1)
    if(Trig_Legend_Oracle_Talk_Cond_FirstVisit())then
        if(Trig_Legend_Oracle_Talk_Cond_CinematicsOnIntro())then
            call Cine_Enter()
            call Cam_PanToUnit(GetTriggerUnit(),0)
            call Text_Say(udg_NpcUnit[16],"En Taro Adun, visitor. My name is Zeratul.",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"En Taro Tassadar. You are the Legendary Oracle then?",false)
            call Text_Say(udg_NpcUnit[16],"Indeed I have been manifested here in that role by this Spring. I am most honored.",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"You don't look like you're from Gaya. How did you end up here?",false)
            call Text_Say(udg_NpcUnit[16],"Indeed I am not. This form of mine is most unusual as is. In reality I am an Oracle of the Protoss, and I've never been to this world. Still, I was manifested in this place nonetheless.",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"Seems like the Elysium works in really strange ways. There's no limit to who can show up here, is there. In any case, for someone as removed from this world as you to be here as the Legendary Oracle, you must be truly in a league of your own. Any advice you could give?",false)
            call Text_Say(udg_NpcUnit[16],"The Oracle class of Gaya has a very particular niche; to turn the tide of battle in your favor through domination of both buffs and debuffs. Not protective ones like the Priest's, but aggressively taking charge of the fight.",false)
            call Text_Say(udg_NpcUnit[16],"One of the most important elements of your set, however, is simply Jinx, due to the machinations of cooldowns and how buffs and debuffs interact with one another.",false)
            call Text_Say(udg_NpcUnit[16],"Bravery and Pain cancel each other out, as do Faith and Fog. So if you are up against a foe using Faith, you can keep their magic potency suppressed by cancelling it with a Fog spell immediately every time when they cast it. But what if you take a timeout to put Faith on yourself? You will fall out of the debuff loop and now instead if you put Fog on them, their Faith spell will be ready and they will override your Fog with Faith instantly instead.",false)
            call Text_Say(udg_NpcUnit[16],"This is where Jinx comes in; casting it on an enemy with Faith on it will also put Fog on it, without requiring the cooldown of your Predict Magic skill. This allows you to retake control of the cycle if you lose it. This is what separates good Oracles from great ones; the ones that can take control of the debuff loop no matter what.",false)
            call Text_Say(udg_NpcUnit[16],"In addition, don't forget that Jinx is a source of the rare debuffs Deprotect and Deshell. Enemies that would normally be the most protected against damage will quickly become the most vulnerable instead before a strong Oracle.",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"Interesting... it does appear there is more to this class than meets the eye.",false)
            call Text_Say(udg_NpcUnit[16],"Your domain remains that of buffs and debuffs. That much is true. But the battle of mastering them is far from simple indeed. If you take this class lightly, you will not nearly reach your full potential.",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"I see. Thank you, Zeratul.",false)
            call Cine_ExitAction()
        endif
    else
        if(Trig_Legend_Oracle_Talk_Cond_CinematicsOnTask())then
            call Cine_Enter()
            call Cam_PanToUnit(GetTriggerUnit(),0)
            call Text_Say(udg_NpcUnit[16],"You've returned. So you have your sights set on becoming a Legendary Master in the Oracle class, then?",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"I have. What task do you have for us to prove our worth?",false)
            call Text_Say(udg_NpcUnit[16],"Rather than testing a special edge case I will simply have you prove your swiftness and observation. Every greater skill of an Oracle comes down to these fundaments.",false)
            call Text_Say(udg_NpcUnit[16],"Your task is simply this: in the span of 1 minute, use your buffs and debuffs successfully at least 20 times. Any of Blind, Bravery, Pain, Faith, Fog, from your hero skills only, no tomes or consumables, and Jinx does not count either.",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"So just cast them at least 20 times in one minute. That doesn't sound too hard.",false)
            call Text_Say(udg_NpcUnit[16],"It should not be, but good observation is also necessary. Casting a buff or debuff will not count for this task if the target already has the buff in question. So keep your eyes peeled.",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"I will.",false)
            call Cine_ExitAction()
        endif
    endif
    call StartTimerBJ(udg_UnitUpdateTimer,false,1.)
endfunction

function InitTrig_Legend_Oracle takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Legend (module Legend),
// which keeps the original registration order.

function Register_Legend_Oracle_Talk takes nothing returns nothing
    set gg_trg_Legend_Oracle_Talk=CreateTrigger()
    call DisableTrigger(gg_trg_Legend_Oracle_Talk)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Oracle_Talk,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Oracle_Talk,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Oracle_Talk,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Oracle_Talk,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Oracle_Talk,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Oracle_Talk,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Oracle_Talk,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Oracle_Talk,Player(7),true)
    call TriggerAddCondition(gg_trg_Legend_Oracle_Talk,Condition(function Trig_Legend_Oracle_Talk_Conditions))
    call TriggerAddAction(gg_trg_Legend_Oracle_Talk,function Trig_Legend_Oracle_Talk_Actions)
endfunction

endlibrary
