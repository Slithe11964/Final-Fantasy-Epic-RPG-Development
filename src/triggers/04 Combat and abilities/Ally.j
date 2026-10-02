library TAlly
function Trig_Ally_Death_Cleanup_IsDefenderUnit takes nothing returns boolean
    return(IsUnitInGroup(GetTriggerUnit(),udg_AllyBrothersGroup))or(IsUnitInGroup(GetTriggerUnit(),udg_AllyRangerGroup))or(IsUnitInGroup(GetTriggerUnit(),udg_AllyEngineerGroup))
endfunction

function Trig_Ally_Death_Cleanup_Conditions takes nothing returns boolean
    return(Trig_Ally_Death_Cleanup_IsDefenderUnit())
endfunction

function Trig_Ally_Death_Cleanup_Actions takes nothing returns nothing
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_AllyBrothersGroup)
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_AllyRangerGroup)
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_AllyEngineerGroup)
    call GroupAddUnitSimple(GetTriggerUnit(),udg_InactiveUnits)
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Ally takes nothing returns nothing
endfunction
function RegisterR11_Ally_Death_Cleanup takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Ally_Death_Cleanup=CreateTrigger()
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_Ally_Death_Cleanup,Player(9),EVENT_PLAYER_UNIT_DEATH)
    call TriggerAddCondition(gg_trg_Ally_Death_Cleanup,Condition(function Trig_Ally_Death_Cleanup_Conditions))
    call TriggerAddAction(gg_trg_Ally_Death_Cleanup,function Trig_Ally_Death_Cleanup_Actions)
endfunction




endlibrary
