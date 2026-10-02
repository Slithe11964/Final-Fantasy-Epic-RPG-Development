library TLegendGeomancer requires TCam, TCine, TForce, TPlayerHero, TText, TUnit
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Legend_Geomancer_Talk=null
endglobals

function Trig_Legend_Geomancer_Talk_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,udg_NpcUnit[5],true,true,true))
endfunction

function Trig_Legend_Geomancer_Talk_Cond_WrongJobOrLevel takes nothing returns boolean
    return(GetUnitTypeId(Player_GetHero(GetTriggerPlayer()))!=udg_JobUnitType[udg_TempInteger])or(GetHeroLevel(Player_GetHero(GetTriggerPlayer()))<99)
endfunction

function Trig_Legend_Geomancer_Talk_Cond_TaskLocked takes nothing returns boolean
    return(udg_QuestStage[udg_TempInteger]>=2)and(Trig_Legend_Geomancer_Talk_Cond_WrongJobOrLevel())
endfunction

function Trig_Legend_Geomancer_Talk_Cond_CinematicsOnTask takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Legend_Geomancer_Talk_Cond_CinematicsOnIntro takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Legend_Geomancer_Talk_Cond_FirstVisit takes nothing returns boolean
    return(udg_QuestStage[udg_TempInteger]==2)
endfunction

function Trig_Legend_Geomancer_Talk_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    set udg_TempInteger=5
    if(Trig_Legend_Geomancer_Talk_Cond_TaskLocked())then
        set udg_TempForce=Force_OfPlayer(GetTriggerPlayer())
        call DisplayTimedTextToForce(udg_TempForce,15.,((GetHeroProperName(GetTriggerUnit())+": You need to be |cffffcc00Ultimate Master ")+(udg_JobName[udg_TempInteger]+"|r to take on my task.")))
        call DestroyForce(udg_TempForce)
        return
    endif
    call DestroyEffectBJ(udg_LegendMarker[udg_TempInteger])
    set udg_QuestStage[udg_TempInteger]=(udg_QuestStage[udg_TempInteger]+1)
    if(Trig_Legend_Geomancer_Talk_Cond_FirstVisit())then
        if(Trig_Legend_Geomancer_Talk_Cond_CinematicsOnIntro())then
            call Cine_Enter()
            call Cam_PanToUnit(GetTriggerUnit(),0)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"Greetings. You are the Legendary Geomancer, correct?",false)
            call Text_Say(udg_NpcUnit[5],"People call me that. In my era we called ourselves Spellblades. I take it you are looking for advice?",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"If you have any to give it would be most appreciated.",false)
            call Text_Say(udg_NpcUnit[5],"I assume this much is obvious to you, but as a Geomancer your power lies in your mastery of the elements.",false)
            call Text_Say(udg_NpcUnit[5],"Know your enemy's weakness and hit them with it as hard as you can. Not many know this, but if you use an elemental weapon and cast an enchantment of the matching element on yourself on top of that, you will do more damage than if you just had one of the two.",false)
            call Text_Say(udg_NpcUnit[5],"Don't forget that axes work on upswing. The longer the interval between one attack and the next, the more damage it will do. Slow strikes still will not outpace fast strikes, but don't get too hung up about taking too much time with your swings. Axes work well that way.",false)
            call Text_Say(udg_NpcUnit[5],"And of course, there is much more you can do to master the elements beyond merely using an Enchantment or elemental weapon. Use an elemental book, or an elemental orb, even throw on an elemental mystic gear, or straight up use all of them together to truly demolish your opponents.",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"Well of course the Geomancer relies on striking with elements. But what if the enemy resists all elements?",false)
            call Text_Say(udg_NpcUnit[5],"Those are your biggest enemy for sure. In those cases your best shot is pushing a single element as strongly as possible but equipping yourself with a Blank Orb. That way your strikes will have massive weight behind them but still be unaffected by the enemy's resistances. Still, you may also consider just avoiding them altogether. They are a poor match with your strengths after all.",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"I see, well that's still very helpful. Thank you.",false)
            call Text_Say(udg_NpcUnit[5],"I bid you good luck on your journey.",false)
            call Cine_ExitAction()
        endif
    else
        if(Trig_Legend_Geomancer_Talk_Cond_CinematicsOnTask())then
            call Cine_Enter()
            call Cam_PanToUnit(GetTriggerUnit(),0)
            call Text_Say(udg_NpcUnit[5],"So you've returned. You wish to ascend to the level of Legendary Master, is that it?",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"Indeed I do. What task would you have us complete to prove our worth?",false)
            call Text_Say(udg_NpcUnit[5],"By now you should be more than familiar with just how devastating your axe swings can be. I want to put them to the ultimate test.",false)
            call Text_Say(udg_NpcUnit[5],"I want you to deal over 200'000 damage in a single cleaving Blitz strike.",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),". . . OVER 200'000 DAMAGE? IN ONE STRIKE?",false)
            call Text_Say(udg_NpcUnit[5],"Exactly. If you truly are a masterful Geomancer, this should not pose too big of a problem to you. Just think of all the ways you can maximize your power, and then just unleash all at once on a group of gathered monsters in one clean hit with Blitz. I'm sure you'll figure it out.",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"You're serious huh. Well guess I'll just have to do it then.",false)
            call Cine_ExitAction()
        endif
    endif
    call StartTimerBJ(udg_UnitUpdateTimer,false,1.)
endfunction

function InitTrig_Legend_Geomancer takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Legend (module Legend),
// which keeps the original registration order.

function Register_Legend_Geomancer_Talk takes nothing returns nothing
    set gg_trg_Legend_Geomancer_Talk=CreateTrigger()
    call DisableTrigger(gg_trg_Legend_Geomancer_Talk)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Geomancer_Talk,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Geomancer_Talk,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Geomancer_Talk,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Geomancer_Talk,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Geomancer_Talk,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Geomancer_Talk,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Geomancer_Talk,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Geomancer_Talk,Player(7),true)
    call TriggerAddCondition(gg_trg_Legend_Geomancer_Talk,Condition(function Trig_Legend_Geomancer_Talk_Conditions))
    call TriggerAddAction(gg_trg_Legend_Geomancer_Talk,function Trig_Legend_Geomancer_Talk_Actions)
endfunction

endlibrary
