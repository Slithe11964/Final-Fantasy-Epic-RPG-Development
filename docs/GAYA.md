# Spirit of Gaya: the companion every player has

Modules (folder 04):

- `Gaya`: start-up registration list.
- `Gaya_Shared`: `Gaya_RecreateSpirit`.
- `Gaya_Movement`: follow, house portal.
- `Gaya_Orders`: using items from Gaya's bag.
- `Gaya_Inventory`: shop purchases, item gathering.
- `Gaya_Support`: Break Stun, Mana Transfer, Mega Heal.
- `Gaya_Channeling`
- `Gaya_Scan`
- `Gaya_Stats`
- `Gaya_Appearance`: tint.

## What players see

- **Following:** each player has a Spirit of Gaya (unit `'H01D'`, `udg_SpiritOfGaya[player number]`)
  that follows the hero.
- **Spare bag:** it carries 6 items, and the hero can use them from Gaya's inventory.
- **Scan:** shows a unit's HP/MP, species, accuracy/evasion, elements and weaknesses. Cast on an
  item, it sends the item to the player's house.
- **Support spells:** bought from the Pandaren Spiritualist; see the table below.
- **Spiritual Power:** comes from Tarugaya / Sukugaya / Rakugaya.
- **Levelling:** Gaya levels up (`udg_SecondaryXPRate`; arena BP can be exchanged for Gaya experience).
- **Saving:** its level, inventory and abilities are in the save code (see
  [SAVE_CODES.md](SAVE_CODES.md)).

## How it works in code

| Feature | Where | How |
|---|---|---|
| Can't die | `Gaya_Stats` (`Gaya_RefreshStats`) | Every second (`udg_LoadRefreshTimer`) Gaya is set to 1,000,000 max HP/mana, its life to 990,000, and its buffs are cleared. Gaya is effectively immortal; its mana stays topped up. |
| Follow | `Gaya_Movement` (`Gaya_Follow`, every 1 s, starts off) | If Gaya is 384+ away from the hero, or from the transport the hero is in (`udg_PlayerTransport`), it is moved next to them. |
| House portal | `Gaya_HousePortal` | Spell cast to travel to the player's house (`udg_PlayerHouse`). |
| Item use | `Gaya_Orders` | Orders 852008–852013 (the six inventory slots) on Gaya call `Item_UseFromOtherUnit(gaya, slot, 0/1/2)` (no target / point / unit). |
| Shop | `Gaya_Inventory` (`Gaya_ShopPurchase`) | The items Break Stun `'I007'`, Mana Transfer `'I008'` and Mega Heal unlock a tech the first time (`'Resi'`, `'R00F'`, `'R00G'`), then raise the matching ability up to level 3. Buying past level 3 refunds 1500 gold + 1 shard. |
| Gathering | `Gaya_GatherItems` | Collects items around Gaya into the player's house. |
| Busy flag | `Gaya_Channeling` | `udg_GayaReady[player]` is false while Gaya channels a spell. |
| Support spells | `Gaya_Support` | Break Stun `'A0B4'` removes stun/freeze/daze/sleep buffs from the hero. Mana Transfer `'A02K'` gives the hero (level+1)×50 mana. Mega Heal `'A02L'` heals the hero. |
| Scan | `Gaya_Scan` (650 lines, mostly text) | Prints unit info. Species comes from `udg_MonsterDataHash[type][1]` (see [SPAWNS.md](SPAWNS.md)), elements from `Element_SetFromUnit`, accuracy/evasion from the damage engine. |
| Rebuild | `Gaya_RecreateSpirit` (`Gaya_Shared`) | Makes a fresh Gaya. It copies mana, experience, items, the Chronicle ability levels (`udg_ChronicleAbility[1..11]`), Spirit Blessing, MP Regeneration, the three support abilities and the -gaya spells (Tarugaya +1, Sukugaya +2, Rakugaya +4 Spiritual Power levels). Used when a job hero is created (`Job_GetHero`). |

## Common changes

| Change | Where |
|---|---|
| New Gaya ability | Add it in `Gaya_ShopPurchase` (buy/level rules) and in `Gaya_RecreateSpirit` (or it's lost when Gaya is rebuilt). For it to survive save codes, add it to `Save_WriteCode` and the loader too ([SAVE_CODES.md](SAVE_CODES.md)). |
| Follow distance | The `384` in `Trig_Gaya_Follow_MoveGayaToHero`. |
| Mana Transfer amount | `(abilityLevel+1)*50` in `Trig_Gaya_ManaTransfer_Actions`. |
| Scan text | `Trig_Gaya_Scan_Actions`. |

## Gotchas

- **Gaya has no real HP.** The refresh sets huge HP every second. Anything that reads Gaya's HP
  (damage meters, Scan of Gaya) sees these numbers.
- **Unit type in code:** several triggers recognise Gaya by its unit type `'H01D'`. A different
  Gaya model must be a skin, not a new unit type.
- **Rebuilding:** any new state on Gaya must also be copied in `Gaya_RecreateSpirit`.
- **Variables:** `udg_SpiritOfGaya` and the other per-player arrays are indexed by player
  number (1–8), not player id (0–7).
