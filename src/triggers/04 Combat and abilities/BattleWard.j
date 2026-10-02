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

// Registration ownership; called at the original bootstrap positions.
function InitTrig_BattleWard takes nothing returns nothing
endfunction
function RegisterR11_BattleWard_Enter takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_BattleWard_Enter=CreateTrigger()
    call TriggerRegisterEnterRectSimple(gg_trg_BattleWard_Enter,GetPlayableMapRect())
    call TriggerAddCondition(gg_trg_BattleWard_Enter,Condition(function Trig_BattleWard_Enter_Conditions))
    call TriggerAddAction(gg_trg_BattleWard_Enter,function Trig_BattleWard_Enter_Actions)
endfunction
function RegisterR11_BattleWard_Death takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_BattleWard_Death=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_BattleWard_Death,EVENT_PLAYER_UNIT_DEATH)
    call TriggerAddCondition(gg_trg_BattleWard_Death,Condition(function Trig_BattleWard_Death_Conditions))
    call TriggerAddAction(gg_trg_BattleWard_Death,function Trig_BattleWard_Death_Actions)
endfunction




endlibrary
