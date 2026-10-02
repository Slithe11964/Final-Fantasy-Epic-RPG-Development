library TDarkPhoenix requires TCam, TCine, TLoc, TPlayerPart01, TText, TWait
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_DarkPhoenix_Appear=null
    trigger gg_trg_DarkPhoenix_Death=null
endglobals

function Trig_DarkPhoenix_Appear_InPhoenixRect takes nothing returns boolean
    return(RectContainsUnit(gg_rct_123,GetTriggerUnit()))or(RectContainsUnit(gg_rct_123,GetSpellTargetUnit()))
endfunction

function Trig_DarkPhoenix_Appear_IsFireSpell takes nothing returns boolean
    return(GetSpellAbilityId()=='A0PU')or(GetSpellAbilityId()=='A0QD')or(GetSpellAbilityId()=='A0AE')or(GetSpellAbilityId()=='A0V6')or(GetSpellAbilityId()=='A0RK')or(GetSpellAbilityId()=='A11R')or(GetSpellAbilityId()=='A0S8')or(GetSpellAbilityId()=='A0QA')or(GetSpellAbilityId()=='A19P')or(GetSpellAbilityId()=='A0UX') // 'A0PU': ability "Fire"; 'A0QD': ability "Firaga"; 'A0AE': ability "Rapid Fire"; 'A0V6': ability "Golem"; 'A0RK': ability "!Hellfire"; 'A11R': ability "Dragon Breath"; 'A0S8': ability "Enfire"; 'A0QA': ability "Fire"; 'A19P': ability "Fire"; 'A0UX': ability "Firaga"
endfunction

function Trig_DarkPhoenix_Appear_Conditions takes nothing returns boolean
    return(udg_InCinematicMode==false)and(Trig_DarkPhoenix_Appear_InPhoenixRect())and(Trig_DarkPhoenix_Appear_IsFireSpell())
endfunction

function Trig_DarkPhoenix_Appear_SummonIfrit_NoCine takes nothing returns boolean
    return(udg_Difficulty>=3)and(IsQuestCompleted(udg_SideQuest[50]))and(IsUnitInGroup(gg_unit_E00D_0043,udg_DarkEidolonGroup)==false)
endfunction

function Trig_DarkPhoenix_Appear_SummonIfrit_Cine takes nothing returns boolean
    return(udg_Difficulty>=3)and(IsQuestCompleted(udg_SideQuest[50]))and(IsUnitInGroup(gg_unit_E00D_0043,udg_DarkEidolonGroup)==false)
endfunction

