library TAngbar requires TPlayerPart01
function Trig_Angbar_Pickup_Conditions takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='I0HU')and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(GetTriggerUnit()==Player_GetHero(GetOwningPlayer(GetTriggerUnit()))) // 'I0HU': item "Angbar"
endfunction

function Trig_Angbar_Pickup_Actions takes nothing returns nothing
    call StartTimerBJ(udg_PostReviveTimer,false,.01)
endfunction

function Trig_Angbar_Drop_Conditions takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='I0HU')and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(GetTriggerUnit()==Player_GetHero(GetOwningPlayer(GetTriggerUnit()))) // 'I0HU': item "Angbar"
endfunction

function Trig_Angbar_Drop_Actions takes nothing returns nothing
    call SetUnitVertexColorBJ(GetTriggerUnit(),'d','d','d',0)
    call StartTimerBJ(udg_PostReviveTimer,false,.01)
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Angbar takes nothing returns nothing
endfunction

function RegisterR11_Angbar_Pickup takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Angbar_Pickup=CreateTrigger()

call TriggerRegisterAnyUnitEventBJ(gg_trg_Angbar_Pickup,EVENT_PLAYER_UNIT_PICKUP_ITEM)

call TriggerAddCondition(gg_trg_Angbar_Pickup,Condition(function Trig_Angbar_Pickup_Conditions))

call TriggerAddAction(gg_trg_Angbar_Pickup,function Trig_Angbar_Pickup_Actions)

endfunction




function RegisterR11_Angbar_Drop takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Angbar_Drop=CreateTrigger()

call TriggerRegisterAnyUnitEventBJ(gg_trg_Angbar_Drop,EVENT_PLAYER_UNIT_DROP_ITEM)

call TriggerAddCondition(gg_trg_Angbar_Drop,Condition(function Trig_Angbar_Drop_Conditions))

call TriggerAddAction(gg_trg_Angbar_Drop,function Trig_Angbar_Drop_Actions)

endfunction




endlibrary
