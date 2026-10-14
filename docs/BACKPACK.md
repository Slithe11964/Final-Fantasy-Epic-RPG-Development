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

## Confirmed working in 1.29.2 (stage ASM)

The Backpack button opens the holder, its six inventory slots show, and the Talents button
on the holder's card works. So a second inventory really is reachable in 1.29.2 through a
holder unit, and the dialog fallback stays unused for now - worth keeping, since it costs
nothing and covers a client that refuses the selection.

Open and cosmetic: the holder's command card still shows buttons inherited from the footman
it is built from, and one slot draws as a red question mark. `BTNSelectHeroOn` is not the
cause - the map uses that icon 283 times elsewhere - so it is most likely the Invulnerable
ability, which has no command icon. The holder's ability list wants trimming to just
Inventory, Back to hero and Talents.

Note on the icon test: it checks that an icon path appears somewhere in the map, which does
not prove the file exists. A path used hundreds of times is good evidence; a path used once
is not.

## Pages (stage ASQ)

Seven holders per player, one per page, each with its own six slots:

| Page | Holds |
|---|---|
| 1 | Weapon, offhand, head, chest, gloves, boots |
| 2 | Ring, ring, trinket |
| 3 to 7 | The thirty-slot bag |

Next page and Previous page sit on every holder's card and wrap around. A picked-up item
always lands on a bag page, never in an equipment slot.

## Standing beside the hero (stage ASR)

The holder used to wait in the map's corner, which quietly broke three things at once: an
inventory drops an item at the unit holding it, so items dropped from the backpack landed in
the corner; an item can only be dragged between two units standing close together, so nothing
could move between hero and holder; and with no way to move items at all, the equipment slots
could not be used.

The open page's holder now stands 96 units from the hero and follows it once a second, and the
other pages stay hidden where they are, so six wisps do not gather around the hero. Closing the
backpack hides the holder again. `-grab` takes the nearest loose item into the page being looked
at, which is how an item moves between pages: drop it, turn the page, grab it.

## Equipment pages (stage ASS)

`tools/gear_slots.py` generates `GearSlots.j` from the map's own object data: each armory item's
category comes from its armory unit's point-value field, exactly as the reviewed Forsaken gear
work classified all 276 equipment items, and the loose categories split by name. It writes two
things per item: the slot kind, and the item's passive abilities.

| Page | Holds | Rule |
|---|---|---|
| 1 | Weapon, offhand, helm, chest, gloves, boots | one of each kind |
| 2 | Ring, ring, trinket | two rings, one trinket |
| 3 to 7 | The bag | no rules |

An item arriving on an equipment page is checked: anything that is not equipment, belongs on the
other equipment page, or doubles up on a piece already worn goes to the bag with a message
saying why. Position within the page does not matter, so no slot has to be kept clear.

Worn gear is carried by the holder, and in 1.29.2 an item's abilities only work on the unit
carrying it, so the hero is granted each worn item's passive bonuses by script - 760 bonuses
across 274 of the 276 items. Active item abilities are left alone: they need the item in hand.
A bonus the hero already has from elsewhere is not granted, and so is never taken away either.
A job change or a load replaces the hero unit, so the bonuses are granted again to whoever the
hero is then.

`-gear` lists what is worn and how many bonuses that comes to.

## On the hero, invisible, and the same size as Reforged (stage ASU)

The holder now stands exactly where the hero stands, set with `SetUnitX`/`SetUnitY` rather
than `SetUnitPosition`, which would shift it to the nearest free spot. It is fully
transparent (`SetUnitVertexColor` with zero alpha), so there is no second unit to look at or
click by accident, and it keeps its model and so stays selectable - selection is what shows
its six slots. Standing on the hero rather than beside it also means items are equally in
reach in every direction.

While a page is open, anything the hero picks up lands on that page, which is what `-grab`
did by hand. `-grab` stays for an item already lying on the ground. With the page closed,
pickups behave as they always did: the hero's own slots, then a bag page when those are full.

Page buttons answered late or not at all. The holder is built from the footman, which brings a
third of a second of cast animation and an attack: a holder that goes hunting is busy fighting
when the button is clicked. It now has no attacks, no acquisition range and no cast point.

| Slots | Reforged | 1.29.2 |
|---|---|---|
| Quick slots on the hero | 6 | 6 |
| Equipment | 9 | 6 on page 1 + 3 on page 2 |
| Bag | 30 | 5 pages of 6 |

Page 2 has six slots like any unit inventory, so its three surplus slots are filled with the
map's own `I0ZB` "Fix slot filler", an item that cannot be dropped, moved out or sold. Both
versions therefore offer exactly the same amount of space.

