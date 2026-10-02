library TKalmSiege2 requires TCam, TCine, TGroup, TLoc, TMusic, TPlayerHero, TReward, TText, TUnit, TWait
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_KalmSiege2_Call=null
    trigger gg_trg_KalmSiege2_Start=null
    trigger gg_trg_KalmSiege2_Restart=null
    trigger gg_trg_KalmSiege2_Begin=null
    trigger gg_trg_KalmSiege2_SouthWave=null
    trigger gg_trg_KalmSiege2_DemonSpotted=null
    trigger gg_trg_KalmSiege2_DemonFlee=null
    trigger gg_trg_KalmSiege2_Defeat=null
    trigger gg_trg_KalmSiege2_TrackDeaths=null
    trigger gg_trg_KalmSiege2_Complete=null
    trigger gg_trg_KalmSiege2_Fail=null
    // Variables only this module uses.
    boolean udg_DemonRetreated=false
endglobals

function Trig_KalmSiege2_Call_Actions takes nothing returns nothing
    call DisplayTextToForce(GetPlayersAll(),"|cffff0000Meliadoul is calling for you !!!|r")
    call PlaySoundBJ(gg_snd_HornOfCenariusSound)
    set udg_TempPoint=GetUnitLoc(gg_unit_Hvwd_0098)
    call PingMinimapLocForForceEx(GetPlayersAll(),udg_TempPoint,5.,bj_MINIMAPPINGSTYLE_SIMPLE,'d',80.,.0)
    call RemoveLocation(udg_TempPoint)
    call GroupAddUnitSimple(gg_unit_Hvwd_0098,udg_BossUnits)
    set udg_SpecialEffect[30]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_Hvwd_0098,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call EnableTrigger(gg_trg_KalmSiege2_Start)
    call GroupAddUnitSimple(gg_unit_Hpb1_0013,udg_RecruitedAllies)
    call GroupAddUnitSimple(gg_unit_h00K_0137,udg_RecruitedAllies)
    call GroupAddUnitSimple(gg_unit_n00D_0091,udg_RecruitedAllies)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_KalmSiege2_Start_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_Hvwd_0098,true,true,true))
endfunction

function Trig_KalmSiege2_Start_CinematicsOn takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_KalmSiege2_Start_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[30])
    if(Trig_KalmSiege2_Start_CinematicsOn())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(gg_unit_Hvwd_0098,"I'm glad to see you. It seems the monsters are gathering for another assault.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Another one... this will be rough.",false)
        call Text_Say(gg_unit_Hvwd_0098,"Yes, it seems their numbers are similar to last time.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"When did the monsters turn so aggressive anyways?",false)
        call Text_Say(gg_unit_Hvwd_0098,"Oh right, we didn't get to talking about that last time did we.",false)
        call Text_Say(gg_unit_Hvwd_0098,"It was around the time you left for the Night Elf settlement I believe. The Hunt Club quickly realized that the monsters were starting to use a more calm and tactical approach in their behavior.",false)
        call Text_Say(gg_unit_Hvwd_0098,"Soon enough they discovered the monsters actually united under a leader; some sort of flying golden demon.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"A flying golden demon? That doesn't sound like Hashmalum...",false)
        call Text_Say(gg_unit_Hvwd_0098,"No, it must be a different demon. We are heavily on guard as we do not know what he's capable of, but it seems likely he will show up to tear down our defenses sooner or later.",false)
        call Text_Say(gg_unit_Hvwd_0098,"This is why we desperately need more allies to defend our gates. We're having a hard time holding out as it is.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Yeah... the previous siege was no joke.",false)
        call Text_Say(gg_unit_Hvwd_0098,"This is why we desperately need more allies to defend our gates. We're having a hard time holding out as it is.",false)
        call PlaySoundBJ(gg_snd_HornOfCenariusSound)
        call Wait_Polled(2)
        call Text_Say(gg_unit_Hvwd_0098,"Damn it! They're gathering again!",false)
        call Text_Say(gg_unit_Hvwd_0098,"Everyone, ready our defenses! They'll be here in about |cffffcc0030 seconds|r!",false)
        call Cine_ExitAction()
    endif
    set udg_SpecialEffect[30]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_Hvwd_0098,"Objects\\RandomObject\\RandomObject.mdl")
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_DISCOVERED,"New Quest Received: |cffffcc00Kalm Siege II|r")
    set udg_MainQuest[$A]=CreateQuestBJ(bj_QUESTTYPE_REQ_DISCOVERED,(udg_QuestNamePrefix+"Kalm Siege II"),"Kalm is under attack again! It seems there's a flying gold demon leading the monsters. Beware of possible surprises during the assault!","ReplaceableTextures\\CommandButtons\\BTNChaosWolfRider.blp") // $A = 10
    set udg_StoryProgress=(udg_StoryProgress+1)
    call ConditionalTriggerExecute(gg_trg_QuestCount_Milestones)
    call StartTimerBJ(udg_SiegeTimer,false,30)
    set udg_SiegeTimerWindow=CreateTimerDialogBJ(GetLastCreatedTimerBJ(),"Kalm Siege in ...")
    call EnableTrigger(gg_trg_KalmSiege2_Begin)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_KalmSiege2_Restart_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_Hvwd_0098,true,true,true))
endfunction

function Trig_KalmSiege2_Restart_CinematicsOn takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_KalmSiege2_Restart_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[30])
    if(Trig_KalmSiege2_Restart_CinematicsOn())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(gg_unit_Hvwd_0098,"Damn it! They're gathering again!",false)
        call Text_Say(gg_unit_Hvwd_0098,"Everyone, ready our defenses! They'll be here in about |cffffcc0010 seconds|r!",true)
        call Cine_ExitAction()
    endif
    set udg_SpecialEffect[30]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_Hvwd_0098,"Objects\\RandomObject\\RandomObject.mdl")
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_UPDATED,"Defend Kalm from the siege starting in 10 seconds!\r\n- Meliadoul must survive!")
    call QuestSetDescriptionBJ(udg_MainQuest[$A],"Defend Kalm from the siege starting in 10 seconds!\r\n\r\nMeliadoul must survive!") // $A = 10
    call StartTimerBJ(udg_SiegeTimer,false,10.)
    set udg_SiegeTimerWindow=CreateTimerDialogBJ(GetLastCreatedTimerBJ(),"Kalm Siege in ...")
    call EnableTrigger(gg_trg_KalmSiege2_Begin)
endfunction

function Trig_KalmSiege2_Begin_CinematicBusy takes nothing returns boolean
    return(udg_InCinematicMode)
