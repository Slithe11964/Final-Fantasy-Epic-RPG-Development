library TLiniel
function Trig_Liniel_ShowMarker_Actions takes nothing returns nothing
    set udg_SpecialEffect[46]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_n01Y_0131,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call EnableTrigger(gg_trg_Quest_FallenRanger_Start)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_Liniel automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Liniel (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Liniel takes nothing returns nothing
endfunction

function Register_Liniel_ShowMarker takes nothing returns nothing
    set gg_trg_Liniel_ShowMarker=CreateTrigger()
    call DisableTrigger(gg_trg_Liniel_ShowMarker)
    call TriggerAddAction(gg_trg_Liniel_ShowMarker,function Trig_Liniel_ShowMarker_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Liniel takes nothing returns nothing
    call Register_Liniel_ShowMarker()
endfunction

endlibrary
