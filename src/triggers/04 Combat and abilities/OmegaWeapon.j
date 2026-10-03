library TOmegaWeapon requires TGroup, TWait
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_OmegaWeapon_Hide=null
    trigger gg_trg_OmegaWeapon_SpellRotation=null
endglobals

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
    return(CountUnitsInGroup(udg_TempGroup)>0)and(GetUnitCurrentOrder(gg_unit_N022_0125)!=$D009D)and(GetUnitLifePercent(gg_unit_N022_0125)<=75.) // $D009D = 852125
endfunction

function Trig_OmegaWeapon_SpellRotation_Actions takes nothing returns nothing
    local location l_tempPoint
    set l_tempPoint=GetUnitLoc(gg_unit_N022_0125)
    set udg_TempGroup=Group_UnitsInRangeOfLoc(750.,l_tempPoint,Condition(function Trig_OmegaWeapon_SpellRotation_Filter_ValidTarget1))
    call RemoveLocation(l_tempPoint)
    if(Trig_OmegaWeapon_SpellRotation_Cond_CanCastLightning())then
        call IssueTargetOrderBJ(gg_unit_N022_0125,"forkedlightning",GroupPickRandomUnit(udg_TempGroup))
    endif
    call DestroyGroup(udg_TempGroup)
    call Wait_Polled(2)
    set l_tempPoint=GetUnitLoc(gg_unit_N022_0125)
    set udg_TempGroup=Group_UnitsInRangeOfLoc(750.,l_tempPoint,Condition(function Trig_OmegaWeapon_SpellRotation_Filter_ValidTarget2))
    call RemoveLocation(l_tempPoint)
    if(Trig_OmegaWeapon_SpellRotation_Cond_CanCastThunderbolt())then
        call IssueTargetOrderBJ(gg_unit_N022_0125,"thunderbolt",GroupPickRandomUnit(udg_TempGroup))
    endif
    call DestroyGroup(udg_TempGroup)
    call Wait_Polled(2)
    set l_tempPoint=GetUnitLoc(gg_unit_N022_0125)
    set udg_TempGroup=Group_UnitsInRangeOfLoc(750.,l_tempPoint,Condition(function Trig_OmegaWeapon_SpellRotation_Filter_ValidTarget3))
    call RemoveLocation(l_tempPoint)
    if(Trig_OmegaWeapon_SpellRotation_Cond_CanCastFrostNova())then
        call IssueTargetOrderBJ(gg_unit_N022_0125,"frostnova",GroupPickRandomUnit(udg_TempGroup))
    endif
    call DestroyGroup(udg_TempGroup)
    call Wait_Polled(2)
    set l_tempPoint=GetUnitLoc(gg_unit_N022_0125)
    set udg_TempGroup=Group_UnitsInRangeOfLoc(750.,l_tempPoint,Condition(function Trig_OmegaWeapon_SpellRotation_Filter_ValidTarget4))
    call RemoveLocation(l_tempPoint)
    if(Trig_OmegaWeapon_SpellRotation_Cond_CanCastFlameStrike())then
        set l_tempPoint=GetUnitLoc(GroupPickRandomUnit(udg_TempGroup))
        call IssuePointOrderLocBJ(gg_unit_N022_0125,"flamestrike",l_tempPoint)
        call RemoveLocation(l_tempPoint)
    endif
    call DestroyGroup(udg_TempGroup)
    set l_tempPoint=null
endfunction

// World Editor calls InitTrig_OmegaWeapon automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_OmegaWeapon (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_OmegaWeapon takes nothing returns nothing
endfunction

function Register_OmegaWeapon_Hide takes nothing returns nothing
    set gg_trg_OmegaWeapon_Hide=CreateTrigger()
    call TriggerAddAction(gg_trg_OmegaWeapon_Hide,function Trig_OmegaWeapon_Hide_Actions)
endfunction

function Register_OmegaWeapon_SpellRotation takes nothing returns nothing
    set gg_trg_OmegaWeapon_SpellRotation=CreateTrigger()
    call DisableTrigger(gg_trg_OmegaWeapon_SpellRotation)
    call TriggerRegisterTimerEventPeriodic(gg_trg_OmegaWeapon_SpellRotation,10.)
    call TriggerAddAction(gg_trg_OmegaWeapon_SpellRotation,function Trig_OmegaWeapon_SpellRotation_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_OmegaWeapon takes nothing returns nothing
    call Register_OmegaWeapon_Hide() // run by MapBootstrap
    call Register_OmegaWeapon_SpellRotation() // starts off; enabled by Quest_OmegaWeapon
endfunction

endlibrary
