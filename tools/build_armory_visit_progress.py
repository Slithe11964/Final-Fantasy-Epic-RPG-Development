"""Package the armory inspection correction for H and the current development map."""
from pathlib import Path
import hashlib
import json

from add_header import build_header, read_header
from armory_visit_progress import refresh
from downgrade import wts_read, wts_write
from editor_pair import View
from jtok import functions, tokens
from mpq import MPQ, compact, write_files
from test_map_identity import info_labels
from wct import raw_of, text_of, write_wct

ROOT = Path(__file__).resolve().parents[1]
CHANGED = {"Armory_RefreshCounter", "Armory_PollCounter", "Armory_VisitHouse", "Trig_Armory_Select_CanWithdraw"}


def build(base, output, label, short, old_short):
    assert not output.exists()
    view = View(base)
    old_label = view.strings[38788]

    def labels(text):
        return text.replace(old_label, label).replace(old_short + " F/G:", short + " F/G:")

    runtime = labels(refresh(view.runtime))
    source = labels(refresh(view.modules["TArmory"]))
    assert source != labels(view.modules["TArmory"])
    for index, raw in enumerate(view.wct["entries"]):
        old = text_of(raw)
        updated = source.replace("\n", "\r\n") if old.lstrip().startswith("library TArmory ") else labels(old)
        if updated != old:
            view.wct["entries"][index] = raw_of(updated)
    if view.wct.get("header"):
        header = text_of(view.wct["header"])
        if labels(header) != header:
            view.wct["header"] = raw_of(labels(header))
    archive = view.archive
    strings = {key: labels(text) for key, text in wts_read(archive.read("war3map.wts")).items()}
    strings[38788] = strings[4] = label
    assert strings[38790] == view.strings[38790] and strings[5] == view.strings[5]
    files = {
        "war3map.j": runtime.replace("\n", "\r\n").encode(),
        "war3map.wct": write_wct(view.wct),
        "war3map.wts": wts_write(strings),
        "war3map.w3i": info_labels(archive.read("war3map.w3i"), label),
    }
    before, after = functions(labels(view.runtime)), functions(runtime)
    assert before.keys() == after.keys()
    assert {name for name in before if tokens(before[name]) != tokens(after[name])} == CHANGED
    output.parent.mkdir(parents=True, exist_ok=True)
    temp = output.with_suffix(".unpacked.w3x")
    write_files(str(base), str(temp), files)
    compact(str(temp), str(output))
    _, flags, players = read_header(str(base))
    data = output.read_bytes()
    output.write_bytes(build_header(label, flags, players) + data[data.index(b"MPQ\x1a"):])
    result = MPQ(str(output))
    for name in archive.read("(listfile)").decode().splitlines():
        if name.lower() not in {"(listfile)", "(attributes)", "(signature)"}:
            assert result.read(name) == files.get(name, archive.read(name)), name
    output.with_suffix(".j").write_text(runtime, encoding="utf-8")
    output.with_suffix(".json").write_text(json.dumps({
        "base": str(base), "output": str(output), "changed_functions": sorted(CHANGED),
        "sha256": hashlib.sha256(output.read_bytes()).hexdigest(),
    }, indent=2), encoding="utf-8")
    print(output, flush=True)


if __name__ == "__main__":
    build(ROOT / "release/0.9.7.5h/rebuild-from-save01/FFERPG-0.9.7.5h.w3x",
          ROOT / "release/0.9.7.5h/Armory01/FFERPG-0.9.7.5h-Armory01.w3x",
          "FFERPG 0.9.7.5h Armory01", "h Armory01", "0.9.7.5h")
    build(ROOT / "release/development/V37/FFERPG-V37.w3x",
          ROOT / "release/development/V38/FFERPG-V38.w3x", "FFERPG V38", "V38", "V37")
