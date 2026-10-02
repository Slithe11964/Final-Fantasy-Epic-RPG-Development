library TImmobilize
function Trig_Immobilize_Cast_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A1EG') // 'A1EG': ability "Immobilize"
endfunction

function Trig_Immobilize_Cast_IsHeroTarget takes nothing returns boolean
    return(IsUnitType(GetSpellTargetUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Immobilize_Cast_HasDrunkenHaze takes nothing returns boolean
    return(UnitHasBuffBJ(GetSpellTargetUnit(),'B08L')) // 'B08L': buff tooltip "Heavy"
endfunction

function Trig_Immobilize_Cast_Actions takes nothing returns nothing
    set udg_TempPoint=GetUnitLoc(GetSpellTargetUnit())
    call CreateNUnitsAtLocFacingLocBJ(1,'h02S',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,udg_TempPoint) // 'h02S': unit "Simple Casting Dummy"
    call RemoveLocation(udg_TempPoint)
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(2.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitRemoveBuffBJ('B05M',GetSpellTargetUnit()) // 'B05M': buff tooltip "Immobilize"
    if(Trig_Immobilize_Cast_HasDrunkenHaze())then
        call UnitAddAbilityBJ('A1EJ',GetLastCreatedUnit()) // 'A1EJ': ability "Immobilize"
    else
        if(Trig_Immobilize_Cast_IsHeroTarget())then
            call UnitAddAbilityBJ('A1EI',GetLastCreatedUnit()) // 'A1EI': ability "Immobilize"
        else
            call UnitAddAbilityBJ('A1EH',GetLastCreatedUnit()) // 'A1EH': ability "Immobilize"
            call SetUnitAbilityLevelSwapped('A1EH',GetLastCreatedUnit(),GetUnitAbilityLevelSwapped(GetSpellAbilityId(),GetTriggerUnit())) // 'A1EH': ability "Immobilize"
        endif
    endif
    call IssueTargetOrderBJ(GetLastCreatedUnit(),"ensnare",GetSpellTargetUnit())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Immobilize takes nothing returns nothing
endfunction
function RegisterR11_Immobilize_Cast takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Immobilize_Cast=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Immobilize_Cast,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Immobilize_Cast,Condition(function Trig_Immobilize_Cast_Conditions))
    call TriggerAddAction(gg_trg_Immobilize_Cast,function Trig_Immobilize_Cast_Actions)
endfunction




endlibrary
