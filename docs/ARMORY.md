# Armory discovery hints — stages AB through AM

The existing Armory title/access requirement remains. Once the armory is available, all its
categories can be browsed, including Celestial Weapons before storing one. Each of the 280
collectible gear entries displays its normal icon when stored, or a question mark when missing.
Hover to read a hint; clicking a question mark repeats the hint for that player and gives nothing.

Every category fits on one panel (at most eleven gear entries plus Back). Icons run left to right,
then top to bottom, in ascending item level requirement. Equal-level items retain their authored
order. Stored gear and its missing question mark occupy the same slot. Category state belongs to
each player. Withdrawing gear replaces its icon with a question
mark. Storing gear still consumes the deposited item and closes the open armory, as before.
Existing title thresholds, prices, inventory item indexes and rewards are retained. Stage AM adds four materia to collection counts and appends their armory save bits.

Hints describe one existing route, not every possible source. They point to hunts, arena prizes,
monsters, treasure, quests, crafting, Bali, chocobo digging and fishing. The user confirmed Mina comes through Fairy Voodoo and Halberd of Justice from level-99 Valfodr.
Stage AC uses the requested hints: "Have you found a voodoo doll?" and "Valfodr was last seen
holding it." These hints add no acquisition methods or change the existing rewards.

## In-game test

Use release/FFERPG_0.9.7.3-r16-stageAN.w3x for Reforged play/editor development.
Use release/1.29.2/FFERPG_0.9.7.3-r16-stageAN.w3x for classic play (AE Bazaar presentation).

1. With an armory-enabled character, browse a category with no stored gear. Hover a question mark
   and click it: the hint appears, no item/gold/BP is gained or spent, and the entry remains.
2. Browse Swords and Accessories with a mix of stored and missing gear. Check that every item
   appears on one panel in ascending level order, no icons overlap, and Back returns correctly.
3. Browse Celestial Weapons without having stored one: missing entries should be visible.
4. Store one item, reopen the armory, and find its normal icon. Withdraw it once: it should arrive
   at the hero/house as before and leave a question mark. Store it again to restore the icon.
5. Save/load an existing character and armory code; compare stored items and collection count.
6. With two players, use different categories and collections at the same time. Browsing/withdrawing
   must affect only the owning player's armory. Trying another player's shop still rejects access.
7. Repeat in 1.29.2 and Reforged. Open the Reforged build in World Editor, check Armory's source,
   and Save As a new file with JassHelper enabled.

Automated tests execute the browsing, hint clicks, withdrawal and Back source with mocked
stock natives. They cannot verify Warcraft's actual icon layout or mouse interaction.

## Rebuilding from a full Git clone

Generated release maps are ignored. The public baseline predates the new stock objects, so first
prepare a fresh base from that baseline (Python 3 on PATH):

```powershell
python tools/armory_catalog.py baseline/Reforged/FFERPG_0.9.7.3-r16.w3x build/armory-objects.w3x
python tools/bazaar_catalog.py build/armory-objects.w3x build/bazaar-objects.w3x
.\build.ps1 -Stage AO -Base build/bazaar-objects.w3x -AllowNew '^gg_trg_Bazaar_(OpenRecipes|BrowseRecipes|FrameClick|FrameSync)$'
.\make_129.ps1 -Map release/FFERPG_0.9.7.3-r16-stageAO.w3x
```

Use an unused stage and output filename. For ongoing local development, use the newest reviewed
Reforged release as -Base. The object preparer refuses existing output/object IDs, adds 280
question-mark unit proxies and sorts existing collectible proxy button positions, and synchronizes Armory_InitHints in CRLF.
The preparer also adds the Materia category and four stored proxies when missing. Only presentation positions on existing collectible proxies change. Item requirements, other unit
fields, items, abilities, terrain, dialogue and rewards are preserved.
Current sources also need the Bazaar preparer in the example above; see BAZAAR.md for that addition.

