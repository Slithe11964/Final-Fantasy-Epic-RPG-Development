# Armory discovery hints — stages AB through AD

The existing Armory title/access requirement remains. Once the armory is available, all its
categories can be browsed, including Celestial Weapons before storing one. Each of the 276
collectible gear entries displays its normal icon when stored, or a question mark when missing.
Hover to read a hint; clicking a question mark repeats the hint for that player and gives nothing.

Every category fits on one panel (at most eleven gear entries plus Back). Icons run left to right,
then top to bottom, in ascending item level requirement. Equal-level items retain their authored
order. Stored gear and its missing question mark occupy the same slot. Category state belongs to
each player. Withdrawing gear replaces its icon with a question
mark. Storing gear still consumes the deposited item and closes the open armory, as before.
Titles, prices, item indexes, collection counts, rewards and save-code format are unchanged.

Hints describe one existing route, not every possible source. They point to hunts, arena prizes,
monsters, treasure, quests, crafting, Bali, chocobo digging and fishing. The user confirmed Mina comes through Fairy Voodoo and Halberd of Justice from level-99 Valfodr.
Stage AC uses the requested hints: "Have you found a voodoo doll?" and "Valfodr was last seen
holding it." These hints add no acquisition methods or change the existing rewards.

## In-game test

Use release/1.29.2/FFERPG_0.9.7.3-r16-stageAD.w3x for the shared playable copy in either client.
Use release/FFERPG_0.9.7.3-r16-stageAD.w3x for Reforged editor development.

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
.\build.ps1 -Stage AG -Base build/bazaar-objects.w3x -AllowNew '^gg_trg_Bazaar_(OpenRecipes|BrowseRecipes)$'
.\make_129.ps1 -Map release/FFERPG_0.9.7.3-r16-stageAG.w3x
```

Use an unused stage and output filename. For ongoing local development, use the newest reviewed
Reforged release as -Base. The object preparer refuses existing output/object IDs, adds 276
question-mark unit proxies and sorts existing collectible proxy button positions, and synchronizes Armory_InitHints in CRLF.
Only presentation positions on existing collectible proxies change. Item requirements, other unit
fields, items, abilities, terrain, dialogue and rewards are preserved.
Current sources also need the Bazaar preparer in the example above; see BAZAAR.md for that addition.

Edit src/armory-hints.json to change hints. Each entry retains the save item index, item/unit IDs,
hint and evidence for its acquisition route. Re-run the preparer from the original baseline before
building changed hints, so both hover tooltips and click messages update together. To carry forward
other Object Editor edits, use a reviewed map that has those edits but no existing hint proxy IDs.
check_armory.py is a build gate: missing proxy objects or catalogue/source mismatches block release.

tools/tests/verify_armory_build.py records the current stage preservation audit. Only war3map.j, war3map.wct and
war3map.w3u differ from the public baseline; existing unit fields are preserved except collectible proxy button positions. All runtime
functions outside Armory are unchanged. Syncing Armory also restores two pre-existing optimized
store-handler bodies from the unchanged editor source; the save compatibility gate still passes.
