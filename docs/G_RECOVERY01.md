REFERENCE CORRECTION2026-11-08: retained latest-g below was NOT the owner-confirmed working g. See CONFIRMED_G_RECOVERY04.md and pinned hash in AGENTS.md.

# g Recovery01 / V11: retain accepted fixes, exclude H inventory changes

2026-11-07. Owner clarifies Maiden Eye, teleporter and autosave fixes worked and must survive the recovery. Latest instruction supersedes the previous broad rollback of those independent fixes. It does not establish the exact desync cause.

Production modern/classic is derived from retained released g. DevelopmentV11 is derived from recoveredV10. Maiden Eye aMEy hidden command coordinates were already present in all baselines and are retained byte exact, along with all other objects/assets.

Only accepted travel_h02 and autosave_h02 + autosave_twenty transformations are applied. No backpack_b_h02, item_refresh_h02, ui_stable_h, load_quiet_h03, sync_load_h04 or inventory_snap_h05 patch is applied. All existing inventory/backpack/gear/F-G/cursor/preview/job/character-load/stat functions match the rollback baseline exactly. No Inventory05, InventoryH03, Load04, KeepInventoryFrames or ClearAim helper exists.

Retained fixes:
* Maiden Eye True Sight button remains hidden and cannot replace Q (inherited object fix).
* Modern teleporter layout fits the full page with Cancel above the native HUD, panel level80 and non-intercepting title; click/Cancel/Esc/request/sync logic remains unchanged from g. Classic keeps its existing native teleporter because it has no TravelPanel implementation.
* Autosave defaultON; only explicit -autosave off disables it. First schedule at match minute20, then30/40/etc. Existing staged capture/deferred retry and owner file writer retained. Manual -autosave now does not reset timing. Saving still obeys character-readiness/Hardcore/busy/cinematic conditions.

Scope assertions: nine existing autosave/game-start functions change in every output; only the two TravelPanel render/init functions also change where present. Four autosave helpers added. Every other function matches the input. All archive resources except playable/editor scripts remain byte exact; full development creature/job/difficulty/badge/Omni/arena/import work preserved. Released g/h files and all prior recovery maps preserved.

Validation: six focused test groups reuse executable accepted tests for20/30/40 timing, default/explicit optout, departures, busy/cinematic/load deferrals, failed capture/export retry, staged capture, owner autosave.txt file path, full/partial teleporter geometry and unchanged request/sync/Esc handlers. All groups pass against the new outputs. All three maps pass playable/editor compilation, startup/source/global pairing, native save/load text checks and358item/22job save compatibility. Exclusion and archive isolation verified. This combination has no new live multiplayer confirmation; do not promise a desync root-cause fix or ask for another multiplayer session merely because compile passed.

Installed TEST:
FFERPG-0.9.7.5g-Recovery01.w3x
FFERPG-0.9.7.5g-1.29.2-Recovery01.w3x
FFERPG-V11.w3x
Hashes in release/development/GRecovery01/installed.json. These supersede StableRollback as the requested selective recovery. The exact StableRollback copies remain available as references. CreatureReview03m remains unchanged: no travel/autosave scheduling is exercised by that review, and it retains the requested current creature collision/displays.

Current full developmentV11, nextV12. Builder tools/build_g_recovery01.py; focused verification tools/tests/test_recovery01.py. No editor-master change.
