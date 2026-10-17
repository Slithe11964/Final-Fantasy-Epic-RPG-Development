library TMeteor requires TAbil, TProf, TMyriad
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
    local unit caster=GetTriggerUnit()
    local integer raw=GetSpellAbilityId()
    call Rain_Start(caster,raw,IMaxBJ(1,GetUnitAbilityLevel(caster,raw)),BlzGetAbilityManaCost(raw,Abil_GetLevel(caster,raw)),GetSpellTargetX(),GetSpellTargetY())
    set caster=null
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
