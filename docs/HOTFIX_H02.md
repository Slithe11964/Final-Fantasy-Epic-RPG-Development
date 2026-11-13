# Production h Hotfix02 candidate — 2026-11-06

Original h is restored as the release after the owner rejected Hotfix01's B-opening behavior. Hotfix02 is a separate TEST candidate containing the fixes below. Modern and 1.29.2 candidates are provided; frame-UI changes apply only to modern Warcraft. Earlier maps, master, V2 and Creature Review 03h remain preserved.

## Autosave

Enabled by default at map initialization. Only `-autosave off` opts the player out; `-autosave on` opts in, bare `-autosave` reports status and no longer toggles, and `-autosave now` queues an immediate test to autosave.txt. Existing Hardcore no-saving policy remains, without silently changing the setting to OFF.

A 600-second repeating timer starts once at actual match start, replacing the disabled 60-second/ten-slot round robin. Every ten minutes all enabled active players are queued, with at most one capture start per retry second. There is no initial fifteen-minute autosave delay. Actual file completion follows the staged capture; up to eight players are staggered rather than captured together.

Missing/incomplete characters, loads, captures, file operations and cutscenes defer the request instead of dropping it. Failed capture starts and failed capture/export completion remain queued with a thirty-second backoff. Autosave uses the existing staged FRC_Start pump, avoiding four hundred inline capture steps in its timer callback. Manual-save behavior and the full-profile capture/codec/account checks, owner-local file writer and local readback remain unchanged. Shared success means export attempted; it is not proof the local file was physically written. Existing local success/readback warnings remain the authority.

No new fast always-on poll. The schedule is now every 600 seconds. The existing one-second retry timer runs only while there is queued work, and pauses when empty. Actual capture uses the existing temporary capture pump.

## Backpack and inspection

Hotfix01's aim-only item refresh is retained: pickups/drops do not hide/reopen talents, buttons, X, F/G or the inspect panel. Its hard closed-intent gate is removed. The old h native observer is restored as the basis; there is no script-generated opening copy. B remains the native hotkey. X resets the key latch; the existing UI tick recovers a swallowed physical key-up. A real B press after X is distinguished from the synthetic close-key echo, avoiding the extra-click dead state.

Native own-inventory context requires selection of the viewer's own hero or linked Gaya. While inspecting another unit, native gear/backpack frames are hidden and the read-only inspect view remains separate. Other players' selection/item events do not change the viewer's panel intent. Surplus visible cached native frames are hidden, leaving one frame of each native kind. The code creates no new native inventory frames. Custom talent/inspect roots have singleton initialization guards; the native saved-game rebuild explicitly clears stale root handles before reconstructing them.

Inspect item tooltips are positioned left of the inspect root, outside the icon grid. Their text/background ignore mouse input. Drawing stats no longer refreshes all 39 item tooltips every half second; the existing inventory revision check owns those updates. Reads defer during the inspected player's item-settle window. Inspection remains read-only and does not move, equip or cast items.

## Teleporter Cancel

The old full-page layout was .552 high and centered at .3, putting its last Cancel button around .04-.08, inside the native HUD. Long pages now fit within .40 with a .585 top, placing all button bottoms above .18. Same ten destinations per page, standard button/background style, labels, keys and sync/Cancel/ESC actions. The panel is foreground and the title is noninteractive. No teleport gameplay changes. Classic native dialogs are unaffected.

## Verification and limits

22 focused executable/object tests: eleven autosave tests and eleven backpack/inspect/travel tests. Both playable/editor/startup/source/global/native-text and save/content gates pass. All unit/item/ability/buff data and codec/readers/writer are unchanged. Header identifies the map as h Hotfix02.

Tests simulate scheduling at ten, twenty and thirty minutes for eight players, at most one start per second, busy/missing-character deferral, failed-start/export backoff, opt-out persistence, bare-command status and owner-only autosave.txt export routing. UI tests cover owner selection, foreign selection events, native frames hidden during inspection, duplicate-frame filtering, X-to-real-B reopening, lost-key-up recovery, preserved item-refresh logic, tooltip placement and long-page Cancel geometry.

Native file timestamps, physical keyboard behavior, pixel hit testing, Warcraft saved-game reconstruction and two-client UI isolation still require in-game testing. No crash-free or confirmed multiplayer claim.

## Owner acceptance and promotion, 2026-11-06

Owner confirms autosave works correctly and other tests seem to work great; multiplayer has not been tried. Promoted accepted content as production h, changing first autosave to minute20 then every10minutes. Identical relevant fixes forwarded to current development V3. Original H02 candidates remain preserved as test history.
