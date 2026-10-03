library TGoliath requires TAbil, TBerserk, TGoliathTonic
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Goliath_Tonic=null
endglobals

function Trig_Goliath_Tonic_Expire takes nothing returns nothing
    local timer expiredTimer=GetExpiredTimer()
    local unit u=LoadUnitHandle(udg_MaxHpBuffHash,GetHandleId(expiredTimer),7)
    call GoliathTonic_Remove(u)
    set u=null
    set expiredTimer=null
endfunction

function Trig_Goliath_Tonic_Apply takes unit u,real duration returns nothing
    local timer effectTimer=CreateTimer()
    local real hp
    local integer maximumHealth
    call Berserk_Remove(u)
    if(LoadBoolean(udg_MaxHpBuffHash,GetHandleId(u),4))then
        call GoliathTonic_Remove(u)
    endif
    call GroupAddUnit(udg_GoliathTonicGroup,u)
    call SaveBoolean(udg_MaxHpBuffHash,GetHandleId(u),4,true)
    set hp=GetWidgetLife(u)
    set maximumHealth=BlzGetUnitMaxHP(u)
    // (maximum health) times (2).
    call BlzSetUnitMaxHP(u,maximumHealth*2)
    // (hp) times (2).
    call SetUnitState(u,UNIT_STATE_LIFE,hp*2)
    call SaveInteger(udg_MaxHpBuffHash,GetHandleId(u),5,maximumHealth)
    call SaveTimerHandle(udg_MaxHpBuffHash,GetHandleId(u),6,effectTimer)
    call SaveUnitHandle(udg_MaxHpBuffHash,GetHandleId(effectTimer),7,u)
    call TimerStart(effectTimer,duration,false,function Trig_Goliath_Tonic_Expire)
    set effectTimer=null
endfunction

function Trig_Goliath_Tonic_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A18G') // 'A18G': ability "!Goliath Tonic"
endfunction

function Trig_Goliath_Tonic_Actions takes nothing returns nothing
    local real l_tempReal
    // Result 1: (BlzGetAbilityManaCost(GetSpellAbilityId(), Abil_GetLevel(the triggering unit,
    // GetSpellAbilityId()))) divided by (15).
    // Result 2: result 1 treated as a decimal-capable number.
    set l_tempReal=I2R(BlzGetAbilityManaCost(GetSpellAbilityId(),Abil_GetLevel(GetTriggerUnit(),GetSpellAbilityId()))/ $F) // $F = 15
    call Trig_Goliath_Tonic_Apply(GetSpellTargetUnit(),l_tempReal)
endfunction

// World Editor calls InitTrig_Goliath automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Goliath (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Goliath takes nothing returns nothing
endfunction

function Register_Goliath_Tonic takes nothing returns nothing
    set gg_trg_Goliath_Tonic=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Goliath_Tonic,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Goliath_Tonic,Condition(function Trig_Goliath_Tonic_Conditions))
    call TriggerAddAction(gg_trg_Goliath_Tonic,function Trig_Goliath_Tonic_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Goliath takes nothing returns nothing
    call Register_Goliath_Tonic()
endfunction

endlibrary
