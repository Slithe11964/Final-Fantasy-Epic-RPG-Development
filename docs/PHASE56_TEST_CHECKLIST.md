# r13 test round (Phases 5–6)

| File | What changed |
|---|---|
| `FFERPG_0.9.7.3-r13-phase5.w3x` | Quest log help texts moved into the GUI trigger `QuestLog_Entries`. Built on your phase 4 World Editor save. |
| `FFERPG_0.9.7.3-r13-phase6.w3x` | Phase 5, plus modules can be switched off (`static if` guards and optional requires). The compiled script is identical to phase 5. **Test this one.** |

## In game (phase6 map, played directly)
1. Open the quest log (F9). All 19 entries should be there in the usual order, including the
   Difficulty entry, with their full text.
2. Make a **native saved game**, then load it. This is the important check: the help texts no longer
   need Build Play Copy.
3. A quick general pass: start, a quest turn-in, a spell or two.

## In World Editor (phase6 map). This is the important part of this round
1. Open the map with JassHelper and vJass on. In `02 Map setup` you should see a new GUI trigger,
   `QuestLog_Entries`, with 18 "Create Quest" actions. Open one and check the text.
2. **Save As**. It must compile. This is the first save with `static if` / `requires optional`.
3. Play the **saved map directly**, without Build Play Copy. Make a native saved game and load it.
4. Disabling test: untick **Enabled** on the `Healing` trigger (04 Combat and abilities), Save As
   again under another name, and confirm it saves. Then try `Fishing_Casting`. It should fail with
   an error naming `gg_trg_Fishing_Cast`, as `disable_check.py` predicts. Turn both back on afterwards.
