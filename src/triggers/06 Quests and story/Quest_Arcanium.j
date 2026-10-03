library TQuestArcanium requires TCam, TCine, TForce, TPlayerHero, TReward, TText, TUnit
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Quest_Arcanium_Start=null
    trigger gg_trg_Quest_Arcanium_Taken=null
    trigger gg_trg_Quest_Arcanium_Complete=null
endglobals

function Trig_Quest_Arcanium_Start_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_Hmbr_0140,true,true,true))
endfunction

function Trig_Quest_Arcanium_Start_Cond_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_Arcanium_Start_Actions takes nothing returns nothing
    local location l_tempPoint
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[32])
    if(Trig_Quest_Arcanium_Start_Cond_CinematicsEnabled())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(gg_unit_Hmbr_0140,"Lali-ho, adventurers! I am Bali, brother of Loki over there. We man this big smithy together.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Bali, is it. Could I have you forge something for me then?",false)
        call Text_Say(gg_unit_Hmbr_0140,"Certainly I don't mind helpin' ye out. I can do some fine forgin' for ye. But right now, there's a task we need to be takin' care of first and foremost.",false)
        call Text_Say(gg_unit_Hmbr_0140,"See that Thunder Striker over there, Ziegfried? Maybe ye already heard, but he's hired as a mercenary to protect us at this lil' smithy. In exchange we promised to forge 'im something of great power.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Sounds like it should be a simple task for you professional smiths, no?",false)
        call Text_Say(gg_unit_Hmbr_0140,"Aye normally this'd be no problem. But Ziegfried has something very particular in mind - gear made from Arcanium.",false)
        call Text_Say(gg_unit_Hmbr_0140,"A long time, before most of us were born, there was a time when we dwarves made gear of Arcanium. It was said that armor of Arcanium be impossible to penetrate by anything except weapons made of Arcanium themselves. Completely in a league of its own, no other gear could match it.",false)
        call Text_Say(gg_unit_Hmbr_0140,"Then a tragedy occurred and the mine of Arcanium collapsed. Many dwarven lives were lost. Ever since then Arcanium has been lost and the weapons and armor made of it disappeared from the world.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"There was a material that strong? Sounds like a myth to me.",false)
        call Text_Say(gg_unit_Hmbr_0140,"Nay, not a myth. Arcanium really exists. But it's all buried beneath the collapsed mine now, and even the collapsed entrance is guarded by a massive beast. There might still be some remnants of Arcanium over there. If so we'd be glad to be able to hold up our end of the bargain and make our mercenary the gear he desires. But with that beast there we can't even check.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Perhaps I can sneak in and see if I can snatch it for you.",false)
        call Text_Say(gg_unit_Hmbr_0140,"You'd do that for us? Hmm normally I'd be worried you'd try to run off with the material yourself but Mid did vouch for ye and it's not like you'd be able to make anything of this material without our help. It'd really help us out if you could do this.",false)
        call Text_Say(gg_unit_Hmbr_0140,"But remember, don't even try to take that beast on yourself. It's impossible to harm with any normal weapons. If it catches you, just get out fast.",false)
        call Cine_ExitAction()
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_DISCOVERED,"New Quest Received: |cffffcc00Arcanium|r")
    set udg_SideQuest[$D]=CreateQuestBJ(bj_QUESTTYPE_REQ_DISCOVERED,"|cff00ffffArcanium","Bali, one of the dwarves managing the Forge in the Barrens, has told you of Arcanium, a very rare material lost in the collapsed mine of the Northern Mountains, entrance guarded by a massive fearsome beast. Sneak in and retrieve a nugget of Arcanium for him!","ReplaceableTextures\\CommandButtons\\BTNPhilosophersStone.blp") // $D = 13
    set udg_SpecialEffect[32]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_Hmbr_0140,"Objects\\RandomObject\\RandomObject.mdl")
    set l_tempPoint=GetRectCenter(gg_rct_564)
    call CreateItemLoc('mgtk',l_tempPoint) // 'mgtk': item "Arcanium"
    call RemoveLocation(l_tempPoint)
    call SetItemInvulnerableBJ(GetLastCreatedItem(),true)
    call EnableTrigger(gg_trg_Quest_Arcanium_Taken)
    call AddItemToStockBJ('I04U',gg_unit_n02Y_0052,1,1) // 'I04U': item "Information: Arcanium"
    call DestroyTrigger(GetTriggeringTrigger())
    set l_tempPoint=null
