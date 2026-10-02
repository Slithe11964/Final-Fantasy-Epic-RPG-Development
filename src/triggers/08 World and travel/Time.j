library TTime
function Time_ElapsedString takes nothing returns string
    local string l_text
    // Starting value for l_elapsed:
    // (elapsed seconds of udg_GameClock) with its decimal part removed.
    local integer l_elapsed=R2I(TimerGetElapsed(udg_GameClock))
    local integer l_hours=udg_GameHours
    // Starting value for l_minutes:
    // (elapsed time) divided by (60); drop the remainder.
    local integer l_minutes=l_elapsed/ 60
    // Starting value for l_seconds:
    // The remainder after dividing (elapsed time) by (60).
    local integer l_seconds=ModuloInteger(l_elapsed,60)
    if(l_hours>=24)then
        if(l_hours>=48)then
            // (l_hours) divided by (24); drop the remainder.
            set l_text=I2S(l_hours/ 24)+" Days"
            // The remainder after dividing (l_hours) by (24).
            set l_hours=ModuloInteger(l_hours,24)
        else
            set l_text="1 Day"
            // Decrease l_hours by 24.
            set l_hours=l_hours-24
        endif
        set l_text=l_text+", "+I2S(l_hours)
    else
        set l_text=I2S(l_hours)
    endif
    if(l_minutes<$A)then // $A = 10
        set l_text=l_text+":0"+I2S(l_minutes)
    else
        set l_text=l_text+":"+I2S(l_minutes)
    endif
    if(l_seconds<$A)then // $A = 10
        set l_text=l_text+":0"+I2S(l_seconds)
    else
        set l_text=l_text+":"+I2S(l_seconds)
    endif
    return l_text
endfunction

function InitTrig_Time takes nothing returns nothing
endfunction

endlibrary
