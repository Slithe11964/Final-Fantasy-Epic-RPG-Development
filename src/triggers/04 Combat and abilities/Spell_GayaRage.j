library TSpellGayaRage requires TGroup, TLoc
globals
    // Variables only this module uses.
    real udg_GayaRageRadius=0
    effect udg_GayaRageEffect=null
endglobals

function Trig_Spell_GayaRage_Start_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A0TR') // 'A0TR': ability "Gaya Rage"
endfunction

function Trig_Spell_GayaRage_Start_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call RemoveLocation(udg_GayaRageLoc)
    set udg_GayaRageLoc=GetUnitLoc(GetTriggerUnit())
    set udg_GayaRageEffect=AddSpecialEffectTargetUnitBJ("origin",GetTriggerUnit(),"Abilities\\Spells\\Other\\Doom\\DoomTarget.mdl")
    set udg_GayaRageRadius=2.
    call StartTimerBJ(udg_GayaRageTimer,false,1.5)
    call CreateTextTagLocBJ("|cffffcc00GAYA RAGE",udg_GayaRageLoc,0,13.,'d','d','d',0)
    call SetTextTagVelocityBJ(GetLastCreatedTextTag(),80.,90)
    call SetTextTagPermanentBJ(GetLastCreatedTextTag(),false)
    call SetTextTagLifespanBJ(GetLastCreatedTextTag(),1.5)
    call SetTextTagFadepointBJ(GetLastCreatedTextTag(),1.)
    call ShowTextTagForceBJ(false,GetLastCreatedTextTag(),GetPlayersAll())
    call ShowTextTagForceBJ(true,GetLastCreatedTextTag(),udg_AbilityTextForce)
endfunction

function Trig_Spell_GayaRage_Ring_Conditions takes nothing returns boolean
    return(udg_GayaRageRadius>.0)and(udg_GayaRageRadius<750.)
endfunction

function Trig_Spell_GayaRage_Ring_Actions takes nothing returns nothing
    call StartTimerBJ(udg_GayaRageTimer,false,.1)
    // (udg_GayaRageRadius) times (1.36).
    set udg_GayaRageRadius=(udg_GayaRageRadius*1.36)
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=6
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        // Calculation 1:
        // (udg_GayaRageRadius) times (2).
        // Calculation 2:
        // ((loop counter A treated as a decimal-capable number) times (60)) plus ((udg_GayaRageRadius) divided by
        // (2)).
        set udg_TempPoint=Loc_PolarOffset(udg_GayaRageLoc,(udg_GayaRageRadius*2.),((I2R(GetForLoopIndexA())*60.)+(udg_GayaRageRadius/ 2.)))
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\ThunderClap\\ThunderClapCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
endfunction

function Trig_Spell_GayaRage_Damage_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A0TR') // 'A0TR': ability "Gaya Rage"
endfunction

function Trig_Spell_GayaRage_Damage_FilterAliveRect takes nothing returns boolean
    return(IsUnitAliveBJ(GetFilterUnit()))
endfunction

function Trig_Spell_GayaRage_Damage_FilterEnemyRect takes nothing returns boolean
    return(IsUnitEnemy(GetFilterUnit(),GetOwningPlayer(GetTriggerUnit())))
endfunction

function Trig_Spell_GayaRage_Damage_FilterAliveEnemyRect takes nothing returns boolean
    return GetBooleanAnd(Trig_Spell_GayaRage_Damage_FilterAliveRect(),Trig_Spell_GayaRage_Damage_FilterEnemyRect())
endfunction

function Trig_Spell_GayaRage_Damage_FilterVulnerableRect takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('Avul',GetFilterUnit())<=0) // 'Avul': standard ability reference "Invulnerable"
endfunction

function Trig_Spell_GayaRage_Damage_FilterTargetRect takes nothing returns boolean
    return GetBooleanAnd(Trig_Spell_GayaRage_Damage_FilterAliveEnemyRect(),Trig_Spell_GayaRage_Damage_FilterVulnerableRect())
endfunction

function Trig_Spell_GayaRage_Damage_FilterAliveArea takes nothing returns boolean
    return(IsUnitAliveBJ(GetFilterUnit()))
endfunction