## What the first play of the pages found (stage ASV)

Three things came out of playing ASU, and each had a cause worth writing down.

The wisp stayed where it was while the backpack worked from the hero's feet. ASU moved the
holder with `SetUnitX`/`SetUnitY`, and a unit whose movement type is none keeps its model
where it was when only its coordinates are set. `SetUnitPosition` moves the unit itself, so
it is back.

Zero vertex alpha did not hide the wisp: its model glows whatever its alpha says. The holder
is now scaled to a hundredth as well, which is invisible whatever the model does.

A tome bought from the armory crashed 1.29.2. A power-up is used up the instant it is picked
up, so by the time the pickup event runs the item is gone, and the backpack was moving it
into the open page. Power-ups are now left alone everywhere: on pickup, when storing and in
the ground search.

The blocked slots wore the icon of the item the map's filler was built from, which read as a
gem sitting in the slot. They now use `tBlk` "Locked slot", the same immovable item with a red
cancel icon and a tooltip saying why it is there. 1.29.2 cannot remove an inventory slot, so
blocking it is as close as the version allows.

## Two defects behind the crashes (stage ASW)

**Every field was written twice.** A unit or item entry carries no level or data numbers, so
it reads back as `None` where an ability entry reads `0`; the helper that replaces a field
compared the two as different, kept the old entry and appended a new one. The game reads the
first, which is why the blocked slot still called itself "Fix slot filler" under its new
tooltip, and why the holder had fourteen duplicated fields after two runs. The helper now
compares them as equal and writes back in the shape the table uses, and every object this
script owns is de-duplicated on the way through. A test fails the build if any of them writes
a field twice.

**Moving an item inside the event that announced it crashes 1.29.2.** Picking something up
with a page open had the backpack take the item out of the hero and hand it to the holder
while the game was still in the middle of the pickup. Power-ups made it certain, because the
item is destroyed by then, but it was never safe for anything. Every item move now waits for
a zero-second timer and runs outside the event: what the hero picked up goes to the open page,
then the equipment pages are checked and the worn bonuses granted.

The wisp also had to go. Zero alpha does not hide a model that glows, and scaling it down left
its sparkle on the hero. The holder now uses the footman model it is built from - plain
geometry, which transparency does hide.

## Bonuses off the command card (stage ASX)

Granting a worn item's passives to the hero broke the hero's own card: an ability added to a
unit takes a command-card button, and these abilities inherit their position from the stock
ability they are built on, so a bonus landed on top of a job button. The job showed its
abilities for a moment, then a granted bonus replaced one and the card read "Tool tip
missing!" over an evasion with no value.

A button position outside the card is not drawn, so `tools/gear_catalog.py` moves all 430
abilities the backpack can grant to (0, -11) in both ability tables. Items are unaffected -
an item in an inventory never used the command card - and these are all passive bonuses, so
nothing that needed clicking has moved.

The Backpack button also wears a loot sack now instead of a book. The icons this map can show
hold no purpose-made bag; `BTNSalamanderLoot` is the closest.

## Quick slots, mana and shared cooldowns (stage ASY)

**The hero's six slots are carrying space.** The map's one-of-each equip rules only ever
policed those slots, and they stand down whenever the backpack is present, so anything can sit
there. Nothing worn there pays out either: an item gives its abilities to whoever holds it, so
the passives of gear in a quick slot are taken off the hero again on every backpack pass. What
an item *casts* is left alone, so a wand or a materia in a quick slot still works, and a bonus
the worn gear is granting stays.

**Items cast from a page spend the hero's mana.** An item casts from whoever carries it, so a
wand on a bag page was spending the holder's pool. The holder has a pool it never spends on
its own and is given the hero's mana whenever a page opens or turns; what a cast took out is
then taken off the hero. The engine still refuses a cast the hero cannot pay for, because the
mirrored pool is what it checks.

**One cooldown for gear, one for consumables.** The map already shares a timer between
consumables, started when the hero casts one; a page casting one now starts the same timer,
and gear that casts shares a timer of its own. 1.29.2 cannot start a cooldown on another
unit's ability, so both are enforced the way the map already refuses a talentless Cure: the
cast is stopped as it starts and the player is told how long is left.

## Classic water casts and page-wide cooldowns (stage ATC)

Wateraga Materia and Book of Depths now cast through an active, transparent proxy
rather than hiding the proxy before issuing its water-wave order. A page cast uses
the real hero for damage attribution, Intelligence and rod proficiency.

Books, buff tomes, materia and magical weapons share one player-wide timer; food
and potions share another. Both cover the hero's slots and every equipment/bag page.
The used item's actual cooldown starts the pool immediately; deferred readback
confirms it without shortening an existing timer. Consuming the last charge uses
the client's first ability-level index if the item ability has already disappeared.
Item orders and channel starts refuse an early use before its effect or charge.

