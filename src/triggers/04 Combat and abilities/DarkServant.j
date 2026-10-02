library TDarkServant
function Trig_DarkServant_Cleanup_Conditions takes nothing returns boolean
    return(IsUnitInGroup(GetTriggerUnit(),udg_DarkServants))
endfunction

function Trig_DarkServant_Cleanup_Actions takes nothing returns nothing
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_DarkServants)
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_DarkServant takes nothing returns nothing
endfunction
function RegisterR11_DarkServant_Cleanup takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_DarkServant_Cleanup=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_DarkServant_Cleanup,EVENT_PLAYER_UNIT_DEATH)
    call TriggerAddCondition(gg_trg_DarkServant_Cleanup,Condition(function Trig_DarkServant_Cleanup_Conditions))
    call TriggerAddAction(gg_trg_DarkServant_Cleanup,function Trig_DarkServant_Cleanup_Actions)
endfunction




endlibrary
