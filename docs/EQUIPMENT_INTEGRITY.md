# Equipment, item use and inventory controls (PAIR026)

Build from the unchanged editor master through tools/build_pair.py. Shared
transforms in tools/equipment_integrity.py apply to both profiles; native-only
inventory/control/cooldown adapters stay out of the 1.29.2 UI.

## Behavior

- Native hero quick slots may carry gear/books but suspend passive bonuses.
  Only worn equipment restores those bonuses; the regeneration display uses the
  same equipped-only scan. Prototype Crossbow has explicit
  primary-equipment metadata, preserving its existing abilities. It remains
  developer gear without a character-save ID; the existing nonpersistent-item
  capture rule skips it. Legacy table generation explicitly retains this rule.
- Native Prominent/Hunter cloak and Champion Belt markers resolve worn gear.
  Cloak changes request a stat refresh only when the equipped marker set changes.
- Native fishing rods expose their cast ability while equipped and remove it on
  unequip; this uses the same strict equipped lookup.
- Gaya's level check applies to gear only. Potions, food, monster parts, curse
  scrolls and Scroll of Shadows may be carried regardless of level. Gear's
  authored equip requirements and item life/save encoding remain intact.
- House armory deposits require membership in the actual 280-entry catalogue.
  Other cargo is not consumed or counted as an armory entry.
- Pram Nut can breed an owned chocobo near its partner, using the basic breeding
  score rather than a stale bonus from an earlier nut. Ownership/range rules stay.
- All six actual Freelancer forms (three melee, three ranged) capture/load.
  Core schema2 variant values1-6 preserve exact unit form; attribute reconstruction
  maps the ranged forms to their corresponding STR/AGI/INT form. Earlier values1-3
  keep their meaning. Existing borrowed-skill policy remains unchanged.

## Shared cooldown enforcement

The native profile classifies active item abilities from the edited object data.
Weapons, offhands and Materia use the gear pool; food/potions use the consumable
pool. Hero and Gaya share player deadlines. CHANNEL/order vetoes stop recovering
casts before use, and spell-effect conditions block scripted effects if an engine
item ignores the stop order. Duration comes from the cast's actual cooldown,
falling back to the ability's current-rank cooldown. Innate hero spells are not
classified merely because they share an order string. All gameplay state and
listeners are synchronized; local UI state does not control casts.

## Rain spells

Myriad Arrows, Time Mage Meteor and the wide scripted Meteor use owned timers,
six descending visuals per wave and explicit area damage. Per-wave formulas and
master object-data wave counts are preserved. Waves fall at .25-second intervals;
removed casters terminate the cast. Each wave destroys effects; the final wave
releases its group, hash state and timer. Enemy ground targets only; invulnerability
and dead targets are excluded. This avoids the failing native Blizzard proxy order.

## Native inventory presentation

Bag and equipment panes follow one persistent open/close intent. A bounded local
frame search caches the bag container, and native X overlays close both panes.
B/Escape close both; item use/drop/unequip does not clear intent. The extra portrait
close button is removed: a close overlay is displayed only over a found native X.
No frames or gameplay handles are allocated inside a local-player UI branch.

## Acceptance still needed in Warcraft

Check lower and master ranks of both rain spells against enemies; quick-slot books
must cast without granting passive stats; equip/unequip/drop/load Prototype and
Prominent Cloak; fish with each equipped rod; retry Pram Nut; move curse scrolls to
House; save/load a ranged Freelancer; attempt a second gear cast from another
page and Gaya during cooldown. Open/close each native pane and drop/use items with
the inventory open. Repeat multiplayer with a large imported character.

This change does not claim to resolve the earlier 1.29.2 large-character Warcraft
menu checkpoint reload failure. Character export/import transport is retained.

## Build verification

Both PAIR026 gates passed: native191 tests and classic291 (10 expected skips),
compilation, source/runtime agreement, startup/content/save compatibility, armory
and bazaar checks, and legacy conversion. Final archive/tool/master and installed
TEST hashes were verified. Focused capture17, fresh loader35 (all six Freelancer
forms), job schema6, equipment11 and inventory-control11 tests passed. The
in-engine acceptance checklist above remains outstanding.
