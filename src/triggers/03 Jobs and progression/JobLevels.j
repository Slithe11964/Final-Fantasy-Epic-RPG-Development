library TJobLevels requires TJob
function Trig_JobLevels_Update_IsHighestJob takes nothing returns boolean
    return(Job_GetSavedLevel(GetEnumPlayer(),udg_JobUnitType[GetForLoopIndexA()])>udg_HighestJobLevel[GetConvertedPlayerId(GetEnumPlayer())])
endfunction

function Trig_JobLevels_Update_IsMasteryMax takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A02F',udg_FreelancerHero[GetConvertedPlayerId(GetEnumPlayer())])>=4) // 'A02F': ability "Mastery"
endfunction

function Trig_JobLevels_Update_IsHeroLevelHighest takes nothing returns boolean
    return(GetHeroLevel(udg_FreelancerHero[GetConvertedPlayerId(GetEnumPlayer())])>udg_HighestJobLevel[GetConvertedPlayerId(GetEnumPlayer())])
endfunction

function Trig_JobLevels_Update_IsTrackedPlayer takes nothing returns boolean
    return(IsPlayerInForce(GetEnumPlayer(),udg_TitleForce[48])==false)
endfunction

function Trig_JobLevels_Update_SumPlayerJobLevels takes nothing returns nothing
    if(Trig_JobLevels_Update_IsTrackedPlayer())then
        set udg_TotalJobLevel[GetConvertedPlayerId(GetEnumPlayer())]=0
        set bj_forLoopAIndex=0
        // (udg_JobCount) minus (1).
        set bj_forLoopAIndexEnd=(udg_JobCount-1)
        loop
            exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
            // Result 1: (udg_TotalJobLevel at position GetConvertedPlayerId(the player being visited)) plus
            // (Job_GetSavedLevel(the player being visited, udg_JobUnitType at position loop counter A)).
            set udg_TotalJobLevel[GetConvertedPlayerId(GetEnumPlayer())]=(udg_TotalJobLevel[GetConvertedPlayerId(GetEnumPlayer())]+Job_GetSavedLevel(GetEnumPlayer(),udg_JobUnitType[GetForLoopIndexA()]))
            if(Trig_JobLevels_Update_IsHighestJob())then
                set udg_HighestJobLevel[GetConvertedPlayerId(GetEnumPlayer())]=Job_GetSavedLevel(GetEnumPlayer(),udg_JobUnitType[GetForLoopIndexA()])
            endif
            set bj_forLoopAIndex=bj_forLoopAIndex+1
        endloop
        if(Trig_JobLevels_Update_IsMasteryMax())then
            // Increase udg_TotalJobLevel at position GetConvertedPlayerId(the player being visited) by 100.
            set udg_TotalJobLevel[GetConvertedPlayerId(GetEnumPlayer())]=(udg_TotalJobLevel[GetConvertedPlayerId(GetEnumPlayer())]+'d')
        else
            // Result 1: (udg_TotalJobLevel at position GetConvertedPlayerId(the player being visited)) plus (hero level of
            // udg_FreelancerHero at position GetConvertedPlayerId(the player being visited)).
            set udg_TotalJobLevel[GetConvertedPlayerId(GetEnumPlayer())]=(udg_TotalJobLevel[GetConvertedPlayerId(GetEnumPlayer())]+GetHeroLevel(udg_FreelancerHero[GetConvertedPlayerId(GetEnumPlayer())]))
        endif
        if(Trig_JobLevels_Update_IsHeroLevelHighest())then
            set udg_HighestJobLevel[GetConvertedPlayerId(GetEnumPlayer())]=GetHeroLevel(udg_FreelancerHero[GetConvertedPlayerId(GetEnumPlayer())])
        endif
        set udg_TempPlayer=GetEnumPlayer()
        call ConditionalTriggerExecute(gg_trg_Titles_CheckBasic)
    endif
endfunction

function Trig_JobLevels_Update_Actions takes nothing returns nothing
    call ForForce(udg_PlayingPlayers,function Trig_JobLevels_Update_SumPlayerJobLevels)
    call TriggerExecute(gg_trg_Job_XP_Handicap)
    call StartTimerBJ(udg_JobLevelTimer,false,10.)
endfunction

