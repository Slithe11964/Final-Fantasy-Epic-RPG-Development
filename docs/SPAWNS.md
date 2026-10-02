# Spawns: how monsters appear in the world

Modules:

- `Zone` (08): spawn areas and the spawn system.
- `Spawn` (07): monster pools and per-zone numbers.
- `MonsterData` (07): what each monster is and what it drops.
- `Zone1`…`Zone8` (08): zone-specific effects.
- `Wave` (07): story wave spawns.
- `Oversoul`: stronger variants.

All roaming monsters belong to `Player(11)` (Player 12 in GUI).

## The data, all in hashtables

### Spawn areas (`Zone_Rects_Init`)

| Key | Value |
|---|---|
| `udg_SpawnRectHash[zone][1..n]` | The regions (rects) of each zone. |
| `udg_SpawnDataHash[1][0]` | Number of zones (9). |
| `udg_SpawnDataHash[2][zone]` | Number of rects in that zone. |

### Pools and numbers (`Spawn_Pools_Init`)

| Key | Value |
|---|---|
| `udg_SpawnDataHash[3][zone]` | Day monster pool (unit types with weights). |
| `udg_SpawnDataHash[4][zone]` | Night monster pool. |
| `udg_SpawnDataHash[3/4][10]` | Hell pool, used in zone 8 when `udg_HellSpawnsActive`. |
| `udg_SpawnDataHash[5][zone]` | Monsters added each respawn tick. |
| `udg_SpawnDataHash[6][zone]` | Monsters spawned when a player first enters. |
| `udg_SpawnDataHash[7][zone]` | Most monsters alive in the zone at once. |
| `udg_SpawnTimerHash[1][zone]` | Despawn timer. |
| `udg_SpawnTimerHash[3][zone]` | Respawn ("wave") timer. |
| `udg_SpawnTimerHash[5][zone]` | Group of the zone's living spawns. |

### Monster table (`MonsterData_Init_1..4`)

Keyed by unit type, e.g. `'nftr'`:

| Key | Value |
|---|---|
| `udg_MonsterDataHash[type][0]` | `true` = known monster. |
| `udg_MonsterDataHash[type][1]` | Species number. Used by Oversoul kill counts, Chocobo bribing, Dismantle and Steal. |
| `udg_MonsterDataHash[type][2..4]` | Item index for the common, uncommon and rare drop. Converted with `Item_IdFromIndex`. |

Other modules reuse the spawn rects too, through `udg_SpawnRectHashRef` / `udg_SpawnDataHashRef`
(Chocobo digging, Hunt festival).

## How it runs (`Zone_Spawn_System`)

1. **Startup:** every spawn rect becomes a region with one shared "enter" trigger.
2. **Entering a zone** (`OnZoneEntered`): fires when a player hero or another aggressor unit
   enters, and only when spawns are enabled (no cinematic, `udg_SpawnsPaused` off).
   - If the zone is empty, it spawns the "first entry" number of monsters and starts a
     30-second respawn timer.
   - Every entry adds 60 s to the zone's despawn timer, up to 300 s.
3. **Every 30 s** (`ZoneRespawnTick`):
   - Living spawns are sent wandering to a random spot.
   - If fewer than the maximum are alive, "per tick" more are spawned.
4. **Spawning** (`SpawnZoneUnits`): each monster is drawn from the day or night pool, at a
   random point in a random rect of the zone.
   - It is tagged with the zone number (`SetUnitUserData`).
   - Its HP is scaled by handicap (`ScaleSpawnHP`), and to level 60 in Eternity mode.
   - It starts with full mana at night and half mana by day.
5. **Nobody around** (`ZoneDespawn`): when the despawn timer runs out, all of the zone's spawns
   are removed and the respawn timer pauses.

Kills are handled elsewhere: `Loot_MonsterDrop` (drops), `Exp`, `Oversoul`, `Hunt_*`, quests.

## Common changes

- **Add a monster to an area:** add `UnitPoolAddUnitType(l_pool, 'xxxx', weight)` to that
  zone's day and/or night pool in `Spawn_Pools_Init`. Then give it a `MonsterData` entry
  (species and drops); otherwise it drops nothing.
- **More or fewer monsters:** change the `[5]`, `[6]` and `[7]` numbers for the zone.
- **New spawn area in an existing zone:** draw the region in the Region Editor. Add a
  `SaveRectHandle(udg_SpawnRectHash, zone, n+1, gg_rct_...)` line and raise
  `udg_SpawnDataHash[2][zone]`.
- **A new zone:** needs rects, pools, the three numbers, timers (the loop `i<=9` in
  `Spawn_Pools_Init`), and a higher zone count in `udg_SpawnDataHash[1][0]`.
- **Pause spawns for an event:** set `udg_SpawnsPaused=true`, then back to `false` when done.
