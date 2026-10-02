library TQuestCrossbow requires TForce, TGroup
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

endlibrary
