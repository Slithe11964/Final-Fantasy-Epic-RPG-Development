library TQuestNightElves requires TCine, TMusic, TPlayerHero, TReward, TText, TUnit
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Quest_NightElves_Start=null
    trigger gg_trg_Quest_NightElves_Complete=null
    trigger gg_trg_Quest_NightElves_Report=null
endglobals

function Trig_Quest_NightElves_Start_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_Hpb1_0013,true,true,true))
endfunction

function Trig_Quest_NightElves_Start_CameraOnCouncil takes nothing returns nothing
    call CameraSetupApplyForPlayer(true,gg_cam_001,GetEnumPlayer(),0)
endfunction

function Trig_Quest_NightElves_Start_MetNightElves takes nothing returns boolean
    return(udg_LothlorienOpen)
endfunction

function Trig_Quest_NightElves_Start_ShowCouncilScene takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_NightElves_Start_PortalStillHidden takes nothing returns boolean
    return(IsUnitHiddenBJ(gg_unit_nwgt_0142))and(udg_LothlorienOpen==false)
endfunction

function Trig_Quest_NightElves_Start_AlreadyVisitedElves takes nothing returns boolean
    return(udg_LothlorienOpen)
endfunction

function Trig_Quest_NightElves_Start_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[21])
    call GroupRemoveUnitSimple(gg_unit_Hpb1_0013,udg_QuestUnits)
    if(Trig_Quest_NightElves_Start_ShowCouncilScene())then
        call Cine_Enter()
        call ForForce(udg_PlayingPlayers,function Trig_Quest_NightElves_Start_CameraOnCouncil)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Good news. We brought an ancient artifact called the Eye of Jenova to Ao Madoushi. By using it's powers he is able to create a spell that will protect all of us from the Hashmalum's mind dominating powers. But this spell takes much of his power to maintain and he won't be able to help us anymore.",false)
        call Text_Say(gg_unit_Hpb1_0013,"A noble act indeed. We must not waste the time his efforts are buying for us. To that end, I have a request of you.",false)
        call Text_Say(udg_Mid,"100 years ago, two races worked together to rid the world of demons. We humans... and the elves.",false)
        call Text_Say(gg_unit_Hpb1_0013,"Indeed. Our ancestors worked together with the Night Elves to battle Hashmalum in the past. Unfortunately, this was long before Mid or I were even born. We have been in scarce contact with the Night Elves. But elves live much longer lifespans than humans. I would imagine many of the ones we cooperated with are still alive even now and know about this demon.",false)
        call Text_Say(gg_unit_Hpb1_0013,"We have sought counsel of the high elves in this town, but unfortunately elves who leave the forest have a much shortened lifespan. They still live longer than humans, of course, but none of the ones who took part in taking down the demon a hundred years ago are still alive today.",false)
        call Text_Say(gg_unit_Hpb1_0013,"So I ask of you. Seek out the Night Elf settlement to the south and tell them of what has happened. We need their help if we are to fight that demon.",false)
        if(Trig_Quest_NightElves_Start_MetNightElves())then
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"So we'll have to talk to that unpleasant lord and lady once more... alright, we'll seek them out and ask for their aid.",false)
        else
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"How do I find their settlement?",false)
            call Text_Say(udg_Mid,"They live on another continent from ours. But our continents have a point of connection. I've never seen it myself, but it appears to be somewhere near the Farm area.",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"Alright then. We'll make it there.",false)
        endif
        call Cine_ExitAction()
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_DISCOVERED,"New Quest Received: |cffffcc00Night Elves|r")
    set udg_MainQuest[6]=CreateQuestBJ(bj_QUESTTYPE_REQ_DISCOVERED,"|cffff8040Night Elves","Cid told you to seek the aid of Night Elves who are said to reside on a different continent to the south.","ReplaceableTextures\\CommandButtons\\BTNArcher.blp")
    if(Trig_Quest_NightElves_Start_PortalStillHidden())then
        call GroupAddUnitSimple(gg_unit_nwgt_0142,udg_QuestUnits)
    else
        call GroupAddUnitSimple(gg_unit_Emns_0156,udg_QuestUnits)
    endif
    if(Trig_Quest_NightElves_Start_AlreadyVisitedElves())then
        set udg_SpecialEffect[30]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_Emns_0156,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
        call EnableTrigger(gg_trg_Quest_NightElves_Report)
    else
        call DisableTrigger(gg_trg_Talk_Lothlorien_Greet)
        call DestroyTrigger(gg_trg_Talk_Lothlorien_Greet)
        call EnableTrigger(gg_trg_Quest_NightElves_Complete)
    endif
    set udg_QuestMarkerEffect[3]=AddSpecialEffectTargetUnitBJ("head",gg_unit_n013_0164,"Abilities\\Spells\\Other\\Silence\\SilenceTarget.mdl")
    call EnableTrigger(gg_trg_Npc_Talk_Rude)
    call AddUnitToStockBJ('n0B8',gg_unit_n0B3_0049,1,1) // 'n0B8': unit "Hunt: Tindalos"
    set udg_HuntStock[2]=(udg_HuntStock[2]+1)
    call ConditionalTriggerExecute(gg_trg_Hunt_Board_Markers)
    call ConditionalTriggerExecute(gg_trg_HealingWaters_Prepare)
    set udg_NewsText[3]=udg_NewsText[2]
    set udg_NewsText[2]=udg_NewsText[1]
    set udg_NewsText[6]=udg_NewsText[5]
    set udg_NewsText[5]=udg_NewsText[4]
    set udg_NewsText[1]="|cffffcc00Child falls ill|r"
    set udg_NewsText[4]="The son of the Tribal family has fallen terribly ill. It seems to be an unprecedented illness that our local priests cannot take care of. A heartfelt wish to please get better soon goes to little Danny!"
    set udg_StoryProgress=(udg_StoryProgress+1)
    call ConditionalTriggerExecute(gg_trg_QuestCount_Milestones)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Quest_NightElves_Complete_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_Emns_0156,true,true,true))
