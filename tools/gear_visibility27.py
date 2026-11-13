"""Keep regular gear controls clear of the console and its cinematic owner."""
from jtok import functions
from performance_runtime import put

LAYOUT='''function QuickGear_Layout takes nothing returns nothing
    // The complete 40x86-unit dock stays inside the central 4:3 frame band
    // and above the console's top edge, independent of native command anchors.
    call BlzFrameClearAllPoints(QuickGearRoot)
    call BlzFrameSetAbsPoint(QuickGearRoot,FRAMEPOINT_TOPLEFT,.748,.265)
endfunction'''

def refresh(source):
    fs=functions(source)
    body=fs['QuickGear_Init']
    old='BlzCreateFrameByType("FRAME","GearDock25",BlzGetFrameByName("ConsoleUIBackdrop",0),"",900)'
    new='BlzCreateFrameByType("FRAME","GearDock25",origin,"",900)'
    assert body.count(old)==1
    body=body.replace(old,new,1)
    body=body.replace('    // Regular frames under GAME_UI are clipped to the central 4:3 band.\n    // This native regular backdrop supports the side area beside commands.\n    // Resolve it during shared initialization, never in a local input/poll.\n',
       '    // All regular gear frames remain under GAME_UI, within its central\n    // band and clear of the native console. No console-backdrop dependency.\n',1)
    source=put(source,'QuickGear_Init',body)
    source=put(source,'QuickGear_Layout',LAYOUT)
    body=fs['C20_UIResume'];anchor='    set QuickGearReady=false'
    assert body.count(anchor)==1
    body=body.replace(anchor,'''    if QuickGearRoot!=null then
        call QuickGear_Layout()
    endif
'''+anchor,1)
    return put(source,'C20_UIResume',body)
