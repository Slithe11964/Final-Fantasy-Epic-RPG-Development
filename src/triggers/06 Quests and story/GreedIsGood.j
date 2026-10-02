library TGreedIsGood
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

// Registration ownership; called at the original bootstrap positions.
function InitTrig_GreedIsGood takes nothing returns nothing
endfunction

function RegisterR11_GreedIsGood_DropStone takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_GreedIsGood_DropStone=CreateTrigger()

call DisableTrigger(gg_trg_GreedIsGood_DropStone)

call TriggerRegisterUnitEvent(gg_trg_GreedIsGood_DropStone,gg_unit_nmgv_0115,EVENT_UNIT_DEATH)

call TriggerAddAction(gg_trg_GreedIsGood_DropStone,function Trig_GreedIsGood_DropStone_Actions)

endfunction




endlibrary
