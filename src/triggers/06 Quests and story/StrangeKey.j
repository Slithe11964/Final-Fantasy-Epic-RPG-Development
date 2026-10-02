library TStrangeKey
function Trig_StrangeKey_Drop_Cond_DyingIsGolem takes nothing returns boolean
    return(GetUnitTypeId(GetDyingUnit())=='ngrk')or(GetUnitTypeId(GetDyingUnit())=='ngst')or(GetUnitTypeId(GetDyingUnit())=='nggr')or(GetUnitTypeId(GetDyingUnit())=='n016')or(GetUnitTypeId(GetDyingUnit())=='narg')or(GetUnitTypeId(GetDyingUnit())=='nwrg')or(GetUnitTypeId(GetDyingUnit())=='nsgg') // 'ngrk': object name not found in map data; 'ngst': object name not found in map data; 'nggr': object name not found in map data; 'n016': unit "Bloodstone Golem"; 'narg': object name not found in map data; 'nwrg': object name not found in map data; 'nsgg': object name not found in map data
endfunction

function Trig_StrangeKey_Drop_Conditions takes nothing returns boolean
    // A random whole number from 1 through 10.
    return(Trig_StrangeKey_Drop_Cond_DyingIsGolem())and(GetRandomInt(1,$A)<=1) // $A = 10
endfunction

function Trig_StrangeKey_Drop_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    set udg_QuestItem[2]=CreateItemLoc('kygh',udg_TempPoint) // 'kygh': item "Strange Key"
    call SetItemInvulnerableBJ(GetLastCreatedItem(),true)
    call RemoveLocation(udg_TempPoint)
    call EnableTrigger(gg_trg_StrangeCage_Unlock)
    call EnableTrigger(gg_trg_StrangeKey_Ping)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_StrangeKey_Ping_Conditions takes nothing returns boolean
    return(udg_QuestItem[2]!=null)and(IsItemOwned(udg_QuestItem[2])==false)
endfunction

function Trig_StrangeKey_Ping_Actions takes nothing returns nothing
    set udg_TempPoint=GetItemLoc(udg_QuestItem[2])
    call PingMinimapLocForForce(GetPlayersAll(),udg_TempPoint,2.)
    call RemoveLocation(udg_TempPoint)
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_StrangeKey takes nothing returns nothing
endfunction
function RegisterR11_StrangeKey_Drop takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_StrangeKey_Drop=CreateTrigger()
    call DisableTrigger(gg_trg_StrangeKey_Drop)
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_StrangeKey_Drop,Player($B),EVENT_PLAYER_UNIT_DEATH) // $B = 11
    call TriggerAddCondition(gg_trg_StrangeKey_Drop,Condition(function Trig_StrangeKey_Drop_Conditions))
    call TriggerAddAction(gg_trg_StrangeKey_Drop,function Trig_StrangeKey_Drop_Actions)
endfunction
function RegisterR11_StrangeKey_Ping takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_StrangeKey_Ping=CreateTrigger()
    call DisableTrigger(gg_trg_StrangeKey_Ping)
    call TriggerRegisterTimerEventPeriodic(gg_trg_StrangeKey_Ping,15.)
    call TriggerAddCondition(gg_trg_StrangeKey_Ping,Condition(function Trig_StrangeKey_Ping_Conditions))
    call TriggerAddAction(gg_trg_StrangeKey_Ping,function Trig_StrangeKey_Ping_Actions)
endfunction




endlibrary
