"""Put the requested frame readout at the visible end of -gearcheck."""
from jtok import functions
from performance_runtime import put

def refresh(source):
    body=functions(source)['QuickGear_Diagnostic']
    body=body.replace('    local integer slot\n','    local integer slot\n    local string parents=""\n',1)
    start=body.index('        call DisplayTimedTextToPlayer(owner,0.,0.,60.,"Gear UI:')
    end=body.index('        set slot=0',start)+len('        set slot=0\n')
    body=body[:start]+body[end:]
    marker='    endif\n    set carried=null'
    assert body.count(marker)==1
    block='''        // Last output stays visible after the longer item diagnostic.
        set slot=0
        loop
            exitwhen slot>=GearView29Count
            if slot>0 then
                set parents=parents+" > "
            endif
            set parents=parents+GearView29Name[slot]+"="+QuickGear_Bool(BlzFrameIsVisible(GearView29Frame[slot]))
            set slot=slot+1
        endloop
        call DisplayTimedTextToPlayer(owner,0.,0.,120.,"Gear UI: wanted="+QuickGear_Bool(QuickGearShown)+" root="+QuickGear_Bool(BlzFrameIsVisible(QuickGearRoot))+" F/G="+QuickGear_Bool(QuickGearActive[0])+"/"+QuickGear_Bool(QuickGearActive[1])+" anchor="+QuickGear_Bool(BlzFrameIsVisible(QuickGearAnchor))+" size="+R2S(BlzFrameGetWidth(QuickGearRoot))+","+R2S(BlzFrameGetHeight(QuickGearRoot)))
        call DisplayTimedTextToPlayer(owner,0.,0.,120.,"UI parents: "+parents)
'''
    body=body.replace(marker,block+marker,1)
    assert 'BlzFrameGetParent' not in body and 'BlzGetFrameByName' not in body
    return put(source,'QuickGear_Diagnostic',body)
