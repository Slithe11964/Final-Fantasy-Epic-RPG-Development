library TQuestCorruptedOrcs requires TCam, TCine, TPlayerPart01, TText, TUnit
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Quest_CorruptedOrcs_Start=null
endglobals

function Trig_Quest_CorruptedOrcs_Start_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_Hvwd_0098,true,true,true))
endfunction

function Trig_Quest_CorruptedOrcs_Start_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_CorruptedOrcs_Start_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[30])
    if(Trig_Quest_CorruptedOrcs_Start_CinematicsEnabled())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(gg_unit_Hvwd_0098,"Ah, you came.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Greetings. Is there something amiss still?",false)
        call Text_Say(gg_unit_Hvwd_0098,"As you may recall we were attacked not just by monsters but also by strange beasts during the sieges. They were of the same race as Ao Madoushi, but that red skin tone was unnatural.",false)
        call Text_Say(gg_unit_Hvwd_0098,"After conferring with Ao Madoushi on the matter we also asked our scouts and it seems these beasts were seen sailing towards Kalm from an island to the east of the Farm.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"That is good information. Now we can strike before they attack us again!",false)
        call Text_Say(gg_unit_Hvwd_0098,"Yes, that is what I'd like to ask of you. The island is far from Kalm so it'd take a lot of effort and resources to mobilize our forces there, and while we may have defeated the demon it's still too risky to leave the town on low defenses.",false)
        call Text_Say(gg_unit_Hvwd_0098,"I realize that I am asking a lot of you. You are likely going to be met with an entire settlement of these beasts given their numbers. But we cannot afford any other ways, and any day they remain untouched is another day they may yet attack us again.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Worry not. We will raze their entire settlement to the ground!",false)
        call Cine_ExitAction()
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_DISCOVERED,"New Quest Received: |cffffcc00Corrupted Orcs|r")
    set udg_MainQuest[$D]=CreateQuestBJ(bj_QUESTTYPE_REQ_DISCOVERED,(udg_ColorGold+"Corrupted Orcs"),"Meliadoul, First Ranger of Kalm, asked you to attack the enemy base located on an island east of the Farm. Destroy every last building!","ReplaceableTextures\\CommandButtons\\BTNChaosGrom.blp") // $D = 13
    call GroupAddUnitSimple(gg_unit_nbfl_0170,udg_BossUnits)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function InitTrig_Quest_CorruptedOrcs takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Quest_Part5 (module Quest),
// which keeps the original registration order.

function Register_Quest_CorruptedOrcs_Start takes nothing returns nothing
    set gg_trg_Quest_CorruptedOrcs_Start=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_CorruptedOrcs_Start)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_CorruptedOrcs_Start,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_CorruptedOrcs_Start,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_CorruptedOrcs_Start,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_CorruptedOrcs_Start,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_CorruptedOrcs_Start,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_CorruptedOrcs_Start,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_CorruptedOrcs_Start,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_CorruptedOrcs_Start,Player(7),true)
    call TriggerAddCondition(gg_trg_Quest_CorruptedOrcs_Start,Condition(function Trig_Quest_CorruptedOrcs_Start_Conditions))
    call TriggerAddAction(gg_trg_Quest_CorruptedOrcs_Start,function Trig_Quest_CorruptedOrcs_Start_Actions)
endfunction

endlibrary
