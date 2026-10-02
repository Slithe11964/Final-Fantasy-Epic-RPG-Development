library TKalmSiege3 requires TCam, TCine, TGroup, TLink, TLoc, TMusic, TPlayerHero, TReward, TText, TUnit, TWait
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_KalmSiege3_Call=null
    trigger gg_trg_KalmSiege3_CidTalk=null
    trigger gg_trg_KalmSiege3_Start=null
    trigger gg_trg_KalmSiege3_Restart=null
    trigger gg_trg_KalmSiege3_Begin=null
    trigger gg_trg_KalmSiege3_DemonArrive=null
    trigger gg_trg_KalmSiege3_DemonSummon=null
    trigger gg_trg_KalmSiege3_ChiefGuard=null
    trigger gg_trg_KalmSiege3_TrackDeaths=null
    trigger gg_trg_KalmSiege3_Defeat=null
    trigger gg_trg_KalmSiege3_Complete=null
    trigger gg_trg_KalmSiege3_Fail=null
    // Variables only this module uses.
    unit udg_PossessedChieftain=null
endglobals

function Trig_KalmSiege3_Call_IsCidVisible takes nothing returns boolean
    return(IsUnitHiddenBJ(gg_unit_Hpb1_0013)==false)
endfunction

function Trig_KalmSiege3_Call_Actions takes nothing returns nothing
    if(Trig_KalmSiege3_Call_IsCidVisible())then
        call DisplayTextToForce(GetPlayersAll(),"|cff00ffffCid has something to tell you !!!|r")
        call PlaySoundBJ(gg_snd_UtherTaunt2)
    endif
    call GroupAddUnitSimple(gg_unit_Hpb1_0013,udg_BossUnits)
    set udg_SpecialEffect[30]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_Hpb1_0013,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call EnableTrigger(gg_trg_KalmSiege3_CidTalk)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_KalmSiege3_CidTalk_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_Hpb1_0013,true,true,true))
endfunction

function Trig_KalmSiege3_CidTalk_ApplyCamera takes nothing returns nothing
    call CameraSetupApplyForPlayer(true,gg_cam_001,GetEnumPlayer(),0)
endfunction

function Trig_KalmSiege3_CidTalk_NoSouthBeasts takes nothing returns boolean
    return(IsUnitGroupEmptyBJ(udg_RedBeastGroup))
endfunction

function Trig_KalmSiege3_CidTalk_CinematicsOn takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_KalmSiege3_CidTalk_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[30])
    if(Trig_KalmSiege3_CidTalk_CinematicsOn())then
        call Cine_Enter()
        call ForForce(udg_PlayingPlayers,function Trig_KalmSiege3_CidTalk_ApplyCamera)
        call Text_Say(gg_unit_Hpb1_0013,"Greetings again. I've summoned you to speak once more about the Sieges our town has been facing.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"The enemy is surely gathering for another attack.",false)
        if(Trig_KalmSiege3_CidTalk_NoSouthBeasts())then
            call Text_Say(gg_unit_Hpb1_0013,"Indeed. The last siege caught us off guard quite a bit at the south gate, with all those monsters pouring in so suddenly while the battle at the north gate was ongoing.",false)
        else
            call Text_Say(gg_unit_Hpb1_0013,"Indeed. The last siege caught us off guard quite a bit at the south gate. Regular forest monsters would not have been a problem, but we were attacked by red-skinned beasts as well!",false)
            call Text_Say(udg_Mid,"They looked a lot like Ao Madoushi. They may have been his kin once.",false)
            call Text_Say(gg_unit_Hpb1_0013,"Good thinking, Mid. However what matters right now is that they are very much hostile to us, and will likely attack again.",false)
        endif
        call Text_Say(gg_unit_Hpb1_0013,"We won't be blindsided again. I'll guard the south gate when the time comes.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Sounds like a good plan. What about the demon who showed up?",false)
        call Text_Say(gg_unit_Hpb1_0013,"Yes, we've figured out who that is as well. His name is Adrammelech, and he is the Zodiac Brave of Thunder. He seems to be their army commander of sorts.",false)
        call Text_Say(udg_Mid,"It is strange that he attacks us without any backup. They'd have a stronger chance of destroying the town if other Zodiac Braves attacked us as well.",false)
        call Text_Say(gg_unit_Hpb1_0013,"It is rather mystifying, but unfortunately speculating about their motivations is a luxury we cannot afford right now. Whatever their reasons may be, we must strike them back and keep the town safe no matter what.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Indeed we do. We'll take that demon down next time.",false)
        call Text_Say(gg_unit_Hpb1_0013,"It is reassuring to hear you say that. I recall Meliadoul also wanted to speak with you. I'm sure the next siege is fast approaching. You'd best ready yourselves.",false)
        call Cine_ExitAction()
    endif
    set udg_StoryProgress=(udg_StoryProgress+1)
    call ConditionalTriggerExecute(gg_trg_QuestCount_Milestones)
    call GroupRemoveUnitSimple(gg_unit_Hpb1_0013,udg_BossUnits)
    call GroupAddUnitSimple(gg_unit_Hvwd_0098,udg_BossUnits)
    set udg_SpecialEffect[30]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_Hvwd_0098,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call EnableTrigger(gg_trg_KalmSiege3_Start)
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_UPDATED,"Talk to Meliadoul.")
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_KalmSiege3_Start_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_Hvwd_0098,true,true,true))
endfunction

function Trig_KalmSiege3_Start_CinematicsOn takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_KalmSiege3_Start_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[30])
    if(Trig_KalmSiege3_Start_CinematicsOn())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"We've come. How are things looking?",false)
        call Text_Say(gg_unit_Hvwd_0098,"The enemy has gathered a larger army than ever, and the golden demon is gearing up for battle himself. This will likely be the decisive battle.",false)
        call Text_Say(gg_unit_Hvwd_0098,"In addition to that, after being blindsided in the previous siege we've decided to scout for opposition on the south gate of Kalm and just as we feared, there's an army preparing to strike there as well. We are hopelessly outnumbered.",false)
        call Text_Say(gg_unit_Hvwd_0098,"We've recovered from the previous assault, but at this rate our defenses are not capable of fending off these assailants.",false)
        call Text_Say(gg_unit_Hvwd_0098,"It pains me to be so blunt, but we are dependent on your help. So please, help us once more.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"We will. We can't have this town fall either.",false)
        call Text_Say(gg_unit_Hvwd_0098,"... Thank you. Really. You are outsiders, but you've been our greatest ally in these trying times.",false)
        call Text_Say(gg_unit_Hvwd_0098,"Our plan is to still concentrate the main defense force on the north gate, as this is likely where the demon will strike. Cid and a squad of guards will defend the south gate.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Where do you need us to help?",false)
        call Text_Say(gg_unit_Hvwd_0098,"Unfortunately, on both sides. We can keep the enemy at bay, but we won't be able to fend them off without your help.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"That's not good... ideally we can finish this battle before it goes on too long by taking down the demon.",false)
        call Text_Say(gg_unit_Hvwd_0098,"Yes. If you can take down the demon himself, we may be able to turn the tide of battle. Though if he plans on overwhelming us at last I doubt he will leave us much choice but to take him head on.",false)
        call Text_Say(gg_unit_Hvwd_0098,"It's time. This will probably be the ultimate battle for Kalm. Make your final preparations now.",false)
        call Text_Say(gg_unit_Hvwd_0098,"In about |cffffcc0030 seconds|r, it will begin. We're counting on you.",false)
        call Cine_ExitAction()
    endif
    set udg_SpecialEffect[30]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_Hvwd_0098,"Objects\\RandomObject\\RandomObject.mdl")
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_DISCOVERED,"New Quest Received: |cffffcc00Kalm Siege III|r")
    set udg_MainQuest[$B]=CreateQuestBJ(bj_QUESTTYPE_REQ_DISCOVERED,(udg_ColorGold+"Kalm Siege III"),"Kalm is facing its ultimate battle! Help defend the town from the golden demon and his forces!","ReplaceableTextures\\CommandButtons\\BTNGargoyle.blp") // $B = 11
    set udg_StoryProgress=(udg_StoryProgress+1)
    call ConditionalTriggerExecute(gg_trg_QuestCount_Milestones)
    call StartTimerBJ(udg_SiegeTimer,false,30)
    set udg_SiegeTimerWindow=CreateTimerDialogBJ(GetLastCreatedTimerBJ(),"Kalm Siege in ...")
    call EnableTrigger(gg_trg_KalmSiege3_Begin)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_KalmSiege3_Restart_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_Hvwd_0098,true,true,true))
