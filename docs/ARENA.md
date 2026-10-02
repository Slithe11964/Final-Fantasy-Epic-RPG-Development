# Battle Arena: cups, battles and Battle Points

Modules: `Arena` (registration lists) and the `Arena_*` modules (07), plus `ArenaExpansion` and
`ArenaResources`.

On the wiki this is the [Battle Arena](https://fferpg.fandom.com/wiki/Battle_Arena), the
Coliseum in the south-west near the Naga Islands. Players fight AI teams in ranked cups or single
battles. They earn Battle Points (BP) and spend them on prizes, experience, gold or Crystal Shards.

## Player flow

1. **Unlock:** `Arena_Unlock` (run by Cid's quest) reveals the organizers. It stocks the first cup
   and prizes, and turns on `Arena_GateOpen` / `Arena_LeoIntro`. Players then open the gate by
   walking into `gg_rct_043`.
2. **Start a cup:** a player "buys" a cup from `udg_ArenaOrganizer[0]`, which runs `Arena_Start_Cup`.
   - The cup number is the sold dummy unit's **point value** (1–10), stored in `udg_ArenaCupId`.
   - Demon needs level 50, Dimension needs level 99, and Chocobo needs a Chocobo in the arena.
3. **Opponents:**
   - `Arena_Pick_Team` fills bracket slots 2–8 (`udg_ArenaBracketSlot`). Each pick is a random
     team that is enabled and tagged for this cup.
   - Some cups end with a special final team: team 7 or 165+streak for Dimension, team 139 for
     the others.
4. **Rounds:**
   - `Arena_Round_Start` spawns the player's opponent through `Arena_Spawn_Team` and starts
     `udg_ArenaRoundTimer`.
   - The round is won when `udg_CupArenaUnits` is empty (`Arena_Round_End`).
   - AI-vs-AI matches are rolled: strength + d20 − 10.
   - **Tournament** has 3 rounds. **Survival** (`Arena_ToggleCupMode`, `udg_ArenaSurvivalMode`)
     has 7.
   - Winning the cup runs `Arena_Cup_Won`. If every player leaves or dies, `Arena_BattleLost` runs.
5. **Out of bounds:** `Arena_OutOfBounds` damages heroes outside `gg_rct_499` every 1.5 s,
   growing each time.
6. **Single battles:** the "battle simulator" organizers 1–6 run `Arena_StartBattle`. The team is
   the sold unit's point value. It ends in `Arena_FoeDeath`.

### Cups

The numbers are inferred from the unlock code. Check `Arena_UnlockCups` before relying on them.

| # | Cup | # | Cup |
|---|---|---|---|
| 1 | Guardia Forest | 6 | Lothlorien |
| 2 | Barrens | 7 | Unique Enemy |
| 3 | Mountains | 8 | Ningen |
| 4 | Island | 9 | Demon (level 50) |
| 5 | Chocobo | 10 | Dimension (level 99) |

**Unlocks:** `Arena_UnlockCups` puts the next cups in stock from `udg_CupWins[cup]` (plus
`udg_ChocoboCupStage` and `udg_CrystalShardCount`). `Arena_SyncTeams` turns teams on and off as
the story progresses.

## Team data (`udg_GameStateHash`)

All arena data is in one hashtable that `Arena_InitData` creates. In code,
`SaveIntegerBJ(value, key, team, hash)` puts the **key before the team**.

- **Totals:** team 0 holds the totals: key 2 = 188 teams, keys 1/3 = 240 unit entries.

**Team T (1–188)**, defined in `Arena_TeamData1/2` and `Arena_Team_Data_A/B`:

| Key | Meaning |
|---|---|
| 1 | Name |
| 2 | 1 = can appear in cups; 2 = special |
| 3 | Organizer that sells this team's single battle once beaten (9 = already stocked) |
| 4 | ≥1 = units get True Sight and count as bosses |
| 5 | Strength: BP reward and AI-vs-AI rolls |
| 6 | Number of units, n |
| 7 … 6+n | Unit entries (number u + 188) |
| 10, 11, … | Cups this team appears in |
| 20 | Leader slot; the others get Perma Cover on the leader |

**Unit entry u + 188** (`Arena_Unit_Data`):

| Key | Meaning |
|---|---|
| 1 | Index into `udg_ArenaMonsterType[]` |
| 2 | Number of items, then 3… = item indexes |
| 9 | Hero level |
| 10 | Number of drops; 9+2i = item, 10+2i = chance % |

## Battle Points

- **Per battle:** (team strength + 2) × 10, reduced the longer the fight takes. Late cups and
  Survival rounds multiply it. Eternity mode adds +60, and title 22 doubles it.
- **Per cup won:** cup × 500 (× 750 in Survival), +5000 in Eternity mode.
- **Storage:** BP is in `udg_BattlePoints[player]`, capped at 999,999.
- **Spending** (`Arena_BuyPrize`): the prize shops sell placeholder items. An item's **life**
  value is its BP price, and its **item level** says which real item (`udg_ItemIdTable`) the
  player gets.
- **Exchanging with Leo** (`Arena_ExchangeBP`): BP → experience 1:1 (Gaya gets a share),
  BP → gold 1:1, or 5000 BP → 1 Crystal Shard.

**BP and cup progress are not in save codes.** Titles 21–24 give the **Arena Conquest**
ability, which restores cup and prize progress in a new game (`Arena_Conquest`).

## The duel arena (`Arena_Duel`)

This is a separate area used by the Shinryu vs Omega fight (`Boss_Shinryu`):

- The two bosses take turns being hostile (`Arena_Duel_AI`).
- When one dies, the other absorbs it and becomes "Shinryu Omega" / "Omega Mk VIII"
  (`Arena_Omega_Absorbs`, `Arena_Shinryu_Absorbs`, `Arena_Duel_Ascend`).
- The arena-summon bosses ([BOSSES.md](BOSSES.md)) use the same area. `Arena_Abandoned_Reset`
  cleans up when everyone leaves.

## Recipes

**Add a team:**
1. Use a free team number, or raise the team count (team 0, key 2). Raising it shifts every
   unit entry number (u + 188), so all of them must move with it.
2. Fill the team keys in `Arena_TeamData*`.
3. For new monsters, add `udg_ArenaMonsterType[]` entries and unit entries in `Arena_Unit_Data`.
4. Set key 2 = 1 and list the cups at key 10+.

**Add a cup:**
1. Make a dummy unit whose point value is the new number.
2. Widen `Trig_Arena_Start_Cup_IsValidCupID` (hard-coded 1–10).
3. Add its unlock to `Arena_UnlockCups`.
4. Add its music and BP tiers in `Arena_Start_Cup`, `Arena_Round_End` and `Arena_Cup_Won`.
5. Tag teams with it.

**Change rewards:** the BP formulas are in `Arena_Round_End`, `Arena_FoeDeath` and `Arena_Cup_Won`.
The prize prices are in the Object Editor (item life and level).

## Gotchas

- **Duplicated code:** cups and single battles have copies of the same code. Change BP or foe
  setup in **both** `Round_End`/`Round_Start` and `FoeDeath`/`StartBattle`.
- **Team picking:** `Arena_Pick_Team` retries by calling itself. A cup with very few eligible
  teams can hit Warcraft's operation limit.
- **Team-picking loop:** `Pick_Team` relies on the caller's `bj_forLoopBIndex` and on shared
  temp variables.
- **Timers:** the arena timers are created in `MapBootstrap`.
