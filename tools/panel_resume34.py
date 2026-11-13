"""Rearm the existing UI heartbeat after the cinematic gate has cleared."""
from jtok import functions
from performance_runtime import put

def refresh(source):
    f=functions(source)
    b=f['C20_UIPause']
    old='set C20UITimerActive=QuickGearUITimer!=null and TimerGetRemaining(QuickGearUITimer)>0.'
    assert b.count(old)==1
    b=b.replace(old,'set C20UITimerActive=QuickGearUITimer!=null',1)
    source=put(source,'C20_UIPause',b)
    b=f['C20_UIResume']
    old='''    if C20UITimerActive then
        call ResumeTimer(QuickGearUITimer)
    endif
'''
    assert b.count(old)==1
    b=b.replace(old,'',1)
    marker='    set C20UIPaused=false\n'
    assert b.count(marker)==1
    b=b.replace(marker,marker+'''    // This is the existing repeating heartbeat, not a new timer. Rearm it
    // before optional frame restoration so a failed UI helper cannot strand it.
    if C20UITimerActive and QuickGearUITimer!=null then
        call TimerStart(QuickGearUITimer,.1,true,function UI72_Tick)
    endif
''',1)
    source=put(source,'C20_UIResume',b)
    b=f['QuickGear_Diagnostic']
    marker='    set hero=null'
    assert b.count(marker)==1
    b=b.replace(marker,'''    if GetLocalPlayer()==owner then
        call DisplayTimedTextToPlayer(owner,0.,0.,30.,"Panel heartbeat: timer="+I2S(GetHandleId(QuickGearUITimer))+" remaining="+R2S(TimerGetRemaining(QuickGearUITimer))+" period="+R2S(TimerGetTimeout(QuickGearUITimer))+" paused="+Forsaken_BackpackFlag(C20UIPaused)+" resume="+Forsaken_BackpackFlag(C20UITimerActive))
    endif
'''+marker,1)
    return put(source,'QuickGear_Diagnostic',b)
