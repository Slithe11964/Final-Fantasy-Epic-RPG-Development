library TOakaIV requires TWait
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_OakaIV_CutTrees=null
    trigger gg_trg_OakaIV_ReachNorthTree=null
    trigger gg_trg_OakaIV_ReachSouthTree=null
    trigger gg_trg_OakaIV_NorthTreeFelled=null
    trigger gg_trg_OakaIV_SouthTreeFelled=null
endglobals

function Trig_OakaIV_CutTrees_Cond_CutNorthValid takes nothing returns boolean
    return(GetSpellAbilityId()=='A0GE')and(IsDestructableAliveBJ(gg_dest_B002_0040)) // 'A0GE': ability "Cut North"
endfunction

function Trig_OakaIV_CutTrees_Cond_CutSouthValid takes nothing returns boolean
    return(GetSpellAbilityId()=='A0GF')and(IsDestructableAliveBJ(gg_dest_B002_0026)) // 'A0GF': ability "Cut South"
endfunction

function Trig_OakaIV_CutTrees_Cond_CutOrderValid takes nothing returns boolean
    return(Trig_OakaIV_CutTrees_Cond_CutNorthValid())or(Trig_OakaIV_CutTrees_Cond_CutSouthValid())
endfunction

function Trig_OakaIV_CutTrees_Conditions takes nothing returns boolean
    return(Trig_OakaIV_CutTrees_Cond_CutOrderValid())and(udg_InCinematicMode==false)
endfunction

function Trig_OakaIV_CutTrees_Cond_CutNorth takes nothing returns boolean
    return(GetSpellAbilityId()=='A0GE') // 'A0GE': ability "Cut North"
endfunction

function Trig_OakaIV_CutTrees_Cond_CutSouth takes nothing returns boolean
    return(GetSpellAbilityId()=='A0GF') // 'A0GF': ability "Cut South"
endfunction

function Trig_OakaIV_CutTrees_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    if(Trig_OakaIV_CutTrees_Cond_CutNorth())then
        set udg_TempPoint=GetRectCenter(gg_rct_490)
        call EnableTrigger(gg_trg_OakaIV_ReachNorthTree)
    endif
    if(Trig_OakaIV_CutTrees_Cond_CutSouth())then
        set udg_TempPoint=GetRectCenter(gg_rct_491)
        call EnableTrigger(gg_trg_OakaIV_ReachSouthTree)
    endif
    call IssuePointOrderLocBJ(gg_unit_n02F_0108,"move",udg_TempPoint)
    call RemoveLocation(udg_TempPoint)
    call UnitRemoveAbilityBJ('Ane2',gg_unit_n02F_0108) // 'Ane2': object name not found in map data
    call UnitRemoveAbilityBJ('A0GE',gg_unit_n02F_0108) // 'A0GE': ability "Cut North"
    call UnitRemoveAbilityBJ('A0GF',gg_unit_n02F_0108) // 'A0GF': ability "Cut South"
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_OakaIV_ReachNorthTree_Conditions takes nothing returns boolean
    return(GetTriggerUnit()==gg_unit_n02F_0108)
endfunction

function Trig_OakaIV_ReachNorthTree_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call SetDestructableInvulnerableBJ(gg_dest_B002_0040,false)
    call EnableTrigger(gg_trg_OakaIV_NorthTreeFelled)
    call Wait_Polled(.2)
    call IssueTargetDestructableOrder(gg_unit_n02F_0108,"attack",gg_dest_B002_0040)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_OakaIV_ReachSouthTree_Conditions takes nothing returns boolean
    return(GetTriggerUnit()==gg_unit_n02F_0108)
endfunction

