library TValfodr requires TGroup, TLoc, TProf
function Trig_Valfodr_SummonSetup_Conditions takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A124',GetTriggerUnit())>0) // 'A124': ability "Valfodr Summons"
endfunction

function Trig_Valfodr_SummonSetup_IsLevel50Plus takes nothing returns boolean
    return(GetHeroLevel(GetTriggerUnit())>=50)
endfunction

function Trig_Valfodr_SummonSetup_IsLevel70 takes nothing returns boolean
    return(GetHeroLevel(GetTriggerUnit())==70)
endfunction

function Trig_Valfodr_SummonSetup_IsLevel45 takes nothing returns boolean
    return(GetHeroLevel(GetTriggerUnit())==45)
endfunction

function Trig_Valfodr_SummonSetup_IsLevel15 takes nothing returns boolean
    return(GetHeroLevel(GetTriggerUnit())==$F) // $F = 15
endfunction

function Trig_Valfodr_SummonSetup_IsLevel99 takes nothing returns boolean
    return(GetHeroLevel(GetTriggerUnit())==99)
endfunction

function Trig_Valfodr_SummonSetup_Actions takes nothing returns nothing
    call UnitRemoveAbilityBJ('A124',GetTriggerUnit()) // 'A124': ability "Valfodr Summons"
    if(Trig_Valfodr_SummonSetup_IsLevel50Plus())then
        call UnitAddAbilityBJ('A129',GetTriggerUnit()) // 'A129': ability "Bolverk"
    endif
    if(Trig_Valfodr_SummonSetup_IsLevel99())then
        call UnitAddAbilityBJ('A0UG',GetTriggerUnit()) // 'A0UG': ability "!Ultima"
    else
        call UnitAddAbilityBJ('A125',GetTriggerUnit()) // 'A125': ability "Valfodr Summon"
        if(Trig_Valfodr_SummonSetup_IsLevel15())then
            call SetUnitAbilityLevelSwapped('A125',GetTriggerUnit(),2) // 'A125': ability "Valfodr Summon"
        else
            if(Trig_Valfodr_SummonSetup_IsLevel45())then
                call SetUnitAbilityLevelSwapped('A125',GetTriggerUnit(),3) // 'A125': ability "Valfodr Summon"
            else
                if(Trig_Valfodr_SummonSetup_IsLevel70())then
                    call SetUnitAbilityLevelSwapped('A125',GetTriggerUnit(),4) // 'A125': ability "Valfodr Summon"
                endif
            endif
        endif
        call IssueImmediateOrderBJ(GetTriggerUnit(),"spiritwolf")
    endif
endfunction

function Trig_Valfodr_Gagnrath_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A121') // 'A121': ability "!Gagnrath"
endfunction

