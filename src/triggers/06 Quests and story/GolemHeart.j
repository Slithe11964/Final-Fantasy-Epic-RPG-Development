library TGolemHeart requires TForce
function Trig_GolemHeart_Ping_Conditions takes nothing returns boolean
    return(udg_QuestItem[2]!=null)
endfunction

function Trig_GolemHeart_Ping_Cond_HeartCarried takes nothing returns boolean
    return(IsItemOwned(udg_QuestItem[2]))
endfunction

function Trig_GolemHeart_Ping_Actions takes nothing returns nothing
    if(Trig_GolemHeart_Ping_Cond_HeartCarried())then
        set udg_TempPoint=GetUnitLoc(gg_unit_Hjai_0093)
    else
        set udg_TempPoint=GetItemLoc(udg_QuestItem[2])
    endif
    call PingMinimapLocForForce(GetPlayersAll(),udg_TempPoint,2.)
    call RemoveLocation(udg_TempPoint)
endfunction

function Trig_GolemHeart_Pickup_Conditions takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='I022') // 'I022': item "Mithril Golem's Heart"
endfunction

function Trig_GolemHeart_Pickup_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    set udg_TempForce=Force_OfPlayer(GetOwningPlayer(GetTriggerUnit()))
    call QuestMessageBJ(udg_TempForce,bj_QUESTMESSAGE_UPDATED,"Bring the Mithril Golem's heart to Alma.")
    call DestroyForce(udg_TempForce)
    call QuestSetDescriptionBJ(udg_SideQuest[16],"Bring the Mithril Golem's heart to Alma.")
    call EnableTrigger(gg_trg_MithrilGolem_Activate)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_GolemHeart takes nothing returns nothing
endfunction

function RegisterR11_GolemHeart_Ping takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_GolemHeart_Ping=CreateTrigger()

call DisableTrigger(gg_trg_GolemHeart_Ping)

call TriggerRegisterTimerEventPeriodic(gg_trg_GolemHeart_Ping,15.)

call TriggerAddCondition(gg_trg_GolemHeart_Ping,Condition(function Trig_GolemHeart_Ping_Conditions))

call TriggerAddAction(gg_trg_GolemHeart_Ping,function Trig_GolemHeart_Ping_Actions)

endfunction




function RegisterR11_GolemHeart_Pickup takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_GolemHeart_Pickup=CreateTrigger()

call DisableTrigger(gg_trg_GolemHeart_Pickup)

call TriggerRegisterAnyUnitEventBJ(gg_trg_GolemHeart_Pickup,EVENT_PLAYER_UNIT_PICKUP_ITEM)

call TriggerAddCondition(gg_trg_GolemHeart_Pickup,Condition(function Trig_GolemHeart_Pickup_Conditions))

call TriggerAddAction(gg_trg_GolemHeart_Pickup,function Trig_GolemHeart_Pickup_Actions)

endfunction




endlibrary
