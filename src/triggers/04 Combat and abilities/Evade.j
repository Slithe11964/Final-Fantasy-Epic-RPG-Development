library TEvade requires TPlayerPart01
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Evade_Counter_Cost=null
    trigger gg_trg_Evade_Counter_Decay=null
    trigger gg_trg_Evade_Counter_Reset_P1=null
    trigger gg_trg_Evade_Counter_Reset_P2=null
    trigger gg_trg_Evade_Counter_Reset_P3=null
    trigger gg_trg_Evade_Counter_Reset_P4=null
    trigger gg_trg_Evade_Counter_Reset_P5=null
    trigger gg_trg_Evade_Counter_Reset_P6=null
    trigger gg_trg_Evade_Counter_Reset_P7=null
    trigger gg_trg_Evade_Counter_Reset_P8=null
endglobals

function Trig_Evade_Counter_Cost_Conditions takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(GetSpellAbilityId()=='A0R3') // 'A0R3': ability "Evade & Counter"
endfunction

function Trig_Evade_Counter_Cost_Actions takes nothing returns nothing
    // (BlzGetUnitAbilityManaCost(the triggering unit, 'A0R3', udg_AbilityLevelIndex)) plus (5).
    call BlzSetUnitAbilityManaCost(GetTriggerUnit(),'A0R3',udg_AbilityLevelIndex,(BlzGetUnitAbilityManaCost(GetTriggerUnit(),'A0R3',udg_AbilityLevelIndex)+5)) // 'A0R3': ability "Evade & Counter"
    call StartTimerBJ(udg_DodgeFaceTimer[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],false,3.)
endfunction

function Trig_Evade_Counter_Decay_Conditions takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0R3',Player_GetHero(ConvertedPlayer(udg_TempInteger)))>0) // 'A0R3': ability "Evade & Counter"
endfunction

function Trig_Evade_Counter_Decay_CostAboveMin0 takes nothing returns boolean
    return(BlzGetUnitAbilityManaCost(Player_GetHero(ConvertedPlayer(udg_TempInteger)),'A0R3',0)>25) // 'A0R3': ability "Evade & Counter"
endfunction

function Trig_Evade_Counter_Decay_CostAboveMin1 takes nothing returns boolean
    return(BlzGetUnitAbilityManaCost(Player_GetHero(ConvertedPlayer(udg_TempInteger)),'A0R3',1)>25) // 'A0R3': ability "Evade & Counter"
endfunction

function Trig_Evade_Counter_Decay_UseLevelZero takes nothing returns boolean
    return(udg_AbilityLevelShift)
endfunction

function Trig_Evade_Counter_Decay_Actions takes nothing returns nothing
    // (udg_TempInteger) minus (1).
    set udg_DodgeStreak[(udg_TempInteger-1)]=0
    if(Trig_Evade_Counter_Decay_UseLevelZero())then
        if(Trig_Evade_Counter_Decay_CostAboveMin0())then
            call StartTimerBJ(udg_DodgeFaceTimer[udg_TempInteger],false,1.)
            // Calculation 1:
            // (1) minus (1).
            // Calculation 2:
            // (BlzGetUnitAbilityManaCost(Player_GetHero(ConvertedPlayer(udg_TempInteger)), 'A0R3', 0)) minus (20).
            call BlzSetUnitAbilityManaCost(Player_GetHero(ConvertedPlayer(udg_TempInteger)),'A0R3',(1-1),(BlzGetUnitAbilityManaCost(Player_GetHero(ConvertedPlayer(udg_TempInteger)),'A0R3',0)-20)) // 'A0R3': ability "Evade & Counter"
        else
            // (1) minus (1).
            call BlzSetUnitAbilityManaCost(Player_GetHero(ConvertedPlayer(udg_TempInteger)),'A0R3',(1-1),5) // 'A0R3': ability "Evade & Counter"
        endif
    else
        if(Trig_Evade_Counter_Decay_CostAboveMin1())then
            call StartTimerBJ(udg_DodgeFaceTimer[udg_TempInteger],false,1.)
            // (BlzGetUnitAbilityManaCost(Player_GetHero(ConvertedPlayer(udg_TempInteger)), 'A0R3', 1)) minus (20).
            call BlzSetUnitAbilityManaCost(Player_GetHero(ConvertedPlayer(udg_TempInteger)),'A0R3',1,(BlzGetUnitAbilityManaCost(Player_GetHero(ConvertedPlayer(udg_TempInteger)),'A0R3',1)-20)) // 'A0R3': ability "Evade & Counter"
        else
            call BlzSetUnitAbilityManaCost(Player_GetHero(ConvertedPlayer(udg_TempInteger)),'A0R3',1,5) // 'A0R3': ability "Evade & Counter"
        endif
    endif
