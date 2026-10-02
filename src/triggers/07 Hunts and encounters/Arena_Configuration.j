library TArenaConfiguration
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Arena_ToggleCupMode=null
endglobals

function Trig_Arena_ToggleCupMode_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A14R') // 'A14R': ability "Arena Cup Toggle"
endfunction

function Trig_Arena_ToggleCupMode_IsSurvivalMode takes nothing returns boolean
    return(udg_ArenaSurvivalMode)
endfunction

function Trig_Arena_ToggleCupMode_Actions takes nothing returns nothing
    if(Trig_Arena_ToggleCupMode_IsSurvivalMode())then
        set udg_ArenaSurvivalMode=false
        call DisplayTimedTextToForce(udg_PlayingPlayers,10.,"|cff00ff00Arena:|r Cups are now in Tournament Mode.")
        call SetUnitAbilityLevelSwapped(GetSpellAbilityId(),GetTriggerUnit(),1)
        call BlzUnitDisableAbility(gg_unit_h02I_0167,'A0J9',false,false) // 'A0J9': ability "Arena Match Toggle"
    else
        set udg_ArenaSurvivalMode=true
        call DisplayTimedTextToForce(udg_PlayingPlayers,10.,"|cff00ff00Arena:|r Cups are now in Survival Mode.")
        call SetUnitAbilityLevelSwapped(GetSpellAbilityId(),GetTriggerUnit(),2)
        call BlzUnitDisableAbility(gg_unit_h02I_0167,'A0J9',true,false) // 'A0J9': ability "Arena Match Toggle"
    endif
endfunction

function InitTrig_Arena_Configuration takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Arena_Part3 (module Arena),
// which keeps the original registration order.

function Register_Arena_ToggleCupMode takes nothing returns nothing
    set gg_trg_Arena_ToggleCupMode=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Arena_ToggleCupMode,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Arena_ToggleCupMode,Condition(function Trig_Arena_ToggleCupMode_Conditions))
    call TriggerAddAction(gg_trg_Arena_ToggleCupMode,function Trig_Arena_ToggleCupMode_Actions)
endfunction

endlibrary
