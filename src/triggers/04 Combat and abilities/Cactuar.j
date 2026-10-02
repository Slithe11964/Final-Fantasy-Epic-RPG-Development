library TCactuar
function Trig_Cactuar_Haste_Cast_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A0EV') // 'A0EV': ability "Haste"
endfunction

function Trig_Cactuar_Haste_Cast_Actions takes nothing returns nothing
    set udg_IsPureDamage=true
    set udg_DmgFlagManaDamage=true
    // (maximum mana of the spell target) divided by (2).
    call UnitDamageTargetBJ(GetTriggerUnit(),GetSpellTargetUnit(),(GetUnitStateSwap(UNIT_STATE_MAX_MANA,GetSpellTargetUnit())/ 2.),ATTACK_TYPE_NORMAL,DAMAGE_TYPE_UNIVERSAL)
    call AddSpecialEffectTargetUnitBJ("origin",GetSpellTargetUnit(),"Abilities\\Spells\\Items\\AIma\\AImaTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Cactuar takes nothing returns nothing
endfunction

function RegisterR11_Cactuar_Haste_Cast takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Cactuar_Haste_Cast=CreateTrigger()

call TriggerRegisterAnyUnitEventBJ(gg_trg_Cactuar_Haste_Cast,EVENT_PLAYER_UNIT_SPELL_EFFECT)

call TriggerAddCondition(gg_trg_Cactuar_Haste_Cast,Condition(function Trig_Cactuar_Haste_Cast_Conditions))

call TriggerAddAction(gg_trg_Cactuar_Haste_Cast,function Trig_Cactuar_Haste_Cast_Actions)

endfunction




endlibrary
