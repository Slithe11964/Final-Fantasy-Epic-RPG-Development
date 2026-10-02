library TIntro requires TWait
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
    call DisplayTimedTextToForce(udg_PlayingPlayers,40.,"|CFF20C000Welcome to Final Fantasy Epic RPG 0.9.7.3\r\nOriginally created by ILYAS\r\nNow edited and maintained by fferpg.forumotion.com\r\nAny suggestions, bug reports, questions, whatever else, you can post it all right over there.|r")
    call Wait_Polled(10.)
    call DisplayTimedTextToForce(udg_PlayingPlayers,30.,"|CFF20C000Job changing can be done in the northern part of the town, \r\nEquipment shops are found in the eastern part of the town,\r\nGeneral weapon and armor upgrades can be researched in your House,\r\nTo talk to people with a yellow ! over their head just left-click them.|r")
    call Wait_Polled(60.)
    call DisplayTimedTextToForce(udg_PlayingPlayers,45.,"|cFF20C000With a new version come new updates.|r")
    call DisplayTimedTextToForce(udg_PlayingPlayers,45.,"|cFF20C000\r\n- Some rebalancing of buffs and debuffs.\r\n- Ability cooldowns have been adjusted.\r\n- Nerfed attack cooldown of Strength heroes.\r\n- New secret boss has been added.\r\n- Fixed several bugs including some potential crashes.|r")
    call Wait_Polled(60.)
    call DisplayTimedTextToForce(udg_PlayingPlayers,45.,"|cFF20C000Credits this version go to:\r\nKarifean\r\n\r\nEveryone who gave feedback, bugs, glitches, ideas, etc. at the forums fferpg.forumotion.com, the discord server discord.gg/jXA8DHv, or helped on the wiki fferpg.wikia.com.|r")
    call DisplayTimedTextToForce(udg_PlayingPlayers,45.,"|cFF20C000Special thanks to Fommels, Andrenden, h0b099j, SilentSputnik, Gawdl3y, Zebedee, Fungo and Wayne Pol!|r")
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Intro_FadeToBlack_Actions takes nothing returns nothing
    call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUT,.0,"ReplaceableTextures\\CameraMasks\\Black_mask.blp",100.,100.,100.,0)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Intro takes nothing returns nothing
endfunction

function RegisterR11_Intro_LockPlayers takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Intro_LockPlayers=CreateTrigger()

call TriggerRegisterTimerEventSingle(gg_trg_Intro_LockPlayers,.01)

call TriggerAddAction(gg_trg_Intro_LockPlayers,function Trig_Intro_LockPlayers_Actions)

endfunction




function RegisterR11_Intro_StartGameModeVote takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Intro_StartGameModeVote=CreateTrigger()

call TriggerRegisterTimerEventSingle(gg_trg_Intro_StartGameModeVote,10.)

call TriggerAddAction(gg_trg_Intro_StartGameModeVote,function Trig_Intro_StartGameModeVote_Actions)

endfunction




function RegisterR11_Intro_WelcomeMessages takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Intro_WelcomeMessages=CreateTrigger()

call DisableTrigger(gg_trg_Intro_WelcomeMessages)

call TriggerAddAction(gg_trg_Intro_WelcomeMessages,function Trig_Intro_WelcomeMessages_Actions)

endfunction




function RegisterR11_Intro_FadeToBlack takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Intro_FadeToBlack=CreateTrigger()

call TriggerRegisterTimerEventSingle(gg_trg_Intro_FadeToBlack,.01)

call TriggerAddAction(gg_trg_Intro_FadeToBlack,function Trig_Intro_FadeToBlack_Actions)

endfunction




endlibrary
