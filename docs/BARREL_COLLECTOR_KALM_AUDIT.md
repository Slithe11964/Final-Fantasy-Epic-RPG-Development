# Barrel Collector and Kalm I/II/III audit — 2026-10-25

Latest test candidates: VersionDHotfix05 (Forsaken and 1.29.2) and QuickUI35 (from QuickUI34). Installed and SHA256 verified in Maps/Download/TEST. Previous fixes remain; original release and editor master untouched.

## Barrel Collector

Keg Hunter is renamed Barrel Collector in runtime, editor source, ability tables and WTS. The title remains index 59; cKeg and existing save bits are unchanged. Partial monograph history remains per-game/session, as before; the completed title persists in saves.

Native builds previously scanned only quick inventory and Gaya. They now scan all six quick slots, 30 native bag slots, nine equipment slots, Gaya and house. Classic scans its seven six-slot backpack pages plus hero/Gaya/house. Pickup and drop events recognize these owned storage holders; events credit successful carrying, not a failed pickup. Periodic checks run regardless of the old inventory revision cache, so native bag transfers/load placements cannot leave progress stale. Distinct monographs remain counted after removal; duplicates do not increment the count. Neither another player's inventory nor ground items count.

## Kalm audit findings and scope

Reviewed KalmSiege, KalmSiege1/2/3 and shared Cine, Text, Cam, Unit_PlayersNearby and defender-spawn paths. Start selection conditions already reject an active cinematic through Unit_PlayersNearby; timer-started Begin/Complete paths already defer while busy. Quest code does not branch gameplay on GetLocalPlayer. Cine_Exit uses local player selection/camera only after shared pause-group cleanup. Shared AI/order/random operations are synchronized script operations. No confirmed direct desync source was found in the reviewed paths. This does not prove engine/multiplayer safety.

All three quest files used global bj_forLoopAIndex/bj_forLoopAIndexEnd for waves and summons. Unit creation/scaling and nested events can overwrite those counters. Converted all such quest loops to local siegeIndex/siegeEnd values, passing the index explicitly through slot predicates (including wrapper predicates). Counts, modulo rules, spawn types, timings, rewards and dialogue remain intact. A behavioral regression deliberately clobbers global counters in a nested callback and confirms all four intended wave iterations and predicate values still occur.

Extended the prior portrait-free transmission workaround to all non-null-speaker dialogue throughout Kalm I/II/III, including starts, briefings, wave announcements and completion. Existing Kalm II opening workaround remains. Text/timing retained; NPC/player labels are supplied without a model portrait. No camera/pause/quest flow removed. Portrait rendering is a suspected engine exposure, not a reproduced or proven crash cause. No current crash report identifying an engine fault was available; local error text files predate the reports.

## Checks and acceptance

All three final playable/editor scripts compile. Startup wiring, source/runtime startup agreement, globals and native text safety pass. All three save compatibility checks pass: 358 items, 22 jobs, fixed G/H fixtures and original flags/readers/writers. Archive readback and unrelated resources match inputs. Eleven Chronicle regressions and one nested-loop regression pass. Final scripts audited: no global GUI loop index or direct local-player branch remains in any of the three quest files; no unit-model portrait dialogue remains there. Old title text absent from final runtime, ability tables and WTS.

Real-client and multiplayer acceptance is still required: collect monographs through native bag and Classic last page, move/drop/reload; replay all three quests with cinematics on/off, including starts, wave transitions, defeat/retry and completion with at least two players. If crashing continues, capture the last line/visual, exact build, client version and matching new crash report/replay. Do not describe these builds as a confirmed crash cure before that test.
