library TMaxHp requires TBerserk
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_MaxHp_DrainTick=null
endglobals

function Trig_MaxHp_DrainTick_DrainMaxHp takes unit u returns nothing
    local integer maximumHealth=BlzGetUnitMaxHP(u)
    // Starting value for currentHealth:
    // (current health of u) with its decimal part removed.
    local integer currentHealth=R2I(GetWidgetLife(u))
    // Missing health is maximum health minus current health, with current health converted to a whole number.
    local integer l_missing=(maximumHealth-currentHealth)
    local boolean l_active=LoadBoolean(udg_MaxHpBuffHash,GetHandleId(u),0)
    local real l_drained=LoadReal(udg_MaxHpBuffHash,GetHandleId(u),1)
    if(not l_active)then
        if(l_drained>.0)then
            call Berserk_Remove(u)
        endif
        return
    endif
    if(currentHealth>=maximumHealth)then
        return
    endif
    // Limit the amount removed so maximum health cannot fall below 1.
    if(l_missing>maximumHealth-1)then
        // (maximum health) minus (1).
        set l_missing=maximumHealth-1
    endif
    // (l_drained) plus (missing health).
    call SaveReal(udg_MaxHpBuffHash,GetHandleId(u),1,l_drained+l_missing)
    // Lower maximum health by the missing amount. Example: max 500 and current 350 gives a new max of 350.
    call BlzSetUnitMaxHP(u,maximumHealth-l_missing)
endfunction

function Trig_MaxHp_DrainTick_HasBerserk takes nothing returns boolean
    return(UnitHasBuffBJ(GetEnumUnit(),'B05V')) // 'B05V': buff tooltip "Disease"
endfunction

function Trig_MaxHp_DrainTick_ReleaseBerserkEnum takes nothing returns nothing
    if(Trig_MaxHp_DrainTick_HasBerserk())then
        call Berserk_Remove(GetEnumUnit())
        call GroupRemoveUnitSimple(GetEnumUnit(),udg_VirusImmuneGroup)
    endif
endfunction

function Trig_MaxHp_DrainTick_HasReleaseTargets takes nothing returns boolean
    return(IsUnitGroupEmptyBJ(udg_VirusImmuneGroup)==false)
endfunction

function Trig_MaxHp_DrainTick_LacksBerserk takes nothing returns boolean
    return(UnitHasBuffBJ(GetEnumUnit(),'B05V')==false) // 'B05V': buff tooltip "Disease"
endfunction

function Trig_MaxHp_DrainTick_DrainEnum takes nothing returns nothing
    if(Trig_MaxHp_DrainTick_LacksBerserk())then
        call Berserk_Remove(GetEnumUnit())
    else
        call Trig_MaxHp_DrainTick_DrainMaxHp(GetEnumUnit())
    endif
endfunction

function Trig_MaxHp_DrainTick_Actions takes nothing returns nothing
    if(Trig_MaxHp_DrainTick_HasReleaseTargets())then
        set udg_TempGroup=CreateGroup()
        call GroupAddGroup(udg_VirusImmuneGroup,udg_TempGroup)
        call ForGroupBJ(udg_TempGroup,function Trig_MaxHp_DrainTick_ReleaseBerserkEnum)
        call DestroyGroup(udg_TempGroup)
    endif
    set udg_TempGroup=CreateGroup()
    call GroupAddGroup(udg_BerserkGroup,udg_TempGroup)
    call ForGroupBJ(udg_TempGroup,function Trig_MaxHp_DrainTick_DrainEnum)
    call DestroyGroup(udg_TempGroup)
endfunction

// World Editor calls InitTrig_MaxHp automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_MaxHp (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_MaxHp takes nothing returns nothing
endfunction

function Register_MaxHp_DrainTick takes nothing returns nothing
    set gg_trg_MaxHp_DrainTick=CreateTrigger()
    call TriggerRegisterTimerExpireEventBJ(gg_trg_MaxHp_DrainTick,udg_MaxHpDrainTimer)
    call TriggerAddAction(gg_trg_MaxHp_DrainTick,function Trig_MaxHp_DrainTick_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_MaxHp takes nothing returns nothing
    call Register_MaxHp_DrainTick()
endfunction

endlibrary
