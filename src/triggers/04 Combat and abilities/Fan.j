library TFan requires TAbil, TProf
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Fan_Of_Knives=null
endglobals

function Trig_Fan_Of_Knives_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A0QS') // 'A0QS': ability "Fan of Knives"
endfunction

function Trig_Fan_Of_Knives_IsHero takes nothing returns boolean
    return(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Fan_Of_Knives_Actions takes nothing returns nothing
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
    // (2).
    set l_tempInteger=(BlzGetAbilityManaCost(GetSpellAbilityId(),Abil_GetLevel(GetTriggerUnit(),GetSpellAbilityId()))*2)
    if(Trig_Fan_Of_Knives_IsHero())then
        // (l_tempInteger) plus ((Agility of the triggering unit) times (4)).
        set l_tempInteger=(l_tempInteger+(GetHeroStatBJ(bj_HEROSTAT_AGI,GetTriggerUnit(),true)*4))
    endif
    // (0.1) times ((10) plus (Prof_GetLevel(the triggering unit, 'R00B'))).
    set l_tempReal=.1*($A+Prof_GetLevel(GetTriggerUnit(),'R00B')) // $A = 10; 'R00B': upgrade "Dagger"
    // (l_tempInteger treated as a decimal-capable number) times (l_tempReal).
    call SaveRealBJ((I2R(l_tempInteger)*l_tempReal),1,l_tempHandleId,udg_ProxyDamageHash)
    call SaveIntegerBJ(2,2,l_tempHandleId,udg_ProxyDamageHash)
    call SaveIntegerBJ(2,3,l_tempHandleId,udg_ProxyDamageHash)
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(5.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A0QT',GetLastCreatedUnit()) // 'A0QT': ability "Fan of Knives"
    call IssueImmediateOrderBJ(GetLastCreatedUnit(),"fanofknives")
    set l_tempPoint=null
endfunction

// World Editor calls InitTrig_Fan automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Fan (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Fan takes nothing returns nothing
endfunction

function Register_Fan_Of_Knives takes nothing returns nothing
    set gg_trg_Fan_Of_Knives=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Fan_Of_Knives,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Fan_Of_Knives,Condition(function Trig_Fan_Of_Knives_Conditions))
    call TriggerAddAction(gg_trg_Fan_Of_Knives,function Trig_Fan_Of_Knives_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Fan takes nothing returns nothing
    call Register_Fan_Of_Knives()
endfunction

endlibrary
