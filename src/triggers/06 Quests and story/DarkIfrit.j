library TDarkIfrit requires TCam, TCine, TLoc, TPlayerHero, TText, TWait
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_DarkIfrit_Appear=null
    trigger gg_trg_DarkIfrit_Death=null
endglobals

function Trig_DarkIfrit_Appear_Conditions takes nothing returns boolean
    return((IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(GetUnitTypeId(GetTriggerUnit())!='H01D')and(udg_InCinematicMode==false))!=null // 'H01D': unit "Spirit of Gaya"
endfunction

function Trig_DarkIfrit_Appear_SummonIfrit_NoCine takes nothing returns boolean
    return(udg_Difficulty>=3)and(IsQuestCompleted(udg_SideQuest[50]))and(IsUnitInGroup(gg_unit_H021_0034,udg_DarkEidolonGroup)==false)
endfunction

function Trig_DarkIfrit_Appear_SummonIfrit_Cine takes nothing returns boolean
    return(udg_Difficulty>=3)and(IsQuestCompleted(udg_SideQuest[50]))and(IsUnitInGroup(gg_unit_H021_0034,udg_DarkEidolonGroup)==false)
endfunction

function Trig_DarkIfrit_Appear_CinematicsOn takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_DarkIfrit_Appear_Actions takes nothing returns nothing
    local location l_tempPoint
    call DisableTrigger(GetTriggeringTrigger())
    set l_tempPoint=GetUnitLoc(gg_unit_E00D_0043)
    call AddSpecialEffectLocBJ(l_tempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(l_tempPoint)
    call EnableTrigger(gg_trg_DarkIfrit_Death)
    if(Trig_DarkIfrit_Appear_CinematicsOn())then
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_E00D_0043,0)
        call Wait_Polled(.5)
        call ShowUnitShow(gg_unit_E00D_0043)
        call Text_Say(null,"|cffbf0000Dark Ifrit has appeared!|r",true)
        if(Trig_DarkIfrit_Appear_SummonIfrit_Cine())then
            set udg_DarkFireStage=6
            set l_tempPoint=GetRectCenter(gg_rct_606)
            set udg_TempPoint2=GetUnitLoc(gg_unit_E00D_0043)
            call SetUnitPositionLocFacingLocBJ(gg_unit_U00G_0220,l_tempPoint,udg_TempPoint2)
            call AddSpecialEffectLocBJ(l_tempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl")
            call DestroyEffectBJ(GetLastCreatedEffectBJ())
            call RemoveLocation(udg_TempPoint2)
            call RemoveLocation(l_tempPoint)
            call Wait_Polled(.5)
            call ShowUnitShow(gg_unit_U00G_0220)
            call Wait_Polled(1.)
            call SetUnitAnimation(gg_unit_U00G_0220,"spell slam")
            call Wait_Polled(1.)
            set l_tempPoint=GetUnitLoc(gg_unit_E00D_0043)
            call AddSpecialEffectLocBJ(l_tempPoint,"Objects\\Spawnmodels\\Other\\NeutralBuildingExplosion\\NeutralBuildingExplosion.mdl")
            call BlzSetSpecialEffectScale(GetLastCreatedEffectBJ(),5.)
            call DestroyEffectBJ(GetLastCreatedEffectBJ())
            set bj_forLoopAIndex=1
            set bj_forLoopAIndexEnd=$A // $A = 10
            loop
                exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
                set udg_TempPoint2=Loc_PolarOffset(l_tempPoint,256,(I2R(GetForLoopIndexA())*36.))
                call AddSpecialEffectLocBJ(udg_TempPoint2,"Objects\\Spawnmodels\\Other\\NeutralBuildingExplosion\\NeutralBuildingExplosion.mdl")
                call DestroyEffectBJ(GetLastCreatedEffectBJ())
                call RemoveLocation(udg_TempPoint2)
                set bj_forLoopAIndex=bj_forLoopAIndex+1
            endloop
            call TerrainDeformationRippleBJ(1.,false,l_tempPoint,$400,$400,64,.5,512) // $400 = 1024
            call RemoveLocation(l_tempPoint)
            call Wait_Polled(.5)
            set l_tempPoint=GetUnitLoc(gg_unit_E00D_0043)
            call AddSpecialEffectLocBJ(l_tempPoint,"Abilities\\Spells\\Other\\Doom\\DoomDeath.mdl")
            call BlzSetSpecialEffectScale(GetLastCreatedEffectBJ(),4.)
            call DestroyEffectBJ(GetLastCreatedEffectBJ())
            set bj_forLoopAIndex=1
            set bj_forLoopAIndexEnd=$C // $C = 12
            loop
                exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
                set udg_TempPoint2=Loc_PolarOffset(l_tempPoint,256,(I2R(GetForLoopIndexA())*30.))
                call AddSpecialEffectLocBJ(udg_TempPoint2,"Abilities\\Spells\\Other\\Doom\\DoomDeath.mdl")
                call BlzSetSpecialEffectScale(GetLastCreatedEffectBJ(),3.)
                call DestroyEffectBJ(GetLastCreatedEffectBJ())
                call RemoveLocation(udg_TempPoint2)
                set bj_forLoopAIndex=bj_forLoopAIndex+1
            endloop
            call RemoveLocation(l_tempPoint)
            call Wait_Polled(.5)
            call KillUnit(gg_unit_E00D_0043)
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
            call SetUnitInvulnerable(gg_unit_E00D_0043,false)
            call PauseUnitBJ(false,gg_unit_E00D_0043)
            call GroupAddUnitSimple(gg_unit_E00D_0043,udg_BossGroup)
            call GroupAddUnitSimple(gg_unit_E00D_0043,udg_BossUnits)
            call GroupAddUnitSimple(gg_unit_E00D_0043,udg_ImmolationAuraGroup)
            call Cine_ExitAction()
        endif
    else
        call Wait_Polled(.5)
        call ShowUnitShow(gg_unit_E00D_0043)
        call DisplayTimedTextToForce(udg_PlayingPlayers,10.,"|cffbf0000Dark Ifrit has appeared!|r")
        if(Trig_DarkIfrit_Appear_SummonIfrit_NoCine())then
            set udg_DarkFireStage=6
            set l_tempPoint=GetRectCenter(gg_rct_606)
            set udg_TempPoint2=GetUnitLoc(gg_unit_E00D_0043)
            call SetUnitPositionLocFacingLocBJ(gg_unit_U00G_0220,l_tempPoint,udg_TempPoint2)
            call AddSpecialEffectLocBJ(l_tempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl")
            call DestroyEffectBJ(GetLastCreatedEffectBJ())
            call RemoveLocation(udg_TempPoint2)
            call RemoveLocation(l_tempPoint)
            call Wait_Polled(.5)
            call ShowUnitShow(gg_unit_U00G_0220)
            call Wait_Polled(1.)
            call SetUnitAnimation(gg_unit_U00G_0220,"spell slam")
            call Wait_Polled(1.)
            set l_tempPoint=GetUnitLoc(gg_unit_E00D_0043)
            call AddSpecialEffectLocBJ(l_tempPoint,"Objects\\Spawnmodels\\Other\\NeutralBuildingExplosion\\NeutralBuildingExplosion.mdl")
            call BlzSetSpecialEffectScale(GetLastCreatedEffectBJ(),5.)
            call DestroyEffectBJ(GetLastCreatedEffectBJ())
            set bj_forLoopAIndex=1
            set bj_forLoopAIndexEnd=$A // $A = 10
            loop
                exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
                set udg_TempPoint2=Loc_PolarOffset(l_tempPoint,256,(I2R(GetForLoopIndexA())*36.))
                call AddSpecialEffectLocBJ(udg_TempPoint2,"Objects\\Spawnmodels\\Other\\NeutralBuildingExplosion\\NeutralBuildingExplosion.mdl")
                call DestroyEffectBJ(GetLastCreatedEffectBJ())
                call RemoveLocation(udg_TempPoint2)
                set bj_forLoopAIndex=bj_forLoopAIndex+1
            endloop
            call TerrainDeformationRippleBJ(1.,false,l_tempPoint,$400,$400,64,.5,512) // $400 = 1024
            call RemoveLocation(l_tempPoint)
            call Wait_Polled(.5)
            set l_tempPoint=GetUnitLoc(gg_unit_E00D_0043)
            call AddSpecialEffectLocBJ(l_tempPoint,"Abilities\\Spells\\Other\\Doom\\DoomDeath.mdl")
            call BlzSetSpecialEffectScale(GetLastCreatedEffectBJ(),4.)
            call DestroyEffectBJ(GetLastCreatedEffectBJ())
            set bj_forLoopAIndex=1
            set bj_forLoopAIndexEnd=$C // $C = 12
            loop
                exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
                set udg_TempPoint2=Loc_PolarOffset(l_tempPoint,256,(I2R(GetForLoopIndexA())*30.))
                call AddSpecialEffectLocBJ(udg_TempPoint2,"Abilities\\Spells\\Other\\Doom\\DoomDeath.mdl")
                call BlzSetSpecialEffectScale(GetLastCreatedEffectBJ(),3.)
                call DestroyEffectBJ(GetLastCreatedEffectBJ())
                call RemoveLocation(udg_TempPoint2)
                set bj_forLoopAIndex=bj_forLoopAIndex+1
            endloop
            call RemoveLocation(l_tempPoint)
            call Wait_Polled(.5)
            call KillUnit(gg_unit_E00D_0043)
            call ResetUnitAnimation(gg_unit_U00G_0220)
            call ConditionalTriggerExecute(gg_trg_Quest_BlazingDemon_Start)
        else
            set udg_DarkFireStage=(udg_DarkFireStage+1)
            call SetUnitInvulnerable(gg_unit_E00D_0043,false)
            call PauseUnitBJ(false,gg_unit_E00D_0043)
            call GroupAddUnitSimple(gg_unit_E00D_0043,udg_BossGroup)
            call GroupAddUnitSimple(gg_unit_E00D_0043,udg_BossUnits)
            call GroupAddUnitSimple(gg_unit_E00D_0043,udg_ImmolationAuraGroup)
        endif
    endif
    set l_tempPoint=null
endfunction

function Trig_DarkIfrit_Death_DarkShivaDead takes nothing returns boolean
    return(IsUnitInGroup(gg_unit_E00C_0046,udg_DarkEidolonGroup)==false)
endfunction

function Trig_DarkIfrit_Death_KillerIsPlayer takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetKillingUnitBJ()),udg_PlayingPlayers))
endfunction

