library THouse
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

// Registration ownership; called at the original bootstrap positions.
function InitTrig_House takes nothing returns nothing
endfunction

function RegisterR11_House_Options_Switch takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_House_Options_Switch=CreateTrigger()

call TriggerRegisterAnyUnitEventBJ(gg_trg_House_Options_Switch,EVENT_PLAYER_UNIT_SPELL_FINISH)

call TriggerAddCondition(gg_trg_House_Options_Switch,Condition(function Trig_House_Options_Switch_Conditions))

call TriggerAddAction(gg_trg_House_Options_Switch,function Trig_House_Options_Switch_Actions)

endfunction




endlibrary
