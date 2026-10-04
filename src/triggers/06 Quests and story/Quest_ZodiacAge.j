library TQuestZodiacAge requires TQuestEngine, TCam, TCine, TMusic, TPlayerHero, TText, TUnit, TWait
// Main quest "End of Zodiac Age" (udg_MainQuest[18]), run by the quest engine (QuestEngine module,
// docs/QUEST_ENGINE.md). Celeborn and Galadriel tell the party that Hashmalum, leader of the Zodiac
// Braves, hides beyond the Great Wall; the party must find a way into the Icy Realm (the gate, Celeborn,
// Talon, Dana's Shimmering Pendant) and defeat him. If the party meets Hashmalum first, the quest starts
// there instead (Boss_Hashmalum's Intro calls QuestZodiacAge_StartAtHashmalum). Both steps are custom:
// the quest starts (Start or Boss_Hashmalum) and Hashmalum dies for good (Boss_Hashmalum's Death_Final
// calls QuestZodiacAge_HashmalumSlain). The search on the way only changes the quest log: Quest_SetLog
// here and in Boss_Mateus (QuestZodiacAge_MateusSlain); Boss_Mateus's intro and Gate write the log entry
// directly. The "!" and "?" are this module's own effects.
// Does not count toward the story.
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Quest_ZodiacAge_Start=null
    trigger gg_trg_Quest_ZodiacAge_GateBlocked=null
    trigger gg_trg_Quest_ZodiacAge_AskCeleborn=null
    trigger gg_trg_Quest_ZodiacAge_AskTalon=null
    trigger gg_trg_Quest_ZodiacAge_GetPendant=null
    trigger gg_trg_Quest_ZodiacAge_ShowPendant=null
    trigger gg_trg_Quest_ZodiacAge_TalonOpensGate=null
    // The quest's number in the quest engine (0 until it is defined).
    integer QUEST_ZODIAC_AGE=0
endglobals

// l_firstLog: the quest's first description, which depends on how far the party already got.
function QuestZodiacAge_Define takes string l_firstLog returns nothing
    local integer q=Quest_Define("End of Zodiac Age",QUEST_MAIN,18,"ReplaceableTextures\\CommandButtons\\BTNMetamorphosis.blp")
    set QUEST_ZODIAC_AGE=q
    call Quest_Color(q,udg_QuestTitleColor)
    call Quest_NotStory(q)
    call Quest_NoMarker(q)
    // 1. Talk to Celeborn (gg_trg_Quest_ZodiacAge_Start), or meet Hashmalum (Boss_Hashmalum)
    call Quest_Custom(q,l_firstLog)
    // 2. Defeat Hashmalum for good (Boss_Hashmalum)
    call Quest_Custom(q,"")
endfunction

// The party met Hashmalum before Celeborn told them about him (called by Boss_Hashmalum's Intro).
function QuestZodiacAge_StartAtHashmalum takes nothing returns nothing
    if QUEST_ZODIAC_AGE==0 then
        call QuestZodiacAge_Define("Hashmalum, the Zodiac Brave of Earth and leader of all Zodiac Braves, is summoning a calamity. Take him down before the summoning finishes!")
    endif
    call Quest_Start(QUEST_ZODIAC_AGE,null,null)
endfunction

// Hashmalum is dead for good: the quest is done (called by Boss_Hashmalum's Death_Final).
function QuestZodiacAge_HashmalumSlain takes nothing returns nothing
    call Quest_StepDone(QUEST_ZODIAC_AGE,null,null)
endfunction

// Talon opened the way into the Icy Realm (TalonOpensGate).
function QuestZodiacAge_GateOpened takes nothing returns nothing
    call Quest_SetLog(QUEST_ZODIAC_AGE,"Venture forth into the Icy Realm.",true)
endfunction

// Mateus fell and dropped the Winter Key (called by Boss_Mateus through ExecuteFunc).
function QuestZodiacAge_MateusSlain takes nothing returns nothing
    call Quest_SetLog(QUEST_ZODIAC_AGE,"Use the Winter Key to continue your search for Hashmalum.",true)
endfunction

function Trig_Quest_ZodiacAge_Start_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_Emns_0156,true,true,true))
endfunction

function Trig_Quest_ZodiacAge_Start_Enum_ApplyCamera takes nothing returns nothing
    call CameraSetupApplyForPlayer(true,gg_cam_006,GetEnumPlayer(),0)
endfunction

function Trig_Quest_ZodiacAge_Start_Cond_GateVisited_Dialog takes nothing returns boolean
    return(udg_HardMode)
endfunction

function Trig_Quest_ZodiacAge_Start_Cond_GateOpen_Dialog takes nothing returns boolean
    return(udg_ZodiacQuestStage==7)
