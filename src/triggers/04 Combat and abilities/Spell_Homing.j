library TSpellHoming
function Trig_Spell_Homing_Rockets_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A170') // 'A170': ability "Homing Rockets"
endfunction

function Trig_Spell_Homing_Rockets_Actions takes nothing returns nothing
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateNUnitsAtLocFacingLocBJ(1,'h01B',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,udg_TempPoint) // 'h01B': unit "Proxy Dummy"
    call RemoveLocation(udg_TempPoint)
    set udg_TempHandleId=GetHandleIdBJ(GetLastCreatedUnit())
    call SaveUnitHandleBJ(GetTriggerUnit(),0,udg_TempHandleId,udg_ProxyDamageHash)
    call SaveRealBJ(26000.,1,udg_TempHandleId,udg_ProxyDamageHash)
    call SaveIntegerBJ(2,2,udg_TempHandleId,udg_ProxyDamageHash)
    call SaveIntegerBJ(2,3,udg_TempHandleId,udg_ProxyDamageHash)
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(5.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A172',GetLastCreatedUnit()) // 'A172': ability "Homing Rockets"
    call IssueImmediateOrderBJ(GetLastCreatedUnit(),"fanofknives")
endfunction

function InitTrig_Spell_Homing takes nothing returns nothing
endfunction

endlibrary
