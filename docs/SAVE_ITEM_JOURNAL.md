# Original item journal and exact storage placement

2026-10-09. Isolated JASS modules `Forsaken-save-journal.j` and
`Forsaken-save-position.j` add read-only original-item journaling and storage
placement primitives. The staging module also tracks temporary slot fillers.
No initializer, command, map integration or publication is added. Saving remains
blocked. Full native quarantine, rollback and load restoration are unfinished.

Following checkpoint: [SAVE_EQUIPMENT_RESTORE.md](SAVE_EQUIPMENT_RESTORE.md)
adds mandatory prepared ability sets to storage placement and a separate exact
equipment primitive. Original equipment still refuses until safely quarantined.

## Journal

`FSJ_Capture(pid, hero, gaya, house, dropGetterVerified)` records all 57 positions:
quick 0–5, bag 6–35, equipment 36–44, Gaya 45–50 and house 51–56. Both ring
positions and every gap remain distinct. The journal retains actual item handles,
rawcodes, charges, user data, engine owners, visibility, flags and exact life words.
It does not create, move, delete or change any original item.

The hero must have exactly 30 bag positions; unexpected capacity refuses capture.
Gaya and house may be absent. Present Gaya/house units must have no extended bag,
and the three units must be distinct. Hero and Gaya belong to the player. House
ownership can be shared: Player.j contains shared-owner storage paths, so capture
records the actual house owner and verifies it stays unchanged. The caller must
resolve the actual account's hero/Gaya/house through trusted game state. Passing
arbitrary house handles is not an authorized entry route.

Droppability remains an engine acceptance gate. `dropGetterVerified=false`
refuses capture before reading inventory. A true value is a trusted caller
capability from native testing or an authoritative adapter; it cannot come from
a save code. The staging module's probe of newly created items does not itself
authorize this capability. The test model supplies it under modeled getter
semantics. Actual original-item getter behavior is still unverified.

Capture uses separate scratch arrays, rejects duplicate actual handles, rereads
occupied and empty positions and checks unit context again before publishing the
item journal. It releases scratch handle references after success or failure.
A ready journal cannot be overwritten. `FSJ_Verify` detects changed metadata,
unit owner/capacity, missing originals or changed positions without mutating them.
`FSJ_Release` forgets handles only when the original view verifies unchanged.
It does not support post-commit retirement yet. Failure retains the journal.

This is an item/position journal, not the complete transaction journal. It does
not snapshot progression, suspended passive bookkeeping, abilities, cooldowns,
eligibility, previously accepted data or guard state. Holding the same handle
does not prove that unequipping/re-equipping preserves those properties.

## Exact placement primitive

`FSP_Place(pid, ordinal, unit, holder, slot, spacerRaw)` operates only on an
allocation already owned by FSN. Ordinal is its zero-based staging index, not
the serialized inventory ordinal. Logical holders 1, 2, 4 and 5 cover quick,
bag, Gaya and house storage, totaling 48 positions. The caller resolves each
destination through reviewed container policy. Occupied destinations refuse
before inventory mutation. Equipment holder 3 refuses before placement.

Quick/Gaya/house placement uses the actual staged handle with UnitAddItem and,
when needed, UnitDropItemSlot. Bag placement fills earlier empty quick/bag slots
with tracked temporary items, adds the actual staged handle, checks the exact
requested position, removes fillers and checks that filler removal did not move
the item. It never uses UnitAddItemToSlotById or creates a replacement copy.

The caller must supply a reviewed inert filler rawcode. Existing BT conversions
use `fGap`; this module does not generate new objects or assume every rawcode is
safe. Each filler is tracked before setters, checked for the requested type and
hidden state, and verified in its intended temporary slot. FSN_Abort owns cleanup
of both fillers and staged items, including partial placement and failed cleanup.
Failed deletion retains references and blocks reuse; a later Abort can retry.
Placement records release item/unit/player references when cleanup succeeds.

State 4 means placement has begun: no more staging is allowed. `FSP_Verify`
checks all placed and still-hidden allocations, including target-unit ownership,
capacity, exact positions and metadata. The ordinary hidden-only FSN_Verify
refuses state 4. This is not a commit state and no load eligibility is consumed.

The caller must hold synchronized exclusion and suppress pickup/drop, conversion,
stacking and passive hooks. FSN_Busy rejects reentrant public calls, but is not a
gameplay guard. An uncontrolled hook could mutate originals even if placement
later detects failure; these primitives do not restore such changes. They also
do not implement safe thread interruption or an operation-cap scheduler.

## Validation and remaining work

19 tests in `test_save_position.py` execute actual JASS control flow with mocked
native inventories and binary32 arithmetic. Coverage includes full 57-position
journals for all eight players, every sparse position, both rings, exact shared
house ownership, duplicate handles, scratch cleanup, metadata/context changes,
release protection and refusal without the droppability capability.

Placement covers every storage position with earlier gaps and complete 48-item
batches for players 0 and 7. Tests inject silent addition failure at all 36
filler/item positions for bag slot 29, creation failure at all 35 filler positions,
failed filler deletion/retry, silent quick-slot movement rejection, reentrancy,
changed target units and later placement/metadata changes. A sparse-neighbor
test verifies the original journal after placement and allocation cleanup.
Equipment is deliberately tested to refuse; no native equipment rollback claim
is made.

All previous 87 tests rerun: 13 staging, 13 JASS codec, 5 life, 14 reference
transaction, 13 reference codec, 16 migration and 13 legacy tests. With the new
19 tests, 106 tests pass. These are source/model tests, not Warcraft execution.
The legacy suite's existing unclosed item-table ResourceWarning remains unchanged.

Standalone, BT-runtime-plus-modules and BT-editor-plus-modules compile probes
pass with the existing extracted local libraries. Report:
`build/save-codec-compile-8rx50iid/report.json` retains scripts and source/library/
compiler/map hashes. Compiler DLL loading again required outside-sandbox execution.
BT still matches its manifest; no map was built or changed and BU is unused.

```powershell
& $ffPython experiments/Forsaken/test_save_position.py
& $ffPython experiments/Forsaken/check_save_jass.py --position --map release/Forsaken/FFERPG_0.9.7.3-r16-ForsakenBT.w3x --common ../war3.w3mod/scripts/common.j --blizzard ../war3.w3mod/scripts/blizzard.j
```

Next: authoritative flags/defaults, synchronized guard and scheduling, complete
session/progression journal, original quarantine, equipment/passive/cooldown
adapters and verified restoration of original handles. Then connect account and
legacy policy, publish only after full verification and test restart/multiplayer/
transport behavior. Preserve the last-good save and keep exports blocked.
