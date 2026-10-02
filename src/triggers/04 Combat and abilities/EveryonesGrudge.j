library TEveryonesGrudge
function Trig_EveryonesGrudge_Cast_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A0CW') // 'A0CW': ability "!Everyone's Grudge"
endfunction

function Trig_EveryonesGrudge_Cast_Actions takes nothing returns nothing
    set udg_DmgFlagPure=true
    set udg_DmgFlagUnavoidable=-1
    // Result 1: udg_PlayerKillCount at position GetConvertedPlayerId(GetOwningPlayer(the spell target)) treated as
    // a decimal-capable number.
    // Result 2: (10) times (result 1).
    call UnitDamageTargetBJ(GetTriggerUnit(),GetSpellTargetUnit(),(10.*I2R(udg_PlayerKillCount[GetConvertedPlayerId(GetOwningPlayer(GetSpellTargetUnit()))])),ATTACK_TYPE_CHAOS,DAMAGE_TYPE_UNIVERSAL)
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_EveryonesGrudge takes nothing returns nothing
endfunction

function RegisterR11_EveryonesGrudge_Cast takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_EveryonesGrudge_Cast=CreateTrigger()

call TriggerRegisterAnyUnitEventBJ(gg_trg_EveryonesGrudge_Cast,EVENT_PLAYER_UNIT_SPELL_EFFECT)

call TriggerAddCondition(gg_trg_EveryonesGrudge_Cast,Condition(function Trig_EveryonesGrudge_Cast_Conditions))

call TriggerAddAction(gg_trg_EveryonesGrudge_Cast,function Trig_EveryonesGrudge_Cast_Actions)

endfunction




endlibrary
