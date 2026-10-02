library TFafnir
function Trig_Fafnir_Spawn_Actions takes nothing returns nothing
    set udg_FafnirPatrolPoint[0]=GetRectCenter(gg_rct_676)
    set udg_FafnirPatrolPoint[1]=GetRectCenter(gg_rct_677)
    set udg_FafnirPatrolPoint[2]=GetRectCenter(gg_rct_678)
    set udg_FafnirPatrolPoint[3]=GetRectCenter(gg_rct_679)
    call CreateNUnitsAtLoc(1,'n0KF',Player($B),udg_FafnirPatrolPoint[0],.0) // 'n0KF': unit "Fafnir"; $B = 11
    set udg_Fafnir=GetLastCreatedUnit()
    call RemoveGuardPosition(GetLastCreatedUnit())
    set udg_FafnirPatrolIndex=1
    call StartTimerBJ(udg_FafnirPatrolTimer,false,20.)
    call EnableTrigger(gg_trg_Fafnir_LowLife_Credit)
    call TriggerRegisterUnitLifeEvent(gg_trg_Fafnir_LowLife_Credit,udg_Fafnir,LESS_THAN_OR_EQUAL,1.01)
    call EnableTrigger(gg_trg_Fafnir_Attack_Delay)
    call EnableTrigger(gg_trg_Fafnir_Patrol_Waypoint1)
    call EnableTrigger(gg_trg_Fafnir_Patrol_Waypoint2)
    call EnableTrigger(gg_trg_Fafnir_Patrol_Waypoint3)
    call EnableTrigger(gg_trg_Fafnir_Patrol_Waypoint0)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Fafnir_Patrol_Move_Actions takes nothing returns nothing
    call IssuePointOrderLocBJ(udg_Fafnir,"attack",udg_FafnirPatrolPoint[udg_FafnirPatrolIndex])
    call StartTimerBJ(udg_FafnirPatrolTimer,false,45.)
endfunction

function Trig_Fafnir_Patrol_Waypoint1_Conditions takes nothing returns boolean
    return(GetTriggerUnit()==udg_Fafnir)
endfunction

function Trig_Fafnir_Patrol_Waypoint1_Actions takes nothing returns nothing
    set udg_FafnirPatrolIndex=1
    call StartTimerBJ(udg_FafnirPatrolTimer,false,8.)
endfunction

function Trig_Fafnir_Patrol_Waypoint2_Conditions takes nothing returns boolean
    return(GetTriggerUnit()==udg_Fafnir)
endfunction

function Trig_Fafnir_Patrol_Waypoint2_Actions takes nothing returns nothing
    set udg_FafnirPatrolIndex=2
    call StartTimerBJ(udg_FafnirPatrolTimer,false,8.)
endfunction

function Trig_Fafnir_Patrol_Waypoint3_Conditions takes nothing returns boolean
    return(GetTriggerUnit()==udg_Fafnir)
endfunction

function Trig_Fafnir_Patrol_Waypoint3_Actions takes nothing returns nothing
    set udg_FafnirPatrolIndex=3
    call StartTimerBJ(udg_FafnirPatrolTimer,false,8.)
endfunction

function Trig_Fafnir_Patrol_Waypoint0_Conditions takes nothing returns boolean
    return(GetTriggerUnit()==udg_Fafnir)
endfunction

function Trig_Fafnir_Patrol_Waypoint0_Actions takes nothing returns nothing
    set udg_FafnirPatrolIndex=0
    call StartTimerBJ(udg_FafnirPatrolTimer,false,8.)
endfunction

function Trig_Fafnir_Attack_Delay_Conditions takes nothing returns boolean
    return(GetAttacker()==udg_Fafnir)
endfunction

function Trig_Fafnir_Attack_Delay_Actions takes nothing returns nothing
    call StartTimerBJ(udg_FafnirPatrolTimer,false,40.)
endfunction

function Trig_Fafnir_LowLife_Credit_Conditions takes nothing returns boolean
    return(GetTriggerUnit()==udg_Fafnir)
endfunction

function Trig_Fafnir_LowLife_Credit_PlayerNotCredited takes nothing returns boolean
    return(IsPlayerInForce(GetEnumPlayer(),udg_TitleForce[53])==false)
endfunction

function Trig_Fafnir_LowLife_Credit_CreditPlayer takes nothing returns nothing
    if(Trig_Fafnir_LowLife_Credit_PlayerNotCredited())then
        set udg_TempPlayer=GetEnumPlayer()
        set udg_TempInteger=53
        call ConditionalTriggerExecute(gg_trg_Title_Grant)
    endif
endfunction

function Trig_Fafnir_LowLife_Credit_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call ForForce(udg_PlayingPlayers,function Trig_Fafnir_LowLife_Credit_CreditPlayer)
endfunction

function Trig_Fafnir_Battle_Begin_Conditions takes nothing returns boolean
    return(GetTriggerUnit()==udg_Fafnir)and(GetAttacker()==gg_unit_H036_0254)
endfunction

function Trig_Fafnir_Battle_Begin_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DisableTrigger(gg_trg_Fafnir_LowLife_Credit)
    call DestroyTrigger(gg_trg_Fafnir_LowLife_Credit)
    call DisableTrigger(gg_trg_Ziegfried_Advance_Order)
    call EnableTrigger(gg_trg_Ziegfried_Attack_Fafnir)
    call TriggerRegisterUnitEvent(gg_trg_Quest_ImperviousBeast_Complete,udg_Fafnir,EVENT_UNIT_DEATH)
    call EnableTrigger(gg_trg_Quest_ImperviousBeast_Complete)
    call SetUnitAbilityLevelSwapped('A0SF',gg_unit_H036_0254,18) // 'A0SF': ability "Command AI"
    call UnitRemoveAbilityBJ('A0ZR',GetTriggerUnit()) // 'A0ZR': ability "Immortal"
    call UnitRemoveAbilityBJ('A0Y2',GetTriggerUnit()) // 'A0Y2': ability "Arcanium Immortality"
    call RemoveUnit(udg_VikingBoat)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Fafnir takes nothing returns nothing
