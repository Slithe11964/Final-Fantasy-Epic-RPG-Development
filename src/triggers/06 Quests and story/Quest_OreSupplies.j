library TQuestOreSupplies requires TCam, TCine, TPlayerHero, TReward, TText, TUnit
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Quest_OreSupplies_Start=null
    trigger gg_trg_Quest_OreSupplies_Deliver=null
    // Variables only this module uses.
    integer udg_OreSuppliesRemaining=0
endglobals

function Trig_Quest_OreSupplies_Start_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_H00P_0260,true,true,true))
endfunction

function Trig_Quest_OreSupplies_Start_DwarvesDistrust takes nothing returns boolean
    return(udg_KalmTechLevel<3)
endfunction

function Trig_Quest_OreSupplies_Start_PlayLokiScene takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_OreSupplies_Start_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[88])
    if(Trig_Quest_OreSupplies_Start_PlayLokiScene())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(gg_unit_H00P_0260,"Lali-ho, strangers. I saw you talking to Giott earlier. You're adventurers?",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"That's correct. Are you using this forge?",false)
        if(Trig_Quest_OreSupplies_Start_DwarvesDistrust())then
            call Text_Say(gg_unit_H00P_0260,"My brother Bali and I are the smiths here yes. But if you want us to forge you some gear, we're gonna have to say no to that. Not about to make gear for someone we don't even know.",false)
            call Text_Say(gg_unit_H00P_0260,"But even if we wanted to, right now we couldn't. We're all out of supplies to even keep our forge running.",false)
        else
            call Text_Say(gg_unit_H00P_0260,"My brother Bali and I are the smiths here yes. If you want us to forge you some gear, we can help you out with that.",false)
            call Text_Say(gg_unit_H00P_0260,"But even if we want to, right now we can't. We're all out of supplies to even keep our forge running.",false)
        endif
        call Text_Say(gg_unit_H00P_0260,"See this forge needs some minerals from the mines in the Northern Mountains to keep going. And unfortunately we spent the last we had on making some gear for our Thunder Striker over there. He's a bit of a greedy guy so he demands we make the best of the best gear for him.",false)
        call Text_Say(gg_unit_H036_0254,"Is there anything wrong with that? I'm protecting you all here.",false)
        call Text_Say(gg_unit_H00P_0260,"You could at least bring us the materials we need for your arms you know.",false)
        call Text_Say(gg_unit_H036_0254,"Don't treat me like your errand boy now.",false)
        call Text_Say(gg_unit_H00P_0260,"Well you see how it is. And unfortunately although we have some friends at Kalm they haven't been able to provide us with the resources we need.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"So then, if I bring you the resources you need, can you make me some gear then?",false)
        call Text_Say(gg_unit_H00P_0260,"Aye that would be great. We still need to make more gear for our valiant defender there, but I can help you get your hands on some better stuff for sure.",false)
        call Text_Say(gg_unit_H00P_0260,"We need 5 Mine Minerals from the mountains. The mine there may have collapsed in on itself, but you should still be able to get some just from the monsters there.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Alright, we can do that.",false)
        call Cine_ExitAction()
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_DISCOVERED,"New Quest Received: |cffffcc00Ore Supplies|r")
    set udg_SideQuest[67]=CreateQuestBJ(bj_QUESTTYPE_REQ_DISCOVERED,(udg_QuestNamePrefix+"Ore Supplies"),"Loki Smith, one of the dwarves managing the Forge in the Barrens, tasked you with bringing him 5 Mine Minerals from the Northern Mountains.","ReplaceableTextures\\CommandButtons\\BTNGoldMine.blp")
    set udg_SpecialEffect[88]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_H00P_0260,"Objects\\RandomObject\\RandomObject.mdl")
    set udg_OreSuppliesRemaining=5
    set udg_QuestReq[8]=CreateQuestItemBJ(udg_SideQuest[67],"Minerals brought to Loki: 0/5")
    call EnableTrigger(gg_trg_Quest_OreSupplies_Deliver)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Quest_OreSupplies_Deliver_Conditions takes nothing returns boolean
    return((UnitHasItemOfTypeBJ(GetTriggerUnit(),'I074'))and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(IsUnitHiddenBJ(gg_unit_H00P_0260)==false)and(udg_InCinematicMode==false))!=null // 'I074': item "Mine Mineral"
