library TKnot requires TAbil, TProf
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
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateNUnitsAtLocFacingLocBJ(1,'h01B',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,udg_TempPoint) // 'h01B': unit "Proxy Dummy"
    call RemoveLocation(udg_TempPoint)
    if(Trig_Knot_Of_Rust_NoTargetUnit())then
        set udg_TempPoint=GetSpellTargetLoc()
    else
        set udg_TempPoint=GetUnitLoc(GetSpellTargetUnit())
    endif
    call SetUnitFacingToFaceLocTimed(GetLastCreatedUnit(),udg_TempPoint,0)
    call RemoveLocation(udg_TempPoint)
    set udg_TempHandleId=GetHandleIdBJ(GetLastCreatedUnit())
    call SaveUnitHandleBJ(GetTriggerUnit(),0,udg_TempHandleId,udg_ProxyDamageHash)
    // (BlzGetAbilityManaCost(GetSpellAbilityId(), Abil_GetLevel(the triggering unit, GetSpellAbilityId()))) times
    // (4).
    set udg_TempInteger=(BlzGetAbilityManaCost(GetSpellAbilityId(),Abil_GetLevel(GetTriggerUnit(),GetSpellAbilityId()))*4)
    // (udg_TempInteger) plus (((current health of the triggering unit) times (0.2)) with its decimal part
    // removed).
    set udg_TempInteger=(udg_TempInteger+R2I((GetUnitStateSwap(UNIT_STATE_LIFE,GetTriggerUnit())*.2)))
    // (0.1) times ((10) plus (Prof_GetLevel(the triggering unit, 'R000'))).
    set udg_TempReal=.1*($A+Prof_GetLevel(GetTriggerUnit(),'R000')) // $A = 10; 'R000': upgrade "Tools"
    // (udg_TempInteger treated as a decimal-capable number) times (udg_TempReal).
    call SaveRealBJ((I2R(udg_TempInteger)*udg_TempReal),1,udg_TempHandleId,udg_ProxyDamageHash)
    call SaveIntegerBJ(2,2,udg_TempHandleId,udg_ProxyDamageHash)
    call SaveIntegerBJ(4,3,udg_TempHandleId,udg_ProxyDamageHash)
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(6.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A0SO',GetLastCreatedUnit()) // 'A0SO': ability "Knot of Rust"
    call IssueTargetOrderBJ(GetLastCreatedUnit(),"thunderbolt",GetSpellTargetUnit())
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
