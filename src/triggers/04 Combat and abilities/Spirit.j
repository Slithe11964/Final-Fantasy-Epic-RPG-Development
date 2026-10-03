library TSpirit
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Spirit_Create=null
endglobals

function Trig_Spirit_Create_CreateSpirit takes nothing returns nothing
    local location l_tempPoint
    set l_tempPoint=GetRectCenter(udg_PlayerStartRect[GetConvertedPlayerId(GetEnumPlayer())])
    call CreateNUnitsAtLoc(1,'H01D',GetEnumPlayer(),l_tempPoint,bj_UNIT_FACING) // 'H01D': unit "Spirit of Gaya"
    set udg_SpiritOfGaya[GetConvertedPlayerId(GetEnumPlayer())]=GetLastCreatedUnit()
    call RemoveLocation(l_tempPoint)
    set l_tempPoint=null
endfunction

function Trig_Spirit_Create_Actions takes nothing returns nothing
    call ForForce(udg_PlayingPlayers,function Trig_Spirit_Create_CreateSpirit)
    call StartTimerBJ(udg_JobLevelTimer,false,.01)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_Spirit automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Spirit (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Spirit takes nothing returns nothing
endfunction

function Register_Spirit_Create takes nothing returns nothing
    set gg_trg_Spirit_Create=CreateTrigger()
    call TriggerRegisterTimerExpireEventBJ(gg_trg_Spirit_Create,udg_SpiritSpawnTimer)
    call TriggerAddAction(gg_trg_Spirit_Create,function Trig_Spirit_Create_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Spirit takes nothing returns nothing
    call Register_Spirit_Create()
endfunction

endlibrary
