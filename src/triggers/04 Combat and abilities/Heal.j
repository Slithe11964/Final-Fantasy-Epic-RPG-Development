library THeal requires TAbil, TProf
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Heal_Spell_Apply=null
endglobals

function Trig_Heal_Spell_Apply_IsHealSpell takes nothing returns boolean
    return(GetSpellAbilityId()=='A05A')or(GetSpellAbilityId()=='A04O')or(GetSpellAbilityId()=='A03O')or(GetSpellAbilityId()=='A08U')or(GetSpellAbilityId()=='A09X')or(GetSpellAbilityId()=='A12K')or(GetSpellAbilityId()=='A032')or(GetSpellAbilityId()=='A004')or(GetSpellAbilityId()=='A008') // 'A05A': ability "Cura"; 'A04O': ability "Curaga"; 'A03O': ability "Curaga"; 'A08U': ability "Heavenly Light"; 'A09X': ability "Heavenly Light"; 'A12K': ability "Blessed Aether"; 'A032': ability "Blessed Earth"; 'A004': ability "Flames of Life"; 'A008': ability "Naga Light"
endfunction

function Trig_Heal_Spell_Apply_Conditions takes nothing returns boolean
    return(Trig_Heal_Spell_Apply_IsHealSpell())
endfunction

function Trig_Heal_Spell_Apply_CasterIsHero takes nothing returns boolean
    return(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Heal_Spell_Apply_Actions takes nothing returns nothing
    call AddSpecialEffectTargetUnitBJ("origin",GetSpellTargetUnit(),"Abilities\\Spells\\Human\\HolyBolt\\HolyBoltSpecialArt.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    // Start the healing calculation with 10 points per point of the spell's mana cost.
    set udg_TempInteger=(BlzGetAbilityManaCost(GetSpellAbilityId(),Abil_GetLevel(GetTriggerUnit(),GetSpellAbilityId()))*$A) // $A = 10
    if(Trig_Heal_Spell_Apply_CasterIsHero())then
        // A hero adds 5 more points per Intelligence. A non-hero skips this bonus.
        set udg_TempInteger=(udg_TempInteger+(GetHeroStatBJ(bj_HEROSTAT_INT,GetTriggerUnit(),true)*5))
    endif
    set udg_TempReal=Prof_StaffPower(GetTriggerUnit())
    set udg_IsPureDamage=true
    // Multiply that total by Staff power before handing it to the damage/healing system.
    call UnitDamageTargetBJ(GetTriggerUnit(),GetSpellTargetUnit(),(I2R(udg_TempInteger)*udg_TempReal),ATTACK_TYPE_NORMAL,DAMAGE_TYPE_UNIVERSAL)
endfunction

// World Editor calls InitTrig_Heal automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Heal (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Heal takes nothing returns nothing
endfunction

function Register_Heal_Spell_Apply takes nothing returns nothing
    set gg_trg_Heal_Spell_Apply=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Heal_Spell_Apply,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Heal_Spell_Apply,Condition(function Trig_Heal_Spell_Apply_Conditions))
    call TriggerAddAction(gg_trg_Heal_Spell_Apply,function Trig_Heal_Spell_Apply_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Heal takes nothing returns nothing
    call Register_Heal_Spell_Apply()
endfunction

endlibrary
