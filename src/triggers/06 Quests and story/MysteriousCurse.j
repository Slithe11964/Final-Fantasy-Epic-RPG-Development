library TMysteriousCurse requires TCam, TCine, TPlayerHero, TReward, TText, TUnit, TWait
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_MysteriousCurse_Init=null
    trigger gg_trg_MysteriousCurse_Link=null
    trigger gg_trg_MysteriousCurse_Adria=null
    trigger gg_trg_MysteriousCurse_Confront=null
    trigger gg_trg_MysteriousCurse_Witness=null
    trigger gg_trg_MysteriousCurse_AttackLink=null
    trigger gg_trg_MysteriousCurse_AttackAdria=null
    trigger gg_trg_MysteriousCurse_LinkDies=null
    trigger gg_trg_MysteriousCurse_AdriaWitchDead=null
    trigger gg_trg_MysteriousCurse_BabaYagaAppears=null
    trigger gg_trg_MysteriousCurse_AdriaRestored=null
    trigger gg_trg_MysteriousCurse_AdriaReturn=null
    trigger gg_trg_MysteriousCurse_LinkRestored=null
    trigger gg_trg_MysteriousCurse_LinkReturn=null
    trigger gg_trg_MysteriousCurse_AdriaDies=null
    trigger gg_trg_MysteriousCurse_BabaYagaDead=null
    // Variables only this module uses.
    integer udg_CurseLiar=0
    unit array udg_CurseUnit
    integer udg_CurseStage=0
endglobals

function Trig_MysteriousCurse_Init_Cond_LinkIsHonest takes nothing returns boolean
    return(udg_CurseLiar==1)
endfunction

function Trig_MysteriousCurse_Init_Actions takes nothing returns nothing
    set udg_SpecialEffect[40]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_u001_0195,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call ShowUnitHide(gg_unit_u002_0196)
    // A random whole number from 1 through 2.
    set udg_CurseLiar=GetRandomInt(1,2)
    if(Trig_MysteriousCurse_Init_Cond_LinkIsHonest())then
        set udg_CurseHintLine[0]="Hmmm... I wonder who this Link is."
        set udg_CurseHintLine[1]="Interesting..."
        set udg_CurseHintLine[2]="Very interesting indeed..."
        set udg_CurseHintLine[7]="Yes, I should see him."
        set udg_CurseHintLine[8]="He does, don't worry."
    else
        set udg_CurseHintLine[0]="Hmmm... I wonder who this Adria is."
        set udg_CurseHintLine[1]="Link, eh? Hmm..."
        set udg_CurseHintLine[2]="So Link is lying after all."
        set udg_CurseHintLine[7]="There is a different story... but now I must see her."
        set udg_CurseHintLine[8]="She is completely fine."
    endif
    set udg_CurseHintLine[3]="Very good. Now I know who the liar really is."
    set udg_CurseHintLine[4]="No... if only I had known earlier..."
    set udg_CurseHintLine[5]="As I thought."
    set udg_CurseHintLine[6]=". . . . ."
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_MysteriousCurse_Link_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_u001_0195,true,true,true))
endfunction

function Trig_MysteriousCurse_Link_ApplyLinkCam takes nothing returns nothing
    call CameraSetupApplyForPlayer(true,gg_cam_007,GetEnumPlayer(),1.)
endfunction

function Trig_MysteriousCurse_Link_Cond_ShowLinkTalk takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_MysteriousCurse_Link_Cond_StageResolved takes nothing returns boolean
    return(udg_CurseStage==9)
endfunction

