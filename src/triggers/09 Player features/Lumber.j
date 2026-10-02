library TLumber
function Trig_Lumber_Cap_Actions takes nothing returns nothing
    call SetPlayerStateBJ(GetTriggerPlayer(),PLAYER_STATE_RESOURCE_LUMBER,999)
endfunction

function Trig_Lumber_Harvest_Start_Actions takes nothing returns nothing
    call IssueTargetDestructableOrder(gg_unit_h023_0029,"harvest",gg_dest_LTlt_0007)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_Lumber automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Lumber (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Lumber takes nothing returns nothing
endfunction

function Register_Lumber_Cap takes nothing returns nothing
    set gg_trg_Lumber_Cap=CreateTrigger()
    call TriggerRegisterPlayerStateEvent(gg_trg_Lumber_Cap,Player(0),PLAYER_STATE_RESOURCE_LUMBER,GREATER_THAN,999.)
    call TriggerRegisterPlayerStateEvent(gg_trg_Lumber_Cap,Player(1),PLAYER_STATE_RESOURCE_LUMBER,GREATER_THAN,999.)
    call TriggerRegisterPlayerStateEvent(gg_trg_Lumber_Cap,Player(2),PLAYER_STATE_RESOURCE_LUMBER,GREATER_THAN,999.)
    call TriggerRegisterPlayerStateEvent(gg_trg_Lumber_Cap,Player(3),PLAYER_STATE_RESOURCE_LUMBER,GREATER_THAN,999.)
    call TriggerRegisterPlayerStateEvent(gg_trg_Lumber_Cap,Player(4),PLAYER_STATE_RESOURCE_LUMBER,GREATER_THAN,999.)
    call TriggerRegisterPlayerStateEvent(gg_trg_Lumber_Cap,Player(5),PLAYER_STATE_RESOURCE_LUMBER,GREATER_THAN,999.)
    call TriggerRegisterPlayerStateEvent(gg_trg_Lumber_Cap,Player(6),PLAYER_STATE_RESOURCE_LUMBER,GREATER_THAN,999.)
    call TriggerRegisterPlayerStateEvent(gg_trg_Lumber_Cap,Player(7),PLAYER_STATE_RESOURCE_LUMBER,GREATER_THAN,999.)
    call TriggerAddAction(gg_trg_Lumber_Cap,function Trig_Lumber_Cap_Actions)
endfunction

function Register_Lumber_Harvest_Start takes nothing returns nothing
    set gg_trg_Lumber_Harvest_Start=CreateTrigger()
    call TriggerRegisterTimerEventSingle(gg_trg_Lumber_Harvest_Start,17.)
    call TriggerAddAction(gg_trg_Lumber_Harvest_Start,function Trig_Lumber_Harvest_Start_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Lumber takes nothing returns nothing
    call Register_Lumber_Cap()
    call Register_Lumber_Harvest_Start()
endfunction

endlibrary
