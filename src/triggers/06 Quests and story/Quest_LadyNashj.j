library TQuestLadyNashj requires TCam, TCine, TPlayerHero, TReward, TText, TUnit
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Quest_LadyNashj_Init=null
    trigger gg_trg_Quest_LadyNashj_Available=null
    trigger gg_trg_Quest_LadyNashj_Start=null
    trigger gg_trg_Quest_LadyNashj_Slain=null
    trigger gg_trg_Quest_LadyNashj_Complete=null
    // Variables only this module uses.
    boolean udg_NashjDead=false
endglobals

function Trig_Quest_LadyNashj_Init_Actions takes nothing returns nothing
    call ShowUnitHide(gg_unit_Hvsh_0145)
    call SetUnitInvulnerable(gg_unit_Hvsh_0145,true)
    call PauseUnitBJ(true,gg_unit_Hvsh_0145)
    set udg_NashjDead=false
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Quest_LadyNashj_Available_Actions takes nothing returns nothing
    set udg_SpecialEffect[31]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_eshd_0143,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call EnableTrigger(gg_trg_Quest_LadyNashj_Start)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Quest_LadyNashj_Start_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_eshd_0143,true,true,true))
endfunction

function Trig_Quest_LadyNashj_Start_Cond_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_LadyNashj_Start_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[31])
    if(Trig_Quest_LadyNashj_Start_Cond_CinematicsEnabled())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(gg_unit_eshd_0143,"Welcome to Lothlorien. I am Lenna, master ranger.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"You seem troubled. Do you need help?",false)
        call Text_Say(gg_unit_eshd_0143,"In fact, I do. The Naga, our evil neighbours, ceaselessly attack our fishing ships. Their Matriarch, Lady Nashj, commands them to do so. We are not strong enough to fight Naga but here, in Lothlorien, we are protected by ancient magic of the forest.",false)
        call Text_Say(gg_unit_eshd_0143,"Lady Nashj herself unfortunately also has special protection of waters and can't be seen without this charm here. If you feel strong enough I will give it to you so you can try assasinating her. If you succeed a great reward will be given to you.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Sure, we'll take your charm and hunt down this sea witch.",false)
        call Text_Say(gg_unit_eshd_0143,"You have my gratitude. Here's the charm and good luck to you.",false)
        call Cine_ExitAction()
    endif
    set udg_SideQuest[$C]=CreateQuestBJ(bj_QUESTTYPE_REQ_DISCOVERED,(udg_QuestNamePrefix+"Lady Nashj"),"Lenna, ranger from Lothlorien, asked you to slay evil Naga Matriarch named Lady Nashj.","ReplaceableTextures\\CommandButtons\\BTNNagaSeaWitch.blp") // $C = 12
    set udg_QuestItem[27]=UnitAddItemByIdSwapped('I0BO',Player_GetHero(GetTriggerPlayer())) // 'I0BO': item "Grattheos Charm"
    call SetItemInvulnerableBJ(GetLastCreatedItem(),true)
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_DISCOVERED,"New Quest Received: |cffffcc00Lady Nashj|r")
    set udg_SpecialEffect[31]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_eshd_0143,"Objects\\RandomObject\\RandomObject.mdl")
    call ShowUnitShow(gg_unit_Hvsh_0145)
    call SetUnitInvulnerable(gg_unit_Hvsh_0145,false)
    call PauseUnitBJ(false,gg_unit_Hvsh_0145)
    call GroupAddUnitSimple(gg_unit_Hvsh_0145,udg_BossUnits)
    call EnableTrigger(gg_trg_Quest_LadyNashj_Slain)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Quest_LadyNashj_Slain_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    set udg_NashjDead=true
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_BossUnits)
    call SaveIntegerBJ(1,2,'i',udg_GameStateHash)
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateItemLoc('I00I',udg_TempPoint) // 'I00I': item "Germinas Boots"
    call CreateItemLoc('I0HS',udg_TempPoint) // 'I0HS': item "Maiden's Eye"
    call SetItemInvulnerableBJ(GetLastCreatedItem(),true)
    call RemoveLocation(udg_TempPoint)
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_UPDATED,"Come back to Lenna for reward.")
    call QuestSetDescriptionBJ(udg_SideQuest[$C],"Come back to Lenna for reward.") // $C = 12
    call EnableTrigger(gg_trg_Quest_LadyNashj_Complete)
    call ConditionalTriggerExecute(gg_trg_Dana_Prepare)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Quest_LadyNashj_Complete_Conditions takes nothing returns boolean
    return((IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(GetUnitTypeId(GetTriggerUnit())!='H01D')and(udg_InCinematicMode==false))!=null // 'H01D': unit "Spirit of Gaya"
endfunction

function Trig_Quest_LadyNashj_Complete_Cond_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_LadyNashj_Complete_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[31])
    if(Trig_Quest_LadyNashj_Complete_Cond_CinematicsEnabled())then
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_eshd_0143,0)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"Lady Nashj is dead. I don't know if Naga will stop harassing your ships but our part of the deal is done.",false)
        call Text_Say(gg_unit_eshd_0143,"I hope it will help. Thank you very much.",false)
        call Reward_Give($BB8,$9C4,gg_unit_eshd_0143) // $BB8 = 3000; $9C4 = 2500
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"So, do you want your charm back now?",false)
        call Text_Say(gg_unit_eshd_0143,"No, you can just throw it away. It proved to be invaluable this time but to be honest it's known as a charm of misfortune amongst our kind. None of us fully understand how it works either.",false)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"A charm of misfortune? Curious how it was the key to finding this witch nonetheless.",false)
        call Cine_ExitAction()
    else
        call Reward_Give($BB8,$9C4,gg_unit_eshd_0143) // $BB8 = 3000; $9C4 = 2500
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_COMPLETED,"Quest Completed: |cffffcc00Lady Nashj|r")
    call QuestSetCompletedBJ(udg_SideQuest[$C],true) // $C = 12
    set udg_QuestsCompleted=(udg_QuestsCompleted+1)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function InitTrig_Quest_LadyNashj takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Quest_Part9 (module Quest),
