"""Build H Siege01 and V39 without changing unrelated archive payloads."""
import hashlib
import json
from pathlib import Path

from add_header import build_header, read_header
from downgrade import wts_write
from editor_pair import View
from jtok import functions, tokens
from kalm_cinematic39 import refresh
from mpq import MPQ, compact, write_files
from test_map_identity import info_labels
from wct import raw_of, text_of, write_wct

ROOT = Path(__file__).resolve().parents[1]
ALLOWED = {"Cine_Enter", "Cine_Exit", "QuickGear_DrawWheel", "QuickGear_Init",
           "C20_HideUI", "C23_PauseControls", "C23_ResumeControls", "Armory_PollCounter"}


def build(base, output, label, old_short, short):
    assert not output.exists()
    view = View(base)
    archive = view.archive

    def labels(text):
        return text.replace(view.strings[38788], label).replace(old_short + " F/G:", short + " F/G:")

    runtime = labels(refresh(view.runtime))
    before, after = functions(labels(view.runtime)), functions(runtime)
    assert after.keys() - before.keys() == {"Cine_EnterPrepared", "Cine_EnterKalm"}
    assert not before.keys() - after.keys()
    changed = {name for name in before if tokens(before[name]) != tokens(after[name])}
    siege = {name for name, body in before.items() if name.startswith(("Trig_KalmSiege1_", "Trig_KalmSiege2_", "Trig_KalmSiege3_")) and "call Cine_Enter()" in body}
    assert len(siege) >= 15 and changed == ALLOWED | siege, (sorted(changed), sorted(siege))
    for name in siege:
        assert after[name] == before[name].replace("call Cine_Enter()", "call Cine_EnterKalm()"), name
    for i in range(65):
        assert archive.read(f"war3mapImported/QuickGearWheelCD{i:02}.tga")
    for index, raw in enumerate(view.wct["entries"]):
        text = text_of(raw)
        source = text.replace("\r\n", "\n")
        updated = labels(refresh(source))
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
        "siege_entry_points": sorted(siege), "other_changed_functions": sorted(ALLOWED),
    }, indent=2), encoding="utf-8")
    print(output, len(siege), "siege scene paths", flush=True)


if __name__ == "__main__":
    build(ROOT / "release/0.9.7.5h/Armory01/FFERPG-0.9.7.5h-Armory01.w3x",
          ROOT / "release/0.9.7.5h/Siege01/FFERPG-0.9.7.5h-Siege01.w3x",
          "FFERPG 0.9.7.5h Siege01", "h Armory01", "h Siege01")
    build(ROOT / "release/development/V38/FFERPG-V38.w3x",
          ROOT / "release/development/V39/FFERPG-V39.w3x", "FFERPG V39", "V38", "V39")
