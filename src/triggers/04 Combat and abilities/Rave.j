library TRave requires TAbil, TUnit
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Rave_Kick=null
endglobals

function Trig_Rave_Kick_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A0QO') // 'A0QO': ability "Rave Kick"
endfunction

function Trig_Rave_Kick_NoTargetUnit takes nothing returns boolean
    return(GetSpellTargetUnit()==null)
endfunction

function Trig_Rave_Kick_IsHero takes nothing returns boolean
    return(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Rave_Kick_TargetNotDisabled takes nothing returns boolean
    return(UnitHasBuffBJ(GetSpellTargetUnit(),'B08E')==false)and(UnitHasBuffBJ(GetSpellTargetUnit(),'B03R')==false)and(UnitHasBuffBJ(GetSpellTargetUnit(),'B08I')==false)and(UnitHasBuffBJ(GetSpellTargetUnit(),'BPSE')==false) // 'B08E': buff tooltip "Daze"; 'B03R': buff tooltip "Stunned"; 'B08I': buff tooltip "Stunned"; 'BPSE': buff tooltip "Stunned"
endfunction

function Trig_Rave_Kick_IsCritical takes nothing returns boolean
    return(udg_TempBoolean)
endfunction

function Trig_Rave_Kick_HasHighProficiency takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A136',GetTriggerUnit())>0) // 'A136': ability "High Proficiency"
endfunction

function Trig_Rave_Kick_Actions takes nothing returns nothing
    local integer l_tempHandleId
    local integer l_tempInteger
    local location l_tempPoint
    set l_tempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateNUnitsAtLocFacingLocBJ(1,'h01B',GetOwningPlayer(GetTriggerUnit()),l_tempPoint,l_tempPoint) // 'h01B': unit "Proxy Dummy"
    call RemoveLocation(l_tempPoint)
    if(Trig_Rave_Kick_NoTargetUnit())then
        set l_tempPoint=GetSpellTargetLoc()
    else
        set l_tempPoint=GetUnitLoc(GetSpellTargetUnit())
    endif
    call SetUnitFacingToFaceLocTimed(GetLastCreatedUnit(),l_tempPoint,0)
    set l_tempHandleId=GetHandleIdBJ(GetLastCreatedUnit())
    call SaveUnitHandleBJ(GetTriggerUnit(),0,l_tempHandleId,udg_ProxyDamageHash)
    // (BlzGetAbilityManaCost(GetSpellAbilityId(), Abil_GetLevel(the triggering unit, GetSpellAbilityId()))) times
    // (4).
    set l_tempInteger=(BlzGetAbilityManaCost(GetSpellAbilityId(),Abil_GetLevel(GetTriggerUnit(),GetSpellAbilityId()))*4)
    if(Trig_Rave_Kick_IsHero())then
        // (l_tempInteger) plus ((Strength of the triggering unit) times (10)).
        set l_tempInteger=(l_tempInteger+(GetHeroStatBJ(bj_HEROSTAT_STR,GetTriggerUnit(),true)*$A)) // $A = 10
    endif
    set udg_TempBoolean=Unit_HasNoEquipment(GetTriggerUnit())
    if(Trig_Rave_Kick_IsCritical())then
        if(Trig_Rave_Kick_TargetNotDisabled())then
            // (l_tempInteger) times (2).
            set l_tempInteger=(l_tempInteger*2)
        else
            // (l_tempInteger) times (3).
            set l_tempInteger=(l_tempInteger*3)
        endif
    endif
    if(Trig_Rave_Kick_HasHighProficiency())then
        // ((l_tempInteger) times (5)) divided by (3); drop the remainder.
        set l_tempInteger=((l_tempInteger*5)/ 3)
    endif
    // Udg_TempInteger treated as a decimal-capable number.
    call SaveRealBJ(I2R(l_tempInteger),1,l_tempHandleId,udg_ProxyDamageHash)
    call SaveIntegerBJ(2,2,l_tempHandleId,udg_ProxyDamageHash)
    call SaveIntegerBJ(4,3,l_tempHandleId,udg_ProxyDamageHash)
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(4.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A0M5',GetLastCreatedUnit()) // 'A0M5': ability "Earth-elemental Damage"
    call UnitAddAbilityBJ('A0QP',GetLastCreatedUnit()) // 'A0QP': ability "Rave Kick"
    call IssuePointOrderLocBJ(GetLastCreatedUnit(),"shockwave",l_tempPoint)
    call RemoveLocation(l_tempPoint)
    set l_tempPoint=null
endfunction

// World Editor calls InitTrig_Rave automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Rave (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Rave takes nothing returns nothing
endfunction

function Register_Rave_Kick takes nothing returns nothing
    set gg_trg_Rave_Kick=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Rave_Kick,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Rave_Kick,Condition(function Trig_Rave_Kick_Conditions))
    call TriggerAddAction(gg_trg_Rave_Kick,function Trig_Rave_Kick_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Rave takes nothing returns nothing
    call Register_Rave_Kick()
endfunction

endlibrary