endfunction

function Trig_Quest_OreSupplies_Deliver_HasSpareCharges takes nothing returns boolean
    return(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I074'))>udg_TempInteger) // 'I074': item "Mine Mineral"
endfunction

function Trig_Quest_OreSupplies_Deliver_MineralsMissing takes nothing returns boolean
    return(udg_OreSuppliesRemaining>0)
endfunction

function Trig_Quest_OreSupplies_Deliver_DwarvesTrusted takes nothing returns boolean
    return(udg_KalmTechLevel>=3)
endfunction

function Trig_Quest_OreSupplies_Deliver_DwarvesDistrustful takes nothing returns boolean
    return(udg_KalmTechLevel<3)
endfunction

function Trig_Quest_OreSupplies_Deliver_PlayRewardScene takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_OreSupplies_Deliver_ReforgeUnlocked takes nothing returns boolean
    return(udg_KalmTechLevel>=3)
endfunction

function Trig_Quest_OreSupplies_Deliver_Actions takes nothing returns nothing
    local location l_tempPoint
    // Result 1: the smaller of (udg_OreSuppliesRemaining) and (item charges of GetItemOfTypeFromUnitBJ(the
    // triggering unit, 'I074')).
    set udg_TempInteger=IMinBJ(udg_OreSuppliesRemaining,GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I074'))) // 'I074': item "Mine Mineral"
    if(Trig_Quest_OreSupplies_Deliver_HasSpareCharges())then
        // (item charges of GetItemOfTypeFromUnitBJ(the triggering unit, 'I074')) minus (udg_TempInteger).
        call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I074'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I074'))-udg_TempInteger)) // 'I074': item "Mine Mineral"
    else
        call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I074')) // 'I074': item "Mine Mineral"
    endif
    // (udg_OreSuppliesRemaining) minus (udg_TempInteger).
    set udg_OreSuppliesRemaining=(udg_OreSuppliesRemaining-udg_TempInteger)
    // (5) minus (udg_OreSuppliesRemaining).
    call DisplayTextToForce(GetPlayersAll(),("Minerals brought to Loki: "+(I2S((5-udg_OreSuppliesRemaining))+"/5")))
    // (5) minus (udg_OreSuppliesRemaining).
    call QuestItemSetDescriptionBJ(udg_QuestReq[8],("Minerals brought to Loki: "+(I2S((5-udg_OreSuppliesRemaining))+"/5")))
    if(Trig_Quest_OreSupplies_Deliver_MineralsMissing())then
        set l_tempPoint=null
        return
    endif
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[88])
    if(Trig_Quest_OreSupplies_Deliver_PlayRewardScene())then
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_H00P_0260,0)
        call Text_Say(gg_unit_H00P_0260,"Many thanks. This should be enough to get our forge running again.",false)
        if(Trig_Quest_OreSupplies_Deliver_DwarvesDistrustful())then
            call Text_Say(gg_unit_H00P_0260,"Our champion still gets first pick, but in addition to gold I have something here for you - a bit of a rare material.",false)
            call Text_Say(gg_unit_H00P_0260,"I can't make ye some stuff myself, but if you give this to the traders in Kalm they should be able to give you something good in return.",false)
            call Reward_Give(6000,$5DC,gg_unit_H00P_0260) // $5DC = 1500
        else
            call Text_Say(gg_unit_H00P_0260,"In addition to gold I have something here for you - a bit of a rare material. The traders in Kalm should be able to provide you with some decent gear for that.",false)
            call Text_Say(gg_unit_H00P_0260,"Also you've shown to be trustworthy already, I can use this forge to help you out. If you bring me a piece of weak equipment and 3 Crystal Shards, I can forge them right in to bring it up to snuff.",false)
            call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"Thanks, Loki.",false)
            call Text_Say(gg_unit_H00P_0260,"Think nothing of it.",false)
            call Reward_Give(6000,$5DC,gg_unit_H00P_0260) // $5DC = 1500
            call Text_Say(gg_unit_H00P_0260,"|n|cffffcc00Loki can now reforge gear below Level 45 at the cost of up to 3 Crystal Shards!|r",true)
        endif
        call Cine_ExitAction()
    else
        call Reward_Give(6000,$5DC,gg_unit_H00P_0260) // $5DC = 1500
        if(Trig_Quest_OreSupplies_Deliver_DwarvesTrusted())then
            call DisplayTimedTextToForce(udg_PlayingPlayers,10.,"|cffffcc00Loki can now reforge gear below Level 45 at the cost of up to 3 Crystal Shards!|r")
        endif
    endif
    call QuestItemSetCompletedBJ(udg_QuestReq[8],true)
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_COMPLETED,"Quest Completed: |cffffcc00Ore Supplies|r")
    call QuestSetCompletedBJ(udg_SideQuest[67],true)
    set udg_QuestsCompleted=(udg_QuestsCompleted+1)
    call SetUnitAnimation(gg_unit_hbla_0158,"work")
    set l_tempPoint=GetUnitLoc(gg_unit_H00P_0260)
    set udg_LokiForgeSpot=OffsetLocation(l_tempPoint,-10.,-75.)
    call RemoveLocation(l_tempPoint)
    call CreateItemLoc('I0K0',udg_LokiForgeSpot) // 'I0K0': item "Quality Mithril"
    if(Trig_Quest_OreSupplies_Deliver_ReforgeUnlocked())then
        call EnableTrigger(gg_trg_Loki_Reforge_Offer)
        call UnitAddAbilityBJ('A03S',gg_unit_H00P_0260) // 'A03S': ability "Forge Inventory"
        set udg_LokiForgeText=CreateTextTagUnitBJ(" ",gg_unit_H00P_0260,0,12.,'d','d','d',0)
    endif
    call DestroyTrigger(GetTriggeringTrigger())
    set l_tempPoint=null
