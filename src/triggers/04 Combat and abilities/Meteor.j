library TMeteor requires TAbil, TProf
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Meteor_Cast=null
endglobals

function Trig_Meteor_Cast_IsMeteor takes nothing returns boolean
    return(GetSpellAbilityId()=='A0QM')or(GetSpellAbilityId()=='A0QN')or(GetSpellAbilityId()=='A12I')or(GetSpellAbilityId()=='A1F2') // 'A0QM': ability "Meteor"; 'A0QN': ability "Meteor"; 'A12I': ability "Meteor"; 'A1F2': ability "Meteor"
endfunction

function Trig_Meteor_Cast_Conditions takes nothing returns boolean
    return(Trig_Meteor_Cast_IsMeteor())
endfunction

function Trig_Meteor_Cast_NoTargetUnit takes nothing returns boolean
    return(GetSpellTargetUnit()==null)
endfunction

function Trig_Meteor_Cast_IsHero takes nothing returns boolean
    return(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Meteor_Cast_Actions takes nothing returns nothing
    if(Trig_Meteor_Cast_NoTargetUnit())then
        set udg_TempPoint=GetSpellTargetLoc()
    else
        set udg_TempPoint=GetUnitLoc(GetSpellTargetUnit())
    endif
    call CreateNUnitsAtLocFacingLocBJ(1,'h01B',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,udg_TempPoint) // 'h01B': unit "Proxy Dummy"
    set udg_TempHandleId=GetHandleIdBJ(GetLastCreatedUnit())
    call SaveUnitHandleBJ(GetTriggerUnit(),0,udg_TempHandleId,udg_ProxyDamageHash)
    set udg_TempInteger=$FA // $FA = 250
    if(Trig_Meteor_Cast_IsHero())then
        // Add half the caster's Intelligence, dropping any fraction.
        set udg_TempInteger=(udg_TempInteger+(GetHeroStatBJ(bj_HEROSTAT_INT,GetTriggerUnit(),true)/ 2))
    endif
    set udg_TempReal=Prof_InnerManaPower(GetTriggerUnit())
    // (udg_TempInteger treated as a decimal-capable number) times (udg_TempReal).
    call SaveRealBJ((I2R(udg_TempInteger)*udg_TempReal),1,udg_TempHandleId,udg_ProxyDamageHash)
    call SaveIntegerBJ(3,2,udg_TempHandleId,udg_ProxyDamageHash)
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(15.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    // Divide the spell's mana cost by 50 and drop the remainder to get this count.
    set udg_TempInteger=(BlzGetAbilityManaCost(GetSpellAbilityId(),Abil_GetLevel(GetTriggerUnit(),GetSpellAbilityId()))/ 50)
    // The remainder after dividing ((udg_MeteorDummyIndex) plus (1)) by (4).
    set udg_MeteorDummyIndex=ModuloInteger((udg_MeteorDummyIndex+1),4)
    call UnitAddAbilityBJ(udg_MeteorDummyAbility[udg_MeteorDummyIndex],GetLastCreatedUnit())
    call SetUnitAbilityLevelSwapped(udg_MeteorDummyAbility[udg_MeteorDummyIndex],GetLastCreatedUnit(),udg_TempInteger)
    call IssuePointOrderLocBJ(GetLastCreatedUnit(),"blizzard",udg_TempPoint)
    call RemoveLocation(udg_TempPoint)
endfunction

// World Editor calls InitTrig_Meteor automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Meteor (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Meteor takes nothing returns nothing
endfunction

function Register_Meteor_Cast takes nothing returns nothing
    set gg_trg_Meteor_Cast=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Meteor_Cast,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Meteor_Cast,Condition(function Trig_Meteor_Cast_Conditions))
    call TriggerAddAction(gg_trg_Meteor_Cast,function Trig_Meteor_Cast_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Meteor takes nothing returns nothing
    call Register_Meteor_Cast()
endfunction

endlibrary