endfunction

function Trig_KalmSiege3_Restart_CinematicsOn takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_KalmSiege3_Restart_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[30])
    if(Trig_KalmSiege3_Restart_CinematicsOn())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(gg_unit_Hvwd_0098,"It's time. This will probably be the ultimate battle for Kalm. Make your final preparations now.",false)
        call Text_Say(gg_unit_Hvwd_0098,"In about |cffffcc0010 seconds|r, it will begin. We're counting on you.",false)
        call Cine_ExitAction()
    endif
    set udg_SpecialEffect[30]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_Hvwd_0098,"Objects\\RandomObject\\RandomObject.mdl")
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_UPDATED,"Defend Kalm from the siege starting in 10 seconds!\r\n\r\n- Meliadoul must survive!\r\n- Cid must survive!")
    call QuestSetDescriptionBJ(udg_MainQuest[$B],"Defend Kalm from the siege starting in 10 seconds!\r\n\r\nMeliadoul must survive!\r\nCid must survive!") // $B = 11
    call StartTimerBJ(udg_SiegeTimer,false,10.)
    set udg_SiegeTimerWindow=CreateTimerDialogBJ(GetLastCreatedTimerBJ(),"Kalm Siege in ...")
    call EnableTrigger(gg_trg_KalmSiege3_Begin)
endfunction

function Trig_KalmSiege3_Begin_CinematicBusy takes nothing returns boolean
    return(udg_InCinematicMode)
endfunction

function Trig_KalmSiege3_Begin_CinematicsOn takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_KalmSiege3_Begin_RetryEnabled takes nothing returns boolean
    return(udg_HardcoreOff)
endfunction

function Trig_KalmSiege3_Begin_ScalingOff takes nothing returns boolean
    return(udg_EternityMode==false)
endfunction

function Trig_KalmSiege3_Begin_IsForestSlot takes nothing returns boolean
    // Calculation 1:
    // The remainder after dividing (loop counter A) by (20).
    // Calculation 2:
    // The remainder after dividing (loop counter A) by (2).
    return(ModuloInteger(GetForLoopIndexA(),20)>=$A)and(ModuloInteger(GetForLoopIndexA(),2)==1) // $A = 10
endfunction

function Trig_KalmSiege3_Begin_IsShieldSlot takes nothing returns boolean
    // Calculation 1:
    // The remainder after dividing (loop counter A) by (9).
    // Calculation 2:
    // The remainder after dividing (loop counter A) by (9).
    return(ModuloInteger(GetForLoopIndexA(),9)==0)or(ModuloInteger(GetForLoopIndexA(),9)==4)
endfunction

function Trig_KalmSiege3_Begin_ShieldSlotCheck takes nothing returns boolean
    return(Trig_KalmSiege3_Begin_IsShieldSlot())
endfunction

function Trig_KalmSiege3_Begin_IsGhoulMasterSlot takes nothing returns boolean
    // The remainder after dividing (loop counter A) by (19).
    return(udg_GhoulMasterDisabled==false)and(ModuloInteger(GetForLoopIndexA(),19)==1)
endfunction

function Trig_KalmSiege3_Begin_IsBoostedSouthSlot takes nothing returns boolean
    // The remainder after dividing (loop counter A) by (2).
    return(ModuloInteger(GetForLoopIndexA(),2)==0)and(udg_EternityMode==false)
endfunction

function Trig_KalmSiege3_Begin_SendGuardPatrol takes nothing returns nothing
    set udg_TempPoint=GetUnitLoc(GetEnumUnit())
    set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,1024.,GetUnitFacing(GetEnumUnit()))
    call RemoveLocation(udg_TempPoint)
    call IssuePointOrderLocBJ(GetEnumUnit(),"patrol",udg_TempPoint2)
    call RemoveLocation(udg_TempPoint2)
    call PauseUnitBJ(false,GetEnumUnit())
endfunction

function Trig_KalmSiege3_Begin_SendGuardForward takes nothing returns nothing
    set udg_TempPoint=GetUnitLoc(GetEnumUnit())
    set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,384.,GetUnitFacing(GetEnumUnit()))
    call RemoveLocation(udg_TempPoint)
    call IssuePointOrderLocBJ(GetEnumUnit(),"move",udg_TempPoint2)
    call RemoveLocation(udg_TempPoint2)
    call PauseUnitBJ(false,GetEnumUnit())
endfunction

function Trig_KalmSiege3_Begin_SendGuardAttack takes nothing returns nothing
    set udg_TempPoint=GetUnitLoc(GetEnumUnit())
    set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,384.,GetUnitFacing(GetEnumUnit()))
    call RemoveLocation(udg_TempPoint)
    call IssuePointOrderLocBJ(GetEnumUnit(),"attack",udg_TempPoint2)
    call RemoveLocation(udg_TempPoint2)
    call PauseUnitBJ(false,GetEnumUnit())
endfunction

