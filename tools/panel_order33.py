"""Run the isolated native-panel observer before gear presentation helpers."""
from jtok import functions
from performance_runtime import put

def refresh(source):
    f=functions(source)
    b=f['UI72_Tick']
    call='    call ExecuteFunc("Forsaken_PollPanels")\n'
    assert b.count(call)==1
    b=b.replace(call,'',1)
    marker='    call GearChat_Poll63()'
    assert b.count(marker)==1
    b=b.replace(marker,call+marker,1)
    source=put(source,'UI72_Tick',b)
    b=f['QuickGear_Diagnostic']
    marker='    set hero=null'
    assert b.count(marker)==1
    lines='''    if GetLocalPlayer()==owner then
        call DisplayTimedTextToPlayer(owner,0.,0.,30.,"Panel live: gear="+Forsaken_BackpackFlag(Forsaken_SelectCachedFrame(0,null)!=null)+" border="+Forsaken_BackpackFlag(Forsaken_SelectCachedFrame(1,null)!=null)+" bag="+Forsaken_BackpackFlag(Forsaken_SelectCachedFrame(2,null)!=null)+" context="+Forsaken_BackpackFlag(Forsaken_InventoryContext(hero,owner)))
        call DisplayTimedTextToPlayer(owner,0.,0.,30.,"Panel gates: cinematic="+Forsaken_BackpackFlag(udg_InCinematicMode or InventoryCinematicActive)+" inspect="+Forsaken_BackpackFlag(ForsakenInspectTarget!=null)+" wanted="+Forsaken_BackpackFlag(ForsakenBackpackWanted))
    endif
'''
    b=b.replace(marker,lines+marker,1)
    return put(source,'QuickGear_Diagnostic',b)
