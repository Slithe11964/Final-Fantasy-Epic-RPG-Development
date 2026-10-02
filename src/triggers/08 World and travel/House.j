library THouse
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_House_Options_Switch=null
endglobals

function Trig_House_Options_Switch_IsPlayerHouse takes nothing returns boolean
    return(GetSpellAbilityUnit()==udg_PlayerHouse[1])or(GetSpellAbilityUnit()==udg_PlayerHouse[2])or(GetSpellAbilityUnit()==udg_PlayerHouse[3])or(GetSpellAbilityUnit()==udg_PlayerHouse[4])or(GetSpellAbilityUnit()==udg_PlayerHouse[5])or(GetSpellAbilityUnit()==udg_PlayerHouse[6])or(GetSpellAbilityUnit()==udg_PlayerHouse[7])or(GetSpellAbilityUnit()==udg_PlayerHouse[8])
endfunction

function Trig_House_Options_Switch_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A05O')and(Trig_House_Options_Switch_IsPlayerHouse()) // 'A05O': ability "Switch Available Options"
endfunction

function Trig_House_Options_Switch_Actions takes nothing returns nothing
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=8
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        call SetUnitAnimation(udg_PlayerHouse[GetForLoopIndexA()],"stand")
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
endfunction

// World Editor calls InitTrig_House automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_House (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_House takes nothing returns nothing
endfunction

function Register_House_Options_Switch takes nothing returns nothing
    set gg_trg_House_Options_Switch=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_House_Options_Switch,EVENT_PLAYER_UNIT_SPELL_FINISH)
    call TriggerAddCondition(gg_trg_House_Options_Switch,Condition(function Trig_House_Options_Switch_Conditions))
    call TriggerAddAction(gg_trg_House_Options_Switch,function Trig_House_Options_Switch_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_House takes nothing returns nothing
    call Register_House_Options_Switch()
endfunction

endlibrary
