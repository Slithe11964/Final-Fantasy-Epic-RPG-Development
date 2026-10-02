library TIceAge requires TCam, TCine, TGroup, TJob, TMusic, TPlayerHero, TReward, TText, TWait
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_IceAge_FreezeTimeout=null
    trigger gg_trg_IceAge_Victory=null
endglobals

function Trig_IceAge_FreezeTimeout_KnightDead takes nothing returns boolean
    return(IsUnitAliveBJ(udg_StoryBoss)==false)
endfunction

function Trig_IceAge_FreezeTimeout_CinematicActive takes nothing returns boolean
    return(udg_InCinematicMode)
endfunction

function Trig_IceAge_FreezeTimeout_ShakeCamera takes nothing returns nothing
    call CameraSetEQNoiseForPlayer(GetEnumPlayer(),10.)
endfunction

function Trig_IceAge_FreezeTimeout_ClonesRemain takes nothing returns boolean
    return(IsUnitGroupEmptyBJ(udg_BossSummons)==false)
endfunction

function Trig_IceAge_FreezeTimeout_ClearCameraShake takes nothing returns nothing
    call CameraClearNoiseForPlayer(GetEnumPlayer())
endfunction

function Trig_IceAge_FreezeTimeout_HardcoreMode takes nothing returns boolean
    return(udg_HardcoreOff==false)
endfunction

function Trig_IceAge_FreezeTimeout_KnightNeedsRevive takes nothing returns boolean
    return(IsUnitAliveBJ(udg_StoryBoss)==false)
endfunction

function Trig_IceAge_FreezeTimeout_KnightHasChargeItem takes nothing returns boolean
    return(GetItemUserData(UnitItemInSlotBJ(udg_StoryBoss,6))==$B) // $B = 11
endfunction

function Trig_IceAge_FreezeTimeout_IsPlayerOwned takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetFilterUnit()),udg_ActivePlayers))
endfunction

function Trig_IceAge_FreezeTimeout_IsFilterAlive takes nothing returns boolean
    return(IsUnitAliveBJ(GetFilterUnit()))
endfunction

function Trig_IceAge_FreezeTimeout_IsLivePlayerUnit takes nothing returns boolean
    return GetBooleanAnd(Trig_IceAge_FreezeTimeout_IsPlayerOwned(),Trig_IceAge_FreezeTimeout_IsFilterAlive())
endfunction

function Trig_IceAge_FreezeTimeout_MoveToRespawn takes nothing returns nothing
    set udg_TempPoint=GetRandomLocInRect(gg_rct_659)
    call SetUnitPositionLocFacingBJ(GetEnumUnit(),udg_TempPoint,270.)
    call RemoveLocation(udg_TempPoint)
endfunction

