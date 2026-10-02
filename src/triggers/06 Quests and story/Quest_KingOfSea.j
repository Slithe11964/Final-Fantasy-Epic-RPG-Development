library TQuestKingOfSea requires TCam, TCine, TPlayerHero, TReward, TText
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Quest_KingOfSea_Slain=null
    trigger gg_trg_Quest_KingOfSea_Reward=null
endglobals

function Trig_Quest_KingOfSea_Slain_Cond_TrackBossKill takes nothing returns boolean
    return(udg_SpeedrunMode)
endfunction

function Trig_Quest_KingOfSea_Slain_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    if(Trig_Quest_KingOfSea_Slain_Cond_TrackBossKill())then
        set udg_BossUnit=GetTriggerUnit()
        call ConditionalTriggerExecute(gg_trg_Speedrun_Accolade)
    endif
    call GroupRemoveUnitSimple(gg_unit_H02W_0246,udg_BossGroup)
    call GroupRemoveUnitSimple(gg_unit_H02W_0246,udg_BossUnits)
    call PauseTimerBJ(true,udg_NebraKingTimer)
    set udg_FishLoot[90]='I0GW' // 'I0GW': item "Gold Fish"
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateItemLoc('I0GR',udg_TempPoint) // 'I0GR': item "Nebra King Head"
    call SetItemInvulnerableBJ(GetLastCreatedItem(),true)
    call CreateItemLoc('I01Z',udg_TempPoint) // 'I01Z': item "Crystal Shard"
    call CreateItemLoc('I01Z',udg_TempPoint) // 'I01Z': item "Crystal Shard"
    call CreateItemLoc('I01Z',udg_TempPoint) // 'I01Z': item "Crystal Shard"
    call CreateItemLoc('I01Z',udg_TempPoint) // 'I01Z': item "Crystal Shard"
    call CreateItemLoc('I01Z',udg_TempPoint) // 'I01Z': item "Crystal Shard"
    call RemoveLocation(udg_TempPoint)
    call ConditionalTriggerExecute(gg_trg_Promotion_Award_Random)
    call QuestSetDescriptionBJ(udg_SideQuest[48],"You've taken down the Nebra King! Now show your achievement to someone who may be interested.")
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_UPDATED,"Show proof of your achievement to an interested party.")
    call DestroyTrigger(GetTriggeringTrigger())
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
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_COMPLETED,"Quest Completed: |cffffcc00King of the Sea|r")
    call QuestSetCompletedBJ(udg_SideQuest[48],true)
    set udg_QuestsCompleted=(udg_QuestsCompleted+1)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function InitTrig_Quest_KingOfSea takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Quest_Part15 (module Quest),
// which keeps the original registration order.

function Register_Quest_KingOfSea_Slain takes nothing returns nothing
    set gg_trg_Quest_KingOfSea_Slain=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_KingOfSea_Slain)
    call TriggerRegisterUnitEvent(gg_trg_Quest_KingOfSea_Slain,gg_unit_H02W_0246,EVENT_UNIT_DEATH)
    call TriggerAddAction(gg_trg_Quest_KingOfSea_Slain,function Trig_Quest_KingOfSea_Slain_Actions)
endfunction

function Register_Quest_KingOfSea_Reward takes nothing returns nothing
    set gg_trg_Quest_KingOfSea_Reward=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_KingOfSea_Reward)
    call TriggerRegisterUnitInRangeSimple(gg_trg_Quest_KingOfSea_Reward,450.,gg_unit_n0AV_0247)
    call TriggerAddCondition(gg_trg_Quest_KingOfSea_Reward,Condition(function Trig_Quest_KingOfSea_Reward_Conditions))
    call TriggerAddAction(gg_trg_Quest_KingOfSea_Reward,function Trig_Quest_KingOfSea_Reward_Actions)
endfunction

endlibrary
