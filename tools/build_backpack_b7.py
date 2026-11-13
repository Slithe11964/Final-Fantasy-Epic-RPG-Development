"""Scale the backpack cooldown artwork and align it to the item icon."""
from pathlib import Path

from build_backpack_b2 import replace
from build_control_order40 import build
from jtok import functions
from performance_runtime import put

ROOT = Path(__file__).resolve().parents[1]


def refresh(source):
    init = functions(source).get("BagB1_Init")
    if init is None:
        return source
    init = replace(init, """        call BlzFrameSetPoint(BagB2Wheel[i],FRAMEPOINT_BOTTOM,Bag04Button[i],FRAMEPOINT_CENTER,-.004,-.014)
        call BlzFrameSetSize(BagB2Wheel[i],.016,.0128)""", """        call BlzFrameSetSize(BagB2Wheel[i],.016,.0128)
        call BlzFrameSetScale(BagB2Wheel[i],.50)
        // Account for the cooldown model's off-center artwork at half scale.
        call BlzFrameSetPoint(BagB2Wheel[i],FRAMEPOINT_CENTER,Bag04Icon[i],FRAMEPOINT_CENTER,-.0006,-.0066)""")
    return put(source, "BagB1_Init", init)


if __name__ == "__main__":
    build(ROOT / "release/development/B6/FFERPG-B6.w3x",
          ROOT / "release/development/B7/FFERPG-B7.w3x",
          "FFERPG B7", "B6", "B7", transform=refresh,
          expected_changes={"BagB1_Init"}, expected_added=frozenset())
