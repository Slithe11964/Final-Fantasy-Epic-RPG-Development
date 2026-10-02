library TDarkBahamut requires TBerserk, TCam, TCine, TLoc, TMusic, TPlayerPart01, TText, TWait
function Trig_DarkBahamut_Riddle_Conditions takes nothing returns boolean
    return(GetTriggerUnit()==gg_unit_n043_0021)and(udg_InCinematicMode==false)
endfunction

function Trig_DarkBahamut_Riddle_IsAnswer1 takes nothing returns boolean
    return(GetSpellAbilityId()=='A0F9') // 'A0F9': ability "Answer"
endfunction

function Trig_DarkBahamut_Riddle_HeroInPillarRect takes nothing returns boolean
    return(RectContainsUnit(gg_rct_497,udg_PlayerHero[GetForLoopIndexA()]))and(GetUnitAbilityLevelSwapped('Avul',udg_PlayerHero[GetForLoopIndexA()])<=0) // 'Avul': standard ability reference "Invulnerable"
endfunction

function Trig_DarkBahamut_Riddle_PunishHero takes nothing returns nothing
    if(Trig_DarkBahamut_Riddle_HeroInPillarRect())then
        // ((current health of Player_GetHero(the player being visited)) divided by (2)) plus (1).
        call SetUnitLifeBJ(Player_GetHero(GetEnumPlayer()),((GetUnitStateSwap(UNIT_STATE_LIFE,Player_GetHero(GetEnumPlayer()))/ 2.)+1))
        call PlaySoundBJ(gg_snd_LightningBolt)
        set udg_TempPoint=GetRandomLocInRect(gg_rct_492)
        call SetUnitPositionLocFacingBJ(Player_GetHero(GetEnumPlayer()),udg_TempPoint,GetRandomDirectionDeg())
        call PanCameraToTimedLocForPlayer(GetEnumPlayer(),udg_TempPoint,0)
        call RemoveLocation(udg_TempPoint)
        call AddSpecialEffectTargetUnitBJ("origin",Player_GetHero(GetEnumPlayer()),"Abilities\\Spells\\Undead\\DeathCoil\\DeathCoilSpecialArt.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call AddSpecialEffectTargetUnitBJ("origin",Player_GetHero(GetEnumPlayer()),"Abilities\\Spells\\Orc\\FeralSpirit\\feralspiritdone.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call AddSpecialEffectTargetUnitBJ("origin",Player_GetHero(GetEnumPlayer()),"Abilities\\Spells\\Demon\\DemonBoltImpact\\DemonBoltImpact.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
    endif
endfunction

function Trig_DarkBahamut_Riddle_IsAnswer2 takes nothing returns boolean
    return(GetSpellAbilityId()=='A0G9') // 'A0G9': ability "Answer"
endfunction

function Trig_DarkBahamut_Riddle_IsAnswer3 takes nothing returns boolean
    return(GetSpellAbilityId()=='A0GA') // 'A0GA': ability "Answer"
endfunction

function Trig_DarkBahamut_Riddle_IsAnswer4Or5 takes nothing returns boolean
    return(GetSpellAbilityId()=='A0GB')or(GetSpellAbilityId()=='A0GC') // 'A0GB': ability "Answer"; 'A0GC': ability "Answer"
endfunction

function Trig_DarkBahamut_Riddle_Check_Answer4Or5 takes nothing returns boolean
    return(Trig_DarkBahamut_Riddle_IsAnswer4Or5())
endfunction

function Trig_DarkBahamut_Riddle_CinematicsOn takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_DarkBahamut_Riddle_IsAnswer6 takes nothing returns boolean
    return(GetSpellAbilityId()=='A0GD') // 'A0GD': ability "Answer"
endfunction

function Trig_DarkBahamut_Riddle_Actions takes nothing returns nothing
    if(Trig_DarkBahamut_Riddle_IsAnswer1())then
        set udg_TempPoint=GetUnitLoc(gg_unit_n043_0021)
        call CreateNUnitsAtLoc(1,'n041',Player($B),udg_TempPoint,160.) // 'n041': unit "Ruby Dragon"; $B = 11
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Orc\\FeralSpirit\\feralspiritdone.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        call Music_SetTrack(19)
        call EnableTrigger(gg_trg_DarkBahamut_DragonDeath)
        call TriggerRegisterUnitEvent(gg_trg_DarkBahamut_DragonDeath,GetLastCreatedUnit(),EVENT_UNIT_DEATH)
        call UnitRemoveAbilityBJ('Ane2',gg_unit_n043_0021) // 'Ane2': object name not found in map data
        call UnitRemoveAbilityBJ('A0G6',gg_unit_n043_0021) // 'A0G6': ability "Light Pillar Question"
        call UnitRemoveAbilityBJ('A0F9',gg_unit_n043_0021) // 'A0F9': ability "Answer"
        call UnitAddAbilityBJ('A0G7',gg_unit_n043_0021) // 'A0G7': ability "Light Pillar Question"
        call UnitAddAbilityBJ('A0G9',gg_unit_n043_0021) // 'A0G9': ability "Answer"
        call UnitAddAbilityBJ('A0GA',gg_unit_n043_0021) // 'A0GA': ability "Answer"
        return
    endif
    if(Trig_DarkBahamut_Riddle_IsAnswer2())then
        call ForForce(udg_PlayingPlayers,function Trig_DarkBahamut_Riddle_PunishHero)
        call UnitRemoveAbilityBJ('Ane2',gg_unit_n043_0021) // 'Ane2': object name not found in map data
        call Wait_Polled(5.)
        call UnitAddAbilityBJ('Ane2',gg_unit_n043_0021) // 'Ane2': object name not found in map data
        return
    endif
    if(Trig_DarkBahamut_Riddle_IsAnswer3())then
        set udg_TempPoint=GetUnitLoc(gg_unit_n043_0021)
        call CreateNUnitsAtLoc(1,'n041',Player($B),udg_TempPoint,160.) // 'n041': unit "Ruby Dragon"; $B = 11
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Orc\\FeralSpirit\\feralspiritdone.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        call EnableTrigger(gg_trg_DarkBahamut_DragonDeath)
        call TriggerRegisterUnitEvent(gg_trg_DarkBahamut_DragonDeath,GetLastCreatedUnit(),EVENT_UNIT_DEATH)
        call UnitRemoveAbilityBJ('Ane2',gg_unit_n043_0021) // 'Ane2': object name not found in map data
        call UnitRemoveAbilityBJ('A0G7',gg_unit_n043_0021) // 'A0G7': ability "Light Pillar Question"
        call UnitRemoveAbilityBJ('A0G9',gg_unit_n043_0021) // 'A0G9': ability "Answer"
        call UnitRemoveAbilityBJ('A0GA',gg_unit_n043_0021) // 'A0GA': ability "Answer"
        call UnitAddAbilityBJ('A0G8',gg_unit_n043_0021) // 'A0G8': ability "Light Pillar Question"
        call UnitAddAbilityBJ('A0GB',gg_unit_n043_0021) // 'A0GB': ability "Answer"
        call UnitAddAbilityBJ('A0GC',gg_unit_n043_0021) // 'A0GC': ability "Answer"
        call UnitAddAbilityBJ('A0GD',gg_unit_n043_0021) // 'A0GD': ability "Answer"
        return
    endif
    if(Trig_DarkBahamut_Riddle_Check_Answer4Or5())then
        set udg_TempPoint=GetUnitLoc(gg_unit_n043_0021)
        call CreateNUnitsAtLoc(1,'n041',Player($B),udg_TempPoint,160.) // 'n041': unit "Ruby Dragon"; $B = 11
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Orc\\FeralSpirit\\feralspiritdone.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        call EnableTrigger(gg_trg_DarkBahamut_DragonDeath)
        call TriggerRegisterUnitEvent(gg_trg_DarkBahamut_DragonDeath,GetLastCreatedUnit(),EVENT_UNIT_DEATH)
        return
    endif
    if(Trig_DarkBahamut_Riddle_IsAnswer6())then
        call DisableTrigger(GetTriggeringTrigger())
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_n043_0021,0)
        if(Trig_DarkBahamut_Riddle_CinematicsOn())then
            call DisplayTimedTextToForce(GetPlayersAll(),6.,"|cffaaaaaaDamned imbeciles. Why do you wish to fight?|r\r\n")
            call Wait_Polled(2.5)
            call DisplayTimedTextToForce(GetPlayersAll(),3.5,"|cffaaaaaaFor the sake of protecting something\r\nNone of your business|r\r\n (It's our nature...)")
            call Wait_Polled(6.5)
            call DisplayTimedTextToForce(GetPlayersAll(),2.,"(There is no real reason...)")
            call Wait_Polled(5.)
            call DisplayTimedTextToForce(GetPlayersAll(),2.,"(Maybe we were born...only to fight.)")
            call Wait_Polled(5.)
            call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUT,4.,"ReplaceableTextures\\CameraMasks\\White_mask.blp",0,0,0,0)
            call Wait_Polled(5.)
            call DisplayTimedTextToForce(GetPlayersAll(),5.,"|cffaaaaaaI see...interesting...|r")
            call RemoveUnit(gg_unit_n043_0021)
            call Wait_Polled(5.)
            call CinematicFadeBJ(bj_CINEFADETYPE_FADEIN,4.,"ReplaceableTextures\\CameraMasks\\White_mask.blp",0,0,0,0)
            call ShowUnitShow(gg_unit_H01W_0039)
            call Text_Say(null,"|cff920000Dark Bahamut has appeared!|r",true)
        else
            call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUT,2.,"ReplaceableTextures\\CameraMasks\\White_mask.blp",0,0,0,0)
            call Wait_Polled(3.)
            call CinematicFadeBJ(bj_CINEFADETYPE_FADEIN,2.,"ReplaceableTextures\\CameraMasks\\White_mask.blp",0,0,0,0)
            call RemoveUnit(gg_unit_n043_0021)
            call ShowUnitShow(gg_unit_H01W_0039)
            call DisplayTimedTextToForce(udg_PlayingPlayers,10.,"|cff920000Dark Bahamut has appeared!|r")
        endif
        call Cine_ExitAction()
        call SetUnitInvulnerable(gg_unit_H01W_0039,false)
        call PauseUnitBJ(false,gg_unit_H01W_0039)
        call GroupAddUnitSimple(gg_unit_H01W_0039,udg_BossGroup)
        call GroupAddUnitSimple(gg_unit_H01W_0039,udg_BossUnits)
        call UnitAddAbilityBJ('A0ZR',gg_unit_H01W_0039) // 'A0ZR': ability "Immortal"
        call Music_SetTrack(23)
        call EnableTrigger(gg_trg_DarkBahamut_Phase2)
        call DestroyTrigger(GetTriggeringTrigger())
    endif
