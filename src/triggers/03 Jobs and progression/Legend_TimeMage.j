library TLegendTimeMage requires TCam, TCine, TPlayerPart01, TText, TUnit
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Legend_TimeMage_Talk=null
endglobals

function Trig_Legend_TimeMage_Talk_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,udg_NpcUnit[$E],true,true,true)) // $E = 14
endfunction

function Trig_Legend_TimeMage_Talk_Cond_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Legend_TimeMage_Talk_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_LegendMarker[$E]) // $E = 14
    set udg_QuestStage[$E]=(udg_QuestStage[$E]+1) // $E = 14
    if(Trig_Legend_TimeMage_Talk_Cond_CinematicsEnabled())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(udg_NpcUnit[$E],"Greetings again, adventurers.",false) // $E = 14
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"I've been wondering about this, is there no Legendary Time Mage around?",false)
        call Text_Say(udg_NpcUnit[$E],"Ah yes, the Legendary Time Mage, no, they do in fact exist. But capturing their spirit is not possible.",false) // $E = 14
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"What do you mean? Who are you talking about?",false)
        call Text_Say(udg_NpcUnit[$E],"You see, the school of Time Magic is already full of dangerous spells that toy with time and space, but there is a forbidden spell even there. A spell that threatens to destroy causality and ruin the life of the caster as well as their entire world with it.",false) // $E = 14
        call Text_Say(udg_NpcUnit[$E],"It is the spell of traveling back through time. Keeping yourself intact and yet reverting the entire world around you to an earlier state in history.",false) // $E = 14
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Reverting time... makes sense.",false)
        call Text_Say(udg_NpcUnit[$E],"The Legendary Time Mage used that spell and erased themselves from history. Memories of their existence may still remain but you will not find them anywhere in this world. Nor could their spirit be captured by this Spring. It's not possible to manifest them anymore.",false) // $E = 14
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"That sounds scary. So is there no way to gain the blessing of the Legendary Time Mage for me now?",false)
        call Text_Say(udg_NpcUnit[$E],"I'm afraid not. Not unless you also master usage of this forbidden spell.",false) // $E = 14
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Use the forbidden spell...",false)
        call Cine_ExitAction()
    endif
    call StartTimerBJ(udg_UnitUpdateTimer,false,1.)
endfunction

function InitTrig_Legend_TimeMage takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Legend (module Legend),
// which keeps the original registration order.

function Register_Legend_TimeMage_Talk takes nothing returns nothing
    set gg_trg_Legend_TimeMage_Talk=CreateTrigger()
    call DisableTrigger(gg_trg_Legend_TimeMage_Talk)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_TimeMage_Talk,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_TimeMage_Talk,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_TimeMage_Talk,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_TimeMage_Talk,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_TimeMage_Talk,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_TimeMage_Talk,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_TimeMage_Talk,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_TimeMage_Talk,Player(7),true)
    call TriggerAddCondition(gg_trg_Legend_TimeMage_Talk,Condition(function Trig_Legend_TimeMage_Talk_Conditions))
    call TriggerAddAction(gg_trg_Legend_TimeMage_Talk,function Trig_Legend_TimeMage_Talk_Actions)
endfunction

endlibrary
