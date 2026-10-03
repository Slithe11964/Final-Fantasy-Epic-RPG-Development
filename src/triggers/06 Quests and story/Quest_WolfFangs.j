library TQuestWolfFangs requires TCam, TCine, TPlayerHero, TReward, TText, TUnit
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Quest_WolfFangs_Start=null
    trigger gg_trg_Quest_WolfFangs_TurnIn=null
    // Variables only this module uses.
    integer udg_FangsRemaining=0
endglobals

function Trig_Quest_WolfFangs_Start_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_n01R_0081,true,true,true))
endfunction

function Trig_Quest_WolfFangs_Start_Cond_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_WolfFangs_Start_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[44])
    if(Trig_Quest_WolfFangs_Start_Cond_CinematicsEnabled())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(gg_unit_n01R_0081,"Hello. I need help from a hunter. Do you happen to be the person I am looking for?",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Perhaps. What do you need?",false)
        call Text_Say(gg_unit_n01R_0081,"I need someone to hunt Wolves and bring me their fangs.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"That should not be too difficult, but will take some time. Will the reward be worth the effort?",false)
        call Text_Say(gg_unit_n01R_0081,"Of course. But there are some conditions.",false)
        call Text_Say(gg_unit_n01R_0081,"First, I only need special fangs, few Wolves have such fangs. Here, look at this fang - I only need fangs like this one.\r\n|cffffcc00Valera shows you wolf's fang|r",false)
        call Text_Say(gg_unit_n01R_0081,"And second, the fangs must be in perfect condition - I don't need damaged ones.",false)
        call Text_Say(gg_unit_n01R_0081,"I recommend you go and hunt Forest Wolves in Guardia Forest - they are weakest of their kind but still have the fangs I need.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"And how many fangs do you need?",false)
        call Text_Say(gg_unit_n01R_0081,"Three will be enough. And please remember - wolves are dangerous beasts or else I would have collected fangs myself. Good luck.",false)
        call Cine_ExitAction()
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_DISCOVERED,"New Quest Received: |cffffcc00Wolf Fangs|r")
    set udg_SideQuest[26]=CreateQuestBJ(bj_QUESTTYPE_REQ_DISCOVERED,"|cff00ffffWolf Fangs","Valera, villager from Kalm, asked you to bring him 3 wolf fangs. To get such fangs you must kill wolves, for example, Forest Wolves found in Guardia Forest.","ReplaceableTextures\\CommandButtons\\BTNINV_Misc_Bone_06.blp")
    set udg_SpecialEffect[44]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_n01R_0081,"Objects\\RandomObject\\RandomObject.mdl")
    set udg_FangsRemaining=3
    set udg_QuestReq[2]=CreateQuestItemBJ(udg_SideQuest[26],"Fangs brought to Valera: 0/3")
    call EnableTrigger(gg_trg_Quest_WolfFangs_TurnIn)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Quest_WolfFangs_TurnIn_Conditions takes nothing returns boolean
    return((UnitHasItemOfTypeBJ(GetTriggerUnit(),'I08H'))and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(udg_InCinematicMode==false))!=null // 'I08H': item "Wolf Fang"
endfunction

function Trig_Quest_WolfFangs_TurnIn_Cond_FangsToSpare takes nothing returns boolean
    return(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I08H'))>udg_TempInteger) // 'I08H': item "Wolf Fang"
endfunction

function Trig_Quest_WolfFangs_TurnIn_Cond_FangsStillNeeded takes nothing returns boolean
    return(udg_FangsRemaining>0)
endfunction

function Trig_Quest_WolfFangs_TurnIn_Cond_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_WolfFangs_TurnIn_Actions takes nothing returns nothing
    // The smaller of (udg_FangsRemaining) and (item charges of GetItemOfTypeFromUnitBJ(the triggering unit,
    // 'I08H')).
    set udg_TempInteger=IMinBJ(udg_FangsRemaining,GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I08H'))) // 'I08H': item "Wolf Fang"
    if(Trig_Quest_WolfFangs_TurnIn_Cond_FangsToSpare())then
        call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I08H'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I08H'))-udg_TempInteger)) // 'I08H': item "Wolf Fang"
    else
        call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I08H')) // 'I08H': item "Wolf Fang"
    endif
    set udg_FangsRemaining=(udg_FangsRemaining-udg_TempInteger)
    // (3) minus (udg_FangsRemaining).
    call DisplayTextToForce(GetPlayersAll(),("Fangs brought to Valera: "+(I2S((3-udg_FangsRemaining))+"/3")))
    // (3) minus (udg_FangsRemaining).
    call QuestItemSetDescriptionBJ(udg_QuestReq[2],("Fangs brought to Valera: "+(I2S((3-udg_FangsRemaining))+"/3")))
    if(Trig_Quest_WolfFangs_TurnIn_Cond_FangsStillNeeded())then
        return
    endif
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[44])
    if(Trig_Quest_WolfFangs_TurnIn_Cond_CinematicsEnabled())then
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_n01R_0081,0)
        call Text_Say(gg_unit_n01R_0081,"Thank you very much. You are a great hunter indeed.",false)
        call Reward_Give($3E8,500,gg_unit_n01R_0081) // $3E8 = 1000
        call Cine_ExitAction()
    else
        call Reward_Give($3E8,500,gg_unit_n01R_0081) // $3E8 = 1000
    endif
    call QuestItemSetCompletedBJ(udg_QuestReq[2],true)
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_COMPLETED,"Quest Completed: |cffffcc00Wolf Fangs|r")
    call QuestSetCompletedBJ(udg_SideQuest[26],true)
    set udg_QuestsCompleted=(udg_QuestsCompleted+1)
    set udg_MaterialOwnedCount[61]=(udg_MaterialOwnedCount[61]+$A) // $A = 10
    set udg_LastBazaarShop=gg_unit_n01R_0081
    call ConditionalTriggerExecute(gg_trg_Bazaar_UpdateStock)
    set udg_StoryProgress=(udg_StoryProgress+1)
    call ConditionalTriggerExecute(gg_trg_QuestCount_Milestones)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function InitTrig_Quest_WolfFangs takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Quest_Part10 (module Quest),
// which keeps the original registration order.

function Register_Quest_WolfFangs_Start takes nothing returns nothing
    set gg_trg_Quest_WolfFangs_Start=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_WolfFangs_Start)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_WolfFangs_Start,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_WolfFangs_Start,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_WolfFangs_Start,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_WolfFangs_Start,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_WolfFangs_Start,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_WolfFangs_Start,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_WolfFangs_Start,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_WolfFangs_Start,Player(7),true)
    call TriggerAddCondition(gg_trg_Quest_WolfFangs_Start,Condition(function Trig_Quest_WolfFangs_Start_Conditions))
    call TriggerAddAction(gg_trg_Quest_WolfFangs_Start,function Trig_Quest_WolfFangs_Start_Actions)
endfunction

function Register_Quest_WolfFangs_TurnIn takes nothing returns nothing
    set gg_trg_Quest_WolfFangs_TurnIn=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_WolfFangs_TurnIn)
    call TriggerRegisterUnitInRangeSimple(gg_trg_Quest_WolfFangs_TurnIn,450.,gg_unit_n01R_0081)
    call TriggerAddCondition(gg_trg_Quest_WolfFangs_TurnIn,Condition(function Trig_Quest_WolfFangs_TurnIn_Conditions))
    call TriggerAddAction(gg_trg_Quest_WolfFangs_TurnIn,function Trig_Quest_WolfFangs_TurnIn_Actions)
endfunction

endlibrary
