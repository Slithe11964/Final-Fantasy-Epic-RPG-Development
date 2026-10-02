library TGatherServants requires TLoc
function Trig_GatherServants_Cast_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A026') // 'A026': ability "Gather Servants"
endfunction

function Trig_GatherServants_Cast_ExpireServant takes nothing returns nothing
    call UnitApplyTimedLifeBJ(.01,'BTLF',GetEnumUnit()) // 'BTLF': object name not found in map data
    call UnitAddTypeBJ(UNIT_TYPE_SUMMONED,GetEnumUnit())
    call UnitAddAbilityBJ('A14I',GetEnumUnit()) // 'A14I': ability "Summon Poof Death"
endfunction

function Trig_GatherServants_Cast_Actions takes nothing returns nothing
    call ForGroupBJ(udg_DarkServants,function Trig_GatherServants_Cast_ExpireServant)
    call GroupClear(udg_DarkServants)
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,256,GetUnitFacing(GetTriggerUnit()))
    call RemoveLocation(udg_TempPoint)
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=6
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        // Result 1: loop counter A treated as a decimal-capable number.
        // Result 2: (result 1) minus (0.5).
        // Result 3: (60) times (result 2).
        // Result 4: (facing in degrees of the triggering unit) plus (result 3).
        set udg_TempPoint=Loc_PolarOffset(udg_TempPoint2,128.,(GetUnitFacing(GetTriggerUnit())+(60.*(I2R(GetForLoopIndexA())-.5))))
        call CreateNUnitsAtLoc(1,'u01L',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,GetUnitFacing(GetTriggerUnit())) // 'u01L': unit "Dark Servant"
        call RemoveLocation(udg_TempPoint)
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_DarkServants)
        call AddSpecialEffectTargetUnitBJ("origin",GetLastCreatedUnit(),"Abilities\\Spells\\Undead\\RaiseSkeletonWarrior\\RaiseSkeleton.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call AddSpecialEffectTargetUnitBJ("origin",GetLastCreatedUnit(),"Abilities\\Spells\\Orc\\FeralSpirit\\feralspirittarget.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    call RemoveLocation(udg_TempPoint2)
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_GatherServants takes nothing returns nothing
endfunction

function RegisterR11_GatherServants_Cast takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_GatherServants_Cast=CreateTrigger()

call TriggerRegisterAnyUnitEventBJ(gg_trg_GatherServants_Cast,EVENT_PLAYER_UNIT_SPELL_EFFECT)

call TriggerAddCondition(gg_trg_GatherServants_Cast,Condition(function Trig_GatherServants_Cast_Conditions))

call TriggerAddAction(gg_trg_GatherServants_Cast,function Trig_GatherServants_Cast_Actions)

endfunction




endlibrary
