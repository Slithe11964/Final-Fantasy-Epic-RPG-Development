library TZeromus requires TCam, TCine, TGroup, TMusic, TPlayerPart01, TReward, TText, TWait
function Trig_Zeromus_Death_UpgradeSpawnPools takes nothing returns nothing
    local unitpool l_pool
    set l_pool=LoadUnitPoolHandle(udg_SpawnDataHash,3,1)
    call UnitPoolAddUnitType(l_pool,'nrvd',1) // 'nrvd': unit "Etem"
    set l_pool=LoadUnitPoolHandle(udg_SpawnDataHash,4,1)
    call UnitPoolAddUnitType(l_pool,'nrvd',2) // 'nrvd': unit "Etem"
    call UnitPoolAddUnitType(l_pool,'n0N3',1) // 'n0N3': unit "Forest Drake"
    set l_pool=LoadUnitPoolHandle(udg_SpawnDataHash,3,2)
    call UnitPoolAddUnitType(l_pool,'nslr',1) // 'nslr': unit "Zalamander"
    set l_pool=LoadUnitPoolHandle(udg_SpawnDataHash,4,2)
    call UnitPoolAddUnitType(l_pool,'nslr',2) // 'nslr': unit "Zalamander"
    call UnitPoolAddUnitType(l_pool,'n0L6',1) // 'n0L6': unit "Bomb"
    set l_pool=LoadUnitPoolHandle(udg_SpawnDataHash,3,3)
    call UnitPoolAddUnitType(l_pool,'nvdg',1) // 'nvdg': unit "Evil Spirit"
    set l_pool=LoadUnitPoolHandle(udg_SpawnDataHash,4,3)
    call UnitPoolAddUnitType(l_pool,'nvdg',2) // 'nvdg': unit "Evil Spirit"
    call UnitPoolAddUnitType(l_pool,'n0N1',1) // 'n0N1': unit "Xiao Long Gui"
    set l_pool=LoadUnitPoolHandle(udg_SpawnDataHash,3,4)
    call UnitPoolAddUnitType(l_pool,'nmgw',1) // 'nmgw': unit "Behemoth"
    set l_pool=LoadUnitPoolHandle(udg_SpawnDataHash,4,4)
    call UnitPoolAddUnitType(l_pool,'nmgw',2) // 'nmgw': unit "Behemoth"
    call UnitPoolAddUnitType(l_pool,'nmgr',1) // 'nmgr': unit "Grand Behemoth"
    set l_pool=LoadUnitPoolHandle(udg_SpawnDataHash,3,5)
    call UnitPoolAddUnitType(l_pool,'n0L6',1) // 'n0L6': unit "Bomb"
    set l_pool=LoadUnitPoolHandle(udg_SpawnDataHash,4,5)
    call UnitPoolAddUnitType(l_pool,'n0L6',2) // 'n0L6': unit "Bomb"
    call UnitPoolAddUnitType(l_pool,'nrvd',1) // 'nrvd': unit "Etem"
    set l_pool=LoadUnitPoolHandle(udg_SpawnDataHash,3,6)
    call UnitPoolAddUnitType(l_pool,'n0N1',.5) // 'n0N1': unit "Xiao Long Gui"
    call UnitPoolAddUnitType(l_pool,'nvdg',.5) // 'nvdg': unit "Evil Spirit"
    call UnitPoolAddUnitType(l_pool,'nrvd',.5) // 'nrvd': unit "Etem"
    set l_pool=LoadUnitPoolHandle(udg_SpawnDataHash,3,7)
    call UnitPoolAddUnitType(l_pool,'n0N3',1) // 'n0N3': unit "Forest Drake"
    set l_pool=LoadUnitPoolHandle(udg_SpawnDataHash,4,7)
    call UnitPoolAddUnitType(l_pool,'n0N3',2) // 'n0N3': unit "Forest Drake"
    call UnitPoolAddUnitType(l_pool,'nvdg',1) // 'nvdg': unit "Evil Spirit"
    set l_pool=null
