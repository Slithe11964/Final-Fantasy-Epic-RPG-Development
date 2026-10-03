library TEnding requires TCam, TCine, TGroup, TLoc, TMusic, TPlayerHero, TText, TUnit, TWait
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Ending_FrozenWorld=null
    trigger gg_trg_Ending_Wasteland=null
    trigger gg_trg_Ending_ReturnToStart=null
endglobals

function Trig_Ending_ReturnToStart_EnumUnitsInRect takes rect r returns group
    set udg_EnumGroup=CreateGroup()
    call GroupEnumUnitsInRect(udg_EnumGroup,r,udg_FilterTrue)
    return udg_EnumGroup
endfunction

function Trig_Ending_FrozenWorld_SpawnRegionUnits takes integer i returns nothing
    local unit l_spawned
    local unitpool l_pool1=LoadUnitPoolHandle(udg_SpawnDataHash,3,i)
    local unitpool l_pool2=LoadUnitPoolHandle(udg_SpawnDataHash,4,i)
    local integer l_rectCount=LoadInteger(udg_SpawnDataHash,2,i)
    local real l_spawnY
    local real l_spawnX
    local rect l_spawnRect
    local integer j=0
    loop
        exitwhen j>=8
        // A random whole number from 1 through l_rectCount.
        set l_spawnRect=LoadRectHandle(udg_SpawnRectHash,i,GetRandomInt(1,l_rectCount))
        // A random decimal number between GetRectMinY(l_spawnRect) and GetRectMaxY(l_spawnRect).
        set l_spawnY=GetRandomReal(GetRectMinY(l_spawnRect),GetRectMaxY(l_spawnRect))
        // A random decimal number between GetRectMinX(l_spawnRect) and GetRectMaxX(l_spawnRect).
        set l_spawnX=GetRandomReal(GetRectMinX(l_spawnRect),GetRectMaxX(l_spawnRect))
        set l_spawned=PlaceRandomUnit(l_pool1,Player(9),l_spawnX,l_spawnY,270.)
        call UnitPoolRemoveUnitType(l_pool1,GetUnitTypeId(l_spawned))
        // A random whole number from 1 through l_rectCount.
        set l_spawnRect=LoadRectHandle(udg_SpawnRectHash,i,GetRandomInt(1,l_rectCount))
        // A random decimal number between GetRectMinY(l_spawnRect) and GetRectMaxY(l_spawnRect).
        set l_spawnY=GetRandomReal(GetRectMinY(l_spawnRect),GetRectMaxY(l_spawnRect))
        // A random decimal number between GetRectMinX(l_spawnRect) and GetRectMaxX(l_spawnRect).
        set l_spawnX=GetRandomReal(GetRectMinX(l_spawnRect),GetRectMaxX(l_spawnRect))
        set l_spawned=PlaceRandomUnit(l_pool2,Player(9),l_spawnX,l_spawnY,270.)
        call UnitPoolRemoveUnitType(l_pool2,GetUnitTypeId(l_spawned))
        set j=j+1
    endloop
    call DestroyUnitPool(l_pool1)
    call DestroyUnitPool(l_pool2)
    set l_spawned=null
    set l_pool1=null
    set l_pool2=null
    set l_spawnRect=null
endfunction

function Trig_Ending_FrozenWorld_EndGameForPlayer takes nothing returns nothing
    call ForceRemovePlayerSimple(GetEnumPlayer(),udg_PlayingPlayers)
    call CustomVictoryBJ(GetEnumPlayer(),false,false)
endfunction

function Trig_Ending_FrozenWorld_NoPlayersLeft takes nothing returns boolean
    return(CountPlayersInForceBJ(udg_PlayingPlayers)<=0)
endfunction

function Trig_Ending_FrozenWorld_Quest17NotDone takes nothing returns boolean
    return(IsQuestCompleted(udg_MainQuest[17])==false)
endfunction

function Trig_Ending_FrozenWorld_KillAndRemove takes nothing returns nothing
    call KillUnit(GetEnumUnit())
    call RemoveUnit(GetEnumUnit())
endfunction

function Trig_Ending_FrozenWorld_WipeItems1 takes nothing returns nothing
    call RemoveItem(GetEnumItem())
endfunction

function Trig_Ending_FrozenWorld_HasUserData takes nothing returns boolean
    return(GetUnitUserData(GetFilterUnit())>0)
endfunction

function Trig_Ending_FrozenWorld_FadeOutUnit takes nothing returns nothing
    call ShowUnitHide(GetEnumUnit())
    call UnitApplyTimedLifeBJ(.5,'BTLF',GetEnumUnit()) // 'BTLF': object name not found in map data
endfunction

function Trig_Ending_FrozenWorld_WipeItems2 takes nothing returns nothing
    call RemoveItem(GetEnumItem())
endfunction

function Trig_Ending_FrozenWorld_IsNotHero takes nothing returns boolean
    return(IsUnitType(GetFilterUnit(),UNIT_TYPE_HERO)==false)!=null
endfunction

function Trig_Ending_FrozenWorld_GiveToNeutral takes nothing returns nothing
    call SetUnitOwner(GetEnumUnit(),Player(9),true)
endfunction

