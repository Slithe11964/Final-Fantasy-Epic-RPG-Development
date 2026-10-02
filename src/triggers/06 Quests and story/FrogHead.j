library TFrogHead requires TCam, TCine, TPlayerPart01, TText, TWait
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_FrogHead_TurnIn=null
endglobals

function Trig_FrogHead_TurnIn_Conditions takes nothing returns boolean
    return((UnitHasItemOfTypeBJ(GetTriggerUnit(),'I07I'))and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(udg_InCinematicMode==false))!=null // 'I07I': item "Qu's Frog Head"
endfunction

function Trig_FrogHead_TurnIn_Cond_ShowDialogue takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_FrogHead_TurnIn_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I07I')) // 'I07I': item "Qu's Frog Head"
    call DestroyEffectBJ(udg_SpecialEffect[62])
    if(Trig_FrogHead_TurnIn_Cond_ShowDialogue())then
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_n034_0109,0)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"I don't know what I expected but it actually was a lot more complicated than just finding and killing a Qu Frog. Either way, you said this was the last thing you needed right?",false)
        call Text_Say(gg_unit_n034_0109,"Yes, don't worry. All the preparation for the ritual are now complete.",false)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"That's reassuring. Will you summon the portal to the world's boundary now?",false)
        call Text_Say(gg_unit_n034_0109,"Yes, meet me in the Northern Mountains region and I'll show you my newly created dimension portal! This should fix the dimension connection problems!",false)
        call Cine_ExitAction()
    endif
    call QuestMessageBJ(udg_PlayingPlayers,bj_QUESTMESSAGE_UPDATED,"Meet Shinra in the Northern Mountains.")
    call QuestSetDescriptionBJ(udg_SideQuest[40],"Shinra, an Al Bhed child from Spira, now finally has all the artifacts required to make a portal. Meet him in the Northern Mountains.")
    set udg_TempPoint=GetRectCenter(gg_rct_420)
    call SetUnitPositionLocFacingBJ(gg_unit_n034_0109,udg_TempPoint,160.)
    call RemoveLocation(udg_TempPoint)
    call GroupAddUnitSimple(gg_unit_n034_0109,udg_BossUnits)
    call Wait_Polled(1.)
    set udg_SpecialEffect[62]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_n034_0109,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call EnableTrigger(gg_trg_DimensionalBoundary_OpenPortal)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_FrogHead automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_FrogHead (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_FrogHead takes nothing returns nothing
endfunction

function Register_FrogHead_TurnIn takes nothing returns nothing
    set gg_trg_FrogHead_TurnIn=CreateTrigger()
    call DisableTrigger(gg_trg_FrogHead_TurnIn)
    call TriggerRegisterUnitInRangeSimple(gg_trg_FrogHead_TurnIn,250.,gg_unit_n034_0109)
    call TriggerAddCondition(gg_trg_FrogHead_TurnIn,Condition(function Trig_FrogHead_TurnIn_Conditions))
    call TriggerAddAction(gg_trg_FrogHead_TurnIn,function Trig_FrogHead_TurnIn_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_FrogHead takes nothing returns nothing
    call Register_FrogHead_TurnIn() // starts off; enabled by QuFrog
endfunction

endlibrary
