library TWait
function Wait_Polled takes real duration returns nothing
    local real l_remaining
    local real st=TimerGetElapsed(udg_PolledWaitTimer)
    if st<=0 then
        set udg_PolledWaitTimer=CreateTimer()
        call TimerStart(udg_PolledWaitTimer,$F4240,false,null) // $F4240 = 1000000
    endif
    if(duration>0)then
        loop
            // ((duration) minus (elapsed seconds of udg_PolledWaitTimer)) plus (st).
            set l_remaining=duration-TimerGetElapsed(udg_PolledWaitTimer)+st
            exitwhen l_remaining<=0
            if(l_remaining>bj_POLLED_WAIT_SKIP_THRESHOLD)then
                // (0.1) times (l_remaining).
                call TriggerSleepAction(.1*l_remaining)
            else
                call TriggerSleepAction(bj_POLLED_WAIT_INTERVAL)
            endif
        endloop
    endif
endfunction

function InitTrig_Wait takes nothing returns nothing
endfunction

endlibrary