endfunction

function Trig_Zeromus_Encounter_Conditions takes nothing returns boolean
    return(udg_InCinematicMode==false)
endfunction

function Trig_Zeromus_Encounter_Cond_FilterPlayerUnit takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetFilterUnit()),udg_ActivePlayers))
endfunction

function Trig_Zeromus_Encounter_Cond_FilterNotBoat takes nothing returns boolean
    return(GetUnitTypeId(GetFilterUnit())!='nbot') // 'nbot': object name not found in map data
endfunction

function Trig_Zeromus_Encounter_Filter_PulledUnit takes nothing returns boolean
    return GetBooleanAnd(Trig_Zeromus_Encounter_Cond_FilterPlayerUnit(),Trig_Zeromus_Encounter_Cond_FilterNotBoat())
endfunction

function Trig_Zeromus_Encounter_Cond_AtCenterX takes nothing returns boolean
    // Result 1: (x position of udg_TempPoint) minus (x position of udg_TempPoint2).
    // Result 2: the size of (result 1) without its sign; for example, -5 becomes 5.
    return(RAbsBJ((GetLocationX(udg_TempPoint)-GetLocationX(udg_TempPoint2)))<=32.)
endfunction

function Trig_Zeromus_Encounter_Cond_AtCenterY takes nothing returns boolean
    // Result 1: (y position of udg_TempPoint) minus (y position of udg_TempPoint2).
    // Result 2: the size of (result 1) without its sign; for example, -5 becomes 5.
    return(RAbsBJ((GetLocationY(udg_TempPoint)-GetLocationY(udg_TempPoint2)))<=32.)
endfunction

function Trig_Zeromus_Encounter_Cond_TargetVulnerable takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('Avul',GetEnumUnit())<=0) // 'Avul': standard ability reference "Invulnerable"
endfunction

function Trig_Zeromus_Encounter_Cond_HeroLowLife takes nothing returns boolean
    // Result 1: current health divided by maximum health for the unit being visited, times 100 (or 0 if the unit
    // is missing or its maximum is 0).
    return(IsPlayerInForce(GetOwningPlayer(GetEnumUnit()),udg_PlayingPlayers))and(GetEnumUnit()==Player_GetHero(GetOwningPlayer(GetEnumUnit())))and(GetUnitLifePercent(GetEnumUnit())<=50.)
endfunction

function Trig_Zeromus_Encounter_Cond_ReachedCenter takes nothing returns boolean
    // The straight-line distance between udg_TempPoint and udg_TempPoint2.
    return(DistanceBetweenPoints(udg_TempPoint,udg_TempPoint2)<=64.)
endfunction

