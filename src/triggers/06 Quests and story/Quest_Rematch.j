library TQuestRematch requires TCam, TCine, TGroup, TPlayerPart01, TReward, TText, TUnit, TWait
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Quest_Rematch_Start=null
    trigger gg_trg_Quest_Rematch_Begin=null
    trigger gg_trg_Quest_Rematch_Complete=null
endglobals

function Trig_Quest_Rematch_Start_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_Ocb2_0147,true,true,true))
endfunction

function Trig_Quest_Rematch_Start_Cond_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_Rematch_Start_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[53])
    if(Trig_Quest_Rematch_Start_Cond_CinematicsEnabled())then
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_Ocbh_0148,0)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Minotaur, you called for us?",false)
        call Text_Say(gg_unit_Ocb2_0147,"Yeah. I talked it over with bro, and we really need to have a rematch with you!",false)
        call Text_Say(gg_unit_Ocbh_0148,"We've become stronger defending this town, y'know.",false)
        call Text_Say(gg_unit_Ocb2_0147,"And we have our honor as Eidolons to defend. We will gladly continue to serve you if you are still powerful enough to take us both on, of course!",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"You want to be reassured of our power then? Sure, I don't see why not.",false)
        call Text_Say(gg_unit_Ocb2_0147,"We'll go to the place where we fought the first time. Tell us when you're ready!",false)
        call Text_Say(gg_unit_Ocbh_0148,"See you there, mighty one!",false)
        call Cine_ExitAction()
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_DISCOVERED,"New Quest Received: |cffffcc00Rematch|r")
    set udg_SideQuest[34]=CreateQuestBJ(bj_QUESTTYPE_REQ_DISCOVERED,(udg_QuestNamePrefix+"Rematch"),"The Brothers, Sacred and Minotaur, have challenged you one more time. Meet them on the eastern peak of the Northern Mountains to prove that you are still worthy of their loyalty!","ReplaceableTextures\\CommandButtons\\BTNHeroTaurenChieftain.blp")
    call GroupRemoveUnitSimple(gg_unit_Ocb2_0147,udg_RecruitedAllies)
    call GroupRemoveUnitSimple(gg_unit_Ocbh_0148,udg_RecruitedAllies)
    call GroupAddUnitSimple(gg_unit_Ocb2_0147,udg_BossUnits)
    call GroupAddUnitSimple(gg_unit_Ocbh_0148,udg_BossUnits)
    set udg_TempPoint=GetRectCenter(gg_rct_236)
    call SetUnitPositionLocFacingBJ(gg_unit_Ocb2_0147,udg_TempPoint,bj_UNIT_FACING)
    call RemoveLocation(udg_TempPoint)
    set udg_TempPoint=GetRectCenter(gg_rct_377)
    call SetUnitPositionLocFacingBJ(gg_unit_Ocbh_0148,udg_TempPoint,bj_UNIT_FACING)
    call RemoveLocation(udg_TempPoint)
    call SetUnitOwner(gg_unit_Ocb2_0147,Player(8),false)
    call SetUnitOwner(gg_unit_Ocbh_0148,Player(8),false)
    call Wait_Polled(1.)
    set udg_SpecialEffect[53]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_Ocb2_0147,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call EnableTrigger(gg_trg_Quest_Rematch_Begin)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Quest_Rematch_Begin_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_Ocb2_0147,true,true,true))
endfunction

function Trig_Quest_Rematch_Begin_Cond_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_Rematch_Begin_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[53])
    if(Trig_Quest_Rematch_Begin_Cond_CinematicsEnabled())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(gg_unit_Ocb2_0147,"Prepare yourselves!",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Yes, let us fight!",false)
        call Text_Say(gg_unit_Ocbh_0148,"May the better creature win!",false)
        call Cine_ExitAction()
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_UPDATED,"Defeat the Brothers.")
    call QuestSetDescriptionBJ(udg_SideQuest[34],"Defeat the Brothers.")
    call UnitAddAbilityBJ('A0N6',gg_unit_Ocb2_0147) // 'A0N6': ability "Magicdamage Reduction"
    call UnitAddAbilityBJ('A0N6',gg_unit_Ocbh_0148) // 'A0N6': ability "Magicdamage Reduction"
    call SetUnitOwner(gg_unit_Ocb2_0147,Player($B),true) // $B = 11
    call SetUnitOwner(gg_unit_Ocbh_0148,Player($B),true) // $B = 11
    call SetUnitInvulnerable(gg_unit_Ocb2_0147,false)
    call SetUnitInvulnerable(gg_unit_Ocbh_0148,false)
    call EnableTrigger(gg_trg_Quest_Rematch_Complete)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Quest_Rematch_Complete_Cond_NotNeutral takes nothing returns boolean
    return(GetOwningPlayer(GetFilterUnit())!=Player(8))
