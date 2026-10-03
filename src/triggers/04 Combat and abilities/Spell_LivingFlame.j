library TSpellLivingFlame requires TGroup
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Spell_LivingFlame_Apply=null
    trigger gg_trg_Spell_LivingFlame_Tick=null
    trigger gg_trg_Spell_LivingFlame_Spread=null
endglobals

function Trig_Spell_LivingFlame_Apply_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A0YT') // 'A0YT': ability "Living Flame"
endfunction

function Trig_Spell_LivingFlame_Apply_Cond_NoCooldownBuff takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0YV',GetSpellTargetUnit())<=0) // 'A0YV': ability "Living Flame Cool Down"
endfunction

function Trig_Spell_LivingFlame_Apply_Actions takes nothing returns nothing
    call AddSpecialEffectTargetUnitBJ("origin",GetSpellTargetUnit(),"Objects\\Spawnmodels\\Human\\FragmentationShards\\FragBoomSpawn.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call GroupAddUnitSimple(GetSpellTargetUnit(),udg_LivingFlameUnits)
    call UnitAddAbilityBJ('A0YU',GetSpellTargetUnit()) // 'A0YU': ability "Living Flame"
    if(Trig_Spell_LivingFlame_Apply_Cond_NoCooldownBuff())then
        call UnitAddAbilityBJ('A0YV',GetSpellTargetUnit()) // 'A0YV': ability "Living Flame Cool Down"
    endif
endfunction

function Trig_Spell_LivingFlame_Tick_Conditions takes nothing returns boolean
    return(udg_InCinematicMode==false)and(IsUnitGroupEmptyBJ(udg_LivingFlameUnits)==false)
endfunction

function Trig_Spell_LivingFlame_Tick_Actions takes nothing returns nothing
    call GroupAddGroup(udg_LivingFlameUnits,udg_PendingEffectGroup)
    call ConditionalTriggerExecute(gg_trg_Spell_LivingFlame_Spread)
endfunction

function Trig_Spell_LivingFlame_Spread_Conditions takes nothing returns boolean
    return(IsUnitGroupEmptyBJ(udg_PendingEffectGroup)==false)
endfunction

function Trig_Spell_LivingFlame_Spread_Cond_TargetAlive takes nothing returns boolean
    return(IsUnitAliveBJ(GetFilterUnit()))
endfunction

function Trig_Spell_LivingFlame_Spread_Cond_TargetIsAlly takes nothing returns boolean
    return(IsUnitAlly(GetFilterUnit(),GetOwningPlayer(udg_CurrentEffectUnit)))
endfunction

function Trig_Spell_LivingFlame_Spread_Filter_AliveAlly takes nothing returns boolean
    return GetBooleanAnd(Trig_Spell_LivingFlame_Spread_Cond_TargetAlive(),Trig_Spell_LivingFlame_Spread_Cond_TargetIsAlly())
endfunction

function Trig_Spell_LivingFlame_Spread_Cond_NotInvulnerable takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('Avul',GetFilterUnit())<=0) // 'Avul': standard ability reference "Invulnerable"
endfunction

function Trig_Spell_LivingFlame_Spread_Cond_NoCooldownBuff takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0YV',GetFilterUnit())<=0) // 'A0YV': ability "Living Flame Cool Down"
endfunction

function Trig_Spell_LivingFlame_Spread_Filter_Infectable takes nothing returns boolean
    return GetBooleanAnd(Trig_Spell_LivingFlame_Spread_Cond_NotInvulnerable(),Trig_Spell_LivingFlame_Spread_Cond_NoCooldownBuff())
endfunction

function Trig_Spell_LivingFlame_Spread_Filter_SpreadTarget takes nothing returns boolean
    return GetBooleanAnd(Trig_Spell_LivingFlame_Spread_Filter_AliveAlly(),Trig_Spell_LivingFlame_Spread_Filter_Infectable())
endfunction

function Trig_Spell_LivingFlame_Spread_InfectUnit takes nothing returns nothing
    call GroupAddUnitSimple(GetEnumUnit(),udg_LivingFlameUnits)
    call UnitAddAbilityBJ('A0YU',GetEnumUnit()) // 'A0YU': ability "Living Flame"
    call UnitAddAbilityBJ('A0YV',GetEnumUnit()) // 'A0YV': ability "Living Flame Cool Down"
endfunction

function Trig_Spell_LivingFlame_Spread_Cond_HasFlameBuff takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0YU',udg_CurrentEffectUnit)>0) // 'A0YU': ability "Living Flame"
endfunction

