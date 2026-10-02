library TMagicGodToken requires TWait
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_MagicGodToken_Use=null
endglobals

function Trig_MagicGodToken_Use_Conditions takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='I0CX')and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers)) // 'I0CX': item "Magic God Token"
endfunction

function Trig_MagicGodToken_Use_Enum_CameraNoiseOn takes nothing returns nothing
    call CameraSetEQNoiseForPlayer(GetEnumPlayer(),15.)
endfunction

function Trig_MagicGodToken_Use_Enum_CameraNoiseOff takes nothing returns nothing
    call CameraClearNoiseForPlayer(GetEnumPlayer())
endfunction

function Trig_MagicGodToken_Use_Cond_MainQuestDone takes nothing returns boolean
    return(IsQuestCompleted(udg_SideQuest[40]))
endfunction

function Trig_MagicGodToken_Use_Actions takes nothing returns nothing
    if(Trig_MagicGodToken_Use_Cond_MainQuestDone())then
        call DisableTrigger(GetTriggeringTrigger())
        call DisplayTimedTextToForce(GetPlayersAll(),8.7,"|cffff0000The Warring Triad has been summoned!\r\n\r\nThey await your challenge... in the Arena.|r")
        set udg_ArenaBonusBattle[0]=(udg_ArenaBonusBattle[0]+1)
        set udg_ArenaBonusBattle[udg_ArenaBonusBattle[0]]=$92 // $92 = 146
        call ForForce(GetPlayersAll(),function Trig_MagicGodToken_Use_Enum_CameraNoiseOn)
        call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUTIN,2.,"ReplaceableTextures\\CameraMasks\\DreamFilter_Mask.blp",100.,0,0,0)
        call Wait_Polled(2)
        call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUTIN,2.,"ReplaceableTextures\\CameraMasks\\DreamFilter_Mask.blp",100.,0,100.,0)
        call Wait_Polled(2)
        call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUTIN,2.,"ReplaceableTextures\\CameraMasks\\DreamFilter_Mask.blp",.0,100.,100.,0)
        call Wait_Polled(2)
        call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUTIN,2.,"ReplaceableTextures\\CameraMasks\\DreamFilter_Mask.blp",100.,100.,.0,0)
        call Wait_Polled(2)
        call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUTIN,2.,"ReplaceableTextures\\CameraMasks\\DreamFilter_Mask.blp",.0,.0,100.,0)
        call Wait_Polled(2)
        call ForForce(GetPlayersAll(),function Trig_MagicGodToken_Use_Enum_CameraNoiseOff)
        call DestroyTrigger(GetTriggeringTrigger())
    else
        call DisplayTimedTextToForce(GetPlayersAll(),8.7,"The paths between the dimensions are closed... the talisman has no effect.")
    endif
endfunction

// World Editor calls InitTrig_MagicGodToken automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_MagicGodToken (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_MagicGodToken takes nothing returns nothing
endfunction

function Register_MagicGodToken_Use takes nothing returns nothing
    set gg_trg_MagicGodToken_Use=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_MagicGodToken_Use,EVENT_PLAYER_UNIT_USE_ITEM)
    call TriggerAddCondition(gg_trg_MagicGodToken_Use,Condition(function Trig_MagicGodToken_Use_Conditions))
    call TriggerAddAction(gg_trg_MagicGodToken_Use,function Trig_MagicGodToken_Use_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_MagicGodToken takes nothing returns nothing
    call Register_MagicGodToken_Use()
endfunction

endlibrary
