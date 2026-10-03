library TSummonGolem requires TAbil, TProf
function Trig_Summon_Golem_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A0V6') // 'A0V6': ability "Golem"
endfunction

function Trig_Summon_Golem_HasGolem takes nothing returns boolean
    return(udg_GolemSummon!=null)
endfunction

function Trig_Summon_Golem_Actions takes nothing returns nothing
    local location l_tempPoint
    local real l_tempReal
    if(Trig_Summon_Golem_HasGolem())then
        call KillUnit(udg_GolemSummon)
    endif
    set l_tempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateNUnitsAtLoc(1,udg_GolemUnitType[GetUnitAbilityLevelSwapped(GetSpellAbilityId(),GetTriggerUnit())],GetOwningPlayer(GetTriggerUnit()),l_tempPoint,GetUnitFacing(GetTriggerUnit()))
    call AddSpecialEffectLocBJ(l_tempPoint,"Abilities\\Spells\\Items\\AIda\\AIdaCaster.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(l_tempPoint)
    set udg_GolemSummon=GetLastCreatedUnit()
    call UnitAddAbilityBJ('A14I',GetLastCreatedUnit()) // 'A14I': ability "Summon Poof Death"
    call UnitApplyTimedLifeBJ(120.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    set udg_TempUnit2=GetLastCreatedUnit()
    call ConditionalTriggerExecute(gg_trg_Summon_Powerup)
    set l_tempReal=.1*($A+Prof_GetLevel(GetTriggerUnit(),'R00L')) // $A = 10; 'R00L': upgrade "Inner Mana"
    // Result 1: Intelligence of the triggering unit treated as a decimal-capable number.
    // Result 2: (l_tempReal) times (0.1).
    // Result 3: (result 1) times (result 2).
    // Result 4: (result 3) with its decimal part removed.
    // Result 5: (BlzGetUnitBaseDamage(GetLastCreatedUnit(), 0)) plus (result 4).
    call BlzSetUnitBaseDamage(GetLastCreatedUnit(),(BlzGetUnitBaseDamage(GetLastCreatedUnit(),0)+R2I((I2R(GetHeroStatBJ(bj_HEROSTAT_INT,GetTriggerUnit(),true))*(l_tempReal*.1)))),0)
    // Result 1: Intelligence of the triggering unit treated as a decimal-capable number.
    // Result 2: (l_tempReal) times (0.1).
    // Result 3: (result 1) times (result 2).
    // Result 4: (result 3) with its decimal part removed.
    // Result 5: (BlzGetUnitBaseDamage(GetLastCreatedUnit(), 1)) plus (result 4).
    call BlzSetUnitBaseDamage(GetLastCreatedUnit(),(BlzGetUnitBaseDamage(GetLastCreatedUnit(),1)+R2I((I2R(GetHeroStatBJ(bj_HEROSTAT_INT,GetTriggerUnit(),true))*(l_tempReal*.1)))),1)
    // Result 1: Intelligence of the triggering unit treated as a decimal-capable number.
    // Result 2: (l_tempReal) times (0.04).
    // Result 3: (result 1) times (result 2).
    // Result 4: (BlzGetUnitArmor(GetLastCreatedUnit())) plus (result 3).
    call BlzSetUnitArmor(GetLastCreatedUnit(),(BlzGetUnitArmor(GetLastCreatedUnit())+(I2R(GetHeroStatBJ(bj_HEROSTAT_INT,GetTriggerUnit(),true))*(l_tempReal*.04))))
    // Result 1: Intelligence of the triggering unit treated as a decimal-capable number.
    // Result 2: (12) times (l_tempReal).
    // Result 3: (result 1) times (result 2).
    // Result 4: (result 3) with its decimal part removed.
    // Result 5: (maximum health of GetLastCreatedUnit()) plus (result 4).
    call BlzSetUnitMaxHP(GetLastCreatedUnit(),(BlzGetUnitMaxHP(GetLastCreatedUnit())+R2I((I2R(GetHeroStatBJ(bj_HEROSTAT_INT,GetTriggerUnit(),true))*(12.*l_tempReal)))))
    call SetUnitLifePercentBJ(GetLastCreatedUnit(),'d')
    call Abil_CopyPassives(GetTriggerUnit(),bj_lastCreatedUnit)
    set udg_GolemBaseArmor=BlzGetUnitArmor(GetLastCreatedUnit())
    set l_tempPoint=null
endfunction

function InitTrig_Summon_Golem takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Summon_Part2 (module Summon),
// which keeps the original registration order.

function Register_Summon_Golem takes nothing returns nothing
    set gg_trg_Summon_Golem=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Summon_Golem,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Summon_Golem,Condition(function Trig_Summon_Golem_Conditions))
    call TriggerAddAction(gg_trg_Summon_Golem,function Trig_Summon_Golem_Actions)
endfunction

endlibrary
