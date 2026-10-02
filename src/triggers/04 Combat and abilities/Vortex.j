library TVortex requires TGroup, TWait
function Trig_Vortex_Warning_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A0ZO') // 'A0ZO': ability "Vortex"
endfunction

function Trig_Vortex_Warning_Actions takes nothing returns nothing
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateTextTagLocBJ("|cffffcc00VORTEX",udg_TempPoint,0,13.,'d','d','d',0)
    call RemoveLocation(udg_TempPoint)
    call SetTextTagVelocityBJ(GetLastCreatedTextTag(),80.,90)
    call SetTextTagPermanentBJ(GetLastCreatedTextTag(),false)
    call SetTextTagLifespanBJ(GetLastCreatedTextTag(),1.5)
    call SetTextTagFadepointBJ(GetLastCreatedTextTag(),1.)
    call ShowTextTagForceBJ(false,GetLastCreatedTextTag(),GetPlayersAll())
    call ShowTextTagForceBJ(true,GetLastCreatedTextTag(),udg_AbilityTextForce)
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
    set udg_TempPoint=GetUnitLoc(GetEnumUnit())
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Undead\\DarkRitual\\DarkRitualTarget.mdl")
    call BlzSetSpecialEffectColor(GetLastCreatedEffectBJ(),0,0,0)
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(udg_TempPoint)
    call ShowUnitHide(GetEnumUnit())
    call PauseUnitBJ(true,GetEnumUnit())
    call GroupAddUnitSimple(GetEnumUnit(),udg_VortexVictims)
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
    set udg_TempPoint=GetSpellTargetLoc()
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\FlameStrike\\FlameStrikeTarget.mdl")
    call BlzSetSpecialEffectColor(GetLastCreatedEffectBJ(),0,0,0)
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call AddSpecialEffectLocBJ(udg_TempPoint,"units\\nightelf\\Wisp\\Wisp.mdl")
    call BlzSetSpecialEffectScale(GetLastCreatedEffectBJ(),3.)
    call BlzSetSpecialEffectColor(GetLastCreatedEffectBJ(),0,0,0)
    call BlzSetSpecialEffectColorByPlayer(GetLastCreatedEffectBJ(),Player(PLAYER_NEUTRAL_PASSIVE))
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    set udg_TempGroup=Group_UnitsInRangeOfLoc(250.,udg_TempPoint,Condition(function Trig_Vortex_Suck_IsVortexTarget))
    call RemoveLocation(udg_TempPoint)
    call ForGroupBJ(udg_TempGroup,function Trig_Vortex_Suck_PullIntoVortex)
    call DestroyGroup(udg_TempGroup)
    call StartTimerBJ(udg_VortexTimer,false,1.)
    call Wait_Polled(1.)
    if(Trig_Vortex_Suck_UseVortexLevel2())then
        call SetUnitAbilityLevelSwapped(GetSpellAbilityId(),GetTriggerUnit(),2)
    else
        call SetUnitAbilityLevelSwapped(GetSpellAbilityId(),GetTriggerUnit(),1)
    endif
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
    set udg_TempGroup=CreateGroup()
    call GroupAddGroup(udg_VortexVictims,udg_TempGroup)
    call ForGroupBJ(udg_TempGroup,function Trig_Vortex_Drain_DrainVictim)
    call DestroyGroup(udg_TempGroup)
    if(Trig_Vortex_Drain_HasVictimsLeft())then
        call StartTimerBJ(udg_VortexTimer,false,1.)
    endif
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Vortex takes nothing returns nothing
endfunction

function RegisterR11_Vortex_Warning takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Vortex_Warning=CreateTrigger()

call TriggerRegisterAnyUnitEventBJ(gg_trg_Vortex_Warning,EVENT_PLAYER_UNIT_SPELL_CHANNEL)

call TriggerAddCondition(gg_trg_Vortex_Warning,Condition(function Trig_Vortex_Warning_Conditions))

call TriggerAddAction(gg_trg_Vortex_Warning,function Trig_Vortex_Warning_Actions)

endfunction




function RegisterR11_Vortex_Suck takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Vortex_Suck=CreateTrigger()

call TriggerRegisterAnyUnitEventBJ(gg_trg_Vortex_Suck,EVENT_PLAYER_UNIT_SPELL_EFFECT)

call TriggerAddCondition(gg_trg_Vortex_Suck,Condition(function Trig_Vortex_Suck_Conditions))

call TriggerAddAction(gg_trg_Vortex_Suck,function Trig_Vortex_Suck_Actions)

endfunction




function RegisterR11_Vortex_Drain takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Vortex_Drain=CreateTrigger()

call TriggerRegisterTimerExpireEventBJ(gg_trg_Vortex_Drain,udg_VortexTimer)

call TriggerAddAction(gg_trg_Vortex_Drain,function Trig_Vortex_Drain_Actions)

endfunction




endlibrary