endfunction

function Trig_Quest_ZodiacAge_Start_Cond_HashmalumMet takes nothing returns boolean
    return(udg_HashmalumEncountered)
endfunction

function Trig_Quest_ZodiacAge_Start_Cond_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_ZodiacAge_Start_Cond_GateVisited_Quest takes nothing returns boolean
    return(udg_HardMode)
endfunction

function Trig_Quest_ZodiacAge_Start_Cond_GateOpen_Quest takes nothing returns boolean
    return(udg_ZodiacQuestStage==7)
endfunction

function Trig_Quest_ZodiacAge_Start_Cond_HashmalumNotMet takes nothing returns boolean
    return(udg_HashmalumEncountered==false)
endfunction

// Step 1: a hero talks to Celeborn. Unless the party has already met Hashmalum, the quest starts; its first
// text depends on whether the gate to the Icy Realm is open or was already visited.
function Trig_Quest_ZodiacAge_Start_Actions takes nothing returns nothing
    local string l_firstLog
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[43])
    call GroupRemoveUnitSimple(gg_unit_Emns_0156,udg_QuestUnits)
    if(Trig_Quest_ZodiacAge_Start_Cond_CinematicsEnabled())then
        call Cine_Enter()
        call ForForce(udg_PlayingPlayers,function Trig_Quest_ZodiacAge_Start_Enum_ApplyCamera)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Why have you summoned us, Celeborn?",false)
        call Text_Say(gg_unit_Emns_0156,"Galadriel's scouts have located a power source that may be Hashmalum's.",false)
        if(Trig_Quest_ZodiacAge_Start_Cond_HashmalumMet())then
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"What took you so long? We've already found and encountered him.",false)
            call Text_Say(gg_unit_Etyr_0155,"Oh. You have?",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"Yeah. We had to retreat for the time being as his power is still immense.",false)
            call Text_Say(gg_unit_Emns_0156,"It seems our efforts were unnecessary. But still, I wish you good luck in the task before you.",false)
            call Text_Say(gg_unit_Etyr_0155,"May the gods be with you.",false)
        else
            call Text_Say(gg_unit_Etyr_0155,"Beyond the Great Wall, in the realm of ice, a new power source has appeared. It exudes an aura of extreme danger. It must be Hashmalum.",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"\"Must be\"? Do you not know for sure?",false)
            call Text_Say(gg_unit_Etyr_0155,"Unfortunately, while we can sense his power from outside, we cannot enter the icy realm. It is closed off.",false)
            call Text_Say(gg_unit_Emns_0156,"Long ago, after the last war, we night elves collaborated with the humans in creating the Great Wall to shield us from the approaching eternal winter. The gates inside were to remain forever closed to prevent it from leaking and turning our whole world to ice.",false)
            call Text_Say(gg_unit_Emns_0156,"However, the gates no longer heed our will. It seems that rather than shielding us from them, they have been turned from the inside, and now they shield them from us.",false)
            if(Trig_Quest_ZodiacAge_Start_Cond_GateOpen_Dialog())then
                call Text_Say(Player_GetHero(GetTriggerPlayer()),"Oh we have already opened those gates. We can enter the icy realm right away.",false)
                call Text_Say(gg_unit_Emns_0156,"You have? That makes things much easier.",false)
                call Text_Say(gg_unit_Etyr_0155,"Hashmalum must be in there somewhere. It's our best chance to take him out now.",false)
                call Text_Say(Player_GetHero(GetTriggerPlayer()),"Worry not. We will find and defeat him.",false)
                call Text_Say(gg_unit_Emns_0156,"I bid you good luck in this difficult task.",false)
            else
                call Text_Say(Player_GetHero(GetTriggerPlayer()),"Sneaky... but that means Hashmalum is still buying time. If we can make it through and strike now, we may have a good chance at defeating him.",false)
                call Text_Say(gg_unit_Etyr_0155,"You are correct. Getting into the realm of ice is the key to winning this war.",false)
                if(Trig_Quest_ZodiacAge_Start_Cond_GateVisited_Dialog())then
                    call Text_Say(Player_GetHero(GetTriggerPlayer()),"We've actually been to these gates before. When we approached them, a voice spoke to us in our heads. That only someone who swore allegiance to 'the queen' may pass.",false)
                    call Text_Say(gg_unit_Emns_0156,"The queen? Who could that be?",false)
                    call Text_Say(gg_unit_Etyr_0155,"The realm of ice was closed to us our entire lives long. If there is a queen that reigns inside it is beyond our knowledge.",false)
                    call Text_Say(gg_unit_Emns_0156,"You are right. All my long life long I've never heard of a queen beyond the barrier.",false)
                    call Text_Say(Player_GetHero(GetTriggerPlayer()),"Well if we know nothing about this queen we won't be able to enter. There must be someone who knows.",false)
                    call Text_Say(gg_unit_Etyr_0155,"Maybe...",false)
                    call Text_Say(gg_unit_Emns_0156,"Are you thinking of someone?",false)
                    call Text_Say(gg_unit_Etyr_0155,"Yes. There is a wizard in Lothlorien who goes by the name Talon. He was a close confidant of Lady Dana at the time of the last war. He may know more about the area beyond the barrier than we do.",false)
                    call Text_Say(gg_unit_Emns_0156,"Talon... he hasn't spoken to us in how many years?",false)
                    call Text_Say(Player_GetHero(GetTriggerPlayer()),"It matters not. He may not even have the information we seek. We lose nothing by trying.",false)
                else
                    call Text_Say(Player_GetHero(GetTriggerPlayer()),"I will go investigate the gate right away. There may be a clue.",false)
                endif
            endif
        endif
        call Cine_ExitAction()
    endif
    if(Trig_Quest_ZodiacAge_Start_Cond_HashmalumNotMet())then
        if(Trig_Quest_ZodiacAge_Start_Cond_GateOpen_Quest())then
            set l_firstLog="Hashmalum, the Zodiac Brave of Earth and leader of all Zodiac Braves, appears to be hiding beyond the Great Wall in the northeast of Gaya. Venture forth into the Icy Realm to find and defeat him!"
        else
            if(Trig_Quest_ZodiacAge_Start_Cond_GateVisited_Quest())then
                call GroupAddUnitSimple(gg_unit_e015_0238,udg_QuestUnits)
                call EnableTrigger(gg_trg_Quest_ZodiacAge_AskTalon)
                set udg_SpecialEffect[43]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_e015_0238,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
                set udg_ZodiacQuestStage=3
                set l_firstLog="Hashmalum, the Zodiac Brave of Earth and leader of all Zodiac Braves, appears to be hiding beyond the Great Wall in the northeast of Gaya. However, the area is closed off. Speak with Talon, Wizard in Lothlorien, to get a clue on how to get inside!"
            else
                set udg_ZodiacQuestStage=1
                set l_firstLog="Hashmalum, the Zodiac Brave of Earth and leader of all Zodiac Braves, appears to be hiding beyond the Great Wall in the northeast of Gaya. However, the area is closed off. Investigate the gates to find a potential clue!"
            endif
        endif
        if QUEST_ZODIAC_AGE==0 then
            call QuestZodiacAge_Define(l_firstLog)
        endif
        call Quest_Start(QUEST_ZODIAC_AGE,GetTriggerPlayer(),GetTriggerUnit())
        call Music_SetZoneTrack($A) // $A = 10
        set udg_HashmalumStage=2
    endif
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Quest_ZodiacAge_GateBlocked_Conditions takes nothing returns boolean
    return((IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(GetUnitTypeId(GetTriggerUnit())!='H01D')and(udg_InCinematicMode==false))!=null // 'H01D': unit "Spirit of Gaya"
endfunction

function Trig_Quest_ZodiacAge_GateBlocked_Cond_QuestDiscovered takes nothing returns boolean
    return(IsQuestDiscovered(udg_MainQuest[18]))
endfunction

function Trig_Quest_ZodiacAge_GateBlocked_Cond_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_ZodiacAge_GateBlocked_Cond_HashmalumNotMet takes nothing returns boolean
    return(udg_HashmalumEncountered==false)
endfunction

function Trig_Quest_ZodiacAge_GateBlocked_Cond_StageInvestigateGate takes nothing returns boolean
    return(udg_ZodiacQuestStage==1)
endfunction

function Trig_Quest_ZodiacAge_GateBlocked_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    set udg_HardMode=true
    if(Trig_Quest_ZodiacAge_GateBlocked_Cond_CinematicsEnabled())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(null,"You, human, may not pass.",false)
        call Text_Say(null,"Only those who swear allegiance to our queen may enter our realm...",false)
        if(Trig_Quest_ZodiacAge_GateBlocked_Cond_QuestDiscovered())then
            call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"Hmm... this is troublesome. Maybe I should ask Celeborn about this.",false)
        endif
        call Cine_ExitAction()
    endif
    if(Trig_Quest_ZodiacAge_GateBlocked_Cond_StageInvestigateGate())then
        if(Trig_Quest_ZodiacAge_GateBlocked_Cond_HashmalumNotMet())then
            call Quest_SetLog(QUEST_ZODIAC_AGE,"Ask Celeborn about the gate.",false)
        endif
        call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_UPDATED,"Ask Celeborn about the gate.")
        call GroupAddUnitSimple(gg_unit_Emns_0156,udg_QuestUnits)
        set udg_SpecialEffect[43]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_Emns_0156,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
        call EnableTrigger(gg_trg_Quest_ZodiacAge_AskCeleborn)
        set udg_ZodiacQuestStage=2
    endif
    call EnableTrigger(gg_trg_Gate_Codeword_Demesne)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Quest_ZodiacAge_AskCeleborn_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_Emns_0156,true,true,true))
