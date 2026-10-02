library TLegendHolySwordsman requires TCam, TCine, TForce, TJob, TPlayerPart01, TText, TUnit
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Legend_HolySwordsman_Talk=null
endglobals

function Trig_Legend_HolySwordsman_Talk_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,udg_NpcUnit[9],true,true,true))
endfunction

function Trig_Legend_HolySwordsman_Talk_Cond_WrongJobOrLevel takes nothing returns boolean
    return(GetUnitTypeId(Player_GetHero(GetTriggerPlayer()))!=udg_JobUnitType[udg_TempInteger])or(GetHeroLevel(Player_GetHero(GetTriggerPlayer()))<99)
endfunction

function Trig_Legend_HolySwordsman_Talk_Cond_TaskLocked takes nothing returns boolean
    return(udg_QuestStage[udg_TempInteger]>=2)and(Trig_Legend_HolySwordsman_Talk_Cond_WrongJobOrLevel())
endfunction

function Trig_Legend_HolySwordsman_Talk_Cond_CinematicsOnTask takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Legend_HolySwordsman_Talk_Cond_PlayerIsDarkKnight takes nothing returns boolean
    return(Job_GetSavedLevel(GetTriggerPlayer(),'H02X')>0) // 'H02X': unit "Dark Knight"
endfunction

function Trig_Legend_HolySwordsman_Talk_Cond_DarkKnightLegendMet takes nothing returns boolean
    return(udg_QuestStage[20]>=2)
endfunction

function Trig_Legend_HolySwordsman_Talk_Cond_CinematicsOnIntro takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Legend_HolySwordsman_Talk_Cond_FirstVisit takes nothing returns boolean
    return(udg_QuestStage[udg_TempInteger]==2)
endfunction

