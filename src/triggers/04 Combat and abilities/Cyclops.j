library TCyclops requires TAbil, TGroup, TLoc
function Trig_Cyclops_FinalSmash_IsCastAbility takes nothing returns boolean
    return(GetSpellAbilityId()=='A13U')or(GetSpellAbilityId()=='A1F0') // 'A13U': ability "!Final Smash"; 'A1F0': ability "!Final Smash"
endfunction

function Trig_Cyclops_FinalSmash_Conditions takes nothing returns boolean
    return(Trig_Cyclops_FinalSmash_IsCastAbility())
endfunction

function Trig_Cyclops_FinalSmash_FilterIsAlive takes nothing returns boolean
    return(IsUnitAliveBJ(GetFilterUnit()))
endfunction

function Trig_Cyclops_FinalSmash_FilterIsEnemy takes nothing returns boolean
    return(IsUnitEnemy(GetFilterUnit(),GetOwningPlayer(GetTriggerUnit())))
endfunction

function Trig_Cyclops_FinalSmash_FilterAliveEnemy takes nothing returns boolean
    return GetBooleanAnd(Trig_Cyclops_FinalSmash_FilterIsAlive(),Trig_Cyclops_FinalSmash_FilterIsEnemy())
endfunction

function Trig_Cyclops_FinalSmash_FilterNotInvulnerable takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('Avul',GetFilterUnit())<=0) // 'Avul': standard ability reference "Invulnerable"
endfunction

function Trig_Cyclops_FinalSmash_FilterTarget takes nothing returns boolean
    return GetBooleanAnd(Trig_Cyclops_FinalSmash_FilterAliveEnemy(),Trig_Cyclops_FinalSmash_FilterNotInvulnerable())
endfunction

function Trig_Cyclops_FinalSmash_UsesFirstWeapon takes nothing returns boolean
    return(udg_AbilityLevelShift)
endfunction

function Trig_Cyclops_FinalSmash_CasterIsHero takes nothing returns boolean
    return(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Cyclops_FinalSmash_DamageEnum takes nothing returns nothing
    set udg_IsPhysicalAttack=true
    set udg_DamageElement=5
    set udg_DmgFlagNoCrit=-1.
    // Udg_TempInteger treated as a decimal-capable number.
    call UnitDamageTarget(GetTriggerUnit(),GetEnumUnit(),I2R(udg_TempInteger),true,true,ATTACK_TYPE_SIEGE,DAMAGE_TYPE_NORMAL,null)
endfunction

function Trig_Cyclops_FinalSmash_Actions takes nothing returns nothing
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
    set udg_TempGroup=Group_UnitsInRangeOfLoc(682.,udg_TempPoint,Condition(function Trig_Cyclops_FinalSmash_FilterTarget))
    call RemoveLocation(udg_TempPoint)
    // (BlzGetAbilityManaCost(GetSpellAbilityId(), Abil_GetLevel(the triggering unit, GetSpellAbilityId()))) times
    // (5).
    set udg_TempInteger=(BlzGetAbilityManaCost(GetSpellAbilityId(),Abil_GetLevel(GetTriggerUnit(),GetSpellAbilityId()))*5)
    if(Trig_Cyclops_FinalSmash_CasterIsHero())then
        // (udg_TempInteger) plus ((Strength of the triggering unit) times (6)).
        set udg_TempInteger=(udg_TempInteger+(GetHeroStatBJ(bj_HEROSTAT_STR,GetTriggerUnit(),true)*6))
    else
        if(Trig_Cyclops_FinalSmash_UsesFirstWeapon())then
            // (udg_TempInteger) plus ((BlzGetUnitBaseDamage(the triggering unit, 0)) times (5)).
            set udg_TempInteger=(udg_TempInteger+(BlzGetUnitBaseDamage(GetTriggerUnit(),0)*5))
        else
            // (udg_TempInteger) plus ((BlzGetUnitBaseDamage(the triggering unit, 1)) times (5)).
            set udg_TempInteger=(udg_TempInteger+(BlzGetUnitBaseDamage(GetTriggerUnit(),1)*5))
        endif
    endif
    call ForGroupBJ(udg_TempGroup,function Trig_Cyclops_FinalSmash_DamageEnum)
    call DestroyGroup(udg_TempGroup)
endfunction

// World Editor calls InitTrig_Cyclops automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Cyclops (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Cyclops takes nothing returns nothing
endfunction

function Register_Cyclops_FinalSmash takes nothing returns nothing
    set gg_trg_Cyclops_FinalSmash=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Cyclops_FinalSmash,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Cyclops_FinalSmash,Condition(function Trig_Cyclops_FinalSmash_Conditions))
    call TriggerAddAction(gg_trg_Cyclops_FinalSmash,function Trig_Cyclops_FinalSmash_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Cyclops takes nothing returns nothing
    call Register_Cyclops_FinalSmash()
endfunction

endlibrary
