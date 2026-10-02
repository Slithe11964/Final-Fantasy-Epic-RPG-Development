library TQuestOmegaWeapon requires TMusic
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Quest_OmegaWeapon_Start=null
    trigger gg_trg_Quest_OmegaWeapon_Slain=null
endglobals

function Trig_Quest_OmegaWeapon_Start_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_DISCOVERED,"New Quest Received: |cffffcc00Omega Weapon|r")
    set udg_SideQuest[47]=CreateQuestBJ(bj_QUESTTYPE_REQ_DISCOVERED,(udg_QuestNamePrefix+"Omega Weapon"),"Defeat Omega Weapon, the legendary unbeatable weapon putting even Ultima Weapon to shame.","ReplaceableTextures\\CommandButtons\\BTNPitLord.blp")
    call EnableTrigger(gg_trg_OmegaWeapon_SpellRotation)
    call EnableTrigger(gg_trg_Quest_OmegaWeapon_Slain)
    call GroupAddUnitSimple(gg_unit_N022_0125,udg_BossGroup)
    call Music_SetTrack(47)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Quest_OmegaWeapon_Slain_Cond_TrackBossKill takes nothing returns boolean
    return(udg_SpeedrunMode)
endfunction

function Trig_Quest_OmegaWeapon_Slain_Cond_NotRewarded takes nothing returns boolean
    return(IsPlayerInForce(GetEnumPlayer(),udg_TitleForce[26])==false)and(IsPlayerInForce(GetEnumPlayer(),udg_TitleForce[25]))
endfunction

function Trig_Quest_OmegaWeapon_Slain_Reward_EachPlayer takes nothing returns nothing
    if(Trig_Quest_OmegaWeapon_Slain_Cond_NotRewarded())then
        set udg_TempPlayer=GetEnumPlayer()
        set udg_TempInteger=26
        call ConditionalTriggerExecute(gg_trg_Title_Grant)
    endif
endfunction

function Trig_Quest_OmegaWeapon_Slain_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    if(Trig_Quest_OmegaWeapon_Slain_Cond_TrackBossKill())then
        set udg_BossUnit=GetTriggerUnit()
        call ConditionalTriggerExecute(gg_trg_Speedrun_Accolade)
    endif
    call Music_ClearTrack(47)
    call GroupRemoveUnitSimple(gg_unit_N022_0125,udg_BossGroup)
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateItemLoc('I0ES',udg_TempPoint) // 'I0ES': item "Curse: Ultimate Weapon"
    call RemoveLocation(udg_TempPoint)
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_COMPLETED,"Quest Completed: |cffffcc00Omega Weapon|r")
    call QuestSetCompletedBJ(udg_SideQuest[47],true)
    set udg_QuestsCompleted=(udg_QuestsCompleted+1)
    call QuestSetDescriptionBJ(udg_SideQuest[47],"You're incredible! You've defeated Omega Weapon! Surely nothing stands in your way now.")
    set udg_ArenaBonusBattle[0]=(udg_ArenaBonusBattle[0]+1)
    set udg_ArenaBonusBattle[udg_ArenaBonusBattle[0]]=3
    call ConditionalTriggerExecute(gg_trg_AlmightyShinra_Arm)
    call ConditionalTriggerExecute(gg_trg_Promotion_Award_Random)
    call ForForce(udg_PlayingPlayers,function Trig_Quest_OmegaWeapon_Slain_Reward_EachPlayer)
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

function Register_Quest_OmegaWeapon_Slain takes nothing returns nothing
    set gg_trg_Quest_OmegaWeapon_Slain=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_OmegaWeapon_Slain)
    call TriggerRegisterUnitEvent(gg_trg_Quest_OmegaWeapon_Slain,gg_unit_N022_0125,EVENT_UNIT_DEATH)
    call TriggerAddAction(gg_trg_Quest_OmegaWeapon_Slain,function Trig_Quest_OmegaWeapon_Slain_Actions)
endfunction

endlibrary
