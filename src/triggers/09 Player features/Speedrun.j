library TSpeedrun requires TForce, TTime
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Speedrun_Announce=null
    trigger gg_trg_Speedrun_FirstCast=null
    trigger gg_trg_Speedrun_Accolade=null
    trigger gg_trg_Speedrun_Record=null
endglobals

function Trig_Speedrun_Announce_HasNoLoadedSave takes nothing returns boolean
    return(udg_SpeedrunLevel[GetConvertedPlayerId(GetFilterPlayer())]<=0)
endfunction

function Trig_Speedrun_Announce_IsSpeedrunMode takes nothing returns boolean
    return(udg_SpeedrunMode)
endfunction

function Trig_Speedrun_Announce_Actions takes nothing returns nothing
    set udg_SpeedrunStarted=true
    set udg_SpeedrunFlag[3]=false
    call StartTimerBJ(udg_GameClock,false,3600.)
    if(Trig_Speedrun_Announce_IsSpeedrunMode())then
        call EnableTrigger(gg_trg_Multiboard_Title)
        set udg_TempForce=Force_Matching(Condition(function Trig_Speedrun_Announce_HasNoLoadedSave))
        call DisplayTimedTextToForce(udg_TempForce,30,"First Speedrunner's Challenge: Defeat Cid in less than 2 minutes of game time!")
        call DestroyForce(udg_TempForce)
    else
        call DestroyTrigger(gg_trg_Multiboard_Title)
    endif
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Speedrun_FirstCast_Conditions takes nothing returns boolean
    return((IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_STRUCTURE)==false))!=null
endfunction

function Trig_Speedrun_FirstCast_SpeedrunNotStarted takes nothing returns boolean
    return(udg_SpeedrunStarted==false)
endfunction

function Trig_Speedrun_FirstCast_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    if(Trig_Speedrun_FirstCast_SpeedrunNotStarted())then
        call ConditionalTriggerExecute(gg_trg_Speedrun_Announce)
    endif
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Speedrun_Accolade_BossIsEchele takes nothing returns boolean
    return(udg_BossUnit==udg_EcheleBoss)
endfunction

function Trig_Speedrun_Accolade_BossIsHero takes nothing returns boolean
    return(IsUnitType(udg_BossUnit,UNIT_TYPE_HERO))!=null
endfunction

function Trig_Speedrun_Accolade_HasBoss takes nothing returns boolean
    return(udg_BossUnit!=null)
endfunction

function Trig_Speedrun_Accolade_IsTrioGame takes nothing returns boolean
    return(udg_ActivePlayerCount==3)
endfunction

function Trig_Speedrun_Accolade_IsDuoGame takes nothing returns boolean
    return(udg_ActivePlayerCount==2)
endfunction

function Trig_Speedrun_Accolade_IsSoloGame takes nothing returns boolean
    return(udg_ActivePlayerCount==1)
endfunction

function Trig_Speedrun_Accolade_NoLoads takes nothing returns boolean
    return(udg_SpeedrunFlag[0]==false)
endfunction

function Trig_Speedrun_Accolade_NoDeaths takes nothing returns boolean
    return(udg_SpeedrunFlag[1]==false)
endfunction

function Trig_Speedrun_Accolade_UsedWC3Saves takes nothing returns boolean
    return(udg_SpeedrunFlag[2])
endfunction

function Trig_Speedrun_Accolade_SingleJobOnly takes nothing returns boolean
    return(udg_SpeedrunFlag[3]==false)
endfunction

function Trig_Speedrun_Accolade_NoGear takes nothing returns boolean
    return(udg_SpeedrunFlag[4]==false)
endfunction

function Trig_Speedrun_Accolade_NoConsumables takes nothing returns boolean
    return(udg_SpeedrunFlag[5]==false)
endfunction

