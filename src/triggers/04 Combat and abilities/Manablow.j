library TManablow requires TProf, TSpellShared
function Trig_Manablow_Cast_IsManablowAbility takes nothing returns boolean
    return(GetSpellAbilityId()=='A1BD')or(GetSpellAbilityId()=='A1BE') // 'A1BD': ability "Manablow"; 'A1BE': ability "Manablow"
endfunction

function Trig_Manablow_Cast_Conditions takes nothing returns boolean
    return(Trig_Manablow_Cast_IsManablowAbility())
endfunction

function Trig_Manablow_Cast_IsCasterHero takes nothing returns boolean
    return(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Manablow_Cast_Actions takes nothing returns nothing
    call Spell_StoreManaCost()
    // ((udg_SpellManaCost) times (2)) plus (200).
    set udg_TempInteger=((udg_SpellManaCost*2)+$C8) // $C8 = 200
    if(Trig_Manablow_Cast_IsCasterHero())then
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
    call AddSpecialEffectTargetUnitBJ("origin",GetSpellTargetUnit(),"Abilities\\Spells\\Human\\ManaFlare\\ManaFlareBoltImpact.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Manablow takes nothing returns nothing
endfunction
function RegisterR11_Manablow_Cast takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Manablow_Cast=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Manablow_Cast,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Manablow_Cast,Condition(function Trig_Manablow_Cast_Conditions))
    call TriggerAddAction(gg_trg_Manablow_Cast,function Trig_Manablow_Cast_Actions)
endfunction




endlibrary
