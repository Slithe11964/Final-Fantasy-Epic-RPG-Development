# Synchronized loading hardening: h Hotfix04 / V8

2026-11-06. Production Hotfix03 failed multiplayer: the latest Desync.txt records turn 758 with six players. This is a network desync report, not an ACCESS_VIOLATION report, and it does not identify the offending script. The report, replay and logs are preserved alongside Hotfix04. Autosave is not established as the cause.

Warcraft runs synchronized simulation on all clients; it has no separate authoritative map-script server. Game state must agree on every machine. Cursor positions, frame presentation, private file IO and sending an input request necessarily remain local; their results must not independently mutate simulation state.

## Changes

* One shared, read-only load predicate covers all eight players' profile locks/restoration phases and a half-second shared settling period following successful commit or rollback.
* Defer Chronicle inventory/restoration checks, item/passive reconciliation, maintenance, status cleansing, shield/stat display, spell-calculation/panel updates, armory polling and development stack-badge drawing while that predicate is active. The one-shot passive timer schedules a retry, so suspension cannot permanently disable stat refresh. Ignore retired units in deferred status cleansing.
* Remove an unnecessary shared BJ loop-index assignment inside the owner-only load-code UI branch.
* Private file-transfer packet construction uses the private string arena explicitly. The owner-only legacy checksum reader uses an immutable lookup without a reachable lazy shared-hashtable initializer. The existing startup already initialized that lookup synchronously; this closes a potential boundary, not a proven executed failure.
* Wave previews use cursor coordinates without acquiring a local mouse-focus unit handle. Existing F/G receiver/target lookup/native item cast behavior is retained. No new polling timers, frames, native declarations or target registry.

## Audit limits and remaining local work

Reviewed GetLocalPlayer blocks/owner-only returns and reachable helpers for handle construction and game mutations. The reviewed paths did not reveal a demonstrated local unit/item/group/timer allocator that explains this report. Frame acquisition is cached/shared; private file transport is intentionally local. This is not a formal proof that the entire map cannot desync.

F/G still reads the local mouse-focus unit and communicates a target identifier to its existing synchronized receiver. This is a residual boundary to investigate if reproduction continues. A proposed replacement was excluded because the assumed native event-target API does not exist in this Warcraft API. Do not claim that F/G target capture moved to shared mouse events.

The ordinary save scheduler/codec, first autosave at minute20 and subsequent10-minute schedule, item tables, objects, all assets, arena teams, development creatures/jobs and accepted UI behavior are preserved. Actual file output remains owner-only. Transfer and profile workers continue running during suspension; otherwise loading would deadlock. Existing historic workers are not all capped at10Hz by this patch; it adds no worker/timer.

## Validation and delivery

Five focused tests pass: all-player lock/phase/grace behavior, observer ordering, one-shot retry, private codec boundaries and unchanged autosave/F/G receiver paths. Both packages pass playable/editor compilation, source/global pairing, startup wiring and native save/load text checks. Save compatibility passes358items/22jobs. Archive readback verifies only war3map.j and war3map.wct changed; all objects/assets unchanged.

Installed separate TEST candidates FFERPG-0.9.7.5h-Hotfix04.w3x and FFERPG-V8.w3x; installed.json records hashes. Original h, Hotfix03, classic1.29.2, V7, CreatureReview03k and editor master preserved. Current full developmentV8, nextV9. Do not promote these as multiplayer verified.

Live acceptance: repeat the same multiplayer character load first, then open/close inventory, equip/unequip, hover gear and preview/cast staff/book via F/G. Multiplayer and native file-output acceptance remain pending.

Sources: tools/sync_load_h04.py, tools/build_sync_h04.py, tools/tests/test_sync_load_h04.py.