endfunction

function Trig_Evade_Counter_Reset_P1_Actions takes nothing returns nothing
    set udg_TempInteger=1
    call ConditionalTriggerExecute(gg_trg_Evade_Counter_Decay)
endfunction

function Trig_Evade_Counter_Reset_P2_Actions takes nothing returns nothing
    set udg_TempInteger=2
    call ConditionalTriggerExecute(gg_trg_Evade_Counter_Decay)
endfunction

function Trig_Evade_Counter_Reset_P3_Actions takes nothing returns nothing
    set udg_TempInteger=3
    call ConditionalTriggerExecute(gg_trg_Evade_Counter_Decay)
endfunction

function Trig_Evade_Counter_Reset_P4_Actions takes nothing returns nothing
    set udg_TempInteger=4
    call ConditionalTriggerExecute(gg_trg_Evade_Counter_Decay)
endfunction

function Trig_Evade_Counter_Reset_P5_Actions takes nothing returns nothing
    set udg_TempInteger=5
    call ConditionalTriggerExecute(gg_trg_Evade_Counter_Decay)
endfunction

function Trig_Evade_Counter_Reset_P6_Actions takes nothing returns nothing
    set udg_TempInteger=6
    call ConditionalTriggerExecute(gg_trg_Evade_Counter_Decay)
endfunction

function Trig_Evade_Counter_Reset_P7_Actions takes nothing returns nothing
    set udg_TempInteger=7
    call ConditionalTriggerExecute(gg_trg_Evade_Counter_Decay)
endfunction

function Trig_Evade_Counter_Reset_P8_Actions takes nothing returns nothing
    set udg_TempInteger=8
    call ConditionalTriggerExecute(gg_trg_Evade_Counter_Decay)
endfunction

// World Editor calls InitTrig_Evade automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Evade (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Evade takes nothing returns nothing
endfunction

function Register_Evade_Counter_Cost takes nothing returns nothing
    set gg_trg_Evade_Counter_Cost=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Evade_Counter_Cost,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Evade_Counter_Cost,Condition(function Trig_Evade_Counter_Cost_Conditions))
    call TriggerAddAction(gg_trg_Evade_Counter_Cost,function Trig_Evade_Counter_Cost_Actions)
endfunction

function Register_Evade_Counter_Decay takes nothing returns nothing
    set gg_trg_Evade_Counter_Decay=CreateTrigger()
    call TriggerAddCondition(gg_trg_Evade_Counter_Decay,Condition(function Trig_Evade_Counter_Decay_Conditions))
    call TriggerAddAction(gg_trg_Evade_Counter_Decay,function Trig_Evade_Counter_Decay_Actions)
endfunction

function Register_Evade_Counter_Reset_P1 takes nothing returns nothing
    set gg_trg_Evade_Counter_Reset_P1=CreateTrigger()
    call TriggerRegisterTimerExpireEventBJ(gg_trg_Evade_Counter_Reset_P1,udg_DodgeFaceTimer[1])
    call TriggerAddAction(gg_trg_Evade_Counter_Reset_P1,function Trig_Evade_Counter_Reset_P1_Actions)
