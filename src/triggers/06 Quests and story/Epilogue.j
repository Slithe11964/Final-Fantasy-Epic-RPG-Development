library TEpilogue requires TCam, TCine, TPlayerPart01, TText, TUnit, TWait
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Epilogue_WaitForCid=null
    trigger gg_trg_Epilogue_Kalm=null
    trigger gg_trg_Epilogue_Lothlorien=null
    trigger gg_trg_Epilogue_BlueMage=null
    trigger gg_trg_Epilogue_DarkKnight=null
    trigger gg_trg_Epilogue_Dana=null
endglobals

function Trig_Epilogue_WaitForCid_CidNotAvailable takes nothing returns boolean
    return(udg_CidQuestOnHold==false)
endfunction

function Trig_Epilogue_WaitForCid_Actions takes nothing returns nothing
    if(Trig_Epilogue_WaitForCid_CidNotAvailable())then
        call StartTimerBJ(udg_WorldFreezeTimer,false,5.)
        return
    endif
    call DisableTrigger(GetTriggeringTrigger())
    set udg_SpecialEffect[19]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_Hpb1_0013,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call EnableTrigger(gg_trg_Epilogue_Kalm)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Epilogue_Kalm_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_Hpb1_0013,true,true,true))
endfunction

function Trig_Epilogue_Kalm_ApplyCameraKalm takes nothing returns nothing
    call CameraSetupApplyForPlayer(true,gg_cam_001,GetEnumPlayer(),0)
endfunction

function Trig_Epilogue_Kalm_CinematicsOnKalm takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Epilogue_Kalm_StageBelow9 takes nothing returns boolean
    return(udg_CidQuestStage<9)
endfunction

function Trig_Epilogue_Kalm_GiottQuestNotStarted takes nothing returns boolean
    return(udg_KalmTechLevel<=0)
endfunction

function Trig_Epilogue_Kalm_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[19])
    if(Trig_Epilogue_Kalm_CinematicsOnKalm())then
        call Cine_Enter()
        call ForForce(udg_PlayingPlayers,function Trig_Epilogue_Kalm_ApplyCameraKalm)
        call Text_Say(gg_unit_Hpb1_0013,"Welcome back. Now I'm sure this will be a lot to take in but can you explain to us what has been going on?",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Well we're not sure entirely what happened ourselves, but at the very least the imminent threat seems to have passed.",false)
        call Text_Say(udg_Mid,"Hmm I suppose the recent events and changes remain mysteries then?",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Yeah, unfortunately we don't know a whole lot more than before. We did beat up a pretty strong demon though, so that helps.",false)
        call Text_Say(gg_unit_Hpb1_0013,"I see. Well it is reassuring to have you here in case we need protection from more prime evils. In the meantime I suppose we had better deal with the increased monster aggression until things calm back down.",false)
        call Text_Say(udg_Mid,"Thank you for all you've done. As a token of gratitude, here, bring this letter to a dwarf named Giott in the Barrens. If you need a good forge or smith, this should make them help you.",false)
        call Cine_ExitAction()
    endif
    if(Trig_Epilogue_Kalm_StageBelow9())then
        call ConditionalTriggerExecute(gg_trg_Quest_KillSetag_Offer)
        call ConditionalTriggerExecute(gg_trg_Quest_Caravan_SamAvailable)
        call ConditionalTriggerExecute(gg_trg_Quest_KillElmdor_Available)
        call ConditionalTriggerExecute(gg_trg_Quest_DeliverLetter_Available)
        call ConditionalTriggerExecute(gg_trg_Quest_Beastslayer_Available)
        call ConditionalTriggerExecute(gg_trg_Monica_ShowMarker)
    endif
    set udg_StoryProgress=(udg_StoryProgress+1)
    call ConditionalTriggerExecute(gg_trg_QuestCount_Milestones)
    if(Trig_Epilogue_Kalm_GiottQuestNotStarted())then
        set udg_KalmTechLevel=2
        call DisableTrigger(gg_trg_Giott_FirstTalk)
        call DestroyEffectBJ(udg_SpecialEffect[87])
    endif
    set udg_SpecialEffect[87]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_h00R_0256,"Objects\\RandomObject\\RandomObject.mdl")
    set udg_QuestItem[26]=UnitAddItemByIdSwapped('I0KP',Player_GetHero(GetTriggerPlayer())) // 'I0KP': item "Letter from Mid"
    call SetItemInvulnerableBJ(GetLastCreatedItem(),true)
    call EnableTrigger(gg_trg_Mid_Letter_Ping)
    call EnableTrigger(gg_trg_Giott_Letter_Deliver)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Epilogue_Lothlorien_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_Emns_0156,true,true,true))
