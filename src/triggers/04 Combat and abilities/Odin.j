library TOdin requires TBerserk, TWait
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Odin_Escort_Teleport=null
    trigger gg_trg_Odin_Leash_Arena=null
endglobals

function Trig_Odin_Escort_Teleport_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A00W') // 'A00W': ability "Support Teleport"
endfunction

function Trig_Odin_Escort_Teleport_Cond_CasterVulnerable takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('Avul',GetTriggerUnit())<=0) // 'Avul': standard ability reference "Invulnerable"
endfunction

function Trig_Odin_Escort_Teleport_Actions takes nothing returns nothing
    call Wait_Polled(2.9)
    if(Trig_Odin_Escort_Teleport_Cond_CasterVulnerable())then
        set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportTarget.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        call AddSpecialEffectTargetUnitBJ("origin",GetTriggerUnit(),"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportTarget.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call AddSpecialEffectTargetUnitBJ("origin",gg_unit_H01M_0071,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportTarget.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        set udg_TempPoint=GetUnitLoc(gg_unit_H01M_0071)
        call SetUnitPositionLocFacingBJ(GetTriggerUnit(),udg_TempPoint,GetUnitFacing(gg_unit_H01M_0071))
        call RemoveLocation(udg_TempPoint)
    endif
endfunction

function Trig_Odin_Leash_Arena_Conditions takes nothing returns boolean
    return(GetTriggerUnit()==gg_unit_H01M_0071)
endfunction

function Trig_Odin_Leash_Arena_Actions takes nothing returns nothing
    local location l_tempPoint
    set l_tempPoint=GetUnitLoc(GetTriggerUnit())
    call AddSpecialEffectLocBJ(l_tempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(l_tempPoint)
    set l_tempPoint=GetRectCenter(gg_rct_677)
    call SetUnitPositionLocFacingBJ(GetTriggerUnit(),l_tempPoint,270.)
    call RemoveLocation(l_tempPoint)
    call AddSpecialEffectTargetUnitBJ("origin",GetTriggerUnit(),"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call Berserk_Remove(GetTriggerUnit())
    // Result 1: current health divided by maximum health for the triggering unit, times 100 (or 0 if the unit is
    // missing or its maximum is 0).
    // Result 2: (result 1) plus (5).
    call SetUnitLifePercentBJ(GetTriggerUnit(),(GetUnitLifePercent(GetTriggerUnit())+5.))
    set l_tempPoint=null
endfunction

// World Editor calls InitTrig_Odin automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Odin (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Odin takes nothing returns nothing
endfunction

function Register_Odin_Escort_Teleport takes nothing returns nothing
    set gg_trg_Odin_Escort_Teleport=CreateTrigger()
    call DisableTrigger(gg_trg_Odin_Escort_Teleport)
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Odin_Escort_Teleport,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Odin_Escort_Teleport,Condition(function Trig_Odin_Escort_Teleport_Conditions))
    call TriggerAddAction(gg_trg_Odin_Escort_Teleport,function Trig_Odin_Escort_Teleport_Actions)
endfunction

function Register_Odin_Leash_Arena takes nothing returns nothing
    set gg_trg_Odin_Leash_Arena=CreateTrigger()
    call DisableTrigger(gg_trg_Odin_Leash_Arena)
    call TriggerRegisterEnterRectSimple(gg_trg_Odin_Leash_Arena,gg_rct_710)
    call TriggerAddCondition(gg_trg_Odin_Leash_Arena,Condition(function Trig_Odin_Leash_Arena_Conditions))
    call TriggerAddAction(gg_trg_Odin_Leash_Arena,function Trig_Odin_Leash_Arena_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Odin takes nothing returns nothing
    call Register_Odin_Escort_Teleport() // starts off; enabled by Boss_Odin; disabled by Boss_Odin; destroyed by Boss_Odin
    call Register_Odin_Leash_Arena() // starts off; enabled by Boss_Odin; disabled by Boss_Odin; destroyed by Boss_Odin
endfunction

endlibrary
