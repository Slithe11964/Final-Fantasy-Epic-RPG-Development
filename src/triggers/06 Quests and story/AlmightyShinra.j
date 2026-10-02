library TAlmightyShinra requires TCam, TCine, TGroup, TLoc, TReward, TText, TWait
function Trig_AlmightyShinra_Arm_Conditions takes nothing returns boolean
    return(udg_ShinraFinaleArmed==false)and(IsQuestCompleted(udg_SideQuest[42]))and(IsQuestCompleted(udg_SideQuest[47]))and(udg_CupWins[$A]>=1)and(udg_ArenaRank>=3) // $A = 10
endfunction

function Trig_AlmightyShinra_Arm_Actions takes nothing returns nothing
    set udg_ShinraFinaleArmed=true
    call StartTimerBJ(udg_SharedDelayTimer3,false,300.)
    call EnableTrigger(gg_trg_AlmightyShinra_Cinematic)
endfunction

function Trig_AlmightyShinra_Cinematic_Cond_FilterAlive takes nothing returns boolean
    return(IsUnitAliveBJ(GetFilterUnit()))
endfunction

function Trig_AlmightyShinra_Cinematic_Cond_FilterPlayerUnit takes nothing returns boolean
    return(GetConvertedPlayerId(GetOwningPlayer(GetFilterUnit()))<=$C) // $C = 12
endfunction

function Trig_AlmightyShinra_Cinematic_Filter_ActiveUnit takes nothing returns boolean
    return GetBooleanAnd(Trig_AlmightyShinra_Cinematic_Cond_FilterAlive(),Trig_AlmightyShinra_Cinematic_Cond_FilterPlayerUnit())
endfunction

function Trig_AlmightyShinra_Cinematic_Cond_FilterAlive2 takes nothing returns boolean
    return(IsUnitAliveBJ(GetFilterUnit()))
endfunction

function Trig_AlmightyShinra_Cinematic_Cond_FilterPlayerUnit2 takes nothing returns boolean
    return(GetConvertedPlayerId(GetOwningPlayer(GetFilterUnit()))<=$C) // $C = 12
endfunction

function Trig_AlmightyShinra_Cinematic_Filter_ActiveUnit2 takes nothing returns boolean
    return GetBooleanAnd(Trig_AlmightyShinra_Cinematic_Cond_FilterAlive2(),Trig_AlmightyShinra_Cinematic_Cond_FilterPlayerUnit2())
endfunction

function Trig_AlmightyShinra_Cinematic_Cond_SceneBlocked takes nothing returns boolean
    return(udg_InCinematicMode)or(udg_SceneBusy)or(IsTriggerEnabled(gg_trg_Arena_Enter_Region))or(udg_ArenaCupId>0)or(CountUnitsInGroup(Group_UnitsInRect(gg_rct_481,Condition(function Trig_AlmightyShinra_Cinematic_Filter_ActiveUnit)))>=1)or(CountUnitsInGroup(Group_UnitsInRect(gg_rct_499,Condition(function Trig_AlmightyShinra_Cinematic_Filter_ActiveUnit2)))>=1)
endfunction

function Trig_AlmightyShinra_Cinematic_Cond_PostponeScene takes nothing returns boolean
    return(Trig_AlmightyShinra_Cinematic_Cond_SceneBlocked())
endfunction

function Trig_AlmightyShinra_Cinematic_Cam_Snap takes nothing returns nothing
    call CameraSetupApplyForPlayer(true,gg_cam_010,GetEnumPlayer(),.0)
endfunction

function Trig_AlmightyShinra_Cinematic_Cam_Approach takes nothing returns nothing
    call CameraSetupApplyForPlayer(true,gg_cam_011,GetEnumPlayer(),5.)
endfunction

function Trig_AlmightyShinra_Cinematic_Cam_Fiend takes nothing returns nothing
    call CameraSetupApplyForPlayer(true,gg_cam_012,GetEnumPlayer(),5.)
endfunction

function Trig_AlmightyShinra_Cinematic_Cam_Shinra takes nothing returns nothing
    call CameraSetupApplyForPlayer(true,gg_cam_014,GetEnumPlayer(),4.)