function Trig_Speedrun_Accolade_Actions takes nothing returns nothing
    call DisplayTimedTextToForce(GetPlayersAll(),60.,"|cff7f7fff- - - Speedrunner Accolade 0.9.7.3 - - -|r")
    if(Trig_Speedrun_Accolade_HasBoss())then
        if(Trig_Speedrun_Accolade_BossIsHero())then
            if(Trig_Speedrun_Accolade_BossIsEchele())then
                set udg_TempString=(("|cff2020b0Echele Level "+I2S(GetHeroLevel(udg_EcheleBoss)))+"|r defeated in |cffffcc00")
            else
                set udg_TempString=(("|cffff4040"+GetHeroProperName(udg_BossUnit))+"|r defeated in |cffffcc00")
            endif
        else
            set udg_TempString=(("|cffff4040"+GetUnitName(udg_BossUnit))+"|r defeated in |cffffcc00")
        endif
        call StartTimerBJ(udg_AccoladeTimer,false,.01)
    endif
    set udg_TempString=udg_TempString+Time_ElapsedString()
    call DisplayTimedTextToForce(GetPlayersAll(),60.,udg_TempString)
    if(Trig_Speedrun_Accolade_IsSoloGame())then
        set udg_TempString="|cffffcc00Solo Game"
    else
        if(Trig_Speedrun_Accolade_IsDuoGame())then
            set udg_TempString="|cffffcc00Duo Game"
        else
            if(Trig_Speedrun_Accolade_IsTrioGame())then
                set udg_TempString="|cffffcc00Trio Game"
            else
                set udg_TempString="|cffffcc00Team Game"
            endif
        endif
    endif
    set udg_TempString=(udg_DifficultyName+(", "+udg_TempString))
    if(Trig_Speedrun_Accolade_NoLoads())then
        set udg_TempString=(udg_TempString+", Loadless")
    endif
    if(Trig_Speedrun_Accolade_NoDeaths())then
        set udg_TempString=(udg_TempString+", Deathless")
    endif
    if(Trig_Speedrun_Accolade_UsedWC3Saves())then
        set udg_TempString=(udg_TempString+", With WC3 Saves")
    endif
    if(Trig_Speedrun_Accolade_SingleJobOnly())then
        set udg_TempString=(udg_TempString+", Single Job Only")
    endif
    if(Trig_Speedrun_Accolade_NoGear())then
        set udg_TempString=(udg_TempString+", No Gear")
    endif
    if(Trig_Speedrun_Accolade_NoConsumables())then
        set udg_TempString=(udg_TempString+", No Consumables")
    endif
    call DisplayTimedTextToForce(GetPlayersAll(),60.,udg_TempString)
    call DisplayTimedTextToForce(GetPlayersAll(),60.," ")
endfunction

function Trig_Speedrun_Record_Conditions takes nothing returns boolean
    return(udg_BossUnit!=null)
endfunction

function Trig_Speedrun_Record_NeedsRankUp takes nothing returns boolean
    return(udg_SpeedrunLevel[GetConvertedPlayerId(GetEnumPlayer())]==(GetForLoopIndexA()-1))and(IsPlayerInForce(GetEnumPlayer(),udg_TitleForce[(udg_SpeedrunTitleBase+GetForLoopIndexA())])==false)
endfunction

function Trig_Speedrun_Record_AwardRank takes nothing returns nothing
    if(Trig_Speedrun_Record_NeedsRankUp())then
        set udg_SpeedrunLevel[GetConvertedPlayerId(GetEnumPlayer())]=GetForLoopIndexA()
        set udg_TempPlayer=GetEnumPlayer()
        set udg_TempInteger=(udg_SpeedrunTitleBase+GetForLoopIndexA())
        call ConditionalTriggerExecute(gg_trg_Title_Grant)
    endif
endfunction

function Trig_Speedrun_Record_BeatRecordTime takes nothing returns boolean
    return(udg_BossUnit==udg_SpeedrunBoss[GetForLoopIndexA()])and(TimerGetElapsed(udg_GameClock)<udg_SpeedrunTimeLimit[GetForLoopIndexA()])
