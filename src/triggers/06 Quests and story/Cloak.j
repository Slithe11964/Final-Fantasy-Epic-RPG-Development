library TCloak requires TPlayerPart01
function Trig_Cloak_Equip_Cond_IsCloakItem takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='I0HT')or(GetItemTypeId(GetManipulatedItem())=='I0IB')or(GetItemTypeId(GetManipulatedItem())=='I00D')or(GetItemTypeId(GetManipulatedItem())=='I0J8') // 'I0HT': item "Prominent Cloak"; 'I0IB': item "Hunter's Cloak"; 'I00D': item "Champion's Belt"; 'I0J8': item "Champion's Belt (BP)"
endfunction

function Trig_Cloak_Equip_Conditions takes nothing returns boolean
    return(Trig_Cloak_Equip_Cond_IsCloakItem())and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))
endfunction

function Trig_Cloak_Equip_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call StartTimerBJ(udg_JobChangeTimer,false,.01)
    call EnableTrigger(gg_trg_Cloak_UpdateStats)
endfunction

function Trig_Cloak_UpdateStats_Cond_HasOnesDigit takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0Z7',Player_GetHero(GetEnumPlayer()))>0) // 'A0Z7': ability "Cloak"
endfunction

function Trig_Cloak_UpdateStats_Cond_NoOnesDigit_Belt takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0Z7',Player_GetHero(GetEnumPlayer()))<=0) // 'A0Z7': ability "Cloak"
endfunction

function Trig_Cloak_UpdateStats_Cond_BeltStacksOdd takes nothing returns boolean
    // The remainder after dividing (udg_BeltStacks at position GetConvertedPlayerId(the player being visited)) by
    // (2).
    return(ModuloInteger(udg_BeltStacks[GetConvertedPlayerId(GetEnumPlayer())],2)==1)
endfunction

function Trig_Cloak_UpdateStats_Cond_BeltStacksCapped takes nothing returns boolean
    return(udg_BeltStacks[GetConvertedPlayerId(GetEnumPlayer())]>=$F) // $F = 15
endfunction

function Trig_Cloak_UpdateStats_Cond_HasChampionBelt takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A12A',Player_GetHero(GetEnumPlayer()))>0) // 'A12A': ability "Champion's Belt"
endfunction

function Trig_Cloak_UpdateStats_Cond_NoOnesDigit_Hunter takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0Z7',Player_GetHero(GetEnumPlayer()))<=0) // 'A0Z7': ability "Cloak"
endfunction

function Trig_Cloak_UpdateStats_Cond_HunterCountCapped takes nothing returns boolean
    return(udg_PlayerKillCount[GetConvertedPlayerId(GetEnumPlayer())]>=$7D0) // $7D0 = 2000
endfunction

function Trig_Cloak_UpdateStats_Cond_HasHunterCloak takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0ZS',Player_GetHero(GetEnumPlayer()))>0) // 'A0ZS': ability "Hunter Cloak"
endfunction

function Trig_Cloak_UpdateStats_Cond_NoOnesDigit_Prominent takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0Z7',Player_GetHero(GetEnumPlayer()))<=0) // 'A0Z7': ability "Cloak"
endfunction

function Trig_Cloak_UpdateStats_Cond_HasProminentCloak takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0Z6',Player_GetHero(GetEnumPlayer()))>0) // 'A0Z6': ability "Prominent Cloak"
endfunction