endfunction

function Trig_AlmightyShinra_Cinematic_Cam_Reflect takes nothing returns nothing
    call CameraSetupApplyForPlayer(true,gg_cam_015,GetEnumPlayer(),6.)
endfunction

function Trig_AlmightyShinra_Cinematic_Cam_Rise takes nothing returns nothing
    call CameraSetupApplyForPlayer(true,gg_cam_016,GetEnumPlayer(),4.)
endfunction

function Trig_AlmightyShinra_Cinematic_Cam_Arena takes nothing returns nothing
    call CameraSetupApplyForPlayer(true,gg_cam_017,GetEnumPlayer(),1.)
endfunction

function Trig_AlmightyShinra_Cinematic_Cam_Shake takes nothing returns nothing
    call CameraSetSourceNoiseForPlayer(GetEnumPlayer(),$A,.1) // $A = 10
endfunction

function Trig_AlmightyShinra_Cinematic_Cam_Orbit takes nothing returns nothing
    call RotateCameraAroundLocBJ(360.,udg_TempPoint,GetEnumPlayer(),16.)
endfunction

function Trig_AlmightyShinra_Cinematic_Cam_ClearShake takes nothing returns nothing
    call CameraClearNoiseForPlayer(GetEnumPlayer())
endfunction

function Trig_AlmightyShinra_Cinematic_Cam_Reset takes nothing returns nothing
    call ResetToGameCameraForPlayer(GetEnumPlayer(),0)
endfunction

