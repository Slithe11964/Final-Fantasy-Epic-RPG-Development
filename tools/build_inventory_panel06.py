"""Standalone native-storage test with a direct, viewer-only panel command."""
from pathlib import Path
import sys

import build_asset_gallery as gallery
from add_header import read_header, build_header
from downgrade import wts_read, wts_write
from jtok import functions, tokens
from mpq import MPQ, write_files, compact
from objdata import read_objects, write_objects
from performance_runtime import put
from test_map_identity import info_labels

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "release/development/InventoryPanel06/FFERPG-Independent-Backpack-06.w3x"
NAME = "FFERPG Backpack06"


def source_for(source):
    original = functions(source)
    init = original["Bag04_Init"]
    marker = "        call BlzTriggerRegisterPlayerKeyEvent(keys,Player(i),OSKEY_B,0,true)"
    assert init.count(marker) == 1
    init = init.replace(marker, """        call UnitRemoveAbility(InvCheckHero[i],'ASpc')
        call UnitRemoveAbility(InvCheckCourier[i],'ASpc')
        call SetPlayerAbilityAvailable(Player(i),'ASpc',false)
""" + marker)
    init = init.replace("Test Bag 05", "Test Bag 06").replace("X 05", "X 06")
    source = put(source, "Bag04_Init", init)
    chat = original["InvCheck_Chat"]
    marker = '    if text=="-bagstate" then'
    assert chat.count(marker) == 1
    chat = chat.replace(marker, '''    if text=="-bag" then
        if GetLocalPlayer()==p and Bag04Ready and not InvCheckScene then
            set Bag04Chat=false
            call Bag04_Show(not Bag04Open)
        endif
    elseif text=="-bagstate" then''').replace("Bag05 slots=", "Bag06 slots=").replace(
        " native hero/courier=", " native ability levels hero/courier="
    ).replace("Bag05 open=", "Bag06 open=").replace("Bag05 setup", "Bag06 setup")
    source = put(source, "InvCheck_Chat", chat)
    text = 'Backpack06: type -bag to open or close your own custom panel. Look for X 06 and Drop held item. Alternate -bag with another player and use -bagstate to report each client. Test Bag 06 and B also toggle the custom panel.'
    source = put(source, "InvCheck_Help", 'function InvCheck_Help takes player p returns nothing\n'
                 f'    call DisplayTimedTextToPlayer(p,0.,0.,40.,"{text}")\nendfunction')
    main = original["main_old"].replace(
        "Use Test Bag 05 or B. Look for X 05 and Drop held item. Alternate opening and closing in two player slots; -bagstate reports local status.",
        text,
    )
    source = put(source, "main_old", main)
    updated = functions(source)
    assert {name for name in original if tokens(original[name]) != tokens(updated[name])} == {
        "Bag04_Init", "InvCheck_Chat", "InvCheck_Help", "main_old"
    }
    return source


def build(base, extra_files=None):
    if OUT.exists():
        raise FileExistsError(OUT)
    original = MPQ(str(base))
    source = source_for(original.read("war3map.j").decode().replace("\r\n", "\n"))
    strings = wts_read(original.read("war3map.wts"))
    strings[38788] = strings[4] = NAME
    data = read_objects(original.read("war3map.w3a"), "w3a")
    opener = next(obj for obj in data["original"] if obj["base"] == "ASpc")
    changed = set()
    for section in opener["sets"]:
        for mod in section["mods"]:
            if mod["field"] in {"ahky", "atp1"}:
                mod["value"] = "J" if mod["field"] == "ahky" else "Native Backpack (J)"
                changed.add(mod["field"])
    assert changed == {"ahky", "atp1"}
    gallery.NAME = NAME
    files = {
        "war3map.j": source.replace("\n", "\r\n").encode(),
        "war3map.w3a": write_objects(data, data["version"], "w3a"),
        "war3map.wts": wts_write(strings),
        "war3map.w3i": info_labels(original.read("war3map.w3i"), NAME),
        **gallery.editor_files(source),
        **(extra_files or {}),
    }
    OUT.parent.mkdir(parents=True, exist_ok=True)
    temp = OUT.with_suffix(".unpacked.w3x")
    write_files(str(base), str(temp), files)
    compact(str(temp), str(OUT))
    _, flags, players = read_header(str(base))
    binary = OUT.read_bytes()
    OUT.write_bytes(build_header(NAME, flags, players) + binary[binary.index(b"MPQ\x1a"):])
    result = MPQ(str(OUT))
    for name in original.read("(listfile)").decode().splitlines():
        if name.lower() not in {"(listfile)", "(attributes)", "(signature)"}:
            assert result.read(name) == files.get(name, original.read(name)), name
    for name, content in (extra_files or {}).items():
        assert result.read(name) == content, name
    OUT.with_suffix(".j").write_text(source, encoding="utf-8")
    print(OUT)


if __name__ == "__main__":
    build(Path(sys.argv[1]))