function Trig_Ending_FrozenWorld_FreezePlayerHeroes takes nothing returns nothing
    local group l_tempGroup
    call BlzUnitDisableAbility(Player_GetHero(GetEnumPlayer()),'A0Z2',true,false) // 'A0Z2': ability "Raise Dead"
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=6
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        call UnitRemoveItemFromSlotSwapped(GetForLoopIndexA(),Player_GetHero(GetTriggerPlayer()))
        call UnitRemoveItemFromSlotSwapped(GetForLoopIndexA(),udg_SpiritOfGaya[GetConvertedPlayerId(GetEnumPlayer())])
        call UnitRemoveItemFromSlotSwapped(GetForLoopIndexA(),udg_PlayerHouse[GetConvertedPlayerId(GetEnumPlayer())])
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    call SetUnitVertexColorBJ(Player_GetHero(GetEnumPlayer()),.0,.0,'d',0)
    call SetUnitTimeScalePercent(Player_GetHero(GetEnumPlayer()),.0)
    set udg_SpecialEffect[GetConvertedPlayerId(GetEnumPlayer())]=AddSpecialEffectTargetUnitBJ("origin",Player_GetHero(GetEnumPlayer()),"Abilities\\Spells\\Undead\\FreezingBreath\\FreezingBreathTargetArt.mdl")
    call SetUnitVertexColorBJ(udg_SpiritOfGaya[GetConvertedPlayerId(GetEnumPlayer())],.0,.0,'d',0)
    call SetUnitTimeScalePercent(udg_SpiritOfGaya[GetConvertedPlayerId(GetEnumPlayer())],.0)
    // (GetConvertedPlayerId(the player being visited)) plus (10).
    set udg_SpecialEffect[(GetConvertedPlayerId(GetEnumPlayer())+$A)]=AddSpecialEffectTargetUnitBJ("origin",udg_SpiritOfGaya[GetConvertedPlayerId(GetEnumPlayer())],"Abilities\\Spells\\Undead\\FreezingBreath\\FreezingBreathTargetArt.mdl") // $A = 10
    call UnitRemoveAbilityBJ('AInv',Player_GetHero(GetEnumPlayer())) // 'AInv': standard ability reference "Inventory"
    call UnitRemoveAbilityBJ('AInv',udg_SpiritOfGaya[GetConvertedPlayerId(GetEnumPlayer())]) // 'AInv': standard ability reference "Inventory"
    set udg_DispelTarget=Player_GetHero(GetEnumPlayer())
    call ConditionalTriggerExecute(gg_trg_Remove_Debuffs)
    call ConditionalTriggerExecute(gg_trg_Remove_Buffs)
    set l_tempGroup=Group_UnitsOfPlayer(GetEnumPlayer(),Condition(function Trig_Ending_FrozenWorld_IsNotHero))
    call ForGroupBJ(l_tempGroup,function Trig_Ending_FrozenWorld_GiveToNeutral)
    call DestroyGroup(l_tempGroup)
    set l_tempGroup=null
endfunction

function Trig_Ending_FrozenWorld_WipeItems3 takes nothing returns nothing
    call RemoveItem(GetEnumItem())
endfunction

function Trig_Ending_FrozenWorld_RemoveEnumUnit takes nothing returns nothing
    call RemoveUnit(GetEnumUnit())
endfunction

function Trig_Ending_FrozenWorld_IsNotPlayerUnit takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetFilterUnit()),udg_PlayingPlayers)==false)
endfunction

function Trig_Ending_FrozenWorld_IsNotPlayerUnitAlt takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetFilterUnit()),udg_PlayingPlayers)==false)
endfunction

function Trig_Ending_FrozenWorld_WayGatesVisible takes nothing returns boolean
    return(IsUnitHiddenBJ(gg_unit_nwgt_0142)==false)
endfunction

