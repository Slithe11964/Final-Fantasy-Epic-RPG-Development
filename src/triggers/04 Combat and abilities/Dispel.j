library TDispel
function Trig_Dispel_Cast_IsDispel takes nothing returns boolean
    return(GetSpellAbilityId()=='A0SJ')or(GetSpellAbilityId()=='A0SK')or(GetSpellAbilityId()=='A1DT')or(GetSpellAbilityId()=='A0V2')or(GetSpellAbilityId()=='A112') // 'A0SJ': ability "Dispel"; 'A0SK': ability "Dispel"; 'A1DT': ability "Cie'Mar Putrescence"; 'A0V2': ability "!Full Break"; 'A112': ability "!Surprise Mechanic"
endfunction

function Trig_Dispel_Cast_Conditions takes nothing returns boolean
    return(Trig_Dispel_Cast_IsDispel())
endfunction

function Trig_Dispel_Cast_Actions takes nothing returns nothing
    set udg_DispelTarget=GetSpellTargetUnit()
    call ConditionalTriggerExecute(gg_trg_Remove_Buffs)
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Dispel takes nothing returns nothing
endfunction

function RegisterR11_Dispel_Cast takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Dispel_Cast=CreateTrigger()

call TriggerRegisterAnyUnitEventBJ(gg_trg_Dispel_Cast,EVENT_PLAYER_UNIT_SPELL_EFFECT)

call TriggerAddCondition(gg_trg_Dispel_Cast,Condition(function Trig_Dispel_Cast_Conditions))

call TriggerAddAction(gg_trg_Dispel_Cast,function Trig_Dispel_Cast_Actions)

endfunction




endlibrary