function Trig_JobLevels_Init_IsTopJobLevel takes nothing returns boolean
    return(Job_GetSavedLevel(GetEnumPlayer(),udg_JobUnitType[GetForLoopIndexA()])>udg_HighestJobLevel[GetConvertedPlayerId(GetEnumPlayer())])
endfunction

function Trig_JobLevels_Init_HasMaxMastery takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A02F',udg_FreelancerHero[GetConvertedPlayerId(GetEnumPlayer())])>=4) // 'A02F': ability "Mastery"
endfunction

function Trig_JobLevels_Init_IsTopHeroLevel takes nothing returns boolean
    return(GetHeroLevel(udg_FreelancerHero[GetConvertedPlayerId(GetEnumPlayer())])>udg_HighestJobLevel[GetConvertedPlayerId(GetEnumPlayer())])
endfunction

function Trig_JobLevels_Init_ComputeJobTotals takes nothing returns nothing
    set udg_TotalJobLevel[GetConvertedPlayerId(GetEnumPlayer())]=0
    set bj_forLoopAIndex=0
    // (udg_JobCount) minus (1).
    set bj_forLoopAIndexEnd=(udg_JobCount-1)
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        // Result 1: (udg_TotalJobLevel at position GetConvertedPlayerId(the player being visited)) plus
        // (Job_GetSavedLevel(the player being visited, udg_JobUnitType at position loop counter A)).
        set udg_TotalJobLevel[GetConvertedPlayerId(GetEnumPlayer())]=(udg_TotalJobLevel[GetConvertedPlayerId(GetEnumPlayer())]+Job_GetSavedLevel(GetEnumPlayer(),udg_JobUnitType[GetForLoopIndexA()]))
        if(Trig_JobLevels_Init_IsTopJobLevel())then
            set udg_HighestJobLevel[GetConvertedPlayerId(GetEnumPlayer())]=Job_GetSavedLevel(GetEnumPlayer(),udg_JobUnitType[GetForLoopIndexA()])
        endif
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    if(Trig_JobLevels_Init_HasMaxMastery())then
        // Increase udg_TotalJobLevel at position GetConvertedPlayerId(the player being visited) by 100.
        set udg_TotalJobLevel[GetConvertedPlayerId(GetEnumPlayer())]=(udg_TotalJobLevel[GetConvertedPlayerId(GetEnumPlayer())]+'d')
    else
        // Result 1: (udg_TotalJobLevel at position GetConvertedPlayerId(the player being visited)) plus (hero level of
        // udg_FreelancerHero at position GetConvertedPlayerId(the player being visited)).
        set udg_TotalJobLevel[GetConvertedPlayerId(GetEnumPlayer())]=(udg_TotalJobLevel[GetConvertedPlayerId(GetEnumPlayer())]+GetHeroLevel(udg_FreelancerHero[GetConvertedPlayerId(GetEnumPlayer())]))
    endif
    if(Trig_JobLevels_Init_IsTopHeroLevel())then
        set udg_HighestJobLevel[GetConvertedPlayerId(GetEnumPlayer())]=GetHeroLevel(udg_FreelancerHero[GetConvertedPlayerId(GetEnumPlayer())])
    endif
    set udg_TempPlayer=GetEnumPlayer()
    call ConditionalTriggerExecute(gg_trg_Titles_CheckBasic)
endfunction

function Trig_JobLevels_Init_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call ForForce(udg_PlayingPlayers,function Trig_JobLevels_Init_ComputeJobTotals)
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_JobLevels takes nothing returns nothing
endfunction
function RegisterR11_JobLevels_Update takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_JobLevels_Update=CreateTrigger()
    call TriggerRegisterTimerExpireEventBJ(gg_trg_JobLevels_Update,udg_JobLevelTimer)
    call TriggerAddAction(gg_trg_JobLevels_Update,function Trig_JobLevels_Update_Actions)
endfunction
function RegisterR11_JobLevels_Init takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_JobLevels_Init=CreateTrigger()
    call DisableTrigger(gg_trg_JobLevels_Init)
    call TriggerRegisterTimerExpireEventBJ(gg_trg_JobLevels_Init,udg_JobLevelTimer)
    call TriggerAddAction(gg_trg_JobLevels_Init,function Trig_JobLevels_Init_Actions)
endfunction




endlibrary