function Trig_MysteriousCurse_Link_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[40])
    if(Trig_MysteriousCurse_Link_Cond_ShowLinkTalk())then
        call Cine_Enter()
        call ForForce(udg_PlayingPlayers,function Trig_MysteriousCurse_Link_ApplyLinkCam)
        call Text_Transmission(gg_unit_u001_0195,"Skeleton","Please help me !!!","(null)",null,0,false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Wow! A talking skeleton!",false)
        call Text_Transmission(gg_unit_u001_0195,"Skeleton","I am not a skeleton although I may look like I am.\r\nMy name is Link and I am the Elven Swordsman from Kalm.","(null)",null,0,false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Are you sure? You look pretty bony...",false)
        call Text_Say(gg_unit_u001_0195,"That's right, I *look* bony. It's a curse. I was cursed by a witch and everyone seems to think I am skeleton while I am the same Link I was.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"How do I know you are not trying to deceive me? Maybe you want to catch me unguarded and then stab my back with that rusty sword of yours.",false)
        call Text_Say(gg_unit_u001_0195,"Let's call to your common sense. You hear me voice, right?",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Yep.",false)
        call Text_Say(gg_unit_u001_0195,"And do you think skeletons have vocal cords? Not zombies, but skeletons.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"I guess they don't.",false)
        call Text_Transmission(Player_GetHero(GetTriggerPlayer()),udg_PlayerName[GetConvertedPlayerId(GetTriggerPlayer())],"I guess they don't.\r\nOk, I believe you.","I guess they don't.",null,0,false)
        call Text_Transmission(Player_GetHero(GetTriggerPlayer()),udg_PlayerName[GetConvertedPlayerId(GetTriggerPlayer())],"I guess they don't.\r\nOk, I believe you.\r\nHow can I help you?","I guess they don't.\r\nOk, I believe you.",null,0,false)
        call Text_Say(gg_unit_u001_0195,"Please find the witch that cursed me and kill her. That's the only way to remove the curse!",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"And why don't you do that yourself?",false)
        call Text_Say(gg_unit_u001_0195,"Are you crazy? She is a witch, she'll just cast some deadly spell and I'll be dead. It's better to look like undead than to be dead.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Nice logic. Ok, just tell me where you encountered that witch and wait here till I come back.",false)
        call Cine_ExitAction()
    endif
    call ShowUnitShow(gg_unit_u002_0196)
    call GroupAddUnitSimple(gg_unit_u002_0196,udg_BossUnits)
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_DISCOVERED,"New Quest Received: |cffffcc00Mysterious Curse|r")
    set udg_SideQuest[22]=CreateQuestBJ(bj_QUESTTYPE_REQ_DISCOVERED,(udg_QuestNamePrefix+"Mysterious Curse"),"Link, skeleton from Mountains region, says that in truth he is the Elf cursed by a witch. He begs you to help him by finding the witch and killing her.","ReplaceableTextures\\CommandButtons\\BTNSkeletonWarrior.blp")
    set udg_SpecialEffect[40]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_u001_0195,"Objects\\RandomObject\\RandomObject.mdl")
    set udg_SpecialEffect[41]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_u002_0196,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call EnableTrigger(gg_trg_MysteriousCurse_Adria)
    if(Trig_MysteriousCurse_Link_Cond_StageResolved())then
    else
        set udg_CurseStage=1
    endif
    call AddItemToStockBJ('I04W',gg_unit_n02Y_0052,1,1) // 'I04W': item "Information: Cursed Link"
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_MysteriousCurse_Adria_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_u002_0196,true,true,true))
endfunction

function Trig_MysteriousCurse_Adria_ApplyAdriaCam takes nothing returns nothing
    call CameraSetupApplyForPlayer(true,gg_cam_008,GetEnumPlayer(),1.)
endfunction

function Trig_MysteriousCurse_Adria_Cond_KnowsAdriaTruth takes nothing returns boolean
    return(udg_CurseStage==9)and(udg_CurseLiar==2)
endfunction

function Trig_MysteriousCurse_Adria_Cond_ShowAdriaTalk takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_MysteriousCurse_Adria_Cond_AdriaIsHonest takes nothing returns boolean
    return(udg_CurseLiar==2)
endfunction

function Trig_MysteriousCurse_Adria_Cond_HintObtained takes nothing returns boolean
    return(udg_CurseStage==9)
endfunction

function Trig_MysteriousCurse_Adria_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_BossUnits)
    call DestroyEffectBJ(udg_SpecialEffect[40])
    call DestroyEffectBJ(udg_SpecialEffect[41])
    if(Trig_MysteriousCurse_Adria_Cond_ShowAdriaTalk())then
        call Cine_Enter()
        call ForForce(udg_PlayingPlayers,function Trig_MysteriousCurse_Adria_ApplyAdriaCam)
        call Text_Transmission(gg_unit_u002_0196,"Ghost","Hello.","(null)",null,0,false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Hi. Say, did you see a witch nearby? One cursed Elven Swordsman that looks like a skeleton told me she may be found somewhere here.",false)
        call Text_Transmission(gg_unit_u002_0196,"Ghost","I guess he was talking about me.","(null)",null,0,false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Really? I expected the witch to be a hag, not a ghost.",false)
        call Text_Transmission(gg_unit_u002_0196,"Ghost","Well I am neither. But surely you see me as a ghost. It's a curse. Are you surprised?","(null)",null,0,false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Not at all. I knew from the beginning that it wouldn't be a simple \"kill-caster-to-remove-spell\" type of quest.",false)
        call Text_Transmission(gg_unit_u002_0196,"Ghost","I am glad. By the way my name is Adria.","(null)",null,0,false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),("And I am "+(udg_PlayerName[GetConvertedPlayerId(GetTriggerPlayer())]+".")),false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Will you please tell me the whole story now?",false)
        call Text_Say(gg_unit_u002_0196,"No problem.",false)
        call Text_Say(gg_unit_u002_0196,"For many years a witch named Baba Yaga lived in these parts. She was wicked hag that made many evil deeds.",false)
        call Text_Say(gg_unit_u002_0196,"One day while reading an old spellbook she stumbled upon a Spell of Eternal Youth. Evil magic often drains the life of casters and Baba Yaga was very old and ugly. The spell was salvation for her.",false)
        call Text_Say(gg_unit_u002_0196,"Apart from magic reagents the spell also required a special component - a young elven maiden with magical powers.",false)
        call Text_Transmission(gg_unit_u002_0196,"Adria","Apart from magic reagents the spell also required a special component - young elven maiden with magical powers.\r\nMe.","Apart from magic reagents the spell also required a special component - young elven maiden with magical powers.",null,0,false)
        call Text_Say(gg_unit_u002_0196,"She lured me out of the town and then put me in a trance-like state. I tried to resist the spell but my magic powers were nothing compared to hers.",false)
        call Text_Say(gg_unit_u002_0196,"Baba Yaga successfully completed the spell. She took my youth but couldn't kill me because if I die the spell will lose its power and she will again become old.",false)
        call Text_Say(gg_unit_u002_0196,"So Baba Yaga needs me alive. She cursed me with this ghost-like appearence so that even my fellow Elves attacked me on sight. And now I wander here hoping someone would listen to my story and help me.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"The only thing I don't understand is what connection that guy named Link has to you. He told me that you cursed him.",false)
        call Text_Say(gg_unit_u002_0196,"And did he tell you why this curse was bestowed upon him?",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"No.",false)
        call Text_Say(gg_unit_u002_0196,"He is a traitor. He asked me to accompany him on his way to the Shipyard. But he led me to Baga Yaga's dwelling instead. He serves her for a long time. I took my vengeance on him and cursed him just like Baba Yaga cursed me.",false)
        call Text_Say(gg_unit_u002_0196,"And the only way to remove such a curse is to kill the caster. That's why Baba Yaga can't help her servant - she wouldn't kill me, although she can do it.",false)
        if(Trig_MysteriousCurse_Adria_Cond_KnowsAdriaTruth())then
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"You know, Adria, I met a huntress in Lothlorien. She told me she had a friend named Adria when she had visited Kalm.",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"She also said that one day, Link started looking at you with an evil eye.",false)
            call Text_Say(gg_unit_u002_0196,"You met her? I am glad to hear that.",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"I will go ask Link and hear his story. Wait here.",false)
        else
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"You know, I just thought that everything you have just told me could be a lie. That you are just toying with me. And that Link wasn't lying to me - you are really the witch and should be killed.",false)
            call Text_Say(gg_unit_u002_0196,"Link is a skilled persuader. He deceived you. Believe me.",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"I don't know whose words I should believe. I'll go talk to Link once more.",false)
        endif
        call Cine_ExitAction()
    endif
    set udg_SpecialEffect[41]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_u002_0196,"Objects\\RandomObject\\RandomObject.mdl")
    set udg_SpecialEffect[40]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_u001_0195,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    if(Trig_MysteriousCurse_Adria_Cond_HintObtained())then
        if(Trig_MysteriousCurse_Adria_Cond_AdriaIsHonest())then
            call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_UPDATED,"Talk to Link.")
            call QuestSetDescriptionBJ(udg_SideQuest[22],"Adria insists that she is a victim of curse and has her youth stolen by witch named Baba Yaga. She also states that Link is a faithful servant of Baba Yaga and that she cursed him to avenge herself. Confront Link about his lies.")
        else
            call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_UPDATED,"Visit Link to find out who speaks truth.")
            call QuestSetDescriptionBJ(udg_SideQuest[22],"Adria insists that she is a victim of curse and has her youth stolen by witch named Baba Yaga. She also states that Link is a faithful servant of Baba Yaga and that she cursed him to avenge herself. Talk to Link.")
        endif
    else
        set udg_CurseStage=2
        call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_UPDATED,"Visit Link to find out who speaks truth.")
        call QuestSetDescriptionBJ(udg_SideQuest[22],"Adria insists that she is a victim of curse and has her youth stolen by witch named Baba Yaga. She also states that Link is a faithful servant of Baba Yaga and that she cursed him to avenge herself. Talk to Link.")
    endif
    call GroupAddUnitSimple(gg_unit_u001_0195,udg_BossUnits)
    call EnableTrigger(gg_trg_MysteriousCurse_Confront)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_MysteriousCurse_Confront_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_u001_0195,true,true,true))
endfunction

function Trig_MysteriousCurse_Confront_ApplyConfrontCam takes nothing returns nothing
    call CameraSetupApplyForPlayer(true,gg_cam_007,GetEnumPlayer(),1.)
endfunction

function Trig_MysteriousCurse_Confront_Cond_ProofAdriaHonest takes nothing returns boolean
    return(udg_CurseStage==9)and(udg_CurseLiar==2)
endfunction

function Trig_MysteriousCurse_Confront_Cond_ProofLinkHonest takes nothing returns boolean
    return(udg_CurseStage==9)and(udg_CurseLiar==1)
