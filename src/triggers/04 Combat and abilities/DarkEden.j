library TDarkEden requires TCam, TCine, TPlayerPart01, TText, TWait
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_DarkEden_Appear=null
    trigger gg_trg_DarkEden_Death=null
    trigger gg_trg_DarkEden_LightningColor=null
    // Variables only this module uses.
    lightning udg_AbsorbLightning=null
endglobals

function Trig_DarkEden_Appear_Conditions takes nothing returns boolean
    return(GetUnitTypeId(GetTriggerUnit())=='h022')and(udg_InCinematicMode==false) // 'h022': unit "Eden"
endfunction

function Trig_DarkEden_Appear_CinematicsOn_Intro takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_DarkEden_Appear_PanCameraToArea takes nothing returns nothing
    call PanCameraToTimedLocForPlayer(GetEnumPlayer(),udg_TempPoint,.2)
endfunction

function Trig_DarkEden_Appear_CinematicsOn_Dialog takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_DarkEden_Appear_CinematicsOn_Announce takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_DarkEden_Appear_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call Cine_Enter()
    call Cam_PanToUnit(GetTriggerUnit(),0)
    if(Trig_DarkEden_Appear_CinematicsOn_Intro())then
        call Wait_Polled(2)
        set udg_SpecialEffect[58]=AddSpecialEffectTargetUnitBJ("overhead",GetTriggerUnit(),"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
        call Wait_Polled(1.)
        call DestroyEffectBJ(udg_SpecialEffect[58])
        call Wait_Polled(1.)
    endif
    call AddSpecialEffectTargetUnitBJ("overhead",GetTriggerUnit(),"Abilities\\Spells\\Items\\AIda\\AIdaCaster.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call Wait_Polled(1.)
    set udg_TempPoint=GetUnitLoc(gg_unit_N02Z_0031)
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call SetUnitFacingToFaceLocTimed(gg_unit_u007_0128,udg_TempPoint,.2)
    call RemoveLocation(udg_TempPoint)
    call Wait_Polled(.5)
    call ShowUnitShow(gg_unit_N02Z_0031)
    call Wait_Polled(1.)
    if(Trig_DarkEden_Appear_CinematicsOn_Dialog())then
        set udg_TempPoint=GetRectCenter(gg_rct_119)
        call ForForce(udg_PlayingPlayers,function Trig_DarkEden_Appear_PanCameraToArea)
        call RemoveLocation(udg_TempPoint)
        call Text_Say(gg_unit_u007_0128,"Oh no! It... it's a Dark Eidolon!",false)
    endif
    set udg_TempPoint=GetUnitLoc(gg_unit_u007_0128)
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl")
    call RemoveLocation(udg_TempPoint)
    call Wait_Polled(.5)
    call ShowUnitHide(gg_unit_u007_0128)
    if(Trig_DarkEden_Appear_CinematicsOn_Announce())then
        call Wait_Polled(1.)
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(null,"|cff26001CDark Eden has appeared!|r",true)
    else
        call DisplayTimedTextToForce(udg_PlayingPlayers,10.,"|cff26001CDark Eden has appeared!|r")
    endif
    call Cine_ExitAction()
    call SetUnitInvulnerable(gg_unit_N02Z_0031,false)
    call PauseUnitBJ(false,gg_unit_N02Z_0031)
    call GroupAddUnitSimple(gg_unit_N02Z_0031,udg_BossGroup)
    call GroupAddUnitSimple(gg_unit_N02Z_0031,udg_BossUnits)
    call StartTimerBJ(udg_ShiftElementsTimer,false,.01)
    call EnableTrigger(gg_trg_DarkEden_Death)
endfunction

function Trig_DarkEden_Death_PanCameraToArea takes nothing returns nothing
    call PanCameraToTimedLocForPlayer(GetEnumPlayer(),GetRectCenter(gg_rct_119),0)
endfunction

function Trig_DarkEden_Death_KillerIsPlayer takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetKillingUnitBJ()),udg_PlayingPlayers))
endfunction

