library TRipper requires TGroup
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Ripper_Charge_Buffs=null
    trigger gg_trg_Ripper_Mass_Dispel=null
    trigger gg_trg_Ripper_Condemnation=null
    trigger gg_trg_Ripper_Death_Circle=null
endglobals

function Trig_Ripper_Charge_Buffs_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A1ES') // 'A1ES': ability "Ripper Charge"
endfunction

function Trig_Ripper_Charge_Buffs_Actions takes nothing returns nothing
    local location l_tempPoint
    set l_tempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateNUnitsAtLocFacingLocBJ(1,'h02S',GetOwningPlayer(GetTriggerUnit()),l_tempPoint,l_tempPoint) // 'h02S': unit "Simple Casting Dummy"
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(1.5,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('ACbb',GetLastCreatedUnit()) // 'ACbb': ability "Haste"
    call IssueTargetOrderBJ(GetLastCreatedUnit(),"bloodlust",GetTriggerUnit())
    call CreateNUnitsAtLocFacingLocBJ(1,'h02S',GetOwningPlayer(GetTriggerUnit()),l_tempPoint,l_tempPoint) // 'h02S': unit "Simple Casting Dummy"
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(1.5,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A13P',GetLastCreatedUnit()) // 'A13P': ability "Shell"
    call IssueTargetOrderBJ(GetLastCreatedUnit(),"drunkenhaze",GetTriggerUnit())
    call CreateNUnitsAtLocFacingLocBJ(1,'h02S',GetOwningPlayer(GetTriggerUnit()),l_tempPoint,l_tempPoint) // 'h02S': unit "Simple Casting Dummy"
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(1.5,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A09K',GetLastCreatedUnit()) // 'A09K': ability "Protect"
    call IssueTargetOrderBJ(GetLastCreatedUnit(),"frostarmor",GetTriggerUnit())
    call CreateNUnitsAtLocFacingLocBJ(1,'h02S',GetOwningPlayer(GetTriggerUnit()),l_tempPoint,l_tempPoint) // 'h02S': unit "Simple Casting Dummy"
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(1.5,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A0MZ',GetLastCreatedUnit()) // 'A0MZ': ability "Bravery"
    call IssueTargetOrderBJ(GetLastCreatedUnit(),"innerfire",GetTriggerUnit())
    call CreateNUnitsAtLocFacingLocBJ(1,'h02S',GetOwningPlayer(GetTriggerUnit()),l_tempPoint,l_tempPoint) // 'h02S': unit "Simple Casting Dummy"
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(1.5,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A0N0',GetLastCreatedUnit()) // 'A0N0': ability "Faith"
    call IssueTargetOrderBJ(GetLastCreatedUnit(),"unholyfrenzy",GetTriggerUnit())
    call RemoveLocation(l_tempPoint)
    set l_tempPoint=null
endfunction

function Trig_Ripper_Mass_Dispel_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A1EU') // 'A1EU': ability "Mass Dispel"
endfunction

function Trig_Ripper_Mass_Dispel_Filter_DispelAlive takes nothing returns boolean
    return(IsUnitAliveBJ(GetFilterUnit()))
endfunction

function Trig_Ripper_Mass_Dispel_Filter_DispelEnemy takes nothing returns boolean
    return(IsUnitEnemy(GetFilterUnit(),GetOwningPlayer(GetTriggerUnit())))
endfunction

function Trig_Ripper_Mass_Dispel_Filter_DispelAliveEnemy takes nothing returns boolean
    return GetBooleanAnd(Trig_Ripper_Mass_Dispel_Filter_DispelAlive(),Trig_Ripper_Mass_Dispel_Filter_DispelEnemy())
endfunction

function Trig_Ripper_Mass_Dispel_Filter_DispelVulnerable takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('Avul',GetFilterUnit())<=0) // 'Avul': standard ability reference "Invulnerable"
endfunction

function Trig_Ripper_Mass_Dispel_Filter_DispelTarget takes nothing returns boolean
    return GetBooleanAnd(Trig_Ripper_Mass_Dispel_Filter_DispelAliveEnemy(),Trig_Ripper_Mass_Dispel_Filter_DispelVulnerable())
endfunction

function Trig_Ripper_Mass_Dispel_Enum_DispelUnit takes nothing returns nothing
    set udg_DispelTarget=GetEnumUnit()
    call ConditionalTriggerExecute(gg_trg_Remove_Buffs)
endfunction

function Trig_Ripper_Mass_Dispel_Actions takes nothing returns nothing
    local group l_tempGroup
    local location l_tempPoint
    set l_tempPoint=GetUnitLoc(GetTriggerUnit())
    set l_tempGroup=Group_UnitsInRangeOfLoc(900.,l_tempPoint,Condition(function Trig_Ripper_Mass_Dispel_Filter_DispelTarget))
    call RemoveLocation(l_tempPoint)
    call ForGroupBJ(l_tempGroup,function Trig_Ripper_Mass_Dispel_Enum_DispelUnit)
    call DestroyGroup(l_tempGroup)
    set l_tempGroup=null
    set l_tempPoint=null
endfunction

function Trig_Ripper_Condemnation_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A1ER') // 'A1ER': ability "Condemnation"
endfunction

function Trig_Ripper_Condemnation_Actions takes nothing returns nothing
    local integer l_tempHandleId
    local location l_tempPoint
    set l_tempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateNUnitsAtLocFacingLocBJ(1,'h01B',GetOwningPlayer(GetTriggerUnit()),l_tempPoint,l_tempPoint) // 'h01B': unit "Proxy Dummy"
    call RemoveLocation(l_tempPoint)
    set l_tempHandleId=GetHandleIdBJ(GetLastCreatedUnit())
    call SaveUnitHandleBJ(GetTriggerUnit(),0,l_tempHandleId,udg_ProxyDamageHash)
    call SaveRealBJ(33333.,1,l_tempHandleId,udg_ProxyDamageHash)
    call SaveIntegerBJ(3,2,l_tempHandleId,udg_ProxyDamageHash)
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(10.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A1EQ',GetLastCreatedUnit()) // 'A1EQ': ability "Condemn"
    call IssueImmediateOrderBJ(GetLastCreatedUnit(),"fanofknives")
    set l_tempPoint=null
endfunction

function Trig_Ripper_Death_Circle_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A1ET') // 'A1ET': ability "Death Circle"
endfunction

function Trig_Ripper_Death_Circle_Cond_NoTargetUnit takes nothing returns boolean
    return(GetSpellTargetUnit()==null)
endfunction

function Trig_Ripper_Death_Circle_Actions takes nothing returns nothing
    local integer l_tempHandleId
    if(Trig_Ripper_Death_Circle_Cond_NoTargetUnit())then
        set udg_TempPoint=GetSpellTargetLoc()
    else
        set udg_TempPoint=GetUnitLoc(GetSpellTargetUnit())
    endif
    call CreateNUnitsAtLocFacingLocBJ(1,'h01B',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,udg_TempPoint) // 'h01B': unit "Proxy Dummy"
    set l_tempHandleId=GetHandleIdBJ(GetLastCreatedUnit())
    call SaveUnitHandleBJ(GetTriggerUnit(),0,l_tempHandleId,udg_ProxyDamageHash)
    call SaveRealBJ(6666666.,1,l_tempHandleId,udg_ProxyDamageHash)
    call SaveIntegerBJ(4,2,l_tempHandleId,udg_ProxyDamageHash)
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(50.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A1EW',GetLastCreatedUnit()) // 'A1EW': ability "Death Circle"
    call IssuePointOrderLocBJ(GetLastCreatedUnit(),"flamestrike",udg_TempPoint)
    call RemoveLocation(udg_TempPoint)
endfunction

// World Editor calls InitTrig_Ripper automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Ripper (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Ripper takes nothing returns nothing
endfunction

function Register_Ripper_Charge_Buffs takes nothing returns nothing
    set gg_trg_Ripper_Charge_Buffs=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Ripper_Charge_Buffs,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Ripper_Charge_Buffs,Condition(function Trig_Ripper_Charge_Buffs_Conditions))
    call TriggerAddAction(gg_trg_Ripper_Charge_Buffs,function Trig_Ripper_Charge_Buffs_Actions)
endfunction

function Register_Ripper_Mass_Dispel takes nothing returns nothing
    set gg_trg_Ripper_Mass_Dispel=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Ripper_Mass_Dispel,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Ripper_Mass_Dispel,Condition(function Trig_Ripper_Mass_Dispel_Conditions))
    call TriggerAddAction(gg_trg_Ripper_Mass_Dispel,function Trig_Ripper_Mass_Dispel_Actions)
endfunction

function Register_Ripper_Condemnation takes nothing returns nothing
    set gg_trg_Ripper_Condemnation=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Ripper_Condemnation,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Ripper_Condemnation,Condition(function Trig_Ripper_Condemnation_Conditions))
    call TriggerAddAction(gg_trg_Ripper_Condemnation,function Trig_Ripper_Condemnation_Actions)
endfunction

function Register_Ripper_Death_Circle takes nothing returns nothing
    set gg_trg_Ripper_Death_Circle=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Ripper_Death_Circle,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Ripper_Death_Circle,Condition(function Trig_Ripper_Death_Circle_Conditions))
    call TriggerAddAction(gg_trg_Ripper_Death_Circle,function Trig_Ripper_Death_Circle_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Ripper takes nothing returns nothing
    call Register_Ripper_Charge_Buffs()
    call Register_Ripper_Mass_Dispel()
    call Register_Ripper_Condemnation()
    call Register_Ripper_Death_Circle()
endfunction

endlibrary