endfunction

function Trig_MysteriousCurse_Confront_Cond_ShowConfrontTalk takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_MysteriousCurse_Confront_Cond_KillLinkPath takes nothing returns boolean
    return(udg_CurseStage==9)and(udg_CurseLiar==2)
endfunction

function Trig_MysteriousCurse_Confront_Cond_KillAdriaPath takes nothing returns boolean
    return(udg_CurseStage==9)and(udg_CurseLiar==1)
endfunction

function Trig_MysteriousCurse_Confront_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_BossUnits)
    call DestroyEffectBJ(udg_SpecialEffect[40])
    call DestroyEffectBJ(udg_SpecialEffect[41])
    if(Trig_MysteriousCurse_Confront_Cond_ShowConfrontTalk())then
        call Cine_Enter()
        call ForForce(udg_PlayingPlayers,function Trig_MysteriousCurse_Confront_ApplyConfrontCam)
        call Text_Say(gg_unit_u001_0195,"You're back! Do I still look like a skeleton?",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Yes, you do.",false)
        call Text_Say(gg_unit_u001_0195,"But why? Did you not kill the witch?",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Instead of killing her I listened to what she had to tell me. And she told me an interesting story.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),("|cffffcc00"+(udg_PlayerName[GetConvertedPlayerId(GetTriggerPlayer())]+" retells Adria's words to Link.|r")),false)
        call Text_Say(gg_unit_u001_0195,"What she told you about me is completely untrue. I was patrolling Mountains region when she appeared seemingly out of nowhere and said that I was a fool to come there.",false)
        call Text_Say(gg_unit_u001_0195,"She then murmured some strange words and a purple cloud surrounded me. Several minutes later the cloud disappeared and I saw that the witch was also gone. I hurried back to Kalm but was attacked by my fellow swordsmen and had to escape here.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"And how did you know that you look like a skeleton?",false)
        call Text_Say(gg_unit_u001_0195,"By looking in water. I was pretty scared when saw a skeleton staring at me from the bottom of river. It took some time for me to understand that it was just my reflection.",false)
        if(Trig_MysteriousCurse_Confront_Cond_ProofLinkHonest())then
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"You know, Link, you seem to speak truth. And I met a night-elf huntress from the south that confirmed that you always do.",false)
            call Text_Say(gg_unit_u001_0195,"You met her! So do you believe me?",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"I do, Link. I will kill that witch.",false)
        else
            if(Trig_MysteriousCurse_Confront_Cond_ProofAdriaHonest())then
                call Text_Say(Player_GetHero(GetTriggerPlayer()),"You know, Link, you really are a good speaker. But you forgot one thing: Adria made a friend in Kalm who can confirm that she is telling the truth.",false)
                call Text_Say(gg_unit_u001_0195,". . . . .",false)
                call Text_Say(Player_GetHero(GetTriggerPlayer()),"You were trying to deceive me and make me kill an innocent sorceress. That cannot be forgiven, Link.",false)
            else
                call Text_Say(Player_GetHero(GetTriggerPlayer()),"You know, Link, you seem to speak truth. But the problem is that Adria also seems to speak truth. I don't know who I should believe because you can't both be right at the same time.",false)
                call Text_Say(gg_unit_u001_0195,"Then listen to your heart. It will tell you who speaks the truth.",false)
                call Text_Say(Player_GetHero(GetTriggerPlayer()),"Right. But don't blame me if my heart tells me that you are a liar.",false)
            endif
        endif
        call Cine_ExitAction()
    endif
    if(Trig_MysteriousCurse_Confront_Cond_KillAdriaPath())then
        call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_UPDATED,"Kill Adria.")
        call QuestSetDescriptionBJ(udg_SideQuest[22],"Kill Adria, the witch, who speaks nothing but lies.")
        call TriggerExecute(gg_trg_MysteriousCurse_AttackAdria)
    else
        if(Trig_MysteriousCurse_Confront_Cond_KillLinkPath())then
            call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_UPDATED,"Kill Link.")
            call QuestSetDescriptionBJ(udg_SideQuest[22],"Kill Link and release Adria from her curse.")
            call SetUnitInvulnerable(gg_unit_u001_0195,false)
            call TriggerExecute(gg_trg_MysteriousCurse_AttackLink)
        else
            call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_UPDATED,"Decide who is lying: Adria or Link. Then kill the liar.")
            call QuestSetDescriptionBJ(udg_SideQuest[22],"Both Link and Adria seem to tell truth. But one of them is lying.\r\nKILL the one you think is a liar.")
            set udg_CurseStage=3
            call SetUnitInvulnerable(gg_unit_u002_0196,false)
            call SetUnitInvulnerable(gg_unit_u001_0195,false)
            call UnitAddAbilityBJ('A0T8',gg_unit_u002_0196) // 'A0T8': ability "Block All"
            call UnitAddAbilityBJ('A0T8',gg_unit_u001_0195) // 'A0T8': ability "Block All"
            call EnableTrigger(gg_trg_MysteriousCurse_AttackLink)
            call EnableTrigger(gg_trg_MysteriousCurse_AttackAdria)
        endif
    endif
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_MysteriousCurse_Witness_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_esen_0152,true,true,true))
endfunction

function Trig_MysteriousCurse_Witness_Cond_WitnessLinkHonest takes nothing returns boolean
    return(udg_CurseLiar==1)
endfunction

function Trig_MysteriousCurse_Witness_Cond_ShowWitnessTalk takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_MysteriousCurse_Witness_Cond_TargetIsAdria takes nothing returns boolean
    return(udg_CurseLiar==1)
endfunction

function Trig_MysteriousCurse_Witness_Cond_ChoicePending takes nothing returns boolean
    return(udg_CurseStage==3)
endfunction

function Trig_MysteriousCurse_Witness_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_QuestMarkerEffect[16])
    if(Trig_MysteriousCurse_Witness_Cond_ShowWitnessTalk())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        if(Trig_MysteriousCurse_Witness_Cond_WitnessLinkHonest())then
            call Text_Say(gg_unit_esen_0152,"Back when I visited Kalm, I met with a friend of mine named Link.",false)
            call Text_Say(gg_unit_esen_0152,"He is one of the most honest and upstanding soldiers I have ever met.",false)
            call Text_Say(gg_unit_esen_0152,"He could never lie to people even to save his life. I hope he lives happily.",false)
        else
            call Text_Say(gg_unit_esen_0152,"Back when I visited Kalm, I met with a friend of mine named Adria.",false)
            call Text_Say(gg_unit_esen_0152,"She was a nice sorceress. But one day, that Link started to look at her with an evil eye.",false)
            call Text_Say(gg_unit_esen_0152,"I hope he didn't hurt her... she was never the humorous type.",false)
        endif
        call Text_Say(Player_GetHero(GetTriggerPlayer()),udg_CurseHintLine[udg_CurseStage],false)
        call Cine_ExitAction()
    endif
    if(Trig_MysteriousCurse_Witness_Cond_ChoicePending())then
        if(Trig_MysteriousCurse_Witness_Cond_TargetIsAdria())then
            call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_UPDATED,"Kill Adria.")
            call QuestSetDescriptionBJ(udg_SideQuest[22],"Kill Adria, the witch, who speaks nothing but lies.")
            call SetUnitInvulnerable(gg_unit_u001_0195,true)
        else
            call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_UPDATED,"Kill Link.")
            call QuestSetDescriptionBJ(udg_SideQuest[22],"Kill Link and release Adria from her curse.")
            call SetUnitInvulnerable(gg_unit_u002_0196,true)
        endif
    endif
    set udg_CurseStage=9
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_MysteriousCurse_AttackLink_Conditions takes nothing returns boolean
    return(GetTriggerUnit()==gg_unit_u001_0195)
