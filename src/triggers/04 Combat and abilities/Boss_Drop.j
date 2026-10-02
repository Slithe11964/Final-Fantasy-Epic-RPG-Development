library TBossDrop
function Trig_Boss_Drop_TomeOfLife_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    set udg_TempPoint3=GetUnitLoc(GetTriggerUnit())
    call CreateItemLoc('I0HX',udg_TempPoint3) // 'I0HX': item "Tome of Life"
    call CreateItemLoc('I01Z',udg_TempPoint3) // 'I01Z': item "Crystal Shard"
    call RemoveLocation(udg_TempPoint3)
    call SaveIntegerBJ(1,2,98,udg_GameStateHash)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Boss_Drop_CrushersMace_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    set udg_TempPoint3=GetUnitLoc(GetTriggerUnit())
    call CreateItemLoc('I02Y',udg_TempPoint3) // 'I02Y': item "Crusher's Mace"
    call CreateItemLoc('I01Z',udg_TempPoint3) // 'I01Z': item "Crystal Shard"
    call RemoveLocation(udg_TempPoint3)
    call SaveIntegerBJ(1,2,'d',udg_GameStateHash)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Boss_Drop_FurArmor_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    set udg_TempPoint3=GetUnitLoc(GetTriggerUnit())
    call CreateItemLoc('I030',udg_TempPoint3) // 'I030': item "Fur Armor"
    call CreateItemLoc('I01Z',udg_TempPoint3) // 'I01Z': item "Crystal Shard"
    call RemoveLocation(udg_TempPoint3)
    call SaveIntegerBJ(1,2,'j',udg_GameStateHash)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function InitTrig_Boss_Drop takes nothing returns nothing
endfunction

endlibrary
