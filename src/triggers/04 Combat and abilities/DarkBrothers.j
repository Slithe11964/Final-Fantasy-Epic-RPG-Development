library TDarkBrothers requires TCam, TCine, TText, TWait
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_DarkBrothers_Appear=null
endglobals

function Trig_DarkBrothers_Appear_Conditions takes nothing returns boolean
    return((IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(GetUnitTypeId(GetTriggerUnit())!='H01D')and(udg_InCinematicMode==false))!=null // 'H01D': unit "Spirit of Gaya"
endfunction

function Trig_DarkBrothers_Appear_CinematicsOn takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_DarkBrothers_Appear_Actions takes nothing returns nothing
    local location l_tempPoint
    call DisableTrigger(GetTriggeringTrigger())
    set l_tempPoint=GetUnitLoc(gg_unit_O00B_0032)
    call AddSpecialEffectLocBJ(l_tempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(l_tempPoint)
    set l_tempPoint=GetUnitLoc(gg_unit_O00A_0033)
    call AddSpecialEffectLocBJ(l_tempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(l_tempPoint)
    if(Trig_DarkBrothers_Appear_CinematicsOn())then
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_O00B_0032,0)
        call Wait_Polled(.5)
        call ShowUnitShow(gg_unit_O00B_0032)
        call ShowUnitShow(gg_unit_O00A_0033)
        call Text_Say(null,"|cff383838Dark Brothers have appeared!|r",true)
        call Cine_ExitAction()
    else
        call Wait_Polled(.5)
        call ShowUnitShow(gg_unit_O00B_0032)
        call ShowUnitShow(gg_unit_O00A_0033)
        call DisplayTimedTextToForce(udg_PlayingPlayers,10.,"|cff383838Dark Brothers have appeared!|r")
    endif
    call SetUnitInvulnerable(gg_unit_O00B_0032,false)
    call SetUnitInvulnerable(gg_unit_O00A_0033,false)
    call PauseUnitBJ(false,gg_unit_O00B_0032)
    call PauseUnitBJ(false,gg_unit_O00A_0033)
    call GroupAddUnitSimple(gg_unit_O00B_0032,udg_BossGroup)
    call GroupAddUnitSimple(gg_unit_O00A_0033,udg_BossGroup)
    call GroupAddUnitSimple(gg_unit_O00B_0032,udg_BossUnits)
    call GroupAddUnitSimple(gg_unit_O00A_0033,udg_BossUnits)
    call DestroyTrigger(GetTriggeringTrigger())
    set l_tempPoint=null
endfunction

// World Editor calls InitTrig_DarkBrothers automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_DarkBrothers (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_DarkBrothers takes nothing returns nothing
endfunction

function Register_DarkBrothers_Appear takes nothing returns nothing
    set gg_trg_DarkBrothers_Appear=CreateTrigger()
    call DisableTrigger(gg_trg_DarkBrothers_Appear)
    call TriggerRegisterEnterRectSimple(gg_trg_DarkBrothers_Appear,gg_rct_117)
    call TriggerAddCondition(gg_trg_DarkBrothers_Appear,Condition(function Trig_DarkBrothers_Appear_Conditions))
    call TriggerAddAction(gg_trg_DarkBrothers_Appear,function Trig_DarkBrothers_Appear_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_DarkBrothers takes nothing returns nothing
    call Register_DarkBrothers_Appear() // starts off; enabled by DarkEidolons
endfunction

endlibrary
