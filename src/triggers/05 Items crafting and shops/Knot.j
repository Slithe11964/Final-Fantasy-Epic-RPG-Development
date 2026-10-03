library TKnot requires TAbil, TProf
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Knot_Of_Rust=null
endglobals

function Trig_Knot_Of_Rust_IsKnotOfRust takes nothing returns boolean
    return(GetSpellAbilityId()=='A0SP')or(GetSpellAbilityId()=='A17D')or(GetSpellAbilityId()=='A0SQ') // 'A0SP': ability "Knot of Rust"; 'A17D': ability "Knot of Rust"; 'A0SQ': ability "Knot of Rust"
endfunction

function Trig_Knot_Of_Rust_Conditions takes nothing returns boolean
    return(Trig_Knot_Of_Rust_IsKnotOfRust())
endfunction

function Trig_Knot_Of_Rust_NoTargetUnit takes nothing returns boolean
    return(GetSpellTargetUnit()==null)
endfunction

function Trig_Knot_Of_Rust_Actions takes nothing returns nothing
    local integer l_tempHandleId
    local integer l_tempInteger
    local location l_tempPoint
    local real l_tempReal
    set l_tempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateNUnitsAtLocFacingLocBJ(1,'h01B',GetOwningPlayer(GetTriggerUnit()),l_tempPoint,l_tempPoint) // 'h01B': unit "Proxy Dummy"
    call RemoveLocation(l_tempPoint)
    if(Trig_Knot_Of_Rust_NoTargetUnit())then
        set l_tempPoint=GetSpellTargetLoc()
    else
        set l_tempPoint=GetUnitLoc(GetSpellTargetUnit())
    endif
    call SetUnitFacingToFaceLocTimed(GetLastCreatedUnit(),l_tempPoint,0)
    call RemoveLocation(l_tempPoint)
    set l_tempHandleId=GetHandleIdBJ(GetLastCreatedUnit())
    call SaveUnitHandleBJ(GetTriggerUnit(),0,l_tempHandleId,udg_ProxyDamageHash)
    set l_tempInteger=(BlzGetAbilityManaCost(GetSpellAbilityId(),Abil_GetLevel(GetTriggerUnit(),GetSpellAbilityId()))*4)
    set l_tempInteger=(l_tempInteger+R2I((GetUnitStateSwap(UNIT_STATE_LIFE,GetTriggerUnit())*.2)))
    set l_tempReal=.1*($A+Prof_GetLevel(GetTriggerUnit(),'R000')) // $A = 10; 'R000': upgrade "Tools"
    call SaveRealBJ((I2R(l_tempInteger)*l_tempReal),1,l_tempHandleId,udg_ProxyDamageHash)
    call SaveIntegerBJ(2,2,l_tempHandleId,udg_ProxyDamageHash)
    call SaveIntegerBJ(4,3,l_tempHandleId,udg_ProxyDamageHash)
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(6.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A0SO',GetLastCreatedUnit()) // 'A0SO': ability "Knot of Rust"
    call IssueTargetOrderBJ(GetLastCreatedUnit(),"thunderbolt",GetSpellTargetUnit())
    set l_tempPoint=null
endfunction

// World Editor calls InitTrig_Knot automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Knot (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Knot takes nothing returns nothing
endfunction

function Register_Knot_Of_Rust takes nothing returns nothing
    set gg_trg_Knot_Of_Rust=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Knot_Of_Rust,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Knot_Of_Rust,Condition(function Trig_Knot_Of_Rust_Conditions))
    call TriggerAddAction(gg_trg_Knot_Of_Rust,function Trig_Knot_Of_Rust_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Knot takes nothing returns nothing
    call Register_Knot_Of_Rust()
endfunction

endlibrary
