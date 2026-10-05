library TCine requires TCam, TGroup, TLoc, TMusic, TPlayerHero, TText, TUnit, TWait
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Cine_StoneBreaks=null
    trigger gg_trg_Cine_ScryingVision=null
    trigger gg_trg_Cine_Belias_Gafgarion=null
    trigger gg_trg_Cine_StoneBreaks_Alt=null
    // Variables only this module uses (MapBootstrap sets some starting values).
    boolexpr udg_CinematicUnitFilter
    group udg_CinematicPausedUnits
    real udg_StoneTint=0
    real udg_StoneScale=0
    boolean udg_BeliasArrived=false
    sound gg_snd_U08Archimonde19=null
endglobals

function Cine_UnitFilter takes nothing returns boolean
    return(not IsUnitHidden(GetFilterUnit())and GetUnitAbilityLevel(GetFilterUnit(),'A0VJ')<=0 and GetWidgetLife(GetFilterUnit())>.405) // 'A0VJ': ability "Unaffected by Cinematics"
endfunction

function Cine_PauseUnit takes nothing returns nothing
    call PauseUnit(GetEnumUnit(),true)
endfunction

function Cine_UnpauseUnit takes nothing returns nothing
    if(GetEnumUnit()!=null)then
        call PauseUnit(GetEnumUnit(),false)
    endif
endfunction

function Cine_OnSkip takes nothing returns nothing
    call StopSound(bj_cineSceneLastSound,false,true)
    call EndCinematicScene()
    set udg_CinematicSkipped=true
endfunction

function Cine_Init takes nothing returns nothing
    local integer i=1
    set udg_CinematicUnitFilter=Condition(function Cine_UnitFilter)
    if(bj_cineSceneBeingSkipped==null)then
        set bj_cineSceneBeingSkipped=CreateTrigger()
        set i=0
        loop
            call TriggerRegisterPlayerEvent(bj_cineSceneBeingSkipped,Player(i),EVENT_PLAYER_END_CINEMATIC)
            set i=i+1
            exitwhen i>=8
        endloop
        call TriggerAddAction(bj_cineSceneBeingSkipped,function Cine_OnSkip)
    endif
endfunction

function Cine_Enter takes nothing returns nothing
    if(bj_cineModeAlreadyIn or udg_InCinematicMode)then
        return
    endif
    if(udg_MiracleStage[0]==2)then
        set udg_MiracleStage[0]=1
    endif
    call DisableTrigger(GetTriggeringTrigger())
    set udg_CinematicPausedUnits=CreateGroup()
    call GroupEnumUnitsInRect(udg_CinematicPausedUnits,bj_mapInitialPlayableArea,udg_CinematicUnitFilter)
    call ForGroup(udg_CinematicPausedUnits,function Cine_PauseUnit)
    call ClearSelection()
    set udg_InCinematicMode=true
    set bj_cineModeAlreadyIn=true
    set bj_cineModePriorSpeed=GetGameSpeed()
    set bj_cineModePriorFogSetting=IsFogEnabled()
    set bj_cineModePriorMaskSetting=IsFogMaskEnabled()
    set bj_cineModePriorDawnDusk=bj_useDawnDuskSounds
    // A random whole number from 0 through 1000000.
    set bj_cineModeSavedSeed=GetRandomInt(0,$F4240) // $F4240 = 1000000
    call ClearTextMessages()
    call ShowInterface(false,bj_CINEMODE_INTERFACEFADE)
    call EnableUserControl(false)
    call EnableOcclusion(false)
    call SetCineModeVolumeGroupsImmediateBJ()
    call SetGameSpeed(bj_CINEMODE_GAMESPEED)
    call SetMapFlag(MAP_LOCK_SPEED,true)
    call FogMaskEnable(false)
    call FogEnable(false)
    call EnableWorldFogBoundary(false)
    set bj_useDawnDuskSounds=false
    set udg_CinematicSkipped=false
endfunction

function Cine_Exit takes nothing returns nothing
    local unit l_hero
    local integer i
    if(not bj_cineModeAlreadyIn or not udg_InCinematicMode)then
        return
    endif
    call ResetToGameCamera(0)
    set bj_cineModeAlreadyIn=false
    call ShowInterface(true,bj_CINEMODE_INTERFACEFADE)
    call EnableUserControl(true)
    call EnableOcclusion(true)
    call VolumeGroupReset()
    call CameraSetSmoothingFactor(0)
    call SetMapFlag(MAP_LOCK_SPEED,false)
    call SetGameSpeed(bj_cineModePriorSpeed)
    call FogMaskEnable(bj_cineModePriorMaskSetting)
    call FogEnable(bj_cineModePriorFogSetting)
    call EnableWorldFogBoundary(true)
    set bj_useDawnDuskSounds=bj_cineModePriorDawnDusk
    call ForGroup(udg_CinematicPausedUnits,function Cine_UnpauseUnit)
    call GroupClear(udg_CinematicPausedUnits)
    call DestroyGroup(udg_CinematicPausedUnits)
    set udg_CinematicPausedUnits=null
    set l_hero=Player_GetHero(GetLocalPlayer())
    set i=GetPlayerId(GetLocalPlayer())+1
    if udg_PlayerTransport[i]!=null and IsUnitLoaded(l_hero)then
        set l_hero=udg_PlayerTransport[i]
    endif
    call ClearSelection()
    call SelectUnit(l_hero,true)
    call PanCameraToTimed(GetUnitX(l_hero),GetUnitY(l_hero),0)
    if(udg_CameraDistance[i]>0)then
        call SetCameraField(CAMERA_FIELD_TARGET_DISTANCE,udg_CameraDistance[i],.0)
    endif
    set udg_CinematicSkipped=false
    set udg_InCinematicMode=false
    set l_hero=null
endfunction

function Cine_ExitAction takes nothing returns nothing
    call Cine_Exit()
endfunction

