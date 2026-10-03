library TVodyan
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Vodyan_Death_DropTiara=null
endglobals

function Trig_Vodyan_Death_DropTiara_Actions takes nothing returns nothing
    local location l_tempPoint
    call DisableTrigger(GetTriggeringTrigger())
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_BossUnits)
    set l_tempPoint=GetUnitLoc(GetTriggerUnit())
    set udg_QuestItem[22]=CreateItemLoc('I038',l_tempPoint) // 'I038': item "Tiara of the Deep"
    call SetItemInvulnerableBJ(GetLastCreatedItem(),true)
    call RemoveLocation(l_tempPoint)
    call EnableTrigger(gg_trg_Tiara_Ping)
    call EnableTrigger(gg_trg_Quest_SpiritOfWater_Complete)
    call DestroyTrigger(GetTriggeringTrigger())
    set l_tempPoint=null
endfunction

// World Editor calls InitTrig_Vodyan automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Vodyan (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Vodyan takes nothing returns nothing
endfunction

function Register_Vodyan_Death_DropTiara takes nothing returns nothing
    set gg_trg_Vodyan_Death_DropTiara=CreateTrigger()
    call DisableTrigger(gg_trg_Vodyan_Death_DropTiara)
    call TriggerRegisterUnitEvent(gg_trg_Vodyan_Death_DropTiara,gg_unit_n023_0121,EVENT_UNIT_DEATH)
    call TriggerAddAction(gg_trg_Vodyan_Death_DropTiara,function Trig_Vodyan_Death_DropTiara_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Vodyan takes nothing returns nothing
    call Register_Vodyan_Death_DropTiara() // starts off; enabled by Quest_SpiritOfWater
endfunction

endlibrary