function Trig_Zeromus_Encounter_PullUnitToCenter takes nothing returns nothing
    set udg_TempPoint=GetRectCenter(gg_rct_458)
    set udg_TempPoint2=GetUnitLoc(GetEnumUnit())
    if(Trig_Zeromus_Encounter_Cond_AtCenterX())then
        set udg_TempReal=GetLocationX(udg_TempPoint)
    else
        // (x position of udg_TempPoint) minus (x position of udg_TempPoint2).
        set udg_TempReal=(GetLocationX(udg_TempPoint)-GetLocationX(udg_TempPoint2))
        // Result 1: the size of (udg_TempReal) without its sign; for example, -5 becomes 5.
        // Result 2: (1024) minus (result 1).
        // Result 3: the square root of (result 2).
        // Result 4: (result 3) times (RSignBJ(udg_TempReal)).
        set udg_TempReal=(SquareRoot((1024.-RAbsBJ(udg_TempReal)))*RSignBJ(udg_TempReal))
        // (x position of udg_TempPoint2) plus ((udg_TempReal) times (0.66)).
        set udg_TempReal=(GetLocationX(udg_TempPoint2)+(udg_TempReal*.66))
    endif
    call SetUnitX(GetEnumUnit(),udg_TempReal)
    if(Trig_Zeromus_Encounter_Cond_AtCenterY())then
        set udg_TempReal=GetLocationY(udg_TempPoint)
    else
        // (y position of udg_TempPoint) minus (y position of udg_TempPoint2).
        set udg_TempReal=(GetLocationY(udg_TempPoint)-GetLocationY(udg_TempPoint2))
        // Result 1: the size of (udg_TempReal) without its sign; for example, -5 becomes 5.
        // Result 2: (1024) minus (result 1).
        // Result 3: the square root of (result 2).
        // Result 4: (result 3) times (RSignBJ(udg_TempReal)).
        set udg_TempReal=(SquareRoot((1024.-RAbsBJ(udg_TempReal)))*RSignBJ(udg_TempReal))
        // (y position of udg_TempPoint2) plus ((udg_TempReal) times (0.66)).
        set udg_TempReal=(GetLocationY(udg_TempPoint2)+(udg_TempReal*.66))
    endif
    call SetUnitY(GetEnumUnit(),udg_TempReal)
    call RemoveLocation(udg_TempPoint2)
    set udg_TempPoint2=GetUnitLoc(GetEnumUnit())
    if(Trig_Zeromus_Encounter_Cond_ReachedCenter())then
        call RemoveLocation(udg_TempPoint)
        call RemoveLocation(udg_TempPoint2)
        if(Trig_Zeromus_Encounter_Cond_HeroLowLife())then
            call DisableTrigger(GetTriggeringTrigger())
            set udg_CinematicActor=GetEnumUnit()
        else
            if(Trig_Zeromus_Encounter_Cond_TargetVulnerable())then
                set udg_DmgFlagUnavoidable=-1
                set udg_DmgFlagPure=true
                // Result 1: (current health of the unit being visited) times (0.02).
                // Result 2: (maximum health of the unit being visited) times (0.02).
                // Result 3: (result 1) plus (result 2).
                call UnitDamageTargetBJ(gg_unit_U00J_0209,GetEnumUnit(),((GetUnitStateSwap(UNIT_STATE_LIFE,GetEnumUnit())*.02)+(GetUnitStateSwap(UNIT_STATE_MAX_LIFE,GetEnumUnit())*.02)),ATTACK_TYPE_CHAOS,DAMAGE_TYPE_UNIVERSAL)
            endif
        endif
    else
        call RemoveLocation(udg_TempPoint)
        call RemoveLocation(udg_TempPoint2)
    endif
endfunction

function Trig_Zeromus_Encounter_Cond_ShowDialogue takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Zeromus_Encounter_Cond_PullDone takes nothing returns boolean
    return(IsTriggerEnabled(GetTriggeringTrigger())==false)
endfunction

