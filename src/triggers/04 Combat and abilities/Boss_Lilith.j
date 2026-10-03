library TBossLilith requires TCam, TCine, TGroup, TReward, TText
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Boss_Lilith_Death=null
endglobals

function Trig_Boss_Lilith_Death_Cond_TrackKill takes nothing returns boolean
    return(udg_SpeedrunMode)
endfunction

function Trig_Boss_Lilith_Death_Enum_RemoveShadowMaiden takes nothing returns nothing
    call RemoveUnit(GetEnumUnit())
endfunction

function Trig_Boss_Lilith_Death_Cond_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Boss_Lilith_Death_Cond_RamzaDead takes nothing returns boolean
    return(IsUnitDeadBJ(gg_unit_Eill_0119))
endfunction

function Trig_Boss_Lilith_Death_Actions takes nothing returns nothing
    local location l_tempPoint
    call DisableTrigger(GetTriggeringTrigger())
    if(Trig_Boss_Lilith_Death_Cond_TrackKill())then
        set udg_BossUnit=GetTriggerUnit()
        call ConditionalTriggerExecute(gg_trg_Speedrun_Accolade)
    endif
    call GroupRemoveUnitSimple(gg_unit_e009_0118,udg_BossUnits)
    call ForGroupBJ(Group_UnitsOfPlayerAndType(Player($B),'e00A'),function Trig_Boss_Lilith_Death_Enum_RemoveShadowMaiden) // $B = 11; 'e00A': unit "Shadow Maiden"
    set l_tempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateItemLoc('I0KW',l_tempPoint) // 'I0KW': item "Siphoning Staff"
    call RemoveLocation(l_tempPoint)
    if(Trig_Boss_Lilith_Death_Cond_CinematicsEnabled())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Reward_Give(5000,5000,null)
        call Text_Say(null,"|n|cffffcc00All players get 5000 gold and 5000 exp.|r",true)
        call Cine_ExitAction()
    else
        call Reward_Give(5000,5000,gg_unit_Eill_0119)
    endif
    set l_tempPoint=GetRectCenter(gg_rct_641)
    if(Trig_Boss_Lilith_Death_Cond_RamzaDead())then
        call ReviveHeroLoc(gg_unit_Eill_0119,l_tempPoint,false)
        call SetUnitFacingTimed(gg_unit_Eill_0119,bj_UNIT_FACING,0)
    else
        call SetUnitPositionLocFacingBJ(gg_unit_Eill_0119,l_tempPoint,bj_UNIT_FACING)
        call SetUnitLifePercentBJ(gg_unit_Eill_0119,'d')
        call UnitRemoveBuffsBJ(bj_REMOVEBUFFS_ALL,gg_unit_Eill_0119)
    endif
    call RemoveLocation(l_tempPoint)
    call SetUnitOwner(gg_unit_Eill_0119,Player(8),true)
    call SetUnitInvulnerable(gg_unit_Eill_0119,true)
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_COMPLETED,"Quest Completed: |cffffcc00Holy Knight|r")
    call QuestSetCompletedBJ(udg_SideQuest[31],true)
    set udg_QuestsCompleted=(udg_QuestsCompleted+1)
    call SaveIntegerBJ(1,2,'g',udg_GameStateHash)
    call StartTimerBJ(udg_AlmaDisappearTimer,false,300.)
    call EnableTrigger(gg_trg_Alma_Disappear)
    call DestroyTrigger(GetTriggeringTrigger())
    set l_tempPoint=null
endfunction

function InitTrig_Boss_Lilith takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Boss_Part9 (module Boss),
// which keeps the original registration order.

function Register_Boss_Lilith_Death takes nothing returns nothing
    set gg_trg_Boss_Lilith_Death=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_Lilith_Death)
    call TriggerRegisterUnitEvent(gg_trg_Boss_Lilith_Death,gg_unit_e009_0118,EVENT_UNIT_DEATH)
    call TriggerAddAction(gg_trg_Boss_Lilith_Death,function Trig_Boss_Lilith_Death_Actions)
endfunction

endlibrary
