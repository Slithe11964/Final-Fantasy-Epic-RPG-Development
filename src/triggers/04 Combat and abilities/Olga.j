library TOlga
function Trig_Olga_ShowTalkIcon_Actions takes nothing returns nothing
    set udg_SpecialEffect[74]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_e014_0149,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call EnableTrigger(gg_trg_FlanHunt_Start)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_Olga automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Olga (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Olga takes nothing returns nothing
endfunction

function Register_Olga_ShowTalkIcon takes nothing returns nothing
    set gg_trg_Olga_ShowTalkIcon=CreateTrigger()
    call DisableTrigger(gg_trg_Olga_ShowTalkIcon)
    call TriggerAddAction(gg_trg_Olga_ShowTalkIcon,function Trig_Olga_ShowTalkIcon_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Olga takes nothing returns nothing
    call Register_Olga_ShowTalkIcon()
endfunction

endlibrary
