library TBossGilgamesh requires TCam, TCine, TDifficulty, TJob, TMusic, TPlayerHero, TText, TWait
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Boss_Gilgamesh_Summon=null
    trigger gg_trg_Boss_Gilgamesh_NextSword=null
    trigger gg_trg_Boss_Gilgamesh_Death=null
    trigger gg_trg_Boss_Gilgamesh_Cleanup=null
    // Variables only this module uses.
    integer udg_GilgameshSwordStage=0
    unit udg_GilgameshUnit=null
endglobals

function Trig_Boss_Gilgamesh_Summon_FirstEncounter takes nothing returns boolean
    return(udg_RingHintUsed[2]==false)
endfunction

function Trig_Boss_Gilgamesh_Summon_Actions takes nothing returns nothing
    local location l_tempPoint
    set udg_BossCleanupTrigger=gg_trg_Boss_Gilgamesh_Cleanup
    set udg_GilgameshDefeated=false
    call Cine_Enter()
    call Cam_PanToUnit(gg_unit_n03T_0008,0)
    set l_tempPoint=GetRectCenter(gg_rct_473)
    call AddSpecialEffectLocBJ(l_tempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(l_tempPoint)
    call Wait_Polled(.5)
    set l_tempPoint=GetRectCenter(gg_rct_473)
    call CreateNUnitsAtLoc(1,'N0LU',Player($B),l_tempPoint,270.) // 'N0LU': unit "Mighty Swordsman"; $B = 11
    call RemoveLocation(l_tempPoint)
    set udg_GilgameshUnit=GetLastCreatedUnit()
    call Difficulty_SumHandicap(udg_DuelArenaPlayers)
    set udg_EnemyHandicap=(udg_EnemyHandicap/ GetPlayerHandicapBJ(Player($B))) // $B = 11
    call BlzSetUnitMaxHP(GetLastCreatedUnit(),R2I((GetUnitStateSwap(UNIT_STATE_MAX_LIFE,GetLastCreatedUnit())*udg_EnemyHandicap)))
    call Cam_PanToUnit(udg_GilgameshUnit,.2)
    call PauseUnitBJ(true,udg_GilgameshUnit)
    call SetUnitInvulnerable(udg_GilgameshUnit,true)
    call SetHeroLevelBJ(udg_GilgameshUnit,91,false)
    call UnitAddItemByIdSwapped('I011',udg_GilgameshUnit) // 'I011': item "Excalibur"
    call UnitAddItemByIdSwapped('I0DN',udg_GilgameshUnit) // 'I0DN': item "Genji Shield L"
    call UnitAddItemByIdSwapped('I0DO',udg_GilgameshUnit) // 'I0DO': item "Genji Mask Y"
    call UnitAddItemByIdSwapped('I0DP',udg_GilgameshUnit) // 'I0DP': item "Genji Armor D"
    call UnitAddItemByIdSwapped('I00G',udg_GilgameshUnit) // 'I00G': item "Armguard"
    call UnitAddItemByIdSwapped('sror',udg_GilgameshUnit) // 'sror': item "Spirit of Lowtown"
    call Wait_Polled(1.)
    if(Trig_Boss_Gilgamesh_Summon_FirstEncounter())then
        set udg_RingHintUsed[2]=true
        call Text_Say(udg_GilgameshUnit,"How long I've waited!",true)
        call Text_Say(udg_GilgameshUnit,"Gilgamesh fights again!",true)
    endif
    call Cine_ExitAction()
    call SetUnitInvulnerable(udg_GilgameshUnit,false)
    call PauseUnitBJ(false,udg_GilgameshUnit)
    call Music_SetTrack(25)
    call IssueImmediateOrderBJ(udg_GilgameshUnit,"spiritwolf")
    set udg_GilgameshSwordStage=1
    call TriggerRegisterUnitEvent(gg_trg_Boss_Gilgamesh_NextSword,udg_GilgameshUnit,EVENT_UNIT_DEATH)
    call EnableTrigger(gg_trg_Boss_Gilgamesh_NextSword)
    call GroupAddUnitSimple(udg_GilgameshUnit,udg_BossGroup)
    set l_tempPoint=GetUnitLoc(udg_GilgameshUnit)
    call CreateNUnitsAtLocFacingLocBJ(1,'h027',GetOwningPlayer(GetTriggerUnit()),l_tempPoint,l_tempPoint) // 'h027': unit "Gilgamesh Dummy"
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(2.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call IssueTargetOrderBJ(GetLastCreatedUnit(),"bloodlust",udg_GilgameshUnit)
    call CreateNUnitsAtLocFacingLocBJ(1,'h027',GetOwningPlayer(GetTriggerUnit()),l_tempPoint,l_tempPoint) // 'h027': unit "Gilgamesh Dummy"
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(2.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call IssueTargetOrderBJ(GetLastCreatedUnit(),"frostarmor",udg_GilgameshUnit)
    call CreateNUnitsAtLocFacingLocBJ(1,'h027',GetOwningPlayer(GetTriggerUnit()),l_tempPoint,l_tempPoint) // 'h027': unit "Gilgamesh Dummy"
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(2.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call IssueTargetOrderBJ(GetLastCreatedUnit(),"antimagicshell",udg_GilgameshUnit)
    call RemoveLocation(l_tempPoint)
    set l_tempPoint=null
endfunction

function Trig_Boss_Gilgamesh_NextSword_Conditions takes nothing returns boolean
    return(GetTriggerUnit()==udg_GilgameshUnit)
endfunction

function Trig_Boss_Gilgamesh_NextSword_IsStage3 takes nothing returns boolean
    return(udg_GilgameshSwordStage==3)
endfunction

function Trig_Boss_Gilgamesh_NextSword_IsStage2 takes nothing returns boolean
    return(udg_GilgameshSwordStage==2)
endfunction

function Trig_Boss_Gilgamesh_NextSword_IsStage1 takes nothing returns boolean
    return(udg_GilgameshSwordStage==1)
endfunction

function Trig_Boss_Gilgamesh_NextSword_HasMoreSwords takes nothing returns boolean
    return(udg_GilgameshSwordStage<4)
endfunction

function Trig_Boss_Gilgamesh_NextSword_Actions takes nothing returns nothing
    local location l_tempPoint
    local location l_tempPoint3
    set l_tempPoint3=GetUnitLoc(GetTriggerUnit())
    call ReviveHeroLoc(udg_GilgameshUnit,l_tempPoint3,false)
    call RemoveLocation(l_tempPoint3)
    call SetUnitInvulnerable(udg_GilgameshUnit,true)
    call Cine_Enter()
    call Cam_PanToUnit(udg_GilgameshUnit,0)
    call RemoveItem(GetItemOfTypeFromUnitBJ(udg_GilgameshUnit,'sror')) // 'sror': item "Spirit of Lowtown"
    call Wait_Polled(1.)
    call UnitAddItemByIdSwapped('sror',udg_GilgameshUnit) // 'sror': item "Spirit of Lowtown"
    call RemoveItem(UnitItemInSlotBJ(udg_GilgameshUnit,(udg_GilgameshSwordStage+1)))
    call Text_Say(udg_GilgameshUnit,"Hmph. How about this?",false)
    if(Trig_Boss_Gilgamesh_NextSword_IsStage1())then
        call UnitAddItemByIdSwapped('I0HD',udg_GilgameshUnit) // 'I0HD': item "Explosion Sword"
        call Text_Say(udg_GilgameshUnit,"|cffffcc00Gilgamesh equips the \"Explosion Sword\"!|r",true)
    else
        if(Trig_Boss_Gilgamesh_NextSword_IsStage2())then
            call UnitAddItemByIdSwapped('I0HE',udg_GilgameshUnit) // 'I0HE': item "Sanguine Sword"
            call Text_Say(udg_GilgameshUnit,"|cffffcc00Gilgamesh equips the \"Sanguine Sword\"!|r",true)
        else
            if(Trig_Boss_Gilgamesh_NextSword_IsStage3())then
                call UnitAddItemByIdSwapped('I0HF',udg_GilgameshUnit) // 'I0HF': item "Demi Sword"
                call Text_Say(udg_GilgameshUnit,"|cffffcc00Gilgamesh equips the \"Demi Sword\"!|r",true)
            else
                call UnitAddItemByIdSwapped('I0HG',udg_GilgameshUnit) // 'I0HG': item "Joker Sword"
                call UnitResetCooldown(udg_GilgameshUnit)
                call Text_Say(udg_GilgameshUnit,"|cffffcc00Gilgamesh equips the \"Joker Sword\"!|r",true)
            endif
        endif
    endif
    set udg_GilgameshSwordStage=(udg_GilgameshSwordStage+1)
    call Cine_ExitAction()
    call SetUnitInvulnerable(udg_GilgameshUnit,false)
    set l_tempPoint=GetUnitLoc(udg_GilgameshUnit)
    call CreateNUnitsAtLocFacingLocBJ(1,'h027',GetOwningPlayer(GetTriggerUnit()),l_tempPoint,l_tempPoint) // 'h027': unit "Gilgamesh Dummy"
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(2.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call IssueTargetOrderBJ(GetLastCreatedUnit(),"bloodlust",udg_GilgameshUnit)
    call CreateNUnitsAtLocFacingLocBJ(1,'h027',GetOwningPlayer(GetTriggerUnit()),l_tempPoint,l_tempPoint) // 'h027': unit "Gilgamesh Dummy"
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(2.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call IssueTargetOrderBJ(GetLastCreatedUnit(),"frostarmor",udg_GilgameshUnit)
    call CreateNUnitsAtLocFacingLocBJ(1,'h027',GetOwningPlayer(GetTriggerUnit()),l_tempPoint,l_tempPoint) // 'h027': unit "Gilgamesh Dummy"
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(2.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call IssueTargetOrderBJ(GetLastCreatedUnit(),"antimagicshell",udg_GilgameshUnit)
    call RemoveLocation(l_tempPoint)
    call SetUnitLifePercentBJ(udg_GilgameshUnit,100.)
    call SetUnitManaPercentBJ(udg_GilgameshUnit,'d')
    if(Trig_Boss_Gilgamesh_NextSword_HasMoreSwords())then
        call EnableTrigger(GetTriggeringTrigger())
    else
        call TriggerRegisterUnitEvent(gg_trg_Boss_Gilgamesh_Death,udg_GilgameshUnit,EVENT_UNIT_DEATH)
        call EnableTrigger(gg_trg_Boss_Gilgamesh_Death)
    endif
    set l_tempPoint=null
    set l_tempPoint3=null
endfunction

function Trig_Boss_Gilgamesh_Death_Conditions takes nothing returns boolean
    return(GetTriggerUnit()==udg_GilgameshUnit)
endfunction

function Trig_Boss_Gilgamesh_Death_ShouldRecordKill takes nothing returns boolean
    return(udg_SpeedrunMode)
endfunction

function Trig_Boss_Gilgamesh_Death_FlagPlayerCleared takes nothing returns nothing
    call ForceAddPlayerSimple(GetEnumPlayer(),udg_LuShangPending)
endfunction

function Trig_Boss_Gilgamesh_Death_CoinFlip takes nothing returns boolean
    // A random whole number from 1 through 2.
    return(GetRandomInt(1,2)==1)
endfunction

function Trig_Boss_Gilgamesh_Death_TwoThirdsChance takes nothing returns boolean
    // A random whole number from 1 through 3.
    return(GetRandomInt(1,3)<=2)
endfunction

function Trig_Boss_Gilgamesh_Death_CanMasterJob takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A02F',Player_GetHero(udg_SummonerPlayer))==3)and(IsPlayerInForce(udg_SummonerPlayer,udg_QuestForce[udg_TempInteger])==false) // 'A02F': ability "Mastery"
endfunction

function Trig_Boss_Gilgamesh_Death_SummonerIsPlayer takes nothing returns boolean
    return(udg_SummonerPlayer!=Player($B)) // $B = 11
endfunction

function Trig_Boss_Gilgamesh_Death_IsWaygateOpen takes nothing returns boolean
    return(udg_HolyAnkhUsed)
endfunction

function Trig_Boss_Gilgamesh_Death_Actions takes nothing returns nothing
    local location l_tempPoint
    call DisableTrigger(GetTriggeringTrigger())
    if(Trig_Boss_Gilgamesh_Death_ShouldRecordKill())then
        set udg_BossUnit=null
        set udg_TempString="|cffff4040Gilgamesh 2|r defeated in "
        call ConditionalTriggerExecute(gg_trg_Speedrun_Accolade)
    endif
    call Cine_Enter()
    set l_tempPoint=GetUnitLoc(udg_GilgameshUnit)
    call ReviveHeroLoc(udg_GilgameshUnit,l_tempPoint,false)
    call RemoveLocation(l_tempPoint)
    call SetUnitInvulnerable(udg_GilgameshUnit,true)
    call PauseUnitBJ(true,udg_GilgameshUnit)
    call GroupRemoveUnitSimple(udg_GilgameshUnit,udg_BossGroup)
    call Cam_PanToUnit(udg_GilgameshUnit,0)
    call Text_Say(udg_GilgameshUnit,"...",true)
    call Text_Say(udg_GilgameshUnit,"...well I better be off! See ya!",true)
    set udg_GilgameshDefeated=true
    call SaveIntegerBJ(0,2,'l',udg_GameStateHash)
    set udg_ArenaBonusBattle[0]=(udg_ArenaBonusBattle[0]+1)
    set udg_ArenaBonusBattle[udg_ArenaBonusBattle[0]]='m'
    call ForForce(udg_PlayingPlayers,function Trig_Boss_Gilgamesh_Death_FlagPlayerCleared)
    set l_tempPoint=GetUnitLoc(udg_GilgameshUnit)
    call AddSpecialEffectLocBJ(l_tempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(l_tempPoint)
    call Wait_Polled(.5)
    set l_tempPoint=GetUnitLoc(udg_GilgameshUnit)
    call CreateItemLoc('I01Z',l_tempPoint) // 'I01Z': item "Crystal Shard"
    call CreateItemLoc('I07B',l_tempPoint) // 'I07B': item "Samurai's Amulet"
    call CreateItemLoc('I0DT',l_tempPoint) // 'I0DT': item "Curse: Masamune"
    call CreateItemLoc('I0B0',l_tempPoint) // 'I0B0': item "Genji Gloves"
    if(Trig_Boss_Gilgamesh_Death_TwoThirdsChance())then
        call CreateItemLoc('I01Y',l_tempPoint) // 'I01Y': item "Genji Armor"
        if(Trig_Boss_Gilgamesh_Death_CoinFlip())then
            call CreateItemLoc('I0BU',l_tempPoint) // 'I0BU': item "Genji Shield"
        else
            call CreateItemLoc('I0AA',l_tempPoint) // 'I0AA': item "Genji Mask"
        endif
    else
        call CreateItemLoc('I0BU',l_tempPoint) // 'I0BU': item "Genji Shield"
        call CreateItemLoc('I0AA',l_tempPoint) // 'I0AA': item "Genji Mask"
    endif
    call RemoveLocation(l_tempPoint)
    call RemoveItem(udg_SummonItem)
    call Music_ClearTrack(25)
    call PlayThematicMusicBJ("war3mapImported\\FFX-Victory.mp3")
    if(Trig_Boss_Gilgamesh_Death_SummonerIsPlayer())then
        set udg_TempInteger=Job_GetIndex(Player_GetHero(udg_SummonerPlayer))
        if(Trig_Boss_Gilgamesh_Death_CanMasterJob())then
            call ForceAddPlayerSimple(udg_SummonerPlayer,udg_QuestForce[udg_TempInteger])
            call AddSpecialEffectTargetUnitBJ("origin",Player_GetHero(udg_SummonerPlayer),"Abilities\\Spells\\Other\\Levelup\\LevelupCaster.mdl")
            call DestroyEffectBJ(GetLastCreatedEffectBJ())
        endif
    endif
    call DisplayTextToForce(udg_PlayingPlayers,(("|cffaa0000"+GetHeroProperName(GetDyingUnit()))+"|r was defeated !!!"))
    call RemoveUnit(udg_GilgameshUnit)
    if(Trig_Boss_Gilgamesh_Death_IsWaygateOpen())then
        call WaygateActivateBJ(true,gg_unit_n0AP_0240)
        set udg_SpecialEffect[78]=AddSpecialEffectTargetUnitBJ("origin",gg_unit_n0AP_0240,"Abilities\\Spells\\Human\\Brilliance\\Brilliance.mdl")
    endif
    set udg_RingHintsReady=true
    call UnitRemoveAbilityBJ('A0HJ',gg_unit_n03T_0008) // 'A0HJ': ability "Excalipoor Hint"
    call UnitAddAbilityBJ('Ane2',gg_unit_n03T_0008) // 'Ane2': object name not found in map data
    call Cine_ExitAction()
    set l_tempPoint=null
endfunction

function Trig_Boss_Gilgamesh_Cleanup_Actions takes nothing returns nothing
    call DisableTrigger(gg_trg_Boss_Gilgamesh_NextSword)
    call DisableTrigger(gg_trg_Boss_Gilgamesh_Death)
    call GroupRemoveUnitSimple(udg_GilgameshUnit,udg_BossGroup)
    call KillUnit(udg_GilgameshUnit)
    call RemoveUnit(udg_GilgameshUnit)
    call Music_ClearTrack(25)
    set udg_GilgameshDefeated=true
endfunction

function InitTrig_Boss_Gilgamesh takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Boss_Part12 (module Boss),
// which keeps the original registration order.

function Register_Boss_Gilgamesh_Summon takes nothing returns nothing
    set gg_trg_Boss_Gilgamesh_Summon=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_Gilgamesh_Summon)
    call TriggerAddAction(gg_trg_Boss_Gilgamesh_Summon,function Trig_Boss_Gilgamesh_Summon_Actions)
endfunction

function Register_Boss_Gilgamesh_NextSword takes nothing returns nothing
    set gg_trg_Boss_Gilgamesh_NextSword=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_Gilgamesh_NextSword)
    call TriggerAddCondition(gg_trg_Boss_Gilgamesh_NextSword,Condition(function Trig_Boss_Gilgamesh_NextSword_Conditions))
    call TriggerAddAction(gg_trg_Boss_Gilgamesh_NextSword,function Trig_Boss_Gilgamesh_NextSword_Actions)
endfunction

function Register_Boss_Gilgamesh_Death takes nothing returns nothing
    set gg_trg_Boss_Gilgamesh_Death=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_Gilgamesh_Death)
    call TriggerAddCondition(gg_trg_Boss_Gilgamesh_Death,Condition(function Trig_Boss_Gilgamesh_Death_Conditions))
    call TriggerAddAction(gg_trg_Boss_Gilgamesh_Death,function Trig_Boss_Gilgamesh_Death_Actions)
endfunction

function Register_Boss_Gilgamesh_Cleanup takes nothing returns nothing
    set gg_trg_Boss_Gilgamesh_Cleanup=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_Gilgamesh_Cleanup)
    call TriggerAddAction(gg_trg_Boss_Gilgamesh_Cleanup,function Trig_Boss_Gilgamesh_Cleanup_Actions)
endfunction

endlibrary
