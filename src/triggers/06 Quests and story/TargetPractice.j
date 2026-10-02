library TTargetPractice requires TCam, TCine, TForce, TGroup, TPlayerPart01, TReward, TText
function Trig_TargetPractice_Init_Actions takes nothing returns nothing
    set udg_SpecialEffect[81]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_e017_0018,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call EnableTrigger(gg_trg_Quest_TargetPractice_Start)
    set udg_TargetRecordHolder=Player(9)
    set udg_TargetRecordName[1]="Artemis"
    set udg_TargetRecordTime[1]=85.
    set udg_TargetRecordName[2]="Sigroon"
    set udg_TargetRecordTime[2]=90.
    set udg_TargetRecordName[3]="Aisha"
    set udg_TargetRecordTime[3]=95.
    set udg_TargetRecordName[4]="Olga"
    set udg_TargetRecordTime[4]=105.
    set udg_TargetRecordName[5]="Sarai"
    set udg_TargetRecordTime[5]=120.
    set udg_TargetPracticeAreaId=6
    // A random whole number from 1 through 3.
    set udg_TempInteger=GetRandomInt(1,3)
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=LoadIntegerBJ(6,2,udg_SpawnDataHashRef)
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        set bj_forLoopBIndex=1
        set bj_forLoopBIndexEnd=udg_TempInteger
        loop
            exitwhen bj_forLoopBIndex>bj_forLoopBIndexEnd
            set udg_TempPoint=GetRandomLocInRect(LoadRectHandleBJ(GetForLoopIndexA(),6,udg_SpawnRectHashRef))
            call CreateNUnitsAtLoc(1,'n0CD',Player($B),udg_TempPoint,bj_UNIT_FACING) // 'n0CD': unit "Target"; $B = 11
            call RemoveLocation(udg_TempPoint)
            call GroupAddUnitSimple(GetLastCreatedUnit(),udg_TargetPracticeDummies)
            call ShowUnitHide(GetLastCreatedUnit())
            call SetUnitInvulnerable(GetLastCreatedUnit(),true)
            call TriggerRegisterUnitEvent(gg_trg_TargetPractice_TargetHit,GetLastCreatedUnit(),EVENT_UNIT_DAMAGED)
            set bj_forLoopBIndex=bj_forLoopBIndex+1
        endloop
        // (the remainder after dividing (udg_TempInteger) by (3)) plus (1).
        set udg_TempInteger=(ModuloInteger(udg_TempInteger,3)+1)
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_TargetPractice_Begin_Conditions takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetSoldUnit()),udg_PlayingPlayers))and(GetUnitTypeId(GetSoldUnit())=='n0CF') // 'n0CF': unit "Target Practice Start"
endfunction

function Trig_TargetPractice_Begin_Cond_HeroTooFar takes nothing returns boolean
    // The straight-line distance between udg_TempPoint and udg_TempPoint2.
    return(DistanceBetweenPoints(udg_TempPoint,udg_TempPoint2)>=512.)
endfunction

function Trig_TargetPractice_Begin_Enum_ActivateTarget takes nothing returns nothing
    call GroupAddUnitSimple(GetEnumUnit(),udg_TargetsRemaining)
    call ShowUnitShow(GetEnumUnit())
    call SetUnitInvulnerable(GetEnumUnit(),false)
endfunction

function Trig_TargetPractice_Begin_Actions takes nothing returns nothing
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    set udg_TempPoint2=GetUnitLoc(Player_GetHero(GetOwningPlayer(GetSoldUnit())))
    if(Trig_TargetPractice_Begin_Cond_HeroTooFar())then
        set udg_TempForce=Force_OfPlayer(GetOwningPlayer(GetSoldUnit()))
        call DisplayTimedTextToForce(udg_TempForce,5.,"Aisha: Come closer !")
        call DestroyForce(udg_TempForce)
        call RemoveLocation(udg_TempPoint)
        call RemoveLocation(udg_TempPoint2)
        return
    endif
    call DisableTrigger(GetTriggeringTrigger())
    set udg_TargetPracticePlayer=GetOwningPlayer(GetSoldUnit())
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_ITEMACQUIRED,(udg_PlayerName[GetConvertedPlayerId(udg_TargetPracticePlayer)]+" has begun Aisha's Target Practice!"))
    call UnitRemoveAbilityBJ('Aneu',gg_unit_e017_0018) // 'Aneu': standard ability reference "Neutral Building"
    call StartTimerBJ(udg_TargetPracticeTimer,false,120.)
    set udg_TargetPracticeDialog=CreateTimerDialogBJ(GetLastCreatedTimerBJ(),"Target Practice")
    call ForGroupBJ(udg_TargetPracticeDummies,function Trig_TargetPractice_Begin_Enum_ActivateTarget)
    call EnableTrigger(gg_trg_TargetPractice_PingTargets)
    call EnableTrigger(gg_trg_TargetPractice_TargetHit)
    call EnableTrigger(gg_trg_TargetPractice_Timeout)