function Trig_KalmSiege3_Begin_Actions takes nothing returns nothing
    if(Trig_KalmSiege3_Begin_CinematicBusy())then
        call StartTimerBJ(udg_SiegeTimer,false,.49)
        return
    endif
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyTimerDialogBJ(udg_SiegeTimerWindow)
    call Cine_Enter()
    call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUT,1.,"ReplaceableTextures\\CameraMasks\\White_mask.blp",0,0,0,0)
    call GroupRemoveUnitSimple(gg_unit_Hvwd_0098,udg_BossUnits)
    call Wait_Polled(1.5)
    call DestroyEffectBJ(udg_SpecialEffect[30])
    call ConditionalTriggerExecute(gg_trg_Spawn_KalmDefenders)
    set udg_SpecialEffect[30]=AddSpecialEffectTargetUnitBJ("overhead",udg_RangerHero,"Objects\\RandomObject\\RandomObject.mdl")
    call Wait_Polled(.5)
    call CinematicFadeBJ(bj_CINEFADETYPE_FADEIN,1.,"ReplaceableTextures\\CameraMasks\\White_mask.blp",0,0,0,0)
    call Wait_Polled(1.5)
    if(Trig_KalmSiege3_Begin_CinematicsOn())then
        call Cam_PanToUnit(udg_EngineerHero,2.)
        call Wait_Polled(2.5)
        call Text_Say(udg_EngineerHero,"Fight for your lives, brothers and sisters!",false)
        call Cam_PanToUnit(udg_RangerHero,2.)
        call Wait_Polled(2.5)
        call Text_Say(udg_RangerHero,"Everyone! Protect our home with everything you've got!",false)
    endif
    call Cine_ExitAction()
    if(Trig_KalmSiege3_Begin_RetryEnabled())then
        call EnableTrigger(gg_trg_KalmSiege3_Defeat)
    else
        call EnableTrigger(gg_trg_KalmSiege3_Fail)
    endif
    call EnableTrigger(gg_trg_KalmSiege3_TrackDeaths)
    call EnableTrigger(gg_trg_KalmSiege3_DemonArrive)
    call EnableTrigger(gg_trg_KalmSiege_AITick)
    call EnableTrigger(gg_trg_KalmSiege_LeaderRetreat)
    call StartTimerBJ(udg_SiegeTimer,false,90.)
    call Music_SetTrack(40)
    call SetUnitLifePercentBJ(gg_unit_U00E_0222,'d')
    call SetUnitManaPercentBJ(gg_unit_U00E_0222,'d')
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=LoadIntegerBJ(4,2,udg_SpawnDataHashRef)
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        set udg_TempPoint=GetRectCenter(LoadRectHandleBJ(GetForLoopIndexA(),4,udg_SpawnRectHashRef))
        if(Trig_KalmSiege3_Begin_IsForestSlot())then
            // The remainder after dividing (loop counter A) by (8).
            call CreateNUnitsAtLocFacingLocBJ(1,udg_SiegeSouthUnitType[ModuloInteger(GetForLoopIndexA(),8)],Player($B),udg_TempPoint,udg_TempPoint2) // $B = 11
        else
            // The remainder after dividing (loop counter A) by (10).
            call CreateNUnitsAtLocFacingLocBJ(1,udg_SiegeNorthUnitType[ModuloInteger(GetForLoopIndexA(),$A)],Player($B),udg_TempPoint,udg_TempPoint2) // $A = 10; $B = 11
            if(Trig_KalmSiege3_Begin_ScalingOff())then
                // Calculation 1:
                // (BlzGetUnitBaseDamage(GetLastCreatedUnit(), 0)) times (10).
                // Calculation 2:
                // (1) minus (1).
                call BlzSetUnitBaseDamage(GetLastCreatedUnit(),(BlzGetUnitBaseDamage(GetLastCreatedUnit(),0)*$A),(1-1)) // $A = 10
                // (BlzGetUnitBaseDamage(GetLastCreatedUnit(), 1)) times (10).
                call BlzSetUnitBaseDamage(GetLastCreatedUnit(),(BlzGetUnitBaseDamage(GetLastCreatedUnit(),1)*$A),1) // $A = 10
                // (maximum health of GetLastCreatedUnit()) times (10).
                call BlzSetUnitMaxHP(GetLastCreatedUnit(),(BlzGetUnitMaxHP(GetLastCreatedUnit())*$A)) // $A = 10
                call SetUnitLifePercentBJ(GetLastCreatedUnit(),'d')
            endif
        endif
        call RemoveLocation(udg_TempPoint)
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_SpecialUnits)
        call SetUnitAcquireRangeBJ(GetLastCreatedUnit(),600.)
        call Unit_ScaleToLevel60(bj_lastCreatedUnit)
        call IssuePointOrderLocBJ(GetLastCreatedUnit(),"attack",udg_TempPoint2)
        if(Trig_KalmSiege3_Begin_ShieldSlotCheck())then
            call UnitAddAbilityBJ('A0YK',GetLastCreatedUnit()) // 'A0YK': ability "Permanent Lightning Shield"
            call GroupAddUnitSimple(GetLastCreatedUnit(),udg_ShockAuraUnitGroup)
        endif
        if(Trig_KalmSiege3_Begin_IsGhoulMasterSlot())then
            call UnitAddAbilityBJ('A0RB',GetLastCreatedUnit()) // 'A0RB': ability "Ghoul Master"
            call UnitAddAbilityBJ('ACvp',GetLastCreatedUnit()) // 'ACvp': object name not found in map data
        endif
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=LoadIntegerBJ(1,2,udg_SpawnDataHashRef)
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        set udg_TempPoint=GetRectCenter(LoadRectHandleBJ(GetForLoopIndexA(),1,udg_SpawnRectHashRef))
        // The remainder after dividing (loop counter A) by (8).
        call CreateNUnitsAtLocFacingLocBJ(1,udg_SiegeSouthUnitType[ModuloInteger(GetForLoopIndexA(),8)],Player($B),udg_TempPoint,udg_TempPoint2) // $B = 11
        call RemoveLocation(udg_TempPoint)
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_SummonedUnits)
        call Unit_ScaleToLevel60(bj_lastCreatedUnit)
        if(Trig_KalmSiege3_Begin_IsBoostedSouthSlot())then
            // Calculation 1:
            // (BlzGetUnitBaseDamage(GetLastCreatedUnit(), 0)) times (20).
            // Calculation 2:
            // (1) minus (1).
            call BlzSetUnitBaseDamage(GetLastCreatedUnit(),(BlzGetUnitBaseDamage(GetLastCreatedUnit(),0)*20),(1-1))
            // (BlzGetUnitBaseDamage(GetLastCreatedUnit(), 1)) times (20).
            call BlzSetUnitBaseDamage(GetLastCreatedUnit(),(BlzGetUnitBaseDamage(GetLastCreatedUnit(),1)*20),1)
            // (maximum health of GetLastCreatedUnit()) times (20).
            call BlzSetUnitMaxHP(GetLastCreatedUnit(),(BlzGetUnitMaxHP(GetLastCreatedUnit())*20))
            call SetUnitLifePercentBJ(GetLastCreatedUnit(),'d')
        endif
        call SetUnitAcquireRangeBJ(GetLastCreatedUnit(),600.)
        call IssuePointOrderLocBJ(GetLastCreatedUnit(),"attack",udg_TempPoint2)
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    call Wait_Polled(.2)
    call ForGroupBJ(udg_AllyBrothersGroup,function Trig_KalmSiege3_Begin_SendGuardPatrol)
    call Wait_Polled(.2)
    call ForGroupBJ(udg_AllyRangerGroup,function Trig_KalmSiege3_Begin_SendGuardForward)
    call Wait_Polled(.2)
    call ForGroupBJ(udg_AllyEngineerGroup,function Trig_KalmSiege3_Begin_SendGuardAttack)
endfunction

function Trig_KalmSiege3_DemonArrive_CinematicBusy takes nothing returns boolean
    return(udg_InCinematicMode)
endfunction

function Trig_KalmSiege3_DemonArrive_CinematicsOn takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_KalmSiege3_DemonArrive_ChieftainAlive takes nothing returns boolean
    return(IsUnitInGroup(gg_unit_Opgh_0169,udg_RecruitedAllies))
endfunction

function Trig_KalmSiege3_DemonArrive_Actions takes nothing returns nothing
    if(Trig_KalmSiege3_DemonArrive_CinematicBusy())then
        call StartTimerBJ(udg_SiegeTimer,false,.49)
        return
    endif
    set udg_TempPoint=GetRectCenter(gg_rct_588)
    set udg_TempPoint2=GetUnitLoc(udg_RangerHero)
    call SetUnitPositionLocFacingLocBJ(gg_unit_U00E_0222,udg_TempPoint,udg_TempPoint2)
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\ThunderClap\\ThunderClapCaster.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Weapons\\Bolt\\BoltImpact.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(udg_TempPoint)
    call RemoveLocation(udg_TempPoint2)
    if(Trig_KalmSiege3_DemonArrive_CinematicsOn())then
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_U00E_0222,.0)
        call Wait_Polled(.5)
        call ShowUnitShow(gg_unit_U00E_0222)
        call Wait_Polled(1.)
        call Text_Say(udg_RangerHero,"You again!",false)
        call Text_Say(gg_unit_U00E_0222,"Humans. You've been nothing but a plague since you came to this world.",false)
        call Text_Say(gg_unit_U00E_0222,"You are unfit to live in our world. I, Adrammelech, the Zodiac Brave of Thunder, will rectify this, and wipe your race off the face of this world!",false)
        call Text_Say(udg_RangerHero,"Here he comes! Strike him down with all we have!",false)
        call Cine_ExitAction()
    else
        call ShowUnitShow(gg_unit_U00E_0222)
    endif
    call PauseUnitBJ(false,gg_unit_U00E_0222)
    call SetUnitInvulnerable(gg_unit_U00E_0222,false)
    call GroupAddUnitSimple(gg_unit_U00E_0222,udg_QuestUnits)
    set udg_TempPoint2=GetUnitLoc(gg_unit_U00E_0222)
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=6
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        // (loop counter A treated as a decimal-capable number) times (60).
        set udg_TempPoint=Loc_PolarOffset(udg_TempPoint2,256,(I2R(GetForLoopIndexA())*60.))
        call CreateNUnitsAtLocFacingLocBJ(1,'u00R',Player($B),udg_TempPoint,udg_TempPoint2) // 'u00R': unit "Shambling Corpse"; $B = 11
        call RemoveLocation(udg_TempPoint)
        call AddSpecialEffectTargetUnitBJ("origin",GetLastCreatedUnit(),"Abilities\\Spells\\Undead\\RaiseSkeletonWarrior\\RaiseSkeleton.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_SpecialUnits)
        call SetUnitAcquireRangeBJ(GetLastCreatedUnit(),600.)
        call Unit_ScaleToLevel60(bj_lastCreatedUnit)
        call SetUnitLifePercentBJ(GetLastCreatedUnit(),50.)
        // (maximum health of GetLastCreatedUnit()) divided by (2).
        call BlzSetUnitMaxHP(GetLastCreatedUnit(),(BlzGetUnitMaxHP(GetLastCreatedUnit())/ 2))
        call UnitAddAbilityBJ('A0ZU',GetLastCreatedUnit()) // 'A0ZU': ability "Double Vulnerable"
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    call RemoveLocation(udg_TempPoint2)
    if(Trig_KalmSiege3_DemonArrive_ChieftainAlive())then
        set udg_TempPoint2=GetRectCenter(gg_rct_584)
        set udg_TempPoint=GetRectCenter(gg_rct_515)
        call CreateNUnitsAtLocFacingLocBJ(1,'Opgh',Player($B),udg_TempPoint,udg_TempPoint2) // 'Opgh': unit "Corrupted Orc Chieftain"; $B = 11
        call RemoveLocation(udg_TempPoint)
        set udg_PossessedChieftain=GetLastCreatedUnit()
        call SetHeroLevelBJ(GetLastCreatedUnit(),40,false)
        call UnitAddItemByIdSwapped('I01C',GetLastCreatedUnit()) // 'I01C': item "Giant Axe"
        call UnitAddItemByIdSwapped('I016',GetLastCreatedUnit()) // 'I016': item "Platinum Shield"
        call UnitAddItemByIdSwapped('I01K',GetLastCreatedUnit()) // 'I01K': item "Platinum Helmet"
        call UnitAddItemByIdSwapped('I01T',GetLastCreatedUnit()) // 'I01T': item "Platinum Mail"
        call UnitAddItemByIdSwapped('I00G',GetLastCreatedUnit()) // 'I00G': item "Armguard"
        call UnitAddItemByIdSwapped('I02V',GetLastCreatedUnit()) // 'I02V': item "Nectar"
        call SetUnitAcquireRangeBJ(GetLastCreatedUnit(),900.)
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_SpecialUnits)
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_SiegeSummonGroup)
        call IssuePointOrderLocBJ(GetLastCreatedUnit(),"attack",udg_TempPoint2)
        call RemoveLocation(udg_TempPoint2)
    endif
    call Music_SetTrack($D) // $D = 13
    call EnableTrigger(gg_trg_KalmSiege3_DemonSummon)
    call EnableTrigger(gg_trg_KalmSiege3_ChiefGuard)
    call EnableTrigger(gg_trg_KalmSiege3_Complete)
