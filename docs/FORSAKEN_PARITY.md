# Forsaken line vs the normal map

The Forsaken maps (`release/Forsaken/...DZ` is the latest) are the Reforged equipment experiment:
native 30-slot bag and nine equipment slots, stat and inspection panels, and the new save.
The normal map (Reforged and 1.29.2) uses the backpack pages instead. This page records what was
compared at stage ATJ against Forsaken DZ, and where each difference stands.

## Merged into the normal map

| From | Change | Where |
|---|---|---|
| Save DW-DZ | FSVB save, files and loader (1.29.2 only; Reforged keeps its old save) | SAVE_129.md |
| BL-BR | Every item check that read equipped gear reads worn gear (equipment pages) | BACKPACK.md (ATH) |
| BN-BR | Level and Legendary Master rules, Dual Wield, one of each piece | BACKPACK.md (ATI) |
| BM | Gaya Strength no longer counts twice toward an element plus Omni | Damage.j `Damage_ElementDamageBonus` |
| BR | Trident (+32) and Storm Lance (+55) give the accuracy their tooltips promise | Damage.j `GetAccuracy` |
| BS | Bow and gun ammunition elements follow the weapon in hand, not trained proficiency | Element.j, `Gear_WieldsWeaponLevel` |
| BP | An item spell has rank 1 while it is cast, even from a unit that does not list it | Abil.j `Abil_GetLevel` |
| BL | Equipment and Armory tooltips name the slot ("Slot: Helm") | tools/forsaken_parity.py |
| DY | Hero and Spirit of Gaya house portals cast in 3 seconds (was 6) | tools/forsaken_parity.py |
| DZ | Shrine: Reset Talents bottom-left, Legendary Bonus Menu bottom-right | tools/forsaken_parity.py, talents_catalog.py |
| DY | Priest talents, Chronicle restore on load | already in the normal map (TALENTS.md, CHRONICLES.md) |

Every equipment ability Forsaken reads through its equipment lookups is one the backpack grants
to the hero for worn gear, so those effects (Support Expertise, Treasure Hunter, Recharge, mana
refund, elements, block, crit, accuracy and the rest) already work in the normal map.

## Not merged, by design

- Native bag/equipment, item variants (`f###`, `g###`), passive suspension, spacer items: the
  backpack pages do this job, and 1.29.2 has no such natives.
- Stat pages, other-player inspection and the Forsaken talent panel: Reforged frame UI. The normal
  map has its own talent dialog; stat pages could come later as text (for example a `-stats` command).
- Shared inventory transfer on job change: the backpack belongs to the player, not the job hero.

## Normal map ahead of DZ

Item checks seeing the backpack, Keg Hunter/Secrets text, Bazaar Escape, tooltip-level fixes for
1.29.2, the water cone and shared item cooldowns, and refactors with the same behaviour.

Re-run the comparison after new Forsaken work: compare `functions()` of both scripts (tools/jtok.py)
ignoring the Forsaken lookup names, and compare object fields of the two maps.