endfunction

function Trig_Quest_ZodiacAge_AskCeleborn_Enum_ApplyCamera takes nothing returns nothing
    call CameraSetupApplyForPlayer(true,gg_cam_006,GetEnumPlayer(),0)
endfunction

function Trig_Quest_ZodiacAge_AskCeleborn_Cond_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_ZodiacAge_AskCeleborn_Cond_HashmalumNotMet takes nothing returns boolean
    return(udg_HashmalumEncountered==false)
endfunction

function Trig_Quest_ZodiacAge_AskCeleborn_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[43])
    call GroupRemoveUnitSimple(gg_unit_Emns_0156,udg_QuestUnits)
    if(Trig_Quest_ZodiacAge_AskCeleborn_Cond_CinematicsEnabled())then
        call Cine_Enter()
        call ForForce(udg_PlayingPlayers,function Trig_Quest_ZodiacAge_AskCeleborn_Enum_ApplyCamera)
        call Text_Say(gg_unit_Emns_0156,"You've returned. How did your investigation go?",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"The gates are closed. We cannot pass through.",false)
        call Text_Say(gg_unit_Etyr_0155,"As expected. But if we do not find a way through, we won't be able to end this war.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"There may yet be a way through. When we approached the gate, a voice spoke to us in our heads. That only someone who swore allegiance to 'the queen' may pass.",false)
        call Text_Say(gg_unit_Emns_0156,"The queen? Who could that be?",false)
        call Text_Say(gg_unit_Etyr_0155,"The realm of ice was closed to us our entire lives long. If there is a queen that reigns inside it is beyond our knowledge.",false)
        call Text_Say(gg_unit_Emns_0156,"You are right. All my long life long I've never heard of a queen beyond the barrier.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Well if we know nothing about this queen we won't be able to enter. There must be someone who knows.",false)
        call Text_Say(gg_unit_Etyr_0155,"Maybe...",false)
        call Text_Say(gg_unit_Emns_0156,"Are you thinking of someone?",false)
        call Text_Say(gg_unit_Etyr_0155,"Yes. There is a wizard in Lothlorien who goes by the name Talon. He was a close confidant of Lady Dana at the time of the last war. He may know more about the area beyond the barrier than we do.",false)
        call Text_Say(gg_unit_Emns_0156,"Talon... he hasn't spoken to us in how many years?",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"It matters not. He may not even have the information we seek. We lose nothing by trying.",false)
        call Cine_ExitAction()
    endif
    if(Trig_Quest_ZodiacAge_AskCeleborn_Cond_HashmalumNotMet())then
        call Quest_SetLog(QUEST_ZODIAC_AGE,"Ask Talon if he knows about the queen. Talon is a Wizard in Lothlorien who seems to be closed off towards the rulers Celeborn and Galadriel.",false)
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_UPDATED,"Ask Talon if he knows about the queen.")
    call GroupAddUnitSimple(gg_unit_e015_0238,udg_QuestUnits)
    set udg_SpecialEffect[43]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_e015_0238,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call EnableTrigger(gg_trg_Quest_ZodiacAge_AskTalon)
    set udg_ZodiacQuestStage=3
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Quest_ZodiacAge_AskTalon_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_e015_0238,true,true,true))
endfunction

