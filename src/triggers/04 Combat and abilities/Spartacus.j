library TSpartacus requires TLoc
function Trig_Spartacus_Summon_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A1DV') // 'A1DV': ability "Summon Spartacus"
endfunction

function Trig_Spartacus_Summon_Actions takes nothing returns nothing
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,128.,GetUnitFacing(GetTriggerUnit()))
    call RemoveLocation(udg_TempPoint)
    call CreateNUnitsAtLoc(1,'u01V',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint2,GetUnitFacing(GetTriggerUnit())) // 'u01V': unit "Spartacus"
    call RemoveLocation(udg_TempPoint2)
    call UnitApplyTimedLifeBJ(30.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call AddSpecialEffectTargetUnitBJ("origin",GetLastCreatedUnit(),"Abilities\\Spells\\Undead\\RaiseSkeletonWarrior\\RaiseSkeleton.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call IssueTargetOrderBJ(GetLastCreatedUnit(),"drunkenhaze",GetTriggerUnit())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Spartacus takes nothing returns nothing
endfunction

function RegisterR11_Spartacus_Summon takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Spartacus_Summon=CreateTrigger()

call TriggerRegisterAnyUnitEventBJ(gg_trg_Spartacus_Summon,EVENT_PLAYER_UNIT_SPELL_EFFECT)

call TriggerAddCondition(gg_trg_Spartacus_Summon,Condition(function Trig_Spartacus_Summon_Conditions))

call TriggerAddAction(gg_trg_Spartacus_Summon,function Trig_Spartacus_Summon_Actions)

endfunction




endlibrary
