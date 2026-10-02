library TWard
function Trig_Ward_ShowTalkIcon_Actions takes nothing returns nothing
    set udg_SpecialEffect[76]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_h030_0243,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call EnableTrigger(gg_trg_WendigoHunt_Start)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_Ward automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Ward (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Ward takes nothing returns nothing
endfunction

function Register_Ward_ShowTalkIcon takes nothing returns nothing
    set gg_trg_Ward_ShowTalkIcon=CreateTrigger()
    call DisableTrigger(gg_trg_Ward_ShowTalkIcon)
    call TriggerAddAction(gg_trg_Ward_ShowTalkIcon,function Trig_Ward_ShowTalkIcon_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Ward takes nothing returns nothing
    call Register_Ward_ShowTalkIcon()
endfunction

endlibrary