function Trig_Quest_ZodiacAge_AskTalon_Cond_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_ZodiacAge_AskTalon_Cond_HashmalumNotMet takes nothing returns boolean
    return(udg_HashmalumEncountered==false)
endfunction

function Trig_Quest_ZodiacAge_AskTalon_Cond_PendantNpcStage4 takes nothing returns boolean
    return(udg_DanaQuestStage==4)
endfunction

function Trig_Quest_ZodiacAge_AskTalon_Cond_PendantNpcStage1 takes nothing returns boolean
    return(udg_DanaQuestStage==1)
endfunction

function Trig_Quest_ZodiacAge_AskTalon_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[43])
    call GroupRemoveUnitSimple(gg_unit_e015_0238,udg_QuestUnits)
    if(Trig_Quest_ZodiacAge_AskTalon_Cond_CinematicsEnabled())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Are you Talon?",false)
        call Text_Say(gg_unit_e015_0238,"Yes that's me. What do you want?",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"We need to enter the realm of ice. Do you happen to know anything about it?",false)
        call Text_Say(gg_unit_e015_0238,"The realm of ice... did Celeborn and Galadriel send you?",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Yeah they told us you may know more than them.",false)
        call Text_Say(gg_unit_e015_0238,"Leave me be.",false)
        call Text_Transmission(gg_unit_e015_0238,"Talon","Leave me be. I have nothing to do with this.","Leave me be.",null,0,false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"If you know something tell us! There may be Zodiac Braves hiding beyond that barrier!",false)
        call Text_Say(gg_unit_e015_0238,"It doesn't matter. Galadriel is not my queen.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"So you are pledged to the queen beyond the barrier?",false)
        call Text_Say(gg_unit_e015_0238,"No. I once was... but my queen is now another.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"If you're not on their side then help us! Lothlorien is not going to stand when the demons attack!",false)
        call Text_Say(gg_unit_e015_0238,"...",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"This is pointless... we need to get him to talk somehow.",false)
        call Cine_ExitAction()
    endif
    set udg_SpecialEffect[43]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_e015_0238,"Objects\\RandomObject\\RandomObject.mdl")
    if(Trig_Quest_ZodiacAge_AskTalon_Cond_HashmalumNotMet())then
        call Quest_SetLog(QUEST_ZODIAC_AGE,"Find something to make Talon talk.",false)
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_UPDATED,"Find something to make Talon talk.")
    call EnableTrigger(gg_trg_Quest_ZodiacAge_ShowPendant)
    set udg_ZodiacQuestStage=4
    if(Trig_Quest_ZodiacAge_AskTalon_Cond_PendantNpcStage1())then
        set udg_DanaQuestStage=2
        set udg_SpecialEffect[70]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_n0BN_0171,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
        call GroupAddUnitSimple(gg_unit_n0BN_0171,udg_QuestUnits)
        call EnableTrigger(gg_trg_Quest_ZodiacAge_GetPendant)
    else
        if(Trig_Quest_ZodiacAge_AskTalon_Cond_PendantNpcStage4())then
            set udg_DanaQuestStage=6
            call GroupAddUnitSimple(gg_unit_n0BN_0171,udg_QuestUnits)
            call DisableTrigger(gg_trg_Quest_Illusions_Start)
            call EnableTrigger(gg_trg_Quest_ZodiacAge_GetPendant)
        endif
    endif
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Quest_ZodiacAge_GetPendant_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_n0BN_0171,true,true,true))
endfunction

