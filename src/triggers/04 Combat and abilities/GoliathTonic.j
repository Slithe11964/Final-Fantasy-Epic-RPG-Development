library TGoliathTonic
function GoliathTonic_Remove takes unit u returns nothing
    local integer maximumHealth=BlzGetUnitMaxHP(u)
    local real hp=GetWidgetLife(u)
    local boolean l_active=LoadBoolean(udg_MaxHpBuffHash,GetHandleId(u),4)
    local integer l_bonus=LoadInteger(udg_MaxHpBuffHash,GetHandleId(u),5)
    local timer t
    call UnitRemoveAbility(u,'B07U') // 'B07U': buff "Goliath Tonic"
    if(not l_active)then
        return
    endif
    set t=LoadTimerHandle(udg_MaxHpBuffHash,GetHandleId(u),6)
    call FlushChildHashtable(udg_MaxHpBuffHash,GetHandleId(t))
    call PauseTimer(t)
    call DestroyTimer(t)
    call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Undead\\AbsorbMana\\AbsorbManaBirthMissile.mdl",u,"head"))
    // (maximum health) minus (l_bonus).
    call BlzSetUnitMaxHP(u,maximumHealth-l_bonus)
    call SaveInteger(udg_MaxHpBuffHash,GetHandleId(u),5,0)
    call SaveBoolean(udg_MaxHpBuffHash,GetHandleId(u),4,false)
    call GroupRemoveUnit(udg_GoliathTonicGroup,u)
    set t=null
endfunction

function InitTrig_GoliathTonic takes nothing returns nothing
endfunction

endlibrary