function Trig_DarkPhoenix_Appear_CinematicsOn takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_DarkPhoenix_Appear_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    set udg_TempPoint=GetUnitLoc(gg_unit_H021_0034)
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(udg_TempPoint)
    call EnableTrigger(gg_trg_DarkPhoenix_Death)
    if(Trig_DarkPhoenix_Appear_CinematicsOn())then
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_H021_0034,0)
        call Wait_Polled(.5)
        call ShowUnitShow(gg_unit_H021_0034)
        call Text_Say(null,"|cffff0000Dark Phoenix has appeared!|r",true)
        if(Trig_DarkPhoenix_Appear_SummonIfrit_Cine())then
            set udg_DarkFireStage=6
            set udg_TempPoint=GetRectCenter(gg_rct_605)
            set udg_TempPoint2=GetUnitLoc(gg_unit_H021_0034)
            call SetUnitPositionLocFacingLocBJ(gg_unit_U00G_0220,udg_TempPoint,udg_TempPoint2)
            call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl")
            call DestroyEffectBJ(GetLastCreatedEffectBJ())
            call RemoveLocation(udg_TempPoint2)
            call RemoveLocation(udg_TempPoint)
            call Wait_Polled(.5)
            call ShowUnitShow(gg_unit_U00G_0220)
            call Wait_Polled(1.)
            call SetUnitAnimation(gg_unit_U00G_0220,"spell slam")
            call Wait_Polled(1.)
            set udg_TempPoint=GetUnitLoc(gg_unit_H021_0034)
            call AddSpecialEffectLocBJ(udg_TempPoint,"Objects\\Spawnmodels\\Other\\NeutralBuildingExplosion\\NeutralBuildingExplosion.mdl")
            call BlzSetSpecialEffectScale(GetLastCreatedEffectBJ(),5.)
            call DestroyEffectBJ(GetLastCreatedEffectBJ())
            set bj_forLoopAIndex=1
            set bj_forLoopAIndexEnd=$A // $A = 10
            loop
                exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
                // (loop counter A treated as a decimal-capable number) times (36).
                set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,256,(I2R(GetForLoopIndexA())*36.))
                call AddSpecialEffectLocBJ(udg_TempPoint2,"Objects\\Spawnmodels\\Other\\NeutralBuildingExplosion\\NeutralBuildingExplosion.mdl")
                call DestroyEffectBJ(GetLastCreatedEffectBJ())
                call RemoveLocation(udg_TempPoint2)
                set bj_forLoopAIndex=bj_forLoopAIndex+1
            endloop
            call TerrainDeformationRippleBJ(1.,false,udg_TempPoint,$400,$400,64,.5,512) // $400 = 1024
            call RemoveLocation(udg_TempPoint)
            call Wait_Polled(.5)
            set udg_TempPoint=GetUnitLoc(gg_unit_H021_0034)
            call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Other\\Doom\\DoomDeath.mdl")
            call BlzSetSpecialEffectScale(GetLastCreatedEffectBJ(),4.)
            call DestroyEffectBJ(GetLastCreatedEffectBJ())
            set bj_forLoopAIndex=1
            set bj_forLoopAIndexEnd=$C // $C = 12
            loop
                exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
                // (loop counter A treated as a decimal-capable number) times (30).
                set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,256,(I2R(GetForLoopIndexA())*30.))
                call AddSpecialEffectLocBJ(udg_TempPoint2,"Abilities\\Spells\\Other\\Doom\\DoomDeath.mdl")
                call BlzSetSpecialEffectScale(GetLastCreatedEffectBJ(),3.)
                call DestroyEffectBJ(GetLastCreatedEffectBJ())
                call RemoveLocation(udg_TempPoint2)
                set bj_forLoopAIndex=bj_forLoopAIndex+1
            endloop
            call RemoveLocation(udg_TempPoint)
            call Wait_Polled(.5)
            call KillUnit(gg_unit_H021_0034)
            set udg_TempPlayer=GetOwningPlayer(GetTriggerUnit())
            call Cam_PanToUnit(gg_unit_U00G_0220,.2)
            call ResetUnitAnimation(gg_unit_U00G_0220)
            call SetUnitFacingToFaceUnitTimed(gg_unit_U00G_0220,Player_GetHero(udg_TempPlayer),.4)
            call Text_Say(Player_GetHero(udg_TempPlayer),"Did... you just incinerate a Dark Eidolon of FIRE to death?",false)
            call Text_Say(gg_unit_U00G_0220,"Hmph. Those were weak flames.",false)
            call Text_Say(gg_unit_U00G_0220,"I've been watching you fight dark creatures made of flames and I figured now you seem more prepared to light my fires.",false)
            call Text_Say(gg_unit_U00G_0220,"Don't waste your time with small fry like this. You knew we were going to fight sooner or later ever since you held out against me.",false)
            call Text_Say(gg_unit_U00G_0220,"That time is now. And don't hold back or I'll turn you to cinders!",false)
            call Cine_ExitAction()
            call ConditionalTriggerExecute(gg_trg_Quest_BlazingDemon_Start)
        else
            set udg_DarkFireStage=(udg_DarkFireStage+1)
            call SetUnitInvulnerable(gg_unit_H021_0034,false)
            call PauseUnitBJ(false,gg_unit_H021_0034)
            call GroupAddUnitSimple(gg_unit_H021_0034,udg_BossGroup)
            call GroupAddUnitSimple(gg_unit_H021_0034,udg_BossUnits)
            call Cine_ExitAction()
        endif
    else
        call Wait_Polled(.5)
        call ShowUnitShow(gg_unit_H021_0034)
        call DisplayTimedTextToForce(udg_PlayingPlayers,10.,"|cffff0000Dark Phoenix has appeared!|r")
        if(Trig_DarkPhoenix_Appear_SummonIfrit_NoCine())then
            set udg_DarkFireStage=6
            set udg_TempPoint=GetRectCenter(gg_rct_605)
            set udg_TempPoint2=GetUnitLoc(gg_unit_H021_0034)
            call SetUnitPositionLocFacingLocBJ(gg_unit_U00G_0220,udg_TempPoint,udg_TempPoint2)
            call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl")
            call DestroyEffectBJ(GetLastCreatedEffectBJ())
            call RemoveLocation(udg_TempPoint2)
            call RemoveLocation(udg_TempPoint)
            call Wait_Polled(.5)
            call ShowUnitShow(gg_unit_U00G_0220)
            call Wait_Polled(1.)
            call SetUnitAnimation(gg_unit_U00G_0220,"spell slam")
            call Wait_Polled(1.)
            set udg_TempPoint=GetUnitLoc(gg_unit_H021_0034)
            call AddSpecialEffectLocBJ(udg_TempPoint,"Objects\\Spawnmodels\\Other\\NeutralBuildingExplosion\\NeutralBuildingExplosion.mdl")
            call BlzSetSpecialEffectScale(GetLastCreatedEffectBJ(),5.)
            call DestroyEffectBJ(GetLastCreatedEffectBJ())
            set bj_forLoopAIndex=1
            set bj_forLoopAIndexEnd=$A // $A = 10
            loop
                exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
                // (loop counter A treated as a decimal-capable number) times (36).
                set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,256,(I2R(GetForLoopIndexA())*36.))
                call AddSpecialEffectLocBJ(udg_TempPoint2,"Objects\\Spawnmodels\\Other\\NeutralBuildingExplosion\\NeutralBuildingExplosion.mdl")
                call DestroyEffectBJ(GetLastCreatedEffectBJ())
                call RemoveLocation(udg_TempPoint2)
                set bj_forLoopAIndex=bj_forLoopAIndex+1
            endloop
            call TerrainDeformationRippleBJ(1.,false,udg_TempPoint,$400,$400,64,.5,512) // $400 = 1024
            call RemoveLocation(udg_TempPoint)
            call Wait_Polled(.5)
            set udg_TempPoint=GetUnitLoc(gg_unit_H021_0034)
            call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Other\\Doom\\DoomDeath.mdl")
            call BlzSetSpecialEffectScale(GetLastCreatedEffectBJ(),4.)
            call DestroyEffectBJ(GetLastCreatedEffectBJ())
            set bj_forLoopAIndex=1
            set bj_forLoopAIndexEnd=$C // $C = 12
            loop
                exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
                // (loop counter A treated as a decimal-capable number) times (30).
                set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,256,(I2R(GetForLoopIndexA())*30.))
                call AddSpecialEffectLocBJ(udg_TempPoint2,"Abilities\\Spells\\Other\\Doom\\DoomDeath.mdl")
                call BlzSetSpecialEffectScale(GetLastCreatedEffectBJ(),3.)
                call DestroyEffectBJ(GetLastCreatedEffectBJ())
                call RemoveLocation(udg_TempPoint2)
                set bj_forLoopAIndex=bj_forLoopAIndex+1
            endloop
            call RemoveLocation(udg_TempPoint)
            call Wait_Polled(.5)
            call KillUnit(gg_unit_H021_0034)
            call ResetUnitAnimation(gg_unit_U00G_0220)
            call ConditionalTriggerExecute(gg_trg_Quest_BlazingDemon_Start)
        else
            set udg_DarkFireStage=(udg_DarkFireStage+1)
            call SetUnitInvulnerable(gg_unit_H021_0034,false)
            call PauseUnitBJ(false,gg_unit_H021_0034)
            call GroupAddUnitSimple(gg_unit_H021_0034,udg_BossGroup)
            call GroupAddUnitSimple(gg_unit_H021_0034,udg_BossUnits)
        endif
    endif
