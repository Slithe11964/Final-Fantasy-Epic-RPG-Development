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
