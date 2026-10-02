library TArenaConfiguration
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

endlibrary
