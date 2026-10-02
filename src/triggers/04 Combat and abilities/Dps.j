library TDps requires TPlayerPart01
function Trig_Dps_Start_Conditions takes nothing returns boolean
    return(udg_DpsActive==false)
endfunction

function Trig_Dps_Start_Actions takes nothing returns nothing
    set udg_DpsActive=true
    call StartTimerBJ(udg_DpsTimer,false,1.)
    call SaveIntegerBJ(0,0,0,udg_DpsHash)
    call SaveIntegerBJ(0,1,0,udg_DpsHash)
endfunction

function Trig_Dps_Tick_SlotHasDamage takes nothing returns boolean
    return(LoadRealBJ(LoadIntegerBJ(0,0,udg_DpsHash),GetConvertedPlayerId(GetEnumPlayer()),udg_DpsHash)>.0)
endfunction

function Trig_Dps_Tick_IsNinjaAward takes nothing returns boolean
    return(LoadIntegerBJ(2,0,udg_DpsHash)>=5)and(udg_TempReal>=99999.)and(GetUnitTypeId(Player_GetHero(GetEnumPlayer()))=='H00F')and(GetUnitAbilityLevelSwapped('A02F',Player_GetHero(GetEnumPlayer()))==3)and(IsPlayerInForce(GetEnumPlayer(),udg_JobMasterForce[8])==false) // 'H00F': unit "Ninja"; 'A02F': ability "Mastery"
endfunction

function Trig_Dps_Tick_AverageDpsEnum takes nothing returns nothing
    if(Trig_Dps_Tick_SlotHasDamage())then
        set udg_DpsActive=true
        set udg_DpsRefresh=true
    endif
    set udg_TempReal=.0
    set udg_TempInteger=0
    loop
        // (LoadIntegerBJ(2, 0, udg_DpsHash)) minus (1).
        exitwhen udg_TempInteger>(LoadIntegerBJ(2,0,udg_DpsHash)-1)
        // (udg_TempReal) plus (LoadRealBJ(udg_TempInteger, GetConvertedPlayerId(the player being visited),
        // udg_DpsHash)).
        set udg_TempReal=(udg_TempReal+LoadRealBJ(udg_TempInteger,GetConvertedPlayerId(GetEnumPlayer()),udg_DpsHash))
        set udg_TempInteger=udg_TempInteger+1
    endloop
    // (udg_TempReal) divided by (LoadIntegerBJ(2, 0, udg_DpsHash) treated as a decimal-capable number).
    set udg_TempReal=(udg_TempReal/ I2R(LoadIntegerBJ(2,0,udg_DpsHash)))
    if(Trig_Dps_Tick_IsNinjaAward())then
        call ForceAddPlayerSimple(GetEnumPlayer(),udg_JobMasterForce[8])
        call AddSpecialEffectTargetUnitBJ("origin",Player_GetHero(GetEnumPlayer()),"Abilities\\Spells\\Other\\Levelup\\LevelupCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
    endif
    call SaveRealBJ(udg_TempReal,LoadIntegerBJ(3,0,udg_DpsHash),GetConvertedPlayerId(GetEnumPlayer()),udg_DpsHash)
endfunction

function Trig_Dps_Tick_IdleBelowWindow takes nothing returns boolean
    return(LoadIntegerBJ(1,0,udg_DpsHash)<LoadIntegerBJ(3,0,udg_DpsHash))
endfunction

function Trig_Dps_Tick_MeterIdle takes nothing returns boolean
    return(udg_DpsActive==false)
endfunction

function Trig_Dps_Tick_SlotAtWindowEnd takes nothing returns boolean
    return(LoadIntegerBJ(0,0,udg_DpsHash)==LoadIntegerBJ(3,0,udg_DpsHash))
endfunction

function Trig_Dps_Tick_ClearSlotEnum takes nothing returns nothing
    call SaveRealBJ(.0,LoadIntegerBJ(0,0,udg_DpsHash),GetConvertedPlayerId(GetEnumPlayer()),udg_DpsHash)
endfunction

function Trig_Dps_Tick_SlotPastSamples takes nothing returns boolean
    return(LoadIntegerBJ(0,0,udg_DpsHash)>=LoadIntegerBJ(2,0,udg_DpsHash))
endfunction

function Trig_Dps_Tick_MeterActive takes nothing returns boolean
    return(udg_DpsActive)
endfunction

function Trig_Dps_Tick_Actions takes nothing returns nothing
    set udg_DpsActive=false
    set udg_DpsRefresh=false
    call ForForce(udg_PlayingPlayers,function Trig_Dps_Tick_AverageDpsEnum)
    if(Trig_Dps_Tick_MeterIdle())then
        // (LoadIntegerBJ(1, 0, udg_DpsHash)) plus (1).
        call SaveIntegerBJ((LoadIntegerBJ(1,0,udg_DpsHash)+1),1,0,udg_DpsHash)
        if(Trig_Dps_Tick_IdleBelowWindow())then
            set udg_DpsActive=true
        endif
    else
        call SaveIntegerBJ(0,1,0,udg_DpsHash)
    endif
    if(Trig_Dps_Tick_MeterActive())then
        call StartTimerBJ(udg_DpsTimer,false,1.)
        // (LoadIntegerBJ(0, 0, udg_DpsHash)) plus (1).
        call SaveIntegerBJ((LoadIntegerBJ(0,0,udg_DpsHash)+1),0,0,udg_DpsHash)
        if(Trig_Dps_Tick_SlotAtWindowEnd())then
            call SaveIntegerBJ(0,0,0,udg_DpsHash)
        endif
        call ForForce(udg_PlayingPlayers,function Trig_Dps_Tick_ClearSlotEnum)
        if(Trig_Dps_Tick_SlotPastSamples())then
            // (LoadIntegerBJ(0, 0, udg_DpsHash)) plus (1).
            call SaveIntegerBJ((LoadIntegerBJ(0,0,udg_DpsHash)+1),2,0,udg_DpsHash)
        endif
    else
        call SaveIntegerBJ(0,0,0,udg_DpsHash)
        call SaveIntegerBJ(1,2,0,udg_DpsHash)
        set udg_DpsRefresh=true
    endif
    call TriggerExecute(gg_trg_Multiboard_Refresh)
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Dps takes nothing returns nothing
endfunction
function RegisterR11_Dps_Start takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Dps_Start=CreateTrigger()
    call TriggerAddCondition(gg_trg_Dps_Start,Condition(function Trig_Dps_Start_Conditions))
    call TriggerAddAction(gg_trg_Dps_Start,function Trig_Dps_Start_Actions)
endfunction
function RegisterR11_Dps_Tick takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Dps_Tick=CreateTrigger()
    call TriggerRegisterTimerExpireEventBJ(gg_trg_Dps_Tick,udg_DpsTimer)
    call TriggerAddAction(gg_trg_Dps_Tick,function Trig_Dps_Tick_Actions)
endfunction




endlibrary