function Trig_IceAge_FreezeTimeout_Actions takes nothing returns nothing
    call SetUnitInvulnerable(udg_EcheleBoss,true)
    if(Trig_IceAge_FreezeTimeout_KnightDead())then
        call PauseTimerBJ(true,udg_GafgarionReviveTimer)
    else
        call SetUnitInvulnerable(udg_StoryBoss,true)
    endif
    if(Trig_IceAge_FreezeTimeout_CinematicActive())then
        call StartTimerBJ(udg_WorldFreezeTimer,false,.49)
        return
    endif
    call DisableTrigger(GetTriggeringTrigger())
    call DisableTrigger(gg_trg_Boss_Echele_FormChange)
    call DisableTrigger(gg_trg_IceAge_Victory)
    call DisableTrigger(gg_trg_Boss_Echele_Leash)
    call DestroyTimerDialogBJ(udg_WorldFreezeDialog)
    call GroupRemoveUnitSimple(udg_EcheleBoss,udg_QuestUnits)
    call GroupRemoveUnitSimple(udg_EcheleBoss,udg_BossGroup)
    call Cine_Enter()
    call Cam_PanToUnit(udg_EcheleBoss,0)
    call SetUnitInvulnerable(udg_EcheleBoss,true)
    call Wait_Polled(1.)
    call SetUnitAnimation(udg_EcheleBoss,"stand channel")
    call ForForce(udg_PlayingPlayers,function Trig_IceAge_FreezeTimeout_ShakeCamera)
    call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUTIN,1.,"ReplaceableTextures\\CameraMasks\\White_mask.blp",0,0,100.,0)
    call Wait_Polled(1.)
    call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUTIN,1.,"ReplaceableTextures\\CameraMasks\\White_mask.blp",0,0,100.,0)
    call Wait_Polled(1.)
    call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUT,1.,"ReplaceableTextures\\CameraMasks\\White_mask.blp",0,0,100.,0)
    call Wait_Polled(2.)
    if(Trig_IceAge_FreezeTimeout_ClonesRemain())then
        call GroupAddGroup(udg_BossSummons,udg_EcheleMinionsToKill)
        call GroupClear(udg_BossSummons)
        call StartTimerBJ(udg_EcheleMinionKillTimer,false,.01)
    endif
    call RemoveUnit(udg_EcheleBoss)
    call ForForce(udg_PlayingPlayers,function Trig_IceAge_FreezeTimeout_ClearCameraShake)
    call Text_Say(null,"As the spell reached completion, the world was turned to ice.\r\n\r\nAll life frozen for eternity, never to move again.",true)
    if(Trig_IceAge_FreezeTimeout_HardcoreMode())then
        call ConditionalTriggerExecute(gg_trg_Ending_FrozenWorld)
        return
    endif
    call Text_Say(null,"|cffffcc00You may retry the battle against Echele from scratch.\r\n\r\nIf you do not feel strong enough, consider looking for additional gear or allies!|r",true)
    call CinematicFadeBJ(bj_CINEFADETYPE_FADEIN,1.,"ReplaceableTextures\\CameraMasks\\White_mask.blp",0,0,100.,0)
    call Cine_ExitAction()
    if(Trig_IceAge_FreezeTimeout_KnightNeedsRevive())then
        set udg_TempPoint=GetRectCenter(gg_rct_574)
        call ReviveHeroLoc(udg_StoryBoss,udg_TempPoint,false)
        call RemoveLocation(udg_TempPoint)
        call SetUnitInvulnerable(udg_StoryBoss,true)
    else
        set udg_TempPoint=GetRectCenter(gg_rct_574)
        call SetUnitPositionLoc(udg_StoryBoss,udg_TempPoint)
        call RemoveLocation(udg_TempPoint)
    endif
    call SetUnitLifePercentBJ(udg_StoryBoss,'d')
    call SetUnitManaPercentBJ(udg_StoryBoss,'d')
    if(Trig_IceAge_FreezeTimeout_KnightHasChargeItem())then
        call SetItemCharges(UnitItemInSlotBJ(udg_StoryBoss,6),99)
    endif
    call SetUnitFacingTimed(udg_StoryBoss,270.,.01)
    call SetUnitOwner(udg_StoryBoss,Player(8),false)
    call GroupAddUnitSimple(udg_StoryBoss,udg_QuestUnits)
    call PauseUnitBJ(true,udg_StoryBoss)
    set udg_TempGroup=Group_UnitsInRect(gg_rct_658,Condition(function Trig_IceAge_FreezeTimeout_IsLivePlayerUnit))
    call ForGroupBJ(udg_TempGroup,function Trig_IceAge_FreezeTimeout_MoveToRespawn)
    call DestroyGroup(udg_TempGroup)
    set udg_ShadowForcedSpawn=48
    call EnableTrigger(gg_trg_Gafgarion_Join_Summit)
    call EnableTrigger(gg_trg_Boss_Echele_Start)
    call Music_ClearTrack(17)
endfunction

function Trig_IceAge_Victory_Conditions takes nothing returns boolean
    return(GetTriggerUnit()==udg_EcheleBoss)
endfunction

function Trig_IceAge_Victory_SpeedrunMode takes nothing returns boolean
    return(udg_SpeedrunMode)
endfunction

function Trig_IceAge_Victory_KnightLacksChargeItem takes nothing returns boolean
    return(GetItemUserData(UnitItemInSlotBJ(udg_StoryBoss,6))!=$B) // $B = 11
endfunction

function Trig_IceAge_Victory_KnightAlive takes nothing returns boolean
    return(IsUnitAliveBJ(udg_StoryBoss))
endfunction

function Trig_IceAge_Victory_KnightIsDead takes nothing returns boolean
    return(IsUnitAliveBJ(udg_StoryBoss)==false)
endfunction

function Trig_IceAge_Victory_KilledByPlayer takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetKillingUnitBJ()),udg_PlayingPlayers))
endfunction

