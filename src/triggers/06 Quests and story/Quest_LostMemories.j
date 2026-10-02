library TQuestLostMemories requires TCam, TCine, TMusic, TPlayerPart01, TReward, TText, TUnit, TWait
globals
    // Variables only this module uses.
    unit udg_MementoRingHero=null
endglobals

function Trig_Quest_LostMemories_Start_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_e00V_0009,true,true,true))
endfunction

function Trig_Quest_LostMemories_Start_Cond_HasFadedRing_NoTalk takes nothing returns boolean
    return(UnitHasItemOfTypeBJ(Player_GetHero(GetTriggerPlayer()),'I0DS')) // 'I0DS': item "Memento Ring"
endfunction

function Trig_Quest_LostMemories_Start_Cond_HasFadedRing takes nothing returns boolean
    return(UnitHasItemOfTypeBJ(Player_GetHero(GetTriggerPlayer()),'I0DS')) // 'I0DS': item "Memento Ring"
endfunction

function Trig_Quest_LostMemories_Start_Cond_ShowDialog takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_LostMemories_Start_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[66])
    if(Trig_Quest_LostMemories_Start_Cond_ShowDialog())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(gg_unit_e00V_0009,".....",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),".....",false)
        call Text_Say(gg_unit_e00V_0009,".....",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),".....",false)
        call Text_Say(gg_unit_e00V_0009,".....",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),".....",false)
        call Text_Say(gg_unit_e00V_0009,".....",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),".....",false)
        call Text_Say(gg_unit_e00V_0009,"...what do you want.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Oh my god it can talk! It's a miracle!",false)
        call Text_Say(gg_unit_e00V_0009,"What's with you!?",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Oh, nothing, nothing. I was just wondering about the big yellow exclamation mark over your head. Seemed like you had something to tell me.",false)
        call Text_Say(gg_unit_e00V_0009,"And why would I have something to say to a random stranger who stares at me like I'm some kind of rare animal?",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Well I was hoping you could answer that very same question for me.",false)
        call Text_Say(gg_unit_e00V_0009,"Well I've got nothing to say to you. Go away.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"What...? Are you telling me the yellow exclamation mark lied to me?",false)
        call Text_Say(gg_unit_e00V_0009,"I have no idea what you're talking about!",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Well this is going nowhere fast. Why are you so downcast anyways?",false)
        call Text_Say(gg_unit_e00V_0009,"And why would that be any of your business?",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Come now, don't be like that. I should be able to help you, whatever it may be?",false)
        call Text_Say(gg_unit_e00V_0009,"You don't even have any idea what it is! How could you possibly think you can help me?",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Because that's how it works!",false)
        call Text_Say(gg_unit_e00V_0009,"Nothing you say makes any sense...",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),("*sigh* this is troubling. Alright let's start over. Hello, my name is "+(GetPlayerName(GetTriggerPlayer())+" and a certain someone wants me to help you with your problem.")),false)
        call Text_Say(gg_unit_e00V_0009,(GetPlayerName(GetTriggerPlayer())+"...? Oh, you're the person who came from Kalm! Did Celeborn tell you to talk to me?"),false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Uh... something like that.",false)
        call Text_Say(gg_unit_e00V_0009,"Ah well then. I feel relieved. I thought you were just some crazy person, randomly talking to a girl you just met and offering to \"help her with her problems\".",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"...well don't worry, it's not like I was ordered by a god from above to speak to you or anything...",false)
        call Text_Say(gg_unit_e00V_0009,"Haha, you seem to have a sense of humor at least. Sorry for being so suspicious at first.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Let's just get on with it.",false)
        call Text_Say(gg_unit_e00V_0009,"Okay, if Celeborn trusts you I will too.",false)
        call Text_Say(gg_unit_e00V_0009,"I'm looking for a certain person: my father. He's my only remaining relative, even though I haven't seen him in years.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Why is that?",false)
        call Text_Say(gg_unit_e00V_0009,"He left us. Apparently he went looking for someone or something. I don't really remember well. But now after all this time... I want to meet him once more.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"I see. Do you have any idea where he might be? If he's not even in this world I won't be able to find him either.",false)
        call Text_Say(gg_unit_e00V_0009,"I have here a ring. It's a memento from my mother. My father gave it to her a long time ago, and it reacts to his presence with a faint glow. I can say for sure that he must be somewhere in this world.",false)
        call Text_Say(gg_unit_e00V_0009,"I've looked for him for a while now, but I still have no clue where he could be...",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Alright, that's good enough. If I find him, I'll tell you.",false)
        call Text_Say(gg_unit_e00V_0009,"Here, take the ring. As long as its glow does not disappear, I'm sure you'll find him. Please...",false)
        if(Trig_Quest_LostMemories_Start_Cond_HasFadedRing())then
            call Text_Transmission(gg_unit_e00V_0009,"Relm","Here, take the ring. As long as its glow does not disappear, I'm sure you'll find him. Please... ...wait...","Here, take the ring. As long as its glow does not disappear, I'm sure you'll find him. Please...",null,0,false)
            call Text_Transmission(gg_unit_e00V_0009,"Relm","Here, take the ring. As long as its glow does not disappear, I'm sure you'll find him. Please... ...wait... that ring you're wearing..:!","Here, take the ring. As long as its glow does not disappear, I'm sure you'll find him. Please... ...wait...",null,0,false)
            call Text_Say(gg_unit_e00V_0009,"Is... isn't that the exact same ring?!",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"Now that you mention it... it does seem that way.",false)
            call Text_Say(gg_unit_e00V_0009,"How... did you get that?!",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"Uhm... I don't recall. I pick up a lot of rings and items so I don't remember where I got all of them from. Sorry.",false)
            call Text_Say(gg_unit_e00V_0009,"So you just got it from somewhere... I see.",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"Maybe they're just two rings of the same kind?",false)
            call Text_Say(gg_unit_e00V_0009,"That's possible. Sorry, I got worked up. Besides, your ring doesn't glow.",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"Yeah, it doesn't. Does that mean the person my ring reacts to is not in this world?",false)
            call Text_Say(gg_unit_e00V_0009,"Well actually they might be. If these rings lose their glow once, their link to the target is severed forever, so they will not glow again even if their target returns.",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"What if the ring itself had been brought to another world? Wouldn't the same thing happen?",false)
            call Text_Say(gg_unit_e00V_0009,"No, that's not possible. These rings are crafted here, and they are absolutely bound to Gaya. If these rings were to leave this world, they would shatter in an instant.",false)
            call Text_Say(gg_unit_e00V_0009,"So I don't know who that ring of yours reacts to, but it seems unlikely you'll find them with it.",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"Alright then. I'll be looking for your father.",false)
            call EnableTrigger(gg_trg_Quest_LostMemories_ShadowTruth)
        else
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"Don't worry. I will definitely find him.",false)
            call EnableTrigger(gg_trg_Quest_LostMemories_ShadowLie)
        endif
        call Cine_ExitAction()
    else
        if(Trig_Quest_LostMemories_Start_Cond_HasFadedRing_NoTalk())then
            call EnableTrigger(gg_trg_Quest_LostMemories_ShadowTruth)
        else
            call EnableTrigger(gg_trg_Quest_LostMemories_ShadowLie)
        endif
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_DISCOVERED,"New Quest Received: |cffffcc00Lost Memories|r")
    set udg_SideQuest[44]=CreateQuestBJ(bj_QUESTTYPE_REQ_DISCOVERED,(udg_QuestNamePrefix+"Lost Memories"),"Relm, a young archer from Lothlorien, is looking for her father whom she hasn't met in years. Find her father and reunite the long separated family!","ReplaceableTextures\\CommandButtons\\BTNRingVioletSpider.blp")
    set udg_SpecialEffect[66]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_e00V_0009,"Objects\\RandomObject\\RandomObject.mdl")
    set udg_MementoRingHero=Player_GetHero(GetTriggerPlayer())
    call EnableTrigger(gg_trg_Quest_LostMemories_Pickup)
    call UnitAddItemByIdSwapped('I0DQ',Player_GetHero(GetTriggerPlayer())) // 'I0DQ': item "Memento Ring"
    call SetItemInvulnerableBJ(GetLastCreatedItem(),true)
    call AddItemToStockBJ('I0E4',gg_unit_n02Y_0052,1,1) // 'I0E4': item "Information: Memento Ring"
    call EnableTrigger(gg_trg_Quest_LostMemories_RingFade)
    call ConditionalTriggerExecute(gg_trg_Quest_LostMemories_RingFade)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Quest_LostMemories_RingFade_Conditions takes nothing returns boolean
    return(IsTriggerEnabled(GetTriggeringTrigger()))and(udg_ShadowLoyalty<=0)and(udg_ShadowUnit==null)
endfunction

function Trig_Quest_LostMemories_RingFade_Actions takes nothing returns nothing
    call DisableTrigger(gg_trg_Quest_LostMemories_ShadowLie)
    call DisableTrigger(gg_trg_Quest_LostMemories_Pickup)
    call DestroyTrigger(gg_trg_Quest_LostMemories_ShadowLie)
    call DestroyTrigger(gg_trg_Quest_LostMemories_Pickup)
    call RemoveItemFromStockBJ('I0E4',gg_unit_n02Y_0052) // 'I0E4': item "Information: Memento Ring"
    call Wait_Polled(60.)
    call EnableTrigger(gg_trg_Quest_LostMemories_Fail)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Quest_LostMemories_Fail_Conditions takes nothing returns boolean
    return((UnitHasItemOfTypeBJ(GetTriggerUnit(),'I0DQ'))and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(udg_InCinematicMode==false))!=null // 'I0DQ': item "Memento Ring"
endfunction

function Trig_Quest_LostMemories_Fail_Cond_ShowDialog takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_LostMemories_Fail_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[66])
    call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I0DQ')) // 'I0DQ': item "Memento Ring"
    if(Trig_Quest_LostMemories_Fail_Cond_ShowDialog())then
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_e00V_0009,0)
        call Text_Say(gg_unit_e00V_0009,"The ring... the glow is gone.",false)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"We are sorry. It seems your father is no longer in this world.",false)
        call Text_Say(gg_unit_e00V_0009,"...",false)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"....",false)
        call Text_Say(gg_unit_e00V_0009,"...that's alright. It can't be helped, then.",false)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"If you leave this plane, you may still have a chance of meeting him someday.",false)
        call Text_Say(gg_unit_e00V_0009,"Thanks... but I won't. This is my home, the place I really belong. It's always been that way.",false)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"Are you giving up?",false)
        call Text_Say(gg_unit_e00V_0009,"...it's unlikely he will ever be able to return to Gaya, isn't it?",false)
        call Text_Say(gg_unit_e00V_0009,"You may... keep this ring. I... don't want to have it anymore.",false)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"I understand.",false)
        call Cine_ExitAction()
    endif
    call QuestSetDescriptionBJ(udg_SideQuest[44],"The Memento Ring has lost its glow, indicating that Relm's father is no longer in this world.")
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_FAILED,"Quest Failed: |cffffcc00Lost Memories|r")
    call QuestSetFailedBJ(udg_SideQuest[44],true)
    set udg_QuestsTotal=(udg_QuestsTotal-1)
    call UnitAddItemByIdSwapped('I0DS',GetTriggerUnit()) // 'I0DS': item "Memento Ring"
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Quest_LostMemories_Pickup_Conditions takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(GetItemTypeId(GetManipulatedItem())=='I0DQ') // 'I0DQ': item "Memento Ring"
endfunction

