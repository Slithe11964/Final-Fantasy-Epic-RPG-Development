# Hunts: bounty contracts, the hunt shop and Oversoul monsters

Modules (folder 07):

- `Hunt`: registration list.
- `Hunt_Board`: setup, hunt table, board markers.
- `Hunt_Contracts`: accepting and completing.
- `Hunt_Encounters`: special set-ups for some targets.
- `Hunt_Rewards`: shard drops.
- `Hunt_Shop`
- `HuntFestival`
- `Oversoul`

## What players do

1. **Accept:** at a hunt board, "buy" a contract (a dummy unit named "Hunt: <target>"). The target
   appears somewhere on the map, a minimap ping shows where, and the "Hunt Club" leaderboard lists
   the active hunts.
2. **Hunt:** kill the target, which gets victory music, gold, experience and maybe an item.
3. **New contracts:** completed hunts unlock more contracts and stock the hunt shop with
   hunter gear.

Separately, monsters of a species you have killed many times can turn **Oversoul**: a much
stronger version with better drops.

## How it works in code

### Hunt table (`Trig_Hunt_Setup_Actions`, 3 s after start; 28 hunts)

All data is in the hashtable `udg_HuntData`. The **hunt number is the contract unit's point
value**. In code, `SaveXxxBJ(value, key, hunt, udg_HuntData)` puts the key before the hunt:

| Key | Meaning |
|---|---|
| 0 | `true` if the hunt has a special set-up trigger |
| 1 | That trigger (in `Hunt_Encounters`, e.g. `Hunt_Thextera_Escort`, Tonberry, Demon, Parvati, Phantom Dancer, Exdeath) |
| 2 | Spawn point (location) |
| 3 | Target unit type, stored as a string (`UnitId2StringBJ`) |
| 4 | Facing |
| 5 / 6 | Gold / experience reward (`Reward_Give`) |
| 7 | Item reward index. **Under 1000 = `udg_ItemIdTable[i]`; 1000–1999 = `udg_DropItemIdTable[i-1000]`** (the opposite of the [loot](LOOT.md) numbering) |
| 8 | Player number of whoever holds the contract (0 = free) |

Other setup values:

- `udg_HuntBoard[1..10]`: the board units.
- `udg_HuntStock[board]`: how many contracts each board has left.
- `udg_HuntSlots`: player slots 11–24, used as leaderboard rows, one per active hunt.

### Accepting (`Trig_Hunt_Accept_Actions`)

The trigger fires on selling any unit whose name starts with "Hunt: ".

1. It takes a free leaderboard slot (nothing happens if none is left).
2. It lowers that board's stock and removes the contract from it.
3. It records the holder (key 8) and spawns the target at key 2/3/4 for Player 12.
   - Non-hero targets also go through `Unit_ScaleToLevel60`.
4. It registers the target's death on `Hunt_Complete` (except hunt 22, which ends differently).
5. It runs the special set-up trigger if there is one.

### Completing (`Trig_Hunt_Complete_Actions`)

- **Bookkeeping:** counts `udg_RareHuntsDone`, frees the leaderboard slot and gives gold/experience.
- **Item reward:** drops the key-7 item.
- **Unlocks:** the first completed hunt adds the "Hunt: Stinger" contract to board 1.

### Hunt shop (`Hunt_Shop_Unlock`, every 10 s)

- **Unlock count:** (common hunts × 2 + rare hunts + 3) / 4.
- **Stock:** that many items from `udg_HuntRewardItem[1..11]` go into the shop `gg_unit_h032_0007`.
  Once everything is in stock, the trigger destroys itself.

### Oversoul (`Oversoul`)

- **Kill counting:** monster kills are counted per species (`udg_SpeciesKillCount[species]`; the
  species comes from `udg_MonsterDataHash[type][1]`, see [SPAWNS.md](SPAWNS.md)).
- **Becoming Oversoul:** when a monster of a species past `udg_OversoulKillsNeeded[species]` is
  attacked, `Oversoul_Activate` turns it into an Oversoul and resets the count:
  - damage ×2.2, +40 armor, HP ×2.5, full life and mana, cooldowns reset;
  - abilities Oversoul `'A134'`, Plentiful `'A0MV'` (always drops), Physical/Magical Hardness,
    Swiftness and Command AI;
  - a blue tint.
- **Drops:** they are better (see [LOOT.md](LOOT.md): the drop moves one rarity up).

## Recipes

**Add a hunt:**

1. **Contract unit:** in the Object Editor, make a dummy unit named "Hunt: <Target>" with point
   value = the new hunt number (29).
2. **Hunt data:** in `Trig_Hunt_Setup_Actions`, add keys 0 and 2–7 for hunt 29 (and 1 if it has a
   set-up trigger).
3. **Board stock:** add the contract to a board's stock where the story should unlock it
   (`AddUnitToStockBJ`), and raise that board's `udg_HuntStock`.

**Change rewards:** keys 5/6/7 of that hunt. The shop items are `udg_HuntRewardItem[]` and the
unlock speed is the formula in `Trig_Hunt_Shop_Unlock_Actions`.

## Gotchas

- **Item numbering:** key 7 uses its own scheme, not `Item_IdFromIndex`'s.
- **Hunt number:** it comes from the contract unit's point value, so a wrong point value spawns
  the wrong monster.
- **Running out of slots:** at most 14 hunts can be active at once (the leaderboard rows 11–24).
- **Special hunts:** hunt 22 has no death hook in `Hunt_Accept`. Its encounter trigger must finish
  it.