endfunction

function Trig_MysteriousCurse_AttackLink_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DisableTrigger(gg_trg_MysteriousCurse_AttackAdria)
    call UnitRemoveAbilityBJ('A0T8',GetTriggerUnit()) // 'A0T8': ability "Block All"
    call SetUnitInvulnerable(gg_unit_u002_0196,true)
    call SetUnitOwner(gg_unit_u001_0195,Player($B),false) // $B = 11
    call DisableTrigger(gg_trg_Npc_Talk_LinkGuard)
    call DestroyEffectBJ(udg_QuestMarkerEffect[20])
    call RemoveItemFromStockBJ('I04W',gg_unit_n02Y_0052) // 'I04W': item "Information: Cursed Link"
    set udg_CurseStage=(3+udg_CurseLiar)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_MysteriousCurse_AttackAdria_Conditions takes nothing returns boolean
    return(GetTriggerUnit()==gg_unit_u002_0196)
endfunction

function Trig_MysteriousCurse_AttackAdria_Cond_AdriaIsWitch takes nothing returns boolean
    return(udg_CurseLiar==1)
endfunction

function Trig_MysteriousCurse_AttackAdria_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DisableTrigger(gg_trg_MysteriousCurse_AttackLink)
    call UnitRemoveAbilityBJ('A0T8',GetTriggerUnit()) // 'A0T8': ability "Block All"
    call SetUnitInvulnerable(gg_unit_u001_0195,true)
    call SetUnitOwner(gg_unit_u002_0196,Player($B),false) // $B = 11
    if(Trig_MysteriousCurse_AttackAdria_Cond_AdriaIsWitch())then
        set udg_CurseUnit[4]=ReplaceUnitBJ(gg_unit_u002_0196,'u003',bj_UNIT_STATE_METHOD_RELATIVE) // 'u003': unit "Adria"
        call Unit_ScaleToLevel60(bj_lastReplacedUnit)
    endif
    call DisableTrigger(gg_trg_Npc_Talk_LinkGuard)
    call DestroyEffectBJ(udg_QuestMarkerEffect[20])
    set udg_CurseStage=(6-udg_CurseLiar)
    call RemoveItemFromStockBJ('I04W',gg_unit_n02Y_0052) // 'I04W': item "Information: Cursed Link"
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_MysteriousCurse_LinkDies_Conditions takes nothing returns boolean
    return(udg_CurseLiar==1)
endfunction

function Trig_MysteriousCurse_LinkDies_Cond_ShowRevealTalk takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_MysteriousCurse_LinkDies_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call ReplaceUnitBJ(GetDyingUnit(),'hhes',bj_UNIT_STATE_METHOD_RELATIVE) // 'hhes': unit "Knight"
    call RemoveUnit(gg_unit_u002_0196)
    call CreateNUnitsAtLocFacingLocBJ(1,'u003',Player($B),OffsetLocation(GetUnitLoc(GetKillingUnitBJ()),300.,0),GetUnitLoc(GetKillingUnitBJ())) // 'u003': unit "Adria"; $B = 11
    set udg_CurseUnit[1]=GetLastCreatedUnit()
    call Unit_ScaleToLevel60(bj_lastCreatedUnit)
    call SetUnitFacingToFaceUnitTimed(GetKillingUnitBJ(),GetLastCreatedUnit(),0)
    if(Trig_MysteriousCurse_LinkDies_Cond_ShowRevealTalk())then
        call PauseUnitBJ(true,udg_CurseUnit[1])
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetKillingUnitBJ())),"Adria? Is that you? I killed Link because I decided it was he who was lying.",false)
        call Text_Say(udg_CurseUnit[1],"*laughs*\r\nAnd how does it feel like ... killing an innocent person?",false)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetKillingUnitBJ())),"You deceived me !",false)
        call Text_Say(udg_CurseUnit[1],"Yes, I enjoy toying with you mortals. But the game is over, you will die now.",false)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetKillingUnitBJ())),"You will pay for your lies, witch. It is you who will fall now, not me.",false)
        call Text_Say(udg_CurseUnit[1],"We shall see.",false)
        call Cine_ExitAction()
        call PauseUnitBJ(false,udg_CurseUnit[1])
    endif
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_MysteriousCurse_AdriaWitchDead_Conditions takes nothing returns boolean
    return(GetDyingUnit()!=null)and(GetDyingUnit()==udg_CurseUnit[1])
endfunction

function Trig_MysteriousCurse_AdriaWitchDead_Cond_ShowRegretTalk takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_MysteriousCurse_AdriaWitchDead_Actions takes nothing returns nothing
    local location l_tempPoint3
    call DisableTrigger(GetTriggeringTrigger())
    set l_tempPoint3=GetUnitLoc(GetTriggerUnit())
    call CreateItemLoc('I01G',l_tempPoint3) // 'I01G': item "Ice Wand"
    call RemoveLocation(l_tempPoint3)
    if(Trig_MysteriousCurse_AdriaWitchDead_Cond_ShowRegretTalk())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetKillingUnitBJ())),"I was a fool to believe Adria. But now she is dead ... just like Link, who spoke truth.",false)
        call Reward_Give($3E8,$5DC,null) // $3E8 = 1000; $5DC = 1500
        call Text_Say(null,"|n|cffffcc00All players get 1000 gold and 1500 exp.|r",true)
        call Cine_ExitAction()
    else
        call Reward_Give($3E8,$5DC,GetTriggerUnit()) // $3E8 = 1000; $5DC = 1500
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_COMPLETED,"Quest Completed: |cffffcc00Mysterious Curse|r")
    call QuestSetCompletedBJ(udg_SideQuest[22],true)
    set udg_QuestsCompleted=(udg_QuestsCompleted+1)
    call AddUnitToStockBJ('n0C7',gg_unit_n0BW_0094,1,1) // 'n0C7': unit "Hunt: Titania"
    set udg_HuntStock[4]=(udg_HuntStock[4]+1)
    call ConditionalTriggerExecute(gg_trg_Hunt_Board_Markers)
    set udg_CurseStage=6
    call DestroyTrigger(GetTriggeringTrigger())
    set l_tempPoint3=null
endfunction

function Trig_MysteriousCurse_BabaYagaAppears_Conditions takes nothing returns boolean
    return(udg_CurseLiar==2)
endfunction

