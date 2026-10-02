library TDarkCyclops requires TCam, TCine, TText
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_DarkCyclops_Appear=null
endglobals

function Trig_DarkCyclops_Appear_Conditions takes nothing returns boolean
    return((IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(GetUnitTypeId(GetTriggerUnit())!='H01D')and(udg_InCinematicMode==false))!=null // 'H01D': unit "Spirit of Gaya"
endfunction

function Trig_DarkCyclops_Appear_CinematicsOn takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_DarkCyclops_Appear_CyclopsAlive takes nothing returns boolean
    return(IsUnitInGroup(gg_unit_U00B_0042,udg_DarkEidolonGroup))
endfunction

function Trig_DarkCyclops_Appear_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    if(Trig_DarkCyclops_Appear_CyclopsAlive())then
        call GroupAddUnitSimple(gg_unit_U00B_0042,udg_BossUnits)
        if(Trig_DarkCyclops_Appear_CinematicsOn())then
            call Cine_Enter()
            call Cam_PanToUnit(gg_unit_U00B_0042,0)
            call Text_Say(null,"|cff555555Dark Cyclops has appeared!|r",true)
            call Cine_ExitAction()
        else
            call DisplayTimedTextToForce(udg_PlayingPlayers,10.,"|cff555555Dark Cyclops has appeared!|r")
        endif
    endif
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_DarkCyclops automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_DarkCyclops (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_DarkCyclops takes nothing returns nothing
endfunction

function Register_DarkCyclops_Appear takes nothing returns nothing
    set gg_trg_DarkCyclops_Appear=CreateTrigger()
    call DisableTrigger(gg_trg_DarkCyclops_Appear)
    call TriggerRegisterUnitInRangeSimple(gg_trg_DarkCyclops_Appear,400.,gg_unit_U00B_0042)
    call TriggerAddCondition(gg_trg_DarkCyclops_Appear,Condition(function Trig_DarkCyclops_Appear_Conditions))
    call TriggerAddAction(gg_trg_DarkCyclops_Appear,function Trig_DarkCyclops_Appear_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_DarkCyclops takes nothing returns nothing
    call Register_DarkCyclops_Appear()
endfunction

endlibrary
