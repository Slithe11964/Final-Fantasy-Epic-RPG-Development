library TCartographer requires TCam, TCine, TPlayerHero, TReward, TText, TUnit
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Cartographer_Prepare=null
    trigger gg_trg_Cartographer_Start=null
    trigger gg_trg_Cartographer_Update=null
    trigger gg_trg_Cartographer_Report=null
    trigger gg_trg_Cartographer_Fail=null
    // Variables only this module uses.
    integer udg_MapRewardStage=0
    real udg_MapExploredPct=0
endglobals

function Trig_Cartographer_Prepare_Conditions takes nothing returns boolean
    return(udg_InCinematicMode==false)and(IsQuestCompleted(udg_MainQuest[1]))and(udg_CommonHuntsDone>0)
endfunction

function Trig_Cartographer_Prepare_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    set udg_SpecialEffect[82]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_n0CE_0020,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call EnableTrigger(gg_trg_Cartographer_Start)
    set udg_MontblancHasNews=true
    set udg_MapExploredPct=.0
    set udg_MapRewardStage=0
    set udg_MapRewardTier[0]=$3E8 // $3E8 = 1000
    set udg_MapRewardTier[1]=$7D0 // $7D0 = 2000
    set udg_MapRewardTier[2]=$BB8 // $BB8 = 3000
    set udg_MapRewardTier[3]=$FA0 // $FA0 = 4000
    set udg_MapRewardTier[4]=6000
    set udg_MapRewardTier[5]=8000
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Cartographer_Start_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_n0CE_0020,true,true,true))
endfunction

function Trig_Cartographer_Start_HasMapProgress_Quiet takes nothing returns boolean
    return(udg_MapExploredPct>=15.)
endfunction

function Trig_Cartographer_Start_IsMapComplete_Quiet takes nothing returns boolean
    return(udg_MapExploredPct>=90.)
endfunction

function Trig_Cartographer_Start_HasMapProgress_Talk takes nothing returns boolean
    return(udg_MapExploredPct>=15.)
endfunction

function Trig_Cartographer_Start_IsMapComplete_Talk takes nothing returns boolean
    return(udg_MapExploredPct>=90.)
endfunction

