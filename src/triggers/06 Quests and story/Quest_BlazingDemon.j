library TQuestBlazingDemon requires TCam, TCine, TMusic, TPlayerPart01, TReward, TText, TWait
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Quest_BlazingDemon_Start=null
    trigger gg_trg_Quest_BlazingDemon_EndWeak=null
    trigger gg_trg_Quest_BlazingDemon_End=null
    trigger gg_trg_Quest_BlazingDemon_Escape=null
endglobals

function Trig_Quest_BlazingDemon_Start_Cond_LowDifficulty takes nothing returns boolean
    return(udg_Difficulty<=3)
endfunction

function Trig_Quest_BlazingDemon_Start_Actions takes nothing returns nothing
    call PauseUnitBJ(false,gg_unit_U00G_0220)
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_DISCOVERED,"New Quest Received: |cffffcc00Blazing Demon|r")
    set udg_SideQuest[51]=CreateQuestBJ(bj_QUESTTYPE_REQ_DISCOVERED,(udg_QuestNamePrefix+"Blazing Demon"),"The time has finally come to face McBurn, also known as the Almighty Conflagration or the Blazing Demon, himself.","ReplaceableTextures\\CommandButtons\\BTNEredarWarlockPurple.blp")
    call GroupAddUnitSimple(gg_unit_U00G_0220,udg_BossGroup)
    call GroupAddUnitSimple(gg_unit_U00G_0220,udg_BossUnits)
    call SetUnitInvulnerable(gg_unit_U00G_0220,false)
    call Music_SetTrack(33)
    set udg_ScriptedBossUnit=gg_unit_U00G_0220
    if(Trig_Quest_BlazingDemon_Start_Cond_LowDifficulty())then
        call EnableTrigger(gg_trg_Quest_BlazingDemon_EndWeak)
        call DestroyTrigger(gg_trg_BlazingDemon_FullHeat)
        call DestroyTrigger(gg_trg_Quest_BlazingDemon_End)
        call DestroyTrigger(gg_trg_Quest_BlazingDemon_Escape)
    else
        call EnableTrigger(gg_trg_BlazingDemon_FullHeat)
        call DestroyTrigger(gg_trg_Quest_BlazingDemon_EndWeak)
    endif
endfunction

function Trig_Quest_BlazingDemon_EndWeak_Cond_TrackBossKill takes nothing returns boolean
    return(udg_SpeedrunMode)
endfunction

function Trig_Quest_BlazingDemon_EndWeak_Cond_ShowDialog takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_BlazingDemon_EndWeak_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    if(Trig_Quest_BlazingDemon_EndWeak_Cond_TrackBossKill())then
        set udg_BossUnit=GetTriggerUnit()
        call ConditionalTriggerExecute(gg_trg_Speedrun_Accolade)
    endif
    call GroupRemoveUnitSimple(gg_unit_U00G_0220,udg_BossGroup)
    call GroupRemoveUnitSimple(gg_unit_U00G_0220,udg_BossUnits)
    if(Trig_Quest_BlazingDemon_EndWeak_Cond_ShowDialog())then
        set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
        call ReviveHeroLoc(gg_unit_U00G_0220,udg_TempPoint,false)
        call RemoveLocation(udg_TempPoint)
        call SetUnitVertexColorBJ(gg_unit_U00G_0220,'d',25.,25.,0)
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_U00G_0220,.0)
        call Text_Say(gg_unit_U00G_0220,"That wasn't a bad fight. You got some bite to go with your bark.",false)
        call Text_Say(gg_unit_U00G_0220,"But I can tell you aren't quite hardened up enough to take my heat at full force.",false)
        call Text_Say(gg_unit_U00G_0220,"I'm looking for someone who can withstand a much |cffcc2222harder|r challenge.",false)
        call Text_Say(gg_unit_U00G_0220,"But feels good to heat up a bit more. You can have this.",false)
        call Reward_Give($2710,$2710,gg_unit_U00G_0220) // $2710 = 10000
        set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        call Wait_Polled(.5)
        call Cine_ExitAction()
        set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    else
        call Reward_Give($2710,$2710,gg_unit_U00G_0220) // $2710 = 10000
        set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
    endif
    call CreateItemLoc('I01Z',udg_TempPoint) // 'I01Z': item "Crystal Shard"
    call CreateItemLoc('I01Z',udg_TempPoint) // 'I01Z': item "Crystal Shard"
    call CreateItemLoc('I01Z',udg_TempPoint) // 'I01Z': item "Crystal Shard"
    call CreateItemLoc('I01Z',udg_TempPoint) // 'I01Z': item "Crystal Shard"
    call CreateItemLoc('I01Z',udg_TempPoint) // 'I01Z': item "Crystal Shard"
    call RemoveLocation(udg_TempPoint)
    call RemoveUnit(gg_unit_U00G_0220)
    call Music_ClearTrack(33)
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_COMPLETED,"Quest Completed: |cffffcc00Blazing Demon|r")
    call QuestSetCompletedBJ(udg_SideQuest[51],true)
    set udg_QuestsCompleted=(udg_QuestsCompleted+1)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Quest_BlazingDemon_End_Cond_TrackBossKill takes nothing returns boolean
    return(udg_SpeedrunMode)