endfunction

function Trig_TargetPractice_PingTargets_Cond_IsActiveTarget takes nothing returns boolean
    return(IsUnitInGroup(GetFilterUnit(),udg_TargetsRemaining))
endfunction

function Trig_TargetPractice_PingTargets_Cond_ManyTargetsInArea takes nothing returns boolean
    return(CountUnitsInGroup(udg_TempGroup)>1)
endfunction

function Trig_TargetPractice_PingTargets_Enum_PingTarget takes nothing returns nothing
    set udg_TempPoint=GetUnitLoc(GetEnumUnit())
    call PingMinimapLocForForce(udg_TempForce,udg_TempPoint,2.)
    call RemoveLocation(udg_TempPoint)
endfunction

function Trig_TargetPractice_PingTargets_Actions takes nothing returns nothing
    set udg_TempForce=Force_OfPlayer(udg_TargetPracticePlayer)
    call GroupClear(udg_PendingEffectGroup)
    call GroupAddGroup(udg_TargetsRemaining,udg_PendingEffectGroup)
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=LoadIntegerBJ(6,2,udg_SpawnDataHashRef)
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        set udg_TempGroup=Group_UnitsInRect(LoadRectHandleBJ(GetForLoopIndexA(),6,udg_SpawnRectHashRef),Condition(function Trig_TargetPractice_PingTargets_Cond_IsActiveTarget))
        if(Trig_TargetPractice_PingTargets_Cond_ManyTargetsInArea())then
            set udg_TempPoint=GetRectCenter(LoadRectHandleBJ(GetForLoopIndexA(),6,udg_SpawnRectHashRef))
            call PingMinimapLocForForce(udg_TempForce,udg_TempPoint,2.)
            call RemoveLocation(udg_TempPoint)
            call GroupRemoveGroup(udg_TempGroup,udg_PendingEffectGroup)
        endif
        call DestroyGroup(udg_TempGroup)
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    call ForGroupBJ(udg_PendingEffectGroup,function Trig_TargetPractice_PingTargets_Enum_PingTarget)
    call GroupClear(udg_PendingEffectGroup)
    call DestroyForce(udg_TempForce)
endfunction

function Trig_TargetPractice_TargetHit_Conditions takes nothing returns boolean
    return(GetEventDamage()>.0)
endfunction

function Trig_TargetPractice_TargetHit_Cond_SourceNotDummy takes nothing returns boolean
    return(GetUnitTypeId(GetEventDamageSource())!='h01B') // 'h01B': unit "Proxy Dummy"
endfunction

function Trig_TargetPractice_TargetHit_Cond_NewPrizeUnlocked takes nothing returns boolean
    return(TimerGetElapsed(udg_TargetPracticeTimer)<85.)and(udg_TargetRecordHolder!=Player(9))and(udg_TargetPracticePlayer!=udg_TargetRecordHolder)
endfunction

function Trig_TargetPractice_TargetHit_Cond_Prize5Pending takes nothing returns boolean
    return(udg_TargetPracticeAreaId>5)
endfunction

function Trig_TargetPractice_TargetHit_Cond_QuestDone_Rank4 takes nothing returns boolean
    return(IsQuestCompleted(udg_SideQuest[$E])) // $E = 14
endfunction

function Trig_TargetPractice_TargetHit_Cond_Prize4Pending takes nothing returns boolean
    return(udg_TargetPracticeAreaId>4)
endfunction

function Trig_TargetPractice_TargetHit_Cond_QuestDone_Rank3 takes nothing returns boolean
    return(IsQuestCompleted(udg_SideQuest[$E])) // $E = 14
endfunction

function Trig_TargetPractice_TargetHit_Cond_Prize3Pending takes nothing returns boolean
    return(udg_TargetPracticeAreaId>3)