function Trig_OakaIV_ReachSouthTree_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call SetDestructableInvulnerableBJ(gg_dest_B002_0026,false)
    call EnableTrigger(gg_trg_OakaIV_SouthTreeFelled)
    call Wait_Polled(.2)
    call IssueTargetDestructableOrder(gg_unit_n02F_0108,"attack",gg_dest_B002_0026)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_OakaIV_NorthTreeFelled_Actions takes nothing returns nothing
    local location l_tempPoint
    call DisableTrigger(GetTriggeringTrigger())
    call KillDestructable(gg_dest_ITtw_0037)
    call KillDestructable(gg_dest_ITtw_0043)
    call KillDestructable(gg_dest_ITtw_0034)
    call KillDestructable(gg_dest_ITtw_0035)
    call KillDestructable(gg_dest_ITtw_0036)
    call Wait_Polled(2)
    set l_tempPoint=GetUnitLoc(gg_unit_n02F_0108)
    call AddSpecialEffectLocBJ(l_tempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(l_tempPoint)
    set l_tempPoint=GetRectCenter(gg_rct_482)
    call SetUnitPositionLocFacingBJ(gg_unit_n02F_0108,l_tempPoint,.0)
    call AddSpecialEffectLocBJ(l_tempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(l_tempPoint)
    call DestroyTrigger(GetTriggeringTrigger())
    set l_tempPoint=null
endfunction

function Trig_OakaIV_SouthTreeFelled_Actions takes nothing returns nothing
    local location l_tempPoint
    call DisableTrigger(GetTriggeringTrigger())
    call KillDestructable(gg_dest_ITtw_0039)
    call KillDestructable(gg_dest_ITtw_0041)
    call KillDestructable(gg_dest_ITtw_0018)
    call KillDestructable(gg_dest_ITtw_0059)
    call Wait_Polled(2)
    set l_tempPoint=GetUnitLoc(gg_unit_n02F_0108)
    call AddSpecialEffectLocBJ(l_tempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(l_tempPoint)
    set l_tempPoint=GetRectCenter(gg_rct_482)
    call SetUnitPositionLocFacingBJ(gg_unit_n02F_0108,l_tempPoint,.0)
    call AddSpecialEffectLocBJ(l_tempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(l_tempPoint)
    call DestroyTrigger(GetTriggeringTrigger())
    set l_tempPoint=null
endfunction

// World Editor calls InitTrig_OakaIV automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_OakaIV (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_OakaIV takes nothing returns nothing
endfunction

function Register_OakaIV_CutTrees takes nothing returns nothing
    set gg_trg_OakaIV_CutTrees=CreateTrigger()
    call DisableTrigger(gg_trg_OakaIV_CutTrees)
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_OakaIV_CutTrees,Player(8),EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_OakaIV_CutTrees,Condition(function Trig_OakaIV_CutTrees_Conditions))
    call TriggerAddAction(gg_trg_OakaIV_CutTrees,function Trig_OakaIV_CutTrees_Actions)
endfunction

function Register_OakaIV_ReachNorthTree takes nothing returns nothing
    set gg_trg_OakaIV_ReachNorthTree=CreateTrigger()
    call DisableTrigger(gg_trg_OakaIV_ReachNorthTree)
    call TriggerRegisterEnterRectSimple(gg_trg_OakaIV_ReachNorthTree,gg_rct_490)
    call TriggerAddCondition(gg_trg_OakaIV_ReachNorthTree,Condition(function Trig_OakaIV_ReachNorthTree_Conditions))
    call TriggerAddAction(gg_trg_OakaIV_ReachNorthTree,function Trig_OakaIV_ReachNorthTree_Actions)
endfunction

function Register_OakaIV_ReachSouthTree takes nothing returns nothing
    set gg_trg_OakaIV_ReachSouthTree=CreateTrigger()
    call DisableTrigger(gg_trg_OakaIV_ReachSouthTree)
    call TriggerRegisterEnterRectSimple(gg_trg_OakaIV_ReachSouthTree,gg_rct_491)
    call TriggerAddCondition(gg_trg_OakaIV_ReachSouthTree,Condition(function Trig_OakaIV_ReachSouthTree_Conditions))
    call TriggerAddAction(gg_trg_OakaIV_ReachSouthTree,function Trig_OakaIV_ReachSouthTree_Actions)
endfunction

function Register_OakaIV_NorthTreeFelled takes nothing returns nothing
    set gg_trg_OakaIV_NorthTreeFelled=CreateTrigger()
    call DisableTrigger(gg_trg_OakaIV_NorthTreeFelled)
    call TriggerRegisterDeathEvent(gg_trg_OakaIV_NorthTreeFelled,gg_dest_B002_0040)
    call TriggerAddAction(gg_trg_OakaIV_NorthTreeFelled,function Trig_OakaIV_NorthTreeFelled_Actions)
endfunction

function Register_OakaIV_SouthTreeFelled takes nothing returns nothing
    set gg_trg_OakaIV_SouthTreeFelled=CreateTrigger()
    call DisableTrigger(gg_trg_OakaIV_SouthTreeFelled)
    call TriggerRegisterDeathEvent(gg_trg_OakaIV_SouthTreeFelled,gg_dest_B002_0026)
    call TriggerAddAction(gg_trg_OakaIV_SouthTreeFelled,function Trig_OakaIV_SouthTreeFelled_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_OakaIV takes nothing returns nothing
    call Register_OakaIV_CutTrees() // starts off; enabled by HauntedTree
    call Register_OakaIV_ReachNorthTree() // starts off; enabled by OakaIV
    call Register_OakaIV_ReachSouthTree() // starts off; enabled by OakaIV
    call Register_OakaIV_NorthTreeFelled() // starts off; enabled by OakaIV
    call Register_OakaIV_SouthTreeFelled() // starts off; enabled by OakaIV
endfunction

endlibrary
