"""Clear inherited aura art from the New Game Plus experience indicator."""
from pathlib import Path

from build_control_order40 import build
from mpq import MPQ
from objdata import read_objects, write_objects
from priest_master import setf

ROOT = Path(__file__).resolve().parents[1]


def aura_files(base):
    archive = MPQ(str(base))
    result = {}
    for extension, ids, fields, rank in (
        ("w3a", {"aE19"}, ("acat", "atat", "asat", "aeat", "aaea"), 0),
        ("w3h", {f"bE{level:02d}" for level in range(1, 11)},
         ("ftat", "feat", "fcat", "fsat", "fspt", "fmat"), None),
    ):
        for prefix in ("war3map", "war3mapSkin"):
            filename = f"{prefix}.{extension}"
            data = archive.read(filename)
            if not data:
                continue
            table = read_objects(data, extension)
            objects = [entry for entry in table["custom"] if entry["id"] in ids]
            if prefix == "war3map":
                assert {entry["id"] for entry in objects} == ids
            if objects:
                for entry in objects:
                    for field in fields:
                        setf(entry, field, "", rank)
                result[filename] = write_objects(table, table["version"], extension)
    return result


if __name__ == "__main__":
    for old, new in (("B14", "B15"), ("V44", "V45")):
        base = ROOT / f"release/development/{old}/FFERPG-{old}.w3x"
        build(base, ROOT / f"release/development/{new}/FFERPG-{new}.w3x",
              f"FFERPG {new}", old, new, transform=lambda source: source,
              expected_changes=set(), expected_added=frozenset(), extra_files=aura_files(base))
