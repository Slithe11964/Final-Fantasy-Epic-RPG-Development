library TNimphrodel requires TCam, TCine, TPlayerPart01, TReward, TText, TUnit
function Trig_Nimphrodel_Start_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_Ecen_0180,true,true,true))
endfunction

function Trig_Nimphrodel_Start_Cond_MetKenarius takes nothing returns boolean
    return(udg_PortalGuardianMet)
endfunction

function Trig_Nimphrodel_Start_Cond_ShowKenariusTalk takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Nimphrodel_Start_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[37])
    if(Trig_Nimphrodel_Start_Cond_ShowKenariusTalk())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        if(Trig_Nimphrodel_Start_Cond_MetKenarius())then
            call Text_Say(gg_unit_Ecen_0180,"So we meet again, human. I was pleased to receive word of your safe arrival at our settlement.",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"Good to see you again, Kenarius. Do you need something from us?",false)
            call Text_Say(gg_unit_Ecen_0180,"Indeed I do.",false)
        else
            call Text_Say(gg_unit_Ecen_0180,"Greetings, human. I am Kenarius. I have received word of a human arriving at our settlement. I assume they were talking about you?",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"And what if it was?",false)
            call Text_Say(gg_unit_Ecen_0180,"Reaching our settlement by your own hand is no simple feat. It seems you are quite strong. Perhaps I can ask you for help.",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"Maybe so. What kind of help do you need?",false)
        endif
        call Text_Say(gg_unit_Ecen_0180,"My daughter Nimphrodel was kidnapped by centaurs. My duty is to guard this way gate so the continent of humans may be safe from the corruption in this forest. I can't leave my post.",false)
        call Text_Say(gg_unit_Ecen_0180,"Galadriel's scouts searched for the kidnappers but were unable to find my daughter. And with Satyrs and Naga ceaselessly threatening Lothlorien Celeborn is unable to send a massive search party.",false)
        call Text_Say(gg_unit_Ecen_0180,"Could you please look for my daughter? She is probably being kept somewhere where centaurs reside. If you find her then please save her or at least let me know where she is kept. I will reward you greatly if you do.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Alright, we will look for your daughter.",false)
        call Cine_ExitAction()
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_DISCOVERED,"New Quest Received: |cffffcc00Save Nimphrodel|r")
    set udg_SideQuest[21]=CreateQuestBJ(bj_QUESTTYPE_REQ_DISCOVERED,(udg_QuestNamePrefix+"Save Nimphrodel"),"Kenarius, Glade Warden residing at the eastern part of the Ancient Forest, needs your help in finding his daughter Nimphrodel who was kidnapped by centaurs.","ReplaceableTextures\\CommandButtons\\BTNDryad.blp")
    set udg_SpecialEffect[37]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_Ecen_0180,"Objects\\RandomObject\\RandomObject.mdl")
    set udg_SpecialEffect[38]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_E003_0182,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call EnableTrigger(gg_trg_Nimphrodel_Meet)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Nimphrodel_Meet_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_E003_0182,true,true,true))
endfunction

