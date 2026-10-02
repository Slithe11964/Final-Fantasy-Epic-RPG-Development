library TNinja requires TAbil, TProf, TWait
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Ninja_Ambush=null
    trigger gg_trg_Ninja_Rage_ClearBuffs=null
    trigger gg_trg_Ninja_Trance=null
endglobals

function Trig_Ninja_Ambush_Conditions takes nothing returns boolean
    return GetSpellAbilityId()=='A156' // 'A156': ability "Ambush"
endfunction

function Trig_Ninja_Ambush_Actions takes nothing returns nothing
    local unit caster=GetTriggerUnit()
    local unit targetUnit=GetSpellTargetUnit()
    local unit l_dummy
    local real l_casterX=GetUnitX(caster)
    local real l_casterY=GetUnitY(caster)
    local real l_targetX=GetUnitX(targetUnit)
    local real l_targetY=GetUnitY(targetUnit)
    local real l_landX
    local real l_landY
    // Starting value for l_dx:
    // (l_targetX) minus (l_casterX).
    local real l_dx=l_targetX-l_casterX
    // Starting value for l_dy:
    // (l_targetY) minus (l_casterY).
    local real l_dy=l_targetY-l_casterY
    // Starting value for distance:
    // The square root of ((the square of (l_dx)) plus (the square of (l_dy))).
    local real distance=SquareRoot(l_dx*l_dx+l_dy*l_dy)
    local real angle
    local real l_facing
    local integer manaCost=BlzGetAbilityManaCost(GetSpellAbilityId(),Abil_GetLevel(caster,GetSpellAbilityId()))
    // Starting value for l_agiBonus:
    // (Agility of caster) times (3).
    local integer l_agiBonus=GetHeroAgi(caster,true)*3
    local integer l_mult
    local real damageAmount
    if distance>420. then
        // The angle in radians from the y gap (l_dy) and x gap (l_dx).
        set angle=Atan2(l_dy,l_dx)
        // (angle) times (bj_RADTODEG).
        set l_facing=angle*bj_RADTODEG
        set l_dummy=CreateUnit(GetOwningPlayer(caster),'h02S',l_targetX,l_targetY,.0) // 'h02S': unit "Simple Casting Dummy"
        call ShowUnit(l_dummy,false)
        call UnitAddAbility(l_dummy,'A157') // 'A157': ability "Ambush Stun"
        call UnitApplyTimedLife(l_dummy,'BTLF',1.) // 'BTLF': object name not found in map data
        call IssueTargetOrderById(l_dummy,$D011C,targetUnit) // $D011C = 852252
        set l_dummy=null
        set l_mult=1
    else
        set l_facing=GetUnitFacing(targetUnit)
        // (l_facing) times (bj_DEGTORAD).
        set angle=l_facing*bj_DEGTORAD
        set l_mult=3
    endif
    call SetUnitFacing(caster,l_facing)
    // (l_targetX) minus ((90) times (the horizontal direction share for angle (angle) in radians)).
    set l_landX=l_targetX-90*Cos(angle)
    // (l_targetY) minus ((90) times (the vertical direction share for angle (angle) in radians)).
    set l_landY=l_targetY-90*Sin(angle)
    call SetUnitX(caster,l_landX)
    call SetUnitY(caster,l_landY)
    // (((mana cost) plus (l_agiBonus)) times (l_mult)) times (((10) plus (Prof_GetLevel(caster, 'R00B'))) times
    // (0.1)).
    set damageAmount=((manaCost+l_agiBonus)*l_mult)*(($A+Prof_GetLevel(caster,'R00B'))*.1) // $A = 10; 'R00B': upgrade "Dagger"
    set udg_IsPhysicalAttack=true
    call UnitDamageTarget(caster,targetUnit,damageAmount,true,false,ATTACK_TYPE_MELEE,DAMAGE_TYPE_NORMAL,WEAPON_TYPE_METAL_LIGHT_SLICE)
    set caster=null
    set targetUnit=null
endfunction

function Trig_Ninja_Rage_ClearBuffs_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A070') // 'A070': ability "Rage"
endfunction

function Trig_Ninja_Rage_ClearBuffs_Actions takes nothing returns nothing
    call UnitRemoveBuffBJ('B00K',GetTriggerUnit()) // 'B00K': buff tooltip "Rage"
    call UnitRemoveBuffBJ('B07P',GetTriggerUnit()) // 'B07P': buff "Enraged"
endfunction

function Trig_Ninja_Trance_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A14N')and(UnitHasBuffBJ(GetTriggerUnit(),'B06M')==false) // 'A14N': ability "!Trance"; 'B06M': buff "Exhaustion"
endfunction

function Trig_Ninja_Trance_LacksImmortal takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0ZR',GetTriggerUnit())<=0) // 'A0ZR': ability "Immortal"
endfunction

function Trig_Ninja_Trance_Actions takes nothing returns nothing
    call StartTimerBJ(udg_NinjaImmortalTimer[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],false,8.)
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateNUnitsAtLocFacingLocBJ(1,'h02S',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,udg_TempPoint) // 'h02S': unit "Simple Casting Dummy"
    call RemoveLocation(udg_TempPoint)
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(1.5,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A14O',GetLastCreatedUnit()) // 'A14O': ability "Trance"
    call IssueTargetOrderBJ(GetLastCreatedUnit(),"bloodlust",GetTriggerUnit())
    if(Trig_Ninja_Trance_LacksImmortal())then
        call UnitAddAbilityBJ('A0ZR',GetTriggerUnit()) // 'A0ZR': ability "Immortal"
        call Wait_Polled(1.)
        call UnitRemoveAbilityBJ('A0ZR',GetTriggerUnit()) // 'A0ZR': ability "Immortal"
    endif
endfunction

// World Editor calls InitTrig_Ninja automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Ninja (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Ninja takes nothing returns nothing
endfunction

function Register_Ninja_Ambush takes nothing returns nothing
    set gg_trg_Ninja_Ambush=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Ninja_Ambush,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Ninja_Ambush,Condition(function Trig_Ninja_Ambush_Conditions))
    call TriggerAddAction(gg_trg_Ninja_Ambush,function Trig_Ninja_Ambush_Actions)
endfunction

function Register_Ninja_Rage_ClearBuffs takes nothing returns nothing
    set gg_trg_Ninja_Rage_ClearBuffs=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Ninja_Rage_ClearBuffs,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Ninja_Rage_ClearBuffs,Condition(function Trig_Ninja_Rage_ClearBuffs_Conditions))
    call TriggerAddAction(gg_trg_Ninja_Rage_ClearBuffs,function Trig_Ninja_Rage_ClearBuffs_Actions)
endfunction

function Register_Ninja_Trance takes nothing returns nothing
    set gg_trg_Ninja_Trance=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Ninja_Trance,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Ninja_Trance,Condition(function Trig_Ninja_Trance_Conditions))
    call TriggerAddAction(gg_trg_Ninja_Trance,function Trig_Ninja_Trance_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Ninja takes nothing returns nothing
    call Register_Ninja_Ambush()
    call Register_Ninja_Rage_ClearBuffs()
    call Register_Ninja_Trance()
endfunction

endlibrary
