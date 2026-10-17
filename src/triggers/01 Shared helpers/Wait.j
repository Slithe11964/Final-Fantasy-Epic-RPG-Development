library TWait
globals
    // Variables only this module uses.
    timer udg_PolledWaitTimer=null
    hashtable SupportBuffStamp=InitHashtable()
    timer SupportBuffClock=null
endglobals

function Wait_Polled takes real duration returns nothing
    local real l_remaining
    local real st=TimerGetElapsed(udg_PolledWaitTimer)
    if st<=0 then
        set udg_PolledWaitTimer=CreateTimer()
        call TimerStart(udg_PolledWaitTimer,$F4240,false,null) // $F4240 = 1000000
    endif
    if(duration>0)then
        loop
            set l_remaining=duration-TimerGetElapsed(udg_PolledWaitTimer)+st
            exitwhen l_remaining<=0
            if(l_remaining>bj_POLLED_WAIT_SKIP_THRESHOLD)then
                call TriggerSleepAction(.1*l_remaining)
            else
                call TriggerSleepAction(bj_POLLED_WAIT_INTERVAL)
            endif
        endloop
    endif
endfunction

function SupportBuff_Now takes nothing returns real
    if SupportBuffClock==null then
        set SupportBuffClock=CreateTimer()
        call TimerStart(SupportBuffClock,1000000.,false,null)
    endif
    return TimerGetElapsed(SupportBuffClock)
endfunction


function SupportBuff_Refresh takes unit target returns nothing
    call SaveReal(SupportBuffStamp,GetHandleId(target),0,SupportBuff_Now())
endfunction


function SupportBuff_Wait takes unit target,real duration returns nothing
    local real started=SupportBuff_Now()
    local real ending=started+duration
    local real refreshed
    loop
        call Wait_Polled(ending-SupportBuff_Now())
        set refreshed=LoadReal(SupportBuffStamp,GetHandleId(target),0)
        if refreshed>=started and refreshed+duration>ending then
            set ending=refreshed+duration
        endif
        exitwhen ending<=SupportBuff_Now()
    endloop
endfunction

function InitTrig_Wait takes nothing returns nothing
endfunction

endlibrary
