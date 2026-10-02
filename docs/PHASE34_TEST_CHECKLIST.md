# r13 test round (Phases 3–4)

| File | What changed | Expected risk |
|---|---|---|
| `FFERPG_0.9.7.3-r13-phase3.w3x` | Variable declarations moved into the modules that own them (phase 2 + phase 3). | Very low |
| `FFERPG_0.9.7.3-r13-phase4.w3x` | Phase 3, plus trigger registration helpers moved next to their trigger code, legacy spell registration, renamed locals, comments and guide. | Very low; test this one |

Automated proof (`release/checks-phase*.txt`, `tools/refactor/verify_functions.py`):
- Every function outside startup is token-identical to r12test. The only exception is three
  functions whose local variables were renamed, and those are identical after reversing the
  rename.
- The startup audit passes: same statements, same order, same 1,602 triggers, and the event
  firing order is kept.
- The only runtime differences from phase 2:
  - Library variables are now initialised before the map header's. They are moved only when
    their starting value is a constant or a fresh timer, group, etc.
  - `Startup_LegacySpellTriggers` now calls the identical `RegisterLegacy_*` functions in each
    spell module.

## In game (phase4 map, played directly)

1. Start a game: no errors, music, NPCs and units present.
2. Cast the legacy spells: Holy Blast, Bolt, Cure, Blizzaga, Rapid Fire, Shuriken, Tatsumaki and
   Liquid Steel. Fight Verc (Wicked Whirl) or Shinra (Clione) if convenient.
3. Do a quest turn-in or two, including a multi-step quest such as Save Timmy or Shimmerweed.
4. Teleport, Chocobo, fishing, arena entry, `-save`/`-load`, and a native save/load.
5. Multiplayer with 2+ players if possible.

## In World Editor (phase4 map)

1. Open with JassHelper and vJass on. Look at the map header (the developer guide at the top),
   `Quest_SaveTimmy` (its own variables and registration at the bottom), `Quest` (registration
   lists with notes) and `Damage` (CalcDamage step comments).
2. **Save As**. It must compile. This is the first editor save with variables declared inside
   libraries, so it's the important check.
3. Run Build Play Copy on the saved map and play briefly.