function Trig_Spell_GayaRage_Damage_FilterEnemyArea takes nothing returns boolean
    return(IsUnitEnemy(GetFilterUnit(),GetOwningPlayer(GetTriggerUnit())))
endfunction

function Trig_Spell_GayaRage_Damage_FilterAliveEnemyArea takes nothing returns boolean
    return GetBooleanAnd(Trig_Spell_GayaRage_Damage_FilterAliveArea(),Trig_Spell_GayaRage_Damage_FilterEnemyArea())
endfunction

function Trig_Spell_GayaRage_Damage_FilterVulnerableArea takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('Avul',GetFilterUnit())<=0) // 'Avul': standard ability reference "Invulnerable"
endfunction

function Trig_Spell_GayaRage_Damage_FilterTargetArea takes nothing returns boolean
    return GetBooleanAnd(Trig_Spell_GayaRage_Damage_FilterAliveEnemyArea(),Trig_Spell_GayaRage_Damage_FilterVulnerableArea())
endfunction

function Trig_Spell_GayaRage_Damage_CasterInArena takes nothing returns boolean
    return(RectContainsLoc(gg_rct_496,udg_TempPoint))
endfunction

function Trig_Spell_GayaRage_Damage_DamageTarget takes nothing returns nothing
    call UnitRemoveBuffBJ('B063',GetEnumUnit()) // 'B063': buff "Cover"
    // (a random decimal number between 15 and 16) divided by (16).
    set udg_TempReal=(GetRandomReal(15.,16.)/ 16.)
    set udg_DmgFlagPure=true
    set udg_IgnoresReduction=true
    set udg_DmgFlagUnavoidable=-1
    // (99999.9) times (udg_TempReal).
    call UnitDamageTarget(GetTriggerUnit(),GetEnumUnit(),99999.9*udg_TempReal,true,true,ATTACK_TYPE_CHAOS,DAMAGE_TYPE_UNIVERSAL,null)
endfunction

function Trig_Spell_GayaRage_Damage_Actions takes nothing returns nothing
    set udg_GayaRageRadius=.0
    call DestroyEffectBJ(udg_GayaRageEffect)
    call EnableTrigger(gg_trg_Spell_GayaRage_Start)
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=6
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        // (loop counter A treated as a decimal-capable number) times (60).
        set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,325.,(I2R(GetForLoopIndexA())*60.))
        call AddSpecialEffectLocBJ(udg_TempPoint2,"Abilities\\Spells\\Human\\ThunderClap\\ThunderClapCaster.mdl")
        call BlzSetSpecialEffectScale(GetLastCreatedEffectBJ(),4.)
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint2)
        // ((loop counter A treated as a decimal-capable number) times (60)) minus (30).
        set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,650.,((I2R(GetForLoopIndexA())*60.)-30.))
        call AddSpecialEffectLocBJ(udg_TempPoint2,"Abilities\\Spells\\Human\\ThunderClap\\ThunderClapCaster.mdl")
        call BlzSetSpecialEffectScale(GetLastCreatedEffectBJ(),4.)
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint2)
        // (loop counter A treated as a decimal-capable number) times (60).
        set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,975.,(I2R(GetForLoopIndexA())*60.))
        call AddSpecialEffectLocBJ(udg_TempPoint2,"Abilities\\Spells\\Human\\ThunderClap\\ThunderClapCaster.mdl")
        call BlzSetSpecialEffectScale(GetLastCreatedEffectBJ(),4.)
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call TerrainDeformationWaveBJ(.5,udg_TempPoint,udg_TempPoint2,256,96,0)
        call RemoveLocation(udg_TempPoint2)
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    if(Trig_Spell_GayaRage_Damage_CasterInArena())then
        set udg_TempGroup=Group_UnitsInRect(gg_rct_496,Condition(function Trig_Spell_GayaRage_Damage_FilterTargetRect))
    else
        set udg_TempGroup=Group_UnitsInRangeOfLoc(1332.,udg_TempPoint,Condition(function Trig_Spell_GayaRage_Damage_FilterTargetArea))
    endif
    call RemoveLocation(udg_TempPoint)
    call ForGroupBJ(udg_TempGroup,function Trig_Spell_GayaRage_Damage_DamageTarget)
    call DestroyGroup(udg_TempGroup)
endfunction

function InitTrig_Spell_GayaRage takes nothing returns nothing
endfunction

endlibrary
