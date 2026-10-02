library THades requires TGroup, TLoc, TProf, TWait
function Trig_Hades_BlackCauldron_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A02Q') // 'A02Q': ability "!Black Cauldron"
endfunction

function Trig_Hades_BlackCauldron_Filter_IsEnemy takes nothing returns boolean
    return(IsUnitEnemy(GetFilterUnit(),GetOwningPlayer(GetTriggerUnit())))
endfunction

function Trig_Hades_BlackCauldron_Filter_NotAsleep takes nothing returns boolean
    return(UnitHasBuffBJ(GetFilterUnit(),'B03A')==false) // 'B03A': buff tooltip "Sleep"
endfunction

function Trig_Hades_BlackCauldron_Filter_NotSleepproof takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0U6',GetFilterUnit())<=0) // 'A0U6': ability "Sleepproof"
endfunction

function Trig_Hades_BlackCauldron_Filter_Sleepable takes nothing returns boolean
    return GetBooleanAnd(Trig_Hades_BlackCauldron_Filter_NotAsleep(),Trig_Hades_BlackCauldron_Filter_NotSleepproof())
endfunction

function Trig_Hades_BlackCauldron_Filter_EnemySleepable takes nothing returns boolean
    return GetBooleanAnd(Trig_Hades_BlackCauldron_Filter_IsEnemy(),Trig_Hades_BlackCauldron_Filter_Sleepable())
endfunction

function Trig_Hades_BlackCauldron_Filter_IsAlive takes nothing returns boolean
    return(IsUnitAliveBJ(GetFilterUnit()))
endfunction

function Trig_Hades_BlackCauldron_Filter_NotInvulnerable takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('Avul',GetFilterUnit())<=0) // 'Avul': standard ability reference "Invulnerable"
endfunction

function Trig_Hades_BlackCauldron_Filter_AliveVulnerable takes nothing returns boolean
    return GetBooleanAnd(Trig_Hades_BlackCauldron_Filter_IsAlive(),Trig_Hades_BlackCauldron_Filter_NotInvulnerable())
endfunction

function Trig_Hades_BlackCauldron_Filter_SleepTarget takes nothing returns boolean
    return GetBooleanAnd(Trig_Hades_BlackCauldron_Filter_EnemySleepable(),Trig_Hades_BlackCauldron_Filter_AliveVulnerable())
endfunction

function Trig_Hades_BlackCauldron_Enum_CastSleep takes nothing returns nothing
    set udg_TempPoint=GetUnitLoc(GetEnumUnit())
    call CreateNUnitsAtLocFacingLocBJ(1,'h02S',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,udg_TempPoint) // 'h02S': unit "Simple Casting Dummy"
    call RemoveLocation(udg_TempPoint)
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(1.5,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A0U4',GetLastCreatedUnit()) // 'A0U4': ability "Sleep"
    call IssueTargetOrderBJ(GetLastCreatedUnit(),"sleep",GetEnumUnit())
endfunction

function Trig_Hades_BlackCauldron_Filter_IsEnemy2 takes nothing returns boolean
    return(IsUnitEnemy(GetFilterUnit(),GetOwningPlayer(GetTriggerUnit())))
endfunction

function Trig_Hades_BlackCauldron_Filter_IsAsleep takes nothing returns boolean
    return(UnitHasBuffBJ(GetFilterUnit(),'B03A')) // 'B03A': buff tooltip "Sleep"
endfunction

function Trig_Hades_BlackCauldron_Filter_EnemyAsleep takes nothing returns boolean
    return GetBooleanAnd(Trig_Hades_BlackCauldron_Filter_IsEnemy2(),Trig_Hades_BlackCauldron_Filter_IsAsleep())
endfunction

function Trig_Hades_BlackCauldron_Filter_IsAlive2 takes nothing returns boolean
    return(IsUnitAliveBJ(GetFilterUnit()))
endfunction

function Trig_Hades_BlackCauldron_Filter_NotInvulnerable2 takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('Avul',GetFilterUnit())<=0) // 'Avul': standard ability reference "Invulnerable"
endfunction

function Trig_Hades_BlackCauldron_Filter_AliveVulnerable2 takes nothing returns boolean
    return GetBooleanAnd(Trig_Hades_BlackCauldron_Filter_IsAlive2(),Trig_Hades_BlackCauldron_Filter_NotInvulnerable2())
endfunction

