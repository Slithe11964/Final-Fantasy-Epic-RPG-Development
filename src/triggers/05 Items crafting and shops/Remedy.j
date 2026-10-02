library TRemedy
function Trig_Remedy_Use_Conditions takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='I0DI') // 'I0DI': item "Remedy"
endfunction

function Trig_Remedy_Use_Actions takes nothing returns nothing
    set udg_DispelTarget=GetTriggerUnit()
    call ConditionalTriggerExecute(gg_trg_Remove_Debuffs)
endfunction

// World Editor calls InitTrig_Remedy automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Remedy (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Remedy takes nothing returns nothing
endfunction

function Register_Remedy_Use takes nothing returns nothing
    set gg_trg_Remedy_Use=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Remedy_Use,EVENT_PLAYER_UNIT_USE_ITEM)
    call TriggerAddCondition(gg_trg_Remedy_Use,Condition(function Trig_Remedy_Use_Conditions))
    call TriggerAddAction(gg_trg_Remedy_Use,function Trig_Remedy_Use_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Remedy takes nothing returns nothing
    call Register_Remedy_Use()
endfunction

endlibrary