function Trig_Ending_FrozenWorld_IsHero takes nothing returns boolean
    return(IsUnitType(GetEnumUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Ending_FrozenWorld_CloneAsFrozen takes nothing returns nothing
    local location l_tempPoint
    call ShowUnitHide(GetEnumUnit())
    set l_tempPoint=GetUnitLoc(GetEnumUnit())
    call CreateNUnitsAtLoc(1,GetUnitTypeId(GetEnumUnit()),Player(8),l_tempPoint,GetUnitFacing(GetEnumUnit()))
    call RemoveLocation(l_tempPoint)
    call GroupAddUnitSimple(GetLastCreatedUnit(),udg_FrozenUnits)
    if(Trig_Ending_FrozenWorld_IsHero())then
        call SetHeroLevelBJ(GetLastCreatedUnit(),GetHeroLevel(GetEnumUnit()),false)
    endif
    set l_tempPoint=null
endfunction

function Trig_Ending_FrozenWorld_FreezeUnit takes nothing returns nothing
    call SetUnitVertexColorBJ(GetEnumUnit(),.0,.0,'d',0)
    call SetUnitTimeScalePercent(GetEnumUnit(),.0)
    call AddSpecialEffectTargetUnitBJ("origin",GetEnumUnit(),"Abilities\\Spells\\Undead\\FreezingBreath\\FreezingBreathTargetArt.mdl")
    call PauseUnitBJ(true,GetEnumUnit())
    call SetUnitInvulnerable(GetEnumUnit(),true)
    call UnitAddAbilityBJ('A0VJ',GetEnumUnit()) // 'A0VJ': ability "Unaffected by Cinematics"
    call UnitRemoveAbilityBJ('AInv',GetEnumUnit()) // 'AInv': standard ability reference "Inventory"
    call UnitRemoveAbilityBJ('Awan',GetEnumUnit()) // 'Awan': object name not found in map data
    call UnitRemoveAbilityBJ('Aneu',GetEnumUnit()) // 'Aneu': standard ability reference "Neutral Building"
endfunction

function Trig_Ending_FrozenWorld_WipeItems4 takes nothing returns nothing
    call RemoveItem(GetEnumItem())
endfunction

function Trig_Ending_FrozenWorld_IsGreenTree takes nothing returns boolean
    return(GetDestructableTypeId(GetEnumDestructable())=='ATtr')or(GetDestructableTypeId(GetEnumDestructable())=='CTtr') // 'ATtr': object name not found in map data; 'CTtr': object name not found in map data
endfunction

function Trig_Ending_FrozenWorld_IsGreenTreeCheck takes nothing returns boolean
    return(Trig_Ending_FrozenWorld_IsGreenTree())
endfunction

function Trig_Ending_FrozenWorld_IsSummerOrFallTree takes nothing returns boolean
    return(GetDestructableTypeId(GetEnumDestructable())=='LTlt')or(GetDestructableTypeId(GetEnumDestructable())=='FTtw') // 'LTlt': object name not found in map data; 'FTtw': object name not found in map data
endfunction

function Trig_Ending_FrozenWorld_IsSummerOrFallTreeCheck takes nothing returns boolean
    return(Trig_Ending_FrozenWorld_IsSummerOrFallTree())
endfunction

function Trig_Ending_FrozenWorld_IsDestructableAlive takes nothing returns boolean
    return(IsDestructableAliveBJ(GetEnumDestructable()))
endfunction

function Trig_Ending_FrozenWorld_FreezeTrees takes nothing returns nothing
    if(Trig_Ending_FrozenWorld_IsDestructableAlive())then
        if(Trig_Ending_FrozenWorld_IsSummerOrFallTreeCheck())then
            set udg_TempPoint=GetDestructableLoc(GetEnumDestructable())
            call RemoveDestructable(GetEnumDestructable())
            // Calculation 1:
            // A random decimal number between 0.8 and 1.2.
            // Calculation 2:
            // A random whole number from 0 through 9.
            call CreateDestructableLoc('WTst',udg_TempPoint,GetRandomDirectionDeg(),GetRandomReal(.8,1.2),GetRandomInt(0,9)) // 'WTst': object name not found in map data
            call RemoveLocation(udg_TempPoint)
        else
            if(Trig_Ending_FrozenWorld_IsGreenTreeCheck())then
                set udg_TempPoint=GetDestructableLoc(GetEnumDestructable())
                call RemoveDestructable(GetEnumDestructable())
                // Calculation 1:
                // A random decimal number between 0.8 and 1.2.
                // Calculation 2:
                // A random whole number from 0 through 9.
                call CreateDestructableLoc('ITtw',udg_TempPoint,GetRandomDirectionDeg(),GetRandomReal(.8,1.2),GetRandomInt(0,9)) // 'ITtw': object name not found in map data
                call RemoveLocation(udg_TempPoint)
            endif
        endif
    endif
endfunction

function Trig_Ending_FrozenWorld_WipeItems5 takes nothing returns nothing
    call RemoveItem(GetEnumItem())
endfunction

function Trig_Ending_FrozenWorld_DoomEffect1 takes nothing returns nothing
    call AddSpecialEffectTargetUnitBJ("origin",Player_GetHero(GetEnumPlayer()),"Abilities\\Spells\\Other\\Doom\\DoomDeath.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
endfunction

function Trig_Ending_FrozenWorld_DoomEffect2 takes nothing returns nothing
    call AddSpecialEffectTargetUnitBJ("origin",Player_GetHero(GetEnumPlayer()),"Abilities\\Spells\\Other\\Doom\\DoomDeath.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
endfunction

function Trig_Ending_FrozenWorld_UnfreezePlayerHeroes takes nothing returns nothing
    call AddSpecialEffectTargetUnitBJ("origin",Player_GetHero(GetEnumPlayer()),"Abilities\\Spells\\Other\\Doom\\DoomDeath.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call SetUnitVertexColorBJ(Player_GetHero(GetEnumPlayer()),60.,60.,'d',0)
    call SetUnitTimeScalePercent(Player_GetHero(GetEnumPlayer()),80.)
    call DestroyEffectBJ(udg_SpecialEffect[GetConvertedPlayerId(GetEnumPlayer())])
    call SetUnitVertexColorBJ(udg_SpiritOfGaya[GetConvertedPlayerId(GetEnumPlayer())],60.,60.,'d',0)
    call SetUnitTimeScalePercent(udg_SpiritOfGaya[GetConvertedPlayerId(GetEnumPlayer())],80.)
    // (GetConvertedPlayerId(the player being visited)) plus (10).
    call DestroyEffectBJ(udg_SpecialEffect[(GetConvertedPlayerId(GetEnumPlayer())+$A)]) // $A = 10
endfunction

function Trig_Ending_FrozenWorld_RevealSpot takes nothing returns nothing
    call CreateFogModifierRadiusLocBJ(true,GetEnumPlayer(),FOG_OF_WAR_VISIBLE,udg_TempPoint,200.)
endfunction

function Trig_Ending_FrozenWorld_Actions takes nothing returns nothing
    local integer l_tempInteger
    local location l_tempPoint2
    local group l_tempGroup
    call ForForce(udg_EliminatedPlayers,function Trig_Ending_FrozenWorld_EndGameForPlayer)
    if(Trig_Ending_FrozenWorld_NoPlayersLeft())then
        set l_tempPoint2=null
        set l_tempGroup=null
        return
    endif
    set udg_SpawnsPaused=true
    call Music_ClearTrack(17)
    call Music_ClearTrack(18)
    call Music_SetZoneTrack(49)
    call PauseTimerBJ(true,udg_ShadowTimer)
    call PauseTimerBJ(true,udg_BlueGirlTimer)
    call PauseTimerBJ(true,udg_SharedDelayTimer6)
    call PauseTimerBJ(true,udg_SharedDelayTimer3)
    call PauseTimerBJ(true,udg_SiegeTimer)
    call PauseTimerBJ(true,udg_SharedDelayTimer1)
    call PauseTimerBJ(true,udg_SharedDelayTimer2)
    call PauseTimerBJ(true,udg_SharedDelayTimer4)
    call PauseTimerBJ(true,udg_StoryEventTimer)
    call PauseTimerBJ(true,udg_CidResearchTimer)
    call PauseTimerBJ(true,udg_AlmaDisappearTimer)
    call PauseTimerBJ(true,udg_SharedDelayTimer5)
    call SetTimeOfDay(.0)
    call UseTimeOfDayBJ(false)
    call GroupClear(udg_BossUnits)
    call GroupClear(udg_HuntMonsters)
    call GroupClear(udg_QuestUnits)
    call GroupClear(udg_PrimaryQuestUnits)
    call RemoveUnit(udg_BlueGirl)
    if(Trig_Ending_FrozenWorld_Quest17NotDone())then
        call RemoveUnit(gg_unit_U00H_0211)
    endif
    call ForGroupBJ(udg_DarkEidolonIllusions,function Trig_Ending_FrozenWorld_KillAndRemove)
    call DestroyGroup(udg_DarkEidolonIllusions)
    call DestroyLeaderboardBJ(udg_HuntLeaderboard)
    call DestroyLeaderboardBJ(udg_HuntFestivalBoard)
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=udg_QuestsTotal
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        call QuestSetEnabledBJ(false,udg_SideQuest[GetForLoopIndexA()])
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=20
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        call QuestSetEnabledBJ(false,udg_MainQuest[GetForLoopIndexA()])
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    call EnumItemsInRectBJ(GetPlayableMapRect(),function Trig_Ending_FrozenWorld_WipeItems1)
    call Wait_Polled(1.)
    call SetWaterBaseColorBJ(60.,60.,'d',0)
    call SetSkyModel("Environment\\Sky\\BlizzardSky\\BlizzardSky.mdl")
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=50
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        set bj_forLoopBIndex=1
        set bj_forLoopBIndexEnd=50
        loop
            exitwhen bj_forLoopBIndex>bj_forLoopBIndexEnd
            // Calculation 1:
            // Result 1: loop counter A treated as a decimal-capable number.
            // Result 2: (GetRectWidthBJ(GetPlayableMapRect())) times (0.02).
            // Result 3: (result 1) times (result 2).
            // Result 4: (GetRectMinX(GetPlayableMapRect())) plus (result 3).
            // Calculation 2:
            // Result 1: loop counter B treated as a decimal-capable number.
            // Result 2: (GetRectHeightBJ(GetPlayableMapRect())) times (0.02).
            // Result 3: (result 1) times (result 2).
            // Result 4: (GetRectMinY(GetPlayableMapRect())) plus (result 3).
            set udg_TempPoint=Location((GetRectMinX(GetPlayableMapRect())+(I2R(GetForLoopIndexA())*(GetRectWidthBJ(GetPlayableMapRect())*.02))),(GetRectMinY(GetPlayableMapRect())+(I2R(GetForLoopIndexB())*(GetRectHeightBJ(GetPlayableMapRect())*.02))))
            call SetTerrainTypeBJ(udg_TempPoint,'Isnw',-1,5,1) // 'Isnw': object name not found in map data
            call RemoveLocation(udg_TempPoint)
            set bj_forLoopBIndex=bj_forLoopBIndex+1
        endloop
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    call SetBlightRectBJ(false,Player($B),GetEntireMapRect()) // $B = 11
    set l_tempGroup=Group_UnitsOfPlayer(Player($B),Condition(function Trig_Ending_FrozenWorld_HasUserData)) // $B = 11
    call ForGroupBJ(l_tempGroup,function Trig_Ending_FrozenWorld_FadeOutUnit)
    call DestroyGroup(l_tempGroup)
    call EnumItemsInRectBJ(GetPlayableMapRect(),function Trig_Ending_FrozenWorld_WipeItems2)
    call Wait_Polled(1.)
    set l_tempInteger=1
    loop
        exitwhen l_tempInteger>8
        call Trig_Ending_FrozenWorld_SpawnRegionUnits(l_tempInteger)
        set l_tempInteger=l_tempInteger+1
    endloop
    call ForForce(udg_PlayingPlayers,function Trig_Ending_FrozenWorld_FreezePlayerHeroes)
    call EnumItemsInRectBJ(GetPlayableMapRect(),function Trig_Ending_FrozenWorld_WipeItems3)
    call Wait_Polled(1.)
    call ForGroupBJ(udg_FishingSpots,function Trig_Ending_FrozenWorld_RemoveEnumUnit)
    if(Trig_Ending_FrozenWorld_WayGatesVisible())then
        call ShowUnitHide(gg_unit_nwgt_0142)
        call ShowUnitHide(gg_unit_nwgt_0141)
        set udg_WorldUnits=Group_UnitsInRect(GetPlayableMapRect(),Condition(function Trig_Ending_FrozenWorld_IsNotPlayerUnitAlt))
        call ShowUnitShow(gg_unit_nwgt_0142)
        call ShowUnitShow(gg_unit_nwgt_0141)
    else
        set udg_WorldUnits=Group_UnitsInRect(GetPlayableMapRect(),Condition(function Trig_Ending_FrozenWorld_IsNotPlayerUnit))
    endif
    call ForGroupBJ(udg_WorldUnits,function Trig_Ending_FrozenWorld_CloneAsFrozen)
    call ForGroupBJ(udg_FrozenUnits,function Trig_Ending_FrozenWorld_FreezeUnit)
    call EnumItemsInRectBJ(GetPlayableMapRect(),function Trig_Ending_FrozenWorld_WipeItems4)
    call Wait_Polled(1.)
    call EnumDestructablesInRectAll(GetPlayableMapRect(),function Trig_Ending_FrozenWorld_FreezeTrees)
    call EnumItemsInRectBJ(GetPlayableMapRect(),function Trig_Ending_FrozenWorld_WipeItems5)
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=50
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        set udg_QuestItem[GetForLoopIndexA()]=null
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    set udg_ShimmerweedItem=null
    set udg_ThunderbloomItem=null
    call DisableTrigger(gg_trg_Mid_Cage_Ping)
    call DisableTrigger(gg_trg_Ping_ArenaTarget)
    call DisableTrigger(gg_trg_Quest_SaveTimmy_Ping)
    set udg_CinematicActor=Player_GetHero(ForcePickRandomPlayer(udg_PlayingPlayers))
    call Cam_PanToUnit(udg_CinematicActor,0)
    set udg_TempPoint=GetUnitLoc(udg_CinematicActor)
    set l_tempPoint2=Loc_PolarOffset(udg_TempPoint,256,GetUnitFacing(udg_CinematicActor))
    call RemoveLocation(udg_TempPoint)
    // (facing in degrees of udg_CinematicActor) plus (180).
    call CreateNUnitsAtLoc(1,'U00H',Player(8),l_tempPoint2,(GetUnitFacing(udg_CinematicActor)+180.)) // 'U00H': unit "Zodiac Brave of Darkness"
    call RemoveLocation(l_tempPoint2)
    set udg_ZodiacStone=GetLastCreatedUnit()
    call SetHeroLevelBJ(GetLastCreatedUnit(),99,false)
    call ModifyHeroStat(bj_HEROSTAT_STR,GetLastCreatedUnit(),bj_MODIFYMETHOD_SET,999)
    call ModifyHeroStat(bj_HEROSTAT_AGI,GetLastCreatedUnit(),bj_MODIFYMETHOD_SET,999)
    call ModifyHeroStat(bj_HEROSTAT_INT,GetLastCreatedUnit(),bj_MODIFYMETHOD_SET,999)
    call SetUnitInvulnerable(udg_ZodiacStone,true)
    call UnitRemoveAbilityBJ('AInv',udg_ZodiacStone) // 'AInv': standard ability reference "Inventory"
    call Text_Say(null,"An unknown amount of time later ...",true)
    call CinematicFadeBJ(bj_CINEFADETYPE_FADEIN,1.,"ReplaceableTextures\\CameraMasks\\White_mask.blp",0,0,100.,0)
    call Wait_Polled(2.)
    call ForForce(udg_PlayingPlayers,function Trig_Ending_FrozenWorld_DoomEffect1)
    call Wait_Polled(1.)
    call ForForce(udg_PlayingPlayers,function Trig_Ending_FrozenWorld_DoomEffect2)
    call Wait_Polled(1.)
    call ForForce(udg_PlayingPlayers,function Trig_Ending_FrozenWorld_UnfreezePlayerHeroes)
    call Wait_Polled(1.)
    call Text_Say(udg_CinematicActor,"Damn it...! Where did that demon go!?",true)
    call Text_Say(udg_ZodiacStone,"Calm yourself, outsider. What is the last thing you remember?",true)
    call Text_Say(udg_CinematicActor,"We fought the Ice Demon... then he started powering up even further and... we failed to stop him.",true)
    call Text_Say(udg_ZodiacStone,"That's right. Your fight is long since over. The world of Gaya has been frozen over, to be preserved as such for all eternity.",true)
    call Text_Say(udg_CinematicActor,"That can't be right... that's not how it was supposed to go.",true)
    call Text_Say(udg_ZodiacStone,"If it's hard to believe, take a look around for yourself.",true)
    call Text_Say(udg_ZodiacStone,"Whenever you're convinced, come seek me out again.",true)
    call AddSpecialEffectTargetUnitBJ("origin",udg_ZodiacStone,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call Wait_Polled(.7)
    set udg_TempPoint=GetRectCenter(gg_rct_703)
    call SetUnitPositionLocFacingBJ(udg_ZodiacStone,udg_TempPoint,bj_UNIT_FACING)
    call RemoveLocation(udg_TempPoint)
    call GroupAddUnitSimple(udg_ZodiacStone,udg_QuestUnits)
    call Wait_Polled(1.3)
    call Cine_ExitAction()
    set udg_TempPoint=GetRectCenter(gg_rct_645)
    call ForForce(udg_PlayingPlayers,function Trig_Ending_FrozenWorld_RevealSpot)
    call CreateNUnitsAtLoc(1,'e01L',Player(9),udg_TempPoint,bj_UNIT_FACING) // 'e01L': unit "Memories of a Lost Battle"
    call RemoveLocation(udg_TempPoint)
    set udg_SpecialEffect[43]=AddSpecialEffectTargetUnitBJ("overhead",udg_ZodiacStone,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call EnableTrigger(gg_trg_Ending_Wasteland)
    set udg_TempPoint=GetRectCenter(gg_rct_572)
    call CreateNUnitsAtLoc(1,'e00Y',Player(8),udg_TempPoint,135.) // 'e00Y': unit "Mysterious Blue Girl"
    call RemoveLocation(udg_TempPoint)
    set udg_BlueGirl=GetLastCreatedUnit()
    call SetUnitColor(udg_BlueGirl,PLAYER_COLOR_BLUE)
    call EnableTrigger(gg_trg_Bernkastel_Final_Talk)
    call DestroyTrigger(GetTriggeringTrigger())
    set l_tempPoint2=null
    set l_tempGroup=null
endfunction

function Trig_Ending_Wasteland_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,udg_ZodiacStone,true,true,true))
endfunction

function Trig_Ending_Wasteland_ShakeCameraShift takes nothing returns nothing
    call CameraSetSourceNoiseForPlayer(GetEnumPlayer(),30.,.3)
    call CameraSetEQNoiseForPlayer(GetEnumPlayer(),5.)
endfunction

function Trig_Ending_Wasteland_RestoreHeroes takes nothing returns nothing
    call CameraClearNoiseForPlayer(GetEnumPlayer())
    call SetUnitVertexColorBJ(Player_GetHero(GetEnumPlayer()),100.,40.,60.,0)
    call SetUnitTimeScalePercent(Player_GetHero(GetEnumPlayer()),100.)
    call SetUnitVertexColorBJ(udg_SpiritOfGaya[GetConvertedPlayerId(GetEnumPlayer())],100.,40.,60.,0)
    call SetUnitTimeScalePercent(udg_SpiritOfGaya[GetConvertedPlayerId(GetEnumPlayer())],100.)
endfunction

function Trig_Ending_Wasteland_IsNotHeroUnit takes nothing returns boolean
    return(IsUnitType(GetEnumUnit(),UNIT_TYPE_HERO)==false)!=null
endfunction

function Trig_Ending_Wasteland_IsNotStructure takes nothing returns boolean
    return(IsUnitType(GetEnumUnit(),UNIT_TYPE_STRUCTURE)==false)!=null
endfunction

function Trig_Ending_Wasteland_RuinUnit takes nothing returns nothing
    call ShowUnitHide(GetEnumUnit())
    if(Trig_Ending_Wasteland_IsNotStructure())then
        if(Trig_Ending_Wasteland_IsNotHeroUnit())then
            set udg_TempPoint=GetUnitLoc(GetEnumUnit())
            call CreatePermanentCorpseLocBJ(bj_CORPSETYPE_FLESH,GetUnitTypeId(GetEnumUnit()),Player(8),udg_TempPoint,GetRandomDirectionDeg())
            // Calculation 1:
            // A random decimal number between -256 and 256.
            // Calculation 2:
            // A random decimal number between -256 and 256.
            set udg_TempPoint2=OffsetLocation(udg_TempPoint,GetRandomReal(-256.,256.),GetRandomReal(-256.,256.))
            call RemoveLocation(udg_TempPoint)
            call AddSpecialEffectLocBJ(udg_TempPoint2,"Environment\\LargeBuildingFire\\LargeBuildingFire2.mdl")
            call RemoveLocation(udg_TempPoint2)
        endif
    else
        set udg_TempPoint=GetUnitLoc(GetEnumUnit())
        call CreateNUnitsAtLoc(1,GetUnitTypeId(GetEnumUnit()),Player(8),udg_TempPoint,GetUnitFacing(GetEnumUnit()))
        call RemoveLocation(udg_TempPoint)
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_BurningBuildings)
    endif
    call RemoveUnit(GetEnumUnit())
endfunction

function Trig_Ending_Wasteland_BurnBuilding takes nothing returns nothing
    call SetUnitVertexColorBJ(GetEnumUnit(),100.,.0,.0,0)
    call SetUnitAnimation(GetEnumUnit(),"decay")
    call SetUnitTimeScalePercent(GetEnumUnit(),.0)
    call AddSpecialEffectTargetUnitBJ("origin",GetEnumUnit(),"Environment\\LargeBuildingFire\\LargeBuildingFire1.mdl")
    call AddSpecialEffectTargetUnitBJ("head",GetEnumUnit(),"Environment\\LargeBuildingFire\\LargeBuildingFire2.mdl")
    call SetUnitLifeBJ(GetEnumUnit(),1.)
    call PauseUnitBJ(true,GetEnumUnit())
    call SetUnitInvulnerable(GetEnumUnit(),true)
    call UnitRemoveAbilityBJ('AInv',GetEnumUnit()) // 'AInv': standard ability reference "Inventory"
    call UnitRemoveAbilityBJ('Aneu',GetEnumUnit()) // 'Aneu': standard ability reference "Neutral Building"
endfunction

function Trig_Ending_Wasteland_OneInTenChance takes nothing returns boolean
    // A random whole number from 1 through 10.
    return(GetRandomInt(1,$A)==1) // $A = 10
endfunction

function Trig_Ending_Wasteland_IsSnowTree takes nothing returns boolean
    return(GetDestructableTypeId(GetEnumDestructable())=='WTst')or(GetDestructableTypeId(GetEnumDestructable())=='ITtw') // 'WTst': object name not found in map data; 'ITtw': object name not found in map data
endfunction

function Trig_Ending_Wasteland_IsSnowTreeCheck takes nothing returns boolean
    return(Trig_Ending_Wasteland_IsSnowTree())
endfunction

function Trig_Ending_Wasteland_BurnTrees takes nothing returns nothing
    if(Trig_Ending_Wasteland_IsSnowTreeCheck())then
        set udg_TempPoint=GetDestructableLoc(GetEnumDestructable())
        call RemoveDestructable(GetEnumDestructable())
        // Calculation 1:
        // A random decimal number between 0.8 and 1.2.
        // Calculation 2:
        // A random whole number from 0 through 9.
        call CreateDestructableLoc('NTtw',udg_TempPoint,GetRandomDirectionDeg(),GetRandomReal(.8,1.2),GetRandomInt(0,9)) // 'NTtw': object name not found in map data
        if(Trig_Ending_Wasteland_OneInTenChance())then
            call AddSpecialEffectLocBJ(udg_TempPoint,"Environment\\LargeBuildingFire\\LargeBuildingFire1.mdl")
        endif
        call RemoveLocation(udg_TempPoint)
    else
        call SetDestructableAnimationBJ(GetEnumDestructable(),"death")
        call SetDestructableAnimationBJ(GetEnumDestructable(),"decay")
    endif
endfunction

function Trig_Ending_Wasteland_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[43])
    call RemoveUnit(udg_BlueGirl)
    call Cine_Enter()
    call Cam_PanToUnit(GetTriggerUnit(),0)
    call Text_Say(udg_ZodiacStone,"You made it here. Look around us. Are you convinced yet?",true)
    call Text_Say(Player_GetHero(GetTriggerPlayer()),"You were right. The entire world, it's all completely frozen over. I remember now, even I was but a block of ice, for however long I cannot fathom.",true)
    call Text_Transmission(Player_GetHero(GetTriggerPlayer()),udg_PlayerName[GetConvertedPlayerId(GetTriggerPlayer())],"You were right. The entire world, it's all completely frozen over. I remember now, even I was but a block of ice, for however long I cannot fathom.\r\nBut you, you thawed me from this icy prison. Why did you?","You were right. The entire world, it's all completely frozen over. I remember now, even I was but a block of ice, for however long I cannot fathom.",null,0,true)
    call Text_Say(udg_ZodiacStone,"It is but a whim of mine. I wanted you to see the end result of this timeline with your own eyes. What you see before you now, this is the victory of Hashmalum.",true)
    call Text_Say(Player_GetHero(GetTriggerPlayer()),"Right, this is what the icy demon's purpose was in the first place. But why would you want this? Why would you want to freeze an entire world over? Not pillaging it, not even enslaving it. Even if you're demons, there's nothing for you to gain in all this.",true)
    call Text_Say(udg_ZodiacStone,"You are very much right. Even this ending, Hashmalum's victory, leads to no gain for any of the Zodiac Braves. You may not realize this, but the 12 demons were all born in Gaya. And now they too are frozen alongside everything else in this world.",true)
    call Text_Say(Player_GetHero(GetTriggerPlayer()),"What? The demons, too, are frozen here? Then all this makes even less sense. Are you demons all just insane?",true)
    call Text_Say(udg_ZodiacStone,"Not at all, human. It is but a matter of choosing the lesser of two evils.",true)
    call Text_Say(udg_ZodiacStone,"This is but one outcome. A single fragment in the sea. But what if we switch over to a different world?",true)
    call Text_Say(Player_GetHero(GetTriggerPlayer()),"Just one outcome? Fragment? Just who the hell are you anyways!?",true)
    call Text_Say(udg_ZodiacStone,"Hold yourself together for now. Shifting to another fragment can be a bit disorienting if you haven't done it before.",true)
    call ForForce(udg_PlayingPlayers,function Trig_Ending_Wasteland_ShakeCameraShift)
    call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUTIN,2.,"ReplaceableTextures\\CameraMasks\\White_mask.blp",0,0,100.,0)
    call Text_Say(Player_GetHero(GetTriggerPlayer()),"Ugh... feels like my head is splitting...",true)
    call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUTIN,2.,"ReplaceableTextures\\CameraMasks\\White_mask.blp",100.,0,100.,0)
    call Text_Say(Player_GetHero(GetTriggerPlayer()),"Can't... this is too much...!",true)
    call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUT,2.,"ReplaceableTextures\\CameraMasks\\White_mask.blp",100.,0,.0,0)
    call Wait_Polled(2.5)
    call ForForce(udg_PlayingPlayers,function Trig_Ending_Wasteland_RestoreHeroes)
    call ShowUnitHide(udg_ZodiacStone)
    call Music_SetZoneTrack(50)
    call ForGroupBJ(udg_FrozenUnits,function Trig_Ending_Wasteland_RuinUnit)
    call ForGroupBJ(udg_BurningBuildings,function Trig_Ending_Wasteland_BurnBuilding)
    call SetWaterBaseColorBJ(100.,.0,.0,0)
    call SetSkyModel("Environment\\Sky\\Outland_Sky\\Outland_Sky.mdl")
    call EnumDestructablesInRectAll(GetPlayableMapRect(),function Trig_Ending_Wasteland_BurnTrees)
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=50
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        set bj_forLoopBIndex=1
        set bj_forLoopBIndexEnd=50
        loop
            exitwhen bj_forLoopBIndex>bj_forLoopBIndexEnd
            // Calculation 1:
            // Result 1: loop counter A treated as a decimal-capable number.
            // Result 2: (GetRectWidthBJ(GetPlayableMapRect())) times (0.02).
            // Result 3: (result 1) times (result 2).
            // Result 4: (GetRectMinX(GetPlayableMapRect())) plus (result 3).
            // Calculation 2:
            // Result 1: loop counter B treated as a decimal-capable number.
            // Result 2: (GetRectHeightBJ(GetPlayableMapRect())) times (0.02).
            // Result 3: (result 1) times (result 2).
            // Result 4: (GetRectMinY(GetPlayableMapRect())) plus (result 3).
            set udg_TempPoint=Location((GetRectMinX(GetPlayableMapRect())+(I2R(GetForLoopIndexA())*(GetRectWidthBJ(GetPlayableMapRect())*.02))),(GetRectMinY(GetPlayableMapRect())+(I2R(GetForLoopIndexB())*(GetRectHeightBJ(GetPlayableMapRect())*.02))))
            call SetTerrainTypeBJ(udg_TempPoint,'Odtr',-1,5,1) // 'Odtr': object name not found in map data
            // Calculation 1:
            // Result 1: (GetRectWidthBJ(GetPlayableMapRect())) times (-0.02).
            // Result 2: (GetRectWidthBJ(GetPlayableMapRect())) times (0.02).
            // Result 3: a random decimal number between result 1 and result 2.
            // Calculation 2:
            // Result 1: (GetRectHeightBJ(GetPlayableMapRect())) times (-0.02).
            // Result 2: (GetRectHeightBJ(GetPlayableMapRect())) times (0.02).
            // Result 3: a random decimal number between result 1 and result 2.
            set udg_TempPoint2=OffsetLocation(udg_TempPoint,GetRandomReal((GetRectWidthBJ(GetPlayableMapRect())*-.02),(GetRectWidthBJ(GetPlayableMapRect())*.02)),GetRandomReal((GetRectHeightBJ(GetPlayableMapRect())*-.02),(GetRectHeightBJ(GetPlayableMapRect())*.02)))
            call AddSpecialEffectLocBJ(udg_TempPoint2,"Environment\\UndeadBuildingFire\\UndeadLargeBuildingFire2.mdl")
            call RemoveLocation(udg_TempPoint2)
            call RemoveLocation(udg_TempPoint)
            set bj_forLoopBIndex=bj_forLoopBIndex+1
        endloop
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    call SetBlightRectBJ(true,Player($B),GetEntireMapRect()) // $B = 11
    set udg_TempPoint=GetRectCenter(gg_rct_413)
    call SetUnitPositionLocFacingBJ(udg_ZodiacStone,udg_TempPoint,bj_UNIT_FACING)
    call RemoveLocation(udg_TempPoint)
    call Wait_Polled(.5)
    call CinematicFadeBJ(bj_CINEFADETYPE_FADEIN,2.,"ReplaceableTextures\\CameraMasks\\White_mask.blp",100.,0,.0,0)
    call Wait_Polled(2.5)
    call Text_Say(Player_GetHero(GetTriggerPlayer()),"Ngh... where am I now?",true)
    call Text_Say(Player_GetHero(GetTriggerPlayer()),"This is a complete wasteland... what the hell happened?",true)
    call Cine_ExitAction()
    call ShowUnitShow(udg_ZodiacStone)
    set udg_SpecialEffect[43]=AddSpecialEffectTargetUnitBJ("overhead",udg_ZodiacStone,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call EnableTrigger(gg_trg_Ending_ReturnToStart)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Ending_ReturnToStart_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,udg_ZodiacStone,true,true,true))
