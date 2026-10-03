library TMinusStrike requires TAbil, TProf
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_MinusStrike_Cast=null
endglobals

function Trig_MinusStrike_Cast_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A0Z5') // 'A0Z5': ability "Minus Strike"
endfunction

function Trig_MinusStrike_Cast_IsCasterBelow4Pct takes nothing returns boolean
    // Result 1: current health divided by maximum health for the triggering unit, times 100 (or 0 if the unit is
    // missing or its maximum is 0).
    return(GetUnitLifePercent(GetTriggerUnit())<=4.)
endfunction

function Trig_MinusStrike_Cast_IsCasterBelow16Pct takes nothing returns boolean
    // Result 1: current health divided by maximum health for the triggering unit, times 100 (or 0 if the unit is
    // missing or its maximum is 0).
    return(GetUnitLifePercent(GetTriggerUnit())<=16.)
endfunction

function Trig_MinusStrike_Cast_IsCasterBelow36Pct takes nothing returns boolean
    // Result 1: current health divided by maximum health for the triggering unit, times 100 (or 0 if the unit is
    // missing or its maximum is 0).
    return(GetUnitLifePercent(GetTriggerUnit())<=36.)
endfunction

function Trig_MinusStrike_Cast_IsCasterBelow64Pct takes nothing returns boolean
    // Result 1: current health divided by maximum health for the triggering unit, times 100 (or 0 if the unit is
    // missing or its maximum is 0).
    return(GetUnitLifePercent(GetTriggerUnit())<=64.)
endfunction

function Trig_MinusStrike_Cast_IsCasterHero takes nothing returns boolean
    return(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_MinusStrike_Cast_Actions takes nothing returns nothing
    local integer l_tempInteger
    local real l_tempReal
    call AddSpecialEffectTargetUnitBJ("origin",GetSpellTargetUnit(),"Abilities\\Spells\\NightElf\\ManaBurn\\ManaBurnTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call AddSpecialEffectTargetUnitBJ("origin",GetSpellTargetUnit(),"Abilities\\Spells\\Undead\\DarkRitual\\DarkRitualCaster.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    if(Trig_MinusStrike_Cast_IsCasterBelow64Pct())then
        call AddSpecialEffectTargetUnitBJ("origin",GetSpellTargetUnit(),"Abilities\\Spells\\Undead\\OrbOfDeath\\AnnihilationMissile.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        if(Trig_MinusStrike_Cast_IsCasterBelow36Pct())then
            call AddSpecialEffectTargetUnitBJ("origin",GetSpellTargetUnit(),"Abilities\\Spells\\Other\\HowlOfTerror\\HowlCaster.mdl")
            call DestroyEffectBJ(GetLastCreatedEffectBJ())
            if(Trig_MinusStrike_Cast_IsCasterBelow16Pct())then
                call AddSpecialEffectTargetUnitBJ("origin",GetSpellTargetUnit(),"Abilities\\Spells\\Undead\\DeathPact\\DeathPactCaster.mdl")
                call DestroyEffectBJ(GetLastCreatedEffectBJ())
                if(Trig_MinusStrike_Cast_IsCasterBelow4Pct())then
                    call AddSpecialEffectTargetUnitBJ("origin",GetSpellTargetUnit(),"Abilities\\Spells\\Undead\\Possession\\PossessionMissile.mdl")
                    call DestroyEffectBJ(GetLastCreatedEffectBJ())
                    call AddSpecialEffectTargetUnitBJ("origin",GetSpellTargetUnit(),"Abilities\\Spells\\Demon\\DarkPortal\\DarkPortalTarget.mdl")
                    call DestroyEffectBJ(GetLastCreatedEffectBJ())
                endif
            endif
        endif
    endif
    // (BlzGetAbilityManaCost(GetSpellAbilityId(), Abil_GetLevel(the triggering unit, GetSpellAbilityId()))) times
    // (30).
    set l_tempInteger=(BlzGetAbilityManaCost(GetSpellAbilityId(),Abil_GetLevel(GetTriggerUnit(),GetSpellAbilityId()))*30)
    if(Trig_MinusStrike_Cast_IsCasterHero())then
        // (l_tempInteger) plus ((Strength of the triggering unit) times (25)).
        set l_tempInteger=(l_tempInteger+(GetHeroStatBJ(bj_HEROSTAT_STR,GetTriggerUnit(),true)*25))
    endif
    // (0.1) times ((10) plus (Prof_GetHybridLevel(the triggering unit))).
    set l_tempReal=.1*($A+Prof_GetHybridLevel(GetTriggerUnit())) // $A = 10
    set udg_IsPhysicalAttack=true
    // Result 1: l_tempInteger treated as a decimal-capable number.
    // Result 2: current health divided by maximum health for the triggering unit, times 100 (or 0 if the unit is
    // missing or its maximum is 0).
    // Result 3: (result 2) times (0.25).
    // Result 4: the square root of (result 3).
    // Result 5: the larger of (1) and (result 4).
    // Result 6: (l_tempReal) divided by (result 5).
    // Result 7: (result 1) times (result 6).
    // Result 8: (result 7) plus (500).
    call UnitDamageTargetBJ(GetTriggerUnit(),GetSpellTargetUnit(),((I2R(l_tempInteger)*(l_tempReal/ RMaxBJ(1.,SquareRoot((GetUnitLifePercent(GetTriggerUnit())*.25)))))+500.),ATTACK_TYPE_CHAOS,DAMAGE_TYPE_NORMAL)
endfunction

// World Editor calls InitTrig_MinusStrike automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_MinusStrike (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_MinusStrike takes nothing returns nothing
endfunction

function Register_MinusStrike_Cast takes nothing returns nothing
    set gg_trg_MinusStrike_Cast=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_MinusStrike_Cast,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_MinusStrike_Cast,Condition(function Trig_MinusStrike_Cast_Conditions))
    call TriggerAddAction(gg_trg_MinusStrike_Cast,function Trig_MinusStrike_Cast_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_MinusStrike takes nothing returns nothing
    call Register_MinusStrike_Cast()
endfunction

endlibrary
