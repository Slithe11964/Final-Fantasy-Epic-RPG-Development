library TQuestOmegaWeapon requires TQuestEngine, TMusic
// Side quest "Omega Weapon", written for the quest engine (QuestEngine module, docs/QUEST_ENGINE.md).
// The quest starts when the party first attacks Omega Weapon (Ultima Weapon's death enables
// gg_trg_Quest_OmegaWeapon_Start) and is done when it dies. Does not count toward the story.
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Quest_OmegaWeapon_Start=null
    // The quest's number in the quest engine (0 until it is defined).
    integer QUEST_OMEGA_WEAPON=0
endglobals

function QuestOmegaWeapon_Cond_TrackBossKill takes nothing returns boolean
    return(udg_SpeedrunMode)
endfunction

function QuestOmegaWeapon_Cond_NotRewarded takes nothing returns boolean
    return(IsPlayerInForce(GetEnumPlayer(),udg_TitleForce[26])==false)and(IsPlayerInForce(GetEnumPlayer(),udg_TitleForce[25]))
endfunction

function QuestOmegaWeapon_Reward_EachPlayer takes nothing returns nothing
    if(QuestOmegaWeapon_Cond_NotRewarded())then
        set udg_TempPlayer=GetEnumPlayer()
        set udg_TempInteger=26
        call ConditionalTriggerExecute(gg_trg_Title_Grant)
    endif
endfunction

// Quest done (Omega Weapon died): it drops the Curse: Ultimate Weapon; a bonus arena battle opens, Almighty
// Shinra may appear, a random promotion is awarded, and players with the Ultima Weapon title get Omega's.
function QuestOmegaWeapon_Slain takes nothing returns nothing
    if(QuestOmegaWeapon_Cond_TrackBossKill())then
        set udg_BossUnit=gg_unit_N022_0125
        call ConditionalTriggerExecute(gg_trg_Speedrun_Accolade)
    endif
    call Music_ClearTrack(47)
    call GroupRemoveUnitSimple(gg_unit_N022_0125,udg_BossGroup)
    call CreateItem('I0ES',GetUnitX(gg_unit_N022_0125),GetUnitY(gg_unit_N022_0125)) // 'I0ES': item "Curse: Ultimate Weapon"
    // the log text changes once more after the quest is completed (Quest_SetLog only works while active)
    call QuestSetDescriptionBJ(Quest_LogEntry(QUEST_OMEGA_WEAPON),"You're incredible! You've defeated Omega Weapon! Surely nothing stands in your way now.")
    set udg_ArenaBonusBattle[0]=(udg_ArenaBonusBattle[0]+1)
    set udg_ArenaBonusBattle[udg_ArenaBonusBattle[0]]=3
    call ConditionalTriggerExecute(gg_trg_AlmightyShinra_Arm)
    call ConditionalTriggerExecute(gg_trg_Promotion_Award_Random)
    call ForForce(udg_PlayingPlayers,function QuestOmegaWeapon_Reward_EachPlayer)
endfunction

function QuestOmegaWeapon_Define takes nothing returns nothing
    local integer q=Quest_Define("Omega Weapon",QUEST_SIDE,47,"ReplaceableTextures\\CommandButtons\\BTNPitLord.blp")
    set QUEST_OMEGA_WEAPON=q
    call Quest_NotStory(q)
    // 1. Attack Omega Weapon (gg_trg_Quest_OmegaWeapon_Start)
    call Quest_Custom(q,"Defeat Omega Weapon, the legendary unbeatable weapon putting even Ultima Weapon to shame.")
    // 2. Kill it
    call Quest_Kill(q,gg_unit_N022_0125,"")
    call Quest_OnDone(q,"QuestOmegaWeapon_Slain")
endfunction

// Step 1: Omega Weapon was attacked or damaged for the first time. It starts casting and its music plays.
function Trig_Quest_OmegaWeapon_Start_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    if QUEST_OMEGA_WEAPON==0 then
        call QuestOmegaWeapon_Define()
    endif
    call Quest_Start(QUEST_OMEGA_WEAPON,null,null)
    call EnableTrigger(gg_trg_OmegaWeapon_SpellRotation)
    call GroupAddUnitSimple(gg_unit_N022_0125,udg_BossGroup)
    call Music_SetTrack(47)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function InitTrig_Quest_OmegaWeapon takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Quest_Part15 (module Quest),
// which keeps the original registration order.

function Register_Quest_OmegaWeapon_Start takes nothing returns nothing
    set gg_trg_Quest_OmegaWeapon_Start=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_OmegaWeapon_Start)
    call TriggerRegisterUnitEvent(gg_trg_Quest_OmegaWeapon_Start,gg_unit_N022_0125,EVENT_UNIT_ATTACKED)
    call TriggerRegisterUnitEvent(gg_trg_Quest_OmegaWeapon_Start,gg_unit_N022_0125,EVENT_UNIT_DAMAGED)
    call TriggerAddAction(gg_trg_Quest_OmegaWeapon_Start,function Trig_Quest_OmegaWeapon_Start_Actions)
endfunction

endlibrary