endfunction

function Trig_Quest_Arcanium_Taken_Conditions takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='mgtk') // 'mgtk': item "Arcanium"
endfunction

function Trig_Quest_Arcanium_Taken_Actions takes nothing returns nothing
    local force l_tempForce
    call DisableTrigger(GetTriggeringTrigger())
    set l_tempForce=Force_OfPlayer(GetOwningPlayer(GetTriggerUnit()))
    call QuestMessageBJ(l_tempForce,bj_QUESTMESSAGE_UPDATED,"Bring the Arcanium to Bali Forgefire.")
    call DestroyForce(l_tempForce)
    call QuestSetDescriptionBJ(udg_SideQuest[$D],"Bring the Arcanium to Bali Forgefire.") // $D = 13
    call EnableTrigger(gg_trg_Quest_Arcanium_Complete)
    call DestroyTrigger(GetTriggeringTrigger())
    set l_tempForce=null
endfunction

function Trig_Quest_Arcanium_Complete_Conditions takes nothing returns boolean
    return((UnitHasItemOfTypeBJ(GetTriggerUnit(),'mgtk'))and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(IsUnitHiddenBJ(gg_unit_Hmbr_0140)==false)and(udg_InCinematicMode==false))!=null // 'mgtk': item "Arcanium"
endfunction

function Trig_Quest_Arcanium_Complete_Cond_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_Arcanium_Complete_Cond_Quest66Completed takes nothing returns boolean
    return(IsQuestCompleted(udg_SideQuest[66]))
endfunction

