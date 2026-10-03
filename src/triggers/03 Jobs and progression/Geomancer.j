library TGeomancer requires TAbil, TElement, TGroup, TLoc, TProf
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Geomancer_Enchant_Cycle=null
    trigger gg_trg_Geomancer_Enchant_Apply=null
    trigger gg_trg_Geomancer_Enchant_ClearBuffs=null
    trigger gg_trg_Geomancer_GayaRage=null
    // Variables only this module uses.
    unit udg_EnchantCycleCaster=null
endglobals

function Trig_Geomancer_Enchant_Cycle_HasEnchantAbility takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0S8',GetTriggerUnit())>0)or(GetUnitAbilityLevelSwapped('A0S9',GetTriggerUnit())>0)or(GetUnitAbilityLevelSwapped('A0SB',GetTriggerUnit())>0)or(GetUnitAbilityLevelSwapped('A0SC',GetTriggerUnit())>0)or(GetUnitAbilityLevelSwapped('A0SD',GetTriggerUnit())>0)or(GetUnitAbilityLevelSwapped('A0SE',GetTriggerUnit())>0) // 'A0S8': ability "Enfire"; 'A0S9': ability "Enfrost"; 'A0SB': ability "Enthunder"; 'A0SC': ability "Enwater"; 'A0SD': ability "Enstone"; 'A0SE': ability "Enaero"
endfunction

function Trig_Geomancer_Enchant_Cycle_Conditions takes nothing returns boolean
    return(GetIssuedOrderIdBJ()==$D00DF)and(Trig_Geomancer_Enchant_Cycle_HasEnchantAbility())and(udg_SubSkillSlot[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]!=26) // $D00DF = 852191
endfunction

function Trig_Geomancer_Enchant_Cycle_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    set udg_EnchantCycleCaster=GetTriggerUnit()
    call StartTimerBJ(udg_EnchantCycleTimer,false,.0)
endfunction

function Trig_Geomancer_Enchant_Apply_Conditions takes nothing returns boolean
    return(udg_EnchantCycleCaster!=null)
endfunction

function Trig_Geomancer_Enchant_Apply_HasNoVariant takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0SI',udg_EnchantCycleCaster)<=0) // 'A0SI': ability "Enchantment Variant"
endfunction

function Trig_Geomancer_Enchant_Apply_VariantAtMax takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0SI',udg_EnchantCycleCaster)>=6) // 'A0SI': ability "Enchantment Variant"
endfunction

function Trig_Geomancer_Enchant_Apply_VariantIsFirst takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0SI',udg_EnchantCycleCaster)==1) // 'A0SI': ability "Enchantment Variant"
endfunction

function Trig_Geomancer_Enchant_Apply_Actions takes nothing returns nothing
    call IssueImmediateOrderBJ(udg_EnchantCycleCaster,"curseoff")
    if(Trig_Geomancer_Enchant_Apply_HasNoVariant())then
        call UnitAddAbilityBJ('A0SI',udg_EnchantCycleCaster) // 'A0SI': ability "Enchantment Variant"
    endif
    if(Trig_Geomancer_Enchant_Apply_VariantAtMax())then
        call SetUnitAbilityLevelSwapped('A0SI',udg_EnchantCycleCaster,1) // 'A0SI': ability "Enchantment Variant"
    else
        call IncUnitAbilityLevelSwapped('A0SI',udg_EnchantCycleCaster) // 'A0SI': ability "Enchantment Variant"
    endif
    if(Trig_Geomancer_Enchant_Apply_VariantIsFirst())then
        set udg_TempInteger=Abil_GetLevel(udg_EnchantCycleCaster,'A0S8') // 'A0S8': ability "Enfire"
    else
        set udg_TempInteger=Abil_GetLevel(udg_EnchantCycleCaster,udg_EnchantAbility[GetUnitAbilityLevel(udg_EnchantCycleCaster,'A0SI')]) // 'A0SI': ability "Enchantment Variant"
    endif
    call BlzSetAbilityTooltip('A0S8',BlzGetAbilityTooltip(udg_EnchantAbility[GetUnitAbilityLevelSwapped('A0SI',udg_EnchantCycleCaster)],udg_TempInteger),udg_TempInteger) // 'A0S8': ability "Enfire"; 'A0SI': ability "Enchantment Variant"
    call BlzSetAbilityExtendedTooltip('A0S8',BlzGetAbilityExtendedTooltip(udg_EnchantAbility[GetUnitAbilityLevelSwapped('A0SI',udg_EnchantCycleCaster)],udg_TempInteger),udg_TempInteger) // 'A0S8': ability "Enfire"; 'A0SI': ability "Enchantment Variant"
    call BlzSetAbilityIcon('A0S8',BlzGetAbilityIcon(udg_EnchantAbility[GetUnitAbilityLevelSwapped('A0SI',udg_EnchantCycleCaster)])) // 'A0S8': ability "Enfire"; 'A0SI': ability "Enchantment Variant"
    set udg_EnchantCycleCaster=null
    call EnableTrigger(gg_trg_Geomancer_Enchant_Cycle)
