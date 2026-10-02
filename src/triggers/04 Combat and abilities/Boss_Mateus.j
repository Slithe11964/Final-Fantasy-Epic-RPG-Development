library TBossMateus requires TCam, TCine, TLink, TMusic, TPlayerPart01, TText
function Trig_Boss_Mateus_Intro_Conditions takes nothing returns boolean
    return((IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(GetUnitTypeId(GetTriggerUnit())!='H01D')and(udg_InCinematicMode==false))!=null // 'H01D': unit "Spirit of Gaya"
endfunction

function Trig_Boss_Mateus_Intro_Cond_NoQuestKnowledge takes nothing returns boolean
    return(udg_HashmalumStage<=0)
endfunction

function Trig_Boss_Mateus_Intro_Cond_NoGlennHelp takes nothing returns boolean
    return(udg_HashmalumStage<=2)
endfunction

function Trig_Boss_Mateus_Intro_Cond_StumbledIn takes nothing returns boolean
    return(udg_HashmalumStage<=1)
endfunction

function Trig_Boss_Mateus_Intro_Cond_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Boss_Mateus_Intro_Cond_QuestDiscovered takes nothing returns boolean
    return(IsQuestDiscovered(udg_MainQuest[18]))
endfunction

function Trig_Boss_Mateus_Intro_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    if(Trig_Boss_Mateus_Intro_Cond_CinematicsEnabled())then
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_U00M_0206,0)
        call Text_Transmission(gg_unit_U00L_0207,"Unknown Demon","Halt, intruder!","(null)",null,0,false)
        if(Trig_Boss_Mateus_Intro_Cond_NoQuestKnowledge())then
            call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"Who are you?",false)
        else
            call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"You're not Hashmalum... who are you?",false)
        endif
        call Text_Say(gg_unit_U00L_0207,"I am Mateus, the Zodiac Brave of Ice. And this is my wife and queen regent, Lady Demesne.",false)
        call Text_Say(gg_unit_U00M_0206,"Humans. You've come to invade our realm, haven't you.",false)
        if(Trig_Boss_Mateus_Intro_Cond_StumbledIn())then
            call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"We just stumbled in here. So you are the rulers of this realm are you.",false)
            call Text_Say(gg_unit_U00M_0206,"Hmph, you are not welcome in this place. Leave at once.",false)
            call Text_Say(gg_unit_U00L_0207,"I'm surprised you made it in here at all. I suppose there are still those out there that know the name of my lady.",false)
            call Text_Say(gg_unit_U00M_0206,"Perhaps it was Glenn who opened the gate for them.",false)
            call Text_Say(gg_unit_U00L_0207,"It matters not. We do not take kindly to intruders. Leave, humans.",false)
            call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"We refuse.",false)
        else
            call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"We are searching for the demon Hashmalum. We found out he's hiding somewhere here. So you're a Zodiac Brave as well. So you're hiding him from us, are you...?",false)
            call Text_Say(gg_unit_U00L_0207,"So you are the outsiders we heard of. Not even from Gaya and yet trying to take down our leader. How arrogant you are.",false)
            if(Trig_Boss_Mateus_Intro_Cond_NoGlennHelp())then
                call Text_Say(gg_unit_U00M_0206,"I don't know how you got in here but if you won't leave we won't show you mercy.",false)
            else
                call Text_Say(gg_unit_U00M_0206,"It was Glenn who brought you in here, wasn't it. Never thought he'd call out my name again.",false)
                call Text_Say(gg_unit_U00M_0206,"Still, if he brought you in here his allegiance is clear. We won't show mercy to him, or you.",false)
            endif
            call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"Then you will die here and now. We are not letting him take over this world again.",false)
        endif
        call Text_Say(gg_unit_U00L_0207,"As expected... outsiders never knew when to dial back their ego.",false)
        call Text_Say(gg_unit_U00M_0206,"Prepare to die, intruder !",false)
        call Cine_ExitAction()
    endif
    call SetUnitInvulnerable(gg_unit_U00L_0207,false)
    call SetUnitInvulnerable(gg_unit_U00M_0206,false)
    call UnitRemoveAbilityBJ('A0VJ',gg_unit_U00L_0207) // 'A0VJ': ability "Unaffected by Cinematics"
    call UnitRemoveAbilityBJ('A0VJ',gg_unit_U00M_0206) // 'A0VJ': ability "Unaffected by Cinematics"
    call PauseUnitBJ(false,gg_unit_U00L_0207)
    call PauseUnitBJ(false,gg_unit_U00M_0206)
    call SetUnitAcquireRangeBJ(gg_unit_U00L_0207,1100.)
    call SetUnitAcquireRangeBJ(gg_unit_U00M_0206,1100.)
    call UnitAddAbilityBJ('A0ZR',gg_unit_U00M_0206) // 'A0ZR': ability "Immortal"
    if(Trig_Boss_Mateus_Intro_Cond_QuestDiscovered())then
        call QuestSetDescriptionBJ(udg_MainQuest[18],"Destroy Mateus and Demesne.")
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_UPDATED,"Destroy Mateus and Demesne.")
    call StartTimerBJ(udg_JobLevelTimer,false,.01)
    call EnableTrigger(gg_trg_Boss_Demesne_CoverSwap)
    call EnableTrigger(gg_trg_Boss_Mateus_CoverSwap)
    call EnableTrigger(gg_trg_Boss_Mateus_Death)
    call Music_SetTrack($D) // $D = 13
