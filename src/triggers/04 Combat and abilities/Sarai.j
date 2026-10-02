library TSarai
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Sarai_ShowTalkIcon=null
endglobals

function Trig_Sarai_ShowTalkIcon_Actions takes nothing returns nothing
    set udg_SpecialEffect[77]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_e013_0176,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    set udg_TentacleCount=-1
    call EnableTrigger(gg_trg_Tentacles_Start)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_Sarai automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Sarai (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Sarai takes nothing returns nothing
endfunction

function Register_Sarai_ShowTalkIcon takes nothing returns nothing
    set gg_trg_Sarai_ShowTalkIcon=CreateTrigger()
    call DisableTrigger(gg_trg_Sarai_ShowTalkIcon)
    call TriggerAddAction(gg_trg_Sarai_ShowTalkIcon,function Trig_Sarai_ShowTalkIcon_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Sarai takes nothing returns nothing
    call Register_Sarai_ShowTalkIcon()
endfunction

endlibrary
