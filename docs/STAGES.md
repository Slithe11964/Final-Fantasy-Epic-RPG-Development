# Stage log: the long autonomous run that started on 2026-10-02

Each stage is saved separately, so it can be checked on its own and undone if needed:

- a Git commit in this repo (or in `../MapToolkit`);
- a map file, if the stage changed the map: `release/FFERPG_0.9.7.3-r16-stage<X>.w3x`;
- its automated check results (`release/checks-r16-stage<X>.txt`).

To undo a stage: open the previous stage's map, or `git revert <commit>`.

Each map in the table includes all earlier stages. A stage with no map changed only docs or
tools, so the newest map listed above it is still current.

| Stage | What | Commit | Map | Status |
|---|---|---|---|---|
| (start) | r15: phases 8–9 | ba47da7 | `FFERPG_0.9.7.3-r15.w3x` | Checks pass; waiting for your play test |
| A | `docs/BUGS.md`: suspected bugs found while writing the guides | see git log | (docs only) | Done |
| B | Developer test commands: module `DevCommands` (folder 11), `docs/DEBUG_COMMANDS.md`; `check_map --allow-new` | see git log | `FFERPG_0.9.7.3-r16-stageB.w3x` | Checks pass (check 6 lists the 2 new triggers). **Needs play test:** type `-dev` in single player |
| C | Save code tool `tools/savecode.py` (decode/encode/selftest), `-dumpitems` dev command, `tools/sync_module.py` (put a changed module into the playable script) | see git log | `FFERPG_0.9.7.3-r16-stageC.w3x` | Selftest passes. **Needs:** run `-dumpitems`, then decode one of your real codes and compare |
| D | Object reference: `tools/objects.py` + `tools/objdata.py` (reads/writes object data, byte-exact round trip) → `docs/OBJECTS.md`, `docs/objects/*.md/csv`, `src/items-guess.json` | see git log | (docs/tools only) | Done |
| E | 1.29.2 converter `MapToolkit/tools/downgrade.py` (terrain, doodads, units, objects, map info, script). First 1.29.2 map built from stage C | see git log | `FFERPG_0.9.7.3-r16-stageE-1.29.2.w3x` (1.29.2 only) | Conversions checked against r7. **Needs:** play test in 1.29.2 (see LEGACY_129.md) |
| F | Quest map: `tools/quest_map.py` → `docs/QUESTS.md` (quest-log entries and links per quest/boss module) + `docs/quest-graph.mmd` | see git log | (docs only) | Done |
| G | System guides: `CHOCOBOS.md`, `GAYA.md`, `SUMMONS_AND_SHADOWS.md`, `CRAFTING.md`, `HUNTS.md` | see git log | (docs only) | Done |
| H | Map list fix: our built maps (since r13) had lost the 512-byte `HM3W` header, so 1.29.2's map list skipped them. New `MapToolkit/tools/add_header.py`; `downgrade.py` now adds the header itself (`--name`). Headers added to r15, r16-stageB/C and stageE (archive contents unchanged) | see git log | same files, re-headed | **Needs:** check the maps now show under Custom Game → Download |
| I | 1.29.2 crash on selecting the map: Reforged had moved all object names/tooltips into `war3map.wts` (37,926 strings, 5 MB) and 1.29.2 crashes reading it (found with test maps: a cut-down wts didn't crash). `downgrade.py` now puts object text back inline (the classic way) and keeps only the 47 strings still used by the script, map info and triggers | see git log | `FFERPG_0.9.7.3-r16-stageI-1.29.2.w3x` (1.29.2 only; replaces stageE) | **Needs:** select it in 1.29.2, then play test (LEGACY_129.md) |
| J | 1.29.2: caster frozen after Fan of Knives. Reforged's editor had dropped ~23,000 object fields it treats as defaults (mostly ability values for levels above the base ability's levels, e.g. Channel's settings for levels 5–11). 1.29 doesn't supply them the same way. `downgrade.py --fill-from <older classic map>` copies them back from r7; object data now matches r7 field for field | see git log | `FFERPG_0.9.7.3-r16-stageJ-1.29.2.w3x` (replaces stageI) | **Needs:** cast Fan of Knives (and other Thief/Channel spells) in 1.29.2 |
| K | Phase 16 tidy-up: shared `udg_Temp*` variables became locals in 509 functions (321 modules), proven private to each function (`tools/refactor/phase16_temps.py`, `verify_phase16.py`); 2 leaks fixed (Trickster Reveal, Demi Fiend summon). Remaining hand-offs listed in `docs/phase16-handoffs.csv`, see `docs/PHASE16.md`. Also `savecode.py checkname`/`rename` (move a code to a new account name; hash checked on a real code) | see git log | `FFERPG_0.9.7.3-r16-stageK.w3x` (Reforged) and `FFERPG_0.9.7.3-r16-stageK-1.29.2.w3x` | All checks pass; the 1.29.2 build loads in 1.29.2. Both builds now have distinct in-game names. **Needs:** a general play test (spells, bosses, quests, arena, save/load), since 509 functions changed |
| L | Built from your editor save (FFETEST = stage K saved in World Editor, DevCommands switched off). Removed 4,029 word-for-word calculation comments on simple lines (`+5`, random rolls, single multiplications); 653 kept on real formulas (`tools/refactor/trim_calc_comments.py`; code tokens unchanged). Only the Trigger Editor text changed, so it plays exactly like your save. Rule added to CONTRIBUTING.md. 1.29.2 builds keep the Game Interface (crystal shard resource icon) again; `check_map` skips triggers disabled in the editor | see git log | `FFERPG_0.9.7.3-r16-stageL.w3x` (edit this one in World Editor) and `FFERPG_0.9.7.3-r16-stageL-1.29.2.w3x` (play in both games) | **Needs:** crystal shard icon back; play test the 1.29.2 file in both games |
