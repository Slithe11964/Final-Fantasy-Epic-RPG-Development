library TSpellDewall
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Spell_Dewall_Apply=null
endglobals

function Trig_Spell_Dewall_Apply_IsDewallSpell takes nothing returns boolean
    return(GetSpellAbilityId()=='A1DT')or(GetSpellAbilityId()=='A12D') // 'A1DT': ability "Cie'Mar Putrescence"; 'A12D': ability "Dewall"
endfunction

function Trig_Spell_Dewall_Apply_Conditions takes nothing returns boolean
    return(Trig_Spell_Dewall_Apply_IsDewallSpell())
endfunction

function Trig_Spell_Dewall_Apply_Actions takes nothing returns nothing
    local location l_tempPoint2
    set l_tempPoint2=GetUnitLoc(GetSpellTargetUnit())
    call CreateNUnitsAtLocFacingLocBJ(1,'h02S',GetOwningPlayer(GetTriggerUnit()),l_tempPoint2,l_tempPoint2) // 'h02S': unit "Simple Casting Dummy"
    call RemoveLocation(l_tempPoint2)
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(2.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A10S',GetLastCreatedUnit()) // 'A10S': ability "Deshell"
    call IssueTargetOrderBJ(GetLastCreatedUnit(),"faeriefire",GetSpellTargetUnit())
    set l_tempPoint2=null
endfunction

function InitTrig_Spell_Dewall takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Spell_Part2 (module Spell),
// which keeps the original registration order.

function Register_Spell_Dewall_Apply takes nothing returns nothing
    set gg_trg_Spell_Dewall_Apply=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Spell_Dewall_Apply,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Spell_Dewall_Apply,Condition(function Trig_Spell_Dewall_Apply_Conditions))
    call TriggerAddAction(gg_trg_Spell_Dewall_Apply,function Trig_Spell_Dewall_Apply_Actions)
endfunction

endlibrary
