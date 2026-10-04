library TQuestLightOfJudgment requires TQuestEngine, TCam, TCine, TPlayerHero, TText, TUnit
// Main quest "Light of Judgment" (udg_MainQuest[16]), run by the quest engine (QuestEngine module,
// docs/QUEST_ENGINE.md). Alma has disappeared from Kalm; Ramza and the party look for her and find her
// possessed by Ultima, the Zodiac Brave of Holy. All steps are custom: Start (talk to Ramza) calls
// Quest_Start, Ultima reveals herself (Ultima calls QuestLightOfJudgment_UltimaAppears) and Ultima dies
// (Boss_Ultima calls QuestLightOfJudgment_UltimaSlain). The "!" over Ramza (from Alma) and over Alma are
// effects outside the engine. Does not count toward the story.
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Quest_LightOfJudgment_Start=null
    // The quest's number in the quest engine (0 until it is defined).
    integer QUEST_LIGHT_OF_JUDGMENT=0
endglobals

function QuestLightOfJudgment_Define takes nothing returns nothing
    local integer q=Quest_Define("Light of Judgment",QUEST_MAIN,16,"ReplaceableTextures\\CommandButtons\\BTNJaina.blp")
    set QUEST_LIGHT_OF_JUDGMENT=q
    call Quest_NotStory(q)
    call Quest_NoMarker(q)
    // 1. Talk to Ramza (gg_trg_Quest_LightOfJudgment_Start)
    call Quest_Custom(q,"Alma has gone missing! Find her!")
    // 2. Find Alma: Ultima possesses her and kills Ramza (Ultima)
    call Quest_Custom(q,"Defeat Ultima, the Zodiac Brave of Holy, to avenge Ramza, and to get Alma her body back!")
    call Quest_Message(q,"Defeat Ultima, the Zodiac Brave of Holy.")
    // 3. Defeat Ultima (Boss_Ultima)
    call Quest_Custom(q,"")
endfunction

// Ultima shows herself and the fight begins (called by Ultima through ExecuteFunc). Ultima's trigger is
// never turned off, so only its first run moves the quest on.
function QuestLightOfJudgment_UltimaAppears takes nothing returns nothing
    if Quest_CurrentStep(QUEST_LIGHT_OF_JUDGMENT)==2 then
        call Quest_StepDone(QUEST_LIGHT_OF_JUDGMENT,null,null)
    endif
endfunction

// Ultima is dead and Alma is free: the quest is done (called by Boss_Ultima through ExecuteFunc).
function QuestLightOfJudgment_UltimaSlain takes nothing returns nothing
    call Quest_StepDone(QUEST_LIGHT_OF_JUDGMENT,null,null)
endfunction

function Trig_Quest_LightOfJudgment_Start_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_Eill_0119,true,true,true))
endfunction

function Trig_Quest_LightOfJudgment_Start_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

// Step 1: a hero talks to Ramza. Alma (a stand-in unit) waits near Ultima's hiding place.
function Trig_Quest_LightOfJudgment_Start_Actions takes nothing returns nothing
    local location l_tempPoint
    call DisableTrigger(GetTriggeringTrigger())
    call GroupRemoveUnitSimple(gg_unit_Eill_0119,udg_BossUnits)
    call DestroyEffectBJ(udg_SpecialEffect[50])
    if(Trig_Quest_LightOfJudgment_Start_CinematicsEnabled())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(gg_unit_Eill_0119,("En Taro Adun, "+(udg_PlayerName[GetConvertedPlayerId(GetTriggerPlayer())]+".")),false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"En Taro Tassadar, brother.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Ramza, do you know where Alma has gone? She has disappeared from Kalm.",false)
        call Text_Say(gg_unit_Eill_0119,"My sister? No I haven't heard about this.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"I have a bad feeling about this... we better try and find her as soon as possible.",false)
        call Text_Say(gg_unit_Eill_0119,"Yes you're right. Alma would never just disappear like that without a word. Let's split up and look for her.",false)
        call Cine_ExitAction()
    endif
    if QUEST_LIGHT_OF_JUDGMENT==0 then
        call QuestLightOfJudgment_Define()
    endif
    call Quest_Start(QUEST_LIGHT_OF_JUDGMENT,GetTriggerPlayer(),GetTriggerUnit())
    call ShowUnitHide(gg_unit_Eill_0119)
    set l_tempPoint=GetUnitLoc(gg_unit_U00F_0221)
    call CreateNUnitsAtLoc(1,'Hjai',Player(8),l_tempPoint,GetUnitFacing(gg_unit_U00F_0221)) // 'Hjai': unit "Cleric"
    call RemoveLocation(l_tempPoint)
    set udg_AlmaUnit=GetLastCreatedUnit()
    call SetUnitColor(udg_AlmaUnit,PLAYER_COLOR_LIGHT_BLUE)
    call SetHeroLevelBJ(udg_AlmaUnit,$F,false) // $F = 15
    call UnitRemoveAbilityBJ('AInv',udg_AlmaUnit) // 'AInv': standard ability reference "Inventory"
    set udg_SpecialEffect[50]=AddSpecialEffectTargetUnitBJ("overhead",udg_AlmaUnit,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call EnableTrigger(gg_trg_Ultima_Possession)
    call PauseUnitBJ(true,gg_unit_Eill_0119)
    call DestroyTrigger(GetTriggeringTrigger())
    set l_tempPoint=null
endfunction

function InitTrig_Quest_LightOfJudgment takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Quest_Part7 (module Quest),
// which keeps the original registration order.

function Register_Quest_LightOfJudgment_Start takes nothing returns nothing
    set gg_trg_Quest_LightOfJudgment_Start=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_LightOfJudgment_Start)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_LightOfJudgment_Start,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_LightOfJudgment_Start,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_LightOfJudgment_Start,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_LightOfJudgment_Start,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_LightOfJudgment_Start,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_LightOfJudgment_Start,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_LightOfJudgment_Start,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_LightOfJudgment_Start,Player(7),true)
    call TriggerAddCondition(gg_trg_Quest_LightOfJudgment_Start,Condition(function Trig_Quest_LightOfJudgment_Start_Conditions))
    call TriggerAddAction(gg_trg_Quest_LightOfJudgment_Start,function Trig_Quest_LightOfJudgment_Start_Actions)
endfunction

endlibrary
