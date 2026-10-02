library TSeeker requires TWait
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Seeker_Teleport_Cast=null
endglobals

function Trig_Seeker_Teleport_Cast_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A102') // 'A102': ability "!Teleport"
endfunction

function Trig_Seeker_Teleport_Cast_Cond_TeleportBlocked takes nothing returns boolean
    return(udg_DmgFlagUnavoidable>0)
endfunction

function Trig_Seeker_Teleport_Cast_Actions takes nothing returns nothing
    set udg_DmgFlagUnavoidable=0
    if(Trig_Seeker_Teleport_Cast_Cond_TeleportBlocked())then
        set udg_DmgFlagUnavoidable=0
        call AddSpecialEffectTargetUnitBJ("chest",GetSpellTargetUnit(),"Abilities\\Spells\\Items\\SpellShieldAmulet\\SpellShieldCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
    else
        set udg_TempPoint=GetUnitLoc(GetSpellTargetUnit())
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportTarget.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        // A random whole number from 1 through LoadIntegerBJ(4, 2, udg_SpawnDataHashRef).
        set udg_TempPoint=GetRandomLocInRect(LoadRectHandleBJ(GetRandomInt(1,LoadIntegerBJ(4,2,udg_SpawnDataHashRef)),4,udg_SpawnRectHashRef))
        call SetUnitPositionLoc(GetSpellTargetUnit(),udg_TempPoint)
        call RemoveLocation(udg_TempPoint)
        call AddSpecialEffectTargetUnitBJ("origin",GetTriggerUnit(),"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportTarget.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
    endif
    call Wait_Polled(4.)
    // A random whole number from 1 through LoadIntegerBJ(4, 2, udg_SpawnDataHashRef).
    set udg_TempPoint=GetRandomLocInRect(LoadRectHandleBJ(GetRandomInt(1,LoadIntegerBJ(4,2,udg_SpawnDataHashRef)),4,udg_SpawnRectHashRef))
    call IssuePointOrderLocBJ(GetTriggerUnit(),"patrol",udg_TempPoint)
    call RemoveLocation(udg_TempPoint)
endfunction

// World Editor calls InitTrig_Seeker automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Seeker (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Seeker takes nothing returns nothing
endfunction

function Register_Seeker_Teleport_Cast takes nothing returns nothing
    set gg_trg_Seeker_Teleport_Cast=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Seeker_Teleport_Cast,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Seeker_Teleport_Cast,Condition(function Trig_Seeker_Teleport_Cast_Conditions))
    call TriggerAddAction(gg_trg_Seeker_Teleport_Cast,function Trig_Seeker_Teleport_Cast_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Seeker takes nothing returns nothing
    call Register_Seeker_Teleport_Cast()
endfunction

endlibrary
