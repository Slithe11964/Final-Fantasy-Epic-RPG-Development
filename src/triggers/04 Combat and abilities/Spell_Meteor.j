library TSpellMeteor requires TProf, TMyriad
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Spell_Meteor_Wide=null
endglobals

function Trig_Spell_Meteor_Wide_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A028') // 'A028': ability "Meteor"
endfunction

function Trig_Spell_Meteor_Wide_IsPointCast takes nothing returns boolean
    return(GetSpellTargetUnit()==null)
endfunction

function Trig_Spell_Meteor_Wide_IsCasterHero takes nothing returns boolean
    return(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Spell_Meteor_Wide_Actions takes nothing returns nothing
    local unit caster=GetTriggerUnit()
    local integer raw=GetSpellAbilityId()
    call Rain_Start(caster,raw,IMaxBJ(1,GetUnitAbilityLevel(caster,raw)),BlzGetAbilityManaCost(raw,Abil_GetLevel(caster,raw)),GetSpellTargetX(),GetSpellTargetY())
    set caster=null
endfunction

function InitTrig_Spell_Meteor takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Spell_Part6 (module Spell),
// which keeps the original registration order.

function Register_Spell_Meteor_Wide takes nothing returns nothing
    set gg_trg_Spell_Meteor_Wide=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Spell_Meteor_Wide,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Spell_Meteor_Wide,Condition(function Trig_Spell_Meteor_Wide_Conditions))
    call TriggerAddAction(gg_trg_Spell_Meteor_Wide,function Trig_Spell_Meteor_Wide_Actions)
endfunction

endlibrary
