# Working on FF Epic RPG

A one-page guide for anyone changing the map. For where things are, read `docs/SYSTEMS.md`.

## Set-up (once)

- **Warcraft III Reforged and its World Editor.**
- **JassHelper on:** in the Trigger Editor, open the **JassHelper** menu and tick **Enable JassHelper**
  and **Enable vJass**. The map is vJass: libraries, `globals` blocks and `static if`. Without JassHelper
  it does not compile.
- **Python 3** (any recent version), for the checks in `tools/`.
- **pjass:** `tools/check_map.py` uses it to compile-check the script. Put `pjass.exe` (or `pjass` on
  Linux/macOS) in `tools/bin/` next to `common.j` and `blizzard.j`.
- **Git** (optional, but recommended): it records each change, so a bad one can be undone.

## The routine for every change

1. **Open the newest map** from `release/` in World Editor.
2. **Make the change and Save As** under a new name, for example `FFERPG_0.9.7.3-r16.w3x`. Never overwrite
   the only working copy.
3. **Run the checks:**
   `python tools/check_map.py <your map>.w3x --baseline baseline/<last good map>.w3x`.
   All must say PASS. Check 6 compares startup with the baseline, so expect it to report the
   triggers you added or removed on purpose.
4. **Play test** what you changed, plus a quick save code (`-save`, then `-load` in a new game).
5. **Record it:**
   - `python tools/export_sources.py <your map>.w3x`
   - `git add -A`
   - `git commit -m "what changed"`
6. **When a map is confirmed working,** copy it to `baseline/` so the next change is compared with it.

## Where to put things

| You are adding … | Put it … |
|---|---|
| A trigger for an existing system | In that system's module (one World Editor trigger per module, e.g. `Arena_Rounds`). |
| A new system | A new custom-text trigger in the right folder, starting with `library T<Name>` (no underscores in the library name). |
| A trigger that starts at map start | Create it in a `Register_<Trigger>` function. Add a call to it in that module's `RegisterTriggers_<Module>` function at the bottom of the module. |
| A variable only your module uses | Declare it in the module's `globals` block at its top. |
| A variable several modules share | Add it in the Variable Editor (Ctrl+B), in the matching "Shared variables" sub-folder. |
| Long text (quest log, help, dialogue over ~1000 characters) | Use GUI actions (string table), not custom script. Very long script strings break loading saved games. |
| A new spell | Copy a small `Spell_*` module. |
| A new boss | Copy a small `Boss_*` module. See `docs/BOSSES.md`. |

## Naming conventions

- **Modules:** a module `Foo` is the trigger `Foo` with `library TFoo`. Its triggers are `gg_trg_Foo_*`
  and its functions are `Trig_Foo_*`.
- **Startup helpers:** `Register_<Trigger>` creates one trigger: its events, conditions and actions.
  `RegisterTriggers_<Module>` lists them in startup order.
- **Variables:** shared variables use the `udg_` prefix in code. The Variable Editor shows them
  without the prefix.
- **Object IDs:** add the object's name as a comment, e.g. `'A0B3' // 'A0B3': ability "Cover"`.

## Things that break easily

- **Save codes:** don't reorder `udg_JobUnitType`, the item table, or anything `Save_WriteCode` writes.
  Read `docs/SAVE_CODES.md` first.
- **Calling another module:** a module that calls into another needs `requires T<Other>`, or
  `requires optional T<Other>` with a `static if LIBRARY_T<Other>` guard. Then that module can be
  switched off (`docs/DISABLING.md`).
- **The damage formula:** it lives in `Damage`, as `Trig_Damage_Engine_Step01_Setup` …
  `Step19_Apply`. Keep a hit's values in the `DmgCtx_*` arrays (slot `c`), never in plain globals.
  Hits can nest.
- **Player numbers:** `Player(0)`–`Player(7)` are the humans, `Player(8)` holds the town NPCs, and
  `Player(11)` is the enemy.

## Helpful tools

| Command | Use it to |
|---|---|
| `python tools/disable_check.py MAP Module` | Check whether a module can be switched off. |
| `python tools/gen_docs.py` | Refresh `docs/TRIGGER_INDEX.md`, `GLOBALS.md` and `DEAD_CODE.md` after changes. |
| `python tools/rename_module.py BASE OUT Old New` | Rename a module everywhere. |
