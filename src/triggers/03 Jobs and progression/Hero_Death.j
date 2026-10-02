library THeroDeath requires TForce, TGroup, TPlayerPart01, TWait
function Trig_Hero_Death_Revive_Conditions takes nothing returns boolean
    return((IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(GetUnitTypeId(GetTriggerUnit())!='H01D'))!=null // 'H01D': unit "Spirit of Gaya"
endfunction

function Trig_Hero_Death_Revive_KillerIsHero takes nothing returns boolean
    return(IsUnitType(GetKillingUnitBJ(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Hero_Death_Revive_HasKiller takes nothing returns boolean
    return(GetKillingUnitBJ()!=null)and(GetKillingUnitBJ()!=GetTriggerUnit())
endfunction

function Trig_Hero_Death_Revive_MessagesAllowed takes nothing returns boolean
    return(udg_SuppressDeathMessages==false)
endfunction

function Trig_Hero_Death_Revive_RemoveEnumUnit takes nothing returns nothing
    call RemoveUnit(GetEnumUnit())
endfunction

function Trig_Hero_Death_Revive_NoRevive takes nothing returns boolean
    return(udg_HardcoreOff==false)
endfunction

function Trig_Hero_Death_Revive_HasLivingFlame takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0YU',GetTriggerUnit())>0) // 'A0YU': ability "Living Flame"
endfunction

function Trig_Hero_Death_Revive_IsLivingFlameTarget takes nothing returns boolean
    return(IsUnitInGroup(GetTriggerUnit(),udg_LivingFlameUnits))
endfunction

function Trig_Hero_Death_Revive_LosesExpOnDeath takes nothing returns boolean
    return(GetHeroLevel(GetTriggerUnit())>=20)and(GetHeroLevel(GetTriggerUnit())<99)
endfunction

function Trig_Hero_Death_Revive_HasGoldPenaltyPerk1 takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_TitleForce[3]))
endfunction

function Trig_Hero_Death_Revive_HasGoldPenaltyPerk2 takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_TitleForce[6]))
endfunction

function Trig_Hero_Death_Revive_HasGoldLossCap takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_LegendaryGuardianForce))and(udg_StatCalcValue>$2710) // $2710 = 10000
endfunction

function Trig_Hero_Death_Revive_NoGoldLoss takes nothing returns boolean
    return(udg_StatCalcValue<=0)
endfunction

function Trig_Hero_Death_Revive_CanAutoFullRestore takes nothing returns boolean
    // (unit level of the triggering unit) times (3).
    return(udg_AutoBrewEnabled[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])and(GetPlayerState(GetOwningPlayer(GetTriggerUnit()),PLAYER_STATE_RESOURCE_GOLD)>=(GetUnitLevel(GetTriggerUnit())*3))
endfunction

function Trig_Hero_Death_Revive_HasNoDeathPenalty takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_TitleForce[56]))
endfunction

