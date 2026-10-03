library TRunic requires TAbil
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Runic_Shield=null
endglobals

function Runic_Remove takes unit u returns nothing
    local timer t=LoadTimerHandle(udg_RunicHash,GetHandleId(u),7)
    call UnitRemoveAbility(u,'A1AV') // 'A1AV': ability "Runic Damage Bonus"
    call UnitRemoveAbility(u,'A1AW') // 'A1AW': ability "Runic Damage Bonus"
    call UnitRemoveAbility(u,'A1AX') // 'A1AX': ability "Runic Damage Bonus"
    call UnitRemoveAbility(u,'A1AY') // 'A1AY': ability "Runic Damage Bonus"
    call SaveReal(udg_RunicHash,GetHandleId(u),5,0)
    call GroupRemoveUnit(udg_RunicGroup,u)
    call UnitRemoveAbility(u,'B07R') // 'B07R': buff "Runic Shield"
    call UnitRemoveAbility(u,'B07S') // 'B07S': buff "Runic Revenge"
    call FlushChildHashtable(udg_RunicHash,GetHandleId(t))
    call PauseTimer(t)
    call DestroyTimer(t)
    set t=null
endfunction

// ---- Runic ----
function Trig_Runic_Shield_Expire takes nothing returns nothing
    local timer tm=GetExpiredTimer()
    local unit u=LoadUnitHandle(udg_RunicHash,GetHandleId(tm),8)
    call Runic_Remove(u)
    set u=null
    set tm=null
endfunction

function Trig_Runic_Shield_Apply takes unit t,integer duration returns nothing
    local unit u
    local timer tm=CreateTimer()
    if(IsUnitInGroup(t,udg_RunicGroup))then
        call Runic_Remove(t)
    endif
    call GroupAddUnit(udg_RunicGroup,t)
    call UnitAddAbility(t,'A1AV') // 'A1AV': ability "Runic Damage Bonus"
    call UnitAddAbility(t,'A1AW') // 'A1AW': ability "Runic Damage Bonus"
    call UnitAddAbility(t,'A1AX') // 'A1AX': ability "Runic Damage Bonus"
    call UnitAddAbility(t,'A1AY') // 'A1AY': ability "Runic Damage Bonus"
    // (duration) divided by (2); drop the remainder.
    call SaveInteger(udg_RunicHash,GetHandleId(t),6,duration/ 2)
    call SaveTimerHandle(udg_RunicHash,GetHandleId(t),7,tm)
    call SaveUnitHandle(udg_RunicHash,GetHandleId(tm),8,t)
    set u=CreateUnit(GetOwningPlayer(t),'h02S',GetUnitX(t),GetUnitY(t),.0) // 'h02S': unit "Simple Casting Dummy"
    call ShowUnit(u,false)
    call UnitApplyTimedLife(u,'BTLF',1.5) // 'BTLF': object name not found in map data
    call UnitAddAbility(u,'A17R') // 'A17R': ability "Runic Revenge"
    call IssueTargetOrderById(u,$D0085,t) // $D0085 = 852101
    // (duration) minus (8).
    call TimerStart(tm,duration-8,false,function Trig_Runic_Shield_Expire)
    set u=null
    set t=null
    set tm=null
endfunction

function Trig_Runic_Shield_IsRunicShield takes nothing returns boolean
    return(GetSpellAbilityId()=='A17P')or(GetSpellAbilityId()=='A18I')or(GetSpellAbilityId()=='A1AQ') // 'A17P': ability "Runic Shield"; 'A18I': ability "Runic Shield"; 'A1AQ': ability "Runic Shield"
endfunction

function Trig_Runic_Shield_Conditions takes nothing returns boolean
    return(Trig_Runic_Shield_IsRunicShield())
endfunction

function Trig_Runic_Shield_Actions takes nothing returns nothing
    local integer l_tempInteger
    // Result 1: (BlzGetAbilityManaCost(GetSpellAbilityId(), Abil_GetLevel(the triggering unit,
    // GetSpellAbilityId()))) divided by (10).
    // Result 2: (result 1) plus (10).
    set l_tempInteger=(BlzGetAbilityManaCost(GetSpellAbilityId(),Abil_GetLevel(GetTriggerUnit(),GetSpellAbilityId()))/ $A)+$A // $A = 10
    call Trig_Runic_Shield_Apply(GetSpellTargetUnit(),l_tempInteger)
endfunction

// World Editor calls InitTrig_Runic automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Runic (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Runic takes nothing returns nothing
endfunction

function Register_Runic_Shield takes nothing returns nothing
    set gg_trg_Runic_Shield=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Runic_Shield,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Runic_Shield,Condition(function Trig_Runic_Shield_Conditions))
    call TriggerAddAction(gg_trg_Runic_Shield,function Trig_Runic_Shield_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Runic takes nothing returns nothing
    call Register_Runic_Shield()
endfunction

endlibrary
