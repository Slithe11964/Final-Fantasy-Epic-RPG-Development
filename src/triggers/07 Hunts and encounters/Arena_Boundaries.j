library TArenaBoundaries requires TPlayerHero
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Arena_Leash=null
    trigger gg_trg_Arena_OutOfBounds=null
endglobals

function Trig_Arena_Leash_IsArenaUnit takes nothing returns boolean
    return(GetTriggerUnit()==gg_unit_U00J_0209)or(GetTriggerUnit()==gg_unit_N022_0125)or(IsUnitInGroup(GetTriggerUnit(),udg_ArenaBoundUnits))
endfunction

function Trig_Arena_Leash_Conditions takes nothing returns boolean
    return(Trig_Arena_Leash_IsArenaUnit())
endfunction

function Trig_Arena_Leash_Actions takes nothing returns nothing
    local location l_tempPoint
    set l_tempPoint=GetRectCenter(gg_rct_458)
    call SetUnitPositionLoc(GetEnteringUnit(),l_tempPoint)
    call RemoveLocation(l_tempPoint)
    set l_tempPoint=null
endfunction

function Trig_Arena_OutOfBounds_Conditions takes nothing returns boolean
    return(IsUnitGroupEmptyBJ(udg_CupArenaUnits)==false)
endfunction

function Trig_Arena_OutOfBounds_PlayerOutside takes nothing returns boolean
    return(RectContainsUnit(gg_rct_499,Player_GetHero(GetEnumPlayer()))==false)
endfunction

function Trig_Arena_OutOfBounds_PunishPlayer takes nothing returns nothing
    if(Trig_Arena_OutOfBounds_PlayerOutside())then
        set udg_ArenaStallTicks=(udg_ArenaStallTicks+1)
        call AddSpecialEffectTargetUnitBJ("origin",Player_GetHero(GetEnumPlayer()),"Abilities\\Weapons\\Bolt\\BoltImpact.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        set udg_DmgFlagPure=true
        set udg_DmgFlagUnavoidable=-1
        // Result 1: udg_ArenaStallTicks treated as a decimal-capable number.
        // Result 2: (result 1) times (0.05).
        // Result 3: (maximum health of Player_GetHero(the player being visited)) times (result 2).
        call UnitDamageTargetBJ(GroupPickRandomUnit(udg_CupArenaUnits),Player_GetHero(GetEnumPlayer()),(GetUnitStateSwap(UNIT_STATE_MAX_LIFE,Player_GetHero(GetEnumPlayer()))*(I2R(udg_ArenaStallTicks)*.05)),ATTACK_TYPE_CHAOS,DAMAGE_TYPE_UNIVERSAL)
    endif
endfunction

function Trig_Arena_OutOfBounds_Actions takes nothing returns nothing
    call ForForce(udg_CupArenaPlayers,function Trig_Arena_OutOfBounds_PunishPlayer)
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Arena_Boundaries takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Arena_Part1, RegisterTriggers_Arena_Part2 (module Arena),
// which keeps the original registration order.

function Register_Arena_Leash takes nothing returns nothing
    set gg_trg_Arena_Leash=CreateTrigger()
    call TriggerRegisterEnterRectSimple(gg_trg_Arena_Leash,gg_rct_371)
    call TriggerAddCondition(gg_trg_Arena_Leash,Condition(function Trig_Arena_Leash_Conditions))
    call TriggerAddAction(gg_trg_Arena_Leash,function Trig_Arena_Leash_Actions)
endfunction

function Register_Arena_OutOfBounds takes nothing returns nothing
    set gg_trg_Arena_OutOfBounds=CreateTrigger()
    call DisableTrigger(gg_trg_Arena_OutOfBounds)
    call TriggerRegisterTimerEventPeriodic(gg_trg_Arena_OutOfBounds,1.5)
    call TriggerAddCondition(gg_trg_Arena_OutOfBounds,Condition(function Trig_Arena_OutOfBounds_Conditions))
    call TriggerAddAction(gg_trg_Arena_OutOfBounds,function Trig_Arena_OutOfBounds_Actions)
endfunction

endlibrary
