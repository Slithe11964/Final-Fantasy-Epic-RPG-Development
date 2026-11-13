"""Build the next standalone backpack layout test."""
from pathlib import Path
import sys

import build_inventory_panel06 as panel
from jtok import functions, tokens
from performance_runtime import put

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "release/development/InventoryPanel10/FFERPG-Independent-Backpack-10.w3x"


def source_for(source):
    before = functions(source)
    init = before["Bag04_Init"].replace(".096,.096)", ".088,.088)")
    init = init.replace('"Talents",-.015,-.049', '"Talents",-.015,-.045')
    source = put(source, "Bag04_Init", init)

    # Keep slot centers fixed and add clearance on all four sides.
    slots = before["Bag05_InitSlots"].replace("parent,FRAMEPOINT_TOPLEFT,x,y)",
                                             "parent,FRAMEPOINT_TOPLEFT,x+.0015,y-.0015)")
    slots = slots.replace("Bag04Button[i],.031,.031", "Bag04Button[i],.028,.028")
    source = put(source, "Bag05_InitSlots", slots)
    for prefix in ("Backpack", "Bag"):
        source = source.replace(prefix + "09", prefix + "10")
    after = functions(source)
    assert {name for name in before if tokens(before[name]) != tokens(after[name])} == {
        "Bag04_Init", "Bag05_InitSlots", "InvCheck_Chat", "InvCheck_Help", "main_old",
    }
    return source


if __name__ == "__main__":
    panel.OUT = OUT
    panel.NAME = "FFERPG Backpack10"
    panel.source_for = source_for
    panel.build(Path(sys.argv[1]))
