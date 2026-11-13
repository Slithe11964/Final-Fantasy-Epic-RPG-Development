# Cross-player native bag closure investigation

2026-10-30: Owner confirms UI77 previews work well, but opening another player's bag appears to close their own bag and vice versa. Owner correctly requires B, native icon and X to be independent between players; specific input was not remembered and is not needed for expected behavior.

Existing UI77 BackpackCloseAction, BackpackToggleAction, PanelAccess and BackpackChatSubmitted callbacks already guard GetLocalPlayer()==GetTriggerPlayer(). Request/close helpers are reached through these guarded local paths or local UI heartbeat. Four mocked remote-player callback checks leave local open/close/selection/visibility state unchanged (build/bag78-owner-guard-checks.json). This is a source observation, not a native-engine proof. No new normal-map patch is made without a demonstrated script fault.

Independent first-hand reports match exactly: https://us.forums.blizzard.com/en/warcraft3/t/new-300-ptr-build-24306/39295?page=5 (September27 post86) and https://www.hiveworkshop.com/threads/new-equipment-inventory-system-in-multiplayer-doesnt-work-properly-forsaken.374745/ (September28 report, October8 followup). The reporter tried separate bags/abilities/cooldown groups without resolving it. These reports are evidence for an engine/native-inventory lead, not proof that this map's specific incident has been attributed. No verified workaround was found in those threads.

## Clean reproduction map

TEST/FFERPG-Inventory-Multiplayer-Check-01.w3x is a standalone native inventory test. Up to8 player-owned testers and nearby couriers use the exact fBag/fGer/ASpc ability definitions from UI77, plus stock six-slot inventory. This isolates the native inventory/configuration from the RPG runtime. There are no frame APIs, custom bag toggles/close handlers, inventory/preview polling, F/G helpers, sync messages or repeating timers. Only a half-second startup timer positions each local camera, then destroys itself. The small runtime and editable source compile; native metadata/config/abilities/imports are preserved and archive readback verified.

Have two people join separate player slots. Each selects their own tester. A opens and leaves the bag open; B opens/closes theirs; swap roles. If cross-closing happens here too, the custom RPG inventory UI/polling is not needed to reproduce this bag symptom. It still would not establish a cause of the separate network desync. If it does not happen, continue isolating the full-map integration. This is a diagnostic map, not a fix. UI77/Hotfix08, releases and master remain unchanged.

2026-10-31: Owner now explicitly confirms opening bags closes other players’ bags. Treat the cross-player symptom as confirmed, rather than tentative. Clean diagnostic-map multiplayer result is still unknown; do not treat the existing callback audit as a fix. QuickUI79 deliberately preserves all bag/input/preview functions.
