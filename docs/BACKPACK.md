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

## Object data: use only what the map proves

ASG was withdrawn because its holder unit set fields that do not exist (`uspd`) and a real
field with the wrong type (`ussc` as an integer where this map writes a real). Warcraft reads
the object file as a stream, so one bad entry corrupted everything after it: unit tooltips
showed raw text, an inventory item vanished, and the Backpack button drew as a green square
and did nothing. The icon path and the order string were wrong too - an icon the game cannot
find draws green, and `battlestations` is not a no-target order a Channel ability can use.

Every field, type, icon path and order string now comes from one the map already uses, and
`tools/tests/test_backpack_catalog.py` fails the build if that stops being true.

Then ASH's button still did nothing: Channel keeps its order string in a numbered data
column, and the helper wrote it at column 0 instead of the column 6 the working Talents
button uses, which leaves the ability with no order at all. `setf` now treats the data
column as part of a field's identity, and a test compares the new buttons' order column
against the Talents one.

`-bag` opens the holder without using the button, so the two halves can be told apart if
this happens again.

ASI opened nothing and cleared the selection instead: the holder was copied from the map's
casting dummy, whose model is `nothing.mdl`. A unit with no model has nothing for the UI to
select, so `SelectUnit` had nothing to act on while `ClearSelection` had already run. The
holder now carries a real model, drops the summoned classification and is no longer paused.
`-bagwhere` prints what the holder actually is.

A control test settled the last of it: the same selection call takes Gaya but is refused for
the holder, beside the hero as well as in its corner. So the call is fine and the unit was
not selectable. It had been copied from the map's casting dummy, a unit built to be
invisible and unselectable - Locust, no model, no sight, no collision, hero defense type -
and removing two of those traits was not enough. The holder is now built from the stock
footman with eleven fields changed, inheriting none of that.

Because the inventory view only ever shows the selected unit, there is no second grid to
fall back on in 1.29.2. If the game still refuses the holder, the backpack opens as a dialog
listing each stored item with a Take button. Less pleasant than a grid, but it works without
depending on selection at all.

## Still to build

Equipment pages (weapon, offhand, head, chest, gloves, boots, two rings, trinket), the bag
pages, click to equip, the shared "what is equipped" lookup that the 115 item checks in 46
triggers will use, and stats applied by script. Saving keeps using the legacy system in
1.29.2 until the model is settled; Reforged keeps the new save line unchanged.
