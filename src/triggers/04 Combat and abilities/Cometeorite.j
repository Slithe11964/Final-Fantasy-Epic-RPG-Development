library TCometeorite
function Trig_Cometeorite_Rocks_Cleanup_Conditions takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0YP',GetTriggerUnit())>0) // 'A0YP': ability "!Cometeorite"
endfunction

function Trig_Cometeorite_Rocks_Cleanup_ExpireRock takes nothing returns nothing
    call UnitApplyTimedLifeBJ(.01,'BTLF',GetEnumUnit()) // 'BTLF': object name not found in map data
endfunction

function Trig_Cometeorite_Rocks_Cleanup_Actions takes nothing returns nothing
    call ForGroupBJ(udg_MeteoriteRocks,function Trig_Cometeorite_Rocks_Cleanup_ExpireRock)
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Cometeorite takes nothing returns nothing
endfunction

function RegisterR11_Cometeorite_Rocks_Cleanup takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Cometeorite_Rocks_Cleanup=CreateTrigger()

call TriggerRegisterAnyUnitEventBJ(gg_trg_Cometeorite_Rocks_Cleanup,EVENT_PLAYER_UNIT_DEATH)

call TriggerAddCondition(gg_trg_Cometeorite_Rocks_Cleanup,Condition(function Trig_Cometeorite_Rocks_Cleanup_Conditions))

call TriggerAddAction(gg_trg_Cometeorite_Rocks_Cleanup,function Trig_Cometeorite_Rocks_Cleanup_Actions)

endfunction




endlibrary
