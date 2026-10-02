library THuntFestival requires TCam, TCine, TMusic, TPlayerPart01, TReward, TText, TUnit, TWait
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_HuntFestival_Announce=null
    trigger gg_trg_HuntFestival_Invite=null
    trigger gg_trg_HuntFestival_Begin=null
    trigger gg_trg_HuntFestival_Teleport=null
    trigger gg_trg_HuntFestival_KeepAway=null
    trigger gg_trg_HuntFestival_Reorder=null
    trigger gg_trg_HuntFestival_Respawn=null
    trigger gg_trg_HuntFestival_Score=null
    trigger gg_trg_HuntFestival_End=null
    // Variables only this module uses.
    timerdialog udg_FestivalTimerDialog=null
    unit udg_FestivalBansat=null
    unit udg_FestivalMonica=null
    unit udg_FestivalWard=null
    unit udg_FestivalGuest=null
    player udg_FestivalWinner=null
endglobals

function Trig_HuntFestival_Announce_Conditions takes nothing returns boolean
    return(IsQuestCompleted(udg_MainQuest[$B]))and(IsQuestDiscovered(udg_SideQuest[24]))and(IsQuestDiscovered(udg_SideQuest[53]))and(IsQuestDiscovered(udg_SideQuest[57]))and(udg_CommonHuntsDone>=2)and(udg_RareHuntsDone>=3)and(udg_MontblancHasNews==false) // $B = 11
endfunction

function Trig_HuntFestival_Announce_IsMapQuestOpen takes nothing returns boolean
    return(IsQuestCompleted(udg_SideQuest[61])==false)and(IsQuestFailed(udg_SideQuest[61])==false)
endfunction

function Trig_HuntFestival_Announce_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    if(Trig_HuntFestival_Announce_IsMapQuestOpen())then
        call DestroyEffectBJ(udg_SpecialEffect[82])
    endif
    set udg_MontblancHasNews=true
    call DisplayTextToForce(GetPlayersAll(),"|cff00ffffMontblanc has something to tell you !!|r")
    set udg_SpecialEffect[82]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_n0CE_0020,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call EnableTrigger(gg_trg_HuntFestival_Invite)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_HuntFestival_Invite_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_n0CE_0020,true,true,true))
endfunction

function Trig_HuntFestival_Invite_IsDialogueOn takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_HuntFestival_Invite_IsMapQuestOpen takes nothing returns boolean
    return(IsQuestCompleted(udg_SideQuest[61])==false)and(IsQuestFailed(udg_SideQuest[61])==false)
endfunction

function Trig_HuntFestival_Invite_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[82])
    if(Trig_HuntFestival_Invite_IsDialogueOn())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(gg_unit_n0CE_0020,"Good day, adventurers. Might I interest you in partaking in a special event?",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"A special event? Is this about the Hunt Club?",false)
        call Text_Say(gg_unit_n0CE_0020,"Yes, we of the Hunt Club have the tradition of holding a festival every year. A competition for hunters to see who is worthy of the title of our best hunter.",false)
        call Text_Say(gg_unit_n0CE_0020,"This year we missed our usual day due to the recent sieges, but since we've now overcome them, we figured this festival would be a good way to lift people's spirits.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"That sounds like a good idea. Are you giving out prizes?",false)
        call Text_Say(gg_unit_n0CE_0020,"Of course, so give it your all and don't be holding back now.",false)
        call Text_Say(gg_unit_n0CE_0020,"The festival is set to begin soon. You are scored points based on how many monsters you kill in a certain time limit.",false)
        call Text_Say(gg_unit_n0CE_0020,"Afterwards, the hunter with the highest score is determined the winner.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Alright then. We'll try to be there.",false)
        call Cine_ExitAction()
    endif
    set udg_MontblancHasNews=false
    if(Trig_HuntFestival_Invite_IsMapQuestOpen())then
        set udg_SpecialEffect[82]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_n0CE_0020,"Objects\\RandomObject\\RandomObject.mdl")
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_DISCOVERED,"New Quest Received: |cffffcc00Hunt Festival|r")
    set udg_SideQuest[62]=CreateQuestBJ(bj_QUESTTYPE_REQ_DISCOVERED,(udg_QuestNamePrefix+"Hunt Festival"),"The annual Hunt Club's Hunt Festival is about to begin! Participate for potential prizes!","ReplaceableTextures\\CommandButtons\\BTNPandarenBrewmaster.blp")
    call EnableTrigger(gg_trg_HuntFestival_Begin)
    call StartTimerBJ(udg_FestivalTimer,false,120.)
    set udg_FestivalTimerDialog=CreateTimerDialogBJ(GetLastCreatedTimerBJ(),"Hunt Festival")
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_HuntFestival_Begin_IsCinematicBusy takes nothing returns boolean
    return(udg_InCinematicMode)
endfunction

function Trig_HuntFestival_Begin_IsGuestNaisha takes nothing returns boolean
    return(udg_NaishaTownUnit==udg_NaishaUnit)
endfunction

function Trig_HuntFestival_Begin_IsGuestClyde takes nothing returns boolean
    return(udg_NaishaTownUnit==udg_ShadowUnit)
endfunction

function Trig_HuntFestival_Begin_EmpowerHunter takes nothing returns nothing
    call UnitAddAbilityBJ('S00J',GetEnumUnit()) // 'S00J': ability "Festival Spirit"
    // (BlzGetUnitBaseDamage(the unit being visited, udg_AbilityLevelIndex)) times ((udg_Difficulty) plus (1)).
    call BlzSetUnitBaseDamage(GetEnumUnit(),(BlzGetUnitBaseDamage(GetEnumUnit(),udg_AbilityLevelIndex)*(udg_Difficulty+1)),udg_AbilityLevelIndex)
endfunction

function Trig_HuntFestival_Begin_EmpowerHunterHigh takes nothing returns nothing
    call UnitAddAbilityBJ('S00J',GetEnumUnit()) // 'S00J': ability "Festival Spirit"
    // (BlzGetUnitBaseDamage(the unit being visited, udg_AbilityLevelIndex)) times ((udg_Difficulty) plus (4)).
    call BlzSetUnitBaseDamage(GetEnumUnit(),(BlzGetUnitBaseDamage(GetEnumUnit(),udg_AbilityLevelIndex)*(udg_Difficulty+4)),udg_AbilityLevelIndex)
