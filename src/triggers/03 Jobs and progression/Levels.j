library TLevels requires TForce, TJob
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Levels_Command=null
endglobals

function Trig_Levels_Command_Cond_HasNewGamePlus takes nothing returns boolean
    return(udg_NewGamePlusLevel[GetConvertedPlayerId(GetTriggerPlayer())]>0)
endfunction

function Trig_Levels_Command_Cond_ExtraJobsUnlocked takes nothing returns boolean
    return(udg_DarkJobsUnlocked)
endfunction

function Trig_Levels_Command_Cond_FreelancerMaxLevel takes nothing returns boolean
    return(udg_ShrineUnlocked)and(GetHeroLevel(udg_FreelancerHero[GetConvertedPlayerId(GetTriggerPlayer())])==99)and(GetUnitAbilityLevelSwapped('A02F',udg_FreelancerHero[GetConvertedPlayerId(GetTriggerPlayer())])>3) // 'A02F': ability "Mastery"
endfunction

function Trig_Levels_Command_Cond_FreelancerUnlocked takes nothing returns boolean
    return(udg_ShrineUnlocked)
endfunction

function Trig_Levels_Command_Cond_JobMastered takes nothing returns boolean
    return(Job_GetSavedLevel(GetTriggerPlayer(),udg_JobUnitType[GetForLoopIndexA()])>=50)and(Job_GetSavedLevel(GetTriggerPlayer(),udg_JobUnitType[GetForLoopIndexA()])<=98)
endfunction

function Trig_Levels_Command_Cond_LastJobMastered takes nothing returns boolean
    return(Job_GetSavedLevel(GetTriggerPlayer(),udg_JobUnitType[GetForLoopIndexA()])>=50)and(Job_GetSavedLevel(GetTriggerPlayer(),udg_JobUnitType[GetForLoopIndexA()])<=98)
endfunction

function Trig_Levels_Command_Cond_FreelancerMastered takes nothing returns boolean
    return(udg_ShrineUnlocked)and(GetHeroLevel(udg_FreelancerHero[GetConvertedPlayerId(GetTriggerPlayer())])>=50)and(GetHeroLevel(udg_FreelancerHero[GetConvertedPlayerId(GetTriggerPlayer())])<=98)
endfunction

function Trig_Levels_Command_Cond_MasteredListFilled takes nothing returns boolean
    return(StringLength(udg_TempString)>25)
endfunction

function Trig_Levels_Command_Cond_JobUltimate takes nothing returns boolean
    return(Job_GetSavedLevel(GetTriggerPlayer(),udg_JobUnitType[GetForLoopIndexA()])==99)
endfunction

function Trig_Levels_Command_Cond_FreelancerUltimate takes nothing returns boolean
    return(udg_ShrineUnlocked)and(GetHeroLevel(udg_FreelancerHero[GetConvertedPlayerId(GetTriggerPlayer())])==99)and(GetUnitAbilityLevelSwapped('A02F',udg_FreelancerHero[GetConvertedPlayerId(GetTriggerPlayer())])==3) // 'A02F': ability "Mastery"
endfunction

function Trig_Levels_Command_Cond_UltimateListFilled takes nothing returns boolean
    return(StringLength(udg_TempString)>36)
endfunction

function Trig_Levels_Command_Cond_JobLegendary takes nothing returns boolean
    return(Job_GetSavedLevel(GetTriggerPlayer(),udg_JobUnitType[GetForLoopIndexA()])=='d')
endfunction

function Trig_Levels_Command_Cond_FreelancerLegendary takes nothing returns boolean
    return(udg_ShrineUnlocked)and(GetHeroLevel(udg_FreelancerHero[GetConvertedPlayerId(GetTriggerPlayer())])==99)and(GetUnitAbilityLevelSwapped('A02F',udg_FreelancerHero[GetConvertedPlayerId(GetTriggerPlayer())])>3) // 'A02F': ability "Mastery"
endfunction

function Trig_Levels_Command_Cond_LegendaryListFilled takes nothing returns boolean
    return(StringLength(udg_TempString)>37)
endfunction

function Trig_Levels_Command_Cond_LegendaryModeOn takes nothing returns boolean
    return(udg_LegendaryUnlocked)
endfunction

