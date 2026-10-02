library TStop
function Trig_Stop_Friendly_Attack_Conditions takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetAttacker()),udg_ActivePlayers))and(IsPlayerInForce(GetOwningPlayer(GetAttackedUnitBJ()),udg_PlayingPlayers))and(IsUnitEnemy(GetTriggerUnit(),GetOwningPlayer(GetAttacker()))==false)
endfunction

function Trig_Stop_Friendly_Attack_Actions takes nothing returns nothing
    call IssueImmediateOrderBJ(GetAttacker(),"stop")
endfunction

// World Editor calls InitTrig_Stop automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Stop (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Stop takes nothing returns nothing
endfunction

function Register_Stop_Friendly_Attack takes nothing returns nothing
    set gg_trg_Stop_Friendly_Attack=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Stop_Friendly_Attack,EVENT_PLAYER_UNIT_ATTACKED)
    call TriggerAddCondition(gg_trg_Stop_Friendly_Attack,Condition(function Trig_Stop_Friendly_Attack_Conditions))
    call TriggerAddAction(gg_trg_Stop_Friendly_Attack,function Trig_Stop_Friendly_Attack_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Stop takes nothing returns nothing
    call Register_Stop_Friendly_Attack()
endfunction

endlibrary
