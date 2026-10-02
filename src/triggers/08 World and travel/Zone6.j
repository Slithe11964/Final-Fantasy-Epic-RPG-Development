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

// World Editor calls InitTrig_Zone6 automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Zone6_Part1 / RegisterTriggers_Zone6_Part2 (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Zone6 takes nothing returns nothing
endfunction

function Register_Zone6_Leash takes nothing returns nothing
    set gg_trg_Zone6_Leash=CreateTrigger()
    call TriggerRegisterEnterRectSimple(gg_trg_Zone6_Leash,gg_rct_365)
    call TriggerAddCondition(gg_trg_Zone6_Leash,Condition(function Trig_Zone6_Leash_Conditions))
    call TriggerAddAction(gg_trg_Zone6_Leash,function Trig_Zone6_Leash_Actions)
endfunction

function Register_Zone6_Leash_West takes nothing returns nothing
    set gg_trg_Zone6_Leash_West=CreateTrigger()
    call TriggerRegisterEnterRectSimple(gg_trg_Zone6_Leash_West,gg_rct_043)
    call TriggerAddCondition(gg_trg_Zone6_Leash_West,Condition(function Trig_Zone6_Leash_West_Conditions))
    call TriggerAddAction(gg_trg_Zone6_Leash_West,function Trig_Zone6_Leash_West_Actions)
endfunction

// Creates part 1 of 2 of this module's triggers. Called once at startup from
// Startup_RegisterTriggers (MapBootstrap). The parts are registered at different points so that
// triggers sharing an event with other modules keep their original firing order.
function RegisterTriggers_Zone6_Part1 takes nothing returns nothing
    call Register_Zone6_Leash()
endfunction

// Creates part 2 of 2 of this module's triggers. Called once at startup from
// Startup_RegisterTriggers (MapBootstrap). The parts are registered at different points so that
// triggers sharing an event with other modules keep their original firing order.
function RegisterTriggers_Zone6_Part2 takes nothing returns nothing
    call Register_Zone6_Leash_West()
endfunction

endlibrary
