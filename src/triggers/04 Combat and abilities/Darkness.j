library TDarkness requires TAbil, TForce, TGroup, TProf
function Trig_Darkness_LowHP_Cancel_IsDarknessAbility takes nothing returns boolean
    return(GetSpellAbilityId()=='A0KS')or(GetSpellAbilityId()=='A0U5')or(GetSpellAbilityId()=='A183') // 'A0KS': ability "Darkness"; 'A0U5': ability "Darkness"; 'A183': ability "Darkness"
endfunction

function Trig_Darkness_LowHP_Cancel_Conditions takes nothing returns boolean
    // (maximum health of the triggering unit) divided by (8).
    return(Trig_Darkness_LowHP_Cancel_IsDarknessAbility())and(GetUnitStateSwap(UNIT_STATE_LIFE,GetTriggerUnit())<(GetUnitStateSwap(UNIT_STATE_MAX_LIFE,GetTriggerUnit())/ 8.))
endfunction

function Trig_Darkness_LowHP_Cancel_Actions takes nothing returns nothing
    call PauseUnitBJ(true,GetTriggerUnit())
    call IssueImmediateOrderBJ(GetTriggerUnit(),"stop")
    call PauseUnitBJ(false,GetTriggerUnit())
    set udg_TempForce=Force_OfPlayer(GetOwningPlayer(GetTriggerUnit()))
    call DisplayTimedTextToForce(udg_TempForce,10.,"|cffff0000Your HP is too low to use this ability!|r")
    call DestroyForce(udg_TempForce)
endfunction

function Trig_Darkness_Cast_IsDarknessAbility takes nothing returns boolean
    return(GetSpellAbilityId()=='A0KS')or(GetSpellAbilityId()=='A0U5')or(GetSpellAbilityId()=='A183') // 'A0KS': ability "Darkness"; 'A0U5': ability "Darkness"; 'A183': ability "Darkness"
endfunction

function Trig_Darkness_Cast_Conditions takes nothing returns boolean
    return(Trig_Darkness_Cast_IsDarknessAbility())
endfunction

function Trig_Darkness_Cast_IsCasterHero takes nothing returns boolean
    return(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Darkness_Cast_Filter_IsAlive takes nothing returns boolean
    return(IsUnitAliveBJ(GetFilterUnit()))
endfunction

function Trig_Darkness_Cast_Filter_IsEnemy takes nothing returns boolean
    return(IsUnitEnemy(GetFilterUnit(),GetOwningPlayer(GetTriggerUnit())))
endfunction

function Trig_Darkness_Cast_Filter_AliveEnemy takes nothing returns boolean
    return GetBooleanAnd(Trig_Darkness_Cast_Filter_IsAlive(),Trig_Darkness_Cast_Filter_IsEnemy())
endfunction

function Trig_Darkness_Cast_Filter_NotInvulnerable takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('Avul',GetFilterUnit())<=0) // 'Avul': standard ability reference "Invulnerable"
endfunction

function Trig_Darkness_Cast_Filter_ValidTarget takes nothing returns boolean
    return GetBooleanAnd(Trig_Darkness_Cast_Filter_AliveEnemy(),Trig_Darkness_Cast_Filter_NotInvulnerable())
endfunction

