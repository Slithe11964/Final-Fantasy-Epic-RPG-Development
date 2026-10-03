library TQuestDeliverLetter requires TQuestEngine, TGroup
// Side quest "Deliver Letter", written for the quest engine (QuestEngine module, docs/QUEST_ENGINE.md).
// Wedge in Kalm sends a letter to his brother Zack at the Farm; Zack sends one back. Made available by
// Cid and Epilogue, which run gg_trg_Quest_DeliverLetter_Available.
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Quest_DeliverLetter_Init=null
    trigger gg_trg_Quest_DeliverLetter_Available=null
    // The quest's number in the quest engine (0 until it is defined).
    integer QUEST_DELIVER_LETTER=0
    // Variables only this module uses (MapBootstrap sets some starting values).
    sound gg_snd_CaptainPissed=null
endglobals

// Step 1 done (the party talked to Wedge): his letter goes to the hero who talked to him.
function QuestDeliverLetter_Started takes nothing returns nothing
    call SetItemInvulnerable(UnitAddItemById(QuestDoneUnit,'k3m2'),true) // 'k3m2': item "Letter to Zack"
endfunction

// Step 2 done (Zack got the letter): Zack's answer and 150 gold coins go to the hero who brought it.
function QuestDeliverLetter_ZackAnswers takes nothing returns nothing
    call SetItemInvulnerable(UnitAddItemById(QuestDoneUnit,'phlt'),true) // 'phlt': item "Letter to Wedge"
    call UnitAddItemById(QuestDoneUnit,'I005') // 'I005': item "150 Gold Coins"
endfunction

// Quest done: Kiros arrives at the Farm, the dead farmers get their names and the news reports it.
function QuestDeliverLetter_Done takes nothing returns nothing
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
endfunction

function QuestDeliverLetter_Define takes nothing returns nothing
    local integer q=Quest_Define("Deliver Letter",QUEST_SIDE,10,"ReplaceableTextures\\CommandButtons\\BTNINV_Letter.BLP")
    set QUEST_DELIVER_LETTER=q
    // 1. Talk to Wedge
    call Quest_Talk(q,gg_unit_h00K_0137,"Wedge, footman from Kalm, asked you to deliver letter to his brother Zack who lives in the Farm.")
    call Quest_SayAs(q,gg_unit_h00K_0137,"Wedge",gg_snd_CaptainPissed,"I should've been a farmer like my father wanted.")
    call Quest_Say(q,gg_unit_h00K_0137,"But I chose to be a soldier and freelance newswriter instead. Well, at least my elder brother Zack inherited father's farm. I miss him a little. Say, if you come across the Farm south from Kalm could you please give my brother Zack this letter? I wrote it some time ago but with the recent growth of monster activity I couldn't ever make it through to give it to him.")
    call Quest_Say(q,null,"I'll see what I can do.")
    call Quest_Say(q,gg_unit_h00K_0137,"Thanks a lot.")
    call Quest_OnDone(q,"QuestDeliverLetter_Started")
    // 2. Give the letter to Zack
    call Quest_Deliver(q,gg_unit_n00K_0150,'k3m2',1,"","Bring Zack's letter to Wedge") // 'k3m2': item "Letter to Zack"
    call Quest_PingItem(q)
    call Quest_Say(q,null,"Hello. Are you Zack?")
    call Quest_Say(q,gg_unit_n00K_0150,"Yes, that's my name.")
    call Quest_Say(q,null,"Here's a letter for you from your brother Wedge. He'd like to know how you're doing.")
    call Quest_Say(q,gg_unit_n00K_0150,"A letter from my brother? Thank you very much. Unfortunately we are not doing well at the moment.")
    // only if the party saved Timmy (side quest 9)
    call Quest_SayIfSideQuestDone(q,9,gg_unit_n00K_0150,"You saved our youngest from the gnolls and we are incredibly thankful, but even so we're still shaken.")
    call Quest_Say(q,gg_unit_n00K_0150,"I'd like to write him a letter back to inform him of our circumstances... would you mind delivering it back to him?")
    call Quest_Say(q,null,"Sure.")
    call Quest_Say(q,gg_unit_n00K_0150,"Thank you.")
    call Quest_OnDone(q,"QuestDeliverLetter_ZackAnswers")
    // 3. Bring Zack's letter to Wedge
    call Quest_Deliver(q,gg_unit_h00K_0137,'phlt',1,"","") // 'phlt': item "Letter to Wedge"
    call Quest_PingItem(q)
    call Quest_Say(q,null,"Hi Wedge. We delivered your letter to Zack. Looks like he's not doing too well. He sent you this letter right back.")
    call Quest_Say(q,gg_unit_h00K_0137,"Oh dear, allow me to read this letter...")
    call Quest_Say(q,gg_unit_h00K_0137,"Damn it, the Farm is affected most horribly by this uprising of monsters... five men dead... my god.")
    call Quest_Say(q,gg_unit_h00K_0137,"Thank you for bringing me this letter... the town must know of the horrible state of the Farm. I will write about it in my newspaper immediately, both to spread awareness and to honor the dead.")
    call Quest_Say(q,gg_unit_h00K_0137,"Johnny... Wirt... Bill... Tseng... Laguna... I won't let you be forgotten...")
    call Quest_Say(q,gg_unit_h00K_0137,"Anyways, sorry to bother you with this. Here's some gold for your trouble.")
    call Quest_Reward(q,500,500)
    call Quest_OnDone(q,"QuestDeliverLetter_Done")
endfunction

function Trig_Quest_DeliverLetter_Init_Enum_MakeCorpse takes nothing returns nothing
    call SetUnitVertexColorBJ(GetEnumUnit(),'d',.0,.0,0)
    call SetUnitAnimation(GetEnumUnit(),"decay flesh")
    call SetUnitTimeScalePercent(GetEnumUnit(),.0)
    call SetUnitLifeBJ(GetEnumUnit(),1.)
endfunction

// Map start: Wedge sells the news, and the Farm's dead lie where they fell.
function Trig_Quest_DeliverLetter_Init_Actions takes nothing returns nothing
    call UnitAddAbilityBJ('Aneu',gg_unit_h00K_0137) // 'Aneu': standard ability reference "Neutral Building"
    call AddItemToStockBJ('I03R',gg_unit_h00K_0137,1,1) // 'I03R': item "Kalm News"
    set udg_FarmCorpses=Group_UnitsInRectOfPlayer(gg_rct_580,Player(8))
    call ForGroupBJ(udg_FarmCorpses,function Trig_Quest_DeliverLetter_Init_Enum_MakeCorpse)
    call SetUnitLifePercentBJ(gg_unit_nten_0232,10.)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Quest_DeliverLetter_Available_Actions takes nothing returns nothing
    if QUEST_DELIVER_LETTER==0 then
        call QuestDeliverLetter_Define()
    endif
    call Quest_MakeAvailable(QUEST_DELIVER_LETTER)
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

endlibrary
