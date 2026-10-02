library TKrjn
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Krjn_ShowTalkIcon=null
endglobals

function Trig_Krjn_ShowTalkIcon_Actions takes nothing returns nothing
    set udg_SpecialEffect[75]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_e012_0227,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call EnableTrigger(gg_trg_AncientHunt_Start)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_Krjn automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Krjn (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Krjn takes nothing returns nothing
endfunction

function Register_Krjn_ShowTalkIcon takes nothing returns nothing
    set gg_trg_Krjn_ShowTalkIcon=CreateTrigger()
    call DisableTrigger(gg_trg_Krjn_ShowTalkIcon)
    call TriggerAddAction(gg_trg_Krjn_ShowTalkIcon,function Trig_Krjn_ShowTalkIcon_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Krjn takes nothing returns nothing
    call Register_Krjn_ShowTalkIcon() // starts off; run by Epilogue, Quest_NightElves, Talk
endfunction

endlibrary