function Trig_Quest_LostMemories_Pickup_Actions takes nothing returns nothing
    set udg_MementoRingHero=Player_GetHero(GetOwningPlayer(GetTriggerUnit()))
endfunction

function Trig_Quest_LostMemories_ShadowLie_Conditions takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='I0DQ')and(GetTriggerUnit()==udg_ShadowUnit) // 'I0DQ': item "Memento Ring"
endfunction

function Trig_Quest_LostMemories_ShadowLie_Cond_ShowDialog takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_LostMemories_ShadowLie_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call UnitPauseTimedLifeBJ(true,udg_ShadowUnit)
    call DestroyEffectBJ(udg_SpecialEffect[66])
    call RemoveItemFromStockBJ('I0E4',gg_unit_n02Y_0052) // 'I0E4': item "Information: Memento Ring"
    call RemoveItem(GetManipulatedItem())
    if(Trig_Quest_LostMemories_ShadowLie_Cond_ShowDialog())then
        call Cine_Enter()
        call Cam_PanToUnit(udg_ShadowUnit,0)
        call Text_Say(udg_ShadowUnit,"...!",false)
        call Text_Say(udg_ShadowUnit,"That ring...",false)
        call Text_Say(udg_MementoRingHero,"Do you recognize this ring?",false)
        call Text_Say(udg_ShadowUnit,"...",false)
        call Text_Say(udg_MementoRingHero,"Shadow?",false)
        call Text_Say(udg_ShadowUnit,"...",false)
        call Text_Say(udg_MementoRingHero,"Shadow... are you Relm's father?",false)
        call Text_Say(udg_ShadowUnit,"...",false)
        call Text_Say(udg_MementoRingHero,"It's you, isn't it?",false)
        call Text_Say(udg_ShadowUnit,"...",false)
        call Text_Say(udg_MementoRingHero,"She's... been looking for you.",false)
        call Text_Say(udg_ShadowUnit,"...",false)
        call Text_Say(udg_ShadowUnit,"No...",false)
        call Text_Say(udg_MementoRingHero,"...?",false)
        call Text_Say(udg_ShadowUnit,"It's not me... I'm not her father.",false)
        call Text_Say(udg_ShadowUnit,"But... I do know that ring. All too well.",false)
        call Text_Say(udg_MementoRingHero,"How is that possible? If you're not her father, who is?",false)
        call Text_Say(udg_ShadowUnit,"...",false)
        call Text_Say(udg_ShadowUnit,"It was... my friend and coworker.",false)
        call Text_Say(udg_MementoRingHero,"Your friend... and coworker?",false)
        call Text_Say(udg_ShadowUnit,"\"Shadow\" was originally the name of a two-man-group. Me and my partner would do this business together.",false)
        call Text_Say(udg_ShadowUnit,"But sometime back the two of us took on more than we could handle. We found a treasure worth a million gil... but the authorities caught us.",false)
        call Text_Say(udg_ShadowUnit,"My partner was wounded... and he asked me to kill him to avoid being captured...",false)
        call Text_Say(udg_ShadowUnit,"...I couldn't do it. I couldn't kill the partner who'd been by my side for so long.",false)
        call Text_Say(udg_ShadowUnit,"And then...",false)
        call Text_Say(udg_ShadowUnit,"...",false)
        call Text_Say(udg_MementoRingHero,"It's okay. You don't need to force yourself.",false)
        call Text_Say(udg_ShadowUnit,"...thank you.",false)
        call Text_Say(udg_ShadowUnit,"I've carried on the legacy of \"Shadow\" on my own ever since.",false)
        call Text_Say(udg_ShadowUnit,"This ring... my partner boasted about it when he had it made. He'd looked so happy in that moment, I could never forget about it.",false)
        call Text_Say(udg_ShadowUnit,"So Relm... she's been looking... has she.",false)
        call Text_Say(udg_ShadowUnit,"...",false)
        call Text_Say(udg_ShadowUnit,"May I keep this ring?",false)
        call Text_Say(udg_MementoRingHero,"Relm gave it to me to look for her father. It seems I won't need it any longer... but she may want it back as a memento.",false)
        call Text_Say(udg_ShadowUnit,"I see... you're right. But please... don't tell Relm about what happened.",false)
        call Text_Say(udg_MementoRingHero,"Why not?",false)
        call Text_Say(udg_ShadowUnit,"I could never face her after what happened... but I believe it is better to preserve her hope that her father would return to her someday.",false)
        call Text_Say(udg_ShadowUnit,"She doesn't need to know...",false)
        call Text_Say(udg_MementoRingHero,"Don't you think she has a right to know?",false)
        call Text_Say(udg_ShadowUnit,"Don't you think she should have a right NOT to know?",false)
        call Text_Say(udg_MementoRingHero,"...",false)
        call Text_Say(udg_ShadowUnit,"She would only be worse off for knowing. There's no need to force that on her.",false)
        call Text_Say(udg_MementoRingHero,"Are you sure that this is for the best?",false)
        call Text_Say(udg_ShadowUnit,"Yes...",false)
        call Text_Say(udg_MementoRingHero,"...fine. Keep the ring. I won't tell Relm. If she asks, I'll tell her I'm still looking.",false)
        call Text_Say(udg_ShadowUnit,"I'm very grateful. I was afraid you wouldn't listen. If you had insisted... I would have struck you down.",false)
        call Text_Say(udg_MementoRingHero,"Whoa... glad it didn't come to that!",false)
        call Text_Say(udg_ShadowUnit,"I'll need some time to think. Here I'll give you some of my gold as thanks. Should we meet again, I won't charge you anymore.",false)
        call Text_Say(udg_MementoRingHero,"That's great! Well then, until next time.",false)
        // ((udg_ShadowLoyalty) times (100)) plus (1000).
        call Reward_Give(((udg_ShadowLoyalty*'d')+$3E8),5000,udg_ShadowUnit) // $3E8 = 1000
        call Cine_ExitAction()
    else
        // ((udg_ShadowLoyalty) times (100)) plus (1000).
        call Reward_Give(((udg_ShadowLoyalty*'d')+$3E8),5000,udg_ShadowUnit) // $3E8 = 1000
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_COMPLETED,"Quest Completed: |cffffcc00Lost Memories|r")
    call QuestSetCompletedBJ(udg_SideQuest[44],true)
    set udg_QuestsCompleted=(udg_QuestsCompleted+1)
    // Increase udg_ShadowLoyalty by 128.
    set udg_ShadowLoyalty=(udg_ShadowLoyalty+$80) // $80 = 128
    call SaveIntegerBJ(1,2,$A3,udg_GameStateHash) // $A3 = 163
    call Music_SetTrack(32)
    call TriggerExecute(gg_trg_Shadow_Death)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Quest_LostMemories_ShadowTruth_Conditions takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='I0DQ')and(GetTriggerUnit()==udg_ShadowUnit) // 'I0DQ': item "Memento Ring"
