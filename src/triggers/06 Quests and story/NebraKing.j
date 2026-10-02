library TNebraKing requires TLoc, TWait
function Trig_NebraKing_Hide_Actions takes nothing returns nothing
    call ShowUnitHide(gg_unit_H02W_0246)
    call SetUnitInvulnerable(gg_unit_H02W_0246,true)
    call PauseUnitBJ(true,gg_unit_H02W_0246)
    set udg_NebraKingLife=.0
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_NebraKing_Summon_Conditions takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='I0FH') // 'I0FH': item "The Nebra King"
endfunction

function Trig_NebraKing_Summon_Cond_QuestNotStarted takes nothing returns boolean
    return(IsQuestDiscovered(udg_SideQuest[48])==false)
endfunction

function Trig_NebraKing_Summon_Cond_KingVisible takes nothing returns boolean
    return(IsUnitHiddenBJ(gg_unit_H02W_0246)==false)
endfunction

function Trig_NebraKing_Summon_Cond_MaxLifeTooLow takes nothing returns boolean
    return(GetUnitStateSwap(UNIT_STATE_MAX_LIFE,gg_unit_H02W_0246)<udg_NebraKingLife)
endfunction

function Trig_NebraKing_Summon_Cond_HasStoredLife takes nothing returns boolean
    return(udg_NebraKingLife>.0)
endfunction

