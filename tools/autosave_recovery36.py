"""Recover stalled autosave ownership on the existing shared scheduler."""
from jtok import functions
from performance_runtime import put

def refresh(source):
    fs=functions(source)
    if 'FRC_Timeout' in fs:
        body=fs['FRC_Timeout']
        marker='    if FRC_WriterOwned[pid] then\n'
        assert marker in body
        body=body.replace(marker,marker+'''        // A terminated validation can leave the decoder busy. This expired
        // capture owns the writer and must release that flag before Abort.
        set FSC_Busy[pid]=false
''',1)
        return put(source,'FRC_Timeout',body)
    if 'C20_ProfilePause' not in fs:
        return source
    pause=fs['C20_ProfilePause'].replace('FFL_Poll!=null and TimerGetRemaining(FFL_Poll)>0.','FFL_Poll!=null')
    assert pause!=fs['C20_ProfilePause']
    source=put(source,'C20_ProfilePause',pause)
    resume=fs['C20_ProfileResume']
    resume=resume.replace('    local real elapsed=', '    local real remaining\n    local real elapsed=',1)
    old='''    if C20PollPaused then
        call ResumeTimer(FFL_Poll)
    endif
'''
    assert old in resume
    resume=resume.replace(old,'',1)
    resume=resume.replace('    set C20ProfilePaused=false\n','''    set C20ProfilePaused=false
    if C20PollPaused and FFL_Poll!=null then
        call ExecuteFunc("C36_ResumeProfilePoll")
    endif
''',1)
    old='''            call ResumeTimer(FRC_Timer[pid])
            call ResumeTimer(FRC_Watchdog[pid])'''
    assert old in resume
    resume=resume.replace(old,'''            set remaining=TimerGetRemaining(FRC_Watchdog[pid])
            if C20SoftAutosave[pid] then
                call TimerStart(FRC_Timer[pid],.1,true,function FRC_Tick)
            else
                call TimerStart(FRC_Timer[pid],.02,true,function FRC_Tick)
            endif
            call TimerStart(FRC_Watchdog[pid],remaining,false,function FRC_Timeout)''',1)
    source=put(source,'C20_ProfileResume',resume)
    begin=fs['C20_BeginAutosave'].replace('    set FFL_Phase[pid]=1','    set FFL_Started[pid]=TimerGetElapsed(FST_Clock)\n    set FFL_Phase[pid]=1',1)
    assert begin!=fs['C20_BeginAutosave']
    source=put(source,'C20_BeginAutosave',begin)
    scheduler=fs['Restore_AutosaveTick']
    marker='''    set pid=0
    loop
        exitwhen pid>=8
        if FFL_Phase[pid]!=0'''
    assert scheduler.count(marker)==1
    recovery='''    // The existing shared scheduler can finish a capture even if the
    // profile poll stopped. Never release a load/rollback transaction here.
    set pid=0
    loop
        exitwhen pid>=8
        if FFL_Phase[pid]==1 and FRC_Phase[pid]==0 then
            call ExecuteFunc("FFL_Tick")
            return
        elseif FFL_Phase[pid]==1 and C20SoftAutosave[pid] and now-FFL_Started[pid]>=60. then
            // Discard an incomplete capture, release its writer, and retry
            // later. The previous successfully written save remains on disk.
            set FRC_Ready[pid]=false
            set FSC_Busy[pid]=false
            call FSC_Abort(pid)
            set FRC_WriterOwned[pid]=false
            call FRC_Stop(pid,"autosave capture timed out; please save again")
            set FFL_Phase[pid]=0
            set C20SoftAutosave[pid]=false
            set RestoreAutoPending[pid]=not RestoreAutoOff[pid]
            set C20RetryAfter[pid]=now+30.
            call FFL_Message(pid,"Autosave was interrupted. Saving is available again.")
            return
        endif
        set pid=pid+1
    endloop
'''
    scheduler=scheduler.replace(marker,recovery+marker,1)
    old='''                    if C20_BeginAutosave(pid) then
                        set RestoreAutoPending[pid]=false
                    endif
                endif
                // At most one capture starts per shared heartbeat.
                return'''
    assert old in scheduler
    scheduler=scheduler.replace(old,'''                    if C20_BeginAutosave(pid) then
                        set RestoreAutoPending[pid]=false
                        // At most one capture starts per shared heartbeat.
                        return
                    endif
                endif
                // A failed start or retry backoff must not starve other players.''',1)
    source=put(source,'Restore_AutosaveTick',scheduler)
    # JASS requires the callback declaration before its code reference.
    tick=fs['FFL_Tick'].replace('    local integer pid\n','    local integer pid\n    local boolean autosave=false\n    local boolean written=false\n',1)
    marker='''            set FFL_Phase[pid]=0
            if C20SoftAutosave[pid] then'''
    assert marker in tick
    tick=tick.replace(marker,'''            set FFL_Phase[pid]=0
            set autosave=C20SoftAutosave[pid]
            set written=false
            if C20SoftAutosave[pid] then''',1)
    marker='                    if (not FST_Write(pid,FRC_Result[pid],FRC_Account(pid))) then'
    assert marker in tick
    tick=tick.replace(marker,'''                    set written=FST_Write(pid,FRC_Result[pid],FRC_Account(pid))
                    if not written then''',1)
    marker='        elseif ((FFL_Phase[pid] == 2) and (not FST_Pending[pid])) then'
    assert marker in tick
    tick=tick.replace(marker,'''            if autosave and not written then
                set RestoreAutoPending[pid]=not RestoreAutoOff[pid]
                set C20RetryAfter[pid]=TimerGetElapsed(FST_Clock)+10.
            endif
'''+marker,1)
    source=put(source,'FFL_Tick',tick+'''

function C36_ResumeProfilePoll takes nothing returns nothing
    call TimerStart(FFL_Poll,.05,true,function FFL_Tick)
endfunction
''')
    return source
