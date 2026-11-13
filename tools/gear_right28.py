"""Restore the original right-of-spells geometry with a different UI layer."""
from jtok import functions
from performance_runtime import put

LAYOUT='''function QuickGear_Layout takes nothing returns nothing
    // Restore the original F/G stack beside the second spell-command row.
    call BlzFrameClearAllPoints(QuickGearRoot)
    call BlzFrameSetPoint(QuickGearRoot,FRAMEPOINT_TOPLEFT,QuickGearAnchor,FRAMEPOINT_TOPRIGHT,.012,0.)
endfunction'''

def refresh(source):
    fs=functions(source);body=fs['QuickGear_Init']
    before='BlzCreateFrameByType("FRAME","GearDock25",origin,"",900)'
    after='BlzCreateFrameByType("FRAME","GearDock25",BlzFrameGetParent(BlzGetOriginFrame(ORIGIN_FRAME_PORTRAIT,0)),"",900)'
    assert body.count(before)==1
    body=body.replace(before,after,1)
    body=body.replace('    // All regular gear frames remain under GAME_UI, within its central\n    // band and clear of the native console. No console-backdrop dependency.\n',
      '    // The native portrait UI layer supports regular frames outside the\n    // central band, without the console-backdrop layer below console art.\n    // Resolve its existing parent only during shared frame initialization.\n',1)
    source=put(source,'QuickGear_Init',body)
    return put(source,'QuickGear_Layout',LAYOUT)
