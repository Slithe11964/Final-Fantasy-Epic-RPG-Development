library TMetaFragment
function Trig_MetaFragment_Pickup_Conditions takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='ciri') // 'ciri': item "Meta Fragment"
endfunction

function Trig_MetaFragment_Pickup_Actions takes nothing returns nothing
    set udg_MetaFragments[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_MetaFragments[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+1)
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_MetaFragment takes nothing returns nothing
endfunction

function RegisterR11_MetaFragment_Pickup takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_MetaFragment_Pickup=CreateTrigger()

call TriggerRegisterAnyUnitEventBJ(gg_trg_MetaFragment_Pickup,EVENT_PLAYER_UNIT_PICKUP_ITEM)

call TriggerAddCondition(gg_trg_MetaFragment_Pickup,Condition(function Trig_MetaFragment_Pickup_Conditions))

call TriggerAddAction(gg_trg_MetaFragment_Pickup,function Trig_MetaFragment_Pickup_Actions)

endfunction




endlibrary
