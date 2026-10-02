library TEnemy requires TUnit
function Trig_Enemy_Summon_Setup_Conditions takes nothing returns boolean
    return((IsUnitType(GetSummonedUnit(),UNIT_TYPE_RESISTANT)==false)and(IsUnitIllusionBJ(GetSummonedUnit())==false))!=null
endfunction

function Trig_Enemy_Summon_Setup_Actions takes nothing returns nothing
    call Unit_ScaleToLevel60(GetSummonedUnit())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Enemy takes nothing returns nothing
endfunction
function RegisterR11_Enemy_Summon_Setup takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Enemy_Summon_Setup=CreateTrigger()
    call DisableTrigger(gg_trg_Enemy_Summon_Setup)
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_Enemy_Summon_Setup,Player($B),EVENT_PLAYER_UNIT_SUMMON) // $B = 11
    call TriggerAddCondition(gg_trg_Enemy_Summon_Setup,Condition(function Trig_Enemy_Summon_Setup_Conditions))
    call TriggerAddAction(gg_trg_Enemy_Summon_Setup,function Trig_Enemy_Summon_Setup_Actions)
endfunction




endlibrary
