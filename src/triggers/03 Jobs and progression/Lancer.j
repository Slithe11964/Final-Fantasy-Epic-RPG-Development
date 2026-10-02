library TLancer requires TAbil, TForce, TGroup, TPlayerPart01, TProf, TWait, TWave
function Trig_Lancer_DragonBreath_IsCastAbility takes nothing returns boolean
    return(GetSpellAbilityId()=='A11R')or(GetSpellAbilityId()=='A0SL') // 'A11R': ability "Dragon Breath"; 'A0SL': ability "Dragon Breath"
endfunction

function Trig_Lancer_DragonBreath_Conditions takes nothing returns boolean
    return(Trig_Lancer_DragonBreath_IsCastAbility())
endfunction

function Trig_Lancer_DragonBreath_HasNoTargetUnit takes nothing returns boolean
    return(GetSpellTargetUnit()==null)
endfunction

function Trig_Lancer_DragonBreath_CasterIsHero takes nothing returns boolean
    return(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Lancer_DragonBreath_Actions takes nothing returns nothing
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateNUnitsAtLocFacingLocBJ(1,'h01B',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,udg_TempPoint) // 'h01B': unit "Proxy Dummy"
    call RemoveLocation(udg_TempPoint)
    if(Trig_Lancer_DragonBreath_HasNoTargetUnit())then
        set udg_TempPoint=GetSpellTargetLoc()
    else
        set udg_TempPoint=GetUnitLoc(GetSpellTargetUnit())
    endif
    call SetUnitFacingToFaceLocTimed(GetLastCreatedUnit(),udg_TempPoint,0)
    set udg_TempHandleId=GetHandleIdBJ(GetLastCreatedUnit())
    call SaveUnitHandleBJ(GetTriggerUnit(),0,udg_TempHandleId,udg_ProxyDamageHash)
    // (BlzGetAbilityManaCost(GetSpellAbilityId(), Abil_GetLevel(the triggering unit, GetSpellAbilityId()))) times
    // (4).
    set udg_TempInteger=(BlzGetAbilityManaCost(GetSpellAbilityId(),Abil_GetLevel(GetTriggerUnit(),GetSpellAbilityId()))*4)
    if(Trig_Lancer_DragonBreath_CasterIsHero())then
        // (udg_TempInteger) plus (Strength of the triggering unit).
        set udg_TempInteger=(udg_TempInteger+GetHeroStatBJ(bj_HEROSTAT_STR,GetTriggerUnit(),true))
        // (udg_TempInteger) plus (Agility of the triggering unit).
        set udg_TempInteger=(udg_TempInteger+GetHeroStatBJ(bj_HEROSTAT_AGI,GetTriggerUnit(),true))
        // (udg_TempInteger) plus (Intelligence of the triggering unit).
        set udg_TempInteger=(udg_TempInteger+GetHeroStatBJ(bj_HEROSTAT_INT,GetTriggerUnit(),true))
    endif
    // (udg_TempInteger) divided by (4); drop the remainder.
    set udg_TempInteger=(udg_TempInteger/ 4)
    // (0.2) times ((5) plus (Prof_GetLevel(the triggering unit, 'R009'))).
    set udg_TempReal=.2*(5+Prof_GetLevel(GetTriggerUnit(),'R009')) // 'R009': upgrade "Spear"
    // (udg_TempInteger treated as a decimal-capable number) times (udg_TempReal).
    call SaveRealBJ((I2R(udg_TempInteger)*udg_TempReal),1,udg_TempHandleId,udg_ProxyDamageHash)
    call SaveIntegerBJ(2,2,udg_TempHandleId,udg_ProxyDamageHash)
    call SaveIntegerBJ(1,3,udg_TempHandleId,udg_ProxyDamageHash)
    call SaveBooleanBJ(true,5,udg_TempHandleId,udg_ProxyDamageHash)
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(8.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A0M1',GetLastCreatedUnit()) // 'A0M1': ability "Fire-elemental Damage"
    call UnitAddAbilityBJ('A0RJ',GetLastCreatedUnit()) // 'A0RJ': ability "Dragon Breath"
    call IssuePointOrderLocBJ(GetLastCreatedUnit(),"breathoffrost",udg_TempPoint)
    call RemoveLocation(udg_TempPoint)
endfunction

function Trig_Lancer_DragonSlam_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A03M') // 'A03M': ability "Dragon Slam"
endfunction

function Trig_Lancer_DragonSlam_FilterIsAlive takes nothing returns boolean
    return(IsUnitAliveBJ(GetFilterUnit()))
endfunction

function Trig_Lancer_DragonSlam_FilterIsEnemy takes nothing returns boolean
    return(IsUnitEnemy(GetFilterUnit(),GetOwningPlayer(GetTriggerUnit())))
endfunction

function Trig_Lancer_DragonSlam_FilterAliveEnemy takes nothing returns boolean
    return GetBooleanAnd(Trig_Lancer_DragonSlam_FilterIsAlive(),Trig_Lancer_DragonSlam_FilterIsEnemy())
endfunction

function Trig_Lancer_DragonSlam_FilterNotInvulnerable takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('Avul',GetFilterUnit())<=0) // 'Avul': standard ability reference "Invulnerable"
endfunction

function Trig_Lancer_DragonSlam_FilterTarget takes nothing returns boolean
    return GetBooleanAnd(Trig_Lancer_DragonSlam_FilterAliveEnemy(),Trig_Lancer_DragonSlam_FilterNotInvulnerable())
endfunction

function Trig_Lancer_DragonSlam_CasterIsHero takes nothing returns boolean
    return(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Lancer_DragonSlam_KnockbackAndDamage takes nothing returns nothing
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    set udg_TempPoint2=GetUnitLoc(GetEnumUnit())
    // The straight-line distance between udg_TempPoint and udg_TempPoint2.
    set udg_TempReal=DistanceBetweenPoints(udg_TempPoint,udg_TempPoint2)
    call RemoveLocation(udg_TempPoint)
    call RemoveLocation(udg_TempPoint2)
    // (0.14) minus ((udg_TempReal) divided by (3820)).
    call Trig_Wave_Fist_Knockback(GetTriggerUnit(),GetEnumUnit(),.14-(udg_TempReal/ 3820.),.5,null,true,.0)
    set udg_IsPhysicalAttack=true
    set udg_DamageElement=5
    // Udg_TempInteger treated as a decimal-capable number.
    call UnitDamageTarget(GetTriggerUnit(),GetEnumUnit(),I2R(udg_TempInteger),true,true,ATTACK_TYPE_SIEGE,DAMAGE_TYPE_NORMAL,null)
endfunction

function Trig_Lancer_DragonSlam_Actions takes nothing returns nothing
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    set udg_TempGroup=Group_UnitsInRangeOfLoc(382.,udg_TempPoint,Condition(function Trig_Lancer_DragonSlam_FilterTarget))
    call RemoveLocation(udg_TempPoint)
    // (BlzGetAbilityManaCost(GetSpellAbilityId(), Abil_GetLevel(the triggering unit, GetSpellAbilityId()))) times
    // (3).
    set udg_TempInteger=(BlzGetAbilityManaCost(GetSpellAbilityId(),Abil_GetLevel(GetTriggerUnit(),GetSpellAbilityId()))*3)
    if(Trig_Lancer_DragonSlam_CasterIsHero())then
        // (udg_TempInteger) plus (Strength of the triggering unit).
        set udg_TempInteger=(udg_TempInteger+GetHeroStatBJ(bj_HEROSTAT_STR,GetTriggerUnit(),true))
        // (udg_TempInteger) plus (Agility of the triggering unit).
        set udg_TempInteger=(udg_TempInteger+GetHeroStatBJ(bj_HEROSTAT_AGI,GetTriggerUnit(),true))
        // (udg_TempInteger) plus (Intelligence of the triggering unit).
        set udg_TempInteger=(udg_TempInteger+GetHeroStatBJ(bj_HEROSTAT_INT,GetTriggerUnit(),true))
    endif
    // (0.2) times ((5) plus (Prof_GetLevel(the triggering unit, 'R009'))).
    set udg_TempReal=.2*(5+Prof_GetLevel(GetTriggerUnit(),'R009')) // 'R009': upgrade "Spear"
    // ((udg_TempInteger treated as a decimal-capable number) times (udg_TempReal)) with its decimal part removed.
    set udg_TempInteger=R2I((I2R(udg_TempInteger)*udg_TempReal))
    call ForGroupBJ(udg_TempGroup,function Trig_Lancer_DragonSlam_KnockbackAndDamage)
    call DestroyGroup(udg_TempGroup)
endfunction

function Trig_Lancer_DragonAlly_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A14G') // 'A14G': ability "Dragon Ally"
endfunction

function Trig_Lancer_DragonAlly_HasActiveDragon takes nothing returns boolean
    return(udg_PetUnit[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]!=null)
endfunction

function Trig_Lancer_DragonAlly_Actions takes nothing returns nothing
    if(Trig_Lancer_DragonAlly_HasActiveDragon())then
        call UnitApplyTimedLifeBJ(30.,'BTLF',udg_PetUnit[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]) // 'BTLF': object name not found in map data
    endif
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateNUnitsAtLoc(1,udg_DragonSummonUnit[GetUnitAbilityLevelSwapped(GetSpellAbilityId(),GetTriggerUnit())],GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,GetUnitFacing(GetTriggerUnit()))
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Orc\\FeralSpirit\\feralspiritdone.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(udg_TempPoint)
    set udg_PetUnit[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=GetLastCreatedUnit()
    call UnitAddAbilityBJ('A14I',GetLastCreatedUnit()) // 'A14I': ability "Summon Poof Death"
    set udg_TempUnit2=GetLastCreatedUnit()
    call ConditionalTriggerExecute(gg_trg_Summon_Powerup)
    call SetUnitLifePercentBJ(GetLastCreatedUnit(),'d')
endfunction

function Trig_Lancer_Jump_RangeCheck_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A14D') // 'A14D': ability "!Jump"
endfunction

function Trig_Lancer_Jump_RangeCheck_TargetTooClose takes nothing returns boolean
    // The straight-line distance between udg_TempPoint and udg_TempPoint2.
    return(DistanceBetweenPoints(udg_TempPoint,udg_TempPoint2)<=64.)
endfunction

function Trig_Lancer_Jump_RangeCheck_Actions takes nothing returns nothing
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    set udg_TempPoint2=GetUnitLoc(GetSpellTargetUnit())
    if(Trig_Lancer_Jump_RangeCheck_TargetTooClose())then
        call PauseUnitBJ(true,GetTriggerUnit())
        call IssueImmediateOrderBJ(GetTriggerUnit(),"stop")
        call PauseUnitBJ(false,GetTriggerUnit())
        set udg_TempForce=Force_OfPlayer(GetOwningPlayer(GetTriggerUnit()))
        call DisplayTimedTextToForce(udg_TempForce,10.,"|cffff0000The target is too close to the hero!|r")
        call DestroyForce(udg_TempForce)
    endif
    call RemoveLocation(udg_TempPoint)
    call RemoveLocation(udg_TempPoint2)
endfunction

function Trig_Lancer_Jump_Conditions takes nothing returns boolean
    return GetSpellAbilityId()=='A14D' // 'A14D': ability "!Jump"
endfunction

function Trig_Lancer_Jump_Actions takes nothing returns nothing
    local integer l_abilId=GetSpellAbilityId()
    local unit triggeringUnit=GetTriggerUnit()
    local unit spellTarget=GetSpellTargetUnit()
    local player owningPlayer=GetOwningPlayer(triggeringUnit)
    local real l_casterX=GetUnitX(triggeringUnit)
    local real l_casterY=GetUnitY(triggeringUnit)
    local real l_targetX=GetUnitX(spellTarget)
    local real l_targetY=GetUnitY(spellTarget)
    // Starting value for l_dx:
    // (l_casterX) minus (l_targetX).
    local real l_dx=l_casterX-l_targetX
    // Starting value for l_dy:
    // (l_casterY) minus (l_targetY).
    local real l_dy=l_casterY-l_targetY
    // Starting value for distance:
    // The square root of ((the square of (l_dx)) plus (the square of (l_dy))).
    local real distance=SquareRoot(l_dx*l_dx+l_dy*l_dy)
    // Starting value for angle:
    // Result 1: (l_targetY) minus (l_casterY).
    // Result 2: (l_targetX) minus (l_casterX).
    // Result 3: the angle in radians from the y gap (result 1) and x gap (result 2).
    // Result 4: (bj_RADTODEG) times (result 3).
    local real angle=bj_RADTODEG*Atan2(l_targetY-l_casterY,l_targetX-l_casterX)
    local integer l_dummyId
    local real damageAmount
    local real l_extra
    local unit l_dummy
    local group l_targets
    if(distance<64.)then
        call PauseUnit(triggeringUnit,true)
        call IssueImmediateOrderById(triggeringUnit,$D0004) // $D0004 = 851972
        call PauseUnit(triggeringUnit,false)
        call DisplayTimedTextToPlayer(owningPlayer,0,0,$A,"|cffff0000The target is too close to the hero!|r") // $A = 10
        set triggeringUnit=null
        set spellTarget=null
        set owningPlayer=null
        return
    endif
    if(distance>1000.)then
        set distance=1000.
    endif
    set l_dummy=CreateUnit(owningPlayer,'h01B',l_casterX,l_casterY,angle) // 'h01B': unit "Proxy Dummy"
    set l_dummyId=GetHandleId(l_dummy)
    call SaveUnitHandle(udg_ProxyDamageHash,l_dummyId,0,triggeringUnit)
    // Result 1: (BlzGetAbilityManaCost(l_abilId, Abil_GetLevel(triggeringUnit, l_abilId))) plus (Strength of triggeringUnit).
    // Result 2: (result 1) plus (Agility of triggeringUnit).
    // Result 3: (result 2) plus (Intelligence of triggeringUnit).
    set damageAmount=BlzGetAbilityManaCost(l_abilId,Abil_GetLevel(triggeringUnit,l_abilId))+GetHeroStr(triggeringUnit,true)+GetHeroAgi(triggeringUnit,true)+GetHeroInt(triggeringUnit,true)
    // ((damage) times (0.02)) times ((distance) plus (200)).
    set damageAmount=(damageAmount*.02)*(distance+200.)
    // (damage) times ((0.1) times ((10) plus (Prof_GetLevel(triggeringUnit, 'R009')))).
    set damageAmount=damageAmount*(.1*($A+Prof_GetLevel(triggeringUnit,'R009'))) // $A = 10; 'R009': upgrade "Spear"
    call SaveReal(udg_ProxyDamageHash,l_dummyId,1,damageAmount)
    call SaveInteger(udg_ProxyDamageHash,l_dummyId,2,1)
    call SaveInteger(udg_ProxyDamageHash,l_dummyId,3,2)
    call SaveBoolean(udg_ProxyDamageHash,l_dummyId,5,true)
    call SaveBoolean(udg_ProxyDamageHash,l_dummyId,7,true)
    call ShowUnit(l_dummy,false)
    call UnitApplyTimedLife(l_dummy,'BTLF',6.) // 'BTLF': object name not found in map data
    call UnitAddAbility(l_dummy,'A14E') // 'A14E': ability "Jump"
    call IssueTargetOrderById(l_dummy,$D007F,spellTarget) // $D007F = 852095
    set l_dummy=CreateUnit(owningPlayer,'h02S',l_targetX,l_targetY,.0) // 'h02S': unit "Simple Casting Dummy"
    call ShowUnit(l_dummy,false)
    call UnitApplyTimedLife(l_dummy,'BTLF',1.4) // 'BTLF': object name not found in map data
    call UnitAddAbility(l_dummy,'A0ID') // 'A0ID': ability "Jump"
    call IssueTargetOrderById(l_dummy,$D008A,spellTarget) // $D008A = 852106
    call ShowUnit(triggeringUnit,false)
    // (distance) times (0.0025).
    call Wait_Polled(distance*.0025)
    call SetUnitX(triggeringUnit,l_targetX)
    call SetUnitY(triggeringUnit,l_targetY)
    call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Human\\ThunderClap\\ThunderClapCaster.mdl",l_targetX,l_targetY))
    call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Orc\\WarStomp\\WarStompCaster.mdl",l_targetX,l_targetY))
    call TerrainDeformRipple(l_targetX,l_targetY,512.,24.,$3E8,1,4.,5.,1.,false) // $3E8 = 1000
    set l_targets=CreateGroup()
    call GroupAddUnit(l_targets,spellTarget)
    set l_dummy=CreateUnit(owningPlayer,'h01B',l_targetX,l_targetY,.0) // 'h01B': unit "Proxy Dummy"
    set l_dummyId=GetHandleId(l_dummy)
    call SaveUnitHandle(udg_ProxyDamageHash,l_dummyId,0,triggeringUnit)
    // (damage) times (0.5).
    call SaveReal(udg_ProxyDamageHash,l_dummyId,1,damageAmount*.5)
    call SaveInteger(udg_ProxyDamageHash,l_dummyId,2,1)
    call SaveInteger(udg_ProxyDamageHash,l_dummyId,3,2)
    call SaveBoolean(udg_ProxyDamageHash,l_dummyId,5,true)
    call SaveGroupHandle(udg_ProxyDamageHash,l_dummyId,6,l_targets)
    call SaveBoolean(udg_ProxyDamageHash,l_dummyId,7,true)
    call ShowUnit(l_dummy,false)
    call UnitApplyTimedLife(l_dummy,'BTLF',1.) // 'BTLF': object name not found in map data
    call UnitAddAbility(l_dummy,'A14F') // 'A14F': ability "Jump Splash"
    call IssueImmediateOrderById(l_dummy,$D009F) // $D009F = 852127
    call UnitRemoveAbility(spellTarget,'B03T') // 'B03T': buff tooltip "Jump"
    call UnitRemoveAbility(spellTarget,'B03U') // 'B03U': buff tooltip "Jump"
    call ShowUnit(triggeringUnit,true)
    call SelectUnitForPlayerSingle(triggeringUnit,owningPlayer)
    call Wait_Polled(1.)
    call DestroyGroup(l_targets)
    set triggeringUnit=null
    set spellTarget=null
    set l_dummy=null
    set owningPlayer=null
    set l_targets=null
endfunction

function Trig_Lancer_Task_Dragons_Cond_IsDragon takes nothing returns boolean
    return(GetUnitTypeId(GetTriggerUnit())=='n0N3')or(GetUnitTypeId(GetTriggerUnit())=='n02C')or(GetUnitTypeId(GetTriggerUnit())=='n03G')or(GetUnitTypeId(GetTriggerUnit())=='n03H')or(GetUnitTypeId(GetTriggerUnit())=='n03F')or(GetUnitTypeId(GetTriggerUnit())=='n03E')or(GetUnitTypeId(GetTriggerUnit())=='n041') // 'n0N3': unit "Forest Drake"; 'n02C': unit "Icy Whelp"; 'n03G': unit "Dusk Wyrm"; 'n03H': unit "Black Dragon"; 'n03F': unit "Marsh Whelp"; 'n03E': unit "Nether Drake"; 'n041': unit "Ruby Dragon"
endfunction

function Trig_Lancer_Task_Dragons_Conditions takes nothing returns boolean
    return(GetUnitTypeId(Player_GetHero(GetOwningPlayer(GetKillingUnitBJ())))=='H00C')and(GetUnitAbilityLevelSwapped('A02F',Player_GetHero(GetOwningPlayer(GetKillingUnitBJ())))==3)and(IsPlayerInForce(GetOwningPlayer(GetKillingUnitBJ()),udg_JobMasterForce[7])==false)and(Trig_Lancer_Task_Dragons_Cond_IsDragon()) // 'H00C': unit "Lancer"; 'A02F': ability "Mastery"
endfunction

function Trig_Lancer_Task_Dragons_Cond_AllLancersDone takes nothing returns boolean
    return(CountPlayersInForceBJ(udg_PlayingPlayers)<=CountPlayersInForceBJ(udg_JobMasterForce[7]))
endfunction

function Trig_Lancer_Task_Dragons_Cond_DragonQuotaMet takes nothing returns boolean
    return(udg_DragonKillCount[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]>=$A) // $A = 10
endfunction

function Trig_Lancer_Task_Dragons_Actions takes nothing returns nothing
    set udg_DragonKillCount[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]=(udg_DragonKillCount[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]+1)
    if(Trig_Lancer_Task_Dragons_Cond_DragonQuotaMet())then
        call ForceAddPlayerSimple(GetOwningPlayer(GetKillingUnitBJ()),udg_JobMasterForce[7])
        call AddSpecialEffectTargetUnitBJ("origin",Player_GetHero(GetOwningPlayer(GetKillingUnitBJ())),"Abilities\\Spells\\Other\\Levelup\\LevelupCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        if(Trig_Lancer_Task_Dragons_Cond_AllLancersDone())then
            call DisableTrigger(GetTriggeringTrigger())
        endif
    else
        call Wait_Polled(60.)
        set udg_DragonKillCount[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]=(udg_DragonKillCount[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]-1)
    endif
endfunction

// World Editor calls InitTrig_Lancer automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Lancer_Part1 / RegisterTriggers_Lancer_Part2 (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Lancer takes nothing returns nothing
endfunction

function Register_Lancer_DragonBreath takes nothing returns nothing
    set gg_trg_Lancer_DragonBreath=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Lancer_DragonBreath,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Lancer_DragonBreath,Condition(function Trig_Lancer_DragonBreath_Conditions))
    call TriggerAddAction(gg_trg_Lancer_DragonBreath,function Trig_Lancer_DragonBreath_Actions)
endfunction

function Register_Lancer_DragonSlam takes nothing returns nothing
    set gg_trg_Lancer_DragonSlam=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Lancer_DragonSlam,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Lancer_DragonSlam,Condition(function Trig_Lancer_DragonSlam_Conditions))
    call TriggerAddAction(gg_trg_Lancer_DragonSlam,function Trig_Lancer_DragonSlam_Actions)
endfunction

function Register_Lancer_DragonAlly takes nothing returns nothing
    set gg_trg_Lancer_DragonAlly=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Lancer_DragonAlly,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Lancer_DragonAlly,Condition(function Trig_Lancer_DragonAlly_Conditions))
    call TriggerAddAction(gg_trg_Lancer_DragonAlly,function Trig_Lancer_DragonAlly_Actions)
endfunction

function Register_Lancer_Jump_RangeCheck takes nothing returns nothing
    set gg_trg_Lancer_Jump_RangeCheck=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Lancer_Jump_RangeCheck,EVENT_PLAYER_UNIT_SPELL_CAST)
    call TriggerAddCondition(gg_trg_Lancer_Jump_RangeCheck,Condition(function Trig_Lancer_Jump_RangeCheck_Conditions))
    call TriggerAddAction(gg_trg_Lancer_Jump_RangeCheck,function Trig_Lancer_Jump_RangeCheck_Actions)