function Trig_Quest_ZodiacAge_GetPendant_Cond_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_ZodiacAge_GetPendant_Cond_PendantNpcStage6 takes nothing returns boolean
    return(udg_DanaQuestStage==6)
endfunction

function Trig_Quest_ZodiacAge_GetPendant_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[70])
    call GroupRemoveUnitSimple(gg_unit_n0BN_0171,udg_QuestUnits)
    if(Trig_Quest_ZodiacAge_GetPendant_Cond_CinematicsEnabled())then
        call PauseUnitBJ(true,gg_unit_n0BN_0171)
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(gg_unit_n0BN_0171,"Hmm, you seem troubled. Do you need my aid?",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"We were just wondering if you knew anything about the queen in the realm of ice.",false)
        call Text_Say(gg_unit_n0BN_0171,"The queen in the realm of ice...? Hmm... I'd suggest you speak to a wizard named Talon for help. He should still be in Lothlorien.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Yeah we talked to him, but we won't open up to us. Says Galadriel is not his queen.",false)
        call Text_Say(gg_unit_n0BN_0171,"Is that so...",false)
        call Text_Say(gg_unit_n0BN_0171,"... I may be able to help you.",false)
        call Text_Say(gg_unit_n0BN_0171,"Show him this pendant. It may make him listen to you...",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"A pendant? Not sure what this means, but we may as well try. Thank you.",false)
        call Text_Say(gg_unit_n0BN_0171,"... it's still his choice to help you or not in the end. Don't push him too hard, please...",false)
        call Cine_ExitAction()
        call PauseUnitBJ(false,gg_unit_n0BN_0171)
    endif
    set udg_QuestItem[$E]=UnitAddItemByIdSwapped('I0I9',Player_GetHero(GetTriggerPlayer())) // $E = 14; 'I0I9': item "Shimmering Pendant"
    call SetItemInvulnerableBJ(GetLastCreatedItem(),true)
    call GroupAddUnitSimple(gg_unit_e015_0238,udg_QuestUnits)
    set udg_ZodiacQuestStage=5
    if(Trig_Quest_ZodiacAge_GetPendant_Cond_PendantNpcStage6())then
        call Wait_Polled(2)
        set udg_SpecialEffect[70]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_n0BN_0171,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
        call EnableTrigger(gg_trg_Quest_Illusions_Start)
    else
        set udg_DanaQuestStage=3
    endif
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Quest_ZodiacAge_ShowPendant_Conditions takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(UnitHasItemOfTypeBJ(GetTriggerUnit(),'I0I9')) // 'I0I9': item "Shimmering Pendant"
endfunction

