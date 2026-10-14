# Chronicles and monographs - stage AP

Hero Chronicles keeps its first ten categories on page one. Next page occupies the eleventh
entry and opens a nested spellbook containing Time Trial and Secrets. Secrets contains Keg Hunter.
The books use different order IDs and leave a slot for the engine's Cancel control. Navigation
and native rendering need play-testing in both clients; compilation/mocks do not establish it.
Existing category visibility and title benefits are preserved.

Each Chronicle tooltip shows unlocked titles / available titles, not its internal ability level.
Some internal levels are bitfields: a single title can advance the ability by several points.
Maxima: Warrior5, Mage5, Gaya4, Mastery6, Demons5, Arena5, Fiends6, Summoning8, Gear7, Quests6,
Time Trial5 and Secrets1 (63 total). The root book also shows the total. Tooltips refresh locally
once per second; all progression changes occur in the synchronized pickup/inventory path.

Keg Hunter requires holding each of the ten monographs with the hero or their own Gaya during
one game. They can be held one at a time; duplicate books do not count again. Other units,
rejected pickups and other players do not add progress. A periodic inventory scan covers items
already carried or restored/recreated; completed players bypass collection tracking.

Only completion is saved, as requested. Title59 was unused but its force flag already had a
dedicated bit in both the current writer and reader. Keg Hunter uses that bit, without changing
serializers, field order, inventory indexes or compatibility contracts. Partial discovery is
session-only. Loaded completion restores Secrets/Keg Hunter and gives the bonus immediately.
Gaya recreation and title restoration include the twelfth Chronicle ability.

## What monographs do

They are regional loot bonuses, not stat bonuses. The hero must land the killing blow. Holding
the matching book in either the hero's or their Gaya's inventory enables the bonus. Keg Hunter
enables the same check for every region without carrying books; effects do not stack.

| Monograph | Applies to |
|---|---|
| Knight's | Non-roaming monsters (zone0) |
| Hunter's | Guardia Forest |
| Traveller's | Barrens |
| Sentinel's | Central Islands |
| Warmage's | Northern Mountains |
| Berserker's | Galbados Highroad |
| Scholar's | Naga Islands |
| Sage's | Ancient Forest |
| Elder's | Icy Realm |
| Dragoon's | Dark Dragon Marsh |

For registered ordinary monster loot, after the existing chance-to-drop check succeeds, the
three loot-table tiers change from 65% / 25% / 10% to 45% / 35% / 20%. Existing Oversoul,
Shard Hunter and special drop rules still apply. The common-tier monograph roll doubles charges
on eligible charged drops; powerups are excluded and Spider Legs keep their separate1..8 roll.
In roaming regions1..8, actual essence drops have a50% chance to double their charges. This
does not double the chance of an essence dropping; the streak/drop logic is unchanged. Knight
has no roaming essence event, and Dark Dragon Marsh keeps its existing no-essence exception.

Before AP, hero/Gaya checks already existed for the regional books. The normal-loot predicate
incorrectly excluded zone0, so Knight's advertised normal-loot benefit did not apply. AP includes
zone0 in the shared predicate. Ordinary drops, monster tables and item descriptions are unchanged.

## Building and testing

For incremental work use the latest AP Reforged map. On a fresh baseline prepare armory and
Bazaar objects, then run `python tools/chronicles_catalog.py BASE OUT` before building. See
BUILDS.md for the complete recipe and allowed new startup trigger. The preparer adds three
abilities and changes only A0AR's spell list and A10C's button position on existing objects.

Tests execute collection/ownership guards, real title metadata and grants, local counters,
all ten zone/inventory/earned-title combinations, loot tier rolls and existing save-bit round trips.
The preservation audit is tools/tests/verify_chronicles_build.py (removed 2026-10-10, kept in Git history).

In both clients test page navigation/Cancel, all tooltip stages, hero/Gaya sequential collection,
duplicates and two players, Keg Hunter save/load/recreation, and Knight/regional loot with and
without books. Test Bazaar open/Close/reopen repeatedly and from different buyers/shops; AP
explicitly replenishes the Recipes stock entry after every click. Multiplayer/native rendering
and World Editor Save As remain in-game checks.

## Forsaken fresh loads (DY)

DY restores category visibility from the loaded title flags and Chronicle levels
at commit, without granting titles or bonuses again. Keg Hunter keeps its existing
Secrets refresh. Load an existing DW save and check earned categories on both pages.
