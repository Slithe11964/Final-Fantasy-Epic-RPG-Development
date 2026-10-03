library TZone8 requires TGroup, TWait
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Zone8_Heal_Assist=null
endglobals

function Trig_Zone8_Heal_Assist_Conditions takes nothing returns boolean
    // Result 1: current health divided by maximum health for the triggering unit, times 100 (or 0 if the unit is
    // missing or its maximum is 0).
    return((GetUnitUserData(GetTriggerUnit())==8)and(GetUnitLifePercent(GetTriggerUnit())<90.)and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_UNDEAD)==false)and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_RESISTANT)==false))!=null
endfunction

function Trig_Zone8_Heal_Assist_HasDevour takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0YR',GetFilterUnit())>0) // 'A0YR': ability "!Devour"
endfunction

function Trig_Zone8_Heal_Assist_IsAliveUnit takes nothing returns boolean
    return(IsUnitAliveBJ(GetFilterUnit()))
endfunction

function Trig_Zone8_Heal_Assist_IsEnemyOwned takes nothing returns boolean
    return(GetOwningPlayer(GetFilterUnit())==Player($B)) // $B = 11
endfunction

function Trig_Zone8_Heal_Assist_IsLiveEnemy takes nothing returns boolean
    return GetBooleanAnd(Trig_Zone8_Heal_Assist_IsAliveUnit(),Trig_Zone8_Heal_Assist_IsEnemyOwned())
endfunction

function Trig_Zone8_Heal_Assist_IsDevourHealer takes nothing returns boolean
    return GetBooleanAnd(Trig_Zone8_Heal_Assist_HasDevour(),Trig_Zone8_Heal_Assist_IsLiveEnemy())
endfunction

function Trig_Zone8_Heal_Assist_FoundHealer takes nothing returns boolean
    return(IsUnitGroupEmptyBJ(udg_TempGroup)==false)
endfunction

function Trig_Zone8_Heal_Assist_Actions takes nothing returns nothing
    local location l_tempPoint
    call DisableTrigger(GetTriggeringTrigger())
    set l_tempPoint=GetUnitLoc(GetTriggerUnit())
    set udg_TempGroup=Group_UnitsInRangeOfLoc(800.,l_tempPoint,Condition(function Trig_Zone8_Heal_Assist_IsDevourHealer))
    call RemoveLocation(l_tempPoint)
    if(Trig_Zone8_Heal_Assist_FoundHealer())then
        call IssueTargetOrderBJ(GroupPickRandomUnit(udg_TempGroup),"holybolt",GetTriggerUnit())
    endif
    call DestroyGroup(udg_TempGroup)
    call Wait_Polled(5.)
    call EnableTrigger(GetTriggeringTrigger())
    set l_tempPoint=null
endfunction

// World Editor calls InitTrig_Zone8 automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Zone8 (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Zone8 takes nothing returns nothing
endfunction

function Register_Zone8_Heal_Assist takes nothing returns nothing
    set gg_trg_Zone8_Heal_Assist=CreateTrigger()
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_Zone8_Heal_Assist,Player($B),EVENT_PLAYER_UNIT_ATTACKED) // $B = 11
    call TriggerAddCondition(gg_trg_Zone8_Heal_Assist,Condition(function Trig_Zone8_Heal_Assist_Conditions))
    call TriggerAddAction(gg_trg_Zone8_Heal_Assist,function Trig_Zone8_Heal_Assist_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Zone8 takes nothing returns nothing
    call Register_Zone8_Heal_Assist()
endfunction

endlibrary
