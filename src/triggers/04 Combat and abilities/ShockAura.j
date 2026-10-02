library TShockAura requires TGroup
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_ShockAura_Pulse_Start=null
    trigger gg_trg_ShockAura_Pulse=null
endglobals

function Trig_ShockAura_Pulse_Start_Conditions takes nothing returns boolean
    return(udg_InCinematicMode==false)and(IsUnitGroupEmptyBJ(udg_ShockAuraUnitGroup)==false)
endfunction

function Trig_ShockAura_Pulse_Start_Actions takes nothing returns nothing
    call GroupAddGroup(udg_ShockAuraUnitGroup,udg_PendingEffectGroup)
    call ConditionalTriggerExecute(gg_trg_ShockAura_Pulse)
endfunction

function Trig_ShockAura_Pulse_Conditions takes nothing returns boolean
    return(IsUnitGroupEmptyBJ(udg_PendingEffectGroup)==false)
endfunction

function Trig_ShockAura_Pulse_Filter_IsAlive takes nothing returns boolean
    return(IsUnitAliveBJ(GetFilterUnit()))
endfunction

function Trig_ShockAura_Pulse_Filter_IsEnemy takes nothing returns boolean
    return(IsUnitEnemy(GetFilterUnit(),GetOwningPlayer(udg_CurrentEffectUnit)))
endfunction

function Trig_ShockAura_Pulse_Filter_AliveEnemy takes nothing returns boolean
    return GetBooleanAnd(Trig_ShockAura_Pulse_Filter_IsAlive(),Trig_ShockAura_Pulse_Filter_IsEnemy())
endfunction

function Trig_ShockAura_Pulse_Filter_NotInvulnerable takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('Avul',GetFilterUnit())<=0) // 'Avul': standard ability reference "Invulnerable"
endfunction

function Trig_ShockAura_Pulse_Filter_ValidTarget takes nothing returns boolean
    return GetBooleanAnd(Trig_ShockAura_Pulse_Filter_AliveEnemy(),Trig_ShockAura_Pulse_Filter_NotInvulnerable())
endfunction

function Trig_ShockAura_Pulse_ShockEnemy takes nothing returns nothing
    call AddSpecialEffectTargetUnitBJ("origin",GetEnumUnit(),"Abilities\\Spells\\Orc\\LightningShield\\LightningShieldBuff.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    set udg_DamageElement=3
    // ((unit level of udg_CurrentEffectUnit) plus (1) treated as a decimal-capable number) times (15).
    call UnitDamageTargetBJ(udg_CurrentEffectUnit,GetEnumUnit(),(I2R((GetUnitLevel(udg_CurrentEffectUnit)+1))*15.),ATTACK_TYPE_NORMAL,DAMAGE_TYPE_MAGIC)
endfunction

function Trig_ShockAura_Pulse_IsSourceActive takes nothing returns boolean
    return(IsUnitHiddenBJ(udg_CurrentEffectUnit)==false)and(IsUnitAliveBJ(udg_CurrentEffectUnit))and(GetUnitAbilityLevelSwapped('Avul',udg_CurrentEffectUnit)<=0) // 'Avul': standard ability reference "Invulnerable"
endfunction

function Trig_ShockAura_Pulse_Actions takes nothing returns nothing
    set udg_CurrentEffectUnit=GroupPickRandomUnit(udg_PendingEffectGroup)
    call GroupRemoveUnitSimple(udg_CurrentEffectUnit,udg_PendingEffectGroup)
    if(Trig_ShockAura_Pulse_IsSourceActive())then
        set udg_TempPoint=GetUnitLoc(udg_CurrentEffectUnit)
        set udg_TempGroup=Group_UnitsInRangeOfLoc(300.,udg_TempPoint,Condition(function Trig_ShockAura_Pulse_Filter_ValidTarget))
        call RemoveLocation(udg_TempPoint)
        call ForGroupBJ(udg_TempGroup,function Trig_ShockAura_Pulse_ShockEnemy)
        call DestroyGroup(udg_TempGroup)
    endif
    call ConditionalTriggerExecute(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_ShockAura automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_ShockAura (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_ShockAura takes nothing returns nothing
endfunction

function Register_ShockAura_Pulse_Start takes nothing returns nothing
    set gg_trg_ShockAura_Pulse_Start=CreateTrigger()
    call TriggerRegisterTimerEventPeriodic(gg_trg_ShockAura_Pulse_Start,.5)
    call TriggerAddCondition(gg_trg_ShockAura_Pulse_Start,Condition(function Trig_ShockAura_Pulse_Start_Conditions))
    call TriggerAddAction(gg_trg_ShockAura_Pulse_Start,function Trig_ShockAura_Pulse_Start_Actions)
endfunction

function Register_ShockAura_Pulse takes nothing returns nothing
    set gg_trg_ShockAura_Pulse=CreateTrigger()
    call DisableTrigger(gg_trg_ShockAura_Pulse)
    call TriggerAddCondition(gg_trg_ShockAura_Pulse,Condition(function Trig_ShockAura_Pulse_Conditions))
    call TriggerAddAction(gg_trg_ShockAura_Pulse,function Trig_ShockAura_Pulse_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_ShockAura takes nothing returns nothing
    call Register_ShockAura_Pulse_Start()
    call Register_ShockAura_Pulse()
endfunction

endlibrary
