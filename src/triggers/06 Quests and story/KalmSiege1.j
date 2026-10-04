library TKalmSiege1 requires TQuestEngine, TCam, TCine, TGroup, TLoc, TMusic, TPlayerHero, TReward, TText, TUnit, TWait
// Main quest "Kalm Siege" (udg_MainQuest[9]), run by the quest engine (QuestEngine module,
// docs/QUEST_ENGINE.md). After Zalera falls, Cid asks the party to help Meliadoul defend Kalm. All steps are
// custom and stay in this module's triggers: Start (talk to Cid) calls Quest_Start, Briefing (talk to
// Meliadoul) starts the 30 second countdown, and Complete (the siege is won) finishes the quest. If
// Meliadoul falls the party may retry (Defeat, Briefing again) or, in hardcore, the quest fails (Fail).
// The "!" and "?" over Cid and Meliadoul are this module's own effects. Talking to Cid counts toward the
// story once more, besides the engine's count when the quest is done.
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_KalmSiege1_Start=null
    trigger gg_trg_KalmSiege1_Briefing=null
    trigger gg_trg_KalmSiege1_Begin=null
    trigger gg_trg_KalmSiege1_Defeat=null
    trigger gg_trg_KalmSiege1_TrackDeaths=null
    trigger gg_trg_KalmSiege1_Complete=null
    trigger gg_trg_KalmSiege1_Fail=null
    // The quest's number in the quest engine (0 until it is defined).
    integer QUEST_KALM_SIEGE=0
endglobals

function KalmSiege1_Define takes nothing returns nothing
    local integer q=Quest_Define("Kalm Siege",QUEST_MAIN,9,"ReplaceableTextures\\CommandButtons\\BTNSylvanusWindrunner.blp")
    set QUEST_KALM_SIEGE=q
    call Quest_Color(q,udg_QuestNamePrefix)
    call Quest_NoMarker(q)
    // 1. Talk to Cid (gg_trg_KalmSiege1_Start)
    call Quest_Custom(q,"Kalm is under attack! Cid asked you to speak to Meliadoul to help with the defenses.")
    // 2. Talk to Meliadoul (gg_trg_KalmSiege1_Briefing); a retry after a defeat is not a step
    call Quest_Custom(q,"Defend Kalm from the siege starting in 30 seconds!\r\n\r\nMeliadoul must survive!")
    call Quest_Message(q,"Defend Kalm from the siege starting in 30 seconds!\r\n- Meliadoul must survive!")
    // 3. Win the siege (gg_trg_KalmSiege1_Complete)
    call Quest_Custom(q,"")
endfunction

function Trig_KalmSiege1_Start_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_Hpb1_0013,true,true,true))
endfunction

function Trig_KalmSiege1_Start_ApplyCamera takes nothing returns nothing
    call CameraSetupApplyForPlayer(true,gg_cam_001,GetEnumPlayer(),0)
endfunction

function Trig_KalmSiege1_Start_CinematicsOn takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

// Step 1: a hero talks to Cid. The quest starts and Meliadoul waits for the party.
function Trig_KalmSiege1_Start_Actions takes nothing returns nothing
    local location l_tempPoint
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[30])
    call GroupRemoveUnitSimple(gg_unit_Hpb1_0013,udg_QuestUnits)
    if(Trig_KalmSiege1_Start_CinematicsOn())then
        call Cine_Enter()
        call ForForce(udg_PlayingPlayers,function Trig_KalmSiege1_Start_ApplyCamera)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"We've heard you're in trouble. What's going on?",false)
        call Text_Say(gg_unit_Hpb1_0013,"Thank god you're here. I have dire news. The monsters around here have grown more and more aggressive and are now laying siege to our town.",false)
        call Text_Say(udg_Mid,"We've kept them at bay until now, but at this rate we won't hold out.",false)
        call Text_Say(gg_unit_Hpb1_0013,"This increase in aggression is incredibly sudden. Do you know what's going on?",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Yeah... it's a long story, but it looks like things will remain dire for a while. Don't worry, we will help defend this town.",false)
        call Text_Say(gg_unit_Hpb1_0013,"It is reassuring to have you here in these times.",false)
        call Text_Say(gg_unit_Hpb1_0013,"Please talk with our first ranger, Meliadoul, near the north gate. She's in charge of our defenses.",false)
        call Cine_ExitAction()
    endif
    if QUEST_KALM_SIEGE==0 then
        call KalmSiege1_Define()
    endif
    call Quest_Start(QUEST_KALM_SIEGE,GetTriggerPlayer(),GetTriggerUnit())
    // the talk with Cid counts toward the story on its own (the engine counts the quest when it is done)
    set udg_StoryProgress=(udg_StoryProgress+1)
    call ConditionalTriggerExecute(gg_trg_QuestCount_Milestones)
    call GroupAddUnitSimple(gg_unit_Hvwd_0098,udg_QuestUnits)
    set l_tempPoint=GetRectCenter(gg_rct_585)
    call SetUnitPositionLocFacingBJ(gg_unit_Hvwd_0098,l_tempPoint,315.)
    call RemoveLocation(l_tempPoint)
    call IssueImmediateOrderBJ(gg_unit_Hvwd_0098,"holdposition")
    set udg_SpecialEffect[30]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_Hvwd_0098,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call EnableTrigger(gg_trg_KalmSiege1_Briefing)
    set udg_ShadowForcedSpawn=1
    set udg_SpecialEffect[89]=AddSpecialEffectTargetUnitBJ("overhead",udg_Mid,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call EnableTrigger(gg_trg_Mid_Letter_Give)
    call DestroyTrigger(GetTriggeringTrigger())
    set l_tempPoint=null
endfunction

function Trig_KalmSiege1_Briefing_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_Hvwd_0098,true,true,true))
endfunction

