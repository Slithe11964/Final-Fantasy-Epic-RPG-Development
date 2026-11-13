"""Build the H and V40 hero order and travel-control candidates."""
import hashlib
import json
from pathlib import Path

from add_header import build_header, read_header
from downgrade import wts_write
from editor_pair import View
from jtok import functions, tokens
from control_order40 import refresh
from mpq import MPQ, compact, write_files
from test_map_identity import info_labels
from wct import raw_of, text_of, write_wct

ROOT = Path(__file__).resolve().parents[1]
ALLOWED = {"Trig_Job_Change_Actions", "FFL_Commit", "TravelPanel_Render", "Travel_Hide", "Cine_EnterPrepared", "Travel_Show",
           "Forsaken_RequestBackpackToggle", "Forsaken_PanelClick", "QuickGear_Request"}


def build(base, output, label, old_short, short, *, transform=refresh,
          expected_changes=ALLOWED, expected_added=frozenset({"Travel_CloseForCinematic"}), extra_files=None):
    assert not output.exists()
    view = View(base)
    archive = view.archive

    def labels(text):
        return text.replace(view.strings[38788], label).replace(old_short + " F/G:", short + " F/G:")

    runtime = labels(transform(view.runtime))
    before, after = functions(labels(view.runtime)), functions(runtime)
    assert after.keys() - before.keys() == expected_added
    assert not before.keys() - after.keys()
    changed = {name for name in before if tokens(before[name]) != tokens(after[name])}
    assert changed == expected_changes, sorted(changed)
    for index, raw in enumerate(view.wct["entries"]):
        text = text_of(raw)
        source = text.replace("\r\n", "\n")
        updated = labels(transform(source))
        if updated != source:
            view.wct["entries"][index] = raw_of(updated.replace("\n", "\r\n"))
    if view.wct.get("header"):
        header = text_of(view.wct["header"])
        if labels(header) != header:
            view.wct["header"] = raw_of(labels(header))
    strings = {key: labels(value) for key, value in view.strings.items()}
    strings[38788] = strings[4] = label
    assert strings[38790] == view.strings[38790] and strings[5] == view.strings[5]
    files = {
        "war3map.j": runtime.replace("\n", "\r\n").encode(),
        "war3map.wct": write_wct(view.wct),
        "war3map.wts": wts_write(strings),
        "war3map.w3i": info_labels(archive.read("war3map.w3i"), label),
        **(extra_files or {}),
    }
    output.parent.mkdir(parents=True, exist_ok=True)
    scratch = output.with_suffix(".unpacked.w3x")
    write_files(str(base), str(scratch), files)
    compact(str(scratch), str(output))
    _, flags, players = read_header(str(base))
    data = output.read_bytes()
    output.write_bytes(build_header(label, flags, players) + data[data.index(b"MPQ\x1a"):])
    result = MPQ(str(output))
    for name in archive.read("(listfile)").decode().splitlines():
        if name.lower() not in {"(listfile)", "(attributes)", "(signature)"}:
            assert result.read(name) == files.get(name, archive.read(name)), name
    output.with_suffix(".json").write_text(json.dumps({
        "base": str(base), "output": str(output), "sha256": hashlib.sha256(output.read_bytes()).hexdigest(),
        "changed_functions": sorted(changed),
    }, indent=2), encoding="utf-8")
    print(output, flush=True)


if __name__ == "__main__":
    build(ROOT / "release/0.9.7.5h/Siege01/FFERPG-0.9.7.5h-Siege01.w3x",
          ROOT / "release/0.9.7.5h/Controls01/FFERPG-0.9.7.5h-Controls01.w3x",
          "FFERPG 0.9.7.5h Controls01", "h Siege01", "h Controls01")
    build(ROOT / "release/development/V39/FFERPG-V39.w3x",
          ROOT / "release/development/V40/FFERPG-V40.w3x", "FFERPG V40", "V39", "V40")
