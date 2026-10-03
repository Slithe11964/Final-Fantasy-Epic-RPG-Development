library TMcBurn requires TCam, TCine, TGroup, TLoc, TMusic, TPlayerHero, TText, TWait
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_McBurn_Arena_Hide=null
    trigger gg_trg_McBurn_Arena_Appear=null
    trigger gg_trg_McBurn_Heat_Color=null
    trigger gg_trg_McBurn_TrueForm_Reveal=null
    trigger gg_trg_McBurn_Arena_Return=null
    trigger gg_trg_McBurn_Volcano=null
endglobals

function Trig_McBurn_Arena_Hide_Actions takes nothing returns nothing
    call ShowUnitHide(gg_unit_n0AX_0188)
    set udg_DarkFireStage=0
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_McBurn_Arena_Appear_Actions takes nothing returns nothing
    set udg_SpecialEffect[69]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_n0AX_0188,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    set udg_ArenaOrganizerLast=6
    call UnitAddAbilityBJ('Ane2',gg_unit_n0AX_0188) // 'Ane2': object name not found in map data
    call EnableTrigger(gg_trg_Quest_TrialByFire_Start)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_McBurn_Heat_Color_Cond_HasGatheringHeat takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0YW',GetFilterUnit())>0) // 'A0YW': ability "Gathering Heat"
endfunction

function Trig_McBurn_Heat_Color_Cond_NoFullHeat takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0Z1',GetFilterUnit())<=0) // 'A0Z1': ability "Full Heat"
endfunction

function Trig_McBurn_Heat_Color_Filter_HeatingUnit takes nothing returns boolean
    return GetBooleanAnd(Trig_McBurn_Heat_Color_Cond_HasGatheringHeat(),Trig_McBurn_Heat_Color_Cond_NoFullHeat())
endfunction

function Trig_McBurn_Heat_Color_Cond_EnumHeating takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0YW',GetEnumUnit())>0)and(GetUnitAbilityLevelSwapped('A0Z1',GetEnumUnit())<=0) // 'A0YW': ability "Gathering Heat"; 'A0Z1': ability "Full Heat"
endfunction

function Trig_McBurn_Heat_Color_TintByLife takes nothing returns nothing
    if(Trig_McBurn_Heat_Color_Cond_EnumHeating())then
        // Calculation 1:
        // Result 1: current health divided by maximum health for the unit being visited, times 100 (or 0 if the unit
        // is missing or its maximum is 0).
        // Calculation 2:
        // Result 1: current health divided by maximum health for the unit being visited, times 100 (or 0 if the unit
        // is missing or its maximum is 0).
        call SetUnitVertexColorBJ(GetEnumUnit(),'d',GetUnitLifePercent(GetEnumUnit()),GetUnitLifePercent(GetEnumUnit()),0)
    endif
endfunction

function Trig_McBurn_Heat_Color_Actions takes nothing returns nothing
    local group l_tempGroup
    set l_tempGroup=Group_UnitsInRect(GetPlayableMapRect(),Condition(function Trig_McBurn_Heat_Color_Filter_HeatingUnit))
    call ForGroupBJ(l_tempGroup,function Trig_McBurn_Heat_Color_TintByLife)
    call DestroyGroup(l_tempGroup)
    call StartTimerBJ(udg_PostReviveTimer,false,1.)
    set l_tempGroup=null
endfunction

