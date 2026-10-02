library THypernova requires TGroup, TLoc
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Hypernova_Cast=null
endglobals

function Trig_Hypernova_Cast_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A1FI') // 'A1FI': ability "!Hypernova"
endfunction

function Trig_Hypernova_Cast_IsEnemyUnit takes nothing returns boolean
    return(IsUnitEnemy(GetFilterUnit(),GetOwningPlayer(GetTriggerUnit())))
endfunction

function Trig_Hypernova_Cast_IsNotBuilding takes nothing returns boolean
    return(IsUnitType(GetFilterUnit(),UNIT_TYPE_STRUCTURE)==false)!=null
endfunction

function Trig_Hypernova_Cast_IsEnemyNonBuilding takes nothing returns boolean
    return GetBooleanAnd(Trig_Hypernova_Cast_IsEnemyUnit(),Trig_Hypernova_Cast_IsNotBuilding())
endfunction

function Trig_Hypernova_Cast_IsUnitAlive takes nothing returns boolean
    return(IsUnitAliveBJ(GetFilterUnit()))
endfunction

function Trig_Hypernova_Cast_IsNotInvulnerable takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('Avul',GetFilterUnit())<=0) // 'Avul': standard ability reference "Invulnerable"
endfunction

function Trig_Hypernova_Cast_IsAliveTarget takes nothing returns boolean
    return GetBooleanAnd(Trig_Hypernova_Cast_IsUnitAlive(),Trig_Hypernova_Cast_IsNotInvulnerable())
endfunction

function Trig_Hypernova_Cast_IsHypernovaTarget takes nothing returns boolean
    return GetBooleanAnd(Trig_Hypernova_Cast_IsEnemyNonBuilding(),Trig_Hypernova_Cast_IsAliveTarget())
endfunction

function Trig_Hypernova_Cast_BlastTarget takes nothing returns nothing
    call SaveUnitHandleBJ(GetTriggerUnit(),0,GetHandleIdBJ(GetEnumUnit()),udg_MolotovHash)
    call SaveRealBJ(3000.,1,GetHandleIdBJ(GetEnumUnit()),udg_MolotovHash)
    set udg_TempPoint=GetUnitLoc(GetEnumUnit())
    call AddSpecialEffectLocBJ(udg_TempPoint,"Objects\\Spawnmodels\\Other\\NeutralBuildingExplosion\\NeutralBuildingExplosion.mdl")
    call BlzSetSpecialEffectScale(GetLastCreatedEffectBJ(),2.5)
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Other\\Doom\\DoomDeath.mdl")
    call BlzSetSpecialEffectScale(GetLastCreatedEffectBJ(),2.5)
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call CreateNUnitsAtLocFacingLocBJ(1,'h02S',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,udg_TempPoint) // 'h02S': unit "Simple Casting Dummy"
    call RemoveLocation(udg_TempPoint)
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(1.5,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A1FJ',GetLastCreatedUnit()) // 'A1FJ': ability "Hypernova"
    call IssueTargetOrderBJ(GetLastCreatedUnit(),"drunkenhaze",GetEnumUnit())
    set udg_IsPhysicalAttack=true
    set udg_DamageElement=1
    call UnitDamageTarget(GetTriggerUnit(),GetEnumUnit(),15000.,true,true,ATTACK_TYPE_CHAOS,DAMAGE_TYPE_NORMAL,null)
endfunction

function Trig_Hypernova_Cast_Actions takes nothing returns nothing
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call AddSpecialEffectLocBJ(udg_TempPoint,"Objects\\Spawnmodels\\Other\\NeutralBuildingExplosion\\NeutralBuildingExplosion.mdl")
    call BlzSetSpecialEffectScale(GetLastCreatedEffectBJ(),4.)
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=16
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        // (22.5) times (loop counter A treated as a decimal-capable number).
        set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,256.,(22.5*I2R(GetForLoopIndexA())))
        call AddSpecialEffectLocBJ(udg_TempPoint2,"Abilities\\Spells\\Other\\Doom\\DoomDeath.mdl")
        call RemoveLocation(udg_TempPoint2)
        call BlzSetSpecialEffectScale(GetLastCreatedEffectBJ(),3.)
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        // (22.5) times ((loop counter A treated as a decimal-capable number) minus (0.5)).
        set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,512.,(22.5*(I2R(GetForLoopIndexA())-.5)))
        call AddSpecialEffectLocBJ(udg_TempPoint2,"Abilities\\Spells\\Other\\Doom\\DoomDeath.mdl")
        call RemoveLocation(udg_TempPoint2)
        call BlzSetSpecialEffectScale(GetLastCreatedEffectBJ(),2.)
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        // (22.5) times (loop counter A treated as a decimal-capable number).
        set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,768.,(22.5*I2R(GetForLoopIndexA())))
        call AddSpecialEffectLocBJ(udg_TempPoint2,"Abilities\\Spells\\Other\\Doom\\DoomDeath.mdl")
        call RemoveLocation(udg_TempPoint2)
        call BlzSetSpecialEffectScale(GetLastCreatedEffectBJ(),1.5)
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    set udg_TempGroup=Group_UnitsInRangeOfLoc(800.,udg_TempPoint,Condition(function Trig_Hypernova_Cast_IsHypernovaTarget))
    call RemoveLocation(udg_TempPoint)
    call ForGroupBJ(udg_TempGroup,function Trig_Hypernova_Cast_BlastTarget)
    call DestroyGroup(udg_TempGroup)
endfunction

// World Editor calls InitTrig_Hypernova automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Hypernova (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Hypernova takes nothing returns nothing
endfunction

function Register_Hypernova_Cast takes nothing returns nothing
    set gg_trg_Hypernova_Cast=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Hypernova_Cast,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Hypernova_Cast,Condition(function Trig_Hypernova_Cast_Conditions))
    call TriggerAddAction(gg_trg_Hypernova_Cast,function Trig_Hypernova_Cast_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Hypernova takes nothing returns nothing
    call Register_Hypernova_Cast()
endfunction

endlibrary
