library TTremor requires TAbil, TGroup, TLoc, TProf
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Tremor_Cast=null
endglobals

function Trig_Tremor_Cast_IsTremorAbility takes nothing returns boolean
    return(GetSpellAbilityId()=='A1AH')or(GetSpellAbilityId()=='A0T7') // 'A1AH': ability "Tremor"; 'A0T7': ability "Tremor"
endfunction

function Trig_Tremor_Cast_Conditions takes nothing returns boolean
    return(Trig_Tremor_Cast_IsTremorAbility())
endfunction

function Trig_Tremor_Cast_Filter_IsAlive takes nothing returns boolean
    return(IsUnitAliveBJ(GetFilterUnit()))
endfunction

function Trig_Tremor_Cast_Filter_IsEnemy takes nothing returns boolean
    return(IsUnitEnemy(GetFilterUnit(),GetOwningPlayer(GetTriggerUnit())))
endfunction

function Trig_Tremor_Cast_Filter_AliveEnemy takes nothing returns boolean
    return GetBooleanAnd(Trig_Tremor_Cast_Filter_IsAlive(),Trig_Tremor_Cast_Filter_IsEnemy())
endfunction

function Trig_Tremor_Cast_Filter_NotInvulnerable takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('Avul',GetFilterUnit())<=0) // 'Avul': standard ability reference "Invulnerable"
endfunction

function Trig_Tremor_Cast_Filter_ValidTarget takes nothing returns boolean
    return GetBooleanAnd(Trig_Tremor_Cast_Filter_AliveEnemy(),Trig_Tremor_Cast_Filter_NotInvulnerable())
endfunction

function Trig_Tremor_Cast_IsCasterHero takes nothing returns boolean
    return(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Tremor_Cast_DamageEnemy takes nothing returns nothing
    set udg_DamageElement=5
    // Udg_TempInteger treated as a decimal-capable number.
    call UnitDamageTarget(GetTriggerUnit(),GetEnumUnit(),I2R(udg_TempInteger),true,true,ATTACK_TYPE_NORMAL,DAMAGE_TYPE_MAGIC,null)
endfunction

function Trig_Tremor_Cast_Actions takes nothing returns nothing
    local group l_tempGroup
    local location l_tempPoint
    local real l_tempReal
    set l_tempPoint=GetUnitLoc(GetTriggerUnit())
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=6
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        // (loop counter A treated as a decimal-capable number) times (60).
        set udg_TempPoint2=Loc_PolarOffset(l_tempPoint,325.,(I2R(GetForLoopIndexA())*60.))
        call AddSpecialEffectLocBJ(udg_TempPoint2,"Abilities\\Spells\\Human\\ThunderClap\\ThunderClapCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint2)
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    set l_tempGroup=Group_UnitsInRangeOfLoc(682.,l_tempPoint,Condition(function Trig_Tremor_Cast_Filter_ValidTarget))
    call RemoveLocation(l_tempPoint)
    // (BlzGetAbilityManaCost(GetSpellAbilityId(), Abil_GetLevel(the triggering unit, GetSpellAbilityId()))) times
    // (4).
    set udg_TempInteger=(BlzGetAbilityManaCost(GetSpellAbilityId(),Abil_GetLevel(GetTriggerUnit(),GetSpellAbilityId()))*4)
    if(Trig_Tremor_Cast_IsCasterHero())then
        // (udg_TempInteger) plus ((Intelligence of the triggering unit) times (4)).
        set udg_TempInteger=(udg_TempInteger+(GetHeroStatBJ(bj_HEROSTAT_INT,GetTriggerUnit(),true)*4))
    endif
    set l_tempReal=Prof_RodPower(GetTriggerUnit())
    // ((udg_TempInteger treated as a decimal-capable number) times (l_tempReal)) with its decimal part removed.
    set udg_TempInteger=R2I((I2R(udg_TempInteger)*l_tempReal))
    call ForGroupBJ(l_tempGroup,function Trig_Tremor_Cast_DamageEnemy)
    call DestroyGroup(l_tempGroup)
    set l_tempGroup=null
    set l_tempPoint=null
endfunction

// World Editor calls InitTrig_Tremor automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Tremor (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Tremor takes nothing returns nothing
endfunction

function Register_Tremor_Cast takes nothing returns nothing
    set gg_trg_Tremor_Cast=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Tremor_Cast,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Tremor_Cast,Condition(function Trig_Tremor_Cast_Conditions))
    call TriggerAddAction(gg_trg_Tremor_Cast,function Trig_Tremor_Cast_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Tremor takes nothing returns nothing
    call Register_Tremor_Cast()
endfunction

endlibrary