function Trig_MysteriousCurse_BabaYagaAppears_Cond_ShowWitchTalk takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_MysteriousCurse_BabaYagaAppears_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call ReplaceUnitBJ(GetDyingUnit(),'hhes',bj_UNIT_STATE_METHOD_RELATIVE) // 'hhes': unit "Knight"
    call CreateNUnitsAtLocFacingLocBJ(1,'u005',Player($B),OffsetLocation(GetUnitLoc(GetKillingUnitBJ()),300.,0),GetUnitLoc(GetKillingUnitBJ())) // 'u005': unit "Baba Yaga"; $B = 11
    set udg_CurseUnit[2]=GetLastCreatedUnit()
    call Unit_ScaleToLevel60(bj_lastCreatedUnit)
    call SetUnitFacingToFaceUnitTimed(GetKillingUnitBJ(),GetLastCreatedUnit(),0)
    if(Trig_MysteriousCurse_BabaYagaAppears_Cond_ShowWitchTalk())then
        call PauseUnitBJ(true,udg_CurseUnit[2])
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(udg_CurseUnit[2],"You killed my loyal servant! Prepare to die!",false)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetKillingUnitBJ())),"It is you who will die, witch.",false)
        call Cine_ExitAction()
        call PauseUnitBJ(false,udg_CurseUnit[2])
    endif
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_MysteriousCurse_AdriaRestored_Conditions takes nothing returns boolean
    return(GetDyingUnit()!=null)and(GetDyingUnit()==udg_CurseUnit[2])
endfunction

function Trig_MysteriousCurse_AdriaRestored_Cond_ShowLiftedTalk takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_MysteriousCurse_AdriaRestored_Actions takes nothing returns nothing
    local location l_tempPoint3
    call DisableTrigger(GetTriggeringTrigger())
    set l_tempPoint3=GetUnitLoc(GetTriggerUnit())
    call CreateItemLoc('I01G',l_tempPoint3) // 'I01G': item "Ice Wand"
    call RemoveLocation(l_tempPoint3)
    if(Trig_MysteriousCurse_AdriaRestored_Cond_ShowLiftedTalk())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetKillingUnitBJ())),"Now that Baba Yaga is dead Adria's curse should be lifted and she will once again look normal. I must visit her.",false)
        call Cine_ExitAction()
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_UPDATED,"Talk to Adria.")
    call QuestSetDescriptionBJ(udg_SideQuest[22],"Talk to Adria.")
    set udg_CurseUnit[3]=ReplaceUnitBJ(gg_unit_u002_0196,'u004',bj_UNIT_STATE_METHOD_RELATIVE) // 'u004': unit "Adria"
    set udg_SpecialEffect[41]=AddSpecialEffectTargetUnitBJ("overhead",udg_CurseUnit[3],"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call EnableTrigger(gg_trg_MysteriousCurse_AdriaReturn)
    call AddUnitToStockBJ('n0C7',gg_unit_n0BW_0094,1,1) // 'n0C7': unit "Hunt: Titania"
    set udg_HuntStock[4]=(udg_HuntStock[4]+1)
    call ConditionalTriggerExecute(gg_trg_Hunt_Board_Markers)
    set udg_CurseStage=7
    call DestroyTrigger(GetTriggeringTrigger())
    set l_tempPoint3=null
endfunction

function Trig_MysteriousCurse_AdriaReturn_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,udg_CurseUnit[3],true,true,true))
endfunction

function Trig_MysteriousCurse_AdriaReturn_ApplyAdriaReturnCam takes nothing returns nothing
    call CameraSetupApplyForPlayer(true,gg_cam_008,GetEnumPlayer(),1.)
endfunction

function Trig_MysteriousCurse_AdriaReturn_Cond_ShowFarewellTalk takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_MysteriousCurse_AdriaReturn_Cond_TownInvaded takes nothing returns boolean
    return(IsUnitGroupEmptyBJ(udg_AllyRangerGroup)==false)
endfunction

function Trig_MysteriousCurse_AdriaReturn_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[41])
    if(Trig_MysteriousCurse_AdriaReturn_Cond_ShowFarewellTalk())then
        call Cine_Enter()
        call ForForce(udg_PlayingPlayers,function Trig_MysteriousCurse_AdriaReturn_ApplyAdriaReturnCam)
        call Text_Say(udg_CurseUnit[3],"Hi again. What news do you bring?",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Baba Yaga is dead and you look normal.",false)
        call Text_Say(udg_CurseUnit[3],"Really?! Thank you very much. I am so glad you believed me and not that traitorous Link.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"I am glad too. You can return to Kalm now.",false)
        call Text_Say(udg_CurseUnit[3],"I will. Thank you very much. Without your help my suffering would have never ended.",false)
        call Reward_Give($BB8,$9C4,udg_CurseUnit[3]) // $BB8 = 3000; $9C4 = 2500
        set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        call Wait_Polled(.5)
        set udg_TempPoint=GetRectCenter(gg_rct_549)
        call SetUnitPositionLocFacingBJ(GetTriggerUnit(),udg_TempPoint,315.)
        call RemoveLocation(udg_TempPoint)
        call Wait_Polled(2)
        call Cine_ExitAction()
    else
        call Reward_Give($BB8,$9C4,udg_CurseUnit[3]) // $BB8 = 3000; $9C4 = 2500
        set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        set udg_TempPoint=GetRectCenter(gg_rct_549)
        call SetUnitPositionLocFacingBJ(GetTriggerUnit(),udg_TempPoint,315.)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
    endif
    call GroupAddUnitSimple(GetTriggerUnit(),udg_RecruitedAllies)
    if(Trig_MysteriousCurse_AdriaReturn_Cond_TownInvaded())then
        call ShowUnitHide(GetTriggerUnit())
    endif
    call SetUnitOwner(GetTriggerUnit(),Player(9),true)
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_COMPLETED,"Quest Completed: |cffffcc00Mysterious Curse|r")
    call QuestSetCompletedBJ(udg_SideQuest[22],true)
    set udg_QuestsCompleted=(udg_QuestsCompleted+1)
    set udg_CurseStage=8
    set udg_NewsText[3]=udg_NewsText[2]
    set udg_NewsText[2]=udg_NewsText[1]
    set udg_NewsText[6]=udg_NewsText[5]
    set udg_NewsText[5]=udg_NewsText[4]
    set udg_NewsText[1]="|cffffcc00Adria Has Returned|r"
    set udg_NewsText[4]="Adria, a sorceress from Kalm, has returned from missing state. Link was a traitor, who was cursed by her. Welcome back anyway, Adria!"
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_MysteriousCurse_LinkRestored_Conditions takes nothing returns boolean
    return(GetDyingUnit()!=null)and(GetDyingUnit()==udg_CurseUnit[4])
endfunction

function Trig_MysteriousCurse_LinkRestored_Cond_ShowVictoryTalk takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_MysteriousCurse_LinkRestored_Actions takes nothing returns nothing
    local location l_tempPoint3
    call DisableTrigger(GetTriggeringTrigger())
    set l_tempPoint3=GetUnitLoc(GetTriggerUnit())
    call CreateItemLoc('I01G',l_tempPoint3) // 'I01G': item "Ice Wand"
    call RemoveLocation(l_tempPoint3)
    if(Trig_MysteriousCurse_LinkRestored_Cond_ShowVictoryTalk())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetKillingUnitBJ())),"Now that this witch that was trying to deceive me is dead Link should look normal again.",false)
        call Cine_ExitAction()
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_UPDATED,"Talk to Link.")
    call QuestSetDescriptionBJ(udg_SideQuest[22],"Talk to Link.")
    set udg_CurseUnit[5]=ReplaceUnitBJ(gg_unit_u001_0195,'h00U',bj_UNIT_STATE_METHOD_RELATIVE) // 'h00U': unit "Link"
    set udg_SpecialEffect[41]=AddSpecialEffectTargetUnitBJ("overhead",udg_CurseUnit[5],"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call EnableTrigger(gg_trg_MysteriousCurse_LinkReturn)
    call AddUnitToStockBJ('n0C7',gg_unit_n0BW_0094,1,1) // 'n0C7': unit "Hunt: Titania"
    set udg_HuntStock[4]=(udg_HuntStock[4]+1)
    call ConditionalTriggerExecute(gg_trg_Hunt_Board_Markers)
    set udg_CurseStage=7
    call DestroyTrigger(GetTriggeringTrigger())
    set l_tempPoint3=null
endfunction

function Trig_MysteriousCurse_LinkReturn_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,udg_CurseUnit[5],true,true,true))
endfunction

