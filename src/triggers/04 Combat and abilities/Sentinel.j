library TSentinel
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Sentinel_Cast=null
endglobals

function Trig_Sentinel_Cast_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A0ON') // 'A0ON': ability "!Sentinel"
endfunction

function Trig_Sentinel_Cast_Actions takes nothing returns nothing
    local location l_tempPoint
    set l_tempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateNUnitsAtLocFacingLocBJ(1,'h02S',GetOwningPlayer(GetTriggerUnit()),l_tempPoint,l_tempPoint) // 'h02S': unit "Simple Casting Dummy"
    call RemoveLocation(l_tempPoint)
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(1.5,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A1BJ',GetLastCreatedUnit()) // 'A1BJ': ability "Sentinel"
    call SetUnitAbilityLevelSwapped('A1BJ',GetLastCreatedUnit(),GetUnitAbilityLevelSwapped(GetSpellAbilityId(),GetTriggerUnit())) // 'A1BJ': ability "Sentinel"
    call IssueTargetOrderBJ(GetLastCreatedUnit(),"bloodlust",GetTriggerUnit())
    set l_tempPoint=null
endfunction

// World Editor calls InitTrig_Sentinel automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Sentinel (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Sentinel takes nothing returns nothing
endfunction

function Register_Sentinel_Cast takes nothing returns nothing
    set gg_trg_Sentinel_Cast=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Sentinel_Cast,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Sentinel_Cast,Condition(function Trig_Sentinel_Cast_Conditions))
    call TriggerAddAction(gg_trg_Sentinel_Cast,function Trig_Sentinel_Cast_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Sentinel takes nothing returns nothing
    call Register_Sentinel_Cast()
endfunction

endlibrary