endfunction

function Trig_Speedrun_Record_PastTimeLimit takes nothing returns boolean
    return(udg_GameHours>0)
endfunction

function Trig_Speedrun_Record_Actions takes nothing returns nothing
    if(Trig_Speedrun_Record_PastTimeLimit())then
        call DisableTrigger(GetTriggeringTrigger())
        call DestroyTrigger(GetTriggeringTrigger())
    else
        set bj_forLoopAIndex=1
        set bj_forLoopAIndexEnd=5
        loop
            exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
            if(Trig_Speedrun_Record_BeatRecordTime())then
                call ForForce(udg_PlayingPlayers,function Trig_Speedrun_Record_AwardRank)
            endif
            set bj_forLoopAIndex=bj_forLoopAIndex+1
        endloop
    endif
endfunction

// World Editor calls InitTrig_Speedrun automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Speedrun_Part1 / RegisterTriggers_Speedrun_Part2 (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Speedrun takes nothing returns nothing
endfunction

function Register_Speedrun_Announce takes nothing returns nothing
    set gg_trg_Speedrun_Announce=CreateTrigger()
    call DisableTrigger(gg_trg_Speedrun_Announce)
    call TriggerAddAction(gg_trg_Speedrun_Announce,function Trig_Speedrun_Announce_Actions)
endfunction

function Register_Speedrun_FirstCast takes nothing returns nothing
    set gg_trg_Speedrun_FirstCast=CreateTrigger()
    call DisableTrigger(gg_trg_Speedrun_FirstCast)
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Speedrun_FirstCast,EVENT_PLAYER_UNIT_SPELL_CAST)
    call TriggerAddCondition(gg_trg_Speedrun_FirstCast,Condition(function Trig_Speedrun_FirstCast_Conditions))
    call TriggerAddAction(gg_trg_Speedrun_FirstCast,function Trig_Speedrun_FirstCast_Actions)
endfunction

function Register_Speedrun_Accolade takes nothing returns nothing
    set gg_trg_Speedrun_Accolade=CreateTrigger()
    call DisableTrigger(gg_trg_Speedrun_Accolade)
    call TriggerAddAction(gg_trg_Speedrun_Accolade,function Trig_Speedrun_Accolade_Actions)
endfunction

function Register_Speedrun_Record takes nothing returns nothing
    set gg_trg_Speedrun_Record=CreateTrigger()
    call DisableTrigger(gg_trg_Speedrun_Record)
    call TriggerRegisterTimerExpireEventBJ(gg_trg_Speedrun_Record,udg_AccoladeTimer)
    call TriggerAddCondition(gg_trg_Speedrun_Record,Condition(function Trig_Speedrun_Record_Conditions))
    call TriggerAddAction(gg_trg_Speedrun_Record,function Trig_Speedrun_Record_Actions)
endfunction

// Creates part 1 of 2 of this module's triggers. Called once at startup from
// Startup_RegisterTriggers (MapBootstrap). The parts are registered at different points so that
// triggers sharing an event with other modules keep their original firing order.
function RegisterTriggers_Speedrun_Part1 takes nothing returns nothing
    call Register_Speedrun_Announce() // starts off; run by Speedrun, Cid
    call Register_Speedrun_FirstCast() // starts off; enabled by Game
endfunction

// Creates part 2 of 2 of this module's triggers. Called once at startup from
// Startup_RegisterTriggers (MapBootstrap). The parts are registered at different points so that
// triggers sharing an event with other modules keep their original firing order.
function RegisterTriggers_Speedrun_Part2 takes nothing returns nothing
    call Register_Speedrun_Accolade() // starts off; run by AlmightyShinra, Arena_Duel, Boss_BlackDevil +35 more
    call Register_Speedrun_Record() // starts off; enabled by GameMode
endfunction

endlibrary