function Trig_KalmSiege1_Briefing_CinematicsOn takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

// Step 2: a hero talks to Meliadoul (again after a defeat): the siege starts in 30 seconds.
function Trig_KalmSiege1_Briefing_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[30])
    if(Trig_KalmSiege1_Briefing_CinematicsOn())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(gg_unit_Hvwd_0098,"Damn it, they're gearing up for another attack!",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"You're the first ranger, Meliadoul, correct? We're here to help.",false)
        call Text_Say(gg_unit_Hvwd_0098,"Ah, you're the adventurers? I've heard about you. Thanks, you'll be a great help.",false)
        call Text_Say(gg_unit_Hvwd_0098,"They monsters have just suddenly started getting much more aggressive. They must be led by some evil force.",false)
        call Text_Say(gg_unit_Hvwd_0098,"Sadly I don't have much time to explain or chitchat. The attack is about to start!",false)
        call Text_Say(gg_unit_Hvwd_0098,"It looks like they'll be here in |cffffcc0030 seconds|r! Get ready to fight!",false)
        call Cine_ExitAction()
    endif
    set udg_SpecialEffect[30]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_Hvwd_0098,"Objects\\RandomObject\\RandomObject.mdl")
    if Quest_CurrentStep(QUEST_KALM_SIEGE)==2 then
        call Quest_StepDone(QUEST_KALM_SIEGE,GetTriggerPlayer(),GetTriggerUnit())
    else
        // a retry after a defeat: the same update as the first time
        call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_UPDATED,"Defend Kalm from the siege starting in 30 seconds!\r\n- Meliadoul must survive!")
        call Quest_SetLog(QUEST_KALM_SIEGE,"Defend Kalm from the siege starting in 30 seconds!\r\n\r\nMeliadoul must survive!",false)
    endif
    call StartTimerBJ(udg_SiegeTimer,false,30)
    set udg_SiegeTimerWindow=CreateTimerDialogBJ(GetLastCreatedTimerBJ(),"Kalm Siege in ...")
    call EnableTrigger(gg_trg_KalmSiege1_Begin)
endfunction

function Trig_KalmSiege1_Begin_CinematicBusy takes nothing returns boolean
    return(udg_InCinematicMode)
endfunction

function Trig_KalmSiege1_Begin_CinematicsOn takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_KalmSiege1_Begin_RetryEnabled takes nothing returns boolean
    return(udg_HardcoreOff)
endfunction

function Trig_KalmSiege1_Begin_ScalingOff takes nothing returns boolean
    return(udg_EternityMode==false)
endfunction

function Trig_KalmSiege1_Begin_IsShieldSlot takes nothing returns boolean
    // The remainder after dividing (loop counter A) by (9).
    return(ModuloInteger(GetForLoopIndexA(),9)==0)
endfunction

function Trig_KalmSiege1_Begin_IsGhoulMasterSlot takes nothing returns boolean
    // The remainder after dividing (loop counter A) by (19).
    return(udg_GhoulMasterDisabled==false)and(ModuloInteger(GetForLoopIndexA(),19)==1)
endfunction

function Trig_KalmSiege1_Begin_SendGuardPatrol takes nothing returns nothing
    local location l_tempPoint
    local location l_tempPoint2
    set l_tempPoint=GetUnitLoc(GetEnumUnit())
    set l_tempPoint2=Loc_PolarOffset(l_tempPoint,1024.,GetUnitFacing(GetEnumUnit()))
    call RemoveLocation(l_tempPoint)
    call IssuePointOrderLocBJ(GetEnumUnit(),"patrol",l_tempPoint2)
    call RemoveLocation(l_tempPoint2)
    call PauseUnitBJ(false,GetEnumUnit())
    set l_tempPoint=null
    set l_tempPoint2=null