function Trig_AlmightyShinra_Cinematic_Actions takes nothing returns nothing
    if(Trig_AlmightyShinra_Cinematic_Cond_PostponeScene())then
        call StartTimerBJ(GetExpiredTimer(),false,10.)
        return
    endif
    call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUT,2,"ReplaceableTextures\\CameraMasks\\White_mask.blp",0,0,0,0)
    call Cine_Enter()
    call Wait_Polled(2.5)
    set udg_TempPoint=GetRectCenter(gg_rct_459)
    call SetUnitPositionLocFacingBJ(gg_unit_n034_0109,udg_TempPoint,45.)
    call RemoveLocation(udg_TempPoint)
    call ShowUnitShow(gg_unit_n034_0109)
    call PauseUnitBJ(false,gg_unit_n034_0109)
    call SetUnitTimeScalePercent(gg_unit_n034_0109,80.)
    set udg_TempPoint=GetRectCenter(gg_rct_458)
    call CreateNUnitsAtLoc(1,'N022',Player($B),udg_TempPoint,225.) // 'N022': unit "Weapon"; $B = 11
    set udg_CinematicActor=GetLastCreatedUnit()
    call RemoveLocation(udg_TempPoint)
    call ForForce(udg_PlayingPlayers,function Trig_AlmightyShinra_Cinematic_Cam_Snap)
    call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUT,.0,"ReplaceableTextures\\CameraMasks\\White_mask.blp",0,0,0,33.33)
    call Wait_Polled(1.)
    call ForForce(udg_PlayingPlayers,function Trig_AlmightyShinra_Cinematic_Cam_Approach)
    call Wait_Polled(5.)
    call PlaySoundBJ(gg_snd_SargerasRoar)
    call Text_Say(udg_CinematicActor,"Little one from Spira...",true)
    call Wait_Polled(.5)
    call ForForce(udg_PlayingPlayers,function Trig_AlmightyShinra_Cinematic_Cam_Fiend)
    call Text_Say(udg_CinematicActor,"You've been studying us fiends carefully, have you not...?",true)
    call Wait_Polled(1.)
    call SetUnitVertexColorBJ(udg_CinematicActor,'d','d','d',25.)
    call Wait_Polled(1.)
    call SetUnitVertexColorBJ(udg_CinematicActor,'d','d','d',50.)
    call Wait_Polled(1.)
    call SetUnitVertexColorBJ(udg_CinematicActor,'d','d','d',75.)
    call Wait_Polled(1.)
    call RemoveUnit(udg_CinematicActor)
    call Wait_Polled(2.)
    call SetUnitMoveSpeed(gg_unit_n034_0109,60.)
    set udg_TempPoint=GetRectCenter(gg_rct_458)
    call IssuePointOrderLocBJ(gg_unit_n034_0109,"move",udg_TempPoint)
    call RemoveLocation(udg_TempPoint)
    call UnitAddAbilityBJ('Arav',gg_unit_n034_0109) // 'Arav': object name not found in map data
    call UnitRemoveAbilityBJ('Arav',gg_unit_n034_0109) // 'Arav': object name not found in map data
    call Text_Say(gg_unit_n034_0109,"The almighty fiend king, Omega Weapon...",true)
    call Wait_Polled(1.)
    call ForForce(udg_PlayingPlayers,function Trig_AlmightyShinra_Cinematic_Cam_Shinra)
    call Text_Say(gg_unit_n034_0109,"Slain by such simple adventurers...",true)
    call Wait_Polled(1.)
    call ForForce(udg_PlayingPlayers,function Trig_AlmightyShinra_Cinematic_Cam_Reflect)
    call Text_Say(gg_unit_n034_0109,"I've helped them, guided them, to reach this point.",true)
    call Text_Say(gg_unit_n034_0109,"And they helped me understand fiends, too.",true)
    call Wait_Polled(2.)
    call Text_Say(gg_unit_n034_0109,"But I'm still only a kid. Can I truly...?",true)
    call Text_Say(gg_unit_n034_0109,"No, of course I can.",true)
    call CinematicFadeBJ(bj_CINEFADETYPE_FADEIN,.5,"ReplaceableTextures\\CameraMasks\\White_mask.blp",0,0,0,33.33)
    set udg_SpiralAngle=0
    call EnableTrigger(gg_trg_AlmightyShinra_Spiral)
    call Wait_Polled(2.5)
    call SetUnitFacingTimed(gg_unit_n034_0109,235.,.3)
    call SetUnitPathing(gg_unit_n034_0109,false)
    call Wait_Polled(.5)
    call SetUnitFlyHeightBJ(gg_unit_n034_0109,150.,60.)
    call ForForce(udg_PlayingPlayers,function Trig_AlmightyShinra_Cinematic_Cam_Rise)
    call Wait_Polled(.5)
    set udg_TempPoint=GetUnitLoc(gg_unit_n034_0109)
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Orc\\FeralSpirit\\feralspirittarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call CreateNUnitsAtLoc(1,'E00K',Player(9),udg_TempPoint,235.) // 'E00K': unit "Just A Kid?"
    set udg_CinematicActor=GetLastCreatedUnit()
    call RemoveLocation(udg_TempPoint)
    call ShowUnitHide(udg_CinematicActor)
    call PauseUnitBJ(true,udg_CinematicActor)
    call SetUnitInvulnerable(udg_CinematicActor,true)
    call SetUnitPathing(udg_CinematicActor,false)
    call UnitAddAbilityBJ('Abun',udg_CinematicActor) // 'Abun': object name not found in map data
    call Wait_Polled(.8)
    set udg_TempPoint=GetUnitLoc(gg_unit_n034_0109)
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Orc\\FeralSpirit\\feralspirittarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(udg_TempPoint)
    call Wait_Polled(.8)
    set udg_TempPoint=GetUnitLoc(gg_unit_n034_0109)
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Orc\\FeralSpirit\\feralspirittarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Items\\AIil\\AIilTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(udg_TempPoint)
    call Wait_Polled(.8)
    set udg_TempPoint=GetUnitLoc(gg_unit_n034_0109)
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Orc\\FeralSpirit\\feralspirittarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Other\\Awaken\\Awaken.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(udg_TempPoint)
    call Wait_Polled(.8)
    set udg_TempPoint=GetUnitLoc(gg_unit_n034_0109)
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Orc\\FeralSpirit\\feralspirittarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\NightElf\\Starfall\\StarfallCaster.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(udg_TempPoint)
    call ShowUnitShow(udg_CinematicActor)
    call SetUnitColor(udg_CinematicActor,PLAYER_COLOR_BROWN)
    call SetUnitVertexColorBJ(udg_CinematicActor,50.,50.,'d',80.)
    call SetUnitVertexColorBJ(gg_unit_n034_0109,10.,10.,10.,25.)
    call Wait_Polled(.5)
    call SetUnitVertexColorBJ(udg_CinematicActor,50.,50.,'d',60.)
    call SetUnitVertexColorBJ(gg_unit_n034_0109,10.,10.,10.,50.)
    call Wait_Polled(.5)
    call SetUnitVertexColorBJ(udg_CinematicActor,50.,50.,'d',40.)
    call SetUnitVertexColorBJ(gg_unit_n034_0109,10.,10.,10.,75.)
    call Wait_Polled(.5)
    call SetUnitVertexColorBJ(udg_CinematicActor,50.,50.,'d',20.)
    call ShowUnitHide(gg_unit_n034_0109)
    call Wait_Polled(.5)
    call SetUnitVertexColorBJ(udg_CinematicActor,50.,50.,'d',.0)
    call DisableTrigger(gg_trg_AlmightyShinra_Spiral)
    call DestroyTrigger(gg_trg_AlmightyShinra_Spiral)
    set udg_SpiralAngle=0
    call Wait_Polled(2.)
    call SetUnitAnimation(udg_CinematicActor,"stand second")
    call Wait_Polled(1.)
    set udg_TempPoint=GetUnitLoc(udg_CinematicActor)
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(udg_TempPoint)
    call Wait_Polled(.5)
    set udg_TempPoint=GetRectCenter(gg_rct_046)
    call SetUnitPositionLoc(udg_CinematicActor,udg_TempPoint)
    call RemoveLocation(udg_TempPoint)
    call Wait_Polled(1.)
    call Cam_PanToUnit(udg_CinematicActor,3.3)
    call Wait_Polled(4.)
    call SetUnitAnimation(udg_CinematicActor,"spell channel")
    call PauseUnitBJ(false,udg_CinematicActor)
    call Wait_Polled(1.)
    call ForForce(udg_PlayingPlayers,function Trig_AlmightyShinra_Cinematic_Cam_Arena)
    call ForForce(udg_PlayingPlayers,function Trig_AlmightyShinra_Cinematic_Cam_Shake)
    set udg_TempPoint=GetUnitLoc(udg_CinematicActor)
    call TerrainDeformationRippleBJ(3.,false,udg_TempPoint,$400,$400,64,1,512) // $400 = 1024
    call ForForce(udg_PlayingPlayers,function Trig_AlmightyShinra_Cinematic_Cam_Orbit)
    call IssuePointOrderLocBJ(udg_CinematicActor,"flamestrike",udg_TempPoint)
    call RemoveLocation(udg_TempPoint)
    call Text_Say(udg_CinematicActor,"The new almighty fiend king... is me.",true)
    call ForForce(udg_PlayingPlayers,function Trig_AlmightyShinra_Cinematic_Cam_ClearShake)
    set udg_TempPoint=GetUnitLoc(udg_CinematicActor)
    set udg_TempPoint2=OffsetLocation(udg_TempPoint,0,-400.)
    call RemoveLocation(udg_TempPoint)
    call CreateNUnitsAtLoc(1,'h02H',Player($B),udg_TempPoint2,bj_UNIT_FACING) // 'h02H': unit "Target"; $B = 11
    call RemoveLocation(udg_TempPoint2)
    set udg_ShinraSpellTarget=GetLastCreatedUnit()
    call IssueTargetOrderBJ(udg_CinematicActor,"thunderbolt",udg_ShinraSpellTarget)
    call Wait_Polled(1.)
    call SetUnitAnimation(udg_CinematicActor,"spell channel")
    set udg_TempPoint=GetUnitLoc(udg_CinematicActor)
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=8
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        // (loop counter A treated as a decimal-capable number) times (45).
        set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,128.,(I2R(GetForLoopIndexA())*45.))
        call AddSpecialEffectLocBJ(udg_TempPoint2,"Abilities\\Spells\\Orc\\WarStomp\\WarStompCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call AddSpecialEffectLocBJ(udg_TempPoint2,"Abilities\\Spells\\Other\\Doom\\DoomDeath.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint2)
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    call RemoveLocation(udg_TempPoint)
    call Wait_Polled(.5)
    set udg_TempPoint=GetUnitLoc(udg_CinematicActor)
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=8
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        // (loop counter A treated as a decimal-capable number) times (45).
        set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,192.,(I2R(GetForLoopIndexA())*45.))
        call AddSpecialEffectLocBJ(udg_TempPoint2,"Abilities\\Spells\\Orc\\WarStomp\\WarStompCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call AddSpecialEffectLocBJ(udg_TempPoint2,"Abilities\\Spells\\Other\\Doom\\DoomDeath.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint2)
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    call RemoveLocation(udg_TempPoint)
    call Wait_Polled(.5)
    set udg_TempPoint=GetUnitLoc(udg_CinematicActor)
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=8
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        // (loop counter A treated as a decimal-capable number) times (45).
        set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,256.,(I2R(GetForLoopIndexA())*45.))
        call AddSpecialEffectLocBJ(udg_TempPoint2,"Abilities\\Spells\\Orc\\WarStomp\\WarStompCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call AddSpecialEffectLocBJ(udg_TempPoint2,"Abilities\\Spells\\Other\\Doom\\DoomDeath.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint2)
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    call RemoveLocation(udg_TempPoint)
    call IssueTargetOrderBJ(udg_CinematicActor,"frostnova",udg_ShinraSpellTarget)
    call UnitApplyTimedLifeBJ(.2,'BTLF',udg_ShinraSpellTarget) // 'BTLF': object name not found in map data
    call Wait_Polled(1.5)
    call RemoveUnit(udg_ShinraSpellTarget)
    call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUT,2,"ReplaceableTextures\\CameraMasks\\White_mask.blp",0,0,0,0)
    call Text_Transmission(null,"Mission Time!","Shinra has absorbed the power of Omega Weapon to become the fiend king, Almighty Shinra, and has entered the Battle Arena! Defeat him in the Dimension Cup and return Shinra to who he used to be.","(null)",null,0,true)
    call Wait_Polled(2.5)
    call KillUnit(udg_CinematicActor)
    call RemoveUnit(udg_CinematicActor)
    call SetUnitFlyHeightBJ(gg_unit_n034_0109,.0,60.)
    call ForForce(udg_PlayingPlayers,function Trig_AlmightyShinra_Cinematic_Cam_Reset)
    call Wait_Polled(.5)
    call CinematicFadeBJ(bj_CINEFADETYPE_FADEIN,2,"ReplaceableTextures\\CameraMasks\\White_mask.blp",0,0,0,0)
    call SaveIntegerBJ(2,2,7,udg_GameStateHash)
    set udg_NewsText[3]=udg_NewsText[2]
    set udg_NewsText[2]=udg_NewsText[1]
    set udg_NewsText[6]=udg_NewsText[5]
    set udg_NewsText[5]=udg_NewsText[4]
    set udg_NewsText[1]="|cffffcc00A new challenger has appeared!|r"
    set udg_NewsText[4]="A very strong contestant has entered the arena! They await any and all challengers in the Dimension Cup! Feel like trying your luck?"
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_DISCOVERED,"New Quest Received: |cffffcc00Almighty Shinra|r")
    set udg_SideQuest[43]=CreateQuestBJ(bj_QUESTTYPE_REQ_DISCOVERED,(udg_QuestTitleRed+"Almighty Shinra"),"Shinra, an Al Bhed child from Spira, has absorbed Omega Weapon's power and become the King of Fiends. To prove his worth, he has entered the Dimension Cup in the Battle Arena, ready to take on and crush any opponent. Defeat him!","ReplaceableTextures\\CommandButtons\\BTNEvilIllidan.blp")
    call Cine_ExitAction()