function Trig_Valfodr_Gagnrath_Actions takes nothing returns nothing
    call GroupAddUnitSimple(GetTriggerUnit(),udg_GagnrathCasters)
    call StartTimerBJ(udg_GagnrathTimer,false,1.)
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call AddSpecialEffectTargetUnitBJ("origin",GetTriggerUnit(),"Abilities\\Spells\\Orc\\WarStomp\\WarStompCaster.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=6
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        // (loop counter A treated as a decimal-capable number) times (60).
        set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,275.,(I2R(GetForLoopIndexA())*60.))
        call AddSpecialEffectLocBJ(udg_TempPoint2,"Abilities\\Spells\\Orc\\WarStomp\\WarStompCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint2)
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    call CreateNUnitsAtLocFacingLocBJ(1,'h01B',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,udg_TempPoint) // 'h01B': unit "Proxy Dummy"
    call RemoveLocation(udg_TempPoint)
    set udg_TempHandleId=GetHandleIdBJ(GetLastCreatedUnit())
    call SaveUnitHandleBJ(GetTriggerUnit(),0,udg_TempHandleId,udg_ProxyDamageHash)
    // ((Strength of the triggering unit) times (5)) plus (5000).
    set udg_TempInteger=((GetHeroStatBJ(bj_HEROSTAT_STR,GetTriggerUnit(),true)*5)+5000)
    // (0.1) times ((10) plus (Prof_GetLevel(the triggering unit, 'R00I'))).
    set udg_TempReal=.1*($A+Prof_GetLevel(GetTriggerUnit(),'R00I')) // $A = 10; 'R00I': upgrade "Heavens Forged Axe"
    // (udg_TempInteger treated as a decimal-capable number) times (udg_TempReal).
    call SaveRealBJ((I2R(udg_TempInteger)*udg_TempReal),1,udg_TempHandleId,udg_ProxyDamageHash)
    call SaveIntegerBJ(1,2,udg_TempHandleId,udg_ProxyDamageHash)
    call SaveIntegerBJ(4,3,udg_TempHandleId,udg_ProxyDamageHash)
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(2.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A0M5',GetLastCreatedUnit()) // 'A0M5': ability "Earth-elemental Damage"
    call UnitAddAbilityBJ('A123',GetLastCreatedUnit()) // 'A123': ability "Gagnrath"
    call IssueImmediateOrderBJ(GetLastCreatedUnit(),"stomp")
endfunction

function Trig_Valfodr_GagnrathEnd_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A121') // 'A121': ability "!Gagnrath"
endfunction

function Trig_Valfodr_GagnrathEnd_Actions takes nothing returns nothing
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_GagnrathCasters)
endfunction

function Trig_Valfodr_GagnrathPulse_Conditions takes nothing returns boolean
    return(IsUnitGroupEmptyBJ(udg_GagnrathCasters)==false)
endfunction

function Trig_Valfodr_GagnrathPulse_Actions takes nothing returns nothing
    call StartTimerBJ(udg_GagnrathTimer,false,1.)
    call GroupAddGroup(udg_GagnrathCasters,udg_PendingEffectGroup)
    call ConditionalTriggerExecute(gg_trg_Valfodr_GagnrathWave)
endfunction

function Trig_Valfodr_GagnrathWave_Conditions takes nothing returns boolean
    return(IsUnitGroupEmptyBJ(udg_PendingEffectGroup)==false)
endfunction

function Trig_Valfodr_GagnrathWave_FilterAlive takes nothing returns boolean
    return(IsUnitAliveBJ(GetFilterUnit()))
endfunction

function Trig_Valfodr_GagnrathWave_FilterEnemy takes nothing returns boolean
    return(IsUnitEnemy(GetFilterUnit(),GetOwningPlayer(udg_CurrentEffectUnit)))
endfunction

function Trig_Valfodr_GagnrathWave_FilterAliveEnemy takes nothing returns boolean
    return GetBooleanAnd(Trig_Valfodr_GagnrathWave_FilterAlive(),Trig_Valfodr_GagnrathWave_FilterEnemy())
endfunction

function Trig_Valfodr_GagnrathWave_FilterVulnerable takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('Avul',GetFilterUnit())<=0) // 'Avul': standard ability reference "Invulnerable"
endfunction

function Trig_Valfodr_GagnrathWave_FilterWaveTarget takes nothing returns boolean
    return GetBooleanAnd(Trig_Valfodr_GagnrathWave_FilterAliveEnemy(),Trig_Valfodr_GagnrathWave_FilterVulnerable())
endfunction

function Trig_Valfodr_GagnrathWave_DamageTarget takes nothing returns nothing
    set udg_DamageElement=5
    set udg_IsPhysicalAttack=true
    // Udg_TempInteger treated as a decimal-capable number.
    call UnitDamageTargetBJ(udg_CurrentEffectUnit,GetEnumUnit(),I2R(udg_TempInteger),ATTACK_TYPE_SIEGE,DAMAGE_TYPE_NORMAL)
endfunction

