library TQuestBrothers requires TCine, TGroup, TPlayerPart01, TReward, TText, TUnit
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
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_DISCOVERED,"New Quest Received: |cffffcc00Brothers|r")
    set udg_SideQuest[8]=CreateQuestBJ(bj_QUESTTYPE_REQ_DISCOVERED,"|cff00ffffBrothers","Izlude, Blade Knight from Kalm, asked you to defeat two Eidolons in the mountains.","ReplaceableTextures\\CommandButtons\\BTNTauren.blp")
    set udg_SpecialEffect[26]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_Hdgo_0097,"Objects\\RandomObject\\RandomObject.mdl")
    call EnableTrigger(gg_trg_Quest_Brothers_Defeated)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Quest_Brothers_Defeated_Cond_NotNeutralPassive takes nothing returns boolean
    return(GetOwningPlayer(GetFilterUnit())!=Player(PLAYER_NEUTRAL_PASSIVE))
endfunction

function Trig_Quest_Brothers_Defeated_Enum_MoveAside takes nothing returns nothing
    set udg_TempPoint=GetUnitLoc(GetEnumUnit())
    set udg_TempPoint2=OffsetLocation(udg_TempPoint,0,-386.)
    call RemoveLocation(udg_TempPoint)
    call SetUnitPositionLoc(GetEnumUnit(),udg_TempPoint2)
    call RemoveLocation(udg_TempPoint2)
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

function Trig_Quest_Brothers_Defeated_Actions takes nothing returns nothing
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_BossUnits)
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call ReviveHeroLoc(GetDyingUnit(),udg_TempPoint,false)
    call RemoveLocation(udg_TempPoint)
    call SetUnitInvulnerable(GetTriggerUnit(),true)
    call SetUnitOwner(GetDyingUnit(),Player(8),false)
    if(Trig_Quest_Brothers_Defeated_Cond_BothBrothersDefeated())then
        call DisableTrigger(GetTriggeringTrigger())
        if(Trig_Quest_Brothers_Defeated_Cond_CinematicsEnabled())then
            set udg_TempPlayer=GetOwningPlayer(GetKillingUnitBJ())
            set udg_TempPoint=GetRectCenter(gg_rct_236)
            call SetUnitPositionLoc(gg_unit_Ocb2_0147,udg_TempPoint)
            call RemoveLocation(udg_TempPoint)
            set udg_TempPoint=GetRectCenter(gg_rct_377)
            call SetUnitPositionLoc(gg_unit_Ocbh_0148,udg_TempPoint)
            call SetUnitFacingTimed(gg_unit_Ocb2_0147,bj_UNIT_FACING,0)
            call SetUnitFacingTimed(gg_unit_Ocbh_0148,bj_UNIT_FACING,0)
            set udg_TempGroup=Group_UnitsInRangeOfLoc(512,udg_TempPoint,Condition(function Trig_Quest_Brothers_Defeated_Cond_NotNeutralPassive))
            call RemoveLocation(udg_TempPoint)
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
        call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_UPDATED,"Return to Izlude.")
        call QuestSetDescriptionBJ(udg_SideQuest[8],"Return to Izlude, Divine Knight from Kalm.")
        call GroupAddUnitSimple(gg_unit_Hdgo_0097,udg_BossUnits)
        set udg_TempPoint=GetRectCenter(gg_rct_235)
        call SetUnitPositionLoc(gg_unit_Ocb2_0147,udg_TempPoint)
        call RemoveLocation(udg_TempPoint)
        set udg_TempPoint=GetRectCenter(gg_rct_376)
        call SetUnitPositionLoc(gg_unit_Ocbh_0148,udg_TempPoint)
        call RemoveLocation(udg_TempPoint)
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
        call EnableTrigger(gg_trg_Quest_Brothers_Complete)
        call EnableTrigger(gg_trg_Brothers_Alert_Eidolons)
        call StartTimerBJ(udg_SharedDelayTimer4,false,30.)
        call DestroyTrigger(GetTriggeringTrigger())
    endif
endfunction

function Trig_Quest_Brothers_Complete_Conditions takes nothing returns boolean
    return((IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(IsUnitHiddenBJ(gg_unit_Hdgo_0097)==false)and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(GetUnitTypeId(GetTriggerUnit())!='H01D')and(udg_InCinematicMode==false))!=null // 'H01D': unit "Spirit of Gaya"
endfunction

function Trig_Quest_Brothers_Complete_Enum_ApplyCamera takes nothing returns nothing
    call CameraSetupApplyForPlayer(true,gg_cam_005,GetEnumPlayer(),1.)
endfunction

function Trig_Quest_Brothers_Complete_Cond_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_Brothers_Complete_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[26])
    call GroupRemoveUnitSimple(gg_unit_Hdgo_0097,udg_BossUnits)
    if(Trig_Quest_Brothers_Complete_Cond_CinematicsEnabled())then
        call Cine_Enter()
        call ForForce(udg_PlayingPlayers,function Trig_Quest_Brothers_Complete_Enum_ApplyCamera)
        call Text_Say(gg_unit_Hdgo_0097,"Thank you very much. Our mighty defenders are already here and their presence here makes me hope that we'll be able to protect ourselves if monsters attack Kalm.",false)
        call Text_Say(gg_unit_Hdgo_0097,"Please, take this gold as a sign of our gratitude.",false)
        call Reward_Give($BB8,$9C4,gg_unit_Hdgo_0097) // $BB8 = 3000; $9C4 = 2500
        call Cine_ExitAction()
    else
        call Reward_Give($BB8,$9C4,gg_unit_Hdgo_0097) // $BB8 = 3000; $9C4 = 2500
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_COMPLETED,"Quest Completed: |cffffcc00Brothers|r")
    call QuestSetCompletedBJ(udg_SideQuest[8],true)
    set udg_QuestsCompleted=(udg_QuestsCompleted+1)
    call AddUnitToStockBJ('n0BC',gg_unit_n0BW_0094,1,1) // 'n0BC': unit "Hunt: Lacerta"
    set udg_HuntStock[4]=(udg_HuntStock[4]+1)
    call ConditionalTriggerExecute(gg_trg_Hunt_Board_Markers)
    set udg_StoryProgress=(udg_StoryProgress+1)
    call ConditionalTriggerExecute(gg_trg_QuestCount_Milestones)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function InitTrig_Quest_Brothers takes nothing returns nothing
endfunction

endlibrary
