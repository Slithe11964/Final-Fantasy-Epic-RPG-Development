library TSpellHolyBlast requires TAbil, TCombatFormulas, TMissile, TProf
function Trig_Spell_HolyBlast_MissileCreate takes unit c,string l_missileFx,string l_trailFx,unit t,real rd returns integer
    local integer d=Missile_Create(rd)
    local real a
    set udg_MissileCaster[d]=c
    set udg_MissileTarget[d]=t
    set udg_MissileX[d]=GetUnitX(c)
    set udg_MissileY[d]=GetUnitY(c)
    set a=Atan2(GetUnitY(udg_MissileTarget[d])-udg_MissileY[d],GetUnitX(udg_MissileTarget[d])-udg_MissileX[d])
    set gg_unit_h020_0269[d]=CreateUnit(GetOwningPlayer(udg_MissileCaster[d]),'h020',udg_MissileX[d],udg_MissileY[d],a*bj_RADTODEG) // 'h020': unit "Dummy Missile"
    call SetUnitX(gg_unit_h020_0269[d],udg_MissileX[d])
    call SetUnitY(gg_unit_h020_0269[d],udg_MissileY[d])
    set udg_MissileModelEffect[d]=AddSpecialEffectTarget(l_missileFx,gg_unit_h020_0269[d],"chest")
    set udg_MissileTrailEffect[d]=AddSpecialEffectTarget(l_trailFx,gg_unit_h020_0269[d],"chest")
    // The horizontal direction share for angle (a) in radians.
    set udg_MissileCosA[d]=Cos(a)
    // The vertical direction share for angle (a) in radians.
    set udg_MissileSinA[d]=Sin(a)
    call GroupAddUnit(udg_MissileHitGroup[d],c)
    call GroupAddUnit(udg_MissileHitGroup[d],t)
    call Missile_Register(d)
    return d
endfunction

function Trig_Spell_HolyBlast_MissileLaunchDamage takes unit c,string l_missileFx,unit t,real rd,real s,real l_aoe,real l_splashDmg,real damageAmount,boolean l_stopOnImpact,integer l_element,attacktype l_atkType,boolean l_isSpellDamage returns nothing
    local integer d=Trig_Spell_HolyBlast_MissileCreate(c,l_missileFx,"",t,rd)
    set udg_MissileSpeed[d]=s
    set udg_MissileRange[d]=$F423F // $F423F = 999999
    set udg_MissileAoE[d]=l_aoe
    set udg_MissileTravelDamage[d]=l_splashDmg
    set udg_MissileImpactDamage[d]=damageAmount
    set udg_MissileHitOnce[d]=l_stopOnImpact
    set udg_MissileFalloff[d]=false
    set udg_MissileHoming[d]=true
    set udg_MissileElement[d]=l_element
    set udg_MissileAttackType[d]=l_atkType
    set udg_MissileIsMagic[d]=l_atkType==ATTACK_TYPE_NORMAL
    set udg_MissileTrueDamage[d]=l_isSpellDamage
endfunction

function Trig_Spell_HolyBlast_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A039' or GetSpellAbilityId()=='A0UF') // 'A039': ability "Holy Blast"; 'A0UF': ability "Holy Blast"
endfunction

function Trig_Spell_HolyBlast_Actions takes nothing returns nothing
    local unit triggeringUnit=GetTriggerUnit()
    local unit spellTarget=GetSpellTargetUnit()
    local integer manaCost=BlzGetAbilityManaCost(GetSpellAbilityId(),Abil_GetLevel(triggeringUnit,GetSpellAbilityId()))
    local real r=Trig_Spell_HolyBlast_DamageFormula(manaCost,GetHeroInt(triggeringUnit,true),Prof_StaffPowerAlt(triggeringUnit))
    call Trig_Spell_HolyBlast_MissileLaunchDamage(triggeringUnit,"Abilities\\Weapons\\RedDragonBreath\\RedDragonMissile.mdl",spellTarget,.0,20.,256.,r*.66,r,true,0,ATTACK_TYPE_NORMAL,true)
    set triggeringUnit=null
    set spellTarget=null
endfunction

// Owns event registration, filters, and preloads for Spell_HolyBlast.
// Called once at startup by Startup_LegacySpellTriggers (MapBootstrap).
function RegisterLegacy_Spell_HolyBlast takes nothing returns nothing
    local trigger eventTrigger
    local integer setupIndex
    set eventTrigger=CreateTrigger()
    set setupIndex=0
    loop
        exitwhen setupIndex==bj_MAX_PLAYER_SLOTS
        call TriggerRegisterPlayerUnitEvent(eventTrigger,Player(setupIndex),EVENT_PLAYER_UNIT_SPELL_EFFECT,null)
        set setupIndex=setupIndex+1
    endloop
    call TriggerAddCondition(eventTrigger,Condition(function Trig_Spell_HolyBlast_Conditions))
    call TriggerAddAction(eventTrigger,function Trig_Spell_HolyBlast_Actions)
    call Preload("Abilities\\Weapons\\RedDragonBreath\\RedDragonMissile.mdl")
endfunction

function InitTrig_Spell_HolyBlast takes nothing returns nothing
endfunction

endlibrary
