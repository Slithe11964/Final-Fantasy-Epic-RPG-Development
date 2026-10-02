library TSpellOzmeteor
function Trig_Spell_Ozmeteor_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A1BI') // 'A1BI': ability "!Ozmeteor"
endfunction

function Trig_Spell_Ozmeteor_IsPointCast takes nothing returns boolean
    return(GetSpellTargetUnit()==null)
endfunction

function Trig_Spell_Ozmeteor_Actions takes nothing returns nothing
    if(Trig_Spell_Ozmeteor_IsPointCast())then
        set udg_TempPoint=GetSpellTargetLoc()
    else
        set udg_TempPoint=GetUnitLoc(GetSpellTargetUnit())
    endif
    call CreateNUnitsAtLocFacingLocBJ(1,'h01B',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,udg_TempPoint) // 'h01B': unit "Proxy Dummy"
    set udg_TempHandleId=GetHandleIdBJ(GetLastCreatedUnit())
    call SaveUnitHandleBJ(GetTriggerUnit(),0,udg_TempHandleId,udg_ProxyDamageHash)
    // A random decimal number between 1 and 65535.
    call SaveRealBJ(GetRandomReal(1.,65535.),1,udg_TempHandleId,udg_ProxyDamageHash)
    call SaveIntegerBJ(4,2,udg_TempHandleId,udg_ProxyDamageHash)
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(4.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A0YO',GetLastCreatedUnit()) // 'A0YO': ability "Cometeorite"
    call IssuePointOrderLocBJ(GetLastCreatedUnit(),"blizzard",udg_TempPoint)
    call RemoveLocation(udg_TempPoint)
endfunction

function InitTrig_Spell_Ozmeteor takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Spell_Part6 (module Spell),
// which keeps the original registration order.

function Register_Spell_Ozmeteor takes nothing returns nothing
    set gg_trg_Spell_Ozmeteor=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Spell_Ozmeteor,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Spell_Ozmeteor,Condition(function Trig_Spell_Ozmeteor_Conditions))
    call TriggerAddAction(gg_trg_Spell_Ozmeteor,function Trig_Spell_Ozmeteor_Actions)
endfunction

endlibrary
