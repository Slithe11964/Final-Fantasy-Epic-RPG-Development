library TQuestUltimaWeapon requires TMusic
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Quest_UltimaWeapon_Start=null
    trigger gg_trg_Quest_UltimaWeapon_Slain=null
endglobals

function Trig_Quest_UltimaWeapon_Start_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call EnableTrigger(gg_trg_Quest_UltimaWeapon_Slain)
    call GroupAddUnitSimple(gg_unit_Nman_0151,udg_BossGroup)
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_DISCOVERED,"New Quest Received: |cffffcc00Ultima Weapon|r")
    set udg_SideQuest[46]=CreateQuestBJ(bj_QUESTTYPE_REQ_DISCOVERED,(udg_QuestNamePrefix+"Ultima Weapon"),"Defeat Ultima Weapon.","ReplaceableTextures\\CommandButtons\\BTNMannoroth.blp")
    call Music_SetTrack(23)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Quest_UltimaWeapon_Slain_Cond_TrackBossKill takes nothing returns boolean
    return(udg_SpeedrunMode)
endfunction

function Trig_Quest_UltimaWeapon_Slain_Cond_HiddenQuest8Done takes nothing returns boolean
    return(IsQuestCompleted(udg_MainQuest[8]))
endfunction

function Trig_Quest_UltimaWeapon_Slain_Cond_Quest29Done takes nothing returns boolean
    return(IsQuestCompleted(udg_SideQuest[29]))
endfunction

function Trig_Quest_UltimaWeapon_Slain_Cond_NotRewarded takes nothing returns boolean
    return(IsPlayerInForce(GetEnumPlayer(),udg_TitleForce[25])==false)
endfunction

function Trig_Quest_UltimaWeapon_Slain_Reward_EachPlayer takes nothing returns nothing
    if(Trig_Quest_UltimaWeapon_Slain_Cond_NotRewarded())then
        set udg_TempPlayer=GetEnumPlayer()
        set udg_TempInteger=25
        call ConditionalTriggerExecute(gg_trg_Title_Grant)
    endif
endfunction

function Trig_Quest_UltimaWeapon_Slain_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    if(Trig_Quest_UltimaWeapon_Slain_Cond_TrackBossKill())then
        set udg_BossUnit=GetTriggerUnit()
        call ConditionalTriggerExecute(gg_trg_Speedrun_Accolade)
    endif
    call GroupRemoveUnitSimple(gg_unit_Nman_0151,udg_BossGroup)
    call Music_ClearTrack(23)
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateItemLoc('I00S',udg_TempPoint) // 'I00S': item "Ultimate Weapon"
    call RemoveLocation(udg_TempPoint)
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_COMPLETED,"Quest Completed: |cffffcc00Ultima Weapon|r")
    call QuestSetCompletedBJ(udg_SideQuest[46],true)
    set udg_QuestsCompleted=(udg_QuestsCompleted+1)
    call QuestSetDescriptionBJ(udg_SideQuest[46],"You defeated Ultima Weapon! You've proven to be an incredibly strong fighter!")
    if(Trig_Quest_UltimaWeapon_Slain_Cond_HiddenQuest8Done())then
        call SetUnitInvulnerable(gg_unit_N022_0125,false)
        call PauseUnitBJ(false,gg_unit_N022_0125)
        call ShowUnitShow(gg_unit_N022_0125)
    endif
    call EnableTrigger(gg_trg_Quest_OmegaWeapon_Start)
    if(Trig_Quest_UltimaWeapon_Slain_Cond_Quest29Done())then
        call ConditionalTriggerExecute(gg_trg_Priscilla_ShowMarker_Eden)
    endif
    call SaveIntegerBJ(1,2,2,udg_GameStateHash)
    call ForForce(udg_PlayingPlayers,function Trig_Quest_UltimaWeapon_Slain_Reward_EachPlayer)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function InitTrig_Quest_UltimaWeapon takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Quest_Part15 (module Quest),
// which keeps the original registration order.

function Register_Quest_UltimaWeapon_Start takes nothing returns nothing
    set gg_trg_Quest_UltimaWeapon_Start=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_UltimaWeapon_Start)
    call TriggerRegisterUnitEvent(gg_trg_Quest_UltimaWeapon_Start,gg_unit_Nman_0151,EVENT_UNIT_DAMAGED)
    call TriggerRegisterUnitEvent(gg_trg_Quest_UltimaWeapon_Start,gg_unit_Nman_0151,EVENT_UNIT_ATTACKED)
    call TriggerAddAction(gg_trg_Quest_UltimaWeapon_Start,function Trig_Quest_UltimaWeapon_Start_Actions)
endfunction

function Register_Quest_UltimaWeapon_Slain takes nothing returns nothing
    set gg_trg_Quest_UltimaWeapon_Slain=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_UltimaWeapon_Slain)
    call TriggerRegisterUnitEvent(gg_trg_Quest_UltimaWeapon_Slain,gg_unit_Nman_0151,EVENT_UNIT_DEATH)
    call TriggerAddAction(gg_trg_Quest_UltimaWeapon_Slain,function Trig_Quest_UltimaWeapon_Slain_Actions)
endfunction

endlibrary