Edit src/armory-hints.json to change hints. Each entry retains the save item index, item/unit IDs,
hint and evidence for its acquisition route. Use the hint refresh workflow below on an existing
prepared map so hover tooltips and click messages update together while retaining Object Editor edits.
check_armory.py is a build gate: missing proxy objects or catalogue/source mismatches block release.

tools/tests/verify_armory_build.py (removed 2026-10-10, kept in Git history) records the earlier armory discovery audit against the public baseline.
The current AM audit is tools/tests/verify_armory_materia_build.py (removed 2026-10-10, kept in Git history) against AL; it checks all existing
object fields, other modules, the nine new stock units and the reviewed bitmap extension.

## House icon collection counter - stages AL and AM

Hover the house's Armory icon. The original description is followed by `Armory collection: N / 280`.
N counts currently stored collectible gear and the four final-tier materia, not lifetime acquisitions or reward/title flags.
The denominator comes from eligible hint entries. Withdrawals lower N; depositing or loading
updates it within one second. The text is local to the viewing player; no collection flags,
rewards or save data are changed. Test 0/partial/full collections, deposits/withdrawals/load,
two players with different collections, both clients and World Editor Save As.

## Customizing hints

Edit `src/armory-hints.json`: find the entry by its `name` and change only its `hint` text.
Keep the numbered keys, `item`, `unit` and evidence mappings intact. `Armory_InitHints` in
Armory.j is generated from this file; editing it alone leaves the hover tooltip/catalogue stale.

For an existing prepared development map, update both the question-mark tooltip objects and
generated source, then build/convert using unused filenames/stage names:

```powershell
python tools/armory_catalog.py release/FFERPG_0.9.7.3-r16-stageAN.w3x build/custom-hints.w3x --refresh-hints
.\build.ps1 -Stage AO -Base build/custom-hints.w3x
.\make_129.ps1 -Map release/FFERPG_0.9.7.3-r16-stageAO.w3x
```

The refresh mode preserves existing objects and stock positions, changes only missing-item
extended tooltip fields and synchronizes hint source in CRLF. It refuses missing proxies and
existing output files. For a fresh baseline use the original object preparer workflow above.
The mandatory catalogue gate checks source and tooltips agree before a build is published.

## Materia storage - stage AM

The new Materia icon is immediately to the right of Accessories. Its four slots are Wateraga,
Quakeraga, Demiga and Aeroga Materia; their existing names, spells and acquisition routes remain.
Missing slots show question marks. The hints point to obtaining the base materia and using it
through both upgrades. Lower-tier materia and unrelated charged items are not storable.
Store a final-tier materia in your own house after unlocking the Armory title; duplicate deposits
remain as items. Withdrawal returns the original materia and restores its missing question mark.
The count is now N / 280. These entries participate in existing collection/title checks.

To extend a prepared pre-AM map, use unused output/stage names:

```powershell
python tools/armory_catalog.py release/FFERPG_0.9.7.3-r16-stageAL.w3x build/materia-objects.w3x --add-materia
.\build.ps1 -Stage AO -Base build/materia-objects.w3x
.\make_129.ps1 -Map release/FFERPG_0.9.7.3-r16-stageAO.w3x
```

The fresh-baseline workflow above includes the new objects automatically. --add-materia keeps
all existing objects and adds only missing stock proxies; partial/colliding materia IDs are refused.
Original inventory indexes (71,100,103,150), charge classifications and item definitions stay fixed.
The armory bitmap stores these four flags AFTER the complete old flag order, preserving old saves.
Old codes remain valid. To retain materia from new saves, load in AM or later. The original
compatibility contract remains intact, with a separately reviewed exact serializer extension.

Test Back, each missing hint and original icon, all four deposits/withdrawals, duplicates,
lower-tier rejection, N / 280 changes, older saves and new materia save/load in both clients.
Use two players to check ownership and independent collections. Also verify World Editor Save As.
tools/tests/verify_armory_materia_build.py (removed 2026-10-10, kept in Git history) audits the AM maps against AL.

Current sources also require Chronicle page/Secrets abilities. Use the complete fresh workflow
in BUILDS.md, or an AP-or-later map for incremental work; older partial object examples above
need the Chronicle preparer before a current-source build.
