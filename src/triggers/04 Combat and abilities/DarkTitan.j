library TDarkTitan requires TCam, TCine, TText
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_DarkTitan_Appear=null
endglobals

function Trig_DarkTitan_Appear_Conditions takes nothing returns boolean
    return((IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(GetUnitTypeId(GetTriggerUnit())!='H01D')and(udg_InCinematicMode==false))!=null // 'H01D': unit "Spirit of Gaya"
endfunction

function Trig_DarkTitan_Appear_CinematicsOn takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_DarkTitan_Appear_TitanAlive takes nothing returns boolean
    return(IsUnitInGroup(gg_unit_H01U_0040,udg_DarkEidolonGroup))
endfunction

function Trig_DarkTitan_Appear_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    if(Trig_DarkTitan_Appear_TitanAlive())then
        call GroupAddUnitSimple(gg_unit_H01U_0040,udg_BossUnits)
        if(Trig_DarkTitan_Appear_CinematicsOn())then
            call Cine_Enter()
            call Cam_PanToUnit(gg_unit_H01U_0040,0)
            call Text_Say(null,"|cff666666Dark Titan has appeared!|r",true)
            call Cine_ExitAction()
        else
            call DisplayTimedTextToForce(udg_PlayingPlayers,10.,"|cff666666Dark Titan has appeared!|r")
        endif
    endif
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_DarkTitan automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_DarkTitan (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_DarkTitan takes nothing returns nothing
endfunction

function Register_DarkTitan_Appear takes nothing returns nothing
    set gg_trg_DarkTitan_Appear=CreateTrigger()
    call DisableTrigger(gg_trg_DarkTitan_Appear)
    call TriggerRegisterUnitInRangeSimple(gg_trg_DarkTitan_Appear,400.,gg_unit_H01U_0040)
    call TriggerAddCondition(gg_trg_DarkTitan_Appear,Condition(function Trig_DarkTitan_Appear_Conditions))
    call TriggerAddAction(gg_trg_DarkTitan_Appear,function Trig_DarkTitan_Appear_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_DarkTitan takes nothing returns nothing
    call Register_DarkTitan_Appear()
endfunction

endlibrary