function Trig_NebraKing_Summon_Actions takes nothing returns nothing
    set udg_NebraKingSpot=udg_PlayerFishSpot[udg_TempInteger]
    if(Trig_NebraKing_Summon_Cond_QuestNotStarted())then
        call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_DISCOVERED,"New Quest Received: |cffffcc00King of the Sea|r")
        set udg_SideQuest[48]=CreateQuestBJ(bj_QUESTTYPE_REQ_DISCOVERED,(udg_QuestNamePrefix+"King of the Sea"),"Defeat the Nebra King!","ReplaceableTextures\\CommandButtons\\BTNMurlocFlesheater.blp")
        call EnableTrigger(gg_trg_Quest_KingOfSea_Slain)
    else
        call QuestSetDescriptionBJ(udg_SideQuest[48],"Kill the Nebra King!")
        call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_UPDATED,"Kill the Nebra King.")
    endif
    if(Trig_NebraKing_Summon_Cond_KingVisible())then
        set udg_TempPoint=GetUnitLoc(gg_unit_H02W_0246)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Objects\\Spawnmodels\\Naga\\NagaDeath\\NagaDeath.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
    endif
    // (facing in degrees of the triggering unit) plus (180).
    set udg_TempReal=(GetUnitFacing(GetTriggerUnit())+180.)
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,256,udg_TempReal)
    call RemoveLocation(udg_TempPoint)
    call AddSpecialEffectLocBJ(udg_TempPoint2,"Objects\\Spawnmodels\\Naga\\NagaDeath\\NagaDeath.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call SetUnitPositionLocFacingLocBJ(gg_unit_H02W_0246,udg_TempPoint2,udg_TempPoint)
    call RemoveLocation(udg_TempPoint2)
    if(Trig_NebraKing_Summon_Cond_HasStoredLife())then
        if(Trig_NebraKing_Summon_Cond_MaxLifeTooLow())then
            // (udg_NebraKingLife) with its decimal part removed.
            call BlzSetUnitMaxHP(gg_unit_H02W_0246,R2I(udg_NebraKingLife))
        endif
        call SetUnitLifeBJ(gg_unit_H02W_0246,udg_NebraKingLife)
    else
        set udg_NebraKingLife=GetUnitStateSwap(UNIT_STATE_LIFE,gg_unit_H02W_0246)
    endif
    call SetUnitManaPercentBJ(gg_unit_H02W_0246,'d')
    call ShowUnitShow(gg_unit_H02W_0246)
    call SetUnitInvulnerable(gg_unit_H02W_0246,false)
    call PauseUnitBJ(false,gg_unit_H02W_0246)
    call IssueImmediateOrderBJ(gg_unit_H02W_0246,"spiritwolf")
    call GroupAddUnitSimple(gg_unit_H02W_0246,udg_BossGroup)
    call GroupAddUnitSimple(gg_unit_H02W_0246,udg_BossUnits)
    call StartTimerBJ(udg_NebraKingTimer,false,120.)
    call EnableTrigger(gg_trg_NebraKing_Escape)
endfunction

function Trig_NebraKing_Escape_Cond_LifeDropped takes nothing returns boolean
    return(udg_NebraKingLife>.0)and(udg_NebraKingLife>GetUnitStateSwap(UNIT_STATE_LIFE,gg_unit_H02W_0246))
endfunction

function Trig_NebraKing_Escape_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call SetUnitInvulnerable(gg_unit_H02W_0246,true)
    call PauseUnitBJ(true,gg_unit_H02W_0246)
    if(Trig_NebraKing_Escape_Cond_LifeDropped())then
        set udg_NebraKingLife=GetUnitStateSwap(UNIT_STATE_LIFE,gg_unit_H02W_0246)
    endif
    set udg_TempPoint=GetUnitLoc(gg_unit_H02W_0246)
    call AddSpecialEffectLocBJ(udg_TempPoint,"Objects\\Spawnmodels\\Naga\\NagaDeath\\NagaDeath.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=$A // $A = 10
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        // (loop counter A treated as a decimal-capable number) times (36).
        set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,256,(I2R(GetForLoopIndexA())*36.))
        call AddSpecialEffectLocBJ(udg_TempPoint2,"Objects\\Spawnmodels\\Naga\\NagaDeath\\NagaDeath.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint2)
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    call RemoveLocation(udg_TempPoint)
    call Wait_Polled(.5)
    call ShowUnitHide(gg_unit_H02W_0246)
    call GroupRemoveUnitSimple(gg_unit_H02W_0246,udg_BossGroup)
    call GroupRemoveUnitSimple(gg_unit_H02W_0246,udg_BossUnits)
    call QuestSetDescriptionBJ(udg_SideQuest[48],"The Nebra King has disappeared! Find him again!")
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_UPDATED,"Find the Nebra King again.")
    set udg_DispelTarget=gg_unit_H02W_0246
    call ConditionalTriggerExecute(gg_trg_Remove_Debuffs)
    call ConditionalTriggerExecute(gg_trg_Remove_Buffs)
endfunction

// World Editor calls InitTrig_NebraKing automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_NebraKing (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_NebraKing takes nothing returns nothing
endfunction

function Register_NebraKing_Hide takes nothing returns nothing
    set gg_trg_NebraKing_Hide=CreateTrigger()
    call TriggerAddAction(gg_trg_NebraKing_Hide,function Trig_NebraKing_Hide_Actions)
endfunction

function Register_NebraKing_Summon takes nothing returns nothing
    set gg_trg_NebraKing_Summon=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_NebraKing_Summon,EVENT_PLAYER_UNIT_PICKUP_ITEM)
    call TriggerAddCondition(gg_trg_NebraKing_Summon,Condition(function Trig_NebraKing_Summon_Conditions))
    call TriggerAddAction(gg_trg_NebraKing_Summon,function Trig_NebraKing_Summon_Actions)
endfunction

function Register_NebraKing_Escape takes nothing returns nothing
    set gg_trg_NebraKing_Escape=CreateTrigger()
    call DisableTrigger(gg_trg_NebraKing_Escape)
    call TriggerRegisterTimerExpireEventBJ(gg_trg_NebraKing_Escape,udg_NebraKingTimer)
    call TriggerAddAction(gg_trg_NebraKing_Escape,function Trig_NebraKing_Escape_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_NebraKing takes nothing returns nothing
    call Register_NebraKing_Hide()
    call Register_NebraKing_Summon()
    call Register_NebraKing_Escape()
endfunction

endlibrary