endfunction

function Trig_Quest_NightElves_Complete_CameraOnElfLords takes nothing returns nothing
    call CameraSetupApplyForPlayer(true,gg_cam_006,GetEnumPlayer(),0)
endfunction

function Trig_Quest_NightElves_Complete_ShowElfLordsScene takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_NightElves_Complete_IsGuardianTalkActive takes nothing returns boolean
    return(IsTriggerEnabled(gg_trg_Talk_ForestGuardian))
endfunction

function Trig_Quest_NightElves_Complete_GuardianNotMet takes nothing returns boolean
    return(udg_PortalGuardianMet==false)
endfunction

function Trig_Quest_NightElves_Complete_IsPortalStillHidden takes nothing returns boolean
    return(IsUnitHiddenBJ(gg_unit_nwgt_0142))
endfunction

function Trig_Quest_NightElves_Complete_IsSceneQueueEmpty takes nothing returns boolean
    return(udg_ShadowLoyalty<=0)
endfunction

function Trig_Quest_NightElves_Complete_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call GroupRemoveUnitSimple(gg_unit_nwgt_0142,udg_QuestUnits)
    call GroupRemoveUnitSimple(gg_unit_Emns_0156,udg_QuestUnits)
    call DestroyEffectBJ(udg_SpecialEffect[30])
    if(Trig_Quest_NightElves_Complete_ShowElfLordsScene())then
        call Cine_Enter()
        call ForForce(udg_PlayingPlayers,function Trig_Quest_NightElves_Complete_CameraOnElfLords)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Greetings to you, noble Lord and Lady.",false)
        call Text_Say(gg_unit_Emns_0156,"Why have you come to Lothlorien, human?",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"I represent here the High Elves and Men of Kalm. A great peril has befallen upon us - mighty Demon named Hashmalum threatens our very existence. Already he has gathered hordes of monsters under his command and his wrath will surely fall upon us soon.",false)
        call Text_Say(gg_unit_Etyr_0155,"Hashmalum? Know mortal that it was us who sealed him long ago in the Zodiac Stone. So now he is free.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"So you know how to defeat him then?",false)
        call Text_Say(gg_unit_Emns_0156,"We couldn't defeat him a hundred years ago - we were only able to imprison him inside the Zodiac Stone.",false)
        call Text_Say(gg_unit_Etyr_0155,"We can not let such evil walk freely upon the earth of Gaya. We must now ultimately destroy Hashmalum. But first we must locate him. Do you know where has he escaped to?",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Sorry Lady, but no idea.",false)
        call Text_Say(gg_unit_Etyr_0155,"Then I will send out scouts to search for him. It will take time but Hashmalum will eventually be found. Farewell for now.",false)
        call Reward_Give(0,$3E8,gg_unit_Etyr_0155) // $3E8 = 1000
        call Cine_ExitAction()
    else
        call Reward_Give(0,$3E8,gg_unit_Etyr_0155) // $3E8 = 1000
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_COMPLETED,"Quest Completed: |cffffcc00Night Elves|r")
    call QuestSetCompletedBJ(udg_MainQuest[6],true)
    set udg_QuestsCompleted=(udg_QuestsCompleted+1)
    set udg_LothlorienOpen=true
    call UnitAddAbilityBJ('Aneu',gg_unit_eaom_0159) // 'Aneu': standard ability reference "Neutral Building"
    call UnitAddAbilityBJ('Aneu',gg_unit_n00L_0153) // 'Aneu': standard ability reference "Neutral Building"
    call ConditionalTriggerExecute(gg_trg_Quest_LadyNashj_Available)
    call ConditionalTriggerExecute(gg_trg_DefiledFountain_Prepare)
    call ConditionalTriggerExecute(gg_trg_Liniel_ShowMarker)
    call ConditionalTriggerExecute(gg_trg_ArenaResources_Prepare)
    call ConditionalTriggerExecute(gg_trg_ShinrasPlan_Prepare)
    call ConditionalTriggerExecute(gg_trg_Krjn_ShowTalkIcon)
    if(Trig_Quest_NightElves_Complete_GuardianNotMet())then
        call UnitAddAbilityBJ('Ane2',gg_unit_Ecen_0180) // 'Ane2': object name not found in map data
        if(Trig_Quest_NightElves_Complete_IsGuardianTalkActive())then
            call DisableTrigger(gg_trg_Talk_ForestGuardian)
            call DestroyTrigger(gg_trg_Talk_ForestGuardian)
        else
            call DisableTrigger(gg_trg_Talk_PortalGuardian)
            call DestroyTrigger(gg_trg_Talk_PortalGuardian)
        endif
    else
        set udg_SpecialEffect[37]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_Ecen_0180,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    endif
    call EnableTrigger(gg_trg_Nimphrodel_Start)
    if(Trig_Quest_NightElves_Complete_IsPortalStillHidden())then
        call TriggerExecute(gg_trg_Portal_Reveal)
    endif
    call EnableTrigger(gg_trg_MysteriousCurse_Witness)
    set udg_QuestMarkerEffect[16]=AddSpecialEffectTargetUnitBJ("head",gg_unit_esen_0152,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call EnableTrigger(gg_trg_BridgeBattle_Prepare)
    if(Trig_Quest_NightElves_Complete_IsSceneQueueEmpty())then
        call TriggerExecute(gg_trg_NightElf_TalkPrepare)
    else
        call EnableTrigger(gg_trg_NightElf_TalkPrepare)
    endif
    call Music_SetZoneTrack(8)
    call StartTimerBJ(udg_StoryEventTimer,false,240.)
    call EnableTrigger(gg_trg_Cine_ScryingVision)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Quest_NightElves_Report_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_Emns_0156,true,true,true))