function Trig_Darkness_Cast_DamageEnemy takes nothing returns nothing
    call AddSpecialEffectTargetUnitBJ("origin",GetEnumUnit(),"Abilities\\Spells\\Undead\\AnimateDead\\AnimateDeadTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    set udg_IgnoresReduction=true
    // Udg_TempInteger treated as a decimal-capable number.
    call UnitDamageTargetBJ(GetSpellAbilityUnit(),GetEnumUnit(),I2R(udg_TempInteger),ATTACK_TYPE_NORMAL,DAMAGE_TYPE_UNIVERSAL)
endfunction

function Trig_Darkness_Cast_HasEnoughLife takes nothing returns boolean
    // (maximum health of the triggering unit) divided by (8).
    return(GetUnitStateSwap(UNIT_STATE_LIFE,GetTriggerUnit())>(GetUnitStateSwap(UNIT_STATE_MAX_LIFE,GetTriggerUnit())/ 8.))
endfunction

function Trig_Darkness_Cast_Actions takes nothing returns nothing
    if(Trig_Darkness_Cast_HasEnoughLife())then
        // (BlzGetAbilityManaCost(GetSpellAbilityId(), Abil_GetLevel(the triggering unit, GetSpellAbilityId()))) times
        // (4).
        set udg_TempInteger=(BlzGetAbilityManaCost(GetSpellAbilityId(),Abil_GetLevel(GetTriggerUnit(),GetSpellAbilityId()))*4)
        if(Trig_Darkness_Cast_IsCasterHero())then
            // (udg_TempInteger) plus ((Intelligence of the triggering unit) times (6)).
            set udg_TempInteger=(udg_TempInteger+(GetHeroStatBJ(bj_HEROSTAT_INT,GetTriggerUnit(),true)*6))
        else
            // (udg_TempInteger) plus ((unit level of the triggering unit) times (10)).
            set udg_TempInteger=(udg_TempInteger+(GetUnitLevel(GetTriggerUnit())*$A)) // $A = 10
        endif
        set udg_TempReal=Prof_StaffPower(GetTriggerUnit())
        // ((udg_TempInteger treated as a decimal-capable number) times (udg_TempReal)) with its decimal part removed.
        set udg_TempInteger=R2I((I2R(udg_TempInteger)*udg_TempReal))
        set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
        set udg_TempGroup=Group_UnitsInRangeOfLoc(800.,udg_TempPoint,Condition(function Trig_Darkness_Cast_Filter_ValidTarget))
        call RemoveLocation(udg_TempPoint)
        call ForGroupBJ(udg_TempGroup,function Trig_Darkness_Cast_DamageEnemy)
        call DestroyGroup(udg_TempGroup)
        // Result 1: (maximum health of the triggering unit) divided by (8).
        // Result 2: (current health of the triggering unit) minus (result 1).
        // Result 3: the larger of (1) and (result 2).
        call SetUnitLifeBJ(GetTriggerUnit(),RMaxBJ(1.,(GetUnitStateSwap(UNIT_STATE_LIFE,GetTriggerUnit())-(GetUnitStateSwap(UNIT_STATE_MAX_LIFE,GetTriggerUnit())/ 8.))))
    else
        set udg_TempForce=Force_OfPlayer(GetOwningPlayer(GetTriggerUnit()))
        call DisplayTimedTextToForce(udg_TempForce,10.,"|cffff0000Your HP is too low to use this ability!|r")
        call DestroyForce(udg_TempForce)
    endif
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Darkness takes nothing returns nothing
endfunction

function RegisterR11_Darkness_LowHP_Cancel takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Darkness_LowHP_Cancel=CreateTrigger()

call TriggerRegisterAnyUnitEventBJ(gg_trg_Darkness_LowHP_Cancel,EVENT_PLAYER_UNIT_SPELL_CAST)

call TriggerAddCondition(gg_trg_Darkness_LowHP_Cancel,Condition(function Trig_Darkness_LowHP_Cancel_Conditions))

call TriggerAddAction(gg_trg_Darkness_LowHP_Cancel,function Trig_Darkness_LowHP_Cancel_Actions)

endfunction




function RegisterR11_Darkness_Cast takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Darkness_Cast=CreateTrigger()

call TriggerRegisterAnyUnitEventBJ(gg_trg_Darkness_Cast,EVENT_PLAYER_UNIT_SPELL_EFFECT)

call TriggerAddCondition(gg_trg_Darkness_Cast,Condition(function Trig_Darkness_Cast_Conditions))

call TriggerAddAction(gg_trg_Darkness_Cast,function Trig_Darkness_Cast_Actions)

endfunction




endlibrary