function Trig_IceAge_Victory_HasNoDarkClassHero takes nothing returns boolean
    return(Job_GetSavedLevel(GetOwningPlayer(udg_CinematicActor),'H02X')<=1)and(Job_GetSavedLevel(GetOwningPlayer(udg_CinematicActor),'H02Y')<=1) // 'H02X': unit "Dark Knight"; 'H02Y': unit "Necromancer"
endfunction

function Trig_IceAge_Victory_HeroNotDarkClass takes nothing returns boolean
    return(GetUnitTypeId(udg_CinematicActor)!='H02X')and(GetUnitTypeId(udg_CinematicActor)!='H02Y') // 'H02X': unit "Dark Knight"; 'H02Y': unit "Necromancer"
endfunction

function Trig_IceAge_Victory_KnightLacksChargeItemAlt takes nothing returns boolean
    return(GetItemUserData(UnitItemInSlotBJ(udg_StoryBoss,6))!=$B) // $B = 11
endfunction

function Trig_IceAge_Victory_HeroLacksAward16 takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(udg_CinematicActor),udg_TitleForce[16])==false)
endfunction

function Trig_IceAge_Victory_CinematicsOn takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_IceAge_Victory_ArenaCup8Cleared takes nothing returns boolean
    return(udg_CupWins[8]>=3)
endfunction

function Trig_IceAge_Victory_HeroAtLevel50 takes nothing returns boolean
    return(GetHeroLevel(GetTriggerUnit())==50)
endfunction

function Trig_IceAge_Victory_Quest40Completed takes nothing returns boolean
    return(IsQuestCompleted(udg_SideQuest[40]))
endfunction

function Trig_IceAge_Victory_Quest12Completed takes nothing returns boolean
    return(IsQuestCompleted(udg_MainQuest[$C])) // $C = 12
endfunction

function Trig_IceAge_Victory_Quest14Completed takes nothing returns boolean
    return(IsQuestCompleted(udg_MainQuest[$E])) // $E = 14
endfunction

function Trig_IceAge_Victory_PlayerLacksAward16 takes nothing returns boolean
    return(IsPlayerInForce(GetEnumPlayer(),udg_TitleForce[16])==false)
endfunction

function Trig_IceAge_Victory_GrantAward16 takes nothing returns nothing
    if(Trig_IceAge_Victory_PlayerLacksAward16())then
        set udg_TempPlayer=GetEnumPlayer()
        set udg_TempInteger=16
        call ConditionalTriggerExecute(gg_trg_Title_Grant)
    endif
endfunction

function Trig_IceAge_Victory_TalonInParty takes nothing returns boolean
    return(udg_TalonGone==false)
endfunction

