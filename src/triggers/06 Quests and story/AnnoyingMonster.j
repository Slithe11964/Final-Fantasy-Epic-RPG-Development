library TAnnoyingMonster
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

// Registration ownership; called at the original bootstrap positions.
function InitTrig_AnnoyingMonster takes nothing returns nothing
endfunction

function RegisterR11_AnnoyingMonster_DropBelongings takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_AnnoyingMonster_DropBelongings=CreateTrigger()

call DisableTrigger(gg_trg_AnnoyingMonster_DropBelongings)

call TriggerAddAction(gg_trg_AnnoyingMonster_DropBelongings,function Trig_AnnoyingMonster_DropBelongings_Actions)

endfunction




endlibrary
