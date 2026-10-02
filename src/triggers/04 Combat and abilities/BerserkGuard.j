library TBerserkGuard
function Trig_BerserkGuard_Decay_Conditions takes nothing returns boolean
    return(IsUnitInGroup(GetTriggerUnit(),udg_BerserkGuards))
endfunction

function Trig_BerserkGuard_Decay_Actions takes nothing returns nothing
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_BerserkGuards)
    call RemoveUnit(GetTriggerUnit())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_BerserkGuard takes nothing returns nothing
endfunction

function RegisterR11_BerserkGuard_Decay takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_BerserkGuard_Decay=CreateTrigger()

call DisableTrigger(gg_trg_BerserkGuard_Decay)

call TriggerAddCondition(gg_trg_BerserkGuard_Decay,Condition(function Trig_BerserkGuard_Decay_Conditions))

call TriggerAddAction(gg_trg_BerserkGuard_Decay,function Trig_BerserkGuard_Decay_Actions)

endfunction




endlibrary
