# Original-item quarantine and verified recovery

The isolated `Forsaken-save-recovery.j` moves and restores original item handles
across all 57 positions. It never deletes originals or substitutes copies. This
is an item recovery checkpoint, not a complete character/session transaction.
There is no map integration or enabled save route.

The user permits cooldown refreshes when changing characters, including recovery
after a failed change. Cooldowns are per-game, never saved, and their equality
is not an acceptance gate. Ability instances and passive bookkeeping are checked.

## Capture and movement

`FQR_Begin(pid, bagAbilities)` requires a verified FSJ journal and the trusted
existing Forsaken bag-ability table. It captures up to 16 native ability IDs and
actual ability handles per item, rejecting duplicates, invalid IDs and excess
entries. It snapshots the known stored-passive fields at keys -1, 0 and 1 through
the bounded count without modifying the table. This is a defined bookkeeping
subset, not a snapshot of every gameplay table.

`FQR_Quarantine(pid)` verifies capture again, unequips/removes the same handles
from their holders, hides them and verifies all 57 positions are empty. Original
metadata and ability instances must remain unchanged. Originals never enter
FSN's replacement ownership list. The caller must provide synchronized exclusion
and suppress inventory/effect hooks; this gameplay guard remains unimplemented.

## Recovery and retention

`FQR_Recover(pid, spacerRaw, ringRaw, markerRaw)` first verifies FSN cleanup of
tracked replacements. Failed deletion blocks before original movement. Untracked
occupants refuse rather than being deleted or overwritten. Equipment restores
first, then storage. Sparse bags use tracked inert spacers; a lone second ring
uses the reviewed inert ring/marker contract from FSE. Metadata is reapplied and
verified: charges, binding/user data, engine owner, flags, visibility and exact
life words. Both ring positions and all sparse gaps must match the original view.

Changed or missing ability instances, altered passive bookkeeping, destroyed
originals and changed unit ownership prevent successful recovery. Abilities are
not recreated to claim equivalence. Only temporary fillers and owned replacements
can be deleted. Failed filler cleanup retains its handle for retry.

States: 0 idle, 1 captured, 2 moving/recovery required, 3 quarantined, 4 blocked,
5 items restored. Failed recovery retains the journal and blocks new staging,
preparation and placement while allowing recovery retry. Best-effort hiding is
not proof of containment: visibility changes can fail. State 5 retains the block
until `FQR_Release` verifies original positions, instances, bookkeeping and no
fillers. `FSJ_RecoveryPending` prevents independent journal release. Releasing
the external gameplay guard remains the future controller's responsibility.

## Validation and remaining gates

20 new actual-source harness tests and all 125 prior tests pass (145 total).
Coverage includes full 57-item recovery, every sparse position, both rings,
player 7 and maximum ability-array index 7295; 57 injected detach failures,
57 silent placement failures and all 35 filler-creation failures; cleanup retry,
unexpected occupants, metadata repair/readback failure, actual ability identity,
bookkeeping changes, destroyed originals, reentrancy and allowed cooldown refresh.
These native operations are modeled; Warcraft engine execution remains required.
Legacy's pre-existing unclosed item-table ResourceWarning remains unchanged.

Standalone, BT-runtime and BT-editor read-only compile probes pass with extracted
local libraries. `build/save-codec-compile-3e9quhly/report.json` retains hashes and
scripts. Compiler DLL loading required outside-sandbox execution. There is no
fresh installed-version claim.

```powershell
& $ffPython experiments/Forsaken/test_save_recovery.py
& $ffPython experiments/Forsaken/check_save_jass.py --recovery --map release/Forsaken/FFERPG_0.9.7.3-r16-ForsakenBT.w3x --common ../war3.w3mod/scripts/common.j --blizzard ../war3.w3mod/scripts/blizzard.j
```

BT remains unchanged, SHA256
`4a7cd22fe195ffec8740ff418c0d02ea17d6539d275348962f7609a34aea74b2`.
BU is unused and exports remain blocked. Complete progression/session capture
and rollback, derived stat/effect verification, live policy/default loading,
reviewed ring filler objects, synchronized guards/scheduling, accepted-data
publication and real restart/multiplayer/transport tests remain required.

Following checkpoint: [SAVE_PROGRESSION_JOURNAL.md](SAVE_PROGRESSION_JOURNAL.md)
adds bounded live progression recovery and independent guards. Full unit/session
and derived-effect recovery remain required.
