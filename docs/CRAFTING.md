# Crafting, forging, materia and cooking

Modules (folder 05):

- `Recipe`: the recipe table.
- `Craft`: making recipe items.
- `Forge`: Bali the blacksmith.
- `Bazaar`: material shop and pawning; also builds the material table.
- `Materia`: materia altars.
- `Cooking`: fireplace recipes.
- `Dismantle`

Item numbering is explained in [LOOT.md](LOOT.md).

## What players do

| System | In game |
|---|---|
| Recipes | Buy an item called "Recipe: X" from a shop while carrying the ingredients. The ingredients are used up and X appears in the inventory. |
| Forge (Bali) | Give Bali a base item and a material (a gem, Psypher …). He forges the result, e.g. Shimmering Sword + Ice Gem → Icebrand. Psypher on a level-99 weapon makes its Celestial version. |
| Bazaar | Pawn materials (monster parts, Marks of Darkness …) at the bazaar. It stocks goods you can afford from what you pawned, and sells material bundles. |
| Materia | Drop a high-grade materia (…aga Materia) on its altar for a one-time ritual. Each altar works once (`udg_MateriaAltarDone[n]`). |
| Cooking | Fireplaces (`'n0KG'`) sell cooking recipes. More are unlocked with titles (`udg_CookingStage` 0–3). |
| Dismantle | A spell (`'A1BB'`) for dismantling mechanical enemies (species 22 in the monster table). It deals pure, unavoidable damage. |

## Recipes (`Recipe` + `Craft`)

**Data:** `Recipe_InitTables` (32 recipes, run at start-up by `MapBootstrap`) fills, per recipe `i`:

| Variable | Meaning |
|---|---|
| `udg_RecipeName[i]` | Name; it must match the shop item's name after "Recipe: " |
| `udg_RecipeResult[i]` | Item made |
| `udg_RecipeItem1..6[i]` | Ingredient item types (`0` = unused) |
| `udg_RecipeCharges1..2[i]`, `udg_RecipeCount3..6[i]` | Minimum charges needed for each ingredient |

**How a purchase becomes an item:**

1. `Craft_Recipe` fires on any sold item whose name starts with "Recipe: ".
2. `Trig_Craft_Recipe_MakeRecipe` finds the recipe **by name**.
3. `Trig_Craft_Recipe_ConsumeIngredients` matches each ingredient to a different inventory slot,
   and only if all six are found removes them.
4. The result is created. Charged results get 3 charges, or 5 with title 55.
5. The shop item itself is always removed.
6. Making one of the last recipes (index 29 and up) can award the Chemist mastery force
   (`udg_JobMasterForce[10]`) to a level-99 Chemist.

## Forge (`Forge`, Bali = `gg_unit_Hmbr_0140`)

- **Recipes:** `Trig_Forge_Bali_Init_Actions` sets `udg_ForgeRecipeCount` (33) and, per recipe:
  `udg_ForgeRecipeBase[i]` + `udg_ForgeRecipeMaterial[i]` → `udg_ForgeRecipeResult[i]`.
- **Giving items:** `Forge_Bali_ItemGiven` / `ItemTaken` track what was handed to Bali
  (`udg_ForgeGearSlot`, `udg_ForgeMaterialSlot`). His shop shows "Result Unknown" until both are
  filled.
- **Forging (`Forge_Bali_Craft`):**
  - Psypher on a level-99 weapon gives `udg_CelestialWeapon[item level]`.
  - Otherwise the base/material pair is looked up in the table.
  - The result keeps its owner (item user data). A material with charges loses one charge
    instead of being used up.

## Bazaar (`Bazaar`)

- **`Bazaar_Init` (3 s after start):**
  - fills `udg_DropItemIdTable[1..106]`: every material, used by drops, save codes and here;
  - sets `udg_MaterialTypeCount`;
  - sets `udg_BazaarGoodItem[1..56]` and what each costs in materials.
- **Pawning:** `Bazaar_PawnMaterial` counts pawned materials per type (`udg_MaterialOwnedCount[i]`).
  `Bazaar_UpdateStock` (timer `udg_BazaarUpdateTimer`) adds goods whose material costs can be paid.
  Selling a good spends the materials.
- **Bundles:** `Bazaar_Sell_Bundle` handles material bundles.

## Common changes

| Change | Where |
|---|---|
| New recipe | Object Editor: a shop item named exactly "Recipe: <Name>", sold somewhere. Code: add `udg_RecipeName/Result/Item1..6/Charges…[33]` in `Recipe_InitTables`. No count to raise: the search stops at the first empty name. |
| New forge recipe | Add `udg_ForgeRecipeBase/Material/Result[34]` in `Trig_Forge_Bali_Init_Actions` and raise `udg_ForgeRecipeCount`. |
| New material | Add `udg_DropItemIdTable[107]`, raise `udg_MaterialTypeCount`, and give monsters the index in `MonsterData` ([LOOT.md](LOOT.md)). |
| New cooking recipe | Add an `AddItemToStockBJ` line in the right tier function of `Cooking`, plus the recipe in `Recipe_InitTables` (cooking recipes are also "Recipe: …" items; not verified). |
| New materia altar | Add a rect check and a `udg_MateriaAltarDone[n]` slot in `Trig_Materia_Altar_Ritual_*`. |

## Gotchas

- **Recipes match by name.** Renaming a recipe item in the Object Editor, or a typo in
  `udg_RecipeName`, silently breaks that recipe. The search also stops at the first empty name,
  so don't leave gaps.
- **Ingredient counts:** `udg_RecipeCharges1/2` and `udg_RecipeCount3..6` both mean "minimum
  charges", under two naming styles.
- **One shared forge:** Bali's two slots are shared by all players.
- **Material indexes are stored elsewhere:** `MonsterData` drop slots and hunt contracts use
  them. Add new materials at the end only.
