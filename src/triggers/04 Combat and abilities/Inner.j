library TInner
function Trig_Inner_Fire_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A1BK') // 'A1BK': ability "!Inner Fire"
endfunction

function Trig_Inner_Fire_IsSelfCast takes nothing returns boolean
    return(GetTriggerUnit()==GetSpellTargetUnit())
endfunction

function Trig_Inner_Fire_Actions takes nothing returns nothing
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateNUnitsAtLocFacingLocBJ(1,'h02S',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,udg_TempPoint) // 'h02S': unit "Simple Casting Dummy"
    call RemoveLocation(udg_TempPoint)
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(1.5,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    if(Trig_Inner_Fire_IsSelfCast())then
        call UnitAddAbilityBJ('A1BL',GetLastCreatedUnit()) // 'A1BL': ability "Inner Fire"
        call SetUnitAbilityLevelSwapped('A1BL',GetLastCreatedUnit(),GetUnitAbilityLevelSwapped(GetSpellAbilityId(),GetTriggerUnit())) // 'A1BL': ability "Inner Fire"
        call IssueTargetOrderBJ(GetLastCreatedUnit(),"bloodlust",GetTriggerUnit())
    else
        call UnitAddAbilityBJ('A1B5',GetLastCreatedUnit()) // 'A1B5': ability "Inner Fire"
        call SetUnitAbilityLevelSwapped('A1B5',GetLastCreatedUnit(),GetUnitAbilityLevelSwapped(GetSpellAbilityId(),GetTriggerUnit())) // 'A1B5': ability "Inner Fire"
        call IssueTargetOrderBJ(GetLastCreatedUnit(),"bloodlust",GetTriggerUnit())
        set udg_TempPoint=GetUnitLoc(GetSpellTargetUnit())
        call CreateNUnitsAtLocFacingLocBJ(1,'h02S',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,udg_TempPoint) // 'h02S': unit "Simple Casting Dummy"
        call RemoveLocation(udg_TempPoint)
        call ShowUnitHide(GetLastCreatedUnit())
        call UnitApplyTimedLifeBJ(2.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
        call UnitAddAbilityBJ('A1B5',GetLastCreatedUnit()) // 'A1B5': ability "Inner Fire"
        call SetUnitAbilityLevelSwapped('A1B5',GetLastCreatedUnit(),GetUnitAbilityLevelSwapped(GetSpellAbilityId(),GetTriggerUnit())) // 'A1B5': ability "Inner Fire"
        call IssueTargetOrderBJ(GetLastCreatedUnit(),"bloodlust",GetSpellTargetUnit())
    endif
endfunction

// World Editor calls InitTrig_Inner automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Inner (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Inner takes nothing returns nothing
endfunction

function Register_Inner_Fire takes nothing returns nothing
    set gg_trg_Inner_Fire=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Inner_Fire,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Inner_Fire,Condition(function Trig_Inner_Fire_Conditions))
    call TriggerAddAction(gg_trg_Inner_Fire,function Trig_Inner_Fire_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Inner takes nothing returns nothing
    call Register_Inner_Fire()
endfunction

endlibrary
