library TQuestPhantomDiary requires TCam, TCine, TPlayerPart01, TText
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Quest_PhantomDiary_ShowAlberich=null
endglobals

function Trig_Quest_PhantomDiary_ShowAlberich_Conditions takes nothing returns boolean
    return((UnitHasItemOfTypeBJ(GetTriggerUnit(),'I0BR'))and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(IsUnitHiddenBJ(gg_unit_h037_0257)==false)and(udg_InCinematicMode==false))!=null // 'I0BR': item "Phantom Diary Page 3"
endfunction

function Trig_Quest_PhantomDiary_ShowAlberich_Cond_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_PhantomDiary_ShowAlberich_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call RemoveItem(udg_QuestItem[31])
    call RemoveItem(udg_QuestItem[32])
    call RemoveItem(udg_QuestItem[33])
    call RemoveItem(udg_QuestItem[34])
    if(Trig_Quest_PhantomDiary_ShowAlberich_Cond_CinematicsEnabled())then
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_h037_0257,0)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"Hey Alberich. Can you take a look at this?",false)
        call Text_Say(gg_unit_h037_0257,"That...!",false)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"Ziegfried had it on him after we struck him down. Although it's only barely clinging to this realm to begin with. There were a few names in these pages, like Forgefire I imagine means Bali and Loki's ancestors. But one name - \"Alby\" - that's truly you, isn't it?",false)
        call Text_Say(gg_unit_h037_0257,"You're too curious for your own good, you know that?",false)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"Tell me more. Who wrote these pages? What do you know, and why didn't you ever say anything?",false)
        call Text_Say(gg_unit_h037_0257,"Fine. If you want to know more, let's talk. But not here. Meet me in a more secluded place. This doesn't concern the others.",false)
        call Cine_ExitAction()
    endif
    set udg_TempPoint=GetRectCenter(gg_rct_711)
    call SetUnitPositionLocFacingBJ(gg_unit_h037_0257,udg_TempPoint,200.)
    call RemoveLocation(udg_TempPoint)
    call ShowUnitShow(gg_unit_E01O_0268)
    call GroupAddUnitSimple(gg_unit_h037_0257,udg_BossUnits)
    set udg_SpecialEffect[90]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_h037_0257,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call EnableTrigger(gg_trg_Quest_NorthernGod_Judgment)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function InitTrig_Quest_PhantomDiary takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Quest_Part12 (module Quest),
// which keeps the original registration order.

function Register_Quest_PhantomDiary_ShowAlberich takes nothing returns nothing
    set gg_trg_Quest_PhantomDiary_ShowAlberich=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_PhantomDiary_ShowAlberich)
    call TriggerRegisterUnitInRangeSimple(gg_trg_Quest_PhantomDiary_ShowAlberich,300.,gg_unit_h037_0257)
    call TriggerAddCondition(gg_trg_Quest_PhantomDiary_ShowAlberich,Condition(function Trig_Quest_PhantomDiary_ShowAlberich_Conditions))
    call TriggerAddAction(gg_trg_Quest_PhantomDiary_ShowAlberich,function Trig_Quest_PhantomDiary_ShowAlberich_Actions)
endfunction

endlibrary
