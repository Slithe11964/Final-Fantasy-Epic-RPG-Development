library TOblivion requires TAbil, TGroup, TLoc, TProf, TText
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Oblivion_Cast=null
    trigger gg_trg_Oblivion_Pulse_Start=null
    trigger gg_trg_Oblivion_Pulse=null
    trigger gg_trg_Oblivion_Dummy_Death=null
endglobals

function Trig_Oblivion_Cast_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A0ZV') // 'A0ZV': ability "!Oblivion"
endfunction

function Trig_Oblivion_Cast_NoTargetUnit takes nothing returns boolean
    return(GetSpellTargetUnit()==null)
endfunction

function Trig_Oblivion_Cast_Actions takes nothing returns nothing
    if(Trig_Oblivion_Cast_NoTargetUnit())then
        set udg_TempPoint=GetSpellTargetLoc()
    else
        set udg_TempPoint=GetUnitLoc(GetSpellTargetUnit())
    endif
    call CreateNUnitsAtLocFacingLocBJ(1,'h01B',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,udg_TempPoint) // 'h01B': unit "Proxy Dummy"
    set udg_TempHandleId=GetHandleIdBJ(GetLastCreatedUnit())
    call SaveUnitHandleBJ(GetTriggerUnit(),0,udg_TempHandleId,udg_ProxyDamageHash)
    // Result 1: (BlzGetAbilityManaCost(GetSpellAbilityId(), Abil_GetLevel(the triggering unit,
    // GetSpellAbilityId()))) divided by (3).
    set udg_TempInteger=(BlzGetAbilityManaCost(GetSpellAbilityId(),Abil_GetLevel(GetTriggerUnit(),GetSpellAbilityId()))/ 3)
    // (udg_TempInteger) plus ((Intelligence of the triggering unit) divided by (2); drop the remainder).
    set udg_TempInteger=(udg_TempInteger+(GetHeroStatBJ(bj_HEROSTAT_INT,GetTriggerUnit(),true)/ 2))
    set udg_TempReal=Prof_StaffPower(GetTriggerUnit())
    // ((udg_TempInteger treated as a decimal-capable number) times (udg_TempReal)) with its decimal part removed.
    call BlzSetUnitMaxHP(GetLastCreatedUnit(),R2I((I2R(udg_TempInteger)*udg_TempReal)))
    // (udg_TempInteger) times (3).
    set udg_TempInteger=(udg_TempInteger*3)
    set udg_TempReal=Prof_StaffPower(GetTriggerUnit())
    // (udg_TempInteger treated as a decimal-capable number) times (udg_TempReal).
    call SaveRealBJ((I2R(udg_TempInteger)*udg_TempReal),1,udg_TempHandleId,udg_ProxyDamageHash)
    call SaveIntegerBJ(3,2,udg_TempHandleId,udg_ProxyDamageHash)
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(8.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call GroupAddUnitSimple(GetLastCreatedUnit(),udg_OblivionDummyGroup)
    call RemoveLocation(udg_TempPoint)
endfunction

function Trig_Oblivion_Pulse_Start_Conditions takes nothing returns boolean
    return(udg_InCinematicMode==false)and(IsUnitGroupEmptyBJ(udg_OblivionDummyGroup)==false)
endfunction

function Trig_Oblivion_Pulse_Start_Actions takes nothing returns nothing
    call GroupAddGroup(udg_OblivionDummyGroup,udg_PendingEffectGroup)
    call ConditionalTriggerExecute(gg_trg_Oblivion_Pulse)
endfunction

function Trig_Oblivion_Pulse_Conditions takes nothing returns boolean
    return(IsUnitGroupEmptyBJ(udg_PendingEffectGroup)==false)
endfunction

function Trig_Oblivion_Pulse_IsEvenLoopIndex takes nothing returns boolean
    // The remainder after dividing (loop counter A) by (2).
    return(ModuloInteger(GetForLoopIndexA(),2)==0)
endfunction

function Trig_Oblivion_Pulse_Filter_IsAlly takes nothing returns boolean
    return(IsUnitAlly(GetFilterUnit(),GetOwningPlayer(udg_CurrentEffectUnit)))
endfunction

function Trig_Oblivion_Pulse_Filter_IsUndead takes nothing returns boolean
    return(IsUnitType(GetFilterUnit(),UNIT_TYPE_UNDEAD))!=null
endfunction

function Trig_Oblivion_Pulse_Filter_HasBerserk takes nothing returns boolean
    return(UnitHasBuffBJ(GetFilterUnit(),'B05T')) // 'B05T': buff tooltip "Zombie"
endfunction

function Trig_Oblivion_Pulse_Filter_UndeadOrBerserk takes nothing returns boolean
    return GetBooleanOr(Trig_Oblivion_Pulse_Filter_IsUndead(),Trig_Oblivion_Pulse_Filter_HasBerserk())
endfunction

function Trig_Oblivion_Pulse_Filter_AllyUndead takes nothing returns boolean
    return GetBooleanAnd(Trig_Oblivion_Pulse_Filter_IsAlly(),Trig_Oblivion_Pulse_Filter_UndeadOrBerserk())
endfunction

function Trig_Oblivion_Pulse_Filter_IsAlive takes nothing returns boolean
    return(IsUnitAliveBJ(GetFilterUnit()))
endfunction

function Trig_Oblivion_Pulse_Filter_NotInvulnerable takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('Avul',GetFilterUnit())<=0) // 'Avul': standard ability reference "Invulnerable"
endfunction

