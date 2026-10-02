library THaste
function Trig_Haste_Slow_Cast_IsHasteOrSlow takes nothing returns boolean
    return(GetSpellAbilityId()=='A01D')or(GetSpellAbilityId()=='A0D9')or(GetSpellAbilityId()=='A059')or(GetSpellAbilityId()=='A0ED')or(GetSpellAbilityId()=='A17L')or(GetSpellAbilityId()=='A17M')or(GetSpellAbilityId()=='A18Y')or(GetSpellAbilityId()=='ACbl')or(GetSpellAbilityId()=='ACbb')or(GetSpellAbilityId()=='A1F5')or(GetSpellAbilityId()=='A0EV')or(GetSpellAbilityId()=='A0A7')or(GetSpellAbilityId()=='A0ZF')or(GetSpellAbilityId()=='A01E')or(GetSpellAbilityId()=='A0DA')or(GetSpellAbilityId()=='A09D')or(GetSpellAbilityId()=='Aslo')or(GetSpellAbilityId()=='ACsw')or(GetSpellAbilityId()=='A1FK')or(GetSpellAbilityId()=='A0ZG') // 'A01D': ability "Haste"; 'A0D9': ability "Chocobo Haste"; 'A059': ability "Haste"; 'A0ED': ability "Haste"; 'A17L': ability "Haste"; 'A17M': ability "Haste"; 'A18Y': ability "Haste"; 'ACbl': ability "Haste"; 'ACbb': ability "Haste"; 'A1F5': ability "Haste"; 'A0EV': ability "Haste"; 'A0A7': ability "Hastega"; 'A0ZF': ability "Haste"; 'A01E': ability "Slow"; 'A0DA': ability "Chocobo Slow"; 'A09D': ability "Slow"; 'Aslo': ability "Slow"; 'ACsw': ability "Slow"; 'A1FK': ability "Slow"; 'A0ZG': ability "Slow"
endfunction

function Trig_Haste_Slow_Cast_Conditions takes nothing returns boolean
    return(Trig_Haste_Slow_Cast_IsHasteOrSlow())
endfunction

function Trig_Haste_Slow_Cast_HasSupportExpertiseSlow takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0QK',GetTriggerUnit())>0) // 'A0QK': ability "Support Expertise"
endfunction

function Trig_Haste_Slow_Cast_IsTimeMageSlow takes nothing returns boolean
    return(GetSpellAbilityId()=='A01E') // 'A01E': ability "Slow"
endfunction

function Trig_Haste_Slow_Cast_HasSupportExpertise takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0QK',GetTriggerUnit())>0) // 'A0QK': ability "Support Expertise"
endfunction

function Trig_Haste_Slow_Cast_IsTimeMageHaste takes nothing returns boolean
    return(GetSpellAbilityId()=='A01D') // 'A01D': ability "Haste"
endfunction

function Trig_Haste_Slow_Cast_HasAutoHaste takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0GJ',GetSpellTargetUnit())>0) // 'A0GJ': ability "Auto-Haste"
endfunction

function Trig_Haste_Slow_Cast_Actions takes nothing returns nothing
    call UnitRemoveBuffBJ('B00F',GetSpellTargetUnit()) // 'B00F': buff "Haste"
    call UnitRemoveBuffBJ('B08T',GetSpellTargetUnit()) // 'B08T': buff "Hastera"
    call UnitRemoveBuffBJ('B07F',GetSpellTargetUnit()) // 'B07F': buff "Haste"
    call UnitRemoveBuffBJ('Bslo',GetSpellTargetUnit()) // 'Bslo': buff tooltip "Slow"
    if(Trig_Haste_Slow_Cast_HasAutoHaste())then
        call GroupAddUnitSimple(GetSpellTargetUnit(),udg_ActiveHeroGroup)
        call StartTimerBJ(udg_HeroRefreshTimer,false,.01)
    else
        if(Trig_Haste_Slow_Cast_IsTimeMageHaste())then
            set udg_TempPoint=GetUnitLoc(GetSpellTargetUnit())
            call CreateNUnitsAtLocFacingLocBJ(1,'h02S',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,udg_TempPoint) // 'h02S': unit "Simple Casting Dummy"
            call RemoveLocation(udg_TempPoint)
            call ShowUnitHide(GetLastCreatedUnit())
            call UnitApplyTimedLifeBJ(2.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
            if(Trig_Haste_Slow_Cast_HasSupportExpertise())then
                call UnitAddAbilityBJ('A0TI',GetLastCreatedUnit()) // 'A0TI': ability "Hastera"
                call SetUnitAbilityLevelSwapped('A0TI',GetLastCreatedUnit(),GetUnitAbilityLevelSwapped(GetSpellAbilityId(),GetTriggerUnit())) // 'A0TI': ability "Hastera"
            else
                call UnitAddAbilityBJ('A162',GetLastCreatedUnit()) // 'A162': ability "Haste"
                call SetUnitAbilityLevelSwapped('A162',GetLastCreatedUnit(),GetUnitAbilityLevelSwapped(GetSpellAbilityId(),GetTriggerUnit())) // 'A162': ability "Haste"
            endif
            call IssueTargetOrderBJ(GetLastCreatedUnit(),"bloodlust",GetSpellTargetUnit())
        else
            if(Trig_Haste_Slow_Cast_IsTimeMageSlow())then
                set udg_TempPoint=GetUnitLoc(GetSpellTargetUnit())
                call CreateNUnitsAtLocFacingLocBJ(1,'h02S',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,udg_TempPoint) // 'h02S': unit "Simple Casting Dummy"
                call RemoveLocation(udg_TempPoint)
                call ShowUnitHide(GetLastCreatedUnit())
                call UnitApplyTimedLifeBJ(2.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
                if(Trig_Haste_Slow_Cast_HasSupportExpertiseSlow())then
                    call UnitAddAbilityBJ('A15N',GetLastCreatedUnit()) // 'A15N': ability "Slowra"
                    call SetUnitAbilityLevelSwapped('A15N',GetLastCreatedUnit(),GetUnitAbilityLevelSwapped(GetSpellAbilityId(),GetTriggerUnit())) // 'A15N': ability "Slowra"
                else
                    call UnitAddAbilityBJ('A1FB',GetLastCreatedUnit()) // 'A1FB': ability "Slow"
                    call SetUnitAbilityLevelSwapped('A1FB',GetLastCreatedUnit(),GetUnitAbilityLevelSwapped(GetSpellAbilityId(),GetTriggerUnit())) // 'A1FB': ability "Slow"
                endif
                call IssueTargetOrderBJ(GetLastCreatedUnit(),"slow",GetSpellTargetUnit())
            endif
        endif
    endif
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Haste takes nothing returns nothing
endfunction

function RegisterR11_Haste_Slow_Cast takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Haste_Slow_Cast=CreateTrigger()

call TriggerRegisterAnyUnitEventBJ(gg_trg_Haste_Slow_Cast,EVENT_PLAYER_UNIT_SPELL_EFFECT)

call TriggerAddCondition(gg_trg_Haste_Slow_Cast,Condition(function Trig_Haste_Slow_Cast_Conditions))

call TriggerAddAction(gg_trg_Haste_Slow_Cast,function Trig_Haste_Slow_Cast_Actions)

endfunction




endlibrary
