# Item-life conversion and reference restore protocol

2026-10-08. New isolated pieces: `Forsaken-save-life.j`, `save_transaction.py`,
`test_save_life.py` and `test_save_transaction.py`. This checkpoint implements
JASS real/word conversion and a Python reference capture/restore controller.
It does **not** implement a Warcraft restoration backend, live flag capture,
actual inventory capture/placement or a playable save route. Saving stays blocked.

## Binary32 item life

Library TForsakenSaveLife requires TForsakenSaveCodec and has no initializer.
`FSL_Real(high, low)` reconstructs finite positive binary32 values from two
16-bit words using powers of two and an exact 23-bit mantissa. Normal values
start from 1+mantissa/8388608; subnormals start from mantissa and divide by two
149 times. Invalid sign/exponent/word ranges and zero return 0.

`FSL_Pack(pid, value)` normalizes a positive real with at most149 power-of-two
steps, extracts its mantissa without unsafe integer conversion, handles subnormals
by exact integer shifts and reconstructs the value for equality before publishing
FSL_High/Low[pid]. Invalid/nonfinite values leave prior words unchanged. Human
IDs0–7 are checked before array access. `FSL_Encode` returns the reference life
metadata payload or null. `FSL_CaptureLife` reads GetWidgetLife from an existing
nonremoved item and performs no mutation. This is life capture only, not a snapshot.

Tests execute the actual source through the limited JASS harness. A Real32 wrapper
rounds every real arithmetic result to binary32, including division; it does not
mistake the harness's integer-division translation for real division. Expected
words/values come independently from Python struct, not the JASS algorithm.
5 tests pass:5000 seeded finite-positive patterns,1274 exponent/mantissa boundary
patterns and8 authored/fractional examples (6282 total patterns); invalid values
and player IDs; read-only item-life capture; CRLF; bundled/classic1.29.2 compilation.

These are arithmetic-model results, not a test of the Warcraft floating-point
environment. Denormal handling, GetWidgetLife/SetWidgetLife behavior and item-life
clamping still need native tests. Future restoration must read life back and
compare exact words before committing. A flushed/changed value must fail rather
than silently round. The existing envelope life-word validator remains unchanged.

## Read-only reference inventory capture

`capture_inventory()` consumes a caller-supplied live-item view and reviewed
rawcode aliases. Canonical originals, equipment and offhand variants map to the
same permanent ID. It orders occupied positions deterministically, deduplicates
actual handle identities before assigning ordinals and emits life/flag metadata.
It preserves unbound vs account-bound state without serializing a player slot.

The caller must supply a complete view, actual mode-eligible identities, an idle
conversion/transfer context and authoritative flag values. An occupied unknown,
ineligible or foreign-bound item refuses capture; it is not silently omitted.
Unresolved flags, duplicate handles/positions, unsupported noncharged quantity
changes and oversized state also refuse. Charged quantities0..127 are lossless;
normal gameplay target120 remains unchanged. Noncharged default charges come from
reviewed per-rawcode definitions and are not guessed from the runtime variant type.

Unavailable records and unknown optional item metadata can remain inaccessible
reservations. Their exact tuple/ordinal/position is retained and cannot coexist
with a live item at that position. If content becomes available, reconciliation
is required before capture; do not silently turn a reservation into a second item.
The complete envelope still must enforce aggregate section/opaque budgets.

The extracted native declarations contain SetItemDroppable but no matching direct
getter. BlzGetItemBooleanField(ITEM_BF_CAN_BE_DROPPED) exists, but this checkpoint
does not prove it reflects per-instance SetItemDroppable mutations. Live capture
therefore remains gated on a verified getter behavior or authoritative mutation
journal. It cannot substitute object defaults for captured flags. Native binding,
mode eligibility and capture guards also need integration with the existing code.

## Reference transaction and backend obligations

The controller accepts a complete reference envelope and a mandatory expected
account. It validates profile/cheat status and, for migrated data, the original-code
semantic comparison before acquiring a load guard. A future backend must implement
the following operations; tests supply a model backend, not a Warcraft simulator.