function Trig_Cartographer_Start_IsDialogueOn takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Cartographer_Start_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[82])
    set udg_SideQuest[61]=CreateQuestBJ(bj_QUESTTYPE_REQ_DISCOVERED,(udg_QuestNamePrefix+"Cartographer"),"Montblanc, leader of the Hunt Club, has tasked you with mapping out Gaya. Explore as much of the world as you can and report your progress to him!","ReplaceableTextures\\CommandButtons\\BTNSpy.blp")
    set udg_QuestReq[6]=CreateQuestItemBJ(udg_SideQuest[61],"Explored: 0.00%")
    call ConditionalTriggerExecute(gg_trg_Cartographer_Update)
    if(Trig_Cartographer_Start_IsDialogueOn())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(gg_unit_n0CE_0020,"Good day, adventurers. My name is Montblanc, I am the leader of the Hunt Club that is active all over Gaya.",false)
        call Text_Say(gg_unit_n0CE_0020,"First I'd like to thank you for your contributions to our club. Your help is greatly appreciated, and I hope you will continue doing tasks for us.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"It's been our pleasure. So is there something the club leader himself wishes to ask of us?",false)
        call Text_Say(gg_unit_n0CE_0020,"There is. I believe you are perfect for this particular job.",false)
        call Text_Say(gg_unit_n0CE_0020,"While we of the Hunt Club are active all over Gaya, each of us merely specializes in governing a particular area for monsters. However we've been increasingly pressured to create a map of the world as well.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"A map of the world?",false)
        call Text_Say(gg_unit_n0CE_0020,"Yes. But we are hunters, not cartographers, and every one of our member is specialized on their particular region so even if we tried, we would struggle to pool all our knowledge of the world together into one big map.",false)
        call Text_Say(gg_unit_n0CE_0020,"But you are an adventurer - you intend on exploring this whole world, don't you? And so I'd like to hire you to make this map for us.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"I see. We are certainly interested in traveling the world so I see why you picked us. But making a full map is no easy task. I hope you don't expect us to do this for free.",false)
        call Text_Say(gg_unit_n0CE_0020,"Of course not. Truth be told, Cid has decided to sponsor this project by giving us a budget of 30000 Gold to work with. I'd be willing to split it 80:20 in your favor if you are willing to take this task.",false)
        call Text_Say(gg_unit_n0CE_0020,"That would make the deal 24000 Gold for a complete map. And I'd gladly give you the reward in portions if you come report your progress to me periodically. Does that sound acceptable?",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"That's a very tempting offer. Sure, we'll do it!",false)
        call Text_Say(gg_unit_n0CE_0020,"Glad to hear it.",false)
        if(Trig_Cartographer_Start_IsMapComplete_Talk())then
            call Text_Say(gg_unit_n0CE_0020,"Wow, your map is already incredibly detailed. I am very impressed.",false)
            call Text_Say(gg_unit_n0CE_0020,"Here, I will gladly buy it from you right here and now.",false)
            call Reward_Give($5DC0,$5DC0,gg_unit_n0CE_0020) // $5DC0 = 24000
            call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_COMPLETED,"Quest Completed: |cffffcc00Cartographer|r")
            call QuestSetCompletedBJ(udg_SideQuest[61],true)
            call QuestItemSetDescriptionBJ(udg_QuestReq[6],"Sufficiently explored!")
            call QuestItemSetCompletedBJ(udg_QuestReq[6],true)
            set udg_QuestsCompleted=(udg_QuestsCompleted+1)
            call DestroyTrigger(gg_trg_Cartographer_Update)
            call DestroyTrigger(gg_trg_Cartographer_Report)
        else
            if(Trig_Cartographer_Start_HasMapProgress_Talk())then
                call Text_Say(gg_unit_n0CE_0020,"It seems you've already mapped out a decent amount of our world.",false)
                call Text_Say(gg_unit_n0CE_0020,"Here, have this. There will be more where that came from the more complete your map becomes.",false)
                set udg_TempInteger=0
                set bj_forLoopAIndex=udg_MapRewardStage
                // (((udg_MapExploredPct) with its decimal part removed) divided by (15)) minus (1).
                set bj_forLoopAIndexEnd=((R2I(udg_MapExploredPct)/ $F)-1) // $F = 15
                loop
                    exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
                    // (udg_TempInteger) plus (udg_MapRewardTier at position loop counter A).
                    set udg_TempInteger=(udg_TempInteger+udg_MapRewardTier[GetForLoopIndexA()])
                    set bj_forLoopAIndex=bj_forLoopAIndex+1
                endloop
                // ((udg_MapExploredPct) with its decimal part removed) divided by (15).
                set udg_MapRewardStage=(R2I(udg_MapExploredPct)/ $F) // $F = 15
                call Reward_Give(udg_TempInteger,udg_TempInteger,gg_unit_n0CE_0020)
            else
                call Text_Say(gg_unit_n0CE_0020,"Come to me periodically when you've mapped out a significant part of our world. I will give you your rewards then.",false)
            endif
            call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_DISCOVERED,"New Quest Received: |cffffcc00Cartographer|r")
            set udg_SpecialEffect[82]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_n0CE_0020,"Objects\\RandomObject\\RandomObject.mdl")
            call EnableTrigger(gg_trg_Cartographer_Update)
        endif
        call Cine_ExitAction()
    else
        if(Trig_Cartographer_Start_IsMapComplete_Quiet())then
            call Reward_Give($5DC0,$5DC0,gg_unit_n0CE_0020) // $5DC0 = 24000
            call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_COMPLETED,"Quest Completed: |cffffcc00Cartographer|r")
            call QuestSetCompletedBJ(udg_SideQuest[61],true)
            call QuestItemSetDescriptionBJ(udg_QuestReq[6],"Sufficiently explored!")
            call QuestItemSetCompletedBJ(udg_QuestReq[6],true)
            set udg_QuestsCompleted=(udg_QuestsCompleted+1)
            call DestroyTrigger(gg_trg_Cartographer_Update)
            call DestroyTrigger(gg_trg_Cartographer_Report)
        else
            if(Trig_Cartographer_Start_HasMapProgress_Quiet())then
                set udg_TempInteger=0
                set bj_forLoopAIndex=udg_MapRewardStage
                // (((udg_MapExploredPct) with its decimal part removed) divided by (15)) minus (1).
                set bj_forLoopAIndexEnd=((R2I(udg_MapExploredPct)/ $F)-1) // $F = 15
                loop
                    exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
                    // (udg_TempInteger) plus (udg_MapRewardTier at position loop counter A).
                    set udg_TempInteger=(udg_TempInteger+udg_MapRewardTier[GetForLoopIndexA()])
                    set bj_forLoopAIndex=bj_forLoopAIndex+1
                endloop
                // ((udg_MapExploredPct) with its decimal part removed) divided by (15).
                set udg_MapRewardStage=(R2I(udg_MapExploredPct)/ $F) // $F = 15
                call Reward_Give(udg_TempInteger,udg_TempInteger,gg_unit_n0CE_0020)
            endif
            call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_DISCOVERED,"New Quest Received: |cffffcc00Cartographer|r")
            set udg_SpecialEffect[82]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_n0CE_0020,"Objects\\RandomObject\\RandomObject.mdl")
            call EnableTrigger(gg_trg_Cartographer_Update)
        endif
    endif
    set udg_MontblancHasNews=false
    set udg_SpecialEffect[84]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_h032_0007,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call EnableTrigger(gg_trg_Makenroh_Greet)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Cartographer_Update_Conditions takes nothing returns boolean
    return(udg_InCinematicMode==false)
