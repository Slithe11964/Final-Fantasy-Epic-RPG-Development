library TSorcerer requires TAbil, TGroup, TLoc, TProf
function Trig_Sorcerer_Flare_IsFlareSpell takes nothing returns boolean
    return(GetSpellAbilityId()=='A0TB')or(GetSpellAbilityId()=='A0TD')or(GetSpellAbilityId()=='A0TC')or(GetSpellAbilityId()=='A0TF')or(GetSpellAbilityId()=='A0TE') // 'A0TB': ability "Flare"; 'A0TD': ability "Flare"; 'A0TC': ability "Flare"; 'A0TF': ability "Flare"; 'A0TE': ability "Flare"
endfunction

function Trig_Sorcerer_Flare_Conditions takes nothing returns boolean
    return(Trig_Sorcerer_Flare_IsFlareSpell())
endfunction

function Trig_Sorcerer_Flare_HasNoTargetUnit takes nothing returns boolean
    return(GetSpellTargetUnit()==null)
endfunction

function Trig_Sorcerer_Flare_CasterIsHero takes nothing returns boolean
    return(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Sorcerer_Flare_Actions takes nothing returns nothing
    if(Trig_Sorcerer_Flare_HasNoTargetUnit())then
        set udg_TempPoint=GetSpellTargetLoc()
    else
        set udg_TempPoint=GetUnitLoc(GetSpellTargetUnit())
    endif
    call CreateNUnitsAtLocFacingLocBJ(1,'h01B',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,udg_TempPoint) // 'h01B': unit "Proxy Dummy"
    call AddSpecialEffectLocBJ(udg_TempPoint,"Objects\\Spawnmodels\\Other\\NeutralBuildingExplosion\\NeutralBuildingExplosion.mdl")
    call BlzSetSpecialEffectScale(GetLastCreatedEffectBJ(),3.)
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=16
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        // (22.5) times (loop counter A treated as a decimal-capable number).
        set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,128.,(22.5*I2R(GetForLoopIndexA())))
        call AddSpecialEffectLocBJ(udg_TempPoint2,"Abilities\\Spells\\Other\\Doom\\DoomDeath.mdl")
        call RemoveLocation(udg_TempPoint2)
        call BlzSetSpecialEffectScale(GetLastCreatedEffectBJ(),2.)
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        // (22.5) times (loop counter A treated as a decimal-capable number).
        set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,256.,(22.5*I2R(GetForLoopIndexA())))
        call AddSpecialEffectLocBJ(udg_TempPoint2,"Abilities\\Spells\\Other\\Doom\\DoomDeath.mdl")
        call RemoveLocation(udg_TempPoint2)
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    call RemoveLocation(udg_TempPoint)
    set udg_TempHandleId=GetHandleIdBJ(GetLastCreatedUnit())
    call SaveUnitHandleBJ(GetTriggerUnit(),0,udg_TempHandleId,udg_ProxyDamageHash)
    // (BlzGetAbilityManaCost(GetSpellAbilityId(), Abil_GetLevel(the triggering unit, GetSpellAbilityId()))) times
    // (4).
    set udg_TempInteger=(BlzGetAbilityManaCost(GetSpellAbilityId(),Abil_GetLevel(GetTriggerUnit(),GetSpellAbilityId()))*4)
    if(Trig_Sorcerer_Flare_CasterIsHero())then
        // (udg_TempInteger) plus ((Intelligence of the triggering unit) times (4)).
        set udg_TempInteger=(udg_TempInteger+(GetHeroStatBJ(bj_HEROSTAT_INT,GetTriggerUnit(),true)*4))
    endif
    set udg_TempReal=Prof_InnerManaPower(GetTriggerUnit())
    // (udg_TempInteger treated as a decimal-capable number) times (udg_TempReal).
    call SaveRealBJ((I2R(udg_TempInteger)*udg_TempReal),1,udg_TempHandleId,udg_ProxyDamageHash)
    call SaveIntegerBJ(3,2,udg_TempHandleId,udg_ProxyDamageHash)
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(2.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A0TA',GetLastCreatedUnit()) // 'A0TA': ability "Flare"
    call IssueImmediateOrderBJ(GetLastCreatedUnit(),"stomp")
endfunction

function Trig_Sorcerer_Holy_IsHolySpell takes nothing returns boolean
    return(GetSpellAbilityId()=='A04K')or(GetSpellAbilityId()=='A01V')or(GetSpellAbilityId()=='A0E5')or(GetSpellAbilityId()=='A11X')or(GetSpellAbilityId()=='A0UE')or(GetSpellAbilityId()=='A0XI')or(GetSpellAbilityId()=='A0CY')or(GetSpellAbilityId()=='A11L') // 'A04K': ability "Holy"; 'A01V': ability "Holy"; 'A0E5': ability "Holy"; 'A11X': ability "Holy"; 'A0UE': ability "Holy"; 'A0XI': ability "Holy"; 'A0CY': ability "Holy"; 'A11L': ability "Holy"
endfunction

function Trig_Sorcerer_Holy_Conditions takes nothing returns boolean
    return(Trig_Sorcerer_Holy_IsHolySpell())
endfunction

function Trig_Sorcerer_Holy_CasterIsHero takes nothing returns boolean
    return(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Sorcerer_Holy_FilterIsAlive takes nothing returns boolean
    return(IsUnitAliveBJ(GetFilterUnit()))
endfunction

function Trig_Sorcerer_Holy_FilterNotCaster takes nothing returns boolean
    return(GetTriggerUnit()!=GetFilterUnit())
endfunction

function Trig_Sorcerer_Holy_FilterAliveNotCaster takes nothing returns boolean
    return GetBooleanAnd(Trig_Sorcerer_Holy_FilterIsAlive(),Trig_Sorcerer_Holy_FilterNotCaster())
endfunction

function Trig_Sorcerer_Holy_FilterNotInvulnerable takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('Avul',GetFilterUnit())<=0) // 'Avul': standard ability reference "Invulnerable"
endfunction

function Trig_Sorcerer_Holy_FilterTarget takes nothing returns boolean
    return GetBooleanAnd(Trig_Sorcerer_Holy_FilterAliveNotCaster(),Trig_Sorcerer_Holy_FilterNotInvulnerable())
endfunction

function Trig_Sorcerer_Holy_EnumNegatesHeal takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0Z8',GetEnumUnit())>0) // 'A0Z8': ability "Negate Collateral Heals"
endfunction

function Trig_Sorcerer_Holy_EnumNotUndead takes nothing returns boolean
    return((GetUnitAbilityLevelSwapped('A0Z8',GetEnumUnit())>0)or(IsUnitType(GetEnumUnit(),UNIT_TYPE_UNDEAD)==false))!=null // 'A0Z8': ability "Negate Collateral Heals"
endfunction

function Trig_Sorcerer_Holy_EnumIsSameSide takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_ActivePlayers)==IsPlayerInForce(GetOwningPlayer(GetEnumUnit()),udg_ActivePlayers))and(GetOwningPlayer(GetEnumUnit())!=Player(8))and(GetOwningPlayer(GetEnumUnit())!=Player(PLAYER_NEUTRAL_PASSIVE))and(Trig_Sorcerer_Holy_EnumNotUndead())
endfunction

