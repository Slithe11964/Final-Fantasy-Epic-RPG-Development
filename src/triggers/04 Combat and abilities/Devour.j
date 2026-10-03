library TDevour requires TBerserk, TGoliathTonic
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Devour_Absorb=null
endglobals

function Trig_Devour_Absorb_Conditions takes nothing returns boolean
    return((GetSpellAbilityId()=='A0YR')and(IsUnitType(GetSpellTargetUnit(),UNIT_TYPE_HERO)==false)and(IsUnitType(GetSpellTargetUnit(),UNIT_TYPE_RESISTANT)==false))!=null // 'A0YR': ability "!Devour"
endfunction

function Trig_Devour_Absorb_IsHostileOwned takes nothing returns boolean
    return(GetOwningPlayer(GetTriggerUnit())==Player($B)) // $B = 11
endfunction

function Trig_Devour_Absorb_IsCasterNotResistant takes nothing returns boolean
    return(IsUnitType(GetTriggerUnit(),UNIT_TYPE_RESISTANT)==false)!=null
endfunction

function Trig_Devour_Absorb_Actions takes nothing returns nothing
    call AddSpecialEffectTargetUnitBJ("origin",GetTriggerUnit(),"Abilities\\Spells\\Undead\\RaiseSkeletonWarrior\\RaiseSkeleton.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call AddSpecialEffectTargetUnitBJ("head",GetTriggerUnit(),"Abilities\\Spells\\Orc\\Devour\\DevourEffectArt.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call BlzSetUnitBaseDamage(GetTriggerUnit(),(BlzGetUnitBaseDamage(GetTriggerUnit(),0)+BlzGetUnitBaseDamage(GetSpellTargetUnit(),0)),(1-1))
    call BlzSetUnitBaseDamage(GetTriggerUnit(),(BlzGetUnitBaseDamage(GetTriggerUnit(),1)+BlzGetUnitBaseDamage(GetSpellTargetUnit(),1)),1)
    call GoliathTonic_Remove(GetSpellTargetUnit())
    call Berserk_Remove(GetSpellTargetUnit())
    call BlzSetUnitMaxHP(GetTriggerUnit(),(BlzGetUnitMaxHP(GetTriggerUnit())+BlzGetUnitMaxHP(GetSpellTargetUnit())))
    call BlzSetUnitMaxMana(GetTriggerUnit(),(BlzGetUnitMaxMana(GetTriggerUnit())+BlzGetUnitMaxMana(GetSpellTargetUnit())))
    call BlzSetUnitArmor(GetTriggerUnit(),(BlzGetUnitArmor(GetTriggerUnit())+BlzGetUnitArmor(GetSpellTargetUnit())))
    if(Trig_Devour_Absorb_IsCasterNotResistant())then
        call UnitAddAbilityBJ('ACrk',GetTriggerUnit()) // 'ACrk': object name not found in map data
    else
        if(Trig_Devour_Absorb_IsHostileOwned())then
            call UnitRemoveAbilityBJ('A0YR',GetTriggerUnit()) // 'A0YR': ability "!Devour"
        else
            call BlzUnitDisableAbility(GetTriggerUnit(),GetSpellAbilityId(),true,false)
        endif
    endif
    set udg_IsPureDamage=true
    set udg_DmgFlagHealUndead=true
    call UnitDamageTargetBJ(GetTriggerUnit(),GetTriggerUnit(),GetUnitStateSwap(UNIT_STATE_LIFE,GetSpellTargetUnit()),ATTACK_TYPE_CHAOS,DAMAGE_TYPE_UNIVERSAL)
    call UnitAddAbilityBJ('A0QY',GetSpellTargetUnit()) // 'A0QY': ability "Devalued"
    call KillUnit(GetSpellTargetUnit())
    call ShowUnitHide(GetSpellTargetUnit())
endfunction

// World Editor calls InitTrig_Devour automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Devour (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Devour takes nothing returns nothing
endfunction

function Register_Devour_Absorb takes nothing returns nothing
    set gg_trg_Devour_Absorb=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Devour_Absorb,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Devour_Absorb,Condition(function Trig_Devour_Absorb_Conditions))
    call TriggerAddAction(gg_trg_Devour_Absorb,function Trig_Devour_Absorb_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Devour takes nothing returns nothing
    call Register_Devour_Absorb()
endfunction

endlibrary
