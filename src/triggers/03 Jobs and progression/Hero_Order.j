library THeroOrder requires TPlayerPart01
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

endlibrary
