library TQuestUnits
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_QuestUnits_Ping=null
endglobals

function Trig_QuestUnits_Ping_AnyGroupHasUnits takes nothing returns boolean
    return(IsUnitGroupEmptyBJ(udg_PrimaryQuestUnits)==false)or(IsUnitGroupEmptyBJ(udg_QuestUnits)==false)or(IsUnitGroupEmptyBJ(udg_BossUnits)==false)or(IsUnitGroupEmptyBJ(udg_HuntMonsters)==false)
endfunction

function Trig_QuestUnits_Ping_Conditions takes nothing returns boolean
    return(Trig_QuestUnits_Ping_AnyGroupHasUnits())
endfunction

function Trig_QuestUnits_Ping_IsAllyUnit_Primary takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetEnumUnit()),udg_ActivePlayers))
endfunction

function Trig_QuestUnits_Ping_Ping_Primary takes nothing returns nothing
    local location l_tempPoint
    set l_tempPoint=GetUnitLoc(GetEnumUnit())
    call PingMinimapLocForForceEx(GetPlayersAll(),l_tempPoint,2.,bj_MINIMAPPINGSTYLE_SIMPLE,'d',.0,.0)
    call RemoveLocation(l_tempPoint)
    if(Trig_QuestUnits_Ping_IsAllyUnit_Primary())then
        call DisplayTextToForce(GetPlayersAll(),"DEBUG: A player/ally unit is being pinged! Please report this and at what point this is occurring.")
    endif
    set l_tempPoint=null
endfunction

function Trig_QuestUnits_Ping_IsAllyUnit_Quest takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetEnumUnit()),udg_ActivePlayers))
endfunction

function Trig_QuestUnits_Ping_Ping_Quest takes nothing returns nothing
    local location l_tempPoint
    set l_tempPoint=GetUnitLoc(GetEnumUnit())
    call PingMinimapLocForForceEx(GetPlayersAll(),l_tempPoint,2.,bj_MINIMAPPINGSTYLE_SIMPLE,'d',80.,.0)
    call RemoveLocation(l_tempPoint)
    if(Trig_QuestUnits_Ping_IsAllyUnit_Quest())then
        call DisplayTextToForce(GetPlayersAll(),"DEBUG: A player/ally unit is being pinged! Please report this and at what point this is occurring.")
    endif
    set l_tempPoint=null
endfunction

function Trig_QuestUnits_Ping_IsAllyUnit_Boss takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetEnumUnit()),udg_ActivePlayers))
endfunction

function Trig_QuestUnits_Ping_Ping_Boss takes nothing returns nothing
    local location l_tempPoint
    set l_tempPoint=GetUnitLoc(GetEnumUnit())
    call PingMinimapLocForForce(GetPlayersAll(),l_tempPoint,2.)
    call RemoveLocation(l_tempPoint)
    if(Trig_QuestUnits_Ping_IsAllyUnit_Boss())then
        call DisplayTextToForce(GetPlayersAll(),"DEBUG: A player/ally unit is being pinged! Please report this and at what point this is occurring.")
    endif
    set l_tempPoint=null
endfunction

function Trig_QuestUnits_Ping_IsAllyUnit_Extra takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetEnumUnit()),udg_ActivePlayers))
endfunction

function Trig_QuestUnits_Ping_Ping_Extra takes nothing returns nothing
    local location l_tempPoint
    set l_tempPoint=GetUnitLoc(GetEnumUnit())
    call PingMinimapLocForForceEx(GetPlayersAll(),l_tempPoint,2.,bj_MINIMAPPINGSTYLE_SIMPLE,30.,50.,100.)
    call RemoveLocation(l_tempPoint)
    if(Trig_QuestUnits_Ping_IsAllyUnit_Extra())then
        call DisplayTextToForce(GetPlayersAll(),"DEBUG: A player/ally unit is being pinged! Please report this and at what point this is occurring.")
    endif
    set l_tempPoint=null
endfunction

function Trig_QuestUnits_Ping_Actions takes nothing returns nothing
    call ForGroupBJ(udg_PrimaryQuestUnits,function Trig_QuestUnits_Ping_Ping_Primary)
    call ForGroupBJ(udg_QuestUnits,function Trig_QuestUnits_Ping_Ping_Quest)
    call ForGroupBJ(udg_BossUnits,function Trig_QuestUnits_Ping_Ping_Boss)
    call ForGroupBJ(udg_HuntMonsters,function Trig_QuestUnits_Ping_Ping_Extra)
endfunction

// World Editor calls InitTrig_QuestUnits automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_QuestUnits (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_QuestUnits takes nothing returns nothing
endfunction

function Register_QuestUnits_Ping takes nothing returns nothing
    set gg_trg_QuestUnits_Ping=CreateTrigger()
    call TriggerRegisterTimerEventPeriodic(gg_trg_QuestUnits_Ping,15.)
    call TriggerAddCondition(gg_trg_QuestUnits_Ping,Condition(function Trig_QuestUnits_Ping_Conditions))
    call TriggerAddAction(gg_trg_QuestUnits_Ping,function Trig_QuestUnits_Ping_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_QuestUnits takes nothing returns nothing
    call Register_QuestUnits_Ping()
endfunction

endlibrary