endfunction

function Register_Lancer_Jump takes nothing returns nothing
    set gg_trg_Lancer_Jump=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Lancer_Jump,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Lancer_Jump,Condition(function Trig_Lancer_Jump_Conditions))
    call TriggerAddAction(gg_trg_Lancer_Jump,function Trig_Lancer_Jump_Actions)
endfunction

function Register_Lancer_Task_Dragons takes nothing returns nothing
    set gg_trg_Lancer_Task_Dragons=CreateTrigger()
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_Lancer_Task_Dragons,Player($B),EVENT_PLAYER_UNIT_DEATH) // $B = 11
    call TriggerAddCondition(gg_trg_Lancer_Task_Dragons,Condition(function Trig_Lancer_Task_Dragons_Conditions))
    call TriggerAddAction(gg_trg_Lancer_Task_Dragons,function Trig_Lancer_Task_Dragons_Actions)
endfunction

// Creates part 1 of 2 of this module's triggers. Called once at startup from
// Startup_RegisterTriggers (MapBootstrap). The parts are registered at different points so that
// triggers sharing an event with other modules keep their original firing order.
function RegisterTriggers_Lancer_Part1 takes nothing returns nothing
    call Register_Lancer_DragonBreath()
    call Register_Lancer_DragonSlam()
    call Register_Lancer_DragonAlly()
    call Register_Lancer_Jump_RangeCheck()
    call Register_Lancer_Jump()
endfunction

// Creates part 2 of 2 of this module's triggers. Called once at startup from
// Startup_RegisterTriggers (MapBootstrap). The parts are registered at different points so that
// triggers sharing an event with other modules keep their original firing order.
function RegisterTriggers_Lancer_Part2 takes nothing returns nothing
    call Register_Lancer_Task_Dragons()
endfunction

endlibrary
