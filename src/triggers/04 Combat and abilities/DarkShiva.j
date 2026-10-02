library TDarkShiva requires TBerserk, TCam, TCine, TLoc, TText, TWait
function Trig_DarkShiva_Appear_Conditions takes nothing returns boolean
    return((IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(GetUnitTypeId(GetTriggerUnit())!='H01D')and(udg_InCinematicMode==false)and(udg_HellSpawnsActive==false))!=null // 'H01D': unit "Spirit of Gaya"
endfunction

function Trig_DarkShiva_Appear_CinematicsOn takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_DarkShiva_Appear_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    set udg_TempPoint=GetUnitLoc(gg_unit_E00C_0046)
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(udg_TempPoint)
    if(Trig_DarkShiva_Appear_CinematicsOn())then
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_E00C_0046,0)
        call Wait_Polled(.5)
        call ShowUnitShow(gg_unit_E00C_0046)
        call Text_Say(null,"|cff0000ffDark Shiva has appeared!|r",true)
        call Cine_ExitAction()
    else
        call Wait_Polled(.5)
        call ShowUnitShow(gg_unit_E00C_0046)
        call DisplayTimedTextToForce(udg_PlayingPlayers,10.,"|cff0000ffDark Shiva has appeared!|r")
    endif
    call SetUnitInvulnerable(gg_unit_E00C_0046,false)
    call PauseUnitBJ(false,gg_unit_E00C_0046)
    call GroupAddUnitSimple(gg_unit_E00C_0046,udg_BossGroup)
    call GroupAddUnitSimple(gg_unit_E00C_0046,udg_BossUnits)
    call UnitAddAbilityBJ('A0ZR',gg_unit_E00C_0046) // 'A0ZR': ability "Immortal"
    call EnableTrigger(gg_trg_DarkShiva_Phase2)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_DarkShiva_Phase2_CinematicsOn takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_DarkShiva_Phase2_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call Berserk_Remove(GetTriggerUnit())
    set udg_TempPoint=GetUnitLoc(gg_unit_E00C_0046)
    // The remainder after dividing ((facing in degrees of gg_unit_E00C_0046) plus (90)) by (360).
    set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,256,ModuloReal((GetUnitFacing(gg_unit_E00C_0046)+90.),360.))
    call SetUnitPositionLocFacingBJ(gg_unit_H01S_0045,udg_TempPoint2,GetUnitFacing(gg_unit_E00C_0046))
    call AddSpecialEffectLocBJ(udg_TempPoint2,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(udg_TempPoint2)
    // The remainder after dividing ((facing in degrees of gg_unit_E00C_0046) plus (270)) by (360).
    set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,256,ModuloReal((GetUnitFacing(gg_unit_E00C_0046)+270.),360.))
    call SetUnitPositionLocFacingBJ(gg_unit_H01T_0044,udg_TempPoint2,GetUnitFacing(gg_unit_E00C_0046))
    call AddSpecialEffectLocBJ(udg_TempPoint2,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(udg_TempPoint2)
    call RemoveLocation(udg_TempPoint)
    call SetUnitInvulnerable(gg_unit_E00C_0046,true)
    if(Trig_DarkShiva_Phase2_CinematicsOn())then
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_E00C_0046,0)
        call Wait_Polled(.5)
        call SetUnitLifePercentBJ(gg_unit_E00C_0046,'d')
        call ShowUnitShow(gg_unit_H01S_0045)
        call ShowUnitShow(gg_unit_H01T_0044)
        call SetUnitFacingToFaceUnitTimed(gg_unit_E00C_0046,gg_unit_H01S_0045,.2)
        call Text_Say(gg_unit_H01S_0045,"|cff555555We will help you, Shiva!|r",true)
        set udg_TempPoint=GetUnitLoc(gg_unit_E00C_0046)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\Resurrect\\ResurrectTarget.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        call SetUnitFacingToFaceUnitTimed(gg_unit_E00C_0046,gg_unit_H01T_0044,.2)
        call Text_Say(gg_unit_H01T_0044,"|cff555555Yes... we will.|r",true)
        call SetUnitFacingTimed(gg_unit_E00C_0046,GetUnitFacing(gg_unit_H01S_0045),.2)
        call Text_Say(null,"|cffbb00ccDark Pandemona and Dark Typhon have appeared!|r",true)
        call Cine_ExitAction()
    else
        call PauseUnitBJ(true,gg_unit_E00C_0046)
        set udg_TempPoint=GetUnitLoc(gg_unit_E00C_0046)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\Resurrect\\ResurrectTarget.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        call Wait_Polled(.5)
        call SetUnitLifePercentBJ(gg_unit_E00C_0046,'d')
        call ShowUnitShow(gg_unit_H01S_0045)
        call ShowUnitShow(gg_unit_H01T_0044)
        call DisplayTimedTextToForce(udg_PlayingPlayers,10.,"|cffbb00ccDark Pandemona and Dark Typhon have appeared!|r")
        call Wait_Polled(1.)
        call PauseUnitBJ(false,gg_unit_E00C_0046)
    endif
    call GroupAddUnitSimple(gg_unit_H01S_0045,udg_BossGroup)
    call GroupAddUnitSimple(gg_unit_H01T_0044,udg_BossGroup)
    call GroupAddUnitSimple(gg_unit_H01S_0045,udg_BossUnits)
    call GroupAddUnitSimple(gg_unit_H01T_0044,udg_BossUnits)
    call SetUnitInvulnerable(gg_unit_H01S_0045,false)
    call SetUnitInvulnerable(gg_unit_H01T_0044,false)
    call SetUnitInvulnerable(gg_unit_E00C_0046,false)
    call PauseUnitBJ(false,gg_unit_H01S_0045)
    call PauseUnitBJ(false,gg_unit_H01T_0044)
    call UnitRemoveAbilityBJ('A0ZR',gg_unit_E00C_0046) // 'A0ZR': ability "Immortal"
    call EnableTrigger(gg_trg_DarkShiva_Death)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_DarkShiva_Death_DarkIfritDead takes nothing returns boolean
    return(IsUnitInGroup(gg_unit_E00D_0043,udg_DarkEidolonGroup)==false)
