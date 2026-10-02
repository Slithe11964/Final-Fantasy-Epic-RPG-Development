library TSpellDewall
function Trig_Spell_Dewall_Apply_IsDewallSpell takes nothing returns boolean
    return(GetSpellAbilityId()=='A1DT')or(GetSpellAbilityId()=='A12D') // 'A1DT': ability "Cie'Mar Putrescence"; 'A12D': ability "Dewall"
endfunction

function Trig_Spell_Dewall_Apply_Conditions takes nothing returns boolean
    return(Trig_Spell_Dewall_Apply_IsDewallSpell())
endfunction

function Trig_Spell_Dewall_Apply_Actions takes nothing returns nothing
    set udg_TempPoint2=GetUnitLoc(GetSpellTargetUnit())
    call CreateNUnitsAtLocFacingLocBJ(1,'h02S',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint2,udg_TempPoint2) // 'h02S': unit "Simple Casting Dummy"
    call RemoveLocation(udg_TempPoint2)
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(2.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A10S',GetLastCreatedUnit()) // 'A10S': ability "Deshell"
    call IssueTargetOrderBJ(GetLastCreatedUnit(),"faeriefire",GetSpellTargetUnit())
endfunction

function InitTrig_Spell_Dewall takes nothing returns nothing
endfunction

endlibrary
