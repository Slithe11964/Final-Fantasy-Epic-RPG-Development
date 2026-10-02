library TCheat requires TEnding, TWait
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Cheat_Detect_Init=null
    trigger gg_trg_Cheat_Detect_Fog=null
    trigger gg_trg_Cheat_Detect_Invuln=null
    trigger gg_trg_Cheat_Detect_Resources=null
    trigger gg_trg_Cheat_Detect_Mana=null
    trigger gg_trg_Cheat_Punish=null
endglobals

function Trig_Cheat_Detect_Init_IsPlayerRed takes nothing returns boolean
    return(ForcePickRandomPlayer(udg_PlayingPlayers)==Player(0))
endfunction

function Trig_Cheat_Detect_Init_IsSinglePlayer takes nothing returns boolean
    return(CountPlayersInForceBJ(udg_PlayingPlayers)==1)
endfunction

function Trig_Cheat_Detect_Init_Actions takes nothing returns nothing
    call FogEnableOn()
    call FogMaskEnableOn()
    if(Trig_Cheat_Detect_Init_IsSinglePlayer())then
        if(Trig_Cheat_Detect_Init_IsPlayerRed())then
            call SetPlayerAllianceBJ(Player(1),ALLIANCE_SHARED_VISION,false,Player(0))
            call SetUnitOwner(gg_unit_o006_0123,Player(1),true)
            call UnitShareVisionBJ(true,udg_PlayerHouse[2],ForcePickRandomPlayer(udg_PlayingPlayers))
        else
            call SetPlayerAllianceBJ(Player(0),ALLIANCE_SHARED_VISION,false,Player(1))
            call SetUnitOwner(gg_unit_o006_0123,Player(0),true)
            call UnitShareVisionBJ(true,udg_PlayerHouse[1],ForcePickRandomPlayer(udg_PlayingPlayers))
        endif
        call EnableTrigger(gg_trg_Cheat_Detect_Invuln)
        call EnableTrigger(gg_trg_Cheat_Detect_Resources)
        call EnableTrigger(gg_trg_Cheat_Detect_Mana)
        call EnableTrigger(gg_trg_Cheat_Detect_Fog)
    else
        call DestroyTrigger(gg_trg_Cheat_Detect_Fog)
        call DestroyTrigger(gg_trg_Cheat_Detect_Invuln)
        call DestroyTrigger(gg_trg_Cheat_Detect_Resources)
        call DestroyTrigger(gg_trg_Cheat_Detect_Mana)
        call DestroyTrigger(gg_trg_Cheat_Punish)
        call RemoveUnit(gg_unit_o006_0123)
        call RemoveUnit(gg_unit_o007_0122)
    endif
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Cheat_Detect_Fog_IsFogOff takes nothing returns boolean
    return(IsFogEnabled()==false)
endfunction

function Trig_Cheat_Detect_Fog_IsFogMaskOff takes nothing returns boolean
    return(IsFogMaskEnabled()==false)
endfunction

function Trig_Cheat_Detect_Fog_IsMapHackOn takes nothing returns boolean
    return(udg_InCinematicMode==false)and(GetBooleanOr(Trig_Cheat_Detect_Fog_IsFogOff(),Trig_Cheat_Detect_Fog_IsFogMaskOff()))
endfunction

function Trig_Cheat_Detect_Fog_Actions takes nothing returns nothing
    call IssueTargetOrderBJ(gg_unit_o006_0123,"attack",gg_unit_o007_0122)
    call Wait_Polled(5.)
    call IssueImmediateOrderBJ(gg_unit_o006_0123,"roar")
    if(Trig_Cheat_Detect_Fog_IsMapHackOn())then
        set udg_FogDisabled=true
        call Cheat("iseedeadpeople")
    endif
endfunction

function Trig_Cheat_Detect_Invuln_DefeatWhosyourdaddy takes nothing returns nothing
    call CustomDefeatBJ(GetEnumPlayer(),"WHOSYOURDADDY detected.")
