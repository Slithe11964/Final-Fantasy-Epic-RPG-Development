library TBossUltima requires TCam, TCine, TMusic, TPlayerHero, TReward, TText, TWait
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Boss_Ultima_Death=null
endglobals

function Trig_Boss_Ultima_Death_TrackBossKills takes nothing returns boolean
    return(udg_SpeedrunMode)
endfunction

function Trig_Boss_Ultima_Death_DyingIsHero takes nothing returns boolean
    return(IsUnitType(GetDyingUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Boss_Ultima_Death_KillerIsPlayer takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetKillingUnitBJ()),udg_PlayingPlayers))
endfunction

function Trig_Boss_Ultima_Death_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Boss_Ultima_Death_Quest17Completed takes nothing returns boolean
    return(IsQuestCompleted(udg_MainQuest[17]))
endfunction

function Trig_Boss_Ultima_Death_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    if(Trig_Boss_Ultima_Death_TrackBossKills())then
        set udg_BossUnit=GetTriggerUnit()
        call ConditionalTriggerExecute(gg_trg_Speedrun_Accolade)
    endif
    set udg_BossDefeated[$C]=true // $C = 12
    call Music_ClearTrack($D) // $D = 13
    call PlayThematicMusicBJ("FF7-Victory Fanfare.mp3")
    if(Trig_Boss_Ultima_Death_DyingIsHero())then
        call DisplayTextToForce(udg_PlayingPlayers,(("|cffaa0000"+GetHeroProperName(GetDyingUnit()))+"|r was defeated !!!"))
    else
        call DisplayTextToForce(udg_PlayingPlayers,(("|cffaa0000"+GetUnitName(GetDyingUnit()))+"|r was defeated !!!"))
    endif
    call GroupRemoveUnitSimple(gg_unit_U00F_0221,udg_BossUnits)
    if(Trig_Boss_Ultima_Death_CinematicsEnabled())then
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_U00F_0221,0)
        set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
        call SetUnitPositionLocFacingBJ(udg_AlmaUnit,udg_TempPoint,GetUnitFacing(GetTriggerUnit()))
        call RemoveLocation(udg_TempPoint)
        call Reward_Give($2710,$2710,null) // $2710 = 10000
        call Text_Say(null,"|n|cffffcc00All players get 10000 gold and 8000 exp.|r",true)
        if(Trig_Boss_Ultima_Death_KillerIsPlayer())then
            set udg_CinematicActor=Player_GetHero(GetOwningPlayer(GetKillingUnitBJ()))
        else
            set udg_CinematicActor=Player_GetHero(ForcePickRandomPlayer(udg_PlayingPlayers))
        endif
        call Text_Say(udg_CinematicActor,"We've... defeated her...",false)
        call Text_Say(udg_CinematicActor,"Alma!",false)
        set udg_TempPoint=GetUnitLoc(udg_AlmaUnit)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Orc\\FeralSpirit\\feralspiritdone.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        call Wait_Polled(1.)
        set udg_TempPoint=GetUnitLoc(udg_AlmaUnit)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Orc\\FeralSpirit\\feralspiritdone.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        call Wait_Polled(1.)
        set udg_TempPoint=GetUnitLoc(udg_AlmaUnit)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\ReviveHuman\\ReviveHuman.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        call Wait_Polled(1.)
        call ShowUnitShow(udg_AlmaUnit)
        call SetUnitColor(udg_AlmaUnit,PLAYER_COLOR_LIGHT_BLUE)
        call Text_Say(udg_CinematicActor,"Alma!",false)
        call Text_Say(udg_AlmaUnit,"Unngh... what happened to me... I was engulfed in a divine light... and then...",false)
        call Text_Say(udg_CinematicActor,"Alma... you were possessed by a foul demon. We struck her down... but your brother was killed.",false)
        call Text_Say(udg_AlmaUnit,"A foul demon... killed my brother...? No... what are you saying...",false)
        call Text_Say(udg_CinematicActor,"... I'm sorry. You're still dazed and this must be a huge shock to you. Please, for now just return to Kalm. They've been surely very worried.",false)
        call Text_Say(udg_AlmaUnit,"Yeah... I'll go back right away. Sorry.",false)
        set udg_TempPoint=GetUnitLoc(udg_AlmaUnit)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportTarget.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        call Wait_Polled(.5)
        call Cine_ExitAction()
        set udg_TempPoint=GetUnitLoc(udg_AlmaUnit)
    else
        call Reward_Give($2710,$2710,gg_unit_U00F_0221) // $2710 = 10000
        set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    endif
    call CreateItemLoc('I0D5',udg_TempPoint) // 'I0D5': item "Judge's Helm"
    call SetItemInvulnerableBJ(GetLastCreatedItem(),true)
    call CreateItemLoc('I0I3',udg_TempPoint) // 'I0I3': item "Holy Book of Galbados"
    call CreateItemLoc('I01Z',udg_TempPoint) // 'I01Z': item "Crystal Shard"
    call CreateItemLoc('I05I',udg_TempPoint) // 'I05I': item "Spirit Potion"
    call CreateItemLoc('I05H',udg_TempPoint) // 'I05H': item "Blood Ether"
    call RemoveLocation(udg_TempPoint)
    call RemoveUnit(udg_AlmaUnit)
    call ShowUnitShow(gg_unit_Hjai_0093)
    call GroupAddUnitSimple(gg_unit_Hjai_0093,udg_RecruitedAllies)
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_COMPLETED,"Quest Completed: |cffffcc00Light of Judgment|r")
    call QuestSetCompletedBJ(udg_MainQuest[16],true)
    set udg_QuestsCompleted=(udg_QuestsCompleted+1)
    if(Trig_Boss_Ultima_Death_Quest17Completed())then
        set udg_ArenaBonusBattle[0]=(udg_ArenaBonusBattle[0]+1)
        set udg_ArenaBonusBattle[udg_ArenaBonusBattle[0]]=$AC // $AC = 172
    endif
    call ConditionalTriggerExecute(gg_trg_Quest_WorldLiberation_Count)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function InitTrig_Boss_Ultima takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Boss_Part5 (module Boss),
// which keeps the original registration order.

function Register_Boss_Ultima_Death takes nothing returns nothing
    set gg_trg_Boss_Ultima_Death=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_Ultima_Death)
    call TriggerRegisterUnitEvent(gg_trg_Boss_Ultima_Death,gg_unit_U00F_0221,EVENT_UNIT_DEATH)
    call TriggerAddAction(gg_trg_Boss_Ultima_Death,function Trig_Boss_Ultima_Death_Actions)
endfunction

endlibrary
