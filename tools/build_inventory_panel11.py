"""Increase outer clearance while restoring Backpack09's grid spacing."""
from pathlib import Path
import sys

import build_inventory_panel06 as panel
from jtok import functions, tokens
from performance_runtime import put

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "release/development/InventoryPanel11/FFERPG-Independent-Backpack-11.w3x"


def source_for(source):
    before = functions(source)
    init = before["Bag04_Init"].replace("Bag04Bag,.2075,.175", "Bag04Bag,.2075,.1775")
    source = put(source, "Bag04_Init", init)
    slots = before["Bag05_InitSlots"]
    # .0145 from the outer frame puts the slots .009 inside the gold line.
    # The .030 pitch leaves Backpack09's .0015 gap between .0285 cells.
    for old, new in (
        ("set x=.007+I2R(column)*.0325", "set x=.0145+I2R(column)*.030"),
        ("set y=-.007-I2R(row)*.0325", "set y=-.0145-I2R(row)*.030"),
        ("set x=.007\n", "set x=.0145\n"),
        ("set y=-.007-I2R(i)*.0325", "set y=-.0145-I2R(i)*.0325"),
        ("set x=.1695", "set x=.1645"),
        ("set y=-.2028", "set y=-.1978"),
        ("set y=-.1703", "set y=-.1653"),
        ("parent,FRAMEPOINT_TOPLEFT,x+.0015,y-.0015)", "parent,FRAMEPOINT_TOPLEFT,x,y)"),
        ("Bag04Button[i],.028,.028", "Bag04Button[i],.0285,.0285"),
    ):
        assert old in slots, old
        slots = slots.replace(old, new)
    source = put(source, "Bag05_InitSlots", slots)
    for prefix in ("Backpack", "Bag"):
        source = source.replace(prefix + "10", prefix + "11")
    after = functions(source)
    assert {name for name in before if tokens(before[name]) != tokens(after[name])} == {
        "Bag04_Init", "Bag05_InitSlots", "InvCheck_Chat", "InvCheck_Help", "main_old",
    }
    return source


if __name__ == "__main__":
    panel.OUT = OUT
    panel.NAME = "FFERPG Backpack11"
    panel.source_for = source_for
    panel.build(Path(sys.argv[1]))
