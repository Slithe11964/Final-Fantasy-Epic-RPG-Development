library TNeedles
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Needles_Cast=null
    trigger gg_trg_Needles_99999_Cast=null
endglobals

function Trig_Needles_Cast_IsNeedlesAbility takes nothing returns boolean
    return(GetSpellAbilityId()=='A0W5')or(GetSpellAbilityId()=='A0W6')or(GetSpellAbilityId()=='A0W7') // 'A0W5': ability "1000 Needles"; 'A0W6': ability "!9999 Needles"; 'A0W7': ability "10000 Needles"
endfunction

function Trig_Needles_Cast_Conditions takes nothing returns boolean
    return(Trig_Needles_Cast_IsNeedlesAbility())
endfunction

function Trig_Needles_Cast_NoTargetUnit takes nothing returns boolean
    return(GetSpellTargetUnit()==null)
endfunction

function Trig_Needles_Cast_Is10000Needles takes nothing returns boolean
    return(GetSpellAbilityId()=='A0W7') // 'A0W7': ability "10000 Needles"
endfunction

function Trig_Needles_Cast_Is9999Needles takes nothing returns boolean
    return(GetSpellAbilityId()=='A0W6') // 'A0W6': ability "!9999 Needles"
endfunction

function Trig_Needles_Cast_Is1000Needles takes nothing returns boolean
    return(GetSpellAbilityId()=='A0W5') // 'A0W5': ability "1000 Needles"
endfunction

function Trig_Needles_Cast_Actions takes nothing returns nothing
    local integer l_tempHandleId
    local integer l_tempInteger
    local location l_tempPoint
    set l_tempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateNUnitsAtLocFacingLocBJ(1,'h01B',GetOwningPlayer(GetTriggerUnit()),l_tempPoint,l_tempPoint) // 'h01B': unit "Proxy Dummy"
    call RemoveLocation(l_tempPoint)
    if(Trig_Needles_Cast_NoTargetUnit())then
        set l_tempPoint=GetSpellTargetLoc()
    else
        set l_tempPoint=GetUnitLoc(GetSpellTargetUnit())
    endif
    call SetUnitFacingToFaceLocTimed(GetLastCreatedUnit(),l_tempPoint,0)
    call RemoveLocation(l_tempPoint)
    set l_tempHandleId=GetHandleIdBJ(GetLastCreatedUnit())
    call SaveUnitHandleBJ(GetTriggerUnit(),0,l_tempHandleId,udg_ProxyDamageHash)
    set l_tempInteger=0
    if(Trig_Needles_Cast_Is1000Needles())then
        set l_tempInteger=$3E8 // $3E8 = 1000
    else
        if(Trig_Needles_Cast_Is9999Needles())then
            set l_tempInteger=9999
        else
            if(Trig_Needles_Cast_Is10000Needles())then
                set l_tempInteger=$2710 // $2710 = 10000
            endif
        endif
    endif
    // Udg_TempInteger treated as a decimal-capable number.
    call SaveRealBJ(I2R(l_tempInteger),1,l_tempHandleId,udg_ProxyDamageHash)
    call SaveIntegerBJ(4,2,l_tempHandleId,udg_ProxyDamageHash)
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(6.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A0EN',GetLastCreatedUnit()) // 'A0EN': ability "Single Target Needles"
    call IssueTargetOrderBJ(GetLastCreatedUnit(),"creepthunderbolt",GetSpellTargetUnit())
    set l_tempPoint=null
endfunction

function Trig_Needles_99999_Cast_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A0W4') // 'A0W4': ability "!99999 Needles"
endfunction

function Trig_Needles_99999_Cast_Actions takes nothing returns nothing
    local integer l_tempHandleId
    local location l_tempPoint
    set l_tempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateNUnitsAtLocFacingLocBJ(1,'h01B',GetOwningPlayer(GetTriggerUnit()),l_tempPoint,l_tempPoint) // 'h01B': unit "Proxy Dummy"
    call RemoveLocation(l_tempPoint)
    set l_tempHandleId=GetHandleIdBJ(GetLastCreatedUnit())
    call SaveUnitHandleBJ(GetTriggerUnit(),0,l_tempHandleId,udg_ProxyDamageHash)
    call SaveRealBJ(9999.,1,l_tempHandleId,udg_ProxyDamageHash)
    call SaveIntegerBJ(4,2,l_tempHandleId,udg_ProxyDamageHash)
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(5.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A0QT',GetLastCreatedUnit()) // 'A0QT': ability "Fan of Knives"
    call IssueImmediateOrderBJ(GetLastCreatedUnit(),"fanofknives")
    set l_tempPoint=null
endfunction

// World Editor calls InitTrig_Needles automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Needles (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Needles takes nothing returns nothing
endfunction

function Register_Needles_Cast takes nothing returns nothing
    set gg_trg_Needles_Cast=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Needles_Cast,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Needles_Cast,Condition(function Trig_Needles_Cast_Conditions))
    call TriggerAddAction(gg_trg_Needles_Cast,function Trig_Needles_Cast_Actions)
endfunction

function Register_Needles_99999_Cast takes nothing returns nothing
    set gg_trg_Needles_99999_Cast=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Needles_99999_Cast,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Needles_99999_Cast,Condition(function Trig_Needles_99999_Cast_Conditions))
    call TriggerAddAction(gg_trg_Needles_99999_Cast,function Trig_Needles_99999_Cast_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Needles takes nothing returns nothing
    call Register_Needles_Cast()
    call Register_Needles_99999_Cast()
endfunction

endlibrary
