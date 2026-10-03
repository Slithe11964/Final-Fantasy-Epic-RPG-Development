library TManablow requires TProf, TSpellShared
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Manablow_Cast=null
endglobals

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
    local integer l_tempInteger
    call Spell_StoreManaCost()
    // ((udg_SpellManaCost) times (2)) plus (200).
    set l_tempInteger=((udg_SpellManaCost*2)+$C8) // $C8 = 200
    if(Trig_Manablow_Cast_IsCasterHero())then
        // (l_tempInteger) plus ((Intelligence of the triggering unit) times (2)).
        set l_tempInteger=(l_tempInteger+(GetHeroStatBJ(bj_HEROSTAT_INT,GetTriggerUnit(),true)*2))
    endif
    // Result 1: l_tempInteger treated as a decimal-capable number.
    // Result 2: (result 1) times (Prof_StaffPower(the triggering unit)).
    // Result 3: (result 2) with its decimal part removed.
    set l_tempInteger=R2I((I2R(l_tempInteger)*Prof_StaffPower(GetTriggerUnit())))
    set udg_DmgFlagManaDamage=true
    // Udg_TempInteger treated as a decimal-capable number.
    call UnitDamageTargetBJ(GetTriggerUnit(),GetSpellTargetUnit(),I2R(l_tempInteger),ATTACK_TYPE_CHAOS,DAMAGE_TYPE_UNIVERSAL)
    call AddSpecialEffectTargetUnitBJ("origin",GetSpellTargetUnit(),"Abilities\\Spells\\Human\\ManaFlare\\ManaFlareBoltImpact.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
endfunction

// World Editor calls InitTrig_Manablow automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Manablow (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Manablow takes nothing returns nothing
endfunction

function Register_Manablow_Cast takes nothing returns nothing
    set gg_trg_Manablow_Cast=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Manablow_Cast,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Manablow_Cast,Condition(function Trig_Manablow_Cast_Conditions))
    call TriggerAddAction(gg_trg_Manablow_Cast,function Trig_Manablow_Cast_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Manablow takes nothing returns nothing
    call Register_Manablow_Cast()
endfunction

endlibrary
