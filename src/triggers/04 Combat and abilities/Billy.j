library TBilly
function Trig_Billy_ShowTalkIcon_NeedsSelectAbility takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('Aneu',gg_unit_n0KE_0072)<=0) // 'Aneu': standard ability reference "Neutral Building"
endfunction

function Trig_Billy_ShowTalkIcon_Actions takes nothing returns nothing
    if(Trig_Billy_ShowTalkIcon_NeedsSelectAbility())then
        call UnitAddAbilityBJ('Aneu',gg_unit_n0KE_0072) // 'Aneu': standard ability reference "Neutral Building"
        set udg_SpecialEffect[86]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_n0KE_0072,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
        call EnableTrigger(gg_trg_ChocoboRider_Start)
    endif
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_Billy automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Billy (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Billy takes nothing returns nothing
endfunction

function Register_Billy_ShowTalkIcon takes nothing returns nothing
    set gg_trg_Billy_ShowTalkIcon=CreateTrigger()
    call DisableTrigger(gg_trg_Billy_ShowTalkIcon)
    call TriggerAddAction(gg_trg_Billy_ShowTalkIcon,function Trig_Billy_ShowTalkIcon_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Billy takes nothing returns nothing
    call Register_Billy_ShowTalkIcon()
endfunction

endlibrary
