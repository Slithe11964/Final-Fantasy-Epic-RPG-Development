library TBossLilith requires TCam, TCine, TGroup, TReward, TText
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
    call DisableTrigger(GetTriggeringTrigger())
    if(Trig_Boss_Lilith_Death_Cond_TrackKill())then
        set udg_BossUnit=GetTriggerUnit()
        call ConditionalTriggerExecute(gg_trg_Speedrun_Accolade)
    endif
    call GroupRemoveUnitSimple(gg_unit_e009_0118,udg_BossUnits)
    call ForGroupBJ(Group_UnitsOfPlayerAndType(Player($B),'e00A'),function Trig_Boss_Lilith_Death_Enum_RemoveShadowMaiden) // $B = 11; 'e00A': unit "Shadow Maiden"
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateItemLoc('I0KW',udg_TempPoint) // 'I0KW': item "Siphoning Staff"
    call RemoveLocation(udg_TempPoint)
    if(Trig_Boss_Lilith_Death_Cond_CinematicsEnabled())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Reward_Give(5000,5000,null)
        call Text_Say(null,"|n|cffffcc00All players get 5000 gold and 5000 exp.|r",true)
        call Cine_ExitAction()
    else
        call Reward_Give(5000,5000,gg_unit_Eill_0119)
    endif
    set udg_TempPoint=GetRectCenter(gg_rct_641)
    if(Trig_Boss_Lilith_Death_Cond_RamzaDead())then
        call ReviveHeroLoc(gg_unit_Eill_0119,udg_TempPoint,false)
        call SetUnitFacingTimed(gg_unit_Eill_0119,bj_UNIT_FACING,0)
    else
        call SetUnitPositionLocFacingBJ(gg_unit_Eill_0119,udg_TempPoint,bj_UNIT_FACING)
        call SetUnitLifePercentBJ(gg_unit_Eill_0119,'d')
        call UnitRemoveBuffsBJ(bj_REMOVEBUFFS_ALL,gg_unit_Eill_0119)
    endif
    call RemoveLocation(udg_TempPoint)
    call SetUnitOwner(gg_unit_Eill_0119,Player(8),true)
    call SetUnitInvulnerable(gg_unit_Eill_0119,true)
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_COMPLETED,"Quest Completed: |cffffcc00Holy Knight|r")
    call QuestSetCompletedBJ(udg_SideQuest[31],true)
    set udg_QuestsCompleted=(udg_QuestsCompleted+1)
    call SaveIntegerBJ(1,2,'g',udg_GameStateHash)
    call StartTimerBJ(udg_AlmaDisappearTimer,false,300.)
    call EnableTrigger(gg_trg_Alma_Disappear)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function InitTrig_Boss_Lilith takes nothing returns nothing
endfunction

endlibrary