endfunction

function Trig_KalmSiege2_Begin_CinematicsOn takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_KalmSiege2_Begin_RetryEnabled takes nothing returns boolean
    return(udg_HardcoreOff)
endfunction

function Trig_KalmSiege2_Begin_ScalingOff takes nothing returns boolean
    return(udg_EternityMode==false)
endfunction

function Trig_KalmSiege2_Begin_IsShieldSlot takes nothing returns boolean
    // Calculation 1:
    // The remainder after dividing (loop counter A) by (9).
    // Calculation 2:
    // The remainder after dividing (loop counter A) by (9).
    return(ModuloInteger(GetForLoopIndexA(),9)==0)or(ModuloInteger(GetForLoopIndexA(),9)==4)
endfunction

function Trig_KalmSiege2_Begin_ShieldSlotCheck takes nothing returns boolean
    return(Trig_KalmSiege2_Begin_IsShieldSlot())
endfunction

function Trig_KalmSiege2_Begin_IsGhoulMasterSlot takes nothing returns boolean
    // The remainder after dividing (loop counter A) by (19).
    return(udg_GhoulMasterDisabled==false)and(ModuloInteger(GetForLoopIndexA(),19)==1)
endfunction

function Trig_KalmSiege2_Begin_SendGuardPatrol takes nothing returns nothing
    set udg_TempPoint=GetUnitLoc(GetEnumUnit())
    set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,1024.,GetUnitFacing(GetEnumUnit()))
    call RemoveLocation(udg_TempPoint)
    call IssuePointOrderLocBJ(GetEnumUnit(),"patrol",udg_TempPoint2)
    call RemoveLocation(udg_TempPoint2)
    call PauseUnitBJ(false,GetEnumUnit())
endfunction

function Trig_KalmSiege2_Begin_SendGuardForward takes nothing returns nothing
    set udg_TempPoint=GetUnitLoc(GetEnumUnit())
    set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,384.,GetUnitFacing(GetEnumUnit()))
    call RemoveLocation(udg_TempPoint)
    call IssuePointOrderLocBJ(GetEnumUnit(),"move",udg_TempPoint2)
    call RemoveLocation(udg_TempPoint2)
    call PauseUnitBJ(false,GetEnumUnit())
endfunction

function Trig_KalmSiege2_Begin_Actions takes nothing returns nothing
    if(Trig_KalmSiege2_Begin_CinematicBusy())then
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
    if(Trig_KalmSiege2_Begin_CinematicsOn())then
        call Cam_PanToUnit(udg_RangerHero,1.)
        call Wait_Polled(1.)
        call Text_Say(udg_RangerHero,"For our families!",false)
    endif
    call Cine_ExitAction()
    call Music_SetTrack(39)
    set udg_DemonRetreated=false
    if(Trig_KalmSiege2_Begin_RetryEnabled())then
        call EnableTrigger(gg_trg_KalmSiege2_Defeat)
    else
        call EnableTrigger(gg_trg_KalmSiege2_Fail)
    endif
    call EnableTrigger(gg_trg_KalmSiege2_TrackDeaths)
    call EnableTrigger(gg_trg_KalmSiege2_SouthWave)
    call EnableTrigger(gg_trg_KalmSiege_AITick)
    call EnableTrigger(gg_trg_KalmSiege_LeaderRetreat)
    set udg_TempPoint2=GetRectCenter(gg_rct_584)
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=LoadIntegerBJ(4,2,udg_SpawnDataHashRef)
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        set udg_TempPoint=GetRectCenter(LoadRectHandleBJ(GetForLoopIndexA(),4,udg_SpawnRectHashRef))
        // The remainder after dividing (loop counter A) by (10).
        call CreateNUnitsAtLocFacingLocBJ(1,udg_SiegeNorthUnitType[ModuloInteger(GetForLoopIndexA(),$A)],Player($B),udg_TempPoint,udg_TempPoint2) // $A = 10; $B = 11
        call RemoveLocation(udg_TempPoint)
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_SpecialUnits)
        if(Trig_KalmSiege2_Begin_ScalingOff())then
            // Calculation 1:
            // (BlzGetUnitBaseDamage(GetLastCreatedUnit(), 0)) times (6).
            // Calculation 2:
            // (1) minus (1).
            call BlzSetUnitBaseDamage(GetLastCreatedUnit(),(BlzGetUnitBaseDamage(GetLastCreatedUnit(),0)*6),(1-1))
            // (BlzGetUnitBaseDamage(GetLastCreatedUnit(), 1)) times (6).
            call BlzSetUnitBaseDamage(GetLastCreatedUnit(),(BlzGetUnitBaseDamage(GetLastCreatedUnit(),1)*6),1)
            // (maximum health of GetLastCreatedUnit()) times (6).
            call BlzSetUnitMaxHP(GetLastCreatedUnit(),(BlzGetUnitMaxHP(GetLastCreatedUnit())*6))
            call SetUnitLifePercentBJ(GetLastCreatedUnit(),'d')
        else
            call Unit_ScaleToLevel60(bj_lastCreatedUnit)
        endif
        call SetUnitLifePercentBJ(GetLastCreatedUnit(),'d')
        call SetUnitAcquireRangeBJ(GetLastCreatedUnit(),600.)
        call IssuePointOrderLocBJ(GetLastCreatedUnit(),"attack",udg_TempPoint2)
        if(Trig_KalmSiege2_Begin_ShieldSlotCheck())then
            call UnitAddAbilityBJ('A0YK',GetLastCreatedUnit()) // 'A0YK': ability "Permanent Lightning Shield"
            call GroupAddUnitSimple(GetLastCreatedUnit(),udg_ShockAuraUnitGroup)
        endif
        if(Trig_KalmSiege2_Begin_IsGhoulMasterSlot())then
            call UnitAddAbilityBJ('A0RB',GetLastCreatedUnit()) // 'A0RB': ability "Ghoul Master"
            call UnitAddAbilityBJ('ACvp',GetLastCreatedUnit()) // 'ACvp': object name not found in map data
        endif
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    call RemoveLocation(udg_TempPoint2)
    call Wait_Polled(.2)
    call ForGroupBJ(udg_AllyBrothersGroup,function Trig_KalmSiege2_Begin_SendGuardPatrol)
    call Wait_Polled(.2)
    call ForGroupBJ(udg_AllyRangerGroup,function Trig_KalmSiege2_Begin_SendGuardForward)
endfunction

function Trig_KalmSiege2_SouthWave_CinematicBusy takes nothing returns boolean
    return(udg_InCinematicMode)
