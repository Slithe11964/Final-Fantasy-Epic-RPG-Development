library TEsuna
function Trig_Esuna_Cast_IsEsuna takes nothing returns boolean
    return(GetSpellAbilityId()=='A0W9')or(GetSpellAbilityId()=='A12K')or(GetSpellAbilityId()=='A032')or(GetSpellAbilityId()=='A140')or(GetSpellAbilityId()=='A0HV') // 'A0W9': ability "Esuna"; 'A12K': ability "Blessed Aether"; 'A032': ability "Blessed Earth"; 'A140': ability "Charge Command"; 'A0HV': ability "Toss Remedy"
endfunction

function Trig_Esuna_Cast_Conditions takes nothing returns boolean
    return(Trig_Esuna_Cast_IsEsuna())
endfunction

function Trig_Esuna_Cast_Actions takes nothing returns nothing
    set udg_DispelTarget=GetSpellTargetUnit()
    call ConditionalTriggerExecute(gg_trg_Remove_Debuffs)
endfunction

// World Editor calls InitTrig_Esuna automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Esuna (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Esuna takes nothing returns nothing
endfunction

function Register_Esuna_Cast takes nothing returns nothing
    set gg_trg_Esuna_Cast=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Esuna_Cast,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Esuna_Cast,Condition(function Trig_Esuna_Cast_Conditions))
    call TriggerAddAction(gg_trg_Esuna_Cast,function Trig_Esuna_Cast_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Esuna takes nothing returns nothing
    call Register_Esuna_Cast()
endfunction

endlibrary
