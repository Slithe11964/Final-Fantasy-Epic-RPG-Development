library TBossChaos requires TCam, TCine, TMusic, TPlayerPart01, TReward, TText
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Boss_Chaos_Death=null
endglobals

function Trig_Boss_Chaos_Death_TrackBossKills takes nothing returns boolean
    return(udg_SpeedrunMode)
endfunction

function Trig_Boss_Chaos_Death_DyingIsHero takes nothing returns boolean
    return(IsUnitType(GetDyingUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Boss_Chaos_Death_CoinFlip takes nothing returns boolean
    // A random whole number from 1 through 2.
    return(GetRandomInt(1,2)<=1)
endfunction

function Trig_Boss_Chaos_Death_KillChaosjet takes nothing returns nothing
    call KillUnit(GetEnumUnit())
endfunction

function Trig_Boss_Chaos_Death_KillerIsPlayer takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetKillingUnitBJ()),udg_PlayingPlayers))
endfunction

function Trig_Boss_Chaos_Death_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Boss_Chaos_Death_Quest19Completed takes nothing returns boolean
    return(IsQuestCompleted(udg_MainQuest[19]))
endfunction

function Trig_Boss_Chaos_Death_Quest7Discovered takes nothing returns boolean
    return(IsQuestDiscovered(udg_MainQuest[7]))
endfunction

function Trig_Boss_Chaos_Death_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    if(Trig_Boss_Chaos_Death_TrackBossKills())then
        set udg_BossUnit=GetTriggerUnit()
        call ConditionalTriggerExecute(gg_trg_Speedrun_Accolade)
    endif
    set udg_BossDefeated[$B]=true // $B = 11
    call Music_ClearTrack($D) // $D = 13
    call PlayThematicMusicBJ("FF7-Victory Fanfare.mp3")
    if(Trig_Boss_Chaos_Death_DyingIsHero())then
        call DisplayTextToForce(udg_PlayingPlayers,(("|cffaa0000"+GetHeroProperName(GetDyingUnit()))+"|r was defeated !!!"))
    else
        call DisplayTextToForce(udg_PlayingPlayers,(("|cffaa0000"+GetUnitName(GetDyingUnit()))+"|r was defeated !!!"))
    endif
    call GroupRemoveUnitSimple(gg_unit_U00O_0191,udg_BossUnits)
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateItemLoc('I0E8',udg_TempPoint) // 'I0E8': item "Magus Rod"
    call CreateItemLoc('I01Z',udg_TempPoint) // 'I01Z': item "Crystal Shard"
    if(Trig_Boss_Chaos_Death_CoinFlip())then
        call CreateItemLoc('I05I',udg_TempPoint) // 'I05I': item "Spirit Potion"
    else
        call CreateItemLoc('I05H',udg_TempPoint) // 'I05H': item "Blood Ether"
    endif
    call RemoveLocation(udg_TempPoint)
    call ForGroupBJ(udg_ChaosElementalGroup,function Trig_Boss_Chaos_Death_KillChaosjet)
    if(Trig_Boss_Chaos_Death_CinematicsEnabled())then
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_U00O_0191,.0)
        call Text_Say(null,"|n|cffffcc00All players get 6000 gold and 6000 exp.|r",true)
        call Text_Say(null,"|n|cffffcc00A new artifact is available for buying at the Ancient of Wonders.|r",true)
        if(Trig_Boss_Chaos_Death_KillerIsPlayer())then
            set udg_CinematicActor=Player_GetHero(GetOwningPlayer(GetKillingUnitBJ()))
        else
            set udg_CinematicActor=Player_GetHero(ForcePickRandomPlayer(udg_PlayingPlayers))
        endif
        call Text_Say(udg_CinematicActor,"He's down at last...",false)
        call Text_Say(udg_CinematicActor,"Chaos is dead. Now proper order can return to the forest.",false)
        call Text_Say(udg_CinematicActor,"It seems the forest spirits are not returning. They must have sacrificed their spiritual energy to summon forth that demon's body.",false)
        call Text_Say(udg_CinematicActor,"Regardless, with this demon out of the way the woods can finally recover. Even if it may take time, the corruption will heal. Celeborn and Galadriel will make it happen, I'm sure of it.",false)
        call Reward_Give(6000,6000,null)
        call Cine_ExitAction()
    else
        call Reward_Give(6000,6000,gg_unit_U00O_0191)
        call DisplayTimedTextToForce(udg_PlayingPlayers,10.,"|cffffcc00A new artifact is available for buying at the Ancient of Wonders.|r")
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_COMPLETED,"Quest Completed: |cffffcc00Voice of the Forest|r")
    call QuestSetCompletedBJ(udg_MainQuest[$C],true) // $C = 12
    set udg_QuestsCompleted=(udg_QuestsCompleted+1)
    call ConditionalTriggerExecute(gg_trg_Quest_WorldLiberation_Count)
    call SaveIntegerBJ(1,2,$86,udg_GameStateHash) // $86 = 134
    if(Trig_Boss_Chaos_Death_Quest19Completed())then
        call SaveIntegerBJ(1,2,$AE,udg_GameStateHash) // $AE = 174
    endif
    call AddItemToStockBJ('I00H',gg_unit_n00L_0153,1,1) // 'I00H': item "Griever"
    set udg_AreaSpawnUnitA[7]='n0AL' // 'n0AL': unit "Holy Elemental"
    set udg_AreaSpawnUnitB[7]='n0AN' // 'n0AN': unit "Diakon Entite"
    if(Trig_Boss_Chaos_Death_Quest7Discovered())then
        set udg_TempInteger=7
        call ConditionalTriggerExecute(gg_trg_Elemental_Spawn)
    endif
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function InitTrig_Boss_Chaos takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Boss_Part2 (module Boss),
// which keeps the original registration order.

function Register_Boss_Chaos_Death takes nothing returns nothing
    set gg_trg_Boss_Chaos_Death=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_Chaos_Death)
    call TriggerRegisterUnitEvent(gg_trg_Boss_Chaos_Death,gg_unit_U00O_0191,EVENT_UNIT_DEATH)
    call TriggerAddAction(gg_trg_Boss_Chaos_Death,function Trig_Boss_Chaos_Death_Actions)
endfunction

endlibrary
