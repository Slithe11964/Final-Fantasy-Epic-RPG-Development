library TIntro requires TWait
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Intro_LockPlayers=null
    trigger gg_trg_Intro_StartGameModeVote=null
    trigger gg_trg_Intro_WelcomeMessages=null
    trigger gg_trg_Intro_FadeToBlack=null
endglobals

function Trig_Intro_LockPlayers_Actions takes nothing returns nothing
    call SetUserControlForceOff(GetPlayersAll())
    call ClearSelection()
    call EnableSelect(false,false)
    call ClearTextMessagesBJ(GetPlayersAll())
    call DisplayTimedTextToForce(GetPlayersAll(),15.,"Welcome to |cffffcc00Final Fantasy Epic RPG|r!\r\n\r\nBefore we begin, you will decide on |cffffcc00Game Mode|r, |cffffcc00Difficulty|r and |cffffcc00Text Speed|r for this session.")
    set udg_GameHours=0
    set udg_NarratorUnit=gg_unit_haro_0178
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Intro_StartGameModeVote_Actions takes nothing returns nothing
    call ConditionalTriggerExecute(gg_trg_Vote_GameMode_Show)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Intro_WelcomeMessages_Actions takes nothing returns nothing
    call SetUserControlForceOn(GetPlayersAll())
    call Wait_Polled(10.)
    call DisplayTimedTextToForce(udg_PlayingPlayers,40.,"|CFF20C000Welcome to Final Fantasy Epic RPG 0.9.7.3-r16\r\nOriginally created by ILYAS then Karifean\r\nAny suggestions, bug reports, or questions you can post in discord.gg/gYR4t3m3hK|r")
    call Wait_Polled(10.)
    call DisplayTimedTextToForce(udg_PlayingPlayers,30.,"|CFF20C000Try different Jobs up the stairs in town\r\nShops for starter gear is found in town, and you'll find much more through exploring and questing.\r\nJob base weapon and armor upgrades are found in your house.\r\nTo talk to people with a quest marker over their head just left-click them.|r")
    call Wait_Polled(60.)
    call DisplayTimedTextToForce(udg_PlayingPlayers,45.,"|cFF20C000Here's the new patch notes|r")
    call DisplayTimedTextToForce(udg_PlayingPlayers,45.,"|cFF20C000\r\n- Fixed several bugs including some potential crashes since 3.0 came out.|r")
    call Wait_Polled(60.)
    call DisplayTimedTextToForce(udg_PlayingPlayers,45.,"|cFF20C000Credits for this version go to:\r\nElDarkRevenger\r\n\r\nEveryone who gave feedback, reported bugs, ideas, answered questions in discord at discord.gg/gYR4t3m3hK, or helped on the wiki fferpg.wikia.com.|r")
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Intro_FadeToBlack_Actions takes nothing returns nothing
    call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUT,.0,"ReplaceableTextures\\CameraMasks\\Black_mask.blp",100.,100.,100.,0)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_Intro automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Intro (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Intro takes nothing returns nothing
endfunction

function Register_Intro_LockPlayers takes nothing returns nothing
    set gg_trg_Intro_LockPlayers=CreateTrigger()
    call TriggerRegisterTimerEventSingle(gg_trg_Intro_LockPlayers,.01)
    call TriggerAddAction(gg_trg_Intro_LockPlayers,function Trig_Intro_LockPlayers_Actions)
endfunction

function Register_Intro_StartGameModeVote takes nothing returns nothing
    set gg_trg_Intro_StartGameModeVote=CreateTrigger()
    call TriggerRegisterTimerEventSingle(gg_trg_Intro_StartGameModeVote,10.)
    call TriggerAddAction(gg_trg_Intro_StartGameModeVote,function Trig_Intro_StartGameModeVote_Actions)
endfunction

function Register_Intro_WelcomeMessages takes nothing returns nothing
    set gg_trg_Intro_WelcomeMessages=CreateTrigger()
    call DisableTrigger(gg_trg_Intro_WelcomeMessages)
    call TriggerAddAction(gg_trg_Intro_WelcomeMessages,function Trig_Intro_WelcomeMessages_Actions)
endfunction

function Register_Intro_FadeToBlack takes nothing returns nothing
    set gg_trg_Intro_FadeToBlack=CreateTrigger()
    call TriggerRegisterTimerEventSingle(gg_trg_Intro_FadeToBlack,.01)
    call TriggerAddAction(gg_trg_Intro_FadeToBlack,function Trig_Intro_FadeToBlack_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Intro takes nothing returns nothing
    call Register_Intro_LockPlayers()
    call Register_Intro_StartGameModeVote()
    call Register_Intro_WelcomeMessages() // starts off; run by Game
    call Register_Intro_FadeToBlack()
endfunction

endlibrary