function Trig_Quest_ZodiacAge_ShowPendant_Cond_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_ZodiacAge_ShowPendant_Cond_HashmalumNotMet takes nothing returns boolean
    return(udg_HashmalumEncountered==false)
endfunction

function Trig_Quest_ZodiacAge_ShowPendant_Actions takes nothing returns nothing
    local location l_tempPoint
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[43])
    if(Trig_Quest_ZodiacAge_ShowPendant_Cond_CinematicsEnabled())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(gg_unit_e015_0238,"That pendant...",false)
        call Text_Say(gg_unit_e015_0238,"I see... so you have her blessing.",false)
        call Text_Say(gg_unit_e015_0238,"In that case I apologize for my earlier rudeness.",false)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"Will you help us get past the barrier now?",false)
        call Text_Say(gg_unit_e015_0238,"Yes, I will.",false)
        call Text_Say(gg_unit_e015_0238,"Allow me just to... prepare for a bit. Meet me at the far north gate.",false)
        call Cine_ExitAction()
    endif
    if(Trig_Quest_ZodiacAge_ShowPendant_Cond_HashmalumNotMet())then
        call Quest_SetLog(QUEST_ZODIAC_AGE,"Speak with Talon at the northern gate to the Icy Realm.",false)
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_UPDATED,"Speak with Talon at the northern gate to the Icy Realm.")
    set l_tempPoint=GetRectCenter(gg_rct_636)
    call SetUnitPositionLocFacingBJ(gg_unit_e015_0238,l_tempPoint,.0)
    call RemoveLocation(l_tempPoint)
    set udg_ZodiacQuestStage=6
    call Wait_Polled(1.)
    set udg_SpecialEffect[43]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_e015_0238,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call EnableTrigger(gg_trg_Quest_ZodiacAge_TalonOpensGate)
    call DestroyTrigger(GetTriggeringTrigger())
    set l_tempPoint=null
endfunction

function Trig_Quest_ZodiacAge_TalonOpensGate_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_e015_0238,true,true,true))
endfunction

function Trig_Quest_ZodiacAge_TalonOpensGate_Enum_ShakeCamera takes nothing returns nothing
    call CameraSetEQNoiseForPlayer(GetEnumPlayer(),15.)
endfunction

function Trig_Quest_ZodiacAge_TalonOpensGate_Enum_ClearCameraNoise takes nothing returns nothing
    call CameraClearNoiseForPlayer(GetEnumPlayer())
endfunction

function Trig_Quest_ZodiacAge_TalonOpensGate_Cond_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_ZodiacAge_TalonOpensGate_Cond_HashmalumNotMet takes nothing returns boolean
    return(udg_HashmalumEncountered==false)
endfunction

