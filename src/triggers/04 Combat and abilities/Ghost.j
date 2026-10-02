library TGhost
function Trig_Ghost_Despawn_Conditions takes nothing returns boolean
    return(GetUnitTypeId(GetTriggerUnit())=='u00D') // 'u00D': unit "Death Ghost"
endfunction

function Trig_Ghost_Despawn_Actions takes nothing returns nothing
    call KillUnit(GetTriggerUnit())
    call RemoveUnit(GetTriggerUnit())
endfunction

// World Editor calls InitTrig_Ghost automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Ghost (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Ghost takes nothing returns nothing
endfunction

function Register_Ghost_Despawn takes nothing returns nothing
    set gg_trg_Ghost_Despawn=CreateTrigger()
    call TriggerRegisterEnterRectSimple(gg_trg_Ghost_Despawn,gg_rct_582)
    call TriggerAddCondition(gg_trg_Ghost_Despawn,Condition(function Trig_Ghost_Despawn_Conditions))
    call TriggerAddAction(gg_trg_Ghost_Despawn,function Trig_Ghost_Despawn_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Ghost takes nothing returns nothing
    call Register_Ghost_Despawn()
endfunction

endlibrary
