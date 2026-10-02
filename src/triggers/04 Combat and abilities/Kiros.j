library TKiros
function Trig_Kiros_Hide_Actions takes nothing returns nothing
    call ShowUnitHide(gg_unit_n0BV_0229)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Kiros_ShowTalkIcon_Actions takes nothing returns nothing
    set udg_SpecialEffect[73]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_n0BV_0229,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call EnableTrigger(gg_trg_GnollHunt_Start)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_Kiros automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Kiros (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Kiros takes nothing returns nothing
endfunction

function Register_Kiros_Hide takes nothing returns nothing
    set gg_trg_Kiros_Hide=CreateTrigger()
    call TriggerAddAction(gg_trg_Kiros_Hide,function Trig_Kiros_Hide_Actions)
endfunction

function Register_Kiros_ShowTalkIcon takes nothing returns nothing
    set gg_trg_Kiros_ShowTalkIcon=CreateTrigger()
    call DisableTrigger(gg_trg_Kiros_ShowTalkIcon)
    call TriggerAddAction(gg_trg_Kiros_ShowTalkIcon,function Trig_Kiros_ShowTalkIcon_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Kiros takes nothing returns nothing
    call Register_Kiros_Hide()
    call Register_Kiros_ShowTalkIcon()
endfunction

endlibrary