endfunction

function Trig_Epilogue_Lothlorien_ApplyCameraLothlorien takes nothing returns nothing
    call CameraSetupApplyForPlayer(true,gg_cam_006,GetEnumPlayer(),0)
endfunction

function Trig_Epilogue_Lothlorien_LothlorienClosed takes nothing returns boolean
    return(udg_LothlorienOpen==false)
endfunction

function Trig_Epilogue_Lothlorien_LothlorienClosedAlt takes nothing returns boolean
    return(udg_LothlorienOpen==false)
endfunction

function Trig_Epilogue_Lothlorien_CinematicsOnLothlorien takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Epilogue_Lothlorien_PriceNotSet takes nothing returns boolean
    return(udg_ShadowLoyalty<=0)
endfunction

function Trig_Epilogue_Lothlorien_LothlorienNotOpened takes nothing returns boolean
    return(udg_LothlorienOpen==false)
endfunction

function Trig_Epilogue_Lothlorien_WardenTriggerActive takes nothing returns boolean
    return(IsTriggerEnabled(gg_trg_Talk_ForestGuardian))
endfunction

function Trig_Epilogue_Lothlorien_WardenSilent takes nothing returns boolean
    return(udg_PortalGuardianMet==false)
endfunction

function Trig_Epilogue_Lothlorien_WayGateHidden takes nothing returns boolean
    return(IsUnitHiddenBJ(gg_unit_nwgt_0142))
endfunction

