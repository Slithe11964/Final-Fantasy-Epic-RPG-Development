library TBossShemhazai requires TCam, TCine, TMusic, TPlayerPart01, TReward, TText
function Trig_Boss_Shemhazai_Death_TrackBossKills takes nothing returns boolean
    return(udg_SpeedrunMode)
endfunction

function Trig_Boss_Shemhazai_Death_DyingIsHero takes nothing returns boolean
    return(IsUnitType(GetDyingUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Boss_Shemhazai_Death_CoinFlip takes nothing returns boolean
    // A random whole number from 1 through 2.
    return(GetRandomInt(1,2)<=1)
endfunction

function Trig_Boss_Shemhazai_Death_KillerIsPlayer takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetKillingUnitBJ()),udg_PlayingPlayers))
endfunction

function Trig_Boss_Shemhazai_Death_StoryFlagOn takes nothing returns boolean
    return(udg_HashmalumStage>0)
endfunction

function Trig_Boss_Shemhazai_Death_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Boss_Shemhazai_Death_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    if(Trig_Boss_Shemhazai_Death_TrackBossKills())then
        set udg_BossUnit=GetTriggerUnit()
        call ConditionalTriggerExecute(gg_trg_Speedrun_Accolade)
    endif
    set udg_BossDefeated[9]=true
    call Music_ClearTrack($D) // $D = 13
    set udg_ShemhazaiPhase=5
    call PlayThematicMusicBJ("FF7-Victory Fanfare.mp3")
    if(Trig_Boss_Shemhazai_Death_DyingIsHero())then
        call DisplayTextToForce(udg_PlayingPlayers,(("|cffaa0000"+GetHeroProperName(GetDyingUnit()))+"|r was defeated !!!"))
    else
        call DisplayTextToForce(udg_PlayingPlayers,(("|cffaa0000"+GetUnitName(GetDyingUnit()))+"|r was defeated !!!"))
    endif
    call GroupRemoveUnitSimple(gg_unit_U00I_0210,udg_BossUnits)
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateItemLoc('I0KC',udg_TempPoint) // 'I0KC': item "Rosetta Stone"
    call CreateItemLoc('I01Z',udg_TempPoint) // 'I01Z': item "Crystal Shard"
    if(Trig_Boss_Shemhazai_Death_CoinFlip())then
        call CreateItemLoc('I05I',udg_TempPoint) // 'I05I': item "Spirit Potion"
    else
        call CreateItemLoc('I05H',udg_TempPoint) // 'I05H': item "Blood Ether"
    endif
    call RemoveLocation(udg_TempPoint)
    if(Trig_Boss_Shemhazai_Death_CinematicsEnabled())then
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_U00I_0210,.0)
        call Reward_Give(6000,6000,null)
        call Text_Say(null,"|n|cffffcc00All players get 6000 gold and 6000 exp.|r",true)
        if(Trig_Boss_Shemhazai_Death_KillerIsPlayer())then
            set udg_CinematicActor=Player_GetHero(GetOwningPlayer(GetKillingUnitBJ()))
        else
            set udg_CinematicActor=Player_GetHero(ForcePickRandomPlayer(udg_PlayingPlayers))
        endif
        call Text_Say(udg_CinematicActor,"We've beaten him... damn this guy was scary.",false)
        call Text_Say(udg_CinematicActor,"What a crazy and dangerous demon that was... as if even corrupting an entire base of orcs was just something to laugh at.",false)
        call Text_Say(udg_CinematicActor,"These demons are truly evil. Gaya won't be free until they're all gone from here.",false)
        if(Trig_Boss_Shemhazai_Death_StoryFlagOn())then
            call Cine_ExitAction()
        endif
    else
        call Reward_Give(6000,6000,gg_unit_U00I_0210)
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_COMPLETED,"Quest Completed: |cffffcc00Corrupted Orcs|r")
    call QuestSetCompletedBJ(udg_MainQuest[$D],true) // $D = 13
    set udg_QuestsCompleted=(udg_QuestsCompleted+1)
    call SaveIntegerBJ(1,2,$B0,udg_GameStateHash) // $B0 = 176
    call ConditionalTriggerExecute(gg_trg_Quest_WorldLiberation_Count)
endfunction

function InitTrig_Boss_Shemhazai takes nothing returns nothing
endfunction

endlibrary