endfunction

function Trig_Quest_Rematch_Complete_Enum_PushUnitAside takes nothing returns nothing
    set udg_TempPoint=GetUnitLoc(GetEnumUnit())
    set udg_TempPoint2=OffsetLocation(udg_TempPoint,0,-386.)
    call RemoveLocation(udg_TempPoint)
    call SetUnitPositionLoc(GetEnumUnit(),udg_TempPoint2)
    call RemoveLocation(udg_TempPoint2)
endfunction

function Trig_Quest_Rematch_Complete_Cond_TowerOwned_Text takes nothing returns boolean
    return(GetOwningPlayer(gg_unit_h00Z_0130)==Player($A)) // $A = 10
endfunction

function Trig_Quest_Rematch_Complete_Enum_ApplyCamera takes nothing returns nothing
    call CameraSetupApplyForPlayer(true,gg_cam_013,GetEnumPlayer(),1.)
endfunction

function Trig_Quest_Rematch_Complete_Cond_TowerOwned_Cine takes nothing returns boolean
    return(GetOwningPlayer(gg_unit_h00Z_0130)==Player($A)) // $A = 10
endfunction

function Trig_Quest_Rematch_Complete_Cond_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_Rematch_Complete_Enum_GiveMateria takes nothing returns nothing
    call UnitAddItemByIdSwapped('I03G',Player_GetHero(GetEnumPlayer())) // 'I03G': item "Quake Materia"
endfunction

function Trig_Quest_Rematch_Complete_Cond_SacredDefeated takes nothing returns boolean
    return(GetOwningPlayer(gg_unit_Ocbh_0148)==Player(8))
endfunction

function Trig_Quest_Rematch_Complete_Cond_MinotaurDefeated takes nothing returns boolean
    return(GetOwningPlayer(gg_unit_Ocb2_0147)==Player(8))
endfunction

function Trig_Quest_Rematch_Complete_Cond_BothBrothersDefeated takes nothing returns boolean
    return(GetBooleanAnd(Trig_Quest_Rematch_Complete_Cond_SacredDefeated(),Trig_Quest_Rematch_Complete_Cond_MinotaurDefeated()))
endfunction

