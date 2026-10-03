library TPhantomDiary requires TUnit
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_PhantomDiary_Open=null
endglobals

function Trig_PhantomDiary_Open_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,udg_PhantomDiaryUnit,true,true,false))
endfunction

function Trig_PhantomDiary_Open_Actions takes nothing returns nothing
    local location l_tempPoint
    local location l_tempPoint2
    call DisableTrigger(GetTriggeringTrigger())
    set l_tempPoint=GetUnitLoc(GetTriggerUnit())
    set l_tempPoint2=OffsetLocation(l_tempPoint,-48.,48.)
    call CreateItemLoc('I07R',l_tempPoint2) // 'I07R': item "Phantom Diary Page 1"
    call SetItemInvulnerableBJ(GetLastCreatedItem(),true)
    set udg_QuestItem[31]=GetLastCreatedItem()
    call RemoveLocation(l_tempPoint2)
    set l_tempPoint2=OffsetLocation(l_tempPoint,48.,48.)
    call CreateItemLoc('I040',l_tempPoint2) // 'I040': item "Phantom Diary Page 2"
    call SetItemInvulnerableBJ(GetLastCreatedItem(),true)
    set udg_QuestItem[32]=GetLastCreatedItem()
    call RemoveLocation(l_tempPoint2)
    set l_tempPoint2=OffsetLocation(l_tempPoint,-48.,-48.)
    call CreateItemLoc('I0BR',l_tempPoint2) // 'I0BR': item "Phantom Diary Page 3"
    call SetItemInvulnerableBJ(GetLastCreatedItem(),true)
    set udg_QuestItem[33]=GetLastCreatedItem()
    call RemoveLocation(l_tempPoint2)
    set l_tempPoint2=OffsetLocation(l_tempPoint,48.,-48.)
    call CreateItemLoc('I0BS',l_tempPoint2) // 'I0BS': item "Phantom Diary Page 4"
    call SetItemInvulnerableBJ(GetLastCreatedItem(),true)
    set udg_QuestItem[34]=GetLastCreatedItem()
    call RemoveLocation(l_tempPoint2)
    call RemoveLocation(l_tempPoint)
    call KillUnit(GetTriggerUnit())
    call EnableTrigger(gg_trg_Quest_PhantomDiary_ShowAlberich)
    call DestroyTrigger(GetTriggeringTrigger())
    set l_tempPoint=null
    set l_tempPoint2=null
endfunction

// World Editor calls InitTrig_PhantomDiary automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_PhantomDiary (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_PhantomDiary takes nothing returns nothing
endfunction

function Register_PhantomDiary_Open takes nothing returns nothing
    set gg_trg_PhantomDiary_Open=CreateTrigger()
    call DisableTrigger(gg_trg_PhantomDiary_Open)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_PhantomDiary_Open,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_PhantomDiary_Open,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_PhantomDiary_Open,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_PhantomDiary_Open,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_PhantomDiary_Open,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_PhantomDiary_Open,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_PhantomDiary_Open,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_PhantomDiary_Open,Player(7),true)
    call TriggerAddCondition(gg_trg_PhantomDiary_Open,Condition(function Trig_PhantomDiary_Open_Conditions))
    call TriggerAddAction(gg_trg_PhantomDiary_Open,function Trig_PhantomDiary_Open_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_PhantomDiary takes nothing returns nothing
    call Register_PhantomDiary_Open() // starts off; enabled by Quest_DivineOrder
endfunction

endlibrary
