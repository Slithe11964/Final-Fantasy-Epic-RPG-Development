library TJudgment requires TCam, TCine, TPlayerHero, TText, TWait
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Judgment_Attack_Alberich=null
    trigger gg_trg_Judgment_Spare_Alberich=null
endglobals

function Trig_Judgment_Attack_Alberich_Conditions takes nothing returns boolean
    return(GetTriggerUnit()==gg_unit_h037_0257)
endfunction

function Trig_Judgment_Attack_Alberich_Cond_AttackerIsPlayer takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetAttacker()),udg_PlayingPlayers))
endfunction

function Trig_Judgment_Attack_Alberich_Cond_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Judgment_Attack_Alberich_Actions takes nothing returns nothing
    local location l_tempPoint2
    call DisableTrigger(GetTriggeringTrigger())
    call DisableTrigger(gg_trg_Judgment_Spare_Alberich)
    call DestroyTrigger(gg_trg_Judgment_Spare_Alberich)
    call DestroyEffectBJ(udg_SpecialEffect[90])
    call GroupRemoveUnitSimple(gg_unit_h037_0257,udg_BossUnits)
    call SetUnitInvulnerable(gg_unit_h037_0257,true)
    call UnitRemoveAbilityBJ('A0T8',GetTriggerUnit()) // 'A0T8': ability "Block All"
    if(Trig_Judgment_Attack_Alberich_Cond_AttackerIsPlayer())then
        set udg_JudgePlayer=GetOwningPlayer(GetAttacker())
    endif
    if(Trig_Judgment_Attack_Alberich_Cond_CinematicsEnabled())then
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_E01O_0268,0)
        call AddSpecialEffectTargetUnitBJ("chest",GetTriggerUnit(),"Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call Text_Say(gg_unit_E01O_0268,"Hold your blade. So that is your choice after all. But before you go ahead, I would like to hear your reasons.",false)
        call Text_Say(Player_GetHero(udg_JudgePlayer),"Hmph, alright. I understand wanting to take revenge against the beast for what it's done to people very important to you, and if you had gone after it to defeat it yourself I would have cheered you on, and even wanted to defend you from the Northern God's punishment.",false)
        call Text_Say(Player_GetHero(udg_JudgePlayer),"But you sent Ziegfried to do the dirty work for you, knowing he would be executed for it, not protecting him, and all this in spite of the fact that he has nothing to do with what happened to your nephew and the others. You simply sent an innocent man to his death.",false)
        call Text_Say(gg_unit_h037_0257,"If that's how you take it, I have nothing more to say. I've given my side already, and I have nothing tying me to Gaya anymore regardless. Finish me.",false)
        call Text_Say(gg_unit_E01O_0268,"They will not. The Northern God has already made his own judgment, and it is to pardon you, Alberich. This has all been merely to judge their judgment of you.",false)
        call Text_Say(gg_unit_E01O_0268,"I understand your reasons now. But the Northern God's position is that Ziegfried was only going to cause troubles sooner or later, and Alberich's actions simply brought him forward sooner. That is all.",false)
        call Text_Say(Player_GetHero(udg_JudgePlayer),"So you'd already decided, and you still wanted us to judge Alberich for ourselves, just so you can then overrule us anyways? This god of yours toys with people as he sees fit, doesn't he.",false)
        call Text_Say(Player_GetHero(udg_JudgePlayer),"This is all your fault to begin with. You were the ones who sent down that Godbeast, and then didn't even clean up your own mess. We don't need gods like that claiming to be watching out for us. Just leave this world.",false)
        call Text_Say(Player_GetHero(udg_JudgePlayer),"And you're just hypocrites on top. I saw the Northern God slice through Ziegfried's armor, which should be impenetrable by all but Arcanium itself. So in reality you're using Arcanium blades yourself, for your own supremacy, so no one may defy you, isn't that right?",false)
        call Text_Say(gg_unit_E01O_0268,"You don't hold your tongue much, do you. Yes, we are using Arcanium. It is too dangerous to be left in the hands of everybody, but it is a necessity for an arbiter of order to be able to enforce executions.",false)
        call Text_Say(Player_GetHero(udg_JudgePlayer),"And you're just taking the right to do that for yourselves. I'm not going to accept someone like that as a god. In fact, I really badly want to punch all your faces right now.",false)
        call Text_Say(gg_unit_E01O_0268,"Huhuhu... you might be in way over your head, human. If you need a humbling, I'll arrange a meeting between you and the Northern God himself.",false)
        call Text_Say(Player_GetHero(udg_JudgePlayer),"I'm not going to back down. I will beat you and your impenetrable gear even without any Arcanium blades of my own if I have to.",false)
        call Text_Say(gg_unit_E01O_0268,"Now I'm looking forward to this. I'll call on him right away. Come meet us at the old mine's entrance in the northwest, if your confidence is true.",false)
        call Text_Say(Player_GetHero(udg_JudgePlayer),"I will.",false)
        set udg_TempPoint=GetUnitLoc(gg_unit_E01O_0268)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        call Wait_Polled(.5)
        call Cine_ExitAction()
    else
        set udg_TempPoint=GetUnitLoc(gg_unit_E01O_0268)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
    endif
    call RemoveUnit(gg_unit_h037_0257)
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_DISCOVERED,"New Quest Received: |cffffcc00The Northern God|r")
    set udg_SideQuest[35]=CreateQuestBJ(bj_QUESTTYPE_REQ_DISCOVERED,(udg_QuestTitleRed+"The Northern God"),"Face off against the Northern God at the old Arcanium mine.","ReplaceableTextures\\CommandButtons\\BTNChaosWarlord.blp")
    set udg_TempPoint=GetRectCenter(gg_rct_677)
    call SetUnitPositionLocFacingBJ(gg_unit_H01M_0071,udg_TempPoint,270.)
    set l_tempPoint2=OffsetLocation(udg_TempPoint,-300.,0)
    call SetUnitPositionLocFacingBJ(gg_unit_N0N0_0267,l_tempPoint2,270.)
    call RemoveLocation(l_tempPoint2)
    set l_tempPoint2=OffsetLocation(udg_TempPoint,300.,0)
    call SetUnitPositionLocFacingBJ(gg_unit_E01O_0268,l_tempPoint2,270.)
    call RemoveLocation(l_tempPoint2)
    call RemoveLocation(udg_TempPoint)
    call ShowUnitShow(gg_unit_H01M_0071)
    call ShowUnitShow(gg_unit_N0N0_0267)
    call GroupAddUnitSimple(gg_unit_H01M_0071,udg_BossUnits)
    set udg_SpecialEffect[90]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_H01M_0071,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call EnableTrigger(gg_trg_Boss_Odin_Intro)
    call DestroyTrigger(GetTriggeringTrigger())
    set l_tempPoint2=null
