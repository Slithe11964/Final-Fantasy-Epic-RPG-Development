library TTrueIceAge requires TCam, TCine, TGroup, TLoc, TMusic, TPlayerPart01, TReward, TText, TWait
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_TrueIceAge_GateUnlock=null
    trigger gg_trg_TrueIceAge_Summon=null
    trigger gg_trg_TrueIceAge_SpawnBrave=null
    trigger gg_trg_TrueIceAge_BossIntro=null
    trigger gg_trg_TrueIceAge_FreezeTimeout=null
    trigger gg_trg_TrueIceAge_Victory=null
    // Variables only this module uses.
    integer array udg_ZodiacBraveType
    unit udg_Cuchulainn=null
    boolean udg_DanaAvailable=false
endglobals

function Trig_TrueIceAge_GateUnlock_Conditions takes nothing returns boolean
    return((IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(udg_InCinematicMode==false))!=null
endfunction

function Trig_TrueIceAge_GateUnlock_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call UnitAddAbilityBJ('A11Z',gg_unit_ndmg_0124) // 'A11Z': ability "Activate Demon Gate"
    call UnitAddAbilityBJ('Ane2',gg_unit_ndmg_0124) // 'Ane2': object name not found in map data
    call EnableTrigger(gg_trg_TrueIceAge_Summon)
endfunction

function Trig_TrueIceAge_Summon_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A11Z')and(udg_InCinematicMode==false) // 'A11Z': ability "Activate Demon Gate"
endfunction

function Trig_TrueIceAge_Summon_IsPlayerUnit takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetFilterUnit()),udg_PlayingPlayers))
endfunction

function Trig_TrueIceAge_Summon_IsHeroUnit takes nothing returns boolean
    return(IsUnitType(GetFilterUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_TrueIceAge_Summon_IsPlayerHero takes nothing returns boolean
    return GetBooleanAnd(Trig_TrueIceAge_Summon_IsPlayerUnit(),Trig_TrueIceAge_Summon_IsHeroUnit())
endfunction

function Trig_TrueIceAge_Summon_AnyHeroNearby takes nothing returns boolean
    return(IsUnitGroupEmptyBJ(udg_TempGroup)==false)
endfunction

function Trig_TrueIceAge_Summon_ShakeCameraSummon takes nothing returns nothing
    call CameraSetSourceNoiseForPlayer(GetEnumPlayer(),30.,.3)
    call CameraSetEQNoiseForPlayer(GetEnumPlayer(),5.)
endfunction

function Trig_TrueIceAge_Summon_ClearShakeSummon takes nothing returns nothing
    call CameraClearNoiseForPlayer(GetEnumPlayer())
endfunction

function Trig_TrueIceAge_Summon_ClearDoodads1 takes nothing returns nothing
    call RemoveDestructable(GetEnumDestructable())
endfunction

function Trig_TrueIceAge_Summon_ClearDoodads2 takes nothing returns nothing
    call RemoveDestructable(GetEnumDestructable())
endfunction

function Trig_TrueIceAge_Summon_ClearDoodads3 takes nothing returns nothing
    call RemoveDestructable(GetEnumDestructable())
endfunction

function Trig_TrueIceAge_Summon_ClearDoodads4 takes nothing returns nothing
    call RemoveDestructable(GetEnumDestructable())
endfunction

function Trig_TrueIceAge_Summon_ClearDoodads5 takes nothing returns nothing
    call RemoveDestructable(GetEnumDestructable())
endfunction

function Trig_TrueIceAge_Summon_WinterQueenAlive takes nothing returns boolean
    return(IsUnitDeadBJ(gg_unit_U00M_0206)==false)
endfunction

function Trig_TrueIceAge_Summon_IceBraveNoPassive takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0VJ',gg_unit_U00L_0207)<=0) // 'A0VJ': ability "Unaffected by Cinematics"
endfunction

function Trig_TrueIceAge_Summon_KillAndRemoveUnit takes nothing returns nothing
    call KillUnit(GetEnumUnit())
    call RemoveUnit(GetEnumUnit())
endfunction

function Trig_TrueIceAge_Summon_XQuestActive takes nothing returns boolean
    return(udg_ExodusQuestStage>0)and(udg_ExodusQuestStage<6)
endfunction

function Trig_TrueIceAge_Summon_XQuestStage5 takes nothing returns boolean
    return(udg_ExodusQuestStage==5)
endfunction

function Trig_TrueIceAge_Summon_XQuestStage4 takes nothing returns boolean
    return(udg_ExodusQuestStage==4)
endfunction

function Trig_TrueIceAge_Summon_XQuestStage3 takes nothing returns boolean
    return(udg_ExodusQuestStage==3)
endfunction

function Trig_TrueIceAge_Summon_XQuestStage1 takes nothing returns boolean
    return(udg_ExodusQuestStage==1)
endfunction

function Trig_TrueIceAge_Summon_XQuestUnfinished takes nothing returns boolean
    return(udg_ExodusQuestStage<6)
endfunction

function Trig_TrueIceAge_Summon_KillAndRemoveUnit2 takes nothing returns nothing
    call KillUnit(GetEnumUnit())
    call RemoveUnit(GetEnumUnit())
endfunction

function Trig_TrueIceAge_Summon_SoulQuestStage2 takes nothing returns boolean
    return(udg_ShemhazaiPhase==2)
endfunction

function Trig_TrueIceAge_Summon_SoulQuestBelow4 takes nothing returns boolean
    return(udg_ShemhazaiPhase<4)
endfunction

function Trig_TrueIceAge_Summon_SoulQuestActive takes nothing returns boolean
    return(udg_ShemhazaiPhase>0)and(udg_ShemhazaiPhase<5)
endfunction

function Trig_TrueIceAge_Summon_DanaQuestNotStarted takes nothing returns boolean
    return(udg_DanaQuestStage<=0)
endfunction

function Trig_TrueIceAge_Summon_DanaNotInvisible takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('Apiv',gg_unit_n0BN_0171)<=0) // 'Apiv': object name not found in map data
endfunction

function Trig_TrueIceAge_Summon_WaterBraveVulnerable takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('Avul',gg_unit_U00N_0205)<=0) // 'Avul': standard ability reference "Invulnerable"
endfunction

function Trig_TrueIceAge_Summon_WaterBraveVisible takes nothing returns boolean
    return(IsUnitHiddenBJ(gg_unit_U00N_0205)==false)
endfunction

function Trig_TrueIceAge_Summon_DanaQuestDiscovered takes nothing returns boolean
    return(IsQuestDiscovered(udg_MainQuest[$F])) // $F = 15
endfunction

function Trig_TrueIceAge_Summon_DanaQuestAtLeast4 takes nothing returns boolean
    return(udg_DanaQuestStage>=4)
endfunction

function Trig_TrueIceAge_Summon_SideQuest64Done takes nothing returns boolean
    return(IsQuestCompleted(udg_SideQuest[64]))
endfunction

function Trig_TrueIceAge_Summon_KillDoodads takes nothing returns nothing
    call KillDestructable(GetEnumDestructable())
endfunction

function Trig_TrueIceAge_Summon_StageBelow11 takes nothing returns boolean
    return(udg_CidQuestStage<$B) // $B = 11
endfunction

function Trig_TrueIceAge_Summon_StageAtLeast4 takes nothing returns boolean
    return(udg_CidQuestStage>=4)
endfunction

function Trig_TrueIceAge_Summon_StageAtLeast3 takes nothing returns boolean
    return(udg_CidQuestStage>=3)
endfunction

function Trig_TrueIceAge_Summon_StageIs7 takes nothing returns boolean
    return(udg_CidQuestStage==7)
endfunction

function Trig_TrueIceAge_Summon_StageIs8 takes nothing returns boolean
    return(udg_CidQuestStage==8)
endfunction

function Trig_TrueIceAge_Summon_StageAtLeast9 takes nothing returns boolean
    return(udg_CidQuestStage>=9)
endfunction

function Trig_TrueIceAge_Summon_PartnerIsReno takes nothing returns boolean
    return(udg_FluteHolder==gg_unit_n012_0163)
endfunction

function Trig_TrueIceAge_Summon_NoPartnerChosen takes nothing returns boolean
    return(udg_FluteHolder==null)
endfunction

function Trig_TrueIceAge_Summon_StageIs9 takes nothing returns boolean
    return(udg_CidQuestStage==9)
endfunction

function Trig_TrueIceAge_Summon_StageIs10 takes nothing returns boolean
    return(udg_CidQuestStage==$A) // $A = 10
endfunction

function Trig_TrueIceAge_Summon_StageIs11 takes nothing returns boolean
    return(udg_CidQuestStage==$B) // $B = 11
