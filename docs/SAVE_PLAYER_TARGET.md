# Reversible Gaya research and skill-choice targets

2026-10-09, isolated checkpoint; no map build or successful load/commit route.

Forsaken-save-player-target.j applies a narrow player target after owned hero
preparation: Gaya's three purchase research levels and six per-game skill-choice
slots. It does not apply currencies, titles, talents, Chronicle effects or ability
availability. The extracted common.j exposes SetPlayerAbilityAvailable but no
corresponding native getter. Spiritual Power availability remains a controller
target requiring a reviewed verification/rollback mechanism; no invented getter
or unchecked availability setter is used here.

FPT_Begin requires idle journals, contained assigned replacements, prepared exact
core/ability readback, original progression/session journals and no activation
pending. It accepts three saved support ranks0–3 and verifies the prepared Gaya
native ranks match max(1,saved rank). It captures the current Resi/R00F/R00G counts
and six choice integers only if they agree with the original journals. Purchase
targets are0 for saved rank0 and1 otherwise; the six choice targets are0.
Capture performs no native setters and rejects invalid/drifted context.

States are idle, captured, applied, blocked and recovered. Apply requires the
captured player values still match and verifies the prepared hero state both
before and after writing. Three research setters and six choice assignments
receive complete readback. Research side effects that change the prepared core
prevent applied state. Failed writes retain the player journal and pending guard.

Recovery restores all three original research counts and six original choice
integers, with readback and retry. It still permits prepared core drift so the
changed target can later be discarded. It requires the known owned pair remain
contained with the same references/owners; activation must first be contained
and released. Foreign ownership/references or pending activation refuse setters.
There is no release from captured/applied/blocked state. Release after verified
recovery clears only this player pending guard; preceding journals remain.

The player pending guard blocks prepared-plan discard, ownership neutralization,
reference reversal, owned-unit cleanup and original-item journal disposal.
Existing journal locks exclude reentrant apply/recovery/disposal. A controller
must suppress synchronized gameplay/research side effects through this operation.
Recovery/release precedes prepared-plan discard and the established ownership,
reference, owned-unit and original-state recovery path. No successful commit API
or old-unit retirement is added.

Evidence: ten new actual-source checks and74 focused prepared-hero/unit/ownership/
reference/activation regressions PASS (84 unique checks). Coverage includes
research setter faults in both directions, six rejected choice assignments,
exact restoration, reentrancy, capture drift/invalid supports, player7, core side
effects and activation/foreign-owner recovery refusal. A rejected no-op write is
accepted when the required value already reads back exactly. Native mocks do
not establish engine research lowering or gameplay-hook behavior.
Standalone/BT runtime/editor compile PASS:
build/save-codec-compile-f77nce38/report.json. Run test_save_player_target.py and
compile --activation --job-policy --gaya-policy --freelancer-policy --player-target
with the existing BT/native-library arguments. The complete older suite was not
rerun; BT/BU hashes unchanged, BV unused, full saving/loading remains blocked.
