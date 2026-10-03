library TZone7
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Zone7_Leash=null
endglobals

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
    local location l_tempPoint
    // A random whole number from 1 through LoadIntegerBJ(7, 2, udg_SpawnDataHashRef).
    set l_tempPoint=GetRandomLocInRect(LoadRectHandleBJ(GetRandomInt(1,LoadIntegerBJ(7,2,udg_SpawnDataHashRef)),7,udg_SpawnRectHashRef))
    call SetUnitPositionLoc(GetTriggerUnit(),l_tempPoint)
    call RemoveLocation(l_tempPoint)
    set l_tempPoint=null
endfunction

// World Editor calls InitTrig_Zone7 automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Zone7 (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Zone7 takes nothing returns nothing
endfunction

function Register_Zone7_Leash takes nothing returns nothing
    set gg_trg_Zone7_Leash=CreateTrigger()
    call TriggerRegisterEnterRectSimple(gg_trg_Zone7_Leash,gg_rct_364)
    call TriggerAddCondition(gg_trg_Zone7_Leash,Condition(function Trig_Zone7_Leash_Conditions))
    call TriggerAddAction(gg_trg_Zone7_Leash,function Trig_Zone7_Leash_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Zone7 takes nothing returns nothing
    call Register_Zone7_Leash()
endfunction

endlibrary
