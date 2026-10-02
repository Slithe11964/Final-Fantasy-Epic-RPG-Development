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

// World Editor calls InitTrig_Defend automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Defend (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Defend takes nothing returns nothing
endfunction

function Register_Defend_Toggle takes nothing returns nothing
    set gg_trg_Defend_Toggle=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Defend_Toggle,EVENT_PLAYER_UNIT_ISSUED_TARGET_ORDER)
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Defend_Toggle,EVENT_PLAYER_UNIT_ISSUED_POINT_ORDER)
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Defend_Toggle,EVENT_PLAYER_UNIT_ISSUED_ORDER)
    call TriggerAddCondition(gg_trg_Defend_Toggle,Condition(function Trig_Defend_Toggle_Conditions))
    call TriggerAddAction(gg_trg_Defend_Toggle,function Trig_Defend_Toggle_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Defend takes nothing returns nothing
    call Register_Defend_Toggle()
endfunction

endlibrary
