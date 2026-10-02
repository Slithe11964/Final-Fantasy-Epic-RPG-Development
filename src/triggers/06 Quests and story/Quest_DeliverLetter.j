library TQuestDeliverLetter requires TCam, TCine, TGroup, TPlayerPart01, TReward, TText, TUnit
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Quest_DeliverLetter_Init=null
    trigger gg_trg_Quest_DeliverLetter_Available=null
    trigger gg_trg_Quest_DeliverLetter_Start=null
    trigger gg_trg_Quest_DeliverLetter_PingZack=null
    trigger gg_trg_Quest_DeliverLetter_PingWedge=null
    trigger gg_trg_Quest_DeliverLetter_GiveZack=null
    trigger gg_trg_Quest_DeliverLetter_Complete=null
    // Variables only this module uses (MapBootstrap sets some starting values).
    sound gg_snd_CaptainPissed=null
endglobals

function Trig_Quest_DeliverLetter_Init_Enum_MakeCorpse takes nothing returns nothing
    call SetUnitVertexColorBJ(GetEnumUnit(),'d',.0,.0,0)
    call SetUnitAnimation(GetEnumUnit(),"decay flesh")
    call SetUnitTimeScalePercent(GetEnumUnit(),.0)
    call SetUnitLifeBJ(GetEnumUnit(),1.)
endfunction

function Trig_Quest_DeliverLetter_Init_Actions takes nothing returns nothing
    call UnitAddAbilityBJ('Aneu',gg_unit_h00K_0137) // 'Aneu': standard ability reference "Neutral Building"
    call AddItemToStockBJ('I03R',gg_unit_h00K_0137,1,1) // 'I03R': item "Kalm News"
    set udg_FarmCorpses=Group_UnitsInRectOfPlayer(gg_rct_580,Player(8))
    call ForGroupBJ(udg_FarmCorpses,function Trig_Quest_DeliverLetter_Init_Enum_MakeCorpse)
    call SetUnitLifePercentBJ(gg_unit_nten_0232,10.)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Quest_DeliverLetter_Available_Actions takes nothing returns nothing
    set udg_SpecialEffect[28]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_h00K_0137,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call EnableTrigger(gg_trg_Quest_DeliverLetter_Start)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Quest_DeliverLetter_Start_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_h00K_0137,true,true,true))
endfunction

function Trig_Quest_DeliverLetter_Start_Cond_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_DeliverLetter_Start_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[28])
    if(Trig_Quest_DeliverLetter_Start_Cond_CinematicsEnabled())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Transmission(gg_unit_h00K_0137,"Wedge","I should've been a farmer like my father wanted.","(null)",gg_snd_CaptainPissed,0,false)
        call Text_Say(gg_unit_h00K_0137,"But I chose to be a soldier and freelance newswriter instead. Well, at least my elder brother Zack inherited father's farm. I miss him a little. Say, if you come across the Farm south from Kalm could you please give my brother Zack this letter? I wrote it some time ago but with the recent growth of monster activity I couldn't ever make it through to give it to him.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"I'll see what I can do.",false)
        call Text_Say(gg_unit_h00K_0137,"Thanks a lot.",false)
        call Cine_ExitAction()
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_DISCOVERED,"New Quest Received: |cffffcc00Deliver Letter|r")
    set udg_SideQuest[$A]=CreateQuestBJ(bj_QUESTTYPE_REQ_DISCOVERED,"|cff00ffffDeliver Letter","Wedge, footman from Kalm, asked you to deliver letter to his brother Zack who lives in the Farm.","ReplaceableTextures\\CommandButtons\\BTNINV_Letter.BLP") // $A = 10
    set udg_SpecialEffect[28]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_n00K_0150,"Objects\\RandomObject\\RandomObject.mdl")
    call EnableTrigger(gg_trg_Quest_DeliverLetter_PingZack)
    set udg_QuestItem[16]=UnitAddItemByIdSwapped('k3m2',Player_GetHero(GetTriggerPlayer())) // 'k3m2': item "Letter to Zack"
    call SetItemInvulnerableBJ(GetLastCreatedItem(),true)
    call EnableTrigger(gg_trg_Quest_DeliverLetter_GiveZack)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Quest_DeliverLetter_PingZack_Conditions takes nothing returns boolean
    return(udg_QuestItem[16]!=null)
