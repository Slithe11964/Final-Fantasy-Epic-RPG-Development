library TProphet requires TAbil, TGroup, TProf
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Prophet_Pray_Start=null
    trigger gg_trg_Prophet_Pray_Stop=null
    trigger gg_trg_Prophet_Pray_Tick=null
    trigger gg_trg_Prophet_Pray_Heal=null
    trigger gg_trg_Prophet_BlessingOfLight=null
    trigger gg_trg_Prophet_DivineShield=null
    trigger gg_trg_Prophet_Infinity=null
endglobals

function Trig_Prophet_Pray_Start_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A0PC') // 'A0PC': ability "Pray"
endfunction

function Trig_Prophet_Pray_Start_NoPrayingUnits takes nothing returns boolean
    return(IsUnitGroupEmptyBJ(udg_PrayingUnits))
endfunction

function Trig_Prophet_Pray_Start_Actions takes nothing returns nothing
    if(Trig_Prophet_Pray_Start_NoPrayingUnits())then
        call EnableTrigger(gg_trg_Prophet_Pray_Tick)
    endif
    call GroupAddUnitSimple(GetTriggerUnit(),udg_PrayingUnits)
endfunction

function Trig_Prophet_Pray_Stop_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A0PC') // 'A0PC': ability "Pray"
endfunction

function Trig_Prophet_Pray_Stop_NoPrayingUnits takes nothing returns boolean
    return(IsUnitGroupEmptyBJ(udg_PrayingUnits))
endfunction

function Trig_Prophet_Pray_Stop_Actions takes nothing returns nothing
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_PrayingUnits)
    if(Trig_Prophet_Pray_Stop_NoPrayingUnits())then
        call DisableTrigger(gg_trg_Prophet_Pray_Tick)
    endif
endfunction

function Trig_Prophet_Pray_Tick_Conditions takes nothing returns boolean
    return(udg_InCinematicMode==false)and(IsUnitGroupEmptyBJ(udg_PrayingUnits)==false)
endfunction

function Trig_Prophet_Pray_Tick_Actions takes nothing returns nothing
    call GroupAddGroup(udg_PrayingUnits,udg_PendingEffectGroup)
    call ConditionalTriggerExecute(gg_trg_Prophet_Pray_Heal)
endfunction

function Trig_Prophet_Pray_Heal_Conditions takes nothing returns boolean
    return(IsUnitGroupEmptyBJ(udg_PendingEffectGroup)==false)
endfunction

function Trig_Prophet_Pray_Heal_FilterIsAlly takes nothing returns boolean
    return(IsUnitAlly(GetFilterUnit(),GetOwningPlayer(udg_CurrentEffectUnit)))
endfunction

function Trig_Prophet_Pray_Heal_FilterNotStructure takes nothing returns boolean
    return(IsUnitType(GetFilterUnit(),UNIT_TYPE_STRUCTURE)==false)!=null
endfunction

function Trig_Prophet_Pray_Heal_FilterNotPlayer8 takes nothing returns boolean
    return(GetOwningPlayer(GetFilterUnit())!=Player(8))
endfunction

function Trig_Prophet_Pray_Heal_FilterNotNeutral takes nothing returns boolean
    return(GetOwningPlayer(GetFilterUnit())!=Player(PLAYER_NEUTRAL_PASSIVE))
endfunction

function Trig_Prophet_Pray_Heal_FilterNotNeutralOwner takes nothing returns boolean
    return GetBooleanAnd(Trig_Prophet_Pray_Heal_FilterNotPlayer8(),Trig_Prophet_Pray_Heal_FilterNotNeutral())
endfunction

function Trig_Prophet_Pray_Heal_FilterOwnerCheck takes nothing returns boolean
    return GetBooleanAnd(Trig_Prophet_Pray_Heal_FilterNotStructure(),Trig_Prophet_Pray_Heal_FilterNotNeutralOwner())
endfunction

function Trig_Prophet_Pray_Heal_FilterAllyCheck takes nothing returns boolean
    return GetBooleanAnd(Trig_Prophet_Pray_Heal_FilterIsAlly(),Trig_Prophet_Pray_Heal_FilterOwnerCheck())