function Trig_Cloak_UpdateStats_UpdateCloakDigits takes nothing returns nothing
    if(Trig_Cloak_UpdateStats_Cond_HasProminentCloak())then
        if(Trig_Cloak_UpdateStats_Cond_NoOnesDigit_Prominent())then
            call UnitAddAbilityBJ('A0Z7',Player_GetHero(GetEnumPlayer())) // 'A0Z7': ability "Cloak"
            call UnitAddAbilityBJ('A15T',Player_GetHero(GetEnumPlayer())) // 'A15T': ability "Cloak"
        endif
        // (the remainder after dividing (udg_QuestsCompleted) by (10)) plus (1).
        call SetUnitAbilityLevelSwapped('A0Z7',Player_GetHero(GetEnumPlayer()),(ModuloInteger(udg_QuestsCompleted,$A)+1)) // 'A0Z7': ability "Cloak"; $A = 10
        // ((udg_QuestsCompleted) divided by (10); drop the remainder) plus (1).
        call SetUnitAbilityLevelSwapped('A15T',Player_GetHero(GetEnumPlayer()),((udg_QuestsCompleted/ $A)+1)) // 'A15T': ability "Cloak"; $A = 10
        set udg_TempBoolean=true
    else
        if(Trig_Cloak_UpdateStats_Cond_HasHunterCloak())then
            if(Trig_Cloak_UpdateStats_Cond_NoOnesDigit_Hunter())then
                call UnitAddAbilityBJ('A0Z7',Player_GetHero(GetEnumPlayer())) // 'A0Z7': ability "Cloak"
                call UnitAddAbilityBJ('A15T',Player_GetHero(GetEnumPlayer())) // 'A15T': ability "Cloak"
            endif
            if(Trig_Cloak_UpdateStats_Cond_HunterCountCapped())then
                call SetUnitAbilityLevelSwapped('A0Z7',Player_GetHero(GetEnumPlayer()),1) // 'A0Z7': ability "Cloak"
                call SetUnitAbilityLevelSwapped('A15T',Player_GetHero(GetEnumPlayer()),$B) // 'A15T': ability "Cloak"; $B = 11
            else
                // Result 1: (udg_PlayerKillCount at position GetConvertedPlayerId(the player being visited)) divided by (20);
                // drop the remainder.
                // Result 2: the remainder after dividing (result 1) by (10).
                // Result 3: (result 2) plus (1).
                call SetUnitAbilityLevelSwapped('A0Z7',Player_GetHero(GetEnumPlayer()),(ModuloInteger((udg_PlayerKillCount[GetConvertedPlayerId(GetEnumPlayer())]/ 20),$A)+1)) // 'A0Z7': ability "Cloak"; $A = 10
                // Result 1: (udg_PlayerKillCount at position GetConvertedPlayerId(the player being visited)) divided by (200);
                // drop the remainder.
                // Result 2: (result 1) plus (1).
                call SetUnitAbilityLevelSwapped('A15T',Player_GetHero(GetEnumPlayer()),((udg_PlayerKillCount[GetConvertedPlayerId(GetEnumPlayer())]/ $C8)+1)) // 'A15T': ability "Cloak"; $C8 = 200
            endif
            set udg_TempBoolean=true
        else
            if(Trig_Cloak_UpdateStats_Cond_HasChampionBelt())then
                if(Trig_Cloak_UpdateStats_Cond_NoOnesDigit_Belt())then
                    call UnitAddAbilityBJ('A0Z7',Player_GetHero(GetEnumPlayer())) // 'A0Z7': ability "Cloak"
                    call UnitAddAbilityBJ('A15T',Player_GetHero(GetEnumPlayer())) // 'A15T': ability "Cloak"
                endif
                if(Trig_Cloak_UpdateStats_Cond_BeltStacksCapped())then
                    call SetUnitAbilityLevelSwapped('A0Z7',Player_GetHero(GetEnumPlayer()),6) // 'A0Z7': ability "Cloak"
                    call SetUnitAbilityLevelSwapped('A15T',Player_GetHero(GetEnumPlayer()),8) // 'A15T': ability "Cloak"
                else
                    if(Trig_Cloak_UpdateStats_Cond_BeltStacksOdd())then
                        call SetUnitAbilityLevelSwapped('A0Z7',Player_GetHero(GetEnumPlayer()),6) // 'A0Z7': ability "Cloak"
                    else
                        call SetUnitAbilityLevelSwapped('A0Z7',Player_GetHero(GetEnumPlayer()),1) // 'A0Z7': ability "Cloak"
                    endif
                    // Result 1: (udg_BeltStacks at position GetConvertedPlayerId(the player being visited)) divided by (2); drop
                    // the remainder.
                    // Result 2: (result 1) plus (1).
                    call SetUnitAbilityLevelSwapped('A15T',Player_GetHero(GetEnumPlayer()),((udg_BeltStacks[GetConvertedPlayerId(GetEnumPlayer())]/ 2)+1)) // 'A15T': ability "Cloak"
                endif
                set udg_TempBoolean=true
            else
                if(Trig_Cloak_UpdateStats_Cond_HasOnesDigit())then
                    call UnitRemoveAbilityBJ('A0Z7',Player_GetHero(GetEnumPlayer())) // 'A0Z7': ability "Cloak"
                    call UnitRemoveAbilityBJ('A15T',Player_GetHero(GetEnumPlayer())) // 'A15T': ability "Cloak"
                endif
            endif
        endif
    endif