endfunction

function Trig_DarkBahamut_DragonDeath_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call UnitAddAbilityBJ('Ane2',gg_unit_n043_0021) // 'Ane2': object name not found in map data
endfunction

function Trig_DarkBahamut_Phase2_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call Berserk_Remove(GetTriggerUnit())
    call Cine_Enter()
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_BossUnits)
    call SetUnitInvulnerable(gg_unit_H01W_0039,true)
    call PauseUnitBJ(true,gg_unit_H01W_0039)
    call PauseUnitBJ(false,gg_unit_H01X_0038)
    call SetUnitFacingTimed(gg_unit_H01X_0038,GetUnitFacing(gg_unit_H01W_0039),0)
    call PauseUnitBJ(true,gg_unit_H01X_0038)
    call Cam_PanToUnit(GetTriggerUnit(),0)
    call Wait_Polled(1.)
    set udg_TempPoint=GetUnitLoc(gg_unit_H01W_0039)
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Undead\\DeathPact\\DeathPactTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Other\\HowlOfTerror\\HowlCaster.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\Resurrect\\ResurrectTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(udg_TempPoint)
    call Wait_Polled(1.)
    call ShowUnitHide(gg_unit_H01W_0039)
    set udg_TempPoint=GetUnitLoc(gg_unit_H01W_0039)
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Items\\AIda\\AIdaCaster.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call SetUnitPositionLoc(gg_unit_H01X_0038,udg_TempPoint)
    call RemoveLocation(udg_TempPoint)
    call ShowUnitShow(gg_unit_H01X_0038)
    call Wait_Polled(2.)
    call Cine_ExitAction()
    call SetUnitInvulnerable(gg_unit_H01X_0038,false)
    call PauseUnitBJ(false,gg_unit_H01X_0038)
    call GroupAddUnitSimple(gg_unit_H01X_0038,udg_BossGroup)
    call GroupAddUnitSimple(gg_unit_H01X_0038,udg_BossUnits)
    call UnitAddAbilityBJ('A0ZR',gg_unit_H01X_0038) // 'A0ZR': ability "Immortal"
    call EnableTrigger(gg_trg_DarkBahamut_Phase3)
    call PauseUnitBJ(true,gg_unit_H01W_0039)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_DarkBahamut_Phase3_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call Berserk_Remove(GetTriggerUnit())
    call Cine_Enter()
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_BossUnits)
    call SetUnitInvulnerable(gg_unit_H01X_0038,true)
    call PauseUnitBJ(true,gg_unit_H01X_0038)
    call PauseUnitBJ(false,gg_unit_H01Y_0037)
    call SetUnitFacingTimed(gg_unit_H01Y_0037,GetUnitFacing(gg_unit_H01X_0038),0)
    call PauseUnitBJ(true,gg_unit_H01Y_0037)
    call Cam_PanToUnit(GetTriggerUnit(),0)
    call Wait_Polled(1.)
    set udg_TempPoint=GetUnitLoc(gg_unit_H01X_0038)
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Undead\\DeathPact\\DeathPactTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Other\\HowlOfTerror\\HowlCaster.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(udg_TempPoint)
    call Wait_Polled(.5)
    set udg_TempPoint=GetUnitLoc(gg_unit_H01X_0038)
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\NightElf\\BattleRoar\\RoarCaster.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Other\\Charm\\CharmTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(udg_TempPoint)
    call Wait_Polled(.5)
    set udg_TempPoint=GetUnitLoc(gg_unit_H01X_0038)
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\HolyBolt\\HolyBoltSpecialArt.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Orc\\MirrorImage\\MirrorImageCaster.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\Resurrect\\ResurrectTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(udg_TempPoint)
    call Wait_Polled(1.)
    call ShowUnitHide(gg_unit_H01X_0038)
    set udg_TempPoint=GetUnitLoc(gg_unit_H01X_0038)
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Items\\AIda\\AIdaCaster.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call SetUnitPositionLoc(gg_unit_H01Y_0037,udg_TempPoint)
    call RemoveLocation(udg_TempPoint)
    call ShowUnitShow(gg_unit_H01Y_0037)
    call Wait_Polled(2)
    call Cine_ExitAction()
    call SetUnitInvulnerable(gg_unit_H01Y_0037,false)
    call PauseUnitBJ(false,gg_unit_H01Y_0037)
    call UnitAddAbilityBJ('A0ZR',gg_unit_H01Y_0037) // 'A0ZR': ability "Immortal"
    call GroupAddUnitSimple(gg_unit_H01Y_0037,udg_BossGroup)
    call GroupAddUnitSimple(gg_unit_H01Y_0037,udg_BossUnits)
    call EnableTrigger(gg_trg_DarkBahamut_Phase4)
    call PauseUnitBJ(true,gg_unit_H01X_0038)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_DarkBahamut_Phase4_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call Berserk_Remove(GetTriggerUnit())
    call Cine_Enter()
    call SetUnitInvulnerable(gg_unit_H01Y_0037,true)
    call PauseUnitBJ(true,gg_unit_H01Y_0037)
    call PauseUnitBJ(false,gg_unit_H01W_0039)
    call SetUnitFacingTimed(gg_unit_H01W_0039,GetUnitFacing(gg_unit_H01Y_0037),0)
    call PauseUnitBJ(true,gg_unit_H01W_0039)
    call PauseUnitBJ(false,gg_unit_H01X_0038)
    call SetUnitFacingTimed(gg_unit_H01X_0038,GetUnitFacing(gg_unit_H01Y_0037),0)
    call PauseUnitBJ(true,gg_unit_H01X_0038)
    call Cam_PanToUnit(GetTriggerUnit(),0)
    call Wait_Polled(1.)
    set udg_TempPoint=GetUnitLoc(gg_unit_H01Y_0037)
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Undead\\DeathPact\\DeathPactTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Other\\HowlOfTerror\\HowlCaster.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(udg_TempPoint)
    call Wait_Polled(.5)
    set udg_TempPoint=GetUnitLoc(gg_unit_H01Y_0037)
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\NightElf\\BattleRoar\\RoarCaster.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Other\\Charm\\CharmTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(udg_TempPoint)
    call Wait_Polled(.5)
    set udg_TempPoint=GetUnitLoc(gg_unit_H01Y_0037)
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\HolyBolt\\HolyBoltSpecialArt.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Orc\\MirrorImage\\MirrorImageCaster.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(udg_TempPoint)
    call Wait_Polled(1.)
    set udg_TempPoint=GetUnitLoc(gg_unit_H01Y_0037)
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=8
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        // (loop counter A treated as a decimal-capable number) times (45).
        set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,256,(I2R(GetForLoopIndexA())*45.))
        call AddSpecialEffectLocBJ(udg_TempPoint2,"Abilities\\Spells\\Orc\\MirrorImage\\MirrorImageCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint2)
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    call RemoveLocation(udg_TempPoint)
    call Wait_Polled(.5)
    set udg_TempPoint=GetUnitLoc(gg_unit_H01Y_0037)
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=8
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        // (loop counter A treated as a decimal-capable number) times (45).
        set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,512.,(I2R(GetForLoopIndexA())*45.))
        call AddSpecialEffectLocBJ(udg_TempPoint2,"Abilities\\Spells\\Orc\\MirrorImage\\MirrorImageCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint2)
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    call RemoveLocation(udg_TempPoint)
    call Wait_Polled(.5)
    set udg_TempPoint=GetUnitLoc(gg_unit_H01Y_0037)
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=8
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        // (loop counter A treated as a decimal-capable number) times (45).
        set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,256,(I2R(GetForLoopIndexA())*45.))
        call AddSpecialEffectLocBJ(udg_TempPoint2,"Abilities\\Spells\\Orc\\MirrorImage\\MirrorImageCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint2)
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    call RemoveLocation(udg_TempPoint)
    call Wait_Polled(.5)
    set udg_TempPoint=GetUnitLoc(gg_unit_H01Y_0037)
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=8
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        // (loop counter A treated as a decimal-capable number) times (45).
        set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,512.,(I2R(GetForLoopIndexA())*45.))
        call AddSpecialEffectLocBJ(udg_TempPoint2,"Abilities\\Spells\\Orc\\MirrorImage\\MirrorImageCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint2)
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    call RemoveLocation(udg_TempPoint)
    call Wait_Polled(2.)
    set udg_TempPoint=GetUnitLoc(gg_unit_H01Y_0037)
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Items\\AIda\\AIdaCaster.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\MarkOfChaos\\MarkOfChaosTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    // The remainder after dividing ((facing in degrees of gg_unit_H01Y_0037) plus (90)) by (360).
    call SetUnitPositionLoc(gg_unit_H01W_0039,Loc_PolarOffset(udg_TempPoint,256.,ModuloReal((GetUnitFacing(gg_unit_H01Y_0037)+90.),360.)))
    // The remainder after dividing ((facing in degrees of gg_unit_H01Y_0037) plus (270)) by (360).
    call SetUnitPositionLoc(gg_unit_H01X_0038,Loc_PolarOffset(udg_TempPoint,256.,ModuloReal((GetUnitFacing(gg_unit_H01Y_0037)+270.),360.)))
    call RemoveLocation(udg_TempPoint)
    call ShowUnitShow(gg_unit_H01W_0039)
    call ShowUnitShow(gg_unit_H01X_0038)
    call Wait_Polled(2)
    call Cine_ExitAction()
    call GroupAddUnitSimple(gg_unit_H01W_0039,udg_BossUnits)
    call GroupAddUnitSimple(gg_unit_H01X_0038,udg_BossUnits)
    call SetUnitInvulnerable(gg_unit_H01W_0039,false)
    call SetUnitInvulnerable(gg_unit_H01X_0038,false)
    call SetUnitInvulnerable(gg_unit_H01Y_0037,false)
    call PauseUnitBJ(false,gg_unit_H01W_0039)
    call PauseUnitBJ(false,gg_unit_H01X_0038)
    call PauseUnitBJ(false,gg_unit_H01Y_0037)
    call SetUnitLifePercentBJ(gg_unit_H01W_0039,50.)
    call SetUnitLifePercentBJ(gg_unit_H01X_0038,50.)
    call SetUnitLifePercentBJ(gg_unit_H01Y_0037,50.)
    call UnitRemoveAbilityBJ('A0ZR',gg_unit_H01W_0039) // 'A0ZR': ability "Immortal"
    call UnitRemoveAbilityBJ('A0ZR',gg_unit_H01X_0038) // 'A0ZR': ability "Immortal"
    call UnitRemoveAbilityBJ('A0ZR',gg_unit_H01Y_0037) // 'A0ZR': ability "Immortal"
    call Wait_Polled(10.)
    call Music_ClearTrack(23)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_DarkBahamut takes nothing returns nothing
endfunction

function RegisterR11_DarkBahamut_Riddle takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_DarkBahamut_Riddle=CreateTrigger()

call DisableTrigger(gg_trg_DarkBahamut_Riddle)

call TriggerRegisterPlayerUnitEventSimple(gg_trg_DarkBahamut_Riddle,Player(8),EVENT_PLAYER_UNIT_SPELL_EFFECT)

call TriggerAddCondition(gg_trg_DarkBahamut_Riddle,Condition(function Trig_DarkBahamut_Riddle_Conditions))

call TriggerAddAction(gg_trg_DarkBahamut_Riddle,function Trig_DarkBahamut_Riddle_Actions)

endfunction




function RegisterR11_DarkBahamut_DragonDeath takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_DarkBahamut_DragonDeath=CreateTrigger()

call DisableTrigger(gg_trg_DarkBahamut_DragonDeath)

call TriggerAddAction(gg_trg_DarkBahamut_DragonDeath,function Trig_DarkBahamut_DragonDeath_Actions)

endfunction




function RegisterR11_DarkBahamut_Phase2 takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_DarkBahamut_Phase2=CreateTrigger()

call DisableTrigger(gg_trg_DarkBahamut_Phase2)

call TriggerRegisterUnitLifeEvent(gg_trg_DarkBahamut_Phase2,gg_unit_H01W_0039,LESS_THAN,100.)

call TriggerAddAction(gg_trg_DarkBahamut_Phase2,function Trig_DarkBahamut_Phase2_Actions)

endfunction




function RegisterR11_DarkBahamut_Phase3 takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_DarkBahamut_Phase3=CreateTrigger()

call DisableTrigger(gg_trg_DarkBahamut_Phase3)

call TriggerRegisterUnitLifeEvent(gg_trg_DarkBahamut_Phase3,gg_unit_H01X_0038,LESS_THAN,100.)

call TriggerAddAction(gg_trg_DarkBahamut_Phase3,function Trig_DarkBahamut_Phase3_Actions)

endfunction




function RegisterR11_DarkBahamut_Phase4 takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_DarkBahamut_Phase4=CreateTrigger()

call DisableTrigger(gg_trg_DarkBahamut_Phase4)

call TriggerRegisterUnitLifeEvent(gg_trg_DarkBahamut_Phase4,gg_unit_H01Y_0037,LESS_THAN,100.)

call TriggerAddAction(gg_trg_DarkBahamut_Phase4,function Trig_DarkBahamut_Phase4_Actions)

endfunction




endlibrary