function Trig_Quest_Arcanium_Complete_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'mgtk')) // 'mgtk': item "Arcanium"
    call DestroyEffectBJ(udg_SpecialEffect[32])
    if(Trig_Quest_Arcanium_Complete_Cond_CinematicsEnabled())then
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_Hmbr_0140,0)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"Hi Bali. Guess what I got!",false)
        call Text_Say(gg_unit_Hmbr_0140,"I don't like riddles.",false)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"Well, it was stressful to get but I managed to get some Arcanium. It's all yours now.",false)
        call Text_Say(gg_unit_Hmbr_0140,"Oh lali me you did it. You're really something else.",false)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"With this can you finish this task of yours?",false)
        call Text_Say(gg_unit_Hmbr_0140,"Indeed. But first here, have something for your help.",false)
        call Reward_Give(9000,$BB8,gg_unit_Hmbr_0140) // $BB8 = 3000
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"Ok, Arcanium is yours.",false)
        call Text_Say(gg_unit_Hmbr_0140,"There we go. With this we have some truly incredible gear on our hands.",false)
        call Text_Say(gg_unit_Hmbr_0140,"You hear that, Striker? We got what you wanted.",false)
        call Cam_PanToUnit(gg_unit_H036_0254,.3)
        call Text_Say(gg_unit_H036_0254,"At last. This'll be the gear I need.",false)
        call Text_Say(gg_unit_Hmbr_0140,"Yeah, yeah. Well you do guard us so it's all yours.",false)
        call Text_Say(gg_unit_H036_0254,"The blade and armor of the gods. Yes, this is wonderful. With this, even the great beast won't stand a chance against me.",false)
        call Text_Say(gg_unit_Hmbr_0140,"In any case, you've been a great help, to me and Loki both. With this done I'm at your service as well. If you give me gear you had Loki reforge for you along with a special material, I can forge them together to create some great stuff for you.",false)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"That sounds great.",false)
        call Text_Say(gg_unit_Hmbr_0140,"|n|cffffcc00Bali can now merge special gems into gear reforged by Loki!|r",true)
        call Cine_ExitAction()
    else
        call Reward_Give(9000,$BB8,gg_unit_Hmbr_0140) // $BB8 = 3000
        call DisplayTimedTextToForce(udg_PlayingPlayers,10.,"|cffffcc00Bali can now merge special gems into gear reforged by Loki!|r")
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_COMPLETED,"Quest Completed: |cffffcc00Arcanium|r")
    call QuestSetCompletedBJ(udg_SideQuest[$D],true) // $D = 13
    call RemoveItem(UnitItemInSlotBJ(gg_unit_H036_0254,1))
    call RemoveItem(UnitItemInSlotBJ(gg_unit_H036_0254,4))
    call UnitAddItemByIdSwapped('I0KU',gg_unit_H036_0254) // 'I0KU': item "Gram"
    call UnitAddItemByIdSwapped('I0KV',gg_unit_H036_0254) // 'I0KV': item "Primordial Armor"
    set udg_QuestsCompleted=(udg_QuestsCompleted+1)
    call UnitAddAbilityBJ('Ane2',gg_unit_Hmbr_0140) // 'Ane2': object name not found in map data
    call UnitAddAbilityBJ('A03T',gg_unit_Hmbr_0140) // 'A03T': ability "Forge Inventory"
    set udg_ForgeText=CreateTextTagUnitBJ(" ",gg_unit_Hmbr_0140,0,12.,'d','d','d',0)
    call EnableTrigger(gg_trg_Forge_Bali_ItemGiven)
    call EnableTrigger(gg_trg_Forge_Bali_Craft)
    call EnableTrigger(gg_trg_Forge_Bali_PsypherTalk)
    if(Trig_Quest_Arcanium_Complete_Cond_Quest66Completed())then
        call EnableTrigger(gg_trg_Ziegfried_Mine_Arrive)
        call StartTimerBJ(udg_SharedDelayTimer5,false,180.)
    endif
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function InitTrig_Quest_Arcanium takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Quest_Part9 (module Quest),
// which keeps the original registration order.

function Register_Quest_Arcanium_Start takes nothing returns nothing
    set gg_trg_Quest_Arcanium_Start=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_Arcanium_Start)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Arcanium_Start,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Arcanium_Start,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Arcanium_Start,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Arcanium_Start,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Arcanium_Start,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Arcanium_Start,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Arcanium_Start,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Arcanium_Start,Player(7),true)
    call TriggerAddCondition(gg_trg_Quest_Arcanium_Start,Condition(function Trig_Quest_Arcanium_Start_Conditions))
    call TriggerAddAction(gg_trg_Quest_Arcanium_Start,function Trig_Quest_Arcanium_Start_Actions)
endfunction

function Register_Quest_Arcanium_Taken takes nothing returns nothing
    set gg_trg_Quest_Arcanium_Taken=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_Arcanium_Taken)
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Quest_Arcanium_Taken,EVENT_PLAYER_UNIT_PICKUP_ITEM)
    call TriggerAddCondition(gg_trg_Quest_Arcanium_Taken,Condition(function Trig_Quest_Arcanium_Taken_Conditions))
    call TriggerAddAction(gg_trg_Quest_Arcanium_Taken,function Trig_Quest_Arcanium_Taken_Actions)
endfunction

function Register_Quest_Arcanium_Complete takes nothing returns nothing
    set gg_trg_Quest_Arcanium_Complete=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_Arcanium_Complete)
    call TriggerRegisterUnitInRangeSimple(gg_trg_Quest_Arcanium_Complete,450.,gg_unit_Hmbr_0140)
    call TriggerAddCondition(gg_trg_Quest_Arcanium_Complete,Condition(function Trig_Quest_Arcanium_Complete_Conditions))
    call TriggerAddAction(gg_trg_Quest_Arcanium_Complete,function Trig_Quest_Arcanium_Complete_Actions)
endfunction

endlibrary