endfunction

function Trig_Prophet_Pray_Heal_FilterIsAlive takes nothing returns boolean
    return(IsUnitAliveBJ(GetFilterUnit()))
endfunction

function Trig_Prophet_Pray_Heal_FilterNotInvulnerable takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('Avul',GetFilterUnit())<=0) // 'Avul': standard ability reference "Invulnerable"
endfunction

function Trig_Prophet_Pray_Heal_FilterAliveTargetable takes nothing returns boolean
    return GetBooleanAnd(Trig_Prophet_Pray_Heal_FilterIsAlive(),Trig_Prophet_Pray_Heal_FilterNotInvulnerable())
endfunction

function Trig_Prophet_Pray_Heal_FilterTarget takes nothing returns boolean
    return GetBooleanAnd(Trig_Prophet_Pray_Heal_FilterAllyCheck(),Trig_Prophet_Pray_Heal_FilterAliveTargetable())
endfunction

function Trig_Prophet_Pray_Heal_EnumAcceptsHeal takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0Z8',GetEnumUnit())<=0) // 'A0Z8': ability "Negate Collateral Heals"
endfunction

function Trig_Prophet_Pray_Heal_QueueHealEnum takes nothing returns nothing
    if(Trig_Prophet_Pray_Heal_EnumAcceptsHeal())then
        call AddSpecialEffectTargetUnitBJ("origin",GetEnumUnit(),"Abilities\\Spells\\Undead\\VampiricAura\\VampiricAuraTarget.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        // Result 1: udg_TempInteger treated as a decimal-capable number.
        // Result 2: (LoadRealBJ(2, GetHandleIdBJ(the unit being visited), udg_HealOverTimeHash)) plus (result 1).
        set udg_TempReal=(LoadRealBJ(2,GetHandleIdBJ(GetEnumUnit()),udg_HealOverTimeHash)+I2R(udg_TempInteger))
        call SaveRealBJ(udg_TempReal,2,GetHandleIdBJ(GetEnumUnit()),udg_HealOverTimeHash)
        call GroupAddUnitSimple(GetEnumUnit(),udg_RegenGroup)
    endif
endfunction

function Trig_Prophet_Pray_Heal_Actions takes nothing returns nothing
    set udg_CurrentEffectUnit=GroupPickRandomUnit(udg_PendingEffectGroup)
    call GroupRemoveUnitSimple(udg_CurrentEffectUnit,udg_PendingEffectGroup)
    call SetUnitAnimation(udg_CurrentEffectUnit,"spell")
    set udg_TempPoint=GetUnitLoc(udg_CurrentEffectUnit)
    set udg_TempGroup=Group_UnitsInRangeOfLoc(800.,udg_TempPoint,Condition(function Trig_Prophet_Pray_Heal_FilterTarget))
    call RemoveLocation(udg_TempPoint)
    set udg_TempReal=Prof_StaffPower(udg_CurrentEffectUnit)
    // Result 1: (Intelligence of udg_CurrentEffectUnit) divided by (4); drop the remainder.
    // Result 2: (result 1) plus (50).
    // Result 3: result 2 treated as a decimal-capable number.
    // Result 4: (result 3) times (udg_TempReal).
    // Result 5: (result 4) with its decimal part removed.
    set udg_TempInteger=R2I((I2R(((GetHeroStatBJ(bj_HEROSTAT_INT,udg_CurrentEffectUnit,true)/ 4)+50))*udg_TempReal))
    call ForGroupBJ(udg_TempGroup,function Trig_Prophet_Pray_Heal_QueueHealEnum)
    call DestroyGroup(udg_TempGroup)
    call ConditionalTriggerExecute(GetTriggeringTrigger())
endfunction

function Trig_Prophet_BlessingOfLight_IsBlessingSpell takes nothing returns boolean
    return(GetSpellAbilityId()=='A089')or(GetSpellAbilityId()=='A06Q') // 'A089': ability "Blessing of Light"; 'A06Q': ability "Blessing of Light"
endfunction

function Trig_Prophet_BlessingOfLight_Conditions takes nothing returns boolean
    return(Trig_Prophet_BlessingOfLight_IsBlessingSpell())
endfunction

function Trig_Prophet_BlessingOfLight_FilterIsAlly takes nothing returns boolean
    return(IsUnitAlly(GetFilterUnit(),GetOwningPlayer(GetTriggerUnit())))
endfunction

function Trig_Prophet_BlessingOfLight_FilterNotStructure takes nothing returns boolean
    return(IsUnitType(GetFilterUnit(),UNIT_TYPE_STRUCTURE)==false)!=null
endfunction

function Trig_Prophet_BlessingOfLight_FilterNotCaster takes nothing returns boolean
    return(GetTriggerUnit()!=GetFilterUnit())
endfunction

function Trig_Prophet_BlessingOfLight_FilterStructureCheck takes nothing returns boolean
    return GetBooleanAnd(Trig_Prophet_BlessingOfLight_FilterNotStructure(),Trig_Prophet_BlessingOfLight_FilterNotCaster())
endfunction

function Trig_Prophet_BlessingOfLight_FilterNotPlayer8 takes nothing returns boolean
    return(GetOwningPlayer(GetFilterUnit())!=Player(8))
endfunction

function Trig_Prophet_BlessingOfLight_FilterNotNeutral takes nothing returns boolean
    return(GetOwningPlayer(GetFilterUnit())!=Player(PLAYER_NEUTRAL_PASSIVE))
endfunction

function Trig_Prophet_BlessingOfLight_FilterOwnerCheck takes nothing returns boolean
    return GetBooleanAnd(Trig_Prophet_BlessingOfLight_FilterNotPlayer8(),Trig_Prophet_BlessingOfLight_FilterNotNeutral())
endfunction

function Trig_Prophet_BlessingOfLight_FilterUnitCheck takes nothing returns boolean
    return GetBooleanAnd(Trig_Prophet_BlessingOfLight_FilterStructureCheck(),Trig_Prophet_BlessingOfLight_FilterOwnerCheck())
endfunction

function Trig_Prophet_BlessingOfLight_FilterAllyCheck takes nothing returns boolean
    return GetBooleanAnd(Trig_Prophet_BlessingOfLight_FilterIsAlly(),Trig_Prophet_BlessingOfLight_FilterUnitCheck())
endfunction

function Trig_Prophet_BlessingOfLight_FilterIsAlive takes nothing returns boolean
    return(IsUnitAliveBJ(GetFilterUnit()))
endfunction

function Trig_Prophet_BlessingOfLight_FilterNotInvulnerable takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('Avul',GetFilterUnit())<=0) // 'Avul': standard ability reference "Invulnerable"
endfunction

