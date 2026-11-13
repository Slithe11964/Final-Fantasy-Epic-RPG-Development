"""Allow the Recovery14 regular-frame dock to draw outside the 4:3 band."""
from jtok import functions
from performance_runtime import put

def refresh(source):
    body=functions(source)['QuickGear_Init']
    before='    set QuickGearRoot=BlzCreateFrameByType("FRAME","GearDock25",origin,"",900)'
    after='''    // Regular frames under GAME_UI are clipped to the central 4:3 band.
    // This native regular backdrop supports the side area beside commands.
    // Resolve it during shared initialization, never in a local input/poll.
    set QuickGearRoot=BlzCreateFrameByType("FRAME","GearDock25",BlzGetFrameByName("ConsoleUIBackdrop",0),"",900)'''
    assert body.count(before)==1
    return put(source,'QuickGear_Init',body.replace(before,after,1))
