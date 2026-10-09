# Owned replacement-unit staging and cleanup

Isolated checkpoint, 2026-10-09. `Forsaken-save-units.j` allocates and tracks
replacement job/Freelancer/Gaya heroes without changing original units or live
hero references. No initializer, load route, reference promotion or successful
commit is added. The playable BT map is unchanged; BU remains unused and saving
remains blocked.

## Why a separate allocator

The current `Job_GetHero` immediately writes JobHeroHash and calls
`Gaya_RecreateSpirit`. Gaya's helper creates a replacement, transfers items,
removes the original and publishes the new reference. Those operations cannot
serve as the staging backend for recovery that preserves original handles.
The isolated allocator calls CreateUnit directly and never calls either helper.

## Allocation contract

Begin requires verified item/progression/hero/session captures, no active writer
and no recovery block. It reserves item-journal release until owned units have
been verified deleted. A batch contains at most 24 heroes: one per frozen job
role 0..21, Freelancer 22 (`H02L`) and Gaya 23 (`H01D`). The active hero will
eventually alias a selected role; there is no separate active allocation.

Stage accepts a role and caller-selected staging coordinates, bounded to
[-32768,32768] and excluding NaN/infinity. This numeric bound is not a reviewed
world location. The caller must supply a valid location and exclude synchronized
gameplay, enter-region, creation, level, inventory and other effect hooks.
Creation uses neutral-passive ownership and facing zero. It records the returned
handle before applying hidden, paused and invulnerable flags. Readback requires
the expected raw type, hero status, neutral owner, all three flags, no live or
journal reference and empty native/extended/equipment inventory. Duplicate roles
refuse before allocation. Previously staged heroes are rechecked before adding
another.

The allocator refuses to adopt a handle already held by another owned-unit batch,
by any of eight players' live job/Freelancer/Gaya/active references, by the cached
Freelancer key, or by item/progression/hero/session journals. It never applies
setters or deletion to such a rejected handle. Native CreateUnit remains the
provenance guarantee for units outside those known references.

## Failure and cleanup

States are 0 idle, 1 open, 2 failed and 3 cleanup unverified. Creation or readback
failure retains any newly created handle, blocks item staging and public codec
mutation/re-encoding, and allows owned cleanup. These guards are independent of
item, progression, hero and session recovery. Other journal releases cannot clear
a failed unit cleanup block. Item-journal disposal remains pending until cleanup.

Abort requires completed owned-item/filler cleanup and an idle writer. Codec
Abort remains allowed. Before deleting anything, unit cleanup checks the whole
batch for published references or carried items. Either condition refuses the
batch; the controller must first detach references and recover/clean items using
their separate ownership journals. Unit cleanup never deletes items itself.

Cleanup rechecks each candidate, attempts containment, rechecks reference/item
safety after setters, then calls RemoveUnit. GetUnitTypeId returning zero and no
remaining known reference are the deletion readback gates. Successfully removed
slots clear; failed slots remain retained in state 3 and can retry. A unit already
removed by another actor clears without a second RemoveUnit call. Cleanup clears
only its own guards after every slot is verified gone. Cross-journal busy flags
exclude reentrant operations during native writes.

## Evidence and remaining gates

20 actual-source harness tests pass. Coverage includes all 24 roles, failed
creation and each of three containment setters, every one of 24 deletion failure
positions/retry, original and cross-player handles, repeated native handles,
changed raw/owner/hero status, items in all three inventory kinds, publication
during cleanup, writer/item cleanup order, reentrancy, independent guards, other
journal releases, player 7/index 191, invalid coordinates and original preservation.
All 219 previous checks pass, giving 239 checks total. These are mocked natives,
not Warcraft execution. The legacy decoder's pre-existing unclosed item-table
ResourceWarning is unchanged.

Standalone, BT-runtime and BT-editor compile probes pass:
`build/save-codec-compile-5anxjlgn/report.json`. The report records source, map,
compiler and extracted library hashes. Compiler DLL loading required execution
outside the sandbox; no installed-current client-version claim is made.

```powershell
& $ffPython experiments/Forsaken/test_save_units.py
& $ffPython experiments/Forsaken/check_save_jass.py --units --map release/Forsaken/FFERPG_0.9.7.3-r16-ForsakenBT.w3x --common ../war3.w3mod/scripts/common.j --blizzard ../war3.w3mod/scripts/blizzard.j
```

Hidden/paused/invulnerable readback does not establish a gameplay freeze or prevent
creation/removal hooks, timers, projections, summoned units or neutral-player
resource effects. Hook suppression, operation-cap interruption handling and a
synchronized scheduler remain required. The full 24-unit batch has not been
measured against Warcraft's operation limits; loops are bounded, but this is not
an execution-budget acceptance claim. Interrupted busy flags are not recovered
by this checkpoint. The caller must not wire these primitives into gameplay yet.

Still required: non-destructive reference promotion/reversal, staged hero
progression and effects, HP/MP and other original body/combat state, live staging
location/policy/filler objects, complete controller and native restart/multiplayer/
transport acceptance. There is no ownership-transfer/commit API yet; every staged
batch must currently be aborted. Cooldown refresh remains permitted.

BT SHA256 remains
`4a7cd22fe195ffec8740ff418c0d02ea17d6539d275348962f7609a34aea74b2`.
