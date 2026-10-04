library TQuestBrothers requires TQuestEngine, TCine, TGroup, TPlayerHero, TText, TUnit
// Side quest "Brothers", written for the quest engine (QuestEngine module, docs/QUEST_ENGINE.md).
// Izlude asks the party to defeat two Eidolons in the mountains; beaten, they guard Kalm. Made available by
// Kill Elmdor, which runs gg_trg_Quest_Brothers_Available.
// Izlude's first line names the talking hero's unit type, and the fight ends with a cinematic, so the talk
// and the fight stay triggers of this module (custom steps); the engine keeps the quest log and the reward.
// The module shows its own "!" / "?" over Izlude.
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Quest_Brothers_Init=null
    trigger gg_trg_Quest_Brothers_Available=null
    trigger gg_trg_Quest_Brothers_Start=null
    trigger gg_trg_Quest_Brothers_Defeated=null
    // The quest's number in the quest engine (0 until it is defined).
    integer QUEST_BROTHERS=0
endglobals

// Quest done: the "?" over Izlude goes, and the Lacerta hunt is offered.
function QuestBrothers_Done takes nothing returns nothing
    call DestroyEffectBJ(udg_SpecialEffect[26])
    call AddUnitToStockBJ('n0BC',gg_unit_n0BW_0094,1,1) // 'n0BC': unit "Hunt: Lacerta"
    set udg_HuntStock[4]=(udg_HuntStock[4]+1)
    call ConditionalTriggerExecute(gg_trg_Hunt_Board_Markers)
endfunction

function QuestBrothers_Define takes nothing returns nothing
    local integer q=Quest_Define("Brothers",QUEST_SIDE,8,"ReplaceableTextures\\CommandButtons\\BTNTauren.blp")
    set QUEST_BROTHERS=q
    call Quest_NoMarker(q)
    // 1. Talk to Izlude (gg_trg_Quest_Brothers_Start)
    call Quest_Custom(q,"Izlude, Blade Knight from Kalm, asked you to defeat two Eidolons in the mountains.")
    // 2. Defeat both Eidolons (gg_trg_Quest_Brothers_Defeated)
    call Quest_Custom(q,"Return to Izlude, Divine Knight from Kalm.")
    call Quest_Message(q,"Return to Izlude.")
    // 3. Report back to Izlude
    call Quest_Return(q,gg_unit_Hdgo_0097,"")
    call Quest_PingUnit(q)
    call Quest_Camera(q,gg_cam_005)
    call Quest_Say(q,gg_unit_Hdgo_0097,"Thank you very much. Our mighty defenders are already here and their presence here makes me hope that we'll be able to protect ourselves if monsters attack Kalm.")
    call Quest_Say(q,gg_unit_Hdgo_0097,"Please, take this gold as a sign of our gratitude.")
    call Quest_Reward(q,3000,2500)
    call Quest_OnDone(q,"QuestBrothers_Done")
endfunction

function Trig_Quest_Brothers_Init_Actions takes nothing returns nothing
    call ShowUnitHide(gg_unit_Ocb2_0147)
    call ShowUnitHide(gg_unit_Ocbh_0148)
    call IssueImmediateOrderBJ(gg_unit_Hdgo_0097,"holdposition")
    call IssueImmediateOrderBJ(gg_unit_hhes_0099,"holdposition")
    call IssueImmediateOrderBJ(gg_unit_hhes_0100,"holdposition")
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Quest_Brothers_Available_Actions takes nothing returns nothing
    set udg_SpecialEffect[25]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_Hdgo_0097,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call EnableTrigger(gg_trg_Quest_Brothers_Start)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Quest_Brothers_Start_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_Hdgo_0097,true,true,true))
endfunction

function Trig_Quest_Brothers_Start_Enum_ApplyCamera takes nothing returns nothing
    call CameraSetupApplyForPlayer(true,gg_cam_005,GetEnumPlayer(),1.)
endfunction

function Trig_Quest_Brothers_Start_Cond_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

