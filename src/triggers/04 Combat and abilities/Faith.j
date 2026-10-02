library TFaith
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Faith_Target_Cleanup=null
endglobals

function Trig_Faith_Target_Cleanup_IsFaithSpell takes nothing returns boolean
    return(GetSpellAbilityId()=='A0RW')or(GetSpellAbilityId()=='A0QZ')or(GetSpellAbilityId()=='A0TH')or(GetSpellAbilityId()=='A0UC')or(GetSpellAbilityId()=='A10H')or(GetSpellAbilityId()=='A0N0')or(GetSpellAbilityId()=='A17F')or(GetSpellAbilityId()=='A17G')or(GetSpellAbilityId()=='A1AP')or(GetSpellAbilityId()=='A0ZA')or(GetSpellAbilityId()=='A0P4')or(GetSpellAbilityId()=='A155')or(GetSpellAbilityId()=='A10R')or(GetSpellAbilityId()=='A1DR')or(GetSpellAbilityId()=='A1FM')or(GetSpellAbilityId()=='A0ZB') // 'A0RW': ability "Faith"; 'A0QZ': ability "Faithra"; 'A0TH': ability "Faith"; 'A0UC': ability "Faith"; 'A10H': ability "Faith"; 'A0N0': ability "Faith"; 'A17F': ability "Faith"; 'A17G': ability "Faith"; 'A1AP': ability "Faith"; 'A0ZA': ability "Faith"; 'A0P4': ability "Fog"; 'A155': ability "Fogra"; 'A10R': ability "Fog"; 'A1DR': ability "Fog"; 'A1FM': ability "Fog"; 'A0ZB': ability "Fog"
endfunction

function Trig_Faith_Target_Cleanup_Conditions takes nothing returns boolean
    return(Trig_Faith_Target_Cleanup_IsFaithSpell())
endfunction

function Trig_Faith_Target_Cleanup_TargetHasAutoFaith takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0WG',GetSpellTargetUnit())>0) // 'A0WG': ability "Auto-Faith"
endfunction

function Trig_Faith_Target_Cleanup_Actions takes nothing returns nothing
    call UnitRemoveBuffBJ('B05A',GetSpellTargetUnit()) // 'B05A': buff "Faith"
    call UnitRemoveBuffBJ('B08Q',GetSpellTargetUnit()) // 'B08Q': buff "Faithra"
    call UnitRemoveBuffBJ('B07J',GetSpellTargetUnit()) // 'B07J': buff "Faith"
    call UnitRemoveBuffBJ('B06I',GetSpellTargetUnit()) // 'B06I': buff "Fog"
    call UnitRemoveBuffBJ('B08X',GetSpellTargetUnit()) // 'B08X': buff "Fogra"
    if(Trig_Faith_Target_Cleanup_TargetHasAutoFaith())then
        call GroupAddUnitSimple(GetSpellTargetUnit(),udg_ActiveHeroGroup)
        call StartTimerBJ(udg_HeroRefreshTimer,false,.01)
    endif
endfunction

// World Editor calls InitTrig_Faith automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Faith (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Faith takes nothing returns nothing
endfunction

function Register_Faith_Target_Cleanup takes nothing returns nothing
    set gg_trg_Faith_Target_Cleanup=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Faith_Target_Cleanup,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Faith_Target_Cleanup,Condition(function Trig_Faith_Target_Cleanup_Conditions))
    call TriggerAddAction(gg_trg_Faith_Target_Cleanup,function Trig_Faith_Target_Cleanup_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Faith takes nothing returns nothing
    call Register_Faith_Target_Cleanup()
endfunction

endlibrary
