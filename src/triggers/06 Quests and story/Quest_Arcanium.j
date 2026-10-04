library TQuestArcanium requires TQuestEngine, TCam, TCine, TForce, TPlayerHero, TReward, TText
// Side quest "Arcanium", written for the quest engine (QuestEngine module, docs/QUEST_ENGINE.md).
// Bali, smith at the Forge in the Barrens, asks the party to sneak into the collapsed northern mine for a
// nugget of Arcanium so he can forge Ziegfried's gear. Made available by Forge (QuestArcanium_Available).
// Step 2 stays in this module's own triggers: its dialogue moves the camera to Ziegfried and ends with a
// notice that is shown even when the cinematic is skipped. Does not count toward the story.
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Quest_Arcanium_Taken=null
    trigger gg_trg_Quest_Arcanium_Complete=null
    // The quest's number in the quest engine (0 until it is defined).
    integer QUEST_ARCANIUM=0
endglobals

// Step 1 done (the party talked to Bali): the Arcanium lies in the mine; the information shop sells a hint.
function QuestArcanium_Started takes nothing returns nothing
    local location l_tempPoint=GetRectCenter(gg_rct_564)
    call CreateItemLoc('mgtk',l_tempPoint) // 'mgtk': item "Arcanium"
    call RemoveLocation(l_tempPoint)
    call SetItemInvulnerableBJ(GetLastCreatedItem(),true)
    call EnableTrigger(gg_trg_Quest_Arcanium_Taken)
    call AddItemToStockBJ('I04U',gg_unit_n02Y_0052,1,1) // 'I04U': item "Information: Arcanium"
    set l_tempPoint=null
endfunction

function QuestArcanium_Define takes nothing returns nothing
    local integer q=Quest_Define("Arcanium",QUEST_SIDE,13,"ReplaceableTextures\\CommandButtons\\BTNPhilosophersStone.blp")
    set QUEST_ARCANIUM=q
    call Quest_NotStory(q)
    // 1. Talk to Bali
    call Quest_Talk(q,gg_unit_Hmbr_0140,"Bali, one of the dwarves managing the Forge in the Barrens, has told you of Arcanium, a very rare material lost in the collapsed mine of the Northern Mountains, entrance guarded by a massive fearsome beast. Sneak in and retrieve a nugget of Arcanium for him!")
    call Quest_Say(q,gg_unit_Hmbr_0140,"Lali-ho, adventurers! I am Bali, brother of Loki over there. We man this big smithy together.")
    call Quest_Say(q,null,"Bali, is it. Could I have you forge something for me then?")
    call Quest_Say(q,gg_unit_Hmbr_0140,"Certainly I don't mind helpin' ye out. I can do some fine forgin' for ye. But right now, there's a task we need to be takin' care of first and foremost.")
    call Quest_Say(q,gg_unit_Hmbr_0140,"See that Thunder Striker over there, Ziegfried? Maybe ye already heard, but he's hired as a mercenary to protect us at this lil' smithy. In exchange we promised to forge 'im something of great power.")
    call Quest_Say(q,null,"Sounds like it should be a simple task for you professional smiths, no?")
    call Quest_Say(q,gg_unit_Hmbr_0140,"Aye normally this'd be no problem. But Ziegfried has something very particular in mind - gear made from Arcanium.")
    call Quest_Say(q,gg_unit_Hmbr_0140,"A long time, before most of us were born, there was a time when we dwarves made gear of Arcanium. It was said that armor of Arcanium be impossible to penetrate by anything except weapons made of Arcanium themselves. Completely in a league of its own, no other gear could match it.")
    call Quest_Say(q,gg_unit_Hmbr_0140,"Then a tragedy occurred and the mine of Arcanium collapsed. Many dwarven lives were lost. Ever since then Arcanium has been lost and the weapons and armor made of it disappeared from the world.")
    call Quest_Say(q,null,"There was a material that strong? Sounds like a myth to me.")
    call Quest_Say(q,gg_unit_Hmbr_0140,"Nay, not a myth. Arcanium really exists. But it's all buried beneath the collapsed mine now, and even the collapsed entrance is guarded by a massive beast. There might still be some remnants of Arcanium over there. If so we'd be glad to be able to hold up our end of the bargain and make our mercenary the gear he desires. But with that beast there we can't even check.")
    call Quest_Say(q,null,"Perhaps I can sneak in and see if I can snatch it for you.")
    call Quest_Say(q,gg_unit_Hmbr_0140,"You'd do that for us? Hmm normally I'd be worried you'd try to run off with the material yourself but Mid did vouch for ye and it's not like you'd be able to make anything of this material without our help. It'd really help us out if you could do this.")
    call Quest_Say(q,gg_unit_Hmbr_0140,"But remember, don't even try to take that beast on yourself. It's impossible to harm with any normal weapons. If it catches you, just get out fast.")
    call Quest_OnDone(q,"QuestArcanium_Started")
    // 2. Bring the Arcanium to Bali (gg_trg_Quest_Arcanium_Taken / gg_trg_Quest_Arcanium_Complete)
    call Quest_Custom(q,"")
endfunction

// Called by Forge when Bali first appears at the Forge.
function QuestArcanium_Available takes nothing returns nothing
    if QUEST_ARCANIUM==0 then
        call QuestArcanium_Define()
    endif
    call Quest_MakeAvailable(QUEST_ARCANIUM)
endfunction

function Trig_Quest_Arcanium_Taken_Conditions takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='mgtk') // 'mgtk': item "Arcanium"
endfunction

// Someone picked up the Arcanium: only that player is told; the quest log changes for everyone.
function Trig_Quest_Arcanium_Taken_Actions takes nothing returns nothing
    local force l_tempForce
    call DisableTrigger(GetTriggeringTrigger())
    set l_tempForce=Force_OfPlayer(GetOwningPlayer(GetTriggerUnit()))
    call QuestMessageBJ(l_tempForce,bj_QUESTMESSAGE_UPDATED,"Bring the Arcanium to Bali Forgefire.")
    call DestroyForce(l_tempForce)
    call Quest_SetLog(QUEST_ARCANIUM,"Bring the Arcanium to Bali Forgefire.",false)
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

// Step 2: a hero brings the Arcanium to Bali. Bali forges Gram and the Primordial Armor for Ziegfried and
// starts merging gems; Ziegfried leaves for the mine if the dwarves were already rescued.
function Trig_Quest_Arcanium_Complete_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'mgtk')) // 'mgtk': item "Arcanium"
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
    call Quest_StepDone(QUEST_ARCANIUM,GetOwningPlayer(GetTriggerUnit()),GetTriggerUnit())
    call RemoveItem(UnitItemInSlotBJ(gg_unit_H036_0254,1))
    call RemoveItem(UnitItemInSlotBJ(gg_unit_H036_0254,4))
    call UnitAddItemByIdSwapped('I0KU',gg_unit_H036_0254) // 'I0KU': item "Gram"
    call UnitAddItemByIdSwapped('I0KV',gg_unit_H036_0254) // 'I0KV': item "Primordial Armor"
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
