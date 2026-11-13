"""Adjust backpack labels and shorten the cooldown model from its top."""
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
    control = replace(fs["Bag04_Control"], "BlzFrameSetScale(label,1.23)", "BlzFrameSetScale(label,1.40)")
    control = replace(control, "f,FRAMEPOINT_CENTER,0.,.0015)", "f,FRAMEPOINT_CENTER,0.,-.0005)")
    source = put(source, "Bag04_Control", control)

    init = fs["BagB1_Init"]
    # B5's center minus half its height was -.014. Anchor that edge directly.
    init = replace(init, """        call BlzFrameSetPoint(BagB2Wheel[i],FRAMEPOINT_CENTER,Bag04Button[i],FRAMEPOINT_CENTER,-.004,-.006)
        call BlzFrameSetSize(BagB2Wheel[i],.016,.016)""", """        call BlzFrameSetPoint(BagB2Wheel[i],FRAMEPOINT_BOTTOM,Bag04Button[i],FRAMEPOINT_CENTER,-.004,-.014)
        call BlzFrameSetSize(BagB2Wheel[i],.016,.0128)""")
    return put(source, "BagB1_Init", init)


if __name__ == "__main__":
    build(ROOT / "release/development/B5/FFERPG-B5.w3x",
          ROOT / "release/development/B6/FFERPG-B6.w3x",
          "FFERPG B6", "B5", "B6", transform=refresh,
          expected_changes={"Bag04_Control", "BagB1_Init"}, expected_added=frozenset())
