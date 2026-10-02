library THeroOrder requires TPlayerPart01
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Hero_Order_Cooldown=null
endglobals

function Trig_Hero_Order_Cooldown_IsMoveOrder takes nothing returns boolean
    return(GetIssuedOrderIdBJ()==$D0012)or(GetIssuedOrderIdBJ()==$D0003) // $D0012 = 851986; $D0003 = 851971
endfunction

function Trig_Hero_Order_Cooldown_Conditions takes nothing returns boolean
    return(GetTriggerUnit()==Player_GetHero(GetOwningPlayer(GetTriggerUnit())))and(Trig_Hero_Order_Cooldown_IsMoveOrder())and(TimerGetRemaining(udg_DodgeSaveTimer[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])<=.01)
endfunction

function Trig_Hero_Order_Cooldown_Actions takes nothing returns nothing
    call StartTimerBJ(udg_DodgeSaveTimer[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],false,1.)
endfunction

function InitTrig_Hero_Order takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Hero_Part2 (module Hero),
// which keeps the original registration order.

function Register_Hero_Order_Cooldown takes nothing returns nothing
    set gg_trg_Hero_Order_Cooldown=CreateTrigger()
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_Hero_Order_Cooldown,Player(0),EVENT_PLAYER_UNIT_ISSUED_POINT_ORDER)
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_Hero_Order_Cooldown,Player(1),EVENT_PLAYER_UNIT_ISSUED_POINT_ORDER)
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_Hero_Order_Cooldown,Player(2),EVENT_PLAYER_UNIT_ISSUED_POINT_ORDER)
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_Hero_Order_Cooldown,Player(3),EVENT_PLAYER_UNIT_ISSUED_POINT_ORDER)
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_Hero_Order_Cooldown,Player(4),EVENT_PLAYER_UNIT_ISSUED_POINT_ORDER)
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_Hero_Order_Cooldown,Player(5),EVENT_PLAYER_UNIT_ISSUED_POINT_ORDER)
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_Hero_Order_Cooldown,Player(6),EVENT_PLAYER_UNIT_ISSUED_POINT_ORDER)
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_Hero_Order_Cooldown,Player(7),EVENT_PLAYER_UNIT_ISSUED_POINT_ORDER)
    call TriggerAddCondition(gg_trg_Hero_Order_Cooldown,Condition(function Trig_Hero_Order_Cooldown_Conditions))
    call TriggerAddAction(gg_trg_Hero_Order_Cooldown,function Trig_Hero_Order_Cooldown_Actions)
endfunction

endlibrary
