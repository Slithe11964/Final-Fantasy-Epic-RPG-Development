library TAccumulate
function Trig_Accumulate_Cast_IsAccumulate takes nothing returns boolean
    return(GetSpellAbilityId()=='A003')or(GetSpellAbilityId()=='A03Z') // 'A003': ability "Accumulate"; 'A03Z': ability "Accumulate"
endfunction

function Trig_Accumulate_Cast_Conditions takes nothing returns boolean
    return(Trig_Accumulate_Cast_IsAccumulate())
endfunction

function Trig_Accumulate_Cast_Actions takes nothing returns nothing
    call UnitRemoveBuffBJ('B03D',GetTriggerUnit()) // 'B03D': buff tooltip "Spawn Protection"
    set udg_DmgFlagPure=true
    set udg_IsPureDamage=true
    // (maximum health of the triggering unit) times (0.3).
    call UnitDamageTargetBJ(GetTriggerUnit(),GetTriggerUnit(),(GetUnitStateSwap(UNIT_STATE_MAX_LIFE,GetTriggerUnit())*.3),ATTACK_TYPE_CHAOS,DAMAGE_TYPE_UNIVERSAL)
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Accumulate takes nothing returns nothing
endfunction

function RegisterR11_Accumulate_Cast takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Accumulate_Cast=CreateTrigger()

call TriggerRegisterAnyUnitEventBJ(gg_trg_Accumulate_Cast,EVENT_PLAYER_UNIT_SPELL_EFFECT)

call TriggerAddCondition(gg_trg_Accumulate_Cast,Condition(function Trig_Accumulate_Cast_Conditions))

call TriggerAddAction(gg_trg_Accumulate_Cast,function Trig_Accumulate_Cast_Actions)

endfunction




endlibrary