endfunction

function Trig_Quest_DeliverLetter_PingZack_Cond_LetterCarried takes nothing returns boolean
    return(IsItemOwned(udg_QuestItem[16]))
endfunction

function Trig_Quest_DeliverLetter_PingZack_Actions takes nothing returns nothing
    if(Trig_Quest_DeliverLetter_PingZack_Cond_LetterCarried())then
        set udg_TempPoint=GetUnitLoc(gg_unit_n00K_0150)
    else
        set udg_TempPoint=GetItemLoc(udg_QuestItem[16])
    endif
    call PingMinimapLocForForce(GetPlayersAll(),udg_TempPoint,2.)
    call RemoveLocation(udg_TempPoint)
endfunction

function Trig_Quest_DeliverLetter_PingWedge_Conditions takes nothing returns boolean
    return(udg_QuestItem[16]!=null)
endfunction

function Trig_Quest_DeliverLetter_PingWedge_Cond_LetterCarried takes nothing returns boolean
    return(IsItemOwned(udg_QuestItem[16]))
endfunction

function Trig_Quest_DeliverLetter_PingWedge_Actions takes nothing returns nothing
    if(Trig_Quest_DeliverLetter_PingWedge_Cond_LetterCarried())then
        set udg_TempPoint=GetUnitLoc(gg_unit_h00K_0137)
    else
        set udg_TempPoint=GetItemLoc(udg_QuestItem[16])
    endif
    call PingMinimapLocForForce(GetPlayersAll(),udg_TempPoint,2.)
    call RemoveLocation(udg_TempPoint)
endfunction

function Trig_Quest_DeliverLetter_GiveZack_Conditions takes nothing returns boolean
    return((UnitHasItemOfTypeBJ(GetTriggerUnit(),'k3m2'))and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(udg_InCinematicMode==false))!=null // 'k3m2': item "Letter to Zack"
endfunction

function Trig_Quest_DeliverLetter_GiveZack_Cond_TimmyQuestDone takes nothing returns boolean
    return(IsQuestCompleted(udg_SideQuest[9]))
endfunction

function Trig_Quest_DeliverLetter_GiveZack_Cond_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_DeliverLetter_GiveZack_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DisableTrigger(gg_trg_Quest_DeliverLetter_PingZack)
    call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'k3m2')) // 'k3m2': item "Letter to Zack"
    call DestroyEffectBJ(udg_SpecialEffect[28])
    if(Trig_Quest_DeliverLetter_GiveZack_Cond_CinematicsEnabled())then
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_n00K_0150,0)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"Hello. Are you Zack?",false)
        call Text_Say(gg_unit_n00K_0150,"Yes, that's my name.",false)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"Here's a letter for you from your brother Wedge. He'd like to know how you're doing.",false)
        call Text_Say(gg_unit_n00K_0150,"A letter from my brother? Thank you very much. Unfortunately we are not doing well at the moment.",false)
        if(Trig_Quest_DeliverLetter_GiveZack_Cond_TimmyQuestDone())then
            call Text_Say(gg_unit_n00K_0150,"You saved our youngest from the gnolls and we are incredibly thankful, but even so we're still shaken.",false)
        endif
        call Text_Say(gg_unit_n00K_0150,"I'd like to write him a letter back to inform him of our circumstances... would you mind delivering it back to him?",false)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"Sure.",false)
        call Text_Say(gg_unit_n00K_0150,"Thank you.",false)
        call Cine_ExitAction()
    endif
    set udg_QuestItem[16]=UnitAddItemByIdSwapped('phlt',GetTriggerUnit()) // 'phlt': item "Letter to Wedge"
    call SetItemInvulnerableBJ(GetLastCreatedItem(),true)
    call QuestMessageBJ(udg_PlayingPlayers,bj_QUESTMESSAGE_UPDATED,"Bring Zack's letter to Wedge")
    call QuestSetDescriptionBJ(udg_SideQuest[$A],"Bring Zack's letter to Wedge") // $A = 10
    call EnableTrigger(gg_trg_Quest_DeliverLetter_PingWedge)
    set udg_SpecialEffect[28]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_h00K_0137,"Objects\\RandomObject\\RandomObject.mdl")
    call EnableTrigger(gg_trg_Quest_DeliverLetter_Complete)
    call UnitAddItemByIdSwapped('I005',GetTriggerUnit()) // 'I005': item "150 Gold Coins"
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Quest_DeliverLetter_Complete_Conditions takes nothing returns boolean
    return((UnitHasItemOfTypeBJ(GetTriggerUnit(),'phlt'))and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(udg_InCinematicMode==false))!=null // 'phlt': item "Letter to Wedge"
