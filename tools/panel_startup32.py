"""Keep independent UI setup workloads out of one combined JASS call budget."""
from jtok import functions
from performance_runtime import put

def refresh(source):
    f=functions(source)
    b=f['Register_Forsaken_PanelAccess']
    for name in ['Forsaken_RegisterBackpackActivity','QuickGear_Init']:
        old='    call '+name+'()'
        assert b.count(old)==1
        b=b.replace(old,'    call ExecuteFunc("'+name+'")',1)
    source=put(source,'Register_Forsaken_PanelAccess',b)
    # The preceding chat-registration loop leaves i==8. The debug event loop
    # otherwise registers no players and cannot report a failed initialization.
    b=f['Forsaken_RegisterBackpackActivity']
    old='        set ForsakenBackpackDebugEvents=CreateTrigger()\n        loop'
    assert old in b
    b=b.replace(old,'        set ForsakenBackpackDebugEvents=CreateTrigger()\n        set i=0\n        loop',1)
    source=put(source,'Forsaken_RegisterBackpackActivity',b)
    b=f['QuickGear_Diagnostic']
    marker='    set hero=null'
    assert marker in b
    # Read existing handles only, on the existing explicit diagnostic command.
    lines='''    if GetLocalPlayer()==viewer then
        call DisplayTimedTextToPlayer(viewer,0.,0.,30.,"Panel setup: talent="+I2S(GetHandleId(ForsakenTalentRoot))+" toggle="+I2S(GetHandleId(ForsakenTalentToggle))+" close="+I2S(GetHandleId(ForsakenBackpackClose))+" move="+I2S(GetHandleId(CarryUIButton)))
        call DisplayTimedTextToPlayer(viewer,0.,0.,30.,"Panel cache gear/border/bag="+I2S(ForsakenNativeFrameCount[0])+"/"+I2S(ForsakenNativeFrameCount[1])+"/"+I2S(ForsakenNativeFrameCount[2])+" open="+Forsaken_BackpackFlag(ForsakenBackpackWasVisible))
    endif
'''
    lines=lines.replace('viewer','owner')
    assert 'local player owner' in b
    b=b.replace(marker,lines+marker,1)
    return put(source,'QuickGear_Diagnostic',b)
