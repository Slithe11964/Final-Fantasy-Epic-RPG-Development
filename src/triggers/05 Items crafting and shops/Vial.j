library TVial
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Vial_EmptyOnUse=null
endglobals

function Trig_Vial_EmptyOnUse_Cond_ItemIsFilledVial takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='bzbf')or(GetItemTypeId(GetManipulatedItem())=='I0JL')or(GetItemTypeId(GetManipulatedItem())=='I0JM') // 'bzbf': item "Filled Vial"; 'I0JL': item "Filled Vial"; 'I0JM': item "Filled Vial"
endfunction

function Trig_Vial_EmptyOnUse_Conditions takes nothing returns boolean
    return(Trig_Vial_EmptyOnUse_Cond_ItemIsFilledVial())
endfunction

function Trig_Vial_EmptyOnUse_Actions takes nothing returns nothing
    local location l_tempPoint
    set l_tempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateItemLoc('bzbe',l_tempPoint) // 'bzbe': editor label "Empty Vial"
    call RemoveLocation(l_tempPoint)
    set udg_QuestItem[18]=GetLastCreatedItem()
    call SetItemInvulnerableBJ(GetLastCreatedItem(),true)
    call RemoveItem(GetManipulatedItem())
    call UnitAddItemSwapped(udg_QuestItem[18],GetTriggerUnit())
    set l_tempPoint=null
endfunction

// World Editor calls InitTrig_Vial automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Vial (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Vial takes nothing returns nothing
endfunction

function Register_Vial_EmptyOnUse takes nothing returns nothing
    set gg_trg_Vial_EmptyOnUse=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Vial_EmptyOnUse,EVENT_PLAYER_UNIT_USE_ITEM)
    call TriggerAddCondition(gg_trg_Vial_EmptyOnUse,Condition(function Trig_Vial_EmptyOnUse_Conditions))
    call TriggerAddAction(gg_trg_Vial_EmptyOnUse,function Trig_Vial_EmptyOnUse_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Vial takes nothing returns nothing
    call Register_Vial_EmptyOnUse()
endfunction

endlibrary
