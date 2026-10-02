library TOkuu
function Trig_Okuu_Leash_Conditions takes nothing returns boolean
    return(GetTriggerUnit()==udg_HuntTarget[28])and(GetOwningPlayer(GetTriggerUnit())==Player($B)) // $B = 11
endfunction

function Trig_Okuu_Leash_Actions takes nothing returns nothing
    set udg_TempPoint=GetRectCenter(gg_rct_714)
    call SetUnitPositionLocFacingBJ(GetTriggerUnit(),udg_TempPoint,270.)
    call RemoveLocation(udg_TempPoint)
endfunction

function Trig_Okuu_Death_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DisableTrigger(gg_trg_Okuu_Leash)
    call DestroyTrigger(gg_trg_Okuu_Leash)
    call GroupRemoveUnitSimple(udg_HuntTarget[28],udg_BossGroup)
    set udg_OkuuStage=2
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Okuu takes nothing returns nothing
endfunction
function RegisterR11_Okuu_Leash takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Okuu_Leash=CreateTrigger()
    call DisableTrigger(gg_trg_Okuu_Leash)
    call TriggerRegisterEnterRectSimple(gg_trg_Okuu_Leash,gg_rct_638)
    call TriggerRegisterEnterRectSimple(gg_trg_Okuu_Leash,gg_rct_631)
    call TriggerAddCondition(gg_trg_Okuu_Leash,Condition(function Trig_Okuu_Leash_Conditions))
    call TriggerAddAction(gg_trg_Okuu_Leash,function Trig_Okuu_Leash_Actions)
endfunction
function RegisterR11_Okuu_Death takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Okuu_Death=CreateTrigger()
    call TriggerAddAction(gg_trg_Okuu_Death,function Trig_Okuu_Death_Actions)
endfunction




endlibrary
