library TSamurai requires TAbil, TDamage, TProf
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Samurai_Mineuchi=null
    trigger gg_trg_Samurai_Renzokuken=null
    trigger gg_trg_Samurai_Iainuki=null
endglobals

function Trig_Samurai_Mineuchi_IsMineuchiSpell takes nothing returns boolean
    return(GetSpellAbilityId()=='A02E')or(GetSpellAbilityId()=='A0XR') // 'A02E': ability "Mineuchi"; 'A0XR': ability "Mineuchi"
endfunction

function Trig_Samurai_Mineuchi_Conditions takes nothing returns boolean
    return(Trig_Samurai_Mineuchi_IsMineuchiSpell())
endfunction

function Trig_Samurai_Mineuchi_CasterIsHero takes nothing returns boolean
    return(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Samurai_Mineuchi_Actions takes nothing returns nothing
    local integer l_tempInteger
    local real l_tempReal
    call UnitRemoveBuffBJ('B00F',GetSpellTargetUnit()) // 'B00F': buff "Haste"
    call UnitRemoveBuffBJ('B07F',GetSpellTargetUnit()) // 'B07F': buff "Haste"
    call UnitRemoveBuffBJ('B08T',GetSpellTargetUnit()) // 'B08T': buff "Hastera"
    call UnitRemoveBuffBJ('B007',GetSpellTargetUnit()) // 'B007': buff "Protect"
    call UnitRemoveBuffBJ('B07G',GetSpellTargetUnit()) // 'B07G': buff "Protect"
    call UnitRemoveBuffBJ('B08R',GetSpellTargetUnit()) // 'B08R': buff "Protectra"
    call UnitRemoveBuffBJ('B005',GetSpellTargetUnit()) // 'B005': buff "Shell"
    call UnitRemoveBuffBJ('B07H',GetSpellTargetUnit()) // 'B07H': buff "Shell"
    call UnitRemoveBuffBJ('B08S',GetSpellTargetUnit()) // 'B08S': buff "Shellra"
    set l_tempInteger=(BlzGetAbilityManaCost(GetSpellAbilityId(),Abil_GetLevel(GetTriggerUnit(),GetSpellAbilityId()))*3)
    if(Trig_Samurai_Mineuchi_CasterIsHero())then
        set l_tempInteger=(l_tempInteger+(GetHeroStatBJ(bj_HEROSTAT_STR,GetTriggerUnit(),true)*2))
        set l_tempInteger=(l_tempInteger+(GetHeroStatBJ(bj_HEROSTAT_AGI,GetTriggerUnit(),true)*2))
    endif
    set l_tempReal=.1*($A+Prof_GetLevel(GetTriggerUnit(),'R00A')) // $A = 10; 'R00A': upgrade "Katana"
    set udg_IsPhysicalAttack=true
    call UnitDamageTargetBJ(GetTriggerUnit(),GetSpellTargetUnit(),(I2R(l_tempInteger)*l_tempReal),ATTACK_TYPE_MELEE,DAMAGE_TYPE_NORMAL)
endfunction

function Trig_Samurai_Renzokuken_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A16J') // 'A16J': ability "Renzokuken"
endfunction

function Trig_Samurai_Renzokuken_MissingBonusStrikes takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0IY',GetTriggerUnit())<=0) // 'A0IY': ability "Renzokuken"
endfunction

function Trig_Samurai_Renzokuken_AbilityAtMaxLevel takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A16J',GetTriggerUnit())>=$B) // 'A16J': ability "Renzokuken"; $B = 11
endfunction

function Trig_Samurai_Renzokuken_AtFullLife takes nothing returns boolean
    return(GetUnitLifePercent(GetTriggerUnit())>=100.)
endfunction

function Trig_Samurai_Renzokuken_Actions takes nothing returns nothing
    if(Trig_Samurai_Renzokuken_MissingBonusStrikes())then
        call UnitAddAbilityBJ('A0IY',GetTriggerUnit()) // 'A0IY': ability "Renzokuken"
    endif
    if(Trig_Samurai_Renzokuken_AtFullLife())then
        call SetUnitAbilityLevelSwapped('A0IY',GetTriggerUnit(),1) // 'A0IY': ability "Renzokuken"
    else
        if(Trig_Samurai_Renzokuken_AbilityAtMaxLevel())then
            // Result 1: (maximum health of the triggering unit) minus (current health of the triggering unit).
            // Result 2: (result 1) divided by (maximum health of the triggering unit).
            // Result 3: (GetUnitAbilityLevelSwapped(GetSpellAbilityId(), the triggering unit)) plus (1).
            // Result 4: result 3 treated as a decimal-capable number.
            // Result 5: (result 2) times (result 4).
            // Result 6: (result 5) with its decimal part removed.
            // Result 7: (3) plus (result 6).
            call SetUnitAbilityLevelSwapped('A0IY',GetTriggerUnit(),(3+R2I((((GetUnitStateSwap(UNIT_STATE_MAX_LIFE,GetTriggerUnit())-GetUnitStateSwap(UNIT_STATE_LIFE,GetTriggerUnit()))/ GetUnitStateSwap(UNIT_STATE_MAX_LIFE,GetTriggerUnit()))*I2R((GetUnitAbilityLevelSwapped(GetSpellAbilityId(),GetTriggerUnit())+1)))))) // 'A0IY': ability "Renzokuken"
        else
            // Result 1: (maximum health of the triggering unit) minus (current health of the triggering unit).
            // Result 2: (result 1) divided by (maximum health of the triggering unit).
            // Result 3: (GetUnitAbilityLevelSwapped(GetSpellAbilityId(), the triggering unit)) plus (1).
            // Result 4: result 3 treated as a decimal-capable number.
            // Result 5: (result 2) times (result 4).
            // Result 6: (result 5) with its decimal part removed.
            // Result 7: (2) plus (result 6).
            call SetUnitAbilityLevelSwapped('A0IY',GetTriggerUnit(),(2+R2I((((GetUnitStateSwap(UNIT_STATE_MAX_LIFE,GetTriggerUnit())-GetUnitStateSwap(UNIT_STATE_LIFE,GetTriggerUnit()))/ GetUnitStateSwap(UNIT_STATE_MAX_LIFE,GetTriggerUnit()))*I2R((GetUnitAbilityLevelSwapped(GetSpellAbilityId(),GetTriggerUnit())+1)))))) // 'A0IY': ability "Renzokuken"
        endif
    endif
endfunction

function Trig_Samurai_Iainuki_Conditions takes nothing returns boolean
    return GetSpellAbilityId()=='A18P' // 'A18P': ability "!Iainuki"
endfunction

function Trig_Samurai_Iainuki_ResetComboState takes nothing returns nothing
    if(udg_ComboAwarded and udg_ComboUnit!=null)then
        call BlzEndUnitAbilityCooldown(udg_ComboUnit,'A18P') // 'A18P': ability "!Iainuki"
    endif
    set udg_ComboUnit=null
    set udg_ComboAwarded=false
    set udg_ComboCount=0
endfunction

function Trig_Samurai_Iainuki_Actions takes nothing returns nothing
    local unit caster=GetTriggerUnit()
    local unit targetUnit=GetSpellTargetUnit()
    local player owner
    local real l_casterX=GetUnitX(caster)
    local real l_casterY=GetUnitY(caster)
    local real l_targetX=GetUnitX(targetUnit)
    local real l_targetY=GetUnitY(targetUnit)
    local real l_landX
    local real l_landY
    local real dx=l_targetX-l_casterX
    local real dy=l_targetY-l_casterY
    // The angle in radians from the y gap (dy) and x gap (dx).
    local real angle=Atan2(dy,dx)
    local real l_facing=angle*bj_RADTODEG
    local integer manaCost=BlzGetAbilityManaCost(GetSpellAbilityId(),Abil_GetLevel(caster,GetSpellAbilityId()))*$A // $A = 10
    local integer l_strBonus=GetHeroStr(caster,true)*8
    local integer l_agiBonus=GetHeroAgi(caster,true)*8
    local integer l_comboCount=0
    local real l_comboMult=1.
    local real damageAmount
    call SetUnitFacing(caster,l_facing)
    set l_landX=l_targetX+'d'*Cos(angle)
    set l_landY=l_targetY+'d'*Sin(angle)
    call SetUnitX(caster,l_landX)
    call SetUnitY(caster,l_landY)
    if(GetUnitAbilityLevel(caster,'A137')>0)then // 'A137': ability "Combo Strike"
        set l_comboCount=LoadInteger(udg_ComboHash,GetHandleId(caster),5)
        set l_comboMult=1.+(l_comboCount*.1)
        if(GetUnitAbilityLevel(caster,'A1DG')<=0)then // 'A1DG': ability "Combo Dragon"
            call Trig_Damage_Engine_ComboEnd(caster)
        else
            call UnitRemoveAbility(caster,'A137') // 'A137': ability "Combo Strike"
            call FlushChildHashtable(udg_ComboHash,GetHandleId(caster))
        endif
    endif
    set udg_ComboUnit=caster
    set udg_ComboAwarded=false
    set udg_ComboCount=l_comboCount
    call TimerStart(udg_ComboTimer,.01,false,function Trig_Samurai_Iainuki_ResetComboState)
    // Result 1: (mana cost) plus (l_strBonus).
    // Result 2: (result 1) plus (l_agiBonus).
    // Result 3: (10) plus (Prof_GetLevel(caster, 'R00A')).
    // Result 4: (result 3) times (0.1).
    // Result 5: (result 2) times (result 4).
    // Result 6: (result 5) times (l_comboMult).
    set damageAmount=(manaCost+l_strBonus+l_agiBonus)*(($A+Prof_GetLevel(caster,'R00A'))*.1)*l_comboMult // $A = 10; 'R00A': upgrade "Katana"
    set udg_IsPhysicalAttack=true
    call UnitDamageTarget(caster,targetUnit,damageAmount,true,false,ATTACK_TYPE_MELEE,DAMAGE_TYPE_NORMAL,WEAPON_TYPE_METAL_HEAVY_SLICE)
    set caster=null
    set targetUnit=null
endfunction

// World Editor calls InitTrig_Samurai automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Samurai (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Samurai takes nothing returns nothing
endfunction

function Register_Samurai_Mineuchi takes nothing returns nothing
    set gg_trg_Samurai_Mineuchi=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Samurai_Mineuchi,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Samurai_Mineuchi,Condition(function Trig_Samurai_Mineuchi_Conditions))
    call TriggerAddAction(gg_trg_Samurai_Mineuchi,function Trig_Samurai_Mineuchi_Actions)
endfunction

function Register_Samurai_Renzokuken takes nothing returns nothing
    set gg_trg_Samurai_Renzokuken=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Samurai_Renzokuken,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Samurai_Renzokuken,Condition(function Trig_Samurai_Renzokuken_Conditions))
    call TriggerAddAction(gg_trg_Samurai_Renzokuken,function Trig_Samurai_Renzokuken_Actions)
endfunction

function Register_Samurai_Iainuki takes nothing returns nothing
    set gg_trg_Samurai_Iainuki=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Samurai_Iainuki,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Samurai_Iainuki,Condition(function Trig_Samurai_Iainuki_Conditions))
    call TriggerAddAction(gg_trg_Samurai_Iainuki,function Trig_Samurai_Iainuki_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Samurai takes nothing returns nothing
    call Register_Samurai_Mineuchi()
    call Register_Samurai_Renzokuken()
    call Register_Samurai_Iainuki()
endfunction

endlibrary
