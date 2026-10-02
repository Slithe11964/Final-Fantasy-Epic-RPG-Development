library TBossGodDragon requires TCam, TCine, TMusic, TPlayerHero, TReward, TText
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Boss_GodDragon_Death=null
endglobals

function Trig_Boss_GodDragon_Death_Cond_TrackKill takes nothing returns boolean
    return(udg_SpeedrunMode)
endfunction

function Trig_Boss_GodDragon_Death_Cond_DyingIsHero takes nothing returns boolean
    return(IsUnitType(GetDyingUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Boss_GodDragon_Death_Cond_KillerIsPlayer takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetKillingUnitBJ()),udg_PlayingPlayers))
endfunction

function Trig_Boss_GodDragon_Death_Cond_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Boss_GodDragon_Death_Cond_Quest16Completed takes nothing returns boolean
    return(IsQuestCompleted(udg_MainQuest[16]))
endfunction

function Trig_Boss_GodDragon_Death_Cond_Quest20Completed takes nothing returns boolean
    return(IsQuestCompleted(udg_MainQuest[20]))
endfunction

function Trig_Boss_GodDragon_Death_Cond_PlayerMissingCredit takes nothing returns boolean
    return(IsPlayerInForce(GetEnumPlayer(),udg_TitleForce[18])==false)
endfunction

function Trig_Boss_GodDragon_Death_Enum_CreditPlayer takes nothing returns nothing
    if(Trig_Boss_GodDragon_Death_Cond_PlayerMissingCredit())then
        set udg_TempPlayer=GetEnumPlayer()
        set udg_TempInteger=18
        call ConditionalTriggerExecute(gg_trg_Title_Grant)
    endif
endfunction

function Trig_Boss_GodDragon_Death_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    if(Trig_Boss_GodDragon_Death_Cond_TrackKill())then
        set udg_BossUnit=GetTriggerUnit()
        call ConditionalTriggerExecute(gg_trg_Speedrun_Accolade)
    endif
    call Music_ClearTrack($D) // $D = 13
    call PlayThematicMusicBJ("FF7-Victory Fanfare.mp3")
    if(Trig_Boss_GodDragon_Death_Cond_DyingIsHero())then
        call DisplayTextToForce(udg_PlayingPlayers,(("|cffaa0000"+GetHeroProperName(GetDyingUnit()))+"|r was defeated !!!"))
    else
        call DisplayTextToForce(udg_PlayingPlayers,(("|cffaa0000"+GetUnitName(GetDyingUnit()))+"|r was defeated !!!"))
    endif
    call GroupRemoveUnitSimple(gg_unit_U00H_0211,udg_BossUnits)
    if(Trig_Boss_GodDragon_Death_Cond_CinematicsEnabled())then
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_U00H_0211,0)
        call Reward_Give($4E20,$4E20,null) // $4E20 = 20000
        call Text_Say(null,"|n|cffffcc00All players get 20000 gold and 20000 exp.|r",true)
        if(Trig_Boss_GodDragon_Death_Cond_KillerIsPlayer())then
            set udg_CinematicActor=Player_GetHero(GetOwningPlayer(GetKillingUnitBJ()))
        else
            set udg_CinematicActor=Player_GetHero(ForcePickRandomPlayer(udg_PlayingPlayers))
        endif
        call Text_Say(udg_CinematicActor,"He's gone...",false)
        call Text_Say(udg_CinematicActor,"His power was beyond ridiculous. So he was the ace the Zodiac Braves still had up their sleeve.",false)
        call Text_Say(udg_CinematicActor,"But now we've defeated him. With this I'm sure we can bring the reign of the Braves to an end at last.",false)
        call Text_Say(udg_CinematicActor,"Montblanc will surely be happy as well.",false)
        call Cine_ExitAction()
    else
        call Reward_Give($4E20,$4E20,gg_unit_U00H_0211) // $4E20 = 20000
    endif
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateItemLoc('I08B',udg_TempPoint) // 'I08B': item "Serpent Gem"
    call CreateItemLoc('I01Z',udg_TempPoint) // 'I01Z': item "Crystal Shard"
    call CreateItemLoc('I05I',udg_TempPoint) // 'I05I': item "Spirit Potion"
    call CreateItemLoc('I05H',udg_TempPoint) // 'I05H': item "Blood Ether"
    if(Trig_Boss_GodDragon_Death_Cond_Quest20Completed())then
        call CreateItemLoc('I0D5',udg_TempPoint) // 'I0D5': item "Judge's Helm"
        call SetItemInvulnerableBJ(GetLastCreatedItem(),true)
        set udg_ArenaBonusBattle[0]=(udg_ArenaBonusBattle[0]+1)
        set udg_ArenaBonusBattle[udg_ArenaBonusBattle[0]]=$AC // $AC = 172
    else
        call CreateItemLoc('I01L',udg_TempPoint) // 'I01L': item "Grand Helmet"
        if(Trig_Boss_GodDragon_Death_Cond_Quest16Completed())then
            set udg_ArenaBonusBattle[0]=(udg_ArenaBonusBattle[0]+1)
            set udg_ArenaBonusBattle[udg_ArenaBonusBattle[0]]=$AC // $AC = 172
        endif
    endif
    call RemoveLocation(udg_TempPoint)
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_COMPLETED,"Quest Completed: |cffffcc00God Dragon|r")
    call QuestSetCompletedBJ(udg_MainQuest[17],true)
    set udg_QuestsCompleted=(udg_QuestsCompleted+1)
    // (udg_BravesDefeated) plus (1).
    call QuestItemSetDescriptionBJ(udg_QuestReq[4],("Zodiac Braves defeated: "+(I2S((udg_BravesDefeated+1))+"/13")))
    call ConditionalTriggerExecute(gg_trg_Promotion_Award_Random)
    call ForForce(udg_PlayingPlayers,function Trig_Boss_GodDragon_Death_Enum_CreditPlayer)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function InitTrig_Boss_GodDragon takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Boss_Part5 (module Boss),
// which keeps the original registration order.

function Register_Boss_GodDragon_Death takes nothing returns nothing
    set gg_trg_Boss_GodDragon_Death=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_GodDragon_Death)
    call TriggerRegisterUnitEvent(gg_trg_Boss_GodDragon_Death,gg_unit_U00H_0211,EVENT_UNIT_DEATH)
    call TriggerAddAction(gg_trg_Boss_GodDragon_Death,function Trig_Boss_GodDragon_Death_Actions)
endfunction

endlibrary
