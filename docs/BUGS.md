# Suspected bugs (found while reading the code)

These were spotted while writing the system guides. **None has been confirmed in game.**

To work through one:
1. Try it in game; the developer test commands (`docs/DEBUG_COMMANDS.md`) make that quick.
2. Move it to "Confirmed", or delete it if it isn't a bug.
3. Fix it in its own commit.

## Open

| # | Where | What could go wrong | How to check | Likely fix |
|---|---|---|---|---|
| 1 | `Loot` → `Trig_Loot_MonsterDrop_Actions` (Greed) | Greed picks `udg_LevelItemIdTable[sqrt(level) + 0..2]`. The table ends at 12 (Crystal Shard). A monster of level 121+ gives index 13, which is empty, so nothing drops. From level 100, Greed can drop Crystal Shards, which may not be intended either. | Kill a level 100+ / 121+ unit with Greed. | Cap the index at 11, or 12 if shards are intended. |
| 2 | `Arena_TeamSelection` → `Trig_Arena_Pick_Team_Actions` | A rejected random pick runs the same trigger again (`ConditionalTriggerExecute(GetTriggeringTrigger())`), with no limit. If a cup has very few enabled teams, the chain can get so deep that Warcraft stops the thread and the bracket is left half-filled. | Start a cup that has only a few teams enabled; watch for empty bracket slots. | Replace the recursion with a loop over the eligible teams, then pick one at random. |
| 3 | `Arena_Round_End` and `Arena_FoeDeath` | The Battle Point formula and foe drops exist twice: cups and single battles. A fix applied to one copy and not the other makes them drift apart. | Compare the two functions. | Move the shared part into one helper, e.g. `Arena_BattleReward`. |
| 4 | `Boss_BlackDevil` (and other arena bosses with `DestroyTrigger` in `_Death`) | The death trigger destroys itself after the first win, but `_Summon` adds a new death event to it each time. If the boss can be summoned again, the second kill is never noticed: no reward, and the arena stays locked. | Win against Black Devil, then summon it again if the item allows. | Remove the `DestroyTrigger` line for bosses that can be fought more than once. |
| 5 | `Arena_Start_Cup` | The dialogue mentions a 10 gold fee, but no code charges it. It may be the dummy unit's gold cost in the Object Editor. | Check gold before and after starting a cup. | Nothing, if the Object Editor cost is the fee. |
| 6 | `Save` / `Armory` (save codes) | Items are saved as 9-bit indexes, and `udg_SaveFlagForce[501..540]` is also used for armory stock. An item table past index 500 would collide. Not a bug today (351 items), but a trap for the next developer. | — | Note kept in `SAVE_CODES.md` / `LOOT.md`; add a check that fails above 500. |
| 7 | Unknown (stages M and N) | From the start of the game, in "…r16 stageM" and "…r16 stageN" (Reforged with definitive graphics, and the 1.29.2 builds): the Chemist and the Ninja have a moon-like effect, the Geomancer a red shield-like effect, and Gaya a ground circle with a line. They never go away. Clean: r7, stage L and earlier, QB-D-both (the same playable script as stage M, but without the HM3W map header and with another map name). So far the only differences between QB-D-both and stage M are the map header, the map name and the folder. Test maps D1 (stage N without the header) and D2 (stage L + the quest engine only) are in Download/FFERPG check. | Results: E1 Reforged clean (5 of 5 launches), E1 1.29.2 build always shows it in Reforged, E2 clean. The markers are the game's own (hidden in cutscenes; Gaya and the bird near the start get a ground circle with a line, the Chemist a blue glow), not a buff. Builds from stage O on are the Reforged format with the lazy hashtables. | Open for the 1.29.2-format build only; play the Reforged build. |

## Confirmed

(none yet)

## Fixed

(none yet)
