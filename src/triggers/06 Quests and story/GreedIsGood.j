library TGreedIsGood
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_GreedIsGood_DropStone=null
endglobals

function Trig_GreedIsGood_DropStone_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_BossUnits)
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    set udg_QuestItem[21]=CreateItemLoc('I034',udg_TempPoint) // 'I034': item "Portal Stone"
    call RemoveLocation(udg_TempPoint)
    call EnableTrigger(gg_trg_PortalStone_Ping)
    call EnableTrigger(gg_trg_PortalStone_PickedUp)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_GreedIsGood automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_GreedIsGood (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_GreedIsGood takes nothing returns nothing
endfunction

function Register_GreedIsGood_DropStone takes nothing returns nothing
    set gg_trg_GreedIsGood_DropStone=CreateTrigger()
    call DisableTrigger(gg_trg_GreedIsGood_DropStone)
    call TriggerRegisterUnitEvent(gg_trg_GreedIsGood_DropStone,gg_unit_nmgv_0115,EVENT_UNIT_DEATH)
    call TriggerAddAction(gg_trg_GreedIsGood_DropStone,function Trig_GreedIsGood_DropStone_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_GreedIsGood takes nothing returns nothing
    call Register_GreedIsGood_DropStone() // starts off; enabled by Quest_GreedIsGood
endfunction

endlibrary
