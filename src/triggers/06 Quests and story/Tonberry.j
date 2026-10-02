library TTonberry
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Tonberry_Gate_Open=null
endglobals

function Trig_Tonberry_Gate_Open_Actions takes nothing returns nothing
    call ModifyGateBJ(bj_GATEOPERATION_OPEN,gg_dest_ATg3_0012)
    call RemoveDestructable(gg_dest_Dofw_0016)
    call ShowUnitShow(gg_unit_Nman_0151)
    call PauseUnitBJ(false,gg_unit_Nman_0151)
    call SetUnitInvulnerable(gg_unit_Nman_0151,false)
    call EnableTrigger(gg_trg_Quest_UltimaWeapon_Start)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_Tonberry automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Tonberry (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Tonberry takes nothing returns nothing
endfunction

function Register_Tonberry_Gate_Open takes nothing returns nothing
    set gg_trg_Tonberry_Gate_Open=CreateTrigger()
    call TriggerAddAction(gg_trg_Tonberry_Gate_Open,function Trig_Tonberry_Gate_Open_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Tonberry takes nothing returns nothing
    call Register_Tonberry_Gate_Open() // used by Hunt_Encounters
endfunction

endlibrary
