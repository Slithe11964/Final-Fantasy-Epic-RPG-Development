# Prepared abilities and exact equipment placement

2026-10-09. New isolated modules `Forsaken-save-effects.j` and
`Forsaken-save-equipment.j` add staged ability verification and exact equipment
placement. This is source/model work, not a playable load route. No map was built;
BT is unchanged, BU unused and saving blocked.

## Ability preparation

`FSA_Prepare(pid, ordinal, stored, policy)` operates only on a hidden,
transaction-owned item before placement begins. It enumerates and snapshots all
native ability IDs before removing anything. The trusted policy classifies every
ID as a removable stored passive (1) or retained active/harmless marker (2).
Unclassified IDs, duplicate IDs, invalid roles and more than 16 abilities refuse
the batch. Sixteen IDs per item keep all eight players' 57-item arrays within
the JASS array bound (last index 7295).

For bag storage it removes only classified passives, then verifies absence of
every removed ID, presence of every retained ID, exact ability count and absence
of unexpected IDs. For quick, Gaya, house and equipment destinations it retains
the created ability set. Active abilities are not removed and re-added. A setter
return value alone never establishes success. Preparation failure deletes only
owned allocations, retaining failed deletions and their metadata for retry.

The entire batch must be prepared before the first placement. Storage placement
now requires prepared effects and the correct destination mode: bag items must
have stored passives removed, other storage destinations must retain their set.
`FSP_Verify` checks abilities as well as item metadata and positions, including
still-hidden allocations. Later added/missing abilities reject the batch.
Cleanup clears ability IDs, roles and readiness only after verified item deletion.

The policy must be generated/reviewed from current definitions and the existing
Forsaken passive classification. It is not supplied by a save. A deployed policy
loader/registry is not implemented by this checkpoint; tests use synthetic IDs.
The existing gameplay passive helpers and tables remain unchanged. Ability
membership does not prove that native unit stats, derived bonuses or cooldowns
are correct; actual client and full-state verification remain required.

## Equipment placement

`FSE_Place(pid, ordinal, hero, slot, ringSpacerRaw, harmlessMarker)` accepts only
prepared, nonstored, transaction-owned gear. It verifies the actual requested
slot after UnitAddItem/UnitEquipItem, then checks the remaining tracked equipment.
It accepts existing equipment only when it belongs to this same staged batch and
still matches its recorded position, metadata and ability set. Any original
equipment refuses before inventory mutation: the future controller must journal
and safely quarantine originals first. Native equip eligibility/job/offhand rules
must also be checked by the reviewed policy adapter; native refusal is detected.

For a lone alternate ring (slot 5 with slot 4 empty), placement creates a tracked
temporary ring filler. It checks its rawcode, hidden state, matching equipment
type and exactly one expected harmless marker ability. The filler must occupy
slot 4 before the actual ring equips into slot 5. Cleanup removes the filler and
rechecks that the actual ring stayed in slot 5. If the engine compacts it into
slot 4, placement fails. Both ring identities remain distinct.

The filler rawcode and marker are trusted reviewed inputs. No inert ring filler
object is installed in BT by this work; defining/auditing that object in a future
experimental map is still required. Native checks cannot establish that an
arbitrary supplied marker has zero gameplay effect. Tests use a synthetic inert
ring and marker; neither test ID is a production definition.

Equipment must be placed before filling all storage, so UnitAddItem can obtain
temporary possession. Temporary allocations remain under FSN cleanup ownership.
Failures in filler creation/equip/removal or actual equip trigger owned-allocation
cleanup. Unverified deletion blocks reuse; no successful original rollback is
claimed. Target-owner changes during placement are checked against the owner
recorded before mutations, not silently accepted as the new baseline.

The same synchronized gameplay exclusion, hook suppression and thread scheduling
obligations still apply. No guard, original quarantine, session/progression
restoration, publication or eligibility consumption is implemented here. Removing
newly equipped items also needs actual client verification for residual effects.
Original ability instances, passive bookkeeping and cooldowns remain untouched
by these modules; a future original-item adapter must preserve and verify them.

## Evidence

19 new source-harness tests cover stored-passive removal, retained active/marker
abilities, invalid/unclassified/duplicate/oversized sets, silent and excessive
removal, maximum array index, every equipment slot, a lone second ring, original
equipment refusal, unprepared/wrong-mode refusal, entire-batch preparation,
changed target owners, filler type/marker/creation failures, silent equip failure,
ring compaction, failed filler deletion/retry, later ability changes, reentrancy
and a full 57-item modeled batch (equipment first, then all storage).

All previous 106 tests rerun: 19 storage/journal, 13 native staging, 13 JASS codec,
5 life, 14 reference transaction, 13 reference codec, 16 migration and 13 legacy.
With 19 new tests, 125 tests pass. Legacy's pre-existing unclosed item-table
ResourceWarning remains unchanged. These are modeled native behaviors, not
Warcraft engine execution.

Standalone, BT-runtime-plus-modules and BT-editor-plus-modules compile probes
pass with extracted local libraries. Report:
`build/save-codec-compile-h6pyfqj1/report.json` retains hashes and scripts.
Compiler DLL loading required outside-sandbox execution. No fresh installed
client-version claim is made; BT still matches its release manifest.

```powershell
& $ffPython experiments/Forsaken/test_save_equipment.py
& $ffPython experiments/Forsaken/check_save_jass.py --equipment --map release/Forsaken/FFERPG_0.9.7.3-r16-ForsakenBT.w3x --common ../war3.w3mod/scripts/common.j --blizzard ../war3.w3mod/scripts/blizzard.j
```

Next: reviewed live policy/defaults/filler objects, complete session/progression
journal, synchronized guard/scheduling, original quarantine and verified original
restoration. Only then connect legacy/account policy and publish after full-state
verification, followed by real restart/multiplayer/transport acceptance.

Following checkpoint: [SAVE_ORIGINAL_RECOVERY.md](SAVE_ORIGINAL_RECOVERY.md)
implements original-item quarantine/recovery. Full session/progression and
derived effects remain open. The user permits cooldown refresh on character
changes, including rollback; cooldown equality is no longer required.