function Trig_Hero_Death_Revive_Actions takes nothing returns nothing
    call DialogDisplay(GetOwningPlayer(GetTriggerUnit()),udg_WarpDialog,false)
    if(Trig_Hero_Death_Revive_MessagesAllowed())then
        if(Trig_Hero_Death_Revive_HasKiller())then
            if(Trig_Hero_Death_Revive_KillerIsHero())then
                call DisplayTimedTextToForce(GetPlayersAll(),10.,((("|cffffcc00"+udg_PlayerName[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])+("|r (Level "+((I2S(GetHeroLevel(GetTriggerUnit()))+" ")+GetUnitName(GetTriggerUnit()))))+(") has been killed by |cffffcc00"+GetHeroProperName(GetKillingUnitBJ()))))
            else
                call DisplayTimedTextToForce(GetPlayersAll(),10.,((("|cffffcc00"+udg_PlayerName[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])+("|r (Level "+((I2S(GetHeroLevel(GetTriggerUnit()))+" ")+GetUnitName(GetTriggerUnit()))))+(") has been killed by |cffffcc00"+GetUnitName(GetKillingUnitBJ()))))
            endif
        else
            call DisplayTimedTextToForce(GetPlayersAll(),10.,((("|cffffcc00"+udg_PlayerName[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])+("|r (Level "+((I2S(GetHeroLevel(GetTriggerUnit()))+" ")+GetUnitName(GetTriggerUnit()))))+") has perished."))
        endif
    endif
    if(Trig_Hero_Death_Revive_NoRevive())then
        set bj_forLoopAIndex=1
        set bj_forLoopAIndexEnd=6
        loop
            exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
            call UnitRemoveItemFromSlotSwapped(GetForLoopIndexA(),Player_GetHero(GetTriggerPlayer()))
            call UnitRemoveItemFromSlotSwapped(GetForLoopIndexA(),udg_SpiritOfGaya[GetConvertedPlayerId(GetTriggerPlayer())])
            call UnitRemoveItemFromSlotSwapped(GetForLoopIndexA(),udg_PlayerHouse[GetConvertedPlayerId(GetTriggerPlayer())])
            set bj_forLoopAIndex=bj_forLoopAIndex+1
        endloop
        call KillUnit(udg_SpiritOfGaya[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
        call KillUnit(udg_PlayerHouse[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
        call ForGroupBJ(Group_AllUnitsOfPlayer(GetOwningPlayer(GetTriggerUnit())),function Trig_Hero_Death_Revive_RemoveEnumUnit)
        call ForceAddPlayerSimple(GetOwningPlayer(GetTriggerUnit()),udg_EliminatedPlayers)
        return
    endif
    set udg_SpeedrunFlag[1]=true
    call SetDestructableAnimationBJ(gg_dest_BTrx_0011,"Stand Work")
    set udg_TempPoint3=GetRectCenter(gg_rct_571)
    call PanCameraToTimedLocForPlayer(GetOwningPlayer(GetTriggerUnit()),udg_TempPoint3,.0)
    call ReviveHeroLoc(GetTriggerUnit(),udg_TempPoint3,true)
    call RemoveLocation(udg_TempPoint3)
    call SelectUnitForPlayerSingle(GetTriggerUnit(),GetOwningPlayer(GetTriggerUnit()))
    call StartTimerBJ(udg_PostReviveTimer,false,.01)
    call AddSpecialEffectTargetUnitBJ("origin",GetTriggerUnit(),"Abilities\\Spells\\Orc\\Reincarnation\\ReincarnationTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call UnitAddItemByIdSwapped('I0A4',GetTriggerUnit()) // 'I0A4': item "Spawn Protection"
    if(Trig_Hero_Death_Revive_IsLivingFlameTarget())then
        call GroupRemoveUnitSimple(GetTriggerUnit(),udg_LivingFlameUnits)
        call UnitRemoveAbilityBJ('A0YV',GetTriggerUnit()) // 'A0YV': ability "Living Flame Cool Down"
        if(Trig_Hero_Death_Revive_HasLivingFlame())then
            call UnitRemoveAbilityBJ('A0YU',GetTriggerUnit()) // 'A0YU': ability "Living Flame"
        endif
    endif
    call PauseUnitBJ(true,GetTriggerUnit())
    call IssueImmediateOrderBJ(GetTriggerUnit(),"stop")
    call PauseUnitBJ(false,GetTriggerUnit())
    call GroupAddUnitSimple(GetTriggerUnit(),udg_RevivedHeroes)
    call StartTimerBJ(udg_ReviveCleanupTimer,false,.0)
    if(Trig_Hero_Death_Revive_HasNoDeathPenalty())then
        call SetUnitLifePercentBJ(GetTriggerUnit(),'d')
        call SetUnitManaPercentBJ(GetTriggerUnit(),'d')
    else
        set udg_TempForce=Force_OfPlayer(GetOwningPlayer(GetTriggerUnit()))
        if(Trig_Hero_Death_Revive_LosesExpOnDeath())then
            call DisplayTextToForce(udg_TempForce,"As penalty for death you lose experience and gold.")
            // ((-1) times ((hero level of the triggering unit) divided by (2))) times (hero level of the triggering unit).
            call AddHeroXPSwapped(((-1*(GetHeroLevel(GetTriggerUnit())/ 2))*GetHeroLevel(GetTriggerUnit())),GetTriggerUnit(),false)
            // ((hero level of the triggering unit) divided by (2)) times (hero level of the triggering unit).
            call DisplayTextToForce(udg_TempForce,("You lose "+(I2S(((GetHeroLevel(GetTriggerUnit())/ 2)*GetHeroLevel(GetTriggerUnit())))+" exp.")))
        else
            call DisplayTextToForce(udg_TempForce,"As penalty for death you lose gold.")
        endif
        // Result 1: (hero level of udg_SpiritOfGaya at position GetConvertedPlayerId(GetOwningPlayer(the triggering
        // unit))) plus (1).
        // Result 2: (4) times (result 1).
        // Result 3: (hero level of the triggering unit) plus (1).
        // Result 4: (result 2) times (result 3).
        set udg_StatCalcValue=((4*(GetHeroLevel(udg_SpiritOfGaya[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])+1))*(GetHeroLevel(GetTriggerUnit())+1))
        if(Trig_Hero_Death_Revive_HasGoldPenaltyPerk1())then
            // Decrease udg_StatCalcValue by 10000.
            set udg_StatCalcValue=(udg_StatCalcValue-$2710) // $2710 = 10000
        endif
        if(Trig_Hero_Death_Revive_HasGoldPenaltyPerk2())then
            // Decrease udg_StatCalcValue by 10000.
            set udg_StatCalcValue=(udg_StatCalcValue-$2710) // $2710 = 10000
        endif
        if(Trig_Hero_Death_Revive_HasGoldLossCap())then
            set udg_StatCalcValue=$2710 // $2710 = 10000
        endif
        if(Trig_Hero_Death_Revive_NoGoldLoss())then
            set udg_StatCalcValue=0
        else
            // (-1) times (udg_StatCalcValue).
            call AdjustPlayerStateBJ((-1*udg_StatCalcValue),GetOwningPlayer(GetDyingUnit()),PLAYER_STATE_RESOURCE_GOLD)
        endif
        call DisplayTextToForce(udg_TempForce,("You lose "+(I2S(udg_StatCalcValue)+" gold.")))
        call DestroyForce(udg_TempForce)
        if(Trig_Hero_Death_Revive_CanAutoFullRestore())then
            call AddSpecialEffectTargetUnitBJ("origin",GetTriggerUnit(),"Abilities\\Spells\\Items\\AIre\\AIreTarget.mdl")
            call DestroyEffectBJ(GetLastCreatedEffectBJ())
            call SetUnitLifePercentBJ(GetTriggerUnit(),'d')
            call SetUnitManaPercentBJ(GetTriggerUnit(),'d')
            call SetUnitManaBJ(udg_SpiritOfGaya[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],990000.)
            // (-3) times (unit level of the triggering unit).
            call AdjustPlayerStateBJ((-3*GetUnitLevel(GetTriggerUnit())),GetOwningPlayer(GetTriggerUnit()),PLAYER_STATE_RESOURCE_GOLD)
        else
            call SetUnitLifePercentBJ(GetTriggerUnit(),50.)
            call SetUnitManaPercentBJ(GetTriggerUnit(),10.)
        endif
    endif
    call Wait_Polled(2)
    call SetDestructableAnimationBJ(gg_dest_BTrx_0011,"Stand Alternate")
endfunction

function InitTrig_Hero_Death takes nothing returns nothing
endfunction

endlibrary
