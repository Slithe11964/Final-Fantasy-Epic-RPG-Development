library TQuestKingOfSea requires TQuestEngine, TCam, TCine, TPlayerHero, TReward, TText
// Side quest "King of the Sea", run by the quest engine (QuestEngine module, docs/QUEST_ENGINE.md).
// Fishing up the Nebra King (NebraKing module) starts it; kill him and show his head to Anabel. The
// hand-in stays a module trigger (enabled by Nebra Angler; its dialogue depends on how often he fled).
// Does not count toward the story.
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Quest_KingOfSea_Reward=null
    // The quest's number in the quest engine (0 until it is defined).
    integer QUEST_KING_OF_SEA=0
endglobals

// Step 2 done (the Nebra King is slain): his head and treasure drop.
function QuestKingOfSea_Slain takes nothing returns nothing
    local location l_tempPoint
    if udg_SpeedrunMode then
        set udg_BossUnit=gg_unit_H02W_0246
        call ConditionalTriggerExecute(gg_trg_Speedrun_Accolade)
    endif
    call GroupRemoveUnitSimple(gg_unit_H02W_0246,udg_BossGroup)
    call GroupRemoveUnitSimple(gg_unit_H02W_0246,udg_BossUnits)
    call PauseTimerBJ(true,udg_NebraKingTimer)
    set udg_FishLoot[90]='I0GW' // 'I0GW': item "Gold Fish"
    set l_tempPoint=GetUnitLoc(gg_unit_H02W_0246)
    call CreateItemLoc('I0GR',l_tempPoint) // 'I0GR': item "Nebra King Head"
    call SetItemInvulnerableBJ(GetLastCreatedItem(),true)
    call CreateItemLoc('I01Z',l_tempPoint) // 'I01Z': item "Crystal Shard"
    call CreateItemLoc('I01Z',l_tempPoint) // 'I01Z': item "Crystal Shard"
    call CreateItemLoc('I01Z',l_tempPoint) // 'I01Z': item "Crystal Shard"
    call CreateItemLoc('I01Z',l_tempPoint) // 'I01Z': item "Crystal Shard"
    call CreateItemLoc('I01Z',l_tempPoint) // 'I01Z': item "Crystal Shard"
    call RemoveLocation(l_tempPoint)
    call ConditionalTriggerExecute(gg_trg_Promotion_Award_Random)
    set l_tempPoint=null
endfunction

function QuestKingOfSea_Define takes nothing returns nothing
    local integer q=Quest_Define("King of the Sea",QUEST_SIDE,48,"ReplaceableTextures\\CommandButtons\\BTNMurlocFlesheater.blp")
    set QUEST_KING_OF_SEA=q
    call Quest_NotStory(q)
    call Quest_NoMarker(q)
    // 1. The Nebra King is fished up for the first time (QuestKingOfSea_Summoned, from NebraKing_Summon)
    call Quest_Custom(q,"Defeat the Nebra King!")
    // 2. Kill the Nebra King
    call Quest_Kill(q,gg_unit_H02W_0246,"You've taken down the Nebra King! Now show your achievement to someone who may be interested.")
    call Quest_Message(q,"Show proof of your achievement to an interested party.")
    call Quest_OnDone(q,"QuestKingOfSea_Slain")
    // 3. Show his head to Anabel (gg_trg_Quest_KingOfSea_Reward)
    call Quest_Custom(q,"")
endfunction

// Called by NebraKing_Summon (through ExecuteFunc) each time the Nebra King is fished up.
function QuestKingOfSea_Summoned takes nothing returns nothing
    if IsQuestDiscovered(udg_SideQuest[48])==false then
        if QUEST_KING_OF_SEA==0 then
            call QuestKingOfSea_Define()
        endif
        call Quest_Start(QUEST_KING_OF_SEA,null,null)
    else
        // the log text and the announcement differ, so the announcement is shown here
        call Quest_SetLog(QUEST_KING_OF_SEA,"Kill the Nebra King!",false)
        call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_UPDATED,"Kill the Nebra King.")
    endif
endfunction

// Called by NebraKing_Escape (through ExecuteFunc) when the Nebra King dives away.
function QuestKingOfSea_Escaped takes nothing returns nothing
    call Quest_SetLog(QUEST_KING_OF_SEA,"The Nebra King has disappeared! Find him again!",false)
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_UPDATED,"Find the Nebra King again.")
endfunction

