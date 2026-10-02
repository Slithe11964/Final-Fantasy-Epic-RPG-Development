library TPatrol
function Trig_Patrol_Disabled_Conditions takes nothing returns boolean
    return(GetIssuedOrderIdBJ()==$D0016)and(udg_PatrolAllowed==false) // $D0016 = 851990
endfunction

function Trig_Patrol_Disabled_Actions takes nothing returns nothing
    call DisplayTimedTextToPlayer(GetTriggerPlayer(),.52,-.05,2.,"|cFFFF0000Patrolling is disabled.|r")
    call PauseUnitBJ(true,GetTriggerUnit())
    call IssueImmediateOrderBJ(GetTriggerUnit(),"stop")
    call PauseUnitBJ(false,GetTriggerUnit())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Patrol takes nothing returns nothing
endfunction

function RegisterR11_Patrol_Disabled takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Patrol_Disabled=CreateTrigger()

call TriggerRegisterPlayerUnitEventSimple(gg_trg_Patrol_Disabled,Player(0),EVENT_PLAYER_UNIT_ISSUED_POINT_ORDER)

call TriggerRegisterPlayerUnitEventSimple(gg_trg_Patrol_Disabled,Player(1),EVENT_PLAYER_UNIT_ISSUED_POINT_ORDER)

call TriggerRegisterPlayerUnitEventSimple(gg_trg_Patrol_Disabled,Player(2),EVENT_PLAYER_UNIT_ISSUED_POINT_ORDER)

call TriggerRegisterPlayerUnitEventSimple(gg_trg_Patrol_Disabled,Player(3),EVENT_PLAYER_UNIT_ISSUED_POINT_ORDER)

call TriggerRegisterPlayerUnitEventSimple(gg_trg_Patrol_Disabled,Player(4),EVENT_PLAYER_UNIT_ISSUED_POINT_ORDER)

call TriggerRegisterPlayerUnitEventSimple(gg_trg_Patrol_Disabled,Player(5),EVENT_PLAYER_UNIT_ISSUED_POINT_ORDER)

call TriggerRegisterPlayerUnitEventSimple(gg_trg_Patrol_Disabled,Player(6),EVENT_PLAYER_UNIT_ISSUED_POINT_ORDER)

call TriggerRegisterPlayerUnitEventSimple(gg_trg_Patrol_Disabled,Player(7),EVENT_PLAYER_UNIT_ISSUED_POINT_ORDER)

call TriggerAddCondition(gg_trg_Patrol_Disabled,Condition(function Trig_Patrol_Disabled_Conditions))

call TriggerAddAction(gg_trg_Patrol_Disabled,function Trig_Patrol_Disabled_Actions)

endfunction




endlibrary