endfunction

function Trig_Cartographer_Update_IsFogOff takes nothing returns boolean
    return(IsFogEnabled()==false)
endfunction

function Trig_Cartographer_Update_IsFogMaskOff takes nothing returns boolean
    return(IsFogMaskEnabled()==false)
endfunction

function Trig_Cartographer_Update_IsFogCheat takes nothing returns boolean
    return(GetBooleanOr(Trig_Cartographer_Update_IsFogOff(),Trig_Cartographer_Update_IsFogMaskOff()))
endfunction

function Trig_Cartographer_Update_IsReportIdle takes nothing returns boolean
    return(udg_MontblancHasNews==false)
endfunction

function Trig_Cartographer_Update_IsFogCheatFlagged takes nothing returns boolean
    return(udg_FogDisabled)
endfunction

function Trig_Cartographer_Update_IsPointExplored takes nothing returns boolean
    return(IsLocationMaskedToPlayer(udg_TempPoint,udg_TempPlayer)==false)
endfunction

function Trig_Cartographer_Update_IsMapQuestActive takes nothing returns boolean
    return(IsQuestDiscovered(udg_SideQuest[61]))
endfunction

function Trig_Cartographer_Update_HasNewRewardTier takes nothing returns boolean
    // ((udg_MapExploredPct) with its decimal part removed) divided by (15).
    return((R2I(udg_MapExploredPct)/ $F)>udg_MapRewardStage)and(udg_MontblancHasNews==false) // $F = 15
endfunction

