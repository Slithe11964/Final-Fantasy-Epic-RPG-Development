library THuntRewards
function Trig_Hunt_Shard_Register_Actions takes nothing returns nothing
    call TriggerRegisterUnitEvent(gg_trg_Hunt_Shard_Drop,GetLastCreatedUnit(),EVENT_UNIT_DEATH)
endfunction

function Trig_Hunt_Shard_Drop_ShardsLeft takes nothing returns boolean
    return(udg_CrystalShardCount<3)
endfunction

function Trig_Hunt_Shard_Drop_Actions takes nothing returns nothing
    set udg_CrystalShardCount=(udg_CrystalShardCount+1)
    if(Trig_Hunt_Shard_Drop_ShardsLeft())then
        set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
        call CreateItemLoc('I01Z',udg_TempPoint) // 'I01Z': item "Crystal Shard"
        call RemoveLocation(udg_TempPoint)
    else
        call DisableTrigger(GetTriggeringTrigger())
        call DestroyTrigger(GetTriggeringTrigger())
    endif
endfunction

function InitTrig_Hunt_Rewards takes nothing returns nothing
endfunction

endlibrary