endfunction

function Trig_Geomancer_Enchant_ClearBuffs_IsEnchantSpell takes nothing returns boolean
    return(GetSpellAbilityId()=='A1DS')or(GetSpellAbilityId()=='A0S8')or(GetSpellAbilityId()=='A0S9')or(GetSpellAbilityId()=='A0SB')or(GetSpellAbilityId()=='A0SC')or(GetSpellAbilityId()=='A0SD')or(GetSpellAbilityId()=='A0SE') // 'A1DS': ability "Enfire"; 'A0S8': ability "Enfire"; 'A0S9': ability "Enfrost"; 'A0SB': ability "Enthunder"; 'A0SC': ability "Enwater"; 'A0SD': ability "Enstone"; 'A0SE': ability "Enaero"
endfunction

function Trig_Geomancer_Enchant_ClearBuffs_Conditions takes nothing returns boolean
    return(Trig_Geomancer_Enchant_ClearBuffs_IsEnchantSpell())
endfunction

function Trig_Geomancer_Enchant_ClearBuffs_Actions takes nothing returns nothing
    call UnitRemoveBuffBJ('B05C',GetSpellTargetUnit()) // 'B05C': buff "Enfire"
    call UnitRemoveBuffBJ('B05D',GetSpellTargetUnit()) // 'B05D': buff "Enfrost"
    call UnitRemoveBuffBJ('B05E',GetSpellTargetUnit()) // 'B05E': buff "Enthunder"
    call UnitRemoveBuffBJ('B05F',GetSpellTargetUnit()) // 'B05F': buff "Enwater"
    call UnitRemoveBuffBJ('B05G',GetSpellTargetUnit()) // 'B05G': buff "Enstone"
    call UnitRemoveBuffBJ('B05H',GetSpellTargetUnit()) // 'B05H': buff "Enaero"
endfunction

function Trig_Geomancer_GayaRage_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A05P') // 'A05P': ability "Gaya Rage"
endfunction

function Trig_Geomancer_GayaRage_HasElementIndex takes nothing returns boolean
    return(udg_DamageElement>0)
endfunction

function Trig_Geomancer_GayaRage_FilterIsAlive takes nothing returns boolean
    return(IsUnitAliveBJ(GetFilterUnit()))
endfunction

function Trig_Geomancer_GayaRage_FilterIsEnemy takes nothing returns boolean
    return(IsUnitEnemy(GetFilterUnit(),GetOwningPlayer(GetTriggerUnit())))
endfunction

function Trig_Geomancer_GayaRage_FilterAliveEnemy takes nothing returns boolean
    return GetBooleanAnd(Trig_Geomancer_GayaRage_FilterIsAlive(),Trig_Geomancer_GayaRage_FilterIsEnemy())
endfunction

function Trig_Geomancer_GayaRage_FilterNotInvulnerable takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('Avul',GetFilterUnit())<=0) // 'Avul': standard ability reference "Invulnerable"
endfunction

function Trig_Geomancer_GayaRage_FilterTarget takes nothing returns boolean
    return GetBooleanAnd(Trig_Geomancer_GayaRage_FilterAliveEnemy(),Trig_Geomancer_GayaRage_FilterNotInvulnerable())
endfunction