function Trig_IceAge_Victory_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    if(Trig_IceAge_Victory_SpeedrunMode())then
        set udg_BossUnit=GetTriggerUnit()
        call ConditionalTriggerExecute(gg_trg_Speedrun_Accolade)
    endif
    call PauseTimerBJ(true,udg_WorldFreezeTimer)
    call Music_ClearTrack(17)
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_QuestUnits)
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_BossGroup)
    call GroupRemoveUnitSimple(udg_StoryBoss,udg_BossGroup)
    call DisableTrigger(gg_trg_IceAge_FreezeTimeout)
    call DisableTrigger(gg_trg_Boss_Echele_Leash)
    call DisableTrigger(gg_trg_Gafgarion_Leash)
    call DestroyTrigger(gg_trg_Gafgarion_Leash)
    call DisableTrigger(gg_trg_Gafgarion_Death_Timer)
    call DestroyTrigger(gg_trg_Gafgarion_Death_Timer)
    call DisableTrigger(gg_trg_Gafgarion_Revive)
    call DestroyTrigger(gg_trg_Gafgarion_Revive)
    call DisableTrigger(gg_trg_Gafgarion_Block_Portal_Scroll)
    call DestroyTrigger(gg_trg_Gafgarion_Block_Portal_Scroll)
    if(Trig_IceAge_Victory_CinematicsOn())then
        if(Trig_IceAge_Victory_KnightIsDead())then
            call PauseTimerBJ(true,udg_GafgarionReviveTimer)
            set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
            set udg_TempPoint2=OffsetLocation(udg_TempPoint,0,400.)
            call ReviveHeroLoc(udg_StoryBoss,udg_TempPoint2,false)
            call SetUnitFacingToFaceLocTimed(udg_StoryBoss,udg_TempPoint,0)
            call RemoveLocation(udg_TempPoint)
            call RemoveLocation(udg_TempPoint2)
        endif
        call SetUnitOwner(udg_StoryBoss,Player(8),false)
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(null,"|n|cffffcc00All players get 10000 gold and 10000 exp.|r",true)
        call Text_Say(udg_StoryBoss,"I am sorry, my masters, for what I had to do.",false)
        if(Trig_IceAge_Victory_KilledByPlayer())then
            set udg_CinematicActor=Player_GetHero(GetOwningPlayer(GetKillingUnitBJ()))
        else
            set udg_CinematicActor=Player_GetHero(ForcePickRandomPlayer(udg_PlayingPlayers))
        endif
        call SetUnitFacingToFaceUnitTimed(udg_StoryBoss,udg_CinematicActor,.2)
        call Text_Say(udg_StoryBoss,"Well fought, outsiders.",false)
        call Text_Say(udg_CinematicActor,"You fought well yourself. But what will you do now?",false)
        call Text_Say(udg_StoryBoss,"Defeating this demon should have released the Zodiac Braves he absorbed from his grasp.",false)
        call Text_Say(udg_StoryBoss," I am the knight of the Zodiac Braves. They may view what I did today as a betrayal. Even so, I believe in them, and I will find a way to return them.",false)
        call Text_Say(udg_CinematicActor,"So you remain our enemy. And possibly theirs as well. Are you seriously intending on pursuing this mad idea all on your own?",false)
        call Text_Say(udg_StoryBoss,"I will. Even if it is madness as you say. It is my duty.",false)
        call Text_Say(udg_CinematicActor,"You are a curious fellow I'll give you that. Weren't you originally allied with the night elves, against the Zodiac Braves? What made you turn to darkness in the first place?",false)
        call Text_Say(udg_StoryBoss,"Is it not obvious? I realized I was being used by the people I believed in. I was fighting for the wrong side.",false)
        if(Trig_IceAge_Victory_HeroNotDarkClass())then
            call Text_Say(udg_StoryBoss,"And I never 'turned to darkness'. I merely faced it, and now I can control it. What about you? Have you even attempted to fight using darkness, and control it?",false)
            if(Trig_IceAge_Victory_HasNoDarkClassHero())then
                call Text_Say(udg_CinematicActor,"No, I have not.",false)
                call Text_Say(udg_StoryBoss,"Really now. What kind of warrior of light cowers in front of the darkness instead of controlling it and using its power for what they believe in?",false)
            else
                call Text_Say(udg_CinematicActor,"Yeah, I suppose you're right.",false)
            endif
        else
            call Text_Say(udg_StoryBoss,"And I never 'turned to darkness'. I merely faced it, and now I can control it. You should know.",false)
        endif
        call Text_Say(udg_StoryBoss,"But enough of that. Whether the Braves will forgive me or not, it seems the next time we meet it will be as enemies.",false)
        call Text_Say(udg_CinematicActor,"If we meet again at all. Farewell, Gafgarion.",false)
        call Text_Say(udg_StoryBoss,"Farewell.",false)
        set udg_TempPoint=GetUnitLoc(udg_StoryBoss)
        set udg_SpecialEffect[43]=AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportTo.mdl")
        call RemoveLocation(udg_TempPoint)
        call Wait_Polled(3.)
        call DestroyEffectBJ(udg_SpecialEffect[43])
        if(Trig_IceAge_Victory_KnightLacksChargeItemAlt())then
            call UnitRemoveItemFromSlotSwapped(6,udg_StoryBoss)
        endif
        set udg_TempPoint=GetUnitLoc(udg_StoryBoss)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        call ShowUnitHide(udg_StoryBoss)
        call Wait_Polled(2)
        call KillUnit(udg_StoryBoss)
        call RemoveUnit(udg_StoryBoss)
        if(Trig_IceAge_Victory_HeroLacksAward16())then
            call Text_Say(udg_CinematicActor,"Controlling the darkness, is it...",false)
        endif
        call Reward_Give($2EE0,$2EE0,null) // $2EE0 = 12000
        call Cine_ExitAction()
    else
        call Reward_Give($2EE0,$2EE0,udg_StoryBoss) // $2EE0 = 12000
        if(Trig_IceAge_Victory_KnightLacksChargeItem())then
            call UnitRemoveItemFromSlotSwapped(6,udg_StoryBoss)
        endif
        if(Trig_IceAge_Victory_KnightAlive())then
            set udg_TempPoint=GetUnitLoc(udg_StoryBoss)
            call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl")
            call DestroyEffectBJ(GetLastCreatedEffectBJ())
            call RemoveLocation(udg_TempPoint)
        else
            call PauseTimerBJ(true,udg_GafgarionReviveTimer)
        endif
        call RemoveUnit(udg_StoryBoss)
    endif
    if(Trig_IceAge_Victory_ArenaCup8Cleared())then
        call SaveIntegerBJ(0,2,'z',udg_GameStateHash)
        call SaveIntegerBJ(1,2,'{',udg_GameStateHash)
    endif
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    if(Trig_IceAge_Victory_HeroAtLevel50())then
        call CreateItemLoc('I0LP',udg_TempPoint) // 'I0LP': item "True Ice Axe"
    endif
    call CreateItemLoc('I0KB',udg_TempPoint) // 'I0KB': item "Hero's Badge"
    call CreateItemLoc('I01Z',udg_TempPoint) // 'I01Z': item "Crystal Shard"
    call CreateItemLoc('I05I',udg_TempPoint) // 'I05I': item "Spirit Potion"
    call CreateItemLoc('I05H',udg_TempPoint) // 'I05H': item "Blood Ether"
    call RemoveLocation(udg_TempPoint)
    call DestroyTimerDialogBJ(udg_WorldFreezeDialog)
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_COMPLETED,"Quest Completed: |cffffcc00Advent of Ice Age|r")
    call QuestSetCompletedBJ(udg_MainQuest[19],true)
    set udg_QuestsCompleted=(udg_QuestsCompleted+1)
    call SaveIntegerBJ(1,2,91,udg_GameStateHash)
    if(Trig_IceAge_Victory_Quest40Completed())then
        call SaveIntegerBJ(1,2,$AD,udg_GameStateHash) // $AD = 173
    endif
    if(Trig_IceAge_Victory_Quest12Completed())then
        call SaveIntegerBJ(1,2,$AE,udg_GameStateHash) // $AE = 174
    endif
    if(Trig_IceAge_Victory_Quest14Completed())then
        call SaveIntegerBJ(1,2,$AF,udg_GameStateHash) // $AF = 175
    endif
    call Music_SetZoneTrack($C) // $C = 12
    call ForForce(udg_PlayingPlayers,function Trig_IceAge_Victory_GrantAward16)
    if(Trig_IceAge_Victory_TalonInParty())then
        set udg_TalonGone=true
        call DisplayTextToForce(GetPlayersAll(),"Talon leaves the party.")
        set udg_TempPoint=GetUnitLoc(udg_TalonUnit)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        call KillUnit(udg_TalonUnit)
        call RemoveUnit(udg_TalonUnit)
    endif
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_IceAge automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_IceAge (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_IceAge takes nothing returns nothing
endfunction

function Register_IceAge_FreezeTimeout takes nothing returns nothing
    set gg_trg_IceAge_FreezeTimeout=CreateTrigger()
    call DisableTrigger(gg_trg_IceAge_FreezeTimeout)
    call TriggerRegisterTimerExpireEventBJ(gg_trg_IceAge_FreezeTimeout,udg_WorldFreezeTimer)
    call TriggerAddAction(gg_trg_IceAge_FreezeTimeout,function Trig_IceAge_FreezeTimeout_Actions)
endfunction

function Register_IceAge_Victory takes nothing returns nothing
    set gg_trg_IceAge_Victory=CreateTrigger()
    call DisableTrigger(gg_trg_IceAge_Victory)
    call TriggerAddCondition(gg_trg_IceAge_Victory,Condition(function Trig_IceAge_Victory_Conditions))
    call TriggerAddAction(gg_trg_IceAge_Victory,function Trig_IceAge_Victory_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_IceAge takes nothing returns nothing
    call Register_IceAge_FreezeTimeout() // starts off; enabled by Boss_Echele; disabled by IceAge
    call Register_IceAge_Victory() // starts off; enabled by Boss_Echele; disabled by IceAge
endfunction

endlibrary