endfunction

function Trig_KalmSiege1_Begin_SendGuardForward takes nothing returns nothing
    local location l_tempPoint
    local location l_tempPoint2
    set l_tempPoint=GetUnitLoc(GetEnumUnit())
    set l_tempPoint2=Loc_PolarOffset(l_tempPoint,384.,GetUnitFacing(GetEnumUnit()))
    call RemoveLocation(l_tempPoint)
    call IssuePointOrderLocBJ(GetEnumUnit(),"move",l_tempPoint2)
    call RemoveLocation(l_tempPoint2)
    call PauseUnitBJ(false,GetEnumUnit())
    set l_tempPoint=null
    set l_tempPoint2=null
endfunction

function Trig_KalmSiege1_Begin_Actions takes nothing returns nothing
    local location l_tempPoint2
    if(Trig_KalmSiege1_Begin_CinematicBusy())then
        call StartTimerBJ(udg_SiegeTimer,false,.49)
        set l_tempPoint2=null
        return
    endif
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyTimerDialogBJ(udg_SiegeTimerWindow)
    call Cine_Enter()
    call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUT,1.,"ReplaceableTextures\\CameraMasks\\White_mask.blp",0,0,0,0)
    call GroupRemoveUnitSimple(gg_unit_Hvwd_0098,udg_QuestUnits)
    call Wait_Polled(1.5)
    call DestroyEffectBJ(udg_SpecialEffect[30])
    call ConditionalTriggerExecute(gg_trg_Spawn_KalmDefenders)
    set udg_SpecialEffect[30]=AddSpecialEffectTargetUnitBJ("overhead",udg_RangerHero,"Objects\\RandomObject\\RandomObject.mdl")
    call Wait_Polled(.5)
    call CinematicFadeBJ(bj_CINEFADETYPE_FADEIN,1.,"ReplaceableTextures\\CameraMasks\\White_mask.blp",0,0,0,0)
    call Wait_Polled(1.5)
    if(Trig_KalmSiege1_Begin_CinematicsOn())then
        call Cam_PanToUnit(udg_RangerHero,1.)
        call Wait_Polled(1.)
        call Text_Say(udg_RangerHero,"Everybody! Protect our city!",false)
        call Text_Say(udg_RangerHero,"For our people!",false)
    endif
    call Cine_ExitAction()
    call Music_SetTrack(39)
    if(Trig_KalmSiege1_Begin_RetryEnabled())then
        call EnableTrigger(gg_trg_KalmSiege1_Defeat)
    else
        call EnableTrigger(gg_trg_KalmSiege1_Fail)
    endif
    call EnableTrigger(gg_trg_KalmSiege1_TrackDeaths)
    call EnableTrigger(gg_trg_KalmSiege_AITick)
    call EnableTrigger(gg_trg_KalmSiege_LeaderRetreat)
    set l_tempPoint2=GetRectCenter(gg_rct_584)
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=LoadIntegerBJ(4,2,udg_SpawnDataHashRef)
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        set udg_TempPoint=GetRectCenter(LoadRectHandleBJ(GetForLoopIndexA(),4,udg_SpawnRectHashRef))
        // The remainder after dividing (loop counter A) by (10).
        call CreateNUnitsAtLocFacingLocBJ(1,udg_SiegeNorthUnitType[ModuloInteger(GetForLoopIndexA(),$A)],Player($B),udg_TempPoint,l_tempPoint2) // $A = 10; $B = 11
        call RemoveLocation(udg_TempPoint)
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_SpecialUnits)
        if(Trig_KalmSiege1_Begin_ScalingOff())then
            call BlzSetUnitBaseDamage(GetLastCreatedUnit(),(BlzGetUnitBaseDamage(GetLastCreatedUnit(),0)*4),(1-1))
            call BlzSetUnitBaseDamage(GetLastCreatedUnit(),(BlzGetUnitBaseDamage(GetLastCreatedUnit(),1)*4),1)
            call BlzSetUnitMaxHP(GetLastCreatedUnit(),(BlzGetUnitMaxHP(GetLastCreatedUnit())*4))
            call SetUnitLifePercentBJ(GetLastCreatedUnit(),'d')
        else
            call Unit_ScaleToLevel60(bj_lastCreatedUnit)
        endif
        call SetUnitAcquireRangeBJ(GetLastCreatedUnit(),600.)
        call IssuePointOrderLocBJ(GetLastCreatedUnit(),"attack",l_tempPoint2)
        if(Trig_KalmSiege1_Begin_IsShieldSlot())then
            call UnitAddAbilityBJ('A0YK',GetLastCreatedUnit()) // 'A0YK': ability "Permanent Lightning Shield"
            call GroupAddUnitSimple(GetLastCreatedUnit(),udg_ShockAuraUnitGroup)
        endif
        if(Trig_KalmSiege1_Begin_IsGhoulMasterSlot())then
            call UnitAddAbilityBJ('A0RB',GetLastCreatedUnit()) // 'A0RB': ability "Ghoul Master"
            call UnitAddAbilityBJ('ACvp',GetLastCreatedUnit()) // 'ACvp': object name not found in map data
        endif
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    call RemoveLocation(l_tempPoint2)
    call Wait_Polled(.2)
    call ForGroupBJ(udg_AllyBrothersGroup,function Trig_KalmSiege1_Begin_SendGuardPatrol)
    call Wait_Polled(.2)
    call ForGroupBJ(udg_AllyRangerGroup,function Trig_KalmSiege1_Begin_SendGuardForward)
    set l_tempPoint2=null