endfunction

function Trig_Quest_BlazingDemon_End_Cond_ShowDialog takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_BlazingDemon_End_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    if(Trig_Quest_BlazingDemon_End_Cond_TrackBossKill())then
        set udg_BossUnit=GetTriggerUnit()
        call ConditionalTriggerExecute(gg_trg_Speedrun_Accolade)
    endif
    call GroupRemoveUnitSimple(gg_unit_U00G_0220,udg_BossGroup)
    call GroupRemoveUnitSimple(gg_unit_U00G_0220,udg_BossUnits)
    if(Trig_Quest_BlazingDemon_End_Cond_ShowDialog())then
        set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
        call ReviveHeroLoc(gg_unit_U00G_0220,udg_TempPoint,false)
        call RemoveLocation(udg_TempPoint)
        call SetUnitVertexColorBJ(gg_unit_U00G_0220,'d',25.,25.,0)
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_U00G_0220,.0)
        call Text_Say(gg_unit_U00G_0220,"Haha. Man that was fun.",false)
        call Text_Say(gg_unit_U00G_0220,"But I think it's time we called it quits. If I turn it up any higher there won't be anything left of you.",false)
        call Text_Say(gg_unit_U00G_0220,"Sorry, but I'm looking for someone who can withstand a true |cffdd0000Inferno|r.",false)
        call Text_Say(gg_unit_U00G_0220,"Thanks for the fight though. That was the good stuff.",false)
        call Reward_Give($2710,$2710,gg_unit_U00G_0220) // $2710 = 10000
        set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        call Wait_Polled(.5)
        call Cine_ExitAction()
        set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    else
        call Reward_Give($2710,$2710,gg_unit_U00G_0220) // $2710 = 10000
        set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
    endif
    call CreateItemLoc('I01Z',udg_TempPoint) // 'I01Z': item "Crystal Shard"
    call CreateItemLoc('I01Z',udg_TempPoint) // 'I01Z': item "Crystal Shard"
    call CreateItemLoc('I01Z',udg_TempPoint) // 'I01Z': item "Crystal Shard"
    call CreateItemLoc('I01Z',udg_TempPoint) // 'I01Z': item "Crystal Shard"
    call CreateItemLoc('I01Z',udg_TempPoint) // 'I01Z': item "Crystal Shard"
    call RemoveLocation(udg_TempPoint)
    call RemoveUnit(gg_unit_U00G_0220)
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_COMPLETED,"Quest Completed: |cffffcc00Blazing Demon|r")
    call QuestSetCompletedBJ(udg_SideQuest[51],true)
    call Music_ClearTrack(33)
    set udg_QuestsCompleted=(udg_QuestsCompleted+1)
    call ConditionalTriggerExecute(gg_trg_Promotion_Award_Random)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Quest_BlazingDemon_Escape_Cond_KilledByPlayer takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetKillingUnitBJ()),udg_PlayingPlayers))
endfunction