function Trig_Cine_StoneBreaks_Conditions takes nothing returns boolean
    return((IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(IsUnitHiddenBJ(gg_unit_Hpb1_0013)==false)and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(GetUnitTypeId(GetTriggerUnit())!='H01D')and(udg_InCinematicMode==false))!=null // 'H01D': unit "Spirit of Gaya"
endfunction

function Trig_Cine_StoneBreaks_CameraOnScene takes nothing returns nothing
    call CameraSetupApplyForPlayer(true,gg_cam_001,GetEnumPlayer(),0)
endfunction

function Trig_Cine_StoneBreaks_CameraRestore takes nothing returns nothing
    call ResetToGameCameraForPlayer(GetEnumPlayer(),0)
endfunction

function Trig_Cine_StoneBreaks_ShowBreakScene takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Cine_StoneBreaks_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call GroupRemoveUnitSimple(udg_ZodiacStone,udg_QuestUnits)
    call SetUnitFacingTimed(gg_unit_Hpb1_0013,260.,0)
    call SetUnitFacingTimed(udg_Mid,280.,0)
    set udg_CidQuestStage=$D // $D = 13
    if(Trig_Cine_StoneBreaks_ShowBreakScene())then
        call Cine_Enter()
        call ForForce(udg_PlayingPlayers,function Trig_Cine_StoneBreaks_CameraOnScene)
        call Text_Say(gg_unit_Hpb1_0013,"You're back! So, were you able to find Ao Madoushi?",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Yes, and he told us to bring the Zodiac Stone to him.",false)
        call Text_Say(udg_Mid,"Did he explain anything?",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"No, but he seemed to be very anxious. He told us to bring him the Stone as fast as possible.",false)
        call Text_Say(gg_unit_Hpb1_0013,"In that case I think we must",false)
        call Text_Transmission(gg_unit_Hpb1_0013,"Cid","In that case I think we must ...","In that case I think we must",null,0,false)
        call Text_Transmission(gg_unit_Hpb1_0013,"Cid","In that case I think we must ... Wait !","In that case I think we must ...",null,0,false)
        call Text_Transmission(gg_unit_Hpb1_0013,"Cid","In that case I think we must ... Wait ! What's happening to the stone?","In that case I think we must ... Wait !",null,0,false)
        call PlayThematicMusicBJ("Sound\\Music\\mp3Music\\Tension.mp3")
        set udg_StoneTint=100.
        set udg_StoneScale=100.
        set udg_StoneTint=(udg_StoneTint-10.)
        set udg_TempPoint=GetUnitLoc(udg_ZodiacStone)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Demon\\DemonBoltImpact\\DemonBoltImpact.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        call SetUnitVertexColorBJ(udg_ZodiacStone,'d',udg_StoneTint,udg_StoneTint,0)
        set udg_StoneScale=(udg_StoneScale+50.)
        call SetUnitScalePercent(udg_ZodiacStone,udg_StoneScale,udg_StoneScale,udg_StoneScale)
        call Wait_Polled(1.)
        set udg_StoneTint=(udg_StoneTint-10.)
        set udg_TempPoint=GetUnitLoc(udg_ZodiacStone)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Demon\\DemonBoltImpact\\DemonBoltImpact.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        set udg_StoneScale=(udg_StoneScale+50.)
        call SetUnitScalePercent(udg_ZodiacStone,udg_StoneScale,udg_StoneScale,udg_StoneScale)
        call Wait_Polled(1.)
        set udg_StoneTint=(udg_StoneTint-10.)
        set udg_TempPoint=GetUnitLoc(udg_ZodiacStone)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\Thunderclap\\ThunderClapCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        call SetUnitVertexColorBJ(udg_ZodiacStone,'d',udg_StoneTint,udg_StoneTint,0)
        set udg_StoneScale=(udg_StoneScale+50.)
        call SetUnitScalePercent(udg_ZodiacStone,udg_StoneScale,udg_StoneScale,udg_StoneScale)
        call Wait_Polled(1.)
        set udg_StoneTint=(udg_StoneTint-10.)
        set udg_TempPoint=GetUnitLoc(udg_ZodiacStone)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Demon\\DarkPortal\\DarkPortalTarget.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        call SetUnitVertexColorBJ(udg_ZodiacStone,'d',udg_StoneTint,udg_StoneTint,0)
        set udg_StoneScale=(udg_StoneScale+50.)
        call SetUnitScalePercent(udg_ZodiacStone,udg_StoneScale,udg_StoneScale,udg_StoneScale)
        call Wait_Polled(1.)
        set udg_StoneTint=(udg_StoneTint-10.)
        set udg_TempPoint=GetUnitLoc(udg_ZodiacStone)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Other\\Doom\\DoomDeath.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        call SetUnitVertexColorBJ(udg_ZodiacStone,'d',udg_StoneTint,udg_StoneTint,0)
        set udg_StoneScale=(udg_StoneScale+50.)
        call SetUnitScalePercent(udg_ZodiacStone,udg_StoneScale,udg_StoneScale,udg_StoneScale)
        call Wait_Polled(1.)
        set udg_StoneTint=(udg_StoneTint-10.)
        set udg_TempPoint=GetUnitLoc(udg_ZodiacStone)
        set udg_SpecialEffect[21]=AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Orc\\Purge\\PurgeBuffTarget.mdl")
        call RemoveLocation(udg_TempPoint)
        call SetUnitVertexColorBJ(udg_ZodiacStone,'d',udg_StoneTint,udg_StoneTint,0)
        set udg_StoneScale=(udg_StoneScale+50.)
        call SetUnitScalePercent(udg_ZodiacStone,udg_StoneScale,udg_StoneScale,udg_StoneScale)
        call Wait_Polled(1.)
        call DestroyEffectBJ(udg_SpecialEffect[21])
        set udg_StoneTint=(udg_StoneTint-10.)
        set udg_TempPoint=GetUnitLoc(udg_ZodiacStone)
        set udg_SpecialEffect[21]=AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Undead\\Possession\\PossessionCaster.mdl")
        call RemoveLocation(udg_TempPoint)
        call SetUnitVertexColorBJ(udg_ZodiacStone,'d',udg_StoneTint,udg_StoneTint,0)
        set udg_StoneScale=(udg_StoneScale+50.)
        call SetUnitScalePercent(udg_ZodiacStone,udg_StoneScale,udg_StoneScale,udg_StoneScale)
        call Wait_Polled(1.)
        call DestroyEffectBJ(udg_SpecialEffect[21])
        set udg_StoneTint=(udg_StoneTint-10.)
        set udg_TempPoint=GetUnitLoc(udg_ZodiacStone)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Demon\\DemonBoltImpact\\DemonBoltImpact.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        call SetUnitVertexColorBJ(udg_ZodiacStone,'d',udg_StoneTint,udg_StoneTint,0)
        set udg_StoneScale=(udg_StoneScale+50.)
        call SetUnitScalePercent(udg_ZodiacStone,udg_StoneScale,udg_StoneScale,udg_StoneScale)
        call Wait_Polled(1.)
        set udg_StoneTint=(udg_StoneTint-10.)
        set udg_TempPoint=GetUnitLoc(udg_ZodiacStone)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Demon\\DemonBoltImpact\\DemonBoltImpact.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        call SetUnitVertexColorBJ(udg_ZodiacStone,'d',udg_StoneTint,udg_StoneTint,0)
        set udg_StoneScale=(udg_StoneScale+50.)
        call SetUnitScalePercent(udg_ZodiacStone,udg_StoneScale,udg_StoneScale,udg_StoneScale)
        call Wait_Polled(1.)
        set udg_StoneTint=(udg_StoneTint-10.)
        set udg_TempPoint=GetUnitLoc(udg_ZodiacStone)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Demon\\DemonBoltImpact\\DemonBoltImpact.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        call SetUnitVertexColorBJ(udg_ZodiacStone,'d',udg_StoneTint,udg_StoneTint,0)
        set udg_StoneScale=(udg_StoneScale+50.)
        call SetUnitScalePercent(udg_ZodiacStone,udg_StoneScale,udg_StoneScale,udg_StoneScale)
        call Wait_Polled(1.)
        set udg_TempPoint=GetUnitLoc(udg_ZodiacStone)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Objects\\Spawnmodels\\Undead\\UDeathMedium\\UDeath.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        call Wait_Polled(2)
        set udg_TempPoint=GetUnitLoc(udg_ZodiacStone)
        set udg_TempPoint2=OffsetLocation(udg_TempPoint,0,-400.)
        call RemoveLocation(udg_TempPoint)
        call SetUnitPositionLoc(udg_ZodiacStone,udg_TempPoint2)
        call RemoveLocation(udg_TempPoint2)
        set udg_CinematicActor=ReplaceUnitBJ(udg_ZodiacStone,'Eevi',bj_UNIT_STATE_METHOD_MAXIMUM) // 'Eevi': object name not found in map data
        call PauseUnitBJ(true,udg_CinematicActor)
        call SetUnitAnimation(udg_CinematicActor,"morph")
        call Wait_Polled(1.5)
        set udg_CinematicActor=ReplaceUnitBJ(udg_CinematicActor,'E002',bj_UNIT_STATE_METHOD_MAXIMUM) // 'E002': unit "Zodiac Brave of Earth"
        call PauseUnitBJ(true,udg_CinematicActor)
        call ForForce(udg_PlayingPlayers,function Trig_Cine_StoneBreaks_CameraRestore)
        call Cam_PanToUnit(udg_CinematicActor,1.)
        call SetUnitFacingToFaceUnitTimed(GetTriggerUnit(),udg_CinematicActor,1.)
        call Text_Transmission(udg_CinematicActor,"Mysterious Demon","Hahaha... Free, at last !!!","(null)",null,0,false)
        call Text_Transmission(udg_CinematicActor,"Mysterious Demon","Tremble mortals and despair. Doom has come to this world.","(null)",gg_snd_U08Archimonde19,0,false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"So, your name is Doom, right?",false)
        call SetUnitFacingToFaceUnitTimed(udg_CinematicActor,GetTriggerUnit(),1.)
        call Text_Transmission(udg_CinematicActor,"Mysterious Demon","Worthless maggot. Soon you will be punished for your insolence but for now know that I am Hashmalum, the Regulator.","(null)",null,0,false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Regulator? What a stupid name! Can't you call yourself Angel of Death, or Lord of the Terror or something like that!?",false)
        call Text_Say(udg_CinematicActor,"Insolent creature ! I shall crush you into dust !!!",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Maybe we should finish talking and get some real action? I am kinda impatient to crush *you* into dust.",false)
        call Text_Say(udg_CinematicActor,"Soon, pathetic creature, you will feel my wrath. Live, for now, enjoy the last moments of your miserable life and prepare to suffer the unspeakable horrors of hell.",false)
        set udg_TempPoint=GetUnitLoc(udg_CinematicActor)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        call Wait_Polled(.5)
        call RemoveUnit(udg_CinematicActor)
        call Wait_Polled(2)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Ha, this guy is simply afraid of me ! He ran away !",false)
        call Text_Say(gg_unit_Hpb1_0013,"Don't be too overconfident in your abilities. I think this Demon is simply exhausted - breaking the Stone took much of his power. But I am afraid that he will restore his power soon and we must be ready to face him anytime soon.",false)
        call Text_Say(udg_Mid,"I think you need to visit Ao Madoushi and learn what he knows about these events.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"No problem.",false)
        call Cine_ExitAction()
    else
        call RemoveUnit(udg_ZodiacStone)
    endif
    call ConditionalTriggerExecute(gg_trg_World_AfterDemonAppears)
    call QuestMessageBJ(udg_PlayingPlayers,bj_QUESTMESSAGE_UPDATED,"Visit Ao Madoushi")
    call ExecuteFunc("QuestAoMadoushi_StoneBroke")
    call GroupAddUnitSimple(gg_unit_Othr_0106,udg_QuestUnits)
    call EnableTrigger(gg_trg_Quest_AoMadoushi_Report)
    set udg_SpecialEffect[21]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_Othr_0106,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    set udg_TempPoint=GetRandomLocInRect(gg_rct_189)
    call CreateNUnitsAtLoc(1,'n01A',Player($B),udg_TempPoint,GetRandomDirectionDeg()) // 'n01A': unit "Infernal Knight"; $B = 11
    call RemoveLocation(udg_TempPoint)
    call Unit_ScaleToLevel60(bj_lastCreatedUnit)
    set udg_TempPoint=GetRandomLocInRect(gg_rct_189)
    call CreateNUnitsAtLoc(1,'n01A',Player($B),udg_TempPoint,GetRandomDirectionDeg()) // 'n01A': unit "Infernal Knight"; $B = 11
    call RemoveLocation(udg_TempPoint)
    call Unit_ScaleToLevel60(bj_lastCreatedUnit)
    set udg_TempPoint=GetRandomLocInRect(gg_rct_189)
    call CreateNUnitsAtLoc(1,'n01A',Player($B),udg_TempPoint,GetRandomDirectionDeg()) // 'n01A': unit "Infernal Knight"; $B = 11
    call RemoveLocation(udg_TempPoint)
    call Unit_ScaleToLevel60(bj_lastCreatedUnit)
    set udg_NewsText[3]=udg_NewsText[2]
    set udg_NewsText[2]=udg_NewsText[1]
    set udg_NewsText[6]=udg_NewsText[5]
    set udg_NewsText[5]=udg_NewsText[4]
    set udg_NewsText[1]="|cffffcc00DEMON THREATENS KALM|r"
    set udg_NewsText[4]="Just a short few hours ago, a demon appeared right in the midst of Kalm, threatening our leaders! It is unclear what will await us, but it looks like hard times are ahead for our fair city. Be on your guard!"
    set udg_StoryProgress=(udg_StoryProgress+1)
    call ConditionalTriggerExecute(gg_trg_QuestCount_Milestones)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Cine_ScryingVision_IsSceneBusy takes nothing returns boolean
    return(udg_InCinematicMode)or(udg_SceneBusy)
endfunction

function Trig_Cine_ScryingVision_ShouldDelayScene takes nothing returns boolean
    return(Trig_Cine_ScryingVision_IsSceneBusy())
endfunction

function Trig_Cine_ScryingVision_OrderGhostMove takes nothing returns nothing
    call IssuePointOrderLocBJ(GetEnumUnit(),"move",udg_TempPoint)
endfunction

function Trig_Cine_ScryingVision_ShowGhostScene takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Cine_ScryingVision_CameraFollowBelias takes nothing returns nothing
    call SetCameraTargetControllerNoZForPlayer(GetEnumPlayer(),gg_unit_Uwar_0192,0,0,false)
endfunction

function Trig_Cine_ScryingVision_BeliasNotArrived takes nothing returns boolean
    return(udg_BeliasArrived==false)
endfunction

function Trig_Cine_ScryingVision_ShowBeliasScene takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Cine_ScryingVision_IsGafgarionRoute takes nothing returns boolean
    return(IsQuestDiscovered(udg_MainQuest[18])==false)
endfunction

function Trig_Cine_ScryingVision_Actions takes nothing returns nothing
    if(Trig_Cine_ScryingVision_ShouldDelayScene())then
        call StartTimerBJ(udg_StoryEventTimer,false,6.)
        return
    endif
    call DisableTrigger(GetTriggeringTrigger())
    call UnitAddAbilityBJ('A0VJ',gg_unit_U000_0248) // 'A0VJ': ability "Unaffected by Cinematics"
    call SetUnitAnimationWithRarity(gg_unit_U000_0248,"stand channel",RARITY_FREQUENT)
    call SetUnitVertexColorBJ(gg_unit_U000_0248,.0,.0,.0,50.)
    if(Trig_Cine_ScryingVision_IsGafgarionRoute())then
        if(Trig_Cine_ScryingVision_ShowBeliasScene())then
            call EnableTrigger(gg_trg_Cine_Belias_Gafgarion)
            call Cine_Enter()
            call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUT,.0,"ReplaceableTextures\\CameraMasks\\DreamFilter_Mask.blp",50.,100.,75.,80.)
            call ForForce(udg_PlayingPlayers,function Trig_Cine_ScryingVision_CameraFollowBelias)
            call Wait_Polled(1.)
            set udg_TempPoint=GetUnitLoc(gg_unit_Uwar_0192)
            call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl")
            call DestroyEffectBJ(GetLastCreatedEffectBJ())
            call RemoveLocation(udg_TempPoint)
            call Wait_Polled(.5)
            call ShowUnitShow(gg_unit_Uwar_0192)
            call SetUnitPathing(gg_unit_Uwar_0192,false)
            call Wait_Polled(1.)
            call PauseUnitBJ(false,gg_unit_Uwar_0192)
            set udg_TempPoint=GetRectCenter(gg_rct_409)
            call IssuePointOrderLocBJ(gg_unit_Uwar_0192,"move",udg_TempPoint)
            call RemoveLocation(udg_TempPoint)
            call Wait_Polled(1.)
            set udg_TempPoint=GetRectCenter(gg_rct_409)
            call IssuePointOrderLocBJ(gg_unit_Uwar_0192,"move",udg_TempPoint)
            call RemoveLocation(udg_TempPoint)
            call Wait_Polled(.25)
            set udg_TempPoint=GetRectCenter(gg_rct_409)
            call IssuePointOrderLocBJ(gg_unit_Uwar_0192,"move",udg_TempPoint)
            call RemoveLocation(udg_TempPoint)
            set udg_BeliasArrived=false
            call Wait_Polled(20.)
            if(Trig_Cine_ScryingVision_BeliasNotArrived())then
                call TriggerExecute(gg_trg_Cine_Belias_Gafgarion)
            endif
        else
            set udg_TempPoint=GetRectCenter(gg_rct_582)
            call ConditionalTriggerExecute(gg_trg_Spawn_Gafgarion)
            call RemoveLocation(udg_TempPoint)
            set udg_TempPoint=GetRectCenter(gg_rct_409)
            call SetUnitFacingToFaceLocTimed(udg_StoryBoss,udg_TempPoint,0)
            call RemoveLocation(udg_TempPoint)
            call PauseUnitBJ(true,udg_StoryBoss)
            call UnitAddAbilityBJ('A0VJ',udg_StoryBoss) // 'A0VJ': ability "Unaffected by Cinematics"
            call SetUnitInvulnerable(udg_StoryBoss,true)
            call ConditionalTriggerExecute(gg_trg_Quest_DarkKnight_Start)
        endif
    else
        if(Trig_Cine_ScryingVision_ShowGhostScene())then
            call Cine_Enter()
            call Cam_PanToUnit(gg_unit_U000_0248,0)
            call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUT,.0,"ReplaceableTextures\\CameraMasks\\DreamFilter_Mask.blp",50.,100.,75.,80.)
            set udg_TempPoint=GetRectCenter(gg_rct_409)
            call CreateNUnitsAtLoc(1,'u00D',Player(8),udg_TempPoint,bj_UNIT_FACING) // 'u00D': unit "Death Ghost"
            call RemoveLocation(udg_TempPoint)
            call Wait_Polled(1.)
            set udg_TempPoint=GetRectCenter(gg_rct_409)
            set bj_forLoopAIndex=1
            set bj_forLoopAIndexEnd=4
            loop
                exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
                set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,128.,(I2R(GetForLoopIndexA())*90.))
                call CreateNUnitsAtLoc(1,'u00D',Player(8),udg_TempPoint2,bj_UNIT_FACING) // 'u00D': unit "Death Ghost"
                call RemoveLocation(udg_TempPoint2)
                set bj_forLoopAIndex=bj_forLoopAIndex+1
            endloop
            call RemoveLocation(udg_TempPoint)
            call Wait_Polled(1.)
            set bj_forLoopAIndex=1
            set bj_forLoopAIndexEnd=4
            loop
                exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
                set udg_TempPoint=GetRandomLocInRect(gg_rct_151)
                call CreateNUnitsAtLoc(1,'u00D',Player(8),udg_TempPoint,bj_UNIT_FACING) // 'u00D': unit "Death Ghost"
                call RemoveLocation(udg_TempPoint)
                set bj_forLoopAIndex=bj_forLoopAIndex+1
            endloop
            set bj_forLoopAIndex=1
            set bj_forLoopAIndexEnd=2
            loop
                exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
                set udg_TempPoint=GetRandomLocInRect(gg_rct_152)
                call CreateNUnitsAtLoc(1,'u00D',Player(8),udg_TempPoint,bj_UNIT_FACING) // 'u00D': unit "Death Ghost"
                call RemoveLocation(udg_TempPoint)
                set bj_forLoopAIndex=bj_forLoopAIndex+1
            endloop
            set bj_forLoopAIndex=1
            set bj_forLoopAIndexEnd=4
            loop
                exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
                set udg_TempPoint=GetRandomLocInRect(gg_rct_153)
                call CreateNUnitsAtLoc(1,'u00D',Player(8),udg_TempPoint,bj_UNIT_FACING) // 'u00D': unit "Death Ghost"
                call RemoveLocation(udg_TempPoint)
                set bj_forLoopAIndex=bj_forLoopAIndex+1
            endloop
            call Wait_Polled(1.)
            set udg_TempGroup=Group_UnitsOfPlayerAndType(Player(8),'u00D') // 'u00D': unit "Death Ghost"
            set udg_TempPoint=GetRectCenter(gg_rct_582)
            call ForGroupBJ(udg_TempGroup,function Trig_Cine_ScryingVision_OrderGhostMove)
            call RemoveLocation(udg_TempPoint)
            call DestroyGroup(udg_TempGroup)
            call Wait_Polled(1.)
            call ShowUnitShow(gg_unit_U000_0248)
            call Wait_Polled(6.)
            call CinematicFadeBJ(bj_CINEFADETYPE_FADEIN,.0,"ReplaceableTextures\\CameraMasks\\DreamFilter_Mask.blp",.0,.0,.0,.0)
            call Cam_PanToUnit(gg_unit_Etyr_0155,0)
            call Text_Say(gg_unit_Etyr_0155,"What you saw just now was projected by my scrying spell.",false)
            call Text_Say(gg_unit_Etyr_0155,"Did you see that demon appear? It seems he is still gathering his energy. It's the perfect time to strike to chip away at the enemy forces!",false)
            call Cine_ExitAction()
        else
            call ShowUnitShow(gg_unit_U000_0248)
        endif
        call ExecuteFunc("QuestDarkKnight_StartNecrophobe") // "Necrophobe" starts (Quest_DarkKnight module)
        set udg_NecrophobeStarted=true
        set udg_ZaleraStage=20
        call Music_SetZoneTrack(9)
        call ConditionalTriggerExecute(gg_trg_Elemental_Setup)
        call EnableTrigger(gg_trg_Boss_Zalera_Intro)
    endif
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Cine_Belias_Gafgarion_Conditions takes nothing returns boolean
    return(GetEnteringUnit()==gg_unit_Uwar_0192)
endfunction

function Trig_Cine_Belias_Gafgarion_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    set udg_BeliasArrived=true
    call PauseUnitBJ(true,gg_unit_Uwar_0192)
    call Wait_Polled(.5)
    set udg_TempPoint=GetRectCenter(gg_rct_582)
    call SetUnitFacingToFaceLocTimed(gg_unit_Uwar_0192,udg_TempPoint,.1)
    call RemoveLocation(udg_TempPoint)
    call Wait_Polled(.5)
    call SetUnitAnimation(gg_unit_Uwar_0192,"channel")
    call SetUnitAnimation(gg_unit_Uwar_0192,"spell slam")
    call SetUnitAnimation(gg_unit_Uwar_0192,"slam")
    call Wait_Polled(2.)
    set udg_TempPoint=GetRectCenter(gg_rct_582)
    call ConditionalTriggerExecute(gg_trg_Spawn_Gafgarion)
    call RemoveLocation(udg_TempPoint)
    call PauseUnitBJ(true,udg_StoryBoss)
    call UnitAddAbilityBJ('A0VJ',udg_StoryBoss) // 'A0VJ': ability "Unaffected by Cinematics"
    call SetUnitInvulnerable(udg_StoryBoss,true)
    call SetUnitFacingToFaceUnitTimed(udg_StoryBoss,gg_unit_Uwar_0192,0)
    call SetUnitPathing(gg_unit_Uwar_0192,true)
    call ResetUnitAnimation(gg_unit_Uwar_0192)
    call Text_Say(udg_StoryBoss,"Belias? I haven't seen you in a long time.",false)
    call Text_Say(gg_unit_Uwar_0192,"Spare the sentimentalities. Hashmalum is free. He is gathering his minions. This time, we won't be defeated.",false)
    call Text_Say(gg_unit_Uwar_0192,"I'm sure you haven't forgotten the past yourself. Now you have a chance at redemption. See this through to the end with us.",false)
    call Text_Say(udg_StoryBoss,"Very well.",false)
    call Text_Say(udg_StoryBoss,"Have the Zodiac Braves gathered yet?",false)
    call Text_Say(gg_unit_Uwar_0192,"That brings us nicely to your first job. I'm sure you realize the significance of this place.",false)
    call Text_Say(udg_StoryBoss,"Of course I do.",false)
    call Text_Say(gg_unit_Uwar_0192,"Good. You are to guard this place for the time being.",false)
    call Text_Say(udg_StoryBoss,"Guard it? From whom?",false)
    call Text_Say(gg_unit_Uwar_0192,"Unfortunately, we have a serious enemy to contend with this time.We may be able to protect ourselves from the Night Elves, but our opponents this time are more dangerous and unpredictable than they are.",false)
    call Text_Say(udg_StoryBoss,"What do you mean?",false)
    call Text_Say(gg_unit_Uwar_0192,"It seems outsiders have come to Gaya recently.",false)
    call Text_Say(gg_unit_Uwar_0192,"These outsiders allied themselves with the Humans and Elves. And they have already proven themselves very powerful.",false)
    call Text_Say(gg_unit_Uwar_0192,"They vanquished Cúchulainn. Of course he was weakened and lost his mind but he was still one of the Zodiac Braves.",false)
    call Text_Say(gg_unit_Uwar_0192,"That is why we summoned you once more. Do not let these pests interfere with our plans.",false)
    call Text_Say(udg_StoryBoss,"I won't let them. Leave this place to me.",false)
    set udg_TempPoint=GetUnitLoc(gg_unit_Uwar_0192)
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(udg_TempPoint)
    call Wait_Polled(.5)
    call ShowUnitHide(gg_unit_Uwar_0192)
    call Wait_Polled(2.)
    call CinematicFadeBJ(bj_CINEFADETYPE_FADEIN,.0,"ReplaceableTextures\\CameraMasks\\DreamFilter_Mask.blp",.0,.0,.0,.0)
    call Cam_PanToUnit(gg_unit_Etyr_0155,0)
    call Text_Say(gg_unit_Etyr_0155,"What you saw just now was projected by my scrying spell.",false)
    call Text_Say(gg_unit_Etyr_0155,"Hurry and destroy this Gafgarion. It seems he is guarding something important to the enemy.",false)
    call Cine_ExitAction()
    call ConditionalTriggerExecute(gg_trg_Quest_DarkKnight_Start)
endfunction

function Trig_Cine_StoneBreaks_Alt_IsStoneWithSageStage takes nothing returns boolean
    return(udg_CidQuestStage==$C) // $C = 12
endfunction

function Trig_Cine_StoneBreaks_Alt_IsStageResearch takes nothing returns boolean
    return(udg_CidQuestStage==7)
endfunction

function Trig_Cine_StoneBreaks_Alt_IsStoneCarried takes nothing returns boolean
    return(IsItemOwned(udg_QuestItem[$B])) // $B = 11
endfunction

function Trig_Cine_StoneBreaks_Alt_ShowStoneSpawn takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Cine_StoneBreaks_Alt_HasStoneStageBegun takes nothing returns boolean
    return(udg_CidQuestStage>=4)
endfunction

function Trig_Cine_StoneBreaks_Alt_IsStoneQuestActive takes nothing returns boolean
    return(IsQuestCompleted(udg_MainQuest[2])==false)and(IsQuestDiscovered(udg_MainQuest[2]))
endfunction

function Trig_Cine_StoneBreaks_Alt_HasStoneOnMap takes nothing returns boolean
    return(udg_CidQuestStage>=4)
endfunction

function Trig_Cine_StoneBreaks_Alt_CameraOnStone takes nothing returns nothing
    call CameraSetupApplyForPlayer(true,gg_cam_001,GetEnumPlayer(),0)
endfunction

function Trig_Cine_StoneBreaks_Alt_IsStoneQuestDone takes nothing returns boolean
    return(IsQuestCompleted(udg_MainQuest[2]))
endfunction

function Trig_Cine_StoneBreaks_Alt_ShakeCamera takes nothing returns nothing
    call CameraSetEQNoiseForPlayer(GetEnumPlayer(),15.)
endfunction

function Trig_Cine_StoneBreaks_Alt_StopCameraShake takes nothing returns nothing
    call CameraClearNoiseForPlayer(GetEnumPlayer())
endfunction

function Trig_Cine_StoneBreaks_Alt_IsResearchStage takes nothing returns boolean
    return(udg_CidQuestStage==7)
endfunction

function Trig_Cine_StoneBreaks_Alt_IsCidAlive takes nothing returns boolean
    return(GetOwningPlayer(gg_unit_Hpb1_0013)!=Player($B)) // $B = 11
endfunction

function Trig_Cine_StoneBreaks_Alt_CameraRestoreGame takes nothing returns nothing
    call ResetToGameCameraForPlayer(GetEnumPlayer(),0)
endfunction

function Trig_Cine_StoneBreaks_Alt_IsStoneVisible takes nothing returns boolean
    return(udg_CidQuestStage>=4)
endfunction

function Trig_Cine_StoneBreaks_Alt_IsCidFriendly takes nothing returns boolean
    return(GetOwningPlayer(gg_unit_Hpb1_0013)!=Player($B)) // $B = 11
endfunction

function Trig_Cine_StoneBreaks_Alt_ShowBreakAltScene takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Cine_StoneBreaks_Alt_StoneQuestFinished takes nothing returns boolean
    return(IsQuestCompleted(udg_MainQuest[2]))
endfunction

function Trig_Cine_StoneBreaks_Alt_ShouldSendToSage takes nothing returns boolean
    return(udg_CidQuestStage==$C) // $C = 12
endfunction

function Trig_Cine_StoneBreaks_Alt_IsStageChanneling takes nothing returns boolean
    return(udg_CidQuestStage==7)
endfunction

function Trig_Cine_StoneBreaks_Alt_IsCidEnemy takes nothing returns boolean
    return(GetOwningPlayer(gg_unit_Hpb1_0013)==Player($B)) // $B = 11
endfunction

function Trig_Cine_StoneBreaks_Alt_Actions takes nothing returns nothing
    if(Trig_Cine_StoneBreaks_Alt_IsStoneQuestActive())then
        call DisableTrigger(gg_trg_Cid_Berserk_Start)
        call DestroyTrigger(gg_trg_Cid_Berserk_Start)
        call EnableTrigger(gg_trg_Cid_Talk_Hashmalum)
        if(Trig_Cine_StoneBreaks_Alt_HasStoneStageBegun())then
            call DisableTrigger(gg_trg_Artifact_Carrier)
            if(Trig_Cine_StoneBreaks_Alt_ShowStoneSpawn())then
                if(Trig_Cine_StoneBreaks_Alt_IsStoneCarried())then
                    set udg_TempPoint=GetUnitLoc(udg_ArtifactCarrier)
                else
                    set udg_TempPoint=GetItemLoc(udg_QuestItem[$B]) // $B = 11
                endif
                call CreateNUnitsAtLoc(1,'o000',Player(PLAYER_NEUTRAL_PASSIVE),udg_TempPoint,bj_UNIT_FACING) // 'o000': unit "Zodiac Stone"
                set udg_ZodiacStone=GetLastCreatedUnit()
                call RemoveLocation(udg_TempPoint)
            endif
            call RemoveItem(udg_QuestItem[$B]) // $B = 11
        endif
    else
        if(Trig_Cine_StoneBreaks_Alt_IsStageResearch())then
            call PauseTimerBJ(true,udg_CidResearchTimer)
        else
            if(Trig_Cine_StoneBreaks_Alt_IsStoneWithSageStage())then
                call GroupRemoveUnitSimple(udg_ZodiacStone,udg_QuestUnits)
                call DisableTrigger(gg_trg_Cine_StoneBreaks)
            endif
        endif
    endif
    call DestroyTrigger(gg_trg_Cine_StoneBreaks)
    if(Trig_Cine_StoneBreaks_Alt_ShowBreakAltScene())then
        call Cine_Enter()
        if(Trig_Cine_StoneBreaks_Alt_IsStoneVisible())then
            if(Trig_Cine_StoneBreaks_Alt_IsStoneQuestDone())then
                call ForForce(udg_PlayingPlayers,function Trig_Cine_StoneBreaks_Alt_CameraOnStone)
            else
                call Cam_PanToUnit(udg_ZodiacStone,0)
            endif
            if(Trig_Cine_StoneBreaks_Alt_IsCidAlive())then
                call Text_Say(gg_unit_Hpb1_0013,"Look !",false)
                call Text_Transmission(gg_unit_Hpb1_0013,"Cid","Look ! Something's happening to the stone!","Look !",null,0,false)
                call ResetUnitAnimation(gg_unit_Hpb1_0013)
                call ResetUnitAnimation(udg_Mid)
            endif
            call PlayThematicMusicBJ("Sound\\Music\\mp3Music\\Tension.mp3")
            set udg_StoneTint=100.
            set udg_StoneScale=100.
            set udg_StoneTint=(udg_StoneTint-10.)
            set udg_TempPoint=GetUnitLoc(udg_ZodiacStone)
            call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Demon\\DemonBoltImpact\\DemonBoltImpact.mdl")
            call DestroyEffectBJ(GetLastCreatedEffectBJ())
            call RemoveLocation(udg_TempPoint)
            call SetUnitVertexColorBJ(udg_ZodiacStone,'d',udg_StoneTint,udg_StoneTint,0)
            set udg_StoneScale=(udg_StoneScale+50.)
            call SetUnitScalePercent(udg_ZodiacStone,udg_StoneScale,udg_StoneScale,udg_StoneScale)
            call Wait_Polled(1.)
            set udg_StoneTint=(udg_StoneTint-10.)
            set udg_TempPoint=GetUnitLoc(udg_ZodiacStone)
            call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Demon\\DemonBoltImpact\\DemonBoltImpact.mdl")
            call DestroyEffectBJ(GetLastCreatedEffectBJ())
            call RemoveLocation(udg_TempPoint)
            set udg_StoneScale=(udg_StoneScale+50.)
            call SetUnitScalePercent(udg_ZodiacStone,udg_StoneScale,udg_StoneScale,udg_StoneScale)
            call Wait_Polled(1.)
            set udg_StoneTint=(udg_StoneTint-10.)
            set udg_TempPoint=GetUnitLoc(udg_ZodiacStone)
            call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\Thunderclap\\ThunderClapCaster.mdl")
            call DestroyEffectBJ(GetLastCreatedEffectBJ())
            call RemoveLocation(udg_TempPoint)
            call SetUnitVertexColorBJ(udg_ZodiacStone,'d',udg_StoneTint,udg_StoneTint,0)
            set udg_StoneScale=(udg_StoneScale+50.)
            call SetUnitScalePercent(udg_ZodiacStone,udg_StoneScale,udg_StoneScale,udg_StoneScale)
            call Wait_Polled(1.)
            set udg_StoneTint=(udg_StoneTint-10.)
            set udg_TempPoint=GetUnitLoc(udg_ZodiacStone)
            call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Demon\\DarkPortal\\DarkPortalTarget.mdl")
            call DestroyEffectBJ(GetLastCreatedEffectBJ())
            call RemoveLocation(udg_TempPoint)
            call SetUnitVertexColorBJ(udg_ZodiacStone,'d',udg_StoneTint,udg_StoneTint,0)
            set udg_StoneScale=(udg_StoneScale+50.)
            call SetUnitScalePercent(udg_ZodiacStone,udg_StoneScale,udg_StoneScale,udg_StoneScale)
            call Wait_Polled(1.)
            set udg_StoneTint=(udg_StoneTint-10.)
            set udg_TempPoint=GetUnitLoc(udg_ZodiacStone)
            call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Other\\Doom\\DoomDeath.mdl")
            call DestroyEffectBJ(GetLastCreatedEffectBJ())
            call RemoveLocation(udg_TempPoint)
            call SetUnitVertexColorBJ(udg_ZodiacStone,'d',udg_StoneTint,udg_StoneTint,0)
            set udg_StoneScale=(udg_StoneScale+50.)
            call SetUnitScalePercent(udg_ZodiacStone,udg_StoneScale,udg_StoneScale,udg_StoneScale)
            call Wait_Polled(1.)
            set udg_StoneTint=(udg_StoneTint-10.)
            set udg_TempPoint=GetUnitLoc(udg_ZodiacStone)
            set udg_SpecialEffect[21]=AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Orc\\Purge\\PurgeBuffTarget.mdl")
            call RemoveLocation(udg_TempPoint)
            call SetUnitVertexColorBJ(udg_ZodiacStone,'d',udg_StoneTint,udg_StoneTint,0)
            set udg_StoneScale=(udg_StoneScale+50.)
            call SetUnitScalePercent(udg_ZodiacStone,udg_StoneScale,udg_StoneScale,udg_StoneScale)
            call Wait_Polled(1.)
            call DestroyEffectBJ(udg_SpecialEffect[21])
            set udg_StoneTint=(udg_StoneTint-10.)
            set udg_TempPoint=GetUnitLoc(udg_ZodiacStone)
            set udg_SpecialEffect[21]=AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Undead\\Possession\\PossessionCaster.mdl")
            call RemoveLocation(udg_TempPoint)
            call SetUnitVertexColorBJ(udg_ZodiacStone,'d',udg_StoneTint,udg_StoneTint,0)
            set udg_StoneScale=(udg_StoneScale+50.)
            call SetUnitScalePercent(udg_ZodiacStone,udg_StoneScale,udg_StoneScale,udg_StoneScale)
            call Wait_Polled(1.)
            call DestroyEffectBJ(udg_SpecialEffect[21])
            set udg_StoneTint=(udg_StoneTint-10.)
            set udg_TempPoint=GetUnitLoc(udg_ZodiacStone)
            call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Demon\\DemonBoltImpact\\DemonBoltImpact.mdl")
            call DestroyEffectBJ(GetLastCreatedEffectBJ())
            call RemoveLocation(udg_TempPoint)
            call SetUnitVertexColorBJ(udg_ZodiacStone,'d',udg_StoneTint,udg_StoneTint,0)
            set udg_StoneScale=(udg_StoneScale+50.)
            call SetUnitScalePercent(udg_ZodiacStone,udg_StoneScale,udg_StoneScale,udg_StoneScale)
            call Wait_Polled(1.)
            set udg_StoneTint=(udg_StoneTint-10.)
            set udg_TempPoint=GetUnitLoc(udg_ZodiacStone)
            call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Demon\\DemonBoltImpact\\DemonBoltImpact.mdl")
            call DestroyEffectBJ(GetLastCreatedEffectBJ())
            call RemoveLocation(udg_TempPoint)
            call SetUnitVertexColorBJ(udg_ZodiacStone,'d',udg_StoneTint,udg_StoneTint,0)
            set udg_StoneScale=(udg_StoneScale+50.)
            call SetUnitScalePercent(udg_ZodiacStone,udg_StoneScale,udg_StoneScale,udg_StoneScale)
            call Wait_Polled(1.)
            set udg_StoneTint=(udg_StoneTint-10.)
            set udg_TempPoint=GetUnitLoc(udg_ZodiacStone)
            call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Demon\\DemonBoltImpact\\DemonBoltImpact.mdl")
            call DestroyEffectBJ(GetLastCreatedEffectBJ())
            call RemoveLocation(udg_TempPoint)
            call SetUnitVertexColorBJ(udg_ZodiacStone,'d',udg_StoneTint,udg_StoneTint,0)
            set udg_StoneScale=(udg_StoneScale+50.)
            call SetUnitScalePercent(udg_ZodiacStone,udg_StoneScale,udg_StoneScale,udg_StoneScale)
            call Wait_Polled(1.)
            set udg_TempPoint=GetUnitLoc(udg_ZodiacStone)
            call AddSpecialEffectLocBJ(udg_TempPoint,"Objects\\Spawnmodels\\Undead\\UDeathMedium\\UDeath.mdl")
            call DestroyEffectBJ(GetLastCreatedEffectBJ())
            call RemoveLocation(udg_TempPoint)
            call Wait_Polled(2)
            set udg_TempPoint=GetUnitLoc(udg_ZodiacStone)
            set udg_TempPoint2=OffsetLocation(udg_TempPoint,0,-400.)
            call RemoveLocation(udg_TempPoint)
            call SetUnitPositionLoc(udg_ZodiacStone,udg_TempPoint2)
            call RemoveLocation(udg_TempPoint2)
            set udg_CinematicActor=ReplaceUnitBJ(udg_ZodiacStone,'Eevi',bj_UNIT_STATE_METHOD_MAXIMUM) // 'Eevi': object name not found in map data
            call PauseUnitBJ(true,udg_CinematicActor)
            call SetUnitAnimation(udg_CinematicActor,"morph")
            call Wait_Polled(1.5)
            set udg_CinematicActor=ReplaceUnitBJ(udg_CinematicActor,'E002',bj_UNIT_STATE_METHOD_MAXIMUM) // 'E002': unit "Zodiac Brave of Earth"
            call PauseUnitBJ(true,udg_CinematicActor)
            call ForForce(udg_PlayingPlayers,function Trig_Cine_StoneBreaks_Alt_CameraRestoreGame)
            call Cam_PanToUnit(udg_CinematicActor,1.)
            call Text_Transmission(udg_CinematicActor,"Mysterious Demon","Hahaha... free, at last.","(null)",null,0,false)
            call Text_Transmission(udg_CinematicActor,"Mysterious Demon","Tremble mortals and despair. Doom has come to this world.","(null)",gg_snd_U08Archimonde19,0,false)
            call Text_Transmission(udg_CinematicActor,"Mysterious Demon","Know that I, Hashmalum, the Regulator, will have you all purged.","(null)",null,0,false)
            set udg_TempPoint=GetUnitLoc(udg_CinematicActor)
            call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl")
            call DestroyEffectBJ(GetLastCreatedEffectBJ())
            call RemoveLocation(udg_TempPoint)
            call Wait_Polled(.5)
            call RemoveUnit(udg_CinematicActor)
            call Wait_Polled(2)
        else
            call ForForce(GetPlayersAll(),function Trig_Cine_StoneBreaks_Alt_ShakeCamera)
            call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUTIN,4.,"ReplaceableTextures\\CameraMasks\\DreamFilter_Mask.blp",.0,0,0,0)
            call Wait_Polled(4.)
            call ForForce(GetPlayersAll(),function Trig_Cine_StoneBreaks_Alt_StopCameraShake)
            call Text_Transmission(null,"Mysterious Voice","Hahaha... Free, at last !!!","(null)",null,0,false)
            call Text_Transmission(null,"Mysterious Voice","Tremble mortals and despair. Doom has come to this world.","(null)",gg_snd_U08Archimonde19,0,false)
            call Text_Transmission(null,"Mysterious Voice","Know that I, Hashmalum, the Regulator, will have you all purged.","(null)",null,0,false)
            if(Trig_Cine_StoneBreaks_Alt_IsResearchStage())then
                call Text_Say(gg_unit_Hpb1_0013,"Hashmalum... this sounds bad.",false)
                call Text_Say(udg_Mid,"Well no point in researching the Zodiac Stone anymore. Let's see if we find something on this Hashmalum!",false)
                call Text_Say(gg_unit_Hpb1_0013,"Indeed, Mid.",false)
            endif
        endif
        if(Trig_Cine_StoneBreaks_Alt_IsCidFriendly())then
            call Cine_ExitAction()
        endif
    else
        if(Trig_Cine_StoneBreaks_Alt_HasStoneOnMap())then
            call RemoveUnit(udg_ZodiacStone)
        endif
    endif
    call ConditionalTriggerExecute(gg_trg_World_AfterDemonAppears)
    if(Trig_Cine_StoneBreaks_Alt_StoneQuestFinished())then
        set udg_NewsText[3]=udg_NewsText[2]
        set udg_NewsText[2]=udg_NewsText[1]
        set udg_NewsText[6]=udg_NewsText[5]
        set udg_NewsText[5]=udg_NewsText[4]
        set udg_NewsText[1]="|cffffcc00DEMON THREATENS KALM|r"
        set udg_NewsText[4]="Just a short few hours ago, a demon appeared right in the midst of Kalm, threatening our leaders! It is unclear what will await us, but it looks like hard times are ahead for our fair city. Be on your guard!"
    endif
    if(Trig_Cine_StoneBreaks_Alt_IsCidEnemy())then
        call TriggerExecute(gg_trg_Cid_Berserk_End)
    else
        if(Trig_Cine_StoneBreaks_Alt_IsStageChanneling())then
            call SetUnitAnimation(gg_unit_Hpb1_0013,"channel")
            call SetUnitAnimation(udg_Mid,"channel")
            call StartTimerBJ(udg_CidResearchTimer,false,60.)
        else
            if(Trig_Cine_StoneBreaks_Alt_ShouldSendToSage())then
                call QuestMessageBJ(udg_PlayingPlayers,bj_QUESTMESSAGE_UPDATED,"Visit Ao Madoushi")
                call ExecuteFunc("QuestAoMadoushi_StoneBroke")
                call GroupAddUnitSimple(gg_unit_Othr_0106,udg_QuestUnits)
                call EnableTrigger(gg_trg_Quest_AoMadoushi_Report)
                set udg_SpecialEffect[21]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_Othr_0106,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
                set udg_TempPoint=GetRandomLocInRect(gg_rct_189)
                call CreateNUnitsAtLoc(1,'n01A',Player($B),udg_TempPoint,GetRandomDirectionDeg()) // 'n01A': unit "Infernal Knight"; $B = 11
                call RemoveLocation(udg_TempPoint)
                set udg_TempPoint=GetRandomLocInRect(gg_rct_189)
                call CreateNUnitsAtLoc(1,'n01A',Player($B),udg_TempPoint,GetRandomDirectionDeg()) // 'n01A': unit "Infernal Knight"; $B = 11
                call RemoveLocation(udg_TempPoint)
                set udg_TempPoint=GetRandomLocInRect(gg_rct_189)
                call CreateNUnitsAtLoc(1,'n01A',Player($B),udg_TempPoint,GetRandomDirectionDeg()) // 'n01A': unit "Infernal Knight"; $B = 11
                call RemoveLocation(udg_TempPoint)
            endif
        endif
    endif
endfunction

// World Editor calls InitTrig_Cine automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Cine (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Cine takes nothing returns nothing
endfunction

function Register_Cine_StoneBreaks takes nothing returns nothing
    set gg_trg_Cine_StoneBreaks=CreateTrigger()
    call DisableTrigger(gg_trg_Cine_StoneBreaks)
    call TriggerRegisterUnitInRangeSimple(gg_trg_Cine_StoneBreaks,450.,gg_unit_Hpb1_0013)
    call TriggerAddCondition(gg_trg_Cine_StoneBreaks,Condition(function Trig_Cine_StoneBreaks_Conditions))
    call TriggerAddAction(gg_trg_Cine_StoneBreaks,function Trig_Cine_StoneBreaks_Actions)
endfunction

function Register_Cine_ScryingVision takes nothing returns nothing
    set gg_trg_Cine_ScryingVision=CreateTrigger()
    call DisableTrigger(gg_trg_Cine_ScryingVision)
    call TriggerRegisterTimerExpireEventBJ(gg_trg_Cine_ScryingVision,udg_StoryEventTimer)
    call TriggerAddAction(gg_trg_Cine_ScryingVision,function Trig_Cine_ScryingVision_Actions)
endfunction

function Register_Cine_Belias_Gafgarion takes nothing returns nothing
    set gg_trg_Cine_Belias_Gafgarion=CreateTrigger()
    call DisableTrigger(gg_trg_Cine_Belias_Gafgarion)
    call TriggerRegisterEnterRectSimple(gg_trg_Cine_Belias_Gafgarion,gg_rct_409)
    call TriggerAddCondition(gg_trg_Cine_Belias_Gafgarion,Condition(function Trig_Cine_Belias_Gafgarion_Conditions))
    call TriggerAddAction(gg_trg_Cine_Belias_Gafgarion,function Trig_Cine_Belias_Gafgarion_Actions)
endfunction

function Register_Cine_StoneBreaks_Alt takes nothing returns nothing
    set gg_trg_Cine_StoneBreaks_Alt=CreateTrigger()
    call DisableTrigger(gg_trg_Cine_StoneBreaks_Alt)
    call TriggerAddAction(gg_trg_Cine_StoneBreaks_Alt,function Trig_Cine_StoneBreaks_Alt_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Cine takes nothing returns nothing
    call Register_Cine_StoneBreaks() // starts off; enabled by Quest_AoMadoushi; disabled by Cine, TrueIceAge; destroyed by Cine
    call Register_Cine_ScryingVision() // starts off; enabled by Quest_NightElves
    call Register_Cine_Belias_Gafgarion() // starts off; enabled by Cine; run by Cine
    call Register_Cine_StoneBreaks_Alt() // starts off; run by Quest_WorldLiberation; destroyed by World
endfunction

endlibrary