function Trig_Spell_LivingFlame_Spread_Cond_CanBurn takes nothing returns boolean
    return(IsUnitHiddenBJ(udg_CurrentEffectUnit)==false)and(IsUnitAliveBJ(udg_CurrentEffectUnit))and(GetUnitAbilityLevelSwapped('Avul',udg_CurrentEffectUnit)<=0)and(GetUnitAbilityLevelSwapped('A0YV',udg_CurrentEffectUnit)<=$A)and(udg_ScriptedBossUnit!=null) // 'Avul': standard ability reference "Invulnerable"; 'A0YV': ability "Living Flame Cool Down"; $A = 10
endfunction

function Trig_Spell_LivingFlame_Spread_Cond_HasFlameBuff2 takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0YU',udg_CurrentEffectUnit)>0) // 'A0YU': ability "Living Flame"
endfunction

function Trig_Spell_LivingFlame_Spread_Cond_BurnedOut takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0YV',udg_CurrentEffectUnit)>=20) // 'A0YV': ability "Living Flame Cool Down"
endfunction

function Trig_Spell_LivingFlame_Spread_Actions takes nothing returns nothing
    set udg_CurrentEffectUnit=GroupPickRandomUnit(udg_PendingEffectGroup)
    call GroupRemoveUnitSimple(udg_CurrentEffectUnit,udg_PendingEffectGroup)
    if(Trig_Spell_LivingFlame_Spread_Cond_BurnedOut())then
        call GroupRemoveUnitSimple(udg_CurrentEffectUnit,udg_LivingFlameUnits)
        call UnitRemoveAbilityBJ('A0YV',udg_CurrentEffectUnit) // 'A0YV': ability "Living Flame Cool Down"
        if(Trig_Spell_LivingFlame_Spread_Cond_HasFlameBuff2())then
            call UnitRemoveAbilityBJ('A0YU',udg_CurrentEffectUnit) // 'A0YU': ability "Living Flame"
        endif
    else
        if(Trig_Spell_LivingFlame_Spread_Cond_CanBurn())then
            set udg_TempPoint=GetUnitLoc(udg_CurrentEffectUnit)
            set udg_TempGroup=Group_UnitsInRangeOfLoc(250.,udg_TempPoint,Condition(function Trig_Spell_LivingFlame_Spread_Filter_SpreadTarget))
            call RemoveLocation(udg_TempPoint)
            call ForGroupBJ(udg_TempGroup,function Trig_Spell_LivingFlame_Spread_InfectUnit)
            call DestroyGroup(udg_TempGroup)
            set udg_DamageElement=1
            call UnitDamageTargetBJ(udg_ScriptedBossUnit,udg_CurrentEffectUnit,(4000.*(GetRandomReal(15.,16.)/ 16.)),ATTACK_TYPE_NORMAL,DAMAGE_TYPE_UNIVERSAL)
        else
            if(Trig_Spell_LivingFlame_Spread_Cond_HasFlameBuff())then
                call UnitRemoveAbilityBJ('A0YU',udg_CurrentEffectUnit) // 'A0YU': ability "Living Flame"
            endif
        endif
        call IncUnitAbilityLevelSwapped('A0YV',udg_CurrentEffectUnit) // 'A0YV': ability "Living Flame Cool Down"
    endif
    call ConditionalTriggerExecute(GetTriggeringTrigger())
endfunction

function InitTrig_Spell_LivingFlame takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Spell_Part4 (module Spell),
// which keeps the original registration order.

function Register_Spell_LivingFlame_Apply takes nothing returns nothing
    set gg_trg_Spell_LivingFlame_Apply=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Spell_LivingFlame_Apply,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Spell_LivingFlame_Apply,Condition(function Trig_Spell_LivingFlame_Apply_Conditions))
    call TriggerAddAction(gg_trg_Spell_LivingFlame_Apply,function Trig_Spell_LivingFlame_Apply_Actions)
endfunction

function Register_Spell_LivingFlame_Tick takes nothing returns nothing
    set gg_trg_Spell_LivingFlame_Tick=CreateTrigger()
    call TriggerRegisterTimerEventPeriodic(gg_trg_Spell_LivingFlame_Tick,1.)
    call TriggerAddCondition(gg_trg_Spell_LivingFlame_Tick,Condition(function Trig_Spell_LivingFlame_Tick_Conditions))
    call TriggerAddAction(gg_trg_Spell_LivingFlame_Tick,function Trig_Spell_LivingFlame_Tick_Actions)
endfunction

function Register_Spell_LivingFlame_Spread takes nothing returns nothing
    set gg_trg_Spell_LivingFlame_Spread=CreateTrigger()
    call DisableTrigger(gg_trg_Spell_LivingFlame_Spread)
    call TriggerAddCondition(gg_trg_Spell_LivingFlame_Spread,Condition(function Trig_Spell_LivingFlame_Spread_Conditions))
    call TriggerAddAction(gg_trg_Spell_LivingFlame_Spread,function Trig_Spell_LivingFlame_Spread_Actions)
endfunction

endlibrary