endfunction

function Trig_Quest_LostMemories_ShadowTruth_Cond_ShowDialog takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_LostMemories_ShadowTruth_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call UnitPauseTimedLifeBJ(true,udg_ShadowUnit)
    call DestroyEffectBJ(udg_SpecialEffect[66])
    call RemoveItemFromStockBJ('I0E4',gg_unit_n02Y_0052) // 'I0E4': item "Information: Memento Ring"
    call RemoveItem(GetManipulatedItem())
    if(Trig_Quest_LostMemories_ShadowTruth_Cond_ShowDialog())then
        call Cine_Enter()
        call Cam_PanToUnit(udg_ShadowUnit,0)
        call Text_Say(udg_ShadowUnit,"...!",false)
        call Text_Say(udg_ShadowUnit,"That ring...",false)
        call Text_Say(udg_MementoRingHero,"Do you recognize this ring?",false)
        call Text_Say(udg_ShadowUnit,"...",false)
        call Text_Say(udg_MementoRingHero,"Shadow?",false)
        call Text_Say(udg_ShadowUnit,"...",false)
        call Text_Say(udg_MementoRingHero,"Shadow... are you Relm's father?",false)
        call Text_Say(udg_ShadowUnit,"...",false)
        call Text_Say(udg_MementoRingHero,"It's you, isn't it?",false)
        call Text_Say(udg_ShadowUnit,"...",false)
        call Text_Say(udg_MementoRingHero,"She's... been looking for you.",false)
        call Text_Say(udg_ShadowUnit,"...",false)
        call Text_Say(udg_ShadowUnit,"No...",false)
        call Text_Say(udg_MementoRingHero,"...?",false)
        call Text_Say(udg_ShadowUnit,"It's not me... I'm not her father.",false)
        call Text_Say(udg_ShadowUnit,"No, no, it's not me the ring reacts to.",false)
        call Text_Say(udg_MementoRingHero,"That isn't possible. This ring reacts to you, and this ring was definitely given to Relm's mother by Relm's father.",false)
        call Text_Say(udg_ShadowUnit,"...",false)
        call Text_Say(udg_ShadowUnit,"It was... my friend and coworker.",false)
        call Text_Say(udg_MementoRingHero,"Your friend... and coworker?",false)
        call Text_Say(udg_ShadowUnit,"\"Shadow\" was originally the name of a two-man-group. Me and my partner would do this business together.",false)
        call Text_Say(udg_ShadowUnit,"But sometime back the two of us took on more than we could handle. We found a treasure worth a million gil... but the authorities caught us.",false)
        call Text_Say(udg_ShadowUnit,"My partner was wounded... and he asked me to kill him to avoid being captured...",false)
        call Text_Say(udg_ShadowUnit,"...I couldn't do it. I couldn't kill the partner who'd been by my side for so long.",false)
        call Text_Say(udg_ShadowUnit,"And then...",false)
        call Text_Say(udg_ShadowUnit,"...",false)
        call Text_Say(udg_MementoRingHero,"It's okay. You don't need to force yourself.",false)
        call Text_Say(udg_ShadowUnit,"...thank you.",false)
        call Text_Say(udg_ShadowUnit,"I've carried on the legacy of \"Shadow\" on my own ever since.",false)
        call Text_Say(udg_ShadowUnit,"This ring... my partner boasted about it when he had it made. He'd looked so happy in that moment, I could never forget about it.",false)
        call Text_Say(udg_ShadowUnit,"So Relm... she's been looking... has she.",false)
        call Text_Say(udg_ShadowUnit,"...",false)
        call Text_Say(udg_MementoRingHero,"(wait a second... something's not right...)",false)
        call Text_Say(udg_MementoRingHero,"Excuse me for asking this, but... seeing as how this ring is still glowing, your partner is still in this world, right?",false)
        call Text_Say(udg_ShadowUnit,"...",false)
        call Text_Say(udg_ShadowUnit,"... I found his body... later.",false)
        call Text_Say(udg_ShadowUnit,"I couldn't leave him in a miserable state like that... so I buried him.",false)
        call Text_Say(udg_ShadowUnit,"As long as he is buried here, the ring will not stop glowing.",false)
        call Text_Say(udg_ShadowUnit,"He has probably... already decayed and returned to the planet, so there is no way the ring will ever stop glowing now.",false)
        call Text_Say(udg_MementoRingHero,"Is that so...",false)
        call Text_Say(udg_ShadowUnit,"...?",false)
        call Text_Say(udg_MementoRingHero,"Shadow ...",false)
        call Text_Transmission(udg_MementoRingHero,udg_PlayerName[GetConvertedPlayerId(GetOwningPlayer(udg_MementoRingHero))],"Shadow ... could it be ...","Shadow ...",null,0,false)
        call Text_Transmission(udg_MementoRingHero,udg_PlayerName[GetConvertedPlayerId(GetOwningPlayer(udg_MementoRingHero))],"Shadow ... could it be ... that you're lying to me?","Shadow ... could it be ...",null,0,false)
        call Text_Say(udg_ShadowUnit,"What!?",false)
        call Text_Say(udg_MementoRingHero,"You see, this ring has stopped glowing once.",false)
        call Text_Say(udg_ShadowUnit,"What are you talking about!? It's glowing!",false)
        call Text_Say(udg_MementoRingHero,"You see when Relm gave us this ring it turned out I had another one just like it. Except... it wasn't glowing anymore.",false)
        call Text_Say(udg_ShadowUnit,"Another one... just like it?",false)
        call Text_Say(udg_ShadowUnit,"Couldn't it be a different ring altogether?",false)
        call Text_Say(udg_MementoRingHero,"That's what Relm thought. But I compared the rings in question. The engravings and scratches on them aren't just similar, they are identical. The ring I had... is doubtlessly the same ring as Relm's.",false)
        call Text_Say(udg_MementoRingHero,"I don't know how or why I ended up with it, but it's rather curious that the glow was gone, isn't it?",false)
        call Text_Say(udg_ShadowUnit,"...what are you getting at.",false)
        call Text_Say(udg_MementoRingHero,"From what you've just said, it would be impossible for the ring to ever lose its glow if your partner was Relm's father, right?\r\nAnd yet...",false)
        call Text_Transmission(udg_MementoRingHero,udg_PlayerName[GetConvertedPlayerId(GetOwningPlayer(udg_MementoRingHero))],"From what you've just said, it would be impossible for the ring to ever lose its glow if your partner was Relm's father, right?\r\nAnd yet... it did.","From what you've just said, it would be impossible for the ring to ever lose its glow if your partner was Relm's father, right?\r\nAnd yet...",null,0,false)
        call Text_Say(udg_ShadowUnit,"...",false)
        call Text_Say(udg_MementoRingHero,"Wherever the ring may have come from, this is fact. The only possible way for the ring to lose its glow... is if its target were to leave Gaya.",false)
        call Text_Say(udg_ShadowUnit,"...",false)
        call Text_Say(udg_MementoRingHero,"That means... your partner isn't Relm's father. He couldn't possibly be.",false)
        call Text_Say(udg_ShadowUnit,"...",false)
        call Text_Say(udg_MementoRingHero,"So then... who could it be?",false)
        call Text_Say(udg_ShadowUnit,"...",false)
        call Text_Say(udg_MementoRingHero,"It is you after all... isn't it?",false)
        call Text_Say(udg_ShadowUnit,"...",false)
        call Text_Say(udg_MementoRingHero,"...",false)
        call Text_Say(udg_ShadowUnit,"...",false)
        call Text_Say(udg_MementoRingHero,"...",false)
        call Text_Say(udg_ShadowUnit,"...fine.",false)
        call Text_Transmission(udg_ShadowUnit,"Shadow","...fine. You're right.","...fine.",null,0,false)
        call Text_Transmission(udg_ShadowUnit,"Shadow","...fine. You're right. I am her real father.","...fine. You're right.",null,0,false)
        call Text_Say(udg_ShadowUnit,"When she was born, it hit me. I was starting a family. Leaving behind all my partner had ever stood for. Discarding it all, throwing it away.",false)
        call Text_Say(udg_ShadowUnit,"Denying that I ever was a \"Shadow\"... wouldn't that be the same as denying that my friend ever existed?",false)
        call Text_Say(udg_ShadowUnit,"So I decided to leave, and carry on being Shadow. To bring honor and meaning to what my friend built up in his lifetime.",false)
        call Text_Say(udg_ShadowUnit,"When I told Elayne - Relm's mother - she understood. She knew that I couldn't find happiness in leaving my friend's legacy behind. But I gave her the ring... so that she may always know that I am still here. That I will always be here.",false)
        call Text_Say(udg_MementoRingHero,"...",false)
        call Text_Say(udg_ShadowUnit,"You see? I left behind my daughter. How could I return to her after all these years?",false)
        call Text_Say(udg_MementoRingHero,"...",false)
        call Text_Say(udg_MementoRingHero,"... Shadow...",false)
        call Text_Say(udg_MementoRingHero,"... Shadow... you should go see her.",false)
        call Text_Say(udg_ShadowUnit,"...!",false)
        call Text_Say(udg_MementoRingHero,"Yes, you left her behind. That won't change. But you owe it to her... you owe it to her that you tell her who you are, and what you're doing.",false)
        call Text_Say(udg_MementoRingHero,"She's been looking for you. And I told her I would reunite her with her father.",false)
        call Text_Say(udg_ShadowUnit,"So you would have me go to Relm only to abandon her again?",false)
        call Text_Say(udg_MementoRingHero,"What you decide to do isn't my business. If you decide to stay with her, that's fine. If you decide you still cannot, that's fine too.",false)
        call Text_Say(udg_MementoRingHero,"But... Relm has to make that decision as well. If she is fine with you going, as her mother was, that's fine. If she is not... that's your problem, but one you have to deal with.",false)
        call Text_Say(udg_ShadowUnit,"...",false)
        call Text_Say(udg_MementoRingHero,"Go talk to her.",false)
        call Text_Say(udg_ShadowUnit,"...you will not ever let up on this, will you?",false)
        call Text_Say(udg_MementoRingHero,"...do you refuse?",false)
        call Text_Say(udg_ShadowUnit,"...no.",false)
        call Text_Say(udg_ShadowUnit,"You're right, after all. She deserves it. And whatever she decides I am for abandoning her... I deserve that as well.",false)
        call Text_Say(udg_MementoRingHero,"I'm glad you've come to your senses.",false)
        call Text_Say(udg_ShadowUnit,"I'll be on my way now. This may be our last meeting.",false)
        call Text_Say(udg_MementoRingHero,"Thanks for fighting at our side. Good bye.",false)
        call Text_Say(udg_ShadowUnit,"Farewell.",false)
        call Cine_ExitAction()
    endif
    call DisableTrigger(gg_trg_Quest_LostMemories_RingFade)
    set udg_ShadowLoyalty=0
    call TriggerExecute(gg_trg_Shadow_Death)
    set udg_TempPoint=GetRectCenter(gg_rct_551)
    call CreateNUnitsAtLoc(1,'n04K',Player(9),udg_TempPoint,180.) // 'n04K': unit "Shadow"
    call RemoveLocation(udg_TempPoint)
    call UnitRemoveAbilityBJ('Ane2',GetLastCreatedUnit()) // 'Ane2': object name not found in map data
    set udg_ShadowUnit=GetLastCreatedUnit()
    set udg_SpecialEffect[66]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_e00V_0009,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call Music_SetTrack(32)
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_UPDATED,"Talk to Relm.")
    call QuestSetDescriptionBJ(udg_SideQuest[44],"Talk to Relm.")
    call EnableTrigger(gg_trg_Quest_LostMemories_Reunion)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Quest_LostMemories_Reunion_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_e00V_0009,true,true,true))