endfunction

function Trig_KalmSiege1_Defeat_Conditions takes nothing returns boolean
    return(GetTriggerUnit()==udg_RangerHero)
endfunction

function Trig_KalmSiege1_Defeat_CinematicBusy takes nothing returns boolean
    return(udg_InCinematicMode)
endfunction

function Trig_KalmSiege1_Defeat_StripMonsterBuffs takes nothing returns nothing
    call UnitAddAbilityBJ('A0QY',GetEnumUnit()) // 'A0QY': ability "Devalued"
    call UnitRemoveAbilityBJ('A0YK',GetEnumUnit()) // 'A0YK': ability "Permanent Lightning Shield"
    call GroupRemoveUnitSimple(GetEnumUnit(),udg_ShockAuraUnitGroup)
endfunction

function Trig_KalmSiege1_Defeat_KilledByPlayer takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetKillingUnitBJ()),udg_PlayingPlayers))
endfunction

function Trig_KalmSiege1_Defeat_CinematicsOn takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_KalmSiege1_Defeat_KillGuard takes nothing returns nothing
    call KillUnit(GetEnumUnit())
endfunction

function Trig_KalmSiege1_Defeat_KillDefender takes nothing returns nothing
    call KillUnit(GetEnumUnit())
endfunction

function Trig_KalmSiege1_Defeat_RemoveSummon takes nothing returns nothing
    call RemoveUnit(GetEnumUnit())
endfunction

function Trig_KalmSiege1_Defeat_KillAndRemove takes nothing returns nothing
    call KillUnit(GetEnumUnit())
    call RemoveUnit(GetEnumUnit())
endfunction

function Trig_KalmSiege1_Defeat_ShowTownUnit takes nothing returns nothing
    call ShowUnitShow(GetEnumUnit())
endfunction

function Trig_KalmSiege1_Defeat_Actions takes nothing returns nothing
    if(Trig_KalmSiege1_Defeat_CinematicBusy())then
        set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
        call ReviveHeroLoc(udg_RangerHero,udg_TempPoint,false)
        call RemoveLocation(udg_TempPoint)
        call SetUnitLifeBJ(GetTriggerUnit(),1.)
        return
    endif
    call DisableTrigger(gg_trg_KalmSiege1_TrackDeaths)
    call DisableTrigger(gg_trg_KalmSiege_AITick)
    call DisableTrigger(gg_trg_KalmSiege_LeaderRetreat)
    call ForGroupBJ(udg_SpecialUnits,function Trig_KalmSiege1_Defeat_StripMonsterBuffs)
    call Cine_Enter()
    call Cam_PanToUnit(udg_RangerHero,0)
    call DestroyEffectBJ(udg_SpecialEffect[30])
    call Wait_Polled(1.)
    call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUT,1.,"ReplaceableTextures\\CameraMasks\\White_mask.blp",0,0,0,0)
    call Wait_Polled(1.5)
    call Music_ClearTrack(39)
    call PlayThematicMusicBJ("war3mapImported\\FF7GameOver.mp3")
    if(Trig_KalmSiege1_Defeat_CinematicsOn())then
        if(Trig_KalmSiege1_Defeat_KilledByPlayer())then
            call Text_Say(null,"After being betrayed by the adventurers they trusted, Kalm was quickly overrun by monsters...",true)
        else
            call Text_Say(null,"With the fall of their defense line, Kalm was quickly overrun by monsters...",true)
        endif
    endif
    call ForGroupBJ(udg_AllyBrothersGroup,function Trig_KalmSiege1_Defeat_KillGuard)
    call ForGroupBJ(udg_AllyRangerGroup,function Trig_KalmSiege1_Defeat_KillDefender)
    call ForGroupBJ(udg_InactiveUnits,function Trig_KalmSiege1_Defeat_RemoveSummon)
    call ForGroupBJ(udg_SpecialUnits,function Trig_KalmSiege1_Defeat_KillAndRemove)
    call ForGroupBJ(udg_RecruitedAllies,function Trig_KalmSiege1_Defeat_ShowTownUnit)
    set udg_SpecialEffect[30]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_Hvwd_0098,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call EnableTrigger(gg_trg_KalmSiege1_Briefing)
    call GroupAddUnitSimple(gg_unit_Hvwd_0098,udg_QuestUnits)
    call Quest_SetLog(QUEST_KALM_SIEGE,"Speak to Meliadoul to retry the Siege.",false)
    call Text_Say(null,"|cffffcc00Speak to Meliadoul to retry the Siege.\r\n\r\nYou may want to search for additional allies first!|r",true)
    call CinematicFadeBJ(bj_CINEFADETYPE_FADEIN,1.,"ReplaceableTextures\\CameraMasks\\White_mask.blp",0,0,0,0)
    call Cine_ExitAction()
