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
