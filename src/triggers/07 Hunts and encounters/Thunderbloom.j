library TThunderbloom
function Trig_Thunderbloom_Spawn_Actions takes nothing returns nothing
    set udg_TempPoint=GetRectCenter(gg_rct_569)
    set udg_ThunderbloomItem=CreateItemLoc('I0FN',udg_TempPoint) // 'I0FN': item "Thunderbloom Bulb"
    call RemoveLocation(udg_TempPoint)
    call EnableTrigger(gg_trg_Thunderbloom_Pickup)
endfunction

function Trig_Thunderbloom_Pickup_Conditions takes nothing returns boolean
    return(GetManipulatedItem()==udg_ThunderbloomItem)
endfunction

function Trig_Thunderbloom_Pickup_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call StartTimerBJ(udg_HerbRespawnTimer[1],false,180.)
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Thunderbloom takes nothing returns nothing
endfunction
function RegisterR11_Thunderbloom_Spawn takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Thunderbloom_Spawn=CreateTrigger()
    call TriggerRegisterTimerExpireEventBJ(gg_trg_Thunderbloom_Spawn,udg_HerbRespawnTimer[1])
    call TriggerAddAction(gg_trg_Thunderbloom_Spawn,function Trig_Thunderbloom_Spawn_Actions)
endfunction
function RegisterR11_Thunderbloom_Pickup takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Thunderbloom_Pickup=CreateTrigger()
    call DisableTrigger(gg_trg_Thunderbloom_Pickup)
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Thunderbloom_Pickup,EVENT_PLAYER_UNIT_PICKUP_ITEM)
    call TriggerAddCondition(gg_trg_Thunderbloom_Pickup,Condition(function Trig_Thunderbloom_Pickup_Conditions))
    call TriggerAddAction(gg_trg_Thunderbloom_Pickup,function Trig_Thunderbloom_Pickup_Actions)
endfunction




endlibrary
