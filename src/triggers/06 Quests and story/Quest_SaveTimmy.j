library TQuestSaveTimmy requires TCam, TCine, TGroup, TPlayerPart01, TReward, TText, TUnit
globals
    // Variables only this module uses (MapBootstrap sets some starting values).
    boolean udg_FarmGateOpen=false
    boolean udg_GateGuardTalked=false
    sound gg_snd_H01VillagerF42=null
endglobals

function Trig_Quest_SaveTimmy_Init_Enum_SetWorkAnim takes nothing returns nothing
    call SetUnitAnimation(GetEnumUnit(),"stand work")
    call SetUnitTimeScalePercent(GetEnumUnit(),50.)
endfunction

function Trig_Quest_SaveTimmy_Init_Enum_HideUnit takes nothing returns nothing
    call ShowUnitHide(GetEnumUnit())
endfunction

function Trig_Quest_SaveTimmy_Init_Cond_OwnedByCreeps takes nothing returns boolean
    return(GetOwningPlayer(GetFilterUnit())==Player($B)) // $B = 11
endfunction

function Trig_Quest_SaveTimmy_Init_Cond_NoUserData takes nothing returns boolean
    return(GetUnitUserData(GetFilterUnit())==0)
endfunction

function Trig_Quest_SaveTimmy_Init_Cond_IsCampMonster takes nothing returns boolean
    return GetBooleanAnd(Trig_Quest_SaveTimmy_Init_Cond_OwnedByCreeps(),Trig_Quest_SaveTimmy_Init_Cond_NoUserData())
endfunction

function Trig_Quest_SaveTimmy_Init_Enum_BuffCampUnit takes nothing returns nothing
    // (maximum health of the unit being visited) times (3).
    call BlzSetUnitMaxHP(GetEnumUnit(),(BlzGetUnitMaxHP(GetEnumUnit())*3))
    call SetUnitLifePercentBJ(GetEnumUnit(),'d')
    // Calculation 1:
    // (BlzGetUnitBaseDamage(the unit being visited, 0)) times (3).
    // Calculation 2:
    // (1) minus (1).
    call BlzSetUnitBaseDamage(GetEnumUnit(),(BlzGetUnitBaseDamage(GetEnumUnit(),0)*3),(1-1))
    // (BlzGetUnitBaseDamage(the unit being visited, 1)) times (3).
    call BlzSetUnitBaseDamage(GetEnumUnit(),(BlzGetUnitBaseDamage(GetEnumUnit(),1)*3),1)
endfunction

function Trig_Quest_SaveTimmy_Init_Actions takes nothing returns nothing
    set udg_FarmWorkingVillagers=Group_UnitsInRectOfPlayer(gg_rct_412,Player(9))
    set udg_FarmGatheredVillagers=Group_UnitsInRectOfPlayer(gg_rct_577,Player(9))
    call ForGroupBJ(udg_FarmWorkingVillagers,function Trig_Quest_SaveTimmy_Init_Enum_SetWorkAnim)
    call ForGroupBJ(udg_FarmGatheredVillagers,function Trig_Quest_SaveTimmy_Init_Enum_HideUnit)
    set udg_VillagerEffectActive=false
    set udg_SpecialEffect[27]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_n00I_0011,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    set udg_SpecialEffect[67]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_hcth_0231,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call SetDestructableInvulnerableBJ(gg_dest_LOcg_0024,true)
    set udg_GnollCampUnits=Group_UnitsInRect(gg_rct_488,Condition(function Trig_Quest_SaveTimmy_Init_Cond_IsCampMonster))
    call ForGroupBJ(udg_GnollCampUnits,function Trig_Quest_SaveTimmy_Init_Enum_BuffCampUnit)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Quest_SaveTimmy_Start_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_n00I_0011,true,true,true))
endfunction

function Trig_Quest_SaveTimmy_Start_Cond_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_SaveTimmy_Start_Cond_GuardNotTalked takes nothing returns boolean
    return(udg_GateGuardTalked==false)
endfunction