endfunction

function Trig_KalmSiege2_SouthWave_IsEvenSlot takes nothing returns boolean
    // The remainder after dividing (loop counter A) by (2).
    return(ModuloInteger(GetForLoopIndexA(),2)==0)
endfunction

function Trig_KalmSiege2_SouthWave_ScalingOff takes nothing returns boolean
    return(udg_EternityMode==false)
endfunction

function Trig_KalmSiege2_SouthWave_ReleaseSouthGuard takes nothing returns nothing
    call ShowUnitShow(GetEnumUnit())
    call PauseUnitBJ(false,GetEnumUnit())
    set udg_TempPoint=GetUnitLoc(GetEnumUnit())
    set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,384.,GetUnitFacing(GetEnumUnit()))
    call RemoveLocation(udg_TempPoint)
    call IssuePointOrderLocBJ(GetEnumUnit(),"attack",udg_TempPoint2)
    call RemoveLocation(udg_TempPoint2)
endfunction

function Trig_KalmSiege2_SouthWave_ShareLeaderVision takes nothing returns nothing
    call UnitShareVisionBJ(true,udg_EngineerHero,GetEnumPlayer())
endfunction

function Trig_KalmSiege2_SouthWave_Actions takes nothing returns nothing
    if(Trig_KalmSiege2_SouthWave_CinematicBusy())then
        call StartTimerBJ(udg_SiegeTimer,false,.49)
        return
    endif
    call DisableTrigger(GetTriggeringTrigger())
    call Music_SetTrack(40)
    set udg_TempPoint2=GetRectCenter(gg_rct_635)
    set udg_TempPoint=OffsetLocation(udg_TempPoint2,-800.,-800.)
    call CreateNUnitsAtLocFacingLocBJ(1,udg_SiegeSouthUnitType[5],Player($B),udg_TempPoint,udg_TempPoint2) // $B = 11
    call RemoveLocation(udg_TempPoint)
    call GroupAddUnitSimple(GetLastCreatedUnit(),udg_SummonedUnits)
    call SetUnitAcquireRangeBJ(GetLastCreatedUnit(),600.)
    call IssuePointOrderLocBJ(GetLastCreatedUnit(),"attack",udg_TempPoint2)
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=LoadIntegerBJ(1,2,udg_SpawnDataHashRef)
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        set udg_TempPoint=GetRectCenter(LoadRectHandleBJ(GetForLoopIndexA(),1,udg_SpawnRectHashRef))
        // The remainder after dividing (loop counter A) by (8).
        call CreateNUnitsAtLocFacingLocBJ(1,udg_SiegeSouthUnitType[ModuloInteger(GetForLoopIndexA(),8)],Player($B),udg_TempPoint,udg_TempPoint2) // $B = 11
        call RemoveLocation(udg_TempPoint)
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_SummonedUnits)
        if(Trig_KalmSiege2_SouthWave_ScalingOff())then
            if(Trig_KalmSiege2_SouthWave_IsEvenSlot())then
                // Calculation 1:
                // (BlzGetUnitBaseDamage(GetLastCreatedUnit(), 0)) times (12).
                // Calculation 2:
                // (1) minus (1).
                call BlzSetUnitBaseDamage(GetLastCreatedUnit(),(BlzGetUnitBaseDamage(GetLastCreatedUnit(),0)*$C),(1-1)) // $C = 12
                // (BlzGetUnitBaseDamage(GetLastCreatedUnit(), 1)) times (12).
                call BlzSetUnitBaseDamage(GetLastCreatedUnit(),(BlzGetUnitBaseDamage(GetLastCreatedUnit(),1)*$C),1) // $C = 12
                // (maximum health of GetLastCreatedUnit()) times (12).
                call BlzSetUnitMaxHP(GetLastCreatedUnit(),(BlzGetUnitMaxHP(GetLastCreatedUnit())*$C)) // $C = 12
            else
                // Calculation 1:
                // (BlzGetUnitBaseDamage(GetLastCreatedUnit(), 0)) divided by (2).
                // Calculation 2:
                // (1) minus (1).
                call BlzSetUnitBaseDamage(GetLastCreatedUnit(),(BlzGetUnitBaseDamage(GetLastCreatedUnit(),0)/ 2),(1-1))
                // (BlzGetUnitBaseDamage(GetLastCreatedUnit(), 1)) divided by (2).
                call BlzSetUnitBaseDamage(GetLastCreatedUnit(),(BlzGetUnitBaseDamage(GetLastCreatedUnit(),1)/ 2),1)
                // (maximum health of GetLastCreatedUnit()) divided by (2).
                call BlzSetUnitMaxHP(GetLastCreatedUnit(),(BlzGetUnitMaxHP(GetLastCreatedUnit())/ 2))
            endif
            call SetUnitLifePercentBJ(GetLastCreatedUnit(),'d')
        else
            call Unit_ScaleToLevel60(bj_lastCreatedUnit)
        endif
        call SetUnitAcquireRangeBJ(GetLastCreatedUnit(),600.)
        call IssuePointOrderLocBJ(GetLastCreatedUnit(),"attack",udg_TempPoint2)
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    call RemoveLocation(udg_TempPoint2)
    set udg_TempPoint2=GetRectCenter(gg_rct_584)
    set udg_TempPoint=GetRectCenter(gg_rct_298)
    call CreateNUnitsAtLocFacingLocBJ(1,'U00E',Player($B),udg_TempPoint,udg_TempPoint2) // 'U00E': unit "Zodiac Brave of Thunder"; $B = 11
    call RemoveLocation(udg_TempPoint)
    call GroupAddUnitSimple(GetLastCreatedUnit(),udg_SpecialUnits)
    call UnitAddAbilityBJ('A0ZR',GetLastCreatedUnit()) // 'A0ZR': ability "Immortal"
    call UnitAddAbilityBJ('A0YK',GetLastCreatedUnit()) // 'A0YK': ability "Permanent Lightning Shield"
    call GroupAddUnitSimple(GetLastCreatedUnit(),udg_ShockAuraUnitGroup)
    call UnitRemoveAbilityBJ('AInv',GetLastCreatedUnit()) // 'AInv': standard ability reference "Inventory"
    call UnitRemoveAbilityBJ('A00P',GetLastCreatedUnit()) // 'A00P': ability "Summon Shambling Corpses"
    call SetHeroLevelBJ(GetLastCreatedUnit(),50,false)
    call SetUnitAcquireRangeBJ(GetLastCreatedUnit(),600.)
    call TriggerRegisterUnitEvent(gg_trg_KalmSiege2_DemonFlee,GetLastCreatedUnit(),EVENT_UNIT_DAMAGED)
    call EnableTrigger(gg_trg_KalmSiege2_DemonFlee)
    call TriggerRegisterUnitInRangeSimple(gg_trg_KalmSiege2_DemonSpotted,900.,GetLastCreatedUnit())
    call EnableTrigger(gg_trg_KalmSiege2_DemonSpotted)
    call IssuePointOrderLocBJ(GetLastCreatedUnit(),"attack",udg_TempPoint2)
    call RemoveLocation(udg_TempPoint2)
    call Wait_Polled(.5)
    call ForGroupBJ(udg_AllyEngineerGroup,function Trig_KalmSiege2_SouthWave_ReleaseSouthGuard)
    call ForForce(udg_PlayingPlayers,function Trig_KalmSiege2_SouthWave_ShareLeaderVision)
    call Text_Say(udg_EngineerHero,"Kalm is being attacked from the south as well! We need support!",true)