endfunction

function Trig_Cheat_Detect_Invuln_Actions takes nothing returns nothing
    call ForForce(udg_PlayingPlayers,function Trig_Cheat_Detect_Invuln_DefeatWhosyourdaddy)
    call ConditionalTriggerExecute(gg_trg_Cheat_Punish)
endfunction

function Trig_Cheat_Detect_Resources_DefeatLeafittome takes nothing returns nothing
    call CustomDefeatBJ(GetEnumPlayer(),"LEAFITTOME detected.")
endfunction

function Trig_Cheat_Detect_Resources_HasLumber takes nothing returns boolean
    return(GetPlayerState(Player($B),PLAYER_STATE_RESOURCE_LUMBER)>=1) // $B = 11
endfunction

function Trig_Cheat_Detect_Resources_DefeatKeysersoze takes nothing returns nothing
    call CustomDefeatBJ(GetEnumPlayer(),"KEYSERSOZE detected.")
endfunction

function Trig_Cheat_Detect_Resources_HasGold takes nothing returns boolean
    return(GetPlayerState(Player($B),PLAYER_STATE_RESOURCE_GOLD)>=1) // $B = 11
endfunction

function Trig_Cheat_Detect_Resources_DefeatGreedisgood takes nothing returns nothing
    call CustomDefeatBJ(GetEnumPlayer(),"GREEDISGOOD detected.")
endfunction

function Trig_Cheat_Detect_Resources_HasGoldAndLumber takes nothing returns boolean
    return(GetPlayerState(Player($B),PLAYER_STATE_RESOURCE_GOLD)>=1)and(GetPlayerState(Player($B),PLAYER_STATE_RESOURCE_LUMBER)>=1) // $B = 11
endfunction

function Trig_Cheat_Detect_Resources_Actions takes nothing returns nothing
    if(Trig_Cheat_Detect_Resources_HasGoldAndLumber())then
        call ForForce(udg_PlayingPlayers,function Trig_Cheat_Detect_Resources_DefeatGreedisgood)
        call ConditionalTriggerExecute(gg_trg_Cheat_Punish)
    else
        if(Trig_Cheat_Detect_Resources_HasGold())then
            call ForForce(udg_PlayingPlayers,function Trig_Cheat_Detect_Resources_DefeatKeysersoze)
            call ConditionalTriggerExecute(gg_trg_Cheat_Punish)
        else
            if(Trig_Cheat_Detect_Resources_HasLumber())then
                call ForForce(udg_PlayingPlayers,function Trig_Cheat_Detect_Resources_DefeatLeafittome)
                call ConditionalTriggerExecute(gg_trg_Cheat_Punish)
            endif
        endif
    endif
endfunction

function Trig_Cheat_Detect_Mana_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A09P') // 'A09P': ability "Anti Thereisnospoon"
endfunction

function Trig_Cheat_Detect_Mana_DefeatThereisnospoon takes nothing returns nothing
    call CustomDefeatBJ(GetEnumPlayer(),"THEREISNOSPOON detected.")
endfunction

function Trig_Cheat_Detect_Mana_Actions takes nothing returns nothing
    call ForForce(GetPlayersAll(),function Trig_Cheat_Detect_Mana_DefeatThereisnospoon)
    call ConditionalTriggerExecute(gg_trg_Cheat_Punish)
endfunction

function Trig_Cheat_Punish_RemoveEnumUnit takes nothing returns nothing
    call RemoveUnit(GetEnumUnit())
endfunction

function Trig_Cheat_Punish_Actions takes nothing returns nothing
    set udg_GameRunning=false
    call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUT,.0,"ReplaceableTextures\\CameraMasks\\White_mask.blp",0,0,0,0)
    call ShowInterfaceForceOff(GetPlayersAll(),.1)
    call DisableTrigger(gg_trg_Fafnir_LowLife_Credit)
    call DestroyTrigger(gg_trg_Fafnir_LowLife_Credit)
    call ForGroupBJ(Trig_Ending_ReturnToStart_EnumUnitsInRect(GetPlayableMapRect()),function Trig_Cheat_Punish_RemoveEnumUnit)