function Trig_Valfodr_GagnrathWave_Actions takes nothing returns nothing
    set udg_CurrentEffectUnit=GroupPickRandomUnit(udg_PendingEffectGroup)
    call GroupRemoveUnitSimple(udg_CurrentEffectUnit,udg_PendingEffectGroup)
    call AddSpecialEffectTargetUnitBJ("origin",udg_CurrentEffectUnit,"Abilities\\Spells\\Orc\\WarStomp\\WarStompCaster.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    set udg_TempPoint=GetUnitLoc(udg_CurrentEffectUnit)
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=6
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        // (loop counter A treated as a decimal-capable number) times (60).
        set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,275.,(I2R(GetForLoopIndexA())*60.))
        call AddSpecialEffectLocBJ(udg_TempPoint2,"Abilities\\Spells\\Orc\\WarStomp\\WarStompCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint2)
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    set udg_TempGroup=Group_UnitsInRangeOfLoc(600.,udg_TempPoint,Condition(function Trig_Valfodr_GagnrathWave_FilterWaveTarget))
    call RemoveLocation(udg_TempPoint)
    // ((Strength of udg_CurrentEffectUnit) times (5)) plus (5000).
    set udg_TempInteger=((GetHeroStatBJ(bj_HEROSTAT_STR,udg_CurrentEffectUnit,true)*5)+5000)
    // (0.1) times ((10) plus (Prof_GetLevel(the triggering unit, 'R00I'))).
    set udg_TempReal=.1*($A+Prof_GetLevel(GetTriggerUnit(),'R00I')) // $A = 10; 'R00I': upgrade "Heavens Forged Axe"
    // ((udg_TempInteger treated as a decimal-capable number) times (udg_TempReal)) with its decimal part removed.
    set udg_TempInteger=R2I((I2R(udg_TempInteger)*udg_TempReal))
    call ForGroupBJ(udg_TempGroup,function Trig_Valfodr_GagnrathWave_DamageTarget)
    call DestroyGroup(udg_TempGroup)
    call ConditionalTriggerExecute(GetTriggeringTrigger())
endfunction

function Trig_Valfodr_Bolverk_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A129') // 'A129': ability "Bolverk"
endfunction

function Trig_Valfodr_Bolverk_Actions takes nothing returns nothing
    call AddSpecialEffectTargetUnitBJ("origin",GetTriggerUnit(),"Objects\\Spawnmodels\\NightElf\\NEDeathMedium\\NEDeath.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=6
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        // (loop counter A treated as a decimal-capable number) times (60).
        set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,300.,(I2R(GetForLoopIndexA())*60.))
        call AddSpecialEffectLocBJ(udg_TempPoint2,"Abilities\\Spells\\Human\\ManaFlare\\ManaFlareBoltImpact.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint2)
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    call CreateNUnitsAtLocFacingLocBJ(1,'h01B',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,udg_TempPoint) // 'h01B': unit "Proxy Dummy"
    call RemoveLocation(udg_TempPoint)
    set udg_TempHandleId=GetHandleIdBJ(GetLastCreatedUnit())
    call SaveUnitHandleBJ(GetTriggerUnit(),0,udg_TempHandleId,udg_ProxyDamageHash)
    set udg_TempInteger=9999
    // (0.1) times ((10) plus (Prof_GetLevel(the triggering unit, 'R00I'))).
    set udg_TempReal=.1*($A+Prof_GetLevel(GetTriggerUnit(),'R00I')) // $A = 10; 'R00I': upgrade "Heavens Forged Axe"
    // (udg_TempInteger treated as a decimal-capable number) times (udg_TempReal).
    call SaveRealBJ((I2R(udg_TempInteger)*udg_TempReal),1,udg_TempHandleId,udg_ProxyDamageHash)
    call SaveIntegerBJ(1,2,udg_TempHandleId,udg_ProxyDamageHash)
    call SaveIntegerBJ(4,3,udg_TempHandleId,udg_ProxyDamageHash)
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(2.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A0M3',GetLastCreatedUnit()) // 'A0M3': ability "Thunder-elemental Damage"
    call UnitAddAbilityBJ('A128',GetLastCreatedUnit()) // 'A128': ability "Bolverk"
    call IssueImmediateOrderBJ(GetLastCreatedUnit(),"thunderclap")
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Valfodr takes nothing returns nothing
endfunction

function RegisterR11_Valfodr_SummonSetup takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Valfodr_SummonSetup=CreateTrigger()

call TriggerRegisterPlayerUnitEventSimple(gg_trg_Valfodr_SummonSetup,Player($B),EVENT_PLAYER_UNIT_ATTACKED) // $B = 11

call TriggerAddCondition(gg_trg_Valfodr_SummonSetup,Condition(function Trig_Valfodr_SummonSetup_Conditions))

call TriggerAddAction(gg_trg_Valfodr_SummonSetup,function Trig_Valfodr_SummonSetup_Actions)

endfunction




function RegisterR11_Valfodr_Gagnrath takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Valfodr_Gagnrath=CreateTrigger()

call TriggerRegisterAnyUnitEventBJ(gg_trg_Valfodr_Gagnrath,EVENT_PLAYER_UNIT_SPELL_EFFECT)

call TriggerAddCondition(gg_trg_Valfodr_Gagnrath,Condition(function Trig_Valfodr_Gagnrath_Conditions))

call TriggerAddAction(gg_trg_Valfodr_Gagnrath,function Trig_Valfodr_Gagnrath_Actions)

endfunction




function RegisterR11_Valfodr_GagnrathEnd takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Valfodr_GagnrathEnd=CreateTrigger()

call TriggerRegisterAnyUnitEventBJ(gg_trg_Valfodr_GagnrathEnd,EVENT_PLAYER_UNIT_SPELL_ENDCAST)

call TriggerAddCondition(gg_trg_Valfodr_GagnrathEnd,Condition(function Trig_Valfodr_GagnrathEnd_Conditions))

call TriggerAddAction(gg_trg_Valfodr_GagnrathEnd,function Trig_Valfodr_GagnrathEnd_Actions)

endfunction




function RegisterR11_Valfodr_GagnrathPulse takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Valfodr_GagnrathPulse=CreateTrigger()

call TriggerRegisterTimerExpireEventBJ(gg_trg_Valfodr_GagnrathPulse,udg_GagnrathTimer)

call TriggerAddCondition(gg_trg_Valfodr_GagnrathPulse,Condition(function Trig_Valfodr_GagnrathPulse_Conditions))

call TriggerAddAction(gg_trg_Valfodr_GagnrathPulse,function Trig_Valfodr_GagnrathPulse_Actions)

endfunction




function RegisterR11_Valfodr_GagnrathWave takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Valfodr_GagnrathWave=CreateTrigger()

call DisableTrigger(gg_trg_Valfodr_GagnrathWave)

call TriggerAddCondition(gg_trg_Valfodr_GagnrathWave,Condition(function Trig_Valfodr_GagnrathWave_Conditions))

call TriggerAddAction(gg_trg_Valfodr_GagnrathWave,function Trig_Valfodr_GagnrathWave_Actions)

endfunction




function RegisterR11_Valfodr_Bolverk takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Valfodr_Bolverk=CreateTrigger()

call TriggerRegisterAnyUnitEventBJ(gg_trg_Valfodr_Bolverk,EVENT_PLAYER_UNIT_SPELL_EFFECT)

call TriggerAddCondition(gg_trg_Valfodr_Bolverk,Condition(function Trig_Valfodr_Bolverk_Conditions))

call TriggerAddAction(gg_trg_Valfodr_Bolverk,function Trig_Valfodr_Bolverk_Actions)

endfunction




endlibrary
