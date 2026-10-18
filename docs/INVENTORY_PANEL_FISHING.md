# PAIR028 inventory panels, fishing and healing

The native client executable identifies the bag as SimpleEquipmentInventoryPanel;
it is not SimpleInventoryPanel, and it does not match the old bag-name heuristic.
PAIR028 resolves the actual bag and equipment panels directly. Initial opening
and hero changes invoke their native inventory command controls, allowing the
engine to bind its model and items to the selected hero. Cached ownership is
accepted only after both panels open. Failed binding hides both, avoiding stale
models or single-pane output. Selecting Gaya/another unit hides both hero panes
while retaining intent for hero reselection. Closed/unbound inventory never runs
the expensive context search; positive handles are cached. Subsequent same-hero item-use/drop refreshes restore
both without native command clicks or canceling item targeting. B/Escape/native
close overlays still hide both. This is local presentation only: no local unit,
item, ability, order or selection mutations are introduced.

Fishing discovery is shared gameplay. The original raw-ID pickup-only unlock is
replaced by a bounded carry scan, including native aliases, loaded items, the last
bag page and Gaya. It checks once per second until discovery, then disables its
own trigger. It retains the original map-wide permanent fishing unlock and shop
information. Cast acceptance separately requires the matching rod to be worn.
All four rods retain their abilities and existing fish/catch/quest calculations.

Explicit native gear-to-quick-slot drag orders convert the equipment alias to a
separate q-prefixed carried copy. Only that copy is ordinary Permanent inventory
cargo; original items retain their classes and equipment aliases retain Equipment
type. The capture map normalizes carried copies to the existing permanent IDs;
native quick-slot loading creates the carried copy and legacy loading retains its
own canonical items. The existing carry marker prevents
reconversion while in the chosen quick slot, including loaded quick gear. Passive
bonuses are suspended immediately; active item abilities remain available and
share the same cooldown pool. Fresh world pickups retain the existing conversion
path. Permanent save IDs, original object classes, ownership, charges, life and save
positions are preserved.

## Priest/Prophet healing

Tranquility uses its authored rank data: 50/100/150/200/250/400 HP every .1 seconds,
for 15 seconds. The normal base rates are 500/1000/1500/2000/2500/4000 HP/sec.
Acid Rain converts half to damage: healing and magic damage each receive half the
current base rate. Master is 2000 base HP/sec and 2000 magic damage/sec. A single
scripted pulse supplies the heal, using the existing healing engine; native Etq1
pulses are zeroed to prevent double healing. Native channeling/visuals remain.
Enemy defense and target recovery rules apply. Healing flags are explicitly reset after each target, including targets that emit no damage event. Ending the channel clears tracking.

Cure: (5 x current-rank mana cost + 5 x INT) x Staff power; travel heals 25%.
Blessing of Light: floor[(3 x current-rank mana cost + 3 x INT) x Staff power] HP,
plus 25% as MP for allies; the caster receives HP only. Existing cleanse remains.
Pray contributes floor[(50 + floor(INT / 4)) x Staff power] to queued recovery each
second. HP recovery rolls 93.75%-100%; MP recovery rolls 23.4375%-25% of accumulated
queued prayer recovery, with the existing queue reset/other recovery rules.
Tooltips include formulas, rank mana values, and current caster amounts. Target
modifiers are separate. Refresh's base cooldown is 45 seconds; normal cooldown
modifiers still apply. Swiftmend is unchanged.

## Engine acceptance

Test B and the native gear/backpack controls from closed state; each should show
both panes. Change Freelancer to Time Mage with the inventory open and verify the
native model/name/items; use and drop items, target an item spell, close and reopen.
Test a rod carried/loaded in every storage type for spot discovery, then equip it
and activate it. Quick/bag/Gaya rods may reveal spots but cannot start fishing from
the hero without the corresponding equipped rod. Drag Tournesol/Tome of Banishment
into first/last hero quick slots, cast their actives, save/load and verify no bonuses.
Test Tranquility with/without Acid Rain at low/master rank and Refresh/reset/CDR.

## Validation

PAIR028 passed native196/classic296 regressions (10 expected legacy skips),
compilation and all paired gates. The final archive audit checked every276 carried
copy's active abilities, unchanged canonical classes, capture ID normalization,
hero quick-slot load binding and metadata. Both profile archives contain the
shared fishing/healing/CD corrections; native UI helpers remain native-only.
Master/tool/output hashes match; both TEST copies are installed and hash-verified.
These checks do not replace the engine acceptance cases above.
