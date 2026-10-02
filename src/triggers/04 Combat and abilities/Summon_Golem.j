library TSummonGolem requires TAbil, TProf
function Trig_Summon_Golem_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A0V6') // 'A0V6': ability "Golem"
endfunction

function Trig_Summon_Golem_HasGolem takes nothing returns boolean
    return(udg_GolemSummon!=null)
endfunction

function Trig_Summon_Golem_Actions takes nothing returns nothing
    if(Trig_Summon_Golem_HasGolem())then
        call KillUnit(udg_GolemSummon)
    endif
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateNUnitsAtLoc(1,udg_GolemUnitType[GetUnitAbilityLevelSwapped(GetSpellAbilityId(),GetTriggerUnit())],GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,GetUnitFacing(GetTriggerUnit()))
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Items\\AIda\\AIdaCaster.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(udg_TempPoint)
    set udg_GolemSummon=GetLastCreatedUnit()
    call UnitAddAbilityBJ('A14I',GetLastCreatedUnit()) // 'A14I': ability "Summon Poof Death"
    call UnitApplyTimedLifeBJ(120.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    set udg_TempUnit2=GetLastCreatedUnit()
    call ConditionalTriggerExecute(gg_trg_Summon_Powerup)
    // (0.1) times ((10) plus (Prof_GetLevel(the triggering unit, 'R00L'))).
    set udg_TempReal=.1*($A+Prof_GetLevel(GetTriggerUnit(),'R00L')) // $A = 10; 'R00L': upgrade "Inner Mana"
    // Result 1: Intelligence of the triggering unit treated as a decimal-capable number.
    // Result 2: (udg_TempReal) times (0.1).
    // Result 3: (result 1) times (result 2).
    // Result 4: (result 3) with its decimal part removed.
    // Result 5: (BlzGetUnitBaseDamage(GetLastCreatedUnit(), 0)) plus (result 4).
    call BlzSetUnitBaseDamage(GetLastCreatedUnit(),(BlzGetUnitBaseDamage(GetLastCreatedUnit(),0)+R2I((I2R(GetHeroStatBJ(bj_HEROSTAT_INT,GetTriggerUnit(),true))*(udg_TempReal*.1)))),0)
    // Result 1: Intelligence of the triggering unit treated as a decimal-capable number.
    // Result 2: (udg_TempReal) times (0.1).
    // Result 3: (result 1) times (result 2).
    // Result 4: (result 3) with its decimal part removed.
    // Result 5: (BlzGetUnitBaseDamage(GetLastCreatedUnit(), 1)) plus (result 4).
    call BlzSetUnitBaseDamage(GetLastCreatedUnit(),(BlzGetUnitBaseDamage(GetLastCreatedUnit(),1)+R2I((I2R(GetHeroStatBJ(bj_HEROSTAT_INT,GetTriggerUnit(),true))*(udg_TempReal*.1)))),1)
    // Result 1: Intelligence of the triggering unit treated as a decimal-capable number.
    // Result 2: (udg_TempReal) times (0.04).
    // Result 3: (result 1) times (result 2).
    // Result 4: (BlzGetUnitArmor(GetLastCreatedUnit())) plus (result 3).
    call BlzSetUnitArmor(GetLastCreatedUnit(),(BlzGetUnitArmor(GetLastCreatedUnit())+(I2R(GetHeroStatBJ(bj_HEROSTAT_INT,GetTriggerUnit(),true))*(udg_TempReal*.04))))
    // Result 1: Intelligence of the triggering unit treated as a decimal-capable number.
    // Result 2: (12) times (udg_TempReal).
    // Result 3: (result 1) times (result 2).
    // Result 4: (result 3) with its decimal part removed.
    // Result 5: (maximum health of GetLastCreatedUnit()) plus (result 4).
    call BlzSetUnitMaxHP(GetLastCreatedUnit(),(BlzGetUnitMaxHP(GetLastCreatedUnit())+R2I((I2R(GetHeroStatBJ(bj_HEROSTAT_INT,GetTriggerUnit(),true))*(12.*udg_TempReal)))))
    call SetUnitLifePercentBJ(GetLastCreatedUnit(),'d')
    call Abil_CopyPassives(GetTriggerUnit(),bj_lastCreatedUnit)
    set udg_GolemBaseArmor=BlzGetUnitArmor(GetLastCreatedUnit())
endfunction

function InitTrig_Summon_Golem takes nothing returns nothing
endfunction

endlibrary