function Trig_Nimphrodel_Meet_Cond_ShowNimphrodelTalk takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Nimphrodel_Meet_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[38])
    if(Trig_Nimphrodel_Meet_Cond_ShowNimphrodelTalk())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Are you Nimphrodel?",false)
        call Text_Say(gg_unit_E003_0182,"Yes, how can I help you?",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),". . .",false)
        call Text_Transmission(Player_GetHero(GetTriggerPlayer()),udg_PlayerName[GetConvertedPlayerId(GetTriggerPlayer())],". . .\r\n. . . . . .",". . .",null,0,false)
        call Text_Transmission(Player_GetHero(GetTriggerPlayer()),udg_PlayerName[GetConvertedPlayerId(GetTriggerPlayer())],". . .\r\n. . . . . .\r\n. . . . . . . . .",". . .\r\n. . . . . .",null,0,false)
        call Text_Transmission(Player_GetHero(GetTriggerPlayer()),udg_PlayerName[GetConvertedPlayerId(GetTriggerPlayer())],". . .\r\n. . . . . .\r\n. . . . . . . . .\r\n(What's going on?)",". . .\r\n. . . . . .\r\n. . . . . . . . .",null,0,false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"(She doesn't exactly seem like to be here against her will...)",false)
        call Text_Say(gg_unit_E003_0182,"Erm... why are you staring at me like that...?",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Actually, your father Kenarius sent us to save you from the centaurs who kidnapped you.",false)
        call Text_Say(gg_unit_E003_0182,"Kidnapped? Me? Is that what he told you?",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Yes, that's right.",false)
        call Text_Say(gg_unit_E003_0182,"Well, either he lied to you or ...",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Or what?",false)
        call Text_Say(gg_unit_E003_0182,". . . Yes, now I see. Listen, this is what really happened.",false)
        call Text_Say(gg_unit_E003_0182,"Several months ago I met Batu. We fell in love with each other and met in secret for some time. And eventually we decided to live together.",false)
        call Text_Say(gg_unit_E003_0182,"But I knew that my orthodox father would never allow us to be together because Batu is a centaur. That's why I left in secret.",false)
        call Text_Say(gg_unit_E003_0182,"I asked my sister Undomiel to tell our father that I left by my own will to live together with my beloved Batu.",false)
        call Text_Say(gg_unit_E003_0182,"So I don't know why father decided that I was kidnapped. But Undomiel must know why. I can't go back to Lothlorien so can you please meet Undomiel and find out what has happened?",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Your father promised a great reward if I save you. Circumstances have changed but I still want to deal with this task. I will visit Undomiel.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"By the way Batu can you tell your fellow centaurs to stop messing up with us? I am kinda tired of kicking their asses.",false)
        call Text_Say(gg_unit_H00S_0181,"Our elders are opposed to centaur-dryad relations even more than Nimphrodel's kin. I am a social outcast just like her.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"That's too bad. Well then, take care.",false)
        call Cine_ExitAction()
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_UPDATED,"Meet Nimphrodel's sister Undomiel in Lothlorien.")
    call QuestSetDescriptionBJ(udg_SideQuest[21],"Meet Nimphrodel's sister Undomiel in Lothlorien.")
    call GroupAddUnitSimple(gg_unit_E004_0190,udg_BossUnits)
    set udg_SpecialEffect[38]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_E003_0182,"Objects\\RandomObject\\RandomObject.mdl")
    set udg_SpecialEffect[39]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_E004_0190,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call EnableTrigger(gg_trg_Nimphrodel_Undomiel)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Nimphrodel_Undomiel_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_E004_0190,true,true,true))
endfunction