endfunction

function Trig_KalmSiege3_DemonSummon_UnderCorpseCap takes nothing returns boolean
    return(CountUnitsInGroup(udg_TempGroup)<20)
endfunction

function Trig_KalmSiege3_DemonSummon_Actions takes nothing returns nothing
    set udg_TempGroup=Group_UnitsOfPlayerAndType(Player($B),'u00R') // $B = 11; 'u00R': unit "Shambling Corpse"
    if(Trig_KalmSiege3_DemonSummon_UnderCorpseCap())then
        call DestroyGroup(udg_TempGroup)
        set udg_TempPoint2=GetUnitLoc(gg_unit_U00E_0222)
        // Calculation 1:
        // A random decimal number between 128 and 384.
        // Calculation 2:
        // (facing in degrees of gg_unit_U00E_0222) plus (a random decimal number between 145 and 215).
        set udg_TempPoint=Loc_PolarOffset(udg_TempPoint2,GetRandomReal(128.,384.),(GetUnitFacing(gg_unit_U00E_0222)+GetRandomReal(145.,215.)))
        call CreateNUnitsAtLocFacingLocBJ(1,'u00R',Player($B),udg_TempPoint,udg_TempPoint2) // 'u00R': unit "Shambling Corpse"; $B = 11
        call RemoveLocation(udg_TempPoint)
        call AddSpecialEffectTargetUnitBJ("origin",GetLastCreatedUnit(),"Abilities\\Spells\\Undead\\RaiseSkeletonWarrior\\RaiseSkeleton.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_SpecialUnits)
        call SetUnitAcquireRangeBJ(GetLastCreatedUnit(),600.)
        call Unit_ScaleToLevel60(bj_lastCreatedUnit)
        call SetUnitLifePercentBJ(GetLastCreatedUnit(),50.)
        // (maximum health of GetLastCreatedUnit()) divided by (2).
        call BlzSetUnitMaxHP(GetLastCreatedUnit(),(BlzGetUnitMaxHP(GetLastCreatedUnit())/ 2))
        call UnitAddAbilityBJ('A0ZU',GetLastCreatedUnit()) // 'A0ZU': ability "Double Vulnerable"
        call IssuePointOrderLocBJ(GetLastCreatedUnit(),"attack",udg_TempPoint2)
        call RemoveLocation(udg_TempPoint2)
    else
        call DestroyGroup(udg_TempGroup)
    endif
endfunction

function Trig_KalmSiege3_ChiefGuard_Conditions takes nothing returns boolean
    return(GetTriggerUnit()==udg_PossessedChieftain)
endfunction

function Trig_KalmSiege3_ChiefGuard_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call UnitAddAbilityBJ('A0X2',gg_unit_U00E_0222) // 'A0X2': ability "Perma Cover"
    call Link_SaveCaster(udg_PossessedChieftain,gg_unit_U00E_0222,.0)
endfunction

function Trig_KalmSiege3_TrackDeaths_IsSiegeMonster takes nothing returns boolean
    return(IsUnitInGroup(GetTriggerUnit(),udg_SpecialUnits))or(IsUnitInGroup(GetTriggerUnit(),udg_SummonedUnits))
endfunction

function Trig_KalmSiege3_TrackDeaths_Conditions takes nothing returns boolean
    return(Trig_KalmSiege3_TrackDeaths_IsSiegeMonster())
endfunction

function Trig_KalmSiege3_TrackDeaths_IsChieftain takes nothing returns boolean
    return(GetTriggerUnit()==udg_PossessedChieftain)
endfunction

function Trig_KalmSiege3_TrackDeaths_IsTempSpawn takes nothing returns boolean
    return(IsUnitInGroup(GetTriggerUnit(),udg_SiegeSummonGroup))
endfunction

function Trig_KalmSiege3_TrackDeaths_Actions takes nothing returns nothing
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_SpecialUnits)
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_SummonedUnits)
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_ShockAuraUnitGroup)
    if(Trig_KalmSiege3_TrackDeaths_IsChieftain())then
        call UnitRemoveAbilityBJ('A0X2',gg_unit_U00E_0222) // 'A0X2': ability "Perma Cover"
        call UnitRemoveBuffBJ('B064',gg_unit_U00E_0222) // 'B064': buff "Perma Cover"
    endif
    if(Trig_KalmSiege3_TrackDeaths_IsTempSpawn())then
        call GroupRemoveUnitSimple(GetTriggerUnit(),udg_SiegeSummonGroup)
        set udg_TempPoint3=GetUnitLoc(GetTriggerUnit())
        call AddSpecialEffectLocBJ(udg_TempPoint3,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportTarget.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint3)
        call RemoveUnit(GetTriggerUnit())
    endif
endfunction

function Trig_KalmSiege3_Defeat_IsLeaderDead takes nothing returns boolean
    return(GetTriggerUnit()==udg_RangerHero)or(GetTriggerUnit()==udg_EngineerHero)
endfunction

function Trig_KalmSiege3_Defeat_Conditions takes nothing returns boolean
    return(Trig_KalmSiege3_Defeat_IsLeaderDead())
endfunction

function Trig_KalmSiege3_Defeat_CinematicBusy takes nothing returns boolean
    return(udg_InCinematicMode)
endfunction

function Trig_KalmSiege3_Defeat_StripMonsterBuffs takes nothing returns nothing
    call UnitAddAbilityBJ('A0QY',GetEnumUnit()) // 'A0QY': ability "Devalued"
    call UnitRemoveAbilityBJ('A0YK',GetEnumUnit()) // 'A0YK': ability "Permanent Lightning Shield"
    call GroupRemoveUnitSimple(GetEnumUnit(),udg_ShockAuraUnitGroup)
endfunction

function Trig_KalmSiege3_Defeat_KilledByPlayer takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetKillingUnitBJ()),udg_PlayingPlayers))
endfunction

function Trig_KalmSiege3_Defeat_CinematicsOn takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_KalmSiege3_Defeat_KillGuard takes nothing returns nothing
    call KillUnit(GetEnumUnit())
endfunction

function Trig_KalmSiege3_Defeat_KillDefender takes nothing returns nothing
    call KillUnit(GetEnumUnit())
endfunction

function Trig_KalmSiege3_Defeat_KillSouthGuard takes nothing returns nothing
    call KillUnit(GetEnumUnit())
endfunction

function Trig_KalmSiege3_Defeat_RemoveSummon takes nothing returns nothing
    call RemoveUnit(GetEnumUnit())
endfunction

function Trig_KalmSiege3_Defeat_PurgeNorthMonster takes nothing returns nothing
    call KillUnit(GetEnumUnit())
    call RemoveUnit(GetEnumUnit())
