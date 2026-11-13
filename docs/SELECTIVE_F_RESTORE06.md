# Selective fixes on the dated-f inventory rollback

2026-11-08. Owner requests individual accepted fixes back on Recovery05/V16, plus autosave and cinematic suspension. Owner selects the native backpack with ownership/event routing only. Output: production Recovery06 modern/classic and full development V17. The dated f file and Recovery05 remain untouched.

## Audited requested fixes

| Fix | Result |
| --- | --- |
| House recovery | Already retained: native house-only auras heal 7% max HP and MP per second in 350 range. Both house forms have the auras. No new timer. |
| New Game Plus | Restored by removing only the two lines that replaced its action with SaveUnavailable. Existing reset-code writer, eligibility rules and unlock behavior remain. Minus stays disabled; the Demi Fiend minus-unlock announcement remains absent. |
| Quest `(null)` spacer | Already retained in TText and its quest callers, including removal of blank notifications. Dialogue transmission and real quest text are unchanged. Existing active-scene-only skip guard remains. |
| Teleporter Cancel | Already retained: dynamic page stride, higher frame level and non-interactive heading. |
| Maiden Eye | Already retained: carried sight uses hidden button coordinates (0,-11); Q is not its visible slot. |
| Legendary mastery | Already retained: job changes keep the chosen +10 on each job hero rather than subtracting/reapplying it. No mastery/constructor source changed here. |
| Blizzaga through Gaya | Blizzaga's wave constructor resolves Gaya to that player's current hero, so all three waves start from the hero. This is a shared spell-event operation, not a local preview-origin mutation. The full later native-six-slot preview interception package is NOT restored. |
| Autosave | On by default; first due at 20 minutes, every 10 minutes afterward; explicit off is respected. Busy/cinematic work stays pending. At most one capture begins per heartbeat. Existing f FFL_BeginSave/FRC_StartNow capture, writer, transport and load paths remain unchanged. Modern/dev use the existing shared PrepareInventories heartbeat; classic adds one shared 1Hz timer at startup because it lacks that callback. Legacy Save_Autosave dispatches into this same scheduler, avoiding an independent per-minute save path. No timer is allocated from owner-local input. |

Some fixes predate the reference f; others survived because Recovery05 preserved unrelated modules and object data. They did not all need reapplying.

## Two backpack approaches and selected implementation

1. **Native backpack, ownership/event routing (chosen).** Keep native controls and item binding. Only a selected hero owned by the viewer can be treated as the viewer's backpack context, and inspection is excluded. Remove the global spell-cast observer from the presentation toggle, leaving the native command frame/key route. Drawing a refreshed hero's panel is allowed only for its owner or an explicit inspector. No new panel, timer, inventory snapshot, frame search, forced click, synchronization message or local unit/item/stat mutation is added.
2. **Synchronized per-player visibility intent.** Record each player's open/close request in indexed shared state and render only that player's panel. This requires transporting UI requests into synchronized events and adds a second state layer, so it was not selected or implemented.

Each approach necessarily has player-specific screen presentation. That is distinct from allowing owner-local decisions to mutate shared units, items or stats. Existing f input/presentation variables remain; this is not a claim that all local code was removed. The exact cause of cross-player closing has not been reproduced here. The ownership changes are a candidate fix, not a native multiplayer guarantee.

## Cinematic audit and suspension

The later Inventory94 package mixed shared scene flags with owner-local UI cleanup, item catalogue replacement and load hooks. No evidence proves that package caused the reported desyncs; it is not restored here.

Shared cinematic flags are now set before unit enumeration/pause and scene preparation. Inventory reconciliation, stored-effect scans, panel/stat updates, talent/status/chronicle heartbeats and input/preview entry points return while those flags are active. Initialized local getters are moved after the gate, avoiding native inventory/frame queries before the check. Existing Cine_Exit clears the shared flags, and the normal callbacks then resume. No forced UI cancel or deferred catalogue rebuild is added.

This suspends the relevant inventory/stat/input checks, not the engine/network clock or every map trigger. An already-running save/load operation is allowed to finish through the unchanged f profile state machine; suspending it midway would require changing its timeout/capture lifecycle again. New autosave captures wait until the scene and profile work are idle. Presentation code still exists in the baseline scene exit (selection/camera), as expected. No new local condition selects gameplay pause/resume behavior.

## Deliberately excluded / other changes

Inventory94/FFL94, later item-ability catalogue, load isolation/snapshot layers, automatic frame rebuilding, aim-only refresh and the later six-slot preview interception are still excluded. The separate talent/inspect/B-X visibility refinements from the failed H recovery sequence are not copied back wholesale. These remain possible follow-up display issues, not implicit additions to this build. Existing development creatures, Dragoon/Thief, difficulty scalars, stack badges, abilities, models and arena content are unchanged. Creature Review03o is not rebuilt by this task.

## Validation

Six behavior tests cover 20/30/40-minute scheduling for two viewers, independent opt-out, cinematic/profile deferral, failed capture retention, manual request timing, gating before initialized getters, owner/inspection context and legacy scheduler routing. All three playable/editor/startup/source/global/native-text checks and all three save-compatibility checks pass (358 items, 22 jobs, fixed fixtures). Archive parity permits only playable script and trigger source changes. The profile capture/codec/transport/loading functions are source-identical to Recovery05 (classic startup adds its shared autosave timer); TJob/TText/TTravel/THouse and development monster/job definitions are unchanged.

Builders: `tools/selective_f_restore.py`, `tools/build_selective_f_restore.py`. Evidence and installed hashes: `release/development/GRecovery06/source-verification.json` and `installed.json`. Tests establish source scope and deterministic modeled behavior; multiplayer, native backpack ownership, cinematic visuals and physical autosave files remain unverified in these candidates.
