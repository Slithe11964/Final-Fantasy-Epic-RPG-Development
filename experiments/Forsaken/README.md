# Forsaken equipment experiment

This is the separate Forsaken test line requested by the user. AT failed its in-game test: no visible backpack controls and NPC gear dropped. AU restored original gear but its Backpack did not open the native panel and reported zero bag capacity. AV also failed to open the panel, reporting capacity0 and hero ability levels0. AW is the next candidate UI correction. Normal development stays on Stage AS. All test releases go in `release/Forsaken/`; the regular sources and release pair remain intact.

The Reforged test uses native Warcraft III 3.0 expanded inventory/equipment. Local data from build 3.0.0.24268 identifies `AInx` (expanded inventory), `AEqu` (equipment inventory), `AIni` (item inventory) and the item equipment field `iequ`. The native equipment UI has Head, Chest, Gloves, Boots, two Ring slots, Primary, Offhand and Trinket. AU gives the hero a visible, usable `fBpk` Backpack item, based on the stock `ebac`, carrying `AIni,AEqu`. Click that item in the ordinary six-slot inventory. Gaya receives stock AInx for carrying gear. Setup runs on recreated heroes/Gaya. A full hero inventory must have a free slot before the Backpack can be supplied.

AU preserves all original item definitions, so NPCs and preplaced heroes keep their existing gear. It adds 276 equipment variants for Armory gear; the four final Materia remain usable items. Once the player's hero has a native bag, eligible gear in that hero's six-slot inventory is copied into its equipment variant in the bag. Charges/ownership are retained, and the original is removed only after the bag accepts the replacement. Weapons use Primary; shields, ammunition and books use Offhand; helmets use Head; armor uses Chest. Accessory names identify shoes/boots, gloves/bracers/armguards and rings; other accessories use Trinket. The build writes the full original/variant/slot list beside the map. Existing item IDs/classes/bonuses/prices/hints/Armory flags stay unchanged. Existing level and Legendary Master restrictions run when equipping.

The existing 1.29.2 map is copied byte-for-byte as the classic fallback. It has the current six-slot inventory, current Armory, and normal saving. It does not use the new abilities or equipment fields. Do not pass the experimental Reforged map through the normal downgrade shortcut: that converter has not been extended to undo this experiment.

## Testing

Start a fresh game in AW, choose a hero and wait one second. Click the Backpack item in the six-slot inventory. Type `-forsaken` to show its slot, native bag capacity, direct fBag/fGer/ASpc ability levels and stock AInv level if the UI still does not appear. Confirm town NPCs retain their gear. Withdraw or buy a weapon, helmet, armor and accessory, pick them up, wait for conversion, then equip them in the corresponding slots. Check bonuses and unequipping. Try a full bag: the original must be retained if conversion fails. Try low-level and Legendary Master gated gear; repeat with a second player and a recreated hero. Variant-to-Armory deposit and other item-ID-dependent systems still require migration; this build only tests the UI/equipment pipeline.

AV uses custom fBgi/fGer item abilities, based on AIni/AEqu, with level1 bag capacity and equipment level threshold explicitly authored in Data F: inv6=30 and equ1=0. Installed AbilityMetaData identifies both fields with data pointer6. The Backpack also carries stock ASpc, the native interface controller. Gaya gets custom fBag with inv6=30. The stock SLK capacity in Data A differs from the current metadata's Data F field; this is a candidate explanation for AU's zero-capacity result, requiring a native play-test. No campaign talents or talent bonuses are added.

AW attaches fBag, fGer and ASpc directly and permanently to the player hero, bypassing the Backpack attachment path. fGer is configured as a unit ability; fBag already was. The stock panel controller has an explicit name/icon and hidden command-card position so it can be referenced and does not occupy a job spell button. The physical Backpack remains the intended entry point. Original AInv and existing carried items remain intact. GetUnitAbilityLevel checks the holder, so AV's zero item-ability readings alone did not prove that the engine failed to load those item abilities. AW's readings check abilities explicitly attached to the unit.

This first build is for evaluating native UI and basic equipment assignment, not normal progression. Save, save-to-file, autosave and New Game export actions are blocked in the test: the unchanged save format only encodes up to six items per holder and cannot preserve a native bag/loadout. Normal save serializers and item/Armory indexes are not rewritten. Existing load code remains present, but old-save loading into the new inventory has not been validated.

Remaining migration work before progression play includes custom item procs and possession queries, quest/crafting scans of six-slot inventories, transfer/stacking/use helpers, job-change item handling, and save/load of bags and equipped slots. Ninja Dual Wield needs a design for weapons in Offhand: a native equipment type assigns one slot family per item, so the original two-weapon rule is not represented by the initial Primary mapping. Multiple accessory slots also change how much gear can be active. These are not claimed as complete or balanced by a compilation pass.

## Rebuilding

From the repository root, with the Stage AS Reforged/classic pair available:

```powershell
python experiments/Forsaken/test_forsaken.py
python experiments/Forsaken/build_forsaken.py --stage AW
```

Existing releases are refused. Choose a new stage for another test. `--base` and `--classic` accept explicit input maps. The builder copies sources/tools into an isolated scratch tree under `build/`, applies the Equip overlay there, prepares the equipment objects, and runs the complete existing stage pipeline: source/quest/save/content/editor checks, regressions, codec test, module sync, library ordering, map checks and header finalization. Only successful builds are copied into `release/Forsaken`. Scratch sources and logs remain available for review; the overlay and builder in this directory are the reproducible source of the test.

Blizzard confirms the new campaign's gear/inventory features are available to custom map creators in its [Forsaken Kingdom deep dive](https://news.blizzard.com/en-gb/article/24298590/warcraft-iii-reforged-forsaken-kingdom-deep-dive-recap). Native names were verified against the locally installed 3.0 libraries; the [PTR patch notes](https://us.forums.blizzard.com/en/warcraft3/t/new-300-ptr-build-24306/39295) describe newer Blz-prefixed aliases. This first test targets the installed live 3.0.0.24268 API.
