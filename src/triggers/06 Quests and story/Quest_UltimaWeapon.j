library TQuestUltimaWeapon requires TQuestEngine, TMusic
// Side quest "Ultima Weapon", written for the quest engine (QuestEngine module, docs/QUEST_ENGINE.md).
// The quest starts when the party first attacks Ultima Weapon behind the Tonberry gate (Tonberry enables
// gg_trg_Quest_UltimaWeapon_Start) and is done when it dies. Does not count toward the story.
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Quest_UltimaWeapon_Start=null
    // The quest's number in the quest engine (0 until it is defined).
    integer QUEST_ULTIMA_WEAPON=0
endglobals

function QuestUltimaWeapon_Cond_TrackBossKill takes nothing returns boolean
    return(udg_SpeedrunMode)
endfunction

function QuestUltimaWeapon_Cond_HiddenQuest8Done takes nothing returns boolean
    return(IsQuestCompleted(udg_MainQuest[8]))
endfunction

function QuestUltimaWeapon_Cond_Quest29Done takes nothing returns boolean
    return(IsQuestCompleted(udg_SideQuest[29]))
endfunction

function QuestUltimaWeapon_Cond_NotRewarded takes nothing returns boolean
    return(IsPlayerInForce(GetEnumPlayer(),udg_TitleForce[25])==false)
endfunction

function QuestUltimaWeapon_Reward_EachPlayer takes nothing returns nothing
    if(QuestUltimaWeapon_Cond_NotRewarded())then
        set udg_TempPlayer=GetEnumPlayer()
        set udg_TempInteger=25
        call ConditionalTriggerExecute(gg_trg_Title_Grant)
    endif
endfunction

// Quest done (Ultima Weapon died): it drops the Ultimate Weapon; Omega Weapon can be challenged (and shows
// up if World Liberation is done); Priscilla offers her Eidolon fight if Spirit of Water is done; every
// player gets the Ultima Weapon title.
function QuestUltimaWeapon_Slain takes nothing returns nothing
    if(QuestUltimaWeapon_Cond_TrackBossKill())then
        set udg_BossUnit=gg_unit_Nman_0151
        call ConditionalTriggerExecute(gg_trg_Speedrun_Accolade)
    endif
    call GroupRemoveUnitSimple(gg_unit_Nman_0151,udg_BossGroup)
    call Music_ClearTrack(23)
    call CreateItem('I00S',GetUnitX(gg_unit_Nman_0151),GetUnitY(gg_unit_Nman_0151)) // 'I00S': item "Ultimate Weapon"
    // the log text changes once more after the quest is completed (Quest_SetLog only works while active)
    call QuestSetDescriptionBJ(Quest_LogEntry(QUEST_ULTIMA_WEAPON),"You defeated Ultima Weapon! You've proven to be an incredibly strong fighter!")
    if(QuestUltimaWeapon_Cond_HiddenQuest8Done())then
        call SetUnitInvulnerable(gg_unit_N022_0125,false)
        call PauseUnitBJ(false,gg_unit_N022_0125)
        call ShowUnitShow(gg_unit_N022_0125)
    endif
    call EnableTrigger(gg_trg_Quest_OmegaWeapon_Start)
    if(QuestUltimaWeapon_Cond_Quest29Done())then
        call ConditionalTriggerExecute(gg_trg_Priscilla_ShowMarker_Eden)
    endif
    call SaveIntegerBJ(1,2,2,udg_GameStateHash)
    call ForForce(udg_PlayingPlayers,function QuestUltimaWeapon_Reward_EachPlayer)
endfunction

function QuestUltimaWeapon_Define takes nothing returns nothing
    local integer q=Quest_Define("Ultima Weapon",QUEST_SIDE,46,"ReplaceableTextures\\CommandButtons\\BTNMannoroth.blp")
    set QUEST_ULTIMA_WEAPON=q
    call Quest_NotStory(q)
    // 1. Attack Ultima Weapon (gg_trg_Quest_UltimaWeapon_Start)
    call Quest_Custom(q,"Defeat Ultima Weapon.")
    // 2. Kill it
    call Quest_Kill(q,gg_unit_Nman_0151,"")
    call Quest_OnDone(q,"QuestUltimaWeapon_Slain")
endfunction

// Step 1: Ultima Weapon was attacked or damaged for the first time. Its music starts.
function Trig_Quest_UltimaWeapon_Start_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call GroupAddUnitSimple(gg_unit_Nman_0151,udg_BossGroup)
    if QUEST_ULTIMA_WEAPON==0 then
        call QuestUltimaWeapon_Define()
    endif
    call Quest_Start(QUEST_ULTIMA_WEAPON,null,null)
    call Music_SetTrack(23)
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

endlibrary
