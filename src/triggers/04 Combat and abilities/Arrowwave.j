library TArrowwave requires TAbil, TProf
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Arrowwave_Cast=null
endglobals

function Trig_Arrowwave_Cast_IsArrowwave takes nothing returns boolean
    return(GetSpellAbilityId()=='A0QQ')or(GetSpellAbilityId()=='A0KB')or(GetSpellAbilityId()=='A00R') // 'A0QQ': ability "Arrowwave"; 'A0KB': ability "Arrowwave"; 'A00R': ability "Arrowwave"
endfunction

function Trig_Arrowwave_Cast_Conditions takes nothing returns boolean
    return(Trig_Arrowwave_Cast_IsArrowwave())
endfunction

function Trig_Arrowwave_Cast_IsHero takes nothing returns boolean
    return(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Arrowwave_Cast_Actions takes nothing returns nothing
    local integer l_tempHandleId
    local integer l_tempInteger
    local location l_tempPoint
    local real l_tempReal
    set l_tempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateNUnitsAtLocFacingLocBJ(1,'h01B',GetOwningPlayer(GetTriggerUnit()),l_tempPoint,l_tempPoint) // 'h01B': unit "Proxy Dummy"
    call RemoveLocation(l_tempPoint)
    set l_tempHandleId=GetHandleIdBJ(GetLastCreatedUnit())
    call SaveUnitHandleBJ(GetTriggerUnit(),0,l_tempHandleId,udg_ProxyDamageHash)
    // (BlzGetAbilityManaCost(GetSpellAbilityId(), Abil_GetLevel(the triggering unit, GetSpellAbilityId()))) times
    // (4).
    set l_tempInteger=(BlzGetAbilityManaCost(GetSpellAbilityId(),Abil_GetLevel(GetTriggerUnit(),GetSpellAbilityId()))*4)
    if(Trig_Arrowwave_Cast_IsHero())then
        // (l_tempInteger) plus ((Agility of the triggering unit) times (2)).
        set l_tempInteger=(l_tempInteger+(GetHeroStatBJ(bj_HEROSTAT_AGI,GetTriggerUnit(),true)*2))
    endif
    // (0.1) times ((10) plus (Prof_GetLevel(the triggering unit, 'R002'))).
    set l_tempReal=.1*($A+Prof_GetLevel(GetTriggerUnit(),'R002')) // $A = 10; 'R002': upgrade "Bow"
    // (l_tempInteger treated as a decimal-capable number) times (l_tempReal).
    call SaveRealBJ((I2R(l_tempInteger)*l_tempReal),1,l_tempHandleId,udg_ProxyDamageHash)
    call SaveIntegerBJ(2,2,l_tempHandleId,udg_ProxyDamageHash)
    call SaveIntegerBJ(3,3,l_tempHandleId,udg_ProxyDamageHash)
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(5.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A0QR',GetLastCreatedUnit()) // 'A0QR': ability "Arrowwave"
    call IssueImmediateOrderBJ(GetLastCreatedUnit(),"fanofknives")
    set l_tempPoint=null
endfunction

// World Editor calls InitTrig_Arrowwave automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Arrowwave (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Arrowwave takes nothing returns nothing
endfunction

function Register_Arrowwave_Cast takes nothing returns nothing
    set gg_trg_Arrowwave_Cast=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Arrowwave_Cast,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Arrowwave_Cast,Condition(function Trig_Arrowwave_Cast_Conditions))
    call TriggerAddAction(gg_trg_Arrowwave_Cast,function Trig_Arrowwave_Cast_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Arrowwave takes nothing returns nothing
    call Register_Arrowwave_Cast()
endfunction

endlibrary
