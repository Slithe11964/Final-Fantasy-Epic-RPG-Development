"""Bounded, on-demand display diagnostics; do not alter the gear renderer."""
from jtok import functions
from performance_runtime import put
GLOBALS='''    framehandle array GearView29Frame
    string array GearView29Name
    integer GearView29Count=0
'''

def refresh(source):
    fs=functions(source);source=source.replace('endglobals',GLOBALS+'endglobals',1)
    body=fs['QuickGear_Init'].replace('    local integer modifier','    local framehandle displayParent=null\n    local integer modifier',1)
    marker='    set QuickGearAnchor=BlzGetOriginFrame(ORIGIN_FRAME_COMMAND_BUTTON,7)'
    assert body.count(marker)==1
    body=body.replace(marker,marker+'''
    // Resolve existing ancestors on all clients during startup. The local
    // readout never looks up frames or allocates handles while testing.
    set displayParent=QuickGearRoot
    set GearView29Count=0
    loop
        exitwhen displayParent==null or GearView29Count>=8
        set GearView29Frame[GearView29Count]=displayParent
        set GearView29Name[GearView29Count]=BlzFrameGetName(displayParent)
        set GearView29Count=GearView29Count+1
        set displayParent=BlzFrameGetParent(displayParent)
    endloop
    set displayParent=null''',1)
    source=put(source,'QuickGear_Init',body)
    body=fs['QuickGear_Diagnostic'];marker='    if GetLocalPlayer()==owner then'
    assert body.count(marker)==1
    body=body.replace(marker,marker+'''
        call DisplayTimedTextToPlayer(owner,0.,0.,60.,"Gear UI: wanted="+QuickGear_Bool(QuickGearShown)+" root="+QuickGear_Bool(BlzFrameIsVisible(QuickGearRoot))+" active F/G="+QuickGear_Bool(QuickGearActive[0])+"/"+QuickGear_Bool(QuickGearActive[1])+" anchor="+QuickGear_Bool(BlzFrameIsVisible(QuickGearAnchor)))
        loop
            exitwhen slot>=GearView29Count
            call DisplayTimedTextToPlayer(owner,0.,0.,60.,"UI parent "+I2S(slot)+" "+GearView29Name[slot]+" visible="+QuickGear_Bool(BlzFrameIsVisible(GearView29Frame[slot]))+" size="+R2S(BlzFrameGetWidth(GearView29Frame[slot]))+","+R2S(BlzFrameGetHeight(GearView29Frame[slot])))
            set slot=slot+1
        endloop
        set slot=0''',1)
    source=put(source,'QuickGear_Diagnostic',body)
    body=fs['QuickGear_Reset'].replace('    call GearInput_Reset()','    set GearView29Count=0\n    call GearInput_Reset()',1)
    assert body!=fs['QuickGear_Reset']
    return put(source,'QuickGear_Reset',body)
