# Forsaken equipment experiment

This is the separate Stage AT test line requested by the user. Normal development stays on Stage AS. All test releases go in `release/Forsaken/`; the regular sources and release pair remain intact.

The Reforged test uses the native Warcraft III 3.0 expanded inventory and equipment abilities, rather than a frame imitation. Local game data from build 3.0.0.24268 identifies `AInx` (expanded inventory), `AEqu` (equipment inventory), and the item equipment field `iequ`. The native equipment UI has Head, Chest, Gloves, Boots, two Ring slots, Primary, Offhand and Trinket. The experiment adds custom abilities `fBag`/`fGer` based on those stock abilities. Heroes receive both; Gaya receives the bag so it can carry the converted gear. Abilities are restored when heroes/Gaya are recreated.

All 276 existing Armory gear items receive an equipment type. The four final Materia remain unchanged usable items. Weapons use Primary; shields, ammunition and books use Offhand; helmets use Head; armor uses Chest. Accessory names identify shoes/boots, gloves/bracers/armguards and rings; other accessories use Trinket. The build writes the complete item-to-slot list beside the map. Item IDs, original classes, bonuses, prices, charges, hints and Armory storage/save flags stay unchanged. Existing level and Legendary Master restrictions run when equipping, rather than preventing gear from being carried in the bag.

The existing 1.29.2 map is copied byte-for-byte as the classic fallback. It has the current six-slot inventory, current Armory, and normal saving. It does not use the new abilities or equipment fields. Do not pass the experimental Reforged map through the normal downgrade shortcut: that converter has not been extended to undo this experiment.

## Testing

Start a fresh game in the Reforged test, choose a hero and wait one second. Look for the native backpack/equipment controls. Withdraw or buy a weapon, helmet, armor and accessory, pick them up, then equip them in the corresponding slots. Check that the bonuses appear only when equipped, that you can unequip them, and that the bag holds spare gear. Check Armory hints/deposit/withdrawal and Gaya carrying gear. Try low-level and Legendary Master gated gear, then repeat with a second player and a changed/recreated hero.

This first build is for evaluating native UI and basic equipment assignment, not normal progression. Save, save-to-file, autosave and New Game export actions are blocked in the test: the unchanged save format only encodes up to six items per holder and cannot preserve a native bag/loadout. Normal save serializers and item/Armory indexes are not rewritten. Existing load code remains present, but old-save loading into the new inventory has not been validated.

Remaining migration work before progression play includes custom item procs and possession queries, quest/crafting scans of six-slot inventories, transfer/stacking/use helpers, job-change item handling, and save/load of bags and equipped slots. Ninja Dual Wield needs a design for weapons in Offhand: a native equipment type assigns one slot family per item, so the original two-weapon rule is not represented by the initial Primary mapping. Multiple accessory slots also change how much gear can be active. These are not claimed as complete or balanced by a compilation pass.

## Rebuilding

From the repository root, with the Stage AS Reforged/classic pair available:

```powershell
python experiments/Forsaken/test_forsaken.py
python experiments/Forsaken/build_forsaken.py --stage AT
```

Existing releases are refused. Choose a new stage for another test. `--base` and `--classic` accept explicit input maps. The builder copies sources/tools into an isolated scratch tree under `build/`, applies the Equip overlay there, prepares the equipment objects, and runs the complete existing stage pipeline: source/quest/save/content/editor checks, regressions, codec test, module sync, library ordering, map checks and header finalization. Only successful builds are copied into `release/Forsaken`. Scratch sources and logs remain available for review; the overlay and builder in this directory are the reproducible source of the test.

Blizzard confirms the new campaign's gear/inventory features are available to custom map creators in its [Forsaken Kingdom deep dive](https://news.blizzard.com/en-gb/article/24298590/warcraft-iii-reforged-forsaken-kingdom-deep-dive-recap). Native names were verified against the locally installed 3.0 libraries; the [PTR patch notes](https://us.forums.blizzard.com/en/warcraft3/t/new-300-ptr-build-24306/39295) describe newer Blz-prefixed aliases. This first test targets the installed live 3.0.0.24268 API.
