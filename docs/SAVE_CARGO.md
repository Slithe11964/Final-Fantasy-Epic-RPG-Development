# Contained replacement cargo journal

2026-10-09, isolated native-source checkpoint. No map build or character-load route.

Forsaken-save-cargo.j adds a bounded cargo journal for the contained replacement
hero/Gaya pair. Begin requires verified prepared heroes, assigned ownership,
switched references, original inventory and no activation or staged items. Plan
records the exact runtime rawcode and position in allocation order. It allows
quick6, backpack30, equipment9 and Gaya6; duplicate positions, invalid players,
out-of-range slots and house records refuse. House restoration remains separate.
The caller must supply reviewed runtime targets from SAVE_INVENTORY_PLAN.md and
suppress synchronized gameplay hooks throughout the operation.

States are idle, planning, sealed, cleanup blocked and recovered. Seal requires
the full planned allocation count, no auxiliary fillers, exact allocation and
placement handles, target owners/slots, item metadata and ability membership.
Every occupied slot in the complete owned hero batch must be accounted for;
other job replacements remain empty. The two ring positions remain distinct.
Prepared core/skill readback still applies. Equipment side effects that change
that projection refuse sealing until their expected projection is implemented.

Ownership and prepared-hero ongoing contexts now use the sealed cargo audit.
Fresh allocation/ownership/preparation retains the existing empty-unit checks.
An unsealed journal grants no exception to those checks. Slot lookup uses a
51-position ordinal table rather than scanning every record for every slot;
per-unit context checks audit only that unit's item records. Full batch audits
also reject duplicate allocation handles. Arrays remain bounded across eight
players (highest cargo position index407).

The independent pending flag blocks prepared-plan discard, neutralization,
reference reversal, replacement deletion, original journal release and activation
capture. Recovery verifies the contained owned context and rejects original or
duplicate tracked handles before deleting items. It accepts item metadata and
prepared core drift so damaged targets can still be discarded. Cleanup runs
under the shared lock and rechecks the context afterward. Failed deletion retains
handles and can retry. Unexpected cargo is never deleted and keeps the journal
pending until removed by its owner. Release requires verified cleanup and every
replacement unit empty; it clears the plan and ordinal table before releasing
the guard. Cargo recovery/release precedes player recovery and prepared disposal.

This checkpoint does not grant FSN/FSA/FSP/FSE phase-aware allocation/placement
authorization. Their existing journal guards remain enforced. Tests construct
detached adapter-output fixtures to exercise the actual JASS audit and cleanup;
they do not demonstrate a working native placement route. Auxiliary fillers,
original house quarantine, equipment effects, loaded-pair exposure and the final
synchronized controller still need integration. No successful commit or original
hero retirement is added. Engine hook behavior and operation-budget acceptance
are still required before playable loading.

Run test_save_cargo.py and compile with --cargo plus --job-policy --gaya-policy
--freelancer-policy --player-target and the existing BT/native-library arguments.

Twelve new actual-source checks PASS, covering full51-slot cargo, player7,
metadata/ability/position drift, separate rings, unexpected/dormant cargo,
original/duplicate handle refusal, deletion retry, cleanup reentrancy and
post-cleanup context drift. The final full-slot check also passes after temporary
item-reference cleanup. Three final compile probes PASS:
build/save-codec-compile-v7_1uxkv/report.json; all22 source hashes match and JASS
remains CRLF. BT/BU hashes are unchanged, BV unused. Native mocks and compilation
do not establish installed-engine placement, hook suppression or operation limits.

All122 focused unit/reference/ownership/prepared/activation/player-target/storage/
equipment regressions PASS. The initial134-test combined run had one new-fixture
error (an extra ability lacked its mock native object); after fixture correction,
the full12 cargo checks and the final full-slot check pass. No older regression
failed. The complete unrelated repository/codec suite was not rerun.
