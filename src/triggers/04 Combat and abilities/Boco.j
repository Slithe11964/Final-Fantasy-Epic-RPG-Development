library TBoco requires TCam, TCine, TReward, TText
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Boco_Feed_Greens=null
    trigger gg_trg_Boco_Meet_Again=null
endglobals

function Trig_Boco_Feed_Greens_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A15X')and(GetSpellTargetUnit()==gg_unit_n00E_0138)and(IsUnitHiddenBJ(gg_unit_n00E_0138)==false)and(udg_InCinematicMode==false) // 'A15X': ability "Gysahl Greens"
endfunction

function Trig_Boco_Feed_Greens_Cond_BocoCineOn takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Boco_Feed_Greens_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    if(Trig_Boco_Feed_Greens_Cond_BocoCineOn())then
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_n00E_0138,0)
        call Text_Transmission(gg_unit_n00E_0138,"Boco","Wark! Wark!","(null)",null,0,false)
        call Text_Transmission(gg_unit_n00E_0138,"Boco",("|cffffcc00Being excited, Boco looks at Gysahl Greens in the hands of "+(udg_PlayerName[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+".|r")),"(null)",null,0,false)
        call Text_Transmission(gg_unit_n00E_0138,"Boco",("|cffffcc00"+(udg_PlayerName[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+" gives Gysahl Greens to Boco and Chocobo eats it with pleasure.|r")),"(null)",null,0,false)
        call Text_Transmission(gg_unit_n00E_0138,"Boco","|n|cffffcc00All players get 2000 exp.|r","(null)",null,0,true)
        call Reward_Give(0,$7D0,null) // $7D0 = 2000
        call Text_Transmission(gg_unit_n00E_0138,"Boco","Wark wark wark!","(null)",null,0,false)
        call Text_Transmission(gg_unit_n00E_0138,"Boco","|cffffcc00Boco looks at you expectantly.|r","(null)",null,0,false)
        call Text_Transmission(gg_unit_n00E_0138,"Boco","|cffffcc00It seems he wants you to find him in another place.|r","(null)",null,0,false)
        call Text_Transmission(gg_unit_n00E_0138,"Boco","|n|cffffcc00You can now dig up more powerful Greens.|r","(null)",null,0,false)
        call Cine_ExitAction()
    else
        call Reward_Give(0,$7D0,gg_unit_n00E_0138) // $7D0 = 2000
        call DisplayTimedTextToForce(udg_PlayingPlayers,10.,"|cffffcc00You can now dig up more powerful Greens.|r")
    endif
    set udg_ChocoboGreensStage=1
    set udg_TempPoint=GetUnitLoc(gg_unit_n00E_0138)
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(udg_TempPoint)
    call SetUnitOwner(gg_unit_n00E_0138,Player(8),false)
    set udg_TempPoint=GetRectCenter(gg_rct_708)
    call SetUnitPositionLocFacingBJ(gg_unit_n00E_0138,udg_TempPoint,bj_UNIT_FACING)
    call RemoveLocation(udg_TempPoint)
    call EnableTrigger(gg_trg_Boco_Meet_Again)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Boco_Meet_Again_Conditions takes nothing returns boolean
    return((IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(GetUnitTypeId(GetTriggerUnit())!='H01D')and(IsUnitHiddenBJ(gg_unit_n00E_0138)==false)and(udg_InCinematicMode==false))!=null // 'H01D': unit "Spirit of Gaya"
endfunction

function Trig_Boco_Meet_Again_Cond_BocoMeetCineOn takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Boco_Meet_Again_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    if(Trig_Boco_Meet_Again_Cond_BocoMeetCineOn())then
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_n00E_0138,0)
        call Text_Transmission(gg_unit_n00E_0138,"Boco","Wark! Wark wark wark wark.","(null)",null,0,false)
        call Text_Transmission(gg_unit_n00E_0138,"Boco","|cffffcc00It seems Boco wishes to congratulate him on how far you've come.|r","(null)",null,0,false)
        call Text_Transmission(gg_unit_n00E_0138,"Boco","|cffffcc00He beckons you to dig up the spot in front of him.|r","(null)",null,0,false)
        call Cine_ExitAction()
    endif
    set udg_ChocoboGreensStage=2
    call SaveIntegerBJ(1,2,58,udg_GameStateHash)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_Boco automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Boco (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Boco takes nothing returns nothing
endfunction

function Register_Boco_Feed_Greens takes nothing returns nothing
    set gg_trg_Boco_Feed_Greens=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Boco_Feed_Greens,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Boco_Feed_Greens,Condition(function Trig_Boco_Feed_Greens_Conditions))
    call TriggerAddAction(gg_trg_Boco_Feed_Greens,function Trig_Boco_Feed_Greens_Actions)
endfunction

function Register_Boco_Meet_Again takes nothing returns nothing
    set gg_trg_Boco_Meet_Again=CreateTrigger()
    call DisableTrigger(gg_trg_Boco_Meet_Again)
    call TriggerRegisterUnitInRangeSimple(gg_trg_Boco_Meet_Again,700.,gg_unit_n00E_0138)
    call TriggerAddCondition(gg_trg_Boco_Meet_Again,Condition(function Trig_Boco_Meet_Again_Conditions))
    call TriggerAddAction(gg_trg_Boco_Meet_Again,function Trig_Boco_Meet_Again_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Boco takes nothing returns nothing
    call Register_Boco_Feed_Greens()
    call Register_Boco_Meet_Again()
endfunction

endlibrary
