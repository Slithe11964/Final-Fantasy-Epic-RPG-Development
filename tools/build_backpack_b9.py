"""Fine-tune the backpack cooldown wheel position from the B8 visual test."""
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
    init = replace(init, "Bag04Icon[i],FRAMEPOINT_CENTER,-.002,-.0095)",
                   "Bag04Icon[i],FRAMEPOINT_CENTER,-.006,-.011)")
    return put(source, "BagB1_Init", init)


if __name__ == "__main__":
    build(ROOT / "release/development/B8/FFERPG-B8.w3x",
          ROOT / "release/development/B9/FFERPG-B9.w3x",
          "FFERPG B9", "B8", "B9", transform=refresh,
          expected_changes={"BagB1_Init"}, expected_added=frozenset())