endfunction

function Trig_TargetPractice_TargetHit_Cond_QuestDone_Rank2 takes nothing returns boolean
    return(IsQuestCompleted(udg_SideQuest[$E])) // $E = 14
endfunction

function Trig_TargetPractice_TargetHit_Cond_Prize2Pending takes nothing returns boolean
    return(udg_TargetPracticeAreaId>2)
endfunction

function Trig_TargetPractice_TargetHit_Cond_QuestDone_Rank1 takes nothing returns boolean
    return(IsQuestCompleted(udg_SideQuest[$E])) // $E = 14
endfunction

function Trig_TargetPractice_TargetHit_Cond_TopPrizeAllowed takes nothing returns boolean
    return(udg_HardcoreOff)
endfunction

function Trig_TargetPractice_TargetHit_Cond_Prize1Pending takes nothing returns boolean
    return(udg_TargetPracticeAreaId>1)
endfunction

function Trig_TargetPractice_TargetHit_Cond_BeatRecord1 takes nothing returns boolean
    return(TimerGetElapsed(udg_TargetPracticeTimer)<udg_TargetRecordTime[1])
endfunction

function Trig_TargetPractice_TargetHit_Cond_BeatRecord2 takes nothing returns boolean
    return(TimerGetElapsed(udg_TargetPracticeTimer)<udg_TargetRecordTime[2])
endfunction

function Trig_TargetPractice_TargetHit_Cond_BeatRecord3 takes nothing returns boolean
    return(TimerGetElapsed(udg_TargetPracticeTimer)<udg_TargetRecordTime[3])
endfunction

function Trig_TargetPractice_TargetHit_Cond_BeatRecord4 takes nothing returns boolean
    return(TimerGetElapsed(udg_TargetPracticeTimer)<udg_TargetRecordTime[4])
endfunction

function Trig_TargetPractice_TargetHit_Cond_BeatRecord5 takes nothing returns boolean
    return(TimerGetElapsed(udg_TargetPracticeTimer)<udg_TargetRecordTime[5])
endfunction

function Trig_TargetPractice_TargetHit_Cond_QuestNotFailed takes nothing returns boolean
    return(IsQuestFailed(udg_SideQuest[$E])==false) // $E = 14
endfunction

function Trig_TargetPractice_TargetHit_Cond_QuestDone takes nothing returns boolean
    return(IsQuestCompleted(udg_SideQuest[$E])) // $E = 14
endfunction

function Trig_TargetPractice_TargetHit_Cond_TargetsMultipleOfTen takes nothing returns boolean
    // The remainder after dividing (CountUnitsInGroup(udg_TargetsRemaining)) by (10).
    return(ModuloInteger(CountUnitsInGroup(udg_TargetsRemaining),$A)==0)and(CountUnitsInGroup(udg_TargetsRemaining)<=50) // $A = 10
endfunction

function Trig_TargetPractice_TargetHit_Cond_ShouldAnnounceCount takes nothing returns boolean
    return(CountUnitsInGroup(udg_TargetsRemaining)<=5)or(Trig_TargetPractice_TargetHit_Cond_TargetsMultipleOfTen())
endfunction

function Trig_TargetPractice_TargetHit_Cond_AnnounceRemaining takes nothing returns boolean
    return(Trig_TargetPractice_TargetHit_Cond_ShouldAnnounceCount())
endfunction

function Trig_TargetPractice_TargetHit_Cond_AllTargetsDown takes nothing returns boolean
    return(CountUnitsInGroup(udg_TargetsRemaining)<=0)
endfunction

function Trig_TargetPractice_TargetHit_Cond_RunnerHitTarget takes nothing returns boolean
    return(GetEventDamageSource()==Player_GetHero(udg_TargetPracticePlayer))and(IsUnitInGroup(GetTriggerUnit(),udg_TargetsRemaining))
endfunction

