library TDarkLeviathan requires TCam, TCine, TText
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_DarkLeviathan_Appear=null
endglobals

function Trig_DarkLeviathan_Appear_Conditions takes nothing returns boolean
    return((IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(GetUnitTypeId(GetTriggerUnit())!='H01D')and(udg_InCinematicMode==false))!=null // 'H01D': unit "Spirit of Gaya"
endfunction

function Trig_DarkLeviathan_Appear_CinematicsOn takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_DarkLeviathan_Appear_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    set udg_TempPoint=GetUnitLoc(gg_unit_H01Z_0036)
    call AddSpecialEffectLocBJ(udg_TempPoint,"Objects\\Spawnmodels\\Naga\\NagaDeath\\NagaDeath.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(udg_TempPoint)
    call ShowUnitShow(gg_unit_H01Z_0036)
    if(Trig_DarkLeviathan_Appear_CinematicsOn())then
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_H01Z_0036,0)
        call Text_Say(null,"|cff0000afDark Leviathan has appeared!|r",true)
        call Cine_ExitAction()
    else
        call DisplayTimedTextToForce(udg_PlayingPlayers,10.,"|cff0000afDark Leviathan has appeared!|r")
    endif
    call SetUnitInvulnerable(gg_unit_H01Z_0036,false)
    call PauseUnitBJ(false,gg_unit_H01Z_0036)
    call GroupAddUnitSimple(gg_unit_H01Z_0036,udg_BossGroup)
    call GroupAddUnitSimple(gg_unit_H01Z_0036,udg_BossUnits)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_DarkLeviathan automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_DarkLeviathan (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_DarkLeviathan takes nothing returns nothing
endfunction

function Register_DarkLeviathan_Appear takes nothing returns nothing
    set gg_trg_DarkLeviathan_Appear=CreateTrigger()
    call DisableTrigger(gg_trg_DarkLeviathan_Appear)
    call TriggerRegisterEnterRectSimple(gg_trg_DarkLeviathan_Appear,gg_rct_121)
    call TriggerAddCondition(gg_trg_DarkLeviathan_Appear,Condition(function Trig_DarkLeviathan_Appear_Conditions))
    call TriggerAddAction(gg_trg_DarkLeviathan_Appear,function Trig_DarkLeviathan_Appear_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_DarkLeviathan takes nothing returns nothing
    call Register_DarkLeviathan_Appear()
endfunction

endlibrary
