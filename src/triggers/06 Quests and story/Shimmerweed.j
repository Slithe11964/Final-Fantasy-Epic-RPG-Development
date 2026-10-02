library TShimmerweed
function Trig_Shimmerweed_Spawn_Actions takes nothing returns nothing
    set udg_TempPoint=GetRectCenter(gg_rct_568)
    set udg_ShimmerweedItem=CreateItemLoc('I0FM',udg_TempPoint) // 'I0FM': item "Shimmerweed"
    call RemoveLocation(udg_TempPoint)
    call EnableTrigger(gg_trg_Shimmerweed_Pickup)
endfunction

function Trig_Shimmerweed_Pickup_Conditions takes nothing returns boolean
    return(GetManipulatedItem()==udg_ShimmerweedItem)
endfunction

function Trig_Shimmerweed_Pickup_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call StartTimerBJ(udg_HerbRespawnTimer[0],false,180.)
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Shimmerweed takes nothing returns nothing
endfunction
function RegisterR11_Shimmerweed_Spawn takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Shimmerweed_Spawn=CreateTrigger()
    call TriggerRegisterTimerExpireEventBJ(gg_trg_Shimmerweed_Spawn,udg_HerbRespawnTimer[0])
    call TriggerAddAction(gg_trg_Shimmerweed_Spawn,function Trig_Shimmerweed_Spawn_Actions)
endfunction
function RegisterR11_Shimmerweed_Pickup takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Shimmerweed_Pickup=CreateTrigger()
    call DisableTrigger(gg_trg_Shimmerweed_Pickup)
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Shimmerweed_Pickup,EVENT_PLAYER_UNIT_PICKUP_ITEM)
    call TriggerAddCondition(gg_trg_Shimmerweed_Pickup,Condition(function Trig_Shimmerweed_Pickup_Conditions))
    call TriggerAddAction(gg_trg_Shimmerweed_Pickup,function Trig_Shimmerweed_Pickup_Actions)
endfunction




endlibrary