endfunction

function Trig_HuntFestival_Begin_IsHardMode takes nothing returns boolean
    return(udg_EternityMode)
endfunction

function Trig_HuntFestival_Begin_AddPlayerToBoard takes nothing returns nothing
    call LeaderboardAddItemBJ(GetEnumPlayer(),udg_HuntFestivalBoard,udg_PlayerName[GetConvertedPlayerId(GetEnumPlayer())],0)
endfunction

function Trig_HuntFestival_Begin_OrderHunterToHunt takes nothing returns nothing
    // A random whole number from 1 through 7.
    set udg_TempInteger=GetRandomInt(1,7)
    // A random whole number from 1 through LoadIntegerBJ(udg_TempInteger, 2, udg_SpawnDataHashRef).
    set udg_TempPoint=GetRandomLocInRect(LoadRectHandleBJ(GetRandomInt(1,LoadIntegerBJ(udg_TempInteger,2,udg_SpawnDataHashRef)),udg_TempInteger,udg_SpawnRectHashRef))
    call IssuePointOrderLocBJ(GetEnumUnit(),"attack",udg_TempPoint)
    call RemoveLocation(udg_TempPoint)
endfunction

function Trig_HuntFestival_Begin_Actions takes nothing returns nothing
    if(Trig_HuntFestival_Begin_IsCinematicBusy())then
        call StartTimerBJ(udg_FestivalTimer,false,.49)
        return
    endif
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyTimerDialogBJ(udg_FestivalTimerDialog)
    set udg_HuntCounter[0]=(udg_HuntCounter[0]+1)
    call LeaderboardDisplayBJ(false,udg_HuntLeaderboard)
    call Cine_Enter()
    call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUT,1.,"ReplaceableTextures\\CameraMasks\\White_mask.blp",0,0,0,0)
    call Wait_Polled(1.5)
    call Cam_PanToUnit(gg_unit_n0CE_0020,0)
    set udg_TempPoint=GetRectCenter(gg_rct_650)
    set udg_TempPoint2=OffsetLocation(udg_TempPoint,0,128.)
    call CreateNUnitsAtLoc(1,'h034',Player(9),udg_TempPoint2,225.) // 'h034': unit "Bansat"
    set udg_FestivalBansat=GetLastCreatedUnit()
    call GroupAddUnitSimple(GetLastCreatedUnit(),udg_FestivalHunters)
    call RemoveLocation(udg_TempPoint2)
    set udg_TempPoint2=OffsetLocation(udg_TempPoint,0,-128.)
    call CreateNUnitsAtLoc(1,'h033',Player(9),udg_TempPoint2,225.) // 'h033': unit "Ward"
    set udg_FestivalWard=GetLastCreatedUnit()
    call GroupAddUnitSimple(GetLastCreatedUnit(),udg_FestivalHunters)
    call RemoveLocation(udg_TempPoint2)
    set udg_TempPoint2=OffsetLocation(udg_TempPoint,128.,.0)
    call CreateNUnitsAtLoc(1,'n0D4',Player(9),udg_TempPoint2,225.) // 'n0D4': unit "Monica"
    set udg_FestivalMonica=GetLastCreatedUnit()
    call GroupAddUnitSimple(GetLastCreatedUnit(),udg_FestivalHunters)
    call RemoveLocation(udg_TempPoint2)
    set udg_TempPoint2=OffsetLocation(udg_TempPoint,-128.,.0)
    if(Trig_HuntFestival_Begin_IsGuestClyde())then
        call CreateNUnitsAtLoc(1,'h035',Player(9),udg_TempPoint2,225.) // 'h035': unit "Clyde"
    else
        if(Trig_HuntFestival_Begin_IsGuestNaisha())then
            call CreateNUnitsAtLoc(1,'e01I',Player(9),udg_TempPoint2,225.) // 'e01I': unit "Naisha"
        else
            call CreateNUnitsAtLoc(1,'e01E',Player(9),udg_TempPoint2,225.) // 'e01E': unit "Krjn"
        endif
    endif
    set udg_FestivalGuest=GetLastCreatedUnit()
    call GroupAddUnitSimple(GetLastCreatedUnit(),udg_FestivalHunters)
    call RemoveLocation(udg_TempPoint2)
    call RemoveLocation(udg_TempPoint)
    call ShowUnitHide(gg_unit_n0BW_0094)
    call ShowUnitHide(gg_unit_h030_0243)
    call ShowUnitHide(gg_unit_h02Z_0230)
    call ShowUnitHide(udg_NaishaTownUnit)
    if(Trig_HuntFestival_Begin_IsHardMode())then
        call ForGroupBJ(udg_FestivalHunters,function Trig_HuntFestival_Begin_EmpowerHunterHigh)
    else
        call ForGroupBJ(udg_FestivalHunters,function Trig_HuntFestival_Begin_EmpowerHunter)
    endif
    call Wait_Polled(.5)
    call CinematicFadeBJ(bj_CINEFADETYPE_FADEIN,1.,"ReplaceableTextures\\CameraMasks\\White_mask.blp",0,0,0,0)
    call Wait_Polled(1.5)
    call Text_Say(gg_unit_n0CE_0020,"Brave hunters! The time has come for our festival to begin!",false)
    call Text_Say(gg_unit_n0CE_0020,"You have |cffffcc004 minutes|r to slay as many monsters as you can!",false)
    call Text_Say(gg_unit_n0CE_0020,"The stronger the monster, the more points you get. But don't waste your time on powerful foes too much; common game will give more points overall.",false)
    call Text_Say(gg_unit_n0CE_0020,("I also want to welcome our guests to this year's festival. The legendary adventurers who helped us defend this town from the recent assaults, as well as a special guest, "+(GetUnitName(udg_FestivalGuest)+"!")),false)
    call Text_Say(gg_unit_n0CE_0020,"I wish you all the best of luck! May the best hunter win!",false)
    call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUT,1.,"ReplaceableTextures\\CameraMasks\\White_mask.blp",0,0,0,0)
    call Wait_Polled(1.5)
    // A random whole number from 1 through LoadIntegerBJ(2, 2, udg_SpawnDataHashRef).
    set udg_TempPoint=GetRandomLocInRect(LoadRectHandleBJ(GetRandomInt(1,LoadIntegerBJ(2,2,udg_SpawnDataHashRef)),2,udg_SpawnRectHashRef))
    call SetUnitPositionLoc(udg_FestivalMonica,udg_TempPoint)
    call RemoveLocation(udg_TempPoint)
    // A random whole number from 1 through LoadIntegerBJ(3, 2, udg_SpawnDataHashRef).
    set udg_TempPoint=GetRandomLocInRect(LoadRectHandleBJ(GetRandomInt(1,LoadIntegerBJ(3,2,udg_SpawnDataHashRef)),3,udg_SpawnRectHashRef))
    call SetUnitPositionLoc(udg_FestivalBansat,udg_TempPoint)
    call RemoveLocation(udg_TempPoint)
    // A random whole number from 1 through LoadIntegerBJ(4, 2, udg_SpawnDataHashRef).
    set udg_TempPoint=GetRandomLocInRect(LoadRectHandleBJ(GetRandomInt(1,LoadIntegerBJ(4,2,udg_SpawnDataHashRef)),4,udg_SpawnRectHashRef))
    call SetUnitPositionLoc(udg_FestivalWard,udg_TempPoint)
    call RemoveLocation(udg_TempPoint)
    // A random whole number from 5 through 7.
    set udg_TempInteger=GetRandomInt(5,7)
    // A random whole number from 1 through LoadIntegerBJ(udg_TempInteger, 2, udg_SpawnDataHashRef).
    set udg_TempPoint=GetRandomLocInRect(LoadRectHandleBJ(GetRandomInt(1,LoadIntegerBJ(udg_TempInteger,2,udg_SpawnDataHashRef)),udg_TempInteger,udg_SpawnRectHashRef))
    call SetUnitPositionLoc(udg_FestivalGuest,udg_TempPoint)
    call RemoveLocation(udg_TempPoint)
    call CinematicFadeBJ(bj_CINEFADETYPE_FADEIN,1.,"ReplaceableTextures\\CameraMasks\\White_mask.blp",0,0,0,0)
    call Cine_ExitAction()
    set udg_HuntFestivalBoard=CreateLeaderboardBJ(GetPlayersAll(),"Festival of the Hunt")
    call ForForce(udg_PlayingPlayers,function Trig_HuntFestival_Begin_AddPlayerToBoard)
    call LeaderboardAddItemBJ(Player(8),udg_HuntFestivalBoard,"Monica",0)
    call LeaderboardAddItemBJ(Player(9),udg_HuntFestivalBoard,"Bansat",0)
    call LeaderboardAddItemBJ(Player($A),udg_HuntFestivalBoard,"Ward",0) // $A = 10
    call LeaderboardAddItemBJ(Player($B),udg_HuntFestivalBoard,GetUnitName(udg_FestivalGuest),0) // $B = 11
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=$C // $C = 12
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        set udg_FestivalScore[GetForLoopIndexA()]=0
        call LeaderboardSetPlayerItemLabelColorBJ(ConvertedPlayer(GetForLoopIndexA()),udg_HuntFestivalBoard,'d',100.,100.,0)
        call LeaderboardSetPlayerItemValueColorBJ(ConvertedPlayer(GetForLoopIndexA()),udg_HuntFestivalBoard,'d',100.,100.,0)
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    call StartTimerBJ(udg_FestivalTimer,false,240.)
    call CreateTimerDialogBJ(GetLastCreatedTimerBJ(),"Hunt Festival")
    call TimerDialogSetTitleColorBJ(GetLastCreatedTimerDialogBJ(),'d',80,20,0)
    call TimerDialogSetTimeColorBJ(GetLastCreatedTimerDialogBJ(),'d',80,20,0)
    set udg_FestivalTimerDialog=GetLastCreatedTimerDialogBJ()
    call EnableTrigger(gg_trg_HuntFestival_Score)
    call EnableTrigger(gg_trg_HuntFestival_End)
    call EnableTrigger(gg_trg_HuntFestival_Reorder)
    call EnableTrigger(gg_trg_HuntFestival_Teleport)
    call EnableTrigger(gg_trg_HuntFestival_KeepAway)
    call EnableTrigger(gg_trg_HuntFestival_Respawn)
    call QuestSetDescriptionBJ(udg_SideQuest[62],"The annual Hunt Festival has begun! Give it your best shot to try and win!")
    call Music_SetTrack(36)
    call Wait_Polled(2)
    call ForGroupBJ(udg_FestivalHunters,function Trig_HuntFestival_Begin_OrderHunterToHunt)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_HuntFestival_Teleport_IsStrongAttacker takes nothing returns boolean
    return((IsUnitType(GetAttacker(),UNIT_TYPE_RESISTANT))or(IsUnitType(GetAttacker(),UNIT_TYPE_HERO)))!=null