function Trig_Prophet_BlessingOfLight_FilterAliveTargetable takes nothing returns boolean
    return GetBooleanAnd(Trig_Prophet_BlessingOfLight_FilterIsAlive(),Trig_Prophet_BlessingOfLight_FilterNotInvulnerable())
endfunction

function Trig_Prophet_BlessingOfLight_FilterTarget takes nothing returns boolean
    return GetBooleanAnd(Trig_Prophet_BlessingOfLight_FilterAllyCheck(),Trig_Prophet_BlessingOfLight_FilterAliveTargetable())
endfunction

function Trig_Prophet_BlessingOfLight_CasterIsHero takes nothing returns boolean
    return(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Prophet_BlessingOfLight_EnumNotCaster takes nothing returns boolean
    return(GetTriggerUnit()!=GetEnumUnit())
endfunction

function Trig_Prophet_BlessingOfLight_EnumNegatesHeal takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0Z8',GetEnumUnit())>0) // 'A0Z8': ability "Negate Collateral Heals"
endfunction

function Trig_Prophet_BlessingOfLight_HealEnum takes nothing returns nothing
    set udg_DispelTarget=GetEnumUnit()
    call ConditionalTriggerExecute(gg_trg_Remove_Debuffs)
    if(Trig_Prophet_BlessingOfLight_EnumNegatesHeal())then
        call AddSpecialEffectTargetUnitBJ("overhead",GetEnumUnit(),"Abilities\\Spells\\Undead\\DeathPact\\DeathPactTarget.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
    else
        call AddSpecialEffectTargetUnitBJ("origin",GetEnumUnit(),"Abilities\\Spells\\Items\\AIre\\AIreTarget.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        if(Trig_Prophet_BlessingOfLight_EnumNotCaster())then
            set udg_IsPureDamage=true
            set udg_DmgFlagManaDamage=true
            // (udg_TempInteger treated as a decimal-capable number) times (0.25).
            call UnitDamageTargetBJ(GetTriggerUnit(),GetEnumUnit(),(I2R(udg_TempInteger)*.25),ATTACK_TYPE_NORMAL,DAMAGE_TYPE_UNIVERSAL)
        endif
        set udg_IsPureDamage=true
        // Udg_TempInteger treated as a decimal-capable number.
        call UnitDamageTargetBJ(GetTriggerUnit(),GetEnumUnit(),I2R(udg_TempInteger),ATTACK_TYPE_NORMAL,DAMAGE_TYPE_UNIVERSAL)
    endif
endfunction

function Trig_Prophet_BlessingOfLight_Actions takes nothing returns nothing
    set udg_TempPoint=GetUnitLoc(GetSpellAbilityUnit())
    set udg_TempGroup=Group_UnitsInRangeOfLoc(800.,udg_TempPoint,Condition(function Trig_Prophet_BlessingOfLight_FilterTarget))
    call RemoveLocation(udg_TempPoint)
    // (BlzGetAbilityManaCost(GetSpellAbilityId(), Abil_GetLevel(the triggering unit, GetSpellAbilityId()))) times
    // (3).
    set udg_TempInteger=(BlzGetAbilityManaCost(GetSpellAbilityId(),Abil_GetLevel(GetTriggerUnit(),GetSpellAbilityId()))*3)
    if(Trig_Prophet_BlessingOfLight_CasterIsHero())then
        // (udg_TempInteger) plus ((Intelligence of the triggering unit) times (3)).
        set udg_TempInteger=(udg_TempInteger+(GetHeroStatBJ(bj_HEROSTAT_INT,GetTriggerUnit(),true)*3))
    endif
    set udg_TempReal=Prof_StaffPower(GetTriggerUnit())
    // ((udg_TempInteger treated as a decimal-capable number) times (udg_TempReal)) with its decimal part removed.
    set udg_TempInteger=R2I((I2R(udg_TempInteger)*udg_TempReal))
    call ForGroupBJ(udg_TempGroup,function Trig_Prophet_BlessingOfLight_HealEnum)
    call DestroyGroup(udg_TempGroup)
    set udg_IsPureDamage=true
    // Udg_TempInteger treated as a decimal-capable number.
    call UnitDamageTargetBJ(GetTriggerUnit(),GetTriggerUnit(),I2R(udg_TempInteger),ATTACK_TYPE_NORMAL,DAMAGE_TYPE_UNIVERSAL)
endfunction

function Trig_Prophet_DivineShield_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A0RY') // 'A0RY': ability "Divine Shield"
endfunction

function Trig_Prophet_DivineShield_ExpireLink takes nothing returns nothing
    local timer expiredTimer=GetExpiredTimer()
    local unit u=LoadUnitHandle(udg_DivineShieldHash,GetHandleId(expiredTimer),6)
    local unit l_ward=LoadUnitHandle(udg_DivineShieldHash,GetHandleId(expiredTimer),7)
    call SaveBoolean(udg_DivineShieldHash,GetHandleId(u),0,false)
    call SaveBoolean(udg_DivineShieldHash,GetHandleId(l_ward),3,false)
    call DestroyTimer(expiredTimer)
    set u=null
    set l_ward=null
    set expiredTimer=null
endfunction

function Trig_Prophet_DivineShield_Actions takes nothing returns nothing
    local timer effectTimer=CreateTimer()
    local unit triggeringUnit=GetTriggerUnit()
    local unit l_ward=GetSpellTargetUnit()
    local unit l_prevUnit
    local timer l_prevTimer
    local boolean l_hasLink=LoadBoolean(udg_DivineShieldHash,GetHandleId(triggeringUnit),0)
    local integer abilityLevel=GetUnitAbilityLevel(triggeringUnit,'A0RY') // 'A0RY': ability "Divine Shield"
    local real l_share=.0
    if(abilityLevel==$B)then // $B = 11
        set l_share=5.
    else
        // ((abilityLevel) times (0.25)) plus (1.75).
        set l_share=(abilityLevel*.25)+1.75
    endif
    if(l_hasLink)then
        set l_prevUnit=LoadUnitHandle(udg_DivineShieldHash,GetHandleId(triggeringUnit),1)
        set l_prevTimer=LoadTimerHandle(udg_DivineShieldHash,GetHandleId(triggeringUnit),2)
        call SaveBoolean(udg_DivineShieldHash,GetHandleId(l_prevUnit),3,false)
        call PauseTimer(l_prevTimer)
        call DestroyTimer(l_prevTimer)
        call UnitRemoveAbility(l_prevUnit,'B051') // 'B051': buff "Divine Shield"
    endif
    if(LoadBoolean(udg_DivineShieldHash,GetHandleId(l_ward),3))then
        set l_prevUnit=LoadUnitHandle(udg_DivineShieldHash,GetHandleId(l_ward),4)
        set l_prevTimer=LoadTimerHandle(udg_DivineShieldHash,GetHandleId(l_prevUnit),2)
        call SaveBoolean(udg_DivineShieldHash,GetHandleId(l_prevUnit),3,false)
        call PauseTimer(l_prevTimer)
        call DestroyTimer(l_prevTimer)
        call UnitRemoveAbility(l_ward,'B051') // 'B051': buff "Divine Shield"
    endif
    call SaveBoolean(udg_DivineShieldHash,GetHandleId(triggeringUnit),0,true)
    call SaveUnitHandle(udg_DivineShieldHash,GetHandleId(triggeringUnit),1,l_ward)
    call SaveTimerHandle(udg_DivineShieldHash,GetHandleId(triggeringUnit),2,effectTimer)
    call SaveBoolean(udg_DivineShieldHash,GetHandleId(l_ward),3,true)
    call SaveUnitHandle(udg_DivineShieldHash,GetHandleId(l_ward),4,triggeringUnit)
    call SaveReal(udg_DivineShieldHash,GetHandleId(l_ward),5,l_share)
    call SaveUnitHandle(udg_DivineShieldHash,GetHandleId(effectTimer),6,triggeringUnit)
    call SaveUnitHandle(udg_DivineShieldHash,GetHandleId(effectTimer),7,l_ward)
    call TimerStart(effectTimer,45.,false,function Trig_Prophet_DivineShield_ExpireLink)
    set triggeringUnit=null
    set l_ward=null
    set l_prevUnit=null
    set effectTimer=null
    set l_prevTimer=null
endfunction

function Trig_Prophet_Infinity_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A0RD') // 'A0RD': ability "!Infinity"
endfunction

function Trig_Prophet_Infinity_MasteryPending takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_JobMasterForce[18])==false)and(GetUnitAbilityLevelSwapped('A02F',GetTriggerUnit())==3) // 'A02F': ability "Mastery"
endfunction

function Trig_Prophet_Infinity_FilterIsAlly takes nothing returns boolean
    return(IsUnitAlly(GetFilterUnit(),GetOwningPlayer(GetTriggerUnit())))
endfunction

function Trig_Prophet_Infinity_FilterNotPlayer8 takes nothing returns boolean
    return(GetOwningPlayer(GetFilterUnit())!=Player(8))
endfunction

function Trig_Prophet_Infinity_FilterNotNeutral takes nothing returns boolean
    return(GetOwningPlayer(GetFilterUnit())!=Player(PLAYER_NEUTRAL_PASSIVE))
endfunction

function Trig_Prophet_Infinity_FilterOwnerCheck takes nothing returns boolean
    return GetBooleanAnd(Trig_Prophet_Infinity_FilterNotPlayer8(),Trig_Prophet_Infinity_FilterNotNeutral())
endfunction

function Trig_Prophet_Infinity_FilterAllyCheck takes nothing returns boolean
    return GetBooleanAnd(Trig_Prophet_Infinity_FilterIsAlly(),Trig_Prophet_Infinity_FilterOwnerCheck())
endfunction

function Trig_Prophet_Infinity_FilterNotStructure takes nothing returns boolean
    return(IsUnitType(GetFilterUnit(),UNIT_TYPE_STRUCTURE)==false)!=null
endfunction

function Trig_Prophet_Infinity_FilterNoFinity takes nothing returns boolean
    return(UnitHasBuffBJ(GetFilterUnit(),'B06G')==false) // 'B06G': buff "Finity"
endfunction

function Trig_Prophet_Infinity_FilterStructureCheck takes nothing returns boolean
    return GetBooleanAnd(Trig_Prophet_Infinity_FilterNotStructure(),Trig_Prophet_Infinity_FilterNoFinity())
endfunction

function Trig_Prophet_Infinity_FilterUnitCheck takes nothing returns boolean
    return GetBooleanAnd(Trig_Prophet_Infinity_FilterAllyCheck(),Trig_Prophet_Infinity_FilterStructureCheck())
endfunction

function Trig_Prophet_Infinity_FilterIsAlive takes nothing returns boolean
    return(IsUnitAliveBJ(GetFilterUnit()))
endfunction

function Trig_Prophet_Infinity_FilterNotInvulnerable takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('Avul',GetFilterUnit())<=0) // 'Avul': standard ability reference "Invulnerable"
endfunction