function Trig_Oblivion_Pulse_Filter_AliveValid takes nothing returns boolean
    return GetBooleanAnd(Trig_Oblivion_Pulse_Filter_IsAlive(),Trig_Oblivion_Pulse_Filter_NotInvulnerable())
endfunction

function Trig_Oblivion_Pulse_Filter_HealTarget takes nothing returns boolean
    return GetBooleanAnd(Trig_Oblivion_Pulse_Filter_AllyUndead(),Trig_Oblivion_Pulse_Filter_AliveValid())
endfunction

function Trig_Oblivion_Pulse_IsEnumHero takes nothing returns boolean
    return(IsUnitType(GetEnumUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Oblivion_Pulse_HealAlly takes nothing returns nothing
    call AddSpecialEffectTargetUnitBJ("origin",GetEnumUnit(),"Abilities\\Spells\\Undead\\DeathandDecay\\DeathandDecayDamage.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    if(Trig_Oblivion_Pulse_IsEnumHero())then
        // Result 1: udg_TempInteger treated as a decimal-capable number.
        // Result 2: a random decimal number between 15 and 16.
        // Result 3: (result 2) divided by (16).
        // Result 4: (result 1) times (result 3).
        set udg_TempReal=(I2R(udg_TempInteger)*(GetRandomReal(15.,16.)/ 16.))
    else
        // Result 1: udg_TempInteger treated as a decimal-capable number.
        // Result 2: a random decimal number between 15 and 16.
        // Result 3: (result 2) divided by (32).
        // Result 4: (result 1) times (result 3).
        set udg_TempReal=(I2R(udg_TempInteger)*(GetRandomReal(15.,16.)/ 32.))
    endif
    // (current health of the unit being visited) plus (udg_TempReal).
    call SetUnitLifeBJ(GetEnumUnit(),(GetUnitStateSwap(UNIT_STATE_LIFE,GetEnumUnit())+udg_TempReal))
    call Text_FloatingDamage(GetEnumUnit(),true,0,udg_TempReal,false,0)
endfunction

function Trig_Oblivion_Pulse_Filter_EnemyIsAlive takes nothing returns boolean
    return(IsUnitAliveBJ(GetFilterUnit()))
endfunction

function Trig_Oblivion_Pulse_Filter_IsEnemy takes nothing returns boolean
    return(IsUnitEnemy(GetFilterUnit(),GetOwningPlayer(udg_CurrentEffectUnit)))
endfunction

function Trig_Oblivion_Pulse_Filter_AliveEnemy takes nothing returns boolean
    return GetBooleanAnd(Trig_Oblivion_Pulse_Filter_EnemyIsAlive(),Trig_Oblivion_Pulse_Filter_IsEnemy())
endfunction

function Trig_Oblivion_Pulse_Filter_EnemyNotInvulnerable takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('Avul',GetFilterUnit())<=0) // 'Avul': standard ability reference "Invulnerable"
endfunction

function Trig_Oblivion_Pulse_Filter_DamageTarget takes nothing returns boolean
    return GetBooleanAnd(Trig_Oblivion_Pulse_Filter_AliveEnemy(),Trig_Oblivion_Pulse_Filter_EnemyNotInvulnerable())
endfunction

function Trig_Oblivion_Pulse_DamageEnemy takes nothing returns nothing
    call AddSpecialEffectTargetUnitBJ("origin",GetEnumUnit(),"Abilities\\Spells\\Undead\\DeathandDecay\\DeathandDecayDamage.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call UnitDamageTargetBJ(udg_CurrentEffectUnit,GetEnumUnit(),100.,ATTACK_TYPE_NORMAL,DAMAGE_TYPE_MAGIC)
endfunction

function Trig_Oblivion_Pulse_Actions takes nothing returns nothing
    set udg_CurrentEffectUnit=GroupPickRandomUnit(udg_PendingEffectGroup)
    call GroupRemoveUnitSimple(udg_CurrentEffectUnit,udg_PendingEffectGroup)
    set udg_TempPoint=GetUnitLoc(udg_CurrentEffectUnit)
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=$C // $C = 12
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        // Calculation 1:
        // A random decimal number between 256 and 836.
        // Calculation 2:
        // (30) times (loop counter A treated as a decimal-capable number).
        set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,GetRandomReal(256.,836.),(30.*I2R(GetForLoopIndexA())))
        if(Trig_Oblivion_Pulse_IsEvenLoopIndex())then
            call AddSpecialEffectLocBJ(udg_TempPoint2,"Abilities\\Spells\\Undead\\Unsummon\\UnsummonTarget.mdl")
        else
            call AddSpecialEffectLocBJ(udg_TempPoint2,"Objects\\Spawnmodels\\Undead\\UndeadDissipate\\UndeadDissipate.mdl")
        endif
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint2)
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    set udg_TempGroup=Group_UnitsInRangeOfLoc(900.,udg_TempPoint,Condition(function Trig_Oblivion_Pulse_Filter_HealTarget))
    set udg_TempInteger=BlzGetUnitMaxHP(udg_CurrentEffectUnit)
    call ForGroupBJ(udg_TempGroup,function Trig_Oblivion_Pulse_HealAlly)
    call DestroyGroup(udg_TempGroup)
    set udg_TempGroup=Group_UnitsInRangeOfLoc(900.,udg_TempPoint,Condition(function Trig_Oblivion_Pulse_Filter_DamageTarget))
    call RemoveLocation(udg_TempPoint)
    call ForGroupBJ(udg_TempGroup,function Trig_Oblivion_Pulse_DamageEnemy)
    call DestroyGroup(udg_TempGroup)
    call ConditionalTriggerExecute(GetTriggeringTrigger())
endfunction

function Trig_Oblivion_Dummy_Death_Conditions takes nothing returns boolean
    return(IsUnitInGroup(GetTriggerUnit(),udg_OblivionDummyGroup))
endfunction

function Trig_Oblivion_Dummy_Death_Actions takes nothing returns nothing
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_OblivionDummyGroup)
endfunction