endfunction

function Trig_KalmSiege3_Defeat_PurgeSouthMonster takes nothing returns nothing
    call KillUnit(GetEnumUnit())
    call RemoveUnit(GetEnumUnit())
endfunction

function Trig_KalmSiege3_Defeat_ShowTownUnit takes nothing returns nothing
    call ShowUnitShow(GetEnumUnit())
endfunction

function Trig_KalmSiege3_Defeat_Actions takes nothing returns nothing
    if(Trig_KalmSiege3_Defeat_CinematicBusy())then
        set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
        call ReviveHeroLoc(GetTriggerUnit(),udg_TempPoint,false)
        call RemoveLocation(udg_TempPoint)
        call SetUnitLifeBJ(GetTriggerUnit(),1.)
        return
    endif
    call SetUnitInvulnerable(gg_unit_U00E_0222,true)
    call DisableTrigger(gg_trg_KalmSiege3_TrackDeaths)
    call DisableTrigger(gg_trg_KalmSiege3_DemonArrive)
    call DisableTrigger(gg_trg_KalmSiege3_DemonSummon)
    call DisableTrigger(gg_trg_KalmSiege3_ChiefGuard)
    call DisableTrigger(gg_trg_KalmSiege3_Complete)
    call DisableTrigger(gg_trg_KalmSiege_AITick)
    call DisableTrigger(gg_trg_KalmSiege_LeaderRetreat)
    call ForGroupBJ(udg_SpecialUnits,function Trig_KalmSiege3_Defeat_StripMonsterBuffs)
    call Cine_Enter()
    call Cam_PanToUnit(GetTriggerUnit(),0)
    call DestroyEffectBJ(udg_SpecialEffect[30])
    call Wait_Polled(1.)
    call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUT,1.,"ReplaceableTextures\\CameraMasks\\White_mask.blp",0,0,0,0)
    call Wait_Polled(1.5)
    call Music_ClearTrack($D) // $D = 13
    call Music_ClearTrack(40)
    call PlayThematicMusicBJ("war3mapImported\\FF7GameOver.mp3")
    if(Trig_KalmSiege3_Defeat_CinematicsOn())then
        if(Trig_KalmSiege3_Defeat_KilledByPlayer())then
            call Text_Say(null,"After being betrayed by the adventurers they trusted, Kalm was quickly overrun by monsters...",true)
        else
            call Text_Say(null,"With the fall of their defense line, Kalm was quickly overrun by monsters...",true)
        endif
    endif
    call UnitRemoveAbilityBJ('A0X2',gg_unit_U00E_0222) // 'A0X2': ability "Perma Cover"
    call UnitRemoveBuffBJ('B064',gg_unit_U00E_0222) // 'B064': buff "Perma Cover"
    call GroupRemoveUnitSimple(gg_unit_U00E_0222,udg_QuestUnits)
    call ShowUnitHide(gg_unit_U00E_0222)
    call ForGroupBJ(udg_AllyBrothersGroup,function Trig_KalmSiege3_Defeat_KillGuard)
    call ForGroupBJ(udg_AllyRangerGroup,function Trig_KalmSiege3_Defeat_KillDefender)
    call ForGroupBJ(udg_AllyEngineerGroup,function Trig_KalmSiege3_Defeat_KillSouthGuard)
    call ForGroupBJ(udg_InactiveUnits,function Trig_KalmSiege3_Defeat_RemoveSummon)
    call ForGroupBJ(udg_SpecialUnits,function Trig_KalmSiege3_Defeat_PurgeNorthMonster)
    call ForGroupBJ(udg_SummonedUnits,function Trig_KalmSiege3_Defeat_PurgeSouthMonster)
    call ForGroupBJ(udg_RecruitedAllies,function Trig_KalmSiege3_Defeat_ShowTownUnit)
    set udg_SpecialEffect[30]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_Hvwd_0098,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call EnableTrigger(gg_trg_KalmSiege3_Restart)
    call GroupAddUnitSimple(gg_unit_Hvwd_0098,udg_BossUnits)
    call QuestSetDescriptionBJ(udg_MainQuest[$B],"Speak to Meliadoul to retry the Siege.") // $B = 11
    call Text_Say(null,"|cffffcc00Speak to Meliadoul to retry the Siege.\r\n\r\nYou may want to search for additional allies first!|r",true)
    call CinematicFadeBJ(bj_CINEFADETYPE_FADEIN,1.,"ReplaceableTextures\\CameraMasks\\White_mask.blp",0,0,0,0)
    call Cine_ExitAction()
    call PauseUnitBJ(true,gg_unit_U00E_0222)
endfunction

function Trig_KalmSiege3_Complete_BossDropEnabled takes nothing returns boolean
    return(udg_SpeedrunMode)
endfunction

function Trig_KalmSiege3_Complete_KillNorthMonster takes nothing returns nothing
    call KillUnit(GetEnumUnit())
endfunction

function Trig_KalmSiege3_Complete_KillSouthMonster takes nothing returns nothing
    call KillUnit(GetEnumUnit())
endfunction

function Trig_KalmSiege3_Complete_IsHeroKill takes nothing returns boolean
    return(IsUnitType(GetDyingUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_KalmSiege3_Complete_KilledByPlayer takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetKillingUnitBJ()),udg_PlayingPlayers))
endfunction

function Trig_KalmSiege3_Complete_CinematicsOn takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_KalmSiege3_Complete_CoinFlip takes nothing returns boolean
    // A random whole number from 1 through 2.
    return(GetRandomInt(1,2)<=1)
endfunction

function Trig_KalmSiege3_Complete_KillGuard takes nothing returns nothing
    call KillUnit(GetEnumUnit())
endfunction

function Trig_KalmSiege3_Complete_KillDefender takes nothing returns nothing
    call KillUnit(GetEnumUnit())
endfunction

function Trig_KalmSiege3_Complete_KillSouthGuard takes nothing returns nothing
    call KillUnit(GetEnumUnit())
endfunction

function Trig_KalmSiege3_Complete_RemoveSummon takes nothing returns nothing
    call RemoveUnit(GetEnumUnit())
endfunction

function Trig_KalmSiege3_Complete_ShowTownUnit takes nothing returns nothing
    call ShowUnitShow(GetEnumUnit())
endfunction

function Trig_KalmSiege3_Complete_CompanionsPresent takes nothing returns boolean
    return(IsUnitInGroup(gg_unit_Ocbh_0148,udg_RecruitedAllies))
endfunction

