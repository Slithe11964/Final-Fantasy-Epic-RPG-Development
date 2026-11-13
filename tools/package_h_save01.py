"""Package a separate production-named H candidate from the verified Save01 map."""
import hashlib
import json
from pathlib import Path

from add_header import build_header, read_header
from downgrade import wts_read, wts_write
from jtok import functions, tokens
from mpq import MPQ, compact, write_files
from test_map_identity import info_labels
from wct import raw_of, read_wct, text_of, write_wct

ROOT = Path(__file__).resolve().parents[1]
RELEASE = ROOT / "release/0.9.7.5h"
ORIGINAL = RELEASE / "FFERPG-0.9.7.5h.w3x"
SOURCE = RELEASE / "FFERPG-0.9.7.5h-Save01.w3x"
OUTPUT = RELEASE / "rebuild-from-save01" / ORIGINAL.name
H_LABEL = "FFERPG 0.9.7.5h"
METADATA = {"(attributes)", "(listfile)", "(signature)"}
EXPECTED_AUTOSAVE_CHANGES = {
    "C20_BeginAutosave", "C20_ProfilePause", "C20_ProfileResume",
    "FFL_Tick", "FRC_Timeout", "Restore_AutosaveTick",
}


def production_labels(source):
    return source.replace("FFERPG 0.9.7.5h Save01", H_LABEL).replace(
        "h Save01 F/G:", "0.9.7.5h F/G:"
    )


def sha256(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def names(archive):
    return set(archive.read("(listfile)").decode().splitlines()) - METADATA


def main():
    if OUTPUT.exists():
        raise FileExistsError(OUTPUT)
    manifest = json.loads(SOURCE.with_suffix(".json").read_text())
    assert sha256(SOURCE) == manifest["sha256"], "Unexpected Save01 input"
    base = MPQ(str(SOURCE))
    original = MPQ(str(ORIGINAL))
    script = production_labels(base.read("war3map.j").decode())
    wct = read_wct(base.read("war3map.wct"))
    if wct.get("header"):
        header = text_of(wct["header"])
        if production_labels(header) != header:
            wct["header"] = raw_of(production_labels(header))
    for index, raw in enumerate(wct["entries"]):
        source = text_of(raw)
        if production_labels(source) != source:
            wct["entries"][index] = raw_of(production_labels(source))
    strings = wts_read(base.read("war3map.wts"))
    strings = {key: production_labels(value) for key, value in strings.items()}
    assert strings[4] == strings[38788] == H_LABEL
    expected = {
        "war3map.j": script.encode(),
        "war3map.wct": write_wct(wct),
        "war3map.wts": wts_write(strings),
        "war3map.w3i": info_labels(base.read("war3map.w3i"), H_LABEL),
    }
    assert strings[5] == wts_read(base.read("war3map.wts"))[5]
    assert strings[38790] == wts_read(base.read("war3map.wts"))[38790]
    before = functions(original.read("war3map.j").decode())
    after = functions(script)
    changed = {name for name in before.keys() & after.keys()
               if tokens(before[name]) != tokens(after[name])}
    added = after.keys() - before.keys()
    removed = before.keys() - after.keys()
    assert changed == EXPECTED_AUTOSAVE_CHANGES, sorted(changed)
    assert added == {"C36_ResumeProfilePoll"} and not removed, (added, removed)
    assert names(base) == names(original)
    assert all(base.read(name) == original.read(name)
               for name in names(base) - expected.keys())
    OUTPUT.parent.mkdir(parents=True, exist_ok=True)
    scratch = OUTPUT.with_suffix(".unpacked.w3x")
    write_files(str(SOURCE), str(scratch), expected)
    compact(str(scratch), str(OUTPUT))
    _, flags, players = read_header(str(SOURCE))
    data = OUTPUT.read_bytes()
    OUTPUT.write_bytes(build_header(H_LABEL, flags, players) + data[data.index(b"MPQ\x1a"):])
    result = MPQ(str(OUTPUT))
    assert names(result) == names(base)
    assert all(result.read(name) == expected.get(name, base.read(name)) for name in names(base))
    diff_save01 = sorted(name for name in names(base) if base.read(name) != result.read(name))
    diff_h = sorted(name for name in names(base) if original.read(name) != result.read(name))
    report = {
        "output": str(OUTPUT),
        "sha256": sha256(OUTPUT),
        "save01_sha256": sha256(SOURCE),
        "original_h_sha256": sha256(ORIGINAL),
        "changed_payloads_vs_save01": diff_save01,
        "changed_payloads_vs_original_h": diff_h,
        "changed_functions_vs_original_h": sorted(changed),
        "added_functions_vs_original_h": sorted(added),
        "archive_files_checked": len(names(base)),
    }
    OUTPUT.with_suffix(".json").write_text(json.dumps(report, indent=2) + "\n", encoding="utf-8")
    print(json.dumps(report, indent=2))


if __name__ == "__main__":
    main()