endfunction

function Trig_KalmSiege1_TrackDeaths_Conditions takes nothing returns boolean
    return(IsUnitInGroup(GetTriggerUnit(),udg_SpecialUnits))
endfunction

function Trig_KalmSiege1_TrackDeaths_IsTempSpawn takes nothing returns boolean
    return(IsUnitInGroup(GetTriggerUnit(),udg_SiegeSummonGroup))
endfunction

function Trig_KalmSiege1_TrackDeaths_WaveCleared takes nothing returns boolean
    return(IsUnitGroupEmptyBJ(udg_SpecialUnits))and(IsUnitGroupEmptyBJ(udg_EscortUnits))
endfunction

function Trig_KalmSiege1_TrackDeaths_Actions takes nothing returns nothing
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_SpecialUnits)
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_ShockAuraUnitGroup)
    call UnitRemoveAbilityBJ('A0YK',GetTriggerUnit()) // 'A0YK': ability "Permanent Lightning Shield"
    if(Trig_KalmSiege1_TrackDeaths_IsTempSpawn())then
        call GroupRemoveUnitSimple(GetTriggerUnit(),udg_SiegeSummonGroup)
        set udg_TempPoint3=GetUnitLoc(GetTriggerUnit())
        call AddSpecialEffectLocBJ(udg_TempPoint3,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportTarget.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint3)
        call RemoveUnit(GetTriggerUnit())
    endif
    if(Trig_KalmSiege1_TrackDeaths_WaveCleared())then
        call DisableTrigger(GetTriggeringTrigger())
        call StartTimerBJ(udg_SiegeTimer,false,5.)
        call SetUnitInvulnerable(udg_RangerHero,true)
        call DisableTrigger(gg_trg_KalmSiege1_Defeat)
        call DisableTrigger(gg_trg_KalmSiege1_Fail)
        call DisableTrigger(gg_trg_KalmSiege_AITick)
        call DisableTrigger(gg_trg_KalmSiege_LeaderRetreat)
        call EnableTrigger(gg_trg_KalmSiege1_Complete)
        call DestroyTrigger(GetTriggeringTrigger())
    endif
endfunction

function Trig_KalmSiege1_Complete_CinematicBusy takes nothing returns boolean
    return(udg_InCinematicMode)
endfunction

function Trig_KalmSiege1_Complete_CinematicsOn takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_KalmSiege1_Complete_KillGuard takes nothing returns nothing
    call KillUnit(GetEnumUnit())
endfunction

function Trig_KalmSiege1_Complete_KillDefender takes nothing returns nothing
    call KillUnit(GetEnumUnit())
endfunction

function Trig_KalmSiege1_Complete_RemoveSummon takes nothing returns nothing
    call RemoveUnit(GetEnumUnit())
endfunction

function Trig_KalmSiege1_Complete_RemoveMonster takes nothing returns nothing
    call RemoveUnit(GetEnumUnit())
endfunction

function Trig_KalmSiege1_Complete_ShowTownUnit takes nothing returns nothing
    call ShowUnitShow(GetEnumUnit())
endfunction

function Trig_KalmSiege1_Complete_CompanionsPresent takes nothing returns boolean
    return(IsUnitInGroup(gg_unit_Ocbh_0148,udg_RecruitedAllies))
endfunction

