library TNecro requires TAbil, TGroup, TLoc, TPlayerHero, TProf, TText
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Necro_RaiseDead_Reset=null
    trigger gg_trg_Necro_Release=null
    trigger gg_trg_Necro_DeathScreech=null
    trigger gg_trg_Necro_Drain_Start=null
    trigger gg_trg_Necro_Drain_End=null
    trigger gg_trg_Necro_Drain_Tick=null
    // Variables only this module uses.
    real udg_NecroReleaseHealTotal=0
endglobals

function Trig_Necro_RaiseDead_Reset_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A0Z2') // 'A0Z2': ability "Raise Dead"
endfunction

function Trig_Necro_RaiseDead_Reset_Actions takes nothing returns nothing
    set udg_NecroReleaseHealTotal=.0
endfunction

function Trig_Necro_Release_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A15M') // 'A15M': ability "Release"
endfunction

function Trig_Necro_Release_Filter_IsAlly takes nothing returns boolean
    return(IsUnitAlly(GetFilterUnit(),GetOwningPlayer(GetTriggerUnit())))
endfunction

function Trig_Necro_Release_Filter_NotInvulnerable takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('Avul',GetFilterUnit())<=0) // 'Avul': standard ability reference "Invulnerable"
endfunction

function Trig_Necro_Release_Filter_AllyNotInvulnerable takes nothing returns boolean
    return GetBooleanAnd(Trig_Necro_Release_Filter_IsAlly(),Trig_Necro_Release_Filter_NotInvulnerable())
endfunction

function Trig_Necro_Release_Filter_IsAlive takes nothing returns boolean
    return(IsUnitAliveBJ(GetFilterUnit()))
endfunction

function Trig_Necro_Release_Filter_AliveAlly takes nothing returns boolean
    return GetBooleanAnd(Trig_Necro_Release_Filter_AllyNotInvulnerable(),Trig_Necro_Release_Filter_IsAlive())
endfunction

function Trig_Necro_Release_Filter_NotExploding takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0FQ',GetFilterUnit())<=0) // 'A0FQ': ability "Explode Upon Death"
endfunction

function Trig_Necro_Release_Filter_HealTarget takes nothing returns boolean
    return GetBooleanAnd(Trig_Necro_Release_Filter_AliveAlly(),Trig_Necro_Release_Filter_NotExploding())
endfunction

function Trig_Necro_Release_HealAlly takes nothing returns nothing
    // Result 1: udg_TempInteger treated as a decimal-capable number.
    // Result 2: (maximum health of the unit being visited) minus (current health of the unit being visited).
    // Result 3: the smaller of (result 1) and (result 2).
    // Result 4: (udg_NecroReleaseHealTotal) plus (result 3).
    set udg_NecroReleaseHealTotal=(udg_NecroReleaseHealTotal+RMinBJ(I2R(udg_TempInteger),(GetUnitStateSwap(UNIT_STATE_MAX_LIFE,GetEnumUnit())-GetUnitStateSwap(UNIT_STATE_LIFE,GetEnumUnit()))))
    // Result 1: udg_TempInteger treated as a decimal-capable number.
    // Result 2: a random decimal number between 15 and 16.
    // Result 3: (result 2) divided by (16).
    // Result 4: (result 1) times (result 3).
    set udg_TempReal=(I2R(udg_TempInteger)*(GetRandomReal(15.,16.)/ 16.))
    // (current health of the unit being visited) plus (udg_TempReal).
    call SetUnitLifeBJ(GetEnumUnit(),(GetUnitStateSwap(UNIT_STATE_LIFE,GetEnumUnit())+udg_TempReal))
    call Text_FloatingDamage(GetEnumUnit(),true,0,udg_TempReal,false,0)
endfunction

function Trig_Necro_Release_EarnedMasteryAward takes nothing returns boolean
    return(udg_NecroReleaseHealTotal>=50000.)and(GetUnitAbilityLevelSwapped('A02F',Player_GetHero(GetOwningPlayer(GetTriggerUnit())))==3)and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_JobMasterForce[21])==false)and(GetUnitTypeId(Player_GetHero(GetOwningPlayer(GetTriggerUnit())))=='H02Y') // 'A02F': ability "Mastery"; 'H02Y': unit "Necromancer"
