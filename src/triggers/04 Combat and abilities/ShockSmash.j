library TShockSmash requires TAbil, TProf
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_ShockSmash_Cast=null
endglobals

function Trig_ShockSmash_Cast_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A01J') // 'A01J': ability "Shock Smash"
endfunction

function Trig_ShockSmash_Cast_IsCasterHero takes nothing returns boolean
    return(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_ShockSmash_Cast_NoTargetUnit takes nothing returns boolean
    return(GetSpellTargetUnit()==null)
endfunction

function Trig_ShockSmash_Cast_Actions takes nothing returns nothing
    call UnitRemoveBuffBJ('B013',GetSpellTargetUnit()) // 'B013': buff tooltip "Shock"
    // (BlzGetAbilityManaCost(GetSpellAbilityId(), Abil_GetLevel(the triggering unit, GetSpellAbilityId()))) times
    // (5).
    set udg_TempInteger=(BlzGetAbilityManaCost(GetSpellAbilityId(),Abil_GetLevel(GetTriggerUnit(),GetSpellAbilityId()))*5)
    if(Trig_ShockSmash_Cast_IsCasterHero())then
        // (udg_TempInteger) plus ((Strength of the triggering unit) times (5)).
        set udg_TempInteger=(udg_TempInteger+(GetHeroStatBJ(bj_HEROSTAT_STR,GetTriggerUnit(),true)*5))
    endif
    // (0.1) times ((10) plus (Prof_GetLevel(the triggering unit, 'R00I'))).
    set udg_TempReal=.1*($A+Prof_GetLevel(GetTriggerUnit(),'R00I')) // $A = 10; 'R00I': upgrade "Heavens Forged Axe"
    set udg_IsPhysicalAttack=true
    // (udg_TempInteger treated as a decimal-capable number) times (udg_TempReal).
    call UnitDamageTargetBJ(GetTriggerUnit(),GetSpellTargetUnit(),(I2R(udg_TempInteger)*udg_TempReal),ATTACK_TYPE_MELEE,DAMAGE_TYPE_NORMAL)
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateNUnitsAtLocFacingLocBJ(1,'h02S',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,udg_TempPoint) // 'h02S': unit "Simple Casting Dummy"
    call RemoveLocation(udg_TempPoint)
    if(Trig_ShockSmash_Cast_NoTargetUnit())then
        set udg_TempPoint=GetSpellTargetLoc()
    else
        set udg_TempPoint=GetUnitLoc(GetSpellTargetUnit())
    endif
    call SetUnitFacingToFaceLocTimed(GetLastCreatedUnit(),udg_TempPoint,0)
    call RemoveLocation(udg_TempPoint)
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(2.5,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A01K',GetLastCreatedUnit()) // 'A01K': ability "Shock Smash"
    call IssueTargetOrderBJ(GetLastCreatedUnit(),"acidbomb",GetSpellTargetUnit())
endfunction

// World Editor calls InitTrig_ShockSmash automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_ShockSmash (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_ShockSmash takes nothing returns nothing
endfunction

function Register_ShockSmash_Cast takes nothing returns nothing
    set gg_trg_ShockSmash_Cast=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_ShockSmash_Cast,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_ShockSmash_Cast,Condition(function Trig_ShockSmash_Cast_Conditions))
    call TriggerAddAction(gg_trg_ShockSmash_Cast,function Trig_ShockSmash_Cast_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_ShockSmash takes nothing returns nothing
    call Register_ShockSmash_Cast()
endfunction

endlibrary