function Trig_Quest_KingOfSea_Reward_Conditions takes nothing returns boolean
    return((UnitHasItemOfTypeBJ(GetTriggerUnit(),'I0GR'))and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(udg_InCinematicMode==false))!=null // 'I0GR': item "Nebra King Head"
endfunction

function Trig_Quest_KingOfSea_Reward_Cond_FledManyTimes takes nothing returns boolean
    return(GetTriggerExecCount(gg_trg_NebraKing_Escape)>2)
endfunction

function Trig_Quest_KingOfSea_Reward_Cond_FledOnce takes nothing returns boolean
    return(GetTriggerExecCount(gg_trg_NebraKing_Escape)>0)
endfunction

function Trig_Quest_KingOfSea_Reward_Cond_ShowDialog takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_KingOfSea_Reward_Cond_FishingQuestDone takes nothing returns boolean
    return(IsQuestCompleted(udg_SideQuest[71]))
endfunction

function Trig_Quest_KingOfSea_Reward_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I0GR')) // 'I0GR': item "Nebra King Head"
    if(Trig_Quest_KingOfSea_Reward_Cond_ShowDialog())then
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_n0AV_0247,0)
        call Text_Say(gg_unit_n0AV_0247,"Is... is that what I think it is!?",false)
        call Text_Say(gg_unit_n0AV_0247,"I can't believe it... you've actually slain the Nebra King?",false)
        if(Trig_Quest_KingOfSea_Reward_Cond_FledOnce())then
            if(Trig_Quest_KingOfSea_Reward_Cond_FledManyTimes())then
                call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"We did. It wasn't easy either. He ran away from us several times and we had to hunt him down all over again.",false)
            else
                call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"We did. It wasn't easy either. He ran away from us and we had to hunt him down all over again.",false)
            endif
        else
            call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"We did. It wasn't easy either. He's a real tough cookie.",false)
        endif
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"But we did it in the end.",false)
        call Text_Say(gg_unit_n0AV_0247,"I... I must have it! I'll buy it from you with all the gold I ever fished up! Just give me the head!!",false)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"Whoa, are you okay?",false)
        call Text_Say(gg_unit_n0AV_0247,"Right, uh, sorry. You've really done it, you've accomplished what no other angler has done before in this world.",false)
        call Text_Say(gg_unit_n0AV_0247,"Now give me that head, I need it!\r\n\r\n|cffffcc00Anabel forcefully grabs the Nebra King's head from you and shoves a reward into your pockets.|r",false)
        call Reward_Give($4E20,$4E20,gg_unit_n0AV_0247) // $4E20 = 20000
        call Text_Say(gg_unit_n0AV_0247,"|n|cffffcc00A new artifact is available for buying at the Ancient of Wonders.|r",true)
        call Cine_ExitAction()
    else
        call Reward_Give($4E20,$4E20,gg_unit_n0AV_0247) // $4E20 = 20000
        call DisplayTimedTextToForce(udg_PlayingPlayers,10.,"|cffffcc00A new artifact is available for buying at the Ancient of Wonders.|r")
    endif
    call RemoveItemFromStockBJ('I0EZ',gg_unit_n00L_0153) // 'I0EZ': item "Muramata"
    call AddItemToStockBJ('I0GZ',gg_unit_n00L_0153,1,1) // 'I0GZ': item "Nebra Suit"
    if(Trig_Quest_KingOfSea_Reward_Cond_FishingQuestDone())then
        set udg_ArenaBonusBattle[0]=(udg_ArenaBonusBattle[0]+1)
        set udg_ArenaBonusBattle[udg_ArenaBonusBattle[0]]=$BA // $BA = 186
    endif
    call Quest_StepDone(QUEST_KING_OF_SEA,GetOwningPlayer(GetTriggerUnit()),GetTriggerUnit())
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function InitTrig_Quest_KingOfSea takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Quest_Part15 (module Quest),
// which keeps the original registration order.

function Register_Quest_KingOfSea_Reward takes nothing returns nothing
    set gg_trg_Quest_KingOfSea_Reward=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_KingOfSea_Reward)
    call TriggerRegisterUnitInRangeSimple(gg_trg_Quest_KingOfSea_Reward,450.,gg_unit_n0AV_0247)
    call TriggerAddCondition(gg_trg_Quest_KingOfSea_Reward,Condition(function Trig_Quest_KingOfSea_Reward_Conditions))
    call TriggerAddAction(gg_trg_Quest_KingOfSea_Reward,function Trig_Quest_KingOfSea_Reward_Actions)
endfunction

endlibrary
