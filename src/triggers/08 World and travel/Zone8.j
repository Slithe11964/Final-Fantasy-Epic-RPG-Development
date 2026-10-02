library TZone8 requires TGroup, TWait
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
    call DisableTrigger(GetTriggeringTrigger())
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    set udg_TempGroup=Group_UnitsInRangeOfLoc(800.,udg_TempPoint,Condition(function Trig_Zone8_Heal_Assist_IsDevourHealer))
    call RemoveLocation(udg_TempPoint)
    if(Trig_Zone8_Heal_Assist_FoundHealer())then
        call IssueTargetOrderBJ(GroupPickRandomUnit(udg_TempGroup),"holybolt",GetTriggerUnit())
    endif
    call DestroyGroup(udg_TempGroup)
    call Wait_Polled(5.)
    call EnableTrigger(GetTriggeringTrigger())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Zone8 takes nothing returns nothing
endfunction
function RegisterR11_Zone8_Heal_Assist takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Zone8_Heal_Assist=CreateTrigger()
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_Zone8_Heal_Assist,Player($B),EVENT_PLAYER_UNIT_ATTACKED) // $B = 11
    call TriggerAddCondition(gg_trg_Zone8_Heal_Assist,Condition(function Trig_Zone8_Heal_Assist_Conditions))
    call TriggerAddAction(gg_trg_Zone8_Heal_Assist,function Trig_Zone8_Heal_Assist_Actions)
endfunction




endlibrary
