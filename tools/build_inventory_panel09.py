"""Match the native inventory spacing and preview the Shrine's Ninja icon."""
from pathlib import Path
import sys

import build_inventory_panel06 as panel
from jtok import functions, tokens
from performance_runtime import put

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "release/development/InventoryPanel09/FFERPG-Independent-Backpack-09.w3x"
NINJA_ICON = r"ReplaceableTextures\CommandButtons\BTNFFT_Ninja_Male.blp"


def source_for(source):
    original = functions(source)
    init = original["Bag04_Init"].replace("Bag04Bag,.2075,.17625", "Bag04Bag,.2075,.175")
    init = init.replace(".017,.004)", ".017,.001)").replace(".122,.122)", ".096,.096)")
    init = init.replace(r"ReplaceableTextures\\CommandButtons\\BTNFootman.blp", NINJA_ICON.replace(chr(92), chr(92)*2))
    init = init.replace('"Inventory Tester"', '"Ninja"')
    source = put(source, "Bag04_Init", init)

    # The gold line is about .0055 inside the frame. Allow .0015
    # between that line and the slots, matching the gaps in the grid.
    slots = original["Bag05_InitSlots"]
    for old, new in (
        ("set x=.016", "set x=.007"),
        ("set y=-.022-I2R(i)*.03125", "set y=-.007-I2R(i)*.0325"),
        ("set x=.16275", "set x=.1695"),
        ("set x=.07425", "set x=.071"),
        ("set x=.1055", "set x=.1035"),
        ("set y=-.19480", "set y=-.2028"),
        ("set y=-.16355", "set y=-.1703"),
        ("set x=.015+I2R(column)*.030", "set x=.007+I2R(column)*.0325"),
        ("set y=-.015-I2R(row)*.02975", "set y=-.007-I2R(row)*.0325"),
        ("Bag04Button[i],.0285,.0285", "Bag04Button[i],.031,.031"),
    ):
        assert old in slots, old
        slots = slots.replace(old, new)
    source = put(source, "Bag05_InitSlots", slots.replace("        call BlzFrameSetTooltip(Bag04Button[i],tip)\n", ""))

    capture = original["Bag04_Capture"].replace('"Empty slot"', '""')
    source = put(source, "Bag04_Capture", capture)
    draw = original["Bag04_Draw"].replace("Level 99 Inventory Tester", "Level 99 Ninja")
    draw = draw.replace("        call BlzFrameSetText(Bag04Count", """        call BlzFrameSetVisible(Bag08TooltipFrame[i],Bag04Open and Bag04Hover==i and Bag04ItemId[key]!=0)
        call BlzFrameSetText(Bag04Count""")
    source = put(source, "Bag04_Draw", draw)

    hover = original["Bag04_Hover"]
    start = hover.index("    if BlzGetTriggerFrameEvent()")
    hover = hover[:start] + """    loop
        exitwhen i>=45
        if BlzGetTriggerFrame()==Bag04Button[i] then
            if BlzGetTriggerFrameEvent()==FRAMEEVENT_MOUSE_LEAVE then
                call BlzFrameSetVisible(Bag08TooltipFrame[i],false)
                if Bag04Hover==i then
                    set Bag04Hover=-1
                endif
            elseif Bag04Open then
                if Bag04Hover>=0 and Bag04Hover!=i then
                    call BlzFrameSetVisible(Bag08TooltipFrame[Bag04Hover],false)
                endif
                set Bag04Hover=i
                call BlzFrameSetVisible(Bag08TooltipFrame[i],Bag04ItemId[GetPlayerId(GetTriggerPlayer())*45+i]!=0)
            endif
            return
        endif
        set i=i+1
    endloop
endfunction"""
    source = put(source, "Bag04_Hover", hover)
    source = source.replace("Backpack08:", "Backpack09:").replace("Bag08 slots=", "Bag09 slots=").replace("Bag08 setup", "Bag09 setup").replace("Bag08 open=", "Bag09 open=")
    updated = functions(source)
    assert {name for name in original if tokens(original[name]) != tokens(updated[name])} == {
        "Bag04_Init", "Bag05_InitSlots", "Bag04_Capture", "Bag04_Draw", "Bag04_Hover",
        "InvCheck_Chat", "InvCheck_Help", "main_old",
    }
    return source


if __name__ == "__main__":
    panel.OUT = OUT
    panel.NAME = "FFERPG Backpack09"
    panel.source_for = source_for
    panel.build(Path(sys.argv[1]))
