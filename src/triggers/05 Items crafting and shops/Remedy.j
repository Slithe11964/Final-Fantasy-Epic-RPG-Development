library TRemedy
function Trig_Remedy_Use_Conditions takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='I0DI') // 'I0DI': item "Remedy"
endfunction

function Trig_Remedy_Use_Actions takes nothing returns nothing
    set udg_DispelTarget=GetTriggerUnit()
    call ConditionalTriggerExecute(gg_trg_Remove_Debuffs)
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Remedy takes nothing returns nothing
endfunction

function RegisterR11_Remedy_Use takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Remedy_Use=CreateTrigger()

call TriggerRegisterAnyUnitEventBJ(gg_trg_Remedy_Use,EVENT_PLAYER_UNIT_USE_ITEM)

call TriggerAddCondition(gg_trg_Remedy_Use,Condition(function Trig_Remedy_Use_Conditions))

call TriggerAddAction(gg_trg_Remedy_Use,function Trig_Remedy_Use_Actions)

endfunction




endlibrary
