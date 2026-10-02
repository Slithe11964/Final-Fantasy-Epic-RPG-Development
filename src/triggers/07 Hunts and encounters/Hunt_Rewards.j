library THuntRewards
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Hunt_Shard_Register=null
    trigger gg_trg_Hunt_Shard_Drop=null
endglobals

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

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Hunt (module Hunt),
// which keeps the original registration order.

function Register_Hunt_Shard_Register takes nothing returns nothing
    set gg_trg_Hunt_Shard_Register=CreateTrigger()
    call DisableTrigger(gg_trg_Hunt_Shard_Register)
    call TriggerAddAction(gg_trg_Hunt_Shard_Register,function Trig_Hunt_Shard_Register_Actions)
endfunction

function Register_Hunt_Shard_Drop takes nothing returns nothing
    set gg_trg_Hunt_Shard_Drop=CreateTrigger()
    call TriggerAddAction(gg_trg_Hunt_Shard_Drop,function Trig_Hunt_Shard_Drop_Actions)
endfunction

endlibrary
