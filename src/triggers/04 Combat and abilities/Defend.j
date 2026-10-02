library TDefend
function Trig_Defend_Toggle_Conditions takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0PP',GetTriggerUnit())>0) // 'A0PP': ability "Defend"
endfunction

function Trig_Defend_Toggle_IsDefendOrder takes nothing returns boolean
    return(GetIssuedOrderIdBJ()==$D0019) // $D0019 = 851993
endfunction

function Trig_Defend_Toggle_Actions takes nothing returns nothing
    if(Trig_Defend_Toggle_IsDefendOrder())then
        call GroupAddUnitSimple(GetTriggerUnit(),udg_DefendingUnits)
    else
        call GroupRemoveUnitSimple(GetTriggerUnit(),udg_DefendingUnits)
    endif
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Defend takes nothing returns nothing
endfunction

function RegisterR11_Defend_Toggle takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Defend_Toggle=CreateTrigger()

call TriggerRegisterAnyUnitEventBJ(gg_trg_Defend_Toggle,EVENT_PLAYER_UNIT_ISSUED_TARGET_ORDER)

call TriggerRegisterAnyUnitEventBJ(gg_trg_Defend_Toggle,EVENT_PLAYER_UNIT_ISSUED_POINT_ORDER)

call TriggerRegisterAnyUnitEventBJ(gg_trg_Defend_Toggle,EVENT_PLAYER_UNIT_ISSUED_ORDER)

call TriggerAddCondition(gg_trg_Defend_Toggle,Condition(function Trig_Defend_Toggle_Conditions))

call TriggerAddAction(gg_trg_Defend_Toggle,function Trig_Defend_Toggle_Actions)

endfunction




endlibrary
