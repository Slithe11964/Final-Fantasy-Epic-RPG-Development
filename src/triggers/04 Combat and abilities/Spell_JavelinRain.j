library TSpellJavelinRain
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Spell_JavelinRain_Cast=null
endglobals

function Trig_Spell_JavelinRain_Cast_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A0U2') // 'A0U2': ability "Javelin Rain"
endfunction

function Trig_Spell_JavelinRain_Cast_NoTargetUnit takes nothing returns boolean
    return(GetSpellTargetUnit()==null)
endfunction

function Trig_Spell_JavelinRain_Cast_Actions takes nothing returns nothing
    if(Trig_Spell_JavelinRain_Cast_NoTargetUnit())then
        set udg_TempPoint=GetSpellTargetLoc()
    else
        set udg_TempPoint=GetUnitLoc(GetSpellTargetUnit())
    endif
    call CreateNUnitsAtLocFacingLocBJ(1,'h01B',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,udg_TempPoint) // 'h01B': unit "Proxy Dummy"
    set udg_TempHandleId=GetHandleIdBJ(GetLastCreatedUnit())
    call SaveUnitHandleBJ(GetTriggerUnit(),0,udg_TempHandleId,udg_ProxyDamageHash)
    call SaveRealBJ(7000.,1,udg_TempHandleId,udg_ProxyDamageHash)
    call SaveIntegerBJ(2,2,udg_TempHandleId,udg_ProxyDamageHash)
    call SaveIntegerBJ(3,3,udg_TempHandleId,udg_ProxyDamageHash)
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(15.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A0X3',GetLastCreatedUnit()) // 'A0X3': ability "Meteor"
    call SetUnitAbilityLevelSwapped('A0X3',GetLastCreatedUnit(),4) // 'A0X3': ability "Meteor"
    call IssuePointOrderLocBJ(GetLastCreatedUnit(),"blizzard",udg_TempPoint)
    call RemoveLocation(udg_TempPoint)
endfunction

function InitTrig_Spell_JavelinRain takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Spell_Part5 (module Spell),
// which keeps the original registration order.

function Register_Spell_JavelinRain_Cast takes nothing returns nothing
    set gg_trg_Spell_JavelinRain_Cast=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Spell_JavelinRain_Cast,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Spell_JavelinRain_Cast,Condition(function Trig_Spell_JavelinRain_Cast_Conditions))
    call TriggerAddAction(gg_trg_Spell_JavelinRain_Cast,function Trig_Spell_JavelinRain_Cast_Actions)
endfunction

endlibrary