function Trig_Cartographer_Update_Actions takes nothing returns nothing
    if(Trig_Cartographer_Update_IsFogCheat())then
        set udg_FogDisabled=true
    endif
    if(Trig_Cartographer_Update_IsFogCheatFlagged())then
        if(Trig_Cartographer_Update_IsReportIdle())then
            call DisableTrigger(GetTriggeringTrigger())
            call QuestItemSetDescriptionBJ(udg_QuestReq[6],"Cancelled")
            call DestroyEffectBJ(udg_SpecialEffect[82])
            set udg_SpecialEffect[82]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_n0CE_0020,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
            set udg_MontblancHasNews=true
            call EnableTrigger(gg_trg_Cartographer_Fail)
            call DestroyTrigger(gg_trg_Cartographer_Report)
            call DestroyTrigger(GetTriggeringTrigger())
        endif
        return
    endif
    set udg_TempPlayer=ForcePickRandomPlayer(udg_PlayingPlayers)
    set udg_TempInteger=0
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=50
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        set bj_forLoopBIndex=1
        set bj_forLoopBIndexEnd=50
        loop
            exitwhen bj_forLoopBIndex>bj_forLoopBIndexEnd
            // Calculation 1:
            // Result 1: loop counter A treated as a decimal-capable number.
            // Result 2: (GetRectWidthBJ(GetPlayableMapRect())) times (0.02).
            // Result 3: (result 1) times (result 2).
            // Result 4: (GetRectMinX(GetPlayableMapRect())) plus (result 3).
            // Calculation 2:
            // Result 1: loop counter B treated as a decimal-capable number.
            // Result 2: (GetRectHeightBJ(GetPlayableMapRect())) times (0.02).
            // Result 3: (result 1) times (result 2).
            // Result 4: (GetRectMinY(GetPlayableMapRect())) plus (result 3).
            set udg_TempPoint=Location((GetRectMinX(GetPlayableMapRect())+(I2R(GetForLoopIndexA())*(GetRectWidthBJ(GetPlayableMapRect())*.02))),(GetRectMinY(GetPlayableMapRect())+(I2R(GetForLoopIndexB())*(GetRectHeightBJ(GetPlayableMapRect())*.02))))
            if(Trig_Cartographer_Update_IsPointExplored())then
                set udg_TempInteger=(udg_TempInteger+1)
            endif
            call RemoveLocation(udg_TempPoint)
            set bj_forLoopBIndex=bj_forLoopBIndex+1
        endloop
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    // (udg_TempInteger treated as a decimal-capable number) times (0.04).
    set udg_MapExploredPct=(I2R(udg_TempInteger)*.04)
    if(Trig_Cartographer_Update_IsMapQuestActive())then
        call QuestItemSetDescriptionBJ(udg_QuestReq[6],("Explored: "+(R2SW(udg_MapExploredPct,3,2)+"%")))
    endif
    if(Trig_Cartographer_Update_HasNewRewardTier())then
        call DestroyEffectBJ(udg_SpecialEffect[82])
        set udg_SpecialEffect[82]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_n0CE_0020,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
        set udg_MontblancHasNews=true
        call EnableTrigger(gg_trg_Cartographer_Report)
    endif
endfunction

function Trig_Cartographer_Report_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_n0CE_0020,true,true,true))
endfunction

function Trig_Cartographer_Report_IsMapDone_Quiet takes nothing returns boolean
    return(udg_MapRewardStage>=6)
endfunction

function Trig_Cartographer_Report_IsMapDone_Talk takes nothing returns boolean
    return(udg_MapRewardStage>=6)
endfunction