// which keeps the original registration order.

function Register_Quest_LadyNashj_Init takes nothing returns nothing
    set gg_trg_Quest_LadyNashj_Init=CreateTrigger()
    call TriggerAddAction(gg_trg_Quest_LadyNashj_Init,function Trig_Quest_LadyNashj_Init_Actions)
endfunction

function Register_Quest_LadyNashj_Available takes nothing returns nothing
    set gg_trg_Quest_LadyNashj_Available=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_LadyNashj_Available)
    call TriggerAddAction(gg_trg_Quest_LadyNashj_Available,function Trig_Quest_LadyNashj_Available_Actions)
endfunction

function Register_Quest_LadyNashj_Start takes nothing returns nothing
    set gg_trg_Quest_LadyNashj_Start=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_LadyNashj_Start)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_LadyNashj_Start,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_LadyNashj_Start,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_LadyNashj_Start,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_LadyNashj_Start,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_LadyNashj_Start,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_LadyNashj_Start,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_LadyNashj_Start,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_LadyNashj_Start,Player(7),true)
    call TriggerAddCondition(gg_trg_Quest_LadyNashj_Start,Condition(function Trig_Quest_LadyNashj_Start_Conditions))
    call TriggerAddAction(gg_trg_Quest_LadyNashj_Start,function Trig_Quest_LadyNashj_Start_Actions)
endfunction

function Register_Quest_LadyNashj_Slain takes nothing returns nothing
    set gg_trg_Quest_LadyNashj_Slain=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_LadyNashj_Slain)
    call TriggerRegisterUnitEvent(gg_trg_Quest_LadyNashj_Slain,gg_unit_Hvsh_0145,EVENT_UNIT_DEATH)
    call TriggerAddAction(gg_trg_Quest_LadyNashj_Slain,function Trig_Quest_LadyNashj_Slain_Actions)
endfunction

function Register_Quest_LadyNashj_Complete takes nothing returns nothing
    set gg_trg_Quest_LadyNashj_Complete=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_LadyNashj_Complete)
    call TriggerRegisterUnitInRangeSimple(gg_trg_Quest_LadyNashj_Complete,450.,gg_unit_eshd_0143)
    call TriggerAddCondition(gg_trg_Quest_LadyNashj_Complete,Condition(function Trig_Quest_LadyNashj_Complete_Conditions))
    call TriggerAddAction(gg_trg_Quest_LadyNashj_Complete,function Trig_Quest_LadyNashj_Complete_Actions)
endfunction

endlibrary
