library TExcaliburII
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

// Registration ownership; called at the original bootstrap positions.
function InitTrig_ExcaliburII takes nothing returns nothing
endfunction
function RegisterR11_ExcaliburII_HideRock takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_ExcaliburII_HideRock=CreateTrigger()
    call TriggerRegisterTimerEventSingle(gg_trg_ExcaliburII_HideRock,2.)
    call TriggerAddAction(gg_trg_ExcaliburII_HideRock,function Trig_ExcaliburII_HideRock_Actions)
endfunction
function RegisterR11_ExcaliburII_ShowRock takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_ExcaliburII_ShowRock=CreateTrigger()
    call TriggerRegisterTimerExpireEventBJ(gg_trg_ExcaliburII_ShowRock,udg_WorldEventTimer)
    call TriggerAddAction(gg_trg_ExcaliburII_ShowRock,function Trig_ExcaliburII_ShowRock_Actions)
endfunction
function RegisterR11_ExcaliburII_Drop takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_ExcaliburII_Drop=CreateTrigger()
    call DisableTrigger(gg_trg_ExcaliburII_Drop)
    call TriggerRegisterDeathEvent(gg_trg_ExcaliburII_Drop,gg_dest_LTcr_0019)
    call TriggerAddAction(gg_trg_ExcaliburII_Drop,function Trig_ExcaliburII_Drop_Actions)
endfunction




endlibrary
