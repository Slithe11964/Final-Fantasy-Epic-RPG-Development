library TBossDarkRanger requires TWait
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Boss_DarkRanger_Death=null
endglobals

function Trig_Boss_DarkRanger_Death_Actions takes nothing returns nothing
    local location l_tempPoint
    call DisableTrigger(GetTriggeringTrigger())
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_BossUnits)
    set l_tempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateItemLoc('I036',l_tempPoint) // 'I036': item "Dark Bow"
    call CreateItemLoc('I0EV',l_tempPoint) // 'I0EV': item "Spirit Scroll"
    call RemoveLocation(l_tempPoint)
    call SetItemInvulnerableBJ(GetLastCreatedItem(),true)
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_UPDATED,"Come back to Liniel for reward.")
    call QuestSetDescriptionBJ(udg_SideQuest[28],"Come back to Liniel for reward.")
    call GroupAddUnitSimple(gg_unit_n01Y_0131,udg_BossUnits)
    call EnableTrigger(gg_trg_Quest_FallenRanger_Complete)
    call SaveIntegerBJ(1,2,'f',udg_GameStateHash)
    call Wait_Polled(5.)
    call RemoveUnit(GetTriggerUnit())
    call DestroyTrigger(GetTriggeringTrigger())
    set l_tempPoint=null
endfunction

function InitTrig_Boss_DarkRanger takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Boss_Part8 (module Boss),
// which keeps the original registration order.

function Register_Boss_DarkRanger_Death takes nothing returns nothing
    set gg_trg_Boss_DarkRanger_Death=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_DarkRanger_Death)
    call TriggerRegisterUnitEvent(gg_trg_Boss_DarkRanger_Death,gg_unit_H00Y_0022,EVENT_UNIT_DEATH)
    call TriggerAddAction(gg_trg_Boss_DarkRanger_Death,function Trig_Boss_DarkRanger_Death_Actions)
endfunction

endlibrary
