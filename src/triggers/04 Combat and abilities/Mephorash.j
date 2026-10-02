library TMephorash requires TBerserk, TLoc, TWait
function Trig_Mephorash_Split_PlayBirthAnim takes nothing returns nothing
    call SetUnitAnimation(GetEnumUnit(),"birth")
    call QueueUnitAnimationBJ(GetEnumUnit(),"stand")
endfunction

function Trig_Mephorash_Split_ActivateClone takes nothing returns nothing
    call TriggerRegisterUnitEvent(gg_trg_Mephorash_Clone_Death,GetEnumUnit(),EVENT_UNIT_DEATH)
    call PauseUnitBJ(false,GetEnumUnit())
    call SetUnitInvulnerable(GetEnumUnit(),false)
    call GroupAddUnitSimple(GetEnumUnit(),udg_BossGroup)
    call GroupAddUnitSimple(GetEnumUnit(),udg_HuntMonsters)
endfunction

function Trig_Mephorash_Split_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call Berserk_Remove(GetTriggerUnit())
    call SetUnitInvulnerable(GetTriggerUnit(),true)
    call PauseUnitBJ(true,GetTriggerUnit())
    call AddSpecialEffectTargetUnitBJ("origin",GetTriggerUnit(),"Abilities\\Spells\\Human\\ReviveHuman\\ReviveHuman.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call Wait_Polled(1.)
    call GroupAddUnitSimple(GetTriggerUnit(),udg_MephorashClones)
    call SetUnitLifePercentBJ(GetTriggerUnit(),'d')
    call UnitRemoveAbilityBJ('A0ZR',GetTriggerUnit()) // 'A0ZR': ability "Immortal"
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,256,GetUnitFacing(GetTriggerUnit()))
    call RemoveLocation(udg_TempPoint)
    // The remainder after dividing ((facing in degrees of the triggering unit) plus (120)) by (360).
    set udg_TempPoint=Loc_PolarOffset(udg_TempPoint2,256,ModuloReal((GetUnitFacing(GetTriggerUnit())+120.),360.))
    call CreateNUnitsAtLocFacingLocBJ(1,GetUnitTypeId(GetTriggerUnit()),GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,udg_TempPoint2)
    call RemoveLocation(udg_TempPoint)
    call AddSpecialEffectTargetUnitBJ("origin",GetLastCreatedUnit(),"Abilities\\Spells\\Human\\ReviveHuman\\ReviveHuman.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call GroupAddUnitSimple(GetLastCreatedUnit(),udg_MephorashClones)
    call SetUnitInvulnerable(GetLastCreatedUnit(),true)
    call PauseUnitBJ(true,GetLastCreatedUnit())
    // The remainder after dividing ((facing in degrees of the triggering unit) plus (240)) by (360).
    set udg_TempPoint=Loc_PolarOffset(udg_TempPoint2,256,ModuloReal((GetUnitFacing(GetTriggerUnit())+240.),360.))
    call CreateNUnitsAtLocFacingLocBJ(1,GetUnitTypeId(GetTriggerUnit()),GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,udg_TempPoint2)
    call RemoveLocation(udg_TempPoint)
    call RemoveLocation(udg_TempPoint2)
    call AddSpecialEffectTargetUnitBJ("origin",GetLastCreatedUnit(),"Abilities\\Spells\\Human\\ReviveHuman\\ReviveHuman.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call GroupAddUnitSimple(GetLastCreatedUnit(),udg_MephorashClones)
    call SetUnitInvulnerable(GetLastCreatedUnit(),true)
    call PauseUnitBJ(true,GetLastCreatedUnit())
    call ForGroupBJ(udg_MephorashClones,function Trig_Mephorash_Split_PlayBirthAnim)
    call Wait_Polled(1.)
    call ForGroupBJ(udg_MephorashClones,function Trig_Mephorash_Split_ActivateClone)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Mephorash_Clone_Death_Conditions takes nothing returns boolean
    return(IsUnitInGroup(GetTriggerUnit(),udg_MephorashClones))
endfunction

function Trig_Mephorash_Clone_Death_OneCloneLeft takes nothing returns boolean
    return(CountUnitsInGroup(udg_MephorashClones)<=1)
endfunction

function Trig_Mephorash_Clone_Death_AllClonesDead takes nothing returns boolean
    return(IsUnitGroupEmptyBJ(udg_MephorashClones))
endfunction

function Trig_Mephorash_Clone_Death_Actions takes nothing returns nothing
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_BossGroup)
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_MephorashClones)
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_HuntMonsters)
    if(Trig_Mephorash_Clone_Death_AllClonesDead())then
        call DisableTrigger(GetTriggeringTrigger())
        call AddUnitToStockBJ('n0BH',gg_unit_e014_0149,1,1) // 'n0BH': unit "Hunt: Melaiduma"
        set udg_HuntStock[6]=(udg_HuntStock[6]+1)
        call ConditionalTriggerExecute(gg_trg_Hunt_Board_Markers)
        call DestroyTrigger(GetTriggeringTrigger())
    else
        if(Trig_Mephorash_Clone_Death_OneCloneLeft())then
            call TriggerRegisterUnitEvent(gg_trg_Hunt_Complete,GroupPickRandomUnit(udg_MephorashClones),EVENT_UNIT_DEATH)
        endif
    endif
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Mephorash takes nothing returns nothing
endfunction

function RegisterR11_Mephorash_Split takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Mephorash_Split=CreateTrigger()

call TriggerAddAction(gg_trg_Mephorash_Split,function Trig_Mephorash_Split_Actions)

endfunction




function RegisterR11_Mephorash_Clone_Death takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Mephorash_Clone_Death=CreateTrigger()

call TriggerAddCondition(gg_trg_Mephorash_Clone_Death,Condition(function Trig_Mephorash_Clone_Death_Conditions))

call TriggerAddAction(gg_trg_Mephorash_Clone_Death,function Trig_Mephorash_Clone_Death_Actions)

endfunction




endlibrary
