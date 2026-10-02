library TGayaSupport requires TPlayerPart01, TText
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Gaya_BreakStun=null
    trigger gg_trg_Gaya_ManaTransfer=null
    trigger gg_trg_Gaya_MegaHeal=null
endglobals

function Trig_Gaya_BreakStun_Conditions takes nothing returns boolean
    return GetSpellAbilityId()=='A0B4' // 'A0B4': ability "Break Stun"
endfunction

function Trig_Gaya_BreakStun_Actions takes nothing returns nothing
    local player owningPlayer=GetOwningPlayer(GetTriggerUnit())
    local unit u=Player_GetHero(owningPlayer)
    call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Undead\\DevourMagic\\DevourMagicBirthMissile.mdl",u,"overhead"))
    call UnitRemoveAbility(u,'BPSE') // 'BPSE': buff tooltip "Stunned"
    call UnitRemoveAbility(u,'B08I') // 'B08I': buff tooltip "Stunned"
    call UnitRemoveAbility(u,'B00L') // 'B00L': buff tooltip "Freeze"
    call UnitRemoveAbility(u,'B08E') // 'B08E': buff tooltip "Daze"
    call UnitRemoveAbility(u,'B03A') // 'B03A': buff tooltip "Sleep"
    call UnitRemoveAbility(u,'B03B') // 'B03B': buff "Sleep (Pause)"
    call UnitRemoveAbility(u,'B03C') // 'B03C': buff "Sleep (Stunned)"
    set u=null
    set owningPlayer=null
endfunction

function Trig_Gaya_ManaTransfer_Conditions takes nothing returns boolean
    return GetSpellAbilityId()=='A02K' // 'A02K': ability "Mana Transfer"
endfunction

function Trig_Gaya_ManaTransfer_Actions takes nothing returns nothing
    local unit us=GetTriggerUnit()
    local player owningPlayer=GetOwningPlayer(us)
    local unit uh=Player_GetHero(owningPlayer)
    local integer abilityLevel=GetUnitAbilityLevel(us,GetSpellAbilityId())
    // Starting value for currentMana:
    // ((abilityLevel) plus (1)) times (50).
    local integer currentMana=((abilityLevel+1)*50)
    call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Items\\AIma\\AImaTarget.mdl",uh,"origin"))
    // (current mana of uh) plus (currentMana).
    call SetUnitState(uh,UNIT_STATE_MANA,GetUnitState(uh,UNIT_STATE_MANA)+currentMana)
    // L_mana treated as a decimal-capable number.
    call Text_FloatingDamage(uh,true,0,I2R(currentMana),true,0)
    set us=null
    set uh=null
    set owningPlayer=null
endfunction

function Trig_Gaya_MegaHeal_Conditions takes nothing returns boolean
    return GetSpellAbilityId()=='A02L' // 'A02L': ability "Mega Heal"
endfunction

function Trig_Gaya_MegaHeal_Actions takes nothing returns nothing
    local unit us=GetTriggerUnit()
    local player owningPlayer=GetOwningPlayer(us)
    local unit uh=Player_GetHero(owningPlayer)
    local integer l_heroLvl=GetHeroLevel(us)
    local integer abilityLevel=GetUnitAbilityLevel(us,GetSpellAbilityId())
    // Starting value for l_heal:
    // Result 1: (l_heroLvl) plus (26).
    // Result 2: (result 1) times (abilityLevel).
    // Result 3: (result 2) times (50).
    // Result 4: a random decimal number between 15 and 16.
    // Result 5: (result 4) divided by (16).
    // Result 6: (result 3) times (result 5).
    local real l_heal=((l_heroLvl+26)*abilityLevel*50*(GetRandomReal(15.,16.)/ 16.))
    call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Human\\HolyBolt\\HolyBoltSpecialArt.mdl",uh,"origin"))
    // (current health of uh) plus (l_heal).
    call SetUnitState(uh,UNIT_STATE_LIFE,GetUnitState(uh,UNIT_STATE_LIFE)+l_heal)
    call Text_FloatingDamage(uh,true,0,l_heal,false,0)
    set us=null
    set uh=null
    set owningPlayer=null
endfunction

function InitTrig_Gaya_Support takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Gaya (module Gaya),
// which keeps the original registration order.

function Register_Gaya_BreakStun takes nothing returns nothing
    set gg_trg_Gaya_BreakStun=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Gaya_BreakStun,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Gaya_BreakStun,Condition(function Trig_Gaya_BreakStun_Conditions))
    call TriggerAddAction(gg_trg_Gaya_BreakStun,function Trig_Gaya_BreakStun_Actions)
endfunction

function Register_Gaya_ManaTransfer takes nothing returns nothing
    set gg_trg_Gaya_ManaTransfer=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Gaya_ManaTransfer,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Gaya_ManaTransfer,Condition(function Trig_Gaya_ManaTransfer_Conditions))
    call TriggerAddAction(gg_trg_Gaya_ManaTransfer,function Trig_Gaya_ManaTransfer_Actions)
endfunction

function Register_Gaya_MegaHeal takes nothing returns nothing
    set gg_trg_Gaya_MegaHeal=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Gaya_MegaHeal,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Gaya_MegaHeal,Condition(function Trig_Gaya_MegaHeal_Conditions))
    call TriggerAddAction(gg_trg_Gaya_MegaHeal,function Trig_Gaya_MegaHeal_Actions)
endfunction

endlibrary
