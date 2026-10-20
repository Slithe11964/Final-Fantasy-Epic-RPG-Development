# PAIR035: Speedrun imports, inventory UI and Priest Ultimate talents

Built from the unchanged editor master. Shared changes apply to both profiles; native frames/input remain Forsaken-specific.

## Speedrun imports

Validated imports omit Pram, Luchil, Carob and Zeio Nuts and Gysahl, Mimett and Silkis Greens from all supported holders. Permanent IDs 352–358 remain unchanged. The detached plan is compacted, preserving each retained item's holder, slot, quantity, binding and metadata. The original save is never edited. Final readback compares the complete retained inventory, allowing exactly these omissions in Speedrun. Normal/Eternity compatibility, disabled Hardcore saving/loading, and difficulty provenance/Inferno restrictions remain.

The real bounded-codec check of local dev.txt removes Silkis Greens (358) and Zeio Nut (355) and passes readback. Original file SHA256 remains a88d261e2a18f55981c04842560e78cd1d8b3ab8232fe5a3803da066c2ce3e5c.

## Backpack and armory

Remove the transparent Backpack input overlay and restore native B. Observe native mouse-up and debounced B events; adopt native opening even if custom input was lost to focus. Explicit X/Escape closes the native inventory and both panes. Binding remains bounded, panes stay linked, and Talents preference persists. Private -bagdebug adds mouse/key/request/close/native-retry counters. Frame allocation happens at shared startup; local input/visibility never changes gameplay state.

Armory Back queues navigation until after Channel returns, stops the completed order, then rebuilds stock/category buttons. Root/close state uses the current player's category instead of the changing ability level; Back is re-added after rebuilding. Hints retain their actual clues and omit the repeated house-storage sentence.

## Priest Ultimate row (level 99)

Choose one:

- **Shielding:** final overhealing from Cure (impact/path), Regen and Tranquility adds an equal damage shield. Additions stack and reset a 30-second expiry. Hits consume it, with excess damage passing through; death clears it. Mana recovery, food recovery, unrelated heals and undead-inverted healing cannot create it. Per-hit context captures the qualifying caster and is released on every exit. Regen separates its healing from queued food recovery when Shielding applies.
- **Blessed Rain:** allies in Tranquility take 10% less health damage while the caster channels. Moving out, ending the cast, death, changing job or resetting the talent ends eligibility. Multiple rains do not stack; mana damage is unaffected.
- **Holy Bolts:** basic attacks gain the percentage from health-healing increases (Inner Fire/HP Plus) and Rejuvenation. Rejuvenation alone gives +50%; attack type is preserved. The native Attack tooltip shows the current bonus. The existing physical-attack detector/flags exclude scripted spell/tech hits.

Native row 3 gains icons, hover descriptions and level-99 purchase checks; classic uses its existing dialog. Cure/Regen/Tranquility tooltips append the selected Ultimate talent independently of calculation visibility.

## Tooltip cleanup

Remove the shared STR/AGI/INT/mana-fraction/rounding footer from damage calculations, including dynamic data. Existing descriptions, rank-specific formulas and -spellcalculations on/off remain.

## Warcraft acceptance

Test backpack B/mouse/X/Escape before and after alt-tab, drops/use and job changes. Navigate Body Armors to Armors to root, withdraw and reopen. Import dev in Speedrun and check greens/nuts are absent. Test each Priest choice separately: Cure path healing, normal/Swiftmend Regen, normal/Acid Rain Tranquility, shield expiry/death and Rejuvenation's +50% attack bonus.

Engine/multiplayer acceptance remains required. This change does not claim to resolve the separate older legacy large-profile Warcraft-menu checkpoint issue.

## Validation and delivery

All paired compiler, regression, editor/source/startup, native-save text safety, save compatibility, content, armory/bazaar and conversion gates passed. Native 237/classic 337 regressions have 1/11 expected skips. Final archives contain all 119 calculation entries without the removed footer, updated hints, exact Speedrun filtering/readback and the new Priest hooks. Output/master/tool hashes were audited and both new TEST copies match pair-report.json. Editor master SHA256 remains ae4b422d24c8a5bc5f67250b7ff290b00873cdf1031f7be12071a4e1876e1276.

- Forsaken: 83062a469143b7070e564687a6abd028d5970b3f48082080214869b484e5dbee
- 1.29.2: ce4c38230559e7ed2cac75f4fc9c1479cc1bb20f261182cd0d4a08105586570d
