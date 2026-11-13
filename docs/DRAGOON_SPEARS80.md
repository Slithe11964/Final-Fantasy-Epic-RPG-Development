# QuickUI79: Dragoon spear balance

Dragoon development test only, based on QuickUI78. Plain 0.9.7.5f, classic, creature review and editor master are unchanged.

Spear proficiency adds 10% of normal mana regeneration and subtracts one percentage point from each enemy block roll per effective proficiency point. Existing weapon research base damage and explicit Spear Technique spell scaling remain. Owner was asked whether spell scaling should also be removed; no answer received at packaging.

Mana regeneration uses one hidden native item-regeneration ability. The existing shared 1-second maintenance updates its values only when effective proficiency changes or the ability is missing; no new timers. Local inventory rendering never invokes this updater. Read-only stat display uses the same amount.

| Weapon | Damage | Accuracy | Other effects |
|---|---:|---:|---|
| Short Lance | 120 | 20 | +10% physical damage |
| Poison Spear | 180 | 20 | +10% physical damage; Normal attacks poison enemies. |
| Heroic Lance | 360 | 25 | +10% physical damage |
| Shimmering Spear | 500 | 40 | +20% physical damage |
| Trident | 560 | 50 | +25% Water damage; Attacks deal Water-elemental damage. |
| Wildfire Spear | 600 | 50 | +25% Fire damage; Attacks deal Fire-elemental damage. |
| Halberd of Justice | 450 | 75 | +30% physical damage; Increases Strength by 80. |
| Holy Lance | 600 | 80 | Increases all stats by 25. Adds 50% of total healing effectiveness as physical damage (100% healing effectiveness grants +50% physical damage). |
| Zodiac Spear | 800 | 100 | +50% physical damage |
| Storm Lance | 750 | 80 | +50% Thunder damage; Attacks deal Thunder-elemental damage and may Shock enemies. |
| Longinus | 1000 | 125 | +60% physical damage |

Halberd loses its old +3500 HP. Holy Lance loses its old +30 HP/sec. Elemental-attack and poison/Shock passives remain. Holy Lance converts half of total healing effectiveness, so baseline 100% gives +50% physical damage, doubled healing gives +100%. Buffs used by the existing healing helper apply. All canonical, equipped and alternate item forms receive matching descriptions and ability lists. Existing elemental-attack passive bonuses remain in addition to the newly listed elemental damage bonuses.

Jump cooldown 30 seconds; radius 200 (diameter 400). Damage: (MP cost + STR) x 0.01 x (min(1000, starting distance) + 200) x (1 + 0.1 x Spear Technique). Sonic Thrust cooldown 20 seconds. Life of the Dragon lasts 15 seconds in both gameplay gate and status buff. Drakesbane uses current attack element, including enchantments; Rise retains Fire. Cooldown-reduction path preserved.

Seven focused tests execute damage, element selection, equipped-only bonuses, block thresholds, mana updater changes/caching and preservation of inventory/input functions. Full playable/editor compilation, startup/pairing/globals/text checks, content IDs, save compatibility and archive readback pass. Native gameplay and multiplayer validation pending.

Backpack cross-player closure is now explicitly confirmed by owner. It remains unresolved; every existing bag/preview/F/G callback is unchanged in QuickUI79. Standalone Inventory-Multiplayer-Check-01 remains available to isolate engine/configuration from full RPG scripting. No claim of desync resolution.
