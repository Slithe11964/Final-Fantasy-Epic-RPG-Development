library TMaelstrom
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Maelstrom_Cast=null
endglobals

function Trig_Maelstrom_Cast_Cond_IsMaelstrom takes nothing returns boolean
    return(GetSpellAbilityId()=='A0V7')or(GetSpellAbilityId()=='A0YM') // 'A0V7': ability "Maelstrom"; 'A0YM': ability "!Maelstrom"
endfunction

function Trig_Maelstrom_Cast_Conditions takes nothing returns boolean
    return(Trig_Maelstrom_Cast_Cond_IsMaelstrom())
endfunction

function Trig_Maelstrom_Cast_Cond_PointCast takes nothing returns boolean
    return(GetSpellTargetUnit()==null)
endfunction

function Trig_Maelstrom_Cast_Actions takes nothing returns nothing
    if(Trig_Maelstrom_Cast_Cond_PointCast())then
        set udg_TempPoint=GetSpellTargetLoc()
    else
        set udg_TempPoint=GetUnitLoc(GetSpellTargetUnit())
    endif
    call CreateNUnitsAtLocFacingLocBJ(1,'h01B',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,udg_TempPoint) // 'h01B': unit "Proxy Dummy"
    set udg_TempHandleId=GetHandleIdBJ(GetLastCreatedUnit())
    call SaveUnitHandleBJ(GetTriggerUnit(),0,udg_TempHandleId,udg_ProxyDamageHash)
    call SaveIntegerBJ(3,2,udg_TempHandleId,udg_ProxyDamageHash)
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(20.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A0JI',GetLastCreatedUnit()) // 'A0JI': ability "Maelstrom"
    call IssuePointOrderLocBJ(GetLastCreatedUnit(),"deathanddecay",udg_TempPoint)
    call RemoveLocation(udg_TempPoint)
endfunction

// World Editor calls InitTrig_Maelstrom automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Maelstrom (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Maelstrom takes nothing returns nothing
endfunction

function Register_Maelstrom_Cast takes nothing returns nothing
    set gg_trg_Maelstrom_Cast=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Maelstrom_Cast,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Maelstrom_Cast,Condition(function Trig_Maelstrom_Cast_Conditions))
    call TriggerAddAction(gg_trg_Maelstrom_Cast,function Trig_Maelstrom_Cast_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Maelstrom takes nothing returns nothing
    call Register_Maelstrom_Cast()
endfunction

endlibrary
