library TGameMode requires TGroup, TUnit, TWait
function Trig_GameMode_Apply_HideModeDialog takes nothing returns nothing
    call DialogDisplayBJ(false,udg_VoteDialog,GetEnumPlayer())
endfunction

function Trig_GameMode_Apply_IsTopVote takes nothing returns boolean
    return(udg_VoteCount[GetForLoopIndexA()]>0)and(udg_VoteCount[GetForLoopIndexA()]>udg_TopVoteCount)
endfunction

function Trig_GameMode_Apply_NoVotes takes nothing returns boolean
    return(udg_VotesCast==0)
endfunction

function Trig_GameMode_Apply_IsHardcore takes nothing returns boolean
    return(udg_WinningOption==3)
endfunction

function Trig_GameMode_Apply_IsSpeedrun takes nothing returns boolean
    return(udg_WinningOption==2)
endfunction

function Trig_GameMode_Apply_FilterNotHero takes nothing returns boolean
    return(IsUnitType(GetFilterUnit(),UNIT_TYPE_HERO)==false)!=null
endfunction

function Trig_GameMode_Apply_FilterUnderLevel60 takes nothing returns boolean
    return(GetUnitLevel(GetFilterUnit())<60)
endfunction

function Trig_GameMode_Apply_FilterEternityTarget takes nothing returns boolean
    return GetBooleanOr(Trig_GameMode_Apply_FilterNotHero(),Trig_GameMode_Apply_FilterUnderLevel60())
endfunction

function Trig_GameMode_Apply_ScaleEnumUnit takes nothing returns nothing
    call Unit_ScaleToLevel60(GetEnumUnit())
endfunction

function Trig_GameMode_Apply_IsEternity takes nothing returns boolean
    return(udg_WinningOption==1)
endfunction

function Trig_GameMode_Apply_IsNormal takes nothing returns boolean
    return(udg_WinningOption==0)
endfunction