function Trig_Nimphrodel_Undomiel_Cond_ShowUndomielTalk takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Nimphrodel_Undomiel_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_BossUnits)
    call DestroyEffectBJ(udg_SpecialEffect[39])
    if(Trig_Nimphrodel_Undomiel_Cond_ShowUndomielTalk())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Hello. You are Undomiel, is that right?",false)
        call Text_Say(gg_unit_E004_0190,"Yes, what business do you have with me?",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"I want to know why your father thinks that Nimphrodel was kidnapped even though she left by her own will and asked you to tell Kenarius about that!?",false)
        call Text_Say(gg_unit_E004_0190,"So, she told you her story? And did she tell you that it was *I* who met Batu first. He was my boyfriend but then Nimphrodel found out that I was secretly meeting him.",false)
        call Text_Say(gg_unit_E004_0190,"She asked me to introduce her to Batu. And so I did. But when I met Batu for the next time he told me that his heart now belongs to Nimphrodel !!! My own sister betrayed me!",false)
        call Text_Say(gg_unit_E004_0190,"And after that she had the inslolence to ask me to help them live together. Of course I wanted to avenge myself and told our father that she was kidnapped hoping he would kill Batu.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"You are a very bad girl.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Now go and tell your father the truth.",false)
        call Text_Say(gg_unit_E004_0190,"Why should I? Of course, I am not so angry anymore. But I have to position myself as a liar to my own father.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"You *are* a liar. Go now or I'll tell him everything myself.",false)
        call Text_Say(gg_unit_E004_0190,"And who do you think he will believe - his beloved daughter or some two-legged stranger?",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"And what do you propose?",false)
        call Text_Say(gg_unit_E004_0190,"There's something I need - the Crystal Ball. It's a tool used for enhancing its user's foresight abilites. Bring it to me and I will confess in my sins.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Why do you need it?",false)
        call Text_Say(gg_unit_E004_0190,"It doesn't matter. Do you agree?",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Where can I find Crystal Ball?",false)
        call Text_Say(gg_unit_E004_0190,"I saw some Satyr performing some ritual using Crystal Ball. I guess if you find him . . .",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),". . . and kill him then I will obtain Crystal Ball. I see.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"These Satyrs are not friendly. And they are not weak. I want 5000 gold for Crystal Ball on top of you confessing.",false)
        call Text_Say(gg_unit_E004_0190,"How about 4000?",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"5000 - no less.",false)
        call Text_Say(gg_unit_E004_0190,"Deal.",false)
        call Cine_ExitAction()
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_UPDATED,"Defeat Satyr carrying Crystal Ball and bring it to Undomiel.")
    call QuestSetDescriptionBJ(udg_SideQuest[21],"Defeat Satyr carrying Crystal Ball and bring it to Undomiel.")
    set udg_SpecialEffect[39]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_E004_0190,"Objects\\RandomObject\\RandomObject.mdl")
    set udg_TempPoint=GetRectCenter(gg_rct_010)
    call CreateNUnitsAtLoc(1,'n019',Player($B),udg_TempPoint,bj_UNIT_FACING) // 'n019': unit "Satyr Farseer"; $B = 11
    call RemoveLocation(udg_TempPoint)
    call Unit_ScaleToLevel60(bj_lastCreatedUnit)
    call GroupAddUnitSimple(GetLastCreatedUnit(),udg_BossUnits)
    call TriggerRegisterUnitEvent(gg_trg_CrystalBall_Drop,GetLastCreatedUnit(),EVENT_UNIT_DEATH)
    call EnableTrigger(gg_trg_CrystalBall_Drop)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Nimphrodel_Complete_Conditions takes nothing returns boolean
    return((UnitHasItemOfTypeBJ(GetTriggerUnit(),'I02B'))and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(udg_InCinematicMode==false))!=null // 'I02B': item "Crystal Ball"
endfunction

function Trig_Nimphrodel_Complete_Cond_ShowUndomielReward takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Nimphrodel_Complete_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DisableTrigger(gg_trg_CrystalBall_Ping)
    call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I02B')) // 'I02B': item "Crystal Ball"
    call DestroyEffectBJ(udg_SpecialEffect[39])
    if(Trig_Nimphrodel_Complete_Cond_ShowUndomielReward())then
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_E004_0190,0)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"Here's the Crystal Ball.",false)
        call Text_Say(gg_unit_E004_0190,"Cool ! You probably want your money first . . .",false)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"Yes, I do.",false)
        call Reward_Give(5000,$FA0,gg_unit_E004_0190) // $FA0 = 4000
        call Text_Say(gg_unit_E004_0190,"|n|cffffcc00A new artifact is available for buying at the Ancient of Wonders.|r",true)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"Here, take the Ball. And now it's time to tell your father the truth.",false)
        call Text_Say(gg_unit_E004_0190,"I already did that. He was about to to abandon his duty and go to Barrens to save Nimphrodel or die trying. So I had to tell him everything before he did something stupid.",false)
        call Text_Say(gg_unit_E004_0190,"He was shocked to find out that one of his daughters lied to him and another is the wife of a centaur now.",false)
        call Text_Say(gg_unit_E004_0190,"He told me that he is greatly disappointed and needs some time to think about everything.",false)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"Does that mean that we won't be getting the reward he promised us?",false)
        call Text_Say(gg_unit_E004_0190,"I guess it does.",false)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"That's too bad but it seems there's nothing we can do about it. Good bye.",false)
        call Cine_ExitAction()
    else
        call Reward_Give(5000,$FA0,gg_unit_E004_0190) // $FA0 = 4000
        call DisplayTimedTextToForce(udg_PlayingPlayers,10.,"|cffffcc00A new artifact is available for buying at the Ancient of Wonders.|r")
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_COMPLETED,"Quest Completed: |cffffcc00Save Nimphrodel|r")
    call QuestSetCompletedBJ(udg_SideQuest[21],true)
    set udg_QuestsCompleted=(udg_QuestsCompleted+1)
    call AddUnitToStockBJ('n0C2',gg_unit_e012_0227,1,1) // 'n0C2': unit "Hunt: Pixie"
    set udg_HuntStock[7]=(udg_HuntStock[7]+1)
    call ConditionalTriggerExecute(gg_trg_Hunt_Board_Markers)
    set udg_QuestMarkerEffect[$A]=AddSpecialEffectTargetUnitBJ("head",gg_unit_Ecen_0180,"Abilities\\Spells\\Other\\Silence\\SilenceTarget.mdl") // $A = 10
    set udg_QuestMarkerEffect[$B]=AddSpecialEffectTargetUnitBJ("head",gg_unit_E003_0182,"Abilities\\Spells\\Other\\Silence\\SilenceTarget.mdl") // $B = 11
    call EnableTrigger(gg_trg_Npc_Talk_Kenarius)
    call EnableTrigger(gg_trg_Npc_Talk_Nimphrodel)
    call DestroyEffectBJ(udg_SpecialEffect[37])
    call DestroyEffectBJ(udg_SpecialEffect[38])
    call DestroyEffectBJ(udg_SpecialEffect[39])
    call AddItemToStockBJ('I063',gg_unit_n00L_0153,1,1) // 'I063': item "Charming Banner"
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Nimphrodel takes nothing returns nothing
endfunction
function RegisterR11_Nimphrodel_Start takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Nimphrodel_Start=CreateTrigger()
    call DisableTrigger(gg_trg_Nimphrodel_Start)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Nimphrodel_Start,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Nimphrodel_Start,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Nimphrodel_Start,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Nimphrodel_Start,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Nimphrodel_Start,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Nimphrodel_Start,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Nimphrodel_Start,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Nimphrodel_Start,Player(7),true)
    call TriggerAddCondition(gg_trg_Nimphrodel_Start,Condition(function Trig_Nimphrodel_Start_Conditions))
    call TriggerAddAction(gg_trg_Nimphrodel_Start,function Trig_Nimphrodel_Start_Actions)
