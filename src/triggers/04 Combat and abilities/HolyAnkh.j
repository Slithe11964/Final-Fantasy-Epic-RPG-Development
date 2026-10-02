library THolyAnkh
function Trig_HolyAnkh_Waygate_Conditions takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(UnitHasItemOfTypeBJ(GetTriggerUnit(),'I0BZ')) // 'I0BZ': item "Holy Ankh"
endfunction

function Trig_HolyAnkh_Waygate_Cond_RingHintsReady takes nothing returns boolean
    return(udg_RingHintsReady)
endfunction

function Trig_HolyAnkh_Waygate_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call UnitRemoveAbilityBJ('A0VR',gg_unit_n0AP_0240) // 'A0VR': ability "Holy Ankh Hint"
    call UnitRemoveAbilityBJ('Ane2',gg_unit_n0AP_0240) // 'Ane2': object name not found in map data
    call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I0BZ')) // 'I0BZ': item "Holy Ankh"
    call WaygateSetDestinationLocBJ(gg_unit_n0AP_0240,GetRectCenter(gg_rct_472))
    set udg_HolyAnkhUsed=true
    if(Trig_HolyAnkh_Waygate_Cond_RingHintsReady())then
        call WaygateActivateBJ(true,gg_unit_n0AP_0240)
        set udg_SpecialEffect[78]=AddSpecialEffectTargetUnitBJ("origin",gg_unit_n0AP_0240,"Abilities\\Spells\\Human\\Brilliance\\Brilliance.mdl")
    endif
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_HolyAnkh automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_HolyAnkh (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_HolyAnkh takes nothing returns nothing
endfunction

function Register_HolyAnkh_Waygate takes nothing returns nothing
    set gg_trg_HolyAnkh_Waygate=CreateTrigger()
    call TriggerRegisterEnterRectSimple(gg_trg_HolyAnkh_Waygate,gg_rct_583)
    call TriggerAddCondition(gg_trg_HolyAnkh_Waygate,Condition(function Trig_HolyAnkh_Waygate_Conditions))
    call TriggerAddAction(gg_trg_HolyAnkh_Waygate,function Trig_HolyAnkh_Waygate_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_HolyAnkh takes nothing returns nothing
    call Register_HolyAnkh_Waygate()
endfunction

endlibrary
