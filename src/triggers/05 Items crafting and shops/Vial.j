library TVial
function Trig_Vial_EmptyOnUse_Cond_ItemIsFilledVial takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='bzbf')or(GetItemTypeId(GetManipulatedItem())=='I0JL')or(GetItemTypeId(GetManipulatedItem())=='I0JM') // 'bzbf': item "Filled Vial"; 'I0JL': item "Filled Vial"; 'I0JM': item "Filled Vial"
endfunction

function Trig_Vial_EmptyOnUse_Conditions takes nothing returns boolean
    return(Trig_Vial_EmptyOnUse_Cond_ItemIsFilledVial())
endfunction

function Trig_Vial_EmptyOnUse_Actions takes nothing returns nothing
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateItemLoc('bzbe',udg_TempPoint) // 'bzbe': editor label "Empty Vial"
    call RemoveLocation(udg_TempPoint)
    set udg_QuestItem[18]=GetLastCreatedItem()
    call SetItemInvulnerableBJ(GetLastCreatedItem(),true)
    call RemoveItem(GetManipulatedItem())
    call UnitAddItemSwapped(udg_QuestItem[18],GetTriggerUnit())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Vial takes nothing returns nothing
endfunction

function RegisterR11_Vial_EmptyOnUse takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Vial_EmptyOnUse=CreateTrigger()

call TriggerRegisterAnyUnitEventBJ(gg_trg_Vial_EmptyOnUse,EVENT_PLAYER_UNIT_USE_ITEM)

call TriggerAddCondition(gg_trg_Vial_EmptyOnUse,Condition(function Trig_Vial_EmptyOnUse_Conditions))

call TriggerAddAction(gg_trg_Vial_EmptyOnUse,function Trig_Vial_EmptyOnUse_Actions)

endfunction




endlibrary
