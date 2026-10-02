library TMalboro requires TWait
function Trig_Malboro_BadBreath_IsMalboro takes nothing returns boolean
    return(GetUnitTypeId(GetTriggerUnit())=='n03W')or(GetUnitTypeId(GetTriggerUnit())=='n03X') // 'n03W': unit "Malboro"; 'n03X': unit "Great Malboro"
endfunction

function Trig_Malboro_BadBreath_Conditions takes nothing returns boolean
    return(Trig_Malboro_BadBreath_IsMalboro())and(GetUnitAbilityLevelSwapped('A0EX',GetTriggerUnit())>=1)and(GetUnitStateSwap(UNIT_STATE_MANA,GetTriggerUnit())>=100000.) // 'A0EX': ability "!Bad Breath"
endfunction

function Trig_Malboro_BadBreath_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call IssueImmediateOrderBJ(GetTriggerUnit(),"stomp")
    call Wait_Polled(3.)
    call EnableTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_Malboro automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Malboro (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Malboro takes nothing returns nothing
endfunction

function Register_Malboro_BadBreath takes nothing returns nothing
    set gg_trg_Malboro_BadBreath=CreateTrigger()
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_Malboro_BadBreath,Player($B),EVENT_PLAYER_UNIT_ATTACKED) // $B = 11
    call TriggerAddCondition(gg_trg_Malboro_BadBreath,Condition(function Trig_Malboro_BadBreath_Conditions))
    call TriggerAddAction(gg_trg_Malboro_BadBreath,function Trig_Malboro_BadBreath_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Malboro takes nothing returns nothing
    call Register_Malboro_BadBreath()
endfunction

endlibrary