function Trig_GameMode_Apply_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DisableTrigger(gg_trg_Vote_GameMode_Click)
    call PauseTimerBJ(true,udg_VoteTimer)
    call ForForce(udg_PlayingPlayers,function Trig_GameMode_Apply_HideModeDialog)
    if(Trig_GameMode_Apply_NoVotes())then
        set udg_WinningOption=0
    else
        set udg_TopVoteCount=0
        set udg_WinningOption=0
        set bj_forLoopAIndex=0
        set bj_forLoopAIndexEnd=4
        loop
            exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
            if(Trig_GameMode_Apply_IsTopVote())then
                set udg_WinningOption=GetForLoopIndexA()
                set udg_TopVoteCount=udg_VoteCount[GetForLoopIndexA()]
            endif
            set bj_forLoopAIndex=bj_forLoopAIndex+1
        endloop
    endif
    set udg_HardcoreOff=true
    set udg_EternityMode=false
    set udg_ModeFlag=false
    set udg_HandicapHPScaling=true
    if(Trig_GameMode_Apply_IsNormal())then
        set udg_GameModeName="|cffffcc00Normal|r"
        call DisplayTimedTextToForce(GetPlayersAll(),15.,"Game Mode: |cffffcc00Normal|r")
        call UnitAddAbilityBJ('A06Y',udg_NarratorUnit) // 'A06Y': ability "Game Mode"
    else
        if(Trig_GameMode_Apply_IsEternity())then
            set udg_EternityMode=true
            set udg_GameModeName="|cff3fff3fEternity|r"
            call DisplayTimedTextToForce(GetPlayersAll(),15.,"Game Mode: |cff3fff3fEternity|r\r\nEnemies below Level 60 are heavily scaled up. EXP, Gold and Item drops are greatly increased.\r\nIt is highly recommended that you load a code.")
            call SetPlayerTechResearchedSwap('R00Y',1,Player($B)) // 'R00Y': upgrade "Attack Speed Eternity Boost"; $B = 11
            call UnitAddAbilityBJ('A17U',udg_NarratorUnit) // 'A17U': ability "Game Mode"
            call UnitAddAbilityBJ('S00N',udg_NarratorUnit) // 'S00N': ability "Attack Speed"
            set udg_HandicapHPScaling=false
            set udg_LevelItemIdTable[1]='I00X' // 'I00X': item "500 Gold Coins"
            set udg_LevelItemIdTable[2]='I00X' // 'I00X': item "500 Gold Coins"
            set udg_LevelItemIdTable[3]='I00Y' // 'I00Y': item "1000 Gold Coins"
            set udg_LevelItemIdTable[4]='I0B2' // 'I0B2': item "1250 Gold Coins"
            set udg_LevelItemIdTable[5]='I021' // 'I021': item "1500 Gold Coins"
            set udg_LevelItemIdTable[6]='I0B3' // 'I0B3': item "2000 Gold Coins"
            set udg_LevelItemIdTable[7]='I0JQ' // 'I0JQ': item "2500 Gold Coins"
            set udg_LevelItemIdTable[8]='I0JQ' // 'I0JQ': item "2500 Gold Coins"
            set udg_LevelItemIdTable[9]='I0JS' // 'I0JS': item "5000 Gold Coins"
            call EnableTrigger(gg_trg_Enemy_Summon_Setup)
            set udg_TempGroup=Group_UnitsOfPlayer(Player($B),Condition(function Trig_GameMode_Apply_FilterEternityTarget)) // $B = 11
            call ForGroupBJ(udg_TempGroup,function Trig_GameMode_Apply_ScaleEnumUnit)
            call DestroyGroup(udg_TempGroup)
            call Unit_ScaleToLevel60(gg_unit_Hpb1_0013)
        else
            if(Trig_GameMode_Apply_IsSpeedrun())then
                set udg_GameModeName="|cff7f7fffSpeedrun|r"
                set udg_ActivePlayerCount=CountPlayersInForceBJ(udg_PlayingPlayers)
                set udg_SpeedrunMode=true
                set udg_TextSpeed=.0
                set udg_CinematicsDisabled=true
                call DisableTrigger(gg_trg_TextSpeed_Command)
                call DisableTrigger(gg_trg_TextInstant_Command)
                call DisableTrigger(gg_trg_TextSkip_Command)
                call EnableTrigger(gg_trg_Speedrun_Record)
                call DisplayTimedTextToForce(GetPlayersAll(),15.,"Game Mode: |cff7f7fffSpeedrun|r\r\nTimes you on achieving certain ingame boss kills and quest clears. Prestige stat bonuses are disabled. Forces skipping of cinematics.")
                call UnitAddAbilityBJ('A138',udg_NarratorUnit) // 'A138': ability "Game Mode"
            else
                if(Trig_GameMode_Apply_IsHardcore())then
                    set udg_HardcoreOff=false
                    set udg_GameModeName="|cffff0000Hardcore|r"
                    call DisplayTimedTextToForce(GetPlayersAll(),15.,"Game Mode: |cffff0000Hardcore|r\r\nNo saving or loading. No reviving on death. No resets.")
                    call UnitAddAbilityBJ('A07W',udg_NarratorUnit) // 'A07W': ability "Game Mode"
                    set udg_SaveFlagUnitID[$91]='n0JS' // $91 = 145; 'n0JS': unit "Seitengrat"
                    set udg_RewardItem[22]='I0K7' // 'I0K7': item "Fading Note"
                    set udg_BonusValue[21]=$A // $A = 10
                    set udg_BonusText[21]="Your base primary attribute increases by 10!"
                    set udg_BonusValue[23]=$A // $A = 10
                    set udg_BonusText[23]="Your base primary attribute increases by 10!"
                else
                    call DisplayTimedTextToForce(GetPlayersAll(),15.,"Game Mode: |cff3fff3fScenario|r\r\nNot implemented yet.")
                    set udg_GameModeName="|cff3fff3fScenario|r"
                    call UnitAddAbilityBJ('A141',udg_NarratorUnit) // 'A141': ability "Game Mode"
                endif
            endif
        endif
    endif
    call Wait_Polled(2)
    call TriggerExecute(gg_trg_Vote_Difficulty_Show)
endfunction

// World Editor calls InitTrig_GameMode automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_GameMode (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_GameMode takes nothing returns nothing
endfunction

function Register_GameMode_Apply takes nothing returns nothing
    set gg_trg_GameMode_Apply=CreateTrigger()
    call DisableTrigger(gg_trg_GameMode_Apply)
    call TriggerRegisterTimerExpireEventBJ(gg_trg_GameMode_Apply,udg_VoteTimer)
    call TriggerAddAction(gg_trg_GameMode_Apply,function Trig_GameMode_Apply_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_GameMode takes nothing returns nothing
    call Register_GameMode_Apply()
endfunction

endlibrary
