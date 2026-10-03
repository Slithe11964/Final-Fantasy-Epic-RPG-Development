library TTower requires TWait
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Tower_Summon_Register=null
    trigger gg_trg_Tower_Quezacotl_Unregister=null
    trigger gg_trg_Tower_Buy_RestoreMP=null
    trigger gg_trg_Tower_Summon_Brothers=null
    trigger gg_trg_Tower_Summon_Eden=null
    trigger gg_trg_Tower_Eden_Expire=null
    trigger gg_trg_Tower_Upgrade_Credit=null
endglobals

function Trig_Tower_Summon_Register_Conditions takes nothing returns boolean
    return((GetOwningPlayer(GetTriggerUnit())==Player($A))and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_SUMMONED))and(GetUnitTypeId(GetTriggerUnit())!='n08D'))!=null // $A = 10; 'n08D': unit "Interceptor"
endfunction

function Trig_Tower_Summon_Register_Cond_IsQuezacotl takes nothing returns boolean
    return(GetUnitTypeId(GetTriggerUnit())=='n01Z') // 'n01Z': unit "Quezacotl"
endfunction

function Trig_Tower_Summon_Register_Actions takes nothing returns nothing
    call RemoveGuardPosition(GetTriggerUnit())
    if(Trig_Tower_Summon_Register_Cond_IsQuezacotl())then
        call GroupAddUnitSimple(GetTriggerUnit(),udg_ShockAuraUnitGroup)
    endif
    set udg_TempUnit2=GetTriggerUnit()
    call ConditionalTriggerExecute(gg_trg_Summon_Powerup)
endfunction

function Trig_Tower_Quezacotl_Unregister_Conditions takes nothing returns boolean
    return(GetUnitTypeId(GetTriggerUnit())=='n01Z') // 'n01Z': unit "Quezacotl"
endfunction

function Trig_Tower_Quezacotl_Unregister_Actions takes nothing returns nothing
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_ShockAuraUnitGroup)
endfunction

function Trig_Tower_Buy_RestoreMP_Conditions takes nothing returns boolean
    return(GetUnitTypeId(GetSoldUnit())=='n088') // 'n088': unit "Restore MP"
endfunction

