# Backpack and equipment (1.29.2 first)

1.29.2 has no frame UI and no extended inventory native, so gear lives in holder units: a
holder carries six inventory slots and the player's selection switches to it, leaving the
hero's own six slots for potions, books and active items. The same data will drive the
Reforged panel later, so one save code suits both.

## What stage ASG has

| Piece | State |
|---|---|
| `tBag` Backpack button, hotkey B, hero command slot (0,1) | opens the holder |
| `tBhr` Back to hero, on the holder | returns the selection |
| `tBpk` holder unit, six slots, parked out of play | invulnerable, no collision, no food, selectable only by its owner |
| Talents | moved onto the holder's card; the hero's slot (0,1) is now Backpack |
| Picking up an item with full hero slots | goes to the backpack, with a message |
| `-take N` / `-put N` | move one slot either way while the pages are being built |

Objects come from `tools/backpack_catalog.py`, run against the base map before the build,
the same way the Talents button was added.

## Still to build

Equipment pages (weapon, offhand, head, chest, gloves, boots, two rings, trinket), the bag
pages, click to equip, the shared "what is equipped" lookup that the 115 item checks in 46
triggers will use, and stats applied by script. Saving keeps using the legacy system in
1.29.2 until the model is settled; Reforged keeps the new save line unchanged.
