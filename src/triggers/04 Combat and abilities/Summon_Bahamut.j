library TSummonBahamut requires TAbil, TProf
function Trig_Summon_Bahamut_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A146') // 'A146': ability "!Bahamut"
endfunction

function Trig_Summon_Bahamut_HasBahamut takes nothing returns boolean
    return(udg_BahamutSummon!=null)
endfunction

function Trig_Summon_Bahamut_Actions takes nothing returns nothing
    local location l_tempPoint
    local real l_tempReal
    if(Trig_Summon_Bahamut_HasBahamut())then
        call KillUnit(udg_BahamutSummon)
    endif
    set l_tempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateNUnitsAtLoc(1,'n005',GetOwningPlayer(GetSpellAbilityUnit()),l_tempPoint,bj_UNIT_FACING) // 'n005': unit "Bahamut"
    call AddSpecialEffectLocBJ(l_tempPoint,"Abilities\\Spells\\Items\\AIda\\AIdaCaster.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(l_tempPoint)
    set udg_BahamutSummon=GetLastCreatedUnit()
    call UnitAddAbilityBJ('A14I',GetLastCreatedUnit()) // 'A14I': ability "Summon Poof Death"
    call AddSpecialEffectTargetUnitBJ("origin",GetLastCreatedUnit(),"Abilities\\Spells\\Human\\MarkOfChaos\\MarkOfChaosTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call UnitApplyTimedLifeBJ(60.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    set udg_TempUnit2=GetLastCreatedUnit()
    call ConditionalTriggerExecute(gg_trg_Summon_Powerup)
    // (0.1) times ((10) plus (Prof_GetLevel(the triggering unit, 'R00L'))).
    set l_tempReal=.1*($A+Prof_GetLevel(GetTriggerUnit(),'R00L')) // $A = 10; 'R00L': upgrade "Inner Mana"
    // Result 1: Intelligence of the triggering unit treated as a decimal-capable number.
    // Result 2: (l_tempReal) times (0.55).
    // Result 3: (result 1) times (result 2).
    // Result 4: (result 3) with its decimal part removed.
    // Result 5: (BlzGetUnitBaseDamage(GetLastCreatedUnit(), 0)) plus (result 4).
    call BlzSetUnitBaseDamage(GetLastCreatedUnit(),(BlzGetUnitBaseDamage(GetLastCreatedUnit(),0)+R2I((I2R(GetHeroStatBJ(bj_HEROSTAT_INT,GetTriggerUnit(),true))*(l_tempReal*.55)))),0)
    // Result 1: Intelligence of the triggering unit treated as a decimal-capable number.
    // Result 2: (l_tempReal) times (0.55).
    // Result 3: (result 1) times (result 2).
    // Result 4: (result 3) with its decimal part removed.
    // Result 5: (BlzGetUnitBaseDamage(GetLastCreatedUnit(), 1)) plus (result 4).
    call BlzSetUnitBaseDamage(GetLastCreatedUnit(),(BlzGetUnitBaseDamage(GetLastCreatedUnit(),1)+R2I((I2R(GetHeroStatBJ(bj_HEROSTAT_INT,GetTriggerUnit(),true))*(l_tempReal*.55)))),1)
    // Result 1: Intelligence of the triggering unit treated as a decimal-capable number.
    // Result 2: (8) times (l_tempReal).
    // Result 3: (result 1) times (result 2).
    // Result 4: (result 3) with its decimal part removed.
    // Result 5: (maximum health of GetLastCreatedUnit()) plus (result 4).
    call BlzSetUnitMaxHP(GetLastCreatedUnit(),(BlzGetUnitMaxHP(GetLastCreatedUnit())+R2I((I2R(GetHeroStatBJ(bj_HEROSTAT_INT,GetTriggerUnit(),true))*(8.*l_tempReal)))))
    call SetUnitLifePercentBJ(GetLastCreatedUnit(),'d')
    call Abil_CopyPassives(GetTriggerUnit(),bj_lastCreatedUnit)
    set udg_BahamutBaseArmor=BlzGetUnitArmor(GetLastCreatedUnit())
    set l_tempPoint=null
endfunction

function InitTrig_Summon_Bahamut takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Summon_Part2 (module Summon),
// which keeps the original registration order.

function Register_Summon_Bahamut takes nothing returns nothing
    set gg_trg_Summon_Bahamut=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Summon_Bahamut,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Summon_Bahamut,Condition(function Trig_Summon_Bahamut_Conditions))
    call TriggerAddAction(gg_trg_Summon_Bahamut,function Trig_Summon_Bahamut_Actions)
endfunction

endlibrary