function Trig_McBurn_TrueForm_Reveal_Conditions takes nothing returns boolean
    return((IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(GetUnitTypeId(GetTriggerUnit())!='H01D')and(udg_InCinematicMode==false))!=null // 'H01D': unit "Spirit of Gaya"
endfunction

function Trig_McBurn_TrueForm_Reveal_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DisableTrigger(gg_trg_ScorchedEarth_HeatFade)
    call DestroyTrigger(gg_trg_ScorchedEarth_HeatFade)
    call Cine_Enter()
    call Cam_PanToUnit(GetTriggerUnit(),0)
    call Wait_Polled(2)
    call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"Whose doing is this!? Show yourself already!",true)
    call PlaySoundBJ(gg_snd_SargerasLaugh)
    call Text_Say(null,"Hahaha...",true)
    call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"!",true)
    call Cam_PanToUnit(gg_unit_U00Q_0023,.2)
    call ShowUnitShow(gg_unit_U00Q_0023)
    call AddSpecialEffectTargetUnitBJ("origin",gg_unit_U00Q_0023,"Abilities\\Spells\\Other\\Doom\\DoomDeath.mdl")
    call BlzSetSpecialEffectScale(GetLastCreatedEffectBJ(),5.)
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call Wait_Polled(3.)
    call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"You... you can't possibly be...",true)
    call Text_Say(gg_unit_U00Q_0023,"I am McBurn. This is my true form.",true)
    call Text_Say(gg_unit_U00Q_0023,"What you see before you is the result of me releasing all the heat I've been suppressing.",true)
    call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"This used to be a land of eternal snow, and your power turned it into a fiery wasteland just like that!?",true)
    call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"I have to admit it... your power is beyond comprehension.",true)
    call Text_Say(gg_unit_U00Q_0023,"... You are powerful fighters yourself. Not many exist that could hold their own against my previous forms.",true)
    call Text_Say(gg_unit_U00Q_0023,"You've allowed me to go all out. So then, you know what comes next, don't you.",true)
    call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"Of course I do.",true)
    call Music_SetTrack(35)
    call Text_Say(gg_unit_U00Q_0023,"Haha. You're just like me aren't you.",true)
    call Text_Say(gg_unit_U00Q_0023,"You're looking to challenge yourself. To take on the toughest demons and monsters you can find. That's what you've done all this for yourself, isn't it?",true)
    call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"Yeah. You're goddamn right. I've been waiting for this myself.",true)
    call Text_Say(gg_unit_U00Q_0023,"That's the spirit. We are surrounded by flames on all sides. That's how it has to be. Let us do battle once more... in this infernal hellscape!",true)
    call Cine_ExitAction()
    call PauseUnitBJ(false,gg_unit_U00Q_0023)
    call SetUnitInvulnerable(gg_unit_U00Q_0023,false)
    call GroupAddUnitSimple(gg_unit_U00Q_0023,udg_BossGroup)
    set udg_ScriptedBossUnit=gg_unit_U00Q_0023
    call EnableTrigger(gg_trg_McBurn_Arena_Return)
    call EnableTrigger(gg_trg_Quest_ScorchedEarth_End)
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_UPDATED,"Defeat McBurn.")
    call QuestSetDescriptionBJ(udg_SideQuest[52],"Defeat McBurn, the Otherworldly King.")
    call Wait_Polled(10.)
    call EnableTrigger(gg_trg_McBurn_Volcano)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_McBurn_Arena_Return_Conditions takes nothing returns boolean
    return(GetTriggerUnit()==gg_unit_U00Q_0023)
endfunction

