# Reversible replacement-pair exposure — isolated checkpoint

2026-10-09. Forsaken-save-activation.j can expose the prepared active hero and
Gaya at caller-supplied positions after protecting the original pair. It also
returns the replacements to their prior staged positions and containment for
failure cleanup. This is an internal empty-inventory checkpoint, not a complete
character load, gameplay entry route or successful-load commit.

## Preconditions and capture

FHA_Begin requires a prepared owned batch, assigned active/Gaya ownership, a
captured original living-body journal, idle journals/writer and exact original
item verification. Both replacements must be living, player-owned, contained and
empty. Original active/Gaya references must be distinct from their replacements
and preserve captured rawcodes/owners/body values. Frozen skill-table IDs and all
prepared progression/ability values must still match. Dormant replacements stay
contained. Other original units are not changed by this module.

The journal records the original/replacement pair, batch count, desired positions
and each replacement's initial position/facing. Coordinates accept only finite
values in [-32768,32768], facing [0,360). These bounds do not establish a safe
town: the future controller must resolve reviewed spawn positions and pathing.
Capture performs no setters and clears partial references on refusal.

States: idle, captured, exposed, blocked, contained. Independent activation
guards block staging/placement/public codec operations and prevent prepared-plan
discard, ownership neutralization, reference reversal, owned-unit deletion and
original-item journal disposal while the exposure journal is held.

## Exposure

FHA_Expose first hides, pauses and protects both originals. All six original
flag writes must read back before either replacement is exposed. Original owners,
positions, HP/MP, progression, ability instances and item handles are not changed.
Original items remain in place for this checkpoint and are verified afterward.

Both replacement X/Y/facing values are written and verified before visibility or
pause changes. Then each replacement loses temporary invulnerability, becomes
visible and unpaused. Exact pair flags/positions and prepared core/skill/rank
readback must pass before state becomes exposed. Rejecting any setter keeps the
journal blocked. There is no command, selection, camera, ownership or reference
mutation, no resurrection and no deletion. Locks prevent reentrant journal APIs
during setters; they are not a complete gameplay-hook exclusion mechanism.

FHA_Verify checks readiness and exposure, including original item equality.
FHP_CoreMatches is a shared internal data-only readback helper; FHP_Matches still
requires its original strict contained-unit context. Exposure uses a separate
audited identity context before reading the prepared data.

## Recovery and release

FHA_Contain validates owned handle/rawcode/owner/reference identity, hides,
pauses and protects the replacements, verifies those flags, then restores their
staged positions/facing. Failed flags stop before position recovery; failed
positions retain blocked state and may retry. It can also cancel captured state.

Containment does not require unchanged core values or original HP/MP: known
owned replacements must still be made safe if those fields drift. A dormant
replacement's flag drift likewise blocks exposure readiness without preventing
pair containment. Changed ownership/reference/rawcode, cargo or dead replacement
identity refuses native writes and retains the journal; engine exclusion and
interrupted-controller/death handling remain required.

FHA_Release requires verified containment/positions and original item equality.
It clears only activation guards/references and does not approve the target plan.
Prepared/ownership/reference/body guards remain. The controller then discards
the prepared plan, neutralizes/releases ownership, reverses references, cleans
owned units and recovers/releases original state. Original visibility/pause/
protection is restored by the existing body journal after reference reversal.
There is no release directly from exposed state and no successful commit API.

## Evidence and limits

12 actual-source tests plus all 308 prior checks pass (320 total). Coverage
includes all 18 exposure setter faults, all 12 containment/position faults,
retry, cancellation, original recovery, invalid poses/missing preparation,
prepared/original-body/dormant-flag drift, foreign identity/ownership/references,
frozen skill IDs, reentrancy, disposal guards and player 7/keys 14–15.
Standalone/BT runtime/BT editor compile probes pass:
build/save-codec-compile-ths3v4mz/report.json. These are native mocks and compile
probes; they do not establish Warcraft engine behavior or operation limits.

Run test_save_activation.py and check_save_jass.py --activation with the BT/native
library arguments in FORSAKEN_REAPPLICATION.md. Compiler DLL loading requires
outside-sandbox execution.

The future controller must hold synchronized exclusion for gameplay hooks,
movement, combat and regeneration through exposure/readback/failure recovery.
Profile translation/mastery/other effects, item quarantine and prepared inventory
integration, safe spawn/pathing/visual policy, selections/orders, scheduling,
original retirement and full capture/load/commit remain open. Original units and
items are retained; nothing is disposed to make this checkpoint look committed.
No save export/file/restart/multiplayer acceptance yet. BT/private BU unchanged,
BV unused; full new saving/loading stays blocked.
