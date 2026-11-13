# Hotfix05 / V9 / Creature Review03l

2026-11-07. Owner reports Hotfix04 failed: load character, open own backpack, drop an item; another player who had not yet loaded disconnected. Owner stayed in game. There is no new report on the owner's computer for this incident; do not attribute the latest local errors folder to it or claim an exact offending script.

## Inventory synchronization candidate (production and development)

UI queries of hero six slots, extended bag contents/capacity and equipment now use shared item snapshots while scripted presentation/input callbacks run. Gameplay callbacks retain native inventory queries. One shared hashtable is created during Inventory94_Init, with per-unit six-slot/bag/equipment records. Bag keys128+slot cannot overlap equipment keys64..72 even for large bags. Missing snapshots fail closed instead of falling back to local extended-inventory queries.

Existing shared UI72 timer refreshes only dirty player inventories or changed hero/Gaya identities before entering presentation scope. Existing Inventory94_Changed item-event classifier marks dirty; ordinary attack/movement events do not. Commit/rollback release marks all players dirty. Shared selection events snapshot selected inspect/NPC units. Retired hero/Gaya snapshots are flushed. All capture/refresh operations defer during profile locks/restoration and cinematic pause. Nested presentation wrappers restore their previous read scope even when wrapped functions return early. No new timer, trigger, frame, native declaration, item conversion, spell cast or damage behavior. Existing engine-native backpack binding, dragging and cooldown UI remain engine-owned.

This removes scripted owner-local extended-inventory scans from the covered UI paths. Native engine rendering/input, item names/art, cursor coordinates, frame presentation and private save-file operations still run locally. The local F/G mouse-focus target-ID boundary described in SYNC_H04.md remains unchanged. This is a reproducible isolation/hardening candidate, not proof of the desync cause or a multiplayer guarantee.

## Development creature display changes

V9 is from V8 with the same production candidate plus:

* Stack-badge root now follows the bottom-right of the native buff bar, aligned beside the status icons instead of above them in the attack/attribute panel. Frame count and read-only stack calculation unchanged. Actual screen placement needs native confirmation.
* Omni Breath retains every accepted mesh/material/texture/animation chunk, but removes the remaining PRE2 particle emitter. RIBB was already removed. This is a second attempt at eliminating the long lines; native visual result remains unconfirmed. Damage/cone and Dusk Wyrm fork breath are unchanged.

Creature Review03l rebuilt from V9: all Review_Add exhibits use SetUnitPathing(true), and D7ReviewNoCollision=false, so ancient uprooting restores collision too. Rooted footprints remain. Standard flying-unit behavior and authored collision sizes remain native. The review retains647exhibits/437unique types, area groups, rare hunts, split commands and current creature content. Existing catalogue unresolved raw m02A remains; no new missing-unit claim.

## Checks and delivery

Nine focused tests PASS: snapshot reads without native inventory access, native gameplay path, dirty-only capture/load suspension, retired identity cleanup, large bag key separation, nested presentation scope, preserved save/cast logic, source/asset comparison and two simulated clients with one loaded/one unloaded during a drop. All three maps PASS playable/editor compilation, startup/source/global pairing and native save/load text safety. Both full maps PASS save compatibility358items/22jobs. Review collision/Omni/badge/root/Dusk parity passes. Archive verification preserves every unmodified resource. These are scripted/static checks, not live multiplayer tests.

Installed TEST FFERPG-0.9.7.5h-Hotfix05.w3x, FFERPG-V9.w3x and FFERPG-Creature-Review-03l.w3x; hashes in VersionHHotfix05/installed.json. Previous maps, plain h, classic1.29.2 and editor master preserved. Current full developmentV9, nextV10.

Live test first: two players, other player not loaded; load the same character, open backpack, drop and pick up an item. Then check F/G equipped item accuracy/icons/previews and moving/equipping items. Check badge location, Omni lines and creature collision in Review03l. Do not promote production until multiplayer reproduction passes.

Implementation: tools/inventory_snap_h05.py, tools/build_inventory_h05.py, tools/build_review03_revision_v9.py; tests/tools path tools/tests/test_inventory_h05.py.
