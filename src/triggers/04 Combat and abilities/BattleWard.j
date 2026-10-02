library TBattleWard
function Trig_BattleWard_Enter_Conditions takes nothing returns boolean
    return(GetUnitName(GetTriggerUnit())=="Battle Ward")and(GetUnitTypeId(GetTriggerUnit())!='n05R') // 'n05R': unit "Battle Ward"
endfunction

function Trig_BattleWard_Enter_Actions takes nothing returns nothing
    call AddSpecialEffectTargetUnitBJ("origin",GetTriggerUnit(),"Abilities\\Spells\\Orc\\FeralSpirit\\feralspiritdone.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call SetUnitVertexColorBJ(GetTriggerUnit(),.0,.0,.0,50.)
    set udg_TempUnit2=GetTriggerUnit()
    call ConditionalTriggerExecute(gg_trg_Summon_Powerup)
endfunction

function Trig_BattleWard_Death_Conditions takes nothing returns boolean
    return(GetUnitName(GetTriggerUnit())=="Battle Ward")and(GetUnitTypeId(GetTriggerUnit())!='n05R') // 'n05R': unit "Battle Ward"
endfunction

function Trig_BattleWard_Death_Actions takes nothing returns nothing
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Orc\\MirrorImage\\MirrorImageDeathCaster.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(udg_TempPoint)
    call RemoveUnit(GetTriggerUnit())
endfunction

// World Editor calls InitTrig_BattleWard automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_BattleWard (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_BattleWard takes nothing returns nothing
endfunction

function Register_BattleWard_Enter takes nothing returns nothing
    set gg_trg_BattleWard_Enter=CreateTrigger()
    call TriggerRegisterEnterRectSimple(gg_trg_BattleWard_Enter,GetPlayableMapRect())
    call TriggerAddCondition(gg_trg_BattleWard_Enter,Condition(function Trig_BattleWard_Enter_Conditions))
    call TriggerAddAction(gg_trg_BattleWard_Enter,function Trig_BattleWard_Enter_Actions)
endfunction

function Register_BattleWard_Death takes nothing returns nothing
    set gg_trg_BattleWard_Death=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_BattleWard_Death,EVENT_PLAYER_UNIT_DEATH)
    call TriggerAddCondition(gg_trg_BattleWard_Death,Condition(function Trig_BattleWard_Death_Conditions))
    call TriggerAddAction(gg_trg_BattleWard_Death,function Trig_BattleWard_Death_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_BattleWard takes nothing returns nothing
    call Register_BattleWard_Enter()
    call Register_BattleWard_Death()
endfunction

endlibrary
