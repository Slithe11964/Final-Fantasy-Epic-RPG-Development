# 0.9.7.5b — Backpack, cooldown groups and Priest healing

## Changes

- Forsaken Backpack visibility is controlled by explicit Backpack/B, X and Escape input. Slot changes, selection changes, combat, and native visibility changes do not change the requested open/closed state. Talents retain the player's toggle preference.
- Mouse input uses the real ASpc command event. The intercepting button overlay, native-open adoption, binding timeout cancellation and automatic hide/rebind phases are removed. No timer activates a command-card button.
- Keep the native inventory's item/icon/charge/cooldown cache and update the existing panes in place. Local polling uses references reserved during shared startup; cached panel selection runs only after an input/item refresh notification. It does not rebuild inventory contents or hide/reopen panes for a refresh. Legacy debug `input=no` is expected because there is no intercepting overlay.
- Shared gear cooldowns follow armory subcategories: Physical Weapons (including celestial weapons), Magical Weapons, Elemental Books, Buff Tomes, and the existing shield, armor, ammunition and accessory leaf categories. A rod and an elemental book can be used independently. Equipped, quick-slot and stored aliases share their category, including use through Gaya. Food/potions keep their separate consumable pool.
- Each of the 18 materia types has its own cooldown, separate from gear, consumables and other materia. Duplicate copies of the same type retain the same cooldown. Engine icon cooldown groups and scripted admission checks agree. Native expiry keys have their own namespace, separate from item/ability registry entries.
- Miracle Piece accepts charged targets with zero hold-level requirement, including when cast from Gaya. Empty or non-charged targets remain ineligible.
- Acid Rain at master rank heals **200 base HP every 0.1 seconds** and deals **2,000 base magic damage every second**. Healing resolves through the existing heal calculation on each script pulse; damage remains a separate once-per-second effect. Lower ranks use their authored values; existing modifiers still apply.
- Regen keeps its target in the periodic update group while its buff is active, even when Shielding consumes the healing accumulator. This fixes the first-tick-only failure and lets subsequent healing numbers appear.
- Shielding converts **25% of overhealing** into a shield. Contributions stack, with expiry 30 seconds after the latest addition. The talent description is updated. A 400-point heal on a target missing 100 HP adds 75 shield, before any further difference caused by healing modifiers.
- Remaining shield is a gold world label above and to the left of its unit, replacing the clipped corner display. Its texttag follows the unit and is cleaned up on depletion, expiry or death. Texttags are created from shared gameplay paths; only visibility is private to the owner.
- Healing numbers (including MP recovery) appear to the left of damage numbers.

## Build and compatibility

Final paired stage: **V0975B4**, public filenames `FFERPG-0.9.7.5b-Forsaken.w3x` and `FFERPG-0.9.7.5b-1.29.2.w3x`. The earlier V0975B validation pair was superseded before public packaging when the user refined cooldown grouping.

The editor master is unchanged: `f7108fa827f36f0c73773308b0d464c468c14a2ff3b58b5afde25f492e4a4e7e`. Both builds are derived from that same master through the paired overlays. Portable-save layout, item/job identities, reader/writer behavior and the user's edited Intro/Reminder text are preserved. This does not resolve the separately reported legacy Warcraft menu-checkpoint loading failure for large imported profiles.

Automated validation: 272 native tests (2 expected skips), 372 classic tests (13 expected skips), playable/editor compilation, startup/source checks, fixed save fixtures and 2,000 randomized save-code round trips, native compilation with deprecated aliases removed, and final archive/source audits. Packaging changes only map-list headers/filenames; checked MPQ bodies remain identical. TEST installation is verified by SHA-256.

No Warcraft gameplay or real multiplayer session was run by the agent. Acceptance testing should start a new 0.9.7.5b session, import the existing character and check mouse/B/X/Escape, item movement/cooldown overlays, separate versus matching cooldown categories, Gaya Miracle, repeated Regen, Acid Rain cadence and shield expiry/absorption. Automated tests cannot establish multiplayer engine behavior.

Native SHA-256: 8a3b0c0d69320265d318bf8fee2bc46c9c48f25255bafa59c42615eb390445f7

Legacy SHA-256: 7c7ddaa061157cd07ecd8251d6cc7b686c81813194c1d3c63ca11a1a9942c207

Reports: `release/0.9.7.5b/release-report.json`, `release/pairs/V0975B4/pair-report.json`, `build/V0975B-final-audit.json`, `build/V0975B-TEST-install.json`.

## Implementation references

- [Native frame/event behavior](https://www.hiveworkshop.com/threads/how-can-i-add-frame-events-to-the-default-ui.354804/): attaching a simple-button frame event can replace its existing handler; the Backpack uses the ability command event instead.
- [Item ability cooldown experiment](https://www.hiveworkshop.com/threads/item-abilities-with-cooldowns.323800/): the used ability supplies duration, while the item cooldown group controls sharing.
- `experiments/Forsaken/BackpackVisibility.j`, `SharedItemCooldown.j`, `PriestShieldDisplay.j`; `tools/inventory_ui.py`, `equipment_integrity.py`, `priest_followup.py`.
