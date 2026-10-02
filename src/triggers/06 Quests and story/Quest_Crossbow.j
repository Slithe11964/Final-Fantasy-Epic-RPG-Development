library TQuestCrossbow requires TForce, TGroup
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Quest_Crossbow_NeedEnemies=null
    trigger gg_trg_Quest_Crossbow_Tested=null
endglobals

function Trig_Quest_Crossbow_NeedEnemies_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A0KB') // 'A0KB': ability "Arrowwave"
endfunction

function Trig_Quest_Crossbow_NeedEnemies_Cond_FilterAlive takes nothing returns boolean
    return(IsUnitAliveBJ(GetFilterUnit()))
endfunction

function Trig_Quest_Crossbow_NeedEnemies_Cond_FilterEnemy takes nothing returns boolean
    return(IsUnitEnemy(GetFilterUnit(),GetOwningPlayer(GetTriggerUnit())))
endfunction

function Trig_Quest_Crossbow_NeedEnemies_Cond_AliveEnemy takes nothing returns boolean
    return GetBooleanAnd(Trig_Quest_Crossbow_NeedEnemies_Cond_FilterAlive(),Trig_Quest_Crossbow_NeedEnemies_Cond_FilterEnemy())
endfunction

function Trig_Quest_Crossbow_NeedEnemies_Cond_FilterVulnerable takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('Avul',GetFilterUnit())<=0) // 'Avul': standard ability reference "Invulnerable"
endfunction

function Trig_Quest_Crossbow_NeedEnemies_Filter_ValidTarget takes nothing returns boolean
    return GetBooleanAnd(Trig_Quest_Crossbow_NeedEnemies_Cond_AliveEnemy(),Trig_Quest_Crossbow_NeedEnemies_Cond_FilterVulnerable())
endfunction

function Trig_Quest_Crossbow_NeedEnemies_Cond_NoEnemiesNear takes nothing returns boolean
    return(IsUnitGroupEmptyBJ(udg_TempGroup))
endfunction

function Trig_Quest_Crossbow_NeedEnemies_Actions takes nothing returns nothing
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    set udg_TempGroup=Group_UnitsInRangeOfLoc(800.,udg_TempPoint,Condition(function Trig_Quest_Crossbow_NeedEnemies_Filter_ValidTarget))
    call RemoveLocation(udg_TempPoint)
    if(Trig_Quest_Crossbow_NeedEnemies_Cond_NoEnemiesNear())then
        call DestroyGroup(udg_TempGroup)
        call PauseUnitBJ(true,GetTriggerUnit())
        call IssueImmediateOrderBJ(GetTriggerUnit(),"stop")
        call PauseUnitBJ(false,GetTriggerUnit())
        set udg_TempForce=Force_OfPlayer(GetOwningPlayer(GetTriggerUnit()))
        call DisplayTimedTextToForce(udg_TempForce,10.,"|cffff0000There must be enemies nearby to test the prototype!|r")
        call DestroyForce(udg_TempForce)
    else
        call DestroyGroup(udg_TempGroup)
    endif
endfunction

function Trig_Quest_Crossbow_Tested_Conditions takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='I0BQ')and(GetItemCharges(GetManipulatedItem())<1) // 'I0BQ': item "Prototype Crossbow"
endfunction

function Trig_Quest_Crossbow_Tested_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DisableTrigger(gg_trg_Quest_Crossbow_NeedEnemies)
    call DestroyTrigger(gg_trg_Quest_Crossbow_NeedEnemies)
    set udg_CrossbowAdviceGiven=true
    set udg_ItemUseReplacement=udg_QuestItem[28]
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_UPDATED,"You have sufficiently tested the Prototype Crossbow.")
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_UPDATED,"Report the test results to Mid.")
    call QuestItemSetDescriptionBJ(udg_QuestReq[9],"Report the test results to Mid.")
    call SetItemPawnable(udg_QuestItem[28],false)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function InitTrig_Quest_Crossbow takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Quest_Part20 (module Quest),
// which keeps the original registration order.

function Register_Quest_Crossbow_NeedEnemies takes nothing returns nothing
    set gg_trg_Quest_Crossbow_NeedEnemies=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_Crossbow_NeedEnemies)
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Quest_Crossbow_NeedEnemies,EVENT_PLAYER_UNIT_SPELL_CHANNEL)
    call TriggerAddCondition(gg_trg_Quest_Crossbow_NeedEnemies,Condition(function Trig_Quest_Crossbow_NeedEnemies_Conditions))
    call TriggerAddAction(gg_trg_Quest_Crossbow_NeedEnemies,function Trig_Quest_Crossbow_NeedEnemies_Actions)
endfunction

function Register_Quest_Crossbow_Tested takes nothing returns nothing
    set gg_trg_Quest_Crossbow_Tested=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_Crossbow_Tested)
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Quest_Crossbow_Tested,EVENT_PLAYER_UNIT_USE_ITEM)
    call TriggerAddCondition(gg_trg_Quest_Crossbow_Tested,Condition(function Trig_Quest_Crossbow_Tested_Conditions))
    call TriggerAddAction(gg_trg_Quest_Crossbow_Tested,function Trig_Quest_Crossbow_Tested_Actions)
endfunction

endlibrary