endfunction

function Trig_Cloak_UpdateStats_Cond_NoCloakFound takes nothing returns boolean
    return(udg_TempBoolean==false)
endfunction

function Trig_Cloak_UpdateStats_Actions takes nothing returns nothing
    set udg_TempBoolean=false
    call ForForce(udg_PlayingPlayers,function Trig_Cloak_UpdateStats_UpdateCloakDigits)
    if(Trig_Cloak_UpdateStats_Cond_NoCloakFound())then
        call DisableTrigger(GetTriggeringTrigger())
        call EnableTrigger(gg_trg_Cloak_Equip)
    else
        call StartTimerBJ(udg_JobChangeTimer,false,2.)
    endif
endfunction

function Trig_Cloak_Drop_Cond_IsCloakDropped takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='I0HT')or(GetItemTypeId(GetManipulatedItem())=='I0IB')or(GetItemTypeId(GetManipulatedItem())=='I00D') // 'I0HT': item "Prominent Cloak"; 'I0IB': item "Hunter's Cloak"; 'I00D': item "Champion's Belt"
endfunction

function Trig_Cloak_Drop_Conditions takes nothing returns boolean
    return(Trig_Cloak_Drop_Cond_IsCloakDropped())and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))
endfunction

function Trig_Cloak_Drop_Actions takes nothing returns nothing
    call StartTimerBJ(udg_JobChangeTimer,false,.01)
endfunction

// World Editor calls InitTrig_Cloak automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Cloak (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Cloak takes nothing returns nothing
endfunction

function Register_Cloak_Equip takes nothing returns nothing
    set gg_trg_Cloak_Equip=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Cloak_Equip,EVENT_PLAYER_UNIT_PICKUP_ITEM)
    call TriggerAddCondition(gg_trg_Cloak_Equip,Condition(function Trig_Cloak_Equip_Conditions))
    call TriggerAddAction(gg_trg_Cloak_Equip,function Trig_Cloak_Equip_Actions)
endfunction

function Register_Cloak_UpdateStats takes nothing returns nothing
    set gg_trg_Cloak_UpdateStats=CreateTrigger()
    call DisableTrigger(gg_trg_Cloak_UpdateStats)
    call TriggerRegisterTimerExpireEventBJ(gg_trg_Cloak_UpdateStats,udg_JobChangeTimer)
    call TriggerAddAction(gg_trg_Cloak_UpdateStats,function Trig_Cloak_UpdateStats_Actions)
endfunction

function Register_Cloak_Drop takes nothing returns nothing
    set gg_trg_Cloak_Drop=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Cloak_Drop,EVENT_PLAYER_UNIT_DROP_ITEM)
    call TriggerAddCondition(gg_trg_Cloak_Drop,Condition(function Trig_Cloak_Drop_Conditions))
    call TriggerAddAction(gg_trg_Cloak_Drop,function Trig_Cloak_Drop_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Cloak takes nothing returns nothing
    call Register_Cloak_Equip()
    call Register_Cloak_UpdateStats()
    call Register_Cloak_Drop()
endfunction

endlibrary
