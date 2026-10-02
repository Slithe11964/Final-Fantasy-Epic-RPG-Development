library TQuestNebraAngler requires TCam, TCine, TPlayerPart01, TReward, TText, TUnit
function Trig_Quest_NebraAngler_Start_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_n0AV_0247,true,true,true))
endfunction

function Trig_Quest_NebraAngler_Start_Cond_ShowDialog takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_NebraAngler_Start_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[68])
    if(Trig_Quest_NebraAngler_Start_Cond_ShowDialog())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Hmm? You're staring at me. Can I help you?",false)
        call Text_Say(gg_unit_n0AV_0247,"Oh it makes me happy to see someone fishing. My name is Anabel and I've been a passionate angler for many years.",false)
        call Text_Say(gg_unit_n0AV_0247,"Seems you are rather new to the craft though.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Well I haven't been fishing for very long, no.",false)
        call Text_Say(gg_unit_n0AV_0247,"After casting the rod you |cffffcc00need to wait until a fish bites (! symbol)|r, then start pulling the fish |cffffcc00in your direction, by mashing as fast as you can|r.",false)
        call Text_Say(gg_unit_n0AV_0247,"Of course the fish won't just let itself be caught. It will struggle. Pay close attention and |cffffcc00match its direction, either pulling left or right, but just once|r. Then you can return to pulling it towards you as fast as you can.",false)
        call Text_Say(gg_unit_n0AV_0247,"A good angler needs discipline of all kinds. Strength to pull the fish. Agility to be able to react to its struggles. Intelligence to get the best fish.",false)
        call Text_Say(gg_unit_n0AV_0247,"Of course you also need a solid fishing pole! You're very limited in what you can fish up if you go with just any regular old stick.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Wow this is a lot to take in at once...",false)
        call Text_Say(gg_unit_n0AV_0247,"Well you'll figure it out. Tell you what I'll be your mentor.",false)
        call Text_Say(gg_unit_n0AV_0247,"I want you to go out and fish up a Nebra Fish. It's one of the most basic landmark achievements for any budding angler.",false)
        call Text_Say(gg_unit_n0AV_0247,"Bring it to me and I'll help kickstart your path towards becoming an A+ angler! It'll be great!",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"(This woman is REALLY into fishing... but why not)",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Alright then, I'll find a Nebra Fish and bring it to you.",false)
        call Text_Say(gg_unit_n0AV_0247,"Sweet! Don't worry, I have full capabilities in your abilities, my student!",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Yes, my mentor !!",false)
        call Cine_ExitAction()
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_DISCOVERED,"New Quest Received: |cffffcc00Nebra Angler|r")
    set udg_SideQuest[49]=CreateQuestBJ(bj_QUESTTYPE_REQ_DISCOVERED,(udg_QuestNamePrefix+"Nebra Angler"),"Anabel, passionate night elf fisherwoman, explained to you the basics of proper fishing. Show her what you can do by bringing her a Nebra Fish!","ReplaceableTextures\\CommandButtons\\BTNTrade_Fishing.blp")
    set udg_SpecialEffect[68]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_n0AV_0247,"Objects\\RandomObject\\RandomObject.mdl")
    call EnableTrigger(gg_trg_Quest_NebraAngler_Reward)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Quest_NebraAngler_Reward_Conditions takes nothing returns boolean
    return((UnitHasItemOfTypeBJ(GetTriggerUnit(),'I0GT'))and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(udg_InCinematicMode==false))!=null // 'I0GT': item "Nebra Fish"
endfunction