function Trig_Levels_Command_Actions takes nothing returns nothing
    set udg_TempForce=Force_OfPlayer(GetTriggerPlayer())
    if(Trig_Levels_Command_Cond_HasNewGamePlus())then
        call DisplayTimedTextToForce(udg_TempForce,20.,("|cffffdd22New Game Plus "+I2S(udg_NewGamePlusLevel[GetConvertedPlayerId(GetTriggerPlayer())])))
    endif
    set udg_TempString=""
    set bj_forLoopAIndex=0
    set bj_forLoopAIndexEnd=19
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        set udg_TempString=(((udg_TempString+"|cff00ffff")+udg_JobName[GetForLoopIndexA()])+(":|r |cffffcc00"+(I2S(Job_GetSavedLevel(GetTriggerPlayer(),udg_JobUnitType[GetForLoopIndexA()]))+"|r ")))
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    if(Trig_Levels_Command_Cond_ExtraJobsUnlocked())then
        set bj_forLoopAIndex=20
        set bj_forLoopAIndexEnd=21
        loop
            exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
            set udg_TempString=(((udg_TempString+"|cff00ffff")+udg_JobName[GetForLoopIndexA()])+(":|r |cffffcc00"+(I2S(Job_GetSavedLevel(GetTriggerPlayer(),udg_JobUnitType[GetForLoopIndexA()]))+"|r ")))
            set bj_forLoopAIndex=bj_forLoopAIndex+1
        endloop
    endif
    if(Trig_Levels_Command_Cond_FreelancerUnlocked())then
        if(Trig_Levels_Command_Cond_FreelancerMaxLevel())then
            set udg_TempString=(udg_TempString+"|cff00ffffFreelancer:|r |cffffcc00100|r")
        else
            set udg_TempString=(((udg_TempString+"|cff00ffff")+"Freelancer")+(":|r |cffffcc00"+(I2S(GetHeroLevel(udg_FreelancerHero[GetConvertedPlayerId(GetTriggerPlayer())]))+"|r ")))
        endif
    endif
    call DisplayTimedTextToForce(udg_TempForce,20.,udg_TempString)
    set udg_TempString="Jobs mastered: |cff00ffff"
    set bj_forLoopAIndex=0
    // (udg_JobCount) minus (1).
    set bj_forLoopAIndexEnd=(udg_JobCount-1)
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        if(Trig_Levels_Command_Cond_JobMastered())then
            set udg_TempString=((udg_TempString+udg_JobName[GetForLoopIndexA()])+" ")
        endif
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    if(Trig_Levels_Command_Cond_LastJobMastered())then
        set udg_TempString=((udg_TempString+udg_JobName[GetForLoopIndexA()])+" ")
    endif
    if(Trig_Levels_Command_Cond_FreelancerMastered())then
        set udg_TempString=(udg_TempString+"Freelancer")
    endif
    if(Trig_Levels_Command_Cond_MasteredListFilled())then
        call DisplayTimedTextToForce(udg_TempForce,20.,(udg_TempString+"|r"))
    endif
    set udg_TempString="Jobs ultimately mastered: |cff00ffff"
    set bj_forLoopAIndex=0
    // (udg_JobCount) minus (1).
    set bj_forLoopAIndexEnd=(udg_JobCount-1)
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        if(Trig_Levels_Command_Cond_JobUltimate())then
            set udg_TempString=((udg_TempString+udg_JobName[GetForLoopIndexA()])+" ")
        endif
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    if(Trig_Levels_Command_Cond_FreelancerUltimate())then
        set udg_TempString=(udg_TempString+"Freelancer")
    endif
    if(Trig_Levels_Command_Cond_UltimateListFilled())then
        call DisplayTimedTextToForce(udg_TempForce,20.,(udg_TempString+"|r"))
    endif
    if(Trig_Levels_Command_Cond_LegendaryModeOn())then
        set udg_TempString="Jobs legendarily mastered: |cff00ffff"
        set bj_forLoopAIndex=0
        // (udg_JobCount) minus (1).
        set bj_forLoopAIndexEnd=(udg_JobCount-1)
        loop
            exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
            if(Trig_Levels_Command_Cond_JobLegendary())then
                set udg_TempString=((udg_TempString+udg_JobName[GetForLoopIndexA()])+" ")
            endif
            set bj_forLoopAIndex=bj_forLoopAIndex+1
        endloop
        if(Trig_Levels_Command_Cond_FreelancerLegendary())then
            set udg_TempString=(udg_TempString+"Freelancer")
        endif
        if(Trig_Levels_Command_Cond_LegendaryListFilled())then
            call DisplayTimedTextToForce(udg_TempForce,20.,(udg_TempString+"|r"))
        endif
    endif
    set udg_TempString=""
    call DestroyForce(udg_TempForce)
endfunction

// World Editor calls InitTrig_Levels automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Levels (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Levels takes nothing returns nothing
endfunction

function Register_Levels_Command takes nothing returns nothing
    set gg_trg_Levels_Command=CreateTrigger()
    call TriggerRegisterPlayerChatEvent(gg_trg_Levels_Command,Player(0),"-levels",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_Levels_Command,Player(1),"-levels",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_Levels_Command,Player(2),"-levels",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_Levels_Command,Player(3),"-levels",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_Levels_Command,Player(4),"-levels",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_Levels_Command,Player(5),"-levels",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_Levels_Command,Player(6),"-levels",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_Levels_Command,Player(7),"-levels",true)
    call TriggerAddAction(gg_trg_Levels_Command,function Trig_Levels_Command_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Levels takes nothing returns nothing
    call Register_Levels_Command()
endfunction

endlibrary