function Trig_Prophet_Infinity_FilterAliveTargetable takes nothing returns boolean
    return GetBooleanAnd(Trig_Prophet_Infinity_FilterIsAlive(),Trig_Prophet_Infinity_FilterNotInvulnerable())
endfunction

function Trig_Prophet_Infinity_FilterTarget takes nothing returns boolean
    return GetBooleanAnd(Trig_Prophet_Infinity_FilterUnitCheck(),Trig_Prophet_Infinity_FilterAliveTargetable())
endfunction

function Trig_Prophet_Infinity_MasteryActive takes nothing returns boolean
    return(udg_TempBoolean)
endfunction

function Trig_Prophet_Infinity_ApplyToEnum takes nothing returns nothing
    if(Trig_Prophet_Infinity_MasteryActive())then
        call UnitAddAbilityBJ('A0KF',GetEnumUnit()) // 'A0KF': ability "Infinity"
        call SetUnitAbilityLevelSwapped('A0KF',GetEnumUnit(),GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))) // 'A0KF': ability "Infinity"
    else
        call UnitRemoveAbilityBJ('A0KF',GetEnumUnit()) // 'A0KF': ability "Infinity"
    endif
    set udg_TempPoint=GetUnitLoc(GetEnumUnit())
    call CreateNUnitsAtLocFacingLocBJ(1,'h02S',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,udg_TempPoint) // 'h02S': unit "Simple Casting Dummy"
    call RemoveLocation(udg_TempPoint)
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(1.5,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A0L2',GetLastCreatedUnit()) // 'A0L2': ability "Infinity"
    call SetUnitAbilityLevelSwapped('A0L2',GetLastCreatedUnit(),udg_TempInteger) // 'A0L2': ability "Infinity"
    call IssueTargetOrderBJ(GetLastCreatedUnit(),"curse",GetEnumUnit())
endfunction

function Trig_Prophet_Infinity_Actions takes nothing returns nothing
    if(Trig_Prophet_Infinity_MasteryPending())then
        set udg_TempBoolean=true
        set udg_InfinityAbsorbed[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=.0
    else
        set udg_TempBoolean=false
    endif
    set udg_TempPoint=GetUnitLoc(GetSpellAbilityUnit())
    set udg_TempGroup=Group_UnitsInRangeOfLoc(1000.,udg_TempPoint,Condition(function Trig_Prophet_Infinity_FilterTarget))
    call RemoveLocation(udg_TempPoint)
    set udg_TempInteger=GetUnitAbilityLevelSwapped(GetSpellAbilityId(),GetTriggerUnit())
    call ForGroupBJ(udg_TempGroup,function Trig_Prophet_Infinity_ApplyToEnum)
    call DestroyGroup(udg_TempGroup)
endfunction

// World Editor calls InitTrig_Prophet automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Prophet (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Prophet takes nothing returns nothing
endfunction

function Register_Prophet_Pray_Start takes nothing returns nothing
    set gg_trg_Prophet_Pray_Start=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Prophet_Pray_Start,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Prophet_Pray_Start,Condition(function Trig_Prophet_Pray_Start_Conditions))
    call TriggerAddAction(gg_trg_Prophet_Pray_Start,function Trig_Prophet_Pray_Start_Actions)
endfunction

function Register_Prophet_Pray_Stop takes nothing returns nothing
    set gg_trg_Prophet_Pray_Stop=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Prophet_Pray_Stop,EVENT_PLAYER_UNIT_SPELL_ENDCAST)
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Prophet_Pray_Stop,EVENT_PLAYER_UNIT_SPELL_FINISH)
    call TriggerAddCondition(gg_trg_Prophet_Pray_Stop,Condition(function Trig_Prophet_Pray_Stop_Conditions))
    call TriggerAddAction(gg_trg_Prophet_Pray_Stop,function Trig_Prophet_Pray_Stop_Actions)