endfunction

function Trig_AlmightyShinra_Spiral_Actions takes nothing returns nothing
    // The remainder after dividing ((udg_SpiralAngle) plus (45)) by (360).
    set udg_SpiralAngle=ModuloInteger((udg_SpiralAngle+45),360)
    set udg_TempPoint=GetUnitLoc(gg_unit_n034_0109)
    // Udg_SpiralAngle treated as a decimal-capable number.
    set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,128.,I2R(udg_SpiralAngle))
    call AddSpecialEffectLocBJ(udg_TempPoint2,"Abilities\\Spells\\Human\\ThunderClap\\ThunderClapCaster.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call AddSpecialEffectLocBJ(udg_TempPoint2,"Abilities\\Weapons\\Bolt\\BoltImpact.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(udg_TempPoint2)
    call RemoveLocation(udg_TempPoint)
endfunction

function Trig_AlmightyShinra_Defeat_Cond_TrackKills takes nothing returns boolean
    return(udg_SpeedrunMode)
endfunction

function Trig_AlmightyShinra_Defeat_GiveShards takes nothing returns nothing
    call AdjustPlayerStateBJ(3,GetEnumPlayer(),PLAYER_STATE_RESOURCE_LUMBER)
endfunction

function Trig_AlmightyShinra_Defeat_Cond_AchievementPending takes nothing returns boolean
    return(IsPlayerInForce(GetEnumPlayer(),udg_TitleForce[27])==false)and(IsPlayerInForce(GetEnumPlayer(),udg_TitleForce[26]))
endfunction

function Trig_AlmightyShinra_Defeat_GrantAchievement takes nothing returns nothing
    if(Trig_AlmightyShinra_Defeat_Cond_AchievementPending())then
        set udg_TempPlayer=GetEnumPlayer()
        set udg_TempInteger=27
        call ConditionalTriggerExecute(gg_trg_Title_Grant)
    endif
endfunction

function Trig_AlmightyShinra_Defeat_Actions takes nothing returns nothing
    call SaveIntegerBJ(0,2,7,udg_GameStateHash)
    call Cine_Enter()
    if(Trig_AlmightyShinra_Defeat_Cond_TrackKills())then
        set udg_BossUnit=udg_TempUnit
        call ConditionalTriggerExecute(gg_trg_Speedrun_Accolade)
    endif
    call Cam_PanToUnit(udg_TempUnit,0)
    set udg_TempPoint=GetUnitLoc(udg_TempUnit)
    call SetUnitPositionLocFacingBJ(gg_unit_n034_0109,udg_TempPoint,90.)
    call RemoveLocation(udg_TempPoint)
    call Text_Transmission(udg_TempUnit,"Shinra","Eh...?","(null)",null,0,true)
    call Wait_Polled(1.)
    set udg_TempPoint=GetUnitLoc(gg_unit_n034_0109)
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Orc\\FeralSpirit\\feralspirittarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(udg_TempPoint)
    call Wait_Polled(1.)
    call ShowUnitShow(gg_unit_n034_0109)
    set udg_TempPoint=GetUnitLoc(gg_unit_n034_0109)
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Orc\\FeralSpirit\\feralspirittarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(udg_TempPoint)
    call Wait_Polled(1.)
    call SetUnitVertexColorBJ(gg_unit_n034_0109,10.,10.,10.,50.)
    set udg_TempPoint=GetUnitLoc(gg_unit_n034_0109)
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Orc\\FeralSpirit\\feralspirittarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(udg_TempPoint)
    call Wait_Polled(1.)
    call SetUnitVertexColorBJ(gg_unit_n034_0109,10.,10.,10.,25.)
    set udg_TempPoint=GetUnitLoc(gg_unit_n034_0109)
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Orc\\FeralSpirit\\feralspirittarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(udg_TempPoint)
    call Wait_Polled(2.)
    set udg_TempPoint=GetUnitLoc(gg_unit_n034_0109)
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Other\\Awaken\\Awaken.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(udg_TempPoint)
    call Wait_Polled(.5)
    call SetUnitVertexColorBJ(gg_unit_n034_0109,10.,10.,10.,.0)
    call Wait_Polled(2.)
    call Text_Say(gg_unit_n034_0109,"I'm just a kid after all...",true)
    set udg_TempPoint=GetUnitLoc(gg_unit_n034_0109)
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(udg_TempPoint)
    call Wait_Polled(.5)
    set udg_TempPoint=GetUnitLoc(gg_unit_n034_0109)
    call CreateItemLoc('I0A7',udg_TempPoint) // 'I0A7': item "Hidden Hero Medicine"
    call RemoveLocation(udg_TempPoint)
    call RemoveUnit(gg_unit_n034_0109)
    call Wait_Polled(1.5)
    call Text_Say(null,"|n|cffffcc00All players get 30000 gold and 3 crystal shards.|r",true)
    call Cine_ExitAction()
    call Reward_Give($7530,0,null) // $7530 = 30000
    call ForForce(udg_PlayingPlayers,function Trig_AlmightyShinra_Defeat_GiveShards)
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_COMPLETED,"Quest Completed: |cffffcc00Almighty Shinra|r")
    call QuestSetCompletedBJ(udg_SideQuest[43],true)
    set udg_QuestsCompleted=(udg_QuestsCompleted+1)
    call ConditionalTriggerExecute(gg_trg_Arena_Cup_Won)
    call AddUnitToStockBJ('n0AS',udg_ArenaOrganizer[5],1,1) // 'n0AS': unit "Arena: Almighty Shinra Battle"
    // (9) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(1,$A,(9+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $A = 10
    // (9) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ($9D,$B,(9+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $9D = 157; $B = 11
    // (9) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(50,$C,(9+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $C = 12
    set udg_ArenaBonusBattle[0]=(udg_ArenaBonusBattle[0]+1)
    set udg_ArenaBonusBattle[udg_ArenaBonusBattle[0]]=7
    set udg_ArenaBonusBattle[0]=(udg_ArenaBonusBattle[0]+1)
    set udg_ArenaBonusBattle[udg_ArenaBonusBattle[0]]=$AB // $AB = 171
    call ForForce(udg_PlayingPlayers,function Trig_AlmightyShinra_Defeat_GrantAchievement)
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_AlmightyShinra takes nothing returns nothing
endfunction
function RegisterR11_AlmightyShinra_Arm takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_AlmightyShinra_Arm=CreateTrigger()
    call DisableTrigger(gg_trg_AlmightyShinra_Arm)
    call TriggerAddCondition(gg_trg_AlmightyShinra_Arm,Condition(function Trig_AlmightyShinra_Arm_Conditions))
    call TriggerAddAction(gg_trg_AlmightyShinra_Arm,function Trig_AlmightyShinra_Arm_Actions)
