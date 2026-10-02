# FF Epic RPG — developer workspace

This folder holds everything a developer needs to keep working on **Final Fantasy Epic RPG**
(a Warcraft III Reforged map) in the World Editor.

| Folder | What's in it |
|---|---|
| `release/` | Map files ready to test. Not tracked by Git. |
| `baseline/` | The last map confirmed to play correctly, for comparisons. Not tracked by Git. |
| `src/` | The map's trigger code exported as text, one file per World Editor trigger, in the same 10 folders. This is what Git tracks and diffs. |
| `tools/` | Python scripts: export, build, automated checks. |
| `docs/` | How the map's code is organised (`STARTUP.md`), the cleanup plan, test checklists. |

The **World Editor map is the source of truth**. `src/` is a text mirror of it, so changes can
be reviewed, diffed and reverted with Git.

## Everyday workflow

1. Open the map from `release/` in World Editor. Keep **JassHelper** and **vJass** enabled
   (Trigger Editor menu).
2. Make your changes and **Save As** a new file name.
3. Build a playable copy. Run `WarcraftMapExtractor` (`dotnet run`), open the
   **Build Play Copy** tab and pick your saved map. This moves long quest-log text into the
   map's string table. Without this step, loading a Warcraft *saved game* crashes. Always
   play the Build Play Copy output, never the editor save itself.
4. Run the automated checks on the play copy:
   `python tools/check_map.py release/<play copy>.w3x --baseline baseline/FFERPG_0.9.7.3-r12test.w3x`
5. Test in game.
6. Record the change in Git:
   `python tools/export_sources.py <your saved map>.w3x`, then `git add -A` and `git commit`.

## Where things are in the code

Start with `docs/SYSTEMS.md`, a folder-by-folder guide. The top of the map header in the
Trigger Editor has a short version of it.

- Startup is described in `docs/STARTUP.md`. Short version: `main_old` (in
  `10 Startup coordinator/MapBootstrap`) runs 11 named `Startup_*` steps.
- To find where a trigger is created, search for `Register_<TriggerName>`. It sits in the
  same module as the trigger's code.
- A module's own variables are in the `globals` block at its top. Shared variables are in the
  map header, grouped by the folders that use them. `docs/GLOBALS.md` lists them all.
- Object IDs such as `'A0B3'` carry a comment with the object's name. Formulas carry comments
  explaining the math.

## Tools

| Command | Purpose |
|---|---|
| `python tools/check_map.py MAP [--baseline MAP]` | All automated checks (compile, startup wiring, text safety, startup audit). |
| `python tools/startup_audit.py OLD NEW` | Proves NEW's startup does the same work as OLD's. |
| `python tools/export_sources.py MAP` | Map → `src/` (for Git). |
| `python tools/build_map.py BASE OUT [--runtime war3map.j]` | `src/` → map (for tool-driven refactors). |
| `python tools/gen_docs.py` | Regenerates `docs/TRIGGER_INDEX.md`, `GLOBALS.md` and `DEAD_CODE.md` from `src/`. |

`check_map.py` needs `pjass`, `common.j` and `blizzard.j`. It finds them in `tools/bin/` or in
`../Builder24/tools/JassHelper/`; on Windows that's the bundled `pjass.exe`.
