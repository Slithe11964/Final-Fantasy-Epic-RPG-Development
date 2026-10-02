library TStrangeCage requires TUnit
function Trig_StrangeCage_Unlock_Conditions takes nothing returns boolean
    return((IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(UnitHasItemOfTypeBJ(GetTriggerUnit(),'kygh')))!=null // 'kygh': item "Strange Key"
endfunction

function Trig_StrangeCage_Unlock_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DisableTrigger(gg_trg_StrangeKey_Ping)
    call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'kygh')) // 'kygh': item "Strange Key"
    set udg_TempPoint=GetUnitLoc(gg_unit_nwc1_0187)
    call AddSpecialEffectLocBJ(udg_TempPoint,"Objects\\Spawnmodels\\Other\\NeutralBuildingExplosion\\NeutralBuildingExplosion.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call KillUnit(gg_unit_nwc1_0187)
    call CreateNUnitsAtLoc(1,'n015',Player($B),udg_TempPoint,bj_UNIT_FACING) // 'n015': unit "Mithril Golem"; $B = 11
    set udg_GolemUnit[3]=GetLastCreatedUnit()
    call Unit_ScaleToLevel60(bj_lastCreatedUnit)
    call UnitAddAbilityBJ('A0MV',GetLastCreatedUnit()) // 'A0MV': ability "Plentiful"
    call GroupAddUnitSimple(GetLastCreatedUnit(),udg_BossUnits)
    call TriggerRegisterUnitEvent(gg_trg_MithrilGolem_Death,GetLastCreatedUnit(),EVENT_UNIT_DEATH)
    call RemoveLocation(udg_TempPoint)
    call EnableTrigger(gg_trg_MithrilGolem_Death)
    call DisplayTextToForce(GetPlayersAll(),(udg_PlayerName[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+" unlocked Strange Cage."))
    call RemoveItemFromStockBJ('I05C',gg_unit_n02Y_0052) // 'I05C': item "Information: Mithril Golem"
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_StrangeCage automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_StrangeCage (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_StrangeCage takes nothing returns nothing
endfunction

function Register_StrangeCage_Unlock takes nothing returns nothing
    set gg_trg_StrangeCage_Unlock=CreateTrigger()
    call DisableTrigger(gg_trg_StrangeCage_Unlock)
    call TriggerRegisterUnitInRangeSimple(gg_trg_StrangeCage_Unlock,200.,gg_unit_nwc1_0187)
    call TriggerAddCondition(gg_trg_StrangeCage_Unlock,Condition(function Trig_StrangeCage_Unlock_Conditions))
    call TriggerAddAction(gg_trg_StrangeCage_Unlock,function Trig_StrangeCage_Unlock_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_StrangeCage takes nothing returns nothing
    call Register_StrangeCage_Unlock()
endfunction

endlibrary