endfunction

function Trig_TrueIceAge_Summon_StageIs12 takes nothing returns boolean
    return(udg_CidQuestStage==$C) // $C = 12
endfunction

function Trig_TrueIceAge_Summon_EngineerIsHostile takes nothing returns boolean
    return(GetOwningPlayer(gg_unit_Hpb1_0013)==Player($B)) // $B = 11
endfunction

function Trig_TrueIceAge_Summon_StageBelow5 takes nothing returns boolean
    return(udg_CidQuestStage<5)
endfunction

function Trig_TrueIceAge_Summon_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call UnitRemoveAbilityBJ('A11Z',gg_unit_ndmg_0124) // 'A11Z': ability "Activate Demon Gate"
    call UnitRemoveAbilityBJ('Ane2',gg_unit_ndmg_0124) // 'Ane2': object name not found in map data
    set udg_MainQuest[8]=CreateQuestBJ(bj_QUESTTYPE_REQ_DISCOVERED,(udg_QuestTitleRed+"True Ice Age"),"You summoned the demon lord Echele! He seems intent and capable of turning the entire world to ice. Face him atop the Snowy Mountain.","ReplaceableTextures\\CommandButtons\\BTNBlueMagnataur.blp")
    set udg_MainQuest[9]=GetLastCreatedQuestBJ()
    set udg_MainQuest[$B]=GetLastCreatedQuestBJ() // $B = 11
    set udg_MainQuest[19]=GetLastCreatedQuestBJ()
    set udg_MainQuest[20]=GetLastCreatedQuestBJ()
    call DestroyTrigger(gg_trg_Ambush_Skeletons_1)
    call DestroyTrigger(gg_trg_Ambush_Skeletons_2)
    call DestroyTrigger(gg_trg_Ambush_Skeletons_3)
    call DestroyTrigger(gg_trg_Ambush_Skeletons_4)
    call Cine_Enter()
    call Cam_PanToUnit(gg_unit_ndmg_0124,.0)
    call Wait_Polled(1.)
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    set udg_TempGroup=Group_UnitsInRangeOfLoc(800.,udg_TempPoint,Condition(function Trig_TrueIceAge_Summon_IsPlayerHero))
    call RemoveLocation(udg_TempPoint)
    if(Trig_TrueIceAge_Summon_AnyHeroNearby())then
        set udg_TempPlayer=GetOwningPlayer(GroupPickRandomUnit(udg_TempGroup))
    else
        set udg_TempPlayer=ForcePickRandomPlayer(udg_PlayingPlayers)
    endif
    call DestroyGroup(udg_TempGroup)
    call Text_Say(Player_GetHero(udg_TempPlayer),"Alright... what's the worst that could happen anyways.",true)
    call Text_Say(Player_GetHero(udg_TempPlayer),"I summon thee, demon lord!",true)
    call ForForce(udg_PlayingPlayers,function Trig_TrueIceAge_Summon_ShakeCameraSummon)
    call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUT,2.,"ReplaceableTextures\\CameraMasks\\White_mask.blp",0,0,100.,0)
    call Wait_Polled(.5)
    set udg_TempPoint=GetRectCenter(gg_rct_578)
    call CreateNUnitsAtLoc(1,'N08G',Player(8),udg_TempPoint,225.) // 'N08G': unit "Ice Demon"
    call RemoveLocation(udg_TempPoint)
    set udg_CinematicActor=GetLastCreatedUnit()
    call SetUnitPathing(udg_CinematicActor,false)
    set udg_TempPoint=GetRectCenter(gg_rct_579)
    call IssuePointOrderLocBJ(udg_CinematicActor,"move",udg_TempPoint)
    call RemoveLocation(udg_TempPoint)
    call SetUnitVertexColorBJ(udg_CinematicActor,'d','d','d',60.)
    call Wait_Polled(.5)
    call SetUnitVertexColorBJ(udg_CinematicActor,'d','d','d',40.)
    call Wait_Polled(.5)
    call SetUnitVertexColorBJ(udg_CinematicActor,'d','d','d',20.)
    call Wait_Polled(.5)
    call SetUnitVertexColorBJ(udg_CinematicActor,'d','d','d',.0)
    call Wait_Polled(1.5)
    call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUT,.0,"ReplaceableTextures\\CameraMasks\\White_mask.blp",0,0,100.,0)
    call Wait_Polled(1.)
    call ForForce(udg_PlayingPlayers,function Trig_TrueIceAge_Summon_ClearShakeSummon)
    call Cam_PanToUnit(udg_CinematicActor,0)
    call Wait_Polled(1.)
    call CinematicFadeBJ(bj_CINEFADETYPE_FADEIN,1.,"ReplaceableTextures\\CameraMasks\\White_mask.blp",0,0,100.,0)
    call Wait_Polled(2.)
    call Text_Say(udg_CinematicActor,"So I have been called into this world.",true)
    call Text_Say(udg_CinematicActor,"Yes, I feel the will of the rulers of this world. All is to be returned to ice.",true)
    call Text_Say(udg_CinematicActor,"Human, it was you who summoned me here? Curious indeed, I expected it to be the Zodiac Brave.",true)
    call Text_Say(udg_CinematicActor,"It matters not. With the powers of all Braves combined this world will be frozen over.",true)
    set udg_TempPoint=GetRectCenter(gg_rct_645)
    call IssuePointOrderLocBJ(udg_CinematicActor,"move",udg_TempPoint)
    call RemoveLocation(udg_TempPoint)
    call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUT,1.,"ReplaceableTextures\\CameraMasks\\White_mask.blp",0,0,100.,0)
    call Wait_Polled(1.5)
    call KillUnit(udg_CinematicActor)
    call RemoveUnit(udg_CinematicActor)
    call CinematicFadeBJ(bj_CINEFADETYPE_FADEIN,1.,"ReplaceableTextures\\CameraMasks\\White_mask.blp",0,0,100.,0)
    call Wait_Polled(1.5)
    call Text_Say(Player_GetHero(udg_TempPlayer),"Suddenly I'm not sure this was such a good idea after all...",true)
    call Cine_ExitAction()
    // Decrease udg_QuestsTotal by 13.
    set udg_QuestsTotal=(udg_QuestsTotal-$D) // $D = 13
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_DISCOVERED,"New Quest Received: |cffffcc00True Ice Age|r")
    call CreateFogModifierRectBJ(true,Player($B),FOG_OF_WAR_VISIBLE,gg_rct_658) // $B = 11
    call ModifyGateBJ(bj_GATEOPERATION_OPEN,gg_dest_LTg2_0021)
    call EnumDestructablesInRectAll(gg_rct_494,function Trig_TrueIceAge_Summon_ClearDoodads1)
    call EnumDestructablesInRectAll(gg_rct_495,function Trig_TrueIceAge_Summon_ClearDoodads2)
    call EnumDestructablesInRectAll(gg_rct_666,function Trig_TrueIceAge_Summon_ClearDoodads3)
    call EnumDestructablesInRectAll(gg_rct_667,function Trig_TrueIceAge_Summon_ClearDoodads4)
    call EnumDestructablesInRectAll(gg_rct_668,function Trig_TrueIceAge_Summon_ClearDoodads5)
    call DisableTrigger(gg_trg_Gate_WinterKey_Unlock)
    call DestroyTrigger(gg_trg_Gate_WinterKey_Unlock)
    call ShowUnitHide(gg_unit_U00L_0207)
    call PauseUnitBJ(true,gg_unit_U00L_0207)
    call SetUnitInvulnerable(gg_unit_U00L_0207,true)
    call ShowUnitHide(gg_unit_U00M_0206)
    if(Trig_TrueIceAge_Summon_WinterQueenAlive())then
        call KillUnit(gg_unit_U00M_0206)
    endif
    call RemoveUnit(gg_unit_U00M_0206)
    if(Trig_TrueIceAge_Summon_IceBraveNoPassive())then
        call DisableTrigger(gg_trg_Boss_Mateus_Death)
    else
        call DisableTrigger(gg_trg_Boss_Mateus_Intro)
    endif
    if(Trig_TrueIceAge_Summon_XQuestUnfinished())then
        call KillUnit(gg_unit_n0D3_0117)
        call RemoveUnit(gg_unit_n0D3_0117)
        call ForGroupBJ(udg_FarmCorpses,function Trig_TrueIceAge_Summon_KillAndRemoveUnit)
        call GroupClear(udg_FarmCorpses)
        if(Trig_TrueIceAge_Summon_XQuestActive())then
            call DestroyEffectBJ(udg_SpecialEffect[28])
        endif
        if(Trig_TrueIceAge_Summon_XQuestStage1())then
            call DisableTrigger(gg_trg_PriestX_Talk1)
        else
            if(Trig_TrueIceAge_Summon_XQuestStage3())then
                call DisableTrigger(gg_trg_PriestX_Talk2)
            else
                if(Trig_TrueIceAge_Summon_XQuestStage4())then
                    call DisableTrigger(gg_trg_Quest_LastRites_Start)
                else
                    if(Trig_TrueIceAge_Summon_XQuestStage5())then
                        call DisableTrigger(gg_trg_Exodus_Reveal)
                        call QuestSetCompletedBJ(udg_MainQuest[$E],true) // $E = 14
                    else
                        call DisableTrigger(gg_trg_Boss_Exodus_Death)
                        call GroupRemoveUnitSimple(gg_unit_U00K_0208,udg_BossUnits)
                        call ShowUnitHide(gg_unit_U00K_0208)
                        call PauseUnitBJ(true,gg_unit_U00K_0208)
                        call SetUnitInvulnerable(gg_unit_U00K_0208,true)
                        call QuestSetCompletedBJ(udg_MainQuest[$E],true) // $E = 14
                    endif
                endif
            endif
        endif
    endif
    if(Trig_TrueIceAge_Summon_SoulQuestActive())then
        call GroupRemoveUnitSimple(gg_unit_U00I_0210,udg_BossUnits)
        if(Trig_TrueIceAge_Summon_SoulQuestBelow4())then
            call DisableTrigger(gg_trg_Cuchulainn_Soul_Death)
            call KillUnit(gg_unit_U019_0253)
            call RemoveUnit(gg_unit_U019_0253)
            if(Trig_TrueIceAge_Summon_SoulQuestStage2())then
                call DisableTrigger(gg_trg_Shemhazai_Phase2_Cuchulainn)
                call ForGroupBJ(udg_ShemhazaiSoulClones,function Trig_TrueIceAge_Summon_KillAndRemoveUnit2)
            endif
        else
            call DisableTrigger(gg_trg_Boss_Shemhazai_Death)
        endif
        call ShowUnitHide(gg_unit_U00I_0210)
        call PauseUnitBJ(true,gg_unit_U00I_0210)
        call SetUnitInvulnerable(gg_unit_U00I_0210,true)
        call QuestSetCompletedBJ(udg_MainQuest[$D],true) // $D = 13
        set udg_QuestsTotal=(udg_QuestsTotal-1)
    endif
    if(Trig_TrueIceAge_Summon_DanaQuestAtLeast4())then
        if(Trig_TrueIceAge_Summon_DanaQuestDiscovered())then
            call QuestSetCompletedBJ(udg_MainQuest[$F],true) // $F = 15
            if(Trig_TrueIceAge_Summon_WaterBraveVisible())then
                set udg_DanaAvailable=false
                call GroupRemoveUnitSimple(gg_unit_U00N_0205,udg_BossUnits)
                if(Trig_TrueIceAge_Summon_WaterBraveVulnerable())then
                    call DisableTrigger(gg_trg_Boss_Famfrit_Death)
                else
                    call DisableTrigger(gg_trg_Famfrit_Encounter)
                endif
                call ShowUnitHide(gg_unit_U00N_0205)
                call PauseUnitBJ(true,gg_unit_U00N_0205)
                call SetUnitInvulnerable(gg_unit_U00N_0205,true)
            else
                set udg_DanaAvailable=true
                call DestroyEffectBJ(udg_SpecialEffect[70])
                if(Trig_TrueIceAge_Summon_DanaNotInvisible())then
                    call DisableTrigger(gg_trg_Dana_Death)
                    call UnitAddAbilityBJ('Apiv',gg_unit_n0BN_0171) // 'Apiv': object name not found in map data
                    call SetUnitInvulnerable(gg_unit_n0BN_0171,true)
                    set udg_TempPoint=GetUnitLoc(gg_unit_n0BN_0171)
                    set udg_TempPoint2=OffsetLocation(udg_TempPoint,-64.,0)
                    call RemoveLocation(udg_TempPoint)
                    call CreateItemLoc('I0HS',udg_TempPoint2) // 'I0HS': item "Maiden's Eye"
                    call SetItemInvulnerableBJ(GetLastCreatedItem(),true)
                    call RemoveLocation(udg_TempPoint2)
                else
                    call DisableTrigger(gg_trg_Dana_Receive_Eye)
                    call SetUnitOwner(gg_unit_n0BN_0171,Player(8),false)
                    call UnitRemoveAbilityBJ('AInv',gg_unit_n0BN_0171) // 'AInv': standard ability reference "Inventory"
                endif
            endif
        else
            call DisableTrigger(gg_trg_Quest_Illusions_Start)
            call DestroyEffectBJ(udg_SpecialEffect[70])
            set udg_DanaAvailable=true
        endif
    else
        if(Trig_TrueIceAge_Summon_DanaQuestNotStarted())then
            set udg_DanaAvailable=false
        endif
    endif
    if(Trig_TrueIceAge_Summon_SideQuest64Done())then
        call StartTimerBJ(udg_StoryDelayTimer,false,180.)
    else
        call ConditionalTriggerExecute(gg_trg_Billy_ShowTalkIcon)
    endif
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=$D // $D = 13
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        set udg_BossDefeated[GetForLoopIndexA()]=true
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    set udg_ZodiacBraveType[1]='U000' // 'U000': unit "Zodiac Brave of Death"
    set udg_ZodiacBraveType[2]='U00N' // 'U00N': unit "Zodiac Brave of Water"
    set udg_ZodiacBraveType[3]='U00K' // 'U00K': unit "Zodiac Brave of Aether"
    set udg_ZodiacBraveType[4]='U00E' // 'U00E': unit "Zodiac Brave of Thunder"
    set udg_ZodiacBraveType[5]='U00L' // 'U00L': unit "Zodiac Brave of Ice"
    set udg_ZodiacBraveType[6]='Uwar' // 'Uwar': unit "Zodiac Brave of Fire"
    set udg_ZodiacBraveType[7]='E002' // 'E002': unit "Zodiac Brave of Earth"
    set udg_ZodiacBraveType[8]='U019' // 'U019': unit "Zodiac Brave of Poison"
    set udg_ZodiacBraveType[9]='U00I' // 'U00I': unit "Zodiac Brave of Soul"
    set udg_ZodiacBraveType[$A]='U00J' // $A = 10; 'U00J': unit "Zodiac Brave of Gravity"
    set udg_ZodiacBraveType[$B]='U00O' // $B = 11; 'U00O': unit "Zodiac Brave of Wind"
    set udg_ZodiacBraveType[$C]='U00F' // $C = 12; 'U00F': unit "Zodiac Brave of Holy"
    call RemoveDestructable(gg_dest_LTcr_0019)
    call EnumDestructablesInRectAll(gg_rct_643,function Trig_TrueIceAge_Summon_KillDoodads)
    call EnableTrigger(gg_trg_TrueIceAge_BossIntro)
    if(Trig_TrueIceAge_Summon_StageBelow11())then
        call ShowUnitShow(gg_unit_Othr_0106)
    endif
    if(Trig_TrueIceAge_Summon_StageBelow5())then
        // Decrease udg_QuestsTotal by 3.
        set udg_QuestsTotal=(udg_QuestsTotal-3)
        if(Trig_TrueIceAge_Summon_StageAtLeast3())then
            call DisableTrigger(gg_trg_Cid_Berserk_Start)
            call DestroyTrigger(gg_trg_Cid_Berserk_Start)
            call QuestSetCompletedBJ(udg_MainQuest[2],true)
            call DestroyEffectBJ(udg_SpecialEffect[19])
            set udg_CidQuestOnHold=true
            if(Trig_TrueIceAge_Summon_StageAtLeast4())then
                call DisableTrigger(gg_trg_Artifact_Ping)
                call DisableTrigger(gg_trg_Artifact_Carrier)
                call RemoveItem(udg_QuestItem[$B]) // $B = 11
            endif
        else
            set udg_CidQuestOnHold=false
        endif
    else
        set udg_QuestsTotal=(udg_QuestsTotal-1)
        set udg_CidQuestOnHold=true
        if(Trig_TrueIceAge_Summon_EngineerIsHostile())then
            call TriggerExecute(gg_trg_Cid_Berserk_End)
        else
            if(Trig_TrueIceAge_Summon_StageIs7())then
                call DisableTrigger(gg_trg_Cid_Research_Done)
                call PauseTimerBJ(true,udg_CidResearchTimer)
                call ResetUnitAnimation(gg_unit_Hpb1_0013)
                call ResetUnitAnimation(udg_Mid)
            endif
            if(Trig_TrueIceAge_Summon_StageIs8())then
                call DisableTrigger(gg_trg_Cid_Talk_AoMadoushi)
                call DestroyEffectBJ(udg_SpecialEffect[20])
                call GroupRemoveUnitSimple(gg_unit_Hpb1_0013,udg_QuestUnits)
            endif
            if(Trig_TrueIceAge_Summon_StageAtLeast9())then
                call QuestSetCompletedBJ(udg_MainQuest[4],true)
            endif
            if(Trig_TrueIceAge_Summon_StageIs9())then
                if(Trig_TrueIceAge_Summon_NoPartnerChosen())then
                    call GroupRemoveUnitSimple(gg_unit_n012_0163,udg_QuestUnits)
                    call GroupRemoveUnitSimple(gg_unit_n013_0164,udg_QuestUnits)
                    call DestroyEffectBJ(udg_QuestMarkerEffect[2])
                    call DestroyEffectBJ(udg_QuestMarkerEffect[3])
                else
                    call GroupRemoveUnitSimple(udg_FluteHolder,udg_QuestUnits)
                    if(Trig_TrueIceAge_Summon_PartnerIsReno())then
                        call DestroyEffectBJ(udg_QuestMarkerEffect[3])
                    else
                        call DestroyEffectBJ(udg_QuestMarkerEffect[2])
                    endif
                endif
            endif
            if(Trig_TrueIceAge_Summon_StageIs10())then
                call DisableTrigger(gg_trg_AoMadoushi_Summon)
                call GroupRemoveUnitSimple(gg_unit_Othr_0106,udg_QuestUnits)
                call RemoveItem(udg_QuestItem[$B]) // $B = 11
            endif
            if(Trig_TrueIceAge_Summon_StageIs11())then
                call DisableTrigger(gg_trg_Turks_Give_Flute)
                call GroupRemoveUnitSimple(gg_unit_Othr_0106,udg_QuestUnits)
            endif
            if(Trig_TrueIceAge_Summon_StageIs12())then
                call DisableTrigger(gg_trg_Cine_StoneBreaks)
                call GroupRemoveUnitSimple(udg_ZodiacStone,udg_QuestUnits)
            endif
        endif
        call RemoveUnit(udg_ZodiacStone)
    endif
    set udg_StoryProgress=(udg_StoryProgress+1)
    call ConditionalTriggerExecute(gg_trg_QuestCount_Milestones)
    set udg_HuntStock[1]=(udg_HuntStock[1]+1)
    call AddUnitToStockBJ('n0BU',gg_unit_n009_0051,1,1) // 'n0BU': unit "Hunt: Marilith"
    set udg_HuntStock[2]=(udg_HuntStock[2]+1)
    call AddUnitToStockBJ('n0B8',gg_unit_n0B3_0049,1,1) // 'n0B8': unit "Hunt: Tindalos"
    call ConditionalTriggerExecute(gg_trg_Hunt_Board_Markers)
    call ConditionalTriggerExecute(gg_trg_HealingWaters_Prepare)
    call ConditionalTriggerExecute(gg_trg_Dwarves_Disappear)
    call Music_SetZoneTrack($B) // $B = 11
    set udg_AreaSpawnUnitA[7]='n0AL' // 'n0AL': unit "Holy Elemental"
    set udg_AreaSpawnUnitB[7]='n0AN' // 'n0AN': unit "Diakon Entite"
    call ConditionalTriggerExecute(gg_trg_Elemental_Setup)
    set udg_NewsText[3]=udg_NewsText[2]
    set udg_NewsText[2]=udg_NewsText[1]
    set udg_NewsText[6]=udg_NewsText[5]
    set udg_NewsText[5]=udg_NewsText[4]
    set udg_NewsText[1]="|cffffcc00Child falls ill|r"
    set udg_NewsText[4]="The son of the Tribal family has fallen terribly ill. It seems to be an unprecedented illness that our local priests cannot take care of. A heartfelt wish to please get better soon goes to little Danny!"
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_TrueIceAge_SpawnBrave_CinematicActiveSpawn takes nothing returns boolean
    return(udg_InCinematicMode)
