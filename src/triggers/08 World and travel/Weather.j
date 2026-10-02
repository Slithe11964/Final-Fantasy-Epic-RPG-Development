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

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Weather takes nothing returns nothing
endfunction
function RegisterR11_Weather_Snow_Init takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Weather_Snow_Init=CreateTrigger()
    call TriggerRegisterTimerEventSingle(gg_trg_Weather_Snow_Init,5)
    call TriggerAddAction(gg_trg_Weather_Snow_Init,function Trig_Weather_Snow_Init_Actions)
endfunction




endlibrary