function Trig_Epilogue_Lothlorien_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[30])
    if(Trig_Epilogue_Lothlorien_CinematicsOnLothlorien())then
        call Cine_Enter()
        call ForForce(udg_PlayingPlayers,function Trig_Epilogue_Lothlorien_ApplyCameraLothlorien)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Greetings to you, noble Lord and Lady.",false)
        if(Trig_Epilogue_Lothlorien_LothlorienClosed())then
            call Text_Say(gg_unit_Emns_0156,"We welcome you, human.",false)
        endif
        call Text_Say(gg_unit_Etyr_0155,"Human from outside, perhaps you can enlighten us. We felt an incredible release of energy earlier, as about a dozen sources of immense power dispersed. Have you born witness to what occurred in this world?",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Indeed we have. The release of energies came from twelve demons who sacrificed themselves to take out an even more powerful demon, who was threatening the very existence of this plane... which we ourselves had summoned from beyond a demonic gate.",false)
        call Text_Say(gg_unit_Emns_0156,"Twelve demons... so it is as we thought. The age of the Zodiacs has ended.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Zodiacs?",false)
        call Text_Say(gg_unit_Etyr_0155,"The twelve demons you speak of were called the Zodiac Braves. Long ago they ruled over this world with an iron fist, permitting no insubordination.",false)
        call Text_Say(gg_unit_Emns_0156,"Galadriel and I have long since sought to rid the world of them. But we only ever managed to seal them away. Your plan was most brilliant.",false)
        call Text_Say(gg_unit_Etyr_0155,"Making them sacrifice themselves against an existential threat... a daring, but genius idea.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Well it's not like it was intentional. We kinda just summoned the demon for no real reason.",false)
        call Text_Say(gg_unit_Etyr_0155,"In any case, it was a complete success. Allow me to thank and congratulate you on behalf of our entire race.",false)
        call Text_Say(gg_unit_Emns_0156,"I give you my word that your names will be passed down as the heroes who rid the world of these great evils for all ages to come.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Uh... thank you.",false)
        call Text_Say(gg_unit_Emns_0156,"Well now, with the main threat removed it's time we rebuilt things to suit our needs.",false)
        if(Trig_Epilogue_Lothlorien_LothlorienClosedAlt())then
            call Text_Say(gg_unit_Etyr_0155,"Lothlorien usually doesn't take well to outsiders, but of course you are our most welcome guests. Feel free to look around at your leisure.",false)
        else
            call Text_Say(gg_unit_Etyr_0155,"Allow me to once more apologize for our conduct when you first came here. You are our most welcome guests.",false)
        endif
        call Cine_ExitAction()
    endif
    if(Trig_Epilogue_Lothlorien_LothlorienNotOpened())then
        set udg_LothlorienOpen=true
        call UnitAddAbilityBJ('Aneu',gg_unit_eaom_0159) // 'Aneu': standard ability reference "Neutral Building"
        call UnitAddAbilityBJ('Aneu',gg_unit_n00L_0153) // 'Aneu': standard ability reference "Neutral Building"
        call ConditionalTriggerExecute(gg_trg_Quest_LadyNashj_Available)
        call ConditionalTriggerExecute(gg_trg_DefiledFountain_Prepare)
        call ConditionalTriggerExecute(gg_trg_Liniel_ShowMarker)
        call ConditionalTriggerExecute(gg_trg_ShinrasPlan_Prepare)
        call ConditionalTriggerExecute(gg_trg_Krjn_ShowTalkIcon)
        call EnableTrigger(gg_trg_MysteriousCurse_Witness)
        set udg_QuestMarkerEffect[16]=AddSpecialEffectTargetUnitBJ("head",gg_unit_esen_0152,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
        call EnableTrigger(gg_trg_BridgeBattle_Prepare)
        if(Trig_Epilogue_Lothlorien_PriceNotSet())then
            call TriggerExecute(gg_trg_NightElf_TalkPrepare)
        else
            call EnableTrigger(gg_trg_NightElf_TalkPrepare)
        endif
    endif
    call ConditionalTriggerExecute(gg_trg_ArenaResources_Prepare)
    if(Trig_Epilogue_Lothlorien_WardenSilent())then
        call UnitAddAbilityBJ('Ane2',gg_unit_Ecen_0180) // 'Ane2': object name not found in map data
        if(Trig_Epilogue_Lothlorien_WardenTriggerActive())then
            call DisableTrigger(gg_trg_Talk_ForestGuardian)
            call DestroyTrigger(gg_trg_Talk_ForestGuardian)
        else
            call DisableTrigger(gg_trg_Talk_PortalGuardian)
            call DestroyTrigger(gg_trg_Talk_PortalGuardian)
        endif
    else
        set udg_SpecialEffect[37]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_Ecen_0180,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    endif
    call EnableTrigger(gg_trg_Nimphrodel_Start)
    if(Trig_Epilogue_Lothlorien_WayGateHidden())then
        call TriggerExecute(gg_trg_Portal_Reveal)
    endif
    set udg_StoryProgress=(udg_StoryProgress+1)
    call ConditionalTriggerExecute(gg_trg_QuestCount_Milestones)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Epilogue_BlueMage_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_Othr_0106,true,true,true))
endfunction

function Trig_Epilogue_BlueMage_ApplyCameraBlueMage takes nothing returns nothing
    call CameraSetupApplyForPlayer(true,gg_cam_003,GetEnumPlayer(),1.)
endfunction

function Trig_Epilogue_BlueMage_StageBelow12 takes nothing returns boolean
    return(udg_CidQuestStage<$C) // $C = 12
endfunction

function Trig_Epilogue_BlueMage_CinematicsOnBlueMage takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Epilogue_BlueMage_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[21])
    call SetUnitPositionLoc(gg_unit_Othr_0106,udg_AoMadoushiLoc)
    call SetUnitFacingTimed(gg_unit_Othr_0106,udg_AoMadoushiFacing,0)
    if(Trig_Epilogue_BlueMage_CinematicsOnBlueMage())then
        call Cine_Enter()
        call ForForce(udg_PlayingPlayers,function Trig_Epilogue_BlueMage_ApplyCameraBlueMage)
        if(Trig_Epilogue_BlueMage_StageBelow12())then
            call Text_Say(gg_unit_Othr_0106,"Greetings, adventurers.",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"You're a local forest hermit?",false)
            call Text_Say(gg_unit_Othr_0106,"That I am, Ao Madoushi is my name. I have been awakened from a long slumber by a powerful energy arriving in this world.",false)
            call Text_Say(gg_unit_Othr_0106,"Yet no sooner had it come, no later was it gone. A massive release of energies that I know well. Demonic power fading. And within, the energy of a human. Yours, was it not?",false)
        else
            call Text_Say(gg_unit_Othr_0106,"Greetings again, adventurers. It seems you have been quite busy.",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"Oh you have no idea!",false)
            call Text_Say(gg_unit_Othr_0106,"Let me guess. A demon from outside coming in. A fierce battle. And finally, a massive release of energies that I know well. Demonic power fading. And within it all, the energy of a human. Yours, was it not?",false)
        endif
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Wow, you could sense all that?",false)
        call Text_Say(gg_unit_Othr_0106,"I am sadly familiar with the processes more than I would like to be. However, that is also why what happened is more perplexing to me than anyone.",false)
        call Text_Say(gg_unit_Othr_0106,"My entire clan was destroyed by demons long ago. And I've seen far more destruction wrought by them in other worlds as well. But I can't deny that sacrificing their lives was a noble act by those twelve.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"It was a surprising occurrence. I'm still not entirely sure what happened there.",false)
        call Text_Say(gg_unit_Othr_0106,"I never dreamed of demons being even capable of doing that. Perhaps I'm too old and the years have clouded my sight.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Well whatever may have been, they're all gone now.",false)
        call Text_Say(gg_unit_Othr_0106,"That they are. Hopefully Gaya will now enter an era of peace.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Definitely.",false)
        call Cine_ExitAction()
    endif
    set udg_StoryProgress=(udg_StoryProgress+1)
    call ConditionalTriggerExecute(gg_trg_QuestCount_Milestones)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Epilogue_DarkKnight_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,udg_StoryBoss,true,true,true))