| Phase | Backend contract |
|---|---|
| validate_policy/acquire | Check actual mode/load window/once-only/owner/equip rules; acquire a guard that prevents concurrent gameplay mutation |
| journal | Read-only capture of original handles, positions, metadata, engine owner, cooldown/passive/session state, progression, reservations, prior accepted data and eligibility |
| project/resolve | Resolve only reviewed identities/defaults/container variants; missing legacy fields retain explicit current defaults; unavailable records grant nothing |
| create_hidden/configure_hidden | Allocate transaction-owned inaccessible items, recording ownership immediately even if a later operation fails; stage metadata without affecting old inventory |
| verify_original/quarantine | Confirm original state still matches the journal; detach originals alive and inaccessible; never destroy them before commit |
| place/reserve/apply | Place exact positions/equipment, reserve unknown records, reconstruct passive effects and apply staged progression |
| verify_staged | Read actual state back: exact positions, metadata, life, quantities, binding, equipment/passive behavior and progression; setter return values are insufficient |
| publish | Publish accepted envelope and consume load eligibility only after all verification |
| retire_originals | Delete quarantined originals after publication; cleanup failure retains inaccessible originals for retry, never rolls back after irreversible deletion |
| recover/verify_recovery | Restore the same original objects and journaled state, remove all transaction allocations and verify equivalence before releasing the guard |
| contain | On failed/unverified recovery, freeze the affected player and retain the guard; do not report a successful rollback |

Guard acquisition/release and journaling must satisfy their contracts, not perform
hidden fallible gameplay work. Python exceptions do not model a Warcraft operation
cap terminating a thread. Scheduling, interruption recovery, synchronized promotion
and native rollback of cooldowns/abilities are unimplemented engine obligations.

Unknown items or optional item metadata produce Dormant records, no fallback item.
Known items require reviewed defaults keyed by canonical ID and destination.
New captures require actual life/flags; migrated absence can resolve only through
reviewed object defaults with source provenance. The test backend's life99/flags6
defaults are synthetic, not an audited object table to deploy.

Result states: rejected (before mutation), rolled_back (verified restoration),
blocked (recovery unverified; guard retained), committed, or
committed_cleanup_pending (new state accepted; old leftovers inaccessible).
The last successful save file is not replaced by a load attempt. Failed verified
loads do not consume eligibility. A blocked result makes no equivalence claim.

14 transaction/capture tests pass, including all57 positions and both rings,
player-slot-independent binding, unknown reservation preservation, all eight
synthetic legacy translations, deliberate metadata/evidence failures and417
injected positions across create/configure/place/equip/passive/quarantine/progression.
Additional boundary faults cover partial publication, missing journals, failed
recovery and post-commit cleanup. Null creation, silent placement/equip rejection
and life clamping are caught by readback. Rollback comparisons retain object
identity, engine owner, cooldowns, passives, flags, progression, reservations,
previous accepted data, eligibility and last-good-save marker in the model.

## Compilation and remaining gates

Codec+life standalone, BT runtime-plus-modules and BT editor-plus-modules probes
pass against the existing extracted local common.j/blizzard.j. Evidence:
`build/save-codec-compile-otuota82/report.json`, with module/map/library/compiler
hashes and retained scripts. `--life` opts into the new module; each probe run
creates a fresh directory and never modifies the input map. No fresh installed
client-version claim is made. Compiler DLLs again required outside-sandbox execution.

```powershell
& $ffPython experiments/Forsaken/test_save_life.py
& $ffPython experiments/Forsaken/test_save_transaction.py
& $ffPython experiments/Forsaken/check_save_jass.py --life --map release/Forsaken/FFERPG_0.9.7.3-r16-ForsakenBT.w3x --common ../war3.w3mod/scripts/common.j --blizzard ../war3.w3mod/scripts/blizzard.j
```

Other suites rerun:13 JASS codec,13 reference codec,16 migration and13 legacy
decoder tests. Together with5 life and14 transaction tests:74 passing tests.
No gameplay source, release or baseline changed; BT hash still matches its
manifest, BU unused, saving blocked. Next: engine execution measurements/work
scheduling, authoritative flags/defaults, native staging/rollback backend,
in-game legacy linkage, then restart/multiplayer/transport acceptance.
