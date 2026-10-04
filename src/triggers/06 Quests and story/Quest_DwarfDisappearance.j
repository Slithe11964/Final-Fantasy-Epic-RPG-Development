library TQuestDwarfDisappearance requires TQuestEngine, TCam, TCine, TPlayerHero, TText
// Side quest "Dwarf Disappearance", written for the quest engine (QuestEngine module, docs/QUEST_ENGINE.md).
// The dwarves at the Forge in the Barrens are gone; Valigarmanda has caged them in the Icy Realm.
// All steps are custom: this module's trigger starts the quest when a hero walks into the empty Forge
// (enabled by Dwarves); the Valigarmanda module finishes the other steps. Does not count toward the story.
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Quest_DwarfDisappearance_Start=null
    // The quest's number in the quest engine (0 until it is defined).
    integer QUEST_DWARF_DISAPPEARANCE=0
endglobals

function QuestDwarfDisappearance_Define takes nothing returns nothing
    local integer q=Quest_Define("Dwarf Disappearance",QUEST_SIDE,66,"ReplaceableTextures\\CommandButtons\\BTNMortarTeam.blp")
    set QUEST_DWARF_DISAPPEARANCE=q
    call Quest_NotStory(q)
    // 1. A hero finds the Forge empty (gg_trg_Quest_DwarfDisappearance_Start)
    call Quest_Custom(q,"The dwarves at the Forge in the Barrens have all disappeared! Try and find where they may have gone.")
    // 2. Confront Valigarmanda (Valigarmanda module, gg_trg_Valigarmanda_Confront)
    call Quest_Custom(q,"Defeat Valigarmanda and free the dwarves.")
    // 3. Valigarmanda dies (Valigarmanda module, gg_trg_Valigarmanda_Death)
    call Quest_Custom(q,"")
endfunction

function Trig_Quest_DwarfDisappearance_Start_Conditions takes nothing returns boolean
    return((IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(GetUnitTypeId(GetTriggerUnit())!='H01D')and(IsUnitHiddenBJ(gg_unit_hbla_0158)==false)and(udg_InCinematicMode==false))!=null // 'H01D': unit "Spirit of Gaya"
endfunction

function Trig_Quest_DwarfDisappearance_Start_PlayDiscoveryScene takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

// Step 1: a hero walks into the empty Forge. The way to the Icy Realm opens and Valigarmanda waits there.
function Trig_Quest_DwarfDisappearance_Start_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    if(Trig_Quest_DwarfDisappearance_Start_PlayDiscoveryScene())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"Wait, where did all the dwarves go?",false)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"That's strange... I can't imagine they'd just up and leave all of a sudden. Maybe something happened to them. I better try and find them.",false)
        call Cine_ExitAction()
    endif
    if QUEST_DWARF_DISAPPEARANCE==0 then
        call QuestDwarfDisappearance_Define()
    endif
    call Quest_Start(QUEST_DWARF_DISAPPEARANCE,GetOwningPlayer(GetTriggerUnit()),GetTriggerUnit())
    call SetDestructableInvulnerableBJ(gg_dest_ITx3_0033,false)
    call SetDestructableInvulnerableBJ(gg_dest_ITx1_0022,false)
    call ShowDestructableBJ(true,gg_dest_LOcg_0070)
    call ShowDestructableBJ(true,gg_dest_LOcg_0071)
    call ShowDestructableBJ(true,gg_dest_LOcg_0042)
    call ShowDestructableBJ(true,gg_dest_LOcg_0031)
    call ShowDestructableBJ(true,gg_dest_LOcg_0032)
    call ShowDestructableBJ(true,gg_dest_LOcg_0029)
    call ShowUnitShow(gg_unit_n0MC_0265)
    call EnableTrigger(gg_trg_Valigarmanda_Confront)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function InitTrig_Quest_DwarfDisappearance takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Quest_Part17 (module Quest),
// which keeps the original registration order.

function Register_Quest_DwarfDisappearance_Start takes nothing returns nothing
    set gg_trg_Quest_DwarfDisappearance_Start=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_DwarfDisappearance_Start)
    call TriggerRegisterEnterRectSimple(gg_trg_Quest_DwarfDisappearance_Start,gg_rct_696)
    call TriggerAddCondition(gg_trg_Quest_DwarfDisappearance_Start,Condition(function Trig_Quest_DwarfDisappearance_Start_Conditions))
    call TriggerAddAction(gg_trg_Quest_DwarfDisappearance_Start,function Trig_Quest_DwarfDisappearance_Start_Actions)
endfunction

endlibrary
