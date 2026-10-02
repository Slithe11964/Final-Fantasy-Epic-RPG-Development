library TArmor requires TAbil, TPlayerPart01, TProf
function Trig_Armor_Breaker_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A0P7') // 'A0P7': ability "Armor Breaker"
endfunction

function Trig_Armor_Breaker_MasteryCheck takes nothing returns nothing
    local timer expiredTimer=GetExpiredTimer()
    local unit u
    local player p
    local integer i=0
    loop
        exitwhen i>7
        if(expiredTimer==udg_ArmorBreakerTimer[i])then
            set p=Player(i)
            set u=Player_GetHero(p)
        endif
        set i=i+1
    endloop
    if(udg_DamageTally[GetPlayerId(p)]>=200000. and GetUnitTypeId(u)=='H003' and GetUnitAbilityLevel(u,'A02F')==3 and not IsPlayerInForce(p,udg_JobMasterForce[1]))then // 'H003': unit "Knight"; 'A02F': ability "Mastery"
        call ForceAddPlayer(udg_JobMasterForce[1],p)
        call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Levelup\\LevelupCaster.mdl",u,"origin"))
    endif
    set udg_DamageTally[GetPlayerId(p)]=-1.
    set u=null
    set p=null
    set expiredTimer=null
endfunction

function Trig_Armor_Breaker_RestoreArmor takes nothing returns nothing
    local timer expiredTimer=GetExpiredTimer()
    local unit targetUnit
    local real armorRemoved
    set targetUnit=LoadUnitHandle(udg_RunicHash,GetHandleId(expiredTimer),0)
    set armorRemoved=LoadReal(udg_RunicHash,GetHandleId(expiredTimer),1)
    // Add back exactly the armor this cast removed, rather than resetting all armor changes.
    call BlzSetUnitArmor(targetUnit,(BlzGetUnitArmor(targetUnit)+armorRemoved))
    call FlushChildHashtable(udg_RunicHash,GetHandleId(expiredTimer))
    call DestroyTimer(expiredTimer)
    set targetUnit=null
    set expiredTimer=null
endfunction

function Trig_Armor_Breaker_Actions takes nothing returns nothing
    local timer effectTimer=CreateTimer()
    local integer duration
    local unit caster=GetTriggerUnit()
    local unit targetUnit=GetSpellTargetUnit()
    local unit l_dummy
    local integer abilityLevel=GetUnitAbilityLevel(caster,'A0P7') // 'A0P7': ability "Armor Breaker"
    local real damageAmount
    local real l_armor
    local real armorRemoved
    local player owningPlayer=GetOwningPlayer(caster)
    set l_armor=BlzGetUnitArmor(targetUnit)
    if IsUnitType(targetUnit,UNIT_TYPE_HERO)then
        // Against heroes, remove 20% of their current armor plus 2 more armor points.
        set armorRemoved=(l_armor*.2)+2
    elseif IsUnitType(targetUnit,UNIT_TYPE_RESISTANT)then
        // Against resistant units, remove 25% of current armor plus 3 points.
        set armorRemoved=(l_armor*.25)+3
    else
        // Against other units, remove 30% of current armor plus 4 points.
        set armorRemoved=(l_armor*.3)+4
    endif
    if(abilityLevel>=$B)then // $B = 11
        set armorRemoved=armorRemoved+1
    endif
    // Limit the armor removed to the amount currently available. This case also applies a disable effect.
    if(armorRemoved>l_armor)then
        set armorRemoved=l_armor
        set l_dummy=CreateUnit(owningPlayer,'h02S',GetUnitX(targetUnit),GetUnitY(targetUnit),.0) // 'h02S': unit "Simple Casting Dummy"
        call ShowUnit(l_dummy,false)
        call UnitApplyTimedLife(l_dummy,'BTLF',1.) // 'BTLF': object name not found in map data
        if(IsUnitInGroup(targetUnit,udg_BossGroup))then
            call UnitAddAbility(l_dummy,'A1BW') // 'A1BW': ability "Daze"
            call IssueTargetOrderById(l_dummy,$D00DD,targetUnit) // $D00DD = 852189
        else
            call UnitAddAbility(l_dummy,'A18J') // 'A18J': ability "Knockdown Stun"
            call IssueTargetOrderById(l_dummy,$D011C,targetUnit) // $D011C = 852252
        endif
        set l_dummy=null
        if(GetUnitTypeId(caster)=='H003' and GetUnitAbilityLevel(caster,'A02F')==3 and not IsPlayerInForce(owningPlayer,udg_JobMasterForce[1]))then // 'H003': unit "Knight"; 'A02F': ability "Mastery"
            set udg_DamageTally[GetPlayerId(owningPlayer)]=1.
            call TimerStart(udg_ArmorBreakerTimer[GetPlayerId(owningPlayer)],4.,false,function Trig_Armor_Breaker_MasteryCheck)
        endif
    endif
    // The debuff lasts 10 seconds plus 5 seconds per ability level; the next check can add 10 more.
    set duration=((abilityLevel*5)+$A) // $A = 10
    if(GetUnitAbilityLevel(caster,'A0P7')>=$B)then // 'A0P7': ability "Armor Breaker"; $B = 11
        // Increase duration by 10.
        set duration=(duration+$A) // $A = 10
    endif
    // (l_armor) minus (armorRemoved).
    call BlzSetUnitArmor(targetUnit,(l_armor-armorRemoved))
    call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Orc\\WarStomp\\WarStompCaster.mdl",targetUnit,"origin"))
    call DestroyEffect(AddSpecialEffectTarget("Objects\\Spawnmodels\\Human\\FragmentationShards\\FragBoomSpawn.mdl",targetUnit,"origin"))
    call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Orc\\Disenchant\\DisenchantSpecialArt.mdl",targetUnit,"chest"))
    call SaveUnitHandle(udg_RunicHash,GetHandleId(effectTimer),0,targetUnit)
    call SaveReal(udg_RunicHash,GetHandleId(effectTimer),1,armorRemoved)
    call TimerStart(effectTimer,duration,false,function Trig_Armor_Breaker_RestoreArmor)
    // Damage starts at 5 times mana cost plus 3 times Strength.
    // Sword proficiency adds 10% of that base per level.
    set damageAmount=I2R((BlzGetAbilityManaCost(GetSpellAbilityId(),Abil_GetLevel(caster,GetSpellAbilityId()))*5)+(GetHeroStr(caster,true)*3))*(.1*($A+Prof_GetLevel(caster,'R001'))) // $A = 10; 'R001': upgrade "Sword"
    set udg_IsPhysicalAttack=true
    call UnitDamageTarget(caster,targetUnit,damageAmount,true,false,ATTACK_TYPE_MELEE,DAMAGE_TYPE_NORMAL,WEAPON_TYPE_METAL_MEDIUM_BASH)
    set caster=null
    set targetUnit=null
    set effectTimer=null
    set owningPlayer=null
endfunction

// World Editor calls InitTrig_Armor automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Armor (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Armor takes nothing returns nothing
endfunction

function Register_Armor_Breaker takes nothing returns nothing
    set gg_trg_Armor_Breaker=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Armor_Breaker,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Armor_Breaker,Condition(function Trig_Armor_Breaker_Conditions))
    call TriggerAddAction(gg_trg_Armor_Breaker,function Trig_Armor_Breaker_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Armor takes nothing returns nothing
    call Register_Armor_Breaker()
endfunction

endlibrary
