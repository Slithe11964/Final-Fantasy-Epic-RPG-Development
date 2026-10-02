library TGoliath requires TAbil, TBerserk, TGoliathTonic
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
    // Result 1: (BlzGetAbilityManaCost(GetSpellAbilityId(), Abil_GetLevel(the triggering unit,
    // GetSpellAbilityId()))) divided by (15).
    // Result 2: result 1 treated as a decimal-capable number.
    set udg_TempReal=I2R(BlzGetAbilityManaCost(GetSpellAbilityId(),Abil_GetLevel(GetTriggerUnit(),GetSpellAbilityId()))/ $F) // $F = 15
    call Trig_Goliath_Tonic_Apply(GetSpellTargetUnit(),udg_TempReal)
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Goliath takes nothing returns nothing
endfunction
function RegisterR11_Goliath_Tonic takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Goliath_Tonic=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Goliath_Tonic,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Goliath_Tonic,Condition(function Trig_Goliath_Tonic_Conditions))
    call TriggerAddAction(gg_trg_Goliath_Tonic,function Trig_Goliath_Tonic_Actions)
endfunction




endlibrary
