library TElixir requires TCam, TCine, TPlayerPart01, TReward, TText, TUnit, TWait
function Trig_Elixir_Prepare_Actions takes nothing returns nothing
    set udg_SpecialEffect[17]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_n001_0012,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call EnableTrigger(gg_trg_Elixir_Start)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Elixir_Start_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_n001_0012,true,true,true))
endfunction

function Trig_Elixir_Start_Cond_ShowShopTalk takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Elixir_Start_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[17])
    if(Trig_Elixir_Start_Cond_ShowShopTalk())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Transmission(gg_unit_n001_0012,"Fire","Fresh, cool ale... is what you won't find here. But I have plenty of potions and ether, as well as some other items. I can also buy items you want to sell.","(null)",null,0,false)
        call Text_Transmission(gg_unit_n001_0012,"Fire","And if ever in your journeys you find Elixir please bring it to me. I am very interested in learning ancient potion-making techniques and studying the legendary Elixir will be of great help to me. Of course I will pay more gold than you would otherwise get for selling it.","(null)",null,0,false)
        call Cine_ExitAction()
    endif
    set udg_SpecialEffect[17]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_n001_0012,"Objects\\RandomObject\\RandomObject.mdl")
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_DISCOVERED,"New Quest Received: |cffffcc00Elixir|r")
    set udg_SideQuest[19]=CreateQuestBJ(bj_QUESTTYPE_REQ_DISCOVERED,"|cff00ffffElixir","Fire, Pandaren Merchant from Kalm, asked you to bring him Elixir.","ReplaceableTextures\\CommandButtons\\BTNPotionOfRestoration.blp")
    call EnableTrigger(gg_trg_Elixir_Deliver)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Elixir_Deliver_Conditions takes nothing returns boolean
    return((UnitHasItemOfTypeBJ(GetTriggerUnit(),'pres'))and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(udg_InCinematicMode==false)and(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'pres'))>=1))!=null // 'pres': item "Elixir"
endfunction

function Trig_Elixir_Deliver_Cond_HasSpareCharge takes nothing returns boolean
    return(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'pres'))>=2) // 'pres': item "Elixir"
endfunction

function Trig_Elixir_Deliver_Cond_ShowThanks takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Elixir_Deliver_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    if(Trig_Elixir_Deliver_Cond_HasSpareCharge())then
        // (item charges of GetItemOfTypeFromUnitBJ(the triggering unit, 'pres')) minus (1).
        call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'pres'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'pres'))-1)) // 'pres': item "Elixir"
    else
        call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'pres')) // 'pres': item "Elixir"
    endif
    call DestroyEffectBJ(udg_SpecialEffect[17])
    set udg_StoryFlag[4]=false
    if(Trig_Elixir_Deliver_Cond_ShowThanks())then
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_n001_0012,0)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"Fire, you should be happy - here's the Elixir you asked for.",false)
        call Text_Transmission(gg_unit_n001_0012,"Fire","Excellent! Thank you very much!","(null)",null,0,false)
        call Text_Transmission(gg_unit_n001_0012,"Fire","|n|cffffcc00All players get 4000 gold and 500 exp.|r","(null)",null,0,true)
        call Reward_Give($FA0,500,null) // $FA0 = 4000
        call Text_Transmission(gg_unit_n001_0012,"Fire","Oh, and I'm always interested in exquisite potions. If you find a rare one, please tell me.","(null)",null,0,false)
        call Cine_ExitAction()
    else
        call Reward_Give($FA0,500,gg_unit_n001_0012) // $FA0 = 4000
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_COMPLETED,"Quest Completed: |cffffcc00Elixir|r")
    call QuestSetCompletedBJ(udg_SideQuest[19],true)
    set udg_QuestsCompleted=(udg_QuestsCompleted+1)
    call EnableTrigger(gg_trg_Fire_Pawn_HeroDrink)
    call EnableTrigger(gg_trg_Fire_Pawn_Nectar)
    call EnableTrigger(gg_trg_Fire_Pawn_SpiritPotion)
    call EnableTrigger(gg_trg_Fire_Pawn_BloodEther)
    set udg_StoryProgress=(udg_StoryProgress+1)
    call ConditionalTriggerExecute(gg_trg_QuestCount_Milestones)
    call Wait_Polled(180.)
    call DisplayTextToForce(GetPlayersAll(),"|cff00ffffFire's stock contains a new item for sale !!!|r")
    call AddItemToStockBJ('pres',gg_unit_n02K_0073,0,99) // 'pres': item "Elixir"
    set udg_StoryFlag[2]=true
    set udg_NewsText[3]=udg_NewsText[2]
    set udg_NewsText[2]=udg_NewsText[1]
    set udg_NewsText[6]=udg_NewsText[5]
    set udg_NewsText[5]=udg_NewsText[4]
    set udg_NewsText[1]="|cffffcc00Fire Sells Elixir|r"
    set udg_NewsText[4]="Thanks to the adventurers, Fire got an Elixir and studied it. Now he sells them!"
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Elixir takes nothing returns nothing
endfunction
function RegisterR11_Elixir_Prepare takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Elixir_Prepare=CreateTrigger()
    call DisableTrigger(gg_trg_Elixir_Prepare)
    call TriggerAddAction(gg_trg_Elixir_Prepare,function Trig_Elixir_Prepare_Actions)
endfunction
function RegisterR11_Elixir_Start takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Elixir_Start=CreateTrigger()
    call DisableTrigger(gg_trg_Elixir_Start)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Elixir_Start,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Elixir_Start,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Elixir_Start,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Elixir_Start,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Elixir_Start,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Elixir_Start,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Elixir_Start,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Elixir_Start,Player(7),true)
    call TriggerAddCondition(gg_trg_Elixir_Start,Condition(function Trig_Elixir_Start_Conditions))
    call TriggerAddAction(gg_trg_Elixir_Start,function Trig_Elixir_Start_Actions)
endfunction
function RegisterR11_Elixir_Deliver takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Elixir_Deliver=CreateTrigger()
    call DisableTrigger(gg_trg_Elixir_Deliver)
    call TriggerRegisterUnitInRangeSimple(gg_trg_Elixir_Deliver,450.,gg_unit_n001_0012)
    call TriggerAddCondition(gg_trg_Elixir_Deliver,Condition(function Trig_Elixir_Deliver_Conditions))
    call TriggerAddAction(gg_trg_Elixir_Deliver,function Trig_Elixir_Deliver_Actions)
endfunction




endlibrary
