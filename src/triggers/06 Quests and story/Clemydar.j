library TClemydar
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Clemydar_ShowMarker=null
endglobals

function Trig_Clemydar_ShowMarker_Actions takes nothing returns nothing
    set udg_SpecialEffect[83]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_nemi_0078,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call EnableTrigger(gg_trg_Quest_SeekDestroy_Start)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_Clemydar automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Clemydar (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Clemydar takes nothing returns nothing
endfunction

function Register_Clemydar_ShowMarker takes nothing returns nothing
    set gg_trg_Clemydar_ShowMarker=CreateTrigger()
    call TriggerRegisterTimerEventSingle(gg_trg_Clemydar_ShowMarker,12.)
    call TriggerAddAction(gg_trg_Clemydar_ShowMarker,function Trig_Clemydar_ShowMarker_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Clemydar takes nothing returns nothing
    call Register_Clemydar_ShowMarker()
endfunction

endlibrary
