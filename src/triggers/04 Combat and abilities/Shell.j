library TShell requires TAbil
function Trig_Shell_Cast_IsShellSpell takes nothing returns boolean
    return(GetSpellAbilityId()=='A0TZ')or(GetSpellAbilityId()=='A0L1')or(GetSpellAbilityId()=='A17N')or(GetSpellAbilityId()=='A17O')or(GetSpellAbilityId()=='A18V')or(GetSpellAbilityId()=='A0U0')or(GetSpellAbilityId()=='A0ZE')or(GetSpellAbilityId()=='A10S')or(GetSpellAbilityId()=='A11D')or(GetSpellAbilityId()=='A1FO') // 'A0TZ': ability "Shell"; 'A0L1': ability "Shell"; 'A17N': ability "Shell"; 'A17O': ability "Shell"; 'A18V': ability "Shell"; 'A0U0': ability "Choco-Shell"; 'A0ZE': ability "Deshell"; 'A10S': ability "Deshell"; 'A11D': ability "Deshell"; 'A1FO': ability "Deshell"
endfunction

function Trig_Shell_Cast_Conditions takes nothing returns boolean
    return(Trig_Shell_Cast_IsShellSpell())
endfunction

function Trig_Shell_Cast_HasSupportExpertise takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0QK',GetTriggerUnit())>0) // 'A0QK': ability "Support Expertise"
endfunction

function Trig_Shell_Cast_IsPriestShell takes nothing returns boolean
    return(GetSpellAbilityId()=='A0TZ') // 'A0TZ': ability "Shell"
endfunction

function Trig_Shell_Cast_HasAutoShell takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A15R',GetSpellTargetUnit())>0) // 'A15R': ability "Auto-Shell"
endfunction

function Trig_Shell_Cast_Actions takes nothing returns nothing
    call UnitRemoveBuffBJ('B005',GetSpellTargetUnit()) // 'B005': buff "Shell"
    call UnitRemoveBuffBJ('B08S',GetSpellTargetUnit()) // 'B08S': buff "Shellra"
    call UnitRemoveBuffBJ('B07H',GetSpellTargetUnit()) // 'B07H': buff "Shell"
    call UnitRemoveBuffBJ('B06K',GetSpellTargetUnit()) // 'B06K': buff tooltip "Deshell"
    if(Trig_Shell_Cast_HasAutoShell())then
        call GroupAddUnitSimple(GetSpellTargetUnit(),udg_ActiveHeroGroup)
        call StartTimerBJ(udg_HeroRefreshTimer,false,.01)
    else
        if(Trig_Shell_Cast_IsPriestShell())then
            set udg_TempPoint=GetUnitLoc(GetSpellTargetUnit())
            call CreateNUnitsAtLocFacingLocBJ(1,'h02S',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,udg_TempPoint) // 'h02S': unit "Simple Casting Dummy"
            call RemoveLocation(udg_TempPoint)
            call ShowUnitHide(GetLastCreatedUnit())
            call UnitApplyTimedLifeBJ(2.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
            if(Trig_Shell_Cast_HasSupportExpertise())then
                call UnitAddAbilityBJ('A0RZ',GetLastCreatedUnit()) // 'A0RZ': ability "Shellra"
                call SetUnitAbilityLevelSwapped('A0RZ',GetLastCreatedUnit(),GetUnitAbilityLevelSwapped(GetSpellAbilityId(),GetTriggerUnit())) // 'A0RZ': ability "Shellra"
            else
                call UnitAddAbilityBJ('A179',GetLastCreatedUnit()) // 'A179': ability "Shell"
                call SetUnitAbilityLevelSwapped('A179',GetLastCreatedUnit(),GetUnitAbilityLevelSwapped(GetSpellAbilityId(),GetTriggerUnit())) // 'A179': ability "Shell"
            endif
            call IssueTargetOrderBJ(GetLastCreatedUnit(),"drunkenhaze",GetSpellTargetUnit())
        endif
    endif
endfunction

function Trig_Shell_AI_Cast_IsShellSpell takes nothing returns boolean
    return(GetSpellAbilityId()=='A0AB')or(GetSpellAbilityId()=='A057')or(GetSpellAbilityId()=='A0EF')or(GetSpellAbilityId()=='A08H')or(GetSpellAbilityId()=='A0UB')or(GetSpellAbilityId()=='A0UD') // 'A0AB': ability "Choco-Shell"; 'A057': ability "Shell"; 'A0EF': ability "Shell"; 'A08H': ability "Shell"; 'A0UB': ability "Wall"; 'A0UD': ability "Wall"
endfunction

function Trig_Shell_AI_Cast_Conditions takes nothing returns boolean
    return(Trig_Shell_AI_Cast_IsShellSpell())
endfunction

function Trig_Shell_AI_Cast_Actions takes nothing returns nothing
    call UnitRemoveBuffBJ('B005',GetSpellTargetUnit()) // 'B005': buff "Shell"
    call UnitRemoveBuffBJ('B08S',GetSpellTargetUnit()) // 'B08S': buff "Shellra"
    call UnitRemoveBuffBJ('B07H',GetSpellTargetUnit()) // 'B07H': buff "Shell"
    call UnitRemoveBuffBJ('B06K',GetSpellTargetUnit()) // 'B06K': buff tooltip "Deshell"
    set udg_TempInteger=(BlzGetAbilityManaCost(GetSpellAbilityId(),Abil_GetLevel(GetTriggerUnit(),GetSpellAbilityId())))
    // Result 1: (udg_TempInteger) minus (80).
    // Result 2: (result 1) divided by (20); drop the remainder.
    // Result 3: (GetUnitAbilityLevelSwapped(GetSpellAbilityId(), the triggering unit)) minus (1).
    // Result 4: (result 2) plus (result 3).
    // Result 5: the larger of (1) and (result 4).
    // Result 6: the smaller of (10) and (result 5).
    set udg_TempInteger=IMinBJ($A,IMaxBJ(1,(((udg_TempInteger-80)/ 20)+(GetUnitAbilityLevelSwapped(GetSpellAbilityId(),GetTriggerUnit())-1)))) // $A = 10
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    set udg_TempPoint2=GetUnitLoc(GetSpellTargetUnit())
    call CreateNUnitsAtLocFacingLocBJ(1,'h02S',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,udg_TempPoint2) // 'h02S': unit "Simple Casting Dummy"
    call RemoveLocation(udg_TempPoint2)
    call RemoveLocation(udg_TempPoint)
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(2.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A179',GetLastCreatedUnit()) // 'A179': ability "Shell"
    call SetUnitAbilityLevelSwapped('A179',GetLastCreatedUnit(),udg_TempInteger) // 'A179': ability "Shell"
    call IssueTargetOrderBJ(GetLastCreatedUnit(),"drunkenhaze",GetSpellTargetUnit())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Shell takes nothing returns nothing
endfunction
function RegisterR11_Shell_Cast takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Shell_Cast=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Shell_Cast,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Shell_Cast,Condition(function Trig_Shell_Cast_Conditions))
    call TriggerAddAction(gg_trg_Shell_Cast,function Trig_Shell_Cast_Actions)
endfunction
function RegisterR11_Shell_AI_Cast takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Shell_AI_Cast=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Shell_AI_Cast,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Shell_AI_Cast,Condition(function Trig_Shell_AI_Cast_Conditions))
    call TriggerAddAction(gg_trg_Shell_AI_Cast,function Trig_Shell_AI_Cast_Actions)
endfunction




endlibrary
