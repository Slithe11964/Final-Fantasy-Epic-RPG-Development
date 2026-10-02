library TKalmSiege1 requires TCam, TCine, TGroup, TLoc, TMusic, TPlayerPart01, TReward, TText, TUnit, TWait
function Trig_KalmSiege1_Start_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_Hpb1_0013,true,true,true))
endfunction

function Trig_KalmSiege1_Start_ApplyCamera takes nothing returns nothing
    call CameraSetupApplyForPlayer(true,gg_cam_001,GetEnumPlayer(),0)
endfunction

function Trig_KalmSiege1_Start_CinematicsOn takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_KalmSiege1_Start_Actions takes nothing returns nothing
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
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_DISCOVERED,"New Quest Received: |cffffcc00Kalm Siege|r")
    set udg_MainQuest[9]=CreateQuestBJ(bj_QUESTTYPE_REQ_DISCOVERED,(udg_QuestNamePrefix+"Kalm Siege"),"Kalm is under attack! Cid asked you to speak to Meliadoul to help with the defenses.","ReplaceableTextures\\CommandButtons\\BTNSylvanusWindrunner.blp")
    set udg_StoryProgress=(udg_StoryProgress+1)
    call ConditionalTriggerExecute(gg_trg_QuestCount_Milestones)
    call GroupAddUnitSimple(gg_unit_Hvwd_0098,udg_QuestUnits)
    set udg_TempPoint=GetRectCenter(gg_rct_585)
    call SetUnitPositionLocFacingBJ(gg_unit_Hvwd_0098,udg_TempPoint,315.)
    call RemoveLocation(udg_TempPoint)
    call IssueImmediateOrderBJ(gg_unit_Hvwd_0098,"holdposition")
    set udg_SpecialEffect[30]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_Hvwd_0098,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call EnableTrigger(gg_trg_KalmSiege1_Briefing)
    set udg_ShadowForcedSpawn=1
    set udg_SpecialEffect[89]=AddSpecialEffectTargetUnitBJ("overhead",udg_Mid,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call EnableTrigger(gg_trg_Mid_Letter_Give)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_KalmSiege1_Briefing_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_Hvwd_0098,true,true,true))
endfunction

function Trig_KalmSiege1_Briefing_CinematicsOn takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

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
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_UPDATED,"Defend Kalm from the siege starting in 30 seconds!\r\n- Meliadoul must survive!")
    call QuestSetDescriptionBJ(udg_MainQuest[9],"Defend Kalm from the siege starting in 30 seconds!\r\n\r\nMeliadoul must survive!")
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
    set udg_TempPoint=GetUnitLoc(GetEnumUnit())
    set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,1024.,GetUnitFacing(GetEnumUnit()))
    call RemoveLocation(udg_TempPoint)
    call IssuePointOrderLocBJ(GetEnumUnit(),"patrol",udg_TempPoint2)
    call RemoveLocation(udg_TempPoint2)
    call PauseUnitBJ(false,GetEnumUnit())
endfunction

function Trig_KalmSiege1_Begin_SendGuardForward takes nothing returns nothing
    set udg_TempPoint=GetUnitLoc(GetEnumUnit())
    set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,384.,GetUnitFacing(GetEnumUnit()))
    call RemoveLocation(udg_TempPoint)
    call IssuePointOrderLocBJ(GetEnumUnit(),"move",udg_TempPoint2)
    call RemoveLocation(udg_TempPoint2)
    call PauseUnitBJ(false,GetEnumUnit())
endfunction

