library TSummonShiva requires TAbil, TProf
function Trig_Summon_Shiva_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A0V5') // 'A0V5': ability "Shiva"
endfunction

function Trig_Summon_Shiva_HasShiva takes nothing returns boolean
    return(udg_Eidolon1!=null)
endfunction

function Trig_Summon_Shiva_Actions takes nothing returns nothing
    if(Trig_Summon_Shiva_HasShiva())then
        call KillUnit(udg_Eidolon1)
    endif
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateNUnitsAtLoc(1,udg_ShivaUnitType[GetUnitAbilityLevelSwapped(GetSpellAbilityId(),GetTriggerUnit())],GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,GetUnitFacing(GetTriggerUnit()))
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Items\\AIda\\AIdaCaster.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(udg_TempPoint)
    set udg_Eidolon1=GetLastCreatedUnit()
    call UnitAddAbilityBJ('A14I',GetLastCreatedUnit()) // 'A14I': ability "Summon Poof Death"
    call UnitApplyTimedLifeBJ(90.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    set udg_TempUnit2=GetLastCreatedUnit()
    call ConditionalTriggerExecute(gg_trg_Summon_Powerup)
    // (0.1) times ((10) plus (Prof_GetLevel(the triggering unit, 'R00L'))).
    set udg_TempReal=.1*($A+Prof_GetLevel(GetTriggerUnit(),'R00L')) // $A = 10; 'R00L': upgrade "Inner Mana"
    // Result 1: Intelligence of the triggering unit treated as a decimal-capable number.
    // Result 2: (udg_TempReal) times (0.5).
    // Result 3: (result 1) times (result 2).
    // Result 4: (result 3) with its decimal part removed.
    // Result 5: (BlzGetUnitBaseDamage(GetLastCreatedUnit(), 0)) plus (result 4).
    call BlzSetUnitBaseDamage(GetLastCreatedUnit(),(BlzGetUnitBaseDamage(GetLastCreatedUnit(),0)+R2I((I2R(GetHeroStatBJ(bj_HEROSTAT_INT,GetTriggerUnit(),true))*(udg_TempReal*.5)))),0)
    // Result 1: Intelligence of the triggering unit treated as a decimal-capable number.
    // Result 2: (udg_TempReal) times (0.5).
    // Result 3: (result 1) times (result 2).
    // Result 4: (result 3) with its decimal part removed.
    // Result 5: (BlzGetUnitBaseDamage(GetLastCreatedUnit(), 1)) plus (result 4).
    call BlzSetUnitBaseDamage(GetLastCreatedUnit(),(BlzGetUnitBaseDamage(GetLastCreatedUnit(),1)+R2I((I2R(GetHeroStatBJ(bj_HEROSTAT_INT,GetTriggerUnit(),true))*(udg_TempReal*.5)))),1)
    // Result 1: Intelligence of the triggering unit treated as a decimal-capable number.
    // Result 2: (5) times (udg_TempReal).
    // Result 3: (result 1) times (result 2).
    // Result 4: (result 3) with its decimal part removed.
    // Result 5: (maximum health of GetLastCreatedUnit()) plus (result 4).
    call BlzSetUnitMaxHP(GetLastCreatedUnit(),(BlzGetUnitMaxHP(GetLastCreatedUnit())+R2I((I2R(GetHeroStatBJ(bj_HEROSTAT_INT,GetTriggerUnit(),true))*(5.*udg_TempReal)))))
    call SetUnitLifePercentBJ(GetLastCreatedUnit(),'d')
    call Abil_CopyPassives(GetTriggerUnit(),bj_lastCreatedUnit)
    set udg_ShivaBaseArmor=BlzGetUnitArmor(GetLastCreatedUnit())
endfunction

function InitTrig_Summon_Shiva takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Summon_Part2 (module Summon),
// which keeps the original registration order.

function Register_Summon_Shiva takes nothing returns nothing
    set gg_trg_Summon_Shiva=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Summon_Shiva,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Summon_Shiva,Condition(function Trig_Summon_Shiva_Conditions))
    call TriggerAddAction(gg_trg_Summon_Shiva,function Trig_Summon_Shiva_Actions)
endfunction

endlibrary
