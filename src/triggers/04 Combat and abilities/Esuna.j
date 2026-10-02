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

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Esuna takes nothing returns nothing
endfunction
function RegisterR11_Esuna_Cast takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Esuna_Cast=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Esuna_Cast,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Esuna_Cast,Condition(function Trig_Esuna_Cast_Conditions))
    call TriggerAddAction(gg_trg_Esuna_Cast,function Trig_Esuna_Cast_Actions)
endfunction




endlibrary
