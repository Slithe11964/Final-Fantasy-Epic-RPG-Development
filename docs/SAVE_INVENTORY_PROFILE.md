# Saved inventory profile bridge

2026-10-09, isolated internal route; no map build or usable load command.

Forsaken-save-inventory-profile.j parses an explicit complete target code in a
separate scratch context, freezes its material inventory records, and drives the
guarded cargo allocation, ability preparation and exact placement route. It does
not replace the prior accepted code or publish a successful character load.

The codec exposes bounded scratch rows for all57 positions: permanent identity,
ordinal, holder/slot, explicit quantity or absence, binding, exact binary32 life
words, flags and optional metadata dormancy. Payloads remain authoritative. The
bridge clears scratch state after preflight and retains the entire target code
until verified recovery/release, including dormant records. All eight player
scratch contexts are covered by projection tests.

Preflight requires the existing contained prepared hero/Gaya pair and unchanged
original inventory. It checks all358 permanent identities against a caller-supplied
reviewed registry policy and the actual compiled gear/defense alias tables.
Quick/Gaya records use canonical rawcodes; bag gear uses its native variant;
equipment resolves exact slot variants, including primary weapons in offhand.
Missing quantities require an explicit reviewed default for the resolved runtime
rawcode. Explicit quantities0..127 are preserved. Known records require captured
life and flags; unknown identities or optional metadata stay dormant in the source.

Both saved house records (including unknown identities) and existing original
house contents refuse before cargo begins. House restoration/recovery remains
pending. Wrong accounts, cheat flags, migration evidence, registry mismatches,
invalid equipment slots and absent defaults likewise refuse before allocation.
Legacy migration evidence still requires its own reviewed native integration.

Allocation freezes exact runtime targets. Every item is staged before abilities
are prepared; every item is prepared before placement. Equipment is placed in
slot order before a potentially full bag, retaining sparse positions and ring
ordering. Each public step handles one item and advances counters only on success.
Seal uses the existing complete51-position cargo audit. Callback reentry refuses.
Native failure retains the target and guarded recovery state; verified cargo
recovery and release clear the frozen profile. No initializer or chat route exists.

Validation: eight profile tests plus three codec projection tests PASS, alongside
13 existing codec checks and12 cargo-placement regressions (36 distinct tests).
The main combined run passed35 tests; the added occupied-house test and tightened
unknown-house refusal then passed in a focused two-test rerun. These use mocked
natives and are not engine acceptance. Three final compilation probes PASS:
`build/save-codec-compile-p1tf8tny/report.json`, with23 source hashes and CRLF verified.

Reproduce with test_save_inventory_profile.py and test_save_inventory_projection.py.
Compile with --inventory-profile plus --job-policy --gaya-policy
--freelancer-policy --player-target against BT and installed script declarations;
--inventory-profile includes its cargo/prepared dependencies automatically.

Remaining integration: reviewed runtime policy initialization, house recovery,
equipment effects in the prepared hero projection, migration evidence/defaults,
loaded activation and complete transaction/controller acceptance. BT and private
BU are unchanged; BV remains unused. Full character save/load remains blocked.
