library TQuestNebraAngler requires TQuestEngine
// Side quest "Nebra Angler", written for the quest engine (QuestEngine module, docs/QUEST_ENGINE.md).
// Anabel teaches the party to fish and wants a Nebra Fish - which she then eats. Made available by Anabel,
// which calls QuestNebraAngler_Available. Does not count toward the story.
globals
    // The quest's number in the quest engine (0 until it is defined).
    integer QUEST_NEBRA_ANGLER=0
endglobals

// Quest done: the Muramata is sold at the Ancient of Wonders, and Anabel rewards a King of the Sea catch.
function QuestNebraAngler_Done takes nothing returns nothing
    if udg_CinematicsDisabled then
        call DisplayTimedTextToForce(udg_PlayingPlayers,10.,"|cffffcc00A new artifact is available for buying at the Ancient of Wonders.|r")
    endif
    call AddItemToStockBJ('I0EZ',gg_unit_n00L_0153,1,1) // 'I0EZ': item "Muramata"
    call EnableTrigger(gg_trg_Quest_KingOfSea_Reward)
endfunction

function QuestNebraAngler_Define takes nothing returns nothing
    local integer q=Quest_Define("Nebra Angler",QUEST_SIDE,49,"ReplaceableTextures\\CommandButtons\\BTNTrade_Fishing.blp")
    set QUEST_NEBRA_ANGLER=q
    call Quest_NotStory(q)
    // 1. Talk to Anabel
    call Quest_Talk(q,gg_unit_n0AV_0247,"Anabel, passionate night elf fisherwoman, explained to you the basics of proper fishing. Show her what you can do by bringing her a Nebra Fish!")
    call Quest_Say(q,null,"Hmm? You're staring at me. Can I help you?")
    call Quest_Say(q,gg_unit_n0AV_0247,"Oh it makes me happy to see someone fishing. My name is Anabel and I've been a passionate angler for many years.")
    call Quest_Say(q,gg_unit_n0AV_0247,"Seems you are rather new to the craft though.")
    call Quest_Say(q,null,"Well I haven't been fishing for very long, no.")
    call Quest_Say(q,gg_unit_n0AV_0247,"After casting the rod you |cffffcc00need to wait until a fish bites (! symbol)|r, then start pulling the fish |cffffcc00in your direction, by mashing as fast as you can|r.")
    call Quest_Say(q,gg_unit_n0AV_0247,"Of course the fish won't just let itself be caught. It will struggle. Pay close attention and |cffffcc00match its direction, either pulling left or right, but just once|r. Then you can return to pulling it towards you as fast as you can.")
    call Quest_Say(q,gg_unit_n0AV_0247,"A good angler needs discipline of all kinds. Strength to pull the fish. Agility to be able to react to its struggles. Intelligence to get the best fish.")
    call Quest_Say(q,gg_unit_n0AV_0247,"Of course you also need a solid fishing pole! You're very limited in what you can fish up if you go with just any regular old stick.")
    call Quest_Say(q,null,"Wow this is a lot to take in at once...")
    call Quest_Say(q,gg_unit_n0AV_0247,"Well you'll figure it out. Tell you what I'll be your mentor.")
    call Quest_Say(q,gg_unit_n0AV_0247,"I want you to go out and fish up a Nebra Fish. It's one of the most basic landmark achievements for any budding angler.")
    call Quest_Say(q,gg_unit_n0AV_0247,"Bring it to me and I'll help kickstart your path towards becoming an A+ angler! It'll be great!")
    call Quest_Say(q,null,"(This woman is REALLY into fishing... but why not)")
    call Quest_Say(q,null,"Alright then, I'll find a Nebra Fish and bring it to you.")
    call Quest_Say(q,gg_unit_n0AV_0247,"Sweet! Don't worry, I have full capabilities in your abilities, my student!")
    call Quest_Say(q,null,"Yes, my mentor !!")
    // 2. Bring Anabel a Nebra Fish (one charge)
    call Quest_Deliver(q,gg_unit_n0AV_0247,'I0GT',1,"","") // 'I0GT': item "Nebra Fish"
    call Quest_Say(q,null,"Great news, my mentor! I have succeeded in the task you have set me on!")
    call Quest_Say(q,gg_unit_n0AV_0247,"... who are you? Why are you calling me your mentor?")
    call Quest_Say(q,gg_unit_n0AV_0247,"I don't deal with crazy people. Leave me alone.")
    call Quest_Say(q,null,"Uh... I'm your student... remember?")
    call Quest_Say(q,gg_unit_n0AV_0247,"What are you talking about? Why would I take on a student?")
    call Quest_Say(q,null,"You told me to fish up a Nebra Fish and show it to you!")
    call Quest_Say(q,gg_unit_n0AV_0247,"IS THAT A NEBRA FISH!?\r\n\r\n|cffffcc00Anabel snatches the fish from you and eats it.|r")
    call Quest_Say(q,null,"Hey!")
    call Quest_Say(q,gg_unit_n0AV_0247,"... sorry, sorry. My memories are coming back to me now.")
    call Quest_Say(q,gg_unit_n0AV_0247,"To tell you the truth I'm a total screwup at fishing. I keep telling people I'm providing for myself but I haven't managed to catch any food in days.")
    call Quest_Say(q,gg_unit_n0AV_0247,"I told you some ridiculous story just to get you to get me a good meal. God it was delicious though...")
    call Quest_Say(q,null,"... so you lied to me about everything, did you.")
    call Quest_Say(q,gg_unit_n0AV_0247,"Well I learned what it means to be a good angler from my late husband, but I never manage to catch any fish. I always only catch gold coins. It's really frustrating.")
    call Quest_Say(q,gg_unit_n0AV_0247,"I'm really sorry. The least I can do for you is give you some of this gold I keep fishing up in return.")
    call Quest_Say(q,gg_unit_n0AV_0247,"Oh and if you want a better fishing pole I can help you out with that as well.")
    call Quest_Reward(q,6000,3000)
    call Quest_Say(q,gg_unit_n0AV_0247,"|n|cffffcc00A new artifact is available for buying at the Ancient of Wonders.|r")
    call Quest_Say(q,null,"Well *sigh* I guess I can't complain too much. Why don't you just admit to everyone that you can't get any fish?")
    call Quest_Say(q,gg_unit_n0AV_0247,"If I do that I'll just be admitting defeat. I swore that I'd manage to get a real fish someday and the fear of starvation is the best motivator one could ask for, don't you think?")
    call Quest_Say(q,null,"That sounds completely insane, actually. How have you even survived all this time?")
    call Quest_Say(q,gg_unit_n0AV_0247,"Well my sisters do share some food with me sometimes...")
    call Quest_Say(q,null,"You're a real troublemaker aren't you.")
    call Quest_Say(q,gg_unit_n0AV_0247,"Hmm well they don't seem too upset. They seem more happy than disappointed that I can't seem to fish up anything but gold.")
    call Quest_Say(q,gg_unit_n0AV_0247,"Still, I'll keep at it. Someday I'll fish up the king of the seas, I swear!")
    call Quest_Say(q,null,"King of the Seas...?")
    call Quest_Say(q,gg_unit_n0AV_0247,"The legendary Nebra King. It's out there somewhere, roaming the seas of the world... no angler has ever managed to defeat it.")
    call Quest_Say(q,null,"Hmm, some old fisherman's legend I gather. Well good luck honing your fishing skills.")
    call Quest_Say(q,gg_unit_n0AV_0247,"Thanks again for the fish. I'll work hard!")
    call Quest_Say(q,null,"Sure.")
    call Quest_OnDone(q,"QuestNebraAngler_Done")
endfunction

// Called by Anabel when she appears.
function QuestNebraAngler_Available takes nothing returns nothing
    if QUEST_NEBRA_ANGLER==0 then
        call QuestNebraAngler_Define()
    endif
    call Quest_MakeAvailable(QUEST_NEBRA_ANGLER)
endfunction

function InitTrig_Quest_NebraAngler takes nothing returns nothing
endfunction

endlibrary
