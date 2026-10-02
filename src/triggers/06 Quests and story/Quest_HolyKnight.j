library TQuestHolyKnight requires TCam, TCine, TPlayerHero, TText, TUnit
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Quest_HolyKnight_Start=null
    trigger gg_trg_Quest_HolyKnight_AskRamza=null
endglobals

function Trig_Quest_HolyKnight_Start_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_Ewrd_0120,true,true,true))
endfunction

function Trig_Quest_HolyKnight_Start_Cond_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_HolyKnight_Start_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[50])
    if(Trig_Quest_HolyKnight_Start_Cond_CinematicsEnabled())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(gg_unit_Ewrd_0120,("En Taro Adun, "+(udg_PlayerName[GetConvertedPlayerId(GetTriggerPlayer())]+".")),false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"En Taro Tassadar, milady. I do not believe we've met.",false)
        call Text_Say(gg_unit_Ewrd_0120,"I have only just managed to return to this plane. My name is Agrias and I am the Holy Knight of Virgo. I do not recognize you, so you must have come to this plane yourself only recently. For what purpose are you here?",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"This world appears to be tainted by demons. There is the possibility of an infernal breaktrough, and I'm seeking to stop it. What of you?",false)
        call Text_Say(gg_unit_Ewrd_0120,"I am here to kill Ramza.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"W-what do you mean? Why Ramza?",false)
        call Text_Say(gg_unit_Ewrd_0120,"He betrayed me. He used my trust in him to lure me to the edge of the world and then banished me from this plane. It's a miracle I survived. I surely would have been lost if it hadn't been for Virgo's blessing.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"I can't believe Ramza would do something like that. I must find him and hear what he has to say.",false)
        call Text_Say(gg_unit_Ewrd_0120,"Do as you wish, just don't stand in my way.",false)
        call Cine_ExitAction()
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_DISCOVERED,"New Quest Received: |cffffcc00Holy Knight|r")
    set udg_SideQuest[31]=CreateQuestBJ(bj_QUESTTYPE_REQ_DISCOVERED,(udg_QuestNamePrefix+"Holy Knight"),"Holy Knight Agrias claims Ramza betrayed her. Find him to find out his side of story.","ReplaceableTextures\\CommandButtons\\BTNHeroWarden.blp")
    call GroupAddUnitSimple(gg_unit_Eill_0119,udg_BossUnits)
    call EnableTrigger(gg_trg_Quest_HolyKnight_AskRamza)
    set udg_SpecialEffect[50]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_Eill_0119,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Quest_HolyKnight_AskRamza_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_Eill_0119,true,true,true))
endfunction

function Trig_Quest_HolyKnight_AskRamza_Cond_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_HolyKnight_AskRamza_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call GroupRemoveUnitSimple(gg_unit_Eill_0119,udg_BossUnits)
    call DestroyEffectBJ(udg_SpecialEffect[50])
    if(Trig_Quest_HolyKnight_AskRamza_Cond_CinematicsEnabled())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(gg_unit_Eill_0119,("En Taro Adun, "+(udg_PlayerName[GetConvertedPlayerId(GetTriggerPlayer())]+".")),false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"En Taro Tassadar, brother.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Ramza, we need to talk about Agrias. She is here, in this world, and seeks to destroys you. According to Agrias' words, you betrayed her and banished her.",false)
        call Text_Say(gg_unit_Eill_0119,"It's a sad story, my friend.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Tell me what happened.",false)
        call Text_Say(gg_unit_Eill_0119,"It was Agrias who betrayed us all!",false)
        call Text_Say(gg_unit_Eill_0119,"A long time ago she lived here as the head of the Holy Knights of Virgo, the goddess of justice we believed in. She was a peerless knight, and my sister Alma and I got along well with her and her order.",false)
        call Text_Say(gg_unit_Eill_0119,"However, at the beginning of the last demon war, it became apparent that the goddess of Virgo they revered was in actuality nothing more than a demon itself!",false)
        call Text_Say(gg_unit_Eill_0119,"I was the one who told Agrias about it. But something was wrong. She was not surprised or shocked to hear any of it and told me to stay out of it. That's when I realized, the demon had already taken control of her and was using the order for its own dark purposes.",false)
        call Text_Say(gg_unit_Eill_0119,"I devised a plan with the Night Elves to get rid of the demon, but I was not willing to sacrifice my friend. I managed to lure her to the border of the world and banish her along with the demon itself. I did this by myself and secluded myself from Kalm so that if I failed or if she one day returned, her wrath and vengeance would fall only on me.",false)
        call Text_Say(gg_unit_Eill_0119,"Now it seems she made it through the world's boundary. It seems she is only after me at least. But this won't end until this demon's flame is truly extinguished.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"That is a sad story indeed. Agrias was once your friend and she was manipulated by this demon. You're no betrayer at all. You did something truly noble.",false)
        call Text_Say(gg_unit_Eill_0119,"If you are willing to help me do it, let us put her to rest. She will surely come after me sooner or later, and I don't wish to see her overcome by the demon like this.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Stay here Ramza, we shall take care of her. We'll make that foul demon leave Agrias' body even if it means her death.",false)
        call Cine_ExitAction()
    endif
    call QuestMessageBJ(udg_PlayingPlayers,bj_QUESTMESSAGE_UPDATED,"Kill Agrias.")
    call QuestSetDescriptionBJ(udg_SideQuest[31],"Kill Agrias Oaks, Holy Knight of Virgo who has fallen to the demon's control.")
    call EnableTrigger(gg_trg_Boss_Agrias_Intro)
    call GroupAddUnitSimple(gg_unit_Ewrd_0120,udg_BossUnits)
    call SetUnitOwner(gg_unit_Ewrd_0120,Player($B),true) // $B = 11
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function InitTrig_Quest_HolyKnight takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Quest_Part11 (module Quest),
// which keeps the original registration order.

function Register_Quest_HolyKnight_Start takes nothing returns nothing
    set gg_trg_Quest_HolyKnight_Start=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_HolyKnight_Start)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_HolyKnight_Start,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_HolyKnight_Start,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_HolyKnight_Start,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_HolyKnight_Start,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_HolyKnight_Start,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_HolyKnight_Start,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_HolyKnight_Start,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_HolyKnight_Start,Player(7),true)
    call TriggerAddCondition(gg_trg_Quest_HolyKnight_Start,Condition(function Trig_Quest_HolyKnight_Start_Conditions))
    call TriggerAddAction(gg_trg_Quest_HolyKnight_Start,function Trig_Quest_HolyKnight_Start_Actions)
endfunction

function Register_Quest_HolyKnight_AskRamza takes nothing returns nothing
    set gg_trg_Quest_HolyKnight_AskRamza=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_HolyKnight_AskRamza)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_HolyKnight_AskRamza,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_HolyKnight_AskRamza,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_HolyKnight_AskRamza,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_HolyKnight_AskRamza,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_HolyKnight_AskRamza,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_HolyKnight_AskRamza,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_HolyKnight_AskRamza,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_HolyKnight_AskRamza,Player(7),true)
    call TriggerAddCondition(gg_trg_Quest_HolyKnight_AskRamza,Condition(function Trig_Quest_HolyKnight_AskRamza_Conditions))
    call TriggerAddAction(gg_trg_Quest_HolyKnight_AskRamza,function Trig_Quest_HolyKnight_AskRamza_Actions)
endfunction

endlibrary
