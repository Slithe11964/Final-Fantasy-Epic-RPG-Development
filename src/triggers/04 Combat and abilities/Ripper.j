library TRipper requires TGroup
function Trig_Ripper_Charge_Buffs_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A1ES') // 'A1ES': ability "Ripper Charge"
endfunction

function Trig_Ripper_Charge_Buffs_Actions takes nothing returns nothing
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateNUnitsAtLocFacingLocBJ(1,'h02S',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,udg_TempPoint) // 'h02S': unit "Simple Casting Dummy"
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(1.5,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('ACbb',GetLastCreatedUnit()) // 'ACbb': ability "Haste"
    call IssueTargetOrderBJ(GetLastCreatedUnit(),"bloodlust",GetTriggerUnit())
    call CreateNUnitsAtLocFacingLocBJ(1,'h02S',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,udg_TempPoint) // 'h02S': unit "Simple Casting Dummy"
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(1.5,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A13P',GetLastCreatedUnit()) // 'A13P': ability "Shell"
    call IssueTargetOrderBJ(GetLastCreatedUnit(),"drunkenhaze",GetTriggerUnit())
    call CreateNUnitsAtLocFacingLocBJ(1,'h02S',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,udg_TempPoint) // 'h02S': unit "Simple Casting Dummy"
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(1.5,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A09K',GetLastCreatedUnit()) // 'A09K': ability "Protect"
    call IssueTargetOrderBJ(GetLastCreatedUnit(),"frostarmor",GetTriggerUnit())
    call CreateNUnitsAtLocFacingLocBJ(1,'h02S',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,udg_TempPoint) // 'h02S': unit "Simple Casting Dummy"
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(1.5,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A0MZ',GetLastCreatedUnit()) // 'A0MZ': ability "Bravery"
    call IssueTargetOrderBJ(GetLastCreatedUnit(),"innerfire",GetTriggerUnit())
    call CreateNUnitsAtLocFacingLocBJ(1,'h02S',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,udg_TempPoint) // 'h02S': unit "Simple Casting Dummy"
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(1.5,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A0N0',GetLastCreatedUnit()) // 'A0N0': ability "Faith"
    call IssueTargetOrderBJ(GetLastCreatedUnit(),"unholyfrenzy",GetTriggerUnit())
    call RemoveLocation(udg_TempPoint)
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
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    set udg_TempGroup=Group_UnitsInRangeOfLoc(900.,udg_TempPoint,Condition(function Trig_Ripper_Mass_Dispel_Filter_DispelTarget))
    call RemoveLocation(udg_TempPoint)
    call ForGroupBJ(udg_TempGroup,function Trig_Ripper_Mass_Dispel_Enum_DispelUnit)
    call DestroyGroup(udg_TempGroup)
endfunction

function Trig_Ripper_Condemnation_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A1ER') // 'A1ER': ability "Condemnation"
endfunction

function Trig_Ripper_Condemnation_Actions takes nothing returns nothing
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateNUnitsAtLocFacingLocBJ(1,'h01B',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,udg_TempPoint) // 'h01B': unit "Proxy Dummy"
    call RemoveLocation(udg_TempPoint)
    set udg_TempHandleId=GetHandleIdBJ(GetLastCreatedUnit())
    call SaveUnitHandleBJ(GetTriggerUnit(),0,udg_TempHandleId,udg_ProxyDamageHash)
    call SaveRealBJ(33333.,1,udg_TempHandleId,udg_ProxyDamageHash)
    call SaveIntegerBJ(3,2,udg_TempHandleId,udg_ProxyDamageHash)
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(10.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A1EQ',GetLastCreatedUnit()) // 'A1EQ': ability "Condemn"
    call IssueImmediateOrderBJ(GetLastCreatedUnit(),"fanofknives")
endfunction

function Trig_Ripper_Death_Circle_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A1ET') // 'A1ET': ability "Death Circle"
endfunction

function Trig_Ripper_Death_Circle_Cond_NoTargetUnit takes nothing returns boolean
    return(GetSpellTargetUnit()==null)
endfunction

function Trig_Ripper_Death_Circle_Actions takes nothing returns nothing
    if(Trig_Ripper_Death_Circle_Cond_NoTargetUnit())then
        set udg_TempPoint=GetSpellTargetLoc()
    else
        set udg_TempPoint=GetUnitLoc(GetSpellTargetUnit())
    endif
    call CreateNUnitsAtLocFacingLocBJ(1,'h01B',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,udg_TempPoint) // 'h01B': unit "Proxy Dummy"
    set udg_TempHandleId=GetHandleIdBJ(GetLastCreatedUnit())
    call SaveUnitHandleBJ(GetTriggerUnit(),0,udg_TempHandleId,udg_ProxyDamageHash)
    call SaveRealBJ(6666666.,1,udg_TempHandleId,udg_ProxyDamageHash)
    call SaveIntegerBJ(4,2,udg_TempHandleId,udg_ProxyDamageHash)
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(50.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A1EW',GetLastCreatedUnit()) // 'A1EW': ability "Death Circle"
    call IssuePointOrderLocBJ(GetLastCreatedUnit(),"flamestrike",udg_TempPoint)
    call RemoveLocation(udg_TempPoint)
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Ripper takes nothing returns nothing
endfunction

function RegisterR11_Ripper_Charge_Buffs takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Ripper_Charge_Buffs=CreateTrigger()

call TriggerRegisterAnyUnitEventBJ(gg_trg_Ripper_Charge_Buffs,EVENT_PLAYER_UNIT_SPELL_EFFECT)

call TriggerAddCondition(gg_trg_Ripper_Charge_Buffs,Condition(function Trig_Ripper_Charge_Buffs_Conditions))

call TriggerAddAction(gg_trg_Ripper_Charge_Buffs,function Trig_Ripper_Charge_Buffs_Actions)

endfunction




function RegisterR11_Ripper_Mass_Dispel takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Ripper_Mass_Dispel=CreateTrigger()

call TriggerRegisterAnyUnitEventBJ(gg_trg_Ripper_Mass_Dispel,EVENT_PLAYER_UNIT_SPELL_EFFECT)

call TriggerAddCondition(gg_trg_Ripper_Mass_Dispel,Condition(function Trig_Ripper_Mass_Dispel_Conditions))

call TriggerAddAction(gg_trg_Ripper_Mass_Dispel,function Trig_Ripper_Mass_Dispel_Actions)

endfunction




function RegisterR11_Ripper_Condemnation takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Ripper_Condemnation=CreateTrigger()

call TriggerRegisterAnyUnitEventBJ(gg_trg_Ripper_Condemnation,EVENT_PLAYER_UNIT_SPELL_EFFECT)

call TriggerAddCondition(gg_trg_Ripper_Condemnation,Condition(function Trig_Ripper_Condemnation_Conditions))

call TriggerAddAction(gg_trg_Ripper_Condemnation,function Trig_Ripper_Condemnation_Actions)

endfunction




function RegisterR11_Ripper_Death_Circle takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Ripper_Death_Circle=CreateTrigger()

call TriggerRegisterAnyUnitEventBJ(gg_trg_Ripper_Death_Circle,EVENT_PLAYER_UNIT_SPELL_EFFECT)

call TriggerAddCondition(gg_trg_Ripper_Death_Circle,Condition(function Trig_Ripper_Death_Circle_Conditions))

call TriggerAddAction(gg_trg_Ripper_Death_Circle,function Trig_Ripper_Death_Circle_Actions)

endfunction




endlibrary