function Trig_KalmSiege1_Begin_Actions takes nothing returns nothing
    if(Trig_KalmSiege1_Begin_CinematicBusy())then
        call StartTimerBJ(udg_SiegeTimer,false,.49)
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
    set udg_TempPoint2=GetRectCenter(gg_rct_584)
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=LoadIntegerBJ(4,2,udg_SpawnDataHashRef)
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        set udg_TempPoint=GetRectCenter(LoadRectHandleBJ(GetForLoopIndexA(),4,udg_SpawnRectHashRef))
        // The remainder after dividing (loop counter A) by (10).
        call CreateNUnitsAtLocFacingLocBJ(1,udg_SiegeNorthUnitType[ModuloInteger(GetForLoopIndexA(),$A)],Player($B),udg_TempPoint,udg_TempPoint2) // $A = 10; $B = 11
        call RemoveLocation(udg_TempPoint)
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_SpecialUnits)
        if(Trig_KalmSiege1_Begin_ScalingOff())then
            // Calculation 1:
            // (BlzGetUnitBaseDamage(GetLastCreatedUnit(), 0)) times (4).
            // Calculation 2:
            // (1) minus (1).
            call BlzSetUnitBaseDamage(GetLastCreatedUnit(),(BlzGetUnitBaseDamage(GetLastCreatedUnit(),0)*4),(1-1))
            // (BlzGetUnitBaseDamage(GetLastCreatedUnit(), 1)) times (4).
            call BlzSetUnitBaseDamage(GetLastCreatedUnit(),(BlzGetUnitBaseDamage(GetLastCreatedUnit(),1)*4),1)
            // (maximum health of GetLastCreatedUnit()) times (4).
            call BlzSetUnitMaxHP(GetLastCreatedUnit(),(BlzGetUnitMaxHP(GetLastCreatedUnit())*4))
            call SetUnitLifePercentBJ(GetLastCreatedUnit(),'d')
        else
            call Unit_ScaleToLevel60(bj_lastCreatedUnit)
        endif
        call SetUnitAcquireRangeBJ(GetLastCreatedUnit(),600.)
        call IssuePointOrderLocBJ(GetLastCreatedUnit(),"attack",udg_TempPoint2)
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
    call RemoveLocation(udg_TempPoint2)
    call Wait_Polled(.2)
    call ForGroupBJ(udg_AllyBrothersGroup,function Trig_KalmSiege1_Begin_SendGuardPatrol)
    call Wait_Polled(.2)
    call ForGroupBJ(udg_AllyRangerGroup,function Trig_KalmSiege1_Begin_SendGuardForward)
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
    call QuestSetDescriptionBJ(udg_MainQuest[9],"Speak to Meliadoul to retry the Siege.")
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
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_COMPLETED,"Quest Completed: |cffffcc00Kalm Siege|r")
    call QuestSetCompletedBJ(udg_MainQuest[9],true)
    set udg_QuestsCompleted=(udg_QuestsCompleted+1)
    set udg_StoryProgress=(udg_StoryProgress+1)
    call ConditionalTriggerExecute(gg_trg_QuestCount_Milestones)
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
    call DisableTrigger(GetTriggeringTrigger())
    call Music_ClearTrack(39)
    call Music_SetZoneTrack(9)
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_FAILED,"Quest Failed: |cffffcc00Kalm Siege|r")
    call QuestSetFailedBJ(udg_MainQuest[9],true)
    call DestroyGroup(udg_TownTargetGroup)
    set udg_TempPoint=GetUnitLoc(gg_unit_Hpb1_0013)
    set udg_TownTargetGroup=Group_UnitsInRangeOfLoc(8192.,udg_TempPoint,Condition(function Trig_KalmSiege1_Fail_IsTownUnit))
    call RemoveLocation(udg_TempPoint)
    call ForGroupBJ(udg_TownTargetGroup,function Trig_KalmSiege1_Fail_MakeVulnerable)
    call EnableTrigger(gg_trg_KalmSiege_FailRespawn)
    call EnableTrigger(gg_trg_KalmSiege_DemonRecover)
    call ForGroupBJ(udg_RecruitedAllies,function Trig_KalmSiege1_Fail_PurgeOrShow)
    set udg_TempPoint=GetRectCenter(gg_rct_298)
    call SetUnitPositionLoc(gg_unit_U00E_0222,udg_TempPoint)
    call RemoveLocation(udg_TempPoint)
    set udg_TempPoint=GetRectCenter(gg_rct_413)
    call IssuePointOrderLocBJ(gg_unit_U00E_0222,"attack",udg_TempPoint)
    call RemoveLocation(udg_TempPoint)
    call ShowUnitShow(gg_unit_U00E_0222)
    call PauseUnitBJ(false,gg_unit_U00E_0222)
    call SetUnitInvulnerable(gg_unit_U00E_0222,false)
    call UnitAddAbilityBJ('A0ZR',gg_unit_U00E_0222) // 'A0ZR': ability "Immortal"
    call UnitAddAbilityBJ('A15D',gg_unit_U00E_0222) // 'A15D': ability "Thunder Boost"
    call UnitAddAbilityBJ('A0M9',gg_unit_U00E_0222) // 'A0M9': ability "Thunder Orb Amplification"
    call UnitAddAbilityBJ('A0LL',gg_unit_U00E_0222) // 'A0LL': ability "Thunder Spell Amplification"
    call SetUnitMoveSpeed(gg_unit_U00E_0222,500.)
    set udg_RaidPowerLevel=30
    set udg_TempPoint2=GetRectCenter(gg_rct_588)
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=LoadIntegerBJ(4,2,udg_SpawnDataHashRef)
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        if(Trig_KalmSiege1_Fail_IsThirdSlot())then
            set udg_TempPoint=GetRectCenter(LoadRectHandleBJ(GetForLoopIndexA(),4,udg_SpawnRectHashRef))
            // The remainder after dividing (loop counter A) by (10).
            call CreateNUnitsAtLocFacingLocBJ(1,udg_SiegeNorthUnitType[ModuloInteger(GetForLoopIndexA(),$A)],Player($B),udg_TempPoint,udg_TempPoint2) // $A = 10; $B = 11
            call RemoveLocation(udg_TempPoint)
            call GroupAddUnitSimple(GetLastCreatedUnit(),udg_EscortUnits)
            // Calculation 1:
            // ((BlzGetUnitBaseDamage(GetLastCreatedUnit(), 0)) times (udg_RaidPowerLevel)) divided by (4).
            // Calculation 2:
            // (1) minus (1).
            call BlzSetUnitBaseDamage(GetLastCreatedUnit(),((BlzGetUnitBaseDamage(GetLastCreatedUnit(),0)*udg_RaidPowerLevel)/ 4),(1-1))
            // ((BlzGetUnitBaseDamage(GetLastCreatedUnit(), 1)) times (udg_RaidPowerLevel)) divided by (4).
            call BlzSetUnitBaseDamage(GetLastCreatedUnit(),((BlzGetUnitBaseDamage(GetLastCreatedUnit(),1)*udg_RaidPowerLevel)/ 4),1)
            // ((maximum health of GetLastCreatedUnit()) times (udg_RaidPowerLevel)) divided by (4).
            call BlzSetUnitMaxHP(GetLastCreatedUnit(),((BlzGetUnitMaxHP(GetLastCreatedUnit())*udg_RaidPowerLevel)/ 4))
            call SetUnitLifePercentBJ(GetLastCreatedUnit(),'d')
            call SetUnitAcquireRangeBJ(GetLastCreatedUnit(),800.)
            call IssuePointOrderLocBJ(GetLastCreatedUnit(),"attack",udg_TempPoint2)
        endif
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    call RemoveLocation(udg_TempPoint2)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_KalmSiege1 takes nothing returns nothing
endfunction