function Trig_KalmSiege3_Complete_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    if(Trig_KalmSiege3_Complete_BossDropEnabled())then
        set udg_BossUnit=GetTriggerUnit()
        call ConditionalTriggerExecute(gg_trg_Speedrun_Accolade)
    endif
    call SetUnitInvulnerable(udg_RangerHero,true)
    call SetUnitInvulnerable(udg_EngineerHero,true)
    call DisableTrigger(gg_trg_KalmSiege3_DemonSummon)
    call DisableTrigger(gg_trg_KalmSiege3_ChiefGuard)
    call DisableTrigger(gg_trg_KalmSiege3_Defeat)
    call DisableTrigger(gg_trg_KalmSiege3_Fail)
    call DisableTrigger(gg_trg_KalmSiege_AITick)
    call DisableTrigger(gg_trg_KalmSiege_LeaderRetreat)
    call ForGroupBJ(udg_SpecialUnits,function Trig_KalmSiege3_Complete_KillNorthMonster)
    call ForGroupBJ(udg_SummonedUnits,function Trig_KalmSiege3_Complete_KillSouthMonster)
    set udg_BossDefeated[4]=true
    call Music_ClearTrack($D) // $D = 13
    call PlayThematicMusicBJ("FF7-Victory Fanfare.mp3")
    if(Trig_KalmSiege3_Complete_IsHeroKill())then
        call DisplayTextToForce(udg_PlayingPlayers,(("|cffaa0000"+GetHeroProperName(GetDyingUnit()))+"|r was defeated !!!"))
    else
        call DisplayTextToForce(udg_PlayingPlayers,(("|cffaa0000"+GetUnitName(GetDyingUnit()))+"|r was defeated !!!"))
    endif
    call GroupRemoveUnitSimple(gg_unit_U00E_0222,udg_QuestUnits)
    call Cine_Enter()
    if(Trig_KalmSiege3_Complete_CinematicsOn())then
        call Cam_PanToUnit(gg_unit_U00E_0222,0)
        call Text_Say(gg_unit_U00E_0222,"You... pests... won't get away with this...",false)
        if(Trig_KalmSiege3_Complete_KilledByPlayer())then
            set udg_CinematicActor=Player_GetHero(GetOwningPlayer(GetKillingUnitBJ()))
        else
            set udg_CinematicActor=Player_GetHero(ForcePickRandomPlayer(udg_PlayingPlayers))
        endif
        call Text_Say(udg_CinematicActor,"He's down...",false)
        call Text_Say(udg_RangerHero,"We've... done it. We struck him down!",false)
        call Text_Say(udg_RangerHero,"We are in your eternal gratitude. If it weren't for your help, this town would be a pile of ashes by now.",false)
    endif
    call Reward_Give(8000,6000,udg_RangerHero)
    call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUT,1.,"ReplaceableTextures\\CameraMasks\\White_mask.blp",0,0,0,0)
    call Wait_Polled(1.25)
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateItemLoc('I0E2',udg_TempPoint) // 'I0E2': item "Curse: Thunder Wand"
    call CreateItemLoc('I01Z',udg_TempPoint) // 'I01Z': item "Crystal Shard"
    if(Trig_KalmSiege3_Complete_CoinFlip())then
        call CreateItemLoc('I05I',udg_TempPoint) // 'I05I': item "Spirit Potion"
    else
        call CreateItemLoc('I05H',udg_TempPoint) // 'I05H': item "Blood Ether"
    endif
    call RemoveLocation(udg_TempPoint)
    call ForGroupBJ(udg_AllyBrothersGroup,function Trig_KalmSiege3_Complete_KillGuard)
    call ForGroupBJ(udg_AllyRangerGroup,function Trig_KalmSiege3_Complete_KillDefender)
    call ForGroupBJ(udg_AllyEngineerGroup,function Trig_KalmSiege3_Complete_KillSouthGuard)
    call ForGroupBJ(udg_InactiveUnits,function Trig_KalmSiege3_Complete_RemoveSummon)
    call ForGroupBJ(udg_RecruitedAllies,function Trig_KalmSiege3_Complete_ShowTownUnit)
    call DestroyTrigger(gg_trg_KalmSiege3_Restart)
    call DestroyTrigger(gg_trg_KalmSiege3_Begin)
    call DestroyTrigger(gg_trg_KalmSiege3_Defeat)
    call DestroyTrigger(gg_trg_KalmSiege3_DemonArrive)
    call DestroyTrigger(gg_trg_KalmSiege3_TrackDeaths)
    call DestroyTrigger(gg_trg_KalmSiege3_DemonSummon)
    call DestroyTrigger(gg_trg_KalmSiege3_ChiefGuard)
    call DestroyTrigger(gg_trg_KalmSiege3_Fail)
    if(Trig_KalmSiege3_Complete_CompanionsPresent())then
        call SetHeroLevelBJ(gg_unit_Ocbh_0148,50,false)
        call SetHeroLevelBJ(gg_unit_Ocb2_0147,60,false)
        call ModifyHeroStat(bj_HEROSTAT_STR,gg_unit_Ocb2_0147,bj_MODIFYMETHOD_ADD,$FA) // $FA = 250
        call ModifyHeroStat(bj_HEROSTAT_STR,gg_unit_Ocbh_0148,bj_MODIFYMETHOD_ADD,$FA) // $FA = 250
        call ModifyHeroStat(bj_HEROSTAT_AGI,gg_unit_Ocb2_0147,bj_MODIFYMETHOD_ADD,$C8) // $C8 = 200
        call ModifyHeroStat(bj_HEROSTAT_AGI,gg_unit_Ocbh_0148,bj_MODIFYMETHOD_ADD,$C8) // $C8 = 200
        call ModifyHeroStat(bj_HEROSTAT_INT,gg_unit_Ocb2_0147,bj_MODIFYMETHOD_ADD,$C8) // $C8 = 200
        call ModifyHeroStat(bj_HEROSTAT_INT,gg_unit_Ocbh_0148,bj_MODIFYMETHOD_ADD,$C8) // $C8 = 200
    endif
    call Wait_Polled(.25)
    call Cine_ExitAction()
    call CinematicFadeBJ(bj_CINEFADETYPE_FADEIN,1.,"ReplaceableTextures\\CameraMasks\\White_mask.blp",0,0,0,0)
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_COMPLETED,"Quest Completed: |cffffcc00Kalm Siege III|r")
    call QuestSetCompletedBJ(udg_MainQuest[$B],true) // $B = 11
    set udg_QuestsCompleted=(udg_QuestsCompleted+1)
    call ConditionalTriggerExecute(gg_trg_Quest_WorldLiberation_Count)
    call StartTimerBJ(udg_SiegeTimer,false,120.)
    call EnableTrigger(gg_trg_Meliadoul_Hint_Timer)
    call SaveIntegerBJ(1,2,$B3,udg_GameStateHash) // $B3 = 179
    call EnableTrigger(gg_trg_HuntFestival_Announce)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_KalmSiege3_Fail_IsLeaderDead takes nothing returns boolean
    return(GetTriggerUnit()==udg_RangerHero)or(GetTriggerUnit()==udg_EngineerHero)
endfunction

function Trig_KalmSiege3_Fail_Conditions takes nothing returns boolean
    return(Trig_KalmSiege3_Fail_IsLeaderDead())
endfunction

function Trig_KalmSiege3_Fail_IsTownUnit takes nothing returns boolean
    return(GetOwningPlayer(GetFilterUnit())==Player(9))
endfunction

function Trig_KalmSiege3_Fail_MakeVulnerable takes nothing returns nothing
    call SetUnitInvulnerable(GetEnumUnit(),false)
endfunction

function Trig_KalmSiege3_Fail_IsMonsterOwned takes nothing returns boolean
    return(GetOwningPlayer(GetEnumUnit())==Player($B)) // $B = 11
endfunction

function Trig_KalmSiege3_Fail_PurgeOrShow takes nothing returns nothing
    if(Trig_KalmSiege3_Fail_IsMonsterOwned())then
        call ShowUnitShow(GetEnumUnit())
    else
        call KillUnit(GetEnumUnit())
        call RemoveUnit(GetEnumUnit())
    endif
endfunction

function Trig_KalmSiege3_Fail_IsDemonHidden takes nothing returns boolean
    return(IsUnitHiddenBJ(gg_unit_U00E_0222))
endfunction

function Trig_KalmSiege3_Fail_IsThirdSlot takes nothing returns boolean
    // The remainder after dividing (loop counter A) by (3).
    return(ModuloInteger(GetForLoopIndexA(),3)==0)
endfunction

function Trig_KalmSiege3_Fail_IsThirdSlotSouth takes nothing returns boolean
    // The remainder after dividing (loop counter A) by (3).
    return(ModuloInteger(GetForLoopIndexA(),3)==0)
endfunction

