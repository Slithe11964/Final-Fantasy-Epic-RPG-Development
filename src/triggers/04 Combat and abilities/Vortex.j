library TVortex requires TGroup, TWait
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Vortex_Warning=null
    trigger gg_trg_Vortex_Suck=null
    trigger gg_trg_Vortex_Drain=null
endglobals

function Trig_Vortex_Warning_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A0ZO') // 'A0ZO': ability "Vortex"
endfunction

function Trig_Vortex_Warning_Actions takes nothing returns nothing
    local location l_tempPoint
    set l_tempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateTextTagLocBJ("|cffffcc00VORTEX",l_tempPoint,0,13.,'d','d','d',0)
    call RemoveLocation(l_tempPoint)
    call SetTextTagVelocityBJ(GetLastCreatedTextTag(),80.,90)
    call SetTextTagPermanentBJ(GetLastCreatedTextTag(),false)
    call SetTextTagLifespanBJ(GetLastCreatedTextTag(),1.5)
    call SetTextTagFadepointBJ(GetLastCreatedTextTag(),1.)
    call ShowTextTagForceBJ(false,GetLastCreatedTextTag(),GetPlayersAll())
    call ShowTextTagForceBJ(true,GetLastCreatedTextTag(),udg_AbilityTextForce)
    set l_tempPoint=null
endfunction

function Trig_Vortex_Suck_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A0ZO') // 'A0ZO': ability "Vortex"
endfunction

function Trig_Vortex_Suck_IsTargetAlive takes nothing returns boolean
    return(IsUnitAliveBJ(GetFilterUnit()))
endfunction

function Trig_Vortex_Suck_IsTargetEnemy takes nothing returns boolean
    return(IsUnitEnemy(GetFilterUnit(),GetOwningPlayer(GetTriggerUnit())))
endfunction

function Trig_Vortex_Suck_IsLivingEnemy takes nothing returns boolean
    return GetBooleanAnd(Trig_Vortex_Suck_IsTargetAlive(),Trig_Vortex_Suck_IsTargetEnemy())
endfunction

function Trig_Vortex_Suck_IsTargetVulnerable takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('Avul',GetFilterUnit())<=0) // 'Avul': standard ability reference "Invulnerable"
endfunction

function Trig_Vortex_Suck_IsVortexTarget takes nothing returns boolean
    return GetBooleanAnd(Trig_Vortex_Suck_IsLivingEnemy(),Trig_Vortex_Suck_IsTargetVulnerable())
endfunction

function Trig_Vortex_Suck_PullIntoVortex takes nothing returns nothing
    local location l_tempPoint
    set l_tempPoint=GetUnitLoc(GetEnumUnit())
    call AddSpecialEffectLocBJ(l_tempPoint,"Abilities\\Spells\\Undead\\DarkRitual\\DarkRitualTarget.mdl")
    call BlzSetSpecialEffectColor(GetLastCreatedEffectBJ(),0,0,0)
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(l_tempPoint)
    call ShowUnitHide(GetEnumUnit())
    call PauseUnitBJ(true,GetEnumUnit())
    call GroupAddUnitSimple(GetEnumUnit(),udg_VortexVictims)
    set l_tempPoint=null
endfunction

function Trig_Vortex_Suck_IsEnragedPhase takes nothing returns boolean
    // Result 1: current health divided by maximum health for the triggering unit, times 100 (or 0 if the unit is
    // missing or its maximum is 0).
    return(GetUnitLifePercent(GetTriggerUnit())<50.)or(UnitHasBuffBJ(GetTriggerUnit(),'B05V')) // 'B05V': buff tooltip "Disease"
endfunction

function Trig_Vortex_Suck_UseVortexLevel2 takes nothing returns boolean
    return(Trig_Vortex_Suck_IsEnragedPhase())
endfunction

