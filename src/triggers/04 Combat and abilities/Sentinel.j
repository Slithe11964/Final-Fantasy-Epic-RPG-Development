library TSentinel
function Trig_Sentinel_Cast_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A0ON') // 'A0ON': ability "!Sentinel"
endfunction

function Trig_Sentinel_Cast_Actions takes nothing returns nothing
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateNUnitsAtLocFacingLocBJ(1,'h02S',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,udg_TempPoint) // 'h02S': unit "Simple Casting Dummy"
    call RemoveLocation(udg_TempPoint)
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(1.5,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A1BJ',GetLastCreatedUnit()) // 'A1BJ': ability "Sentinel"
    call SetUnitAbilityLevelSwapped('A1BJ',GetLastCreatedUnit(),GetUnitAbilityLevelSwapped(GetSpellAbilityId(),GetTriggerUnit())) // 'A1BJ': ability "Sentinel"
    call IssueTargetOrderBJ(GetLastCreatedUnit(),"bloodlust",GetTriggerUnit())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Sentinel takes nothing returns nothing
endfunction
function RegisterR11_Sentinel_Cast takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Sentinel_Cast=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Sentinel_Cast,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Sentinel_Cast,Condition(function Trig_Sentinel_Cast_Conditions))
    call TriggerAddAction(gg_trg_Sentinel_Cast,function Trig_Sentinel_Cast_Actions)
endfunction




endlibrary
