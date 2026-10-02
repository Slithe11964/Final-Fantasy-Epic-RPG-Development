library TGame requires TPlayerPart01, TWait
function Trig_Game_Start_StartPlayerHero takes nothing returns nothing
    call SelectUnitForPlayerSingle(Player_GetHero(GetEnumPlayer()),GetEnumPlayer())
    call SetUnitInvulnerable(Player_GetHero(GetEnumPlayer()),false)
    set udg_TempPoint=GetUnitLoc(Player_GetHero(GetEnumPlayer()))
    call PanCameraToTimedLocForPlayer(GetEnumPlayer(),udg_TempPoint,0)
    call RemoveLocation(udg_TempPoint)
endfunction

function Trig_Game_Start_AddPlayerToForces takes nothing returns nothing
    call ForceAddPlayerSimple(GetEnumPlayer(),udg_AutosaveForce)
    call ForceAddPlayerSimple(GetEnumPlayer(),udg_AbilityTextForce)
    call ForceAddPlayerSimple(GetEnumPlayer(),udg_TrackedPlayers)
endfunction

function Trig_Game_Start_Actions takes nothing returns nothing
    call CinematicFadeBJ(bj_CINEFADETYPE_FADEIN,3.,"ReplaceableTextures\\CameraMasks\\Black_mask.blp",100.,100.,100.,0)
    set udg_GameRunning=true
    call EnableTrigger(gg_trg_Speedrun_FirstCast)
    call EnableSelect(true,true)
    call ForForce(udg_PlayingPlayers,function Trig_Game_Start_StartPlayerHero)
    call DestroyTimerDialogBJ(udg_VoteTimerDialog)
    call DialogDestroy(udg_VoteDialog)
    call EnableTrigger(gg_trg_Gaya_Follow)
    call StartTimerBJ(udg_LoadRefreshTimer,false,1.)
    call TriggerExecute(gg_trg_Multiboard_Create)
    call EnableTrigger(gg_trg_Multiboard_Refresh)
    call TriggerExecute(gg_trg_Multiboard_Refresh)
    call EnableTrigger(gg_trg_Job_XP_Handicap)
    call TriggerExecute(gg_trg_Job_XP_Handicap)
    call TriggerExecute(gg_trg_Intro_WelcomeMessages)
    call StartTimerBJ(udg_WorldEventTimer,false,720.)
    call SetDestructableAnimationBJ(gg_dest_BTrx_0011,"Stand Alternate")
    call UseTimeOfDayBJ(true)
    call ForForce(udg_PlayingPlayers,function Trig_Game_Start_AddPlayerToForces)
    call Wait_Polled(2)
    call EnableTrigger(gg_trg_News_Morning)
    call DestroyTrigger(gg_trg_Vote_TextSpeed_Click)
    call DestroyTrigger(gg_trg_Vote_Difficulty_Click)
    call DestroyTrigger(gg_trg_Vote_GameMode_Click)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Game takes nothing returns nothing
endfunction
function RegisterR11_Game_Start takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Game_Start=CreateTrigger()
    call DisableTrigger(gg_trg_Game_Start)
    call TriggerAddAction(gg_trg_Game_Start,function Trig_Game_Start_Actions)
endfunction




endlibrary
