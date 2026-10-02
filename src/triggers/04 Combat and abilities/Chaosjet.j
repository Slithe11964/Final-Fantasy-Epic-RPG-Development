library TChaosjet requires TWait
function Trig_Chaosjet_Death_Conditions takes nothing returns boolean
    return(IsUnitInGroup(GetTriggerUnit(),udg_ChaosElementalGroup))
endfunction

function Trig_Chaosjet_Death_OwnerAlive takes nothing returns boolean
    return(udg_ChaosBoss!=null)
endfunction

function Trig_Chaosjet_Death_AllJetsDead takes nothing returns boolean
    return(IsUnitGroupEmptyBJ(udg_ChaosElementalGroup))
endfunction

function Trig_Chaosjet_Death_Actions takes nothing returns nothing
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_ChaosElementalGroup)
    if(Trig_Chaosjet_Death_AllJetsDead())then
        call UnitRemoveBuffBJ('B06R',udg_ChaosBoss) // 'B06R': buff tooltip "Spiritual Guard"
        call Wait_Polled(30.)
        if(Trig_Chaosjet_Death_OwnerAlive())then
            call UnitAddAbilityBJ('A11C',udg_ChaosBoss) // 'A11C': ability "!Revive Chaosjets"
        endif
    endif
endfunction

// World Editor calls InitTrig_Chaosjet automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Chaosjet (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Chaosjet takes nothing returns nothing
endfunction

function Register_Chaosjet_Death takes nothing returns nothing
    set gg_trg_Chaosjet_Death=CreateTrigger()
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_Chaosjet_Death,Player($B),EVENT_PLAYER_UNIT_DEATH) // $B = 11
    call TriggerAddCondition(gg_trg_Chaosjet_Death,Condition(function Trig_Chaosjet_Death_Conditions))
    call TriggerAddAction(gg_trg_Chaosjet_Death,function Trig_Chaosjet_Death_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Chaosjet takes nothing returns nothing
    call Register_Chaosjet_Death()
endfunction

endlibrary
