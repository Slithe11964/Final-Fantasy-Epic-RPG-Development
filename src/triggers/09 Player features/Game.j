library TGame requires TPlayerHero, TWait
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Game_Start=null
endglobals

function Trig_Game_Start_StartPlayerHero takes nothing returns nothing
    local location l_tempPoint
    call SelectUnitForPlayerSingle(Player_GetHero(GetEnumPlayer()),GetEnumPlayer())
    call SetUnitInvulnerable(Player_GetHero(GetEnumPlayer()),false)
    set l_tempPoint=GetUnitLoc(Player_GetHero(GetEnumPlayer()))
    call PanCameraToTimedLocForPlayer(GetEnumPlayer(),l_tempPoint,0)
    call RemoveLocation(l_tempPoint)
    set l_tempPoint=null
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

// World Editor calls InitTrig_Game automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Game (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Game takes nothing returns nothing
endfunction

function Register_Game_Start takes nothing returns nothing
    set gg_trg_Game_Start=CreateTrigger()
    call DisableTrigger(gg_trg_Game_Start)
    call TriggerAddAction(gg_trg_Game_Start,function Trig_Game_Start_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Game takes nothing returns nothing
    call Register_Game_Start() // starts off; run by Vote
endfunction

endlibrary
