# Native item staging foundation

2026-10-08. `experiments/Forsaken/Forsaken-save-native.j` is an isolated modern
Warcraft JASS module requiring the life and codec modules. It implements the
allocation/metadata/cleanup part of the reference restore protocol. It has no
initializer, entry route or build integration. No map is changed; saving stays
blocked. This is not the complete native restoration backend.

Following checkpoint: [SAVE_ITEM_JOURNAL.md](SAVE_ITEM_JOURNAL.md) adds an original
item journal and exact storage placement. FSN now also owns temporary fillers
and placement records. State 4 means placement started; use FSP_Verify then,
because FSN_Verify remains hidden-only. Abort cleans both kinds of allocations.

## Lifecycle

`FSN_Begin(pid)` opens an empty batch for human player IDs 0–7. `FSN_Stage`
accepts a resolved rawcode, charges, account-relative binding, flags, exact life
words and staging coordinates. It creates one actual item, records ownership
before its first setter, hides it, applies metadata and verifies readback.
There are at most 57 allocations per player, with separate bounded array ranges.
Charges 0–127 are representable; the normal gameplay target remains 120.

Readback checks actual rawcode, charges, binding, engine owner, visibility,
possession, invulnerability, pawnability and exact life words. Binding becomes
pid+1 for bound items or zero for unbound items; engine owner is Player(pid).
That engine-owner rule still requires integration with reviewed container policy.
Life normalization and reconstruction are checked before creating anything.

Droppability has no direct getter paired with SetItemDroppable. On each newly
created handle, staging sets false and true and checks
BlzGetItemBooleanField(ITEM_BF_CAN_BE_DROPPED) after each change, then sets and
checks the target value. A getter returning unchanged object defaults refuses
the entire batch. This is a runtime consistency check on transaction allocations,
not evidence that original-item flag capture works or that actual client behavior
has been tested. Real-client acceptance remains required. The new module is
modern-only; existing codec/life classic compatibility is unchanged.

`FSN_Verify(pid)` rechecks every staged handle, including whether another system
made it visible or gave it to a unit. Failure marks the batch failed and attempts
to delete only its tracked allocations. Null creation, invalid input, a 58th item
or failed metadata readback follows the same cleanup path. Earlier successful
allocations in the batch are also removed; partial staging is never success.

`FSN_Abort(pid)` deletes tracked allocations and checks GetItemTypeId==0 before
forgetting each handle. Successfully removed entries clear their metadata. A
failed deletion retains the exact handle and blocks reuse, including when other
entries were successfully removed. A later Abort can retry retained entries.
Failure also attempts to hide leftovers, but does not claim containment succeeded
if hiding fails. There is deliberately no promotion/commit API yet.

| State | Meaning |
|---|---|
| 0 | Idle; a new batch may begin |
| 1 | Open; items can be staged and verified |
| 2 | Failed; cleanup completed, but Abort must acknowledge before reuse |
| 3 | Cleanup unverified; handles retained and reuse blocked until verified cleanup |

FSN_Busy rejects reentrant public operations during setters/removal. The Check,
Cleanup and Fail helpers are internal implementation contracts, not entry routes.
The module does not supply the synchronized gameplay guard required by its caller.
It does not freeze a player, intercept other systems, prevent thread termination
or recover a thread killed by an operation cap. A blocked batch requires the
future controller to contain the player. Do not clear its arrays to unblock it.

## Evidence and remaining integration

`test_save_native.py` executes the actual JASS functions with mocked native
behavior and binary32 arithmetic. Its 13 tests cover all eight players with full
57-item batches, all flag combinations, fractional life, bound/unbound markers,
allocation failure at each of 57 positions, every silent metadata setter failure,
stale object-default droppability reads, later readback changes, life clamping,
reentrancy, invalid bounds, partial/failed deletion and retry. A simultaneous
hiding/deletion failure explicitly retains a visible allocation and reports
blocked; the test does not call it safely quarantined. Source checks exclude
original inventory placement/equipment APIs and accepted-code mutation.

All previous suites rerun: 13 JASS codec, 5 life, 14 reference transaction,
13 reference codec, 16 migration and 13 legacy tests. With 13 native staging
tests, 87 tests pass. The source harness is not Warcraft execution.

Read-only standalone, BT-runtime-plus-modules and BT-editor-plus-modules compile
probes pass with extracted local libraries. Report:
`build/save-codec-compile-26ozv4tt/report.json` includes retained scripts and
module/compiler/library/map hashes. BT still matches its release manifest.
No fresh installed-client version claim is made. Compiler DLL loading required
outside-sandbox execution, as in the previous checkpoints.

```powershell
& $ffPython experiments/Forsaken/test_save_native.py
& $ffPython experiments/Forsaken/check_save_jass.py --native --map release/Forsaken/FFERPG_0.9.7.3-r16-ForsakenBT.w3x --common ../war3.w3mod/scripts/common.j --blizzard ../war3.w3mod/scripts/blizzard.j
```

The caller must resolve canonical identities/container variants, legacy defaults,
mode/account/equipment eligibility and reserved records before staging. It must
provide safe staging coordinates and synchronized exclusion of gameplay changes.
No rawcode from an untrusted envelope is accepted directly by an entry route.

Next integration work is complete native original-state capture and journaling,
authoritative original flags, exact position placement, stored/equipped passive
handling, progression application, verification and synchronized publication.
Existing conversion code uses spacer items and verifies actual handles because
UnitAddItemToSlotById previously produced ground duplicates. Reuse that lesson,
not an assumed-success setter. Original item cooldowns/abilities and player
progression must also survive rollback. Keep original handles alive until commit.
Only then add routes and perform restart, legacy and multiplayer acceptance.
