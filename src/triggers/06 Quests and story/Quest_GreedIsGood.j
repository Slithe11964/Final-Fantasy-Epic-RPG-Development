library TQuestGreedIsGood requires TQuestEngine
// Side quest "Greed is Good", written for the quest engine (QuestEngine module, docs/QUEST_ENGINE.md).
// Melaniya, a former thief, sends the party to the thieves' hideout for the Portal Stone, then teleports
// away with it. Available from the start: Melaniya (module Melaniya) calls QuestGreedIsGood_Available.
// Does not count toward the story.
globals
    // The quest's number in the quest engine (0 until it is defined).
    integer QUEST_GREED_IS_GOOD=0
    effect QuestGreedIsGood_TeleportEffect=null
endglobals

function QuestGreedIsGood_Enum_RevealGuard takes nothing returns nothing
    call ShowUnitShow(GetEnumUnit())
    call PauseUnitBJ(false,GetEnumUnit())
    call SetUnitInvulnerable(GetEnumUnit(),false)
endfunction

// Step 1 done (the party talked to Melaniya): the hideout guards appear.
function QuestGreedIsGood_Started takes nothing returns nothing
    call ForGroup(udg_HideoutGuards,function QuestGreedIsGood_Enum_RevealGuard)
endfunction

// Step 2 done (the hideout boss died): it drops the Portal Stone.
function QuestGreedIsGood_DropStone takes nothing returns nothing
    call CreateItem('I034',GetUnitX(gg_unit_nmgv_0115),GetUnitY(gg_unit_nmgv_0115)) // 'I034': item "Portal Stone"
endfunction

function QuestGreedIsGood_Vanish takes nothing returns nothing
    call DestroyTimer(GetExpiredTimer())
    call DestroyEffect(QuestGreedIsGood_TeleportEffect)
    set QuestGreedIsGood_TeleportEffect=null
    call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl",GetUnitX(gg_unit_n01S_0082),GetUnitY(gg_unit_n01S_0082)))
    call RemoveUnit(gg_unit_n01S_0082)
endfunction

// Quest done: Melaniya teleports away (after 3 seconds; at once when cinematics are off), and Kiros offers
// the Phantom Dancer hunt.
function QuestGreedIsGood_Done takes nothing returns nothing
    call AddUnitToStockBJ('n0BF',gg_unit_n0BV_0229,1,1) // 'n0BF': unit "Hunt: Phantom Dancer"
    set udg_HuntStock[5]=udg_HuntStock[5]+1
    call ConditionalTriggerExecute(gg_trg_Hunt_Board_Markers)
    if udg_CinematicsDisabled then
        call TimerStart(CreateTimer(),0.,false,function QuestGreedIsGood_Vanish)
    else
        set QuestGreedIsGood_TeleportEffect=AddSpecialEffect("Abilities\\Spells\\Human\\MassTeleport\\MassTeleportTo.mdl",GetUnitX(gg_unit_n01S_0082),GetUnitY(gg_unit_n01S_0082))
        call TimerStart(CreateTimer(),3.,false,function QuestGreedIsGood_Vanish)
    endif
endfunction