function Trig_Legend_HolySwordsman_Talk_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    set udg_TempInteger=9
    if(Trig_Legend_HolySwordsman_Talk_Cond_TaskLocked())then
        set udg_TempForce=Force_OfPlayer(GetTriggerPlayer())
        call DisplayTimedTextToForce(udg_TempForce,15.,((GetHeroProperName(GetTriggerUnit())+": You need to be |cffffcc00Ultimate Master ")+(udg_JobName[udg_TempInteger]+"|r to take on my task.")))
        call DestroyForce(udg_TempForce)
        return
    endif
    call DestroyEffectBJ(udg_LegendMarker[udg_TempInteger])
    set udg_QuestStage[udg_TempInteger]=(udg_QuestStage[udg_TempInteger]+1)
    if(Trig_Legend_HolySwordsman_Talk_Cond_FirstVisit())then
        if(Trig_Legend_HolySwordsman_Talk_Cond_CinematicsOnIntro())then
            call Cine_Enter()
            call Cam_PanToUnit(GetTriggerUnit(),0)
            call Text_Say(udg_NpcUnit[9],"Good day, adventurers. I am Cecil, here in Elysium as the representative Legendary Holy Swordsman.",false)
            if(Trig_Legend_HolySwordsman_Talk_Cond_DarkKnightLegendMet())then
                call Text_Say(Player_GetHero(GetTriggerPlayer()),"Good day... wait, Cecil? That's the same name as the Dark Knight just next to you.",false)
                call Text_Say(udg_NpcUnit[9],"Yes, we're both the same Cecil. Though I am older than that me by a few years.",false)
                call Text_Say(Player_GetHero(GetTriggerPlayer()),"Okay now that's just surreal. There can even be two of the same person at once here, from different periods of their life?",false)
                call Text_Say(udg_NpcUnit[20],"I am but a snapshot of Cecil as a powerful Dark Knight. I do not know the path of future me... but I admit I am glad to see this future version of myself.",false)
                call Text_Say(udg_NpcUnit[9],"It's a long story. Just know that ultimately, you have more than one road to follow. You can choose to embrace light, or darkness.",false)
                call Text_Say(Player_GetHero(GetTriggerPlayer()),"You went from being the Legendary Dark Knight to being the Legendary Holy Swordsman of all things... that's quite a job change.",false)
                if(Trig_Legend_HolySwordsman_Talk_Cond_PlayerIsDarkKnight())then
                    call Text_Say(udg_NpcUnit[9],"You went from Holy Swordsman to Dark Knight yourself, did you not? Do not mistake the color of the arts you employ to be the color of your own self. It's what you use your skills for that determines who you are.",false)
                else
                    call Text_Say(udg_NpcUnit[9],"It's not that black and white. Do not mistake the color of the arts you employ to be the color of your own self. It's what you use your skills for that determines who you are.",false)
                endif
                call Text_Say(udg_NpcUnit[20],"Well now, apologies for our rambling. Do return to the matter at hand.",false)
            else
                call Text_Say(Player_GetHero(GetTriggerPlayer()),"Good day. Your skills as a Holy Swordsman must be most impressive then. Mind sharing some advice?",false)
            endif
            call Text_Say(udg_NpcUnit[9],"Some advice I can give is that much like the Sorcerer, the real power of this job lies in its sheer versatility. There are not many classes that can heal, deal heavy physical damage, deal with groups of enemies with high damage and incapacitating effects, and even break through highly defended opponents' armors, all at once.",false)
            call Text_Say(udg_NpcUnit[9],"If you are looking to be a one man army, look no further. But conversely, your lack of specialization may be a hindrance more than help when cooperating with specialized allies. Not to say you would not have your place even then, but your power won't truly shine then. You do not need to follow merely one path.",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"Makes sense. It's the nature of a jack of all trades.",false)
            call Text_Say(udg_NpcUnit[9],"Indeed. With that said, if you know what you're up against you can still specialize further against them. I'm sure you've already noticed that the synergy in your skills allow you to deal immense Water elemental damage. You can push this further by getting the Geomancer's Water Enchantment. That way, all your Finisher skills will also be of the Water element.",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"Right I did want to ask, how does the Elemental Quartet skill work exactly? It seems hard to keep track of.",false)
            call Text_Say(udg_NpcUnit[9],"Elemental Quartet is a Finisher skill that will deal a base 9999 damage to anything and everything. It is not physical or magical it is unaffected by most buffs or debuffs, but it does take on an element - specifically, it takes on the element you last used to deal damage to an enemy.",false)
            call Text_Say(udg_NpcUnit[9],"If your Liquid Steel sprite is currently bouncing around, there's no doubt your Elemental Quartet will be Water imbued. Similarly if you're having a Fire or Quake spell going off. Of course if you take care not to use any other elements you can store a particular element for your Quartet for a long time if you need to. In any case, you need not worry about it being a random element; it is under your own control entirely.",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"So that's how it works... thanks for the explanation.",false)
            call Cine_ExitAction()
        endif
    else
        if(Trig_Legend_HolySwordsman_Talk_Cond_CinematicsOnTask())then
            call Cine_Enter()
            call Cam_PanToUnit(GetTriggerUnit(),0)
            call Text_Say(udg_NpcUnit[9],"Good day once more. I believe you have come to receive a task for your ascension?",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"Exactly. What kind of task do you have to propose to attain the title of Legendary Holy Swordsman?",false)
            call Text_Say(udg_NpcUnit[9],"There is one aspect of the Holy Swordsman I did not go into previously; the might of your Holy Power ultimate blessing. As a Holy Swordsman you will most likely use a lot of MP to wield your powers, but your ultimate ability exists precisely to offset this issue.",false)
            call Text_Say(udg_NpcUnit[9],"It may be a formality of a task, but I still want you to use it to its fullest potential. Specifically, in the span of one usage of Holy Power, I want you to both use and restore a total of 4000 MP or more.",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"Both use and restore... you mean with strikes?",false)
            call Text_Say(udg_NpcUnit[9],"Yes of course. Not by Ethers or the like. Simply put, attack 45 times while not being at full MP during one usage of Holy Power. And in the same span of time, use abilities, be they your own or that of items you carry, that total up to more than 4000 MP cost as well. Accomplish this and I will give you my blessing.",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"That doesn't sound too hard.",false)
            call Text_Say(udg_NpcUnit[9],"I would think not. It may be a specific task but the accomplishing it should not be hard. Good luck to you.",false)
            call Cine_ExitAction()
        endif
    endif
    call StartTimerBJ(udg_UnitUpdateTimer,false,1.)
endfunction

function InitTrig_Legend_HolySwordsman takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Legend (module Legend),
// which keeps the original registration order.

function Register_Legend_HolySwordsman_Talk takes nothing returns nothing
    set gg_trg_Legend_HolySwordsman_Talk=CreateTrigger()
    call DisableTrigger(gg_trg_Legend_HolySwordsman_Talk)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_HolySwordsman_Talk,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_HolySwordsman_Talk,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_HolySwordsman_Talk,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_HolySwordsman_Talk,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_HolySwordsman_Talk,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_HolySwordsman_Talk,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_HolySwordsman_Talk,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_HolySwordsman_Talk,Player(7),true)
    call TriggerAddCondition(gg_trg_Legend_HolySwordsman_Talk,Condition(function Trig_Legend_HolySwordsman_Talk_Conditions))
    call TriggerAddAction(gg_trg_Legend_HolySwordsman_Talk,function Trig_Legend_HolySwordsman_Talk_Actions)
endfunction

endlibrary