endfunction

function Trig_DarkShiva_Death_Minion1Alive takes nothing returns boolean
    return(IsUnitInGroup(gg_unit_H01S_0045,udg_DarkEidolonGroup))
endfunction

function Trig_DarkShiva_Death_Minion2Alive takes nothing returns boolean
    return(IsUnitInGroup(gg_unit_H01T_0044,udg_DarkEidolonGroup))
endfunction

function Trig_DarkShiva_Death_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    if(Trig_DarkShiva_Death_DarkIfritDead())then
        call RemoveItemFromStockBJ('I07S',gg_unit_n02Y_0052) // 'I07S': item "Information: Dark Ifrit/Shiva"
    endif
    if(Trig_DarkShiva_Death_Minion1Alive())then
        set udg_TempPoint=GetUnitLoc(gg_unit_H01S_0045)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\NightElf\\BattleRoar\\RoarCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        call UnitAddAbilityBJ('A0BY',gg_unit_H01S_0045) // 'A0BY': ability "Grief"
    endif
    if(Trig_DarkShiva_Death_Minion2Alive())then
        set udg_TempPoint=GetUnitLoc(gg_unit_H01T_0044)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\NightElf\\BattleRoar\\RoarCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        call UnitAddAbilityBJ('A0BY',gg_unit_H01T_0044) // 'A0BY': ability "Grief"
    endif
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_DarkShiva automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_DarkShiva (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_DarkShiva takes nothing returns nothing
endfunction

function Register_DarkShiva_Appear takes nothing returns nothing
    set gg_trg_DarkShiva_Appear=CreateTrigger()
    call DisableTrigger(gg_trg_DarkShiva_Appear)
    call TriggerRegisterEnterRectSimple(gg_trg_DarkShiva_Appear,gg_rct_126)
    call TriggerAddCondition(gg_trg_DarkShiva_Appear,Condition(function Trig_DarkShiva_Appear_Conditions))
    call TriggerAddAction(gg_trg_DarkShiva_Appear,function Trig_DarkShiva_Appear_Actions)
endfunction

function Register_DarkShiva_Phase2 takes nothing returns nothing
    set gg_trg_DarkShiva_Phase2=CreateTrigger()
    call DisableTrigger(gg_trg_DarkShiva_Phase2)
    call TriggerRegisterUnitLifeEvent(gg_trg_DarkShiva_Phase2,gg_unit_E00C_0046,LESS_THAN,100.)
    call TriggerAddAction(gg_trg_DarkShiva_Phase2,function Trig_DarkShiva_Phase2_Actions)
endfunction

function Register_DarkShiva_Death takes nothing returns nothing
    set gg_trg_DarkShiva_Death=CreateTrigger()
    call DisableTrigger(gg_trg_DarkShiva_Death)
    call TriggerRegisterUnitEvent(gg_trg_DarkShiva_Death,gg_unit_E00C_0046,EVENT_UNIT_DEATH)
    call TriggerAddAction(gg_trg_DarkShiva_Death,function Trig_DarkShiva_Death_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_DarkShiva takes nothing returns nothing
    call Register_DarkShiva_Appear()
    call Register_DarkShiva_Phase2()
    call Register_DarkShiva_Death()
endfunction

endlibrary
