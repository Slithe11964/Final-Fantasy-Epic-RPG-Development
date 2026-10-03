library TTeleport
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Teleport_Spell=null
    trigger gg_trg_Teleport_ToKalm=null
    trigger gg_trg_Teleport_ToArena=null
endglobals

function Trig_Teleport_Spell_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A0C9' or GetSpellAbilityId()=='A12Z') // 'A0C9': ability "Teleport"; 'A12Z': ability "Teleport"
endfunction

function Trig_Teleport_Spell_Actions takes nothing returns nothing
    local unit caster=GetTriggerUnit()
    local unit targetUnit=GetSpellTargetUnit()
    local real l_tx=GetUnitX(targetUnit)
    local real l_ty=GetUnitY(targetUnit)
    if(GetSpellAbilityId()=='A12Z' and udg_Difficulty>=5)then // 'A12Z': ability "Teleport"
        call DisplayTimedTextToPlayer(GetOwningPlayer(caster),0,0,$A,"|cffff0000Scroll of Portal cannot be used on Inferno or Nightmare difficulty!|r") // $A = 10
    else
        call SetUnitX(caster,l_tx)
        call SetUnitY(caster,l_ty)
    endif
    set caster=null
    set targetUnit=null
endfunction

function Trig_Teleport_ToKalm_Conditions takes nothing returns boolean
    return((GetSpellAbilityId()=='A0GH')and(IsPlayerInForce(GetOwningPlayer(GetSpellTargetUnit()),udg_ActivePlayers))and(IsUnitType(GetSpellTargetUnit(),UNIT_TYPE_HERO))and(GetUnitTypeId(GetSpellTargetUnit())!='H01D'))!=null // 'A0GH': ability "Teleport"; 'H01D': unit "Spirit of Gaya"
endfunction

function Trig_Teleport_ToKalm_Actions takes nothing returns nothing
    local location l_tempPoint
    set l_tempPoint=GetUnitLoc(GetSpellTargetUnit())
    call AddSpecialEffectLocBJ(l_tempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(l_tempPoint)
    call AddSpecialEffectTargetUnitBJ("origin",GetSpellTargetUnit(),"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    set l_tempPoint=GetRectCenter(gg_rct_483)
    call SetUnitPositionLocFacingBJ(GetSpellTargetUnit(),l_tempPoint,180.)
    call PanCameraToTimedLocForPlayer(GetOwningPlayer(GetSpellTargetUnit()),l_tempPoint,0)
    call RemoveLocation(l_tempPoint)
    set l_tempPoint=null
endfunction

function Trig_Teleport_ToArena_Conditions takes nothing returns boolean
    return((GetSpellAbilityId()=='A0GG')and(IsPlayerInForce(GetOwningPlayer(GetSpellTargetUnit()),udg_ActivePlayers))and(IsUnitType(GetSpellTargetUnit(),UNIT_TYPE_HERO))and(GetUnitTypeId(GetSpellTargetUnit())!='H01D'))!=null // 'A0GG': ability "Teleport"; 'H01D': unit "Spirit of Gaya"
endfunction

function Trig_Teleport_ToArena_Actions takes nothing returns nothing
    local location l_tempPoint
    set l_tempPoint=GetUnitLoc(GetSpellTargetUnit())
    call AddSpecialEffectLocBJ(l_tempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(l_tempPoint)
    call AddSpecialEffectTargetUnitBJ("origin",GetSpellTargetUnit(),"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    set l_tempPoint=GetRectCenter(gg_rct_484)
    call SetUnitPositionLocFacingBJ(GetSpellTargetUnit(),l_tempPoint,315.)
    call PanCameraToTimedLocForPlayer(GetOwningPlayer(GetSpellTargetUnit()),l_tempPoint,0)
    call RemoveLocation(l_tempPoint)
    set l_tempPoint=null
endfunction

// World Editor calls InitTrig_Teleport automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Teleport_Part1 / RegisterTriggers_Teleport_Part2 (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Teleport takes nothing returns nothing
endfunction

function Register_Teleport_Spell takes nothing returns nothing
    set gg_trg_Teleport_Spell=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Teleport_Spell,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Teleport_Spell,Condition(function Trig_Teleport_Spell_Conditions))
    call TriggerAddAction(gg_trg_Teleport_Spell,function Trig_Teleport_Spell_Actions)
endfunction

function Register_Teleport_ToKalm takes nothing returns nothing
    set gg_trg_Teleport_ToKalm=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Teleport_ToKalm,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Teleport_ToKalm,Condition(function Trig_Teleport_ToKalm_Conditions))
    call TriggerAddAction(gg_trg_Teleport_ToKalm,function Trig_Teleport_ToKalm_Actions)
endfunction

function Register_Teleport_ToArena takes nothing returns nothing
    set gg_trg_Teleport_ToArena=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Teleport_ToArena,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Teleport_ToArena,Condition(function Trig_Teleport_ToArena_Conditions))
    call TriggerAddAction(gg_trg_Teleport_ToArena,function Trig_Teleport_ToArena_Actions)
endfunction

// Creates part 1 of 2 of this module's triggers. Called once at startup from
// Startup_RegisterTriggers (MapBootstrap). The parts are registered at different points so that
// triggers sharing an event with other modules keep their original firing order.
function RegisterTriggers_Teleport_Part1 takes nothing returns nothing
    call Register_Teleport_Spell()
endfunction

// Creates part 2 of 2 of this module's triggers. Called once at startup from
// Startup_RegisterTriggers (MapBootstrap). The parts are registered at different points so that
// triggers sharing an event with other modules keep their original firing order.
function RegisterTriggers_Teleport_Part2 takes nothing returns nothing
    call Register_Teleport_ToKalm()
    call Register_Teleport_ToArena()
endfunction

endlibrary
