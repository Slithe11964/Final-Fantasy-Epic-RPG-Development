library TBagOfTricks requires TGroup
function Trig_BagOfTricks_Setup_Cond_IsStructure takes nothing returns boolean
    return(IsUnitType(GetFilterUnit(),UNIT_TYPE_STRUCTURE))!=null
endfunction

function Trig_BagOfTricks_Setup_Cond_IsAlive takes nothing returns boolean
    return(IsUnitAliveBJ(GetFilterUnit()))
endfunction

function Trig_BagOfTricks_Setup_Cond_NotInvulnerable takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('Avul',GetFilterUnit())<=0) // 'Avul': standard ability reference "Invulnerable"
endfunction

function Trig_BagOfTricks_Setup_Cond_AliveAndVulnerable takes nothing returns boolean
    return GetBooleanAnd(Trig_BagOfTricks_Setup_Cond_IsAlive(),Trig_BagOfTricks_Setup_Cond_NotInvulnerable())
endfunction

function Trig_BagOfTricks_Setup_Cond_IsTargetBuilding takes nothing returns boolean
    return GetBooleanAnd(Trig_BagOfTricks_Setup_Cond_IsStructure(),Trig_BagOfTricks_Setup_Cond_AliveAndVulnerable())
endfunction

function Trig_BagOfTricks_Setup_Actions takes nothing returns nothing
    call DestroyGroup(udg_BagOfTricksTargets)
    set udg_BagOfTricksTargets=Group_UnitsOfPlayer(Player(PLAYER_NEUTRAL_PASSIVE),Condition(function Trig_BagOfTricks_Setup_Cond_IsTargetBuilding))
    call GroupRemoveUnitSimple(gg_unit_o007_0122,udg_BagOfTricksTargets)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_BagOfTricks_Progress_Conditions takes nothing returns boolean
    return(IsUnitInGroup(GetTriggerUnit(),udg_BagOfTricksTargets))
endfunction

function Trig_BagOfTricks_Progress_Cond_AllTargetsDead takes nothing returns boolean
    return(IsUnitGroupEmptyBJ(udg_BagOfTricksTargets))
endfunction

function Trig_BagOfTricks_Progress_Actions takes nothing returns nothing
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_BagOfTricksTargets)
    call GroupRemoveUnitSimple(GroupPickRandomUnit(udg_BagOfTricksTargets),udg_BagOfTricksTargets)
    set udg_MonographDropped=true
    if(Trig_BagOfTricks_Progress_Cond_AllTargetsDead())then
        call DisableTrigger(GetTriggeringTrigger())
        set udg_TempPoint3=GetUnitLoc(GetTriggerUnit())
        call CreateItemLoc('I0K1',udg_TempPoint3) // 'I0K1': item "Bag of Tricks"
        call RemoveLocation(udg_TempPoint3)
        call DestroyTrigger(GetTriggeringTrigger())
    endif
endfunction

// World Editor calls InitTrig_BagOfTricks automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_BagOfTricks (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_BagOfTricks takes nothing returns nothing
endfunction

function Register_BagOfTricks_Setup takes nothing returns nothing
    set gg_trg_BagOfTricks_Setup=CreateTrigger()
    call TriggerRegisterTimerEventSingle(gg_trg_BagOfTricks_Setup,40.)
    call TriggerAddAction(gg_trg_BagOfTricks_Setup,function Trig_BagOfTricks_Setup_Actions)
endfunction

function Register_BagOfTricks_Progress takes nothing returns nothing
    set gg_trg_BagOfTricks_Progress=CreateTrigger()
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_BagOfTricks_Progress,Player(PLAYER_NEUTRAL_PASSIVE),EVENT_PLAYER_UNIT_DEATH)
    call TriggerAddCondition(gg_trg_BagOfTricks_Progress,Condition(function Trig_BagOfTricks_Progress_Conditions))
    call TriggerAddAction(gg_trg_BagOfTricks_Progress,function Trig_BagOfTricks_Progress_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_BagOfTricks takes nothing returns nothing
    call Register_BagOfTricks_Setup()
    call Register_BagOfTricks_Progress()
endfunction

endlibrary