endfunction

function Trig_TrueIceAge_SpawnBrave_BraveIndexIs12 takes nothing returns boolean
    return(udg_EchelePhase==$C) // $C = 12
endfunction

function Trig_TrueIceAge_SpawnBrave_BraveIndexIs11 takes nothing returns boolean
    return(udg_EchelePhase==$B) // $B = 11
endfunction

function Trig_TrueIceAge_SpawnBrave_BraveIndexIs3 takes nothing returns boolean
    return(udg_EchelePhase==3)
endfunction

function Trig_TrueIceAge_SpawnBrave_Actions takes nothing returns nothing
    call CreateNUnitsAtLoc(1,udg_ZodiacBraveType[udg_EchelePhase],Player($B),udg_TempPoint2,udg_TempReal) // $B = 11
    call RemoveLocation(udg_TempPoint2)
    call UnitAddAbilityBJ('Aeth',GetLastCreatedUnit()) // 'Aeth': object name not found in map data
    call SetUnitInvulnerable(GetLastCreatedUnit(),true)
    if(Trig_TrueIceAge_SpawnBrave_CinematicActiveSpawn())then
        call PauseUnitBJ(true,GetLastCreatedUnit())
    endif
    call GroupAddUnitSimple(GetLastCreatedUnit(),udg_BossSummons)
    call SetHeroLevelBJ(GetLastCreatedUnit(),50,false)
    call UnitAddItemByIdSwapped(GetItemTypeId(UnitItemInSlotBJ(udg_EcheleBoss,1)),GetLastCreatedUnit())
    call UnitAddItemByIdSwapped(GetItemTypeId(UnitItemInSlotBJ(udg_EcheleBoss,2)),GetLastCreatedUnit())
    call UnitAddItemByIdSwapped(GetItemTypeId(UnitItemInSlotBJ(udg_EcheleBoss,3)),GetLastCreatedUnit())
    call UnitAddItemByIdSwapped(GetItemTypeId(UnitItemInSlotBJ(udg_EcheleBoss,4)),GetLastCreatedUnit())
    call UnitAddItemByIdSwapped(GetItemTypeId(UnitItemInSlotBJ(udg_EcheleBoss,5)),GetLastCreatedUnit())
    call SetUnitVertexColorBJ(GetLastCreatedUnit(),20.,20.,20.,80.)
    if(Trig_TrueIceAge_SpawnBrave_BraveIndexIs3())then
        call UnitRemoveAbilityBJ('A12L',GetLastCreatedUnit()) // 'A12L': ability "Summon Trees of Ages"
    else
        if(Trig_TrueIceAge_SpawnBrave_BraveIndexIs11())then
            call UnitRemoveAbilityBJ('A11C',GetLastCreatedUnit()) // 'A11C': ability "!Revive Chaosjets"
        else
            if(Trig_TrueIceAge_SpawnBrave_BraveIndexIs12())then
                call UnitRemoveAbilityBJ('A0YN',GetLastCreatedUnit()) // 'A0YN': ability "!Holyja"
            endif
        endif
    endif