function Trig_Cartographer_Report_IsDialogueOn takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Cartographer_Report_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call ConditionalTriggerExecute(gg_trg_Cartographer_Update)
    call DestroyEffectBJ(udg_SpecialEffect[82])
    if(Trig_Cartographer_Report_IsDialogueOn())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(gg_unit_n0CE_0020,"Hello, have you come to report your progress? Let me see...",false)
        call Text_Say(gg_unit_n0CE_0020,"Hmm yes, you've done well. As promised, here's a reward.",false)
        set udg_TempInteger=0
        set bj_forLoopAIndex=udg_MapRewardStage
        // (((udg_MapExploredPct) with its decimal part removed) divided by (15)) minus (1).
        set bj_forLoopAIndexEnd=((R2I(udg_MapExploredPct)/ $F)-1) // $F = 15
        loop
            exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
            // (udg_TempInteger) plus (udg_MapRewardTier at position loop counter A).
            set udg_TempInteger=(udg_TempInteger+udg_MapRewardTier[GetForLoopIndexA()])
            set bj_forLoopAIndex=bj_forLoopAIndex+1
        endloop
        // ((udg_MapExploredPct) with its decimal part removed) divided by (15).
        set udg_MapRewardStage=(R2I(udg_MapExploredPct)/ $F) // $F = 15
        call Reward_GiveAll(udg_TempInteger,udg_TempInteger,gg_unit_n0CE_0020)
        if(Trig_Cartographer_Report_IsMapDone_Talk())then
            call DisableTrigger(gg_trg_Cartographer_Update)
            call Text_Say(gg_unit_n0CE_0020,"You've done well. This map is now detailed enough for our purposes.",false)
            call Text_Say(gg_unit_n0CE_0020,"Allow me to express my deepest gratitude. Without your help, this would have been a most arduous task for our club.",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"It was nothing at all!",false)
            call Text_Say(gg_unit_n0CE_0020,"Haha, you truly are adventurers. Your spirit is enviable.",false)
            call Text_Say(gg_unit_n0CE_0020,"Do come talk to me again sometime. You've been a valuable ally to the Hunt Club, you're welcome among us anytime.",false)
            call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_COMPLETED,"Quest Completed: |cffffcc00Cartographer|r")
            call QuestSetCompletedBJ(udg_SideQuest[61],true)
            call QuestItemSetDescriptionBJ(udg_QuestReq[6],"Sufficiently explored!")
            call QuestItemSetCompletedBJ(udg_QuestReq[6],true)
            set udg_QuestsCompleted=(udg_QuestsCompleted+1)
            call DestroyTrigger(gg_trg_Cartographer_Update)
            call DestroyTrigger(gg_trg_Cartographer_Fail)
            call Cine_ExitAction()
            set udg_MontblancHasNews=false
            call DestroyTrigger(GetTriggeringTrigger())
        else
            call Text_Say(gg_unit_n0CE_0020,"Please keep exploring!",false)
            set udg_SpecialEffect[82]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_n0CE_0020,"Objects\\RandomObject\\RandomObject.mdl")
            call Cine_ExitAction()
            set udg_MontblancHasNews=false
        endif
    else
        set udg_MontblancHasNews=false
        set udg_TempInteger=0
        set bj_forLoopAIndex=udg_MapRewardStage
        // (((udg_MapExploredPct) with its decimal part removed) divided by (15)) minus (1).
        set bj_forLoopAIndexEnd=((R2I(udg_MapExploredPct)/ $F)-1) // $F = 15
        loop
            exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
            // (udg_TempInteger) plus (udg_MapRewardTier at position loop counter A).
            set udg_TempInteger=(udg_TempInteger+udg_MapRewardTier[GetForLoopIndexA()])
            set bj_forLoopAIndex=bj_forLoopAIndex+1
        endloop
        // ((udg_MapExploredPct) with its decimal part removed) divided by (15).
        set udg_MapRewardStage=(R2I(udg_MapExploredPct)/ $F) // $F = 15
        call Reward_GiveAll(udg_TempInteger,udg_TempInteger,gg_unit_n0CE_0020)
        if(Trig_Cartographer_Report_IsMapDone_Quiet())then
            call DisableTrigger(gg_trg_Cartographer_Update)
            call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_COMPLETED,"Quest Completed: |cffffcc00Cartographer|r")
            call QuestSetCompletedBJ(udg_SideQuest[61],true)
            call QuestItemSetDescriptionBJ(udg_QuestReq[6],"Sufficiently explored!")
            call QuestItemSetCompletedBJ(udg_QuestReq[6],true)
            set udg_QuestsCompleted=(udg_QuestsCompleted+1)
            call DestroyTrigger(gg_trg_Cartographer_Update)
            call DestroyTrigger(gg_trg_Cartographer_Fail)
            call DestroyTrigger(GetTriggeringTrigger())
        else
            set udg_SpecialEffect[82]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_n0CE_0020,"Objects\\RandomObject\\RandomObject.mdl")
        endif
    endif
endfunction

function Trig_Cartographer_Fail_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_n0CE_0020,true,true,true))
endfunction

