library TBossAgrias requires TCam, TCine, TPlayerPart01, TText, TWait
function Trig_Boss_Agrias_Intro_Conditions takes nothing returns boolean
    return((IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(udg_InCinematicMode==false))!=null
endfunction

function Trig_Boss_Agrias_Intro_Cond_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Boss_Agrias_Intro_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call SetUnitFacingToFaceUnitTimed(gg_unit_Ewrd_0120,GetTriggerUnit(),.0)
    if(Trig_Boss_Agrias_Intro_Cond_CinematicsEnabled())then
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_Ewrd_0120,0)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"Agrias. We have come to grant you freedom from the Zodiac Demon... the freedom of death.",false)
        call Text_Say(gg_unit_Ewrd_0120,"Hmph. Then you shall die as well.",false)
        call Cine_ExitAction()
    endif
    call SetUnitInvulnerable(gg_unit_Ewrd_0120,false)
    call PauseUnitBJ(false,gg_unit_Ewrd_0120)
    call UnitRemoveAbilityBJ('A0VJ',gg_unit_Ewrd_0120) // 'A0VJ': ability "Unaffected by Cinematics"
    call EnableTrigger(gg_trg_Boss_Agrias_Death_Lilith)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Boss_Agrias_Death_Lilith_Cond_CinematicRunning takes nothing returns boolean
    return(udg_InCinematicMode)
endfunction

function Trig_Boss_Agrias_Death_Lilith_Cond_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Boss_Agrias_Death_Lilith_Cond_LilithAlive takes nothing returns boolean
    return(IsUnitAliveBJ(gg_unit_e009_0118))
endfunction

function Trig_Boss_Agrias_Death_Lilith_Actions takes nothing returns nothing
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call ReviveHeroLoc(gg_unit_Ewrd_0120,udg_TempPoint,false)
    call RemoveLocation(udg_TempPoint)
    if(Trig_Boss_Agrias_Death_Lilith_Cond_CinematicRunning())then
        call SetUnitLifeBJ(GetTriggerUnit(),1.)
        return
    endif
    call DisableTrigger(GetTriggeringTrigger())
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_BossUnits)
    call SetUnitFacingTimed(gg_unit_e009_0118,GetUnitFacing(GetTriggerUnit()),0)
    if(Trig_Boss_Agrias_Death_Lilith_Cond_CinematicsEnabled())then
        call SetUnitInvulnerable(GetTriggerUnit(),true)
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Wait_Polled(2.)
        call Text_Say(gg_unit_Ewrd_0120,"Virgo! Give me your power!",false)
        set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Undead\\AnimateDead\\AnimateDeadTarget.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call SetUnitPositionLoc(gg_unit_e009_0118,udg_TempPoint)
        call RemoveLocation(udg_TempPoint)
        call ShowUnitShow(gg_unit_e009_0118)
        call RemoveUnit(GetTriggerUnit())
        call Wait_Polled(2.)
        call Text_Transmission(gg_unit_e009_0118,"Lilith","Embrace the end!","(null)",gg_snd_DarkRangerYesAttack,0,false)
        call Cine_ExitAction()
    else
        set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Undead\\AnimateDead\\AnimateDeadTarget.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call SetUnitPositionLoc(gg_unit_e009_0118,udg_TempPoint)
        call RemoveLocation(udg_TempPoint)
        call RemoveUnit(GetTriggerUnit())
        call ShowUnitShow(gg_unit_e009_0118)
    endif
    call QuestMessageBJ(udg_PlayingPlayers,bj_QUESTMESSAGE_UPDATED,"Kill Shadow Queen Lilith")
    call QuestSetDescriptionBJ(udg_SideQuest[31],"Kill Shadow Queen Lilith")
    call SetUnitInvulnerable(gg_unit_e009_0118,false)
    call PauseUnitBJ(false,gg_unit_e009_0118)
    call IssueImmediateOrderBJ(gg_unit_e009_0118,"spiritwolf")
    call GroupAddUnitSimple(gg_unit_e009_0118,udg_BossUnits)
    call EnableTrigger(gg_trg_Boss_Lilith_Death)
    call Wait_Polled(2)
    if(Trig_Boss_Agrias_Death_Lilith_Cond_LilithAlive())then
        call SetUnitInvulnerable(gg_unit_Eill_0119,false)
        call UnitAddAbilityBJ('A0ZR',gg_unit_Eill_0119) // 'A0ZR': ability "Immortal"
        call SetUnitOwner(gg_unit_Eill_0119,Player(9),true)
        set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
        call SetUnitPositionLocFacingBJ(gg_unit_Eill_0119,udg_TempPoint,bj_UNIT_FACING)
        call RemoveLocation(udg_TempPoint)
    endif
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function InitTrig_Boss_Agrias takes nothing returns nothing
endfunction

endlibrary