endfunction

function Register_Prophet_Pray_Tick takes nothing returns nothing
    set gg_trg_Prophet_Pray_Tick=CreateTrigger()
    call DisableTrigger(gg_trg_Prophet_Pray_Tick)
    call TriggerRegisterTimerEventPeriodic(gg_trg_Prophet_Pray_Tick,1.)
    call TriggerAddCondition(gg_trg_Prophet_Pray_Tick,Condition(function Trig_Prophet_Pray_Tick_Conditions))
    call TriggerAddAction(gg_trg_Prophet_Pray_Tick,function Trig_Prophet_Pray_Tick_Actions)
endfunction

function Register_Prophet_Pray_Heal takes nothing returns nothing
    set gg_trg_Prophet_Pray_Heal=CreateTrigger()
    call DisableTrigger(gg_trg_Prophet_Pray_Heal)
    call TriggerAddCondition(gg_trg_Prophet_Pray_Heal,Condition(function Trig_Prophet_Pray_Heal_Conditions))
    call TriggerAddAction(gg_trg_Prophet_Pray_Heal,function Trig_Prophet_Pray_Heal_Actions)
endfunction

function Register_Prophet_BlessingOfLight takes nothing returns nothing
    set gg_trg_Prophet_BlessingOfLight=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Prophet_BlessingOfLight,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Prophet_BlessingOfLight,Condition(function Trig_Prophet_BlessingOfLight_Conditions))
    call TriggerAddAction(gg_trg_Prophet_BlessingOfLight,function Trig_Prophet_BlessingOfLight_Actions)
endfunction

function Register_Prophet_DivineShield takes nothing returns nothing
    set gg_trg_Prophet_DivineShield=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Prophet_DivineShield,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Prophet_DivineShield,Condition(function Trig_Prophet_DivineShield_Conditions))
    call TriggerAddAction(gg_trg_Prophet_DivineShield,function Trig_Prophet_DivineShield_Actions)
endfunction

function Register_Prophet_Infinity takes nothing returns nothing
    set gg_trg_Prophet_Infinity=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Prophet_Infinity,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Prophet_Infinity,Condition(function Trig_Prophet_Infinity_Conditions))
    call TriggerAddAction(gg_trg_Prophet_Infinity,function Trig_Prophet_Infinity_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Prophet takes nothing returns nothing
    call Register_Prophet_Pray_Start()
    call Register_Prophet_Pray_Stop()
    call Register_Prophet_Pray_Tick()
    call Register_Prophet_Pray_Heal()
    call Register_Prophet_BlessingOfLight()
    call Register_Prophet_DivineShield()
    call Register_Prophet_Infinity()
endfunction

endlibrary