endfunction

function Trig_Quest_NightElves_Report_CameraOnElfCouncil takes nothing returns nothing
    call CameraSetupApplyForPlayer(true,gg_cam_006,GetEnumPlayer(),0)
endfunction

function Trig_Quest_NightElves_Report_ShowReportElvesScene takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_NightElves_Report_IsForestTalkActive takes nothing returns boolean
    return(IsTriggerEnabled(gg_trg_Talk_ForestGuardian))
endfunction

function Trig_Quest_NightElves_Report_GuardianUnmet takes nothing returns boolean
    return(udg_PortalGuardianMet==false)
endfunction

function Trig_Quest_NightElves_Report_PortalHidden takes nothing returns boolean
    return(IsUnitHiddenBJ(gg_unit_nwgt_0142))
endfunction

function Trig_Quest_NightElves_Report_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call GroupRemoveUnitSimple(gg_unit_nwgt_0142,udg_QuestUnits)
    call GroupRemoveUnitSimple(gg_unit_Emns_0156,udg_QuestUnits)
    call DestroyEffectBJ(udg_SpecialEffect[30])
    if(Trig_Quest_NightElves_Report_ShowReportElvesScene())then
        call Cine_Enter()
        call ForForce(udg_PlayingPlayers,function Trig_Quest_NightElves_Report_CameraOnElfCouncil)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Greetings to you, noble Lord and Lady.",false)
        call Text_Say(gg_unit_Emns_0156,"Is there something else you need from us, human?",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"I am not here as an adventurer this time. Now I represent here the High Elves and Men of Kalm. A great peril has befallen upon us - mighty Demon named Hashmalum threatens our very existence. Already he has gathered hordes of monsters under his command and his wrath will surely fall upon us soon.",false)
        call Text_Say(gg_unit_Etyr_0155,"Hashmalum? Know mortal that it was us who sealed him long ago in the Zodiac Stone. So now he is free.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"So you know how to defeat him then?",false)
        call Text_Say(gg_unit_Emns_0156,"We couldn't defeat him a hundred years ago - we were only able to imprison him inside the Zodiac Stone.",false)
        call Text_Say(gg_unit_Etyr_0155,"We can not let such evil walk freely upon the earth of Gaya. We must now ultimately destroy Hashmalum. But first we must locate him. Do you know where has he escaped to?",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Sorry Lady, but no idea.",false)
        call Text_Say(gg_unit_Etyr_0155,"Then I will send out scouts to search for him. It will take time but Hashmalum will eventually be found. Farewell for now.",false)
        call Reward_Give(0,$3E8,gg_unit_Etyr_0155) // $3E8 = 1000
        call Cine_ExitAction()
    else
        call Reward_Give(0,$3E8,gg_unit_Etyr_0155) // $3E8 = 1000
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_COMPLETED,"Quest Completed: |cffffcc00Night Elves|r")
    call QuestSetCompletedBJ(udg_MainQuest[6],true)
    set udg_QuestsCompleted=(udg_QuestsCompleted+1)
    call ConditionalTriggerExecute(gg_trg_ArenaResources_Prepare)
    if(Trig_Quest_NightElves_Report_GuardianUnmet())then
        call UnitAddAbilityBJ('Ane2',gg_unit_Ecen_0180) // 'Ane2': object name not found in map data
        if(Trig_Quest_NightElves_Report_IsForestTalkActive())then
            call DisableTrigger(gg_trg_Talk_ForestGuardian)
            call DestroyTrigger(gg_trg_Talk_ForestGuardian)
        else
            call DisableTrigger(gg_trg_Talk_PortalGuardian)
            call DestroyTrigger(gg_trg_Talk_PortalGuardian)
        endif
    else
        set udg_SpecialEffect[37]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_Ecen_0180,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    endif
    call EnableTrigger(gg_trg_Nimphrodel_Start)
    if(Trig_Quest_NightElves_Report_PortalHidden())then
        call TriggerExecute(gg_trg_Portal_Reveal)
    endif
    call Music_SetZoneTrack(8)
    call StartTimerBJ(udg_StoryEventTimer,false,75.)
    call EnableTrigger(gg_trg_Cine_ScryingVision)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function InitTrig_Quest_NightElves takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Quest_Part2, RegisterTriggers_Quest_Part3, RegisterTriggers_Quest_Part4 (module Quest),
// which keeps the original registration order.

function Register_Quest_NightElves_Start takes nothing returns nothing
    set gg_trg_Quest_NightElves_Start=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_NightElves_Start)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_NightElves_Start,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_NightElves_Start,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_NightElves_Start,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_NightElves_Start,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_NightElves_Start,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_NightElves_Start,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_NightElves_Start,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_NightElves_Start,Player(7),true)
    call TriggerAddCondition(gg_trg_Quest_NightElves_Start,Condition(function Trig_Quest_NightElves_Start_Conditions))
    call TriggerAddAction(gg_trg_Quest_NightElves_Start,function Trig_Quest_NightElves_Start_Actions)
