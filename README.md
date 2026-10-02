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
2. Make your changes and **Save As** a new file name. The saved map is directly playable.
3. Run the automated checks on it:
   `python tools/check_map.py <saved map>.w3x --baseline baseline/FFERPG_0.9.7.3-r14.w3x`
4. Test in game.
5. Optional: **Build Play Copy** in `WarcraftMapExtractor` (`dotnet run`) runs extra checks,
   such as neutral unit ownership, and produces a separate copy. It is no longer needed for
   saved games to load, because the long help texts now live in the GUI trigger `QuestLog_Entries`.
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

## Switching systems off

Untick **Enabled** on a module in the Trigger Editor to leave it out of the map. Startup skips
it automatically. Before you do, run
`python tools/disable_check.py <map>.w3x <Module> [<Module> ...]`: it says whether other code
still needs the module. `docs/DISABLING.md` lists the answer for every module on its own.

## Tools

| Command | Purpose |
|---|---|
| `python tools/check_map.py MAP [--baseline MAP]` | All automated checks (compile, startup wiring, text safety, startup audit). |
| `python tools/startup_audit.py OLD NEW` | Proves NEW's startup does the same work as OLD's. |
| `python tools/export_sources.py MAP` | Map → `src/` (for Git). |
| `python tools/build_map.py BASE OUT [--runtime war3map.j]` | `src/` → map (for tool-driven refactors). |
| `python tools/disable_check.py MAP MODULE...` | Can these modules be switched off? (`--all` regenerates `docs/DISABLING.md`.) |
| `python tools/gen_docs.py` | Regenerates `docs/TRIGGER_INDEX.md`, `GLOBALS.md` and `DEAD_CODE.md` from `src/`. |

`check_map.py` needs `pjass`, `common.j` and `blizzard.j`. It finds them in `tools/bin/` or in
`../Builder24/tools/JassHelper/`; on Windows that's the bundled `pjass.exe`.