endfunction

function Trig_Epilogue_DarkKnight_CinematicsOnDarkKnight takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Epilogue_DarkKnight_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[43])
    if(Trig_Epilogue_DarkKnight_CinematicsOnDarkKnight())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(udg_StoryBoss,"I can't believe what happened...",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Who are you exactly?",false)
        call Text_Say(udg_StoryBoss,"That's not important. I saw what transpired on that icy mountaintop. Are you even aware of the implications of it?",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Uhm... not really. We mostly just stumbled our way on there.",false)
        call Text_Say(udg_StoryBoss,"Well you certainly are powerful, there's no denying that. But ultimately the threat you spawned forth led the true rulers of the world to sacrifice themselves for everyone else's sake.",false)
        call Text_Say(udg_StoryBoss,"And even thinking of how self-congratulatory the humans and elves will be over this already disgusts me. Not like any of them were there or ever even had the intention or resolve to lay down their lives for this world. Just goes to show who it is that actually cares.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Hey...",false)
        call Text_Say(udg_StoryBoss,"You're a new outsider aren't you? You haven't seen the way the world has degraded over the past 100 years, ever since some elves with an ego rose up because they couldn't handle not being the best and brightest around.",false)
        call Text_Say(udg_StoryBoss,"It doesn't matter now. What happened is my defeat. This is... the worst possible ending.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"... I have no idea what you're talking about. Are you just going to ramble on?",false)
        call Text_Say(udg_StoryBoss,"That's the worst part. I can't even hate you for what you did. Because you don't even understand it. Not that I could take you on even if I wanted to. You've well proven your power far exceeds mine.",false)
        call Text_Say(udg_StoryBoss,"Still, I have no reason to stay around these parts. I'm not welcome, nor would I want to be.",false)
        set udg_TempPoint=GetUnitLoc(udg_StoryBoss)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Undead\\AnimateDead\\AnimateDeadTarget.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        call KillUnit(udg_StoryBoss)
        call RemoveUnit(udg_StoryBoss)
        call Wait_Polled(2)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"What a strange man... well he was frustrated, but didn't seem to be a bad guy.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Maybe we'll meet again someday.",false)
        call Cine_ExitAction()
    else
        set udg_TempPoint=GetUnitLoc(udg_StoryBoss)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Undead\\AnimateDead\\AnimateDeadTarget.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        call KillUnit(udg_StoryBoss)
        call RemoveUnit(udg_StoryBoss)
    endif
    call EnableTrigger(gg_trg_DeathSeeker_Give)
    set udg_StoryProgress=(udg_StoryProgress+1)
    call ConditionalTriggerExecute(gg_trg_QuestCount_Milestones)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Epilogue_Dana_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_n0BN_0171,true,true,true))
endfunction