function Trig_Quest_SaveTimmy_Start_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[27])
    call EnableTrigger(gg_trg_Quest_SaveTimmy_TimmyReturns)
    call DisableTrigger(gg_trg_Quest_SaveTimmy_RescueFirst)
    call DestroyTrigger(gg_trg_Quest_SaveTimmy_RescueFirst)
    if(Trig_Quest_SaveTimmy_Start_Cond_CinematicsEnabled())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(gg_unit_n00I_0011,"Please, I need your help.",false)
        call Text_Say(gg_unit_n00I_0011,"A couple days ago, we found the dead bodies of a number of men from our community... including that of my husband.",false)
        call Text_Say(gg_unit_n00I_0011,"But I can't mourn him yet, my son Timmy was also with them but he was never found! The others are telling me it's hopeless, but I don't believe it. Please, find the heinous gnolls that attacked our people and save my son from them! You are my only hope!",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"You can count on me.",false)
        call Cine_ExitAction()
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_DISCOVERED,"New Quest Received: |cffffcc00Save Timmy|r")
    set udg_SideQuest[9]=CreateQuestBJ(bj_QUESTTYPE_REQ_DISCOVERED,"|cff00ffffSave Timmy","Katya, from the Farm, asked you to save her son Timmy who was apparently taken by vicious gnolls.","ReplaceableTextures\\CommandButtons\\BTNVillagerKid.blp")
    set udg_SpecialEffect[27]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_n00I_0011,"Objects\\RandomObject\\RandomObject.mdl")
    call EnableTrigger(gg_trg_Quest_SaveTimmy_Ping)
    call EnableTrigger(gg_trg_Quest_SaveTimmy_GateAsk)
    call DestroyTrigger(gg_trg_Quest_SaveTimmy_CompleteAlt)
    if(Trig_Quest_SaveTimmy_Start_Cond_GuardNotTalked())then
        call DisableTrigger(gg_trg_Quest_SaveTimmy_GateRefused)
        call DestroyTrigger(gg_trg_Quest_SaveTimmy_GateRefused)
    else
        set udg_SpecialEffect[67]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_hcth_0231,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    endif
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Quest_SaveTimmy_Ping_Actions takes nothing returns nothing
    set udg_TempPoint=GetDestructableLoc(gg_dest_LOcg_0024)
    call PingMinimapLocForForce(GetPlayersAll(),udg_TempPoint,2.)
    call RemoveLocation(udg_TempPoint)
endfunction

function Trig_Quest_SaveTimmy_GateRefused_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_hcth_0231,true,true,true))
endfunction

function Trig_Quest_SaveTimmy_GateRefused_Cond_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_SaveTimmy_GateRefused_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[67])
    set udg_GateGuardTalked=true
    if(Trig_Quest_SaveTimmy_GateRefused_Cond_CinematicsEnabled())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(gg_unit_hcth_0231,"This gate is closed off. Passage is forbidden.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Why is it closed off?",false)
        call Text_Say(gg_unit_hcth_0231,"We've recently lost many men on an expedition. The people are frightened. We don't want any monsters overwhelming us.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Can you let us through at least?",false)
        call Text_Say(gg_unit_hcth_0231,"No exceptions I'm afraid, unless you have a very good reason.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"I see. Goodbye then.",false)
        call Cine_ExitAction()
    endif
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Quest_SaveTimmy_GateAsk_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_hcth_0231,true,true,true))
endfunction

function Trig_Quest_SaveTimmy_GateAsk_Cond_GuardTalked takes nothing returns boolean
    return(udg_GateGuardTalked)
endfunction

function Trig_Quest_SaveTimmy_GateAsk_Cond_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_SaveTimmy_GateAsk_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[67])
    if(Trig_Quest_SaveTimmy_GateAsk_Cond_CinematicsEnabled())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        if(Trig_Quest_SaveTimmy_GateAsk_Cond_GuardTalked())then
            call Text_Say(gg_unit_hcth_0231,"You again?",false)
        else
            call Text_Say(gg_unit_hcth_0231,"This gate is closed off. Passage is forbidden.",false)
        endif
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"We are here on urgent business. Katya has requested of us to find her son Timmy. Let us pass.",false)
        call Text_Say(gg_unit_hcth_0231,"Save Timmy? We would be incredibly grateful if you did that.",false)
        call Text_Say(gg_unit_hcth_0231,"Open the gates!",false)
        call Cine_ExitAction()
    endif
    call ConditionalTriggerExecute(gg_trg_Quest_SaveTimmy_GateOpen)
endfunction

