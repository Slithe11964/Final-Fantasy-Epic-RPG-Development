library TKiemarl
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Kiemarl_ShowTalkIcon=null
endglobals

function Trig_Kiemarl_ShowTalkIcon_Actions takes nothing returns nothing
    set udg_SpecialEffect[79]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_e016_0019,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call EnableTrigger(gg_trg_DragonEgg_Start)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_Kiemarl automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Kiemarl (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Kiemarl takes nothing returns nothing
endfunction

function Register_Kiemarl_ShowTalkIcon takes nothing returns nothing
    set gg_trg_Kiemarl_ShowTalkIcon=CreateTrigger()
    call DisableTrigger(gg_trg_Kiemarl_ShowTalkIcon)
    call TriggerAddAction(gg_trg_Kiemarl_ShowTalkIcon,function Trig_Kiemarl_ShowTalkIcon_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Kiemarl takes nothing returns nothing
    call Register_Kiemarl_ShowTalkIcon()
endfunction

endlibrary
