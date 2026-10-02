library TGameLoad requires TPlayerPart01
function Trig_GameLoad_RestoreTitles_KillLoadedHero takes nothing returns nothing
    call UnitApplyTimedLifeBJ(.01,'BTLF',Player_GetHero(GetEnumPlayer())) // 'BTLF': object name not found in map data
endfunction

function Trig_GameLoad_RestoreTitles_HasTitle_Enum takes nothing returns boolean
    return(IsPlayerInForce(GetEnumPlayer(),udg_TitleForce[udg_TempInteger]))
endfunction

function Trig_GameLoad_RestoreTitles_RestoreChronicleLevels takes nothing returns nothing
    set udg_TempInteger=1
    loop
        exitwhen udg_TempInteger>$A // $A = 10
        call SetUnitAbilityLevelSwapped(udg_ChronicleAbility[udg_TempInteger],udg_SpiritOfGaya[GetConvertedPlayerId(GetEnumPlayer())],1)
        set udg_TempInteger=udg_TempInteger+1
    endloop
    set udg_TempInteger=1
    loop
        exitwhen udg_TempInteger>60
        if(Trig_GameLoad_RestoreTitles_HasTitle_Enum())then
            // Result 1: (GetUnitAbilityLevelSwapped(udg_ChronicleAbility at position udg_TitleChronicleIndex at position
            // udg_TempInteger, udg_SpiritOfGaya at position GetConvertedPlayerId(the player being visited))) plus
            // (udg_TitleChroniclePoints at position udg_TempInteger).
            call SetUnitAbilityLevelSwapped(udg_ChronicleAbility[udg_TitleChronicleIndex[udg_TempInteger]],udg_SpiritOfGaya[GetConvertedPlayerId(GetEnumPlayer())],(GetUnitAbilityLevelSwapped(udg_ChronicleAbility[udg_TitleChronicleIndex[udg_TempInteger]],udg_SpiritOfGaya[GetConvertedPlayerId(GetEnumPlayer())])+udg_TitleChroniclePoints[udg_TempInteger]))
        endif
        set udg_TempInteger=udg_TempInteger+1
    endloop
    // (udg_SpeedrunLevel at position GetConvertedPlayerId(the player being visited)) plus (1).
    call SetUnitAbilityLevelSwapped(udg_ChronicleAbility[$B],udg_SpiritOfGaya[GetConvertedPlayerId(GetEnumPlayer())],(udg_SpeedrunLevel[GetConvertedPlayerId(GetEnumPlayer())]+1)) // $B = 11
endfunction

function Trig_GameLoad_RestoreTitles_SaveLoad_Allowed takes nothing returns boolean
    return(udg_HardcoreOff)
endfunction

function Trig_GameLoad_RestoreTitles_Actions takes nothing returns nothing
    if(Trig_GameLoad_RestoreTitles_SaveLoad_Allowed())then
        set udg_SpeedrunFlag[2]=true
        call ForForce(udg_PlayingPlayers,function Trig_GameLoad_RestoreTitles_RestoreChronicleLevels)
    else
        call DisplayTimedTextToForce(GetPlayersAll(),30,"You chose the mode without saving or loading.\r\n\r\nOwn it.")
        call ForForce(udg_PlayingPlayers,function Trig_GameLoad_RestoreTitles_KillLoadedHero)
    endif
endfunction

// World Editor calls InitTrig_GameLoad automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_GameLoad (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_GameLoad takes nothing returns nothing
endfunction

function Register_GameLoad_RestoreTitles takes nothing returns nothing
    set gg_trg_GameLoad_RestoreTitles=CreateTrigger()
    call TriggerRegisterGameLoadedEventBJ(gg_trg_GameLoad_RestoreTitles)
    call TriggerAddAction(gg_trg_GameLoad_RestoreTitles,function Trig_GameLoad_RestoreTitles_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_GameLoad takes nothing returns nothing
    call Register_GameLoad_RestoreTitles()
endfunction

endlibrary