function Trig_Geomancer_GayaRage_CasterIsHero takes nothing returns boolean
    return(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Geomancer_GayaRage_DamageEnum takes nothing returns nothing
    set udg_IsPhysicalAttack=true
    set udg_DmgFlagNoCrit=-1.
    // Udg_TempInteger treated as a decimal-capable number.
    call UnitDamageTarget(GetTriggerUnit(),GetEnumUnit(),I2R(udg_TempInteger),true,true,ATTACK_TYPE_SIEGE,DAMAGE_TYPE_NORMAL,null)
endfunction

function Trig_Geomancer_GayaRage_Actions takes nothing returns nothing
    local group l_tempGroup
    local location l_tempPoint
    local real l_tempReal
    call Element_SetFromUnit(GetTriggerUnit(),true)
    set l_tempPoint=GetUnitLoc(GetTriggerUnit())
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=6
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        // (loop counter A treated as a decimal-capable number) times (60).
        set udg_TempPoint2=Loc_PolarOffset(l_tempPoint,325.,(I2R(GetForLoopIndexA())*60.))
        if(Trig_Geomancer_GayaRage_HasElementIndex())then
            call AddSpecialEffectLocBJ(udg_TempPoint2,udg_EffectModelPath[udg_DamageElement])
        else
            call AddSpecialEffectLocBJ(udg_TempPoint2,"Abilities\\Spells\\Human\\ThunderClap\\ThunderClapCaster.mdl")
        endif
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint2)
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    set l_tempGroup=Group_UnitsInRangeOfLoc(682.,l_tempPoint,Condition(function Trig_Geomancer_GayaRage_FilterTarget))
    call RemoveLocation(l_tempPoint)
    // (BlzGetAbilityManaCost(GetSpellAbilityId(), Abil_GetLevel(the triggering unit, GetSpellAbilityId()))) times
    // (6).
    set udg_TempInteger=(BlzGetAbilityManaCost(GetSpellAbilityId(),Abil_GetLevel(GetTriggerUnit(),GetSpellAbilityId()))*6)
    if(Trig_Geomancer_GayaRage_CasterIsHero())then
        // (udg_TempInteger) plus ((Strength of the triggering unit) times (6)).
        set udg_TempInteger=(udg_TempInteger+(GetHeroStatBJ(bj_HEROSTAT_STR,GetTriggerUnit(),true)*6))
    endif
    // (0.1) times ((10) plus (Prof_GetLevel(the triggering unit, 'R00I'))).
    set l_tempReal=.1*($A+Prof_GetLevel(GetTriggerUnit(),'R00I')) // $A = 10; 'R00I': upgrade "Heavens Forged Axe"
    // ((udg_TempInteger treated as a decimal-capable number) times (l_tempReal)) with its decimal part removed.
    set udg_TempInteger=R2I((I2R(udg_TempInteger)*l_tempReal))
    set udg_DamageElement=0
    call ForGroupBJ(l_tempGroup,function Trig_Geomancer_GayaRage_DamageEnum)
    call DestroyGroup(l_tempGroup)
    set l_tempGroup=null
    set l_tempPoint=null
endfunction

// World Editor calls InitTrig_Geomancer automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Geomancer (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Geomancer takes nothing returns nothing
endfunction

function Register_Geomancer_Enchant_Cycle takes nothing returns nothing
    set gg_trg_Geomancer_Enchant_Cycle=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Geomancer_Enchant_Cycle,EVENT_PLAYER_UNIT_ISSUED_ORDER)
    call TriggerAddCondition(gg_trg_Geomancer_Enchant_Cycle,Condition(function Trig_Geomancer_Enchant_Cycle_Conditions))
    call TriggerAddAction(gg_trg_Geomancer_Enchant_Cycle,function Trig_Geomancer_Enchant_Cycle_Actions)
endfunction

function Register_Geomancer_Enchant_Apply takes nothing returns nothing
    set gg_trg_Geomancer_Enchant_Apply=CreateTrigger()
    call TriggerRegisterTimerExpireEventBJ(gg_trg_Geomancer_Enchant_Apply,udg_EnchantCycleTimer)
    call TriggerAddCondition(gg_trg_Geomancer_Enchant_Apply,Condition(function Trig_Geomancer_Enchant_Apply_Conditions))
    call TriggerAddAction(gg_trg_Geomancer_Enchant_Apply,function Trig_Geomancer_Enchant_Apply_Actions)
endfunction

function Register_Geomancer_Enchant_ClearBuffs takes nothing returns nothing
    set gg_trg_Geomancer_Enchant_ClearBuffs=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Geomancer_Enchant_ClearBuffs,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Geomancer_Enchant_ClearBuffs,Condition(function Trig_Geomancer_Enchant_ClearBuffs_Conditions))
    call TriggerAddAction(gg_trg_Geomancer_Enchant_ClearBuffs,function Trig_Geomancer_Enchant_ClearBuffs_Actions)
endfunction

function Register_Geomancer_GayaRage takes nothing returns nothing
    set gg_trg_Geomancer_GayaRage=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Geomancer_GayaRage,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Geomancer_GayaRage,Condition(function Trig_Geomancer_GayaRage_Conditions))
    call TriggerAddAction(gg_trg_Geomancer_GayaRage,function Trig_Geomancer_GayaRage_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Geomancer takes nothing returns nothing
    call Register_Geomancer_Enchant_Cycle() // enabled by Geomancer
    call Register_Geomancer_Enchant_Apply()
    call Register_Geomancer_Enchant_ClearBuffs()
    call Register_Geomancer_GayaRage()
endfunction

endlibrary