function Trig_Quest_SaveTimmy_GateOpen_Actions takes nothing returns nothing
    set udg_FarmGateOpen=true
    call ModifyGateBJ(bj_GATEOPERATION_OPEN,gg_dest_DTg6_0052)
    set udg_TempPoint=GetRectCenter(gg_rct_573)
    call SetUnitPositionLoc(gg_unit_hcth_0231,udg_TempPoint)
    call RemoveLocation(udg_TempPoint)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Quest_SaveTimmy_CampFlank_Conditions takes nothing returns boolean
    return((IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(GetUnitTypeId(GetTriggerUnit())!='H01D'))!=null // 'H01D': unit "Spirit of Gaya"
endfunction

function Trig_Quest_SaveTimmy_CampFlank_Enum_AddFlanked takes nothing returns nothing
    call UnitAddAbilityBJ('A0GI',GetEnumUnit()) // 'A0GI': ability "Flanked"
endfunction

function Trig_Quest_SaveTimmy_CampFlank_Cond_FlankApproach takes nothing returns boolean
    return(GetUnitFacing(GetTriggerUnit())<=180.)
endfunction

function Trig_Quest_SaveTimmy_CampFlank_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    if(Trig_Quest_SaveTimmy_CampFlank_Cond_FlankApproach())then
        call UnitRemoveAbilityBJ('A0WA',gg_unit_n00H_0005) // 'A0WA': ability "Gnoll Aura"
        call ForGroupBJ(udg_GnollCampUnits,function Trig_Quest_SaveTimmy_CampFlank_Enum_AddFlanked)
    endif
endfunction

function Trig_Quest_SaveTimmy_CampAlerted_Cond_CampUnitInvolved takes nothing returns boolean
    return(IsUnitInGroup(GetTriggerUnit(),udg_GnollCampUnits))or(IsUnitInGroup(GetAttacker(),udg_GnollCampUnits))
endfunction

function Trig_Quest_SaveTimmy_CampAlerted_Conditions takes nothing returns boolean
    return(Trig_Quest_SaveTimmy_CampAlerted_Cond_CampUnitInvolved())
endfunction

function Trig_Quest_SaveTimmy_CampAlerted_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DisableTrigger(gg_trg_Quest_SaveTimmy_CampFlank)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Quest_SaveTimmy_CampCleared_Conditions takes nothing returns boolean
    return(IsUnitInGroup(GetTriggerUnit(),udg_GnollCampUnits))
endfunction

function Trig_Quest_SaveTimmy_CampCleared_Cond_CampEmpty takes nothing returns boolean
    return(IsUnitGroupEmptyBJ(udg_GnollCampUnits))
endfunction

function Trig_Quest_SaveTimmy_CampCleared_Actions takes nothing returns nothing
    call DisableTrigger(gg_trg_Quest_SaveTimmy_CampFlank)
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_GnollCampUnits)
    if(Trig_Quest_SaveTimmy_CampCleared_Cond_CampEmpty())then
        call DisableTrigger(GetTriggeringTrigger())
        call SetDestructableInvulnerableBJ(gg_dest_LOcg_0024,false)
        call DestroyTrigger(GetTriggeringTrigger())
    endif
endfunction

function Trig_Quest_SaveTimmy_Freed_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call CreateNUnitsAtLoc(1,'n00J',Player(9),GetDestructableLoc(GetDyingDestructable()),bj_UNIT_FACING) // 'n00J': unit "Timmy"
    set udg_TimmyUnit=GetLastCreatedUnit()
    call StartTimerBJ(udg_TimmyQuestTimer,false,.01)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Quest_SaveTimmy_TimmyReturns_Cond_CinematicRunning takes nothing returns boolean
    return(udg_InCinematicMode)
endfunction

function Trig_Quest_SaveTimmy_TimmyReturns_Cond_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_SaveTimmy_TimmyReturns_Enum_HideUnit takes nothing returns nothing
    call ShowUnitHide(GetEnumUnit())
endfunction

function Trig_Quest_SaveTimmy_TimmyReturns_Enum_ShowUnit takes nothing returns nothing
    call ShowUnitShow(GetEnumUnit())
endfunction

function Trig_Quest_SaveTimmy_TimmyReturns_Cond_GateStillClosed takes nothing returns boolean
    return(udg_FarmGateOpen==false)
endfunction

