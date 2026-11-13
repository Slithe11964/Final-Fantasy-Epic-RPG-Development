"""Preserve the six native inventory positions when the active job changes."""
from pathlib import Path

from build_control_order40 import build
from jtok import functions
from performance_runtime import put

ROOT = Path(__file__).resolve().parents[1]
JOB = "Trig_Job_Change_Actions"


def refresh(source):
    fs = functions(source)
    if JOB not in fs:
        return source
    body = fs[JOB]
    marker = "    call Forsaken_TransferSharedInventory(forsakenPrevious,jobHero)"
    assert body.count(marker) == 1
    start = body.index(marker)
    item = "JobSwitchItems[jobPid*6+jobSlot-1]"
    restore = f"""            if UnitHasItem(jobHero,{item}) and UnitItemInSlot(jobHero,jobSlot-1)!={item} then
                call UnitDropItemSlot(jobHero,{item},jobSlot-1)
            endif
"""
    loop_end = f"""        endif
        set jobSlot=jobSlot+1
    endloop"""
    before, after = body[:start], body[start:]
    end = after.index(loop_end)
    after = after[:end] + restore + after[end:]
    return put(source, JOB, before + after)


if __name__ == "__main__":
    options = dict(transform=refresh, expected_changes={JOB}, expected_added=frozenset())
    build(ROOT / "release/development/V42/FFERPG-V42.w3x",
          ROOT / "release/development/V43/FFERPG-V43.w3x",
          "FFERPG V43", "V42", "V43", **options)
    build(ROOT / "release/0.9.7.5h/Controls03/FFERPG-0.9.7.5h-Controls03.w3x",
          ROOT / "release/0.9.7.5h/Controls04/FFERPG-0.9.7.5h-Controls04.w3x",
          "FFERPG 0.9.7.5h Controls04", "h Controls03", "h Controls04", **options)