// Step 3: the siege is won. Meliadoul rewards the party; the quest is done (and counted by the engine).
function Trig_KalmSiege1_Complete_Actions takes nothing returns nothing
    if(Trig_KalmSiege1_Complete_CinematicBusy())then
        call StartTimerBJ(udg_SiegeTimer,false,1.)
        return
    endif
    call Cine_Enter()
    call DestroyEffectBJ(udg_SpecialEffect[30])
    if(Trig_KalmSiege1_Complete_CinematicsOn())then
        call Cam_PanToUnit(udg_RangerHero,0)
        call Wait_Polled(1.)
        call Text_Say(udg_RangerHero,"We've done it... we've fought them off.",false)
        call Text_Say(udg_RangerHero,"Great work. We couldn't have done it without your help.",false)
        call Reward_Give(5000,$FA0,udg_RangerHero) // $FA0 = 4000
        call Text_Say(udg_RangerHero,"We may have yet to face more of these attacks. I will call for you if it happens again.",false)
        call Text_Say(udg_RangerHero,"For now let us rest while we still can.",false)
    else
        call Reward_Give(5000,$FA0,udg_RangerHero) // $FA0 = 4000
    endif
    call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUT,1.,"ReplaceableTextures\\CameraMasks\\White_mask.blp",0,0,0,0)
    call Wait_Polled(1.25)
    call ForGroupBJ(udg_AllyBrothersGroup,function Trig_KalmSiege1_Complete_KillGuard)
    call ForGroupBJ(udg_AllyRangerGroup,function Trig_KalmSiege1_Complete_KillDefender)
    call ForGroupBJ(udg_InactiveUnits,function Trig_KalmSiege1_Complete_RemoveSummon)
    call ForGroupBJ(udg_SpecialUnits,function Trig_KalmSiege1_Complete_RemoveMonster)
    call ForGroupBJ(udg_RecruitedAllies,function Trig_KalmSiege1_Complete_ShowTownUnit)
    call DestroyTrigger(gg_trg_KalmSiege1_Briefing)
    call DestroyTrigger(gg_trg_KalmSiege1_Begin)
    call DestroyTrigger(gg_trg_KalmSiege1_Defeat)
    call DestroyTrigger(gg_trg_KalmSiege1_Fail)
    if(Trig_KalmSiege1_Complete_CompanionsPresent())then
        call SetHeroLevelBJ(gg_unit_Ocbh_0148,35,false)
        call SetHeroLevelBJ(gg_unit_Ocb2_0147,45,false)
    endif
    call Wait_Polled(.25)
    call Music_ClearTrack(39)
    call CinematicFadeBJ(bj_CINEFADETYPE_FADEIN,1.,"ReplaceableTextures\\CameraMasks\\White_mask.blp",0,0,0,0)
    if Quest_IsDone(QUEST_KALM_SIEGE) then
        // This trigger is never turned off, so it runs again each time the siege timer expires; as in the
        // original map, the quest is then announced and counted again.
        call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_COMPLETED,"Quest Completed: |cffffcc00Kalm Siege|r")
        call QuestSetCompletedBJ(Quest_LogEntry(QUEST_KALM_SIEGE),true)
        set udg_QuestsCompleted=(udg_QuestsCompleted+1)
        set udg_StoryProgress=(udg_StoryProgress+1)
        call ConditionalTriggerExecute(gg_trg_QuestCount_Milestones)
    else
        call Quest_StepDone(QUEST_KALM_SIEGE,null,null)
    endif
    call ConditionalTriggerExecute(gg_trg_Priscilla_ShowMarker)
    call StartTimerBJ(udg_SiegeTimer,false,300.)
    call EnableTrigger(gg_trg_KalmSiege2_Call)
    call Cine_ExitAction()
endfunction

function Trig_KalmSiege1_Fail_Conditions takes nothing returns boolean
    return(GetTriggerUnit()==udg_RangerHero)
endfunction

function Trig_KalmSiege1_Fail_IsTownUnit takes nothing returns boolean
    return(GetOwningPlayer(GetFilterUnit())==Player(9))
endfunction

function Trig_KalmSiege1_Fail_MakeVulnerable takes nothing returns nothing
    call SetUnitInvulnerable(GetEnumUnit(),false)
endfunction

function Trig_KalmSiege1_Fail_IsMonsterOwned takes nothing returns boolean
    return(GetOwningPlayer(GetEnumUnit())==Player($B)) // $B = 11
endfunction

function Trig_KalmSiege1_Fail_PurgeOrShow takes nothing returns nothing
    if(Trig_KalmSiege1_Fail_IsMonsterOwned())then
        call ShowUnitShow(GetEnumUnit())
    else
        call KillUnit(GetEnumUnit())
        call RemoveUnit(GetEnumUnit())
    endif
endfunction

function Trig_KalmSiege1_Fail_IsThirdSlot takes nothing returns boolean
    // The remainder after dividing (loop counter A) by (3).
    return(ModuloInteger(GetForLoopIndexA(),3)==0)
endfunction