function Trig_MysteriousCurse_LinkReturn_ApplyLinkReturnCam takes nothing returns nothing
    call CameraSetupApplyForPlayer(true,gg_cam_007,GetEnumPlayer(),1.)
endfunction

function Trig_MysteriousCurse_LinkReturn_Cond_ShowGoodbyeTalk takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_MysteriousCurse_LinkReturn_Cond_TownUnderSiege takes nothing returns boolean
    return(IsUnitGroupEmptyBJ(udg_AllyRangerGroup)==false)
endfunction

function Trig_MysteriousCurse_LinkReturn_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[41])
    if(Trig_MysteriousCurse_LinkReturn_Cond_ShowGoodbyeTalk())then
        call Cine_Enter()
        call ForForce(udg_PlayingPlayers,function Trig_MysteriousCurse_LinkReturn_ApplyLinkReturnCam)
        call Text_Say(udg_CurseUnit[5],"Hi again. What news do you bring?",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Adria, the witch that cursed you, is dead and you look normal.",false)
        call Text_Say(udg_CurseUnit[5],"Really?! Thank you very much. I am so glad you believed me and not that evil witch.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"I am glad too. You can return to Kalm now.",false)
        call Text_Say(udg_CurseUnit[5],"I will. Thank you very much. Without your help my suffering would have never ended.",false)
        call Reward_Give($BB8,$9C4,udg_CurseUnit[5]) // $BB8 = 3000; $9C4 = 2500
        set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        call Wait_Polled(.5)
        set udg_TempPoint=GetRectCenter(gg_rct_549)
        call SetUnitPositionLocFacingBJ(GetTriggerUnit(),udg_TempPoint,315.)
        call RemoveLocation(udg_TempPoint)
        call Wait_Polled(2)
        call Cine_ExitAction()
    else
        call Reward_Give($BB8,$9C4,udg_CurseUnit[5]) // $BB8 = 3000; $9C4 = 2500
        set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        set udg_TempPoint=GetRectCenter(gg_rct_549)
        call SetUnitPositionLocFacingBJ(GetTriggerUnit(),udg_TempPoint,315.)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
    endif
    call GroupAddUnitSimple(GetTriggerUnit(),udg_RecruitedAllies)
    if(Trig_MysteriousCurse_LinkReturn_Cond_TownUnderSiege())then
        call ShowUnitHide(GetTriggerUnit())
    endif
    call SetUnitOwner(GetTriggerUnit(),Player(9),true)
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_COMPLETED,"Quest Completed: |cffffcc00Mysterious Curse|r")
    call QuestSetCompletedBJ(udg_SideQuest[22],true)
    set udg_QuestsCompleted=(udg_QuestsCompleted+1)
    set udg_CurseStage=8
    set udg_NewsText[3]=udg_NewsText[2]
    set udg_NewsText[2]=udg_NewsText[1]
    set udg_NewsText[6]=udg_NewsText[5]
    set udg_NewsText[5]=udg_NewsText[4]
    set udg_NewsText[1]="|cffffcc00Link Has Returned|r"
    set udg_NewsText[4]="Link, a swordsman who went missing recently, has reappeared in Kalm. According to his words, the skeleton which attacked Kalm was him. Welcome back anyway, Link!"
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_MysteriousCurse_AdriaDies_Conditions takes nothing returns boolean
    return(udg_CurseLiar==2)
endfunction

function Trig_MysteriousCurse_AdriaDies_Cond_ShowAmbushTalk takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_MysteriousCurse_AdriaDies_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call ReplaceUnitBJ(GetDyingUnit(),'u004',bj_UNIT_STATE_METHOD_RELATIVE) // 'u004': unit "Adria"
    call RemoveUnit(gg_unit_u001_0195)
    call CreateNUnitsAtLocFacingLocBJ(1,'h00U',Player($B),OffsetLocation(GetUnitLoc(GetKillingUnitBJ()),400.,-150.),GetUnitLoc(GetKillingUnitBJ())) // 'h00U': unit "Link"; $B = 11
    call Unit_ScaleToLevel60(bj_lastCreatedUnit)
    set udg_CurseUnit[7]=GetLastCreatedUnit()
    call UnitRemoveAbilityBJ('Avul',GetLastCreatedUnit()) // 'Avul': standard ability reference "Invulnerable"
    call CreateNUnitsAtLocFacingLocBJ(1,'u005',Player($B),OffsetLocation(GetUnitLoc(GetKillingUnitBJ()),300.,0),GetUnitLoc(GetKillingUnitBJ())) // 'u005': unit "Baba Yaga"; $B = 11
    call Unit_ScaleToLevel60(bj_lastCreatedUnit)
    set udg_CurseUnit[6]=GetLastCreatedUnit()
    call SetUnitFacingToFaceUnitTimed(GetKillingUnitBJ(),GetLastCreatedUnit(),0)
    if(Trig_MysteriousCurse_AdriaDies_Cond_ShowAmbushTalk())then
        call PauseUnitBJ(true,udg_CurseUnit[6])
        call PauseUnitBJ(true,udg_CurseUnit[7])
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetKillingUnitBJ())),"Who are you?",false)
        call Text_Say(udg_CurseUnit[6],"I am Baba Yaga. You have killed Adria without whom the Spell of Eternal Youth will lose it's power. I'll have to kill you and then start looking for another Elf maiden.",false)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetKillingUnitBJ())),"I won't let you ruin another person's life. Prepare to die, witch.",false)
        call Cine_ExitAction()
        call PauseUnitBJ(false,udg_CurseUnit[6])
        call PauseUnitBJ(false,udg_CurseUnit[7])
    endif
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_MysteriousCurse_BabaYagaDead_Conditions takes nothing returns boolean
    return(GetDyingUnit()!=null)and(GetDyingUnit()==udg_CurseUnit[6])
endfunction

function Trig_MysteriousCurse_BabaYagaDead_Cond_LinkStillAlive takes nothing returns boolean
    return(IsUnitAliveBJ(udg_CurseUnit[7]))
endfunction