endfunction

function Trig_TrueIceAge_BossIntro_Conditions takes nothing returns boolean
    return((IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(GetUnitTypeId(GetTriggerUnit())!='H01D')and(udg_InCinematicMode==false))!=null // 'H01D': unit "Spirit of Gaya"
endfunction

function Trig_TrueIceAge_BossIntro_ShakeCameraIntro takes nothing returns nothing
    call CameraSetEQNoiseForPlayer(GetEnumPlayer(),6.)
endfunction

function Trig_TrueIceAge_BossIntro_ClearShakeIntro takes nothing returns nothing
    call CameraClearNoiseForPlayer(GetEnumPlayer())
endfunction

function Trig_TrueIceAge_BossIntro_UnpauseUnit takes nothing returns nothing
    call PauseUnitBJ(false,GetEnumUnit())
endfunction

function Trig_TrueIceAge_BossIntro_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    set udg_EchelePhase=0
    set udg_EcheleFormsKilled=0
    call Cine_Enter()
    call Cam_PanToUnit(GetTriggerUnit(),0)
    call Wait_Polled(2)
    set udg_TempPoint=GetRectCenter(gg_rct_657)
    set udg_TempReal=90.
    call ConditionalTriggerExecute(gg_trg_Boss_Echele_SpawnForm)
    call PauseUnitBJ(true,udg_EcheleBoss)
    call AddSpecialEffectTargetUnitBJ("overhead",udg_EcheleBoss,"Abilities\\Spells\\Items\\AIda\\AIdaCaster.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call AddSpecialEffectTargetUnitBJ("overhead",udg_EcheleBoss,"Abilities\\Spells\\Other\\Andt\\Andt.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call Cam_PanToUnit(udg_EcheleBoss,.2)
    call Wait_Polled(2)
    call Text_Say(GetTriggerUnit(),"Alright you demon! We brought you into this world, now it's time to expunge you back out!",true)
    call SetUnitAnimation(udg_EcheleBoss,"stand channel")
    call ForForce(udg_PlayingPlayers,function Trig_TrueIceAge_BossIntro_ShakeCameraIntro)
    call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUTIN,1.,"ReplaceableTextures\\CameraMasks\\White_mask.blp",0,0,100.,0)
    call Wait_Polled(1.)
    call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUTIN,1.,"ReplaceableTextures\\CameraMasks\\White_mask.blp",0,0,100.,0)
    call Wait_Polled(1.5)
    call Text_Say(null,"|cffffcc00Echele channels the power of all Zodiac Braves!|r",false)
    call Text_Say(GetTriggerUnit(),"Damn it! Guess we better make it quick...!",true)
    call Text_Say(null,"|cffffcc00Echele's spell will turn the world to ice in|r 15 minutes|cffffcc00!|r",true)
    call ForForce(udg_PlayingPlayers,function Trig_TrueIceAge_BossIntro_ClearShakeIntro)
    call Cine_ExitAction()
    call PauseUnitBJ(false,udg_EcheleBoss)
    call ForGroupBJ(udg_BossSummons,function Trig_TrueIceAge_BossIntro_UnpauseUnit)
    call StartTimerBJ(udg_WorldFreezeTimer,false,900.)
    set udg_WorldFreezeDialog=CreateTimerDialogBJ(GetLastCreatedTimerBJ(),"World Freeze")
    call TimerDialogSetTitleColorBJ(GetLastCreatedTimerDialogBJ(),40.,40.,100.,0)
    call TimerDialogSetTimeColorBJ(GetLastCreatedTimerDialogBJ(),40.,40.,100.,0)
    call EnableTrigger(gg_trg_Boss_Echele_Leash)
    call EnableTrigger(gg_trg_TrueIceAge_FreezeTimeout)
    call Music_SetTrack(18)