function QuestGreedIsGood_Define takes nothing returns nothing
    local integer q=Quest_Define("Greed is Good",QUEST_SIDE,27,"ReplaceableTextures\\CommandButtons\\BTNSpellShieldAmulet.blp")
    set QUEST_GREED_IS_GOOD=q
    call Quest_NotStory(q)
    // 1. Talk to Melaniya
    call Quest_Talk(q,gg_unit_n01S_0082,"Melaniya, former thief hiding in the Mountains, asked you to go to the secret thieves' hideout, kill guards and bring her Portal Stone.")
    call Quest_Say(q,gg_unit_n01S_0082,"I am so glad to meet you! My name is Melaniya and I heard much about you. You are those famous adventurers.")
    call Quest_Say(q,null,"And why are you so happy to see us?")
    call Quest_Say(q,gg_unit_n01S_0082,"I want to offer you a deal. It just so happens that I know the location of a secret thieves' hideout. But it is guarded by thieves and fearsome jungle beasts. I will tell where to find this hideout, you'll go wipe out the guards and take the treasure but share it with me.")
    call Quest_Say(q,null,"Hmm.. sounds fishy. How do you know about this hideout if it's \"secret\".")
    call Quest_Say(q,gg_unit_n01S_0082,"Well, umm, I was one of these thieves. But as soon as members of our band started to fall under someone's control I decided to leave.")
    call Quest_Say(q,null,"Fall under someone's control? What do you mean?")
    call Quest_Say(q,gg_unit_n01S_0082,"We all started to hear a voice in our heads. And that voice commanded us to submit to the will of .. what was his name?... Kashalut or Kashalom?... never mind... to the will of this sorcerer.")
    call Quest_Say(q,gg_unit_n01S_0082,"I am a White Mage, my role in band was to heal injured thieves and their victims. I joined the band on that terms. I heal bandits but also their victims. I just wanted no one to die.")
    call Quest_Say(q,gg_unit_n01S_0082,"Because of my magical knowledge I was able to resist the spell. Also, I am High Elf and we Elves have some innate resistance to most types of mind control. That's why I escaped. Now I am under Resist Domination Spell and will not submit to this sorceror's will.")
    call Quest_Say(q,gg_unit_n01S_0082,"Of course I am no altruist and I had my share of the band's loot. I have enough gold with me, but I am an outlaw. If I go back to Kalm I'll be arrested and put into jail.")
    call Quest_Say(q,gg_unit_n01S_0082,"So I need the Portal Stone that is kept in the secret hideout. Once I get my hands on it I'll be able to teleport away from this Plane. I always wanted to visit Aden...")
    call Quest_Say(q,gg_unit_n01S_0082,"So please bring me the Portal Stone. Take the rest for yourself. Also know that without me you will never get into hideout - I enchanted it with an Invisibility Enchantment and only I know how to properly disenchant it. Well, do you agree?")
    call Quest_Say(q,null,"Ok. Tell us where this hideout is.")
    call Quest_Say(q,gg_unit_n01S_0082,"It is to the northwest of the Farm that supplies Kalm with food. I'll mark its location on your map.")
    call Quest_Say(q,null,"Good. And remember -  if you are trying to lure us into a trap you will regret it when we have all your fellow thieves dead and come back for you.")
    call Quest_OnDone(q,"QuestGreedIsGood_Started")
    // 2. Kill the hideout's boss (no announcement: the log changes when the stone is picked up)
    call Quest_Kill(q,gg_unit_nmgv_0115,"")
    call Quest_PingUnit(q)
    call Quest_OnDone(q,"QuestGreedIsGood_DropStone")
    // 3. Bring the Portal Stone to Melaniya
    call Quest_Deliver(q,gg_unit_n01S_0082,'I034',1,"","") // 'I034': item "Portal Stone"
    call Quest_PingItem(q)
    call Quest_OnPickup(q,"Bring the Portal Stone to Melaniya.","")
    call Quest_Say(q,null,"I have the Portal Stone with me. Here you go.")
    call Quest_Say(q,gg_unit_n01S_0082,"Thank you very much. Now I can escape this dangerous world. If you ever do the same, do drop by on Aden and see me.")
    call Quest_Reward(q,2500,2500)
    call Quest_Say(q,gg_unit_n01S_0082,"Bye.")
    call Quest_OnDone(q,"QuestGreedIsGood_Done")
endfunction

// Called by Melaniya at map start.
function QuestGreedIsGood_Available takes nothing returns nothing
    if QUEST_GREED_IS_GOOD==0 then
        call QuestGreedIsGood_Define()
    endif
    call Quest_MakeAvailable(QUEST_GREED_IS_GOOD)
endfunction

function InitTrig_Quest_GreedIsGood takes nothing returns nothing
endfunction

endlibrary