function Trig_TargetPractice_TargetHit_Actions takes nothing returns nothing
    if(Trig_TargetPractice_TargetHit_Cond_SourceNotDummy())then
        call BlzSetEventDamage(.0)
    endif
    if(Trig_TargetPractice_TargetHit_Cond_RunnerHitTarget())then
        call GroupRemoveUnitSimple(GetTriggerUnit(),udg_TargetsRemaining)
        call ShowUnitHide(GetTriggerUnit())
        call SetUnitInvulnerable(GetTriggerUnit(),true)
        if(Trig_TargetPractice_TargetHit_Cond_AllTargetsDown())then
            call DisableTrigger(GetTriggeringTrigger())
            call DisableTrigger(gg_trg_TargetPractice_Timeout)
            call DisableTrigger(gg_trg_TargetPractice_PingTargets)
            call DestroyTimerDialogBJ(udg_TargetPracticeDialog)
            call DisplayTimedTextToForce(GetPlayersAll(),30,(udg_PlayerName[GetConvertedPlayerId(udg_TargetPracticePlayer)]+(" completed Aisha's Target Practice in |cffffcc00"+(R2SW(TimerGetElapsed(udg_TargetPracticeTimer),3,2)+" seconds|r!"))))
            if(Trig_TargetPractice_TargetHit_Cond_NewPrizeUnlocked())then
                set udg_TargetRecordHolder=Player(9)
                call AddItemToStockBJ('I0K2',gg_unit_e017_0018,1,1) // 'I0K2': item "Flag of Competition"
                call DisplayTextToForce(GetPlayersAll(),"|cff00ffffAisha has a new prize for sale !!|r")
            endif
            if(Trig_TargetPractice_TargetHit_Cond_BeatRecord5())then
                if(Trig_TargetPractice_TargetHit_Cond_Prize5Pending())then
                    call AddItemToStockBJ('I0HQ',gg_unit_e017_0018,1,1) // 'I0HQ': item "Shock Arrows"
                    set udg_TargetPracticeAreaId=5
                endif
                if(Trig_TargetPractice_TargetHit_Cond_BeatRecord4())then
                    if(Trig_TargetPractice_TargetHit_Cond_Prize4Pending())then
                        call AddItemToStockBJ('I0HR',gg_unit_e017_0018,1,1) // 'I0HR': item "Tempest Arrows"
                        if(Trig_TargetPractice_TargetHit_Cond_QuestDone_Rank4())then
                            call DisplayTextToForce(GetPlayersAll(),"|cff00ffffAisha has a new prize for sale !!|r")
                        endif
                        set udg_TargetPracticeAreaId=4
                    endif
                    set udg_TargetRecordTime[5]=udg_TargetRecordTime[4]
                    set udg_TargetRecordName[5]=udg_TargetRecordName[4]
                    if(Trig_TargetPractice_TargetHit_Cond_BeatRecord3())then
                        if(Trig_TargetPractice_TargetHit_Cond_Prize3Pending())then
                            call AddItemToStockBJ('I0BW',gg_unit_e017_0018,1,1) // 'I0BW': item "Phantom Bow"
                            if(Trig_TargetPractice_TargetHit_Cond_QuestDone_Rank3())then
                                call DisplayTextToForce(GetPlayersAll(),"|cff00ffffAisha has a new prize for sale !!|r")
                            endif
                            set udg_TargetPracticeAreaId=3
                        endif
                        set udg_TargetRecordTime[4]=udg_TargetRecordTime[3]
                        set udg_TargetRecordName[4]=udg_TargetRecordName[3]
                        if(Trig_TargetPractice_TargetHit_Cond_BeatRecord2())then
                            if(Trig_TargetPractice_TargetHit_Cond_Prize2Pending())then
                                call AddItemToStockBJ('I0HO',gg_unit_e017_0018,1,1) // 'I0HO': item "Killer Arrows"
                                if(Trig_TargetPractice_TargetHit_Cond_QuestDone_Rank2())then
                                    call DisplayTextToForce(GetPlayersAll(),"|cff00ffffAisha has a new prize for sale !!|r")
                                endif
                                set udg_TargetPracticeAreaId=2
                            endif
                            set udg_TargetRecordTime[3]=udg_TargetRecordTime[2]
                            set udg_TargetRecordName[3]=udg_TargetRecordName[2]
                            if(Trig_TargetPractice_TargetHit_Cond_BeatRecord1())then
                                if(Trig_TargetPractice_TargetHit_Cond_Prize1Pending())then
                                    set udg_TargetRecordHolder=udg_TargetPracticePlayer
                                    if(Trig_TargetPractice_TargetHit_Cond_TopPrizeAllowed())then
                                        call AddItemToStockBJ('I080',gg_unit_e017_0018,1,1) // 'I080': item "Artemis Bow"
                                        if(Trig_TargetPractice_TargetHit_Cond_QuestDone_Rank1())then
                                            call DisplayTextToForce(GetPlayersAll(),"|cff00ffffAisha has a new prize for sale !!|r")
                                        endif
                                    else
                                        call StartTimerBJ(udg_AishaTalkTimer,false,.2)
                                        call EnableTrigger(gg_trg_Aisha_ArtemisTalk_Prepare)
                                    endif
                                    set udg_TargetPracticeAreaId=1
                                endif
                                set udg_TargetRecordTime[2]=udg_TargetRecordTime[1]
                                set udg_TargetRecordName[2]=udg_TargetRecordName[1]
                                set udg_TargetRecordTime[1]=TimerGetElapsed(udg_TargetPracticeTimer)
                                set udg_TargetRecordName[1]=udg_PlayerName[GetConvertedPlayerId(udg_TargetPracticePlayer)]
                            else
                                set udg_TargetRecordTime[2]=TimerGetElapsed(udg_TargetPracticeTimer)
                                set udg_TargetRecordName[2]=udg_PlayerName[GetConvertedPlayerId(udg_TargetPracticePlayer)]
                            endif
                        else
                            set udg_TargetRecordTime[3]=TimerGetElapsed(udg_TargetPracticeTimer)
                            set udg_TargetRecordName[3]=udg_PlayerName[GetConvertedPlayerId(udg_TargetPracticePlayer)]
                        endif
                    else
                        set udg_TargetRecordTime[4]=TimerGetElapsed(udg_TargetPracticeTimer)
                        set udg_TargetRecordName[4]=udg_PlayerName[GetConvertedPlayerId(udg_TargetPracticePlayer)]
                    endif
                else
                    set udg_TargetRecordTime[5]=TimerGetElapsed(udg_TargetPracticeTimer)
                    set udg_TargetRecordName[5]=udg_PlayerName[GetConvertedPlayerId(udg_TargetPracticePlayer)]
                endif
                call DisplayTimedTextToForce(GetPlayersAll(),30,"|cffffcc00Aisha's Target Practice Leaderboard|r\r\n")
                call DisplayTimedTextToForce(GetPlayersAll(),30,(("#1 "+udg_TargetRecordName[1])+(" - "+R2SW(udg_TargetRecordTime[1],3,2))))
                call DisplayTimedTextToForce(GetPlayersAll(),30,(("#2 "+udg_TargetRecordName[2])+(" - "+R2SW(udg_TargetRecordTime[2],3,2))))
                call DisplayTimedTextToForce(GetPlayersAll(),30,(("#3 "+udg_TargetRecordName[3])+(" - "+R2SW(udg_TargetRecordTime[3],3,2))))
                call DisplayTimedTextToForce(GetPlayersAll(),30,(("#4 "+udg_TargetRecordName[4])+(" - "+R2SW(udg_TargetRecordTime[4],3,2))))
                call DisplayTimedTextToForce(GetPlayersAll(),30,(("#5 "+udg_TargetRecordName[5])+(" - "+R2SW(udg_TargetRecordTime[5],3,2))))
            endif
            if(Trig_TargetPractice_TargetHit_Cond_QuestDone())then
                call UnitAddAbilityBJ('Aneu',gg_unit_e017_0018) // 'Aneu': standard ability reference "Neutral Building"
                call EnableTrigger(gg_trg_TargetPractice_Begin)
            else
                if(Trig_TargetPractice_TargetHit_Cond_QuestNotFailed())then
                    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_UPDATED,"Return to Aisha for a reward.")
                    call QuestSetDescriptionBJ(udg_SideQuest[$E],"Return to Aisha for a reward.") // $E = 14
                    call EnableTrigger(gg_trg_TargetPractice_Reward)
                endif
            endif
        else
            if(Trig_TargetPractice_TargetHit_Cond_AnnounceRemaining())then
                set udg_TempForce=Force_OfPlayer(udg_TargetPracticePlayer)
                call DisplayTimedTextToForce(udg_TempForce,5.,(I2S(CountUnitsInGroup(udg_TargetsRemaining))+" targets remaining!"))
                call DestroyForce(udg_TempForce)
            endif
        endif
    endif