endfunction

function Trig_KalmSiege2_DemonSpotted_IsDefender takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_ActivePlayers))or(IsUnitInGroup(GetTriggerUnit(),udg_AllyBrothersGroup))or(IsUnitInGroup(GetTriggerUnit(),udg_AllyRangerGroup))
endfunction

function Trig_KalmSiege2_DemonSpotted_Conditions takes nothing returns boolean
    return(udg_InCinematicMode==false)and(Trig_KalmSiege2_DemonSpotted_IsDefender())
endfunction

function Trig_KalmSiege2_DemonSpotted_TriggerNotPlayer takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers)==false)
endfunction

function Trig_KalmSiege2_DemonSpotted_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    if(Trig_KalmSiege2_DemonSpotted_TriggerNotPlayer())then
        call Text_Say(udg_RangerHero,"It's the demon!! We need help, now!",true)
    endif
endfunction

function Trig_KalmSiege2_DemonFlee_IsSeriousDamage takes nothing returns boolean
    // Result 1: current health divided by maximum health for the triggering unit, times 100 (or 0 if the unit is
    // missing or its maximum is 0).
    return((GetUnitLifePercent(GetTriggerUnit())<50.)or(IsUnitType(GetEventDamageSource(),UNIT_TYPE_HERO)))!=null
endfunction

function Trig_KalmSiege2_DemonFlee_Conditions takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetEventDamageSource()),udg_ActivePlayers))and(Trig_KalmSiege2_DemonFlee_IsSeriousDamage())
endfunction

function Trig_KalmSiege2_DemonFlee_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DisableTrigger(gg_trg_KalmSiege2_DemonSpotted)
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_SpecialUnits)
    call UnitRemoveAbilityBJ('A0SF',GetTriggerUnit()) // 'A0SF': ability "Command AI"
    call UnitRemoveAbilityBJ('A0YK',GetTriggerUnit()) // 'A0YK': ability "Permanent Lightning Shield"
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_ShockAuraUnitGroup)
    set udg_DemonRetreated=true
    set udg_TempPoint2=GetUnitLoc(GetTriggerUnit())
    // The remainder after dividing ((facing in degrees of the triggering unit) plus (90)) by (360).
    set udg_TempPoint=Loc_PolarOffset(udg_TempPoint2,256,ModuloReal((GetUnitFacing(GetTriggerUnit())+90.),360.))
    call CreateNUnitsAtLoc(1,'u00R',Player($B),udg_TempPoint,GetUnitFacing(GetTriggerUnit())) // 'u00R': unit "Shambling Corpse"; $B = 11
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
    // The remainder after dividing ((facing in degrees of the triggering unit) plus (270)) by (360).
    set udg_TempPoint=Loc_PolarOffset(udg_TempPoint2,256,ModuloReal((GetUnitFacing(GetTriggerUnit())+270.),360.))
    call CreateNUnitsAtLoc(1,'u00R',Player($B),udg_TempPoint,GetUnitFacing(GetTriggerUnit())) // 'u00R': unit "Shambling Corpse"; $B = 11
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
    call RemoveLocation(udg_TempPoint2)
    set udg_TempPoint2=GetUnitLoc(GetEventDamageSource())
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
    set udg_TempPoint=GetRectCenter(gg_rct_298)
    call IssuePointOrderLocBJ(GetTriggerUnit(),"move",udg_TempPoint)
    call RemoveLocation(udg_TempPoint)
    call SetUnitInvulnerable(GetTriggerUnit(),true)
    call SetUnitVertexColorBJ(GetTriggerUnit(),'d',80.,.0,50.)
    call Wait_Polled(5.)
    call UnitRemoveAbilityBJ('A0ZR',GetTriggerUnit()) // 'A0ZR': ability "Immortal"
    call KillUnit(GetTriggerUnit())
    call RemoveUnit(GetTriggerUnit())
endfunction

function Trig_KalmSiege2_Defeat_IsLeaderDead takes nothing returns boolean
    return(GetTriggerUnit()==udg_RangerHero)or(GetTriggerUnit()==udg_EngineerHero)
endfunction

function Trig_KalmSiege2_Defeat_Conditions takes nothing returns boolean
    return(Trig_KalmSiege2_Defeat_IsLeaderDead())
endfunction

function Trig_KalmSiege2_Defeat_CinematicBusy takes nothing returns boolean
    return(udg_InCinematicMode)
endfunction

function Trig_KalmSiege2_Defeat_StripMonsterBuffs takes nothing returns nothing
    call UnitAddAbilityBJ('A0QY',GetEnumUnit()) // 'A0QY': ability "Devalued"
    call UnitRemoveAbilityBJ('A0YK',GetEnumUnit()) // 'A0YK': ability "Permanent Lightning Shield"
    call GroupRemoveUnitSimple(GetEnumUnit(),udg_ShockAuraUnitGroup)
endfunction

function Trig_KalmSiege2_Defeat_KilledByPlayer takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetKillingUnitBJ()),udg_PlayingPlayers))
endfunction

function Trig_KalmSiege2_Defeat_CinematicsOn takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_KalmSiege2_Defeat_KillGuard takes nothing returns nothing
    call KillUnit(GetEnumUnit())
endfunction

function Trig_KalmSiege2_Defeat_KillDefender takes nothing returns nothing
    call KillUnit(GetEnumUnit())
endfunction

function Trig_KalmSiege2_Defeat_KillSouthGuard takes nothing returns nothing
    call KillUnit(GetEnumUnit())
endfunction