endfunction

function Trig_Ending_ReturnToStart_EndGameForPlayerFinal takes nothing returns nothing
    call CustomVictoryBJ(GetEnumPlayer(),false,false)
endfunction

function Trig_Ending_ReturnToStart_RemoveEnumUnitFinal takes nothing returns nothing
    call RemoveUnit(GetEnumUnit())
endfunction

function Trig_Ending_ReturnToStart_Actions takes nothing returns nothing
    local location l_tempPoint
    local location l_tempPoint2
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[43])
    call Cine_Enter()
    call Cam_PanToUnit(GetTriggerUnit(),0)
    call Text_Say(udg_ZodiacStone,"It's quite a sight, is it not?",true)
    call Text_Say(Player_GetHero(GetTriggerPlayer()),"What in the hell happened to this world!?",true)
    call Text_Say(udg_ZodiacStone,"What are you saying? This is your victory.",true)
    call Text_Say(Player_GetHero(GetTriggerPlayer()),"Our... victory?",true)
    call Text_Say(udg_ZodiacStone,"Precisely. Just now you were in the world of the Zodiac Braves' victory. And this is the world of yours.",true)
    call Text_Say(Player_GetHero(GetTriggerPlayer()),"Cut the crap. How can this be our victory?",true)
    call Text_Say(udg_ZodiacStone,"This is the inevitable future Gaya is headed towards. Of course this is not immediately after you slay the great demon Echele, but eventually this is destined to be all that remains of your efforts.",true)
    call Text_Say(Player_GetHero(GetTriggerPlayer()),"Destined...? So you're telling me that long after we were to defeat Echele, some other menace comes in and destroys everything? What is this menace that caused all this destruction?",true)
    call Text_Say(udg_ZodiacStone,"What indeed? Perhaps the world gets ravaged by the Zerg. Or maybe the Burning Legion decides to invade. Or perhaps even an interstellar threat such as Lavos or Jenova. Whatever it may be, Gaya will be unable to defend itself. Do you understand?",true)
    call Text_Say(udg_ZodiacStone,"It is not a single threat that will end this world. It's that the world you leave behind is in complete disarray. The dimensional boundary opened up for anyone to come and go. The forces of the Icy Realm freed of its monarchs that control its own people not to attack outwards. The ancient forest overrun with corruption with nobody taking care of it.",true)
    call Text_Say(udg_ZodiacStone,"And all its species, humans, elves, orcs, ogres, gnolls, centaurs, everything... not a semblance of cooperation among them. Not anymore. There's only mutual destruction now.",true)
    call Text_Say(udg_ZodiacStone,"A hundred years ago this world may have been able to withstand outside attacks. I myself was appointed to deal with otherworldly threats, and the Zodiac Brave of Gravity would ensure the world was not invaded lightly. But now, everything is in chaos. All defense systems thoroughly dismantled. Thanks to you.",true)
    call Text_Say(Player_GetHero(GetTriggerPlayer()),"You say the world is thrown into chaos, and that's why anything imaginable can come in and ravage it if they so please? What of the humans and elves in this world, would they not stop this from happening?",true)
    call Text_Say(udg_ZodiacStone,"Them? Please, you know they could not and would not. Maybe if humans and elves cooperated and all fought together. But tell me, did they ever stand with *you*? Did they not just feel content leaving the fate of the world in your hands alone? Surely you don't expect things to be any different without you around.",true)
    call Text_Say(Player_GetHero(GetTriggerPlayer()),"That's...",true)
    call Text_Say(udg_ZodiacStone,"Save your breath and look around yourself. This is no illusion, this is the future of your victory. All you can do now is accept it, or deny it.",true)
    call Text_Say(null,"So that's what you've been up to.",true)
    set l_tempPoint2=GetUnitLoc(udg_ZodiacStone)
    set l_tempPoint=OffsetLocation(l_tempPoint2,0,-600.)
    call RemoveLocation(l_tempPoint2)
    set l_tempPoint2=GetUnitLoc(Player_GetHero(GetTriggerPlayer()))
    call CreateNUnitsAtLocFacingLocBJ(1,'H00V',Player(8),l_tempPoint,l_tempPoint2) // 'H00V': unit "LTM"
    call RemoveLocation(l_tempPoint2)
    call RemoveLocation(l_tempPoint)
    set udg_CinematicActor=GetLastCreatedUnit()
    call AddSpecialEffectTargetUnitBJ("origin",GetLastCreatedUnit(),"Abilities\\Spells\\NightElf\\Blink\\BlinkTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call CinematicFadeBJ(bj_CINEFADETYPE_FADEIN,1.,"ReplaceableTextures\\CameraMasks\\White_mask.blp",0,0,0,0)
    call Wait_Polled(2)
    call Text_Say(udg_ZodiacStone,"Oh how rare of you to show up yourself.",true)
    call Text_Say(Player_GetHero(GetTriggerPlayer()),"Who is that?",true)
    call Text_Say(udg_CinematicActor,"They chose a world outside the loop. No do overs. No revives. So what are you doing here, you serpent?",true)
    call Text_Say(udg_ZodiacStone,"I merely thought it'd be interesting to expand their perspective on the situation they find themselves in. It is such a rare opportunity to go beyond their failure after all.",true)
    call Text_Say(udg_CinematicActor,"Hmph. You just do whatever you feel like. But enough of this.",true)
    call Text_Say(udg_CinematicActor,"Human. The larger fate of the world does not concern you. Do not play around with it. There is nothing to be gained in that.",true)
    call Text_Say(udg_CinematicActor,"You chose a world without my interference, so this world was supposed to end when you lost to the demon Echele.",true)
    call Text_Say(udg_CinematicActor,"So time to return. Back to start.",true)
    call Text_Say(Player_GetHero(GetTriggerPlayer()),"Wait... are you the Legendary-",true)
    call ForForce(GetPlayersAll(),function Trig_Ending_ReturnToStart_EndGameForPlayerFinal)
    call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUT,.0,"ReplaceableTextures\\CameraMasks\\White_mask.blp",0,0,0,0)
    call ForGroupBJ(Trig_Ending_ReturnToStart_EnumUnitsInRect(GetPlayableMapRect()),function Trig_Ending_ReturnToStart_RemoveEnumUnitFinal)
    set l_tempPoint=null
    set l_tempPoint2=null