function Trig_Cartographer_Fail_IsDialogueOn takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Cartographer_Fail_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[82])
    if(Trig_Cartographer_Fail_IsDialogueOn())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(gg_unit_n0CE_0020,"Hello, have you come to report your progress? Let me see...",false)
        call Text_Say(gg_unit_n0CE_0020,"Hmm yes... wait what? No, no, this won't do at all.",false)
        call Text_Say(gg_unit_n0CE_0020,"This is a plagiarized map, isn't it? You aren't the one who discovered all of this.",false)
        call Text_Say(gg_unit_n0CE_0020,"Sorry, the deal is off. I'll find another to take on this job. Good day.",false)
        call Cine_ExitAction()
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_FAILED,"Quest Failed: |cffffcc00Cartographer|r")
    call QuestSetFailedBJ(udg_SideQuest[61],true)
    set udg_QuestsTotal=(udg_QuestsTotal-1)
    set udg_MontblancHasNews=false
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_Cartographer automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Cartographer (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Cartographer takes nothing returns nothing
endfunction

function Register_Cartographer_Prepare takes nothing returns nothing
    set gg_trg_Cartographer_Prepare=CreateTrigger()
    call TriggerRegisterTimerEventPeriodic(gg_trg_Cartographer_Prepare,4.)
    call TriggerAddCondition(gg_trg_Cartographer_Prepare,Condition(function Trig_Cartographer_Prepare_Conditions))
    call TriggerAddAction(gg_trg_Cartographer_Prepare,function Trig_Cartographer_Prepare_Actions)
endfunction

function Register_Cartographer_Start takes nothing returns nothing
    set gg_trg_Cartographer_Start=CreateTrigger()
    call DisableTrigger(gg_trg_Cartographer_Start)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Cartographer_Start,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Cartographer_Start,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Cartographer_Start,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Cartographer_Start,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Cartographer_Start,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Cartographer_Start,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Cartographer_Start,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Cartographer_Start,Player(7),true)
    call TriggerAddCondition(gg_trg_Cartographer_Start,Condition(function Trig_Cartographer_Start_Conditions))
    call TriggerAddAction(gg_trg_Cartographer_Start,function Trig_Cartographer_Start_Actions)
endfunction

function Register_Cartographer_Update takes nothing returns nothing
    set gg_trg_Cartographer_Update=CreateTrigger()
    call DisableTrigger(gg_trg_Cartographer_Update)
    call TriggerRegisterTimerEventPeriodic(gg_trg_Cartographer_Update,5.)
    call TriggerAddCondition(gg_trg_Cartographer_Update,Condition(function Trig_Cartographer_Update_Conditions))
    call TriggerAddAction(gg_trg_Cartographer_Update,function Trig_Cartographer_Update_Actions)
endfunction

function Register_Cartographer_Report takes nothing returns nothing
    set gg_trg_Cartographer_Report=CreateTrigger()
    call DisableTrigger(gg_trg_Cartographer_Report)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Cartographer_Report,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Cartographer_Report,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Cartographer_Report,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Cartographer_Report,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Cartographer_Report,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Cartographer_Report,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Cartographer_Report,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Cartographer_Report,Player(7),true)
    call TriggerAddCondition(gg_trg_Cartographer_Report,Condition(function Trig_Cartographer_Report_Conditions))
    call TriggerAddAction(gg_trg_Cartographer_Report,function Trig_Cartographer_Report_Actions)
endfunction

function Register_Cartographer_Fail takes nothing returns nothing
    set gg_trg_Cartographer_Fail=CreateTrigger()
    call DisableTrigger(gg_trg_Cartographer_Fail)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Cartographer_Fail,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Cartographer_Fail,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Cartographer_Fail,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Cartographer_Fail,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Cartographer_Fail,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Cartographer_Fail,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Cartographer_Fail,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Cartographer_Fail,Player(7),true)
    call TriggerAddCondition(gg_trg_Cartographer_Fail,Condition(function Trig_Cartographer_Fail_Conditions))
    call TriggerAddAction(gg_trg_Cartographer_Fail,function Trig_Cartographer_Fail_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Cartographer takes nothing returns nothing
    call Register_Cartographer_Prepare()
    call Register_Cartographer_Start() // starts off; enabled by Cartographer
    call Register_Cartographer_Update() // starts off; enabled by Cartographer; disabled by Cartographer; run by Cartographer; destroyed by Cartographer
    call Register_Cartographer_Report() // starts off; enabled by Cartographer; destroyed by Cartographer
    call Register_Cartographer_Fail() // starts off; enabled by Cartographer; destroyed by Cartographer
endfunction

endlibrary
