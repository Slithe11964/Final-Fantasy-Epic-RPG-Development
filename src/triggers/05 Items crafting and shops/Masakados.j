library TMasakados
function Trig_Masakados_Drop_Conditions takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='I0G5') // 'I0G5': item "Masakados"
endfunction

function Trig_Masakados_Drop_Actions takes nothing returns nothing
    call UnitRemoveBuffBJ('B05Q',GetTriggerUnit()) // 'B05Q': buff tooltip "Pierce"
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Masakados takes nothing returns nothing
endfunction
function RegisterR11_Masakados_Drop takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Masakados_Drop=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Masakados_Drop,EVENT_PLAYER_UNIT_DROP_ITEM)
    call TriggerAddCondition(gg_trg_Masakados_Drop,Condition(function Trig_Masakados_Drop_Conditions))
    call TriggerAddAction(gg_trg_Masakados_Drop,function Trig_Masakados_Drop_Actions)
endfunction




endlibrary