endfunction

function Register_Quest_NightElves_Complete takes nothing returns nothing
    set gg_trg_Quest_NightElves_Complete=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_NightElves_Complete)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_NightElves_Complete,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_NightElves_Complete,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_NightElves_Complete,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_NightElves_Complete,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_NightElves_Complete,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_NightElves_Complete,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_NightElves_Complete,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_NightElves_Complete,Player(7),true)
    call TriggerAddCondition(gg_trg_Quest_NightElves_Complete,Condition(function Trig_Quest_NightElves_Complete_Conditions))
    call TriggerAddAction(gg_trg_Quest_NightElves_Complete,function Trig_Quest_NightElves_Complete_Actions)
endfunction

function Register_Quest_NightElves_Report takes nothing returns nothing
    set gg_trg_Quest_NightElves_Report=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_NightElves_Report)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_NightElves_Report,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_NightElves_Report,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_NightElves_Report,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_NightElves_Report,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_NightElves_Report,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_NightElves_Report,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_NightElves_Report,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_NightElves_Report,Player(7),true)
    call TriggerAddCondition(gg_trg_Quest_NightElves_Report,Condition(function Trig_Quest_NightElves_Report_Conditions))
    call TriggerAddAction(gg_trg_Quest_NightElves_Report,function Trig_Quest_NightElves_Report_Actions)
endfunction

endlibrary