function Trig_KalmSiege1_Fail_Actions takes nothing returns nothing
    local location l_tempPoint
    local location l_tempPoint2
    call DisableTrigger(GetTriggeringTrigger())
    call Music_ClearTrack(39)
    call Music_SetZoneTrack(9)
    call Quest_Fail(QUEST_KALM_SIEGE)
    call DestroyGroup(udg_TownTargetGroup)
    set l_tempPoint=GetUnitLoc(gg_unit_Hpb1_0013)
    set udg_TownTargetGroup=Group_UnitsInRangeOfLoc(8192.,l_tempPoint,Condition(function Trig_KalmSiege1_Fail_IsTownUnit))
    call RemoveLocation(l_tempPoint)
    call ForGroupBJ(udg_TownTargetGroup,function Trig_KalmSiege1_Fail_MakeVulnerable)
    call EnableTrigger(gg_trg_KalmSiege_FailRespawn)
    call EnableTrigger(gg_trg_KalmSiege_DemonRecover)
    call ForGroupBJ(udg_RecruitedAllies,function Trig_KalmSiege1_Fail_PurgeOrShow)
    set l_tempPoint=GetRectCenter(gg_rct_298)
    call SetUnitPositionLoc(gg_unit_U00E_0222,l_tempPoint)
    call RemoveLocation(l_tempPoint)
    set l_tempPoint=GetRectCenter(gg_rct_413)
    call IssuePointOrderLocBJ(gg_unit_U00E_0222,"attack",l_tempPoint)
    call RemoveLocation(l_tempPoint)
    call ShowUnitShow(gg_unit_U00E_0222)
    call PauseUnitBJ(false,gg_unit_U00E_0222)
    call SetUnitInvulnerable(gg_unit_U00E_0222,false)
    call UnitAddAbilityBJ('A0ZR',gg_unit_U00E_0222) // 'A0ZR': ability "Immortal"
    call UnitAddAbilityBJ('A15D',gg_unit_U00E_0222) // 'A15D': ability "Thunder Boost"
    call UnitAddAbilityBJ('A0M9',gg_unit_U00E_0222) // 'A0M9': ability "Thunder Orb Amplification"
    call UnitAddAbilityBJ('A0LL',gg_unit_U00E_0222) // 'A0LL': ability "Thunder Spell Amplification"
    call SetUnitMoveSpeed(gg_unit_U00E_0222,500.)
    set udg_RaidPowerLevel=30
    set l_tempPoint2=GetRectCenter(gg_rct_588)
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=LoadIntegerBJ(4,2,udg_SpawnDataHashRef)
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        if(Trig_KalmSiege1_Fail_IsThirdSlot())then
            set l_tempPoint=GetRectCenter(LoadRectHandleBJ(GetForLoopIndexA(),4,udg_SpawnRectHashRef))
            // The remainder after dividing (loop counter A) by (10).
            call CreateNUnitsAtLocFacingLocBJ(1,udg_SiegeNorthUnitType[ModuloInteger(GetForLoopIndexA(),$A)],Player($B),l_tempPoint,l_tempPoint2) // $A = 10; $B = 11
            call RemoveLocation(l_tempPoint)
            call GroupAddUnitSimple(GetLastCreatedUnit(),udg_EscortUnits)
            call BlzSetUnitBaseDamage(GetLastCreatedUnit(),((BlzGetUnitBaseDamage(GetLastCreatedUnit(),0)*udg_RaidPowerLevel)/ 4),(1-1))
            call BlzSetUnitBaseDamage(GetLastCreatedUnit(),((BlzGetUnitBaseDamage(GetLastCreatedUnit(),1)*udg_RaidPowerLevel)/ 4),1)
            call BlzSetUnitMaxHP(GetLastCreatedUnit(),((BlzGetUnitMaxHP(GetLastCreatedUnit())*udg_RaidPowerLevel)/ 4))
            call SetUnitLifePercentBJ(GetLastCreatedUnit(),'d')
            call SetUnitAcquireRangeBJ(GetLastCreatedUnit(),800.)
            call IssuePointOrderLocBJ(GetLastCreatedUnit(),"attack",l_tempPoint2)
        endif
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    call RemoveLocation(l_tempPoint2)
    call DestroyTrigger(GetTriggeringTrigger())
    set l_tempPoint=null
    set l_tempPoint2=null
endfunction

// World Editor calls InitTrig_KalmSiege1 automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_KalmSiege1 (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_KalmSiege1 takes nothing returns nothing
endfunction

function Register_KalmSiege1_Start takes nothing returns nothing
    set gg_trg_KalmSiege1_Start=CreateTrigger()
    call DisableTrigger(gg_trg_KalmSiege1_Start)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_KalmSiege1_Start,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_KalmSiege1_Start,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_KalmSiege1_Start,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_KalmSiege1_Start,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_KalmSiege1_Start,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_KalmSiege1_Start,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_KalmSiege1_Start,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_KalmSiege1_Start,Player(7),true)
    call TriggerAddCondition(gg_trg_KalmSiege1_Start,Condition(function Trig_KalmSiege1_Start_Conditions))
    call TriggerAddAction(gg_trg_KalmSiege1_Start,function Trig_KalmSiege1_Start_Actions)
endfunction

