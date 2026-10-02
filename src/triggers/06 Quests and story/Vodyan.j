library TVodyan
function Trig_Vodyan_Death_DropTiara_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_BossUnits)
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    set udg_QuestItem[22]=CreateItemLoc('I038',udg_TempPoint) // 'I038': item "Tiara of the Deep"
    call SetItemInvulnerableBJ(GetLastCreatedItem(),true)
    call RemoveLocation(udg_TempPoint)
    call EnableTrigger(gg_trg_Tiara_Ping)
    call EnableTrigger(gg_trg_Quest_SpiritOfWater_Complete)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Vodyan takes nothing returns nothing
endfunction
function RegisterR11_Vodyan_Death_DropTiara takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Vodyan_Death_DropTiara=CreateTrigger()
    call DisableTrigger(gg_trg_Vodyan_Death_DropTiara)
    call TriggerRegisterUnitEvent(gg_trg_Vodyan_Death_DropTiara,gg_unit_n023_0121,EVENT_UNIT_DEATH)
    call TriggerAddAction(gg_trg_Vodyan_Death_DropTiara,function Trig_Vodyan_Death_DropTiara_Actions)
endfunction




endlibrary
