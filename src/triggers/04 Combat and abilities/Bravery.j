library TBravery
function Trig_Bravery_Caster_Cleanup_IsBraverySpell takes nothing returns boolean
    return(GetSpellAbilityId()=='A0ZH')or(GetSpellAbilityId()=='A158') // 'A0ZH': ability "Spirit of Lowtown"; 'A158': ability "Whirl"
endfunction

function Trig_Bravery_Caster_Cleanup_Conditions takes nothing returns boolean
    return(Trig_Bravery_Caster_Cleanup_IsBraverySpell())
endfunction

function Trig_Bravery_Caster_Cleanup_HasAutoBravery takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0WE',GetTriggerUnit())>0) // 'A0WE': ability "Auto-Bravery"
endfunction

function Trig_Bravery_Caster_Cleanup_Actions takes nothing returns nothing
    call UnitRemoveBuffBJ('B01W',GetTriggerUnit()) // 'B01W': buff "Bravery"
    call UnitRemoveBuffBJ('B07I',GetTriggerUnit()) // 'B07I': buff "Bravery"
    call UnitRemoveBuffBJ('B06H',GetTriggerUnit()) // 'B06H': buff "Pain"
    if(Trig_Bravery_Caster_Cleanup_HasAutoBravery())then
        call GroupAddUnitSimple(GetTriggerUnit(),udg_ActiveHeroGroup)
        call StartTimerBJ(udg_HeroRefreshTimer,false,.01)
    endif
endfunction

function Trig_Bravery_Target_Cleanup_IsBraverySpell takes nothing returns boolean
    return(GetSpellAbilityId()=='A083')or(GetSpellAbilityId()=='A0QL')or(GetSpellAbilityId()=='A0UH')or(GetSpellAbilityId()=='A0MZ')or(GetSpellAbilityId()=='ACif')or(GetSpellAbilityId()=='A17H')or(GetSpellAbilityId()=='A17I')or(GetSpellAbilityId()=='A1AO')or(GetSpellAbilityId()=='A0Z9')or(GetSpellAbilityId()=='A0P5')or(GetSpellAbilityId()=='A101')or(GetSpellAbilityId()=='A0ZW')or(GetSpellAbilityId()=='A1DQ')or(GetSpellAbilityId()=='A1FL')or(GetSpellAbilityId()=='A0ZC') // 'A083': ability "Bravery"; 'A0QL': ability "Bravera"; 'A0UH': ability "Bravery"; 'A0MZ': ability "Bravery"; 'ACif': ability "Bravery"; 'A17H': ability "Bravery"; 'A17I': ability "Bravery"; 'A1AO': ability "Bravery"; 'A0Z9': ability "Bravery"; 'A0P5': ability "Pain"; 'A101': ability "Painra"; 'A0ZW': ability "Pain"; 'A1DQ': ability "Pain"; 'A1FL': ability "Pain"; 'A0ZC': ability "Pain"
endfunction

function Trig_Bravery_Target_Cleanup_Conditions takes nothing returns boolean
    return(Trig_Bravery_Target_Cleanup_IsBraverySpell())
endfunction

function Trig_Bravery_Target_Cleanup_TargetHasAutoBravery takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0WE',GetSpellTargetUnit())>0) // 'A0WE': ability "Auto-Bravery"
endfunction

function Trig_Bravery_Target_Cleanup_Actions takes nothing returns nothing
    call UnitRemoveBuffBJ('B01W',GetSpellTargetUnit()) // 'B01W': buff "Bravery"
    call UnitRemoveBuffBJ('B08P',GetSpellTargetUnit()) // 'B08P': buff "Bravera"
    call UnitRemoveBuffBJ('B07I',GetSpellTargetUnit()) // 'B07I': buff "Bravery"
    call UnitRemoveBuffBJ('B06H',GetSpellTargetUnit()) // 'B06H': buff "Pain"
    call UnitRemoveBuffBJ('B08W',GetSpellTargetUnit()) // 'B08W': buff "Painra"
    if(Trig_Bravery_Target_Cleanup_TargetHasAutoBravery())then
        call GroupAddUnitSimple(GetSpellTargetUnit(),udg_ActiveHeroGroup)
        call StartTimerBJ(udg_HeroRefreshTimer,false,.01)
    endif
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Bravery takes nothing returns nothing
endfunction
function RegisterR11_Bravery_Caster_Cleanup takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Bravery_Caster_Cleanup=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Bravery_Caster_Cleanup,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Bravery_Caster_Cleanup,Condition(function Trig_Bravery_Caster_Cleanup_Conditions))
    call TriggerAddAction(gg_trg_Bravery_Caster_Cleanup,function Trig_Bravery_Caster_Cleanup_Actions)
endfunction
function RegisterR11_Bravery_Target_Cleanup takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Bravery_Target_Cleanup=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Bravery_Target_Cleanup,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Bravery_Target_Cleanup,Condition(function Trig_Bravery_Target_Cleanup_Conditions))
    call TriggerAddAction(gg_trg_Bravery_Target_Cleanup,function Trig_Bravery_Target_Cleanup_Actions)
endfunction




endlibrary