endfunction
function RegisterR11_Fafnir_Spawn takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Fafnir_Spawn=CreateTrigger()
    call TriggerRegisterTimerEventSingle(gg_trg_Fafnir_Spawn,45.)
    call TriggerAddAction(gg_trg_Fafnir_Spawn,function Trig_Fafnir_Spawn_Actions)
endfunction
function RegisterR11_Fafnir_Patrol_Move takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Fafnir_Patrol_Move=CreateTrigger()
    call TriggerRegisterTimerExpireEventBJ(gg_trg_Fafnir_Patrol_Move,udg_FafnirPatrolTimer)
    call TriggerAddAction(gg_trg_Fafnir_Patrol_Move,function Trig_Fafnir_Patrol_Move_Actions)
endfunction
function RegisterR11_Fafnir_Patrol_Waypoint1 takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Fafnir_Patrol_Waypoint1=CreateTrigger()
    call DisableTrigger(gg_trg_Fafnir_Patrol_Waypoint1)
    call TriggerRegisterEnterRectSimple(gg_trg_Fafnir_Patrol_Waypoint1,gg_rct_676)
    call TriggerAddCondition(gg_trg_Fafnir_Patrol_Waypoint1,Condition(function Trig_Fafnir_Patrol_Waypoint1_Conditions))
    call TriggerAddAction(gg_trg_Fafnir_Patrol_Waypoint1,function Trig_Fafnir_Patrol_Waypoint1_Actions)
endfunction
function RegisterR11_Fafnir_Patrol_Waypoint2 takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Fafnir_Patrol_Waypoint2=CreateTrigger()
    call DisableTrigger(gg_trg_Fafnir_Patrol_Waypoint2)
    call TriggerRegisterEnterRectSimple(gg_trg_Fafnir_Patrol_Waypoint2,gg_rct_677)
    call TriggerAddCondition(gg_trg_Fafnir_Patrol_Waypoint2,Condition(function Trig_Fafnir_Patrol_Waypoint2_Conditions))
    call TriggerAddAction(gg_trg_Fafnir_Patrol_Waypoint2,function Trig_Fafnir_Patrol_Waypoint2_Actions)
endfunction
function RegisterR11_Fafnir_Patrol_Waypoint3 takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Fafnir_Patrol_Waypoint3=CreateTrigger()
    call DisableTrigger(gg_trg_Fafnir_Patrol_Waypoint3)
    call TriggerRegisterEnterRectSimple(gg_trg_Fafnir_Patrol_Waypoint3,gg_rct_678)
    call TriggerAddCondition(gg_trg_Fafnir_Patrol_Waypoint3,Condition(function Trig_Fafnir_Patrol_Waypoint3_Conditions))
    call TriggerAddAction(gg_trg_Fafnir_Patrol_Waypoint3,function Trig_Fafnir_Patrol_Waypoint3_Actions)
endfunction
function RegisterR11_Fafnir_Patrol_Waypoint0 takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Fafnir_Patrol_Waypoint0=CreateTrigger()
    call DisableTrigger(gg_trg_Fafnir_Patrol_Waypoint0)
    call TriggerRegisterEnterRectSimple(gg_trg_Fafnir_Patrol_Waypoint0,gg_rct_679)
    call TriggerAddCondition(gg_trg_Fafnir_Patrol_Waypoint0,Condition(function Trig_Fafnir_Patrol_Waypoint0_Conditions))
    call TriggerAddAction(gg_trg_Fafnir_Patrol_Waypoint0,function Trig_Fafnir_Patrol_Waypoint0_Actions)
endfunction
function RegisterR11_Fafnir_Attack_Delay takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Fafnir_Attack_Delay=CreateTrigger()
    call DisableTrigger(gg_trg_Fafnir_Attack_Delay)
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Fafnir_Attack_Delay,EVENT_PLAYER_UNIT_ATTACKED)
    call TriggerAddCondition(gg_trg_Fafnir_Attack_Delay,Condition(function Trig_Fafnir_Attack_Delay_Conditions))
    call TriggerAddAction(gg_trg_Fafnir_Attack_Delay,function Trig_Fafnir_Attack_Delay_Actions)
endfunction
function RegisterR11_Fafnir_LowLife_Credit takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Fafnir_LowLife_Credit=CreateTrigger()
    call DisableTrigger(gg_trg_Fafnir_LowLife_Credit)
    call TriggerAddCondition(gg_trg_Fafnir_LowLife_Credit,Condition(function Trig_Fafnir_LowLife_Credit_Conditions))
    call TriggerAddAction(gg_trg_Fafnir_LowLife_Credit,function Trig_Fafnir_LowLife_Credit_Actions)
endfunction
function RegisterR11_Fafnir_Battle_Begin takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Fafnir_Battle_Begin=CreateTrigger()
    call DisableTrigger(gg_trg_Fafnir_Battle_Begin)
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_Fafnir_Battle_Begin,Player($B),EVENT_PLAYER_UNIT_ATTACKED) // $B = 11
    call TriggerAddCondition(gg_trg_Fafnir_Battle_Begin,Condition(function Trig_Fafnir_Battle_Begin_Conditions))
    call TriggerAddAction(gg_trg_Fafnir_Battle_Begin,function Trig_Fafnir_Battle_Begin_Actions)
endfunction




endlibrary
