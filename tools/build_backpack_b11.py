"""Restore item lookup for custom backpack clicks."""
from pathlib import Path

from build_backpack_b2 import replace
from build_control_order40 import build
from jtok import functions
from performance_runtime import put

ROOT = Path(__file__).resolve().parents[1]


def refresh(source):
    fs = functions(source)
    if "QuickGear_Item" not in fs:
        return source
    item = replace(fs["QuickGear_Item"], "    if slot==0 then", """    if slot>=10 and slot<49 then
        if slot<19 then
            return BlzUnitItemInEquipmentSlot(hero,ConvertLoadoutSlot(slot-10))
        endif
        return BlzUnitItemInBagSlot(hero,slot-19)
    elseif slot==0 then""")
    source = put(source, "QuickGear_Item", item)

    # Some carried variants are registered only in the wave-preview catalogue.
    for name in ("QuickGear_Request", "QuickGear_Receive"):
        body = fs[name]
        marker = "    set cast=LoadInteger(QuickGearData,0,raw)"
        body = replace(body, marker, marker + """
    if slot>=10 and cast==0 then
        set cast=LoadInteger(GearInputSpells,0,raw)
    endif""")
        if name == "QuickGear_Request":
            body = replace(body, "        if LoadInteger(QuickGearData,1,raw)==0 then",
                           "        if LoadInteger(QuickGearData,1,raw)==0 and (slot<10 or cast==0 or GearWave_ModeFor(cast)==0) then")
        else:
            body = replace(body, "    set mode=LoadInteger(QuickGearData,1,raw)", """    set mode=LoadInteger(QuickGearData,1,raw)
    if slot>=10 and mode==0 and cast!=0 and GearWave_ModeFor(cast)!=0 then
        set mode=2
    endif""")
        source = put(source, name, body)
    return source


if __name__ == "__main__":
    build(ROOT / "release/development/B10/FFERPG-B10.w3x",
          ROOT / "release/development/B11/FFERPG-B11.w3x",
          "FFERPG B11", "B10", "B11", transform=refresh,
          expected_changes={"QuickGear_Item", "QuickGear_Request", "QuickGear_Receive"},
          expected_added=frozenset())
