library THelp
function Trig_Help_Unit_Sold_Conditions takes nothing returns boolean
    return(GetUnitTypeId(GetSoldUnit())=='n00W') // 'n00W': unit "Help"
endfunction

function Trig_Help_Unit_Sold_Actions takes nothing returns nothing
    call UnitApplyTimedLifeBJ(10.,'BTLF',GetSoldUnit()) // 'BTLF': object name not found in map data
    call SetUnitOwner(GetSoldUnit(),Player($A),true) // $A = 10
endfunction

function Trig_Help_Unit_Death_Drop_Conditions takes nothing returns boolean
    return(GetUnitTypeId(GetTriggerUnit())=='n00W')and(GetKillingUnitBJ()!=null) // 'n00W': unit "Help"
endfunction

function Trig_Help_Unit_Death_Drop_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateItemLoc('I004',udg_TempPoint) // 'I004': item "100 Gold Coins"
    call RemoveLocation(udg_TempPoint)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_Help automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Help (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Help takes nothing returns nothing
endfunction

function Register_Help_Unit_Sold takes nothing returns nothing
    set gg_trg_Help_Unit_Sold=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Help_Unit_Sold,EVENT_PLAYER_UNIT_SELL)
    call TriggerAddCondition(gg_trg_Help_Unit_Sold,Condition(function Trig_Help_Unit_Sold_Conditions))
    call TriggerAddAction(gg_trg_Help_Unit_Sold,function Trig_Help_Unit_Sold_Actions)
endfunction

function Register_Help_Unit_Death_Drop takes nothing returns nothing
    set gg_trg_Help_Unit_Death_Drop=CreateTrigger()
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_Help_Unit_Death_Drop,Player($A),EVENT_PLAYER_UNIT_DEATH) // $A = 10
    call TriggerAddCondition(gg_trg_Help_Unit_Death_Drop,Condition(function Trig_Help_Unit_Death_Drop_Conditions))
    call TriggerAddAction(gg_trg_Help_Unit_Death_Drop,function Trig_Help_Unit_Death_Drop_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Help takes nothing returns nothing
    call Register_Help_Unit_Sold()
    call Register_Help_Unit_Death_Drop()
endfunction

endlibrary
