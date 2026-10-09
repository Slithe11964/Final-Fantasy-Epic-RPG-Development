# Guarded contained item creation and placement

2026-10-09, isolated internal native route; no map build or usable load command.

The cargo journal now drives the existing item primitives while replacement
hero/Gaya units remain contained. Begin and Plan retain the reviewed runtime
rawcodes and exact positions. StartItems freezes a nonempty plan and enters
staging state5. Stage allocates the next planned rawcode with supplied exact
life words, flags, quantity and binding. All planned items must be allocated
before PrepareItem classifies their abilities and suspends stored passives.
All abilities must be prepared before PlaceItem writes any inventory position.
Seal still requires the complete exact51-position audit and prepared hero core.
An empty plan uses the existing direct seal path.

FSN_StageCore, FSA_PrepareCore, FSP_PlaceCore and FSE_PlaceCore are internal shared
implementations. Their operation permit is specific to that primitive and rejects
nested execution. The original public functions retain every original phase
guard. The cargo wrapper validates its contained context, previous allocations,
original inventory and prepared core, then holds the shared lock while invoking
one permitted primitive. It clears the permit and keeps item cleanup locked
through post-operation readback. FSJ_VerifyCore reads original inventory under
that existing lock; the public verifier retains its busy/reentry refusal.
No recovery-block flag is temporarily cleared to grant access.

Partial-batch verification accepts only known allocations, either hidden/unowned
or in their planned exact positions. It checks metadata, prepared ability sets,
existing placements and every owned unit's occupied slots. Calls refuse before
writing when the batch is incomplete, the plan/context is wrong, or preparation
is missing. A failed primitive or post-readback changes cargo state to cleanup
blocked and preserves the pending disposal guard. Native failures use the
existing owned-allocation cleanup; refused deletion retains the actual handles.
Recovery now also audits and retries cleanup of temporary bag/ring fillers.
Original or duplicate filler handles are refused before removal.

Place equipment before filling all quick/backpack positions: native equipping
requires temporary inventory capacity. This is placement order, not a change
to saved slot positions or record order. A lone alternate ring uses the existing
reviewed inert ring filler. Sparse bag placement fills earlier empty positions,
then removes fillers and verifies the requested item stayed in its exact slot.
The caller supplies reviewed filler rawcodes and harmless marker, ability policy,
metadata and staging coordinates. These are internal runtime-policy inputs,
not extra trusted fields read directly from a save code.

The complete saved-profile-to-native policy adapter is still pending. House
records are still refused; original house quarantine/placement remains separate.
Equipment side effects must agree with the prepared core or the call fails with
recovery retained. Expected equipment/combat projection, loaded activation,
broader player effects, final controller commit and installed-engine acceptance
remain open. The caller must suppress synchronized gameplay hooks throughout.
Tests use mocked natives; operation-budget and real hook behavior require engine
testing. No original heroes are retired and full new saves/loads remain blocked.

Run test_save_cargo_placement.py, plus the native/storage/equipment/cargo
regressions. Compile with --cargo --job-policy --gaya-policy --freelancer-policy
--player-target and the existing BT/native-library arguments.

Validation: 12 new checks and63 focused native/storage/equipment/cargo regressions
PASS. Coverage includes the actual allocation-to-seal51-position pipeline, sparse
bag29, lone alternate ring, player7, exact metadata/passive handling, frozen plans,
incomplete batches, rejected native writes, filler deletion retry, original filler
protection and reentry during primitives and locked post-readback. The original
native compiler regression needed its usual library-access rerun and then passed.
The final two reentry checks pass after the completion helper was guarded.
Three final compile probes PASS: build/save-codec-compile-ngp325p5/report.json.
All22 compiled source hashes match final files; JASS remains CRLF. BT/BU hashes
unchanged, BV unused. The full unrelated repository suite was not rerun.
