"""Fit the backpack cooldown artwork to the item icon after the B7 visual test."""
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
    init = replace(init, """        call BlzFrameSetScale(BagB2Wheel[i],.50)
        // Account for the cooldown model's off-center artwork at half scale.
        call BlzFrameSetPoint(BagB2Wheel[i],FRAMEPOINT_CENTER,Bag04Icon[i],FRAMEPOINT_CENTER,-.0006,-.0066)""", """        call BlzFrameSetScale(BagB2Wheel[i],.70)
        // Compensate for the model artwork's pivot at this scale.
        call BlzFrameSetPoint(BagB2Wheel[i],FRAMEPOINT_CENTER,Bag04Icon[i],FRAMEPOINT_CENTER,-.002,-.0095)""")
    return put(source, "BagB1_Init", init)


if __name__ == "__main__":
    build(ROOT / "release/development/B7/FFERPG-B7.w3x",
          ROOT / "release/development/B8/FFERPG-B8.w3x",
          "FFERPG B8", "B7", "B8", transform=refresh,
          expected_changes={"BagB1_Init"}, expected_added=frozenset())