endfunction

function Trig_Boss_Mateus_CoverSwap_Conditions takes nothing returns boolean
    // Result 1: current health divided by maximum health for the triggering unit, times 100 (or 0 if the unit is
    // missing or its maximum is 0).
    return(GetUnitLifePercent(GetTriggerUnit())<50.)and(IsUnitAliveBJ(GetTriggerUnit()))
endfunction

function Trig_Boss_Mateus_CoverSwap_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call UnitRemoveAbilityBJ('A0ZR',gg_unit_U00M_0206) // 'A0ZR': ability "Immortal"
    call UnitRemoveAbilityBJ('A0X2',gg_unit_U00M_0206) // 'A0X2': ability "Perma Cover"
    call UnitRemoveBuffBJ('B064',gg_unit_U00M_0206) // 'B064': buff "Perma Cover"
    call UnitAddAbilityBJ('A0X2',gg_unit_U00L_0207) // 'A0X2': ability "Perma Cover"
    call Link_SaveCaster(gg_unit_U00M_0206,gg_unit_U00L_0207,.0)
    call EnableTrigger(gg_trg_Boss_Demesne_Death_Revive)
endfunction

function Trig_Boss_Mateus_Death_Cond_TrackKill takes nothing returns boolean
    return(udg_SpeedrunMode)
endfunction

function Trig_Boss_Mateus_Death_Cond_DyingIsHero takes nothing returns boolean
    return(IsUnitType(GetDyingUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Boss_Mateus_Death_Cond_CanDropKey takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0MS',GetTriggerUnit())<=0) // 'A0MS': ability "Unstealable"
endfunction

function Trig_Boss_Mateus_Death_Cond_RandomHalf takes nothing returns boolean
    // A random whole number from 1 through 2.
    return(GetRandomInt(1,2)<=1)
endfunction

function Trig_Boss_Mateus_Death_Cond_KillerIsPlayer takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetKillingUnitBJ()),udg_PlayingPlayers))
endfunction

function Trig_Boss_Mateus_Death_Cond_KeyDropped takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0MS',GetTriggerUnit())<=0) // 'A0MS': ability "Unstealable"
endfunction

function Trig_Boss_Mateus_Death_Cond_QuestKnown takes nothing returns boolean
    return(udg_HashmalumStage>0)
endfunction

function Trig_Boss_Mateus_Death_Cond_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Boss_Mateus_Death_Cond_QuestActive takes nothing returns boolean
    return(IsQuestDiscovered(udg_MainQuest[18]))and(udg_HashmalumEncountered==false)
endfunction

function Trig_Boss_Mateus_Death_Cond_TalonInParty takes nothing returns boolean
    return(udg_TalonGone==false)
endfunction

