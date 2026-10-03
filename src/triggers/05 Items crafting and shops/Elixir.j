library TElixir requires TQuestEngine
// Side quest "Elixir", written for the quest engine (QuestEngine module, docs/QUEST_ENGINE.md).
// Fire, the Pandaren merchant in Kalm, wants an Elixir to study; afterwards he buys rare potions and later
// sells Elixirs himself. Made available by QuestCount (4 story quests done), which runs gg_trg_Elixir_Prepare.
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Elixir_Prepare=null
    // The quest's number in the quest engine (0 until it is defined).
    integer QUEST_ELIXIR=0
endglobals

// 3 minutes after the quest: Fire sells Elixirs and the news reports it.
function Elixir_FireSellsElixir takes nothing returns nothing
    call DestroyTimer(GetExpiredTimer())
    call DisplayTextToForce(GetPlayersAll(),"|cff00ffffFire's stock contains a new item for sale !!!|r")
    call AddItemToStockBJ('pres',gg_unit_n02K_0073,0,99) // 'pres': item "Elixir"
    set udg_StoryFlag[2]=true
    set udg_NewsText[3]=udg_NewsText[2]
    set udg_NewsText[2]=udg_NewsText[1]
    set udg_NewsText[6]=udg_NewsText[5]
    set udg_NewsText[5]=udg_NewsText[4]
    set udg_NewsText[1]="|cffffcc00Fire Sells Elixir|r"
    set udg_NewsText[4]="Thanks to the adventurers, Fire got an Elixir and studied it. Now he sells them!"
endfunction

// Quest done: Fire starts buying rare potions (module Fire).
function Elixir_Done takes nothing returns nothing
    set udg_StoryFlag[4]=false
    call EnableTrigger(gg_trg_Fire_Pawn_HeroDrink)
    call EnableTrigger(gg_trg_Fire_Pawn_Nectar)
    call EnableTrigger(gg_trg_Fire_Pawn_SpiritPotion)
    call EnableTrigger(gg_trg_Fire_Pawn_BloodEther)
    call TimerStart(CreateTimer(),180.,false,function Elixir_FireSellsElixir)
endfunction

function Elixir_Define takes nothing returns nothing
    local integer q=Quest_Define("Elixir",QUEST_SIDE,19,"ReplaceableTextures\\CommandButtons\\BTNPotionOfRestoration.blp")
    set QUEST_ELIXIR=q
    // 1. Talk to Fire
    call Quest_Talk(q,gg_unit_n001_0012,"Fire, Pandaren Merchant from Kalm, asked you to bring him Elixir.")
    call Quest_SayAs(q,gg_unit_n001_0012,"Fire",null,"Fresh, cool ale... is what you won't find here. But I have plenty of potions and ether, as well as some other items. I can also buy items you want to sell.")
    call Quest_SayAs(q,gg_unit_n001_0012,"Fire",null,"And if ever in your journeys you find Elixir please bring it to me. I am very interested in learning ancient potion-making techniques and studying the legendary Elixir will be of great help to me. Of course I will pay more gold than you would otherwise get for selling it.")
    // 2. Bring an Elixir to Fire
    call Quest_Deliver(q,gg_unit_n001_0012,'pres',1,"","") // 'pres': item "Elixir"
    call Quest_Say(q,null,"Fire, you should be happy - here's the Elixir you asked for.")
    call Quest_SayAs(q,gg_unit_n001_0012,"Fire",null,"Excellent! Thank you very much!")
    call Quest_Reward(q,4000,500)
    call Quest_SayAs(q,gg_unit_n001_0012,"Fire",null,"Oh, and I'm always interested in exquisite potions. If you find a rare one, please tell me.")
    call Quest_OnDone(q,"Elixir_Done")
endfunction

function Trig_Elixir_Prepare_Actions takes nothing returns nothing
    if QUEST_ELIXIR==0 then
        call Elixir_Define()
    endif
    call Quest_MakeAvailable(QUEST_ELIXIR)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_Elixir automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Elixir (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Elixir takes nothing returns nothing
endfunction

function Register_Elixir_Prepare takes nothing returns nothing
    set gg_trg_Elixir_Prepare=CreateTrigger()
    call DisableTrigger(gg_trg_Elixir_Prepare)
    call TriggerAddAction(gg_trg_Elixir_Prepare,function Trig_Elixir_Prepare_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Elixir takes nothing returns nothing
    call Register_Elixir_Prepare() // starts off; run by QuestCount
endfunction

endlibrary
