library TQuestDwarfDisappearance requires TCam, TCine, TPlayerPart01, TText
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Quest_DwarfDisappearance_Start=null
endglobals

function Trig_Quest_DwarfDisappearance_Start_Conditions takes nothing returns boolean
    return((IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(GetUnitTypeId(GetTriggerUnit())!='H01D')and(IsUnitHiddenBJ(gg_unit_hbla_0158)==false)and(udg_InCinematicMode==false))!=null // 'H01D': unit "Spirit of Gaya"
endfunction

function Trig_Quest_DwarfDisappearance_Start_PlayDiscoveryScene takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_DwarfDisappearance_Start_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    if(Trig_Quest_DwarfDisappearance_Start_PlayDiscoveryScene())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"Wait, where did all the dwarves go?",false)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"That's strange... I can't imagine they'd just up and leave all of a sudden. Maybe something happened to them. I better try and find them.",false)
        call Cine_ExitAction()
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_DISCOVERED,"New Quest Received: |cffffcc00Dwarf Disappearance|r")
    set udg_SideQuest[66]=CreateQuestBJ(bj_QUESTTYPE_REQ_DISCOVERED,(udg_QuestNamePrefix+"Dwarf Disappearance"),"The dwarves at the Forge in the Barrens have all disappeared! Try and find where they may have gone.","ReplaceableTextures\\CommandButtons\\BTNMortarTeam.blp")
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
