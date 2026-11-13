"""Build the next standalone backpack layout and clickable command icon."""
from pathlib import Path
import sys

import build_inventory_panel06 as panel
from jtok import functions, tokens
from performance_runtime import put

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "release/development/InventoryPanel12/FFERPG-Independent-Backpack-12.w3x"


def source_for(source):
    before = functions(source)
    init = before["Bag04_Init"]
    for old, new in (
        ('"X",-.015,-.013,.020,.019', '"X",-.015,-.013,.024,.023'),
        ('"Talents",-.015,-.045,.063,.022', '"Talents",-.015,-.045,.071,.026'),
        ('"Move to hero",-.015,-.173,.090,.021', '"Move to hero",-.015,-.173,.102,.025'),
        ('BlzCreateFrameByType("BUTTON","BagAccess07",BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI,0),"",0)',
         'BlzCreateFrame("ScriptDialogButton",BlzFrameGetParent(BlzGetOriginFrame(ORIGIN_FRAME_PORTRAIT,0)),0,912)'),
        ('    call BlzFrameSetAllPoints(Bag04Access,BlzGetOriginFrame(ORIGIN_FRAME_COMMAND_BUTTON,4))',
         '    call BlzFrameClearAllPoints(Bag04Access)\n'
         '    call BlzFrameSetAllPoints(Bag04Access,BlzGetOriginFrame(ORIGIN_FRAME_COMMAND_BUTTON,4))\n'
         '    call BlzFrameSetText(Bag04Access,"")'),
    ):
        assert old in init, old
        init = init.replace(old, new)
    source = put(source, "Bag04_Init", init)

    slots = before["Bag05_InitSlots"]
    slots = slots.replace("set x=.0145+I2R(column)*.030", "set x=.0115+I2R(column)*.031")
    slots = slots.replace("set y=-.0145-I2R(row)*.030", "set y=-.012-I2R(row)*.031")
    slots = slots.replace("        if i>=39 then\n            call BlzFrameClearAllPoints", """        if i>=9 and i<39 then
            call BlzFrameSetSize(Bag04Button[i],.0295,.0295)
        elseif i>=39 then
            call BlzFrameClearAllPoints""", 1)
    source = put(source, "Bag05_InitSlots", slots)
    for prefix in ("Backpack", "Bag"):
        source = source.replace(prefix + "11", prefix + "12")
    after = functions(source)
    assert {name for name in before if tokens(before[name]) != tokens(after[name])} == {
        "Bag04_Init", "Bag05_InitSlots", "InvCheck_Chat", "InvCheck_Help", "main_old",
    }
    return source


if __name__ == "__main__":
    panel.OUT = OUT
    panel.NAME = "FFERPG Backpack12"
    panel.source_for = source_for
    panel.build(Path(sys.argv[1]))
