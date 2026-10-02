library TSpellXerosBeat
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Spell_XerosBeat_Cast=null
endglobals

function Trig_Spell_XerosBeat_Cast_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A0U1') // 'A0U1': ability "Xeros Beat"
endfunction

function Trig_Spell_XerosBeat_Cast_Actions takes nothing returns nothing
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateNUnitsAtLocFacingLocBJ(1,'h01B',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,udg_TempPoint) // 'h01B': unit "Proxy Dummy"
    call RemoveLocation(udg_TempPoint)
    set udg_TempHandleId=GetHandleIdBJ(GetLastCreatedUnit())
    call SaveUnitHandleBJ(GetTriggerUnit(),0,udg_TempHandleId,udg_ProxyDamageHash)
    call SaveRealBJ(17000.,1,udg_TempHandleId,udg_ProxyDamageHash)
    call SaveIntegerBJ(2,2,udg_TempHandleId,udg_ProxyDamageHash)
    call SaveIntegerBJ(2,3,udg_TempHandleId,udg_ProxyDamageHash)
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(5.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A0QT',GetLastCreatedUnit()) // 'A0QT': ability "Fan of Knives"
    call IssueImmediateOrderBJ(GetLastCreatedUnit(),"fanofknives")
endfunction

function InitTrig_Spell_XerosBeat takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Spell_Part5 (module Spell),
// which keeps the original registration order.

function Register_Spell_XerosBeat_Cast takes nothing returns nothing
    set gg_trg_Spell_XerosBeat_Cast=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Spell_XerosBeat_Cast,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Spell_XerosBeat_Cast,Condition(function Trig_Spell_XerosBeat_Cast_Conditions))
    call TriggerAddAction(gg_trg_Spell_XerosBeat_Cast,function Trig_Spell_XerosBeat_Cast_Actions)
endfunction

endlibrary