endfunction

// World Editor calls InitTrig_Cheat automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Cheat (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Cheat takes nothing returns nothing
endfunction

function Register_Cheat_Detect_Init takes nothing returns nothing
    set gg_trg_Cheat_Detect_Init=CreateTrigger()
    call TriggerAddAction(gg_trg_Cheat_Detect_Init,function Trig_Cheat_Detect_Init_Actions)
endfunction

function Register_Cheat_Detect_Fog takes nothing returns nothing
    set gg_trg_Cheat_Detect_Fog=CreateTrigger()
    call DisableTrigger(gg_trg_Cheat_Detect_Fog)
    call TriggerRegisterTimerEventPeriodic(gg_trg_Cheat_Detect_Fog,10.)
    call TriggerAddAction(gg_trg_Cheat_Detect_Fog,function Trig_Cheat_Detect_Fog_Actions)
endfunction

function Register_Cheat_Detect_Invuln takes nothing returns nothing
    set gg_trg_Cheat_Detect_Invuln=CreateTrigger()
    call DisableTrigger(gg_trg_Cheat_Detect_Invuln)
    call TriggerRegisterUnitEvent(gg_trg_Cheat_Detect_Invuln,gg_unit_o007_0122,EVENT_UNIT_DEATH)
    call TriggerAddAction(gg_trg_Cheat_Detect_Invuln,function Trig_Cheat_Detect_Invuln_Actions)
endfunction

function Register_Cheat_Detect_Resources takes nothing returns nothing
    set gg_trg_Cheat_Detect_Resources=CreateTrigger()
    call DisableTrigger(gg_trg_Cheat_Detect_Resources)
    call TriggerRegisterPlayerStateEvent(gg_trg_Cheat_Detect_Resources,Player($B),PLAYER_STATE_RESOURCE_GOLD,GREATER_THAN_OR_EQUAL,1.) // $B = 11
    call TriggerRegisterPlayerStateEvent(gg_trg_Cheat_Detect_Resources,Player($B),PLAYER_STATE_RESOURCE_LUMBER,GREATER_THAN_OR_EQUAL,1.) // $B = 11
    call TriggerAddAction(gg_trg_Cheat_Detect_Resources,function Trig_Cheat_Detect_Resources_Actions)
endfunction

function Register_Cheat_Detect_Mana takes nothing returns nothing
    set gg_trg_Cheat_Detect_Mana=CreateTrigger()
    call DisableTrigger(gg_trg_Cheat_Detect_Mana)
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Cheat_Detect_Mana,EVENT_PLAYER_UNIT_SPELL_CAST)
    call TriggerAddCondition(gg_trg_Cheat_Detect_Mana,Condition(function Trig_Cheat_Detect_Mana_Conditions))
    call TriggerAddAction(gg_trg_Cheat_Detect_Mana,function Trig_Cheat_Detect_Mana_Actions)
endfunction

function Register_Cheat_Punish takes nothing returns nothing
    set gg_trg_Cheat_Punish=CreateTrigger()
    call DisableTrigger(gg_trg_Cheat_Punish)
    call TriggerAddAction(gg_trg_Cheat_Punish,function Trig_Cheat_Punish_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Cheat takes nothing returns nothing
    call Register_Cheat_Detect_Init() // run by Init
    call Register_Cheat_Detect_Fog() // starts off; enabled by Cheat; destroyed by Cheat
    call Register_Cheat_Detect_Invuln() // starts off; enabled by Cheat; destroyed by Cheat
    call Register_Cheat_Detect_Resources() // starts off; enabled by Cheat; destroyed by Cheat
    call Register_Cheat_Detect_Mana() // starts off; enabled by Cheat; destroyed by Cheat
    call Register_Cheat_Punish() // starts off; run by Cheat; destroyed by Cheat
endfunction

endlibrary