endfunction

function Trig_DarkPhoenix_Death_DarkQuezacotlDead takes nothing returns boolean
    return(IsUnitInGroup(gg_unit_H01N_0035,udg_DarkEidolonGroup)==false)
endfunction

function Trig_DarkPhoenix_Death_KillerIsPlayer takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetKillingUnitBJ()),udg_PlayingPlayers))
endfunction

function Trig_DarkPhoenix_Death_DarkFireStageFinal takes nothing returns boolean
    return(udg_DarkFireStage==5)
endfunction

function Trig_DarkPhoenix_Death_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    if(Trig_DarkPhoenix_Death_DarkQuezacotlDead())then
        call RemoveItemFromStockBJ('I07T',gg_unit_n02Y_0052) // 'I07T': item "Information: Dark Quezacotl/Phoenix"
    endif
    set udg_DarkFireStage=(udg_DarkFireStage+1)
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    if(Trig_DarkPhoenix_Death_DarkFireStageFinal())then
        if(Trig_DarkPhoenix_Death_KillerIsPlayer())then
            set udg_CinematicActor=Player_GetHero(GetOwningPlayer(GetKillingUnitBJ()))
        else
            set udg_CinematicActor=Player_GetHero(ForcePickRandomPlayer(udg_PlayingPlayers))
        endif
        call ConditionalTriggerExecute(gg_trg_BlazingDemon_Appear)
    else
        call RemoveLocation(udg_TempPoint)
    endif
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_DarkPhoenix automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_DarkPhoenix (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_DarkPhoenix takes nothing returns nothing
endfunction

function Register_DarkPhoenix_Appear takes nothing returns nothing
    set gg_trg_DarkPhoenix_Appear=CreateTrigger()
    call DisableTrigger(gg_trg_DarkPhoenix_Appear)
    call TriggerRegisterAnyUnitEventBJ(gg_trg_DarkPhoenix_Appear,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_DarkPhoenix_Appear,Condition(function Trig_DarkPhoenix_Appear_Conditions))
    call TriggerAddAction(gg_trg_DarkPhoenix_Appear,function Trig_DarkPhoenix_Appear_Actions)
endfunction

function Register_DarkPhoenix_Death takes nothing returns nothing
    set gg_trg_DarkPhoenix_Death=CreateTrigger()
    call DisableTrigger(gg_trg_DarkPhoenix_Death)
    call TriggerRegisterUnitEvent(gg_trg_DarkPhoenix_Death,gg_unit_H021_0034,EVENT_UNIT_DEATH)
    call TriggerAddAction(gg_trg_DarkPhoenix_Death,function Trig_DarkPhoenix_Death_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_DarkPhoenix takes nothing returns nothing
    call Register_DarkPhoenix_Appear() // starts off; enabled by DarkEidolons
    call Register_DarkPhoenix_Death() // starts off; enabled by DarkPhoenix
endfunction

endlibrary
