library TMid requires TQuestEngine, TCam, TCine, TGroup, TPlayerHero, TText, TUnit, TWait, optional TQuestYoungEngineer
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Mid_Cage_Ping=null
    trigger gg_trg_Mid_Freed=null
    trigger gg_trg_Mid_Letter_Give=null
    trigger gg_trg_Mid_Letter_Ping=null
    trigger gg_trg_Mid_Crossbow_Talk_Enable=null
endglobals

function Trig_Mid_Cage_Ping_Actions takes nothing returns nothing
    local location l_tempPoint
    set l_tempPoint=GetDestructableLoc(gg_dest_LOcg_0010)
    call PingMinimapLocForForceEx(GetPlayersAll(),l_tempPoint,2.,bj_MINIMAPPINGSTYLE_SIMPLE,'d',80.,.0)
    call RemoveLocation(l_tempPoint)
    set l_tempPoint=null
endfunction

function Trig_Mid_Freed_IsHeroUnit takes nothing returns boolean
    return(IsUnitType(GetFilterUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Mid_Freed_IsPlayerOwned takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetFilterUnit()),udg_PlayingPlayers))
endfunction

function Trig_Mid_Freed_IsPlayerHero takes nothing returns boolean
    return GetBooleanAnd(Trig_Mid_Freed_IsHeroUnit(),Trig_Mid_Freed_IsPlayerOwned())
endfunction

function Trig_Mid_Freed_CinematicsOn takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Mid_Freed_FindMidDiscovered takes nothing returns boolean
    return(IsQuestDiscovered(udg_MainQuest[1]))
endfunction

function Trig_Mid_Freed_Actions takes nothing returns nothing
    local location l_tempPoint
    call DisableTrigger(GetTriggeringTrigger())
    set l_tempPoint=GetDestructableLoc(GetDyingDestructable())
    call CreateNUnitsAtLoc(1,'Hart',Player(9),l_tempPoint,bj_UNIT_FACING) // 'Hart': unit "Engineer"
    call RemoveLocation(l_tempPoint)
    set udg_Mid=GetLastCreatedUnit()
    call UnitAddItemByIdSwapped('I01A',udg_Mid) // 'I01A': item "Battle Axe"
    call UnitAddItemByIdSwapped('I013',udg_Mid) // 'I013': item "Iron Shield"
    call UnitAddItemByIdSwapped('I01O',udg_Mid) // 'I01O': item "Storm Wyrm Hide Armor"
    call UnitAddItemByIdSwapped('I01H',udg_Mid) // 'I01H': item "Iron Helmet"
    call UnitAddItemByIdSwapped('I00L',udg_Mid) // 'I00L': item "Totem of Power"
    call UnitAddItemByIdSwapped('pghe',udg_Mid) // 'pghe': item "Hi-Potion"
    call SetHeroLevelBJ(udg_Mid,$A,false) // $A = 10
    call UnitAddTypeBJ(UNIT_TYPE_PEON,udg_Mid)
    if(Trig_Mid_Freed_CinematicsOn())then
        call Cine_Enter()
        call Cam_PanToUnit(udg_Mid,0)
        set l_tempPoint=GetUnitLoc(udg_Mid)
        set udg_TempGroup=Group_UnitsInRangeOfLoc(700.,l_tempPoint,Condition(function Trig_Mid_Freed_IsPlayerHero))
        call RemoveLocation(l_tempPoint)
        call SetUnitFacingToFaceUnitTimed(udg_Mid,GroupPickRandomUnit(udg_TempGroup),.0)
        call DestroyGroup(udg_TempGroup)
        call Text_Say(udg_Mid,"Thank you for saving me. Those ruffians attacked me and there were too many of them for me to fight. They captured me, placed me in this cage, and talked about sacrificing me to some Goblin Chieftain, which is weird, since Bandits never get along with Goblins.",false)
        call Text_Say(udg_Mid,"But now I am free, and I have to thank you for it! Come visit us in Kalm to claim your reward for saving me.  Cya!",false)
        call Cine_ExitAction()
    endif
    set l_tempPoint=GetUnitLoc(udg_Mid)
    call AddSpecialEffectLocBJ(l_tempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(l_tempPoint)
    set l_tempPoint=GetRectCenter(gg_rct_116)
    call SetUnitPositionLoc(gg_unit_Hpb1_0013,GetRectCenter(gg_rct_116))
    call RemoveLocation(l_tempPoint)
    set l_tempPoint=GetRectCenter(gg_rct_234)
    call SetUnitPositionLoc(udg_Mid,GetRectCenter(gg_rct_234))
    call RemoveLocation(l_tempPoint)
    if(Trig_Mid_Freed_FindMidDiscovered())then
        // "Find Mid" was given by Cid: only the text changes (the announcement differs from the text)
        call QuestMessageBJ(udg_PlayingPlayers,bj_QUESTMESSAGE_UPDATED,"Return to Cid")
        call Quest_SetLog(QUEST_FIND_MID,"Return to Cid in Kalm.",false)
    else
        call DisableTrigger(gg_trg_Cid_Talk_FindMid)
        call DestroyTrigger(gg_trg_Cid_Talk_FindMid)
        // "Find Mid" starts here, before anyone talked to Cid (defined in the Cid module)
        if QUEST_FIND_MID==0 then
            call ExecuteFunc("Cid_FindMid_Define")
        endif
        call Quest_Start(QUEST_FIND_MID,null,null)
        call Quest_SetLog(QUEST_FIND_MID,"Talk to Cid to speak to him about Mid.",false)
        call DestroyEffectBJ(udg_SpecialEffect[19])
        set udg_SpecialEffect[19]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_Hpb1_0013,"Objects\\RandomObject\\RandomObject.mdl")
        call ModifyGateBJ(bj_GATEOPERATION_OPEN,gg_dest_LTg4_0005)
        call ModifyGateBJ(bj_GATEOPERATION_OPEN,gg_dest_LTe2_0020)
        call ConditionalTriggerExecute(gg_trg_MysticalGlyph_Prepare)
        call ConditionalTriggerExecute(gg_trg_Frakir_ShowMarker)
        call ConditionalTriggerExecute(gg_trg_Shadow_FirstAppear)
        call ConditionalTriggerExecute(gg_trg_Quest_Shimmerweed_Offer)
        call ConditionalTriggerExecute(gg_trg_Quest_Arachnophobia_Offer)
        call ConditionalTriggerExecute(gg_trg_Naisha_Prepare)
        call ConditionalTriggerExecute(gg_trg_Valera_ShowMarker)
        // starting "Find Mid" counts toward the story too (the engine counts it again when it is done)
        set udg_StoryProgress=(udg_StoryProgress+1)
        call ConditionalTriggerExecute(gg_trg_QuestCount_Milestones)
    endif
    call DisableTrigger(gg_trg_Mid_Cage_Ping)
    call DestroyTrigger(gg_trg_Mid_Cage_Ping)
    call EnableTrigger(gg_trg_Cid_Talk_MidReturned)
    set udg_CidQuestStage=2
    call Wait_Polled(.2)
    call SetUnitFacingTimed(udg_Mid,bj_UNIT_FACING,0)
    set udg_NewsText[3]=udg_NewsText[2]
    set udg_NewsText[2]=udg_NewsText[1]
    set udg_NewsText[6]=udg_NewsText[5]
    set udg_NewsText[5]=udg_NewsText[4]
    set udg_NewsText[1]="|cffffcc00Mid Has Returned|r"
    set udg_NewsText[4]="Mid, nephew of Cid, the head of our community, has returned. He had been captured by bandits in Guardia Forest."
    call DestroyTrigger(GetTriggeringTrigger())
    set l_tempPoint=null
