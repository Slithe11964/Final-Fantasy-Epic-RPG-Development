library TBossBlackDevil requires TCam, TCine, TDifficulty, TMusic, TText, TWait
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Boss_BlackDevil_Summon=null
    trigger gg_trg_Boss_BlackDevil_Death=null
    trigger gg_trg_Boss_BlackDevil_Cleanup=null
    // Variables only this module uses.
    unit udg_BlackDevilUnit=null
endglobals

function Trig_Boss_BlackDevil_Summon_FirstEncounter takes nothing returns boolean
    return(udg_RingHintUsed[4]==false)
endfunction

function Trig_Boss_BlackDevil_Summon_Actions takes nothing returns nothing
    local location l_tempPoint
    set udg_BossCleanupTrigger=gg_trg_Boss_BlackDevil_Cleanup
    call Cine_Enter()
    call Cam_PanToUnit(gg_unit_n03T_0008,0)
    set l_tempPoint=GetRectCenter(gg_rct_473)
    call AddSpecialEffectLocBJ(l_tempPoint,"Abilities\\Spells\\Undead\\Sleep\\SleepSpecialArt.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call AddSpecialEffectLocBJ(l_tempPoint,"Abilities\\Spells\\Demon\\DarkPortal\\DarkPortalTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(l_tempPoint)
    call Wait_Polled(.5)
    set l_tempPoint=GetRectCenter(gg_rct_473)
    call AddSpecialEffectLocBJ(l_tempPoint,"Abilities\\Spells\\Undead\\Sleep\\SleepSpecialArt.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call AddSpecialEffectLocBJ(l_tempPoint,"Abilities\\Spells\\Demon\\DarkPortal\\DarkPortalTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(l_tempPoint)
    call Wait_Polled(.5)
    set l_tempPoint=GetRectCenter(gg_rct_473)
    call AddSpecialEffectLocBJ(l_tempPoint,"Abilities\\Spells\\Undead\\Sleep\\SleepSpecialArt.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call AddSpecialEffectLocBJ(l_tempPoint,"Abilities\\Spells\\Demon\\DarkPortal\\DarkPortalTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(l_tempPoint)
    call Wait_Polled(1.5)
    call Difficulty_SumHandicap(udg_DuelArenaPlayers)
    set udg_EnemyHandicap=(udg_EnemyHandicap/ GetPlayerHandicapBJ(Player($B))) // $B = 11
    set l_tempPoint=GetRectCenter(gg_rct_473)
    call CreateNUnitsAtLoc(1,'E00X',Player($B),l_tempPoint,270.) // 'E00X': unit "Black Devil"; $B = 11
    call RemoveLocation(l_tempPoint)
    set udg_BlackDevilUnit=GetLastCreatedUnit()
    call BlzSetUnitMaxHP(GetLastCreatedUnit(),R2I((GetUnitStateSwap(UNIT_STATE_MAX_LIFE,GetLastCreatedUnit())*udg_EnemyHandicap)))
    call SetHeroLevelBJ(udg_BlackDevilUnit,85,false)
    call UnitAddItemByIdSwapped('I0H5',udg_BlackDevilUnit) // 'I0H5': item "Dark Energy"
    call UnitAddItemByIdSwapped('I0H5',udg_BlackDevilUnit) // 'I0H5': item "Dark Energy"
    call SetUnitLifePercentBJ(udg_BlackDevilUnit,'d')
    call SetUnitManaPercentBJ(udg_BlackDevilUnit,'d')
    call SetUnitInvulnerable(udg_BlackDevilUnit,true)
    call PauseUnitBJ(true,udg_BlackDevilUnit)
    call Wait_Polled(2.)
    if(Trig_Boss_BlackDevil_Summon_FirstEncounter())then
        set udg_RingHintUsed[4]=true
        call Text_Say(udg_BlackDevilUnit,"Who dares disturb my sleep?",true)
    endif
    call SetUnitInvulnerable(udg_BlackDevilUnit,false)
    call PauseUnitBJ(false,udg_BlackDevilUnit)
    call Music_SetTrack(27)
    call GroupAddUnitSimple(udg_BlackDevilUnit,udg_BossGroup)
    call TriggerRegisterUnitEvent(gg_trg_Boss_BlackDevil_Death,udg_BlackDevilUnit,EVENT_UNIT_DEATH)
    call EnableTrigger(gg_trg_Boss_BlackDevil_Death)
    call Cine_Exit()
    set l_tempPoint=null
endfunction

function Trig_Boss_BlackDevil_Death_Conditions takes nothing returns boolean
    return(GetTriggerUnit()==udg_BlackDevilUnit)
endfunction

function Trig_Boss_BlackDevil_Death_ShouldRecordKill takes nothing returns boolean
    return(udg_SpeedrunMode)
endfunction

function Trig_Boss_BlackDevil_Death_TwoKillsDone takes nothing returns boolean
    return(udg_UrnBossDeaths>=2)
endfunction

function Trig_Boss_BlackDevil_Death_IsWaygateOpen takes nothing returns boolean
    return(udg_HolyAnkhUsed)
endfunction

function Trig_Boss_BlackDevil_Death_Actions takes nothing returns nothing
    local location l_tempPoint
    call DisableTrigger(GetTriggeringTrigger())
    if(Trig_Boss_BlackDevil_Death_ShouldRecordKill())then
        set udg_BossUnit=GetTriggerUnit()
        call ConditionalTriggerExecute(gg_trg_Speedrun_Accolade)
    endif
    call Music_ClearTrack(27)
    set udg_UrnBossDeaths=(udg_UrnBossDeaths+1)
    if(Trig_Boss_BlackDevil_Death_TwoKillsDone())then
        call SaveIntegerBJ(1,2,'e',udg_GameStateHash)
    endif
    set l_tempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateItemLoc('I0BM',l_tempPoint) // 'I0BM': item "Gravity Staff"
    call RemoveLocation(l_tempPoint)
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_BossGroup)
    call PlayThematicMusicBJ("war3mapImported\\FFX-Victory.mp3")
    call DisplayTextToForce(udg_PlayingPlayers,(("|cffaa0000"+GetHeroProperName(GetDyingUnit()))+"|r was defeated !!!"))
    if(Trig_Boss_BlackDevil_Death_IsWaygateOpen())then
        call WaygateActivateBJ(true,gg_unit_n0AP_0240)
        set udg_SpecialEffect[78]=AddSpecialEffectTargetUnitBJ("origin",gg_unit_n0AP_0240,"Abilities\\Spells\\Human\\Brilliance\\Brilliance.mdl")
    endif
    call RemoveItem(udg_SummonItem)
    set udg_RingHintsReady=true
    call UnitRemoveAbilityBJ('A0JH',gg_unit_n03T_0008) // 'A0JH': ability "Black Hole Hint"
    call UnitAddAbilityBJ('Ane2',gg_unit_n03T_0008) // 'Ane2': object name not found in map data
    call DestroyTrigger(GetTriggeringTrigger())
    set l_tempPoint=null
endfunction

function Trig_Boss_BlackDevil_Cleanup_Actions takes nothing returns nothing
    call DisableTrigger(gg_trg_Boss_BlackDevil_Death)
    call GroupRemoveUnitSimple(udg_BlackDevilUnit,udg_BossGroup)
    call KillUnit(udg_BlackDevilUnit)
    call RemoveUnit(udg_BlackDevilUnit)
    call Music_ClearTrack(27)
endfunction

function InitTrig_Boss_BlackDevil takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Boss_Part12 (module Boss),
// which keeps the original registration order.

function Register_Boss_BlackDevil_Summon takes nothing returns nothing
    set gg_trg_Boss_BlackDevil_Summon=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_BlackDevil_Summon)
    call TriggerAddAction(gg_trg_Boss_BlackDevil_Summon,function Trig_Boss_BlackDevil_Summon_Actions)
endfunction

function Register_Boss_BlackDevil_Death takes nothing returns nothing
    set gg_trg_Boss_BlackDevil_Death=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_BlackDevil_Death)
    call TriggerAddCondition(gg_trg_Boss_BlackDevil_Death,Condition(function Trig_Boss_BlackDevil_Death_Conditions))
    call TriggerAddAction(gg_trg_Boss_BlackDevil_Death,function Trig_Boss_BlackDevil_Death_Actions)
endfunction

function Register_Boss_BlackDevil_Cleanup takes nothing returns nothing
    set gg_trg_Boss_BlackDevil_Cleanup=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_BlackDevil_Cleanup)
    call TriggerAddAction(gg_trg_Boss_BlackDevil_Cleanup,function Trig_Boss_BlackDevil_Cleanup_Actions)
endfunction

endlibrary