function Trig_Epilogue_Dana_CinematicsOnDana takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Epilogue_Dana_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[70])
    if(Trig_Epilogue_Dana_CinematicsOnDana())then
        call PauseUnitBJ(true,gg_unit_n0BN_0171)
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(gg_unit_n0BN_0171,"You've really done it... I can hardly believe it.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"I see you're still around.",false)
        call Text_Say(gg_unit_n0BN_0171,"All the Zodiac Braves, they all sacrificed themselves, didn't they?",false)
        call Text_Say(gg_unit_n0BN_0171,"So then what are we to do now...",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Well what are the people of the Phantom Village wanting to do?",false)
        call Text_Say(gg_unit_n0BN_0171,"You know... we of the Phantom Village used to be part of Lothlorien. Tensions between the elves who hated demons and elves who trusted them ran high.",false)
        call Text_Say(gg_unit_n0BN_0171,"Eventually the other faction executed a plan to imprison the most important members of the Zodiac Braves... Hashmalum, their leader, and Ultima, their executioner.",false)
        call Text_Say(gg_unit_n0BN_0171,"It was a despicable trap they'd set up and followed through on without even consulting us. And I knew that we would be next.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"You would be \"next\"? What do you mean?",false)
        call Text_Say(gg_unit_n0BN_0171,"While tensions were running high I still tried to keep harmony between the factions. But Celeborn and Galadriel were set in their ways. They wanted to expunge the demons at all costs. They couldn't have had me running around as the maiden of Lothlorien. I have no doubts they were already on their way to find an excuse to get rid of me as well.",false)
        call Text_Say(gg_unit_n0BN_0171,"And if things had gotten really bad, perhaps a war could've started among us elves...",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Damn that sounds dangerous. But it ended up with you just being exiled?",false)
        call Text_Say(gg_unit_n0BN_0171,"No, we were never exiled officially. I couldn't face what was ahead, so I just gathered my closest followers and left, telling them we had an important duty to fulfill to keep order intact, and so we came here and became the Phantom Village.",false)
        call Text_Say(gg_unit_n0BN_0171,"Even though I never told them, I think they knew already. That Lothlorien was no longer safe for us. But even so we love Gaya and want to do what we can to maintain its beauty.",false)
        call Text_Say(gg_unit_n0BN_0171,"I was hoping to one day join up with the remaining Zodiac Braves and take down Celeborn and Galadriel. However much I hated it I prepared myself to wage war against my fellow elves. But that never came to pass.",false)
        call Text_Say(gg_unit_n0BN_0171,"The Braves weren't wanting to just clean up the mess the humans and elves had left... rather they'd just freeze over the whole world so that no one could defile it any longer.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Oh, so that's what that demon I summoned forth was expecting?",false)
        call Text_Say(gg_unit_n0BN_0171,"Yes... but in the end it seems even they can't bear to have the world just freeze over forever. It's ironic. This is the exact outcome they'd been wanting to avoid. Now humans and elves will rule the world to do as they please.",false)
        call Text_Say(gg_unit_n0BN_0171,"In any case... this has not much to do with you. I'm sorry for rambling.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"It's alright. It seems the situation is a lot more complex than it appeared. We'll be sticking around in this world for a while, so we'll see where it goes.",false)
        call Text_Say(gg_unit_n0BN_0171,"Thank you.",false)
        call Text_Say(gg_unit_n0BN_0171,"Here... please take this pendant. It's kept me safe forever. I hope it shields you from evil spirits.",false)
        call Cine_ExitAction()
        call PauseUnitBJ(false,gg_unit_n0BN_0171)
    endif
    set udg_QuestItem[$E]=UnitAddItemByIdSwapped('I0I9',Player_GetHero(GetTriggerPlayer())) // $E = 14; 'I0I9': item "Shimmering Pendant"
    call SetItemInvulnerableBJ(GetLastCreatedItem(),true)
    set udg_StoryProgress=(udg_StoryProgress+1)
    call ConditionalTriggerExecute(gg_trg_QuestCount_Milestones)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_Epilogue automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Epilogue (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Epilogue takes nothing returns nothing
endfunction

function Register_Epilogue_WaitForCid takes nothing returns nothing
    set gg_trg_Epilogue_WaitForCid=CreateTrigger()
    call DisableTrigger(gg_trg_Epilogue_WaitForCid)
    call TriggerRegisterTimerExpireEventBJ(gg_trg_Epilogue_WaitForCid,udg_WorldFreezeTimer)
    call TriggerAddAction(gg_trg_Epilogue_WaitForCid,function Trig_Epilogue_WaitForCid_Actions)
endfunction

function Register_Epilogue_Kalm takes nothing returns nothing
    set gg_trg_Epilogue_Kalm=CreateTrigger()
    call DisableTrigger(gg_trg_Epilogue_Kalm)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Epilogue_Kalm,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Epilogue_Kalm,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Epilogue_Kalm,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Epilogue_Kalm,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Epilogue_Kalm,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Epilogue_Kalm,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Epilogue_Kalm,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Epilogue_Kalm,Player(7),true)
    call TriggerAddCondition(gg_trg_Epilogue_Kalm,Condition(function Trig_Epilogue_Kalm_Conditions))
    call TriggerAddAction(gg_trg_Epilogue_Kalm,function Trig_Epilogue_Kalm_Actions)
endfunction

function Register_Epilogue_Lothlorien takes nothing returns nothing
    set gg_trg_Epilogue_Lothlorien=CreateTrigger()
    call DisableTrigger(gg_trg_Epilogue_Lothlorien)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Epilogue_Lothlorien,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Epilogue_Lothlorien,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Epilogue_Lothlorien,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Epilogue_Lothlorien,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Epilogue_Lothlorien,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Epilogue_Lothlorien,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Epilogue_Lothlorien,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Epilogue_Lothlorien,Player(7),true)
    call TriggerAddCondition(gg_trg_Epilogue_Lothlorien,Condition(function Trig_Epilogue_Lothlorien_Conditions))
    call TriggerAddAction(gg_trg_Epilogue_Lothlorien,function Trig_Epilogue_Lothlorien_Actions)
endfunction

function Register_Epilogue_BlueMage takes nothing returns nothing
    set gg_trg_Epilogue_BlueMage=CreateTrigger()
    call DisableTrigger(gg_trg_Epilogue_BlueMage)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Epilogue_BlueMage,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Epilogue_BlueMage,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Epilogue_BlueMage,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Epilogue_BlueMage,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Epilogue_BlueMage,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Epilogue_BlueMage,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Epilogue_BlueMage,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Epilogue_BlueMage,Player(7),true)
    call TriggerAddCondition(gg_trg_Epilogue_BlueMage,Condition(function Trig_Epilogue_BlueMage_Conditions))
    call TriggerAddAction(gg_trg_Epilogue_BlueMage,function Trig_Epilogue_BlueMage_Actions)
endfunction

function Register_Epilogue_DarkKnight takes nothing returns nothing
    set gg_trg_Epilogue_DarkKnight=CreateTrigger()
    call DisableTrigger(gg_trg_Epilogue_DarkKnight)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Epilogue_DarkKnight,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Epilogue_DarkKnight,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Epilogue_DarkKnight,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Epilogue_DarkKnight,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Epilogue_DarkKnight,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Epilogue_DarkKnight,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Epilogue_DarkKnight,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Epilogue_DarkKnight,Player(7),true)
    call TriggerAddCondition(gg_trg_Epilogue_DarkKnight,Condition(function Trig_Epilogue_DarkKnight_Conditions))
    call TriggerAddAction(gg_trg_Epilogue_DarkKnight,function Trig_Epilogue_DarkKnight_Actions)
endfunction

function Register_Epilogue_Dana takes nothing returns nothing
    set gg_trg_Epilogue_Dana=CreateTrigger()
    call DisableTrigger(gg_trg_Epilogue_Dana)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Epilogue_Dana,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Epilogue_Dana,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Epilogue_Dana,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Epilogue_Dana,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Epilogue_Dana,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Epilogue_Dana,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Epilogue_Dana,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Epilogue_Dana,Player(7),true)
    call TriggerAddCondition(gg_trg_Epilogue_Dana,Condition(function Trig_Epilogue_Dana_Conditions))
    call TriggerAddAction(gg_trg_Epilogue_Dana,function Trig_Epilogue_Dana_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Epilogue takes nothing returns nothing
    call Register_Epilogue_WaitForCid() // starts off; enabled by TrueIceAge
    call Register_Epilogue_Kalm() // starts off; enabled by Epilogue
    call Register_Epilogue_Lothlorien() // starts off; enabled by TrueIceAge
    call Register_Epilogue_BlueMage() // starts off; enabled by TrueIceAge
    call Register_Epilogue_DarkKnight() // starts off; enabled by TrueIceAge
    call Register_Epilogue_Dana() // starts off; enabled by Dana, TrueIceAge
endfunction

endlibrary
