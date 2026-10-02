library TSiegfried
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Siegfried_Hide_Init=null
    trigger gg_trg_Siegfried_Appear=null
endglobals

function Trig_Siegfried_Hide_Init_Actions takes nothing returns nothing
    call ShowUnitHide(gg_unit_N0N0_0267)
    call PauseUnitBJ(true,gg_unit_N0N0_0267)
    call SetUnitInvulnerable(gg_unit_N0N0_0267,true)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Siegfried_Appear_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call ShowUnitShow(gg_unit_N0N0_0267)
    set udg_SpecialEffect[90]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_N0N0_0267,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call EnableTrigger(gg_trg_Quest_DivineOrder_Start)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_Siegfried automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Siegfried (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Siegfried takes nothing returns nothing
endfunction

function Register_Siegfried_Hide_Init takes nothing returns nothing
    set gg_trg_Siegfried_Hide_Init=CreateTrigger()
    call TriggerAddAction(gg_trg_Siegfried_Hide_Init,function Trig_Siegfried_Hide_Init_Actions)
endfunction

function Register_Siegfried_Appear takes nothing returns nothing
    set gg_trg_Siegfried_Appear=CreateTrigger()
    call DisableTrigger(gg_trg_Siegfried_Appear)
    call TriggerRegisterTimerExpireEventBJ(gg_trg_Siegfried_Appear,udg_SharedDelayTimer5)
    call TriggerAddAction(gg_trg_Siegfried_Appear,function Trig_Siegfried_Appear_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Siegfried takes nothing returns nothing
    call Register_Siegfried_Hide_Init()
    call Register_Siegfried_Appear()
endfunction

endlibrary