function Trig_Quest_ZodiacAge_TalonOpensGate_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DisableTrigger(gg_trg_Gate_Codeword_Demesne)
    call DestroyEffectBJ(udg_SpecialEffect[43])
    call GroupRemoveUnitSimple(gg_unit_e015_0238,udg_QuestUnits)
    if(Trig_Quest_ZodiacAge_TalonOpensGate_Cond_CinematicsEnabled())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(gg_unit_e015_0238,"You've come.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"We have. Are you prepared yet?",false)
        call Text_Say(gg_unit_e015_0238,"Yes, I'm prepared.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Why couldn't you just tell us the way to open this gate in Lothlorien?",false)
        call Text_Say(gg_unit_e015_0238,"I've been loyal to the Winter Queen for a long time. Eventually I cast her aside to serve Lady Dana.",false)
        call Text_Say(gg_unit_e015_0238,"However, you can never escape the curse of the queen's name... speaking it will turn me back to who I used to be. I won't be able to return to Lothlorien anymore.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"... I didn't know.",false)
        call Text_Say(gg_unit_e015_0238,"It matters not. My new queen sacrificed her life for her people. How could I call myself her servant if I'm not willing to do this much?",false)
        call Text_Say(gg_unit_e015_0238,"...",false)
        call Text_Transmission(gg_unit_e015_0238,"Talon","... hear my call!","...",null,0,false)
        call Text_Transmission(gg_unit_e015_0238,"Talon","... hear my call! Lady Demesne!","... hear my call!",null,0,false)
        call ForForce(GetPlayersAll(),function Trig_Quest_ZodiacAge_TalonOpensGate_Enum_ShakeCamera)
        call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUTIN,2.,"ReplaceableTextures\\CameraMasks\\DreamFilter_Mask.blp",.0,.0,100.,0)
        set udg_TempPoint=GetDestructableLoc(gg_dest_DTg7_0013)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\ThunderClap\\ThunderClapCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        call Wait_Polled(1.)
        set udg_TempPoint=GetDestructableLoc(gg_dest_DTg7_0013)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Items\\AIda\\AIdaCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        call Wait_Polled(1.)
        call ForForce(GetPlayersAll(),function Trig_Quest_ZodiacAge_TalonOpensGate_Enum_ClearCameraNoise)
        call Wait_Polled(1.)
        call ModifyGateBJ(bj_GATEOPERATION_OPEN,gg_dest_DTg7_0013)
        call Wait_Polled(1.)
        call AddSpecialEffectTargetUnitBJ("origin",gg_unit_e015_0238,"Abilities\\Spells\\Undead\\AnimateDead\\AnimateDeadTarget.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call Wait_Polled(.5)
        set udg_TalonUnit=ReplaceUnitBJ(gg_unit_e015_0238,'n0CH',bj_UNIT_STATE_METHOD_RELATIVE) // 'n0CH': unit "Talon"
        call PauseUnitBJ(true,udg_TalonUnit)
        call Wait_Polled(.5)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"So this is your true form...",false)
        call Text_Say(udg_TalonUnit,"It's hideous, I know.",false)
        call Text_Say(udg_TalonUnit,"I was happy to have cast away this form when I dedicated myself to my new queen. But it is nothing more than a mask, in the end.",false)
        call Text_Say(udg_TalonUnit,"Let us go on. I won't let this have been in vain.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Right you are.",false)
        call Cine_ExitAction()
        call PauseUnitBJ(false,udg_TalonUnit)
    else
        set udg_TempPoint=GetDestructableLoc(gg_dest_DTg7_0013)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\ThunderClap\\ThunderClapCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Items\\AIda\\AIdaCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        call ModifyGateBJ(bj_GATEOPERATION_OPEN,gg_dest_DTg7_0013)
        set udg_TalonUnit=ReplaceUnitBJ(gg_unit_e015_0238,'n0CH',bj_UNIT_STATE_METHOD_RELATIVE) // 'n0CH': unit "Talon"
        call AddSpecialEffectTargetUnitBJ("origin",udg_TalonUnit,"Abilities\\Spells\\Undead\\AnimateDead\\AnimateDeadTarget.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
    endif
    if(Trig_Quest_ZodiacAge_TalonOpensGate_Cond_HashmalumNotMet())then
        call QuestZodiacAge_GateOpened()
        set udg_HashmalumStage=3
    endif
    call DisplayTimedTextToForce(GetPlayersAll(),15.,"Talon joins your party.")
    call SetUnitOwner(udg_TalonUnit,Player($A),true) // $A = 10
    call ConditionalTriggerExecute(gg_trg_IcyRealm_GateOpened_Setup)
    call EnableTrigger(gg_trg_Talon_Leash_Gate)
    call EnableTrigger(gg_trg_Talon_Death)
    call RemoveGuardPosition(udg_TalonUnit)
    set udg_TalonGone=false
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function InitTrig_Quest_ZodiacAge takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Quest_Part8 (module Quest),
// which keeps the original registration order.

function Register_Quest_ZodiacAge_Start takes nothing returns nothing
    set gg_trg_Quest_ZodiacAge_Start=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_ZodiacAge_Start)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_ZodiacAge_Start,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_ZodiacAge_Start,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_ZodiacAge_Start,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_ZodiacAge_Start,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_ZodiacAge_Start,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_ZodiacAge_Start,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_ZodiacAge_Start,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_ZodiacAge_Start,Player(7),true)
    call TriggerAddCondition(gg_trg_Quest_ZodiacAge_Start,Condition(function Trig_Quest_ZodiacAge_Start_Conditions))
    call TriggerAddAction(gg_trg_Quest_ZodiacAge_Start,function Trig_Quest_ZodiacAge_Start_Actions)
endfunction

function Register_Quest_ZodiacAge_GateBlocked takes nothing returns nothing
    set gg_trg_Quest_ZodiacAge_GateBlocked=CreateTrigger()
    call TriggerRegisterEnterRectSimple(gg_trg_Quest_ZodiacAge_GateBlocked,gg_rct_630)
    call TriggerAddCondition(gg_trg_Quest_ZodiacAge_GateBlocked,Condition(function Trig_Quest_ZodiacAge_GateBlocked_Conditions))
    call TriggerAddAction(gg_trg_Quest_ZodiacAge_GateBlocked,function Trig_Quest_ZodiacAge_GateBlocked_Actions)
