# Bazaar recipe browser - stage AE

The Bazaar Shop's bottom-right slot now has a Recipes icon. Click it with your buyer selected
to open a browser for all 56 recipes. Previous/Next recipe wraps around the list. Each entry
shows ingredient names and the shared sold count / required count, plus its existing gold and
crystal-shard price. Ingredients turn green individually when enough have been sold. Recipe
numbers identify entries; the reward name and icon stay hidden until you craft.

Click **Craft this recipe** to buy one recipe's goods. The bazaar checks your buyer, distance,
parts and payment again, then deducts exactly one ingredient set and the original bundle price.
It gives the original items and charge quantities to the buyer. If the buyer's inventory is full,
items remain on the ground beside them, matching the previous bundle delivery behavior.
Successful crafting closes the browser so you can see the reward.

Selling parts, waiting, opening, browsing and closing never spend ingredients. Automatic recipe
stocking has been replaced by the browser. Overlapping recipes compete for parts only when one
is chosen. Failed attempts spend nothing. The material pool remains shared between players,
as before; each player's selected recipe and buyer are separate. Open browsers refresh after
the sold-part update or another player's craft. Wolf Fangs still contributes its ten fangs.

Prices, original recipe data, starting material counts, quest rewards and save format are unchanged.
The armory layout and hints from user-tested stage AD are retained.

## In-game checks

Play `release/1.29.2/FFERPG_0.9.7.3-r16-stageAE.w3x` in both clients. The Reforged editor master
is `release/FFERPG_0.9.7.3-r16-stageAE.w3x`.

1. Visit the bazaar with a buyer selected. Check the bottom-right Recipes icon and open it.
   Scroll through recipes 1 through 56 and wrap around both ways. Recipe 1 has sixteen ingredients;
   confirm the complete list and all four buttons fit on screen. No reward should be revealed.
2. Sell enough parts for one ingredient, then the rest. Its name/count should become green when
   satisfied. Wait at least thirty seconds and browse other recipes: parts must remain available.
3. With insufficient parts, gold or shards, click Craft. Nothing should be spent or received.
4. Craft a ready recipe. Check exact ingredient deduction, original price and reward/charges;
   unrelated parts remain. Test a multi-item recipe and a full inventory.
5. Use two players browsing a recipe that shares the same parts. Craft once with only one set
   available: the other browser should update and its attempt must fail without spending money.
6. Close and reopen, and move the buyer away while browsing. Craft must reject a distant/dead
   buyer. Complete Wolf Fangs; its ten fangs should be available for your recipe choice.
7. Check the armory, save/load, and Reforged World Editor Save As with JassHelper enabled.

Automated tests execute all 56 recipe transactions, display text, navigation, failed payments,
buyer checks and shared-pool competition against mocked natives. Compilation and preservation
audits cover both builds. Actual shop/dialog layout still needs the in-game checks above.

## Rebuilding

For a fresh Git clone, prepare both object additions from the tracked baseline:

```powershell
python tools/armory_catalog.py baseline/Reforged/FFERPG_0.9.7.3-r16.w3x build/armory-objects.w3x
python tools/bazaar_catalog.py build/armory-objects.w3x build/bazaar-objects.w3x
.\build.ps1 -Stage AF -Base build/bazaar-objects.w3x -AllowNew '^gg_trg_Bazaar_(OpenRecipes|BrowseRecipes)$'
.\make_129.ps1 -Map release/FFERPG_0.9.7.3-r16-stageAF.w3x
```

Use unused stage/output names. For incremental development use the latest reviewed Reforged
release as `-Base`. The preparer adds `bRcp`, appends the Sell Units ability to `n030`, and copies
the current bundle prices into `Bazaar_InitBrowserData`. It preserves all item objects. If bundle
prices change later, synchronize that function with `bazaar_catalog.sync_prices`; the mandatory
`check_bazaar.py` gate rejects stale prices, missing buttons and invalid recipe ingredients.

`tools/tests/verify_bazaar_build.py --stage AE` records the preservation comparison with AD.
Syncing Bazaar restores its unchanged pawn and legacy bundle handlers from editor source;
the predecessor's runtime had inlined their condition helpers. The audit checks the unchanged
editor handlers and recipe initializer as well as every function outside Bazaar.
Generated maps/reports stay outside Git; sources, tools and guides are tracked.
