library TAnnoyingMonster
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_AnnoyingMonster_DropBelongings=null
endglobals

function Trig_AnnoyingMonster_DropBelongings_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    set udg_QuestItem[23]=CreateItemLoc('ktrm',udg_TempPoint) // 'ktrm': item "A Lady's Belongings"
    call SetItemInvulnerableBJ(GetLastCreatedItem(),true)
    call RemoveLocation(udg_TempPoint)
    call EnableTrigger(gg_trg_Belongings_Ping)
    call EnableTrigger(gg_trg_Belongings_PickedUp)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_AnnoyingMonster automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_AnnoyingMonster (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_AnnoyingMonster takes nothing returns nothing
endfunction

function Register_AnnoyingMonster_DropBelongings takes nothing returns nothing
    set gg_trg_AnnoyingMonster_DropBelongings=CreateTrigger()
    call DisableTrigger(gg_trg_AnnoyingMonster_DropBelongings)
    call TriggerAddAction(gg_trg_AnnoyingMonster_DropBelongings,function Trig_AnnoyingMonster_DropBelongings_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_AnnoyingMonster takes nothing returns nothing
    call Register_AnnoyingMonster_DropBelongings()
endfunction

endlibrary
