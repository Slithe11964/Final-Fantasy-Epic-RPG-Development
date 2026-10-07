# Bazaar recipe browser - stage AJ

Click the Bazaar Shop's bottom-right Recipes icon with your buyer selected.
Reforged shows three tall recipe panels across one row. Each has ingredients, owned/required
counts, original gold/shard price and its own Craft button. Next 3 recipes and Previous 3 move
between nineteen groups; eighteen Next clicks reach recipes 55-56, then wrap to the start.

AH's ordinary TEXT frames are user-confirmed visible and much better. AI retains these frames for ingredients, replacing AG's blank TEXTAREA regions observed
in the user's screenshot. Ingredient/price text is larger. Names wrap to 24 characters; counts
appear on separate lines. The ingredient region now shows at most eighteen lines plus its heading, typically six Mark of
Darkness entries instead of three. Omni Gem (recipe 49) shows all six required gems on one
page; More ingredients is hidden for it. Text is inset farther from the borders and the font grows
from .014 to .016; the taller body/card gives the enlarged text room.
More ingredients cycles the remaining lines of longer recipes inside the same panel, and is
hidden when all ingredients fit. Satisfied ingredients remain green across text-page boundaries.
AJ moves Close above the cards, away from the normal command/inventory controls, and explicitly
raises its frame level. Clicking it hides the local UI immediately and synchronizes browser cleanup.
The reported bottom Close failure may be HUD input overlap; the root cause is not game-confirmed.
Changing recipe groups resets ingredient pages. Rewards stay hidden until crafting.

The 1.29.2 conversion uses AE's original single-recipe dialog with Previous recipe, Next recipe,
Craft this recipe and Close. It does not show the three-panel layout, even when played in Reforged.
AF's five-choice list and AG's five panels were rejected by the user and are superseded.

Craft checks the buyer, distance, parts and payment again, then deducts exactly one ingredient
set and the original bundle price. It gives the original items and charge quantities to the buyer.
If inventory is full, items remain beside the buyer, matching the previous bundle behavior.
Successful crafting closes the browser so you can see the reward.

Selling parts, waiting, opening, browsing and closing never spend ingredients. Automatic recipe
stocking has been replaced by the browser. Overlapping recipes compete for parts only when one
is chosen. Failed attempts spend nothing. The material pool remains shared between players,
as before; each player's selected recipe and buyer are separate. Open browsers refresh after
the sold-part update or another player's craft. Wolf Fangs still contributes its ten fangs.

Prices, original recipe data, starting material counts, quest rewards and save format are unchanged.
The user-tested AD armory layout, hints and required-level ordering are retained.

## In-game checks

For the three-panel interface, play `release/FFERPG_0.9.7.3-r16-stageAJ.w3x` in Reforged.
For classic, play `release/1.29.2/FFERPG_0.9.7.3-r16-stageAJ.w3x` in 1.29.2.
The classic copy also runs in Reforged but uses the AE dialog.

1. Open Recipes in Reforged. Confirm three panels with visible, readable ingredient names/counts,
   price lines and individual Craft buttons. Click the top-center Close: the entire custom UI must disappear and you must be able to
   interact with the game. Reopen Recipes; confirm the enlarged layout remains usable.
   Eighteen Next clicks reach recipes 55-56; another Next wraps. For recipe 1, use More ingredients
   to see all sixteen ingredients; confirm the first page shows roughly six marks, enlarged text stays inside the inset borders,
   and its green status
   is preserved. Check shorter recipes hide More ingredients. Try your usual resolution/UI scale.
   No reward should be revealed. AH rendering is user-confirmed; AI's enlarged text/padding still needs this check.
2. Check the classic copy uses the AE single-recipe dialog and both navigation buttons wrap.
3. Sell enough parts for one ingredient, then the rest. Its name/count should become green when
   satisfied. Wait thirty seconds and browse other recipes: parts must remain available.
4. With insufficient parts, gold or shards, click Craft. Nothing should be spent or received.
5. Craft a ready recipe. Check exact deduction, original price and reward/charges; unrelated
   parts remain. Test a multi-item recipe and a full inventory.
6. Use two players browsing recipes that share parts. Craft with only one set available: the other
   browser should refresh and its attempt must fail without spending money. Rapidly click Craft,
   close/reopen and navigate while a click is pending. Confirm no duplicate reward or desync.
7. Move the buyer away or let it die while browsing. Craft must reject it. Complete Wolf Fangs;
   its ten fangs should remain available. Check armory, save/load and Editor Save As with JassHelper.

Automated tests execute all 56 recipe transactions, local group navigation, complete ingredient-page traversal, bounded visible text,
panel bounds, synchronized recipe selection, duplicate/stale click rejection and the classic
conversion against mocked natives. Compilation/preservation audits cover both builds. Native
frame rendering and real multiplayer still require the in-game checks above.

## Rebuilding

For a fresh Git clone, prepare both object additions from the tracked baseline:

```powershell
python tools/armory_catalog.py baseline/Reforged/FFERPG_0.9.7.3-r16.w3x build/armory-objects.w3x
python tools/bazaar_catalog.py build/armory-objects.w3x build/bazaar-objects.w3x
.\build.ps1 -Stage AK -Base build/bazaar-objects.w3x -AllowNew '^gg_trg_Bazaar_(OpenRecipes|BrowseRecipes|FrameClick|FrameSync)$'
.\make_129.ps1 -Map release/FFERPG_0.9.7.3-r16-stageAK.w3x
```

Use unused stage/output names. For incremental work use the latest reviewed Reforged release as
`-Base`. Builds from AJ need no new-trigger allowance. The preparers add `bRcp`, append Sell Units
to `n030`, and copy current bundle prices into `Bazaar_InitBrowserData`, preserving all item objects.
If prices change, synchronize that function with `bazaar_catalog.sync_prices`; the mandatory
`check_bazaar.py` gate rejects stale prices, missing buttons and invalid ingredients.

All frame handles are created globally. Navigation/text visibility are local to the viewer.
Craft/Close send an explicit recipe and browser-session number via player sync events; only the
synchronized handler can change game state. Delayed clicks from earlier visits are rejected.
The converter applies `tools/bazaar_legacy.py` to both runtime and editor source, removing frame
APIs and restoring the AE dialog while preserving the shared transaction. Its two unused event
triggers remain as harmless classic placeholders to keep startup identities aligned.

`tools/tests/verify_bazaar_build.py --stage AJ` records preservation against AG: original objects,
recipe data, results, charges and payment code are unchanged; runtime changes are confined to
Bazaar. Syncing retains the original pawn and bundle editor handlers. Generated maps/reports stay
outside Git; sources, tools and guides are tracked.