endfunction

function Trig_Mid_Letter_Give_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,udg_Mid,true,true,true))
endfunction

function Trig_Mid_Letter_Give_KalmQuestDone takes nothing returns boolean
    return(IsQuestCompleted(udg_MainQuest[$B])) // $B = 11
endfunction

function Trig_Mid_Letter_Give_PlayLetterScene takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Mid_Letter_Give_GiottNotMetYet takes nothing returns boolean
    return(udg_KalmTechLevel<=0)
endfunction

function Trig_Mid_Letter_Give_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[89])
    if(Trig_Mid_Letter_Give_PlayLetterScene())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(udg_Mid,"Wait a second. If there's still time, there's something I'd like to ask of you.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"What is it?",false)
        if(Trig_Mid_Letter_Give_KalmQuestDone())then
            call Text_Say(udg_Mid,"We did hold off the attacks on Kalm for now, but in case we are attacked again we could really use the help of the dwarves to fend off the monsters. They are settled in the far northeast of the Barrens. Perhaps you've met them already.",false)
        else
            call Text_Say(udg_Mid,"With Kalm being attacked we could really use the help of the dwarves to fend off the monsters. They are settled in the far northeast of the Barrens. Perhaps you've met them already.",false)
        endif
        call Text_Say(udg_Mid,"They are a suspicious bunch not quick to trust strangers. But uncle and I have worked with them before. If you show them this letter, they should be more willing to help.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Alright, I'll see if I can get their help.",false)
        call Cine_ExitAction()
    endif
    if(Trig_Mid_Letter_Give_GiottNotMetYet())then
        set udg_KalmTechLevel=2
        call DisableTrigger(gg_trg_Giott_FirstTalk)
        call DestroyEffectBJ(udg_SpecialEffect[87])
    endif
    set udg_SpecialEffect[87]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_h00R_0256,"Objects\\RandomObject\\RandomObject.mdl")
    set udg_QuestItem[26]=UnitAddItemByIdSwapped('I0KP',Player_GetHero(GetTriggerPlayer())) // 'I0KP': item "Letter from Mid"
    call SetItemInvulnerableBJ(GetLastCreatedItem(),true)
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_UPDATED,"Bring Mid's letter to Giott in the Barrens.")
    call EnableTrigger(gg_trg_Mid_Letter_Ping)
    call EnableTrigger(gg_trg_Giott_Letter_Deliver)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Mid_Letter_Ping_Conditions takes nothing returns boolean
    return(udg_QuestItem[26]!=null)