endfunction

function Trig_Necro_Release_Actions takes nothing returns nothing
    call UnitAddAbilityBJ('A0FQ',GetTriggerUnit()) // 'A0FQ': ability "Explode Upon Death"
    call UnitApplyTimedLifeBJ(.01,'Brai',GetTriggerUnit()) // 'Brai': buff tooltip "Raised"
    // (current health of the triggering unit) with its decimal part removed.
    call BlzSetUnitMaxHP(GetTriggerUnit(),R2I(GetUnitStateSwap(UNIT_STATE_LIFE,GetTriggerUnit())))
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Demon\\DarkPortal\\DarkPortalTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    set udg_TempGroup=Group_UnitsInRangeOfLoc(250.,udg_TempPoint,Condition(function Trig_Necro_Release_Filter_HealTarget))
    call RemoveLocation(udg_TempPoint)
    // (current health of the triggering unit) with its decimal part removed.
    set udg_TempInteger=R2I(GetUnitStateSwap(UNIT_STATE_LIFE,GetTriggerUnit()))
    call ForGroupBJ(udg_TempGroup,function Trig_Necro_Release_HealAlly)
    call DestroyGroup(udg_TempGroup)
    if(Trig_Necro_Release_EarnedMasteryAward())then
        call ForceAddPlayerSimple(GetOwningPlayer(GetTriggerUnit()),udg_JobMasterForce[21])
        call AddSpecialEffectTargetUnitBJ("origin",Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"Abilities\\Spells\\Other\\Levelup\\LevelupCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
    endif
endfunction

function Trig_Necro_DeathScreech_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A12Y') // 'A12Y': ability "Death Screech"
endfunction

function Trig_Necro_DeathScreech_RemoveCorpse takes nothing returns nothing
    call RemoveUnit(GetEnumUnit())
endfunction

function Trig_Necro_DeathScreech_IsInNarrowRect takes nothing returns boolean
    return(RectContainsLoc(gg_rct_630,udg_TempPoint))or(RectContainsLoc(gg_rct_631,udg_TempPoint))
endfunction

function Trig_Necro_DeathScreech_UseTightCorpseSpread takes nothing returns boolean
    return(udg_ZodiacQuestStage<7)and(Trig_Necro_DeathScreech_IsInNarrowRect())
endfunction

function Trig_Necro_DeathScreech_Actions takes nothing returns nothing
    call ForGroupBJ(udg_NecroCorpseGroup[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],function Trig_Necro_DeathScreech_RemoveCorpse)
    call GroupClear(udg_NecroCorpseGroup[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateNUnitsAtLocFacingLocBJ(1,'h02S',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,udg_TempPoint) // 'h02S': unit "Simple Casting Dummy"
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(2.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A12X',GetLastCreatedUnit()) // 'A12X': ability "Death Screech"
    call SetUnitAbilityLevelSwapped('A12X',GetLastCreatedUnit(),GetUnitAbilityLevelSwapped(GetSpellAbilityId(),GetTriggerUnit())) // 'A12X': ability "Death Screech"
    call IssueImmediateOrderBJ(GetLastCreatedUnit(),"howlofterror")
    set udg_TempReal=GetRandomDirectionDeg()
    if(Trig_Necro_DeathScreech_UseTightCorpseSpread())then
        set bj_forLoopAIndex=0
        set bj_forLoopAIndexEnd=2
        loop
            exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
            // Calculation 1:
            // A random decimal number between 8 and 32.
            // Calculation 2:
            // (udg_TempReal) plus ((loop counter A treated as a decimal-capable number) times (120)).
            set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,GetRandomReal(8.,32.),(udg_TempReal+(I2R(GetForLoopIndexA())*120.)))
            call CreatePermanentCorpseLocBJ(bj_CORPSETYPE_FLESH,'u016',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint2,GetRandomDirectionDeg()) // 'u016': unit "Corpse"
            call RemoveLocation(udg_TempPoint2)
            call GroupAddUnitSimple(GetLastCreatedUnit(),udg_NecroCorpseGroup[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
            set bj_forLoopAIndex=bj_forLoopAIndex+1
        endloop
    else
        set bj_forLoopAIndex=0
        set bj_forLoopAIndexEnd=2
        loop
            exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
            // Calculation 1:
            // A random decimal number between 64 and 300.
            // Calculation 2:
            // (udg_TempReal) plus ((loop counter A treated as a decimal-capable number) times (120)).
            set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,GetRandomReal(64.,300.),(udg_TempReal+(I2R(GetForLoopIndexA())*120.)))
            call CreatePermanentCorpseLocBJ(bj_CORPSETYPE_FLESH,'u016',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint2,GetRandomDirectionDeg()) // 'u016': unit "Corpse"
            call RemoveLocation(udg_TempPoint2)
            call GroupAddUnitSimple(GetLastCreatedUnit(),udg_NecroCorpseGroup[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
            set bj_forLoopAIndex=bj_forLoopAIndex+1
        endloop
    endif
    call RemoveLocation(udg_TempPoint)
endfunction

function Trig_Necro_Drain_Start_IsDrainAbility takes nothing returns boolean
    return(GetSpellAbilityId()=='A0Z4')or(GetSpellAbilityId()=='A07J') // 'A0Z4': ability "Drain"; 'A07J': ability "Drain"
endfunction

function Trig_Necro_Drain_Start_Conditions takes nothing returns boolean
    return(Trig_Necro_Drain_Start_IsDrainAbility())
endfunction

function Trig_Necro_Drain_Start_IsCasterHero takes nothing returns boolean
    return(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Necro_Drain_Start_Actions takes nothing returns nothing
    call GroupAddUnitSimple(GetTriggerUnit(),udg_DrainChannelGroup)
    call SaveUnitHandleBJ(GetSpellTargetUnit(),1,GetHandleIdBJ(GetTriggerUnit()),udg_ChannelDrainHash)
    // (BlzGetAbilityManaCost(GetSpellAbilityId(), Abil_GetLevel(the triggering unit, GetSpellAbilityId()))) times
    // (2).
    set udg_TempInteger=(BlzGetAbilityManaCost(GetSpellAbilityId(),Abil_GetLevel(GetTriggerUnit(),GetSpellAbilityId()))*2)
    if(Trig_Necro_Drain_Start_IsCasterHero())then
        // (udg_TempInteger) plus ((Intelligence of the triggering unit) times (1)).
        set udg_TempInteger=(udg_TempInteger+(GetHeroStatBJ(bj_HEROSTAT_INT,GetTriggerUnit(),true)*1))
    endif
    // Result 1: udg_TempInteger treated as a decimal-capable number.
    // Result 2: (result 1) times (Prof_StaffPower(the triggering unit)).
    // Result 3: (result 2) with its decimal part removed.
    set udg_TempInteger=R2I((I2R(udg_TempInteger)*Prof_StaffPower(GetTriggerUnit())))
    call SaveIntegerBJ(udg_TempInteger,2,GetHandleIdBJ(GetTriggerUnit()),udg_ChannelDrainHash)
endfunction

function Trig_Necro_Drain_End_IsDrainAbility takes nothing returns boolean
    return(GetSpellAbilityId()=='A0Z4')or(GetSpellAbilityId()=='A07J') // 'A0Z4': ability "Drain"; 'A07J': ability "Drain"
endfunction

function Trig_Necro_Drain_End_Conditions takes nothing returns boolean
    return(Trig_Necro_Drain_End_IsDrainAbility())
endfunction

function Trig_Necro_Drain_End_Actions takes nothing returns nothing
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_DrainChannelGroup)
    call SaveIntegerBJ(0,1,GetHandleIdBJ(GetTriggerUnit()),udg_ChannelDrainHash)
endfunction

function Trig_Necro_Drain_Tick_HasHealAmount takes nothing returns boolean
    return(udg_LastDamageDealt>.0)
endfunction

function Trig_Necro_Drain_Tick_DrainTickUnit takes nothing returns nothing
    set udg_TempInteger=LoadIntegerBJ(2,GetHandleIdBJ(GetEnumUnit()),udg_ChannelDrainHash)
    // Udg_TempInteger treated as a decimal-capable number.
    call UnitDamageTargetBJ(GetEnumUnit(),LoadUnitHandleBJ(1,GetHandleIdBJ(GetEnumUnit()),udg_ChannelDrainHash),I2R(udg_TempInteger),ATTACK_TYPE_NORMAL,DAMAGE_TYPE_UNIVERSAL)
    if(Trig_Necro_Drain_Tick_HasHealAmount())then
        // (current health of the unit being visited) plus (udg_LastDamageDealt).
        call SetUnitLifeBJ(GetEnumUnit(),(GetUnitStateSwap(UNIT_STATE_LIFE,GetEnumUnit())+udg_LastDamageDealt))
        call Text_FloatingDamage(GetEnumUnit(),true,0,udg_LastDamageDealt,false,0)
    endif
endfunction

function Trig_Necro_Drain_Tick_Actions takes nothing returns nothing
    call ForGroupBJ(udg_DrainChannelGroup,function Trig_Necro_Drain_Tick_DrainTickUnit)
endfunction

// World Editor calls InitTrig_Necro automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Necro (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Necro takes nothing returns nothing
endfunction

function Register_Necro_RaiseDead_Reset takes nothing returns nothing
    set gg_trg_Necro_RaiseDead_Reset=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Necro_RaiseDead_Reset,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Necro_RaiseDead_Reset,Condition(function Trig_Necro_RaiseDead_Reset_Conditions))
    call TriggerAddAction(gg_trg_Necro_RaiseDead_Reset,function Trig_Necro_RaiseDead_Reset_Actions)
endfunction

function Register_Necro_Release takes nothing returns nothing
    set gg_trg_Necro_Release=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Necro_Release,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Necro_Release,Condition(function Trig_Necro_Release_Conditions))
    call TriggerAddAction(gg_trg_Necro_Release,function Trig_Necro_Release_Actions)
endfunction

function Register_Necro_DeathScreech takes nothing returns nothing
    set gg_trg_Necro_DeathScreech=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Necro_DeathScreech,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Necro_DeathScreech,Condition(function Trig_Necro_DeathScreech_Conditions))
    call TriggerAddAction(gg_trg_Necro_DeathScreech,function Trig_Necro_DeathScreech_Actions)
endfunction

function Register_Necro_Drain_Start takes nothing returns nothing
    set gg_trg_Necro_Drain_Start=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Necro_Drain_Start,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Necro_Drain_Start,Condition(function Trig_Necro_Drain_Start_Conditions))
    call TriggerAddAction(gg_trg_Necro_Drain_Start,function Trig_Necro_Drain_Start_Actions)
endfunction

function Register_Necro_Drain_End takes nothing returns nothing
    set gg_trg_Necro_Drain_End=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Necro_Drain_End,EVENT_PLAYER_UNIT_SPELL_ENDCAST)
    call TriggerAddCondition(gg_trg_Necro_Drain_End,Condition(function Trig_Necro_Drain_End_Conditions))
    call TriggerAddAction(gg_trg_Necro_Drain_End,function Trig_Necro_Drain_End_Actions)
endfunction

function Register_Necro_Drain_Tick takes nothing returns nothing
    set gg_trg_Necro_Drain_Tick=CreateTrigger()
    call TriggerRegisterTimerEventPeriodic(gg_trg_Necro_Drain_Tick,1.)
    call TriggerAddAction(gg_trg_Necro_Drain_Tick,function Trig_Necro_Drain_Tick_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Necro takes nothing returns nothing
    call Register_Necro_RaiseDead_Reset()
    call Register_Necro_Release()
    call Register_Necro_DeathScreech()
    call Register_Necro_Drain_Start()
    call Register_Necro_Drain_End()
    call Register_Necro_Drain_Tick()
endfunction

endlibrary
