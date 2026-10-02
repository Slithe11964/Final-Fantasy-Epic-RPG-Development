library TDeath requires TBerserk, TGoliathTonic, TGroup, TRunic
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Death_Watch_Group1=null
    trigger gg_trg_Death_Watch_Group2=null
    trigger gg_trg_Death_Watch_Group3=null
    trigger gg_trg_Death_Explosion_Queue=null
    trigger gg_trg_Death_Explosion_Start=null
    trigger gg_trg_Death_Explosion_Blast=null
endglobals

function Trig_Death_Watch_Group1_Conditions takes nothing returns boolean
    return(IsUnitInGroup(GetTriggerUnit(),udg_BerserkGroup))
endfunction

function Trig_Death_Watch_Group1_Actions takes nothing returns nothing
    call Berserk_Remove(GetTriggerUnit())
endfunction

function Trig_Death_Watch_Group2_Conditions takes nothing returns boolean
    return(IsUnitInGroup(GetTriggerUnit(),udg_GoliathTonicGroup))
endfunction

function Trig_Death_Watch_Group2_Actions takes nothing returns nothing
    call GoliathTonic_Remove(GetTriggerUnit())
endfunction

function Trig_Death_Watch_Group3_Conditions takes nothing returns boolean
    return(IsUnitInGroup(GetTriggerUnit(),udg_RunicGroup))
endfunction

function Trig_Death_Watch_Group3_Actions takes nothing returns nothing
    call Runic_Remove(GetTriggerUnit())
endfunction

function Trig_Death_Explosion_Queue_Conditions takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0FQ',GetTriggerUnit())>0) // 'A0FQ': ability "Explode Upon Death"
endfunction

function Trig_Death_Explosion_Queue_Actions takes nothing returns nothing
    call GroupAddUnitSimple(GetTriggerUnit(),udg_DeathExplodeGroup)
    call StartTimerBJ(udg_DeathExplodeTimer,false,.01)
endfunction

function Trig_Death_Explosion_Start_Actions takes nothing returns nothing
    call GroupAddGroup(udg_DeathExplodeGroup,udg_PendingEffectGroup)
    call ConditionalTriggerExecute(gg_trg_Death_Explosion_Blast)
endfunction

function Trig_Death_Explosion_Blast_Conditions takes nothing returns boolean
    return(IsUnitGroupEmptyBJ(udg_PendingEffectGroup)==false)
endfunction

function Trig_Death_Explosion_Blast_FilterAlive takes nothing returns boolean
    return(IsUnitAliveBJ(GetFilterUnit()))
endfunction

function Trig_Death_Explosion_Blast_FilterNotInvulnerable takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('Avul',GetFilterUnit())<=0) // 'Avul': standard ability reference "Invulnerable"
endfunction

function Trig_Death_Explosion_Blast_FilterAliveVulnerable takes nothing returns boolean
    return GetBooleanAnd(Trig_Death_Explosion_Blast_FilterAlive(),Trig_Death_Explosion_Blast_FilterNotInvulnerable())
endfunction

function Trig_Death_Explosion_Blast_FilterEnemy takes nothing returns boolean
    return(IsUnitEnemy(GetFilterUnit(),GetOwningPlayer(udg_CurrentEffectUnit)))
endfunction

function Trig_Death_Explosion_Blast_FilterHitByExplosion takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0FV',GetFilterUnit())>0) // 'A0FV': ability "Hit by Death Explosion"
endfunction

function Trig_Death_Explosion_Blast_FilterEnemyOrMarked takes nothing returns boolean
    return GetBooleanOr(Trig_Death_Explosion_Blast_FilterEnemy(),Trig_Death_Explosion_Blast_FilterHitByExplosion())
endfunction

function Trig_Death_Explosion_Blast_FilterTarget takes nothing returns boolean
    return GetBooleanAnd(Trig_Death_Explosion_Blast_FilterAliveVulnerable(),Trig_Death_Explosion_Blast_FilterEnemyOrMarked())
endfunction

function Trig_Death_Explosion_Blast_IsPhysicalExplosion takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A16V',udg_CurrentEffectUnit)>0) // 'A16V': ability "Physical Explosion"
endfunction

function Trig_Death_Explosion_Blast_DamageTarget takes nothing returns nothing
    set udg_DmgFlagUnavoidable=-1
    if(Trig_Death_Explosion_Blast_IsPhysicalExplosion())then
        call UnitDamageTargetBJ(udg_CurrentEffectUnit,GetEnumUnit(),GetUnitStateSwap(UNIT_STATE_MAX_LIFE,udg_CurrentEffectUnit),ATTACK_TYPE_CHAOS,DAMAGE_TYPE_NORMAL)
    else
        call UnitDamageTargetBJ(udg_CurrentEffectUnit,GetEnumUnit(),GetUnitStateSwap(UNIT_STATE_MAX_LIFE,udg_CurrentEffectUnit),ATTACK_TYPE_NORMAL,DAMAGE_TYPE_UNIVERSAL)
    endif