function Trig_Quest_NebraAngler_Reward_Cond_FishHasCharges takes nothing returns boolean
    return(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I0GT'))>=2) // 'I0GT': item "Nebra Fish"
endfunction

function Trig_Quest_NebraAngler_Reward_Cond_ShowDialog takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_NebraAngler_Reward_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    if(Trig_Quest_NebraAngler_Reward_Cond_FishHasCharges())then
        // (item charges of GetItemOfTypeFromUnitBJ(the triggering unit, 'I0GT')) minus (1).
        call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I0GT'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I0GT'))-1)) // 'I0GT': item "Nebra Fish"
    else
        call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I0GT')) // 'I0GT': item "Nebra Fish"
    endif
    call DestroyEffectBJ(udg_SpecialEffect[68])
    if(Trig_Quest_NebraAngler_Reward_Cond_ShowDialog())then
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_n0AV_0247,0)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"Great news, my mentor! I have succeeded in the task you have set me on!",false)
        call Text_Say(gg_unit_n0AV_0247,"... who are you? Why are you calling me your mentor?",false)
        call Text_Say(gg_unit_n0AV_0247,"I don't deal with crazy people. Leave me alone.",false)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"Uh... I'm your student... remember?",false)
        call Text_Say(gg_unit_n0AV_0247,"What are you talking about? Why would I take on a student?",false)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"You told me to fish up a Nebra Fish and show it to you!",false)
        call Text_Say(gg_unit_n0AV_0247,"IS THAT A NEBRA FISH!?\r\n\r\n|cffffcc00Anabel snatches the fish from you and eats it.|r",false)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"Hey!",false)
        call Text_Say(gg_unit_n0AV_0247,"... sorry, sorry. My memories are coming back to me now.",false)
        call Text_Say(gg_unit_n0AV_0247,"To tell you the truth I'm a total screwup at fishing. I keep telling people I'm providing for myself but I haven't managed to catch any food in days.",false)
        call Text_Say(gg_unit_n0AV_0247,"I told you some ridiculous story just to get you to get me a good meal. God it was delicious though...",false)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"... so you lied to me about everything, did you.",false)
        call Text_Say(gg_unit_n0AV_0247,"Well I learned what it means to be a good angler from my late husband, but I never manage to catch any fish. I always only catch gold coins. It's really frustrating.",false)
        call Text_Say(gg_unit_n0AV_0247,"I'm really sorry. The least I can do for you is give you some of this gold I keep fishing up in return.",false)
        call Text_Say(gg_unit_n0AV_0247,"Oh and if you want a better fishing pole I can help you out with that as well.",false)
        call Reward_Give(6000,$BB8,gg_unit_n0AV_0247) // $BB8 = 3000
        call Text_Say(gg_unit_n0AV_0247,"|n|cffffcc00A new artifact is available for buying at the Ancient of Wonders.|r",true)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"Well *sigh* I guess I can't complain too much. Why don't you just admit to everyone that you can't get any fish?",false)
        call Text_Say(gg_unit_n0AV_0247,"If I do that I'll just be admitting defeat. I swore that I'd manage to get a real fish someday and the fear of starvation is the best motivator one could ask for, don't you think?",false)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"That sounds completely insane, actually. How have you even survived all this time?",false)
        call Text_Say(gg_unit_n0AV_0247,"Well my sisters do share some food with me sometimes...",false)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"You're a real troublemaker aren't you.",false)
        call Text_Say(gg_unit_n0AV_0247,"Hmm well they don't seem too upset. They seem more happy than disappointed that I can't seem to fish up anything but gold.",false)
        call Text_Say(gg_unit_n0AV_0247,"Still, I'll keep at it. Someday I'll fish up the king of the seas, I swear!",false)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"King of the Seas...?",false)
        call Text_Say(gg_unit_n0AV_0247,"The legendary Nebra King. It's out there somewhere, roaming the seas of the world... no angler has ever managed to defeat it.",false)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"Hmm, some old fisherman's legend I gather. Well good luck honing your fishing skills.",false)
        call Text_Say(gg_unit_n0AV_0247,"Thanks again for the fish. I'll work hard!",false)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"Sure.",false)
        call Cine_ExitAction()
    else
        call Reward_Give(6000,$BB8,gg_unit_n0AV_0247) // $BB8 = 3000
        call DisplayTimedTextToForce(udg_PlayingPlayers,10.,"|cffffcc00A new artifact is available for buying at the Ancient of Wonders.|r")
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_COMPLETED,"Quest Completed: |cffffcc00Nebra Angler|r")
    call QuestSetCompletedBJ(udg_SideQuest[49],true)
    set udg_QuestsCompleted=(udg_QuestsCompleted+1)
    call AddItemToStockBJ('I0EZ',gg_unit_n00L_0153,1,1) // 'I0EZ': item "Muramata"
    call EnableTrigger(gg_trg_Quest_KingOfSea_Reward)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function InitTrig_Quest_NebraAngler takes nothing returns nothing
endfunction

endlibrary