function Trig_Quest_BlazingDemon_Escape_Cond_ShowDialog takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_BlazingDemon_Escape_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call GroupRemoveUnitSimple(gg_unit_U00G_0220,udg_BossGroup)
    call GroupRemoveUnitSimple(gg_unit_U00G_0220,udg_BossUnits)
    if(Trig_Quest_BlazingDemon_Escape_Cond_ShowDialog())then
        set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
        call ReviveHeroLoc(gg_unit_U00G_0220,udg_TempPoint,false)
        call RemoveLocation(udg_TempPoint)
        call SetUnitVertexColorBJ(gg_unit_U00G_0220,'d',25.,25.,0)
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_U00G_0220,.0)
        call Text_Say(gg_unit_U00G_0220,"|cffffc0c0Hahaha! You're really damn good!|r",false)
        call Text_Say(gg_unit_U00G_0220,"|cffff8080More... more heat...!|r",false)
        call Text_Say(gg_unit_U00G_0220,"|cffff4040Let everything go up in flames!!|r",false)
        call Text_Say(gg_unit_U00G_0220,"|cffff0000Burn everything to cinders!!!|r",false)
        set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        call Wait_Polled(.5)
        call RemoveUnit(gg_unit_U00G_0220)
        call Wait_Polled(1.)
        if(Trig_Quest_BlazingDemon_Escape_Cond_KilledByPlayer())then
            set udg_TempPlayer=GetOwningPlayer(GetKillingUnitBJ())
        else
            set udg_TempPlayer=ForcePickRandomPlayer(udg_PlayingPlayers)
        endif
        call Text_Say(Player_GetHero(udg_TempPlayer),"Where did he go? I have a bad feeling about this... we better find him again, or this world won't be for long...",false)
        call Cine_ExitAction()
    else
        set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        call RemoveUnit(gg_unit_U00G_0220)
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_COMPLETED,"Quest Completed: |cffffcc00Blazing Demon|r")
    call QuestSetCompletedBJ(udg_SideQuest[51],true)
    set udg_QuestsCompleted=(udg_QuestsCompleted+1)
    call ConditionalTriggerExecute(gg_trg_Promotion_Award_Random)
    set udg_QuestsTotal=(udg_QuestsTotal+1)
    call Music_ClearTrack(33)
    call EnableTrigger(gg_trg_ScorchedEarth_Omen)
    call StartTimerBJ(udg_ScorchedEarthTimer,false,600.)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function InitTrig_Quest_BlazingDemon takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Quest_Part15, RegisterTriggers_Quest_Part16 (module Quest),
// which keeps the original registration order.

function Register_Quest_BlazingDemon_Start takes nothing returns nothing
    set gg_trg_Quest_BlazingDemon_Start=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_BlazingDemon_Start)
    call TriggerAddAction(gg_trg_Quest_BlazingDemon_Start,function Trig_Quest_BlazingDemon_Start_Actions)
endfunction

function Register_Quest_BlazingDemon_EndWeak takes nothing returns nothing
    set gg_trg_Quest_BlazingDemon_EndWeak=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_BlazingDemon_EndWeak)
    call TriggerRegisterUnitEvent(gg_trg_Quest_BlazingDemon_EndWeak,gg_unit_U00G_0220,EVENT_UNIT_DEATH)
    call TriggerAddAction(gg_trg_Quest_BlazingDemon_EndWeak,function Trig_Quest_BlazingDemon_EndWeak_Actions)
endfunction

function Register_Quest_BlazingDemon_End takes nothing returns nothing
    set gg_trg_Quest_BlazingDemon_End=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_BlazingDemon_End)
    call TriggerRegisterUnitEvent(gg_trg_Quest_BlazingDemon_End,gg_unit_U00G_0220,EVENT_UNIT_DEATH)
    call TriggerAddAction(gg_trg_Quest_BlazingDemon_End,function Trig_Quest_BlazingDemon_End_Actions)
endfunction

function Register_Quest_BlazingDemon_Escape takes nothing returns nothing
    set gg_trg_Quest_BlazingDemon_Escape=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_BlazingDemon_Escape)
    call TriggerRegisterUnitEvent(gg_trg_Quest_BlazingDemon_Escape,gg_unit_U00G_0220,EVENT_UNIT_DEATH)
    call TriggerAddAction(gg_trg_Quest_BlazingDemon_Escape,function Trig_Quest_BlazingDemon_Escape_Actions)
endfunction

endlibrary