function Register_KalmSiege1_Briefing takes nothing returns nothing
    set gg_trg_KalmSiege1_Briefing=CreateTrigger()
    call DisableTrigger(gg_trg_KalmSiege1_Briefing)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_KalmSiege1_Briefing,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_KalmSiege1_Briefing,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_KalmSiege1_Briefing,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_KalmSiege1_Briefing,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_KalmSiege1_Briefing,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_KalmSiege1_Briefing,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_KalmSiege1_Briefing,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_KalmSiege1_Briefing,Player(7),true)
    call TriggerAddCondition(gg_trg_KalmSiege1_Briefing,Condition(function Trig_KalmSiege1_Briefing_Conditions))
    call TriggerAddAction(gg_trg_KalmSiege1_Briefing,function Trig_KalmSiege1_Briefing_Actions)
endfunction

function Register_KalmSiege1_Begin takes nothing returns nothing
    set gg_trg_KalmSiege1_Begin=CreateTrigger()
    call DisableTrigger(gg_trg_KalmSiege1_Begin)
    call TriggerRegisterTimerExpireEventBJ(gg_trg_KalmSiege1_Begin,udg_SiegeTimer)
    call TriggerAddAction(gg_trg_KalmSiege1_Begin,function Trig_KalmSiege1_Begin_Actions)
endfunction

function Register_KalmSiege1_Defeat takes nothing returns nothing
    set gg_trg_KalmSiege1_Defeat=CreateTrigger()
    call DisableTrigger(gg_trg_KalmSiege1_Defeat)
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_KalmSiege1_Defeat,Player(9),EVENT_PLAYER_UNIT_DEATH)
    call TriggerAddCondition(gg_trg_KalmSiege1_Defeat,Condition(function Trig_KalmSiege1_Defeat_Conditions))
    call TriggerAddAction(gg_trg_KalmSiege1_Defeat,function Trig_KalmSiege1_Defeat_Actions)
endfunction

function Register_KalmSiege1_TrackDeaths takes nothing returns nothing
    set gg_trg_KalmSiege1_TrackDeaths=CreateTrigger()
    call DisableTrigger(gg_trg_KalmSiege1_TrackDeaths)
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_KalmSiege1_TrackDeaths,Player($B),EVENT_PLAYER_UNIT_DEATH) // $B = 11
    call TriggerRegisterAnyUnitEventBJ(gg_trg_KalmSiege1_TrackDeaths,EVENT_PLAYER_UNIT_CHANGE_OWNER)
    call TriggerAddCondition(gg_trg_KalmSiege1_TrackDeaths,Condition(function Trig_KalmSiege1_TrackDeaths_Conditions))
    call TriggerAddAction(gg_trg_KalmSiege1_TrackDeaths,function Trig_KalmSiege1_TrackDeaths_Actions)
endfunction

function Register_KalmSiege1_Complete takes nothing returns nothing
    set gg_trg_KalmSiege1_Complete=CreateTrigger()
    call DisableTrigger(gg_trg_KalmSiege1_Complete)
    call TriggerRegisterTimerExpireEventBJ(gg_trg_KalmSiege1_Complete,udg_SiegeTimer)
    call TriggerAddAction(gg_trg_KalmSiege1_Complete,function Trig_KalmSiege1_Complete_Actions)
endfunction

function Register_KalmSiege1_Fail takes nothing returns nothing
    set gg_trg_KalmSiege1_Fail=CreateTrigger()
    call DisableTrigger(gg_trg_KalmSiege1_Fail)
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_KalmSiege1_Fail,Player(9),EVENT_PLAYER_UNIT_DEATH)
    call TriggerAddCondition(gg_trg_KalmSiege1_Fail,Condition(function Trig_KalmSiege1_Fail_Conditions))
    call TriggerAddAction(gg_trg_KalmSiege1_Fail,function Trig_KalmSiege1_Fail_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_KalmSiege1 takes nothing returns nothing
    call Register_KalmSiege1_Start() // starts off; enabled by Boss_Zalera
    call Register_KalmSiege1_Briefing() // starts off; enabled by KalmSiege1; destroyed by KalmSiege1
    call Register_KalmSiege1_Begin() // starts off; enabled by KalmSiege1; destroyed by KalmSiege1
    call Register_KalmSiege1_Defeat() // starts off; enabled by KalmSiege1; disabled by KalmSiege1; destroyed by KalmSiege1
    call Register_KalmSiege1_TrackDeaths() // starts off; enabled by KalmSiege1; disabled by KalmSiege1
    call Register_KalmSiege1_Complete() // starts off; enabled by KalmSiege1
    call Register_KalmSiege1_Fail() // starts off; enabled by KalmSiege1; disabled by KalmSiege1; destroyed by KalmSiege1
endfunction

endlibrary