function Trig_KalmSiege2_Defeat_RemoveSummon takes nothing returns nothing
    call RemoveUnit(GetEnumUnit())
endfunction

function Trig_KalmSiege2_Defeat_PurgeNorthMonster takes nothing returns nothing
    call KillUnit(GetEnumUnit())
    call RemoveUnit(GetEnumUnit())
endfunction

function Trig_KalmSiege2_Defeat_PurgeSouthMonster takes nothing returns nothing
    call KillUnit(GetEnumUnit())
    call RemoveUnit(GetEnumUnit())
endfunction

function Trig_KalmSiege2_Defeat_ShowTownUnit takes nothing returns nothing
    call ShowUnitShow(GetEnumUnit())
endfunction

function Trig_KalmSiege2_Defeat_Actions takes nothing returns nothing
    if(Trig_KalmSiege2_Defeat_CinematicBusy())then
        set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
        call ReviveHeroLoc(GetTriggerUnit(),udg_TempPoint,false)
        call RemoveLocation(udg_TempPoint)
        call SetUnitLifeBJ(GetTriggerUnit(),1.)
        return
    endif
    call DisableTrigger(gg_trg_KalmSiege2_TrackDeaths)
    call DisableTrigger(gg_trg_KalmSiege2_SouthWave)
    call DisableTrigger(gg_trg_KalmSiege2_DemonFlee)
    call DisableTrigger(gg_trg_KalmSiege2_DemonSpotted)
    call DisableTrigger(gg_trg_KalmSiege_AITick)
    call DisableTrigger(gg_trg_KalmSiege_LeaderRetreat)
    call ForGroupBJ(udg_SpecialUnits,function Trig_KalmSiege2_Defeat_StripMonsterBuffs)
    call Cine_Enter()
    call Cam_PanToUnit(GetTriggerUnit(),0)
    call DestroyEffectBJ(udg_SpecialEffect[30])
    call Wait_Polled(1.)
    call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUT,1.,"ReplaceableTextures\\CameraMasks\\White_mask.blp",0,0,0,0)
    call Wait_Polled(1.5)
    call Music_ClearTrack(39)
    call Music_ClearTrack(40)
    call PlayThematicMusicBJ("war3mapImported\\FF7GameOver.mp3")
    if(Trig_KalmSiege2_Defeat_CinematicsOn())then
        if(Trig_KalmSiege2_Defeat_KilledByPlayer())then
            call Text_Say(null,"After being betrayed by the adventurers they trusted, Kalm was quickly overrun by monsters...",true)
        else
            call Text_Say(null,"With the fall of their defense line, Kalm was quickly overrun by monsters...",true)
        endif
    endif
    call ForGroupBJ(udg_AllyBrothersGroup,function Trig_KalmSiege2_Defeat_KillGuard)
    call ForGroupBJ(udg_AllyRangerGroup,function Trig_KalmSiege2_Defeat_KillDefender)
    call ForGroupBJ(udg_AllyEngineerGroup,function Trig_KalmSiege2_Defeat_KillSouthGuard)
    call ForGroupBJ(udg_InactiveUnits,function Trig_KalmSiege2_Defeat_RemoveSummon)
    call ForGroupBJ(udg_SpecialUnits,function Trig_KalmSiege2_Defeat_PurgeNorthMonster)
    call ForGroupBJ(udg_SummonedUnits,function Trig_KalmSiege2_Defeat_PurgeSouthMonster)
    call ForGroupBJ(udg_RecruitedAllies,function Trig_KalmSiege2_Defeat_ShowTownUnit)
    set udg_SpecialEffect[30]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_Hvwd_0098,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call EnableTrigger(gg_trg_KalmSiege2_Restart)
    call GroupAddUnitSimple(gg_unit_Hvwd_0098,udg_BossUnits)
    call QuestSetDescriptionBJ(udg_MainQuest[$A],"Speak to Meliadoul to retry the Siege.") // $A = 10
    call Text_Say(null,"|cffffcc00Speak to Meliadoul to retry the Siege.\r\n\r\nYou may want to search for additional allies first!|r",true)
    call CinematicFadeBJ(bj_CINEFADETYPE_FADEIN,1.,"ReplaceableTextures\\CameraMasks\\White_mask.blp",0,0,0,0)
    call Cine_ExitAction()
endfunction

function Trig_KalmSiege2_TrackDeaths_IsSiegeMonster takes nothing returns boolean
    return(IsUnitInGroup(GetTriggerUnit(),udg_SpecialUnits))or(IsUnitInGroup(GetTriggerUnit(),udg_SummonedUnits))
endfunction

function Trig_KalmSiege2_TrackDeaths_Conditions takes nothing returns boolean
    return(Trig_KalmSiege2_TrackDeaths_IsSiegeMonster())
endfunction

function Trig_KalmSiege2_TrackDeaths_NorthWaveAtFifty takes nothing returns boolean
    return(IsUnitInGroup(GetTriggerUnit(),udg_SpecialUnits))and(CountUnitsInGroup(udg_SpecialUnits)==50)
endfunction

function Trig_KalmSiege2_TrackDeaths_IsTempSpawn takes nothing returns boolean
    return(IsUnitInGroup(GetTriggerUnit(),udg_SiegeSummonGroup))
endfunction

function Trig_KalmSiege2_TrackDeaths_SiegeCleared takes nothing returns boolean
    return(udg_DemonRetreated)and(IsUnitGroupEmptyBJ(udg_SpecialUnits))and(IsUnitGroupEmptyBJ(udg_SummonedUnits))and(IsUnitGroupEmptyBJ(udg_EscortUnits))
endfunction

function Trig_KalmSiege2_TrackDeaths_Actions takes nothing returns nothing
    if(Trig_KalmSiege2_TrackDeaths_NorthWaveAtFifty())then
        call StartTimerBJ(udg_SiegeTimer,false,1.)
    endif
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_SpecialUnits)
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_SummonedUnits)
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_ShockAuraUnitGroup)
    if(Trig_KalmSiege2_TrackDeaths_IsTempSpawn())then
        call GroupRemoveUnitSimple(GetTriggerUnit(),udg_SiegeSummonGroup)
        set udg_TempPoint3=GetUnitLoc(GetTriggerUnit())
        call AddSpecialEffectLocBJ(udg_TempPoint3,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportTarget.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint3)
        call RemoveUnit(GetTriggerUnit())
    endif
    if(Trig_KalmSiege2_TrackDeaths_SiegeCleared())then
        call DisableTrigger(GetTriggeringTrigger())
        call SetUnitInvulnerable(udg_RangerHero,true)
        call SetUnitInvulnerable(udg_EngineerHero,true)
        call StartTimerBJ(udg_SiegeTimer,false,5.)
        call DisableTrigger(gg_trg_KalmSiege2_Defeat)
        call DisableTrigger(gg_trg_KalmSiege2_SouthWave)
        call DisableTrigger(gg_trg_KalmSiege2_Fail)
        call DisableTrigger(gg_trg_KalmSiege_AITick)
        call DisableTrigger(gg_trg_KalmSiege_LeaderRetreat)
        call EnableTrigger(gg_trg_KalmSiege2_Complete)
        call DestroyTrigger(GetTriggeringTrigger())
    endif