endfunction

function Trig_Mid_Letter_Ping_LetterCarried takes nothing returns boolean
    return(IsItemOwned(udg_QuestItem[26]))
endfunction

function Trig_Mid_Letter_Ping_Actions takes nothing returns nothing
    if(Trig_Mid_Letter_Ping_LetterCarried())then
        set udg_TempPoint=GetUnitLoc(gg_unit_h00R_0256)
    else
        set udg_TempPoint=GetItemLoc(udg_QuestItem[26])
    endif
    call PingMinimapLocForForce(GetPlayersAll(),udg_TempPoint,2.)
    call RemoveLocation(udg_TempPoint)
endfunction

function Trig_Mid_Crossbow_Talk_Enable_Actions takes nothing returns nothing
    static if LIBRARY_TQuestYoungEngineer then
        call ExecuteFunc("QuestYoungEngineer_Available") // the "!" over Mid; the Young Engineer quest can start
    endif
    set udg_CrossbowAdviceGiven=false
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_Mid automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Mid_Part1 / RegisterTriggers_Mid_Part2 (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Mid takes nothing returns nothing
endfunction

function Register_Mid_Cage_Ping takes nothing returns nothing
    set gg_trg_Mid_Cage_Ping=CreateTrigger()
    call DisableTrigger(gg_trg_Mid_Cage_Ping)
    call TriggerRegisterTimerEventPeriodic(gg_trg_Mid_Cage_Ping,15.)
    call TriggerAddAction(gg_trg_Mid_Cage_Ping,function Trig_Mid_Cage_Ping_Actions)
endfunction

function Register_Mid_Freed takes nothing returns nothing
    set gg_trg_Mid_Freed=CreateTrigger()
    call DisableTrigger(gg_trg_Mid_Freed)
    call TriggerRegisterDeathEvent(gg_trg_Mid_Freed,gg_dest_LOcg_0010)
    call TriggerAddAction(gg_trg_Mid_Freed,function Trig_Mid_Freed_Actions)
endfunction

function Register_Mid_Letter_Give takes nothing returns nothing
    set gg_trg_Mid_Letter_Give=CreateTrigger()
    call DisableTrigger(gg_trg_Mid_Letter_Give)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Mid_Letter_Give,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Mid_Letter_Give,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Mid_Letter_Give,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Mid_Letter_Give,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Mid_Letter_Give,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Mid_Letter_Give,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Mid_Letter_Give,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Mid_Letter_Give,Player(7),true)
    call TriggerAddCondition(gg_trg_Mid_Letter_Give,Condition(function Trig_Mid_Letter_Give_Conditions))
    call TriggerAddAction(gg_trg_Mid_Letter_Give,function Trig_Mid_Letter_Give_Actions)
endfunction

function Register_Mid_Letter_Ping takes nothing returns nothing
    set gg_trg_Mid_Letter_Ping=CreateTrigger()
    call DisableTrigger(gg_trg_Mid_Letter_Ping)
    call TriggerRegisterTimerEventPeriodic(gg_trg_Mid_Letter_Ping,15.)
    call TriggerAddCondition(gg_trg_Mid_Letter_Ping,Condition(function Trig_Mid_Letter_Ping_Conditions))
    call TriggerAddAction(gg_trg_Mid_Letter_Ping,function Trig_Mid_Letter_Ping_Actions)
endfunction

function Register_Mid_Crossbow_Talk_Enable takes nothing returns nothing
    set gg_trg_Mid_Crossbow_Talk_Enable=CreateTrigger()
    call DisableTrigger(gg_trg_Mid_Crossbow_Talk_Enable)
    call TriggerAddAction(gg_trg_Mid_Crossbow_Talk_Enable,function Trig_Mid_Crossbow_Talk_Enable_Actions)
endfunction

// Creates part 1 of 2 of this module's triggers. Called once at startup from
// Startup_RegisterTriggers (MapBootstrap). The parts are registered at different points so that
// triggers sharing an event with other modules keep their original firing order.
function RegisterTriggers_Mid_Part1 takes nothing returns nothing
    call Register_Mid_Cage_Ping() // starts off; enabled by Cid; disabled by Mid, Ending; destroyed by Mid
    call Register_Mid_Freed() // starts off; enabled by BanditLord
endfunction

// Creates part 2 of 2 of this module's triggers. Called once at startup from
// Startup_RegisterTriggers (MapBootstrap). The parts are registered at different points so that
// triggers sharing an event with other modules keep their original firing order.
function RegisterTriggers_Mid_Part2 takes nothing returns nothing
    call Register_Mid_Letter_Give() // starts off; enabled by KalmSiege1
    call Register_Mid_Letter_Ping() // starts off; enabled by Mid, Epilogue; disabled by Giott
    call Register_Mid_Crossbow_Talk_Enable() // starts off; run by Giott
endfunction

endlibrary