// World Editor calls InitTrig_Oblivion automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Oblivion (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Oblivion takes nothing returns nothing
endfunction

function Register_Oblivion_Cast takes nothing returns nothing
    set gg_trg_Oblivion_Cast=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Oblivion_Cast,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Oblivion_Cast,Condition(function Trig_Oblivion_Cast_Conditions))
    call TriggerAddAction(gg_trg_Oblivion_Cast,function Trig_Oblivion_Cast_Actions)
endfunction

function Register_Oblivion_Pulse_Start takes nothing returns nothing
    set gg_trg_Oblivion_Pulse_Start=CreateTrigger()
    call TriggerRegisterTimerEventPeriodic(gg_trg_Oblivion_Pulse_Start,.8)
    call TriggerAddCondition(gg_trg_Oblivion_Pulse_Start,Condition(function Trig_Oblivion_Pulse_Start_Conditions))
    call TriggerAddAction(gg_trg_Oblivion_Pulse_Start,function Trig_Oblivion_Pulse_Start_Actions)
endfunction

function Register_Oblivion_Pulse takes nothing returns nothing
    set gg_trg_Oblivion_Pulse=CreateTrigger()
    call DisableTrigger(gg_trg_Oblivion_Pulse)
    call TriggerAddCondition(gg_trg_Oblivion_Pulse,Condition(function Trig_Oblivion_Pulse_Conditions))
    call TriggerAddAction(gg_trg_Oblivion_Pulse,function Trig_Oblivion_Pulse_Actions)
endfunction

function Register_Oblivion_Dummy_Death takes nothing returns nothing
    set gg_trg_Oblivion_Dummy_Death=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Oblivion_Dummy_Death,EVENT_PLAYER_UNIT_DEATH)
    call TriggerAddCondition(gg_trg_Oblivion_Dummy_Death,Condition(function Trig_Oblivion_Dummy_Death_Conditions))
    call TriggerAddAction(gg_trg_Oblivion_Dummy_Death,function Trig_Oblivion_Dummy_Death_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Oblivion takes nothing returns nothing
    call Register_Oblivion_Cast()
    call Register_Oblivion_Pulse_Start()
    call Register_Oblivion_Pulse() // starts off; run by Oblivion
    call Register_Oblivion_Dummy_Death()
endfunction

endlibrary