function Trig_McBurn_Arena_Return_Actions takes nothing returns nothing
    local location l_tempPoint
    set l_tempPoint=GetUnitLoc(GetTriggerUnit())
    call AddSpecialEffectLocBJ(l_tempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(l_tempPoint)
    set l_tempPoint=GetRectCenter(gg_rct_645)
    call SetUnitPositionLocFacingBJ(GetTriggerUnit(),l_tempPoint,90.)
    call RemoveLocation(l_tempPoint)
    call AddSpecialEffectTargetUnitBJ("origin",GetTriggerUnit(),"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    set l_tempPoint=null
endfunction

function Trig_McBurn_Volcano_Conditions takes nothing returns boolean
    return(GetTriggerUnit()==gg_unit_U00Q_0023)
endfunction

function Trig_McBurn_Volcano_ShakeCamera takes nothing returns nothing
    call CameraSetEQNoiseForPlayer(GetEnumPlayer(),1.5)
endfunction

function Trig_McBurn_Volcano_ClearCameraShake takes nothing returns nothing
    call CameraClearNoiseForPlayer(GetEnumPlayer())
endfunction

function Trig_McBurn_Volcano_Cond_NotEnraged takes nothing returns boolean
    // Result 1: current health divided by maximum health for the triggering unit, times 100 (or 0 if the unit is
    // missing or its maximum is 0).
    return(UnitHasBuffBJ(GetTriggerUnit(),'B05V')==false)and(GetUnitLifePercent(GetTriggerUnit())>40.) // 'B05V': buff tooltip "Disease"
endfunction

function Trig_McBurn_Volcano_Actions takes nothing returns nothing
    local integer l_tempHandleId
    local location l_tempPoint
    local location l_tempPoint2
    call DisableTrigger(GetTriggeringTrigger())
    set l_tempPoint=GetUnitLoc(GetTriggerUnit())
    // Calculation 1:
    // A random decimal number between 256 and 512.
    // Calculation 2:
    // (facing in degrees of the triggering unit) plus (a random decimal number between 270 and 450).
    set l_tempPoint2=Loc_PolarOffset(l_tempPoint,GetRandomReal(256.,512.),(GetUnitFacing(GetTriggerUnit())+GetRandomReal(270.,450.)))
    call RemoveLocation(l_tempPoint)
    call CreateNUnitsAtLocFacingLocBJ(1,'h01B',GetOwningPlayer(GetTriggerUnit()),l_tempPoint2,l_tempPoint2) // 'h01B': unit "Proxy Dummy"
    set l_tempHandleId=GetHandleIdBJ(GetLastCreatedUnit())
    call SaveUnitHandleBJ(GetTriggerUnit(),0,l_tempHandleId,udg_ProxyDamageHash)
    call SaveRealBJ(6666.,1,l_tempHandleId,udg_ProxyDamageHash)
    call SaveIntegerBJ(3,2,l_tempHandleId,udg_ProxyDamageHash)
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(15.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A0M1',GetLastCreatedUnit()) // 'A0M1': ability "Fire-elemental Damage"
    call UnitAddAbilityBJ('A114',GetLastCreatedUnit()) // 'A114': ability "Volcano"
    call IssuePointOrderLocBJ(GetLastCreatedUnit(),"volcano",l_tempPoint2)
    call RemoveLocation(l_tempPoint2)
    call ForForce(udg_PlayingPlayers,function Trig_McBurn_Volcano_ShakeCamera)
    call Wait_Polled(2.)
    call ForForce(udg_PlayingPlayers,function Trig_McBurn_Volcano_ClearCameraShake)
    if(Trig_McBurn_Volcano_Cond_NotEnraged())then
        call Wait_Polled(8.)
    endif
    call EnableTrigger(GetTriggeringTrigger())
    set l_tempPoint=null
    set l_tempPoint2=null
endfunction

// World Editor calls InitTrig_McBurn automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_McBurn_Part1 / RegisterTriggers_McBurn_Part2 (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_McBurn takes nothing returns nothing
endfunction

function Register_McBurn_Arena_Hide takes nothing returns nothing
    set gg_trg_McBurn_Arena_Hide=CreateTrigger()
    call TriggerAddAction(gg_trg_McBurn_Arena_Hide,function Trig_McBurn_Arena_Hide_Actions)
endfunction

function Register_McBurn_Arena_Appear takes nothing returns nothing
    set gg_trg_McBurn_Arena_Appear=CreateTrigger()
    call DisableTrigger(gg_trg_McBurn_Arena_Appear)
    call TriggerAddAction(gg_trg_McBurn_Arena_Appear,function Trig_McBurn_Arena_Appear_Actions)
endfunction

function Register_McBurn_Heat_Color takes nothing returns nothing
    set gg_trg_McBurn_Heat_Color=CreateTrigger()
    call TriggerRegisterTimerExpireEventBJ(gg_trg_McBurn_Heat_Color,udg_PostReviveTimer)
    call TriggerAddAction(gg_trg_McBurn_Heat_Color,function Trig_McBurn_Heat_Color_Actions)
endfunction

function Register_McBurn_TrueForm_Reveal takes nothing returns nothing
    set gg_trg_McBurn_TrueForm_Reveal=CreateTrigger()
    call DisableTrigger(gg_trg_McBurn_TrueForm_Reveal)
    call TriggerRegisterUnitInRangeSimple(gg_trg_McBurn_TrueForm_Reveal,800.,gg_unit_U00Q_0023)
    call TriggerAddCondition(gg_trg_McBurn_TrueForm_Reveal,Condition(function Trig_McBurn_TrueForm_Reveal_Conditions))
    call TriggerAddAction(gg_trg_McBurn_TrueForm_Reveal,function Trig_McBurn_TrueForm_Reveal_Actions)
endfunction

function Register_McBurn_Arena_Return takes nothing returns nothing
    set gg_trg_McBurn_Arena_Return=CreateTrigger()
    call DisableTrigger(gg_trg_McBurn_Arena_Return)
    call TriggerRegisterEnterRectSimple(gg_trg_McBurn_Arena_Return,gg_rct_575)
    call TriggerRegisterEnterRectSimple(gg_trg_McBurn_Arena_Return,gg_rct_576)
    call TriggerAddCondition(gg_trg_McBurn_Arena_Return,Condition(function Trig_McBurn_Arena_Return_Conditions))
    call TriggerAddAction(gg_trg_McBurn_Arena_Return,function Trig_McBurn_Arena_Return_Actions)
endfunction

function Register_McBurn_Volcano takes nothing returns nothing
    set gg_trg_McBurn_Volcano=CreateTrigger()
    call DisableTrigger(gg_trg_McBurn_Volcano)
    call TriggerRegisterAnyUnitEventBJ(gg_trg_McBurn_Volcano,EVENT_PLAYER_UNIT_SPELL_CAST)
    call TriggerAddCondition(gg_trg_McBurn_Volcano,Condition(function Trig_McBurn_Volcano_Conditions))
    call TriggerAddAction(gg_trg_McBurn_Volcano,function Trig_McBurn_Volcano_Actions)
endfunction

// Creates part 1 of 2 of this module's triggers. Called once at startup from
// Startup_RegisterTriggers (MapBootstrap). The parts are registered at different points so that
// triggers sharing an event with other modules keep their original firing order.
function RegisterTriggers_McBurn_Part1 takes nothing returns nothing
    call Register_McBurn_Arena_Hide() // run by MapBootstrap
    call Register_McBurn_Arena_Appear() // starts off; run by Arena_TeamSelection
    call Register_McBurn_Heat_Color()
    call Register_McBurn_TrueForm_Reveal() // starts off; enabled by ScorchedEarth
endfunction

// Creates part 2 of 2 of this module's triggers. Called once at startup from
// Startup_RegisterTriggers (MapBootstrap). The parts are registered at different points so that
// triggers sharing an event with other modules keep their original firing order.
function RegisterTriggers_McBurn_Part2 takes nothing returns nothing
    call Register_McBurn_Arena_Return() // starts off; enabled by McBurn; disabled by Quest_ScorchedEarth; destroyed by Quest_ScorchedEarth
    call Register_McBurn_Volcano() // starts off; enabled by McBurn
endfunction

endlibrary
