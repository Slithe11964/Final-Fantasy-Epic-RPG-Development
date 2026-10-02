library TWindShear requires TWait
function Trig_WindShear_Cast_Conditions takes nothing returns boolean
    return GetSpellAbilityId()=='A1DW' // 'A1DW': ability "Wind Shear"
endfunction

function Trig_WindShear_Cast_Actions takes nothing returns nothing
    local unit triggeringUnit=GetTriggerUnit()
    local player owningPlayer=GetOwningPlayer(triggeringUnit)
    local real x=GetUnitX(triggeringUnit)
    local real y=GetUnitY(triggeringUnit)
    local unit l_dummy=CreateUnit(owningPlayer,'h01B',x,y,.0) // 'h01B': unit "Proxy Dummy"
    local integer l_dummyId=GetHandleId(l_dummy)
    call SaveUnitHandle(udg_ProxyDamageHash,l_dummyId,0,triggeringUnit)
    call SaveReal(udg_ProxyDamageHash,l_dummyId,1,7500.)
    call SaveInteger(udg_ProxyDamageHash,l_dummyId,2,2)
    call SaveInteger(udg_ProxyDamageHash,l_dummyId,3,3)
    call ShowUnit(l_dummy,false)
    call UnitAddAbility(l_dummy,'A0M6') // 'A0M6': ability "Wind-elemental Damage"
    call UnitAddAbility(l_dummy,'A1DX') // 'A1DX': ability "Wind Shear"
    call UnitApplyTimedLife(l_dummy,'BTLF',3.) // 'BTLF': object name not found in map data
    call IssueImmediateOrderById(l_dummy,$D022E) // $D022E = 852526
    call Wait_Polled(.5)
    set x=GetUnitX(triggeringUnit)
    set y=GetUnitY(triggeringUnit)
    call SetUnitX(l_dummy,x)
    call SetUnitY(l_dummy,y)
    call IssueImmediateOrderById(l_dummy,$D022E) // $D022E = 852526
    call Wait_Polled(.5)
    set x=GetUnitX(triggeringUnit)
    set y=GetUnitY(triggeringUnit)
    call SetUnitX(l_dummy,x)
    call SetUnitY(l_dummy,y)
    call IssueImmediateOrderById(l_dummy,$D022E) // $D022E = 852526
    set triggeringUnit=null
    set l_dummy=null
    set owningPlayer=null
endfunction

// World Editor calls InitTrig_WindShear automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_WindShear (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_WindShear takes nothing returns nothing
endfunction

function Register_WindShear_Cast takes nothing returns nothing
    set gg_trg_WindShear_Cast=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_WindShear_Cast,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_WindShear_Cast,Condition(function Trig_WindShear_Cast_Conditions))
    call TriggerAddAction(gg_trg_WindShear_Cast,function Trig_WindShear_Cast_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_WindShear takes nothing returns nothing
    call Register_WindShear_Cast()
endfunction

endlibrary