endfunction

function Trig_KalmSiege2_Complete_CinematicBusy takes nothing returns boolean
    return(udg_InCinematicMode)
endfunction

function Trig_KalmSiege2_Complete_CinematicsOn takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_KalmSiege2_Complete_KillGuard takes nothing returns nothing
    call KillUnit(GetEnumUnit())
endfunction

function Trig_KalmSiege2_Complete_KillDefender takes nothing returns nothing
    call KillUnit(GetEnumUnit())
endfunction

function Trig_KalmSiege2_Complete_KillSouthGuard takes nothing returns nothing
    call KillUnit(GetEnumUnit())
endfunction

function Trig_KalmSiege2_Complete_RemoveSummon takes nothing returns nothing
    call RemoveUnit(GetEnumUnit())
endfunction

function Trig_KalmSiege2_Complete_RemoveNorthMonster takes nothing returns nothing
    call RemoveUnit(GetEnumUnit())
endfunction

function Trig_KalmSiege2_Complete_RemoveSouthMonster takes nothing returns nothing
    call RemoveUnit(GetEnumUnit())
endfunction

function Trig_KalmSiege2_Complete_ShowTownUnit takes nothing returns nothing
    call ShowUnitShow(GetEnumUnit())
endfunction

function Trig_KalmSiege2_Complete_CompanionsPresent takes nothing returns boolean
    return(IsUnitInGroup(gg_unit_Ocbh_0148,udg_RecruitedAllies))
endfunction

function Trig_KalmSiege2_Complete_Actions takes nothing returns nothing
    if(Trig_KalmSiege2_Complete_CinematicBusy())then
        call StartTimerBJ(udg_SiegeTimer,false,1.)
        return
    endif
    call Cine_Enter()
    call DestroyEffectBJ(udg_SpecialEffect[30])
    if(Trig_KalmSiege2_Complete_CinematicsOn())then
        call Cam_PanToUnit(udg_RangerHero,0)
        call Wait_Polled(1.)
        call Text_Say(udg_RangerHero,"Looks like we pulled through somehow...",false)
        call Text_Say(udg_RangerHero,"We are seriously in your debt. Kalm would not be still standing without you.",false)
        call Reward_Give(7000,5000,udg_RangerHero)
        call Text_Say(udg_RangerHero,"The demon got away... next time we need to take him down. We won't hold out against these sieges much longer otherwise.",false)
        call Text_Say(udg_RangerHero,"Let's gear up for what'll hopefully be the final battle.",false)
    else
        call Reward_Give(7000,5000,udg_RangerHero)
    endif
    call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUT,1.,"ReplaceableTextures\\CameraMasks\\White_mask.blp",0,0,0,0)
    call Wait_Polled(1.25)
    call ForGroupBJ(udg_AllyBrothersGroup,function Trig_KalmSiege2_Complete_KillGuard)
    call ForGroupBJ(udg_AllyRangerGroup,function Trig_KalmSiege2_Complete_KillDefender)
    call ForGroupBJ(udg_AllyEngineerGroup,function Trig_KalmSiege2_Complete_KillSouthGuard)
    call ForGroupBJ(udg_InactiveUnits,function Trig_KalmSiege2_Complete_RemoveSummon)
    call ForGroupBJ(udg_SpecialUnits,function Trig_KalmSiege2_Complete_RemoveNorthMonster)
    call ForGroupBJ(udg_SummonedUnits,function Trig_KalmSiege2_Complete_RemoveSouthMonster)
    call ForGroupBJ(udg_RecruitedAllies,function Trig_KalmSiege2_Complete_ShowTownUnit)
    call DestroyTrigger(gg_trg_KalmSiege2_Restart)
    call DestroyTrigger(gg_trg_KalmSiege2_Begin)
    call DestroyTrigger(gg_trg_KalmSiege2_Defeat)
    call DestroyTrigger(gg_trg_KalmSiege2_SouthWave)
    call DestroyTrigger(gg_trg_KalmSiege2_DemonFlee)
    call DestroyTrigger(gg_trg_KalmSiege2_DemonSpotted)
    call DestroyTrigger(gg_trg_KalmSiege2_Fail)
    if(Trig_KalmSiege2_Complete_CompanionsPresent())then
        call SetHeroLevelBJ(gg_unit_Ocbh_0148,45,false)
        call SetHeroLevelBJ(gg_unit_Ocb2_0147,50,false)
    endif
    call Wait_Polled(.25)
    call Cine_ExitAction()
    call Music_ClearTrack(40)
    call CinematicFadeBJ(bj_CINEFADETYPE_FADEIN,1.,"ReplaceableTextures\\CameraMasks\\White_mask.blp",0,0,0,0)
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_COMPLETED,"Quest Completed: |cffffcc00Kalm Siege II|r")
    call QuestSetCompletedBJ(udg_MainQuest[$A],true) // $A = 10
    set udg_QuestsCompleted=(udg_QuestsCompleted+1)
    set udg_StoryProgress=(udg_StoryProgress+1)
    call ConditionalTriggerExecute(gg_trg_QuestCount_Milestones)
    call SaveIntegerBJ(1,2,'}',udg_GameStateHash)
    call StartTimerBJ(udg_SiegeTimer,false,300.)
    call EnableTrigger(gg_trg_KalmSiege3_Call)
endfunction

function Trig_KalmSiege2_Fail_IsLeaderDead takes nothing returns boolean
    return(GetTriggerUnit()==udg_RangerHero)or(GetTriggerUnit()==udg_EngineerHero)
endfunction

function Trig_KalmSiege2_Fail_Conditions takes nothing returns boolean
    return(Trig_KalmSiege2_Fail_IsLeaderDead())
endfunction

function Trig_KalmSiege2_Fail_IsTownUnit takes nothing returns boolean
    return(GetOwningPlayer(GetFilterUnit())==Player(9))
endfunction

