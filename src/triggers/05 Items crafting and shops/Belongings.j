library TBelongings requires TForce
function Trig_Belongings_Ping_Conditions takes nothing returns boolean
    return(udg_QuestItem[23]!=null)
endfunction

function Trig_Belongings_Ping_Cond_BelongingsCarried takes nothing returns boolean
    return(IsItemOwned(udg_QuestItem[23]))
endfunction

function Trig_Belongings_Ping_Actions takes nothing returns nothing
    if(Trig_Belongings_Ping_Cond_BelongingsCarried())then
        set udg_TempPoint=GetUnitLoc(gg_unit_h01P_0017)
    else
        set udg_TempPoint=GetItemLoc(udg_QuestItem[23])
    endif
    call PingMinimapLocForForce(GetPlayersAll(),udg_TempPoint,2.)
    call RemoveLocation(udg_TempPoint)
endfunction

function Trig_Belongings_PickedUp_Conditions takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='ktrm') // 'ktrm': item "A Lady's Belongings"
endfunction

function Trig_Belongings_PickedUp_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call QuestMessageBJ(Force_OfPlayer(GetOwningPlayer(GetManipulatingUnit())),bj_QUESTMESSAGE_UPDATED,"Bring the belongings back to Lady Curse.")
    call QuestSetDescriptionBJ(udg_SideQuest[36],"Bring the belongings back to Lady Curse.")
    call EnableTrigger(gg_trg_LadyCurse_ReturnBelongings)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Belongings takes nothing returns nothing
endfunction

function RegisterR11_Belongings_Ping takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Belongings_Ping=CreateTrigger()

call DisableTrigger(gg_trg_Belongings_Ping)

call TriggerRegisterTimerEventPeriodic(gg_trg_Belongings_Ping,15.)

call TriggerAddCondition(gg_trg_Belongings_Ping,Condition(function Trig_Belongings_Ping_Conditions))

call TriggerAddAction(gg_trg_Belongings_Ping,function Trig_Belongings_Ping_Actions)

endfunction




function RegisterR11_Belongings_PickedUp takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Belongings_PickedUp=CreateTrigger()

call DisableTrigger(gg_trg_Belongings_PickedUp)

call TriggerRegisterAnyUnitEventBJ(gg_trg_Belongings_PickedUp,EVENT_PLAYER_UNIT_PICKUP_ITEM)

call TriggerAddCondition(gg_trg_Belongings_PickedUp,Condition(function Trig_Belongings_PickedUp_Conditions))

call TriggerAddAction(gg_trg_Belongings_PickedUp,function Trig_Belongings_PickedUp_Actions)

endfunction




endlibrary
