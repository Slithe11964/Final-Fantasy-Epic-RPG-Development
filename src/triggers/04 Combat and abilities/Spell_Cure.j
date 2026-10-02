library TSpellCure requires TAbil, TCombatFormulas, TProf, TSpellHolyBlast
function Trig_Spell_Cure_MissileLaunchHeal takes unit c,string l_missileFx,string fx,unit t,real rd,real s,real l_aoe,real l_splashHeal,real l_heal,boolean l_stopOnImpact returns nothing
    local integer d=Trig_Spell_HolyBlast_MissileCreate(c,l_missileFx,"",t,rd)
    set udg_MissileHitEffect[d]=fx
    set udg_MissileSpeed[d]=s
    set udg_MissileRange[d]=$F423F // $F423F = 999999
    set udg_MissileAoE[d]=l_aoe
    set udg_MissileTravelDamage[d]=l_splashHeal
    set udg_MissileIsPure[d]=true
    set udg_MissileIsMagic[d]=true
    set udg_MissileImpactDamage[d]=l_heal
    set udg_MissileHitOnce[d]=l_stopOnImpact
    set udg_MissileFalloff[d]=false
    set udg_MissileHoming[d]=true
    if(GetUnitTypeId(c)=='H005' and GetUnitAbilityLevel(c,'A02F')==3 and not IsPlayerInForce(GetOwningPlayer(c),udg_JobMasterForce[$C]))then // 'H005': unit "Priest"; 'A02F': ability "Mastery"; $C = 12
        // (GetPlayerId(GetOwningPlayer(c))) plus (1).
        set udg_MissileHealCredit[d]=GetPlayerId(GetOwningPlayer(c))+1
        set udg_HealingTotal[GetPlayerId(GetOwningPlayer(c))]=.0
    endif
endfunction

function Trig_Spell_Cure_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A00M' or GetSpellAbilityId()=='A10K') // 'A00M': ability "Cure"; 'A10K': ability "Cure"
endfunction

function Trig_Spell_Cure_Actions takes nothing returns nothing
    local unit triggeringUnit=GetTriggerUnit()
    local unit spellTarget=GetSpellTargetUnit()
    local integer manaCost=BlzGetAbilityManaCost(GetSpellAbilityId(),Abil_GetLevel(triggeringUnit,GetSpellAbilityId()))
    local real r=Trig_Spell_Cure_HealFormula(manaCost,GetHeroInt(triggeringUnit,true),Prof_StaffPower(triggeringUnit))
    // (r) times (0.25).
    call Trig_Spell_Cure_MissileLaunchHeal(triggeringUnit,"Abilities\\Weapons\\WitchDoctorMissile\\WitchDoctorMissile.mdl","Abilities\\Spells\\Human\\Resurrect\\ResurrectTarget.mdl",spellTarget,.0,20.,128.,r*.25,r,true)
    set triggeringUnit=null
    set spellTarget=null
endfunction

// Owns event registration, filters, and preloads for Spell_Cure.
// Called once at startup by Startup_LegacySpellTriggers (MapBootstrap).
function RegisterLegacy_Spell_Cure takes nothing returns nothing
    local trigger eventTrigger
    local integer setupIndex
    set eventTrigger=CreateTrigger()
    set setupIndex=0
    loop
        exitwhen setupIndex==bj_MAX_PLAYER_SLOTS
        call TriggerRegisterPlayerUnitEvent(eventTrigger,Player(setupIndex),EVENT_PLAYER_UNIT_SPELL_EFFECT,null)
        set setupIndex=setupIndex+1
    endloop
    call TriggerAddCondition(eventTrigger,Condition(function Trig_Spell_Cure_Conditions))
    call TriggerAddAction(eventTrigger,function Trig_Spell_Cure_Actions)
    call Preload("Abilities\\Weapons\\WitchDoctorMissile\\WitchDoctorMissile.mdl")
    call Preload("Abilities\\Spells\\Human\\Resurrect\\ResurrectTarget.mdl")
endfunction

function InitTrig_Spell_Cure takes nothing returns nothing
endfunction

endlibrary
