# QuickUI48 gear and wave follow-up

The owner rejected QuickUI47 in game: F/G equipment displays stayed stale, G did not arm the offhand, targeting feedback was missing, Aqualung had no effect, and 1000 Cuts displayed its old calculation. The prior UI47 completion claims are not gameplay acceptance.

UI48 refreshes both equipment slots directly on each UI poll and uses ordinary backdrop icon handles with a fresh named-child context after frame recreation. Quick-gear lookup includes primary, offhand and quick-carrier aliases; offhand key initialization is independent of the weapon key. F/G target spells use an imported screen-space crosshair, which restores the ordinary cursor on cancellation or cast.

Wateraga and Book of Depths use the Dragoon rune texture to mark the water wave's 800-unit center path and widening boundaries (100 to 300 half-width), matching Water_Touches. Ice Wand U shows three rune paths matching the existing Blizzaga launch angles (-11.25, +11.25 and +33.75 degrees) and last damaging pulse at 1000 units. Native Wateraga command/inventory clicks also arm its path preview. These previews are local presentation only; cast requests still pass the synchronized owner/item validation.

The Aqualung proxy uses an invisible model already. Hiding it at any point cancels its Blizzard channel, so UI48 removes HideUnit entirely, restores its mana and allows a 12-second lifetime. The earlier order-before-hide workaround was insufficient.

The builder now explicitly applies the current 1000 Cuts ability-object patch. Every rank describes `(100 + 0.3 x AGI) x (1 + 10% x Dagger proficiency)` per dagger, plus 25% rear rip damage. Runtime damage uses the same formula. Sonic Thrust retains a whole-unit 10-unit push; the motion regression moves the target from x=250 to x=260. Dragoon's shrine entry ends with purple `Tier 5 Strength Warrior`.

Focused tests cover F/G arming, an offhand target order, equipment swaps/removals without equip events, wave endpoints, crosshair position/cancellation, local UI safety and final packaged object data. Compilation, editor/runtime consistency, save compatibility and content checks pass. No Warcraft gameplay was run; actual client visuals, Aqualung channeling and multiplayer acceptance remain pending.