endfunction

function Register_Evade_Counter_Reset_P2 takes nothing returns nothing
    set gg_trg_Evade_Counter_Reset_P2=CreateTrigger()
    call TriggerRegisterTimerExpireEventBJ(gg_trg_Evade_Counter_Reset_P2,udg_DodgeFaceTimer[2])
    call TriggerAddAction(gg_trg_Evade_Counter_Reset_P2,function Trig_Evade_Counter_Reset_P2_Actions)
endfunction

function Register_Evade_Counter_Reset_P3 takes nothing returns nothing
    set gg_trg_Evade_Counter_Reset_P3=CreateTrigger()
    call TriggerRegisterTimerExpireEventBJ(gg_trg_Evade_Counter_Reset_P3,udg_DodgeFaceTimer[3])
    call TriggerAddAction(gg_trg_Evade_Counter_Reset_P3,function Trig_Evade_Counter_Reset_P3_Actions)
endfunction

function Register_Evade_Counter_Reset_P4 takes nothing returns nothing
    set gg_trg_Evade_Counter_Reset_P4=CreateTrigger()
    call TriggerRegisterTimerExpireEventBJ(gg_trg_Evade_Counter_Reset_P4,udg_DodgeFaceTimer[4])
    call TriggerAddAction(gg_trg_Evade_Counter_Reset_P4,function Trig_Evade_Counter_Reset_P4_Actions)
endfunction

function Register_Evade_Counter_Reset_P5 takes nothing returns nothing
    set gg_trg_Evade_Counter_Reset_P5=CreateTrigger()
    call TriggerRegisterTimerExpireEventBJ(gg_trg_Evade_Counter_Reset_P5,udg_DodgeFaceTimer[5])
    call TriggerAddAction(gg_trg_Evade_Counter_Reset_P5,function Trig_Evade_Counter_Reset_P5_Actions)
endfunction

function Register_Evade_Counter_Reset_P6 takes nothing returns nothing
    set gg_trg_Evade_Counter_Reset_P6=CreateTrigger()
    call TriggerRegisterTimerExpireEventBJ(gg_trg_Evade_Counter_Reset_P6,udg_DodgeFaceTimer[6])
    call TriggerAddAction(gg_trg_Evade_Counter_Reset_P6,function Trig_Evade_Counter_Reset_P6_Actions)
endfunction

function Register_Evade_Counter_Reset_P7 takes nothing returns nothing
    set gg_trg_Evade_Counter_Reset_P7=CreateTrigger()
    call TriggerRegisterTimerExpireEventBJ(gg_trg_Evade_Counter_Reset_P7,udg_DodgeFaceTimer[7])
    call TriggerAddAction(gg_trg_Evade_Counter_Reset_P7,function Trig_Evade_Counter_Reset_P7_Actions)
endfunction

function Register_Evade_Counter_Reset_P8 takes nothing returns nothing
    set gg_trg_Evade_Counter_Reset_P8=CreateTrigger()
    call TriggerRegisterTimerExpireEventBJ(gg_trg_Evade_Counter_Reset_P8,udg_DodgeFaceTimer[8])
    call TriggerAddAction(gg_trg_Evade_Counter_Reset_P8,function Trig_Evade_Counter_Reset_P8_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Evade takes nothing returns nothing
    call Register_Evade_Counter_Cost()
    call Register_Evade_Counter_Decay() // run by Evade
    call Register_Evade_Counter_Reset_P1()
    call Register_Evade_Counter_Reset_P2()
    call Register_Evade_Counter_Reset_P3()
    call Register_Evade_Counter_Reset_P4()
    call Register_Evade_Counter_Reset_P5()
    call Register_Evade_Counter_Reset_P6()
    call Register_Evade_Counter_Reset_P7()
    call Register_Evade_Counter_Reset_P8()
endfunction

endlibrary
