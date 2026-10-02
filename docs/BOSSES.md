# Bosses: how boss fights are built

Modules:

- `Boss` (04): only the startup registration lists.
- `Boss_*` (04): one module per boss.
- `Boss_Defeat` (04): the shared victory announcement.
- `Boss_Drop` (04): three standalone drops.
- `Summon_Items` (04): summoning bosses in the duel arena.

**There is no central boss framework.** Each boss is a handful of event triggers that follow
the same pattern. To make a new boss, copy a similar one.

## How a boss fight starts

| Style | How | Examples |
|---|---|---|
| **Story boss, pre-placed** | A quest enables the boss's `_Intro` trigger. It fires when a hero comes in range (or selects the boss), plays a scene, unpauses the boss, removes its invulnerability, and turns on its `_Death` trigger. | Agrias, Zalera, Hashmalum, Odin |
| **Story boss, created by a quest** | The quest module creates the unit and adds the range and death events to the boss's triggers at runtime. | Gafgarion (`Quest_DarkKnight`) |
| **Arena summon** | The player drops a summon item in the duel arena (`gg_rct_472`). `Summon_Items` runs that boss's `_Summon` trigger. | Penance, Gilgamesh, Judges, Black Devil, Demi Fiend, Dark Fact, Shinryu/Omega, Ozma |

## How bosses fight

Most spells are cast by the unit's own AI (Object Editor abilities). Triggers add the special
mechanics:

- **Timers:** `Boss_Odin_Escort_AI` (10 s), `Boss_Ozma_Barrier` (1 s),
  `Boss_Penance_Judgment_Loop` (2 s). The Judges re-arm `udg_JudgeTimer[1..4]`.
- **Spell events:** `Boss_Judge_ImperialRage` and `Boss_Penance_JudgmentDay_*` react to casts.
- **Damage events:** `Boss_DemiFiend_Mediarahan`, `Boss_Mateus_CoverSwap`.
- **Health thresholds:** e.g. `Boss_Judges_UseMegalixir` below 10,000 HP.
- **Phases:** a boss's `_Death` trigger enables the next form's trigger (Agrias → Lilith), or
  revive loops run while a story stage holds (Belias, Hashmalum, Mateus with `udg_ZaleraStage`).

## When a boss dies

A typical `Boss_X_Death` does, in order:

1. Disables itself. In Speedrun mode it records the time (`gg_trg_Speedrun_Accolade`).
2. Sets `udg_BossDefeated[n]`. Other systems read it: Echele's form, `Monstrum`, `ChocoboRider`.
3. Plays the fanfare and shows "X was defeated".
4. Removes the unit from `udg_BossUnits` / `udg_BossGroup`.
5. Plays a cutscene, or, with cinematics off, gives the reward directly with `Reward_Give`.
6. **Drops items:** hard-coded `CreateItemLoc` calls, usually including a Crystal Shard
   (`'I01Z'`). Some drops scale with the number of players (Odin: one Sleipnir per player).
7. Completes the quest (`QuestSetCompletedBJ`, `udg_QuestsCompleted`, World Liberation count).
   Some bosses grant a title (`gg_trg_Title_Grant`), which **is saved in the code**.
8. Destroys itself.

`Boss_Defeat_Announce` only plays the fanfare and message for 21 specific pre-placed bosses.

## Difficulty and scaling

- **Story bosses** belong to Player 12. That player's handicap, `udg_EnemyHandicap`, is the sum of
  `udg_EnemyHpPerPlayer` over the players in the game. The vote and leaving players change it.
- **Arena summons** scale with the heroes *in the arena*:
  `BlzSetUnitMaxHP(boss, maxHP * udg_EnemyHandicap)`.
- **Eternity mode** isn't checked by any boss module. It changes things globally: enemy attack
  speed, level-60 scaling, rewards.

## Recipe: a new arena-summon boss

1. **Copy the module:** copy `Boss_BlackDevil` (small) to `Boss_NewBoss`. Rename the library
   (`TBossNewBoss`), the `gg_trg_Boss_BlackDevil_*` variables, the `Trig_`/`Register_` functions
   and `udg_BlackDevilUnit`.
2. **Change the details:** set the unit ID, level, items, music track and hint ability.
3. **Register it:** in `Boss`, add `optional TBossNewBoss` to `requires`. Add a
   `static if LIBRARY_TBossNewBoss` block calling its `Register_*` functions. `Part12` holds the
   other arena bosses.
4. **Hook the summon item:** in `Summon_Items`, add the item to `IsSummonItem` and add a branch
   that runs `gg_trg_Boss_NewBoss_Summon`.
5. **Drops:** edit the `CreateItemLoc` calls in the boss's `_Death` trigger.

For a story boss, copy `Boss_Ultima` (death only) or `Boss_Agrias` (intro + death). Then have
the quest enable it.

## Gotchas

- **`udg_BossGroup` changes gameplay.** Units in it are dazed instead of stunned (`Knock`,
  `Armor`, `Damage`). Always remove the boss on death and in cleanup.
- **Two boss groups:** `udg_BossUnits` is a different group, the minimap ping list.
- **Arena cleanup:** an arena summon must set `udg_BossCleanupTrigger` **first** in `_Summon`.
  Otherwise, leaving the arena runs the previous boss's cleanup.
- **An arena victory must reset the arena:**
  - remove `udg_SummonItem`;
  - set `udg_RingHintsReady`;
  - give `'Ane2'` back to `gg_unit_n03T_0008`;
  - reopen the waygate if `udg_HolyAnkhUsed`.

  Otherwise the arena stays locked.
- **Re-summonable bosses:** `_Death` triggers destroy themselves. Don't copy that line if the
  boss should be fightable again.
- **Map-wide flags:** some deaths set `udg_GameStateHash` flags (e.g. Chaos). Those last for the
  current game only; titles are what save codes keep.