function Trig_Sorcerer_Holy_EnumIsEnemy takes nothing returns boolean
    return(IsUnitEnemy(GetEnumUnit(),GetOwningPlayer(GetTriggerUnit())))
endfunction

function Trig_Sorcerer_Holy_ApplyToEnum takes nothing returns nothing
    if(Trig_Sorcerer_Holy_EnumIsEnemy())then
        call AddSpecialEffectTargetUnitBJ("origin",GetEnumUnit(),"Abilities\\Spells\\Other\\Monsoon\\MonsoonBoltTarget.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        set udg_IgnoresReduction=true
        // Udg_TempInteger treated as a decimal-capable number.
        call UnitDamageTargetBJ(GetSpellAbilityUnit(),GetEnumUnit(),I2R(udg_TempInteger),ATTACK_TYPE_NORMAL,DAMAGE_TYPE_UNIVERSAL)
    else
        if(Trig_Sorcerer_Holy_EnumIsSameSide())then
            if(Trig_Sorcerer_Holy_EnumNegatesHeal())then
                call AddSpecialEffectTargetUnitBJ("overhead",GetEnumUnit(),"Abilities\\Spells\\Undead\\DeathPact\\DeathPactTarget.mdl")
                call DestroyEffectBJ(GetLastCreatedEffectBJ())
            else
                call AddSpecialEffectTargetUnitBJ("origin",GetEnumUnit(),"Abilities\\Spells\\Human\\HolyBolt\\HolyBoltSpecialArt.mdl")
                call DestroyEffectBJ(GetLastCreatedEffectBJ())
                set udg_IsPureDamage=true
                // Udg_TempInteger treated as a decimal-capable number.
                call UnitDamageTargetBJ(GetSpellAbilityUnit(),GetEnumUnit(),I2R(udg_TempInteger),ATTACK_TYPE_NORMAL,DAMAGE_TYPE_UNIVERSAL)
            endif
        endif
    endif
endfunction

function Trig_Sorcerer_Holy_CasterNegatesHeal takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0Z8',GetTriggerUnit())>0) // 'A0Z8': ability "Negate Collateral Heals"
endfunction

function Trig_Sorcerer_Holy_Actions takes nothing returns nothing
    // (BlzGetAbilityManaCost(GetSpellAbilityId(), Abil_GetLevel(the triggering unit, GetSpellAbilityId()))) times
    // (2).
    set udg_TempInteger=(BlzGetAbilityManaCost(GetSpellAbilityId(),Abil_GetLevel(GetTriggerUnit(),GetSpellAbilityId()))*2)
    if(Trig_Sorcerer_Holy_CasterIsHero())then
        // (udg_TempInteger) plus ((Intelligence of the triggering unit) times (2)).
        set udg_TempInteger=(udg_TempInteger+(GetHeroStatBJ(bj_HEROSTAT_INT,GetTriggerUnit(),true)*2))
    endif
    set udg_TempReal=Prof_StaffPowerAlt(GetTriggerUnit())
    // ((udg_TempInteger treated as a decimal-capable number) times (udg_TempReal)) with its decimal part removed.
    set udg_TempInteger=R2I((I2R(udg_TempInteger)*udg_TempReal))
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    set udg_TempGroup=Group_UnitsInRangeOfLoc(800.,udg_TempPoint,Condition(function Trig_Sorcerer_Holy_FilterTarget))
    call RemoveLocation(udg_TempPoint)
    call ForGroupBJ(udg_TempGroup,function Trig_Sorcerer_Holy_ApplyToEnum)
    call DestroyGroup(udg_TempGroup)
    if(Trig_Sorcerer_Holy_CasterNegatesHeal())then
        call AddSpecialEffectTargetUnitBJ("overhead",GetTriggerUnit(),"Abilities\\Spells\\Undead\\DeathPact\\DeathPactTarget.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
    else
        call AddSpecialEffectTargetUnitBJ("origin",GetTriggerUnit(),"Abilities\\Spells\\Human\\HolyBolt\\HolyBoltSpecialArt.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        set udg_IsPureDamage=true
        // Udg_TempInteger treated as a decimal-capable number.
        call UnitDamageTargetBJ(GetSpellAbilityUnit(),GetTriggerUnit(),I2R(udg_TempInteger),ATTACK_TYPE_NORMAL,DAMAGE_TYPE_UNIVERSAL)
    endif
endfunction

function Trig_Sorcerer_MassCripple_IsCrippleSpell takes nothing returns boolean
    return(GetSpellAbilityId()=='A08Y')or(GetSpellAbilityId()=='A000') // 'A08Y': ability "Mass Cripple"; 'A000': ability "Mass Cripple"
endfunction

function Trig_Sorcerer_MassCripple_Conditions takes nothing returns boolean
    return(Trig_Sorcerer_MassCripple_IsCrippleSpell())
endfunction

function Trig_Sorcerer_MassCripple_FilterIsEnemy takes nothing returns boolean
    return(IsUnitEnemy(GetFilterUnit(),GetOwningPlayer(GetTriggerUnit())))
endfunction

function Trig_Sorcerer_MassCripple_FilterNotStructure takes nothing returns boolean
    return(IsUnitType(GetFilterUnit(),UNIT_TYPE_STRUCTURE)==false)!=null
endfunction

function Trig_Sorcerer_MassCripple_FilterEnemyNotStructure takes nothing returns boolean
    return GetBooleanAnd(Trig_Sorcerer_MassCripple_FilterIsEnemy(),Trig_Sorcerer_MassCripple_FilterNotStructure())
endfunction

function Trig_Sorcerer_MassCripple_FilterIsAlive takes nothing returns boolean
    return(IsUnitAliveBJ(GetFilterUnit()))
endfunction

function Trig_Sorcerer_MassCripple_FilterNotInvulnerable takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('Avul',GetFilterUnit())<=0) // 'Avul': standard ability reference "Invulnerable"
endfunction

function Trig_Sorcerer_MassCripple_FilterAliveTargetable takes nothing returns boolean
    return GetBooleanAnd(Trig_Sorcerer_MassCripple_FilterIsAlive(),Trig_Sorcerer_MassCripple_FilterNotInvulnerable())
endfunction

function Trig_Sorcerer_MassCripple_FilterTarget takes nothing returns boolean
    return GetBooleanAnd(Trig_Sorcerer_MassCripple_FilterEnemyNotStructure(),Trig_Sorcerer_MassCripple_FilterAliveTargetable())
endfunction

function Trig_Sorcerer_MassCripple_CrippleEnum takes nothing returns nothing
    set udg_TempPoint=GetUnitLoc(GetEnumUnit())
    call CreateNUnitsAtLocFacingLocBJ(1,'h02S',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,udg_TempPoint) // 'h02S': unit "Simple Casting Dummy"
    call RemoveLocation(udg_TempPoint)
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(1.5,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A15O',GetLastCreatedUnit()) // 'A15O': ability "Mass Cripple"
    call SetUnitAbilityLevelSwapped('A15O',GetLastCreatedUnit(),udg_TempInteger) // 'A15O': ability "Mass Cripple"
    call IssueTargetOrderBJ(GetLastCreatedUnit(),"cripple",GetEnumUnit())
endfunction

function Trig_Sorcerer_MassCripple_Actions takes nothing returns nothing
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    set udg_TempGroup=Group_UnitsInRangeOfLoc(800.,udg_TempPoint,Condition(function Trig_Sorcerer_MassCripple_FilterTarget))
    call RemoveLocation(udg_TempPoint)
    // Result 1: (BlzGetAbilityManaCost(GetSpellAbilityId(), Abil_GetLevel(the triggering unit,
    // GetSpellAbilityId()))) divided by (40).
    set udg_TempInteger=(BlzGetAbilityManaCost(GetSpellAbilityId(),Abil_GetLevel(GetTriggerUnit(),GetSpellAbilityId())))/ 40
    call ForGroupBJ(udg_TempGroup,function Trig_Sorcerer_MassCripple_CrippleEnum)
    call DestroyGroup(udg_TempGroup)
endfunction

function Trig_Sorcerer_BahamutZero_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A148') // 'A148': ability "!Bahamut Zero"
endfunction

function Trig_Sorcerer_BahamutZero_HasBahamutZero takes nothing returns boolean
    return(udg_BahamutZeroSummon!=null)
endfunction

function Trig_Sorcerer_BahamutZero_Actions takes nothing returns nothing
    if(Trig_Sorcerer_BahamutZero_HasBahamutZero())then
        call KillUnit(udg_BahamutZeroSummon)
    endif
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateNUnitsAtLoc(1,'n00Q',GetOwningPlayer(GetSpellAbilityUnit()),udg_TempPoint,bj_UNIT_FACING) // 'n00Q': unit "Bahamut Zero"
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Items\\AIda\\AIdaCaster.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(udg_TempPoint)
    set udg_BahamutZeroSummon=GetLastCreatedUnit()
    call UnitAddAbilityBJ('A14I',GetLastCreatedUnit()) // 'A14I': ability "Summon Poof Death"
    call AddSpecialEffectTargetUnitBJ("origin",GetLastCreatedUnit(),"Abilities\\Spells\\Human\\MarkOfChaos\\MarkOfChaosTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call UnitApplyTimedLifeBJ(60.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    set udg_TempUnit2=GetLastCreatedUnit()
    call ConditionalTriggerExecute(gg_trg_Summon_Powerup)
    // (0.1) times ((10) plus (Prof_GetLevel(the triggering unit, 'R00L'))).
    set udg_TempReal=.1*($A+Prof_GetLevel(GetTriggerUnit(),'R00L')) // $A = 10; 'R00L': upgrade "Inner Mana"
    // Result 1: Intelligence of the triggering unit treated as a decimal-capable number.
    // Result 2: (udg_TempReal) times (0.65).
    // Result 3: (result 1) times (result 2).
    // Result 4: (result 3) with its decimal part removed.
    // Result 5: (BlzGetUnitBaseDamage(GetLastCreatedUnit(), 0)) plus (result 4).
    call BlzSetUnitBaseDamage(GetLastCreatedUnit(),(BlzGetUnitBaseDamage(GetLastCreatedUnit(),0)+R2I((I2R(GetHeroStatBJ(bj_HEROSTAT_INT,GetTriggerUnit(),true))*(udg_TempReal*.65)))),0)
    // Result 1: Intelligence of the triggering unit treated as a decimal-capable number.
    // Result 2: (udg_TempReal) times (0.65).
    // Result 3: (result 1) times (result 2).
    // Result 4: (result 3) with its decimal part removed.
    // Result 5: (BlzGetUnitBaseDamage(GetLastCreatedUnit(), 1)) plus (result 4).
    call BlzSetUnitBaseDamage(GetLastCreatedUnit(),(BlzGetUnitBaseDamage(GetLastCreatedUnit(),1)+R2I((I2R(GetHeroStatBJ(bj_HEROSTAT_INT,GetTriggerUnit(),true))*(udg_TempReal*.65)))),1)
    // Result 1: Intelligence of the triggering unit treated as a decimal-capable number.
    // Result 2: (10) times (udg_TempReal).
    // Result 3: (result 1) times (result 2).
    // Result 4: (result 3) with its decimal part removed.
    // Result 5: (maximum health of GetLastCreatedUnit()) plus (result 4).
    call BlzSetUnitMaxHP(GetLastCreatedUnit(),(BlzGetUnitMaxHP(GetLastCreatedUnit())+R2I((I2R(GetHeroStatBJ(bj_HEROSTAT_INT,GetTriggerUnit(),true))*(10.*udg_TempReal)))))
    call SetUnitLifePercentBJ(GetLastCreatedUnit(),'d')
    call Abil_CopyPassives(GetTriggerUnit(),bj_lastCreatedUnit)
    set udg_BahamutZeroBaseArmor=BlzGetUnitArmor(GetLastCreatedUnit())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Sorcerer takes nothing returns nothing
endfunction
function RegisterR11_Sorcerer_Flare takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Sorcerer_Flare=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Sorcerer_Flare,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Sorcerer_Flare,Condition(function Trig_Sorcerer_Flare_Conditions))
    call TriggerAddAction(gg_trg_Sorcerer_Flare,function Trig_Sorcerer_Flare_Actions)
endfunction
function RegisterR11_Sorcerer_Holy takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Sorcerer_Holy=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Sorcerer_Holy,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Sorcerer_Holy,Condition(function Trig_Sorcerer_Holy_Conditions))
    call TriggerAddAction(gg_trg_Sorcerer_Holy,function Trig_Sorcerer_Holy_Actions)
endfunction
function RegisterR11_Sorcerer_MassCripple takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Sorcerer_MassCripple=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Sorcerer_MassCripple,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Sorcerer_MassCripple,Condition(function Trig_Sorcerer_MassCripple_Conditions))
    call TriggerAddAction(gg_trg_Sorcerer_MassCripple,function Trig_Sorcerer_MassCripple_Actions)
endfunction
function RegisterR11_Sorcerer_BahamutZero takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Sorcerer_BahamutZero=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Sorcerer_BahamutZero,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Sorcerer_BahamutZero,Condition(function Trig_Sorcerer_BahamutZero_Conditions))
    call TriggerAddAction(gg_trg_Sorcerer_BahamutZero,function Trig_Sorcerer_BahamutZero_Actions)
endfunction




endlibrary