endfunction

function Trig_Quest_DeliverLetter_Complete_Cond_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_DeliverLetter_Complete_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DisableTrigger(gg_trg_Quest_DeliverLetter_PingWedge)
    call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'phlt')) // 'phlt': item "Letter to Wedge"
    call DestroyEffectBJ(udg_SpecialEffect[28])
    if(Trig_Quest_DeliverLetter_Complete_Cond_CinematicsEnabled())then
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_h00K_0137,0)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"Hi Wedge. We delivered your letter to Zack. Looks like he's not doing too well. He sent you this letter right back.",false)
        call Text_Say(gg_unit_h00K_0137,"Oh dear, allow me to read this letter...",false)
        call Text_Say(gg_unit_h00K_0137,"Damn it, the Farm is affected most horribly by this uprising of monsters... five men dead... my god.",false)
        call Text_Say(gg_unit_h00K_0137,"Thank you for bringing me this letter... the town must know of the horrible state of the Farm. I will write about it in my newspaper immediately, both to spread awareness and to honor the dead.",false)
        call Text_Say(gg_unit_h00K_0137,"Johnny... Wirt... Bill... Tseng... Laguna... I won't let you be forgotten...",false)
        call Text_Say(gg_unit_h00K_0137,"Anyways, sorry to bother you with this. Here's some gold for your trouble.",false)
        call Reward_Give(500,500,gg_unit_h00K_0137)
        call Cine_ExitAction()
    else
        call Reward_Give(500,500,gg_unit_h00K_0137)
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_COMPLETED,"Quest Completed: |cffffcc00Deliver Letter|r")
    call QuestSetCompletedBJ(udg_SideQuest[$A],true) // $A = 10
    set udg_QuestsCompleted=(udg_QuestsCompleted+1)
    set udg_StoryProgress=(udg_StoryProgress+1)
    call ShowUnitShow(gg_unit_n0BV_0229)
    call BlzSetUnitName(gg_unit_nvl2_0236,"Johnny")
    call BlzSetUnitName(gg_unit_nvil_0235,"Wirt")
    call BlzSetUnitName(gg_unit_nvl2_0233,"Bill")
    call BlzSetUnitName(gg_unit_nvil_0237,"Tseng")
    call BlzSetUnitName(gg_unit_nvil_0234,"Laguna")
    set udg_NewsText[3]=udg_NewsText[2]
    set udg_NewsText[2]=udg_NewsText[1]
    set udg_NewsText[6]=udg_NewsText[5]
    set udg_NewsText[5]=udg_NewsText[4]
    set udg_NewsText[1]="|cffffcc00A Tribute to our Farmers|r"
    set udg_NewsText[4]="I, Wedge, wish to express a request to all readers. The farmers in the Farm to the south are currently in dire straits; they've recently lost five men on an excursion. Please pray for them tonight. Thank you."
    call ConditionalTriggerExecute(gg_trg_QuestCount_Milestones)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function InitTrig_Quest_DeliverLetter takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Quest_Part9 (module Quest),
// which keeps the original registration order.