endfunction

function InitTrig_Quest_OreSupplies takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Quest_Part18 (module Quest),
// which keeps the original registration order.

function Register_Quest_OreSupplies_Start takes nothing returns nothing
    set gg_trg_Quest_OreSupplies_Start=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_OreSupplies_Start)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_OreSupplies_Start,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_OreSupplies_Start,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_OreSupplies_Start,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_OreSupplies_Start,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_OreSupplies_Start,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_OreSupplies_Start,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_OreSupplies_Start,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_OreSupplies_Start,Player(7),true)
    call TriggerAddCondition(gg_trg_Quest_OreSupplies_Start,Condition(function Trig_Quest_OreSupplies_Start_Conditions))
    call TriggerAddAction(gg_trg_Quest_OreSupplies_Start,function Trig_Quest_OreSupplies_Start_Actions)
endfunction

function Register_Quest_OreSupplies_Deliver takes nothing returns nothing
    set gg_trg_Quest_OreSupplies_Deliver=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_OreSupplies_Deliver)
    call TriggerRegisterUnitInRangeSimple(gg_trg_Quest_OreSupplies_Deliver,450.,gg_unit_H00P_0260)
    call TriggerAddCondition(gg_trg_Quest_OreSupplies_Deliver,Condition(function Trig_Quest_OreSupplies_Deliver_Conditions))
    call TriggerAddAction(gg_trg_Quest_OreSupplies_Deliver,function Trig_Quest_OreSupplies_Deliver_Actions)
endfunction

endlibrary
