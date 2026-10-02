library TFireAura requires TGroup, TProf
function Trig_FireAura_Pulse_Start_Conditions takes nothing returns boolean
    return(udg_InCinematicMode==false)and(IsUnitGroupEmptyBJ(udg_ImmolationAuraGroup)==false)
endfunction

function Trig_FireAura_Pulse_Start_Actions takes nothing returns nothing
    call GroupAddGroup(udg_ImmolationAuraGroup,udg_PendingEffectGroup)
    call ConditionalTriggerExecute(gg_trg_FireAura_Pulse)
endfunction

function Trig_FireAura_Pulse_Conditions takes nothing returns boolean
    return(IsUnitGroupEmptyBJ(udg_PendingEffectGroup)==false)
endfunction

function Trig_FireAura_Pulse_Filter_IsAlive takes nothing returns boolean
    return(IsUnitAliveBJ(GetFilterUnit()))
endfunction

function Trig_FireAura_Pulse_Filter_IsEnemy takes nothing returns boolean
    return(IsUnitEnemy(GetFilterUnit(),GetOwningPlayer(udg_CurrentEffectUnit)))
endfunction

function Trig_FireAura_Pulse_Filter_AliveEnemy takes nothing returns boolean
    return GetBooleanAnd(Trig_FireAura_Pulse_Filter_IsAlive(),Trig_FireAura_Pulse_Filter_IsEnemy())
endfunction

function Trig_FireAura_Pulse_Filter_NotInvulnerable takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('Avul',GetFilterUnit())<=0) // 'Avul': standard ability reference "Invulnerable"
endfunction

function Trig_FireAura_Pulse_Filter_ValidTarget takes nothing returns boolean
    return GetBooleanAnd(Trig_FireAura_Pulse_Filter_AliveEnemy(),Trig_FireAura_Pulse_Filter_NotInvulnerable())
endfunction

function Trig_FireAura_Pulse_UseMainHandDamage takes nothing returns boolean
    return(udg_AbilityLevelShift)
endfunction

function Trig_FireAura_Pulse_BurnEnemy takes nothing returns nothing
    call AddSpecialEffectTargetUnitBJ("head",GetEnumUnit(),"Abilities\\Spells\\NightElf\\Immolation\\ImmolationDamage.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    set udg_DamageElement=1
    // Udg_TempInteger treated as a decimal-capable number.
    call UnitDamageTargetBJ(udg_CurrentEffectUnit,GetEnumUnit(),I2R(udg_TempInteger),ATTACK_TYPE_NORMAL,DAMAGE_TYPE_MAGIC)
endfunction

function Trig_FireAura_Pulse_IsSourceActive takes nothing returns boolean
    return(IsUnitHiddenBJ(udg_CurrentEffectUnit)==false)and(IsUnitAliveBJ(udg_CurrentEffectUnit))and(GetUnitAbilityLevelSwapped('Avul',udg_CurrentEffectUnit)<=0) // 'Avul': standard ability reference "Invulnerable"
endfunction

function Trig_FireAura_Pulse_Actions takes nothing returns nothing
    set udg_CurrentEffectUnit=GroupPickRandomUnit(udg_PendingEffectGroup)
    call GroupRemoveUnitSimple(udg_CurrentEffectUnit,udg_PendingEffectGroup)
    if(Trig_FireAura_Pulse_IsSourceActive())then
        set udg_TempPoint=GetUnitLoc(udg_CurrentEffectUnit)
        set udg_TempGroup=Group_UnitsInRangeOfLoc(300.,udg_TempPoint,Condition(function Trig_FireAura_Pulse_Filter_ValidTarget))
        call RemoveLocation(udg_TempPoint)
        // (unit level of udg_CurrentEffectUnit) times (2).
        set udg_TempInteger=(GetUnitLevel(udg_CurrentEffectUnit)*2)
        if(Trig_FireAura_Pulse_UseMainHandDamage())then
            // (udg_TempInteger) plus ((BlzGetUnitBaseDamage(udg_CurrentEffectUnit, 0)) divided by (2)).
            set udg_TempInteger=(udg_TempInteger+(BlzGetUnitBaseDamage(udg_CurrentEffectUnit,0)/ 2))
        else
            // (udg_TempInteger) plus ((BlzGetUnitBaseDamage(udg_CurrentEffectUnit, 1)) divided by (2)).
            set udg_TempInteger=(udg_TempInteger+(BlzGetUnitBaseDamage(udg_CurrentEffectUnit,1)/ 2))
        endif
        set udg_TempReal=Prof_RodPower(udg_CurrentEffectUnit)
        // ((udg_TempInteger treated as a decimal-capable number) times (udg_TempReal)) with its decimal part removed.
        set udg_TempInteger=R2I((I2R(udg_TempInteger)*udg_TempReal))
        call ForGroupBJ(udg_TempGroup,function Trig_FireAura_Pulse_BurnEnemy)
        call DestroyGroup(udg_TempGroup)
    endif
    call ConditionalTriggerExecute(GetTriggeringTrigger())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_FireAura takes nothing returns nothing
endfunction
function RegisterR11_FireAura_Pulse_Start takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_FireAura_Pulse_Start=CreateTrigger()
    call TriggerRegisterTimerEventPeriodic(gg_trg_FireAura_Pulse_Start,1.)
    call TriggerAddCondition(gg_trg_FireAura_Pulse_Start,Condition(function Trig_FireAura_Pulse_Start_Conditions))
    call TriggerAddAction(gg_trg_FireAura_Pulse_Start,function Trig_FireAura_Pulse_Start_Actions)
endfunction
function RegisterR11_FireAura_Pulse takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_FireAura_Pulse=CreateTrigger()
    call DisableTrigger(gg_trg_FireAura_Pulse)
    call TriggerAddCondition(gg_trg_FireAura_Pulse,Condition(function Trig_FireAura_Pulse_Conditions))
    call TriggerAddAction(gg_trg_FireAura_Pulse,function Trig_FireAura_Pulse_Actions)
endfunction




endlibrary
