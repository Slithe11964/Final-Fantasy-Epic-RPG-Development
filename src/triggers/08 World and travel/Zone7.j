library TZone7
function Trig_Zone7_Leash_IsChocobo_Z7 takes nothing returns boolean
    return(GetUnitName(GetTriggerUnit())=="Chocobo")and(GetOwningPlayer(GetTriggerUnit())==Player(8))
endfunction

function Trig_Zone7_Leash_IsLeashTarget_Z7 takes nothing returns boolean
    return(GetOwningPlayer(GetTriggerUnit())==Player($B))or(Trig_Zone7_Leash_IsChocobo_Z7()) // $B = 11
endfunction

function Trig_Zone7_Leash_Conditions takes nothing returns boolean
    return(GetUnitUserData(GetTriggerUnit())==0)and(Trig_Zone7_Leash_IsLeashTarget_Z7())
endfunction

function Trig_Zone7_Leash_Actions takes nothing returns nothing
    // A random whole number from 1 through LoadIntegerBJ(7, 2, udg_SpawnDataHashRef).
    set udg_TempPoint=GetRandomLocInRect(LoadRectHandleBJ(GetRandomInt(1,LoadIntegerBJ(7,2,udg_SpawnDataHashRef)),7,udg_SpawnRectHashRef))
    call SetUnitPositionLoc(GetTriggerUnit(),udg_TempPoint)
    call RemoveLocation(udg_TempPoint)
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Zone7 takes nothing returns nothing
endfunction
function RegisterR11_Zone7_Leash takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Zone7_Leash=CreateTrigger()
    call TriggerRegisterEnterRectSimple(gg_trg_Zone7_Leash,gg_rct_364)
    call TriggerAddCondition(gg_trg_Zone7_Leash,Condition(function Trig_Zone7_Leash_Conditions))
    call TriggerAddAction(gg_trg_Zone7_Leash,function Trig_Zone7_Leash_Actions)
endfunction




endlibrary
