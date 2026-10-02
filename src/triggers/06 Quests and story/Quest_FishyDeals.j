library TQuestFishyDeals requires TCam, TCine, TPlayerPart01, TReward, TText, TUnit
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Quest_FishyDeals_Start=null
    trigger gg_trg_Quest_FishyDeals_Complete=null
endglobals

function Trig_Quest_FishyDeals_Start_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_n0AW_0223,true,true,true))
endfunction

function Trig_Quest_FishyDeals_Start_Cond_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_FishyDeals_Start_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[92])
    if(Trig_Quest_FishyDeals_Start_Cond_CinematicsEnabled())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(gg_unit_n0AW_0223,"Oh I see you've found my Fishing Pole. Well if you wish to keep it I don't mind. I don't get the opportunity to fish much these days.",false)
        call Text_Say(gg_unit_n0AW_0223,"However, I have a favor to ask of you. I haven't been able to taste a good fish meal in a long time. If you can use the fishing pole to get some fish to then cook and bring me a fishy meal, I'll give you a handsome reward.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"We'll see if we can get you something.",false)
        call Cine_ExitAction()
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_DISCOVERED,"New Quest Received: |cffffcc00Fishy Deals|r")
    set udg_SideQuest[74]=CreateQuestBJ(bj_QUESTTYPE_REQ_DISCOVERED,(udg_QuestNamePrefix+"Fishy Deals"),"Ruksel, angler from the Farm and former owner of the Fishing Pole you found, has asked you to make him a \"fishy meal\". Bring him something suitable!","ReplaceableTextures\\CommandButtons\\BTNINV_Misc_Fish_06.blp")
    set udg_SpecialEffect[92]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_n0AW_0223,"Objects\\RandomObject\\RandomObject.mdl")
    call EnableTrigger(gg_trg_Quest_FishyDeals_Complete)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Quest_FishyDeals_Complete_Cond_HasFishMeal takes nothing returns boolean
    return(UnitHasItemOfTypeBJ(GetTriggerUnit(),'I0KI'))or(UnitHasItemOfTypeBJ(GetTriggerUnit(),'I0KM')) // 'I0KI': item "Fish Soup"; 'I0KM': item "Nebra Bread"
endfunction

function Trig_Quest_FishyDeals_Complete_Conditions takes nothing returns boolean
    return((Trig_Quest_FishyDeals_Complete_Cond_HasFishMeal())and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(IsUnitHiddenBJ(gg_unit_n0AW_0223)==false)and(udg_InCinematicMode==false))!=null
endfunction

