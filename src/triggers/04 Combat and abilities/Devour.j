library TDevour requires TBerserk, TGoliathTonic
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
    // Calculation 1:
    // (BlzGetUnitBaseDamage(the triggering unit, 0)) plus (BlzGetUnitBaseDamage(the spell target, 0)).
    // Calculation 2:
    // (1) minus (1).
    call BlzSetUnitBaseDamage(GetTriggerUnit(),(BlzGetUnitBaseDamage(GetTriggerUnit(),0)+BlzGetUnitBaseDamage(GetSpellTargetUnit(),0)),(1-1))
    // (BlzGetUnitBaseDamage(the triggering unit, 1)) plus (BlzGetUnitBaseDamage(the spell target, 1)).
    call BlzSetUnitBaseDamage(GetTriggerUnit(),(BlzGetUnitBaseDamage(GetTriggerUnit(),1)+BlzGetUnitBaseDamage(GetSpellTargetUnit(),1)),1)
    call GoliathTonic_Remove(GetSpellTargetUnit())
    call Berserk_Remove(GetSpellTargetUnit())
    // (maximum health of the triggering unit) plus (maximum health of the spell target).
    call BlzSetUnitMaxHP(GetTriggerUnit(),(BlzGetUnitMaxHP(GetTriggerUnit())+BlzGetUnitMaxHP(GetSpellTargetUnit())))
    // (BlzGetUnitMaxMana(the triggering unit)) plus (BlzGetUnitMaxMana(the spell target)).
    call BlzSetUnitMaxMana(GetTriggerUnit(),(BlzGetUnitMaxMana(GetTriggerUnit())+BlzGetUnitMaxMana(GetSpellTargetUnit())))
    // (BlzGetUnitArmor(the triggering unit)) plus (BlzGetUnitArmor(the spell target)).
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

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Devour takes nothing returns nothing
endfunction

function RegisterR11_Devour_Absorb takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Devour_Absorb=CreateTrigger()

call TriggerRegisterAnyUnitEventBJ(gg_trg_Devour_Absorb,EVENT_PLAYER_UNIT_SPELL_EFFECT)

call TriggerAddCondition(gg_trg_Devour_Absorb,Condition(function Trig_Devour_Absorb_Conditions))

call TriggerAddAction(gg_trg_Devour_Absorb,function Trig_Devour_Absorb_Actions)

endfunction




endlibrary