// Step 1: the party talks to Izlude; the Eidolons appear in the mountains and the quest starts.
function Trig_Quest_Brothers_Start_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[25])
    if(Trig_Quest_Brothers_Start_Cond_CinematicsEnabled())then
        call Cine_Enter()
        call ForForce(udg_PlayingPlayers,function Trig_Quest_Brothers_Start_Enum_ApplyCamera)
        call Text_Say(gg_unit_Hdgo_0097,("What do you need, "+(GetUnitName(Player_GetHero(GetTriggerPlayer()))+"?")),false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Biggs told us that you have a problem and that you might need help in order to solve it.",false)
        call Text_Say(gg_unit_Hdgo_0097,"I have already heard that someon killed Elmdor. So it was you. Impressive. Perhaps you are the ones who can help me.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"So, what's the big deal?",false)
        call Text_Say(gg_unit_Hdgo_0097,"Have you ever heard about Eidolons? They are powerful entities of mystical origin.",false)
        call Text_Say(gg_unit_Hdgo_0097,"Summoners are able to call them in battle and Eidolons fight against Summoners' enemies.",false)
        call Text_Say(gg_unit_Hdgo_0097,"However, there's another way to make Eidolon help you. It is said that if you defeat Eidolon in a fair fight then it will swear its allegiance to you.",false)
        call Text_Say(gg_unit_Hdgo_0097,"As you know, the monsters grow more aggresive with every passing day. I am afraid that they may attack our town soon.",false)
        call Text_Say(gg_unit_Hdgo_0097,"We need to gather as many allies as we can. And it would be great to have Eidolons at our side.",false)
        call Text_Say(gg_unit_Hdgo_0097,"One of my scouts noticed two strange bull-headed humanoids in the mountains. I found out that they are Eidolons and decided to do battle with them.",false)
        call Text_Say(gg_unit_Hdgo_0097,"To my shame, I was easily defeated. They, however, did not kill me and let me go.",false)
        call Text_Say(gg_unit_Hdgo_0097,"Since you slew Elmdor I think that you are a match for those Eidolons. Defeat them and they will be of great help to us all.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Perhaps you are right. We shall see what can be done.",false)
        call Text_Say(gg_unit_Hdgo_0097,"Then I wish you luck and remember - there's no shame in retreating if your enemy is too strong.",false)
        call Cine_ExitAction()
    endif
    call ShowUnitShow(gg_unit_Ocb2_0147)
    call ShowUnitShow(gg_unit_Ocbh_0148)
    call GroupAddUnitSimple(gg_unit_Ocb2_0147,udg_BossUnits)
    call GroupAddUnitSimple(gg_unit_Ocbh_0148,udg_BossUnits)
    if QUEST_BROTHERS==0 then
        call QuestBrothers_Define()
    endif
    call Quest_Start(QUEST_BROTHERS,GetTriggerPlayer(),Player_GetHero(GetTriggerPlayer()))
    set udg_SpecialEffect[26]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_Hdgo_0097,"Objects\\RandomObject\\RandomObject.mdl")
    call EnableTrigger(gg_trg_Quest_Brothers_Defeated)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Quest_Brothers_Defeated_Cond_NotNeutralPassive takes nothing returns boolean
    return(GetOwningPlayer(GetFilterUnit())!=Player(PLAYER_NEUTRAL_PASSIVE))
endfunction

function Trig_Quest_Brothers_Defeated_Enum_MoveAside takes nothing returns nothing
    local location l_tempPoint
    local location l_tempPoint2
    set l_tempPoint=GetUnitLoc(GetEnumUnit())
    set l_tempPoint2=OffsetLocation(l_tempPoint,0,-386.)
    call RemoveLocation(l_tempPoint)
    call SetUnitPositionLoc(GetEnumUnit(),l_tempPoint2)
    call RemoveLocation(l_tempPoint2)
    set l_tempPoint=null
    set l_tempPoint2=null
endfunction

function Trig_Quest_Brothers_Defeated_Enum_ApplyCamera takes nothing returns nothing
    call CameraSetupApplyForPlayer(true,gg_cam_013,GetEnumPlayer(),1.)
endfunction

function Trig_Quest_Brothers_Defeated_Cond_KillerNotPlaying takes nothing returns boolean
    return(IsPlayerInForce(udg_TempPlayer,udg_PlayingPlayers)==false)
endfunction

function Trig_Quest_Brothers_Defeated_Cond_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_Brothers_Defeated_Cond_TownGuardsPresent takes nothing returns boolean
    return(IsUnitGroupEmptyBJ(udg_AllyRangerGroup)==false)
endfunction

function Trig_Quest_Brothers_Defeated_Cond_Quest9Completed takes nothing returns boolean
    return(IsQuestCompleted(udg_MainQuest[9]))
endfunction

function Trig_Quest_Brothers_Defeated_Cond_Quest10Completed takes nothing returns boolean
    return(IsQuestCompleted(udg_MainQuest[$A])) // $A = 10
endfunction

function Trig_Quest_Brothers_Defeated_Cond_Quest11Completed takes nothing returns boolean
    return(IsQuestCompleted(udg_MainQuest[$B])) // $B = 11
endfunction

function Trig_Quest_Brothers_Defeated_Cond_Brother2Defeated takes nothing returns boolean
    return(GetOwningPlayer(gg_unit_Ocbh_0148)==Player(8))
endfunction

function Trig_Quest_Brothers_Defeated_Cond_Brother1Defeated takes nothing returns boolean
    return(GetOwningPlayer(gg_unit_Ocb2_0147)==Player(8))
endfunction

function Trig_Quest_Brothers_Defeated_Cond_BothBrothersDefeated takes nothing returns boolean
    return(GetBooleanAnd(Trig_Quest_Brothers_Defeated_Cond_Brother2Defeated(),Trig_Quest_Brothers_Defeated_Cond_Brother1Defeated()))
endfunction

// Step 2: a brother was beaten. Once both are, they swear allegiance and go to guard Kalm.
function Trig_Quest_Brothers_Defeated_Actions takes nothing returns nothing
    local location l_tempPoint
    local unit l_killer=GetKillingUnitBJ()
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_BossUnits)
    set l_tempPoint=GetUnitLoc(GetTriggerUnit())
    call ReviveHeroLoc(GetDyingUnit(),l_tempPoint,false)
    call RemoveLocation(l_tempPoint)
    call SetUnitInvulnerable(GetTriggerUnit(),true)
    call SetUnitOwner(GetDyingUnit(),Player(8),false)
    if(Trig_Quest_Brothers_Defeated_Cond_BothBrothersDefeated())then
        call DisableTrigger(GetTriggeringTrigger())
        if(Trig_Quest_Brothers_Defeated_Cond_CinematicsEnabled())then
            set udg_TempPlayer=GetOwningPlayer(GetKillingUnitBJ())
            set l_tempPoint=GetRectCenter(gg_rct_236)
            call SetUnitPositionLoc(gg_unit_Ocb2_0147,l_tempPoint)
            call RemoveLocation(l_tempPoint)
            set l_tempPoint=GetRectCenter(gg_rct_377)
            call SetUnitPositionLoc(gg_unit_Ocbh_0148,l_tempPoint)
            call SetUnitFacingTimed(gg_unit_Ocb2_0147,bj_UNIT_FACING,0)
            call SetUnitFacingTimed(gg_unit_Ocbh_0148,bj_UNIT_FACING,0)
            set udg_TempGroup=Group_UnitsInRangeOfLoc(512,l_tempPoint,Condition(function Trig_Quest_Brothers_Defeated_Cond_NotNeutralPassive))
            call RemoveLocation(l_tempPoint)
            call ForGroupBJ(udg_TempGroup,function Trig_Quest_Brothers_Defeated_Enum_MoveAside)
            call DestroyGroup(udg_TempGroup)
            call Cine_Enter()
            call ForForce(udg_PlayingPlayers,function Trig_Quest_Brothers_Defeated_Enum_ApplyCamera)
            call SetUnitFacingToFaceUnitTimed(gg_unit_Ocbh_0148,gg_unit_Ocb2_0147,1.)
            call Text_Say(gg_unit_Ocbh_0148,"That was a good fight, bro !!",false)
            call SetUnitFacingToFaceUnitTimed(gg_unit_Ocb2_0147,gg_unit_Ocbh_0148,1.)
            call Text_Say(gg_unit_Ocb2_0147,"Yeah, bro, but we lost.",false)
            call Text_Say(gg_unit_Ocbh_0148,"Well, one can't always win.",false)
            call Text_Say(gg_unit_Ocb2_0147,"That's right, bro.",false)
            call SetUnitFacingTimed(gg_unit_Ocb2_0147,bj_UNIT_FACING,0)
            call SetUnitFacingTimed(gg_unit_Ocbh_0148,bj_UNIT_FACING,0)
            call Text_Say(gg_unit_Ocb2_0147,"Mighty ones, we shall fulfill your wish.",false)
            call Text_Say(gg_unit_Ocbh_0148,"What are your orders?",false)
            if(Trig_Quest_Brothers_Defeated_Cond_KillerNotPlaying())then
                set udg_TempPlayer=ForcePickRandomPlayer(udg_PlayingPlayers)
            endif
            call Text_Say(Player_GetHero(udg_TempPlayer),"Guard the town of Kalm from any enemies that may threaten town's inhabitants.",false)
            call Text_Say(gg_unit_Ocbh_0148,"I hope guarding will involve bashing someone's head!",false)
            call Text_Say(gg_unit_Ocb2_0147,"We shall do as you command.",false)
            call Cine_ExitAction()
        endif
        // the log now says to return to Izlude, who is pinged on the minimap
        call Quest_StepDone(QUEST_BROTHERS,GetOwningPlayer(l_killer),l_killer)
        set l_tempPoint=GetRectCenter(gg_rct_235)
        call SetUnitPositionLoc(gg_unit_Ocb2_0147,l_tempPoint)
        call RemoveLocation(l_tempPoint)
        set l_tempPoint=GetRectCenter(gg_rct_376)
        call SetUnitPositionLoc(gg_unit_Ocbh_0148,l_tempPoint)
        call RemoveLocation(l_tempPoint)
        call SetUnitFacingTimed(gg_unit_Ocb2_0147,GetUnitFacing(gg_unit_hhes_0087),0)
        call SetUnitFacingTimed(gg_unit_Ocbh_0148,GetUnitFacing(gg_unit_hhes_0087),0)
        call SetUnitOwner(gg_unit_Ocb2_0147,Player(9),true)
        call SetUnitOwner(gg_unit_Ocbh_0148,Player(9),true)
        call IssueImmediateOrderBJ(gg_unit_Ocb2_0147,"holdposition")
        call IssueImmediateOrderBJ(gg_unit_Ocbh_0148,"holdposition")
        call GroupAddUnitSimple(gg_unit_Ocb2_0147,udg_RecruitedAllies)
        call GroupAddUnitSimple(gg_unit_Ocbh_0148,udg_RecruitedAllies)
        if(Trig_Quest_Brothers_Defeated_Cond_TownGuardsPresent())then
            call ShowUnitHide(gg_unit_Ocb2_0147)
            call ShowUnitHide(gg_unit_Ocbh_0148)
        endif
        if(Trig_Quest_Brothers_Defeated_Cond_Quest11Completed())then
            call SetHeroLevelBJ(gg_unit_Ocbh_0148,50,false)
            call SetHeroLevelBJ(gg_unit_Ocb2_0147,60,false)
            call ModifyHeroStat(bj_HEROSTAT_STR,gg_unit_Ocb2_0147,bj_MODIFYMETHOD_ADD,$FA) // $FA = 250
            call ModifyHeroStat(bj_HEROSTAT_STR,gg_unit_Ocbh_0148,bj_MODIFYMETHOD_ADD,$FA) // $FA = 250
            call ModifyHeroStat(bj_HEROSTAT_AGI,gg_unit_Ocb2_0147,bj_MODIFYMETHOD_ADD,$C8) // $C8 = 200
            call ModifyHeroStat(bj_HEROSTAT_AGI,gg_unit_Ocbh_0148,bj_MODIFYMETHOD_ADD,$C8) // $C8 = 200
            call ModifyHeroStat(bj_HEROSTAT_INT,gg_unit_Ocb2_0147,bj_MODIFYMETHOD_ADD,$C8) // $C8 = 200
            call ModifyHeroStat(bj_HEROSTAT_INT,gg_unit_Ocbh_0148,bj_MODIFYMETHOD_ADD,$C8) // $C8 = 200
        else
            if(Trig_Quest_Brothers_Defeated_Cond_Quest10Completed())then
                call SetHeroLevelBJ(gg_unit_Ocbh_0148,45,false)
                call SetHeroLevelBJ(gg_unit_Ocb2_0147,50,false)
            else
                if(Trig_Quest_Brothers_Defeated_Cond_Quest9Completed())then
                    call SetHeroLevelBJ(gg_unit_Ocbh_0148,35,false)
                    call SetHeroLevelBJ(gg_unit_Ocb2_0147,45,false)
                else
                    call SetHeroLevelBJ(gg_unit_Ocbh_0148,25,false)
                    call SetHeroLevelBJ(gg_unit_Ocb2_0147,35,false)
                endif
            endif
        endif
        call SaveIntegerBJ(1,2,'n',udg_GameStateHash)
        call EnableTrigger(gg_trg_Brothers_Alert_Eidolons)
        call StartTimerBJ(udg_SharedDelayTimer4,false,30.)
        call DestroyTrigger(GetTriggeringTrigger())
    endif
    set l_tempPoint=null
    set l_killer=null
