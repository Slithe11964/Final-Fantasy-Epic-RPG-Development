"""Apply quest-specific HP and base damage multipliers."""
from pathlib import Path
import re
from functools import partial

from build_control_order40 import build
from editor_pair import View
from jtok import functions, tokens
from performance_runtime import put

ROOT = Path(__file__).resolve().parents[1]
QUESTS = ROOT / "src/triggers/06 Quests and story"
TIMMY = "Trig_Quest_SaveTimmy_Init_Enum_BuffCampUnit"
LIFE = "call SetUnitLifePercentBJ(GetLastCreatedUnit(),'d')"


def scale(indent, factor):
    unit = "GetLastCreatedUnit()"
    lines = [f"call BlzSetUnitBaseDamage({unit},BlzGetUnitBaseDamage({unit},{slot})*{factor},{slot})"
             for slot in (0, 1)]
    lines += [f"call BlzSetUnitMaxHP({unit},BlzGetUnitMaxHP({unit})*{factor})", LIFE]
    return "\n".join(indent + line for line in lines)


def siege(body, part):
    factor = 2 if part == 1 else 3
    # Old Eternity branches contain the entire legacy stat block.
    body = re.sub(r"(?m)^([ ]+)if\(Trig_KalmSiege[123]_\w+_ScalingOff\(\)\)then\n"
                  r"(?:.*\n)*?^\1endif(?=\n)",
                  lambda match: scale(match[1], factor) if part != 3 else "", body)
    if part == 3:
        # Apply one multiplier to both sides of the mixed forest/north wave.
        body = re.sub(r"(?m)^([ ]+)call Unit_ScaleToLevel60\(bj_lastCreatedUnit\)\n"
                      r"\1if\(Trig_KalmSiege3_Begin_IsBoostedSouthSlot\(siegeIndex\)\)then\n"
                      r"(?:.*\n)*?^\1endif", lambda match: scale(match[1], factor), body)
    # The paired half-health and half-max-HP calls previously made these
    # special spawns full at half max HP. Retain their vulnerability ability.
    body = re.sub(r"(?m)^([ ]+)call Unit_ScaleToLevel60\(bj_lastCreatedUnit\)\n"
                  r"\1call SetUnitLifePercentBJ\(GetLastCreatedUnit\(\),50\.\)\n"
                  r"\1call BlzSetUnitMaxHP\(GetLastCreatedUnit\(\),\(BlzGetUnitMaxHP\(GetLastCreatedUnit\(\)\)/ 2\)\)",
                  lambda match: scale(match[1], factor), body)
    body = re.sub(r"(?m)^([ ]+)call Unit_ScaleToLevel60\(bj_lastCreatedUnit\)$",
                  lambda match: scale(match[1], factor), body)
    return body.replace(f"set udg_RaidPowerLevel={10+20*part}", f"set udg_RaidPowerLevel={4*(part+1)}")


def refresh(source):
    for name, original in functions(source).items():
        if name == TIMMY:
            updated = re.sub(r"(?m)^    call BlzSetUnitBaseDamage.*\n", "", original.replace("*3))", "*2))"))
        elif match := re.match(r"Trig_KalmSiege([123])_", name):
            updated = siege(original, int(match[1]))
        else:
            continue
        if updated != original:
            source = put(source, name, updated)
    return source


def build_map(old, new):
    base = ROOT / f"release/development/{old}/FFERPG-{old}.w3x"
    before = functions(View(base).runtime)
    after = functions(refresh(View(base).runtime))
    changes = {name for name in before if tokens(before[name]) != tokens(after[name])}
    assert TIMMY in changes and len(changes) >= 10, sorted(changes)
    assert all("call Unit_ScaleToLevel60" not in after[name] for name in after
               if re.match(r"Trig_KalmSiege[123]_", name))
    for part in (1, 2, 3):
        assert any(f"set udg_RaidPowerLevel={4*(part+1)}" in after[name]
                   for name in changes if name.startswith(f"Trig_KalmSiege{part}_"))
    build(base, ROOT / f"release/development/{new}/FFERPG-{new}.w3x",
          f"FFERPG {new}", old, new, transform=refresh,
          expected_changes=changes, expected_added=frozenset())


if __name__ == "__main__":
    for filename in ("Quest_SaveTimmy.j", "KalmSiege1.j", "KalmSiege2.j", "KalmSiege3.j"):
        path = QUESTS / filename
        old = path.read_text(encoding="utf-8")
        new = refresh(old)
        if old != new:
            path.write_text(new, encoding="utf-8", newline="\r\n")
    build_map("B13", "B14")
    build_map("V43", "V44")