endfunction

function Trig_HuntFestival_Teleport_Conditions takes nothing returns boolean
    return(IsUnitInGroup(GetTriggerUnit(),udg_FestivalHunters))and(Trig_HuntFestival_Teleport_IsStrongAttacker())
endfunction

function Trig_HuntFestival_Teleport_Actions takes nothing returns nothing
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(udg_TempPoint)
    // A random whole number from 1 through 7.
    set udg_TempInteger=GetRandomInt(1,7)
    // A random whole number from 1 through LoadIntegerBJ(udg_TempInteger, 2, udg_SpawnDataHashRef).
    set udg_TempPoint=GetRandomLocInRect(LoadRectHandleBJ(GetRandomInt(1,LoadIntegerBJ(udg_TempInteger,2,udg_SpawnDataHashRef)),udg_TempInteger,udg_SpawnRectHashRef))
    call SetUnitPositionLoc(GetTriggerUnit(),udg_TempPoint)
    call RemoveLocation(udg_TempPoint)
    call AddSpecialEffectTargetUnitBJ("origin",GetTriggerUnit(),"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call Wait_Polled(2)
    // A random whole number from 1 through 7.
    set udg_TempInteger=GetRandomInt(1,7)
    // A random whole number from 1 through LoadIntegerBJ(udg_TempInteger, 2, udg_SpawnDataHashRef).
    set udg_TempPoint=GetRandomLocInRect(LoadRectHandleBJ(GetRandomInt(1,LoadIntegerBJ(udg_TempInteger,2,udg_SpawnDataHashRef)),udg_TempInteger,udg_SpawnRectHashRef))
    call IssuePointOrderLocBJ(GetTriggerUnit(),"attack",udg_TempPoint)
    call RemoveLocation(udg_TempPoint)
endfunction

function Trig_HuntFestival_KeepAway_Conditions takes nothing returns boolean
    return(IsUnitInGroup(GetTriggerUnit(),udg_FestivalHunters))
endfunction

function Trig_HuntFestival_KeepAway_Actions takes nothing returns nothing
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(udg_TempPoint)
    // A random whole number from 1 through 7.
    set udg_TempInteger=GetRandomInt(1,7)
    // A random whole number from 1 through LoadIntegerBJ(udg_TempInteger, 2, udg_SpawnDataHashRef).
    set udg_TempPoint=GetRandomLocInRect(LoadRectHandleBJ(GetRandomInt(1,LoadIntegerBJ(udg_TempInteger,2,udg_SpawnDataHashRef)),udg_TempInteger,udg_SpawnRectHashRef))
    call SetUnitPositionLoc(GetTriggerUnit(),udg_TempPoint)
    call RemoveLocation(udg_TempPoint)
    call AddSpecialEffectTargetUnitBJ("origin",GetTriggerUnit(),"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call Wait_Polled(2)
    // A random whole number from 1 through 7.
    set udg_TempInteger=GetRandomInt(1,7)
    // A random whole number from 1 through LoadIntegerBJ(udg_TempInteger, 2, udg_SpawnDataHashRef).
    set udg_TempPoint=GetRandomLocInRect(LoadRectHandleBJ(GetRandomInt(1,LoadIntegerBJ(udg_TempInteger,2,udg_SpawnDataHashRef)),udg_TempInteger,udg_SpawnRectHashRef))
    call IssuePointOrderLocBJ(GetTriggerUnit(),"attack",udg_TempPoint)
    call RemoveLocation(udg_TempPoint)
endfunction

function Trig_HuntFestival_Reorder_OrderHunterToHunt takes nothing returns nothing
    // A random whole number from 1 through 7.
    set udg_TempInteger=GetRandomInt(1,7)
    // A random whole number from 1 through LoadIntegerBJ(udg_TempInteger, 2, udg_SpawnDataHashRef).
    set udg_TempPoint=GetRandomLocInRect(LoadRectHandleBJ(GetRandomInt(1,LoadIntegerBJ(udg_TempInteger,2,udg_SpawnDataHashRef)),udg_TempInteger,udg_SpawnRectHashRef))
    call IssuePointOrderLocBJ(GetEnumUnit(),"attack",udg_TempPoint)
    call RemoveLocation(udg_TempPoint)
endfunction

function Trig_HuntFestival_Reorder_Actions takes nothing returns nothing
    call ForGroupBJ(udg_FestivalHunters,function Trig_HuntFestival_Reorder_OrderHunterToHunt)
endfunction

function Trig_HuntFestival_Respawn_Conditions takes nothing returns boolean
    return(IsUnitInGroup(GetTriggerUnit(),udg_FestivalHunters))
endfunction

function Trig_HuntFestival_Respawn_IsWard takes nothing returns boolean
    return(GetTriggerUnit()==udg_FestivalWard)
endfunction

function Trig_HuntFestival_Respawn_IsMonica takes nothing returns boolean
    return(GetTriggerUnit()==udg_FestivalMonica)
endfunction

function Trig_HuntFestival_Respawn_IsGuest takes nothing returns boolean
    return(GetTriggerUnit()==udg_FestivalGuest)
endfunction

function Trig_HuntFestival_Respawn_IsBansat takes nothing returns boolean
    return(GetTriggerUnit()==udg_FestivalBansat)
endfunction

function Trig_HuntFestival_Respawn_Actions takes nothing returns nothing
    if(Trig_HuntFestival_Respawn_IsBansat())then
        set udg_FestivalBansat=ReplaceUnitBJ(GetTriggerUnit(),GetUnitTypeId(GetTriggerUnit()),bj_UNIT_STATE_METHOD_MAXIMUM)
    else
        if(Trig_HuntFestival_Respawn_IsGuest())then
            set udg_FestivalGuest=ReplaceUnitBJ(GetTriggerUnit(),GetUnitTypeId(GetTriggerUnit()),bj_UNIT_STATE_METHOD_MAXIMUM)
        else
            if(Trig_HuntFestival_Respawn_IsMonica())then
                set udg_FestivalMonica=ReplaceUnitBJ(GetTriggerUnit(),GetUnitTypeId(GetTriggerUnit()),bj_UNIT_STATE_METHOD_MAXIMUM)
            else
                if(Trig_HuntFestival_Respawn_IsWard())then
                    set udg_FestivalWard=ReplaceUnitBJ(GetTriggerUnit(),GetUnitTypeId(GetTriggerUnit()),bj_UNIT_STATE_METHOD_MAXIMUM)
                else
                    return
                endif
            endif
        endif
    endif
    call GroupAddUnitSimple(GetLastReplacedUnitBJ(),udg_FestivalHunters)
    call SetUnitInvulnerable(GetLastReplacedUnitBJ(),true)
    call PauseUnitBJ(true,GetLastReplacedUnitBJ())
    call UnitAddAbilityBJ('A0VJ',GetLastReplacedUnitBJ()) // 'A0VJ': ability "Unaffected by Cinematics"
endfunction

function Trig_HuntFestival_Score_IsFestivalKiller takes nothing returns boolean
    return(IsUnitInGroup(GetKillingUnitBJ(),udg_FestivalHunters))or(IsPlayerInForce(GetOwningPlayer(GetKillingUnitBJ()),udg_PlayingPlayers))
endfunction

function Trig_HuntFestival_Score_Conditions takes nothing returns boolean
    return((IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)==false)and(GetKillingUnitBJ()!=null)and(Trig_HuntFestival_Score_IsFestivalKiller()))!=null
endfunction

function Trig_HuntFestival_Score_IsGuestKiller takes nothing returns boolean
    return(GetKillingUnitBJ()==udg_FestivalGuest)
endfunction

function Trig_HuntFestival_Score_IsHunterKiller takes nothing returns boolean
    return(IsUnitInGroup(GetKillingUnitBJ(),udg_FestivalHunters))
endfunction

function Trig_HuntFestival_Score_Actions takes nothing returns nothing
    if(Trig_HuntFestival_Score_IsHunterKiller())then
        if(Trig_HuntFestival_Score_IsGuestKiller())then
            set udg_TempPlayer=Player($B) // $B = 11
        else
            set udg_TempPlayer=ConvertedPlayer(GetUnitPointValue(GetKillingUnitBJ()))
        endif
        // (udg_FestivalScore at position GetConvertedPlayerId(udg_TempPlayer)) plus (udg_Difficulty).
        set udg_FestivalScore[GetConvertedPlayerId(udg_TempPlayer)]=(udg_FestivalScore[GetConvertedPlayerId(udg_TempPlayer)]+udg_Difficulty)
    else
        set udg_TempPlayer=GetOwningPlayer(GetKillingUnitBJ())
    endif
    // Result 1: (udg_FestivalScore at position GetConvertedPlayerId(udg_TempPlayer)) plus (2).
    // Result 2: (unit level of the triggering unit) plus (1).
    // Result 3: result 2 treated as a decimal-capable number.
    // Result 4: the square root of (result 3).
    // Result 5: (result 4) with its decimal part removed.
    // Result 6: (result 1) plus (result 5).
    set udg_FestivalScore[GetConvertedPlayerId(udg_TempPlayer)]=((udg_FestivalScore[GetConvertedPlayerId(udg_TempPlayer)]+2)+R2I(SquareRoot(I2R((GetUnitLevel(GetTriggerUnit())+1)))))
    call LeaderboardSetPlayerItemValueBJ(udg_TempPlayer,udg_HuntFestivalBoard,udg_FestivalScore[GetConvertedPlayerId(udg_TempPlayer)])
    call LeaderboardSortItemsBJ(udg_HuntFestivalBoard,bj_SORTTYPE_SORTBYVALUE,false)
endfunction

function Trig_HuntFestival_End_IsCinematicBusy takes nothing returns boolean
    return(udg_InCinematicMode)
endfunction

function Trig_HuntFestival_End_IsWinnerWard takes nothing returns boolean
    return(udg_FestivalWinner==Player($A)) // $A = 10
endfunction

function Trig_HuntFestival_End_IsWinnerBansat takes nothing returns boolean
    return(udg_FestivalWinner==Player(9))
endfunction

function Trig_HuntFestival_End_IsWinnerMonica takes nothing returns boolean
    return(udg_FestivalWinner==Player(8))
endfunction

function Trig_HuntFestival_End_IsWinnerGuest takes nothing returns boolean
    return(udg_FestivalWinner==Player($B)) // $B = 11
endfunction

function Trig_HuntFestival_End_IsWinnerPlayer takes nothing returns boolean
    return(IsPlayerInForce(udg_FestivalWinner,udg_PlayingPlayers))
endfunction

function Trig_HuntFestival_End_IsDialogueOn takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_HuntFestival_End_IsDialogueOnPrize takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_HuntFestival_End_IsWinnerPlayerPrize takes nothing returns boolean
    return(IsPlayerInForce(udg_FestivalWinner,udg_PlayingPlayers))
endfunction

function Trig_HuntFestival_End_RemoveFestivalHunter takes nothing returns nothing
    call UnitRemoveAbilityBJ('A0ZR',GetEnumUnit()) // 'A0ZR': ability "Immortal"
    call KillUnit(GetEnumUnit())
    call RemoveUnit(GetEnumUnit())
endfunction

function Trig_HuntFestival_End_IsScoreAchievementEarned takes nothing returns boolean
    return(udg_FestivalScore[GetConvertedPlayerId(GetEnumPlayer())]>=500)and(IsPlayerInForce(GetEnumPlayer(),udg_TitleForce[50])==false)
endfunction

function Trig_HuntFestival_End_GrantScoreAchievement takes nothing returns nothing
    if(Trig_HuntFestival_End_IsScoreAchievementEarned())then
        set udg_TempPlayer=GetEnumPlayer()
        set udg_TempInteger=50
        call ConditionalTriggerExecute(gg_trg_Title_Grant)
    endif
endfunction

function Trig_HuntFestival_End_HasQuestCounter takes nothing returns boolean
    return(udg_HuntCounter[GetForLoopIndexA()]>0)
endfunction

function Trig_HuntFestival_End_IsBoardUnitHero takes nothing returns boolean
    return(IsUnitType(udg_HuntTarget[GetForLoopIndexA()],UNIT_TYPE_HERO))!=null
endfunction

function Trig_HuntFestival_End_HasBoardOwner takes nothing returns boolean
    return(LoadIntegerBJ(8,GetForLoopIndexA(),udg_HuntData)>0)
endfunction

function Trig_HuntFestival_End_HasActiveCounters takes nothing returns boolean
    return(udg_HuntCounter[0]>0)
endfunction

function Trig_HuntFestival_End_Actions takes nothing returns nothing
    if(Trig_HuntFestival_End_IsCinematicBusy())then
        call StartTimerBJ(udg_FestivalTimer,false,.49)
        return
    endif
    call DisableTrigger(GetTriggeringTrigger())
    call DisableTrigger(gg_trg_HuntFestival_Score)
    call DisableTrigger(gg_trg_HuntFestival_Respawn)
    call DisableTrigger(gg_trg_HuntFestival_Reorder)
    call DisableTrigger(gg_trg_HuntFestival_Teleport)
    call DisableTrigger(gg_trg_HuntFestival_KeepAway)
    set udg_FestivalWinner=LeaderboardGetIndexedPlayerBJ(1,udg_HuntFestivalBoard)
    call DestroyTimerDialogBJ(udg_FestivalTimerDialog)
    call Music_ClearTrack(36)
    call Cine_Enter()
    call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUT,1.,"ReplaceableTextures\\CameraMasks\\White_mask.blp",0,0,0,0)
    call Wait_Polled(1.5)
    call Cam_PanToUnit(gg_unit_n0CE_0020,0)
    set udg_TempPoint=GetRectCenter(gg_rct_650)
    set udg_TempPoint2=OffsetLocation(udg_TempPoint,0,128.)
    call SetUnitPositionLocFacingBJ(udg_FestivalBansat,udg_TempPoint2,45.)
    call RemoveLocation(udg_TempPoint2)
    set udg_TempPoint2=OffsetLocation(udg_TempPoint,0,-128.)
    call SetUnitPositionLocFacingBJ(udg_FestivalWard,udg_TempPoint2,45.)
    call RemoveLocation(udg_TempPoint2)
    set udg_TempPoint2=OffsetLocation(udg_TempPoint,128.,.0)
    call SetUnitPositionLocFacingBJ(udg_FestivalMonica,udg_TempPoint2,45.)
    call RemoveLocation(udg_TempPoint2)
    set udg_TempPoint2=OffsetLocation(udg_TempPoint,-128.,.0)
    call SetUnitPositionLocFacingBJ(udg_FestivalGuest,udg_TempPoint2,45.)
    call RemoveLocation(udg_TempPoint2)
    call RemoveLocation(udg_TempPoint)
    call Wait_Polled(.5)
    call CinematicFadeBJ(bj_CINEFADETYPE_FADEIN,1.,"ReplaceableTextures\\CameraMasks\\White_mask.blp",0,0,0,0)
    call Wait_Polled(1.5)
    if(Trig_HuntFestival_End_IsDialogueOn())then
        call Text_Say(gg_unit_n0CE_0020,"You've all done splendidly. This was a great festival.",false)
        call Text_Say(gg_unit_n0CE_0020,"I hope you all enjoyed yourselves as much as we did watching you.",false)
        call Text_Say(gg_unit_n0CE_0020,"Now it's time to announce the winner . . .",false)
        call Text_Transmission(gg_unit_n0CE_0020,"Montblanc","Now it's time to announce the winner . . . . . .","Now it's time to announce the winner . . .",null,0,false)
        if(Trig_HuntFestival_End_IsWinnerPlayer())then
            call Text_Transmission(gg_unit_n0CE_0020,"Montblanc",("Now it's time to announce the winner . . . . . . "+(udg_PlayerName[GetConvertedPlayerId(udg_FestivalWinner)]+"!")),"Now it's time to announce the winner . . . . . .",null,0,false)
            call Text_Say(gg_unit_n0CE_0020,"Congratulations. You truly are a great hunter indeed. I am glad you participated in this festival.",false)
            call Text_Say(Player_GetHero(udg_FestivalWinner),"Thank you, Montblanc. It was my pleasure.",false)
        else
            if(Trig_HuntFestival_End_IsWinnerGuest())then
                call Text_Transmission(gg_unit_n0CE_0020,"Montblanc",("Now it's time to announce the winner . . . . . . "+(GetUnitName(udg_FestivalGuest)+"!")),"Now it's time to announce the winner . . . . . .",null,0,false)
                call SetUnitFacingToFaceUnitTimed(udg_FestivalBansat,udg_FestivalGuest,.2)
                call SetUnitFacingToFaceUnitTimed(udg_FestivalMonica,udg_FestivalGuest,.2)
                call SetUnitFacingToFaceUnitTimed(udg_FestivalWard,udg_FestivalGuest,.2)
                call Text_Say(gg_unit_n0CE_0020,"Congratulations. You truly are a great hunter indeed. I am glad you participated in this festival.",false)
                call Text_Say(udg_FestivalGuest,"Thank you for having me, Montblanc.",false)
            else
                if(Trig_HuntFestival_End_IsWinnerMonica())then
                    call Text_Transmission(gg_unit_n0CE_0020,"Montblanc","Now it's time to announce the winner . . . . . . Monica!","Now it's time to announce the winner . . . . . .",null,0,false)
                    call SetUnitFacingToFaceUnitTimed(udg_FestivalBansat,udg_FestivalMonica,.2)
                    call SetUnitFacingToFaceUnitTimed(udg_FestivalGuest,udg_FestivalMonica,.2)
                    call SetUnitFacingToFaceUnitTimed(udg_FestivalWard,udg_FestivalMonica,.2)
                    call Text_Say(gg_unit_n0CE_0020,"Congratulations. You truly are a great hunter indeed. You've improved so much in the past years.",false)
                    call Text_Say(udg_FestivalMonica,"Thank you, Montblanc.",false)
                else
                    if(Trig_HuntFestival_End_IsWinnerBansat())then
                        call Text_Transmission(gg_unit_n0CE_0020,"Montblanc","Now it's time to announce the winner . . . . . . Bansat!","Now it's time to announce the winner . . . . . .",null,0,false)
                        call SetUnitFacingToFaceUnitTimed(udg_FestivalMonica,udg_FestivalBansat,.2)
                        call SetUnitFacingToFaceUnitTimed(udg_FestivalGuest,udg_FestivalBansat,.2)
                        call SetUnitFacingToFaceUnitTimed(udg_FestivalWard,udg_FestivalBansat,.2)
                        call Text_Say(gg_unit_n0CE_0020,"Congratulations. You truly are a great hunter indeed. You've improved so much in the past years.",false)
                        call Text_Say(udg_FestivalBansat,"Thank you, Sir Montblanc.",false)
                    else
                        if(Trig_HuntFestival_End_IsWinnerWard())then
                            call Text_Transmission(gg_unit_n0CE_0020,"Montblanc","Now it's time to announce the winner . . . . . . Ward!","Now it's time to announce the winner . . . . . .",null,0,false)
                            call SetUnitFacingToFaceUnitTimed(udg_FestivalBansat,udg_FestivalWard,.2)
                            call SetUnitFacingToFaceUnitTimed(udg_FestivalMonica,udg_FestivalWard,.2)
                            call SetUnitFacingToFaceUnitTimed(udg_FestivalGuest,udg_FestivalWard,.2)
                            call Text_Say(gg_unit_n0CE_0020,"Congratulations. You truly are a great hunter indeed. You've improved so much in the past years.",false)
                            call Text_Say(udg_FestivalWard,"Thank you, sir leader.",false)
                        endif
                    endif
                endif
            endif
        endif
        call Text_Say(gg_unit_n0CE_0020,"That is all. Thanks to the rest of you for participating, and good luck next year!",false)
    endif
    call Reward_Give(5000,5000,gg_unit_n0CE_0020)
    if(Trig_HuntFestival_End_IsWinnerPlayerPrize())then
        call QuestSetDescriptionBJ(udg_SideQuest[62],"You won the festival! Congratulations!")
        call AdjustPlayerStateBJ($4E20,udg_FestivalWinner,PLAYER_STATE_RESOURCE_GOLD) // $4E20 = 20000
        call AdjustPlayerStateBJ(4,udg_FestivalWinner,PLAYER_STATE_RESOURCE_LUMBER)
        call AddItemToStockBJ('I0I2',gg_unit_h032_0007,1,1) // 'I0I2': item "Tome of Strength"
        if(Trig_HuntFestival_End_IsDialogueOnPrize())then
            call Text_Say(gg_unit_n0CE_0020,("|n|cffffcc00"+(udg_PlayerName[GetConvertedPlayerId(udg_FestivalWinner)]+" gains an extra prize of 20000 Gold and 4 Crystal Shards.|r")),true)
        else
            call DisplayTimedTextToForce(udg_PlayingPlayers,10.,("|cffffcc00"+(udg_PlayerName[GetConvertedPlayerId(udg_FestivalWinner)]+" gains an extra prize of 20000 Gold and 4 Crystal Shards.|r")))
        endif
    else
        call QuestSetDescriptionBJ(udg_SideQuest[62],"You didn't win the festival, but great work still!")
    endif
    call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUT,1.,"ReplaceableTextures\\CameraMasks\\White_mask.blp",0,0,0,0)
    call Wait_Polled(1.5)
    call ForGroupBJ(udg_FestivalHunters,function Trig_HuntFestival_End_RemoveFestivalHunter)
    call ShowUnitShow(gg_unit_n0BW_0094)
    call ShowUnitShow(gg_unit_h030_0243)
    call ShowUnitShow(gg_unit_h02Z_0230)
    call ShowUnitShow(udg_NaishaTownUnit)
    call Wait_Polled(.5)
    call CinematicFadeBJ(bj_CINEFADETYPE_FADEIN,1.,"ReplaceableTextures\\CameraMasks\\White_mask.blp",0,0,0,0)
    call Cine_ExitAction()
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_COMPLETED,"Quest Completed: |cffffcc00Hunt Festival|r")
    call QuestSetCompletedBJ(udg_SideQuest[62],true)
    set udg_QuestsCompleted=(udg_QuestsCompleted+1)
    call ForForce(udg_PlayingPlayers,function Trig_HuntFestival_End_GrantScoreAchievement)
    call DestroyLeaderboardBJ(udg_HuntFestivalBoard)
    call Wait_Polled(1.)
    call DestroyLeaderboardBJ(udg_HuntLeaderboard)
    set udg_HuntLeaderboard=CreateLeaderboardBJ(GetPlayersAll(),"Hunt Club")
    set udg_HuntCounter[0]=(udg_HuntCounter[0]-1)
    if(Trig_HuntFestival_End_HasActiveCounters())then
        set bj_forLoopAIndex=1
        set bj_forLoopAIndexEnd=$A // $A = 10
        loop
            exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
            if(Trig_HuntFestival_End_HasQuestCounter())then
                call LeaderboardAddItemBJ(ConvertedPlayer(GetForLoopIndexA()),udg_HuntLeaderboard,udg_HuntBoardLabel[GetForLoopIndexA()],udg_HuntCounter[GetForLoopIndexA()])
                call LeaderboardSetPlayerItemLabelColorBJ(ConvertedPlayer(GetForLoopIndexA()),udg_HuntLeaderboard,65.,75.,40.,0)
                call LeaderboardSetPlayerItemValueColorBJ(ConvertedPlayer(GetForLoopIndexA()),udg_HuntLeaderboard,80.,20.,20,0)
            endif
            set bj_forLoopAIndex=bj_forLoopAIndex+1
        endloop
        set bj_forLoopAIndex=1
        set bj_forLoopAIndexEnd=28
        loop
            exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
            if(Trig_HuntFestival_End_HasBoardOwner())then
                if(Trig_HuntFestival_End_IsBoardUnitHero())then
                    call LeaderboardAddItemBJ(ConvertedPlayer(LoadIntegerBJ(8,GetForLoopIndexA(),udg_HuntData)),udg_HuntLeaderboard,GetHeroProperName(udg_HuntTarget[GetForLoopIndexA()]),0)
                else
                    call LeaderboardAddItemBJ(ConvertedPlayer(LoadIntegerBJ(8,GetForLoopIndexA(),udg_HuntData)),udg_HuntLeaderboard,GetUnitName(udg_HuntTarget[GetForLoopIndexA()]),0)
                endif
                call LeaderboardSetPlayerItemLabelColorBJ(ConvertedPlayer(LoadIntegerBJ(8,GetForLoopIndexA(),udg_HuntData)),udg_HuntLeaderboard,40.,65.,75.,0)
                call LeaderboardSetPlayerItemValueColorBJ(ConvertedPlayer(LoadIntegerBJ(8,GetForLoopIndexA(),udg_HuntData)),udg_HuntLeaderboard,.0,.0,.0,100.)
            endif
            set bj_forLoopAIndex=bj_forLoopAIndex+1
        endloop
        call LeaderboardSortItemsBJ(udg_HuntLeaderboard,bj_SORTTYPE_SORTBYVALUE,false)
        call LeaderboardDisplayBJ(true,udg_HuntLeaderboard)
    else
        call LeaderboardDisplayBJ(false,udg_HuntLeaderboard)
    endif
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_HuntFestival automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_HuntFestival (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_HuntFestival takes nothing returns nothing
endfunction

function Register_HuntFestival_Announce takes nothing returns nothing
    set gg_trg_HuntFestival_Announce=CreateTrigger()
    call DisableTrigger(gg_trg_HuntFestival_Announce)
    call TriggerRegisterTimerEventPeriodic(gg_trg_HuntFestival_Announce,20.)
    call TriggerAddCondition(gg_trg_HuntFestival_Announce,Condition(function Trig_HuntFestival_Announce_Conditions))
    call TriggerAddAction(gg_trg_HuntFestival_Announce,function Trig_HuntFestival_Announce_Actions)
endfunction

function Register_HuntFestival_Invite takes nothing returns nothing
    set gg_trg_HuntFestival_Invite=CreateTrigger()
    call DisableTrigger(gg_trg_HuntFestival_Invite)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_HuntFestival_Invite,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_HuntFestival_Invite,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_HuntFestival_Invite,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_HuntFestival_Invite,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_HuntFestival_Invite,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_HuntFestival_Invite,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_HuntFestival_Invite,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_HuntFestival_Invite,Player(7),true)
    call TriggerAddCondition(gg_trg_HuntFestival_Invite,Condition(function Trig_HuntFestival_Invite_Conditions))
    call TriggerAddAction(gg_trg_HuntFestival_Invite,function Trig_HuntFestival_Invite_Actions)