function Trig_Zeromus_Encounter_Actions takes nothing returns nothing
    set udg_TempPoint=GetRectCenter(gg_rct_458)
    set udg_TempGroup=Group_UnitsInRangeOfLoc(1024.,udg_TempPoint,Condition(function Trig_Zeromus_Encounter_Filter_PulledUnit))
    call RemoveLocation(udg_TempPoint)
    call ForGroupBJ(udg_TempGroup,function Trig_Zeromus_Encounter_PullUnitToCenter)
    call DestroyGroup(udg_TempGroup)
    if(Trig_Zeromus_Encounter_Cond_PullDone())then
        if(Trig_Zeromus_Encounter_Cond_ShowDialogue())then
            call Cine_Enter()
            call Cam_PanToUnit(gg_unit_U00J_0209,0)
            call Text_Say(udg_CinematicActor,"Ugh... what is this... I'm stuck!",false)
            call Text_Say(null,"What are you doing here... you are not supposed to be here.",false)
            call Text_Say(udg_CinematicActor,"Who's there !?",false)
            call DestroyEffectBJ(udg_SpecialEffect[62])
            call CinematicFadeBJ(bj_CINEFADETYPE_FADEIN,1.,"ReplaceableTextures\\CameraMasks\\White_mask.blp",0,0,0,0)
            call ShowUnitShow(gg_unit_U00J_0209)
            call Wait_Polled(2.)
            call Text_Say(udg_CinematicActor,"A demon!",false)
            call Text_Say(gg_unit_U00J_0209,"I am called Zeromus. I am the protector of this world's boundary.",false)
            call Text_Say(gg_unit_U00J_0209,"Human... what are you doing here, at the edge of the world?",false)
            call Text_Say(udg_CinematicActor,"We've come to open this world up to the outside!",false)
            call Text_Say(gg_unit_U00J_0209,"What!? Why would you do that, are you trying to get this world destroyed!?",false)
            call Text_Say(udg_CinematicActor,"Uh... why did we want to do this again?",false)
            call Text_Say(gg_unit_U00J_0209,". . .",false)
            call Text_Transmission(gg_unit_U00J_0209,"Zeromus",". . . mortal.",". . .",null,0,false)
            call Text_Transmission(gg_unit_U00J_0209,"Zeromus",". . . mortal. Please tell me I am wrong about this.",". . . mortal.",null,0,false)
            call Text_Transmission(gg_unit_U00J_0209,"Zeromus",". . . mortal. Please tell me I am wrong about this. You haven't seriously come all this way to the border of this dimension to open it to the outside.",". . . mortal. Please tell me I am wrong about this.",null,0,false)
            call Text_Transmission(gg_unit_U00J_0209,"Zeromus",". . . mortal. Please tell me I am wrong about this. You haven't seriously come all this way to the border of this dimension to open it to the outside. Without considering the dangers of doing such a thing.",". . . mortal. Please tell me I am wrong about this. You haven't seriously come all this way to the border of this dimension to open it to the outside.",null,0,false)
            call Text_Transmission(gg_unit_U00J_0209,"Zeromus",". . . mortal. Please tell me I am wrong about this. You haven't seriously come all this way to the border of this dimension to open it to the outside. Without considering the dangers of doing such a thing. Have you?",". . . mortal. Please tell me I am wrong about this. You haven't seriously come all this way to the border of this dimension to open it to the outside. Without considering the dangers of doing such a thing.",null,0,false)
            call Text_Say(udg_CinematicActor,"...",false)
            call Text_Say(udg_CinematicActor,"... we may have.",false)
            call Text_Say(gg_unit_U00J_0209,"Hah... well this is precisely why I'm here to begin with... to deal with idiots like you.",false)
            call Text_Transmission(gg_unit_U00J_0209,"Zeromus","Hah... well this is precisely why I'm here to begin with... to deal with idiots like you. Are you still intent on continuing this fool's errand?","Hah... well this is precisely why I'm here to begin with... to deal with idiots like you.",null,0,false)
            call Text_Say(udg_CinematicActor,"We are. Even if it places the world in danger, all we need to do is protect it with our own hands!",false)
            call Text_Say(gg_unit_U00J_0209,"And yet you are only human. What will you do once your lifespan runs out? You are dooming this world to oblivion.",false)
            call Text_Say(gg_unit_U00J_0209,"Hmph. If you'd backed out easily I may have let you leave. But the mere existence of fools like you puts everyone in grave danger.",false)
            call Text_Say(gg_unit_U00J_0209,"I will show you the power that had me named the Zodiac Brave of Gravity.",false)
            call Text_Say(udg_CinematicActor,"Zodiac Brave!? So you are our enemy after all!",false)
            call Text_Say(gg_unit_U00J_0209,"Hmph. Die, you fools.",false)
            call Text_Say(udg_CinematicActor,"Watch out! Here he comes!",false)
            call Cine_ExitAction()
        else
            call DestroyEffectBJ(udg_SpecialEffect[62])
            call CinematicFadeBJ(bj_CINEFADETYPE_FADEIN,1.,"ReplaceableTextures\\CameraMasks\\White_mask.blp",0,0,0,0)
            call ShowUnitShow(gg_unit_U00J_0209)
        endif
        call QuestMessageBJ(udg_PlayingPlayers,bj_QUESTMESSAGE_UPDATED,"Destroy Zeromus, the Zodiac Brave of Gravity.")
        call QuestSetDescriptionBJ(udg_SideQuest[40],"Destroy Zeromus, the Zodiac Brave of Gravity.")
        call EnableTrigger(gg_trg_Zeromus_Death)
        call PauseUnitBJ(false,gg_unit_U00J_0209)
        call SetUnitInvulnerable(gg_unit_U00J_0209,false)
        call Music_SetTrack($D) // $D = 13
        call DestroyTrigger(GetTriggeringTrigger())
    endif
