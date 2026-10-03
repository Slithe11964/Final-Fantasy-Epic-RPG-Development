library TTransport
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Transport_HeroLoaded=null
endglobals

function Trig_Transport_HeroLoaded_Conditions takes nothing returns boolean
    return(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Transport_HeroLoaded_Actions takes nothing returns nothing
    local location l_tempPoint
    set udg_PlayerTransport[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=GetTransportUnitBJ()
    set l_tempPoint=GetRectCenter(udg_PlayerStartRect[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
    call SetUnitPositionLoc(GetTriggerUnit(),l_tempPoint)
    call RemoveLocation(l_tempPoint)
    set l_tempPoint=null
endfunction

// World Editor calls InitTrig_Transport automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Transport (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Transport takes nothing returns nothing
endfunction

function Register_Transport_HeroLoaded takes nothing returns nothing
    set gg_trg_Transport_HeroLoaded=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Transport_HeroLoaded,EVENT_PLAYER_UNIT_LOADED)
    call TriggerAddCondition(gg_trg_Transport_HeroLoaded,Condition(function Trig_Transport_HeroLoaded_Conditions))
    call TriggerAddAction(gg_trg_Transport_HeroLoaded,function Trig_Transport_HeroLoaded_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Transport takes nothing returns nothing
    call Register_Transport_HeroLoaded()
endfunction

endlibrary