function Trig_Quest_SaveTimmy_TimmyReturns_Actions takes nothing returns nothing
    if(Trig_Quest_SaveTimmy_TimmyReturns_Cond_CinematicRunning())then
        call StartTimerBJ(udg_TimmyQuestTimer,false,1.)
        return
    endif
    call DisableTrigger(GetTriggeringTrigger())
    call DisableTrigger(gg_trg_Quest_SaveTimmy_Ping)
    call DestroyTrigger(gg_trg_Quest_SaveTimmy_Ping)
    if(Trig_Quest_SaveTimmy_TimmyReturns_Cond_CinematicsEnabled())then
        call Cine_Enter()
        call Cam_PanToUnit(udg_TimmyUnit,0)
        call Text_Say(udg_TimmyUnit,"Thank you so much for saving me! I'll rush home right away.",false)
        call Cine_ExitAction()
    endif
    set udg_TempPoint=GetUnitLoc(udg_TimmyUnit)
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(udg_TempPoint)
    set udg_TempPoint=GetUnitLoc(gg_unit_n00I_0011)
    call SetUnitPositionLocFacingLocBJ(udg_TimmyUnit,udg_TempPoint,udg_TempPoint)
    call RemoveLocation(udg_TempPoint)
    call DisableTrigger(gg_trg_Npc_Talk_Peasant)
    call DestroyTrigger(gg_trg_Npc_Talk_Peasant)
    call ForGroupBJ(udg_FarmWorkingVillagers,function Trig_Quest_SaveTimmy_TimmyReturns_Enum_HideUnit)
    call ForGroupBJ(udg_FarmGatheredVillagers,function Trig_Quest_SaveTimmy_TimmyReturns_Enum_ShowUnit)
    call QuestMessageBJ(udg_PlayingPlayers,bj_QUESTMESSAGE_UPDATED,"Return to Katya.")
    call QuestSetDescriptionBJ(udg_SideQuest[9],"Return to Katya.")
    call GroupAddUnitSimple(gg_unit_n00I_0011,udg_BossUnits)
    call EnableTrigger(gg_trg_Quest_SaveTimmy_Complete)
    if(Trig_Quest_SaveTimmy_TimmyReturns_Cond_GateStillClosed())then
        call DisableTrigger(gg_trg_Quest_SaveTimmy_GateAsk)
        call DestroyTrigger(gg_trg_Quest_SaveTimmy_GateAsk)
        call DestroyEffectBJ(udg_SpecialEffect[67])
        call ConditionalTriggerExecute(gg_trg_Quest_SaveTimmy_GateOpen)
    endif
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Quest_SaveTimmy_RescueFirst_Cond_CinematicRunning takes nothing returns boolean
    return(udg_InCinematicMode)
endfunction

function Trig_Quest_SaveTimmy_RescueFirst_Cond_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_SaveTimmy_RescueFirst_Enum_HideUnit takes nothing returns nothing
    call ShowUnitHide(GetEnumUnit())
endfunction

function Trig_Quest_SaveTimmy_RescueFirst_Enum_ShowUnit takes nothing returns nothing
    call ShowUnitShow(GetEnumUnit())
endfunction

