# Native item previews: UI77 / 0.9.7.5f Hotfix08

Owner reports Ice Wand U showing a water preview, then no preview, and Book of Depths/Wateraga losing previews after drops/pickups. Clarification places Ice Wand U in the hero quick inventory middle-left and Book of Depths beside it, probably middle-right. Owner wants Gaya item runes to originate at the loaded hero.

## Changes

Only four TEquip functions change from UI76/Hotfix07, plus three local presentation diagnostic scalars. No new functions, callbacks, timers, hooks, overlays, frame/image handles or gameplay writes are introduced.

- Preview75_QuickSlot: replace the decorative-cover-derived .4907 column origin with .516175, giving console-space centers .5318/.5718 at scale1. The former geometry identifies the left-center as the right slot and misses the right-center, consistent with the report. Native FDF supplies .03125 button size and .04 column/.03815 row spacing. Absolute native placement still requires client acceptance; no API exposes the button's absolute location. Local installed FDF files and the community inventory implementation were consulted; this is a source/reproduction-based alignment correction, not a live measurement of the user's current UI scale.
- BagScreen_Click66: remove the stale .12-second post-move veto. The explicit BagMoving64 placement branch still ignores item placement. New recognized inventory clicks always clear the preceding visual, including empty/unsupported slots. Fresh item type is looked up per click; the existing original/equipped/quick-slot aliases remain unchanged. Added last-slot/item/spell diagnostic scalars are displayed by existing -gearcheck only.
- Wave65_Draw: position all water/ice geometry from Player_GetHero(GetLocalPlayer()). Preview75Caster continues to identify the real item holder for selection validity and spell-event cleanup, so Gaya can stay selected while the hero supplies rune origin.
- QuickGear_Diagnostic: print last native click slot/raw/spell and current preview mode, for any remaining client alignment issue.

The Idle76 shared F/G equipment reference cache, idle mouse gating, synchronized cast receiver, F/G dispatch, cooldowns/icons, spell balance, actual item holder, shape geometry and all assets are unchanged. This does not claim resolution of the multiplayer desync.

## Validation and acceptance

Five focused checks exercise actual transformed function bodies: water-to-ice switching, original and repicked quick-slot aliases, Depths/Wateraga selection, first click immediately after a stale move timestamp, ignored explicit placement, clearing unsupported slots, the adjacent-column regression, Gaya selection with hero-origin rune coordinates, unchanged idle/cast handlers and forbidden-mutation/allocation traversal. These use mocked natives. Runtime engine acceptance remains pending.

Outputs: release/development/QuickUI77/FFERPG-QuickUI77.w3x and release/development/VersionFHotfix08/FFERPG-0.9.7.5f-Hotfix08.w3x. Prior candidates, main release and original master remain preserved. Test middle-left Ice Wand U beside middle-right Book of Depths; repeat after dropping/picking up and moving each item. Select Gaya with the hero well away and confirm geometry starts at the hero. If still wrong, existing -gearcheck now records the most recently interpreted slot/item/spell rather than only current hover state.

References consulted (no external code imported): local build/native-ui/inventorybar.fdf and consoleui.fdf; https://www.hiveworkshop.com/threads/inventory-v1-0-8.347464/ (published native inventory implementation's .5318 reference); https://www.hiveworkshop.com/threads/how-can-i-add-frame-events-to-the-default-ui.354804/ (native-button hooks can disturb original actions; hooks remain excluded).