endfunction

function Trig_TrueIceAge_FreezeTimeout_CinematicActiveFreeze takes nothing returns boolean
    return(udg_InCinematicMode)
endfunction

function Trig_TrueIceAge_FreezeTimeout_ShakeCameraFreeze takes nothing returns nothing
    call CameraSetEQNoiseForPlayer(GetEnumPlayer(),10.)
endfunction

function Trig_TrueIceAge_FreezeTimeout_ClonesStillAlive takes nothing returns boolean
    return(IsUnitGroupEmptyBJ(udg_BossSummons)==false)
endfunction

function Trig_TrueIceAge_FreezeTimeout_ClearShakeFreeze takes nothing returns nothing
    call CameraClearNoiseForPlayer(GetEnumPlayer())
endfunction

function Trig_TrueIceAge_FreezeTimeout_HardcoreModeFreeze takes nothing returns boolean
    return(udg_HardcoreOff==false)
endfunction

function Trig_TrueIceAge_FreezeTimeout_IsPlayerOwnedUnit takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetFilterUnit()),udg_ActivePlayers))
endfunction

function Trig_TrueIceAge_FreezeTimeout_IsFilterAliveUnit takes nothing returns boolean
    return(IsUnitAliveBJ(GetFilterUnit()))
endfunction

function Trig_TrueIceAge_FreezeTimeout_IsLivePlayerUnitAlt takes nothing returns boolean
    return GetBooleanAnd(Trig_TrueIceAge_FreezeTimeout_IsPlayerOwnedUnit(),Trig_TrueIceAge_FreezeTimeout_IsFilterAliveUnit())
endfunction

function Trig_TrueIceAge_FreezeTimeout_MoveToRespawnArea takes nothing returns nothing
    set udg_TempPoint=GetRandomLocInRect(gg_rct_659)
    call SetUnitPositionLocFacingBJ(GetEnumUnit(),udg_TempPoint,270.)
    call RemoveLocation(udg_TempPoint)
endfunction

function Trig_TrueIceAge_FreezeTimeout_Actions takes nothing returns nothing
    call SetUnitInvulnerable(udg_EcheleBoss,true)
    if(Trig_TrueIceAge_FreezeTimeout_CinematicActiveFreeze())then
        call StartTimerBJ(udg_WorldFreezeTimer,false,.49)
        return
    endif
    call DisableTrigger(GetTriggeringTrigger())
    call DisableTrigger(gg_trg_Boss_Echele_FormChange)
    call DisableTrigger(gg_trg_Boss_Echele_Leash)
    call DisableTrigger(gg_trg_TrueIceAge_Victory)
    call DestroyTimerDialogBJ(udg_WorldFreezeDialog)
    call GroupRemoveUnitSimple(udg_EcheleBoss,udg_QuestUnits)
    call GroupRemoveUnitSimple(udg_EcheleBoss,udg_BossGroup)
    call Cine_Enter()
    call Cam_PanToUnit(udg_EcheleBoss,0)
    call SetUnitInvulnerable(udg_EcheleBoss,true)
    call Wait_Polled(1.)
    call SetUnitAnimation(udg_EcheleBoss,"stand channel")
    call ForForce(udg_PlayingPlayers,function Trig_TrueIceAge_FreezeTimeout_ShakeCameraFreeze)
    call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUTIN,1.,"ReplaceableTextures\\CameraMasks\\White_mask.blp",0,0,100.,0)
    call Wait_Polled(1.)
    call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUTIN,1.,"ReplaceableTextures\\CameraMasks\\White_mask.blp",0,0,100.,0)
    call Wait_Polled(1.)
    call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUT,1.,"ReplaceableTextures\\CameraMasks\\White_mask.blp",0,0,100.,0)
    call Wait_Polled(2.)
    if(Trig_TrueIceAge_FreezeTimeout_ClonesStillAlive())then
        call GroupAddGroup(udg_BossSummons,udg_EcheleMinionsToKill)
        call GroupClear(udg_BossSummons)
        call StartTimerBJ(udg_EcheleMinionKillTimer,false,.01)
    endif
    call ForForce(udg_PlayingPlayers,function Trig_TrueIceAge_FreezeTimeout_ClearShakeFreeze)
    call RemoveUnit(udg_EcheleBoss)
    call Text_Say(null,"As the spell reached completion, the world was turned to ice.\r\n\r\nAll life frozen for eternity, never to move again.",true)
    if(Trig_TrueIceAge_FreezeTimeout_HardcoreModeFreeze())then
        call ConditionalTriggerExecute(gg_trg_Ending_FrozenWorld)
        return
    endif
    call Text_Say(null,"|cffffcc00You may retry the battle against Echele from scratch.\r\n\r\nIf you do not feel strong enough, consider looking for additional gear or allies!|r",true)
    call CinematicFadeBJ(bj_CINEFADETYPE_FADEIN,1.,"ReplaceableTextures\\CameraMasks\\White_mask.blp",0,0,100.,0)
    call Cine_ExitAction()
    set udg_TempGroup=Group_UnitsInRect(gg_rct_658,Condition(function Trig_TrueIceAge_FreezeTimeout_IsLivePlayerUnitAlt))
    call ForGroupBJ(udg_TempGroup,function Trig_TrueIceAge_FreezeTimeout_MoveToRespawnArea)
    call DestroyGroup(udg_TempGroup)
    set udg_ShadowForcedSpawn=48
    call EnableTrigger(gg_trg_TrueIceAge_BossIntro)
    call Music_ClearTrack(18)
endfunction

function Trig_TrueIceAge_Victory_Conditions takes nothing returns boolean
    return(GetTriggerUnit()==udg_EcheleBoss)
endfunction

function Trig_TrueIceAge_Victory_SpeedrunModeVictory takes nothing returns boolean
    return(udg_SpeedrunMode)
endfunction

function Trig_TrueIceAge_Victory_KilledByPlayerHero takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetKillingUnitBJ()),udg_PlayingPlayers))
endfunction

function Trig_TrueIceAge_Victory_ShakeCameraSacrifice takes nothing returns nothing
    call CameraSetEQNoiseForPlayer(GetEnumPlayer(),10.)
endfunction

function Trig_TrueIceAge_Victory_ClearShakeSacrifice takes nothing returns nothing
    call CameraClearNoiseForPlayer(GetEnumPlayer())
endfunction

function Trig_TrueIceAge_Victory_GiveCrystalShards takes nothing returns nothing
    call AdjustPlayerStateBJ(5,GetEnumPlayer(),PLAYER_STATE_RESOURCE_LUMBER)
