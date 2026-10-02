library TQuestUnits
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
    set udg_TempPoint=GetUnitLoc(GetEnumUnit())
    call PingMinimapLocForForceEx(GetPlayersAll(),udg_TempPoint,2.,bj_MINIMAPPINGSTYLE_SIMPLE,'d',.0,.0)
    call RemoveLocation(udg_TempPoint)
    if(Trig_QuestUnits_Ping_IsAllyUnit_Primary())then
        call DisplayTextToForce(GetPlayersAll(),"DEBUG: A player/ally unit is being pinged! Please report this and at what point this is occurring.")
    endif
endfunction

function Trig_QuestUnits_Ping_IsAllyUnit_Quest takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetEnumUnit()),udg_ActivePlayers))
endfunction

function Trig_QuestUnits_Ping_Ping_Quest takes nothing returns nothing
    set udg_TempPoint=GetUnitLoc(GetEnumUnit())
    call PingMinimapLocForForceEx(GetPlayersAll(),udg_TempPoint,2.,bj_MINIMAPPINGSTYLE_SIMPLE,'d',80.,.0)
    call RemoveLocation(udg_TempPoint)
    if(Trig_QuestUnits_Ping_IsAllyUnit_Quest())then
        call DisplayTextToForce(GetPlayersAll(),"DEBUG: A player/ally unit is being pinged! Please report this and at what point this is occurring.")
    endif
endfunction

function Trig_QuestUnits_Ping_IsAllyUnit_Boss takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetEnumUnit()),udg_ActivePlayers))
endfunction

function Trig_QuestUnits_Ping_Ping_Boss takes nothing returns nothing
    set udg_TempPoint=GetUnitLoc(GetEnumUnit())
    call PingMinimapLocForForce(GetPlayersAll(),udg_TempPoint,2.)
    call RemoveLocation(udg_TempPoint)
    if(Trig_QuestUnits_Ping_IsAllyUnit_Boss())then
        call DisplayTextToForce(GetPlayersAll(),"DEBUG: A player/ally unit is being pinged! Please report this and at what point this is occurring.")
    endif
endfunction

function Trig_QuestUnits_Ping_IsAllyUnit_Extra takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetEnumUnit()),udg_ActivePlayers))
endfunction

function Trig_QuestUnits_Ping_Ping_Extra takes nothing returns nothing
    set udg_TempPoint=GetUnitLoc(GetEnumUnit())
    call PingMinimapLocForForceEx(GetPlayersAll(),udg_TempPoint,2.,bj_MINIMAPPINGSTYLE_SIMPLE,30.,50.,100.)
    call RemoveLocation(udg_TempPoint)
    if(Trig_QuestUnits_Ping_IsAllyUnit_Extra())then
        call DisplayTextToForce(GetPlayersAll(),"DEBUG: A player/ally unit is being pinged! Please report this and at what point this is occurring.")
    endif
endfunction

function Trig_QuestUnits_Ping_Actions takes nothing returns nothing
    call ForGroupBJ(udg_PrimaryQuestUnits,function Trig_QuestUnits_Ping_Ping_Primary)
    call ForGroupBJ(udg_QuestUnits,function Trig_QuestUnits_Ping_Ping_Quest)
    call ForGroupBJ(udg_BossUnits,function Trig_QuestUnits_Ping_Ping_Boss)
    call ForGroupBJ(udg_HuntMonsters,function Trig_QuestUnits_Ping_Ping_Extra)
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_QuestUnits takes nothing returns nothing
endfunction

function RegisterR11_QuestUnits_Ping takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_QuestUnits_Ping=CreateTrigger()

call TriggerRegisterTimerEventPeriodic(gg_trg_QuestUnits_Ping,15.)

call TriggerAddCondition(gg_trg_QuestUnits_Ping,Condition(function Trig_QuestUnits_Ping_Conditions))

call TriggerAddAction(gg_trg_QuestUnits_Ping,function Trig_QuestUnits_Ping_Actions)

endfunction




endlibrary