endfunction
function RegisterR11_Nimphrodel_Meet takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Nimphrodel_Meet=CreateTrigger()
    call DisableTrigger(gg_trg_Nimphrodel_Meet)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Nimphrodel_Meet,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Nimphrodel_Meet,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Nimphrodel_Meet,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Nimphrodel_Meet,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Nimphrodel_Meet,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Nimphrodel_Meet,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Nimphrodel_Meet,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Nimphrodel_Meet,Player(7),true)
    call TriggerAddCondition(gg_trg_Nimphrodel_Meet,Condition(function Trig_Nimphrodel_Meet_Conditions))
    call TriggerAddAction(gg_trg_Nimphrodel_Meet,function Trig_Nimphrodel_Meet_Actions)
endfunction
function RegisterR11_Nimphrodel_Undomiel takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Nimphrodel_Undomiel=CreateTrigger()
    call DisableTrigger(gg_trg_Nimphrodel_Undomiel)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Nimphrodel_Undomiel,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Nimphrodel_Undomiel,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Nimphrodel_Undomiel,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Nimphrodel_Undomiel,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Nimphrodel_Undomiel,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Nimphrodel_Undomiel,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Nimphrodel_Undomiel,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Nimphrodel_Undomiel,Player(7),true)
    call TriggerAddCondition(gg_trg_Nimphrodel_Undomiel,Condition(function Trig_Nimphrodel_Undomiel_Conditions))
    call TriggerAddAction(gg_trg_Nimphrodel_Undomiel,function Trig_Nimphrodel_Undomiel_Actions)
endfunction
function RegisterR11_Nimphrodel_Complete takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Nimphrodel_Complete=CreateTrigger()
    call DisableTrigger(gg_trg_Nimphrodel_Complete)
    call TriggerRegisterUnitInRangeSimple(gg_trg_Nimphrodel_Complete,450.,gg_unit_E004_0190)
    call TriggerAddCondition(gg_trg_Nimphrodel_Complete,Condition(function Trig_Nimphrodel_Complete_Conditions))
    call TriggerAddAction(gg_trg_Nimphrodel_Complete,function Trig_Nimphrodel_Complete_Actions)
endfunction




endlibrary