endfunction

function Trig_TargetPractice_Timeout_HideTarget takes nothing returns nothing
    call ShowUnitHide(GetEnumUnit())
    call SetUnitInvulnerable(GetEnumUnit(),true)
endfunction

function Trig_TargetPractice_Timeout_Cond_RunNotFailed takes nothing returns boolean
    return(IsQuestFailed(udg_SideQuest[$E])==false) // $E = 14
endfunction

function Trig_TargetPractice_Timeout_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DisableTrigger(gg_trg_TargetPractice_TargetHit)
    call DisableTrigger(gg_trg_TargetPractice_PingTargets)
    call ForGroupBJ(udg_TargetsRemaining,function Trig_TargetPractice_Timeout_HideTarget)
    call GroupClear(udg_TargetsRemaining)
    call DestroyTimerDialogBJ(udg_TargetPracticeDialog)
    if(Trig_TargetPractice_Timeout_Cond_RunNotFailed())then
        call DisplayTimedTextToForce(GetPlayersAll(),30,"Target Practice timed out! Talk to Aisha to try again.")
        call UnitAddAbilityBJ('Aneu',gg_unit_e017_0018) // 'Aneu': standard ability reference "Neutral Building"
        call EnableTrigger(gg_trg_TargetPractice_Begin)
    endif