function Trig_Quest_FishyDeals_Complete_Cond_SoupHasCharges takes nothing returns boolean
    return(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I0KI'))>1) // 'I0KI': item "Fish Soup"
endfunction

function Trig_Quest_FishyDeals_Complete_Cond_CinematicsOnSoup takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_FishyDeals_Complete_Cond_BreadHasCharges takes nothing returns boolean
    return(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I0KM'))>1) // 'I0KM': item "Nebra Bread"
endfunction

function Trig_Quest_FishyDeals_Complete_Cond_CinematicsOnBread takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_FishyDeals_Complete_Cond_HasNebraBread takes nothing returns boolean
    return(UnitHasItemOfTypeBJ(GetTriggerUnit(),'I0KM')) // 'I0KM': item "Nebra Bread"
endfunction

function Trig_Quest_FishyDeals_Complete_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[92])
    if(Trig_Quest_FishyDeals_Complete_Cond_HasNebraBread())then
        if(Trig_Quest_FishyDeals_Complete_Cond_BreadHasCharges())then
            // (item charges of GetItemOfTypeFromUnitBJ(the triggering unit, 'I0KM')) minus (1).
            call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I0KM'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I0KM'))-1)) // 'I0KM': item "Nebra Bread"
        else
            call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I0KM')) // 'I0KM': item "Nebra Bread"
        endif
        if(Trig_Quest_FishyDeals_Complete_Cond_CinematicsOnBread())then
            call Cine_Enter()
            call Cam_PanToUnit(gg_unit_n0AW_0223,0)
            call Text_Say(gg_unit_n0AW_0223,"My word, is that Nebra Bread you're holding!?",false)
            call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"It is. You'll have to make a good offer for it, though.",false)
            call Text_Say(gg_unit_n0AW_0223,"But of course. Here you go.",false)
            call Reward_Give($2EE0,6000,gg_unit_n0AW_0223) // $2EE0 = 12000
            call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"Alright, the Nebra Bread is yours.",false)
            call Text_Say(gg_unit_n0AW_0223,"Amazing that you've managed to make one. Truly you are great anglers. Maybe you've even already been to the elusive Fisherman's Horizon? It's a small island hard to reach but it's said to contain a great treasure to fish up from the trenches surrounding it.",false)
            call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"I'll keep it in mind.",false)
            call Cine_ExitAction()
        else
            call Reward_Give($2EE0,6000,gg_unit_n0AW_0223) // $2EE0 = 12000
        endif
    else
        if(Trig_Quest_FishyDeals_Complete_Cond_SoupHasCharges())then
            // (item charges of GetItemOfTypeFromUnitBJ(the triggering unit, 'I0KI')) minus (1).
            call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I0KI'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I0KI'))-1)) // 'I0KI': item "Fish Soup"
        else
            call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I0KI')) // 'I0KI': item "Fish Soup"
        endif
        if(Trig_Quest_FishyDeals_Complete_Cond_CinematicsOnSoup())then
            call Cine_Enter()
            call Cam_PanToUnit(gg_unit_n0AW_0223,0)
            call Text_Say(gg_unit_n0AW_0223,"Is that a Fish Soup you're bringing me? It looks delicious.",false)
            call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"Indeed. So, about that reward?",false)
            call Text_Say(gg_unit_n0AW_0223,"Of course I won't ask you to hand it over for free.",false)
            call Reward_Give(5000,$7D0,gg_unit_n0AW_0223) // $7D0 = 2000
            call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"Alright, here you go.",false)
            call Text_Say(gg_unit_n0AW_0223,"You have my gratitude. It seems you are quite the anglers already. Good luck on your journeys, and beware of the King of the Nebra Seas. They say he lurks out there somewhere.",false)
            call Cine_ExitAction()
        else
            call Reward_Give(5000,$7D0,gg_unit_n0AW_0223) // $7D0 = 2000
        endif
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_COMPLETED,"Quest Completed: |cffffcc00Fishy Deals|r")
    call QuestSetCompletedBJ(udg_SideQuest[74],true)
    set udg_QuestsCompleted=(udg_QuestsCompleted+1)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function InitTrig_Quest_FishyDeals takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Quest_Part21 (module Quest),
// which keeps the original registration order.

function Register_Quest_FishyDeals_Start takes nothing returns nothing
    set gg_trg_Quest_FishyDeals_Start=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_FishyDeals_Start)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_FishyDeals_Start,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_FishyDeals_Start,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_FishyDeals_Start,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_FishyDeals_Start,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_FishyDeals_Start,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_FishyDeals_Start,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_FishyDeals_Start,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_FishyDeals_Start,Player(7),true)
    call TriggerAddCondition(gg_trg_Quest_FishyDeals_Start,Condition(function Trig_Quest_FishyDeals_Start_Conditions))
    call TriggerAddAction(gg_trg_Quest_FishyDeals_Start,function Trig_Quest_FishyDeals_Start_Actions)
endfunction

function Register_Quest_FishyDeals_Complete takes nothing returns nothing
    set gg_trg_Quest_FishyDeals_Complete=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_FishyDeals_Complete)
    call TriggerRegisterUnitInRangeSimple(gg_trg_Quest_FishyDeals_Complete,200.,gg_unit_n0AW_0223)
    call TriggerRegisterUnitInRangeSimple(gg_trg_Quest_FishyDeals_Complete,450.,gg_unit_n0AW_0223)
    call TriggerAddCondition(gg_trg_Quest_FishyDeals_Complete,Condition(function Trig_Quest_FishyDeals_Complete_Conditions))
    call TriggerAddAction(gg_trg_Quest_FishyDeals_Complete,function Trig_Quest_FishyDeals_Complete_Actions)
endfunction

endlibrary
