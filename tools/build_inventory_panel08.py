"""Refine the independent backpack layout and tooltips using Warcraft UI art."""
from pathlib import Path
import re
import sys

import build_inventory_panel06 as panel
from jtok import functions
from performance_runtime import put
from priest_ultimate import declarations

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "release/development/InventoryPanel08/FFERPG-Independent-Backpack-08.w3x"
TOC = "BagUI\\BagTooltip08.toc"
FDF = "BagUI\\BagTooltip08.fdf"
TOOLTIP = r'''
Frame "BACKDROP" "BagSlimBackdrop08" {
    DecorateFileNames,
    BackdropTileBackground,
    BackdropBackground "EscMenuBackground",
    BackdropCornerFlags "UL|UR|BL|BR|T|L|B|R",
    BackdropCornerSize 0.020,
    BackdropBackgroundInsets 0.0021 0.0021 0.0021 0.0021,
    BackdropEdgeFile "EscMenuBorder",
    BackdropBackgroundSize 0.256,
    BackdropBlendAll,
}

Frame "BACKDROP" "BagItemTooltip08" {
    BackdropTileBackground,
    BackdropBackground "UI\Widgets\Tooltips\Human\human-tooltip-background.blp",
    BackdropEdgeFile "UI\Widgets\Tooltips\Human\human-tooltip-border.blp",
    BackdropCornerFlags "UL|UR|BL|BR|T|L|B|R",
    BackdropCornerSize 0.010,
    BackdropBackgroundInsets 0.003 0.003 0.003 0.003,
    BackdropBackgroundSize 0.0625,
    BackdropBlendAll,
}
'''


