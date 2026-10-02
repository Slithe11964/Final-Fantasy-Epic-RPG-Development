library TBerserk
function Berserk_Remove takes unit u returns nothing
    local integer maximumHealth=BlzGetUnitMaxHP(u)
    local boolean l_active=LoadBoolean(udg_MaxHpBuffHash,GetHandleId(u),0)
    // Starting value for l_bonus:
    // (LoadReal(udg_MaxHpBuffHash, GetHandleId(u), 1)) with its decimal part removed.
    local integer l_bonus=R2I(LoadReal(udg_MaxHpBuffHash,GetHandleId(u),1))
    local timer t
    call UnitRemoveAbility(u,'B05V') // 'B05V': buff tooltip "Disease"
    if(not l_active)then
        return
    endif
    set t=LoadTimerHandle(udg_MaxHpBuffHash,GetHandleId(u),2)
    call FlushChildHashtable(udg_MaxHpBuffHash,GetHandleId(t))
    call PauseTimer(t)
    call DestroyTimer(t)
    // (maximum health) plus (l_bonus).
    call BlzSetUnitMaxHP(u,maximumHealth+l_bonus)
    call SaveReal(udg_MaxHpBuffHash,GetHandleId(u),1,.0)
    call SaveBoolean(udg_MaxHpBuffHash,GetHandleId(u),0,false)
    call GroupRemoveUnit(udg_BerserkGroup,u)
    set t=null
endfunction

// ---- Berserk ----
function Trig_Berserk_RemoveBuffs_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A1F1') // 'A1F1': ability "Berserk"
endfunction

function Trig_Berserk_RemoveBuffs_Actions takes nothing returns nothing
    call UnitRemoveBuffBJ('B00K',GetSpellTargetUnit()) // 'B00K': buff tooltip "Rage"
    call UnitRemoveBuffBJ('B07P',GetSpellTargetUnit()) // 'B07P': buff "Enraged"
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Berserk takes nothing returns nothing
endfunction

function RegisterR11_Berserk_RemoveBuffs takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Berserk_RemoveBuffs=CreateTrigger()

call TriggerRegisterAnyUnitEventBJ(gg_trg_Berserk_RemoveBuffs,EVENT_PLAYER_UNIT_SPELL_EFFECT)

call TriggerAddCondition(gg_trg_Berserk_RemoveBuffs,Condition(function Trig_Berserk_RemoveBuffs_Conditions))

call TriggerAddAction(gg_trg_Berserk_RemoveBuffs,function Trig_Berserk_RemoveBuffs_Actions)

endfunction




endlibrary