endfunction

function Trig_TrueIceAge_Victory_ArenaCup8ClearedAlt takes nothing returns boolean
    return(udg_CupWins[8]>=3)
endfunction

function Trig_TrueIceAge_Victory_PlayerLacksAward16Alt takes nothing returns boolean
    return(IsPlayerInForce(GetEnumPlayer(),udg_TitleForce[16])==false)
endfunction

function Trig_TrueIceAge_Victory_PlayerLacksAward17 takes nothing returns boolean
    return(IsPlayerInForce(GetEnumPlayer(),udg_TitleForce[17])==false)
endfunction

function Trig_TrueIceAge_Victory_PlayerHasAward15 takes nothing returns boolean
    return(IsPlayerInForce(GetEnumPlayer(),udg_TitleForce[$F])) // $F = 15
endfunction

function Trig_TrueIceAge_Victory_GrantAwards takes nothing returns nothing
    if(Trig_TrueIceAge_Victory_PlayerHasAward15())then
        if(Trig_TrueIceAge_Victory_PlayerLacksAward16Alt())then
            set udg_TempPlayer=GetEnumPlayer()
            set udg_TempInteger=16
            call ConditionalTriggerExecute(gg_trg_Title_Grant)
        endif
        if(Trig_TrueIceAge_Victory_PlayerLacksAward17())then
            set udg_TempPlayer=GetEnumPlayer()
            set udg_TempInteger=17
            call ConditionalTriggerExecute(gg_trg_Title_Grant)
        endif
    endif
endfunction

function Trig_TrueIceAge_Victory_LothlorienOpen takes nothing returns boolean
    return(udg_LothlorienOpen)
endfunction

function Trig_TrueIceAge_Victory_DanaIsAvailable takes nothing returns boolean
    return(udg_DanaAvailable)
endfunction

