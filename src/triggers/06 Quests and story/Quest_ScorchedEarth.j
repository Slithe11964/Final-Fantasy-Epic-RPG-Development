library TQuestScorchedEarth requires TCam, TCine, TMusic, TPlayerPart01, TReward, TText, TWait
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Quest_ScorchedEarth_Start=null
    trigger gg_trg_Quest_ScorchedEarth_End=null
endglobals

function Trig_Quest_ScorchedEarth_Start_Conditions takes nothing returns boolean
    return(udg_InCinematicMode==false)
endfunction

function Trig_Quest_ScorchedEarth_Start_Actions takes nothing returns nothing
    call DisableTrigger(gg_trg_ScorchedEarth_EnterRegion)
    call DisableTrigger(gg_trg_ScorchedEarth_TowerAttack)
    call DestroyTrigger(gg_trg_ScorchedEarth_EnterRegion)
    call DestroyTrigger(gg_trg_ScorchedEarth_TowerAttack)
    call EnableTrigger(gg_trg_ScorchedEarth_HeatFade)
    call Cine_Enter()
    call Wait_Polled(1.)
    call Text_Say(udg_CinematicActor,"What the hell happened here!?",true)
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_DISCOVERED,"New Quest Received: |cffffcc00Scorched Earth|r")
    set udg_SideQuest[52]=CreateQuestBJ(bj_QUESTTYPE_REQ_DISCOVERED,(udg_QuestTitleRed+"Scorched Earth"),"The icy realm has turned into an infernal hell! Climb to the top of the (former) Snowy Mountain to see if you can find the cause.","ReplaceableTextures\\CommandButtons\\BTNDoomGuard.blp")
    call EnableTrigger(gg_trg_ScorchedEarth_Barrier)
    call Music_SetZoneTrack(34)
    call Cine_ExitAction()
endfunction

function Trig_Quest_ScorchedEarth_End_Cond_TrackBossKill takes nothing returns boolean
    return(udg_SpeedrunMode)
endfunction

function Trig_Quest_ScorchedEarth_End_Cond_KilledByPlayer takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetKillingUnitBJ()),udg_PlayingPlayers))
endfunction

function Trig_Quest_ScorchedEarth_End_GiveCrystalShards takes nothing returns nothing
    call AdjustPlayerStateBJ(6,GetEnumPlayer(),PLAYER_STATE_RESOURCE_LUMBER)
endfunction

function Trig_Quest_ScorchedEarth_End_Cond_NotRewarded takes nothing returns boolean
    return(IsPlayerInForce(GetEnumPlayer(),udg_TitleForce[29])==false)
endfunction

function Trig_Quest_ScorchedEarth_End_Reward_EachPlayer takes nothing returns nothing
    if(Trig_Quest_ScorchedEarth_End_Cond_NotRewarded())then
        set udg_TempPlayer=GetEnumPlayer()
        set udg_TempInteger=29
        call ConditionalTriggerExecute(gg_trg_Title_Grant)
    endif
endfunction

function Trig_Quest_ScorchedEarth_End_Cond_BoardEmpty takes nothing returns boolean
    return(udg_HuntCounter[0]<=0)
endfunction

function Trig_Quest_ScorchedEarth_End_Cond_NoHuntActive takes nothing returns boolean
    return(udg_OkuuStage==0)
endfunction

function Trig_Quest_ScorchedEarth_End_Cond_HuntCountLow takes nothing returns boolean
    return(udg_OkuuStage<2)
endfunction

