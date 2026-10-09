# Private house crash diagnostic — BX

Use the new Reforged diagnostic map:
`release/Forsaken/FFERPG_0.9.7.3-r16-ForsakenBX.w3x`.
BW crashed on -savehousecheck in the real engine. The local crash report records
an engine null-address access violation; it does not identify a JASS operation.
BX is a diagnostic to locate that operation, not a verified crash fix. Character
saving remains disabled. Do not repeat the BW house test. BY is next unused.

## When you return

1. Start BX and select your character. You can load the same old save used for
   earlier tests, with some real items in the house if convenient.
2. Stand still and run `-savecheck`. Wait for PASS.
3. Run `-savehousecheck` and stand still. It displays TRACE checkpoints for about
   15 seconds. Each says which operation will run next. If it crashes, report the
   LAST visible `House test: TRACE: next ...` line. If it finishes, send its result.
4. Run `-saveverify`. Expect PASS for unchanged original inventory.
5. Repeat only if the first test finishes with PASS.

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
refuses inventory event registrations outside this reviewed guard. A sixty-second
watchdog attempts cleanup and restores trigger states if the diagnostic action
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

Each checkpoint yields for half a second before the next operation so the engine
can render the message. Busy prevents another house test during these waits.
Timer recovery skips the waits. A native application crash cannot be recovered
by a script watchdog; it requires a new game session.

## Evidence

Eleven probe checks PASS, including busy ownership across checkpoint yields and
non-yielding watchdog recovery. Existing inventory/projection/placement tests are
checked separately. Compiler/build success does not resolve the reported crash.
BX build identity and validation are recorded in HANDOFF.md and STAGES.md.

Historical BW SHA256: `1d4632eb00bbcceea619f8cd9904f1fe4faefbf3408d2f5b627dc22794594741`.
Its automated checks passed, but its house test FAILED in the real engine.

BX SHA256: `cf25d7cbc158399e59d5e3ee2323af91cb51961beb7aefe8ffc262aecf416c10`. Mandatory gates,96 repository tests,
2,000 codec cases and43 focused checks PASS;517 other archive members preserved.
