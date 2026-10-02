library TNightElf
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_NightElf_TalkPrepare=null
endglobals

function Trig_NightElf_TalkPrepare_Conditions takes nothing returns boolean
    return(GetOwningPlayer(udg_ShadowUnit)==Player($A)) // $A = 10
endfunction

function Trig_NightElf_TalkPrepare_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    set udg_SpecialEffect[66]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_e00V_0009,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call EnableTrigger(gg_trg_Quest_LostMemories_Start)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_NightElf automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_NightElf (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_NightElf takes nothing returns nothing
endfunction

function Register_NightElf_TalkPrepare takes nothing returns nothing
    set gg_trg_NightElf_TalkPrepare=CreateTrigger()
    call DisableTrigger(gg_trg_NightElf_TalkPrepare)
    call TriggerRegisterTimerEventPeriodic(gg_trg_NightElf_TalkPrepare,5.)
    call TriggerAddCondition(gg_trg_NightElf_TalkPrepare,Condition(function Trig_NightElf_TalkPrepare_Conditions))
    call TriggerAddAction(gg_trg_NightElf_TalkPrepare,function Trig_NightElf_TalkPrepare_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_NightElf takes nothing returns nothing
    call Register_NightElf_TalkPrepare()
endfunction

endlibrary
