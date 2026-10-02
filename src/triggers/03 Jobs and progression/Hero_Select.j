library THeroSelect requires TPlayerPart01
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Hero_Select_Redirect=null
endglobals

function Trig_Hero_Select_Redirect_Conditions takes nothing returns boolean
    return(GetTriggerUnit()==Player_GetHero(GetTriggerPlayer()))and(udg_GatherState[GetConvertedPlayerId(GetTriggerPlayer())]>=2)
endfunction

function Trig_Hero_Select_Redirect_Actions takes nothing returns nothing
    call SelectUnitForPlayerSingle(udg_FishingControls[GetConvertedPlayerId(GetTriggerPlayer())],GetTriggerPlayer())
endfunction

function InitTrig_Hero_Select takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Hero_Part4 (module Hero),
// which keeps the original registration order.

function Register_Hero_Select_Redirect takes nothing returns nothing
    set gg_trg_Hero_Select_Redirect=CreateTrigger()
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Hero_Select_Redirect,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Hero_Select_Redirect,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Hero_Select_Redirect,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Hero_Select_Redirect,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Hero_Select_Redirect,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Hero_Select_Redirect,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Hero_Select_Redirect,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Hero_Select_Redirect,Player(7),true)
    call TriggerAddCondition(gg_trg_Hero_Select_Redirect,Condition(function Trig_Hero_Select_Redirect_Conditions))
    call TriggerAddAction(gg_trg_Hero_Select_Redirect,function Trig_Hero_Select_Redirect_Actions)
endfunction

endlibrary