function RegisterR11_KalmSiege1_Start takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

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




function RegisterR11_KalmSiege1_Briefing takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

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




function RegisterR11_KalmSiege1_Begin takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_KalmSiege1_Begin=CreateTrigger()

call DisableTrigger(gg_trg_KalmSiege1_Begin)

call TriggerRegisterTimerExpireEventBJ(gg_trg_KalmSiege1_Begin,udg_SiegeTimer)

call TriggerAddAction(gg_trg_KalmSiege1_Begin,function Trig_KalmSiege1_Begin_Actions)

endfunction




function RegisterR11_KalmSiege1_Defeat takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_KalmSiege1_Defeat=CreateTrigger()

call DisableTrigger(gg_trg_KalmSiege1_Defeat)

call TriggerRegisterPlayerUnitEventSimple(gg_trg_KalmSiege1_Defeat,Player(9),EVENT_PLAYER_UNIT_DEATH)

call TriggerAddCondition(gg_trg_KalmSiege1_Defeat,Condition(function Trig_KalmSiege1_Defeat_Conditions))

call TriggerAddAction(gg_trg_KalmSiege1_Defeat,function Trig_KalmSiege1_Defeat_Actions)

endfunction




function RegisterR11_KalmSiege1_TrackDeaths takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_KalmSiege1_TrackDeaths=CreateTrigger()

call DisableTrigger(gg_trg_KalmSiege1_TrackDeaths)

call TriggerRegisterPlayerUnitEventSimple(gg_trg_KalmSiege1_TrackDeaths,Player($B),EVENT_PLAYER_UNIT_DEATH) // $B = 11

call TriggerRegisterAnyUnitEventBJ(gg_trg_KalmSiege1_TrackDeaths,EVENT_PLAYER_UNIT_CHANGE_OWNER)

call TriggerAddCondition(gg_trg_KalmSiege1_TrackDeaths,Condition(function Trig_KalmSiege1_TrackDeaths_Conditions))

call TriggerAddAction(gg_trg_KalmSiege1_TrackDeaths,function Trig_KalmSiege1_TrackDeaths_Actions)

endfunction




function RegisterR11_KalmSiege1_Complete takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_KalmSiege1_Complete=CreateTrigger()

call DisableTrigger(gg_trg_KalmSiege1_Complete)

call TriggerRegisterTimerExpireEventBJ(gg_trg_KalmSiege1_Complete,udg_SiegeTimer)

call TriggerAddAction(gg_trg_KalmSiege1_Complete,function Trig_KalmSiege1_Complete_Actions)

endfunction




function RegisterR11_KalmSiege1_Fail takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_KalmSiege1_Fail=CreateTrigger()

call DisableTrigger(gg_trg_KalmSiege1_Fail)

call TriggerRegisterPlayerUnitEventSimple(gg_trg_KalmSiege1_Fail,Player(9),EVENT_PLAYER_UNIT_DEATH)

call TriggerAddCondition(gg_trg_KalmSiege1_Fail,Condition(function Trig_KalmSiege1_Fail_Conditions))

call TriggerAddAction(gg_trg_KalmSiege1_Fail,function Trig_KalmSiege1_Fail_Actions)

endfunction




endlibrary
