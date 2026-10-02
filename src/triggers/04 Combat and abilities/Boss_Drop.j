library TBossDrop
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Boss_Drop_TomeOfLife=null
    trigger gg_trg_Boss_Drop_CrushersMace=null
    trigger gg_trg_Boss_Drop_FurArmor=null
endglobals

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

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Boss_Part11 (module Boss),
// which keeps the original registration order.

function Register_Boss_Drop_TomeOfLife takes nothing returns nothing
    set gg_trg_Boss_Drop_TomeOfLife=CreateTrigger()
    call TriggerRegisterUnitEvent(gg_trg_Boss_Drop_TomeOfLife,gg_unit_U006_0077,EVENT_UNIT_DEATH)
    call TriggerAddAction(gg_trg_Boss_Drop_TomeOfLife,function Trig_Boss_Drop_TomeOfLife_Actions)
endfunction

function Register_Boss_Drop_CrushersMace takes nothing returns nothing
    set gg_trg_Boss_Drop_CrushersMace=CreateTrigger()
    call TriggerRegisterUnitEvent(gg_trg_Boss_Drop_CrushersMace,gg_unit_H00W_0079,EVENT_UNIT_DEATH)
    call TriggerAddAction(gg_trg_Boss_Drop_CrushersMace,function Trig_Boss_Drop_CrushersMace_Actions)
endfunction

function Register_Boss_Drop_FurArmor takes nothing returns nothing
    set gg_trg_Boss_Drop_FurArmor=CreateTrigger()
    call TriggerRegisterUnitEvent(gg_trg_Boss_Drop_FurArmor,gg_unit_n014_0174,EVENT_UNIT_DEATH)
    call TriggerAddAction(gg_trg_Boss_Drop_FurArmor,function Trig_Boss_Drop_FurArmor_Actions)
endfunction

endlibrary