endfunction

function Trig_Quest_LostMemories_Reunion_Cond_ShowDialog takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_LostMemories_Reunion_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[66])
    if(Trig_Quest_LostMemories_Reunion_Cond_ShowDialog())then
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_e00V_0009,0)
        call Text_Say(gg_unit_e00V_0009,"You're back!",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"I see your father is here as well.",false)
        call Text_Say(gg_unit_e00V_0009,"Yes. Thanks to you...",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"So have you decided to be a family from now on?",false)
        call Text_Say(gg_unit_e00V_0009,"Yes. We talked a lot... and my father wants to stay here with me.",false)
        call Text_Say(udg_ShadowUnit,"I have something here that means more to me than anything else.",false)
        call Text_Transmission(udg_ShadowUnit,"Shadow","I have something here that means more to me than anything else.\r\nI have you to thank for making me realize such a simple fact.","I have something here that means more to me than anything else.",null,0,false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"I'm glad it worked out.",false)
        call Text_Say(gg_unit_e00V_0009,"I am forever in your debt.",false)
        call Reward_Give($2710,$2710,gg_unit_e00V_0009) // $2710 = 10000
        call Text_Say(udg_ShadowUnit,"|n|cffffcc00A new artifact is available for buying at the Ancient of Wonders.|r",true)
        call Cine_ExitAction()
    else
        call Reward_Give($2710,$2710,gg_unit_e00V_0009) // $2710 = 10000
        call DisplayTimedTextToForce(udg_PlayingPlayers,10.,"|cffffcc00A new artifact is available for buying at the Ancient of Wonders.|r")
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_COMPLETED,"Quest Completed: |cffffcc00Lost Memories|r")
    call QuestSetCompletedBJ(udg_SideQuest[44],true)
    set udg_QuestsCompleted=(udg_QuestsCompleted+1)
    call AddItemToStockBJ('I0E3',gg_unit_n00L_0153,1,1) // 'I0E3': item "Interceptor Guard"
    call SaveIntegerBJ(1,2,$A4,udg_GameStateHash) // $A4 = 164
    set udg_NaishaTownUnit=udg_ShadowUnit
    call Music_ClearTrack(32)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function InitTrig_Quest_LostMemories takes nothing returns nothing
endfunction

endlibrary
