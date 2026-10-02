library TWatts
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Watts_Talk_Enable=null
endglobals

function Trig_Watts_Talk_Enable_Actions takes nothing returns nothing
    set udg_SpecialEffect[91]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_h00Q_0255,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call EnableTrigger(gg_trg_Quest_FieryWings_Start)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_Watts automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Watts (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Watts takes nothing returns nothing
endfunction

function Register_Watts_Talk_Enable takes nothing returns nothing
    set gg_trg_Watts_Talk_Enable=CreateTrigger()
    call DisableTrigger(gg_trg_Watts_Talk_Enable)
    call TriggerAddAction(gg_trg_Watts_Talk_Enable,function Trig_Watts_Talk_Enable_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Watts takes nothing returns nothing
    call Register_Watts_Talk_Enable()
endfunction

endlibrary
