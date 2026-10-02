library TQuestNorthernGod requires TCam, TCine, TPlayerHero, TText, TUnit
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Quest_NorthernGod_Judgment=null
endglobals

function Trig_Quest_NorthernGod_Judgment_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_h037_0257,true,true,true))
endfunction

function Trig_Quest_NorthernGod_Judgment_Cond_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_NorthernGod_Judgment_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[90])
    if(Trig_Quest_NorthernGod_Judgment_Cond_CinematicsEnabled())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(gg_unit_h037_0257,"There you are. I've been waiting.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Who is that?",false)
        call Text_Say(gg_unit_h037_0257,"She's an envoy of the Northern God. She said she wanted to be here as well.",false)
        call Text_Say(gg_unit_E01O_0268,"Do not mind me. I simply want to be witness to this as well.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Well if Alberich is fine with, alright then. So tell me. What is this phantom diary that Ziegfried held? He didn't write it himself, did he?",false)
        call Text_Say(gg_unit_h037_0257,"No, the one who wrote that diary was my nephew. He was a naive fellow but he had a passion. The former head smiths in the Barrens took him under their wing and trained him. Eventually he reached the point of making his own Arcanium weapons. It was a great accomplishment. Until one day it ended in an instant.",false)
        call Text_Say(gg_unit_h037_0257,"He was inside the Arcanium mine when the godbeast Fafnir came down and attacked. Most of the people on site were killed and the entrance caved in, trapping many others inside, including him.",false)
        call Text_Say(gg_unit_h037_0257,"I tried to force my way in there trying to rescue any survivors. I used to be an incredibly powerful tamer of beasts myself. I even managed to fight off the godbeast itself, although it would not stay down for long. But even so, by the time I reached the mine it was too late. There were no survivors of the attack. All I found was this diary.",false)
        call Text_Say(gg_unit_h037_0257,"You've talked with Siegfried right? About why the godbeast was sent to descend onto the mine. But even now I won't accept it. They were murdered, my nephew, everyone else. They can't be brought back. All I could do was at least take revenge on the beast.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"You... took revenge? What do you mean?",false)
        call Text_Say(gg_unit_h037_0257,"It was I who put Ziegfried up to fighting the beast. I told him how much of a hero he'd be if he took it down. I gave him the diary, and put him on the path to acquiring the Arcanium weapons necessary to slay it.",false)
        call Text_Say(gg_unit_E01O_0268,"You knew that making him slay the beast would make Siegfried and I sent in to deal with him, did you not? You knew exactly that he was going to end up dead for executing your revenge for you. And yet still you sacrificed him for it.",false)
        call Text_Say(gg_unit_h037_0257,"I have no regrets. Ziegfried was the exact type of why the godbeast was brought down on the mine in the first place. Seeing his callous arrogance and selfishness made me understand why you did what you did, and that's why I hated him even more. He deserved his end. My nephew did not.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Cold. He was a bastard, but you really think he deserved to die like that, for your own personal revenge?",false)
        call Text_Say(gg_unit_h037_0257,"If you judge me for it I don't care. I feel no guilt for what I set him up to do.",false)
        call Text_Say(gg_unit_E01O_0268,"Well now, adventurers, what do you think?",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"What do you mean?",false)
        call Text_Say(gg_unit_E01O_0268,"This man has told you all of what he did, and he feels no regret or guilt over it. The Northern God brought down judgment on Ziegfried, but he was set on his path intentionally by Alberich. So tell me, do you think Alberich deserves to be judged for what he's done? Or does he deserve to walk free?",false)
        call Text_Say(gg_unit_E01O_0268,"I'm here as the envoy of the Northern God himself, not to judge this man, but to judge your judgment of him. Show me what you believe in.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),". . .",false)
        call Cine_ExitAction()
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_UPDATED,"Decide whether Alberich deserves judgment: attack him, or leave and let him go.")
    set udg_QuestsTotal=(udg_QuestsTotal+1)
    set udg_SpecialEffect[90]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_h037_0257,"Objects\\RandomObject\\RandomObject.mdl")
    call StartTimerBJ(udg_SharedDelayTimer5,false,8.)
    set udg_JudgePlayer=GetTriggerPlayer()
    call UnitAddAbilityBJ('A0T8',gg_unit_h037_0257) // 'A0T8': ability "Block All"
    call SetUnitInvulnerable(gg_unit_h037_0257,false)
    call EnableTrigger(gg_trg_Judgment_Attack_Alberich)
    call EnableTrigger(gg_trg_Judgment_Spare_Alberich)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function InitTrig_Quest_NorthernGod takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Quest_Part13 (module Quest),
// which keeps the original registration order.

function Register_Quest_NorthernGod_Judgment takes nothing returns nothing
    set gg_trg_Quest_NorthernGod_Judgment=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_NorthernGod_Judgment)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_NorthernGod_Judgment,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_NorthernGod_Judgment,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_NorthernGod_Judgment,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_NorthernGod_Judgment,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_NorthernGod_Judgment,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_NorthernGod_Judgment,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_NorthernGod_Judgment,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_NorthernGod_Judgment,Player(7),true)
    call TriggerAddCondition(gg_trg_Quest_NorthernGod_Judgment,Condition(function Trig_Quest_NorthernGod_Judgment_Conditions))
    call TriggerAddAction(gg_trg_Quest_NorthernGod_Judgment,function Trig_Quest_NorthernGod_Judgment_Actions)
endfunction

endlibrary
