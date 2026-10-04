library TBossFamfrit requires TCam, TCine, TMusic, TPlayerHero, TReward, TText
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Boss_Famfrit_Death=null
endglobals

function Trig_Boss_Famfrit_Death_TrackBossKills takes nothing returns boolean
    return(udg_SpeedrunMode)
endfunction

function Trig_Boss_Famfrit_Death_DyingIsHero takes nothing returns boolean
    return(IsUnitType(GetDyingUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Boss_Famfrit_Death_CoinFlip takes nothing returns boolean
    // A random whole number from 1 through 2.
    return(GetRandomInt(1,2)<=1)
endfunction

function Trig_Boss_Famfrit_Death_KillerIsPlayer takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetKillingUnitBJ()),udg_PlayingPlayers))
endfunction

function Trig_Boss_Famfrit_Death_StoryFlagOn takes nothing returns boolean
    return(udg_HashmalumStage>0)
endfunction

function Trig_Boss_Famfrit_Death_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Boss_Famfrit_Death_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    if(Trig_Boss_Famfrit_Death_TrackBossKills())then
        set udg_BossUnit=GetTriggerUnit()
        call ConditionalTriggerExecute(gg_trg_Speedrun_Accolade)
    endif
    set udg_BossDefeated[2]=true
    call Music_ClearTrack($D) // $D = 13
    call PlayThematicMusicBJ("FF7-Victory Fanfare.mp3")
    if(Trig_Boss_Famfrit_Death_DyingIsHero())then
        call DisplayTextToForce(udg_PlayingPlayers,(("|cffaa0000"+GetHeroProperName(GetDyingUnit()))+"|r was defeated !!!"))
    else
        call DisplayTextToForce(udg_PlayingPlayers,(("|cffaa0000"+GetUnitName(GetDyingUnit()))+"|r was defeated !!!"))
    endif
    call GroupRemoveUnitSimple(gg_unit_U00N_0205,udg_BossUnits)
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateItemLoc('I0KY',udg_TempPoint) // 'I0KY': item "Serpent Rod"
    call CreateItemLoc('I01Z',udg_TempPoint) // 'I01Z': item "Crystal Shard"
    if(Trig_Boss_Famfrit_Death_CoinFlip())then
        call CreateItemLoc('I05I',udg_TempPoint) // 'I05I': item "Spirit Potion"
    else
        call CreateItemLoc('I05H',udg_TempPoint) // 'I05H': item "Blood Ether"
    endif
    call RemoveLocation(udg_TempPoint)
    if(Trig_Boss_Famfrit_Death_CinematicsEnabled())then
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_U00N_0205,.0)
        call Text_Say(null,"|n|cffffcc00All players get 6000 gold and 6000 exp.|r",true)
        call Text_Say(gg_unit_U00N_0205,"Now I understand. So this is what your aim is, Dana... but...",false)
        if(Trig_Boss_Famfrit_Death_KillerIsPlayer())then
            set udg_CinematicActor=Player_GetHero(GetOwningPlayer(GetKillingUnitBJ()))
        else
            set udg_CinematicActor=Player_GetHero(ForcePickRandomPlayer(udg_PlayingPlayers))
        endif
        call Text_Say(udg_CinematicActor,"He's down... he was driven by pure rage.",false)
        call Text_Say(udg_CinematicActor,"It seems even the Zodiac Braves valued Lady Dana greatly. Maybe if she hadn't been cast out of Lothlorien, these demons would have lived in harmony with the humans and night elves.",false)
        call Text_Say(udg_CinematicActor,"No, what am I saying. They're demons. They'd have tried to take it all for themselves.",false)
        call Text_Say(udg_CinematicActor,"Lady Dana... thank you. Even if we can't see or talk to you anymore, you, and the entire Phantom Village, are all right there, watching over us. We won't fail your expectations. We'll see this through to the end.",false)
        call Reward_Give(6000,6000,null)
        if(Trig_Boss_Famfrit_Death_StoryFlagOn())then
            call Cine_ExitAction()
        endif
    else
        call Reward_Give(6000,6000,gg_unit_U00N_0205)
    endif
    call ExecuteFunc("QuestIllusions_FamfritSlain") // completes the Illusions to Illusions quest
    call Music_SetZoneTrack(22)
    call SaveIntegerBJ(1,2,$B2,udg_GameStateHash) // $B2 = 178
    call ConditionalTriggerExecute(gg_trg_Quest_WorldLiberation_Count)
endfunction

function InitTrig_Boss_Famfrit takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Boss_Part5 (module Boss),
// which keeps the original registration order.

function Register_Boss_Famfrit_Death takes nothing returns nothing
    set gg_trg_Boss_Famfrit_Death=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_Famfrit_Death)
    call TriggerRegisterUnitEvent(gg_trg_Boss_Famfrit_Death,gg_unit_U00N_0205,EVENT_UNIT_DEATH)
    call TriggerAddAction(gg_trg_Boss_Famfrit_Death,function Trig_Boss_Famfrit_Death_Actions)
endfunction

endlibrary