function Trig_MysteriousCurse_BabaYagaDead_Cond_ShowRemorseTalk takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_MysteriousCurse_BabaYagaDead_Actions takes nothing returns nothing
    local location l_tempPoint3
    call DisableTrigger(GetTriggeringTrigger())
    if(Trig_MysteriousCurse_BabaYagaDead_Cond_LinkStillAlive())then
        call KillUnit(udg_CurseUnit[7])
    endif
    set l_tempPoint3=GetUnitLoc(GetTriggerUnit())
    call CreateItemLoc('I01G',l_tempPoint3) // 'I01G': item "Ice Wand"
    call RemoveLocation(l_tempPoint3)
    if(Trig_MysteriousCurse_BabaYagaDead_Cond_ShowRemorseTalk())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetKillingUnitBJ())),"I was a fool to believe Link. But now he and his mistress are dead ... just like Adria, who spoke truth.",false)
        call Reward_Give($3E8,$5DC,null) // $3E8 = 1000; $5DC = 1500
        call Text_Say(null,"|n|cffffcc00All players get 1000 gold and 1500 exp.|r",true)
        call Cine_ExitAction()
    else
        call Reward_Give($3E8,$5DC,GetTriggerUnit()) // $3E8 = 1000; $5DC = 1500
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_COMPLETED,"Quest Completed: |cffffcc00Mysterious Curse|r")
    call QuestSetCompletedBJ(udg_SideQuest[22],true)
    set udg_QuestsCompleted=(udg_QuestsCompleted+1)
    set udg_CurseStage=6
    call AddUnitToStockBJ('n0C7',gg_unit_n0BW_0094,1,1) // 'n0C7': unit "Hunt: Titania"
    set udg_HuntStock[4]=(udg_HuntStock[4]+1)
    call ConditionalTriggerExecute(gg_trg_Hunt_Board_Markers)
    call DestroyTrigger(GetTriggeringTrigger())
    set l_tempPoint3=null
endfunction

// World Editor calls InitTrig_MysteriousCurse automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_MysteriousCurse (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_MysteriousCurse takes nothing returns nothing
endfunction

function Register_MysteriousCurse_Init takes nothing returns nothing
    set gg_trg_MysteriousCurse_Init=CreateTrigger()
    call TriggerAddAction(gg_trg_MysteriousCurse_Init,function Trig_MysteriousCurse_Init_Actions)
endfunction

function Register_MysteriousCurse_Link takes nothing returns nothing
    set gg_trg_MysteriousCurse_Link=CreateTrigger()
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_MysteriousCurse_Link,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_MysteriousCurse_Link,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_MysteriousCurse_Link,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_MysteriousCurse_Link,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_MysteriousCurse_Link,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_MysteriousCurse_Link,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_MysteriousCurse_Link,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_MysteriousCurse_Link,Player(7),true)
    call TriggerAddCondition(gg_trg_MysteriousCurse_Link,Condition(function Trig_MysteriousCurse_Link_Conditions))
    call TriggerAddAction(gg_trg_MysteriousCurse_Link,function Trig_MysteriousCurse_Link_Actions)
endfunction

function Register_MysteriousCurse_Adria takes nothing returns nothing
    set gg_trg_MysteriousCurse_Adria=CreateTrigger()
    call DisableTrigger(gg_trg_MysteriousCurse_Adria)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_MysteriousCurse_Adria,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_MysteriousCurse_Adria,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_MysteriousCurse_Adria,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_MysteriousCurse_Adria,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_MysteriousCurse_Adria,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_MysteriousCurse_Adria,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_MysteriousCurse_Adria,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_MysteriousCurse_Adria,Player(7),true)
    call TriggerAddCondition(gg_trg_MysteriousCurse_Adria,Condition(function Trig_MysteriousCurse_Adria_Conditions))
    call TriggerAddAction(gg_trg_MysteriousCurse_Adria,function Trig_MysteriousCurse_Adria_Actions)
endfunction

function Register_MysteriousCurse_Confront takes nothing returns nothing
    set gg_trg_MysteriousCurse_Confront=CreateTrigger()
    call DisableTrigger(gg_trg_MysteriousCurse_Confront)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_MysteriousCurse_Confront,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_MysteriousCurse_Confront,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_MysteriousCurse_Confront,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_MysteriousCurse_Confront,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_MysteriousCurse_Confront,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_MysteriousCurse_Confront,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_MysteriousCurse_Confront,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_MysteriousCurse_Confront,Player(7),true)
    call TriggerAddCondition(gg_trg_MysteriousCurse_Confront,Condition(function Trig_MysteriousCurse_Confront_Conditions))
    call TriggerAddAction(gg_trg_MysteriousCurse_Confront,function Trig_MysteriousCurse_Confront_Actions)
endfunction

function Register_MysteriousCurse_Witness takes nothing returns nothing
    set gg_trg_MysteriousCurse_Witness=CreateTrigger()
    call DisableTrigger(gg_trg_MysteriousCurse_Witness)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_MysteriousCurse_Witness,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_MysteriousCurse_Witness,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_MysteriousCurse_Witness,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_MysteriousCurse_Witness,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_MysteriousCurse_Witness,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_MysteriousCurse_Witness,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_MysteriousCurse_Witness,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_MysteriousCurse_Witness,Player(7),true)
    call TriggerAddCondition(gg_trg_MysteriousCurse_Witness,Condition(function Trig_MysteriousCurse_Witness_Conditions))
    call TriggerAddAction(gg_trg_MysteriousCurse_Witness,function Trig_MysteriousCurse_Witness_Actions)
endfunction

function Register_MysteriousCurse_AttackLink takes nothing returns nothing
    set gg_trg_MysteriousCurse_AttackLink=CreateTrigger()
    call DisableTrigger(gg_trg_MysteriousCurse_AttackLink)
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_MysteriousCurse_AttackLink,Player(8),EVENT_PLAYER_UNIT_ATTACKED)
    call TriggerAddCondition(gg_trg_MysteriousCurse_AttackLink,Condition(function Trig_MysteriousCurse_AttackLink_Conditions))
    call TriggerAddAction(gg_trg_MysteriousCurse_AttackLink,function Trig_MysteriousCurse_AttackLink_Actions)
endfunction

function Register_MysteriousCurse_AttackAdria takes nothing returns nothing
    set gg_trg_MysteriousCurse_AttackAdria=CreateTrigger()
    call DisableTrigger(gg_trg_MysteriousCurse_AttackAdria)
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_MysteriousCurse_AttackAdria,Player(8),EVENT_PLAYER_UNIT_ATTACKED)
    call TriggerAddCondition(gg_trg_MysteriousCurse_AttackAdria,Condition(function Trig_MysteriousCurse_AttackAdria_Conditions))
    call TriggerAddAction(gg_trg_MysteriousCurse_AttackAdria,function Trig_MysteriousCurse_AttackAdria_Actions)
endfunction

function Register_MysteriousCurse_LinkDies takes nothing returns nothing
    set gg_trg_MysteriousCurse_LinkDies=CreateTrigger()
    call TriggerRegisterUnitEvent(gg_trg_MysteriousCurse_LinkDies,gg_unit_u001_0195,EVENT_UNIT_DEATH)
    call TriggerAddCondition(gg_trg_MysteriousCurse_LinkDies,Condition(function Trig_MysteriousCurse_LinkDies_Conditions))
    call TriggerAddAction(gg_trg_MysteriousCurse_LinkDies,function Trig_MysteriousCurse_LinkDies_Actions)