function Trig_KalmSiege3_Fail_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call Music_ClearTrack(40)
    call Music_ClearTrack($D) // $D = 13
    call Music_SetZoneTrack(9)
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_FAILED,"Quest Failed: |cffffcc00Kalm Siege III|r")
    call QuestSetFailedBJ(udg_MainQuest[$B],true) // $B = 11
    call DisableTrigger(gg_trg_KalmSiege3_DemonArrive)
    call DestroyTrigger(gg_trg_KalmSiege3_DemonArrive)
    call DisableTrigger(gg_trg_KalmSiege3_DemonSummon)
    call DestroyTrigger(gg_trg_KalmSiege3_DemonSummon)
    call DisableTrigger(gg_trg_KalmSiege3_Complete)
    call DestroyTrigger(gg_trg_KalmSiege3_Complete)
    call DestroyGroup(udg_TownTargetGroup)
    set udg_TempPoint=GetUnitLoc(gg_unit_Hpb1_0013)
    set udg_TownTargetGroup=Group_UnitsInRangeOfLoc(8192.,udg_TempPoint,Condition(function Trig_KalmSiege3_Fail_IsTownUnit))
    call RemoveLocation(udg_TempPoint)
    call ForGroupBJ(udg_TownTargetGroup,function Trig_KalmSiege3_Fail_MakeVulnerable)
    call EnableTrigger(gg_trg_KalmSiege_FailRespawn)
    call EnableTrigger(gg_trg_KalmSiege_DemonRecover)
    call ForGroupBJ(udg_RecruitedAllies,function Trig_KalmSiege3_Fail_PurgeOrShow)
    if(Trig_KalmSiege3_Fail_IsDemonHidden())then
        set udg_TempPoint=GetRectCenter(gg_rct_588)
        set udg_TempPoint2=GetUnitLoc(udg_RangerHero)
        call SetUnitPositionLocFacingLocBJ(gg_unit_U00E_0222,udg_TempPoint,udg_TempPoint2)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\ThunderClap\\ThunderClapCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Weapons\\Bolt\\BoltImpact.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportTarget.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        call RemoveLocation(udg_TempPoint2)
        call SetUnitPositionLoc(gg_unit_U00E_0222,udg_TempPoint)
        call RemoveLocation(udg_TempPoint)
        call ShowUnitShow(gg_unit_U00E_0222)
        call PauseUnitBJ(false,gg_unit_U00E_0222)
        call SetUnitInvulnerable(gg_unit_U00E_0222,false)
    endif
    call UnitAddAbilityBJ('A0ZR',gg_unit_U00E_0222) // 'A0ZR': ability "Immortal"
    call UnitAddAbilityBJ('A15D',gg_unit_U00E_0222) // 'A15D': ability "Thunder Boost"
    call UnitAddAbilityBJ('A0M9',gg_unit_U00E_0222) // 'A0M9': ability "Thunder Orb Amplification"
    call UnitAddAbilityBJ('A0LL',gg_unit_U00E_0222) // 'A0LL': ability "Thunder Spell Amplification"
    call SetUnitMoveSpeed(gg_unit_U00E_0222,500.)
    set udg_TempPoint=GetRectCenter(gg_rct_413)
    call IssuePointOrderLocBJ(gg_unit_U00E_0222,"attack",udg_TempPoint)
    call RemoveLocation(udg_TempPoint)
    set udg_TempPoint2=GetUnitLoc(gg_unit_U00E_0222)
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=6
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        // (loop counter A treated as a decimal-capable number) times (60).
        set udg_TempPoint=Loc_PolarOffset(udg_TempPoint2,256,(I2R(GetForLoopIndexA())*60.))
        call CreateNUnitsAtLocFacingLocBJ(1,'u00R',Player($B),udg_TempPoint,udg_TempPoint2) // 'u00R': unit "Shambling Corpse"; $B = 11
        call RemoveLocation(udg_TempPoint)
        call AddSpecialEffectTargetUnitBJ("origin",GetLastCreatedUnit(),"Abilities\\Spells\\Undead\\RaiseSkeletonWarrior\\RaiseSkeleton.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_EscortUnits)
        call SetUnitAcquireRangeBJ(GetLastCreatedUnit(),800.)
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    call RemoveLocation(udg_TempPoint2)
    set udg_RaidPowerLevel=70
    set udg_TempPoint2=GetRectCenter(gg_rct_588)
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=LoadIntegerBJ(4,2,udg_SpawnDataHashRef)
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        if(Trig_KalmSiege3_Fail_IsThirdSlot())then
            set udg_TempPoint=GetRectCenter(LoadRectHandleBJ(GetForLoopIndexA(),4,udg_SpawnRectHashRef))
            // The remainder after dividing (loop counter A) by (10).
            call CreateNUnitsAtLocFacingLocBJ(1,udg_SiegeNorthUnitType[ModuloInteger(GetForLoopIndexA(),$A)],Player($B),udg_TempPoint,udg_TempPoint2) // $A = 10; $B = 11
            call RemoveLocation(udg_TempPoint)
            call GroupAddUnitSimple(GetLastCreatedUnit(),udg_EscortUnits)
            // Calculation 1:
            // ((BlzGetUnitBaseDamage(GetLastCreatedUnit(), 0)) times (udg_RaidPowerLevel)) divided by (4).
            // Calculation 2:
            // (1) minus (1).
            call BlzSetUnitBaseDamage(GetLastCreatedUnit(),((BlzGetUnitBaseDamage(GetLastCreatedUnit(),0)*udg_RaidPowerLevel)/ 4),(1-1))
            // ((BlzGetUnitBaseDamage(GetLastCreatedUnit(), 1)) times (udg_RaidPowerLevel)) divided by (4).
            call BlzSetUnitBaseDamage(GetLastCreatedUnit(),((BlzGetUnitBaseDamage(GetLastCreatedUnit(),1)*udg_RaidPowerLevel)/ 4),1)
            // ((maximum health of GetLastCreatedUnit()) times (udg_RaidPowerLevel)) divided by (4).
            call BlzSetUnitMaxHP(GetLastCreatedUnit(),((BlzGetUnitMaxHP(GetLastCreatedUnit())*udg_RaidPowerLevel)/ 4))
            call SetUnitLifePercentBJ(GetLastCreatedUnit(),'d')
            call SetUnitAcquireRangeBJ(GetLastCreatedUnit(),800.)
            call IssuePointOrderLocBJ(GetLastCreatedUnit(),"attack",udg_TempPoint2)
        endif
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    call RemoveLocation(udg_TempPoint2)
    set udg_TempPoint2=GetRectCenter(gg_rct_635)
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=LoadIntegerBJ(1,2,udg_SpawnDataHashRef)
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        if(Trig_KalmSiege3_Fail_IsThirdSlotSouth())then
            set udg_TempPoint=GetRectCenter(LoadRectHandleBJ(GetForLoopIndexA(),1,udg_SpawnRectHashRef))
            // The remainder after dividing (loop counter A) by (8).
            call CreateNUnitsAtLocFacingLocBJ(1,udg_SiegeSouthUnitType[ModuloInteger(GetForLoopIndexA(),8)],Player($B),udg_TempPoint,udg_TempPoint2) // $B = 11
            call RemoveLocation(udg_TempPoint)
            call GroupAddUnitSimple(GetLastCreatedUnit(),udg_EscortUnits)
            // Calculation 1:
            // ((BlzGetUnitBaseDamage(GetLastCreatedUnit(), 0)) times (udg_RaidPowerLevel)) divided by (4).
            // Calculation 2:
            // (1) minus (1).
            call BlzSetUnitBaseDamage(GetLastCreatedUnit(),((BlzGetUnitBaseDamage(GetLastCreatedUnit(),0)*udg_RaidPowerLevel)/ 4),(1-1))
            // ((BlzGetUnitBaseDamage(GetLastCreatedUnit(), 1)) times (udg_RaidPowerLevel)) divided by (4).
            call BlzSetUnitBaseDamage(GetLastCreatedUnit(),((BlzGetUnitBaseDamage(GetLastCreatedUnit(),1)*udg_RaidPowerLevel)/ 4),1)
            // ((maximum health of GetLastCreatedUnit()) times (udg_RaidPowerLevel)) divided by (4).
            call BlzSetUnitMaxHP(GetLastCreatedUnit(),((BlzGetUnitMaxHP(GetLastCreatedUnit())*udg_RaidPowerLevel)/ 4))
            call SetUnitLifePercentBJ(GetLastCreatedUnit(),'d')
            call SetUnitAcquireRangeBJ(GetLastCreatedUnit(),800.)
            call IssuePointOrderLocBJ(GetLastCreatedUnit(),"attack",udg_TempPoint2)
        endif
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    call RemoveLocation(udg_TempPoint2)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_KalmSiege3 automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_KalmSiege3 (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_KalmSiege3 takes nothing returns nothing
endfunction

function Register_KalmSiege3_Call takes nothing returns nothing
    set gg_trg_KalmSiege3_Call=CreateTrigger()
    call DisableTrigger(gg_trg_KalmSiege3_Call)
    call TriggerRegisterTimerExpireEventBJ(gg_trg_KalmSiege3_Call,udg_SiegeTimer)
    call TriggerAddAction(gg_trg_KalmSiege3_Call,function Trig_KalmSiege3_Call_Actions)
endfunction

function Register_KalmSiege3_CidTalk takes nothing returns nothing
    set gg_trg_KalmSiege3_CidTalk=CreateTrigger()
    call DisableTrigger(gg_trg_KalmSiege3_CidTalk)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_KalmSiege3_CidTalk,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_KalmSiege3_CidTalk,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_KalmSiege3_CidTalk,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_KalmSiege3_CidTalk,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_KalmSiege3_CidTalk,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_KalmSiege3_CidTalk,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_KalmSiege3_CidTalk,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_KalmSiege3_CidTalk,Player(7),true)
    call TriggerAddCondition(gg_trg_KalmSiege3_CidTalk,Condition(function Trig_KalmSiege3_CidTalk_Conditions))
    call TriggerAddAction(gg_trg_KalmSiege3_CidTalk,function Trig_KalmSiege3_CidTalk_Actions)
endfunction

function Register_KalmSiege3_Start takes nothing returns nothing
    set gg_trg_KalmSiege3_Start=CreateTrigger()
    call DisableTrigger(gg_trg_KalmSiege3_Start)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_KalmSiege3_Start,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_KalmSiege3_Start,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_KalmSiege3_Start,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_KalmSiege3_Start,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_KalmSiege3_Start,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_KalmSiege3_Start,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_KalmSiege3_Start,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_KalmSiege3_Start,Player(7),true)
    call TriggerAddCondition(gg_trg_KalmSiege3_Start,Condition(function Trig_KalmSiege3_Start_Conditions))
    call TriggerAddAction(gg_trg_KalmSiege3_Start,function Trig_KalmSiege3_Start_Actions)