endfunction

function Register_Quest_ZodiacAge_AskCeleborn takes nothing returns nothing
    set gg_trg_Quest_ZodiacAge_AskCeleborn=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_ZodiacAge_AskCeleborn)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_ZodiacAge_AskCeleborn,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_ZodiacAge_AskCeleborn,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_ZodiacAge_AskCeleborn,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_ZodiacAge_AskCeleborn,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_ZodiacAge_AskCeleborn,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_ZodiacAge_AskCeleborn,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_ZodiacAge_AskCeleborn,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_ZodiacAge_AskCeleborn,Player(7),true)
    call TriggerAddCondition(gg_trg_Quest_ZodiacAge_AskCeleborn,Condition(function Trig_Quest_ZodiacAge_AskCeleborn_Conditions))
    call TriggerAddAction(gg_trg_Quest_ZodiacAge_AskCeleborn,function Trig_Quest_ZodiacAge_AskCeleborn_Actions)
endfunction

function Register_Quest_ZodiacAge_AskTalon takes nothing returns nothing
    set gg_trg_Quest_ZodiacAge_AskTalon=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_ZodiacAge_AskTalon)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_ZodiacAge_AskTalon,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_ZodiacAge_AskTalon,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_ZodiacAge_AskTalon,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_ZodiacAge_AskTalon,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_ZodiacAge_AskTalon,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_ZodiacAge_AskTalon,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_ZodiacAge_AskTalon,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_ZodiacAge_AskTalon,Player(7),true)
    call TriggerAddCondition(gg_trg_Quest_ZodiacAge_AskTalon,Condition(function Trig_Quest_ZodiacAge_AskTalon_Conditions))
    call TriggerAddAction(gg_trg_Quest_ZodiacAge_AskTalon,function Trig_Quest_ZodiacAge_AskTalon_Actions)
endfunction

function Register_Quest_ZodiacAge_GetPendant takes nothing returns nothing
    set gg_trg_Quest_ZodiacAge_GetPendant=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_ZodiacAge_GetPendant)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_ZodiacAge_GetPendant,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_ZodiacAge_GetPendant,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_ZodiacAge_GetPendant,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_ZodiacAge_GetPendant,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_ZodiacAge_GetPendant,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_ZodiacAge_GetPendant,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_ZodiacAge_GetPendant,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_ZodiacAge_GetPendant,Player(7),true)
    call TriggerAddCondition(gg_trg_Quest_ZodiacAge_GetPendant,Condition(function Trig_Quest_ZodiacAge_GetPendant_Conditions))
    call TriggerAddAction(gg_trg_Quest_ZodiacAge_GetPendant,function Trig_Quest_ZodiacAge_GetPendant_Actions)
endfunction

function Register_Quest_ZodiacAge_ShowPendant takes nothing returns nothing
    set gg_trg_Quest_ZodiacAge_ShowPendant=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_ZodiacAge_ShowPendant)
    call TriggerRegisterUnitInRangeSimple(gg_trg_Quest_ZodiacAge_ShowPendant,450.,gg_unit_e015_0238)
    call TriggerAddCondition(gg_trg_Quest_ZodiacAge_ShowPendant,Condition(function Trig_Quest_ZodiacAge_ShowPendant_Conditions))
    call TriggerAddAction(gg_trg_Quest_ZodiacAge_ShowPendant,function Trig_Quest_ZodiacAge_ShowPendant_Actions)
endfunction

function Register_Quest_ZodiacAge_TalonOpensGate takes nothing returns nothing
    set gg_trg_Quest_ZodiacAge_TalonOpensGate=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_ZodiacAge_TalonOpensGate)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_ZodiacAge_TalonOpensGate,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_ZodiacAge_TalonOpensGate,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_ZodiacAge_TalonOpensGate,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_ZodiacAge_TalonOpensGate,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_ZodiacAge_TalonOpensGate,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_ZodiacAge_TalonOpensGate,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_ZodiacAge_TalonOpensGate,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_ZodiacAge_TalonOpensGate,Player(7),true)
    call TriggerAddCondition(gg_trg_Quest_ZodiacAge_TalonOpensGate,Condition(function Trig_Quest_ZodiacAge_TalonOpensGate_Conditions))
    call TriggerAddAction(gg_trg_Quest_ZodiacAge_TalonOpensGate,function Trig_Quest_ZodiacAge_TalonOpensGate_Actions)
endfunction

endlibrary
