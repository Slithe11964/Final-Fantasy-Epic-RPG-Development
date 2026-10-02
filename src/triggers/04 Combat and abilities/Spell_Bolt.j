library TSpellBolt requires TAbil, TCombatFormulas, TMissile, TProf
globals
    // Variables only this module uses.
    constant integer udg_BoltRingCount=$A // $A = 10
endglobals

function Trig_Spell_Bolt_DamageWithElement takes unit l_source,real damageAmount,integer l_element,unit targetUnit,attacktype l_atkType,damagetype l_dmgType returns nothing
    set udg_DamageElement=l_element
    call UnitDamageTarget(l_source,targetUnit,damageAmount,true,false,l_atkType,l_dmgType,null)
endfunction

function Trig_Spell_Bolt_Conditions takes nothing returns boolean
    local integer spellAbilityId=GetSpellAbilityId()
    return(spellAbilityId=='A00O' or spellAbilityId=='A0TO' or spellAbilityId=='A07O' or spellAbilityId=='A0JD' or spellAbilityId=='A0U8' or spellAbilityId=='A142' or spellAbilityId=='A0ZQ' or spellAbilityId=='A19R') // 'A00O': ability "Bolt"; 'A0TO': ability "Bolt"; 'A07O': ability "Bolt"; 'A0JD': ability "Elementa"; 'A0U8': ability "Elementa"; 'A142': ability "Elementa"; 'A0ZQ': ability "!Thunder Rush"; 'A19R': ability "Bolt"
endfunction

function Trig_Spell_Bolt_Actions takes nothing returns nothing
    local unit triggeringUnit=GetTriggerUnit()
    local unit spellTarget=GetSpellTargetUnit()
    local integer manaCost=BlzGetAbilityManaCost(GetSpellAbilityId(),Abil_GetLevel(triggeringUnit,GetSpellAbilityId()))
    local real r
    local real x=GetUnitX(spellTarget)
    local real y=GetUnitY(spellTarget)
    local real l_bx
    local real l_by
    local integer l_bolts=udg_BoltRingCount
    local real l_splitRatio=.3
    // Starting value for a:
    // (360) divided by (l_bolts); drop the remainder.
    local real a=360/ l_bolts
    local real l_ang
    local integer i=1
    local unit u=CreateUnit(GetOwningPlayer(triggeringUnit),'h01B',x,y,.0) // 'h01B': unit "Proxy Dummy"
    if((GetSpellAbilityId()=='A0JD')or(GetSpellAbilityId()=='A0U8'))then // 'A0JD': ability "Elementa"; 'A0U8': ability "Elementa"
        // (mana cost) divided by (2); drop the remainder.
        set manaCost=manaCost/ 2
    endif
    set r=Trig_Spell_Bolt_DamageFormula(manaCost,GetHeroInt(triggeringUnit,true),Prof_RodPower(triggeringUnit))
    set udg_TempHandleId=GetHandleIdBJ(u)
    call SaveUnitHandleBJ(triggeringUnit,0,udg_TempHandleId,udg_ProxyDamageHash)
    call SaveIntegerBJ(3,2,udg_TempHandleId,udg_ProxyDamageHash)
    call ShowUnitHide(u)
    call UnitApplyTimedLife(u,'BTLF',3.) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A0M3',u) // 'A0M3': ability "Thunder-elemental Damage"
    call Trig_Spell_Bolt_DamageWithElement(triggeringUnit,r,3,spellTarget,ATTACK_TYPE_NORMAL,DAMAGE_TYPE_MAGIC)
    call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Other\\Monsoon\\MonsoonBoltTarget.mdl",x,y))
    call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Human\\Thunderclap\\ThunderClapCaster.mdl",x,y))
    // (r) times (l_splitRatio).
    set r=r*l_splitRatio
    loop
        exitwhen i>l_bolts
        // (a) times (i).
        set l_ang=a*i
        // (x) plus ((100) times (the horizontal direction share for angle ((l_ang) times (bj_DEGTORAD)) in radians)).
        set l_bx=x+100.*Cos(l_ang*bj_DEGTORAD)
        // (y) plus ((100) times (the vertical direction share for angle ((l_ang) times (bj_DEGTORAD)) in radians)).
        set l_by=y+100.*Sin(l_ang*bj_DEGTORAD)
        call SetUnitX(u,l_bx)
        call SetUnitY(u,l_by)
        call Missile_Launch(u,"Abilities\\Weapons\\FarseerMissile\\FarseerMissile.mdl","Abilities\\Spells\\Human\\Thunderclap\\ThunderClapCaster.mdl",null,l_ang,100.,16.,700.,.0,.0,200.,r,3,ATTACK_TYPE_NORMAL,true)
        set i=i+1
    endloop
    set triggeringUnit=null
    set spellTarget=null
endfunction

// Owns event registration, filters, and preloads for Spell_Bolt.
function RegisterLegacy_Spell_Bolt takes nothing returns nothing
    local trigger eventTrigger
    local integer setupIndex
    set eventTrigger=CreateTrigger()
    set setupIndex=0
    loop
        exitwhen setupIndex==bj_MAX_PLAYER_SLOTS
        call TriggerRegisterPlayerUnitEvent(eventTrigger,Player(setupIndex),EVENT_PLAYER_UNIT_SPELL_EFFECT,null)
        set setupIndex=setupIndex+1
    endloop
    call TriggerAddCondition(eventTrigger,Condition(function Trig_Spell_Bolt_Conditions))
    call TriggerAddAction(eventTrigger,function Trig_Spell_Bolt_Actions)
    call Preload("Abilities\\Spells\\Human\\Thunderclap\\ThunderClapCaster.mdl")
    call Preload("Abilities\\Spells\\Other\\Monsoon\\MonsoonBoltTarget.mdl")
    call Preload("Abilities\\Weapons\\FarseerMissile\\FarseerMissile.mdl")
endfunction

function InitTrig_Spell_Bolt takes nothing returns nothing
endfunction

endlibrary