function Trig_Quest_SaveTimmy_RescueFirst_Actions takes nothing returns nothing
    if(Trig_Quest_SaveTimmy_RescueFirst_Cond_CinematicRunning())then
        call StartTimerBJ(udg_TimmyQuestTimer,false,1.)
        return
    endif
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[27])
    call DisableTrigger(gg_trg_Quest_SaveTimmy_Start)
    call DestroyTrigger(gg_trg_Quest_SaveTimmy_Start)
    call DestroyTrigger(gg_trg_Quest_SaveTimmy_Ping)
    if(Trig_Quest_SaveTimmy_RescueFirst_Cond_CinematicsEnabled())then
        call Cine_Enter()
        call Cam_PanToUnit(udg_TimmyUnit,0)
        call Text_Say(udg_TimmyUnit,"Thank you so much for saving me! I'll rush home right away.",false)
        call Cine_ExitAction()
    endif
    set udg_TempPoint=GetUnitLoc(udg_TimmyUnit)
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(udg_TempPoint)
    set udg_TempPoint=GetUnitLoc(gg_unit_n00I_0011)
    call SetUnitPositionLocFacingLocBJ(udg_TimmyUnit,udg_TempPoint,udg_TempPoint)
    call RemoveLocation(udg_TempPoint)
    call DisableTrigger(gg_trg_Npc_Talk_Peasant)
    call DestroyTrigger(gg_trg_Npc_Talk_Peasant)
    call ForGroupBJ(udg_FarmWorkingVillagers,function Trig_Quest_SaveTimmy_RescueFirst_Enum_HideUnit)
    call ForGroupBJ(udg_FarmGatheredVillagers,function Trig_Quest_SaveTimmy_RescueFirst_Enum_ShowUnit)
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_DISCOVERED,"New Quest Received: |cffffcc00Save Timmy|r")
    set udg_SideQuest[9]=CreateQuestBJ(bj_QUESTTYPE_REQ_DISCOVERED,"|cff00ffffSave Timmy","It seems you saved a child from the Farm. Talk to his mother at the Farm for a potential reward.","ReplaceableTextures\\CommandButtons\\BTNVillagerKid.blp")
    set udg_SpecialEffect[27]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_n00I_0011,"Objects\\RandomObject\\RandomObject.mdl")
    call GroupAddUnitSimple(gg_unit_n00I_0011,udg_BossUnits)
    call EnableTrigger(gg_trg_Quest_SaveTimmy_CompleteAlt)
    call DisableTrigger(gg_trg_Quest_SaveTimmy_GateRefused)
    call DestroyTrigger(gg_trg_Quest_SaveTimmy_GateRefused)
    call DestroyTrigger(gg_trg_Quest_SaveTimmy_GateAsk)
    call DestroyTrigger(gg_trg_Quest_SaveTimmy_TimmyReturns)
    call DestroyTrigger(gg_trg_Quest_SaveTimmy_Complete)
    call DestroyEffectBJ(udg_SpecialEffect[67])
    call ConditionalTriggerExecute(gg_trg_Quest_SaveTimmy_GateOpen)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Quest_SaveTimmy_Complete_Conditions takes nothing returns boolean
    return((IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(GetUnitTypeId(GetTriggerUnit())!='H01D')and(udg_InCinematicMode==false))!=null // 'H01D': unit "Spirit of Gaya"
endfunction

function Trig_Quest_SaveTimmy_Complete_Cond_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_SaveTimmy_Complete_Enum_ShowCelebrate takes nothing returns nothing
    call ShowUnitShow(GetEnumUnit())
    call SetUnitTimeScalePercent(GetEnumUnit(),150.)
endfunction

function Trig_Quest_SaveTimmy_Complete_Enum_RemoveUnit takes nothing returns nothing
    call KillUnit(GetEnumUnit())
    call RemoveUnit(GetEnumUnit())
endfunction

function Trig_Quest_SaveTimmy_Complete_Cond_VillagerEffectActive takes nothing returns boolean
    return(udg_VillagerEffectActive)
endfunction

function Trig_Quest_SaveTimmy_Complete_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[27])
    call GroupRemoveUnitSimple(gg_unit_n00I_0011,udg_BossUnits)
    call SetUnitFacingTimed(udg_TimmyUnit,bj_UNIT_FACING,0)
    if(Trig_Quest_SaveTimmy_Complete_Cond_CinematicsEnabled())then
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_n00I_0011,0)
        call Text_Transmission(gg_unit_n00I_0011,"Katya","Oh, thank you so so much ! I have a reward for you.","(null)",gg_snd_H01VillagerF42,0,false)
        call Reward_Give($7D0,$3E8,gg_unit_n00I_0011) // $7D0 = 2000; $3E8 = 1000
        call Cine_ExitAction()
    else
        call Reward_Give($7D0,$3E8,gg_unit_n00I_0011) // $7D0 = 2000; $3E8 = 1000
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_COMPLETED,"Quest Completed: |cffffcc00Save Timmy|r")
    call QuestSetCompletedBJ(udg_SideQuest[9],true)
    set udg_QuestsCompleted=(udg_QuestsCompleted+1)
    call ForGroupBJ(udg_FarmWorkingVillagers,function Trig_Quest_SaveTimmy_Complete_Enum_ShowCelebrate)
    call ForGroupBJ(udg_FarmGatheredVillagers,function Trig_Quest_SaveTimmy_Complete_Enum_RemoveUnit)
    call EnableTrigger(gg_trg_Npc_Talk_PeasantHarvest)
    if(Trig_Quest_SaveTimmy_Complete_Cond_VillagerEffectActive())then
        set udg_QuestMarkerEffect[$F]=AddSpecialEffectTargetUnitBJ("head",gg_unit_nvil_0003,"Abilities\\Spells\\Other\\Silence\\SilenceTarget.mdl") // $F = 15
    else
        set udg_QuestMarkerEffect[$F]=udg_QuestMarkerEffect[$E] // $F = 15; $E = 14
    endif
    call ConditionalTriggerExecute(gg_trg_Quest_Caravan_Enable)
    call ConditionalTriggerExecute(gg_trg_Kiros_ShowTalkIcon)
    call EnableTrigger(gg_trg_NameDiary_Prepare)
    call StartTimerBJ(udg_TimmyQuestTimer,false,300.)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Quest_SaveTimmy_CompleteAlt_Conditions takes nothing returns boolean
    return((IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(GetUnitTypeId(GetTriggerUnit())!='H01D')and(udg_InCinematicMode==false))!=null // 'H01D': unit "Spirit of Gaya"
endfunction

function Trig_Quest_SaveTimmy_CompleteAlt_Cond_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_SaveTimmy_CompleteAlt_Enum_ShowCelebrate takes nothing returns nothing
    call ShowUnitShow(GetEnumUnit())
    call SetUnitTimeScalePercent(GetEnumUnit(),150.)
endfunction

function Trig_Quest_SaveTimmy_CompleteAlt_Enum_RemoveUnit takes nothing returns nothing
    call KillUnit(GetEnumUnit())
    call RemoveUnit(GetEnumUnit())
endfunction

function Trig_Quest_SaveTimmy_CompleteAlt_Cond_VillagerEffectActive takes nothing returns boolean
    return(udg_VillagerEffectActive)
endfunction

function Trig_Quest_SaveTimmy_CompleteAlt_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[27])
    call GroupRemoveUnitSimple(gg_unit_n00I_0011,udg_BossUnits)
    call SetUnitFacingTimed(udg_TimmyUnit,bj_UNIT_FACING,0)
    if(Trig_Quest_SaveTimmy_CompleteAlt_Cond_CinematicsEnabled())then
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_n00I_0011,0)
        call Text_Say(gg_unit_n00I_0011,"You are the ones who saved my boy? I can't thank you enough.",false)
        call Reward_Give($BB8,$7D0,gg_unit_n00I_0011) // $BB8 = 3000; $7D0 = 2000
        call Cine_ExitAction()
    else
        call Reward_Give($BB8,$7D0,gg_unit_n00I_0011) // $BB8 = 3000; $7D0 = 2000
        call Reward_Give($7D0,$3E8,gg_unit_n00I_0011) // $7D0 = 2000; $3E8 = 1000
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_COMPLETED,"Quest Completed: |cffffcc00Save Timmy|r")
    call QuestSetCompletedBJ(udg_SideQuest[9],true)
    set udg_QuestsCompleted=(udg_QuestsCompleted+1)
    call ForGroupBJ(udg_FarmWorkingVillagers,function Trig_Quest_SaveTimmy_CompleteAlt_Enum_ShowCelebrate)
    call ForGroupBJ(udg_FarmGatheredVillagers,function Trig_Quest_SaveTimmy_CompleteAlt_Enum_RemoveUnit)
    call EnableTrigger(gg_trg_Npc_Talk_PeasantHarvest)
    if(Trig_Quest_SaveTimmy_CompleteAlt_Cond_VillagerEffectActive())then
        set udg_QuestMarkerEffect[$F]=AddSpecialEffectTargetUnitBJ("head",gg_unit_nvil_0003,"Abilities\\Spells\\Other\\Silence\\SilenceTarget.mdl") // $F = 15
    else
        set udg_QuestMarkerEffect[$F]=udg_QuestMarkerEffect[$E] // $F = 15; $E = 14
    endif
    call ConditionalTriggerExecute(gg_trg_Quest_Caravan_Enable)
    call ConditionalTriggerExecute(gg_trg_Kiros_ShowTalkIcon)
    call EnableTrigger(gg_trg_NameDiary_Prepare)
    call StartTimerBJ(udg_TimmyQuestTimer,false,300.)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function InitTrig_Quest_SaveTimmy takes nothing returns nothing
endfunction

endlibrary