endfunction

function Trig_Judgment_Spare_Alberich_Cond_CinematicRunning takes nothing returns boolean
    return(udg_InCinematicMode)
endfunction

function Trig_Judgment_Spare_Alberich_Cond_HeroNearAlberich takes nothing returns boolean
    // The straight-line distance between udg_TempPoint and udg_TempPoint2.
    return(DistanceBetweenPoints(udg_TempPoint,udg_TempPoint2)<=800.)
endfunction

function Trig_Judgment_Spare_Alberich_Enum_CollectNearbyPlayers takes nothing returns nothing
    set udg_TempPoint2=GetUnitLoc(Player_GetHero(GetEnumPlayer()))
    if(Trig_Judgment_Spare_Alberich_Cond_HeroNearAlberich())then
        call ForceAddPlayerSimple(GetEnumPlayer(),udg_TempForce)
    endif
    call RemoveLocation(udg_TempPoint2)
endfunction

function Trig_Judgment_Spare_Alberich_Cond_JudgeNotPresent takes nothing returns boolean
    return(IsPlayerInForce(udg_JudgePlayer,udg_TempForce)==false)
endfunction

function Trig_Judgment_Spare_Alberich_Cond_PlayersStillNear takes nothing returns boolean
    return(CountPlayersInForceBJ(udg_TempForce)>0)
endfunction