endfunction
function RegisterR11_AlmightyShinra_Cinematic takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_AlmightyShinra_Cinematic=CreateTrigger()
    call DisableTrigger(gg_trg_AlmightyShinra_Cinematic)
    call TriggerRegisterTimerExpireEventBJ(gg_trg_AlmightyShinra_Cinematic,udg_SharedDelayTimer3)
    call TriggerAddAction(gg_trg_AlmightyShinra_Cinematic,function Trig_AlmightyShinra_Cinematic_Actions)
endfunction
function RegisterR11_AlmightyShinra_Spiral takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_AlmightyShinra_Spiral=CreateTrigger()
    call DisableTrigger(gg_trg_AlmightyShinra_Spiral)
    call TriggerRegisterTimerEventPeriodic(gg_trg_AlmightyShinra_Spiral,.25)
    call TriggerAddAction(gg_trg_AlmightyShinra_Spiral,function Trig_AlmightyShinra_Spiral_Actions)
endfunction
function RegisterR11_AlmightyShinra_Defeat takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_AlmightyShinra_Defeat=CreateTrigger()
    call DisableTrigger(gg_trg_AlmightyShinra_Defeat)
    call TriggerAddAction(gg_trg_AlmightyShinra_Defeat,function Trig_AlmightyShinra_Defeat_Actions)
endfunction




endlibrary