endfunction

function Register_HuntFestival_Begin takes nothing returns nothing
    set gg_trg_HuntFestival_Begin=CreateTrigger()
    call DisableTrigger(gg_trg_HuntFestival_Begin)
    call TriggerRegisterTimerExpireEventBJ(gg_trg_HuntFestival_Begin,udg_FestivalTimer)
    call TriggerAddAction(gg_trg_HuntFestival_Begin,function Trig_HuntFestival_Begin_Actions)
endfunction

function Register_HuntFestival_Teleport takes nothing returns nothing
    set gg_trg_HuntFestival_Teleport=CreateTrigger()
    call DisableTrigger(gg_trg_HuntFestival_Teleport)
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_HuntFestival_Teleport,Player(9),EVENT_PLAYER_UNIT_ATTACKED)
    call TriggerAddCondition(gg_trg_HuntFestival_Teleport,Condition(function Trig_HuntFestival_Teleport_Conditions))
    call TriggerAddAction(gg_trg_HuntFestival_Teleport,function Trig_HuntFestival_Teleport_Actions)
endfunction

function Register_HuntFestival_KeepAway takes nothing returns nothing
    set gg_trg_HuntFestival_KeepAway=CreateTrigger()
    call DisableTrigger(gg_trg_HuntFestival_KeepAway)
    call TriggerRegisterEnterRectSimple(gg_trg_HuntFestival_KeepAway,gg_rct_224)
    call TriggerRegisterEnterRectSimple(gg_trg_HuntFestival_KeepAway,gg_rct_225)
    call TriggerRegisterEnterRectSimple(gg_trg_HuntFestival_KeepAway,gg_rct_364)
    call TriggerRegisterEnterRectSimple(gg_trg_HuntFestival_KeepAway,gg_rct_374)
    call TriggerRegisterEnterRectSimple(gg_trg_HuntFestival_KeepAway,gg_rct_651)
    call TriggerRegisterEnterRectSimple(gg_trg_HuntFestival_KeepAway,gg_rct_652)
    call TriggerRegisterEnterRectSimple(gg_trg_HuntFestival_KeepAway,gg_rct_653)
    call TriggerRegisterEnterRectSimple(gg_trg_HuntFestival_KeepAway,gg_rct_654)
    call TriggerRegisterEnterRectSimple(gg_trg_HuntFestival_KeepAway,gg_rct_655)
    call TriggerRegisterEnterRectSimple(gg_trg_HuntFestival_KeepAway,gg_rct_656)
    call TriggerAddCondition(gg_trg_HuntFestival_KeepAway,Condition(function Trig_HuntFestival_KeepAway_Conditions))
    call TriggerAddAction(gg_trg_HuntFestival_KeepAway,function Trig_HuntFestival_KeepAway_Actions)