function Trig_DarkEden_Death_CinematicsOn takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_DarkEden_Death_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateItemLoc('I0G7',udg_TempPoint) // 'I0G7': item "Omni Gem"
    call RemoveLocation(udg_TempPoint)
    call RemoveItemFromStockBJ('I07U',gg_unit_n02Y_0052) // 'I07U': item "Information: Dark Eden"
    if(Trig_DarkEden_Death_CinematicsOn())then
        call Cine_Enter()
        call ForForce(udg_PlayingPlayers,function Trig_DarkEden_Death_PanCameraToArea)
        set udg_TempPoint=GetUnitLoc(gg_unit_u007_0128)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl")
        call RemoveLocation(udg_TempPoint)
        call Wait_Polled(.5)
        call ShowUnitShow(gg_unit_u007_0128)
        call Text_Say(gg_unit_u007_0128,"Incredible, you have defeated him! It was Dark Eden... wait a second, allow me...",false)
        call Wait_Polled(1.)
        set udg_TempPoint=GetUnitLoc(gg_unit_u007_0128)
        set udg_TempPoint2=GetUnitLoc(GetTriggerUnit())
        set udg_AbsorbLightning=AddLightningLoc("DRAB",udg_TempPoint,udg_TempPoint2)
        call RemoveLocation(udg_TempPoint)
        call RemoveLocation(udg_TempPoint2)
        call EnableTrigger(gg_trg_DarkEden_LightningColor)
        call ConditionalTriggerExecute(gg_trg_DarkEden_LightningColor)
        call Wait_Polled(1.)
        call Text_Say(gg_unit_u007_0128,"The tiara's power absorption. I'm gonna use Dark Eden's power to make my Eden even stronger!",false)
        if(Trig_DarkEden_Death_KillerIsPlayer())then
            set udg_TempPlayer=GetOwningPlayer(GetKillingUnitBJ())
        else
            set udg_TempPlayer=ForcePickRandomPlayer(udg_PlayingPlayers)
        endif
        call Text_Say(Player_GetHero(udg_TempPlayer),"Make your Eden even stronger!? We could hardly defeat it as it was now!",false)
        call Text_Say(gg_unit_u007_0128,"Hmmm, you think so? Alright, if you say so I won't do it.",false)
        call DisableTrigger(gg_trg_DarkEden_LightningColor)
        call DestroyLightningBJ(udg_AbsorbLightning)
        call Text_Say(gg_unit_u007_0128,"You're such a spoilsport. Well, if you insist.",false)
        call Cine_ExitAction()
    else
        call ShowUnitShow(gg_unit_u007_0128)
    endif
    call SetUnitFacingTimed(gg_unit_u007_0128,270.,.2)
    call DestroyTrigger(gg_trg_DarkEden_LightningColor)
    call ConditionalTriggerExecute(gg_trg_Promotion_Award_Random)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_DarkEden_LightningColor_Actions takes nothing returns nothing
    // Calculation 1:
    // A random decimal number between 0 and 1.
    // Calculation 2:
    // A random decimal number between 0 and 1.
    // Calculation 3:
    // A random decimal number between 0 and 1.
    // Calculation 4:
    // A random decimal number between 0.5 and 1.
    call SetLightningColorBJ(udg_AbsorbLightning,GetRandomReal(0,1),GetRandomReal(0,1),GetRandomReal(0,1),GetRandomReal(.5,1))
endfunction

// World Editor calls InitTrig_DarkEden automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_DarkEden (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_DarkEden takes nothing returns nothing
endfunction

function Register_DarkEden_Appear takes nothing returns nothing
    set gg_trg_DarkEden_Appear=CreateTrigger()
    call DisableTrigger(gg_trg_DarkEden_Appear)
    call TriggerRegisterEnterRectSimple(gg_trg_DarkEden_Appear,gg_rct_118)
    call TriggerAddCondition(gg_trg_DarkEden_Appear,Condition(function Trig_DarkEden_Appear_Conditions))
    call TriggerAddAction(gg_trg_DarkEden_Appear,function Trig_DarkEden_Appear_Actions)
endfunction

function Register_DarkEden_Death takes nothing returns nothing
    set gg_trg_DarkEden_Death=CreateTrigger()
    call DisableTrigger(gg_trg_DarkEden_Death)
    call TriggerRegisterUnitEvent(gg_trg_DarkEden_Death,gg_unit_N02Z_0031,EVENT_UNIT_DEATH)
    call TriggerAddAction(gg_trg_DarkEden_Death,function Trig_DarkEden_Death_Actions)
endfunction

function Register_DarkEden_LightningColor takes nothing returns nothing
    set gg_trg_DarkEden_LightningColor=CreateTrigger()
    call DisableTrigger(gg_trg_DarkEden_LightningColor)
    call TriggerRegisterTimerEventPeriodic(gg_trg_DarkEden_LightningColor,.25)
    call TriggerAddAction(gg_trg_DarkEden_LightningColor,function Trig_DarkEden_LightningColor_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_DarkEden takes nothing returns nothing
    call Register_DarkEden_Appear()
    call Register_DarkEden_Death()
    call Register_DarkEden_LightningColor()
endfunction

endlibrary