endfunction

function InitTrig_Quest_Brothers takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Quest_Part9 (module Quest),
// which keeps the original registration order.

function Register_Quest_Brothers_Init takes nothing returns nothing
    set gg_trg_Quest_Brothers_Init=CreateTrigger()
    call TriggerAddAction(gg_trg_Quest_Brothers_Init,function Trig_Quest_Brothers_Init_Actions)
endfunction

function Register_Quest_Brothers_Available takes nothing returns nothing
    set gg_trg_Quest_Brothers_Available=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_Brothers_Available)
    call TriggerAddAction(gg_trg_Quest_Brothers_Available,function Trig_Quest_Brothers_Available_Actions)
endfunction

function Register_Quest_Brothers_Start takes nothing returns nothing
    set gg_trg_Quest_Brothers_Start=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_Brothers_Start)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Brothers_Start,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Brothers_Start,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Brothers_Start,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Brothers_Start,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Brothers_Start,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Brothers_Start,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Brothers_Start,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Brothers_Start,Player(7),true)
    call TriggerAddCondition(gg_trg_Quest_Brothers_Start,Condition(function Trig_Quest_Brothers_Start_Conditions))
    call TriggerAddAction(gg_trg_Quest_Brothers_Start,function Trig_Quest_Brothers_Start_Actions)
endfunction

function Register_Quest_Brothers_Defeated takes nothing returns nothing
    set gg_trg_Quest_Brothers_Defeated=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_Brothers_Defeated)
    call TriggerRegisterUnitEvent(gg_trg_Quest_Brothers_Defeated,gg_unit_Ocb2_0147,EVENT_UNIT_DEATH)
    call TriggerRegisterUnitEvent(gg_trg_Quest_Brothers_Defeated,gg_unit_Ocbh_0148,EVENT_UNIT_DEATH)
    call TriggerAddAction(gg_trg_Quest_Brothers_Defeated,function Trig_Quest_Brothers_Defeated_Actions)
endfunction

endlibrary