function Trig_Boss_Mateus_Death_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    if(Trig_Boss_Mateus_Death_Cond_TrackKill())then
        set udg_BossUnit=GetTriggerUnit()
        call ConditionalTriggerExecute(gg_trg_Speedrun_Accolade)
    endif
    set udg_MateusDefeated=true
    set udg_BossDefeated[5]=true
    call PlayThematicMusicBJ("FF7-Victory Fanfare.mp3")
    if(Trig_Boss_Mateus_Death_Cond_DyingIsHero())then
        call DisplayTextToForce(udg_PlayingPlayers,(("|cffaa0000"+GetHeroProperName(GetDyingUnit()))+"|r was defeated !!!"))
    else
        call DisplayTextToForce(udg_PlayingPlayers,(("|cffaa0000"+GetUnitName(GetDyingUnit()))+"|r was defeated !!!"))
    endif
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    if(Trig_Boss_Mateus_Death_Cond_CanDropKey())then
        call CreateItemLoc('I0IM',udg_TempPoint) // 'I0IM': item "Winter Key"
        call SetItemInvulnerableBJ(GetLastCreatedItem(),true)
    endif
    call CreateItemLoc('I0E1',udg_TempPoint) // 'I0E1': item "Curse: Ice Wand"
    call CreateItemLoc('I01Z',udg_TempPoint) // 'I01Z': item "Crystal Shard"
    if(Trig_Boss_Mateus_Death_Cond_RandomHalf())then
        call CreateItemLoc('I05I',udg_TempPoint) // 'I05I': item "Spirit Potion"
    else
        call CreateItemLoc('I05H',udg_TempPoint) // 'I05H': item "Blood Ether"
    endif
    call RemoveLocation(udg_TempPoint)
    call EnableTrigger(gg_trg_Gate_WinterKey_Unlock)
    call DisableTrigger(gg_trg_Boss_Demesne_Death_Revive)
    call DisableTrigger(gg_trg_Boss_Demesne_Revived)
    call KillUnit(gg_unit_U00M_0206)
    if(Trig_Boss_Mateus_Death_Cond_CinematicsEnabled())then
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_U00L_0207,0)
        call Text_Say(gg_unit_U00L_0207,"Ugh... I'm sorry... Hashmalum...",false)
        if(Trig_Boss_Mateus_Death_Cond_KillerIsPlayer())then
            set udg_TempPlayer=GetOwningPlayer(GetKillingUnitBJ())
        else
            set udg_TempPlayer=ForcePickRandomPlayer(udg_PlayingPlayers)
        endif
        if(Trig_Boss_Mateus_Death_Cond_KeyDropped())then
            call Text_Say(Player_GetHero(udg_TempPlayer),"That key... is that...?",false)
        endif
        if(Trig_Boss_Mateus_Death_Cond_QuestKnown())then
            call Cine_ExitAction()
        endif
    endif
    if(Trig_Boss_Mateus_Death_Cond_QuestActive())then
        call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_UPDATED,"Use the Winter Key to continue your search for Hashmalum.")
        call QuestSetDescriptionBJ(udg_MainQuest[18],"Use the Winter Key to continue your search for Hashmalum.")
    endif
    if(Trig_Boss_Mateus_Death_Cond_TalonInParty())then
        set udg_TalonGone=true
        call DisplayTextToForce(GetPlayersAll(),"Talon leaves the party.")
        set udg_TempPoint=GetUnitLoc(udg_TalonUnit)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        call KillUnit(udg_TalonUnit)
        call RemoveUnit(udg_TalonUnit)
    endif
    call Music_ClearTrack($D) // $D = 13
    call ConditionalTriggerExecute(gg_trg_Quest_WorldLiberation_Count)
endfunction

function Trig_Boss_Mateus_Death_Final_Cond_DyingIsHero takes nothing returns boolean
    return(IsUnitType(GetDyingUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Boss_Mateus_Death_Final_Cond_RandomHalf takes nothing returns boolean
    // A random whole number from 1 through 2.
    return(GetRandomInt(1,2)<=1)
endfunction

function Trig_Boss_Mateus_Death_Final_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    set udg_MateusDefeated=true
    set udg_BossDefeated[5]=true
    call PlayThematicMusicBJ("FF7-Victory Fanfare.mp3")
    if(Trig_Boss_Mateus_Death_Final_Cond_DyingIsHero())then
        call DisplayTextToForce(udg_PlayingPlayers,(("|cffaa0000"+GetHeroProperName(GetDyingUnit()))+"|r was defeated !!!"))
    else
        call DisplayTextToForce(udg_PlayingPlayers,(("|cffaa0000"+GetUnitName(GetDyingUnit()))+"|r was defeated !!!"))
    endif
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateItemLoc('I0E1',udg_TempPoint) // 'I0E1': item "Curse: Ice Wand"
    call CreateItemLoc('I01Z',udg_TempPoint) // 'I01Z': item "Crystal Shard"
    if(Trig_Boss_Mateus_Death_Final_Cond_RandomHalf())then
        call CreateItemLoc('I05I',udg_TempPoint) // 'I05I': item "Spirit Potion"
    else
        call CreateItemLoc('I05H',udg_TempPoint) // 'I05H': item "Blood Ether"
    endif
    call RemoveLocation(udg_TempPoint)
    call DisableTrigger(gg_trg_Boss_Demesne_Death_Revive)
    call DisableTrigger(gg_trg_Boss_Demesne_Revived)
    call KillUnit(gg_unit_U00M_0206)
    call ConditionalTriggerExecute(gg_trg_Quest_WorldLiberation_Count)
endfunction

function InitTrig_Boss_Mateus takes nothing returns nothing
endfunction

endlibrary