endfunction

function Register_MysteriousCurse_AdriaWitchDead takes nothing returns nothing
    set gg_trg_MysteriousCurse_AdriaWitchDead=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_MysteriousCurse_AdriaWitchDead,EVENT_PLAYER_UNIT_DEATH)
    call TriggerAddCondition(gg_trg_MysteriousCurse_AdriaWitchDead,Condition(function Trig_MysteriousCurse_AdriaWitchDead_Conditions))
    call TriggerAddAction(gg_trg_MysteriousCurse_AdriaWitchDead,function Trig_MysteriousCurse_AdriaWitchDead_Actions)
endfunction

function Register_MysteriousCurse_BabaYagaAppears takes nothing returns nothing
    set gg_trg_MysteriousCurse_BabaYagaAppears=CreateTrigger()
    call TriggerRegisterUnitEvent(gg_trg_MysteriousCurse_BabaYagaAppears,gg_unit_u001_0195,EVENT_UNIT_DEATH)
    call TriggerAddCondition(gg_trg_MysteriousCurse_BabaYagaAppears,Condition(function Trig_MysteriousCurse_BabaYagaAppears_Conditions))
    call TriggerAddAction(gg_trg_MysteriousCurse_BabaYagaAppears,function Trig_MysteriousCurse_BabaYagaAppears_Actions)
endfunction

function Register_MysteriousCurse_AdriaRestored takes nothing returns nothing
    set gg_trg_MysteriousCurse_AdriaRestored=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_MysteriousCurse_AdriaRestored,EVENT_PLAYER_UNIT_DEATH)
    call TriggerAddCondition(gg_trg_MysteriousCurse_AdriaRestored,Condition(function Trig_MysteriousCurse_AdriaRestored_Conditions))
    call TriggerAddAction(gg_trg_MysteriousCurse_AdriaRestored,function Trig_MysteriousCurse_AdriaRestored_Actions)
endfunction

function Register_MysteriousCurse_AdriaReturn takes nothing returns nothing
    set gg_trg_MysteriousCurse_AdriaReturn=CreateTrigger()
    call DisableTrigger(gg_trg_MysteriousCurse_AdriaReturn)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_MysteriousCurse_AdriaReturn,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_MysteriousCurse_AdriaReturn,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_MysteriousCurse_AdriaReturn,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_MysteriousCurse_AdriaReturn,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_MysteriousCurse_AdriaReturn,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_MysteriousCurse_AdriaReturn,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_MysteriousCurse_AdriaReturn,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_MysteriousCurse_AdriaReturn,Player(7),true)
    call TriggerAddCondition(gg_trg_MysteriousCurse_AdriaReturn,Condition(function Trig_MysteriousCurse_AdriaReturn_Conditions))
    call TriggerAddAction(gg_trg_MysteriousCurse_AdriaReturn,function Trig_MysteriousCurse_AdriaReturn_Actions)
endfunction

function Register_MysteriousCurse_LinkRestored takes nothing returns nothing
    set gg_trg_MysteriousCurse_LinkRestored=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_MysteriousCurse_LinkRestored,EVENT_PLAYER_UNIT_DEATH)
    call TriggerAddCondition(gg_trg_MysteriousCurse_LinkRestored,Condition(function Trig_MysteriousCurse_LinkRestored_Conditions))
    call TriggerAddAction(gg_trg_MysteriousCurse_LinkRestored,function Trig_MysteriousCurse_LinkRestored_Actions)
endfunction

function Register_MysteriousCurse_LinkReturn takes nothing returns nothing
    set gg_trg_MysteriousCurse_LinkReturn=CreateTrigger()
    call DisableTrigger(gg_trg_MysteriousCurse_LinkReturn)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_MysteriousCurse_LinkReturn,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_MysteriousCurse_LinkReturn,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_MysteriousCurse_LinkReturn,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_MysteriousCurse_LinkReturn,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_MysteriousCurse_LinkReturn,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_MysteriousCurse_LinkReturn,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_MysteriousCurse_LinkReturn,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_MysteriousCurse_LinkReturn,Player(7),true)
    call TriggerAddCondition(gg_trg_MysteriousCurse_LinkReturn,Condition(function Trig_MysteriousCurse_LinkReturn_Conditions))
    call TriggerAddAction(gg_trg_MysteriousCurse_LinkReturn,function Trig_MysteriousCurse_LinkReturn_Actions)
endfunction

function Register_MysteriousCurse_AdriaDies takes nothing returns nothing
    set gg_trg_MysteriousCurse_AdriaDies=CreateTrigger()
    call TriggerRegisterUnitEvent(gg_trg_MysteriousCurse_AdriaDies,gg_unit_u002_0196,EVENT_UNIT_DEATH)
    call TriggerAddCondition(gg_trg_MysteriousCurse_AdriaDies,Condition(function Trig_MysteriousCurse_AdriaDies_Conditions))
    call TriggerAddAction(gg_trg_MysteriousCurse_AdriaDies,function Trig_MysteriousCurse_AdriaDies_Actions)
endfunction

function Register_MysteriousCurse_BabaYagaDead takes nothing returns nothing
    set gg_trg_MysteriousCurse_BabaYagaDead=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_MysteriousCurse_BabaYagaDead,EVENT_PLAYER_UNIT_DEATH)
    call TriggerAddCondition(gg_trg_MysteriousCurse_BabaYagaDead,Condition(function Trig_MysteriousCurse_BabaYagaDead_Conditions))
    call TriggerAddAction(gg_trg_MysteriousCurse_BabaYagaDead,function Trig_MysteriousCurse_BabaYagaDead_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_MysteriousCurse takes nothing returns nothing
    call Register_MysteriousCurse_Init() // run by MapBootstrap
    call Register_MysteriousCurse_Link()
    call Register_MysteriousCurse_Adria() // starts off; enabled by MysteriousCurse
    call Register_MysteriousCurse_Confront() // starts off; enabled by MysteriousCurse
    call Register_MysteriousCurse_Witness() // starts off; enabled by Epilogue, Quest_NightElves, Talk
    call Register_MysteriousCurse_AttackLink() // starts off; enabled by MysteriousCurse; disabled by MysteriousCurse; run by MysteriousCurse
    call Register_MysteriousCurse_AttackAdria() // starts off; enabled by MysteriousCurse; disabled by MysteriousCurse; run by MysteriousCurse
    call Register_MysteriousCurse_LinkDies()
    call Register_MysteriousCurse_AdriaWitchDead()
    call Register_MysteriousCurse_BabaYagaAppears()
    call Register_MysteriousCurse_AdriaRestored()
    call Register_MysteriousCurse_AdriaReturn() // starts off; enabled by MysteriousCurse
    call Register_MysteriousCurse_LinkRestored()
    call Register_MysteriousCurse_LinkReturn() // starts off; enabled by MysteriousCurse
    call Register_MysteriousCurse_AdriaDies()
    call Register_MysteriousCurse_BabaYagaDead()
endfunction

endlibrary
