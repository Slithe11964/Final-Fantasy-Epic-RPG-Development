# FF Epic RPG on Warcraft III 1.29.2

## Status (stage E, 2026-10-02): first 1.29.2 test map built

`release/FFERPG_0.9.7.3-r16-stageE-1.29.2.w3x` was made from the stage C map by
`MapToolkit/tools/downgrade.py`. Each converted file was checked against the old r7 map:

- **Terrain:** byte-identical to r7.
- **Doodads:** 12,036 of 12,043 records are byte-identical to r7; the other 7 were changed since r7.
- **Placed units:** the file reads back fully.
- **Object data:** the same objects as r7. The only differences are values the Reforged editor leaves out because they are defaults.
- **Map info:** version 25, reads back fully.
- **Script:** compiles against 1.29.2's natives.

**Not proven until you play it in 1.29.2.**

### How to test
1. Copy the map into the Maps folder that 1.29.2 uses (`Documents\\Warcraft III\\Maps`, or the game folder's `Maps`).
2. Start 1.29.2 → Single Player → Custom Game, and pick it.
3. Check, and note anything wrong:
   - the map shows in the list with the right name and loading screen;
   - the terrain, trees and buildings look right;
   - heroes can be picked; the job shrine works; spells work;
   - `-save` and `-load` work;
   - the quest log (F9) works;
   - the `-dev` commands work;
   - nothing crashes in 15+ minutes of play.
4. Optional: open it in the 1.29 World Editor. Do the triggers, terrain and units show?

If it crashes on loading, tell me where (map list, loading screen, or the start of the game). Each
point narrows it down to one file type.

### Known limits
- **The 1.29 editor:** the map also carries the trigger editor (classic format: 11 folders, 576
  variables, 737 triggers), regions and cameras, so the 1.29 World Editor should open it. The
  map's code is vJass, so **saving** it in the 1.29 editor needs JassHelper there. If your 1.29
  editor has no JassHelper menu, look but don't save; the map as built is already playable.
  The Variable Editor sub-folders become one list, since the classic format has no sub-folders.
- **Object data:** fields that only exist in Reforged are kept in the object data. 1.29 should
  ignore them, but that is unconfirmed.
- **Re-run on every release:** `python tools/downgrade.py <Reforged map> <out> --w3i-template FFERPG_0.9.7.3-r7.w3x`.
  `--no-editor-files` makes a play-only map.

---

# Feasibility study (written before the converter)

Date: 2026-10-02. Map checked: `release/FFERPG_0.9.7.3-r15test.w3x`.
Tool: `MapToolkit/tools/compat_report.py` (re-run it after changes).

## Short answer

- **The trigger code is ready for 1.29.2 now.** Every native and constant the map's own code uses
  existed in 1.29.2. The few newer ones in the script are all in code World Editor writes by itself
  (preplaced units, cameras, player race skins, fog/water). A 1.29 editor writes its own version
  of that code. 1.29.0 and older do **not** work: the map uses about 30 `Blz*` natives added in
  1.29.2 (unit damage/HP/armor, ability tooltips and costs, effect scale/colour).
- **The map file is not ready.** Reforged saved every world and object file in a newer format
  that a 1.29 game or editor can't read. Getting there needs a converter. Nothing about it
  looks impossible, but it is a project of its own and can only be proven in a real 1.29.2
  install.

## What blocks 1.29

| Part | Now (Reforged) | 1.29 needs | Work |
|---|---|---|---|
| Map info `war3map.w3i` | version 39 | 28 | Rewrite: drop the Reforged fields (game data version, script language, supported modes, HD fog/water …). |
| Terrain `war3map.w3e` | 12 | 11 | Convert. Check for Reforged-only tilesets. |
| Doodads `war3map.doo`, units `war3mapUnits.doo` | 13 | 8 | Drop the skin IDs Reforged added to every placed object. |
| Regions, cameras `w3r` / `w3c` | 7 / 3 | 5 / 0 | Drop the extra fields. |
| Object data `w3u w3a w3t w3b w3d w3h w3q` | 3 | 2 | Merge each object's first "set" back into the classic layout. Skin fields that Reforged keeps in `war3mapSkin.*` need folding back in. |
| Triggers `wtg` / `wct` | Reforged | 7 / 1 | Our tools already read and write both formats (`MapToolkit/tools/wct_any.py`; the classic trigger tree writer is in `deprotect.py` and `split_modules.py`). |
| Script `war3map.j` | built by the Reforged editor | built by the 1.29 editor | Once the files above open in the 1.29 editor, it regenerates the script. The map's code is vJass, so that editor needs JassHelper. Check whether the 1.29 editor has it built in; otherwise use a community editor pack or run JassHelper separately. |
| Models, textures | some may be Reforged-only | classic assets | Check every model path in the object data against the 1.29 game files. Unknown. |

**A useful shortcut:** the original r7 map was saved by an older editor. Its terrain (`w3e` v11),
doodads (`doo` v8) and object data (v2) are already in the classic formats, and only its map info
is newer (`w3i` v31). If the world and objects have not changed much since r7, a 1.29 map could
use r7's world files plus today's code, and only the *changes* since r7 would need converting.
The next step is to compare r7's object data with r15's.

## Recommended plan

1. **Get a 1.29.2 install to test with.** Without it nothing can be confirmed; every step below
   has to be checked by opening the map in that editor and game.
2. **Compare objects:** compare r7's and r15's object data and terrain. If they are the same or
   close, start from r7's world files.
3. **Write `downgrade.py` in MapToolkit,** one file type at a time, each round-trip tested:
   1. `w3i` 39→28
   2. the trigger files (already possible)
   3. object data v3→v2
   4. `doo` 13→8
   5. `w3e` 12→11
   6. `w3r`/`w3c`
4. **Open in the 1.29 World Editor,** save (this regenerates the script), then run
   `compat_report.py` on that save. It should compile against 1.29.2 with nothing missing.
5. **Play test** the same checklist as Reforged (`PHASE8_TEST_CHECKLIST.md`).

Keep one source of truth: the Reforged map stays the master. The 1.29 version should be produced
from it by the converter on every release, never edited by hand. Otherwise the two drift apart.

## How the script check works

`MapToolkit/tools/version_libs.py` builds `common.j` / `blizzard.j` for any patch from the
jassdoc libraries (`Builder24/reference-libraries`). jassdoc tags every native with the patch that
added it, and the script keeps only what existed in the target patch. pjass then compiles the map
against them. Limits:

- It catches natives that don't exist yet. It does not catch natives whose *behaviour* changed.
- It is only as accurate as jassdoc's patch tags.
