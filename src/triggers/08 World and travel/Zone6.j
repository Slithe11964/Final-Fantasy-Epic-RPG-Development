library TZone6
function Trig_Zone6_Leash_IsChocobo_Z6 takes nothing returns boolean
    return(GetUnitName(GetTriggerUnit())=="Chocobo")and(GetOwningPlayer(GetTriggerUnit())==Player(8))
endfunction

function Trig_Zone6_Leash_IsLeashTarget_Z6 takes nothing returns boolean
    return(GetOwningPlayer(GetTriggerUnit())==Player($B))or(Trig_Zone6_Leash_IsChocobo_Z6()) // $B = 11
endfunction

function Trig_Zone6_Leash_Conditions takes nothing returns boolean
    return(GetUnitUserData(GetTriggerUnit())==0)and(Trig_Zone6_Leash_IsLeashTarget_Z6())
endfunction

function Trig_Zone6_Leash_Actions takes nothing returns nothing
    // A random whole number from 1 through LoadIntegerBJ(6, 2, udg_SpawnDataHashRef).
    set udg_TempPoint=GetRandomLocInRect(LoadRectHandleBJ(GetRandomInt(1,LoadIntegerBJ(6,2,udg_SpawnDataHashRef)),6,udg_SpawnRectHashRef))
    call SetUnitPositionLoc(GetTriggerUnit(),udg_TempPoint)
    call RemoveLocation(udg_TempPoint)
endfunction

function Trig_Zone6_Leash_West_Conditions takes nothing returns boolean
    return(GetOwningPlayer(GetTriggerUnit())==Player($B)) // $B = 11
endfunction

function Trig_Zone6_Leash_West_Actions takes nothing returns nothing
    // A random whole number from 12 through 17.
    set udg_TempPoint=GetRandomLocInRect(LoadRectHandleBJ(GetRandomInt($C,17),6,udg_SpawnRectHashRef)) // $C = 12
    call SetUnitPositionLoc(GetTriggerUnit(),udg_TempPoint)
    call RemoveLocation(udg_TempPoint)
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Zone6 takes nothing returns nothing
endfunction

function RegisterR11_Zone6_Leash takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Zone6_Leash=CreateTrigger()

call TriggerRegisterEnterRectSimple(gg_trg_Zone6_Leash,gg_rct_365)

call TriggerAddCondition(gg_trg_Zone6_Leash,Condition(function Trig_Zone6_Leash_Conditions))

call TriggerAddAction(gg_trg_Zone6_Leash,function Trig_Zone6_Leash_Actions)

endfunction




function RegisterR11_Zone6_Leash_West takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Zone6_Leash_West=CreateTrigger()

call TriggerRegisterEnterRectSimple(gg_trg_Zone6_Leash_West,gg_rct_043)

call TriggerAddCondition(gg_trg_Zone6_Leash_West,Condition(function Trig_Zone6_Leash_West_Conditions))

call TriggerAddAction(gg_trg_Zone6_Leash_West,function Trig_Zone6_Leash_West_Actions)

endfunction




endlibrary
