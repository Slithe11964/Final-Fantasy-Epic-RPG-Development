library TProtect
function Trig_Protect_Cast_IsProtectSpell takes nothing returns boolean
    return(GetSpellAbilityId()=='A00G')or(GetSpellAbilityId()=='A056')or(GetSpellAbilityId()=='ACfa')or(GetSpellAbilityId()=='A09K')or(GetSpellAbilityId()=='A0EE')or(GetSpellAbilityId()=='A0BJ')or(GetSpellAbilityId()=='A17J')or(GetSpellAbilityId()=='A17K')or(GetSpellAbilityId()=='A18W')or(GetSpellAbilityId()=='A07D')or(GetSpellAbilityId()=='A0TQ')or(GetSpellAbilityId()=='A0AA')or(GetSpellAbilityId()=='A0ZD')or(GetSpellAbilityId()=='A040')or(GetSpellAbilityId()=='A0V8')or(GetSpellAbilityId()=='A0F0')or(GetSpellAbilityId()=='A1FN')or(GetSpellAbilityId()=='A12D')or(GetSpellAbilityId()=='A1DT')or(GetSpellAbilityId()=='A0UB')or(GetSpellAbilityId()=='A0UD') // 'A00G': ability "Protect"; 'A056': ability "Protect"; 'ACfa': ability "Protect"; 'A09K': ability "Protect"; 'A0EE': ability "Protect"; 'A0BJ': ability "Protect"; 'A17J': ability "Protect"; 'A17K': ability "Protect"; 'A18W': ability "Protect"; 'A07D': ability "Protect"; 'A0TQ': ability "Ice Shield"; 'A0AA': ability "Choco-Protect"; 'A0ZD': ability "Deprotect"; 'A040': ability "Deprotect"; 'A0V8': ability "Deprotect"; 'A0F0': ability "Deprotect"; 'A1FN': ability "Deprotect"; 'A12D': ability "Dewall"; 'A1DT': ability "Cie'Mar Putrescence"; 'A0UB': ability "Wall"; 'A0UD': ability "Wall"
endfunction

function Trig_Protect_Cast_Conditions takes nothing returns boolean
    return(Trig_Protect_Cast_IsProtectSpell())
endfunction

function Trig_Protect_Cast_HasSupportExpertise takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0QK',GetTriggerUnit())>0) // 'A0QK': ability "Support Expertise"
endfunction

function Trig_Protect_Cast_IsPriestProtect takes nothing returns boolean
    return(GetSpellAbilityId()=='A00G') // 'A00G': ability "Protect"
endfunction

function Trig_Protect_Cast_HasAutoProtect takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A15P',GetSpellTargetUnit())>0) // 'A15P': ability "Auto-Protect"
endfunction

function Trig_Protect_Cast_Actions takes nothing returns nothing
    call UnitRemoveBuffBJ('B007',GetSpellTargetUnit()) // 'B007': buff "Protect"
    call UnitRemoveBuffBJ('B08R',GetSpellTargetUnit()) // 'B08R': buff "Protectra"
    call UnitRemoveBuffBJ('B07G',GetSpellTargetUnit()) // 'B07G': buff "Protect"
    call UnitRemoveBuffBJ('B06J',GetSpellTargetUnit()) // 'B06J': buff tooltip "Deprotect"
    if(Trig_Protect_Cast_HasAutoProtect())then
        call GroupAddUnitSimple(GetSpellTargetUnit(),udg_ActiveHeroGroup)
        call StartTimerBJ(udg_HeroRefreshTimer,false,.01)
    else
        if(Trig_Protect_Cast_IsPriestProtect())then
            set udg_TempPoint=GetUnitLoc(GetSpellTargetUnit())
            call CreateNUnitsAtLocFacingLocBJ(1,'h02S',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,udg_TempPoint) // 'h02S': unit "Simple Casting Dummy"
            call RemoveLocation(udg_TempPoint)
            call ShowUnitHide(GetLastCreatedUnit())
            call UnitApplyTimedLifeBJ(2.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
            if(Trig_Protect_Cast_HasSupportExpertise())then
                call UnitAddAbilityBJ('A0R4',GetLastCreatedUnit()) // 'A0R4': ability "Protectra"
                call SetUnitAbilityLevelSwapped('A0R4',GetLastCreatedUnit(),GetUnitAbilityLevelSwapped(GetSpellAbilityId(),GetTriggerUnit())) // 'A0R4': ability "Protectra"
            else
                call UnitAddAbilityBJ('A163',GetLastCreatedUnit()) // 'A163': ability "Protect"
                call SetUnitAbilityLevelSwapped('A163',GetLastCreatedUnit(),GetUnitAbilityLevelSwapped(GetSpellAbilityId(),GetTriggerUnit())) // 'A163': ability "Protect"
            endif
            call IssueTargetOrderBJ(GetLastCreatedUnit(),"frostarmor",GetSpellTargetUnit())
        endif
    endif
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Protect takes nothing returns nothing
endfunction
function RegisterR11_Protect_Cast takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Protect_Cast=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Protect_Cast,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Protect_Cast,Condition(function Trig_Protect_Cast_Conditions))
    call TriggerAddAction(gg_trg_Protect_Cast,function Trig_Protect_Cast_Actions)
endfunction




endlibrary
