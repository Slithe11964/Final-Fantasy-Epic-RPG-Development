library THarpy requires TUnit, TWait
function Trig_Harpy_Matriarch_CallAid_MatriarchInCombat takes nothing returns boolean
    return(GetTriggerUnit()==udg_HarpyMatriarch)or(GetAttacker()==udg_HarpyMatriarch)
endfunction

function Trig_Harpy_Matriarch_CallAid_Conditions takes nothing returns boolean
    return(Trig_Harpy_Matriarch_CallAid_MatriarchInCombat())
endfunction

function Trig_Harpy_Matriarch_CallAid_SummonHarpyAid takes nothing returns nothing
    call IssuePointOrderLocBJ(GetEnumUnit(),"attack",udg_TempPoint)
    set udg_TempPoint2=GetUnitLoc(GetEnumUnit())
    call CreateNUnitsAtLoc(1,'n0L0',Player($B),udg_TempPoint2,bj_UNIT_FACING) // 'n0L0': unit "Harpy Trickster"; $B = 11
    call RemoveLocation(udg_TempPoint2)
    call Unit_ScaleToLevel60(bj_lastCreatedUnit)
    call GroupAddUnitSimple(GetLastCreatedUnit(),udg_HarpyTricksters)
    call ShowUnitHide(GetLastCreatedUnit())
    call PauseUnitBJ(true,GetLastCreatedUnit())
endfunction

function Trig_Harpy_Matriarch_CallAid_RevealHarpyAid takes nothing returns nothing
    call ShowUnitShow(GetEnumUnit())
    call PauseUnitBJ(false,GetEnumUnit())
endfunction

function Trig_Harpy_Matriarch_CallAid_AidGroupEmpty takes nothing returns boolean
    return(IsUnitGroupEmptyBJ(udg_HarpyTricksters))
endfunction

function Trig_Harpy_Matriarch_CallAid_AidGroupNotEmpty takes nothing returns boolean
    return(IsUnitGroupEmptyBJ(udg_HarpyTricksters)==false)
endfunction

function Trig_Harpy_Matriarch_CallAid_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    if(Trig_Harpy_Matriarch_CallAid_AidGroupNotEmpty())then
        set udg_TempGroup=CreateGroup()
        call GroupAddGroup(udg_HarpyTricksters,udg_TempGroup)
        call GroupClear(udg_HarpyTricksters)
        set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
        call ForGroupBJ(udg_TempGroup,function Trig_Harpy_Matriarch_CallAid_SummonHarpyAid)
        call DestroyGroup(udg_TempGroup)
        call RemoveLocation(udg_TempPoint)
        call Wait_Polled(120.)
        if(Trig_Harpy_Matriarch_CallAid_AidGroupEmpty())then
            call DestroyGroup(udg_HarpyTricksters)
            call DestroyTrigger(GetTriggeringTrigger())
        else
            call ForGroupBJ(udg_HarpyTricksters,function Trig_Harpy_Matriarch_CallAid_RevealHarpyAid)
            call EnableTrigger(GetTriggeringTrigger())
        endif
    else
        call DestroyGroup(udg_HarpyTricksters)
        call DestroyTrigger(GetTriggeringTrigger())
    endif
endfunction

function Trig_Harpy_Trickster_Cleanup_Conditions takes nothing returns boolean
    return(IsUnitInGroup(GetTriggerUnit(),udg_HarpyTricksters))
endfunction

function Trig_Harpy_Trickster_Cleanup_Actions takes nothing returns nothing
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_HarpyTricksters)
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Harpy takes nothing returns nothing
endfunction

function RegisterR11_Harpy_Matriarch_CallAid takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Harpy_Matriarch_CallAid=CreateTrigger()

call DisableTrigger(gg_trg_Harpy_Matriarch_CallAid)

call TriggerRegisterAnyUnitEventBJ(gg_trg_Harpy_Matriarch_CallAid,EVENT_PLAYER_UNIT_ATTACKED)

call TriggerAddCondition(gg_trg_Harpy_Matriarch_CallAid,Condition(function Trig_Harpy_Matriarch_CallAid_Conditions))

call TriggerAddAction(gg_trg_Harpy_Matriarch_CallAid,function Trig_Harpy_Matriarch_CallAid_Actions)

endfunction




function RegisterR11_Harpy_Trickster_Cleanup takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Harpy_Trickster_Cleanup=CreateTrigger()

call DisableTrigger(gg_trg_Harpy_Trickster_Cleanup)

call TriggerRegisterAnyUnitEventBJ(gg_trg_Harpy_Trickster_Cleanup,EVENT_PLAYER_UNIT_CHANGE_OWNER)

call TriggerRegisterPlayerUnitEventSimple(gg_trg_Harpy_Trickster_Cleanup,Player($B),EVENT_PLAYER_UNIT_DEATH) // $B = 11

call TriggerAddCondition(gg_trg_Harpy_Trickster_Cleanup,Condition(function Trig_Harpy_Trickster_Cleanup_Conditions))

call TriggerAddAction(gg_trg_Harpy_Trickster_Cleanup,function Trig_Harpy_Trickster_Cleanup_Actions)

endfunction




endlibrary
