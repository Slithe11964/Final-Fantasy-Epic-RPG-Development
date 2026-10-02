# Loot: what monsters, chests and bosses drop

Modules:

- `Loot` (05): monster drops plus the chest, vault and hut tables.
- `Drop` (05): barrels and crates.
- `Item_Shared` (05): `Item_IdFromIndex` and drop despawning.
- `Armory` and `Bazaar` (05): build the item tables.
- `MonsterData` (07): what each monster drops.
- `Oversoul` (07) and `Steal` (04).

## Item indexes: one number for any item

Drop data stores an **item index**, not an item ID. `Item_IdFromIndex(i)` turns it into the item:

| Index | Table | Filled by | Holds |
|---|---|---|---|
| 1–999 | `udg_DropItemIdTable[i]` | `Bazaar_Init` (3 s after start) | Materials: monster parts, nuts, Marks of Darkness (106 entries, `udg_MaterialTypeCount`). |
| 1000–1999 | `udg_ItemIdTable[i-1000]` | `Armory_Item_List` (2 s) | Equipment, consumables, materia (351 entries, `udg_SaveFlagCount`). |
| 2000–2999 | `udg_LevelItemIdTable[i-2000]` | `MonsterData_Init_1` | Gold coin items 50g … 10000g. 12 = Crystal Shard. Eternity mode swaps in bigger coins. |

Examples: `1007` = `ItemIdTable[7]` (Potion), `2001` = 50 Gold Coins, `23` = Spider Leg.

Save codes store equipment by its `ItemIdTable` position, without the +1000, in **9 bits**
(at most 511). Materials and gold can't be saved. See [SAVE_CODES.md](SAVE_CODES.md).

Watch out: `Hunt_Contracts` uses the *opposite* convention. There, under 1000 means
`ItemIdTable` and 1000+ means `DropItemIdTable`.

## When a monster dies (`Loot_MonsterDrop`)

**Who it applies to:** any Player 12 unit killed by someone, unless it has **Devalued**
(`'A0QY'`). The monster must be registered: `udg_MonsterDataHash[type][0] = true`.

**Does anything drop? (chance out of 20)**
- The base is 4 (20%).
- Bonuses:
  - +4 in Eternity mode
  - +2 when the killer has the Thievery buff `'B04D'`
  - +4 for Treasure Hunter `'A12V'`
  - +2 each for titles `udg_TitleForce[45]` and `[47]`
- The cap is 18 (90%).
- A monster with **Plentiful** (`'A0MV'`) always drops.

**Which drop? (`Trig_Loot_MonsterDrop_PickDropItem`)** A roll of 1–20 picks one of the
monster's three slots:

| Slot (MonsterData key) | Normal | With the zone's Monograph |
|---|---|---|
| 2 = common | 1–13 (65%) | 1–9 (45%), charges doubled |
| 3 = uncommon | 14–18 (25%) | 10–16 (35%) |
| 4 = rare | 19–20 (10%) | 17–20 (20%) |

**Modifiers:**
- **Oversoul** (`'A134'`) on the monster moves the result one slot up.
- **Shard Hunter** (`'A132'`) turns a rare drop into a Crystal Shard.
- **Greed** (`'A131'`) skips the table and drops gold based on the monster's level.

**Despawning:** a dropped *charged* item despawns after 20 minutes unless someone picks it up.
`udg_DropItemHash` holds the timer, and `Loot_CancelDespawn` stops it on pickup. Non-charged
drops never despawn.

The rolls mix the game clock with `udg_DropRollSeed` and `GetRandomInt`, so they aren't plain
random numbers.

## Other drops

- **Chests, vaults, huts, tents, camps:** the `Loot_Drop*`, `Loot_Vault_*`, `Loot_GnollHut_*`,
  `Loot_OrcCamp_*` and `Loot_CentaurTent_*` triggers in `Loot`.
  - They are weighted random tables, written like World Editor item tables
    (`RandomDistAddItem`).
  - Each is tied to one pre-placed unit in `Units` and fires once, when that unit dies or is
    captured.
  - `Drop` does the same for barrels and crates.
- **Bosses:** each boss's own Death trigger creates its items. See [BOSSES.md](BOSSES.md).
- **Steal:** uses the same three MonsterData slots with odds of 70 / 25 / 5%. A robbed monster
  gets Unstealable.

## Recipes

**Give a monster drops.** In `MonsterData`:

```
set udg_MonsterTypeID='xxxx'
set udg_TempInteger=udg_MonsterTypeID
call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)   // without this it never drops
call SaveIntegerBJ(<species>,1,udg_TempInteger,udg_MonsterDataHash)
call SaveIntegerBJ(<common item index>,2,udg_TempInteger,udg_MonsterDataHash)
call SaveIntegerBJ(<uncommon item index>,3,udg_TempInteger,udg_MonsterDataHash)
call SaveIntegerBJ(<rare item index>,4,udg_TempInteger,udg_MonsterDataHash)
```

Index values like `'h'` in that file are just numbers (`'h'` = 104).

**Add a new item:**
- **A material:** add `udg_DropItemIdTable[107]` and raise `udg_MaterialTypeCount`.
- **Equipment or a consumable (saveable):** add `udg_ItemIdTable[352]` and raise
  `udg_SaveFlagCount`.
  - **Always add at the end.** Never reorder existing entries.
  - `udg_SaveFlagCount` also sizes the armory part of save codes. Test old codes before release.
  - Stay below 501.

**Change drop rates:**
- Overall chance: the base 4 and the bonuses in `Trig_Loot_MonsterDrop_Actions`.
- Rarity split: the 13/18 (and 9/16) thresholds in `PickDropItem`.

## Gotchas

- **Read the tables after startup.** They are filled 2–3 seconds after map start, so code
  reading them earlier sees empty tables.
- **`'tkno'` means "no drop".** Don't make a real item with that ID.
- **Steal-only monsters.** A few monsters have drop slots but no `[0]` flag. They can be robbed
  but never drop.
