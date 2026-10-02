library TWeather
function Trig_Weather_Snow_Init_Actions takes nothing returns nothing
    set udg_SnowEffect[0]=AddWeatherEffectSaveLast(gg_rct_592,'SNhs') // 'SNhs': object name not found in map data
    set udg_SnowEffect[1]=AddWeatherEffectSaveLast(gg_rct_593,'SNhs') // 'SNhs': object name not found in map data
    set udg_SnowEffect[2]=AddWeatherEffectSaveLast(gg_rct_594,'SNhs') // 'SNhs': object name not found in map data
    set udg_SnowEffect[3]=AddWeatherEffectSaveLast(gg_rct_595,'SNhs') // 'SNhs': object name not found in map data
    set udg_SnowEffect[4]=AddWeatherEffectSaveLast(gg_rct_596,'SNhs') // 'SNhs': object name not found in map data
    set udg_SnowEffect[5]=AddWeatherEffectSaveLast(gg_rct_597,'SNhs') // 'SNhs': object name not found in map data
    set bj_forLoopAIndex=0
    set bj_forLoopAIndexEnd=5
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        call EnableWeatherEffect(udg_SnowEffect[GetForLoopIndexA()],true)
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
endfunction

// World Editor calls InitTrig_Weather automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Weather (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Weather takes nothing returns nothing
endfunction

function Register_Weather_Snow_Init takes nothing returns nothing
    set gg_trg_Weather_Snow_Init=CreateTrigger()
    call TriggerRegisterTimerEventSingle(gg_trg_Weather_Snow_Init,5)
    call TriggerAddAction(gg_trg_Weather_Snow_Init,function Trig_Weather_Snow_Init_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Weather takes nothing returns nothing
    call Register_Weather_Snow_Init()
endfunction

endlibrary