function Trig_Quest_Rematch_Complete_Actions takes nothing returns nothing
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_BossUnits)
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call ReviveHeroLoc(GetDyingUnit(),udg_TempPoint,false)
    call RemoveLocation(udg_TempPoint)
    call SetUnitInvulnerable(GetTriggerUnit(),true)
    call SetUnitOwner(GetDyingUnit(),Player(8),false)
    if(Trig_Quest_Rematch_Complete_Cond_BothBrothersDefeated())then
        call DisableTrigger(GetTriggeringTrigger())
        if(Trig_Quest_Rematch_Complete_Cond_CinematicsEnabled())then
            set udg_TempPoint=GetRectCenter(gg_rct_236)
            call SetUnitPositionLocFacingBJ(gg_unit_Ocb2_0147,udg_TempPoint,bj_UNIT_FACING)
            call RemoveLocation(udg_TempPoint)
            set udg_TempPoint=GetRectCenter(gg_rct_377)
            call SetUnitPositionLocFacingBJ(gg_unit_Ocbh_0148,udg_TempPoint,bj_UNIT_FACING)
            set udg_TempGroup=Group_UnitsInRangeOfLoc(512,udg_TempPoint,Condition(function Trig_Quest_Rematch_Complete_Cond_NotNeutral))
            call RemoveLocation(udg_TempPoint)
            call ForGroupBJ(udg_TempGroup,function Trig_Quest_Rematch_Complete_Enum_PushUnitAside)
            call DestroyGroup(udg_TempGroup)
            call Cine_Enter()
            call ForForce(udg_PlayingPlayers,function Trig_Quest_Rematch_Complete_Enum_ApplyCamera)
            call SetUnitFacingToFaceUnitTimed(gg_unit_Ocbh_0148,gg_unit_Ocb2_0147,1.)
            call Text_Say(gg_unit_Ocbh_0148,"I can't believe it! They beat us again!",false)
            call SetUnitFacingToFaceUnitTimed(gg_unit_Ocb2_0147,gg_unit_Ocbh_0148,1.)
            call Text_Say(gg_unit_Ocb2_0147,"Yeah. I guess we'll have to accept they're stonger than we are.",false)
            call Text_Say(gg_unit_Ocbh_0148,"Seems that way.",false)
            call SetUnitFacingTimed(gg_unit_Ocb2_0147,bj_UNIT_FACING,0)
            call SetUnitFacingTimed(gg_unit_Ocbh_0148,bj_UNIT_FACING,0)
            call Text_Say(gg_unit_Ocb2_0147,"Mighty ones! We have a great reward for you!",false)
            call Text_Say(gg_unit_Ocbh_0148,"This stone contains a great deal of our power. Use it to call forth our powers as you wish.",false)
            call Text_Say(gg_unit_Ocb2_0147,"Also we will be glad to join you in battle once more, if you require our aid.",false)
            call Reward_Give(6000,6000,gg_unit_Ocb2_0147)
            call Text_Say(gg_unit_Ocb2_0147,"|n|cffffcc00All players get a piece of Quake Materia.|r",true)
            if(Trig_Quest_Rematch_Complete_Cond_TowerOwned_Cine())then
                call Text_Say(gg_unit_Ocb2_0147,"|n|cffffcc00The Brothers are now available at Tower of Summoning.|r",true)
            endif
            call Cine_ExitAction()
        else
            call Reward_Give(6000,6000,gg_unit_Ocb2_0147)
            call DisplayTimedTextToForce(udg_PlayingPlayers,10.,"|cffffcc00All players get a piece of Quake Materia.|r")
            if(Trig_Quest_Rematch_Complete_Cond_TowerOwned_Text())then
                call DisplayTimedTextToForce(udg_PlayingPlayers,10.,"|cffffcc00The Brothers are now available at Tower of Summoning.|r")
            endif
        endif
        call ForForce(udg_PlayingPlayers,function Trig_Quest_Rematch_Complete_Enum_GiveMateria)
        call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_COMPLETED,"Quest Completed: |cffffcc00Rematch|r")
        call QuestSetCompletedBJ(udg_SideQuest[34],true)
        set udg_QuestsCompleted=(udg_QuestsCompleted+1)
        call SaveIntegerBJ(0,2,'n',udg_GameStateHash)
        call SaveIntegerBJ(1,2,'o',udg_GameStateHash)
        call UnitAddAbilityBJ('A09M',gg_unit_h00Z_0130) // 'A09M': ability "Brothers"
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
        call GroupAddUnitSimple(gg_unit_Ocb2_0147,udg_RecruitedAllies)
        call GroupAddUnitSimple(gg_unit_Ocbh_0148,udg_RecruitedAllies)
        call DestroyTrigger(GetTriggeringTrigger())
    endif
endfunction

function InitTrig_Quest_Rematch takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Quest_Part12 (module Quest),
// which keeps the original registration order.

function Register_Quest_Rematch_Start takes nothing returns nothing
    set gg_trg_Quest_Rematch_Start=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_Rematch_Start)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Rematch_Start,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Rematch_Start,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Rematch_Start,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Rematch_Start,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Rematch_Start,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Rematch_Start,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Rematch_Start,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Rematch_Start,Player(7),true)
    call TriggerAddCondition(gg_trg_Quest_Rematch_Start,Condition(function Trig_Quest_Rematch_Start_Conditions))
    call TriggerAddAction(gg_trg_Quest_Rematch_Start,function Trig_Quest_Rematch_Start_Actions)
endfunction

function Register_Quest_Rematch_Begin takes nothing returns nothing
    set gg_trg_Quest_Rematch_Begin=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_Rematch_Begin)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Rematch_Begin,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Rematch_Begin,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Rematch_Begin,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Rematch_Begin,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Rematch_Begin,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Rematch_Begin,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Rematch_Begin,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Rematch_Begin,Player(7),true)
    call TriggerAddCondition(gg_trg_Quest_Rematch_Begin,Condition(function Trig_Quest_Rematch_Begin_Conditions))
    call TriggerAddAction(gg_trg_Quest_Rematch_Begin,function Trig_Quest_Rematch_Begin_Actions)
endfunction

function Register_Quest_Rematch_Complete takes nothing returns nothing
    set gg_trg_Quest_Rematch_Complete=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_Rematch_Complete)
    call TriggerRegisterUnitEvent(gg_trg_Quest_Rematch_Complete,gg_unit_Ocb2_0147,EVENT_UNIT_DEATH)
    call TriggerRegisterUnitEvent(gg_trg_Quest_Rematch_Complete,gg_unit_Ocbh_0148,EVENT_UNIT_DEATH)
    call TriggerAddAction(gg_trg_Quest_Rematch_Complete,function Trig_Quest_Rematch_Complete_Actions)
endfunction

endlibrary