endfunction

function Register_KalmSiege3_Restart takes nothing returns nothing
    set gg_trg_KalmSiege3_Restart=CreateTrigger()
    call DisableTrigger(gg_trg_KalmSiege3_Restart)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_KalmSiege3_Restart,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_KalmSiege3_Restart,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_KalmSiege3_Restart,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_KalmSiege3_Restart,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_KalmSiege3_Restart,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_KalmSiege3_Restart,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_KalmSiege3_Restart,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_KalmSiege3_Restart,Player(7),true)
    call TriggerAddCondition(gg_trg_KalmSiege3_Restart,Condition(function Trig_KalmSiege3_Restart_Conditions))
    call TriggerAddAction(gg_trg_KalmSiege3_Restart,function Trig_KalmSiege3_Restart_Actions)
endfunction

function Register_KalmSiege3_Begin takes nothing returns nothing
    set gg_trg_KalmSiege3_Begin=CreateTrigger()
    call DisableTrigger(gg_trg_KalmSiege3_Begin)
    call TriggerRegisterTimerExpireEventBJ(gg_trg_KalmSiege3_Begin,udg_SiegeTimer)
    call TriggerAddAction(gg_trg_KalmSiege3_Begin,function Trig_KalmSiege3_Begin_Actions)
endfunction

function Register_KalmSiege3_DemonArrive takes nothing returns nothing
    set gg_trg_KalmSiege3_DemonArrive=CreateTrigger()
    call DisableTrigger(gg_trg_KalmSiege3_DemonArrive)
    call TriggerRegisterTimerExpireEventBJ(gg_trg_KalmSiege3_DemonArrive,udg_SiegeTimer)
    call TriggerAddAction(gg_trg_KalmSiege3_DemonArrive,function Trig_KalmSiege3_DemonArrive_Actions)
endfunction

function Register_KalmSiege3_DemonSummon takes nothing returns nothing
    set gg_trg_KalmSiege3_DemonSummon=CreateTrigger()
    call DisableTrigger(gg_trg_KalmSiege3_DemonSummon)
    call TriggerRegisterTimerEventPeriodic(gg_trg_KalmSiege3_DemonSummon,4.)
    call TriggerAddAction(gg_trg_KalmSiege3_DemonSummon,function Trig_KalmSiege3_DemonSummon_Actions)
endfunction

function Register_KalmSiege3_ChiefGuard takes nothing returns nothing
    set gg_trg_KalmSiege3_ChiefGuard=CreateTrigger()
    call DisableTrigger(gg_trg_KalmSiege3_ChiefGuard)
    call TriggerRegisterUnitInRangeSimple(gg_trg_KalmSiege3_ChiefGuard,900.,gg_unit_U00E_0222)
    call TriggerAddCondition(gg_trg_KalmSiege3_ChiefGuard,Condition(function Trig_KalmSiege3_ChiefGuard_Conditions))
    call TriggerAddAction(gg_trg_KalmSiege3_ChiefGuard,function Trig_KalmSiege3_ChiefGuard_Actions)
endfunction

function Register_KalmSiege3_TrackDeaths takes nothing returns nothing
    set gg_trg_KalmSiege3_TrackDeaths=CreateTrigger()
    call DisableTrigger(gg_trg_KalmSiege3_TrackDeaths)
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_KalmSiege3_TrackDeaths,Player($B),EVENT_PLAYER_UNIT_DEATH) // $B = 11
    call TriggerRegisterAnyUnitEventBJ(gg_trg_KalmSiege3_TrackDeaths,EVENT_PLAYER_UNIT_CHANGE_OWNER)
    call TriggerAddCondition(gg_trg_KalmSiege3_TrackDeaths,Condition(function Trig_KalmSiege3_TrackDeaths_Conditions))
    call TriggerAddAction(gg_trg_KalmSiege3_TrackDeaths,function Trig_KalmSiege3_TrackDeaths_Actions)
endfunction

function Register_KalmSiege3_Defeat takes nothing returns nothing
    set gg_trg_KalmSiege3_Defeat=CreateTrigger()
    call DisableTrigger(gg_trg_KalmSiege3_Defeat)
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_KalmSiege3_Defeat,Player(9),EVENT_PLAYER_UNIT_DEATH)
    call TriggerAddCondition(gg_trg_KalmSiege3_Defeat,Condition(function Trig_KalmSiege3_Defeat_Conditions))
    call TriggerAddAction(gg_trg_KalmSiege3_Defeat,function Trig_KalmSiege3_Defeat_Actions)
endfunction

function Register_KalmSiege3_Complete takes nothing returns nothing
    set gg_trg_KalmSiege3_Complete=CreateTrigger()
    call DisableTrigger(gg_trg_KalmSiege3_Complete)
    call TriggerRegisterUnitEvent(gg_trg_KalmSiege3_Complete,gg_unit_U00E_0222,EVENT_UNIT_DEATH)
    call TriggerAddAction(gg_trg_KalmSiege3_Complete,function Trig_KalmSiege3_Complete_Actions)
endfunction

function Register_KalmSiege3_Fail takes nothing returns nothing
    set gg_trg_KalmSiege3_Fail=CreateTrigger()
    call DisableTrigger(gg_trg_KalmSiege3_Fail)
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_KalmSiege3_Fail,Player(9),EVENT_PLAYER_UNIT_DEATH)
    call TriggerAddCondition(gg_trg_KalmSiege3_Fail,Condition(function Trig_KalmSiege3_Fail_Conditions))
    call TriggerAddAction(gg_trg_KalmSiege3_Fail,function Trig_KalmSiege3_Fail_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_KalmSiege3 takes nothing returns nothing
    call Register_KalmSiege3_Call() // starts off; enabled by KalmSiege2
    call Register_KalmSiege3_CidTalk() // starts off; enabled by KalmSiege3
    call Register_KalmSiege3_Start() // starts off; enabled by KalmSiege3
    call Register_KalmSiege3_Restart() // starts off; enabled by KalmSiege3; destroyed by KalmSiege3
    call Register_KalmSiege3_Begin() // starts off; enabled by KalmSiege3; destroyed by KalmSiege3
    call Register_KalmSiege3_DemonArrive() // starts off; enabled by KalmSiege3; disabled by KalmSiege3; destroyed by KalmSiege3
    call Register_KalmSiege3_DemonSummon() // starts off; enabled by KalmSiege3; disabled by KalmSiege3; destroyed by KalmSiege3
    call Register_KalmSiege3_ChiefGuard() // starts off; enabled by KalmSiege3; disabled by KalmSiege3; destroyed by KalmSiege3
    call Register_KalmSiege3_TrackDeaths() // starts off; enabled by KalmSiege3; disabled by KalmSiege3; destroyed by KalmSiege3
    call Register_KalmSiege3_Defeat() // starts off; enabled by KalmSiege3; disabled by KalmSiege3; destroyed by KalmSiege3
    call Register_KalmSiege3_Complete() // starts off; enabled by KalmSiege3; disabled by KalmSiege3; destroyed by KalmSiege3
    call Register_KalmSiege3_Fail() // starts off; enabled by KalmSiege3; disabled by KalmSiege3; destroyed by KalmSiege3
endfunction

endlibrary