function Trig_Quest_ScorchedEarth_End_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call GroupRemoveUnitSimple(gg_unit_U00Q_0023,udg_BossGroup)
    call GroupRemoveUnitSimple(gg_unit_U00Q_0023,udg_BossUnits)
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call ReviveHeroLoc(gg_unit_U00Q_0023,udg_TempPoint,false)
    call RemoveLocation(udg_TempPoint)
    call DisableTrigger(gg_trg_McBurn_Arena_Return)
    call DestroyTrigger(gg_trg_McBurn_Arena_Return)
    call Cine_Enter()
    if(Trig_Quest_ScorchedEarth_End_Cond_TrackBossKill())then
        set udg_BossUnit=GetTriggerUnit()
        call ConditionalTriggerExecute(gg_trg_Speedrun_Accolade)
    endif
    call Cam_PanToUnit(gg_unit_U00Q_0023,.0)
    call Wait_Polled(2)
    call Text_Say(gg_unit_U00Q_0023,"Hahaha... I am most impressed. I really am.",true)
    call Text_Say(gg_unit_U00Q_0023,"I admit defeat. You've fought incredibly.",true)
    if(Trig_Quest_ScorchedEarth_End_Cond_KilledByPlayer())then
        set udg_TempPlayer=GetOwningPlayer(GetKillingUnitBJ())
    else
        set udg_TempPlayer=ForcePickRandomPlayer(udg_PlayingPlayers)
    endif
    call Text_Say(Player_GetHero(udg_TempPlayer),"*pant* *pant*",true)
    call Text_Say(gg_unit_U00Q_0023,"Haha, my bad. I'll leave your world alone. Here, you can have this.",true)
    call Text_Say(null,"|n|cffffcc00All players get 66666 gold and 6 crystal shards.|r",true)
    call Reward_Give(66666,0,null)
    call ForForce(udg_PlayingPlayers,function Trig_Quest_ScorchedEarth_End_GiveCrystalShards)
    call Text_Say(gg_unit_U00Q_0023,"See ya.",true)
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Other\\Doom\\DoomDeath.mdl")
    call BlzSetSpecialEffectScale(GetLastCreatedEffectBJ(),7.)
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call CreateItemLoc('I0HU',udg_TempPoint) // 'I0HU': item "Angbar"
    call RemoveLocation(udg_TempPoint)
    call RemoveUnit(gg_unit_U00Q_0023)
    call Wait_Polled(2.)
    call ConditionalTriggerExecute(gg_trg_IcyRealm_Restore)
    call CinematicFadeBJ(bj_CINEFADETYPE_FADEIN,1.,"ReplaceableTextures\\CameraMasks\\White_mask.blp",0,0,100.,0)
    call Wait_Polled(2.)
    call Text_Say(Player_GetHero(udg_TempPlayer),"*pant* *pant* He's gone...",true)
    call Text_Say(Player_GetHero(udg_TempPlayer),"What a completely insane demon...",true)
    call Text_Say(Player_GetHero(udg_TempPlayer),"Hahaha... but what a fight that was.",true)
    call Cine_ExitAction()
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_COMPLETED,"Quest Completed: |cffffcc00Scorched Earth|r")
    call QuestSetCompletedBJ(udg_SideQuest[52],true)
    set udg_QuestsCompleted=(udg_QuestsCompleted+1)
    call Music_ClearTrack(35)
    call Music_SetZoneTrack($C) // $C = 12
    call ConditionalTriggerExecute(gg_trg_Promotion_Award_Random)
    call ForForce(udg_PlayingPlayers,function Trig_Quest_ScorchedEarth_End_Reward_EachPlayer)
    if(Trig_Quest_ScorchedEarth_End_Cond_HuntCountLow())then
        if(Trig_Quest_ScorchedEarth_End_Cond_NoHuntActive())then
            call RemoveUnitFromStockBJ('n0NF',gg_unit_nsw2_0056) // 'n0NF': unit "Hunt: Okuu"
            set udg_HuntStock[$A]=(udg_HuntStock[$A]-1) // $A = 10
            call ConditionalTriggerExecute(gg_trg_Hunt_Board_Markers)
        else
            call GroupRemoveUnitSimple(udg_HuntTarget[28],udg_HuntMonsters)
            call GroupRemoveUnitSimple(udg_HuntTarget[28],udg_BossGroup)
            call DisableTrigger(gg_trg_Okuu_Death)
            call DestroyTrigger(gg_trg_Okuu_Death)
            call LeaderboardRemovePlayerItemBJ(ConvertedPlayer(28),udg_HuntLeaderboard)
            call SaveIntegerBJ(0,8,28,udg_HuntData)
            set udg_HuntCounter[0]=(udg_HuntCounter[0]-1)
            if(Trig_Quest_ScorchedEarth_End_Cond_BoardEmpty())then
                call LeaderboardDisplayBJ(false,udg_HuntLeaderboard)
            endif
            call ForceAddPlayerSimple(ConvertedPlayer(28),udg_HuntSlots)
            call RemoveUnit(udg_HuntTarget[28])
        endif
    endif
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function InitTrig_Quest_ScorchedEarth takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Quest_Part16 (module Quest),
// which keeps the original registration order.

function Register_Quest_ScorchedEarth_Start takes nothing returns nothing
    set gg_trg_Quest_ScorchedEarth_Start=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_ScorchedEarth_Start)
    call TriggerAddCondition(gg_trg_Quest_ScorchedEarth_Start,Condition(function Trig_Quest_ScorchedEarth_Start_Conditions))
    call TriggerAddAction(gg_trg_Quest_ScorchedEarth_Start,function Trig_Quest_ScorchedEarth_Start_Actions)
endfunction

function Register_Quest_ScorchedEarth_End takes nothing returns nothing
    set gg_trg_Quest_ScorchedEarth_End=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_ScorchedEarth_End)
    call TriggerRegisterUnitEvent(gg_trg_Quest_ScorchedEarth_End,gg_unit_U00Q_0023,EVENT_UNIT_DEATH)
    call TriggerAddAction(gg_trg_Quest_ScorchedEarth_End,function Trig_Quest_ScorchedEarth_End_Actions)
endfunction

endlibrary
