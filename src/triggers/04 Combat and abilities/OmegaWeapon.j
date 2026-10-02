library TOmegaWeapon requires TGroup, TWait
function Trig_OmegaWeapon_Hide_Actions takes nothing returns nothing
    call ShowUnitHide(gg_unit_N022_0125)
    call SetUnitInvulnerable(gg_unit_N022_0125,true)
    call PauseUnitBJ(true,gg_unit_N022_0125)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_OmegaWeapon_SpellRotation_Cond_IsPlayerUnit1 takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetFilterUnit()),udg_PlayingPlayers))
endfunction

function Trig_OmegaWeapon_SpellRotation_Cond_NotGaiaSpirit1 takes nothing returns boolean
    return(GetUnitTypeId(GetFilterUnit())!='H01D') // 'H01D': unit "Spirit of Gaya"
endfunction

function Trig_OmegaWeapon_SpellRotation_Filter_ValidTarget1 takes nothing returns boolean
    return GetBooleanAnd(Trig_OmegaWeapon_SpellRotation_Cond_IsPlayerUnit1(),Trig_OmegaWeapon_SpellRotation_Cond_NotGaiaSpirit1())
endfunction

function Trig_OmegaWeapon_SpellRotation_Cond_CanCastLightning takes nothing returns boolean
    return(GetUnitCurrentOrder(gg_unit_N022_0125)!=$D009D)and(CountUnitsInGroup(udg_TempGroup)>0) // $D009D = 852125
endfunction

function Trig_OmegaWeapon_SpellRotation_Cond_IsPlayerUnit2 takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetFilterUnit()),udg_PlayingPlayers))
endfunction

function Trig_OmegaWeapon_SpellRotation_Cond_NotGaiaSpirit2 takes nothing returns boolean
    return(GetUnitTypeId(GetFilterUnit())!='H01D') // 'H01D': unit "Spirit of Gaya"
endfunction

function Trig_OmegaWeapon_SpellRotation_Filter_ValidTarget2 takes nothing returns boolean
    return GetBooleanAnd(Trig_OmegaWeapon_SpellRotation_Cond_IsPlayerUnit2(),Trig_OmegaWeapon_SpellRotation_Cond_NotGaiaSpirit2())
endfunction

function Trig_OmegaWeapon_SpellRotation_Cond_CanCastThunderbolt takes nothing returns boolean
    return(GetUnitCurrentOrder(gg_unit_N022_0125)!=$D009D)and(CountUnitsInGroup(udg_TempGroup)>0) // $D009D = 852125
endfunction

function Trig_OmegaWeapon_SpellRotation_Cond_IsPlayerUnit3 takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetFilterUnit()),udg_PlayingPlayers))
endfunction

function Trig_OmegaWeapon_SpellRotation_Cond_NotGaiaSpirit3 takes nothing returns boolean
    return(GetUnitTypeId(GetFilterUnit())!='H01D') // 'H01D': unit "Spirit of Gaya"
endfunction

function Trig_OmegaWeapon_SpellRotation_Filter_ValidTarget3 takes nothing returns boolean
    return GetBooleanAnd(Trig_OmegaWeapon_SpellRotation_Cond_IsPlayerUnit3(),Trig_OmegaWeapon_SpellRotation_Cond_NotGaiaSpirit3())
endfunction

function Trig_OmegaWeapon_SpellRotation_Cond_CanCastFrostNova takes nothing returns boolean
    return(GetUnitCurrentOrder(gg_unit_N022_0125)!=$D009D)and(CountUnitsInGroup(udg_TempGroup)>0) // $D009D = 852125
endfunction

function Trig_OmegaWeapon_SpellRotation_Cond_IsPlayerUnit4 takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetFilterUnit()),udg_PlayingPlayers))
endfunction

function Trig_OmegaWeapon_SpellRotation_Cond_NotGaiaSpirit4 takes nothing returns boolean
    return(GetUnitTypeId(GetFilterUnit())!='H01D') // 'H01D': unit "Spirit of Gaya"
endfunction

function Trig_OmegaWeapon_SpellRotation_Filter_ValidTarget4 takes nothing returns boolean
    return GetBooleanAnd(Trig_OmegaWeapon_SpellRotation_Cond_IsPlayerUnit4(),Trig_OmegaWeapon_SpellRotation_Cond_NotGaiaSpirit4())