def source_for(source):
    fs = functions(source)
    source = declarations(source, ["framehandle array Bag08TooltipFrame"])
    init = fs["Bag04_Init"]
    init = init.replace('    set Bag04Bag=BlzCreateFrame', f'    call BlzLoadTOCFile("{TOC.replace(chr(92), chr(92)*2)}")\n    set Bag04Bag=BlzCreateFrame', 1)
    for frame in ("Bag04Bag", "Bag04Gear"):
        original = f'    set {frame}=BlzCreateFrame("EscMenuBackdrop",Bag04Root,0,0)'
        slim = f'    set {frame}=BlzCreateFrame("BagSlimBackdrop08",Bag04Root,0,0)'
        assert original in init
        init = init.replace(original, slim + f"\n    if {frame}==null then\n    " + original + "\n    endif", 1)
    init = init.replace(".014,.007)", ".017,.004)").replace(".116,.116)", ".122,.122)")
    for old, new in (
        (".029,-.004,.150,.037,.010", ".030,-.016,.147,.035,.010"),
        ('"X",-.006,-.004,.023,.021', '"X",-.015,-.013,.020,.019'),
        ('"Talents",-.010,-.042,.065,.025', '"Talents",-.015,-.049,.063,.022'),
        ('"Move to hero",-.010,-.175,.096,.025', '"Move to hero",-.015,-.173,.090,.021'),
        ('"Drop held item",-.010,-.145,.096,.022', '"Drop held item",-.015,-.148,.090,.020'),
    ):
        assert old in init, old
        init = init.replace(old, new, 1)
    source = put(source, "Bag04_Init", init)
    slots = fs["Bag05_InitSlots"]
    for old, new in (
        ("set x=.012", "set x=.016"), ("set y=-.016-I2R(i)*.03125", "set y=-.022-I2R(i)*.03125"),
        ("set x=.16425", "set x=.16275"), ("set x=.0725", "set x=.07425"),
        ("set x=.10375", "set x=.1055"), ("set y=-.19805", "set y=-.19480"),
        ("set y=-.1668", "set y=-.16355"), ("set x=.010+I2R(column)*.03125", "set x=.015+I2R(column)*.030"),
        ("set y=-.010-I2R(row)*.03125", "set y=-.015-I2R(row)*.02975"),
        ("Bag04Button[i],.03125,.03125", "Bag04Button[i],.0285,.0285"),
    ):
        assert old in slots, old
        slots = slots.replace(old, new)
    slots = slots.replace('set tip=BlzCreateFrame("EscMenuBackdrop",Bag04Button[i],0,0)', '''set tip=BlzCreateFrame("BagItemTooltip08",Bag04Button[i],0,0)
        if tip==null then
            set tip=BlzCreateFrame("EscMenuBackdrop",Bag04Button[i],0,0)
        endif
        set Bag08TooltipFrame[i]=tip''',1)
    slots = slots.replace("FRAMEPOINT_BOTTOMLEFT,-.012,0.)","FRAMEPOINT_BOTTOMLEFT,-.014,.003)",1)
    slots = slots.replace("tip,.250,.240","tip,.272,.060",1)
    slots = slots.replace('"BagTip04",.014,-.014,.222,.212,.010', '"BagTip08",.011,-.010,.250,.045,.011',1)
    source = put(source, "Bag05_InitSlots", slots)
    capture = fs["Bag04_Capture"]
    capture = capture.replace("    local item it","    local item it\n    local string description",1)
    empty = ["Head", "Chest", "Hands", "Feet", "Finger", "Finger", "MainHand", "SecondaryHand", "Relic"]
    empty_lines = ["function Bag08_EmptyIcon takes integer slot returns string"]
    for index, kind in enumerate(empty):
        condition = "if" if index == 0 else "elseif"
        empty_lines.extend([f"    {condition} slot=={index} then",
                            rf'        return "UI\\Console\\Reforged\\UI-PaperDoll-Slot-{kind}.blp"'])
    empty_lines.extend(['    endif', r'    return "UI\\Widgets\\Console\\Human\\human-inventory-slotempty.blp"', 'endfunction'])
    old = r'            set Bag04IconPath[key]="UI\\Widgets\\Console\\Human\\human-inventory-slotfiller.blp"'
    assert old in capture
    capture = capture.replace(old, "            set Bag04IconPath[key]=Bag08_EmptyIcon(i)", 1)
    capture = capture.replace('            set Bag04Tooltip[key]="|cffffcc00"+GetItemName(it)+"|r|n"+BlzGetItemExtendedTooltip(it)', '''            set description=BlzGetItemExtendedTooltip(it)
            if description==null or description=="" then
                set description=BlzGetItemDescription(it)
            endif
            set Bag04Tooltip[key]="|cffffcc00"+GetItemName(it)+"|r"
            if description!=null and description!="" then
                set Bag04Tooltip[key]=Bag04Tooltip[key]+"|n|n"+description
            endif''',1)
    source = put(source, "Bag04_Capture", "\n".join(empty_lines) + "\n\n" + capture.strip())
    draw = fs["Bag04_Draw"]
    draw = draw.replace("    local integer key", "    local integer key\n    local real tipHeight",1)
    marker = "        call BlzFrameSetText(Bag04TipText[i],Bag04Tooltip[key])"
    assert marker in draw
    draw = draw.replace(marker, marker + """
        set tipHeight=RMinBJ(.210,.043+.012*I2R((StringLength(Bag04Tooltip[key])+47)/48))
        call BlzFrameSetSize(Bag08TooltipFrame[i],.272,tipHeight)
        call BlzFrameSetSize(Bag04TipText[i],.250,tipHeight-.020)""",1)
    source = put(source, "Bag04_Draw", draw)
    return source.replace("Backpack07:", "Backpack08:").replace("Bag07 slots=", "Bag08 slots=").replace("Bag07 setup", "Bag08 setup").replace("Bag07 open=", "Bag08 open=")


if __name__ == "__main__":
    panel.OUT = OUT
    panel.NAME = "FFERPG Backpack08"
    panel.source_for = source_for
    panel.build(Path(sys.argv[1]), {TOC: (FDF + "\r\n").encode(), FDF: TOOLTIP.encode()})
