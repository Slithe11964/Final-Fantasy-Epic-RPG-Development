library TOsmose requires TForce, TProf, TText
function Trig_Osmose_Cancel_NoMP_IsOsmoseAbility takes nothing returns boolean
    return(GetSpellAbilityId()=='A0Z3')or(GetSpellAbilityId()=='A0DG') // 'A0Z3': ability "Osmose"; 'A0DG': ability "Osmose"
endfunction

function Trig_Osmose_Cancel_NoMP_Conditions takes nothing returns boolean
    return(Trig_Osmose_Cancel_NoMP_IsOsmoseAbility())and(GetUnitStateSwap(UNIT_STATE_MANA,GetSpellTargetUnit())<=.0)
endfunction

function Trig_Osmose_Cancel_NoMP_Actions takes nothing returns nothing
    call PauseUnitBJ(true,GetTriggerUnit())
    call IssueImmediateOrderBJ(GetTriggerUnit(),"stop")
    call PauseUnitBJ(false,GetTriggerUnit())
    set udg_TempForce=Force_OfPlayer(GetOwningPlayer(GetTriggerUnit()))
    call DisplayTimedTextToForce(udg_TempForce,10.,"|cffff0000The target unit has no MP!|r")
    call DestroyForce(udg_TempForce)
endfunction

function Trig_Osmose_Cast_IsOsmoseAbility takes nothing returns boolean
    return(GetSpellAbilityId()=='A0Z3')or(GetSpellAbilityId()=='A0DG')or(GetSpellAbilityId()=='A03L') // 'A0Z3': ability "Osmose"; 'A0DG': ability "Osmose"; 'A03L': ability "Osmose"
endfunction

function Trig_Osmose_Cast_Conditions takes nothing returns boolean
    return(Trig_Osmose_Cast_IsOsmoseAbility())
endfunction

function Trig_Osmose_Cast_TargetHasNoMana takes nothing returns boolean
    return(udg_TempReal<=.0)
endfunction

function Trig_Osmose_Cast_IsCasterHero takes nothing returns boolean
    return(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Osmose_Cast_DrainExceedsTargetMana takes nothing returns boolean
    return(udg_TempReal<udg_LastDamageDealt)
endfunction

function Trig_Osmose_Cast_NothingToDrain takes nothing returns boolean
    return(udg_LastDamageDealt<=.0)
endfunction

function Trig_Osmose_Cast_Actions takes nothing returns nothing
    set udg_TempReal=GetUnitStateSwap(UNIT_STATE_MANA,GetSpellTargetUnit())
    if(Trig_Osmose_Cast_TargetHasNoMana())then
        set udg_TempForce=Force_OfPlayer(GetOwningPlayer(GetTriggerUnit()))
        call DisplayTimedTextToForce(udg_TempForce,10.,"|cffff0000The target unit has no MP!|r")
        call DestroyForce(udg_TempForce)
        return
    endif
    // ((GetUnitAbilityLevelSwapped(GetSpellAbilityId(), the triggering unit)) plus (4)) times (40).
    set udg_TempInteger=((GetUnitAbilityLevelSwapped(GetSpellAbilityId(),GetTriggerUnit())+4)*40)
    if(Trig_Osmose_Cast_IsCasterHero())then
        // (udg_TempInteger) plus ((Intelligence of the triggering unit) times (2)).
        set udg_TempInteger=(udg_TempInteger+(GetHeroStatBJ(bj_HEROSTAT_INT,GetTriggerUnit(),true)*2))
    endif
    // Result 1: udg_TempInteger treated as a decimal-capable number.
    // Result 2: (result 1) times (Prof_StaffPower(the triggering unit)).
    // Result 3: (result 2) with its decimal part removed.
    set udg_TempInteger=R2I((I2R(udg_TempInteger)*Prof_StaffPower(GetTriggerUnit())))
    set udg_DmgFlagManaDamage=true
    // Udg_TempInteger treated as a decimal-capable number.
    call UnitDamageTargetBJ(GetTriggerUnit(),GetSpellTargetUnit(),I2R(udg_TempInteger),ATTACK_TYPE_CHAOS,DAMAGE_TYPE_UNIVERSAL)
    if(Trig_Osmose_Cast_DrainExceedsTargetMana())then
        set udg_LastDamageDealt=udg_TempReal
    endif
    if(Trig_Osmose_Cast_NothingToDrain())then
        return
    endif
    call AddSpecialEffectTargetUnitBJ("origin",GetTriggerUnit(),"Abilities\\Spells\\Items\\AIma\\AImaTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    // (current mana of the triggering unit) plus (udg_LastDamageDealt).
    call SetUnitManaBJ(GetTriggerUnit(),(GetUnitStateSwap(UNIT_STATE_MANA,GetTriggerUnit())+udg_LastDamageDealt))
    call Text_FloatingDamage(GetTriggerUnit(),true,0,udg_LastDamageDealt,true,0)
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Osmose takes nothing returns nothing
endfunction
function RegisterR11_Osmose_Cancel_NoMP takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Osmose_Cancel_NoMP=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Osmose_Cancel_NoMP,EVENT_PLAYER_UNIT_SPELL_CAST)
    call TriggerAddCondition(gg_trg_Osmose_Cancel_NoMP,Condition(function Trig_Osmose_Cancel_NoMP_Conditions))
    call TriggerAddAction(gg_trg_Osmose_Cancel_NoMP,function Trig_Osmose_Cancel_NoMP_Actions)
endfunction
function RegisterR11_Osmose_Cast takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Osmose_Cast=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Osmose_Cast,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Osmose_Cast,Condition(function Trig_Osmose_Cast_Conditions))
    call TriggerAddAction(gg_trg_Osmose_Cast,function Trig_Osmose_Cast_Actions)
endfunction




endlibrary
