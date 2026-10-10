# Private house placement diagnostic — CB

Use the new Reforged diagnostic map:
`release/Forsaken/FFERPG_0.9.7.3-r16-ForsakenCB.w3x`.
BW/BX crashed outside the terrain. BY corrected that point and no longer crashed,
but failed on the first staged item's allocation/properties. Its final STEP10 was
trigger restoration after the failure, not completion of all item stages. Manual
cleanup then PASSed and verified original inventory unchanged.

BZ identified an exact item-health readback mismatch for the old 145.25 fixture.
Clamping is a hypothesis; BZ did not report actual or maximum health. CA uses
exact fractional 50.25 (binary32 words16969/0) and reports wanted, actual and
maximum health if readback fails. It
still reports any failed item check in `[native: ...]` and separately reports
`cleanup`, `originals`, and `release`. It also allows one guarded next-frame cleanup
readback, retaining unresolved handles. Strict property checks remain enforced.
CA passed all six item metadata and ability preparation stages, then failed the
first placement at zero-based slot5 (the sixth temporary-house slot). Cleanup,
original inventory readback and journal release all passed; final-saveverify PASS
was user-confirmed. The real house had slots1-4 occupied and5-6 empty. It was not
the destination: the test allocates its own separate initially empty house.

CB reserves earlier empty quick slots with tracked temporary spacers before
adding the staged item. It no longer calls UnitDropItemSlot for sparse placement;
non-droppable flags stay intact. The original move call is a suspected failure
point, not a confirmed engine cause. Placement errors now name target, spacer,
holder, ability or containment readback. Full character save/load remains blocked.
CC is next unused.

## When you return

1. Start CB and select your character. You can load the same old save used for
   earlier tests, with some real items in the house if convenient.
2. Stand still and run `-savecheck`. Wait for PASS.
3. Run `-savehousecheck` and stand still. It displays numbered STEP checkpoints for about
   15 seconds. Each says which operation will run next. If it crashes, report the
   LAST visible numbered `House test: STEP ...: NEXT ...` line. If it finishes, send its result including the `[native: ...]` details.
4. Run `-saveverify`. Expect PASS for unchanged original inventory.
5. Repeat only if the first test finishes with PASS.

Send the exact House test PASS/FAIL message (a screenshot is useful). A PASS should
mention six exact house slots, quantities0/120/127, binding, life, flags, verified
temporary cleanup and unchanged original inventory. If cleanup needs attention,
run `-savehousecleanup` and report that result too. This is a private test session;
full new-format character save/load is not enabled.

## What the test does

The probe journals the original57 inventory positions and live storage references.
It creates one separate house at the original house position, then contains it
under neutral ownership, hidden, paused and invulnerable, and creates six
zero-ability `fGap` temporary spacer items. It uses the actual native staging,
metadata, ability preparation and house placement primitives. Empty earlier slots
are reserved by temporary spacers, which are removed and verified after insertion.
Sparse-first slot
order5/2/0/1/3/4 exercises exact quick-slot movement before filling the house.
Charges include0/120/127; binding alternates; exact50.25 life words and different
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

CB SHA256: `47cf9fc3038f8c87e75be9a494bdd5fe1e647e6e92348db8f759fa6dd375d5f9`.
Mandatory gates,96 repository tests,2,000 codec cases,49 focused checks and three
affected cargo recovery checks PASS. Three dependency compiles and installed-library
finished-map checks PASS.517 other archive members and original editor source
preserved; nine private input hashes match. Human CB acceptance remains pending.

CA SHA256: `f9c49e58ef71e4a084e93020c0769bd82686a0b7e2fd01587aeae5a5a7943fff`.
Mandatory gates,96 repository tests,2,000 codec cases and47 focused checks PASS.
Three dependency compiles and finished map compilation against installed native
libraries PASS.517 other archive members and original editor source preserved;
all nine private input hashes match. Human CA result remains pending.

Eleven probe checks PASS, including busy ownership across checkpoint yields and
non-yielding watchdog recovery. Existing inventory/projection/placement tests are
checked separately. Compiler/build success does not resolve the reported crash.
BX build identity and validation are recorded in HANDOFF.md and STAGES.md.

Historical BW SHA256: `1d4632eb00bbcceea619f8cd9904f1fe4faefbf3408d2f5b627dc22794594741`.
Its automated checks passed, but its house test FAILED in the real engine.

BX SHA256: `cf25d7cbc158399e59d5e3ee2323af91cb51961beb7aefe8ffc262aecf416c10`. Mandatory gates,96 repository tests,
2,000 codec cases and43 focused checks PASS;517 other archive members preserved.

BY also guards FHS_Stage allocation with actual playable bounds and128 clearance.
Earlier BW/BX point(-4096,-28800) is below terrain y=-28672. The original houses
are preplaced h006 objects assigned by Player.j; original loading does not need
this synthetic allocation. Three full-dependency compile probes PASS.

BY SHA256: `ff6ae8d961d131347fb4b65e430bef09bb8b02f74a01e78e48e271da5fd57b2d`. Full build gates,96 repository tests,
2,000 codec cases and60 focused checks PASS;517 other members preserved.

Human BY evidence: first item failed; manual cleanup PASS, originals unchanged.
BZ adds property-level failure reporting and one deferred cleanup attempt under
the existing guard. Constant false/true getter and clamped-life tests distinguish
unsupported or silent native behavior; none is treated as success.

BZ SHA256: `b64570f7cf5818ab9059b6e951725a5c86a950ca229dc366ba1672a68c227b89`. Full gates,96 repository tests,
2,000 codec cases and46 focused checks PASS;517 other members preserved.
