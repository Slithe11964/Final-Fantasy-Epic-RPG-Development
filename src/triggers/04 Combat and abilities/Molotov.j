library TMolotov
function Trig_Molotov_DamageOnAttack_Conditions takes nothing returns boolean
    return(UnitHasBuffBJ(GetAttacker(),'B002')) // 'B002': buff tooltip "Burn"
endfunction

function Trig_Molotov_DamageOnAttack_Actions takes nothing returns nothing
    set udg_DmgFlagUnavoidable=-1
    set udg_DamageElement=1
    call UnitDamageTargetBJ(LoadUnitHandleBJ(0,GetHandleIdBJ(GetAttacker()),udg_MolotovHash),GetAttacker(),LoadRealBJ(1,GetHandleIdBJ(GetAttacker()),udg_MolotovHash),ATTACK_TYPE_NORMAL,DAMAGE_TYPE_MAGIC)
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Molotov takes nothing returns nothing
endfunction

function RegisterR11_Molotov_DamageOnAttack takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Molotov_DamageOnAttack=CreateTrigger()

call TriggerRegisterAnyUnitEventBJ(gg_trg_Molotov_DamageOnAttack,EVENT_PLAYER_UNIT_ATTACKED)

call TriggerAddCondition(gg_trg_Molotov_DamageOnAttack,Condition(function Trig_Molotov_DamageOnAttack_Conditions))

call TriggerAddAction(gg_trg_Molotov_DamageOnAttack,function Trig_Molotov_DamageOnAttack_Actions)

endfunction




endlibrary