endfunction

function Register_HuntFestival_Reorder takes nothing returns nothing
    set gg_trg_HuntFestival_Reorder=CreateTrigger()
    call DisableTrigger(gg_trg_HuntFestival_Reorder)
    call TriggerRegisterTimerEventPeriodic(gg_trg_HuntFestival_Reorder,25.)
    call TriggerAddAction(gg_trg_HuntFestival_Reorder,function Trig_HuntFestival_Reorder_Actions)
endfunction

function Register_HuntFestival_Respawn takes nothing returns nothing
    set gg_trg_HuntFestival_Respawn=CreateTrigger()
    call DisableTrigger(gg_trg_HuntFestival_Respawn)
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_HuntFestival_Respawn,Player(9),EVENT_PLAYER_UNIT_DEATH)
    call TriggerAddCondition(gg_trg_HuntFestival_Respawn,Condition(function Trig_HuntFestival_Respawn_Conditions))
    call TriggerAddAction(gg_trg_HuntFestival_Respawn,function Trig_HuntFestival_Respawn_Actions)
endfunction

function Register_HuntFestival_Score takes nothing returns nothing
    set gg_trg_HuntFestival_Score=CreateTrigger()
    call DisableTrigger(gg_trg_HuntFestival_Score)
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_HuntFestival_Score,Player($B),EVENT_PLAYER_UNIT_DEATH) // $B = 11
    call TriggerAddCondition(gg_trg_HuntFestival_Score,Condition(function Trig_HuntFestival_Score_Conditions))
    call TriggerAddAction(gg_trg_HuntFestival_Score,function Trig_HuntFestival_Score_Actions)
endfunction

function Register_HuntFestival_End takes nothing returns nothing
    set gg_trg_HuntFestival_End=CreateTrigger()
    call DisableTrigger(gg_trg_HuntFestival_End)
    call TriggerRegisterTimerExpireEventBJ(gg_trg_HuntFestival_End,udg_FestivalTimer)
    call TriggerAddAction(gg_trg_HuntFestival_End,function Trig_HuntFestival_End_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_HuntFestival takes nothing returns nothing
    call Register_HuntFestival_Announce()
    call Register_HuntFestival_Invite()
    call Register_HuntFestival_Begin()
    call Register_HuntFestival_Teleport()
    call Register_HuntFestival_KeepAway()
    call Register_HuntFestival_Reorder()
    call Register_HuntFestival_Respawn()
    call Register_HuntFestival_Score()
    call Register_HuntFestival_End()
endfunction

endlibrary
