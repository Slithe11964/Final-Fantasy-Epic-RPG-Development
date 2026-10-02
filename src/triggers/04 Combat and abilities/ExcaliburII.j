library TExcaliburII
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_ExcaliburII_HideRock=null
    trigger gg_trg_ExcaliburII_ShowRock=null
    trigger gg_trg_ExcaliburII_Drop=null
endglobals

function Trig_ExcaliburII_HideRock_Actions takes nothing returns nothing
    set udg_ExcaliburRockHidden=true
    call ShowDestructableBJ(false,gg_dest_LTcr_0019)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_ExcaliburII_ShowRock_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    set udg_ExcaliburRockHidden=false
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_ExcaliburII_Drop_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    set udg_TempPoint=GetDestructableLoc(GetDyingDestructable())
    call CreateItemLoc('I07M',udg_TempPoint) // 'I07M': item "Excalibur II"
    call RemoveLocation(udg_TempPoint)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_ExcaliburII automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_ExcaliburII (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_ExcaliburII takes nothing returns nothing
endfunction

function Register_ExcaliburII_HideRock takes nothing returns nothing
    set gg_trg_ExcaliburII_HideRock=CreateTrigger()
    call TriggerRegisterTimerEventSingle(gg_trg_ExcaliburII_HideRock,2.)
    call TriggerAddAction(gg_trg_ExcaliburII_HideRock,function Trig_ExcaliburII_HideRock_Actions)
endfunction

function Register_ExcaliburII_ShowRock takes nothing returns nothing
    set gg_trg_ExcaliburII_ShowRock=CreateTrigger()
    call TriggerRegisterTimerExpireEventBJ(gg_trg_ExcaliburII_ShowRock,udg_WorldEventTimer)
    call TriggerAddAction(gg_trg_ExcaliburII_ShowRock,function Trig_ExcaliburII_ShowRock_Actions)
endfunction

function Register_ExcaliburII_Drop takes nothing returns nothing
    set gg_trg_ExcaliburII_Drop=CreateTrigger()
    call DisableTrigger(gg_trg_ExcaliburII_Drop)
    call TriggerRegisterDeathEvent(gg_trg_ExcaliburII_Drop,gg_dest_LTcr_0019)
    call TriggerAddAction(gg_trg_ExcaliburII_Drop,function Trig_ExcaliburII_Drop_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_ExcaliburII takes nothing returns nothing
    call Register_ExcaliburII_HideRock()
    call Register_ExcaliburII_ShowRock()
    call Register_ExcaliburII_Drop()
endfunction

endlibrary