endfunction

function Trig_OmegaWeapon_SpellRotation_Cond_CanCastFlameStrike takes nothing returns boolean
    // Result 1: current health divided by maximum health for gg_unit_N022_0125, times 100 (or 0 if the unit is
    // missing or its maximum is 0).
    return(CountUnitsInGroup(udg_TempGroup)>0)and(GetUnitCurrentOrder(gg_unit_N022_0125)!=$D009D)and(GetUnitLifePercent(gg_unit_N022_0125)<=75.) // $D009D = 852125
endfunction

function Trig_OmegaWeapon_SpellRotation_Actions takes nothing returns nothing
    set udg_TempPoint=GetUnitLoc(gg_unit_N022_0125)
    set udg_TempGroup=Group_UnitsInRangeOfLoc(750.,udg_TempPoint,Condition(function Trig_OmegaWeapon_SpellRotation_Filter_ValidTarget1))
    call RemoveLocation(udg_TempPoint)
    if(Trig_OmegaWeapon_SpellRotation_Cond_CanCastLightning())then
        call IssueTargetOrderBJ(gg_unit_N022_0125,"forkedlightning",GroupPickRandomUnit(udg_TempGroup))
    endif
    call DestroyGroup(udg_TempGroup)
    call Wait_Polled(2)
    set udg_TempPoint=GetUnitLoc(gg_unit_N022_0125)
    set udg_TempGroup=Group_UnitsInRangeOfLoc(750.,udg_TempPoint,Condition(function Trig_OmegaWeapon_SpellRotation_Filter_ValidTarget2))
    call RemoveLocation(udg_TempPoint)
    if(Trig_OmegaWeapon_SpellRotation_Cond_CanCastThunderbolt())then
        call IssueTargetOrderBJ(gg_unit_N022_0125,"thunderbolt",GroupPickRandomUnit(udg_TempGroup))
    endif
    call DestroyGroup(udg_TempGroup)
    call Wait_Polled(2)
    set udg_TempPoint=GetUnitLoc(gg_unit_N022_0125)
    set udg_TempGroup=Group_UnitsInRangeOfLoc(750.,udg_TempPoint,Condition(function Trig_OmegaWeapon_SpellRotation_Filter_ValidTarget3))
    call RemoveLocation(udg_TempPoint)
    if(Trig_OmegaWeapon_SpellRotation_Cond_CanCastFrostNova())then
        call IssueTargetOrderBJ(gg_unit_N022_0125,"frostnova",GroupPickRandomUnit(udg_TempGroup))
    endif
    call DestroyGroup(udg_TempGroup)
    call Wait_Polled(2)
    set udg_TempPoint=GetUnitLoc(gg_unit_N022_0125)
    set udg_TempGroup=Group_UnitsInRangeOfLoc(750.,udg_TempPoint,Condition(function Trig_OmegaWeapon_SpellRotation_Filter_ValidTarget4))
    call RemoveLocation(udg_TempPoint)
    if(Trig_OmegaWeapon_SpellRotation_Cond_CanCastFlameStrike())then
        set udg_TempPoint=GetUnitLoc(GroupPickRandomUnit(udg_TempGroup))
        call IssuePointOrderLocBJ(gg_unit_N022_0125,"flamestrike",udg_TempPoint)
        call RemoveLocation(udg_TempPoint)
    endif
    call DestroyGroup(udg_TempGroup)
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_OmegaWeapon takes nothing returns nothing
endfunction
function RegisterR11_OmegaWeapon_Hide takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_OmegaWeapon_Hide=CreateTrigger()
    call TriggerAddAction(gg_trg_OmegaWeapon_Hide,function Trig_OmegaWeapon_Hide_Actions)
endfunction
function RegisterR11_OmegaWeapon_SpellRotation takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_OmegaWeapon_SpellRotation=CreateTrigger()
    call DisableTrigger(gg_trg_OmegaWeapon_SpellRotation)
    call TriggerRegisterTimerEventPeriodic(gg_trg_OmegaWeapon_SpellRotation,10.)
    call TriggerAddAction(gg_trg_OmegaWeapon_SpellRotation,function Trig_OmegaWeapon_SpellRotation_Actions)
endfunction




endlibrary
