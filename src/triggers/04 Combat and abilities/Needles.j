library TNeedles
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
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateNUnitsAtLocFacingLocBJ(1,'h01B',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,udg_TempPoint) // 'h01B': unit "Proxy Dummy"
    call RemoveLocation(udg_TempPoint)
    if(Trig_Needles_Cast_NoTargetUnit())then
        set udg_TempPoint=GetSpellTargetLoc()
    else
        set udg_TempPoint=GetUnitLoc(GetSpellTargetUnit())
    endif
    call SetUnitFacingToFaceLocTimed(GetLastCreatedUnit(),udg_TempPoint,0)
    call RemoveLocation(udg_TempPoint)
    set udg_TempHandleId=GetHandleIdBJ(GetLastCreatedUnit())
    call SaveUnitHandleBJ(GetTriggerUnit(),0,udg_TempHandleId,udg_ProxyDamageHash)
    set udg_TempInteger=0
    if(Trig_Needles_Cast_Is1000Needles())then
        set udg_TempInteger=$3E8 // $3E8 = 1000
    else
        if(Trig_Needles_Cast_Is9999Needles())then
            set udg_TempInteger=9999
        else
            if(Trig_Needles_Cast_Is10000Needles())then
                set udg_TempInteger=$2710 // $2710 = 10000
            endif
        endif
    endif
    // Udg_TempInteger treated as a decimal-capable number.
    call SaveRealBJ(I2R(udg_TempInteger),1,udg_TempHandleId,udg_ProxyDamageHash)
    call SaveIntegerBJ(4,2,udg_TempHandleId,udg_ProxyDamageHash)
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(6.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A0EN',GetLastCreatedUnit()) // 'A0EN': ability "Single Target Needles"
    call IssueTargetOrderBJ(GetLastCreatedUnit(),"creepthunderbolt",GetSpellTargetUnit())
endfunction

function Trig_Needles_99999_Cast_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A0W4') // 'A0W4': ability "!99999 Needles"
endfunction

function Trig_Needles_99999_Cast_Actions takes nothing returns nothing
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateNUnitsAtLocFacingLocBJ(1,'h01B',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,udg_TempPoint) // 'h01B': unit "Proxy Dummy"
    call RemoveLocation(udg_TempPoint)
    set udg_TempHandleId=GetHandleIdBJ(GetLastCreatedUnit())
    call SaveUnitHandleBJ(GetTriggerUnit(),0,udg_TempHandleId,udg_ProxyDamageHash)
    call SaveRealBJ(9999.,1,udg_TempHandleId,udg_ProxyDamageHash)
    call SaveIntegerBJ(4,2,udg_TempHandleId,udg_ProxyDamageHash)
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(5.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A0QT',GetLastCreatedUnit()) // 'A0QT': ability "Fan of Knives"
    call IssueImmediateOrderBJ(GetLastCreatedUnit(),"fanofknives")
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