function Trig_DarkIfrit_Death_DarkFireStageFinal takes nothing returns boolean
    return(udg_DarkFireStage==5)
endfunction

function Trig_DarkIfrit_Death_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_ImmolationAuraGroup)
    if(Trig_DarkIfrit_Death_DarkShivaDead())then
        call RemoveItemFromStockBJ('I07S',gg_unit_n02Y_0052) // 'I07S': item "Information: Dark Ifrit/Shiva"
    endif
    set udg_DarkFireStage=(udg_DarkFireStage+1)
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    if(Trig_DarkIfrit_Death_DarkFireStageFinal())then
        if(Trig_DarkIfrit_Death_KillerIsPlayer())then
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

// World Editor calls InitTrig_DarkIfrit automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_DarkIfrit (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_DarkIfrit takes nothing returns nothing
endfunction

function Register_DarkIfrit_Appear takes nothing returns nothing
    set gg_trg_DarkIfrit_Appear=CreateTrigger()
    call DisableTrigger(gg_trg_DarkIfrit_Appear)
    call TriggerRegisterEnterRectSimple(gg_trg_DarkIfrit_Appear,gg_rct_120)
    call TriggerAddCondition(gg_trg_DarkIfrit_Appear,Condition(function Trig_DarkIfrit_Appear_Conditions))
    call TriggerAddAction(gg_trg_DarkIfrit_Appear,function Trig_DarkIfrit_Appear_Actions)
endfunction

function Register_DarkIfrit_Death takes nothing returns nothing
    set gg_trg_DarkIfrit_Death=CreateTrigger()
    call DisableTrigger(gg_trg_DarkIfrit_Death)
    call TriggerRegisterUnitEvent(gg_trg_DarkIfrit_Death,gg_unit_E00D_0043,EVENT_UNIT_DEATH)
    call TriggerAddAction(gg_trg_DarkIfrit_Death,function Trig_DarkIfrit_Death_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_DarkIfrit takes nothing returns nothing
    call Register_DarkIfrit_Appear() // starts off; enabled by DarkEidolons
    call Register_DarkIfrit_Death() // starts off; enabled by DarkIfrit
endfunction

endlibrary