endfunction

// World Editor calls InitTrig_Ending automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Ending (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Ending takes nothing returns nothing
endfunction

function Register_Ending_FrozenWorld takes nothing returns nothing
    set gg_trg_Ending_FrozenWorld=CreateTrigger()
    call DisableTrigger(gg_trg_Ending_FrozenWorld)
    call TriggerAddAction(gg_trg_Ending_FrozenWorld,function Trig_Ending_FrozenWorld_Actions)
endfunction

function Register_Ending_Wasteland takes nothing returns nothing
    set gg_trg_Ending_Wasteland=CreateTrigger()
    call DisableTrigger(gg_trg_Ending_Wasteland)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Ending_Wasteland,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Ending_Wasteland,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Ending_Wasteland,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Ending_Wasteland,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Ending_Wasteland,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Ending_Wasteland,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Ending_Wasteland,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Ending_Wasteland,Player(7),true)
    call TriggerAddCondition(gg_trg_Ending_Wasteland,Condition(function Trig_Ending_Wasteland_Conditions))
    call TriggerAddAction(gg_trg_Ending_Wasteland,function Trig_Ending_Wasteland_Actions)
endfunction

function Register_Ending_ReturnToStart takes nothing returns nothing
    set gg_trg_Ending_ReturnToStart=CreateTrigger()
    call DisableTrigger(gg_trg_Ending_ReturnToStart)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Ending_ReturnToStart,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Ending_ReturnToStart,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Ending_ReturnToStart,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Ending_ReturnToStart,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Ending_ReturnToStart,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Ending_ReturnToStart,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Ending_ReturnToStart,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Ending_ReturnToStart,Player(7),true)
    call TriggerAddCondition(gg_trg_Ending_ReturnToStart,Condition(function Trig_Ending_ReturnToStart_Conditions))
    call TriggerAddAction(gg_trg_Ending_ReturnToStart,function Trig_Ending_ReturnToStart_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Ending takes nothing returns nothing
    call Register_Ending_FrozenWorld() // starts off; run by IceAge, TrueIceAge
    call Register_Ending_Wasteland() // starts off; enabled by Ending
    call Register_Ending_ReturnToStart() // starts off; enabled by Ending
endfunction

endlibrary
