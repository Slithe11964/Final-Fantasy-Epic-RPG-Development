library TMasakados
function Trig_Masakados_Drop_Conditions takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='I0G5') // 'I0G5': item "Masakados"
endfunction

function Trig_Masakados_Drop_Actions takes nothing returns nothing
    call UnitRemoveBuffBJ('B05Q',GetTriggerUnit()) // 'B05Q': buff tooltip "Pierce"
endfunction

// World Editor calls InitTrig_Masakados automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Masakados (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Masakados takes nothing returns nothing
endfunction

function Register_Masakados_Drop takes nothing returns nothing
    set gg_trg_Masakados_Drop=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Masakados_Drop,EVENT_PLAYER_UNIT_DROP_ITEM)
    call TriggerAddCondition(gg_trg_Masakados_Drop,Condition(function Trig_Masakados_Drop_Conditions))
    call TriggerAddAction(gg_trg_Masakados_Drop,function Trig_Masakados_Drop_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Masakados takes nothing returns nothing
    call Register_Masakados_Drop()
endfunction

endlibrary
