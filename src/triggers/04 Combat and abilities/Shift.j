library TShift requires TBattleLog, TGroup
function Trig_Shift_Elements_Start_Conditions takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A11N',GetTriggerUnit())>0) // 'A11N': ability "Shifting Elements"
endfunction

function Trig_Shift_Elements_Start_Actions takes nothing returns nothing
    call StartTimerBJ(udg_ShiftElementsTimer,false,8.6)
endfunction

function Trig_Shift_Elements_Roll_IsAliveFilter takes nothing returns boolean
    return(IsUnitAliveBJ(GetFilterUnit()))
endfunction

function Trig_Shift_Elements_Roll_HasShiftingElements takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A11N',GetFilterUnit())>0) // 'A11N': ability "Shifting Elements"
endfunction

function Trig_Shift_Elements_Roll_IsShiftingUnit takes nothing returns boolean
    return GetBooleanAnd(Trig_Shift_Elements_Roll_IsAliveFilter(),Trig_Shift_Elements_Roll_HasShiftingElements())
endfunction

function Trig_Shift_Elements_Roll_RolledSameElement takes nothing returns boolean
    return(udg_TempInteger>=GetUnitAbilityLevelSwapped('A11N',GetEnumUnit())) // 'A11N': ability "Shifting Elements"
endfunction

function Trig_Shift_Elements_Roll_IsVulnerable takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('Avul',GetEnumUnit())<=0) // 'Avul': standard ability reference "Invulnerable"
endfunction

function Trig_Shift_Elements_Roll_HasElementLevel takes nothing returns boolean
    return(udg_TempInteger>=1)
endfunction

function Trig_Shift_Elements_Roll_ShiftUnitElement takes nothing returns nothing
    set udg_TempInteger=GetUnitAbilityLevelSwapped('A11N',GetEnumUnit()) // 'A11N': ability "Shifting Elements"
    if(Trig_Shift_Elements_Roll_HasElementLevel())then
        call UnitRemoveAbilityBJ(udg_ElementSpellPrimary[udg_TempInteger],GetEnumUnit())
        call UnitRemoveAbilityBJ(udg_ElementSpellSecondary[udg_TempInteger],GetEnumUnit())
        // A random whole number from 1 through 5.
        set udg_TempInteger=GetRandomInt(1,5)
        if(Trig_Shift_Elements_Roll_RolledSameElement())then
            set udg_TempInteger=(udg_TempInteger+1)
        endif
        call UnitAddAbilityBJ(udg_ElementSpellPrimary[udg_TempInteger],GetEnumUnit())
        call UnitAddAbilityBJ(udg_ElementSpellSecondary[udg_TempInteger],GetEnumUnit())
        call SetUnitAbilityLevelSwapped('A11N',GetEnumUnit(),udg_TempInteger) // 'A11N': ability "Shifting Elements"
        call AddSpecialEffectTargetUnitBJ("overhead",GetEnumUnit(),"Abilities\\Spells\\Undead\\Unsummon\\UnsummonTarget.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        set udg_TempPoint=GetUnitLoc(GetEnumUnit())
        if(Trig_Shift_Elements_Roll_IsVulnerable())then
            call CreateNUnitsAtLocFacingLocBJ(1,'h02S',GetOwningPlayer(GetEnumUnit()),udg_TempPoint,udg_TempPoint) // 'h02S': unit "Simple Casting Dummy"
            call ShowUnitHide(GetLastCreatedUnit())
            call UnitApplyTimedLifeBJ(1.5,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
            call UnitAddAbilityBJ(udg_EnchantAbility[udg_TempInteger],GetLastCreatedUnit())
            call SetUnitAbilityLevelSwapped(udg_EnchantAbility[udg_TempInteger],GetLastCreatedUnit(),6)
            call IssueTargetOrderBJ(GetLastCreatedUnit(),"curse",GetEnumUnit())
        endif
        call BattleLog_ShowUnit("shifts elements!",GetEnumUnit())
        call CreateTextTagLocBJ("|cffffcc00SHIFT",udg_TempPoint,0,13.,'d','d','d',0)
        call RemoveLocation(udg_TempPoint)
        call SetTextTagVelocityBJ(GetLastCreatedTextTag(),80.,90)
        call SetTextTagPermanentBJ(GetLastCreatedTextTag(),false)
        call SetTextTagLifespanBJ(GetLastCreatedTextTag(),1.5)
        call SetTextTagFadepointBJ(GetLastCreatedTextTag(),1.)
        call ShowTextTagForceBJ(false,GetLastCreatedTextTag(),GetPlayersAll())
        call ShowTextTagForceBJ(true,GetLastCreatedTextTag(),udg_AbilityTextForce)
    endif
endfunction

function Trig_Shift_Elements_Roll_FoundShiftUnits takes nothing returns boolean
    return(IsUnitGroupEmptyBJ(udg_TempGroup)==false)
endfunction

function Trig_Shift_Elements_Roll_Actions takes nothing returns nothing
    set udg_TempGroup=Group_UnitsInRect(GetPlayableMapRect(),Condition(function Trig_Shift_Elements_Roll_IsShiftingUnit))
    if(Trig_Shift_Elements_Roll_FoundShiftUnits())then
        call StartTimerBJ(udg_ShiftElementsTimer,false,20.)
        call ForGroupBJ(udg_TempGroup,function Trig_Shift_Elements_Roll_ShiftUnitElement)
    endif
    call DestroyGroup(udg_TempGroup)
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Shift takes nothing returns nothing
endfunction
function RegisterR11_Shift_Elements_Start takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Shift_Elements_Start=CreateTrigger()
    call TriggerRegisterEnterRectSimple(gg_trg_Shift_Elements_Start,GetPlayableMapRect())
    call TriggerAddCondition(gg_trg_Shift_Elements_Start,Condition(function Trig_Shift_Elements_Start_Conditions))
    call TriggerAddAction(gg_trg_Shift_Elements_Start,function Trig_Shift_Elements_Start_Actions)
endfunction
function RegisterR11_Shift_Elements_Roll takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Shift_Elements_Roll=CreateTrigger()
    call TriggerRegisterTimerExpireEventBJ(gg_trg_Shift_Elements_Roll,udg_ShiftElementsTimer)
    call TriggerAddAction(gg_trg_Shift_Elements_Roll,function Trig_Shift_Elements_Roll_Actions)
endfunction




endlibrary
