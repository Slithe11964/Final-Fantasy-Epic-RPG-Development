library TSpirit
function Trig_Spirit_Create_CreateSpirit takes nothing returns nothing
    set udg_TempPoint=GetRectCenter(udg_PlayerStartRect[GetConvertedPlayerId(GetEnumPlayer())])
    call CreateNUnitsAtLoc(1,'H01D',GetEnumPlayer(),udg_TempPoint,bj_UNIT_FACING) // 'H01D': unit "Spirit of Gaya"
    set udg_SpiritOfGaya[GetConvertedPlayerId(GetEnumPlayer())]=GetLastCreatedUnit()
    call RemoveLocation(udg_TempPoint)
endfunction

function Trig_Spirit_Create_Actions takes nothing returns nothing
    call ForForce(udg_PlayingPlayers,function Trig_Spirit_Create_CreateSpirit)
    call StartTimerBJ(udg_JobLevelTimer,false,.01)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Spirit takes nothing returns nothing
endfunction

function RegisterR11_Spirit_Create takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Spirit_Create=CreateTrigger()

call TriggerRegisterTimerExpireEventBJ(gg_trg_Spirit_Create,udg_SpiritSpawnTimer)

call TriggerAddAction(gg_trg_Spirit_Create,function Trig_Spirit_Create_Actions)

endfunction




endlibrary