function Register_Quest_DeliverLetter_Init takes nothing returns nothing
    set gg_trg_Quest_DeliverLetter_Init=CreateTrigger()
    call TriggerAddAction(gg_trg_Quest_DeliverLetter_Init,function Trig_Quest_DeliverLetter_Init_Actions)
endfunction

function Register_Quest_DeliverLetter_Available takes nothing returns nothing
    set gg_trg_Quest_DeliverLetter_Available=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_DeliverLetter_Available)
    call TriggerAddAction(gg_trg_Quest_DeliverLetter_Available,function Trig_Quest_DeliverLetter_Available_Actions)
endfunction

function Register_Quest_DeliverLetter_Start takes nothing returns nothing
    set gg_trg_Quest_DeliverLetter_Start=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_DeliverLetter_Start)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_DeliverLetter_Start,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_DeliverLetter_Start,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_DeliverLetter_Start,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_DeliverLetter_Start,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_DeliverLetter_Start,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_DeliverLetter_Start,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_DeliverLetter_Start,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_DeliverLetter_Start,Player(7),true)
    call TriggerAddCondition(gg_trg_Quest_DeliverLetter_Start,Condition(function Trig_Quest_DeliverLetter_Start_Conditions))
    call TriggerAddAction(gg_trg_Quest_DeliverLetter_Start,function Trig_Quest_DeliverLetter_Start_Actions)
endfunction

function Register_Quest_DeliverLetter_PingZack takes nothing returns nothing
    set gg_trg_Quest_DeliverLetter_PingZack=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_DeliverLetter_PingZack)
    call TriggerRegisterTimerEventPeriodic(gg_trg_Quest_DeliverLetter_PingZack,15.)
    call TriggerAddCondition(gg_trg_Quest_DeliverLetter_PingZack,Condition(function Trig_Quest_DeliverLetter_PingZack_Conditions))
    call TriggerAddAction(gg_trg_Quest_DeliverLetter_PingZack,function Trig_Quest_DeliverLetter_PingZack_Actions)
endfunction

function Register_Quest_DeliverLetter_PingWedge takes nothing returns nothing
    set gg_trg_Quest_DeliverLetter_PingWedge=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_DeliverLetter_PingWedge)
    call TriggerRegisterTimerEventPeriodic(gg_trg_Quest_DeliverLetter_PingWedge,15.)
    call TriggerAddCondition(gg_trg_Quest_DeliverLetter_PingWedge,Condition(function Trig_Quest_DeliverLetter_PingWedge_Conditions))
    call TriggerAddAction(gg_trg_Quest_DeliverLetter_PingWedge,function Trig_Quest_DeliverLetter_PingWedge_Actions)
endfunction

function Register_Quest_DeliverLetter_GiveZack takes nothing returns nothing
    set gg_trg_Quest_DeliverLetter_GiveZack=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_DeliverLetter_GiveZack)
    call TriggerRegisterUnitInRangeSimple(gg_trg_Quest_DeliverLetter_GiveZack,450.,gg_unit_n00K_0150)
    call TriggerAddCondition(gg_trg_Quest_DeliverLetter_GiveZack,Condition(function Trig_Quest_DeliverLetter_GiveZack_Conditions))
    call TriggerAddAction(gg_trg_Quest_DeliverLetter_GiveZack,function Trig_Quest_DeliverLetter_GiveZack_Actions)
endfunction

function Register_Quest_DeliverLetter_Complete takes nothing returns nothing
    set gg_trg_Quest_DeliverLetter_Complete=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_DeliverLetter_Complete)
    call TriggerRegisterUnitInRangeSimple(gg_trg_Quest_DeliverLetter_Complete,450.,gg_unit_h00K_0137)
    call TriggerAddCondition(gg_trg_Quest_DeliverLetter_Complete,Condition(function Trig_Quest_DeliverLetter_Complete_Conditions))
    call TriggerAddAction(gg_trg_Quest_DeliverLetter_Complete,function Trig_Quest_DeliverLetter_Complete_Actions)
endfunction

endlibrary