function Trig_Tower_Buy_RestoreMP_Actions takes nothing returns nothing
    call ShowUnitHide(GetSoldUnit())
    call UnitApplyTimedLifeBJ(.3,'BTLF',GetSoldUnit()) // 'BTLF': object name not found in map data
    // (current mana of the triggering unit) plus (1000).
    call SetUnitManaBJ(GetTriggerUnit(),(GetUnitStateSwap(UNIT_STATE_MANA,GetTriggerUnit())+1000.))
    call AddSpecialEffectTargetUnitBJ("origin",GetTriggerUnit(),"Abilities\\Spells\\Items\\AIma\\AImaTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call AddSpecialEffectTargetUnitBJ("origin",GetBuyingUnit(),"Abilities\\Spells\\Human\\ManaFlare\\ManaFlareBoltImpact.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
endfunction

function Trig_Tower_Summon_Brothers_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A09M') // 'A09M': ability "Brothers"
endfunction

function Trig_Tower_Summon_Brothers_Actions takes nothing returns nothing
    local location l_tempPoint
    set l_tempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateNUnitsAtLoc(1,'o009',GetOwningPlayer(GetSpellAbilityUnit()),l_tempPoint,bj_UNIT_FACING) // 'o009': unit "Minotaur"
    call RemoveLocation(l_tempPoint)
    call AddSpecialEffectTargetUnitBJ("origin",GetLastCreatedUnit(),"Abilities\\Spells\\Orc\\FeralSpirit\\feralspiritdone.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call UnitApplyTimedLifeBJ(180.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    set l_tempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateNUnitsAtLoc(1,'o008',GetOwningPlayer(GetSpellAbilityUnit()),l_tempPoint,bj_UNIT_FACING) // 'o008': unit "Sacred"
    call RemoveLocation(l_tempPoint)
    call AddSpecialEffectTargetUnitBJ("origin",GetLastCreatedUnit(),"Abilities\\Spells\\Orc\\FeralSpirit\\feralspiritdone.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call UnitApplyTimedLifeBJ(180.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call ShowUnitHide(gg_unit_Ocbh_0148)
    call ShowUnitHide(gg_unit_Ocb2_0147)
    call Wait_Polled(180.)
    call ShowUnitShow(gg_unit_Ocbh_0148)
    call ShowUnitShow(gg_unit_Ocb2_0147)
    set l_tempPoint=null
endfunction

function Trig_Tower_Summon_Eden_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A0CE') // 'A0CE': ability "Eden"
endfunction

function Trig_Tower_Summon_Eden_Actions takes nothing returns nothing
    local location l_tempPoint
    set l_tempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateNUnitsAtLoc(1,'h022',GetOwningPlayer(GetSpellAbilityUnit()),l_tempPoint,bj_UNIT_FACING) // 'h022': unit "Eden"
    call RemoveLocation(l_tempPoint)
    call AddSpecialEffectTargetUnitBJ("origin",GetLastCreatedUnit(),"Abilities\\Spells\\Orc\\FeralSpirit\\feralspiritdone.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call UnitApplyTimedLifeBJ(180.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call SetUnitVertexColorBJ(GetLastCreatedUnit(),'d',50.,'d',15.)
    set l_tempPoint=null
endfunction

function Trig_Tower_Eden_Expire_Conditions takes nothing returns boolean
    return(GetUnitTypeId(GetTriggerUnit())=='h022') // 'h022': unit "Eden"
endfunction

function Trig_Tower_Eden_Expire_Actions takes nothing returns nothing
    call AddSpecialEffectTargetUnitBJ("origin",GetTriggerUnit(),"Abilities\\Spells\\Orc\\FeralSpirit\\feralspiritdone.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveUnit(GetTriggerUnit())
endfunction

function Trig_Tower_Upgrade_Credit_Conditions takes nothing returns boolean
    return(IsQuestCompleted(udg_SideQuest[30]))and(IsQuestCompleted(udg_SideQuest[7]))and(IsQuestCompleted(udg_SideQuest[34]))and(IsQuestCompleted(udg_SideQuest[33]))
endfunction

function Trig_Tower_Upgrade_Credit_Cond_PlayerMissingCredit takes nothing returns boolean
    return(IsPlayerInForce(GetEnumPlayer(),udg_TitleForce[31])==false)and(IsPlayerInForce(GetEnumPlayer(),udg_TitleForce[30]))
endfunction

function Trig_Tower_Upgrade_Credit_Enum_GrantUpgradeCredit takes nothing returns nothing
    if(Trig_Tower_Upgrade_Credit_Cond_PlayerMissingCredit())then
        set udg_TempPlayer=GetEnumPlayer()
        set udg_TempInteger=31
        call ConditionalTriggerExecute(gg_trg_Title_Grant)
    endif
endfunction

function Trig_Tower_Upgrade_Credit_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call ForceAddPlayerSimple(Player($A),udg_TitleForce[31]) // $A = 10
    call ForForce(udg_PlayingPlayers,function Trig_Tower_Upgrade_Credit_Enum_GrantUpgradeCredit)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_Tower automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Tower (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Tower takes nothing returns nothing
endfunction

function Register_Tower_Summon_Register takes nothing returns nothing
    set gg_trg_Tower_Summon_Register=CreateTrigger()
    call TriggerRegisterEnterRectSimple(gg_trg_Tower_Summon_Register,GetPlayableMapRect())
    call TriggerAddCondition(gg_trg_Tower_Summon_Register,Condition(function Trig_Tower_Summon_Register_Conditions))
    call TriggerAddAction(gg_trg_Tower_Summon_Register,function Trig_Tower_Summon_Register_Actions)
endfunction

function Register_Tower_Quezacotl_Unregister takes nothing returns nothing
    set gg_trg_Tower_Quezacotl_Unregister=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Tower_Quezacotl_Unregister,EVENT_PLAYER_UNIT_DEATH)
    call TriggerAddCondition(gg_trg_Tower_Quezacotl_Unregister,Condition(function Trig_Tower_Quezacotl_Unregister_Conditions))
    call TriggerAddAction(gg_trg_Tower_Quezacotl_Unregister,function Trig_Tower_Quezacotl_Unregister_Actions)
endfunction

function Register_Tower_Buy_RestoreMP takes nothing returns nothing
    set gg_trg_Tower_Buy_RestoreMP=CreateTrigger()
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_Tower_Buy_RestoreMP,Player($A),EVENT_PLAYER_UNIT_SELL) // $A = 10
    call TriggerAddCondition(gg_trg_Tower_Buy_RestoreMP,Condition(function Trig_Tower_Buy_RestoreMP_Conditions))
    call TriggerAddAction(gg_trg_Tower_Buy_RestoreMP,function Trig_Tower_Buy_RestoreMP_Actions)
endfunction

function Register_Tower_Summon_Brothers takes nothing returns nothing
    set gg_trg_Tower_Summon_Brothers=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Tower_Summon_Brothers,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Tower_Summon_Brothers,Condition(function Trig_Tower_Summon_Brothers_Conditions))
    call TriggerAddAction(gg_trg_Tower_Summon_Brothers,function Trig_Tower_Summon_Brothers_Actions)
endfunction

function Register_Tower_Summon_Eden takes nothing returns nothing
    set gg_trg_Tower_Summon_Eden=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Tower_Summon_Eden,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Tower_Summon_Eden,Condition(function Trig_Tower_Summon_Eden_Conditions))
    call TriggerAddAction(gg_trg_Tower_Summon_Eden,function Trig_Tower_Summon_Eden_Actions)
endfunction

function Register_Tower_Eden_Expire takes nothing returns nothing
    set gg_trg_Tower_Eden_Expire=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Tower_Eden_Expire,EVENT_PLAYER_UNIT_DEATH)
    call TriggerAddCondition(gg_trg_Tower_Eden_Expire,Condition(function Trig_Tower_Eden_Expire_Conditions))
    call TriggerAddAction(gg_trg_Tower_Eden_Expire,function Trig_Tower_Eden_Expire_Actions)
endfunction

function Register_Tower_Upgrade_Credit takes nothing returns nothing
    set gg_trg_Tower_Upgrade_Credit=CreateTrigger()
    call TriggerRegisterTimerEventPeriodic(gg_trg_Tower_Upgrade_Credit,5.)
    call TriggerAddCondition(gg_trg_Tower_Upgrade_Credit,Condition(function Trig_Tower_Upgrade_Credit_Conditions))
    call TriggerAddAction(gg_trg_Tower_Upgrade_Credit,function Trig_Tower_Upgrade_Credit_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Tower takes nothing returns nothing
    call Register_Tower_Summon_Register()
    call Register_Tower_Quezacotl_Unregister()
    call Register_Tower_Buy_RestoreMP()
    call Register_Tower_Summon_Brothers()
    call Register_Tower_Summon_Eden()
    call Register_Tower_Eden_Expire()
    call Register_Tower_Upgrade_Credit()
endfunction

endlibrary
