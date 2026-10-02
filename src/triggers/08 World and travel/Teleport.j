library TTeleport
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
    set udg_TempPoint=GetUnitLoc(GetSpellTargetUnit())
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(udg_TempPoint)
    call AddSpecialEffectTargetUnitBJ("origin",GetSpellTargetUnit(),"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    set udg_TempPoint=GetRectCenter(gg_rct_483)
    call SetUnitPositionLocFacingBJ(GetSpellTargetUnit(),udg_TempPoint,180.)
    call PanCameraToTimedLocForPlayer(GetOwningPlayer(GetSpellTargetUnit()),udg_TempPoint,0)
    call RemoveLocation(udg_TempPoint)
endfunction

function Trig_Teleport_ToArena_Conditions takes nothing returns boolean
    return((GetSpellAbilityId()=='A0GG')and(IsPlayerInForce(GetOwningPlayer(GetSpellTargetUnit()),udg_ActivePlayers))and(IsUnitType(GetSpellTargetUnit(),UNIT_TYPE_HERO))and(GetUnitTypeId(GetSpellTargetUnit())!='H01D'))!=null // 'A0GG': ability "Teleport"; 'H01D': unit "Spirit of Gaya"
endfunction

function Trig_Teleport_ToArena_Actions takes nothing returns nothing
    set udg_TempPoint=GetUnitLoc(GetSpellTargetUnit())
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(udg_TempPoint)
    call AddSpecialEffectTargetUnitBJ("origin",GetSpellTargetUnit(),"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    set udg_TempPoint=GetRectCenter(gg_rct_484)
    call SetUnitPositionLocFacingBJ(GetSpellTargetUnit(),udg_TempPoint,315.)
    call PanCameraToTimedLocForPlayer(GetOwningPlayer(GetSpellTargetUnit()),udg_TempPoint,0)
    call RemoveLocation(udg_TempPoint)
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Teleport takes nothing returns nothing
endfunction

function RegisterR11_Teleport_Spell takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Teleport_Spell=CreateTrigger()

call TriggerRegisterAnyUnitEventBJ(gg_trg_Teleport_Spell,EVENT_PLAYER_UNIT_SPELL_EFFECT)

call TriggerAddCondition(gg_trg_Teleport_Spell,Condition(function Trig_Teleport_Spell_Conditions))

call TriggerAddAction(gg_trg_Teleport_Spell,function Trig_Teleport_Spell_Actions)

endfunction




function RegisterR11_Teleport_ToKalm takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Teleport_ToKalm=CreateTrigger()

call TriggerRegisterAnyUnitEventBJ(gg_trg_Teleport_ToKalm,EVENT_PLAYER_UNIT_SPELL_EFFECT)

call TriggerAddCondition(gg_trg_Teleport_ToKalm,Condition(function Trig_Teleport_ToKalm_Conditions))

call TriggerAddAction(gg_trg_Teleport_ToKalm,function Trig_Teleport_ToKalm_Actions)

endfunction




function RegisterR11_Teleport_ToArena takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Teleport_ToArena=CreateTrigger()

call TriggerRegisterAnyUnitEventBJ(gg_trg_Teleport_ToArena,EVENT_PLAYER_UNIT_SPELL_EFFECT)

call TriggerAddCondition(gg_trg_Teleport_ToArena,Condition(function Trig_Teleport_ToArena_Conditions))

call TriggerAddAction(gg_trg_Teleport_ToArena,function Trig_Teleport_ToArena_Actions)

endfunction




endlibrary
