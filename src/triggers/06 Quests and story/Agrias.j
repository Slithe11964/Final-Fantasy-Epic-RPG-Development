library TAgrias
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Agrias_ShowMarker=null
endglobals

function Trig_Agrias_ShowMarker_Actions takes nothing returns nothing
    call ShowUnitShow(gg_unit_Ewrd_0120)
    set udg_SpecialEffect[50]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_Ewrd_0120,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call EnableTrigger(gg_trg_Quest_HolyKnight_Start)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_Agrias automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Agrias (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Agrias takes nothing returns nothing
endfunction

function Register_Agrias_ShowMarker takes nothing returns nothing
    set gg_trg_Agrias_ShowMarker=CreateTrigger()
    call DisableTrigger(gg_trg_Agrias_ShowMarker)
    call TriggerAddAction(gg_trg_Agrias_ShowMarker,function Trig_Agrias_ShowMarker_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Agrias takes nothing returns nothing
    call Register_Agrias_ShowMarker()
endfunction

endlibrary
