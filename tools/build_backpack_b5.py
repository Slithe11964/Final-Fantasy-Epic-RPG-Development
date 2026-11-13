"""Refine B4 backpack overlay alignment and type."""
from pathlib import Path

from build_backpack_b2 import replace
from build_control_order40 import build
from jtok import functions
from performance_runtime import put

ROOT = Path(__file__).resolve().parents[1]


def refresh(source):
    fs = functions(source)
    if "BagB1_Init" not in fs:
        return source
    control = fs["Bag04_Control"]
    control = replace(control, "        call BlzFrameSetTextAlignment(label", """        call BlzFrameClearAllPoints(label)
        call BlzFrameSetScale(label,1.23)
        call BlzFrameSetPoint(label,FRAMEPOINT_CENTER,f,FRAMEPOINT_CENTER,0.,.0015)
        call BlzFrameSetTextAlignment(label""")
    source = put(source, "Bag04_Control", control)

    init = fs["BagB1_Init"]
    init = replace(init, '"X",-.015,-.013,.025,.024', '"X",-.008,-.008,.025,.024')
    init = replace(init, """        call BlzFrameSetPoint(BagB2Wheel[i],FRAMEPOINT_TOPLEFT,Bag04Button[i],FRAMEPOINT_TOPLEFT,.003,-.008)
        call BlzFrameSetPoint(BagB2Wheel[i],FRAMEPOINT_BOTTOMRIGHT,Bag04Button[i],FRAMEPOINT_BOTTOMRIGHT,-.003,.002)""", """        // The model draws above and right of the status-bar frame.
        call BlzFrameSetPoint(BagB2Wheel[i],FRAMEPOINT_CENTER,Bag04Button[i],FRAMEPOINT_CENTER,-.004,-.006)
        call BlzFrameSetSize(BagB2Wheel[i],.016,.016)""")
    init = replace(init, '        call BlzFrameSetLevel(BagB1Cooldown[i],80)', """        call BlzFrameClearAllPoints(BagB1Cooldown[i])
        call BlzFrameSetScale(BagB1Cooldown[i],1.45)
        call BlzFrameSetPoint(BagB1Cooldown[i],FRAMEPOINT_CENTER,Bag04Button[i],FRAMEPOINT_CENTER,0.,0.)
        call BlzFrameSetLevel(BagB1Cooldown[i],80)""")
    return put(source, "BagB1_Init", init)


if __name__ == "__main__":
    build(ROOT / "release/development/B4/FFERPG-B4.w3x",
          ROOT / "release/development/B5/FFERPG-B5.w3x",
          "FFERPG B5", "B4", "B5", transform=refresh,
          expected_changes={"Bag04_Control", "BagB1_Init"}, expected_added=frozenset())
