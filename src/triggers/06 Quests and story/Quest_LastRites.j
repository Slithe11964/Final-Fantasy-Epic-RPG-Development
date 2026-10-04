library TQuestLastRites requires TQuestEngine, TCam, TCine, TPlayerHero, TText, TUnit
// Main quest "Last Rites" (udg_MainQuest[14]), run by the quest engine (QuestEngine module,
// docs/QUEST_ENGINE.md). Zack from the Farm wants the dead buried and asks the party to find Maester Exodus,
// the mysterious priest "X". All steps are custom: Start (talk to Zack) calls Quest_Start, the priest
// reveals himself (Exodus calls QuestLastRites_ExodusRevealed) and Exodus dies (Boss_Exodus calls
// QuestLastRites_ExodusSlain). The "!" over Zack and the priest is this module's own effect.
// Does not count toward the story.
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Quest_LastRites_Start=null
    // The quest's number in the quest engine (0 until it is defined).
    integer QUEST_LAST_RITES=0
endglobals

function QuestLastRites_Define takes nothing returns nothing
    local integer q=Quest_Define("Last Rites",QUEST_MAIN,14,"ReplaceableTextures\\CommandButtons\\BTNTranquility.blp")
    set QUEST_LAST_RITES=q
    call Quest_NotStory(q)
    call Quest_NoMarker(q)
    // 1. Talk to Zack (gg_trg_Quest_LastRites_Start)
    call Quest_Custom(q,"Zack from the Farm has asked you to speak with Maester Exodus. It seems likely he is referring to the mysterious priest \"X\". Confront him over his identity!")
    // 2. Talk to the priest, who reveals himself as Exodus (Exodus)
    call Quest_Custom(q,"Defeat Exodus, the Zodiac Brave of Aether.")
    // 3. Defeat Exodus (Boss_Exodus)
    call Quest_Custom(q,"")
endfunction

// The priest shows his true form and the fight begins (called by Exodus through ExecuteFunc).
function QuestLastRites_ExodusRevealed takes nothing returns nothing
    call Quest_StepDone(QUEST_LAST_RITES,null,null)
endfunction

// Exodus is dead: the quest is done (called by Boss_Exodus through ExecuteFunc).
function QuestLastRites_ExodusSlain takes nothing returns nothing
    call Quest_StepDone(QUEST_LAST_RITES,null,null)
endfunction

function Trig_Quest_LastRites_Start_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_n00K_0150,true,true,true))
endfunction

function Trig_Quest_LastRites_Start_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_LastRites_Start_RemoveCorpse takes nothing returns nothing
    call KillUnit(GetEnumUnit())
    call RemoveUnit(GetEnumUnit())
endfunction

// Step 1: a hero talks to Zack. The farm's dead are laid to rest and the priest appears.
function Trig_Quest_LastRites_Start_Actions takes nothing returns nothing
    local location l_tempPoint
    call DisableTrigger(GetTriggeringTrigger())
    set udg_ExodusQuestStage=5
    call DestroyEffectBJ(udg_SpecialEffect[28])
    if(Trig_Quest_LastRites_Start_CinematicsEnabled())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(gg_unit_n00K_0150,"Ah, it's our heroes! Sorry, but could I ask something of you once more?",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Zack, was it? Something the matter?",false)
        call Text_Say(gg_unit_n00K_0150,"Well I've decided we should give the ones who died a proper burial. You've given us back hope, but I believe this is the last step we need to be able to move on. All of us.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"That is a nice gesture. I'm sure the dead will appreciate it as well.",false)
        call Text_Say(gg_unit_n00K_0150,"Thank you. But now someone important has disappeared on us.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Disappeared?",false)
        call Text_Say(gg_unit_n00K_0150,"The local priest. His name is Maester Exodus. He's been this farm's spiritual guide, offering solace and prayer for good weather. If it hadn't been for him we'd have lost hope long ago I'm sure.",false)
        call Text_Say(gg_unit_n00K_0150,"He's been known to wander off and disappear at times, but with the recent happenings it's rather worrying. I'm sure you get what I mean.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Hmm, a priest is it...",false)
        call Text_Say(gg_unit_n00K_0150,"RIght, you wouldn't have met yet. Well just be on the lookout for priest-looking humans and you'll find him I'm sure. Please, we'd need him for a proper sermon!",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Sure, I'll find him. And make him explain.",false)
        call Cine_ExitAction()
    endif
    if QUEST_LAST_RITES==0 then
        call QuestLastRites_Define()
    endif
    call Quest_Start(QUEST_LAST_RITES,GetTriggerPlayer(),GetTriggerUnit())
    call ForGroupBJ(udg_FarmCorpses,function Trig_Quest_LastRites_Start_RemoveCorpse)
    call GroupClear(udg_FarmCorpses)
    call SetDoodadAnimationRectBJ("hide",'NOft',gg_rct_580) // 'NOft': object name not found in map data
    set l_tempPoint=GetRectCenter(gg_rct_649)
    call SetUnitPositionLoc(gg_unit_n0D3_0117,l_tempPoint)
    call RemoveLocation(l_tempPoint)
    call ShowUnitShow(gg_unit_n0D3_0117)
    set udg_SpecialEffect[28]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_n0D3_0117,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call EnableTrigger(gg_trg_Exodus_Reveal)
    call DestroyTrigger(GetTriggeringTrigger())
    set l_tempPoint=null
endfunction

function InitTrig_Quest_LastRites takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Quest_Part6 (module Quest),
// which keeps the original registration order.

function Register_Quest_LastRites_Start takes nothing returns nothing
    set gg_trg_Quest_LastRites_Start=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_LastRites_Start)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_LastRites_Start,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_LastRites_Start,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_LastRites_Start,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_LastRites_Start,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_LastRites_Start,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_LastRites_Start,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_LastRites_Start,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_LastRites_Start,Player(7),true)
    call TriggerAddCondition(gg_trg_Quest_LastRites_Start,Condition(function Trig_Quest_LastRites_Start_Conditions))
    call TriggerAddAction(gg_trg_Quest_LastRites_Start,function Trig_Quest_LastRites_Start_Actions)
endfunction

endlibrary