In 1.29.2, test each water item from the hero and a bag page. After casting a book,
try a wand or buff tome on another page; after food, try a potion on another page.
Only its own group should be blocked, using the first item's cooldown. Also check
last-charge use, no mana/charge loss on refusal, and independent players in a lobby.

## Scripted water wave (stage ATE)

Cross-page magic and consumable cooldowns are confirmed in 1.29.2. ATD showed a
real water item effect but every native proxy order was rejected, including stock.
ATE adapts the Forsaken scripted wave with a classic unit-attached moving effect:
800 travel, widening from 100 to 300 radius, and one water-magic hit per enemy.
Mana cost, Intelligence and rod power retain the original damage formula; backpack
casts use the hero, while hero and Gaya casts retain their own source.

Test Wateraga Materia and Book of Depths from hero, backpack and Gaya at ground
and enemies: check visible travel and damage through a group. `-watercheck` shows
cast/wave/hit activity and launches one visual-only wave. Timers, carrier, effects
and hit groups are released when a wave ends; the confirmed cooldowns are unchanged.

## Pickup equips missing gear (stage ATF)

A real pickup fills an empty matching equipment kind before regular bag routing:
weapon/offhand/helm/chest/gloves/boots on Equipment, two rings and one trinket on
the second equipment page. Occupied kinds are never replaced. This works from the
hero or an open bag holder, including dropping loaded gear and picking it up again.
Moves wait until the pickup event ends, keep the original handles and charges, and
refresh worn bonuses. Internal storage moves and `-take` do not auto-equip again;
`-grab` also prefers an empty matching equipment kind.

Check Book of Depths, chest, helmet, trinket and weapon pickups with empty gear
slots, then pick up duplicates and verify existing gear stays equipped.
Water wave visibility/damage and shared cooldowns are confirmed in 1.29.2.

## Item checks see the backpack (stage ATH)

A player's hero carries its six quick slots and all seven pages, but wears only the two equipment
pages; quick slots and the bag give no bonus. Item checks across the map follow that:

| Use | Function | Where |
|---|---|---|
| Having an item: quests, keys, hand-ins, Holy Ankh, monographs | `Gear_HasCarried` / `Gear_Carried` | hero slots and every page |
| Wearing gear: magic defense, Lion Heart, cursed gear dropped on death or revive | `Gear_Wears` / `Gear_WornOfType` | equipment pages |
| Loops over worn gear: proficiency, weapon damage, two-handed, bare-handed (Striker) | `Gear_WornInSlot(u,i)` to `GEAR_WORN_SLOTS` | equipment pages |
| Taking worn or carried gear off | `Gear_DropFrom` | wherever it is; bonuses refresh |

Any other unit (Gaya, bosses, a page holder) still uses its own six slots. The automatic potion
drinks only from the hero's own slots, and boss scripts keep the native lookups.
`tools/tests/test_gear_queries.py` fails if a new check skips the backpack.

Check: a quest item handed in from a bag page, magic defense and proficiency from worn gear
(and none from the same gear in the bag), two-handed with and without an offhand, and Necklace of
the Necromancer dropping on death from page 2.

## Wearing rules (stage ATI)

The original Equip trigger's rules now apply when gear goes on an equipment page; the bag and
quick slots still carry anything.

- An item's life is the Spirit of Gaya level it needs. Life 145 marks job gear, which needs a
  Legendary Master of the job its item level names (1 Squire or Chemist, 2 Knight, 3 Archer,
  0 Monk, 4 Thief or Ninja, 5 Lancer, 6 Geomancer, 7 Samurai, 8 Holy Swordsman or Dark Knight,
  11 Mediator). Refused gear goes to the bag with the original message, or to the hero's feet
  when the bag is full. Pickups never auto-equip gear the player may not wear yet.
- Dual Wield (Ninja) allows two weapons on page 1, never more than two hand items. A job without
  Dual Wield moves the second weapon to the bag. Two weapons save as weapon and offhand, the way
  Reforged dual-wields.
- Wearing gear ends the speedrun's No Gear accolade, as picking gear up did.

Rules live in `Backpack_WearBlock` and `Backpack_CheckPage`; tests in
`tools/tests/test_backpack_wear_rules.py`. Check: a helm above the Gaya level, job gear without
and with the master, two weapons as Ninja and after changing job.

## Still to build

Click to equip gear already in the hero's own slots. Since ATG the 1.29.2 map saves the backpack with the Reforged
FSVB code (SAVE_129.md); Reforged keeps its own save unchanged.
