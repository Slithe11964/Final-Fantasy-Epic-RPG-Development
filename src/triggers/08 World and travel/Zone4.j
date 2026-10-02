library TZone4
function Trig_Zone4_Leash_IsChocobo_Z4 takes nothing returns boolean
    return(GetUnitName(GetTriggerUnit())=="Chocobo")and(GetOwningPlayer(GetTriggerUnit())==Player(8))
endfunction

function Trig_Zone4_Leash_IsLeashTarget_Z4 takes nothing returns boolean
    return(GetOwningPlayer(GetTriggerUnit())==Player($B))or(Trig_Zone4_Leash_IsChocobo_Z4()) // $B = 11
endfunction

function Trig_Zone4_Leash_Conditions takes nothing returns boolean
    return(GetUnitUserData(GetTriggerUnit())==0)and(Trig_Zone4_Leash_IsLeashTarget_Z4())and(IsUnitInGroup(GetTriggerUnit(),udg_SpecialUnits)==false)and(IsUnitInGroup(GetTriggerUnit(),udg_SummonedUnits)==false)and(IsUnitInGroup(GetTriggerUnit(),udg_EscortUnits)==false)and(GetTriggerUnit()!=gg_unit_Hpb1_0013)and(GetTriggerUnit()!=gg_unit_U00E_0222)
endfunction

function Trig_Zone4_Leash_Actions takes nothing returns nothing
    // A random whole number from 1 through LoadIntegerBJ(4, 2, udg_SpawnDataHashRef).
    set udg_TempPoint=GetRandomLocInRect(LoadRectHandleBJ(GetRandomInt(1,LoadIntegerBJ(4,2,udg_SpawnDataHashRef)),4,udg_SpawnRectHashRef))
    call SetUnitPositionLoc(GetTriggerUnit(),udg_TempPoint)
    call RemoveLocation(udg_TempPoint)
endfunction

function Trig_Zone4_Leash_North_IsChocobo_Z4b takes nothing returns boolean
    return(GetUnitName(GetTriggerUnit())=="Chocobo")and(GetOwningPlayer(GetTriggerUnit())==Player(8))
endfunction

function Trig_Zone4_Leash_North_IsLeashTarget_Z4b takes nothing returns boolean
    return(GetOwningPlayer(GetTriggerUnit())==Player($B))or(Trig_Zone4_Leash_North_IsChocobo_Z4b()) // $B = 11
endfunction

function Trig_Zone4_Leash_North_Conditions takes nothing returns boolean
    return(GetUnitUserData(GetTriggerUnit())==0)and(Trig_Zone4_Leash_North_IsLeashTarget_Z4b())
endfunction

function Trig_Zone4_Leash_North_Actions takes nothing returns nothing
    // A random whole number from 37 through 42.
    set udg_TempPoint=GetRandomLocInRect(LoadRectHandleBJ(GetRandomInt(37,42),4,udg_SpawnRectHashRef))
    call SetUnitPositionLoc(GetTriggerUnit(),udg_TempPoint)
    call RemoveLocation(udg_TempPoint)
endfunction

function Trig_Zone4_Leash_Mid_Conditions takes nothing returns boolean
    return(GetOwningPlayer(GetTriggerUnit())==Player($B)) // $B = 11
endfunction

function Trig_Zone4_Leash_Mid_Actions takes nothing returns nothing
    // A random whole number from 13 through 25.
    set udg_TempPoint=GetRandomLocInRect(LoadRectHandleBJ(GetRandomInt($D,25),4,udg_SpawnRectHashRef)) // $D = 13
    call SetUnitPositionLoc(GetTriggerUnit(),udg_TempPoint)
    call RemoveLocation(udg_TempPoint)
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Zone4 takes nothing returns nothing
endfunction

function RegisterR11_Zone4_Leash takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Zone4_Leash=CreateTrigger()

call TriggerRegisterEnterRectSimple(gg_trg_Zone4_Leash,gg_rct_225)

call TriggerAddCondition(gg_trg_Zone4_Leash,Condition(function Trig_Zone4_Leash_Conditions))

call TriggerAddAction(gg_trg_Zone4_Leash,function Trig_Zone4_Leash_Actions)

endfunction




function RegisterR11_Zone4_Leash_North takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Zone4_Leash_North=CreateTrigger()

call TriggerRegisterEnterRectSimple(gg_trg_Zone4_Leash_North,gg_rct_664)

call TriggerAddCondition(gg_trg_Zone4_Leash_North,Condition(function Trig_Zone4_Leash_North_Conditions))

call TriggerAddAction(gg_trg_Zone4_Leash_North,function Trig_Zone4_Leash_North_Actions)

endfunction




function RegisterR11_Zone4_Leash_Mid takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Zone4_Leash_Mid=CreateTrigger()

call TriggerRegisterEnterRectSimple(gg_trg_Zone4_Leash_Mid,gg_rct_670)

call TriggerAddCondition(gg_trg_Zone4_Leash_Mid,Condition(function Trig_Zone4_Leash_Mid_Conditions))

call TriggerAddAction(gg_trg_Zone4_Leash_Mid,function Trig_Zone4_Leash_Mid_Actions)

endfunction




endlibrary
