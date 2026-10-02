library TPortalStone requires TForce
function Trig_PortalStone_Ping_Conditions takes nothing returns boolean
    return(udg_QuestItem[21]!=null)
endfunction

function Trig_PortalStone_Ping_Cond_StoneCarried takes nothing returns boolean
    return(IsItemOwned(udg_QuestItem[21]))
endfunction

function Trig_PortalStone_Ping_Actions takes nothing returns nothing
    if(Trig_PortalStone_Ping_Cond_StoneCarried())then
        set udg_TempPoint=GetUnitLoc(gg_unit_n01S_0082)
    else
        set udg_TempPoint=GetItemLoc(udg_QuestItem[21])
    endif
    call PingMinimapLocForForce(GetPlayersAll(),udg_TempPoint,2.)
    call RemoveLocation(udg_TempPoint)
endfunction

function Trig_PortalStone_PickedUp_Conditions takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='I034') // 'I034': item "Portal Stone"
endfunction

function Trig_PortalStone_PickedUp_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    set udg_TempForce=Force_OfPlayer(GetOwningPlayer(GetTriggerUnit()))
    call QuestMessageBJ(udg_TempForce,bj_QUESTMESSAGE_UPDATED,"Bring the Portal Stone to Melaniya.")
    call DestroyForce(udg_TempForce)
    call QuestSetDescriptionBJ(udg_SideQuest[27],"Bring the Portal Stone to Melaniya.")
    call EnableTrigger(gg_trg_Quest_GreedIsGood_Complete)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_PortalStone takes nothing returns nothing
endfunction
function RegisterR11_PortalStone_Ping takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_PortalStone_Ping=CreateTrigger()
    call DisableTrigger(gg_trg_PortalStone_Ping)
    call TriggerRegisterTimerEventPeriodic(gg_trg_PortalStone_Ping,15.)
    call TriggerAddCondition(gg_trg_PortalStone_Ping,Condition(function Trig_PortalStone_Ping_Conditions))
    call TriggerAddAction(gg_trg_PortalStone_Ping,function Trig_PortalStone_Ping_Actions)
endfunction
function RegisterR11_PortalStone_PickedUp takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_PortalStone_PickedUp=CreateTrigger()
    call DisableTrigger(gg_trg_PortalStone_PickedUp)
    call TriggerRegisterAnyUnitEventBJ(gg_trg_PortalStone_PickedUp,EVENT_PLAYER_UNIT_PICKUP_ITEM)
    call TriggerAddCondition(gg_trg_PortalStone_PickedUp,Condition(function Trig_PortalStone_PickedUp_Conditions))
    call TriggerAddAction(gg_trg_PortalStone_PickedUp,function Trig_PortalStone_PickedUp_Actions)
endfunction




endlibrary