function Trig_TrueIceAge_Victory_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call PauseTimerBJ(true,udg_WorldFreezeTimer)
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_QuestUnits)
    call DisableTrigger(gg_trg_TrueIceAge_FreezeTimeout)
    call DisableTrigger(gg_trg_Boss_Echele_Leash)
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call ReviveHeroLoc(GetTriggerUnit(),udg_TempPoint,false)
    call RemoveLocation(udg_TempPoint)
    call SetUnitInvulnerable(GetTriggerUnit(),true)
    call Cine_Enter()
    if(Trig_TrueIceAge_Victory_SpeedrunModeVictory())then
        set udg_BossUnit=GetTriggerUnit()
        call ConditionalTriggerExecute(gg_trg_Speedrun_Accolade)
    endif
    call Cam_PanToUnit(GetTriggerUnit(),0)
    call Wait_Polled(1.)
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    set udg_TempReal=GetUnitFacing(GetTriggerUnit())
    set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,400.,udg_TempReal)
    call SetUnitPositionLocFacingLocBJ(gg_unit_E002_0075,udg_TempPoint2,udg_TempPoint)
    call RemoveLocation(udg_TempPoint2)
    // The remainder after dividing ((udg_TempReal) plus (30)) by (360).
    set udg_TempReal=ModuloReal((udg_TempReal+30.),360.)
    set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,400.,udg_TempReal)
    call SetUnitPositionLocFacingLocBJ(gg_unit_Uwar_0192,udg_TempPoint2,udg_TempPoint)
    call RemoveLocation(udg_TempPoint2)
    // The remainder after dividing ((udg_TempReal) plus (30)) by (360).
    set udg_TempReal=ModuloReal((udg_TempReal+30.),360.)
    set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,400.,udg_TempReal)
    call SetUnitPositionLocFacingLocBJ(gg_unit_U00L_0207,udg_TempPoint2,udg_TempPoint)
    call RemoveLocation(udg_TempPoint2)
    // The remainder after dividing ((udg_TempReal) plus (30)) by (360).
    set udg_TempReal=ModuloReal((udg_TempReal+30.),360.)
    set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,400.,udg_TempReal)
    call SetUnitPositionLocFacingLocBJ(gg_unit_U000_0248,udg_TempPoint2,udg_TempPoint)
    call RemoveLocation(udg_TempPoint2)
    // The remainder after dividing ((udg_TempReal) plus (30)) by (360).
    set udg_TempReal=ModuloReal((udg_TempReal+30.),360.)
    set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,400.,udg_TempReal)
    call SetUnitPositionLocFacingLocBJ(gg_unit_U00O_0191,udg_TempPoint2,udg_TempPoint)
    call RemoveLocation(udg_TempPoint2)
    // The remainder after dividing ((udg_TempReal) plus (30)) by (360).
    set udg_TempReal=ModuloReal((udg_TempReal+30.),360.)
    set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,400.,udg_TempReal)
    call SetUnitPositionLocFacingLocBJ(gg_unit_U00J_0209,udg_TempPoint2,udg_TempPoint)
    call RemoveLocation(udg_TempPoint2)
    // The remainder after dividing ((udg_TempReal) plus (30)) by (360).
    set udg_TempReal=ModuloReal((udg_TempReal+30.),360.)
    set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,400.,udg_TempReal)
    call SetUnitPositionLocFacingLocBJ(gg_unit_U00F_0221,udg_TempPoint2,udg_TempPoint)
    call RemoveLocation(udg_TempPoint2)
    // The remainder after dividing ((udg_TempReal) plus (30)) by (360).
    set udg_TempReal=ModuloReal((udg_TempReal+30.),360.)
    set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,400.,udg_TempReal)
    call SetUnitPositionLocFacingLocBJ(gg_unit_U00I_0210,udg_TempPoint2,udg_TempPoint)
    call RemoveLocation(udg_TempPoint2)
    // The remainder after dividing ((udg_TempReal) plus (30)) by (360).
    set udg_TempReal=ModuloReal((udg_TempReal+30.),360.)
    set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,400.,udg_TempReal)
    call CreateNUnitsAtLocFacingLocBJ(1,'uabc',Player($B),udg_TempPoint2,udg_TempPoint) // 'uabc': unit "Tainted Cúchulainn"; $B = 11
    call RemoveLocation(udg_TempPoint2)
    call ShowUnitHide(GetLastCreatedUnit())
    call PauseUnitBJ(true,GetLastCreatedUnit())
    call SetUnitInvulnerable(GetLastCreatedUnit(),true)
    call UnitRemoveAbilityBJ('Aap1',GetLastCreatedUnit()) // 'Aap1': ability "Plague"
    set udg_Cuchulainn=GetLastCreatedUnit()
    // The remainder after dividing ((udg_TempReal) plus (30)) by (360).
    set udg_TempReal=ModuloReal((udg_TempReal+30.),360.)
    set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,400.,udg_TempReal)
    call SetUnitPositionLocFacingLocBJ(gg_unit_U00N_0205,udg_TempPoint2,udg_TempPoint)
    call RemoveLocation(udg_TempPoint2)
    // The remainder after dividing ((udg_TempReal) plus (30)) by (360).
    set udg_TempReal=ModuloReal((udg_TempReal+30.),360.)
    set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,400.,udg_TempReal)
    call SetUnitPositionLocFacingLocBJ(gg_unit_U00K_0208,udg_TempPoint2,udg_TempPoint)
    call RemoveLocation(udg_TempPoint2)
    // The remainder after dividing ((udg_TempReal) plus (30)) by (360).
    set udg_TempReal=ModuloReal((udg_TempReal+30.),360.)
    set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,400.,udg_TempReal)
    call SetUnitPositionLocFacingLocBJ(gg_unit_U00E_0222,udg_TempPoint2,udg_TempPoint)
    call RemoveLocation(udg_TempPoint2)
    call RemoveLocation(udg_TempPoint)
    call Wait_Polled(1.)
    if(Trig_TrueIceAge_Victory_KilledByPlayerHero())then
        set udg_CinematicActor=Player_GetHero(GetOwningPlayer(GetKillingUnitBJ()))
    else
        set udg_CinematicActor=Player_GetHero(ForcePickRandomPlayer(udg_PlayingPlayers))
    endif
    call Text_Say(udg_CinematicActor,"Damn it... there's no end to his power!",true)
    call Text_Say(null,"Hee hee, it's inspiring, isn't it?",true)
    call Text_Say(null,"It truly is. How I miss the days we fought with such fervor for what we wanted to accomplish ourselves.",true)
    call Text_Say(udg_CinematicActor,"Hmm? Am I hearing voices now?",true)
    call Text_Say(null,"It's alright, human.",true)
    call CinematicFadeBJ(bj_CINEFADETYPE_FADEIN,1.,"ReplaceableTextures\\CameraMasks\\White_mask.blp",0,0,0,0)
    call ShowUnitShow(gg_unit_E002_0075)
    call Wait_Polled(2.)
    call Text_Say(gg_unit_E002_0075,"You've fought well.",true)
    call Text_Say(udg_CinematicActor,"Demon!?",true)
    call CinematicFadeBJ(bj_CINEFADETYPE_FADEIN,1.,"ReplaceableTextures\\CameraMasks\\White_mask.blp",0,0,0,0)
    call ShowUnitShow(gg_unit_Uwar_0192)
    call ShowUnitShow(gg_unit_U00L_0207)
    call ShowUnitShow(gg_unit_U00F_0221)
    call ShowUnitShow(gg_unit_U00J_0209)
    call ShowUnitShow(gg_unit_U00N_0205)
    call ShowUnitShow(gg_unit_U00K_0208)
    call ShowUnitShow(gg_unit_U00O_0191)
    call ShowUnitShow(gg_unit_U000_0248)
    call ShowUnitShow(gg_unit_U00I_0210)
    call ShowUnitShow(udg_Cuchulainn)
    call ShowUnitShow(gg_unit_U00E_0222)
    call Wait_Polled(2)
    call Text_Say(gg_unit_Uwar_0192,"We'll take it from here.",true)
    call Text_Say(udg_CinematicActor,"More demons!?",true)
    call Text_Say(gg_unit_E002_0075,"My fellow Braves. It has been too long since we've all been together.",true)
    call Text_Transmission(udg_Cuchulainn,"Cúchulainn",". . . . . . . . . .","(null)",null,5.,true)
    call Text_Say(gg_unit_U00I_0210,"He's saying he is overjoyed to see you all again!",true)
    call Text_Say(gg_unit_U00E_0222,"It really has been too long. But no time for pleasantries.",true)
    call Text_Say(gg_unit_E002_0075,"Lord Echele. Allow me to express my gratitude. But we've decided not to make use of your power.",true)
    call Text_Say(udg_EcheleBoss,"Zodiac Brave. You know as well as I do that this is folly. This world is inevitably headed towards its end. If you do not preserve what is left of it in ice now it will merely fall to ruin.",true)
    call Text_Say(gg_unit_U00K_0208,"Perhaps you are right.",true)
    call Text_Say(gg_unit_U00N_0205,"But if there is a chance...",true)
    call Text_Say(gg_unit_E002_0075,"Then we would have this world live on. If there are people such as this outsider who can keep it going.",true)
    call Text_Say(gg_unit_U00L_0207,"You need not worry about your daughter, Lord Echele. She is a splendid ruler already.",true)
    call Text_Say(udg_EcheleBoss,"Hmph. Even if you decide so, the power inside me cannot be stopped anymore. Unless you're...",true)
    call Text_Say(gg_unit_U00O_0191,"Yeah. We're taking our place in the annals, where we belong.",true)
    call Text_Say(gg_unit_U000_0248,"You've all kept me waiting.",true)
    call Text_Say(gg_unit_U00J_0209,"Works for me. I didn't think I'd ever get to leave that empty void.",true)
    call Text_Say(gg_unit_U00F_0221,"Your orders, my leader?",true)
    call Text_Say(gg_unit_E002_0075,"Zodiac Braves ...",true)
    call Text_Transmission(gg_unit_E002_0075,"Hashmalum","Zodiac Braves ... Fulfill your duty!","Zodiac Braves ...",null,0,true)
    call Text_Transmission(gg_unit_E002_0075,"Hashmalum","Zodiac Braves ... Fulfill your duty! For Gaya !","Zodiac Braves ... Fulfill your duty!",null,0,true)
    call Text_Say(null,"For Gaya!",true)
    call SetUnitAnimation(gg_unit_E002_0075,"stand ready alternate")
    call SetUnitAnimation(gg_unit_Uwar_0192,"spell slam")
    call SetUnitAnimation(gg_unit_U00L_0207,"spell channel")
    call SetUnitAnimation(gg_unit_U00N_0205,"spell")
    call SetUnitAnimation(gg_unit_U00K_0208,"spell")
    call SetUnitAnimation(gg_unit_U00O_0191,"spell slam")
    call SetUnitAnimation(gg_unit_U000_0248,"stand channel")
    call SetUnitAnimation(gg_unit_U00I_0210,"spell")
    call SetUnitAnimation(udg_Cuchulainn,"stand channel")
    call SetUnitAnimation(gg_unit_U00E_0222,"attack")
    call SetUnitAnimation(gg_unit_U00J_0209,"spell")
    call SetUnitAnimation(gg_unit_U00F_0221,"spell")
    call SetUnitAnimation(udg_EcheleBoss,"death")
    call ForForce(udg_PlayingPlayers,function Trig_TrueIceAge_Victory_ShakeCameraSacrifice)
    call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUTIN,1.,"ReplaceableTextures\\CameraMasks\\White_mask.blp",0,0,100.,0)
    call Wait_Polled(1.)
    call SetUnitAnimation(gg_unit_Uwar_0192,"spell slam")
    call SetUnitAnimation(gg_unit_U00L_0207,"spell channel")
    call SetUnitAnimation(gg_unit_U00N_0205,"spell")
    call SetUnitAnimation(gg_unit_U00K_0208,"spell")
    call SetUnitAnimation(gg_unit_U00O_0191,"spell slam")
    call SetUnitAnimation(gg_unit_U00I_0210,"spell")
    call SetUnitAnimation(gg_unit_U00E_0222,"attack")
    call SetUnitAnimation(gg_unit_U00J_0209,"spell")
    call SetUnitAnimation(gg_unit_U00F_0221,"spell")
    call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUTIN,1.,"ReplaceableTextures\\CameraMasks\\White_mask.blp",0,0,100.,0)
    call SetUnitAnimation(gg_unit_Uwar_0192,"spell slam")
    call SetUnitAnimation(gg_unit_U00L_0207,"spell channel")
    call SetUnitAnimation(gg_unit_U00N_0205,"spell")
    call SetUnitAnimation(gg_unit_U00K_0208,"spell")
    call SetUnitAnimation(gg_unit_U00O_0191,"spell slam")
    call SetUnitAnimation(gg_unit_U00I_0210,"spell")
    call SetUnitAnimation(gg_unit_U00E_0222,"attack")
    call SetUnitAnimation(gg_unit_U00J_0209,"spell")
    call SetUnitAnimation(gg_unit_U00F_0221,"spell")
    call Wait_Polled(1.)
    call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUT,1.,"ReplaceableTextures\\CameraMasks\\White_mask.blp",0,0,100.,0)
    call Wait_Polled(1.5)
    call ForForce(udg_PlayingPlayers,function Trig_TrueIceAge_Victory_ClearShakeSacrifice)
    call Music_ClearTrack(18)
    call Music_SetZoneTrack($C) // $C = 12
    call DestroyTimerDialogBJ(udg_WorldFreezeDialog)
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_BossGroup)
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateItemLoc('I0H0',udg_TempPoint) // 'I0H0': item "Paladin Shield"
    call CreateItemLoc('I01Z',udg_TempPoint) // 'I01Z': item "Crystal Shard"
    call CreateItemLoc('I01Z',udg_TempPoint) // 'I01Z': item "Crystal Shard"
    call CreateItemLoc('I01Z',udg_TempPoint) // 'I01Z': item "Crystal Shard"
    call CreateItemLoc('I03P',udg_TempPoint) // 'I03P': item "Megalixir"
    call RemoveLocation(udg_TempPoint)
    call KillUnit(udg_EcheleBoss)
    call KillUnit(gg_unit_E002_0075)
    call KillUnit(gg_unit_Uwar_0192)
    call KillUnit(gg_unit_U00L_0207)
    call KillUnit(gg_unit_U00N_0205)
    call KillUnit(gg_unit_U00K_0208)
    call KillUnit(gg_unit_U00O_0191)
    call KillUnit(gg_unit_U000_0248)
    call KillUnit(gg_unit_U00I_0210)
    call KillUnit(udg_Cuchulainn)
    call KillUnit(gg_unit_U00E_0222)
    call KillUnit(gg_unit_U00J_0209)
    call KillUnit(gg_unit_U00F_0221)
    call Wait_Polled(1.)
    call RemoveUnit(udg_EcheleBoss)
    call RemoveUnit(gg_unit_E002_0075)
    call RemoveUnit(gg_unit_Uwar_0192)
    call RemoveUnit(gg_unit_U00L_0207)
    call RemoveUnit(gg_unit_U00N_0205)
    call RemoveUnit(gg_unit_U00K_0208)
    call RemoveUnit(gg_unit_U00O_0191)
    call RemoveUnit(gg_unit_U000_0248)
    call RemoveUnit(gg_unit_U00I_0210)
    call RemoveUnit(udg_Cuchulainn)
    call RemoveUnit(gg_unit_U00E_0222)
    call RemoveUnit(gg_unit_U00J_0209)
    call RemoveUnit(gg_unit_U00F_0221)
    call Wait_Polled(.5)
    call CinematicFadeBJ(bj_CINEFADETYPE_FADEIN,1.,"ReplaceableTextures\\CameraMasks\\White_mask.blp",0,0,100.,0)
    call Wait_Polled(2)
    call Text_Say(udg_CinematicActor,"I don't understand what just happened... but this feels like the beginning of something unforetold for this world.",true)
    call Text_Say(null,"|n|cffffcc00All players get 50000 gold, 50000 exp and 5 crystal shards.|r",true)
    call Reward_Give($C350,$C350,null) // $C350 = 50000
    call ForForce(udg_PlayingPlayers,function Trig_TrueIceAge_Victory_GiveCrystalShards)
    call Cine_ExitAction()
    if(Trig_TrueIceAge_Victory_ArenaCup8ClearedAlt())then
        call SaveIntegerBJ(0,2,'z',udg_GameStateHash)
        call SaveIntegerBJ(1,2,'{',udg_GameStateHash)
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_COMPLETED,"Quest Completed: |cffffcc00True Ice Age|r")
    call QuestSetCompletedBJ(udg_MainQuest[20],true)
    set udg_QuestsCompleted=(udg_QuestsCompleted+1)
    call SaveIntegerBJ(1,2,91,udg_GameStateHash)
    call SaveIntegerBJ(1,2,'g',udg_GameStateHash)
    call SaveIntegerBJ(1,2,$AD,udg_GameStateHash) // $AD = 173
    call SaveIntegerBJ(1,2,$AE,udg_GameStateHash) // $AE = 174
    call SaveIntegerBJ(1,2,$AF,udg_GameStateHash) // $AF = 175
    call SaveIntegerBJ(1,2,$B0,udg_GameStateHash) // $B0 = 176
    call SaveIntegerBJ(1,2,$B2,udg_GameStateHash) // $B2 = 178
    call SaveIntegerBJ(1,2,$B3,udg_GameStateHash) // $B3 = 179
    call ConditionalTriggerExecute(gg_trg_Promotion_Award_Random)
    call ForForce(udg_PlayingPlayers,function Trig_TrueIceAge_Victory_GrantAwards)
    if(Trig_TrueIceAge_Victory_LothlorienOpen())then
        set udg_SpecialEffect[30]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_Emns_0156,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    else
        call DisableTrigger(gg_trg_Talk_Lothlorien_Greet)
    endif
    call EnableTrigger(gg_trg_Epilogue_Lothlorien)
    set udg_SpecialEffect[21]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_Othr_0106,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call EnableTrigger(gg_trg_Epilogue_BlueMage)
    set udg_GafgarionRevived=true
    set udg_TempPoint=GetRectCenter(gg_rct_582)
    call ConditionalTriggerExecute(gg_trg_Spawn_Gafgarion)
    call RemoveLocation(udg_TempPoint)
    call SetUnitFacingTimed(udg_StoryBoss,.0,0)
    call PauseUnitBJ(true,udg_StoryBoss)
    call SetUnitInvulnerable(udg_StoryBoss,true)
    set udg_SpecialEffect[43]=AddSpecialEffectTargetUnitBJ("overhead",udg_StoryBoss,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call EnableTrigger(gg_trg_Epilogue_DarkKnight)
    if(Trig_TrueIceAge_Victory_DanaIsAvailable())then
        set udg_SpecialEffect[70]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_n0BN_0171,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
        call EnableTrigger(gg_trg_Epilogue_Dana)
    endif
    call StartTimerBJ(udg_WorldFreezeTimer,false,1.)
    call EnableTrigger(gg_trg_Epilogue_WaitForCid)
    call AddUnitToStockBJ('n0BG',gg_unit_n0BV_0229,1,1) // 'n0BG': unit "Hunt: Vercingetorix"
    set udg_HuntStock[5]=(udg_HuntStock[5]+1)
    call ConditionalTriggerExecute(gg_trg_Hunt_Board_Markers)
    set udg_StoryProgress=(udg_StoryProgress+1)
    call ConditionalTriggerExecute(gg_trg_QuestCount_Milestones)
    call ConditionalTriggerExecute(gg_trg_Priscilla_ShowMarker)
    call ConditionalTriggerExecute(gg_trg_ShinrasPlan_Prepare)
    call EnableTrigger(gg_trg_HuntFestival_Announce)
    call ConditionalTriggerExecute(gg_trg_Billy_ShowTalkIcon)
    call TriggerExecute(gg_trg_HolyAnkh_Waygate)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_TrueIceAge automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_TrueIceAge (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_TrueIceAge takes nothing returns nothing
endfunction

function Register_TrueIceAge_GateUnlock takes nothing returns nothing
    set gg_trg_TrueIceAge_GateUnlock=CreateTrigger()
    call TriggerRegisterUnitInRangeSimple(gg_trg_TrueIceAge_GateUnlock,700.,gg_unit_ndmg_0124)
    call TriggerAddCondition(gg_trg_TrueIceAge_GateUnlock,Condition(function Trig_TrueIceAge_GateUnlock_Conditions))
    call TriggerAddAction(gg_trg_TrueIceAge_GateUnlock,function Trig_TrueIceAge_GateUnlock_Actions)
endfunction

function Register_TrueIceAge_Summon takes nothing returns nothing
    set gg_trg_TrueIceAge_Summon=CreateTrigger()
    call DisableTrigger(gg_trg_TrueIceAge_Summon)
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_TrueIceAge_Summon,Player($B),EVENT_PLAYER_UNIT_SPELL_EFFECT) // $B = 11
    call TriggerAddCondition(gg_trg_TrueIceAge_Summon,Condition(function Trig_TrueIceAge_Summon_Conditions))
    call TriggerAddAction(gg_trg_TrueIceAge_Summon,function Trig_TrueIceAge_Summon_Actions)
endfunction

function Register_TrueIceAge_SpawnBrave takes nothing returns nothing
    set gg_trg_TrueIceAge_SpawnBrave=CreateTrigger()
    call DisableTrigger(gg_trg_TrueIceAge_SpawnBrave)
    call TriggerAddAction(gg_trg_TrueIceAge_SpawnBrave,function Trig_TrueIceAge_SpawnBrave_Actions)
endfunction

function Register_TrueIceAge_BossIntro takes nothing returns nothing
    set gg_trg_TrueIceAge_BossIntro=CreateTrigger()
    call DisableTrigger(gg_trg_TrueIceAge_BossIntro)
    call TriggerRegisterEnterRectSimple(gg_trg_TrueIceAge_BossIntro,gg_rct_657)
    call TriggerAddCondition(gg_trg_TrueIceAge_BossIntro,Condition(function Trig_TrueIceAge_BossIntro_Conditions))
    call TriggerAddAction(gg_trg_TrueIceAge_BossIntro,function Trig_TrueIceAge_BossIntro_Actions)
endfunction

function Register_TrueIceAge_FreezeTimeout takes nothing returns nothing
    set gg_trg_TrueIceAge_FreezeTimeout=CreateTrigger()
    call DisableTrigger(gg_trg_TrueIceAge_FreezeTimeout)
    call TriggerRegisterTimerExpireEventBJ(gg_trg_TrueIceAge_FreezeTimeout,udg_WorldFreezeTimer)
    call TriggerAddAction(gg_trg_TrueIceAge_FreezeTimeout,function Trig_TrueIceAge_FreezeTimeout_Actions)
endfunction

function Register_TrueIceAge_Victory takes nothing returns nothing
    set gg_trg_TrueIceAge_Victory=CreateTrigger()
    call DisableTrigger(gg_trg_TrueIceAge_Victory)
    call TriggerAddCondition(gg_trg_TrueIceAge_Victory,Condition(function Trig_TrueIceAge_Victory_Conditions))
    call TriggerAddAction(gg_trg_TrueIceAge_Victory,function Trig_TrueIceAge_Victory_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_TrueIceAge takes nothing returns nothing
    call Register_TrueIceAge_GateUnlock()
    call Register_TrueIceAge_Summon()
    call Register_TrueIceAge_SpawnBrave()
    call Register_TrueIceAge_BossIntro()
    call Register_TrueIceAge_FreezeTimeout()
    call Register_TrueIceAge_Victory()
endfunction

endlibrary