endfunction

function Trig_TargetPractice_Fail_Cond_TargetsStillOut takes nothing returns boolean
    return(IsUnitGroupEmptyBJ(udg_TargetsRemaining)==false)
endfunction

function Trig_TargetPractice_Fail_Actions takes nothing returns nothing
    call DestroyEffectBJ(udg_SpecialEffect[81])
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_FAILED,"Quest Failed: |cffffcc00Target Practice|r")
    call QuestSetFailedBJ(udg_SideQuest[$E],true) // $E = 14
    if(Trig_TargetPractice_Fail_Cond_TargetsStillOut())then
        call StartTimerBJ(udg_TargetPracticeTimer,false,.0)
    endif
    call DestroyTrigger(gg_trg_TargetPractice_Reward)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_TargetPractice_Reward_Conditions takes nothing returns boolean
    return((IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(GetUnitTypeId(GetTriggerUnit())!='H01D')and(IsUnitVisible(gg_unit_e017_0018,GetOwningPlayer(GetTriggerUnit())))and(udg_InCinematicMode==false))!=null // 'H01D': unit "Spirit of Gaya"
endfunction

function Trig_TargetPractice_Reward_Cond_ShowRewardTalk takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_TargetPractice_Reward_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[81])
    call PauseUnitBJ(true,gg_unit_e017_0018)
    if(Trig_TargetPractice_Reward_Cond_ShowRewardTalk())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"We did it. Now do you recognize our skill?",false)
        call Text_Say(gg_unit_e017_0018,"That was a great run! You can be proud. Here, a small prize.",false)
        call Reward_Give($FA0,$FA0,gg_unit_e017_0018) // $FA0 = 4000
        call Text_Say(gg_unit_e017_0018,"Also I can gear you up with some better arrows if you want. In fact, the better you do, the more I'll offer you! So try and beat all the high scores if you will!",false)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"Well I may not hold them for long. Your leaderboards show that you too are pretty skilled.",false)
        call Text_Say(gg_unit_e017_0018,"Well of course we are, it is our pride after all. But... we aren't going to beat your records, don't worry about that.",false)
        call Text_Say(gg_unit_e017_0018,"Didn't you notice? The targets are on your side, not ours. Those records you see were made a long time ago, back when we were still on Gaya.",false)
        call Text_Say(gg_unit_e017_0018,"But now we're here on Terra. We can't exactly run the gauntlet anymore like this, you know?",false)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"I see... so those records of yours are actually very old already. You must've improved a lot since then.",false)
        call Text_Say(gg_unit_e017_0018,"Well we haven't done much fighting since coming here. None, actually. I'd probably be quite out of shape. But if we do ever come back to your side, you bet I'll set a new record that puts all previous ones to shame, even the one from our legendary Artemis!",false)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"I'll be looking forward to it.",false)
        call Cine_ExitAction()
    else
        call Reward_Give($FA0,$FA0,gg_unit_e017_0018) // $FA0 = 4000
    endif
    call PauseUnitBJ(false,gg_unit_e017_0018)
    call UnitAddAbilityBJ('Aneu',gg_unit_e017_0018) // 'Aneu': standard ability reference "Neutral Building"
    call EnableTrigger(gg_trg_TargetPractice_Begin)
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_COMPLETED,"Quest Completed: |cffffcc00Target Practice|r")
    call QuestSetCompletedBJ(udg_SideQuest[$E],true) // $E = 14
    set udg_QuestsCompleted=(udg_QuestsCompleted+1)
    set udg_PhantomVillagersMet=(udg_PhantomVillagersMet+1)
    call DestroyTrigger(gg_trg_TargetPractice_Fail)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_TargetPractice automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_TargetPractice (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_TargetPractice takes nothing returns nothing
endfunction

function Register_TargetPractice_Init takes nothing returns nothing
    set gg_trg_TargetPractice_Init=CreateTrigger()
    call DisableTrigger(gg_trg_TargetPractice_Init)
    call TriggerAddAction(gg_trg_TargetPractice_Init,function Trig_TargetPractice_Init_Actions)
endfunction

function Register_TargetPractice_Begin takes nothing returns nothing
    set gg_trg_TargetPractice_Begin=CreateTrigger()
    call DisableTrigger(gg_trg_TargetPractice_Begin)
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_TargetPractice_Begin,Player(8),EVENT_PLAYER_UNIT_SELL)
    call TriggerAddCondition(gg_trg_TargetPractice_Begin,Condition(function Trig_TargetPractice_Begin_Conditions))
    call TriggerAddAction(gg_trg_TargetPractice_Begin,function Trig_TargetPractice_Begin_Actions)