function Trig_KalmSiege2_Fail_MakeVulnerable takes nothing returns nothing
    call SetUnitInvulnerable(GetEnumUnit(),false)
endfunction

function Trig_KalmSiege2_Fail_IsMonsterOwned takes nothing returns boolean
    return(GetOwningPlayer(GetEnumUnit())==Player($B)) // $B = 11
endfunction

function Trig_KalmSiege2_Fail_PurgeOrShow takes nothing returns nothing
    if(Trig_KalmSiege2_Fail_IsMonsterOwned())then
        call ShowUnitShow(GetEnumUnit())
    else
        call KillUnit(GetEnumUnit())
        call RemoveUnit(GetEnumUnit())
    endif
endfunction

function Trig_KalmSiege2_Fail_IsDemonUnit takes nothing returns boolean
    return(GetUnitTypeId(GetEnumUnit())=='U00E') // 'U00E': unit "Zodiac Brave of Thunder"
endfunction

function Trig_KalmSiege2_Fail_RemoveDemonCopy takes nothing returns nothing
    if(Trig_KalmSiege2_Fail_IsDemonUnit())then
        call RemoveLocation(udg_TempPoint)
        call KillUnit(GetEnumUnit())
        set udg_TempPoint=GetUnitLoc(GetEnumUnit())
        call RemoveUnit(GetEnumUnit())
    endif
endfunction

function Trig_KalmSiege2_Fail_IsThirdSlot takes nothing returns boolean
    // The remainder after dividing (loop counter A) by (3).
    return(ModuloInteger(GetForLoopIndexA(),3)==0)
endfunction

function Trig_KalmSiege2_Fail_IsThirdSlotSouth takes nothing returns boolean
    // The remainder after dividing (loop counter A) by (3).
    return(ModuloInteger(GetForLoopIndexA(),3)==0)
endfunction

function Trig_KalmSiege2_Fail_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call Music_ClearTrack(39)
    call Music_ClearTrack(40)
    call Music_SetZoneTrack(9)
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_FAILED,"Quest Failed: |cffffcc00Kalm Siege II|r")
    call QuestSetFailedBJ(udg_MainQuest[$A],true) // $A = 10
    call DisableTrigger(gg_trg_KalmSiege2_SouthWave)
    call DestroyTrigger(gg_trg_KalmSiege2_SouthWave)
    call DestroyGroup(udg_TownTargetGroup)
    set udg_TempPoint=GetUnitLoc(gg_unit_Hpb1_0013)
    set udg_TownTargetGroup=Group_UnitsInRangeOfLoc(8192.,udg_TempPoint,Condition(function Trig_KalmSiege2_Fail_IsTownUnit))
    call RemoveLocation(udg_TempPoint)
    call ForGroupBJ(udg_TownTargetGroup,function Trig_KalmSiege2_Fail_MakeVulnerable)
    call EnableTrigger(gg_trg_KalmSiege_FailRespawn)
    call EnableTrigger(gg_trg_KalmSiege_DemonRecover)
    call ForGroupBJ(udg_RecruitedAllies,function Trig_KalmSiege2_Fail_PurgeOrShow)
    set udg_TempPoint=GetRectCenter(gg_rct_298)
    call ForGroupBJ(udg_SpecialUnits,function Trig_KalmSiege2_Fail_RemoveDemonCopy)
    call SetUnitPositionLoc(gg_unit_U00E_0222,udg_TempPoint)
    call RemoveLocation(udg_TempPoint)
    set udg_TempPoint=GetRectCenter(gg_rct_413)
    call IssuePointOrderLocBJ(gg_unit_U00E_0222,"attack",udg_TempPoint)
    call RemoveLocation(udg_TempPoint)
    call ShowUnitShow(gg_unit_U00E_0222)
    call PauseUnitBJ(false,gg_unit_U00E_0222)
    call SetUnitInvulnerable(gg_unit_U00E_0222,false)
    call UnitAddAbilityBJ('A0ZR',gg_unit_U00E_0222) // 'A0ZR': ability "Immortal"
    call UnitAddAbilityBJ('A15D',gg_unit_U00E_0222) // 'A15D': ability "Thunder Boost"
    call UnitAddAbilityBJ('A0M9',gg_unit_U00E_0222) // 'A0M9': ability "Thunder Orb Amplification"
    call UnitAddAbilityBJ('A0LL',gg_unit_U00E_0222) // 'A0LL': ability "Thunder Spell Amplification"
    call SetUnitMoveSpeed(gg_unit_U00E_0222,500.)
    set udg_RaidPowerLevel=50
    set udg_TempPoint2=GetRectCenter(gg_rct_588)
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=LoadIntegerBJ(4,2,udg_SpawnDataHashRef)
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        if(Trig_KalmSiege2_Fail_IsThirdSlot())then
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
        if(Trig_KalmSiege2_Fail_IsThirdSlotSouth())then
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

// World Editor calls InitTrig_KalmSiege2 automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_KalmSiege2 (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_KalmSiege2 takes nothing returns nothing
endfunction

function Register_KalmSiege2_Call takes nothing returns nothing
    set gg_trg_KalmSiege2_Call=CreateTrigger()
    call DisableTrigger(gg_trg_KalmSiege2_Call)
    call TriggerRegisterTimerExpireEventBJ(gg_trg_KalmSiege2_Call,udg_SiegeTimer)
    call TriggerAddAction(gg_trg_KalmSiege2_Call,function Trig_KalmSiege2_Call_Actions)
endfunction

function Register_KalmSiege2_Start takes nothing returns nothing
    set gg_trg_KalmSiege2_Start=CreateTrigger()
    call DisableTrigger(gg_trg_KalmSiege2_Start)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_KalmSiege2_Start,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_KalmSiege2_Start,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_KalmSiege2_Start,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_KalmSiege2_Start,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_KalmSiege2_Start,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_KalmSiege2_Start,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_KalmSiege2_Start,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_KalmSiege2_Start,Player(7),true)
    call TriggerAddCondition(gg_trg_KalmSiege2_Start,Condition(function Trig_KalmSiege2_Start_Conditions))
    call TriggerAddAction(gg_trg_KalmSiege2_Start,function Trig_KalmSiege2_Start_Actions)
endfunction

