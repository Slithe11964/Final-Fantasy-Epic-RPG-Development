library TDrainAttack
function Trig_DrainAttack_LevelSync_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A0R1') // 'A0R1': ability "Drain Attack"
endfunction

function Trig_DrainAttack_LevelSync_LacksPassiveAbility takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0R2',GetTriggerUnit())<=0) // 'A0R2': ability "Drain Attack"
endfunction

function Trig_DrainAttack_LevelSync_Actions takes nothing returns nothing
    if(Trig_DrainAttack_LevelSync_LacksPassiveAbility())then
        call UnitAddAbilityBJ('A0R2',GetTriggerUnit()) // 'A0R2': ability "Drain Attack"
    endif
    call SetUnitAbilityLevelSwapped('A0R2',GetTriggerUnit(),GetUnitAbilityLevelSwapped('A0R1',GetTriggerUnit())) // 'A0R2': ability "Drain Attack"; 'A0R1': ability "Drain Attack"
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_DrainAttack takes nothing returns nothing
endfunction

function RegisterR11_DrainAttack_LevelSync takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_DrainAttack_LevelSync=CreateTrigger()

call TriggerRegisterAnyUnitEventBJ(gg_trg_DrainAttack_LevelSync,EVENT_PLAYER_UNIT_SPELL_EFFECT)

call TriggerAddCondition(gg_trg_DrainAttack_LevelSync,Condition(function Trig_DrainAttack_LevelSync_Conditions))

call TriggerAddAction(gg_trg_DrainAttack_LevelSync,function Trig_DrainAttack_LevelSync_Actions)

endfunction




endlibrary
