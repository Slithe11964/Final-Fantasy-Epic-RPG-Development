library TSummonIfrit requires TAbil, TProf
function Trig_Summon_Ifrit_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A1FP') // 'A1FP': ability "Ifrit"
endfunction

function Trig_Summon_Ifrit_HasIfrit takes nothing returns boolean
    return(udg_Eidolon2!=null)
endfunction

function Trig_Summon_Ifrit_IsLevel3Plus takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped(GetSpellAbilityId(),GetTriggerUnit())>=3)
endfunction

function Trig_Summon_Ifrit_Actions takes nothing returns nothing
    local location l_tempPoint
    local real l_tempReal
    if(Trig_Summon_Ifrit_HasIfrit())then
        call KillUnit(udg_Eidolon2)
    endif
    set l_tempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateNUnitsAtLoc(1,udg_IfritUnitType[GetUnitAbilityLevelSwapped(GetSpellAbilityId(),GetTriggerUnit())],GetOwningPlayer(GetTriggerUnit()),l_tempPoint,GetUnitFacing(GetTriggerUnit()))
    call AddSpecialEffectLocBJ(l_tempPoint,"Abilities\\Spells\\Items\\AIda\\AIdaCaster.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(l_tempPoint)
    set udg_Eidolon2=GetLastCreatedUnit()
    call UnitAddAbilityBJ('A14I',GetLastCreatedUnit()) // 'A14I': ability "Summon Poof Death"
    if(Trig_Summon_Ifrit_IsLevel3Plus())then
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_ImmolationAuraGroup)
    endif
    call UnitApplyTimedLifeBJ(90.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    set udg_TempUnit2=GetLastCreatedUnit()
    call ConditionalTriggerExecute(gg_trg_Summon_Powerup)
    set l_tempReal=.1*($A+Prof_GetLevel(GetTriggerUnit(),'R00L')) // $A = 10; 'R00L': upgrade "Inner Mana"
    // Result 1: Intelligence of the triggering unit treated as a decimal-capable number.
    // Result 2: (l_tempReal) times (0.45).
    // Result 3: (result 1) times (result 2).
    // Result 4: (result 3) with its decimal part removed.
    // Result 5: (BlzGetUnitBaseDamage(GetLastCreatedUnit(), 0)) plus (result 4).
    call BlzSetUnitBaseDamage(GetLastCreatedUnit(),(BlzGetUnitBaseDamage(GetLastCreatedUnit(),0)+R2I((I2R(GetHeroStatBJ(bj_HEROSTAT_INT,GetTriggerUnit(),true))*(l_tempReal*.45)))),0)
    // Result 1: Intelligence of the triggering unit treated as a decimal-capable number.
    // Result 2: (l_tempReal) times (0.45).
    // Result 3: (result 1) times (result 2).
    // Result 4: (result 3) with its decimal part removed.
    // Result 5: (BlzGetUnitBaseDamage(GetLastCreatedUnit(), 1)) plus (result 4).
    call BlzSetUnitBaseDamage(GetLastCreatedUnit(),(BlzGetUnitBaseDamage(GetLastCreatedUnit(),1)+R2I((I2R(GetHeroStatBJ(bj_HEROSTAT_INT,GetTriggerUnit(),true))*(l_tempReal*.45)))),1)
    // Result 1: Intelligence of the triggering unit treated as a decimal-capable number.
    // Result 2: (6) times (l_tempReal).
    // Result 3: (result 1) times (result 2).
    // Result 4: (result 3) with its decimal part removed.
    // Result 5: (maximum health of GetLastCreatedUnit()) plus (result 4).
    call BlzSetUnitMaxHP(GetLastCreatedUnit(),(BlzGetUnitMaxHP(GetLastCreatedUnit())+R2I((I2R(GetHeroStatBJ(bj_HEROSTAT_INT,GetTriggerUnit(),true))*(6.*l_tempReal)))))
    call SetUnitLifePercentBJ(GetLastCreatedUnit(),'d')
    call Abil_CopyPassives(GetTriggerUnit(),bj_lastCreatedUnit)
    set udg_IfritBaseArmor=BlzGetUnitArmor(GetLastCreatedUnit())
    set l_tempPoint=null
endfunction

function InitTrig_Summon_Ifrit takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Summon_Part2 (module Summon),
// which keeps the original registration order.

function Register_Summon_Ifrit takes nothing returns nothing
    set gg_trg_Summon_Ifrit=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Summon_Ifrit,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Summon_Ifrit,Condition(function Trig_Summon_Ifrit_Conditions))
    call TriggerAddAction(gg_trg_Summon_Ifrit,function Trig_Summon_Ifrit_Actions)
endfunction

endlibrary
