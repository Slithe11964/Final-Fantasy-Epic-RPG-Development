library TWave requires TAbil, TKnock, TUnit
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Wave_Fist=null
endglobals

function Trig_Wave_Fist_KnockbackStart takes unit c,unit t,real s,real duration,string fx,boolean sf,real damageAmount returns integer
    local integer d=Knock_Create(t,fx)
    // Starting value for a:
    // Result 1: (udg_KnockY at position d) minus (y position of c).
    // Result 2: (udg_KnockX at position d) minus (x position of c).
    // Result 3: the angle in radians from the y gap (result 1) and x gap (result 2).
    local real a=Atan2(udg_KnockY[d]-GetUnitY(c),udg_KnockX[d]-GetUnitX(c))
    set udg_KnockSpeed[d]=s
    if sf then
        // (udg_KnockSpeed at position d) times ((GetUnitDefaultMoveSpeed(t)) minus ((Agility of t) times (0.4))).
        set udg_KnockSpeed[d]=udg_KnockSpeed[d]*(GetUnitDefaultMoveSpeed(t)-GetHeroAgi(t,true)*.4)
        if(GetUnitAbilityLevel(t,'A0KV')>0)then // 'A0KV': ability "Ailment Defense"
            // (udg_KnockSpeed at position d) times (0.2).
            set udg_KnockSpeed[d]=udg_KnockSpeed[d]*.2
        endif
    endif
    // ((udg_KnockSpeed at position d) divided by (duration)) times (0.03).
    set udg_KnockDecay[d]=udg_KnockSpeed[d]/ duration*.03
    // The horizontal direction share for angle (a) in radians.
    set udg_KnockCosA[d]=Cos(a)
    // The vertical direction share for angle (a) in radians.
    set udg_KnockSinA[d]=Sin(a)
    if(damageAmount>.0)then
        set udg_KnockDamage[d]=damageAmount
        set udg_KnockSource[d]=c
    endif
    call Knock_Register(d)
    return d
endfunction

function Trig_Wave_Fist_Knockback takes unit c,unit t,real s,real duration,string fx,boolean sf,real damageAmount returns nothing
    call Trig_Wave_Fist_KnockbackStart(c,t,s,duration,fx,sf,damageAmount)
endfunction

function Trig_Wave_Fist_IsWaveFist takes nothing returns boolean
    return(GetSpellAbilityId()=='A01L')or(GetSpellAbilityId()=='A0ZN') // 'A01L': ability "Wave Fist"; 'A0ZN': ability "Wave Fist"
endfunction

function Trig_Wave_Fist_Conditions takes nothing returns boolean
    return(Trig_Wave_Fist_IsWaveFist())
endfunction

function Trig_Wave_Fist_IsHero takes nothing returns boolean
    return(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Wave_Fist_TargetNotDisabled takes nothing returns boolean
    return(UnitHasBuffBJ(GetSpellTargetUnit(),'B08E')==false)and(UnitHasBuffBJ(GetSpellTargetUnit(),'B03R')==false)and(UnitHasBuffBJ(GetSpellTargetUnit(),'B08I')==false)and(UnitHasBuffBJ(GetSpellTargetUnit(),'BPSE')==false) // 'B08E': buff tooltip "Daze"; 'B03R': buff tooltip "Stunned"; 'B08I': buff tooltip "Stunned"; 'BPSE': buff tooltip "Stunned"
endfunction

function Trig_Wave_Fist_IsCritical takes nothing returns boolean
    return(udg_TempBoolean)
endfunction

function Trig_Wave_Fist_HasHighProficiency takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A136',GetTriggerUnit())>0) // 'A136': ability "High Proficiency"
endfunction

function Trig_Wave_Fist_Actions takes nothing returns nothing
    local integer l_tempInteger
    call AddSpecialEffectTargetUnitBJ("chest",GetSpellTargetUnit(),"Abilities\\Spells\\Human\\SpellSteal\\SpellStealTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    // (BlzGetAbilityManaCost(GetSpellAbilityId(), Abil_GetLevel(the triggering unit, GetSpellAbilityId()))) times
    // (3).
    set l_tempInteger=(BlzGetAbilityManaCost(GetSpellAbilityId(),Abil_GetLevel(GetTriggerUnit(),GetSpellAbilityId()))*3)
    if(Trig_Wave_Fist_IsHero())then
        // (l_tempInteger) plus ((Strength of the triggering unit) times (8)).
        set l_tempInteger=(l_tempInteger+(GetHeroStatBJ(bj_HEROSTAT_STR,GetTriggerUnit(),true)*8))
    endif
    set udg_TempBoolean=Unit_HasNoEquipment(GetTriggerUnit())
    if(Trig_Wave_Fist_IsCritical())then
        if(Trig_Wave_Fist_TargetNotDisabled())then
            // (l_tempInteger) times (2).
            set l_tempInteger=(l_tempInteger*2)
        else
            // (l_tempInteger) times (3).
            set l_tempInteger=(l_tempInteger*3)
        endif
    endif
    if(Trig_Wave_Fist_HasHighProficiency())then
        // ((l_tempInteger) times (5)) divided by (3); drop the remainder.
        set l_tempInteger=((l_tempInteger*5)/ 3)
    endif
    // Udg_TempInteger treated as a decimal-capable number.
    call Trig_Wave_Fist_Knockback(GetTriggerUnit(),GetSpellTargetUnit(),.1,.5,null,true,I2R(l_tempInteger))
    set udg_IsPhysicalAttack=true
    call UnitDamageTarget(GetTriggerUnit(),GetSpellTargetUnit(),l_tempInteger,true,true,ATTACK_TYPE_SIEGE,DAMAGE_TYPE_NORMAL,null)
endfunction

// World Editor calls InitTrig_Wave automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Wave (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Wave takes nothing returns nothing
endfunction

function Register_Wave_Fist takes nothing returns nothing
    set gg_trg_Wave_Fist=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Wave_Fist,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Wave_Fist,Condition(function Trig_Wave_Fist_Conditions))
    call TriggerAddAction(gg_trg_Wave_Fist,function Trig_Wave_Fist_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Wave takes nothing returns nothing
    call Register_Wave_Fist()
endfunction

endlibrary