endfunction

function Register_TargetPractice_PingTargets takes nothing returns nothing
    set gg_trg_TargetPractice_PingTargets=CreateTrigger()
    call DisableTrigger(gg_trg_TargetPractice_PingTargets)
    call TriggerRegisterTimerEventPeriodic(gg_trg_TargetPractice_PingTargets,5.)
    call TriggerAddAction(gg_trg_TargetPractice_PingTargets,function Trig_TargetPractice_PingTargets_Actions)
endfunction

function Register_TargetPractice_TargetHit takes nothing returns nothing
    set gg_trg_TargetPractice_TargetHit=CreateTrigger()
    call DisableTrigger(gg_trg_TargetPractice_TargetHit)
    call TriggerAddCondition(gg_trg_TargetPractice_TargetHit,Condition(function Trig_TargetPractice_TargetHit_Conditions))
    call TriggerAddAction(gg_trg_TargetPractice_TargetHit,function Trig_TargetPractice_TargetHit_Actions)
endfunction

function Register_TargetPractice_Timeout takes nothing returns nothing
    set gg_trg_TargetPractice_Timeout=CreateTrigger()
    call DisableTrigger(gg_trg_TargetPractice_Timeout)
    call TriggerRegisterTimerExpireEventBJ(gg_trg_TargetPractice_Timeout,udg_TargetPracticeTimer)
    call TriggerAddAction(gg_trg_TargetPractice_Timeout,function Trig_TargetPractice_Timeout_Actions)
endfunction

function Register_TargetPractice_Fail takes nothing returns nothing
    set gg_trg_TargetPractice_Fail=CreateTrigger()
    call DisableTrigger(gg_trg_TargetPractice_Fail)
    call TriggerAddAction(gg_trg_TargetPractice_Fail,function Trig_TargetPractice_Fail_Actions)
endfunction

function Register_TargetPractice_Reward takes nothing returns nothing
    set gg_trg_TargetPractice_Reward=CreateTrigger()
    call DisableTrigger(gg_trg_TargetPractice_Reward)
    call TriggerRegisterUnitInRangeSimple(gg_trg_TargetPractice_Reward,200.,gg_unit_e017_0018)
    call TriggerRegisterUnitInRangeSimple(gg_trg_TargetPractice_Reward,450.,gg_unit_e017_0018)
    call TriggerAddCondition(gg_trg_TargetPractice_Reward,Condition(function Trig_TargetPractice_Reward_Conditions))
    call TriggerAddAction(gg_trg_TargetPractice_Reward,function Trig_TargetPractice_Reward_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_TargetPractice takes nothing returns nothing
    call Register_TargetPractice_Init()
    call Register_TargetPractice_Begin()
    call Register_TargetPractice_PingTargets()
    call Register_TargetPractice_TargetHit()
    call Register_TargetPractice_Timeout()
    call Register_TargetPractice_Fail()
    call Register_TargetPractice_Reward()
endfunction

endlibrary