function Trig_Vortex_Suck_Actions takes nothing returns nothing
    local group l_tempGroup
    local location l_tempPoint
    set l_tempPoint=GetSpellTargetLoc()
    call AddSpecialEffectLocBJ(l_tempPoint,"Abilities\\Spells\\Human\\FlameStrike\\FlameStrikeTarget.mdl")
    call BlzSetSpecialEffectColor(GetLastCreatedEffectBJ(),0,0,0)
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call AddSpecialEffectLocBJ(l_tempPoint,"units\\nightelf\\Wisp\\Wisp.mdl")
    call BlzSetSpecialEffectScale(GetLastCreatedEffectBJ(),3.)
    call BlzSetSpecialEffectColor(GetLastCreatedEffectBJ(),0,0,0)
    call BlzSetSpecialEffectColorByPlayer(GetLastCreatedEffectBJ(),Player(PLAYER_NEUTRAL_PASSIVE))
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    set l_tempGroup=Group_UnitsInRangeOfLoc(250.,l_tempPoint,Condition(function Trig_Vortex_Suck_IsVortexTarget))
    call RemoveLocation(l_tempPoint)
    call ForGroupBJ(l_tempGroup,function Trig_Vortex_Suck_PullIntoVortex)
    call DestroyGroup(l_tempGroup)
    call StartTimerBJ(udg_VortexTimer,false,1.)
    call Wait_Polled(1.)
    if(Trig_Vortex_Suck_UseVortexLevel2())then
        call SetUnitAbilityLevelSwapped(GetSpellAbilityId(),GetTriggerUnit(),2)
    else
        call SetUnitAbilityLevelSwapped(GetSpellAbilityId(),GetTriggerUnit(),1)
    endif
    set l_tempGroup=null
    set l_tempPoint=null
endfunction

function Trig_Vortex_Drain_IsNearlyDead takes nothing returns boolean
    // Result 1: current health divided by maximum health for the unit being visited, times 100 (or 0 if the unit
    // is missing or its maximum is 0).
    return(GetUnitLifePercent(GetEnumUnit())<=10.)
endfunction

function Trig_Vortex_Drain_DrainVictim takes nothing returns nothing
    if(Trig_Vortex_Drain_IsNearlyDead())then
        call SetUnitLifeBJ(GetEnumUnit(),1.)
        call ShowUnitShow(GetEnumUnit())
        call PauseUnitBJ(false,GetEnumUnit())
        set udg_TempPoint=GetUnitLoc(GetEnumUnit())
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\ThunderClap\\ThunderClapCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call GroupRemoveUnitSimple(GetEnumUnit(),udg_VortexVictims)
    else
        // Result 1: current health divided by maximum health for the unit being visited, times 100 (or 0 if the unit
        // is missing or its maximum is 0).
        // Result 2: (result 1) minus (10).
        call SetUnitLifePercentBJ(GetEnumUnit(),(GetUnitLifePercent(GetEnumUnit())-10.))
    endif
endfunction

function Trig_Vortex_Drain_HasVictimsLeft takes nothing returns boolean
    return(IsUnitGroupEmptyBJ(udg_VortexVictims)==false)
endfunction

function Trig_Vortex_Drain_Actions takes nothing returns nothing
    local group l_tempGroup
    set l_tempGroup=CreateGroup()
    call GroupAddGroup(udg_VortexVictims,l_tempGroup)
    call ForGroupBJ(l_tempGroup,function Trig_Vortex_Drain_DrainVictim)
    call DestroyGroup(l_tempGroup)
    if(Trig_Vortex_Drain_HasVictimsLeft())then
        call StartTimerBJ(udg_VortexTimer,false,1.)
    endif
    set l_tempGroup=null
endfunction

// World Editor calls InitTrig_Vortex automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Vortex (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Vortex takes nothing returns nothing
endfunction

function Register_Vortex_Warning takes nothing returns nothing
    set gg_trg_Vortex_Warning=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Vortex_Warning,EVENT_PLAYER_UNIT_SPELL_CHANNEL)
    call TriggerAddCondition(gg_trg_Vortex_Warning,Condition(function Trig_Vortex_Warning_Conditions))
    call TriggerAddAction(gg_trg_Vortex_Warning,function Trig_Vortex_Warning_Actions)
endfunction

function Register_Vortex_Suck takes nothing returns nothing
    set gg_trg_Vortex_Suck=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Vortex_Suck,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Vortex_Suck,Condition(function Trig_Vortex_Suck_Conditions))
    call TriggerAddAction(gg_trg_Vortex_Suck,function Trig_Vortex_Suck_Actions)
endfunction

function Register_Vortex_Drain takes nothing returns nothing
    set gg_trg_Vortex_Drain=CreateTrigger()
    call TriggerRegisterTimerExpireEventBJ(gg_trg_Vortex_Drain,udg_VortexTimer)
    call TriggerAddAction(gg_trg_Vortex_Drain,function Trig_Vortex_Drain_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Vortex takes nothing returns nothing
    call Register_Vortex_Warning()
    call Register_Vortex_Suck()
    call Register_Vortex_Drain()
endfunction

endlibrary