function Trig_Judgment_Spare_Alberich_Cond_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Judgment_Spare_Alberich_Actions takes nothing returns nothing
    if(Trig_Judgment_Spare_Alberich_Cond_CinematicRunning())then
        call StartTimerBJ(udg_SharedDelayTimer5,false,2.)
        return
    endif
    set udg_TempPoint=GetUnitLoc(gg_unit_h037_0257)
    set udg_TempForce=CreateForce()
    call ForForce(udg_PlayingPlayers,function Trig_Judgment_Spare_Alberich_Enum_CollectNearbyPlayers)
    call RemoveLocation(udg_TempPoint)
    if(Trig_Judgment_Spare_Alberich_Cond_PlayersStillNear())then
        if(Trig_Judgment_Spare_Alberich_Cond_JudgeNotPresent())then
            set udg_JudgePlayer=ForcePickRandomPlayer(udg_TempForce)
        endif
        call DestroyForce(udg_TempForce)
        call StartTimerBJ(udg_SharedDelayTimer5,false,2.)
        return
    endif
    call DisableTrigger(GetTriggeringTrigger())
    call DisableTrigger(gg_trg_Judgment_Attack_Alberich)
    call DestroyTrigger(gg_trg_Judgment_Attack_Alberich)
    call DestroyForce(udg_TempForce)
    call DestroyEffectBJ(udg_SpecialEffect[90])
    call GroupRemoveUnitSimple(gg_unit_h037_0257,udg_BossUnits)
    call SetUnitInvulnerable(gg_unit_h037_0257,true)
    if(Trig_Judgment_Spare_Alberich_Cond_CinematicsEnabled())then
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_E01O_0268,0)
        call Text_Say(gg_unit_E01O_0268,"So that is their choice. They are more merciful than I thought.",false)
        call Text_Say(gg_unit_h037_0257,"What about you? The Northern God is not letting me go, is he?",false)
        call Text_Say(gg_unit_E01O_0268,"He sure is. It's only because of you that we caught Ziegfried. He may not have done what he did without you, but him being who he was he was always going to be dangerous. Just possibly not getting a chance to do anything. The Northern God pardons you.",false)
        call Text_Say(gg_unit_h037_0257,"Hmph. If you say so. You better not expect me to be grateful.",false)
        call Text_Say(gg_unit_E01O_0268,"Of course not. Until next we meet, farewell.",false)
        set udg_TempPoint=GetUnitLoc(gg_unit_E01O_0268)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        call Wait_Polled(.5)
        call ShowUnitHide(gg_unit_E01O_0268)
        call Wait_Polled(1.5)
        set udg_CinematicActor=Player_GetHero(udg_JudgePlayer)
        set udg_TempPoint2=GetUnitLoc(udg_CinematicActor)
        set udg_TempPoint=OffsetLocation(udg_TempPoint2,256.,0)
        call SetUnitPositionLocFacingLocBJ(gg_unit_E01O_0268,udg_TempPoint,udg_TempPoint2)
        call SetUnitFacingToFaceLocTimed(udg_CinematicActor,udg_TempPoint,.6)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportTarget.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        call Cam_PanToUnit(gg_unit_E01O_0268,.5)
        call Wait_Polled(.5)
        call ShowUnitShow(gg_unit_E01O_0268)
        call Text_Say(gg_unit_E01O_0268,"Wait. This is the choice you've made, is it? I'd like to hear your reasons.",false)
        call Text_Say(Player_GetHero(udg_JudgePlayer),"Your have toyed with the lives of people enough. Ziegfried's blood is on your hands, not Alberich's. Don't you dare pin this on him now, after what your God decided to do himself.",false)
        call Text_Say(Player_GetHero(udg_JudgePlayer),"This is all your fault to begin with. You were the ones who sent down that Godbeast, and then didn't even clean up your own mess. We don't need gods like that claiming to be watching out for us. Just leave this world.",false)
        call Text_Say(Player_GetHero(udg_JudgePlayer),"And you're just hypocrites on top. I saw the Northern God slice through Ziegfried's armor, which should be impenetrable by all but Arcanium itself. So in reality you're using Arcanium blades yourself, for your own supremacy, so no one may defy you, isn't that right?",false)
        call Text_Say(gg_unit_E01O_0268,"You don't hold your tongue much, do you. Yes, we are using Arcanium. It is too dangerous to be left in the hands of everybody, but it is a necessity for an arbiter of order to be able to enforce executions.",false)
        call Text_Say(Player_GetHero(udg_JudgePlayer),"And you're just taking the right to do that for yourselves. I'm not going to accept someone like that as a god. In fact, I really badly want to punch all your faces right now.",false)
        call Text_Say(gg_unit_E01O_0268,"Huhuhu... you might be in way over your head, human. If you need a humbling, I'll arrange a meeting between you and the Northern God himself.",false)
        call Text_Say(Player_GetHero(udg_JudgePlayer),"I'm not going to back down. I will beat you and your impenetrable gear even without any Arcanium blades of my own if I have to.",false)
        call Text_Say(gg_unit_E01O_0268,"Now I'm looking forward to this. I'll call on him right away. Come meet us at the old mine's entrance in the northwest, if your confidence is true.",false)
        call Text_Say(Player_GetHero(udg_JudgePlayer),"I will.",false)
        set udg_TempPoint=GetUnitLoc(gg_unit_E01O_0268)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        call Wait_Polled(.5)
        call Cine_ExitAction()
    else
        set udg_TempPoint=GetUnitLoc(gg_unit_E01O_0268)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
    endif
    call RemoveUnit(gg_unit_h037_0257)
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_DISCOVERED,"New Quest Received: |cffffcc00The Northern God|r")
    set udg_SideQuest[35]=CreateQuestBJ(bj_QUESTTYPE_REQ_DISCOVERED,(udg_QuestTitleRed+"The Northern God"),"Face off against the Northern God at the old Arcanium mine.","ReplaceableTextures\\CommandButtons\\BTNChaosWarlord.blp")
    set udg_TempPoint=GetRectCenter(gg_rct_677)
    call SetUnitPositionLocFacingBJ(gg_unit_H01M_0071,udg_TempPoint,270.)
    set udg_TempPoint2=OffsetLocation(udg_TempPoint,-300.,0)
    call SetUnitPositionLocFacingBJ(gg_unit_N0N0_0267,udg_TempPoint2,270.)
    call RemoveLocation(udg_TempPoint2)
    set udg_TempPoint2=OffsetLocation(udg_TempPoint,300.,0)
    call SetUnitPositionLocFacingBJ(gg_unit_E01O_0268,udg_TempPoint2,270.)
    call RemoveLocation(udg_TempPoint2)
    call RemoveLocation(udg_TempPoint)
    call ShowUnitShow(gg_unit_H01M_0071)
    call ShowUnitShow(gg_unit_N0N0_0267)
    call GroupAddUnitSimple(gg_unit_H01M_0071,udg_BossUnits)
    set udg_SpecialEffect[90]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_H01M_0071,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call EnableTrigger(gg_trg_Boss_Odin_Intro)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_Judgment automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Judgment (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Judgment takes nothing returns nothing
endfunction

function Register_Judgment_Attack_Alberich takes nothing returns nothing
    set gg_trg_Judgment_Attack_Alberich=CreateTrigger()
    call DisableTrigger(gg_trg_Judgment_Attack_Alberich)
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_Judgment_Attack_Alberich,Player(8),EVENT_PLAYER_UNIT_ATTACKED)
    call TriggerAddCondition(gg_trg_Judgment_Attack_Alberich,Condition(function Trig_Judgment_Attack_Alberich_Conditions))
    call TriggerAddAction(gg_trg_Judgment_Attack_Alberich,function Trig_Judgment_Attack_Alberich_Actions)
endfunction

function Register_Judgment_Spare_Alberich takes nothing returns nothing
    set gg_trg_Judgment_Spare_Alberich=CreateTrigger()
    call DisableTrigger(gg_trg_Judgment_Spare_Alberich)
    call TriggerRegisterTimerExpireEventBJ(gg_trg_Judgment_Spare_Alberich,udg_SharedDelayTimer5)
    call TriggerAddAction(gg_trg_Judgment_Spare_Alberich,function Trig_Judgment_Spare_Alberich_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Judgment takes nothing returns nothing
    call Register_Judgment_Attack_Alberich() // starts off; enabled by Quest_NorthernGod; disabled by Judgment; destroyed by Judgment
    call Register_Judgment_Spare_Alberich() // starts off; enabled by Quest_NorthernGod; disabled by Judgment; destroyed by Judgment
endfunction

endlibrary
