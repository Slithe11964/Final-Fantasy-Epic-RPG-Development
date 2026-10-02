library TEarthSmash requires TAbil, TGroup, TLoc
function Trig_EarthSmash_Cast_IsEarthSmashAbility takes nothing returns boolean
    return(GetSpellAbilityId()=='A0ZM')or(GetSpellAbilityId()=='A0FG')or(GetSpellAbilityId()=='A0CC')or(GetSpellAbilityId()=='A0FH') // 'A0ZM': ability "Earth Smash"; 'A0FG': ability "Earth Smash"; 'A0CC': ability "Earth Smash"; 'A0FH': ability "Earth Smash"
endfunction

function Trig_EarthSmash_Cast_Conditions takes nothing returns boolean
    return(Trig_EarthSmash_Cast_IsEarthSmashAbility())
endfunction

function Trig_EarthSmash_Cast_Filter_IsAlive takes nothing returns boolean
    return(IsUnitAliveBJ(GetFilterUnit()))
endfunction

function Trig_EarthSmash_Cast_Filter_IsEnemy takes nothing returns boolean
    return(IsUnitEnemy(GetFilterUnit(),GetOwningPlayer(GetTriggerUnit())))
endfunction

function Trig_EarthSmash_Cast_Filter_AliveEnemy takes nothing returns boolean
    return GetBooleanAnd(Trig_EarthSmash_Cast_Filter_IsAlive(),Trig_EarthSmash_Cast_Filter_IsEnemy())
endfunction

function Trig_EarthSmash_Cast_Filter_NotInvulnerable takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('Avul',GetFilterUnit())<=0) // 'Avul': standard ability reference "Invulnerable"
endfunction

function Trig_EarthSmash_Cast_Filter_ValidTarget takes nothing returns boolean
    return GetBooleanAnd(Trig_EarthSmash_Cast_Filter_AliveEnemy(),Trig_EarthSmash_Cast_Filter_NotInvulnerable())
endfunction

function Trig_EarthSmash_Cast_IsCasterHero takes nothing returns boolean
    return(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_EarthSmash_Cast_DamageEnemy takes nothing returns nothing
    set udg_IsPhysicalAttack=true
    set udg_DamageElement=5
    set udg_DmgFlagNoCrit=-1.
    // Udg_TempInteger treated as a decimal-capable number.
    call UnitDamageTarget(GetTriggerUnit(),GetEnumUnit(),I2R(udg_TempInteger),true,true,ATTACK_TYPE_SIEGE,DAMAGE_TYPE_NORMAL,null)
endfunction

function Trig_EarthSmash_Cast_Actions takes nothing returns nothing
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=6
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        // (loop counter A treated as a decimal-capable number) times (60).
        set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,325.,(I2R(GetForLoopIndexA())*60.))
        call AddSpecialEffectLocBJ(udg_TempPoint2,"Abilities\\Spells\\Human\\ThunderClap\\ThunderClapCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint2)
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    set udg_TempGroup=Group_UnitsInRangeOfLoc(682.,udg_TempPoint,Condition(function Trig_EarthSmash_Cast_Filter_ValidTarget))
    call RemoveLocation(udg_TempPoint)
    // (BlzGetAbilityManaCost(GetSpellAbilityId(), Abil_GetLevel(the triggering unit, GetSpellAbilityId()))) times
    // (5).
    set udg_TempInteger=(BlzGetAbilityManaCost(GetSpellAbilityId(),Abil_GetLevel(GetTriggerUnit(),GetSpellAbilityId()))*5)
    if(Trig_EarthSmash_Cast_IsCasterHero())then
        // (udg_TempInteger) plus ((Strength of the triggering unit) times (6)).
        set udg_TempInteger=(udg_TempInteger+(GetHeroStatBJ(bj_HEROSTAT_STR,GetTriggerUnit(),true)*6))
    endif
    call ForGroupBJ(udg_TempGroup,function Trig_EarthSmash_Cast_DamageEnemy)
    call DestroyGroup(udg_TempGroup)
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_EarthSmash takes nothing returns nothing
endfunction

function RegisterR11_EarthSmash_Cast takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_EarthSmash_Cast=CreateTrigger()

call TriggerRegisterAnyUnitEventBJ(gg_trg_EarthSmash_Cast,EVENT_PLAYER_UNIT_SPELL_EFFECT)

call TriggerAddCondition(gg_trg_EarthSmash_Cast,Condition(function Trig_EarthSmash_Cast_Conditions))

call TriggerAddAction(gg_trg_EarthSmash_Cast,function Trig_EarthSmash_Cast_Actions)

endfunction




endlibrary
