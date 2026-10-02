# r13 test round (Phases 0–2)

## Maps

| File | What changed | Expected risk |
|---|---|---|
| `FFERPG_0.9.7.3-r13-phase1.w3x` | Trigger-editor text formatting only. The playable script is byte-identical to r12test. | None in game. Only the editor view differs. |
| `FFERPG_0.9.7.3-r13-phase2.w3x` | New startup structure. See `docs/STARTUP.md`. | Low. All automated checks pass, but startup now runs differently. |

`release/checks-*.txt` hold the automated results. Every check passed for both maps, including
the startup audit. In short: every startup statement runs in the same order as r12test, every
trigger is created with exactly the same events, conditions and actions, and triggers that
share an event keep their original firing order.

What **did** change at runtime in phase 2:
- A module's triggers are now created in one thread per module, or per part. Before, each
  trigger had its own thread.
- Unrelated triggers are created in a different relative order: 3,865 pairs that share no
  event and no trigger variable.
- `main_old`'s code moved into 11 step functions. Same statements, same order.

## In-game checks (phase2 map, play it directly)

1. **Startup:** start a game. No error messages, music plays, NPCs and units are present, and
   there are no duplicated units or barrels.
2. **Character:** choose a hero/job, move, fight, level, use items, buy from a vendor, change
   job at a shrine.
3. **Spells:** cast several job spells, especially Holy/Bolt/Cure/Blizzaga/Rapid Fire/Shuriken
   (the legacy spell triggers), and a summon.
4. **Quests:** an early quest turn-in, Shimmerweed, Cid/Mid, and the Agrias/Holy Knight marker.
5. **Travel:** teleport, then check the camera position.
6. **Chocobo:** tame, dig, evolve.
7. **Damage text:** `-damagetext off/on`.
8. **Barrels/crates:** break a few. They should drop loot.
9. **Arena:** enter, fight a round, check the results.
10. **Saving:** `-save` and `-load` codes, then a native Warcraft save + load of the same game.
11. **Multiplayer:** 2+ players, through to at least one boss fight.

## In World Editor (phase2 map)

1. Open the map with JassHelper and vJass enabled. Look at `10 Startup coordinator/MapBootstrap`
   and a few modules.
2. **Save As** a new name. It should save with no compile errors.
3. Run **Build Play Copy** on the saved map, then play that output briefly. This confirms the
   editor-compiled version also works.
   - If you rebuilt the WarcraftMapExtractor app (`dotnet build`), Build Play Copy checks the
     new `Register_*` / `RegisterTriggers_*` names. An older build still works; it only
     reports "0 registration dispatches checked".

## If something breaks

Note the map name, what you did, what happened, and any error text or crash file from
`Documents/Warcraft III/Errors`. The phase1 map is the fallback: its gameplay is identical to
r12test.
