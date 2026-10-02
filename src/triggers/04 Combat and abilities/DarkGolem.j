library TDarkGolem requires TCam, TCine, TText
function Trig_DarkGolem_Appear_Conditions takes nothing returns boolean
    return((IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(GetUnitTypeId(GetTriggerUnit())!='H01D')and(udg_InCinematicMode==false))!=null // 'H01D': unit "Spirit of Gaya"
endfunction

function Trig_DarkGolem_Appear_CinematicsOn takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_DarkGolem_Appear_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    if(Trig_DarkGolem_Appear_CinematicsOn())then
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_H01V_0041,0)
        call Text_Say(null,"|cff444444Dark Golem has appeared!|r",true)
        call Cine_ExitAction()
    else
        call DisplayTimedTextToForce(udg_PlayingPlayers,10.,"|cff444444Dark Golem has appeared!|r")
    endif
    call ShowUnitShow(gg_unit_U00B_0042)
    call ShowUnitShow(gg_unit_H01U_0040)
    call AddSpecialEffectTargetUnitBJ("origin",gg_unit_U00B_0042,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call AddSpecialEffectTargetUnitBJ("origin",gg_unit_H01U_0040,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call SetUnitInvulnerable(gg_unit_H01V_0041,false)
    call SetUnitInvulnerable(gg_unit_U00B_0042,false)
    call SetUnitInvulnerable(gg_unit_H01U_0040,false)
    call UnitRemoveAbilityBJ('A0VJ',gg_unit_H01V_0041) // 'A0VJ': ability "Unaffected by Cinematics"
    call PauseUnitBJ(false,gg_unit_H01V_0041)
    call PauseUnitBJ(false,gg_unit_U00B_0042)
    call PauseUnitBJ(false,gg_unit_H01U_0040)
    call GroupAddUnitSimple(gg_unit_H01V_0041,udg_BossGroup)
    call GroupAddUnitSimple(gg_unit_U00B_0042,udg_BossGroup)
    call GroupAddUnitSimple(gg_unit_H01U_0040,udg_BossGroup)
    call GroupAddUnitSimple(gg_unit_H01V_0041,udg_BossUnits)
    set udg_TempPoint=GetUnitLoc(gg_unit_H01V_0041)
    call IssuePointOrderLocBJ(gg_unit_H01U_0040,"attack",udg_TempPoint)
    call IssuePointOrderLocBJ(gg_unit_U00B_0042,"attack",udg_TempPoint)
    call RemoveLocation(udg_TempPoint)
    call EnableTrigger(gg_trg_DarkCyclops_Appear)
    call EnableTrigger(gg_trg_DarkTitan_Appear)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_DarkGolem automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_DarkGolem (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_DarkGolem takes nothing returns nothing
endfunction

function Register_DarkGolem_Appear takes nothing returns nothing
    set gg_trg_DarkGolem_Appear=CreateTrigger()
    call DisableTrigger(gg_trg_DarkGolem_Appear)
    call TriggerRegisterUnitInRangeSimple(gg_trg_DarkGolem_Appear,350.,gg_unit_H01V_0041)
    call TriggerAddCondition(gg_trg_DarkGolem_Appear,Condition(function Trig_DarkGolem_Appear_Conditions))
    call TriggerAddAction(gg_trg_DarkGolem_Appear,function Trig_DarkGolem_Appear_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_DarkGolem takes nothing returns nothing
    call Register_DarkGolem_Appear()
endfunction

endlibrary
