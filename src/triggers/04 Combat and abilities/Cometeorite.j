library TCometeorite
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Cometeorite_Rocks_Cleanup=null
endglobals

function Trig_Cometeorite_Rocks_Cleanup_Conditions takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0YP',GetTriggerUnit())>0) // 'A0YP': ability "!Cometeorite"
endfunction

function Trig_Cometeorite_Rocks_Cleanup_ExpireRock takes nothing returns nothing
    call UnitApplyTimedLifeBJ(.01,'BTLF',GetEnumUnit()) // 'BTLF': object name not found in map data
endfunction

function Trig_Cometeorite_Rocks_Cleanup_Actions takes nothing returns nothing
    call ForGroupBJ(udg_MeteoriteRocks,function Trig_Cometeorite_Rocks_Cleanup_ExpireRock)
endfunction

// World Editor calls InitTrig_Cometeorite automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Cometeorite (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Cometeorite takes nothing returns nothing
endfunction

function Register_Cometeorite_Rocks_Cleanup takes nothing returns nothing
    set gg_trg_Cometeorite_Rocks_Cleanup=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Cometeorite_Rocks_Cleanup,EVENT_PLAYER_UNIT_DEATH)
    call TriggerAddCondition(gg_trg_Cometeorite_Rocks_Cleanup,Condition(function Trig_Cometeorite_Rocks_Cleanup_Conditions))
    call TriggerAddAction(gg_trg_Cometeorite_Rocks_Cleanup,function Trig_Cometeorite_Rocks_Cleanup_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Cometeorite takes nothing returns nothing
    call Register_Cometeorite_Rocks_Cleanup()
endfunction

endlibrary
