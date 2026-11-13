"""Align the two gear shortcuts with the native command grid."""
from pathlib import Path

from build_control_order40 import build
from jtok import functions
from performance_runtime import put

ROOT = Path(__file__).resolve().parents[1]


def refresh(source):
    fs = functions(source)
    if "QuickGear_Layout" not in fs:
        return source
    layout = fs["QuickGear_Layout"]
    marker = "    call BlzFrameSetAbsPoint(QuickGearRoot,FRAMEPOINT_TOPLEFT,.812,.085)"
    assert layout.count(marker) == 1
    layout = layout.replace(marker, """    call BlzFrameSetPoint(QuickGearRoot,FRAMEPOINT_TOPLEFT,QuickGearAnchor,FRAMEPOINT_TOPRIGHT,.026,0.)
    call BlzFrameClearAllPoints(QuickGearButton[0])
    call BlzFrameSetPoint(QuickGearButton[0],FRAMEPOINT_LEFT,QuickGearAnchor,FRAMEPOINT_RIGHT,.026,0.)
    call BlzFrameClearAllPoints(QuickGearButton[1])
    call BlzFrameSetPoint(QuickGearButton[1],FRAMEPOINT_LEFT,BlzGetOriginFrame(ORIGIN_FRAME_COMMAND_BUTTON,11),FRAMEPOINT_RIGHT,.026,0.)""")
    return put(source, "QuickGear_Layout", layout)


if __name__ == "__main__":
    build(ROOT / "release/development/B3/FFERPG-B3.w3x",
          ROOT / "release/development/B4/FFERPG-B4.w3x",
          "FFERPG B4", "B3", "B4", transform=refresh,
          expected_changes={"QuickGear_Layout"}, expected_added=frozenset())
