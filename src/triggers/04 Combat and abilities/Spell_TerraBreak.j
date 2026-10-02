library TSpellTerraBreak
function Trig_Spell_TerraBreak_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A0W3') // 'A0W3': ability "!Terra Break"
endfunction

function Trig_Spell_TerraBreak_Cond_NoTargetUnit takes nothing returns boolean
    return(GetSpellTargetUnit()==null)
endfunction

function Trig_Spell_TerraBreak_Actions takes nothing returns nothing
    if(Trig_Spell_TerraBreak_Cond_NoTargetUnit())then
        set udg_TempPoint=GetSpellTargetLoc()
    else
        set udg_TempPoint=GetUnitLoc(GetSpellTargetUnit())
    endif
    call CreateNUnitsAtLocFacingLocBJ(1,'h01B',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,udg_TempPoint) // 'h01B': unit "Proxy Dummy"
    set udg_TempHandleId=GetHandleIdBJ(GetLastCreatedUnit())
    call SaveUnitHandleBJ(GetTriggerUnit(),0,udg_TempHandleId,udg_ProxyDamageHash)
    call SaveRealBJ(9999.,1,udg_TempHandleId,udg_ProxyDamageHash)
    call SaveIntegerBJ(2,2,udg_TempHandleId,udg_ProxyDamageHash)
    call SaveIntegerBJ(6,3,udg_TempHandleId,udg_ProxyDamageHash)
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(15.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A0JY',GetLastCreatedUnit()) // 'A0JY': ability "Terra Break"
    call IssuePointOrderLocBJ(GetLastCreatedUnit(),"blizzard",udg_TempPoint)
    call RemoveLocation(udg_TempPoint)
endfunction

function InitTrig_Spell_TerraBreak takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Spell_Part4 (module Spell),
// which keeps the original registration order.

function Register_Spell_TerraBreak takes nothing returns nothing
    set gg_trg_Spell_TerraBreak=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Spell_TerraBreak,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Spell_TerraBreak,Condition(function Trig_Spell_TerraBreak_Conditions))
    call TriggerAddAction(gg_trg_Spell_TerraBreak,function Trig_Spell_TerraBreak_Actions)
endfunction

endlibrary