endfunction

function Trig_Zeromus_Death_Cond_TrackKills takes nothing returns boolean
    return(udg_SpeedrunMode)
endfunction

function Trig_Zeromus_Death_Cond_DyingIsHero takes nothing returns boolean
    return(IsUnitType(GetDyingUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Zeromus_Death_KillSkeleton takes nothing returns nothing
    call KillUnit(GetEnumUnit())
endfunction

function Trig_Zeromus_Death_Cond_CoinFlip takes nothing returns boolean
    // A random whole number from 1 through 2.
    return(GetRandomInt(1,2)<=1)
endfunction

function Trig_Zeromus_Death_Cond_KillerNotPlayer takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetKillingUnitBJ()),udg_PlayingPlayers)==false)
endfunction

function Trig_Zeromus_Death_Cond_ShowDialogue takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Zeromus_Death_Cond_SideQuestDone takes nothing returns boolean
    return(IsQuestCompleted(udg_MainQuest[19]))
endfunction

function Trig_Zeromus_Death_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    if(Trig_Zeromus_Death_Cond_TrackKills())then
        set udg_BossUnit=GetTriggerUnit()
        call ConditionalTriggerExecute(gg_trg_Speedrun_Accolade)
    endif
    set udg_BossDefeated[$A]=true // $A = 10
    call Music_ClearTrack($D) // $D = 13
    call PlayThematicMusicBJ("FF7-Victory Fanfare.mp3")
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_BossUnits)
    if(Trig_Zeromus_Death_Cond_DyingIsHero())then
        call DisplayTextToForce(udg_PlayingPlayers,(("|cffaa0000"+GetHeroProperName(GetDyingUnit()))+"|r was defeated !!!"))
    else
        call DisplayTextToForce(udg_PlayingPlayers,(("|cffaa0000"+GetUnitName(GetDyingUnit()))+"|r was defeated !!!"))
    endif
    call GroupClear(udg_ArenaBoundUnits)
    set udg_TempGroup=Group_UnitsOfPlayerAndType(Player($B),'u00P') // $B = 11; 'u00P': unit "Skeleton Champion"
    call ForGroupBJ(udg_TempGroup,function Trig_Zeromus_Death_KillSkeleton)
    call DestroyGroup(udg_TempGroup)
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateItemLoc('I0BZ',udg_TempPoint) // 'I0BZ': item "Holy Ankh"
    call SetItemInvulnerableBJ(GetLastCreatedItem(),true)
    call CreateItemLoc('I01Z',udg_TempPoint) // 'I01Z': item "Crystal Shard"
    if(Trig_Zeromus_Death_Cond_CoinFlip())then
        call CreateItemLoc('I05I',udg_TempPoint) // 'I05I': item "Spirit Potion"
    else
        call CreateItemLoc('I05H',udg_TempPoint) // 'I05H': item "Blood Ether"
    endif
    call RemoveLocation(udg_TempPoint)
    if(Trig_Zeromus_Death_Cond_ShowDialogue())then
        set udg_TempPoint=GetRectCenter(gg_rct_459)
        set udg_TempPoint2=GetUnitLoc(GetTriggerUnit())
        call SetUnitPositionLocFacingLocBJ(gg_unit_n034_0109,udg_TempPoint,udg_TempPoint2)
        call RemoveLocation(udg_TempPoint)
        call RemoveLocation(udg_TempPoint2)
        if(Trig_Zeromus_Death_Cond_KillerNotPlayer())then
            set udg_TempPlayer=ForcePickRandomPlayer(udg_PlayingPlayers)
        else
            set udg_TempPlayer=GetOwningPlayer(GetKillingUnitBJ())
        endif
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(gg_unit_U00J_0209,"Fools... you need to... stop this madness...",false)
        call Text_Say(gg_unit_n034_0109,"Amazing! You've really done it!",false)
        call Text_Say(Player_GetHero(udg_TempPlayer),"That's another one down.",false)
        call Text_Say(gg_unit_n034_0109,"I see... so the protector of the boundary was another Zodiac Brave.",false)
        call Text_Say(gg_unit_n034_0109,"With him out of the way, the boundary's defense should be weakened. Here's your reward!",false)
        call Reward_Give(7500,7500,gg_unit_n034_0109)
        call Text_Say(Player_GetHero(udg_TempPlayer),"So what will happen now?",false)
        call Text_Say(gg_unit_n034_0109,"It should now be easier for outsiders to come in to Gaya. If it turns out we need help, we might even be able to contact other worlds!",false)
        call Text_Say(Player_GetHero(udg_TempPlayer),"That sounds promising. Hopefully we won't be overrun with alien monsters.",false)
        call Text_Say(gg_unit_n034_0109,"Well, I'll return to Kalm now.",false)
        call Cine_ExitAction()
    else
        call Reward_Give(7500,7500,gg_unit_n034_0109)
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_COMPLETED,"Quest Completed: |cffffcc00Dimensional Boundary|r")
    call QuestSetCompletedBJ(udg_SideQuest[40],true)
    set udg_QuestsCompleted=(udg_QuestsCompleted+1)
    if(Trig_Zeromus_Death_Cond_SideQuestDone())then
        call SaveIntegerBJ(1,2,$AE,udg_GameStateHash) // $AE = 174
    endif
    set udg_TempPoint=GetRectCenter(gg_rct_421)
    call SetUnitPositionLocFacingBJ(gg_unit_n034_0109,udg_TempPoint,90.)
    call RemoveLocation(udg_TempPoint)
    call Trig_Zeromus_Death_UpgradeSpawnPools()
    call ShowUnitShow(gg_unit_n0AX_0188)
    call ConditionalTriggerExecute(gg_trg_Quest_WorldLiberation_Count)
    call ConditionalTriggerExecute(gg_trg_Agrias_ShowMarker)
    call ConditionalTriggerExecute(gg_trg_ShinrasPlan_Prepare)
    call ConditionalTriggerExecute(gg_trg_Frakir_NextMarker)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_Zeromus automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Zeromus (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Zeromus takes nothing returns nothing
endfunction

function Register_Zeromus_Encounter takes nothing returns nothing
    set gg_trg_Zeromus_Encounter=CreateTrigger()
    call DisableTrigger(gg_trg_Zeromus_Encounter)
    call TriggerRegisterTimerEventPeriodic(gg_trg_Zeromus_Encounter,.05)
    call TriggerAddCondition(gg_trg_Zeromus_Encounter,Condition(function Trig_Zeromus_Encounter_Conditions))
    call TriggerAddAction(gg_trg_Zeromus_Encounter,function Trig_Zeromus_Encounter_Actions)
endfunction

function Register_Zeromus_Death takes nothing returns nothing
    set gg_trg_Zeromus_Death=CreateTrigger()
    call DisableTrigger(gg_trg_Zeromus_Death)
    call TriggerRegisterUnitEvent(gg_trg_Zeromus_Death,gg_unit_U00J_0209,EVENT_UNIT_DEATH)
    call TriggerAddAction(gg_trg_Zeromus_Death,function Trig_Zeromus_Death_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Zeromus takes nothing returns nothing
    call Register_Zeromus_Encounter()
    call Register_Zeromus_Death()
endfunction

endlibrary
