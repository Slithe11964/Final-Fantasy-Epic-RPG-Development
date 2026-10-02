library TFinalImpact
function Trig_FinalImpact_Cast_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A11E') // 'A11E': ability "!Final Impact"
endfunction

function Trig_FinalImpact_Cast_Cond_PointCast takes nothing returns boolean
    return(GetSpellTargetUnit()==null)
endfunction

function Trig_FinalImpact_Cast_Actions takes nothing returns nothing
    if(Trig_FinalImpact_Cast_Cond_PointCast())then
        set udg_TempPoint=GetSpellTargetLoc()
    else
        set udg_TempPoint=GetUnitLoc(GetSpellTargetUnit())
    endif
    call CreateNUnitsAtLocFacingLocBJ(1,'h01B',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,udg_TempPoint) // 'h01B': unit "Proxy Dummy"
    set udg_TempHandleId=GetHandleIdBJ(GetLastCreatedUnit())
    call SaveUnitHandleBJ(GetTriggerUnit(),0,udg_TempHandleId,udg_ProxyDamageHash)
    // (1000) divided by (udg_DifficultyScale).
    call SaveRealBJ((1000./ udg_DifficultyScale),1,udg_TempHandleId,udg_ProxyDamageHash)
    call SaveIntegerBJ(4,2,udg_TempHandleId,udg_ProxyDamageHash)
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(15.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A0W0',GetLastCreatedUnit()) // 'A0W0': ability "Wide Meteor"
    call IssuePointOrderLocBJ(GetLastCreatedUnit(),"blizzard",udg_TempPoint)
    call RemoveLocation(udg_TempPoint)
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_FinalImpact takes nothing returns nothing
endfunction

function RegisterR11_FinalImpact_Cast takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_FinalImpact_Cast=CreateTrigger()

call TriggerRegisterAnyUnitEventBJ(gg_trg_FinalImpact_Cast,EVENT_PLAYER_UNIT_SPELL_EFFECT)

call TriggerAddCondition(gg_trg_FinalImpact_Cast,Condition(function Trig_FinalImpact_Cast_Conditions))

call TriggerAddAction(gg_trg_FinalImpact_Cast,function Trig_FinalImpact_Cast_Actions)

endfunction




endlibrary
