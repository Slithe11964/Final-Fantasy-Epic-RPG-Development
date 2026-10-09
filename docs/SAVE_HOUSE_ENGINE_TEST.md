# Private house engine test — BW

Use the new Reforged diagnostic map:
`release/Forsaken/FFERPG_0.9.7.3-r16-ForsakenBW.w3x`.
Character saving remains disabled. BT and BU are unchanged. BV was an intermediate
private build; BW is the map to test because its guard also covers dynamic quest
triggers and non-gg scalar inventory triggers. BX is the next unused stage.

## When you return

1. Start BW and select your character. You can load the same old save used for
   earlier tests, with some real items in the house if convenient.
2. Stand still and run `-savecheck`. Wait for PASS.
3. Run `-savehousecheck`. Wait for the House test result.
4. Run `-saveverify`. Expect PASS for unchanged original inventory.
5. Repeat `-savehousecheck` once to check that verified cleanup permits another run.

Send the exact House test PASS/FAIL message (a screenshot is useful). A PASS should
mention six exact house slots, quantities0/120/127, binding, life, flags, verified
temporary cleanup and unchanged original inventory. If cleanup needs attention,
run `-savehousecleanup` and report that result too. This is a private test session;
full new-format character save/load is not enabled.

## What the test does

The probe journals the original57 inventory positions and live storage references.
It creates one separate neutral-owned, hidden, paused, invulnerable house and six
zero-ability `fGap` temporary spacer items. It uses the actual native staging,
metadata, ability preparation and house placement primitives. Sparse-first slot
order5/2/0/1/3/4 exercises exact quick-slot movement before filling the house.
Charges include0/120/127; binding alternates; exact145.25 life words and different
persistent flag masks are checked. No real inventory item is moved or replaced.

The probe records and disables every scalar trigger from the base map, including
non-gg triggers, plus the two dynamic quest trigger arrays over a bounded frozen
span. It restores the recorded handles' exact enabled/disabled states. The builder
refuses inventory event registrations outside this reviewed guard. A five-second
watchdog attempts cleanup and restores trigger states if the synchronous action
is interrupted. Cleanup verifies only tracked test items and the unpublished
empty house are removed; original journal readback follows. Failed deletion retains
handles for retry; a failed original readback keeps the diagnostic journal.

The builder verifies `fGap` has no abilities or automatic-use/powerup behavior in
this exact base. All original archive content and editor source are preserved;
only added diagnostic sources, trigger wiring and script/archive metadata change.
The probe does not execute the full saved-profile/prepared-hero controller. Its
purpose is to resolve native house ownership, non-droppable slot movement, zero
charges, life/flag readback and deletion behavior before loaded activation proceeds.
Mocked-native/compiler/build checks are separate from this human engine gate.

## Evidence

Ten private probe source tests PASS, including trigger guard restoration and
capacity, dynamic quest state preservation, watchdog recovery, borrowed-original
refusal, placement failure and item/house deletion retry. Existing diagnostic,
codec projection and position regressions also PASS (32 tests).

BW SHA256: `1d4632eb00bbcceea619f8cd9904f1fe4faefbf3408d2f5b627dc22794594741`.
Mandatory build gates,96 repository tests and2,000 save-code cases PASS.
Playable/editor/source/startup and installed-library checks PASS. The preservation
audit retains517 archive members and all original editor source.2254 scalar
triggers and the two bounded dynamic quest trigger arrays are covered. Reports:
`release/Forsaken/checks-r16-stageBW.txt`, `build-r16-stageBW.json`,
`save-probe-BW.json`. Scratch: `build/SaveProbeBW-ojh6s931/FFERPG`.
BT and BU hashes are unchanged. Full details are recorded in HANDOFF.md/STAGES.md. The reproducible
builder is `experiments/Forsaken/build_save_probe.py --stage BW --house-probe`;
existing output names are refused. Build inputs are BT and gear-slots-BS.json.