function Trig_Hades_BlackCauldron_Filter_FlareTarget takes nothing returns boolean
    return GetBooleanAnd(Trig_Hades_BlackCauldron_Filter_EnemyAsleep(),Trig_Hades_BlackCauldron_Filter_AliveVulnerable2())
endfunction

function Trig_Hades_BlackCauldron_Cond_AnySleeping takes nothing returns boolean
    return(IsUnitGroupEmptyBJ(udg_TempGroup)==false)
endfunction

function Trig_Hades_BlackCauldron_Actions takes nothing returns nothing
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    set udg_TempGroup=Group_UnitsInRangeOfLoc(800.,udg_TempPoint,Condition(function Trig_Hades_BlackCauldron_Filter_SleepTarget))
    call RemoveLocation(udg_TempPoint)
    call ForGroupBJ(udg_TempGroup,function Trig_Hades_BlackCauldron_Enum_CastSleep)
    call DestroyGroup(udg_TempGroup)
    call Wait_Polled(2)
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    set udg_TempGroup=Group_UnitsInRangeOfLoc(800.,udg_TempPoint,Condition(function Trig_Hades_BlackCauldron_Filter_FlareTarget))
    call RemoveLocation(udg_TempPoint)
    if(Trig_Hades_BlackCauldron_Cond_AnySleeping())then
        set udg_TempPoint=GetUnitLoc(GroupPickRandomUnit(udg_TempGroup))
        call CreateNUnitsAtLocFacingLocBJ(1,'h01B',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,udg_TempPoint) // 'h01B': unit "Proxy Dummy"
        call AddSpecialEffectLocBJ(udg_TempPoint,"Objects\\Spawnmodels\\Other\\NeutralBuildingExplosion\\NeutralBuildingExplosion.mdl")
        call BlzSetSpecialEffectScale(GetLastCreatedEffectBJ(),3.)
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        set bj_forLoopAIndex=1
        set bj_forLoopAIndexEnd=16
        loop
            exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
            // (22.5) times (loop counter A treated as a decimal-capable number).
            set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,128.,(22.5*I2R(GetForLoopIndexA())))
            call AddSpecialEffectLocBJ(udg_TempPoint2,"Abilities\\Spells\\Other\\Doom\\DoomDeath.mdl")
            call RemoveLocation(udg_TempPoint2)
            call BlzSetSpecialEffectScale(GetLastCreatedEffectBJ(),2.)
            call DestroyEffectBJ(GetLastCreatedEffectBJ())
            // (22.5) times (loop counter A treated as a decimal-capable number).
            set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,256.,(22.5*I2R(GetForLoopIndexA())))
            call AddSpecialEffectLocBJ(udg_TempPoint2,"Abilities\\Spells\\Other\\Doom\\DoomDeath.mdl")
            call RemoveLocation(udg_TempPoint2)
            call DestroyEffectBJ(GetLastCreatedEffectBJ())
            set bj_forLoopAIndex=bj_forLoopAIndex+1
        endloop
        call RemoveLocation(udg_TempPoint)
        set udg_TempHandleId=GetHandleIdBJ(GetLastCreatedUnit())
        call SaveUnitHandleBJ(GetTriggerUnit(),0,udg_TempHandleId,udg_ProxyDamageHash)
        set udg_TempReal=Prof_InnerManaPower(GetTriggerUnit())
        // (10000) times (udg_TempReal).
        call SaveRealBJ((10000.*udg_TempReal),1,udg_TempHandleId,udg_ProxyDamageHash)
        call SaveIntegerBJ(3,2,udg_TempHandleId,udg_ProxyDamageHash)
        call ShowUnitHide(GetLastCreatedUnit())
        call UnitApplyTimedLifeBJ(2.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
        call UnitAddAbilityBJ('A0TA',GetLastCreatedUnit()) // 'A0TA': ability "Flare"
        call IssueImmediateOrderBJ(GetLastCreatedUnit(),"stomp")
    endif
    call DestroyGroup(udg_TempGroup)
endfunction

// World Editor calls InitTrig_Hades automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Hades (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Hades takes nothing returns nothing
endfunction

function Register_Hades_BlackCauldron takes nothing returns nothing
    set gg_trg_Hades_BlackCauldron=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Hades_BlackCauldron,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Hades_BlackCauldron,Condition(function Trig_Hades_BlackCauldron_Conditions))
    call TriggerAddAction(gg_trg_Hades_BlackCauldron,function Trig_Hades_BlackCauldron_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Hades takes nothing returns nothing
    call Register_Hades_BlackCauldron()
endfunction

endlibrary
