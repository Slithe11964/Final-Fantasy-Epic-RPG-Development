library TBossExodus requires TCam, TCine, TMusic, TPlayerPart01, TReward, TText
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Boss_Exodus_Death=null
endglobals

function Trig_Boss_Exodus_Death_TrackBossKills takes nothing returns boolean
    return(udg_SpeedrunMode)
endfunction

function Trig_Boss_Exodus_Death_DyingIsHero takes nothing returns boolean
    return(IsUnitType(GetDyingUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Boss_Exodus_Death_CoinFlip takes nothing returns boolean
    // A random whole number from 1 through 2.
    return(GetRandomInt(1,2)<=1)
endfunction

function Trig_Boss_Exodus_Death_KillerIsPlayer takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetKillingUnitBJ()),udg_PlayingPlayers))
endfunction

function Trig_Boss_Exodus_Death_StoryFlagOn takes nothing returns boolean
    return(udg_HashmalumStage>0)
endfunction

function Trig_Boss_Exodus_Death_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Boss_Exodus_Death_Quest19Completed takes nothing returns boolean
    return(IsQuestCompleted(udg_MainQuest[19]))
endfunction

function Trig_Boss_Exodus_Death_Quest64Completed takes nothing returns boolean
    return(IsQuestCompleted(udg_SideQuest[64]))
endfunction

function Trig_Boss_Exodus_Death_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    if(Trig_Boss_Exodus_Death_TrackBossKills())then
        set udg_BossUnit=GetTriggerUnit()
        call ConditionalTriggerExecute(gg_trg_Speedrun_Accolade)
    endif
    set udg_ExodusQuestStage=7
    set udg_BossDefeated[3]=true
    call Music_ClearTrack($D) // $D = 13
    call PlayThematicMusicBJ("FF7-Victory Fanfare.mp3")
    if(Trig_Boss_Exodus_Death_DyingIsHero())then
        call DisplayTextToForce(udg_PlayingPlayers,(("|cffaa0000"+GetHeroProperName(GetDyingUnit()))+"|r was defeated !!!"))
    else
        call DisplayTextToForce(udg_PlayingPlayers,(("|cffaa0000"+GetUnitName(GetDyingUnit()))+"|r was defeated !!!"))
    endif
    call GroupRemoveUnitSimple(gg_unit_U00K_0208,udg_BossUnits)
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateItemLoc('I02U',udg_TempPoint) // 'I02U': item "Helm of the Necromancer"
    call CreateItemLoc('I01Z',udg_TempPoint) // 'I01Z': item "Crystal Shard"
    if(Trig_Boss_Exodus_Death_CoinFlip())then
        call CreateItemLoc('I05I',udg_TempPoint) // 'I05I': item "Spirit Potion"
    else
        call CreateItemLoc('I05H',udg_TempPoint) // 'I05H': item "Blood Ether"
    endif
    call RemoveLocation(udg_TempPoint)
    if(Trig_Boss_Exodus_Death_CinematicsEnabled())then
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_U00K_0208,.0)
        call Text_Say(null,"|n|cffffcc00All players get 6000 gold and 6000 exp.|r",true)
        call Text_Say(gg_unit_U00K_0208,"You can't go on... you will only destroy yourselves...",false)
        if(Trig_Boss_Exodus_Death_KillerIsPlayer())then
            set udg_CinematicActor=Player_GetHero(GetOwningPlayer(GetKillingUnitBJ()))
        else
            set udg_CinematicActor=Player_GetHero(ForcePickRandomPlayer(udg_PlayingPlayers))
        endif
        call Text_Say(udg_CinematicActor,"There he goes. So the Farm's priest was a demon in disguise.",false)
        call Text_Say(udg_CinematicActor,"The farmers would be heartbroken to hear about this, especially in these trying times. I better keep it to myself.",false)
        call Text_Say(udg_CinematicActor,"Still, what a strange demon. What in the world was he hoping to accomplish by playing a human priest?",false)
        call Text_Say(udg_CinematicActor,"Oh well, no point in losing my head over it. That'd just be playing into the demon's game.",false)
        call Reward_Give(6000,6000,null)
        if(Trig_Boss_Exodus_Death_StoryFlagOn())then
            call Cine_ExitAction()
        endif
    else
        call Reward_Give(6000,6000,gg_unit_U00K_0208)
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_COMPLETED,"Quest Completed: |cffffcc00Last Rites|r")
    call QuestSetCompletedBJ(udg_MainQuest[$E],true) // $E = 14
    set udg_QuestsCompleted=(udg_QuestsCompleted+1)
    if(Trig_Boss_Exodus_Death_Quest19Completed())then
        call SaveIntegerBJ(1,2,$AF,udg_GameStateHash) // $AF = 175
    endif
    call ConditionalTriggerExecute(gg_trg_Quest_WorldLiberation_Count)
    if(Trig_Boss_Exodus_Death_Quest64Completed())then
        call StartTimerBJ(udg_StoryDelayTimer,false,180.)
    else
        call ConditionalTriggerExecute(gg_trg_Billy_ShowTalkIcon)
    endif
endfunction

function InitTrig_Boss_Exodus takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Boss_Part4 (module Boss),
// which keeps the original registration order.

function Register_Boss_Exodus_Death takes nothing returns nothing
    set gg_trg_Boss_Exodus_Death=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_Exodus_Death)
    call TriggerRegisterUnitEvent(gg_trg_Boss_Exodus_Death,gg_unit_U00K_0208,EVENT_UNIT_DEATH)
    call TriggerAddAction(gg_trg_Boss_Exodus_Death,function Trig_Boss_Exodus_Death_Actions)
endfunction

endlibrary