function Register_KalmSiege2_Restart takes nothing returns nothing
    set gg_trg_KalmSiege2_Restart=CreateTrigger()
    call DisableTrigger(gg_trg_KalmSiege2_Restart)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_KalmSiege2_Restart,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_KalmSiege2_Restart,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_KalmSiege2_Restart,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_KalmSiege2_Restart,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_KalmSiege2_Restart,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_KalmSiege2_Restart,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_KalmSiege2_Restart,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_KalmSiege2_Restart,Player(7),true)
    call TriggerAddCondition(gg_trg_KalmSiege2_Restart,Condition(function Trig_KalmSiege2_Restart_Conditions))
    call TriggerAddAction(gg_trg_KalmSiege2_Restart,function Trig_KalmSiege2_Restart_Actions)
endfunction

function Register_KalmSiege2_Begin takes nothing returns nothing
    set gg_trg_KalmSiege2_Begin=CreateTrigger()
    call DisableTrigger(gg_trg_KalmSiege2_Begin)
    call TriggerRegisterTimerExpireEventBJ(gg_trg_KalmSiege2_Begin,udg_SiegeTimer)
    call TriggerAddAction(gg_trg_KalmSiege2_Begin,function Trig_KalmSiege2_Begin_Actions)
endfunction

function Register_KalmSiege2_SouthWave takes nothing returns nothing
    set gg_trg_KalmSiege2_SouthWave=CreateTrigger()
    call DisableTrigger(gg_trg_KalmSiege2_SouthWave)
    call TriggerRegisterTimerExpireEventBJ(gg_trg_KalmSiege2_SouthWave,udg_SiegeTimer)
    call TriggerAddAction(gg_trg_KalmSiege2_SouthWave,function Trig_KalmSiege2_SouthWave_Actions)
endfunction

function Register_KalmSiege2_DemonSpotted takes nothing returns nothing
    set gg_trg_KalmSiege2_DemonSpotted=CreateTrigger()
    call DisableTrigger(gg_trg_KalmSiege2_DemonSpotted)
    call TriggerAddCondition(gg_trg_KalmSiege2_DemonSpotted,Condition(function Trig_KalmSiege2_DemonSpotted_Conditions))
    call TriggerAddAction(gg_trg_KalmSiege2_DemonSpotted,function Trig_KalmSiege2_DemonSpotted_Actions)
endfunction

function Register_KalmSiege2_DemonFlee takes nothing returns nothing
    set gg_trg_KalmSiege2_DemonFlee=CreateTrigger()
    call DisableTrigger(gg_trg_KalmSiege2_DemonFlee)
    call TriggerAddCondition(gg_trg_KalmSiege2_DemonFlee,Condition(function Trig_KalmSiege2_DemonFlee_Conditions))
    call TriggerAddAction(gg_trg_KalmSiege2_DemonFlee,function Trig_KalmSiege2_DemonFlee_Actions)
endfunction

function Register_KalmSiege2_Defeat takes nothing returns nothing
    set gg_trg_KalmSiege2_Defeat=CreateTrigger()
    call DisableTrigger(gg_trg_KalmSiege2_Defeat)
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_KalmSiege2_Defeat,Player(9),EVENT_PLAYER_UNIT_DEATH)
    call TriggerAddCondition(gg_trg_KalmSiege2_Defeat,Condition(function Trig_KalmSiege2_Defeat_Conditions))
    call TriggerAddAction(gg_trg_KalmSiege2_Defeat,function Trig_KalmSiege2_Defeat_Actions)
endfunction

function Register_KalmSiege2_TrackDeaths takes nothing returns nothing
    set gg_trg_KalmSiege2_TrackDeaths=CreateTrigger()
    call DisableTrigger(gg_trg_KalmSiege2_TrackDeaths)
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_KalmSiege2_TrackDeaths,Player($B),EVENT_PLAYER_UNIT_DEATH) // $B = 11
    call TriggerRegisterAnyUnitEventBJ(gg_trg_KalmSiege2_TrackDeaths,EVENT_PLAYER_UNIT_CHANGE_OWNER)
    call TriggerAddCondition(gg_trg_KalmSiege2_TrackDeaths,Condition(function Trig_KalmSiege2_TrackDeaths_Conditions))
    call TriggerAddAction(gg_trg_KalmSiege2_TrackDeaths,function Trig_KalmSiege2_TrackDeaths_Actions)
endfunction

function Register_KalmSiege2_Complete takes nothing returns nothing
    set gg_trg_KalmSiege2_Complete=CreateTrigger()
    call DisableTrigger(gg_trg_KalmSiege2_Complete)
    call TriggerRegisterTimerExpireEventBJ(gg_trg_KalmSiege2_Complete,udg_SiegeTimer)
    call TriggerAddAction(gg_trg_KalmSiege2_Complete,function Trig_KalmSiege2_Complete_Actions)
endfunction

function Register_KalmSiege2_Fail takes nothing returns nothing
    set gg_trg_KalmSiege2_Fail=CreateTrigger()
    call DisableTrigger(gg_trg_KalmSiege2_Fail)
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_KalmSiege2_Fail,Player(9),EVENT_PLAYER_UNIT_DEATH)
    call TriggerAddCondition(gg_trg_KalmSiege2_Fail,Condition(function Trig_KalmSiege2_Fail_Conditions))
    call TriggerAddAction(gg_trg_KalmSiege2_Fail,function Trig_KalmSiege2_Fail_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_KalmSiege2 takes nothing returns nothing
    call Register_KalmSiege2_Call() // starts off; enabled by KalmSiege1
    call Register_KalmSiege2_Start() // starts off; enabled by KalmSiege2
    call Register_KalmSiege2_Restart() // starts off; enabled by KalmSiege2; destroyed by KalmSiege2
    call Register_KalmSiege2_Begin() // starts off; enabled by KalmSiege2; destroyed by KalmSiege2
    call Register_KalmSiege2_SouthWave() // starts off; enabled by KalmSiege2; disabled by KalmSiege2; destroyed by KalmSiege2
    call Register_KalmSiege2_DemonSpotted() // starts off; enabled by KalmSiege2; disabled by KalmSiege2; destroyed by KalmSiege2
    call Register_KalmSiege2_DemonFlee() // starts off; enabled by KalmSiege2; disabled by KalmSiege2; destroyed by KalmSiege2
    call Register_KalmSiege2_Defeat() // starts off; enabled by KalmSiege2; disabled by KalmSiege2; destroyed by KalmSiege2
    call Register_KalmSiege2_TrackDeaths() // starts off; enabled by KalmSiege2; disabled by KalmSiege2
    call Register_KalmSiege2_Complete() // starts off; enabled by KalmSiege2
    call Register_KalmSiege2_Fail() // starts off; enabled by KalmSiege2; disabled by KalmSiege2; destroyed by KalmSiege2
endfunction

endlibrary
