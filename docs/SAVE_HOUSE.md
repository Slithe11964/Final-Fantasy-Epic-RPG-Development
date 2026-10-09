# Contained replacement house staging

2026-10-09, isolated internal primitive; no map build or usable load command.

Forsaken-save-house.j provides the separately owned replacement house needed
before saved house records can join the inventory route. It requires a verified
contained prepared hero/Gaya context, the original57-slot inventory journal,
and the current live house matching that journal. The original house may contain
items; this primitive leaves all original handles and contents unchanged.

Stage allocates the same native house type under neutral-passive ownership.
Before mutating it, the journal rejects original/published references and handles
already owned by another replacement journal. The new handle is recorded before
containment setters. Hidden, paused, invulnerable, alive, non-hero, six native
slots, no extended bag and completely empty storage are read back. Shared
exclusion holds through containment and original-inventory/prepared-core readback.
Failed creation or containment retains the pending guard and owned handle, if any.

The new house is deliberately separate from the24 hero-role allocation table.
Its handle participates in the common tracked-handle check. A house-pending guard
blocks cargo begin, empty-pair activation, prepared hero disposal, unit abort and
original inventory journal release. Stage also refuses an active cargo/profile
transaction. This keeps the independent primitive isolated until house cargo
verification and reference integration are implemented.

Recovery deletes only its recorded, unpublished empty replacement. It refuses
references to any live house, original/progression units, another house journal
or the owned hero batch. Unexpected items remain untouched. Failed native deletion
keeps the handle and guard for retry; release requires verified removal. Cleanup
can tolerate owner/containment drift on the owned replacement. Originals and the
previous accepted save code are never changed by this primitive.

States:0 idle,1 verified contained house,2 cleanup required,3 removed awaiting
release. Public calls reject invalid players and callback reentry. Coordinates
must be finite and within the existing staging bounds. Callers must suppress
synchronized gameplay hooks; native mocking/compilation is not engine acceptance.

Validation:11 new house checks and66 inventory/cargo/unit/prepared/activation
regressions PASS. An initial combined run exposed two test-fixture errors; the
corrected house suite passed10 tests, followed by a focused three-test run for
the final prepared-context readback (one new test, two repeated checks). These
are mocked-native checks, not engine acceptance. Three final compile probes PASS:
`build/save-codec-compile-2jn7cj2k/report.json`;24 source hashes/CRLF match.
Reproduce with test_save_house.py and compile --house plus the existing job/Gaya/
Freelancer/player-target policy options. The flag includes inventory/cargo and
prepared dependencies automatically. Compilation uses real BT declarations.

Next: expand the saved-inventory/cargo route from51 to57 positions using this
owned house, audit house placement/effects, recover house cargo before disposal,
and integrate reversible live house references. FIP still refuses saved/existing
house contents today. Reviewed policy initialization, migration evidence,
equipment effects, loaded activation/controller and engine acceptance remain
pending. BT/BU unchanged; BV unused. Full character saving/loading stays blocked.