endfunction

function Trig_Death_Explosion_Blast_Actions takes nothing returns nothing
    set udg_CurrentEffectUnit=GroupPickRandomUnit(udg_PendingEffectGroup)
    call GroupRemoveUnitSimple(udg_CurrentEffectUnit,udg_PendingEffectGroup)
    set udg_TempPoint=GetUnitLoc(udg_CurrentEffectUnit)
    call AddSpecialEffectLocBJ(udg_TempPoint,"Objects\\Spawnmodels\\Other\\NeutralBuildingExplosion\\NeutralBuildingExplosion.mdl")
    call BlzSetSpecialEffectScale(GetLastCreatedEffectBJ(),2.)
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    set udg_TempGroup=Group_UnitsInRangeOfLoc(256.,udg_TempPoint,Condition(function Trig_Death_Explosion_Blast_FilterTarget))
    call RemoveLocation(udg_TempPoint)
    call ForGroupBJ(udg_TempGroup,function Trig_Death_Explosion_Blast_DamageTarget)
    call DestroyGroup(udg_TempGroup)
    call ConditionalTriggerExecute(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_Death automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Death_Part1 / RegisterTriggers_Death_Part2 (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Death takes nothing returns nothing
endfunction

function Register_Death_Watch_Group1 takes nothing returns nothing
    set gg_trg_Death_Watch_Group1=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Death_Watch_Group1,EVENT_PLAYER_UNIT_DEATH)
    call TriggerAddCondition(gg_trg_Death_Watch_Group1,Condition(function Trig_Death_Watch_Group1_Conditions))
    call TriggerAddAction(gg_trg_Death_Watch_Group1,function Trig_Death_Watch_Group1_Actions)
endfunction

function Register_Death_Watch_Group2 takes nothing returns nothing
    set gg_trg_Death_Watch_Group2=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Death_Watch_Group2,EVENT_PLAYER_UNIT_DEATH)
    call TriggerAddCondition(gg_trg_Death_Watch_Group2,Condition(function Trig_Death_Watch_Group2_Conditions))
    call TriggerAddAction(gg_trg_Death_Watch_Group2,function Trig_Death_Watch_Group2_Actions)
endfunction

function Register_Death_Watch_Group3 takes nothing returns nothing
    set gg_trg_Death_Watch_Group3=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Death_Watch_Group3,EVENT_PLAYER_UNIT_DEATH)
    call TriggerAddCondition(gg_trg_Death_Watch_Group3,Condition(function Trig_Death_Watch_Group3_Conditions))
    call TriggerAddAction(gg_trg_Death_Watch_Group3,function Trig_Death_Watch_Group3_Actions)
endfunction

function Register_Death_Explosion_Queue takes nothing returns nothing
    set gg_trg_Death_Explosion_Queue=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Death_Explosion_Queue,EVENT_PLAYER_UNIT_DEATH)
    call TriggerAddCondition(gg_trg_Death_Explosion_Queue,Condition(function Trig_Death_Explosion_Queue_Conditions))
    call TriggerAddAction(gg_trg_Death_Explosion_Queue,function Trig_Death_Explosion_Queue_Actions)
endfunction

function Register_Death_Explosion_Start takes nothing returns nothing
    set gg_trg_Death_Explosion_Start=CreateTrigger()
    call TriggerRegisterTimerExpireEventBJ(gg_trg_Death_Explosion_Start,udg_DeathExplodeTimer)
    call TriggerAddAction(gg_trg_Death_Explosion_Start,function Trig_Death_Explosion_Start_Actions)
endfunction

function Register_Death_Explosion_Blast takes nothing returns nothing
    set gg_trg_Death_Explosion_Blast=CreateTrigger()
    call DisableTrigger(gg_trg_Death_Explosion_Blast)
    call TriggerAddCondition(gg_trg_Death_Explosion_Blast,Condition(function Trig_Death_Explosion_Blast_Conditions))
    call TriggerAddAction(gg_trg_Death_Explosion_Blast,function Trig_Death_Explosion_Blast_Actions)
endfunction

// Creates part 1 of 2 of this module's triggers. Called once at startup from
// Startup_RegisterTriggers (MapBootstrap). The parts are registered at different points so that
// triggers sharing an event with other modules keep their original firing order.
function RegisterTriggers_Death_Part1 takes nothing returns nothing
    call Register_Death_Watch_Group1()
    call Register_Death_Watch_Group2()
    call Register_Death_Watch_Group3()
endfunction

// Creates part 2 of 2 of this module's triggers. Called once at startup from
// Startup_RegisterTriggers (MapBootstrap). The parts are registered at different points so that
// triggers sharing an event with other modules keep their original firing order.
function RegisterTriggers_Death_Part2 takes nothing returns nothing
    call Register_Death_Explosion_Queue()
    call Register_Death_Explosion_Start()
    call Register_Death_Explosion_Blast()
endfunction

endlibrary
