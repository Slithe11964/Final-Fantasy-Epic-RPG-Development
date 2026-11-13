# UI53 recovery and editor opening investigation

Owner acceptance update: UI53 restores F/G casting, including fresh character
loads. Preserve these input/cast/load functions in later builds. Owner reports
icons alone remain stale until job change; UI54 addresses only their rendering.

2026-10-28. Owner rejects UI52: opening backpack/changing gear crashed;
F/G did nothing at all on load and after job change. Latest game crash at
05:40:02 is a main-thread access violation reading 0xffffffffffffffff.
It does not identify a JASS function; do not assert a proven native root cause.
UI51 also failed loaded F/G and live icons. Automated tests are not client proof.

UI53 returns to the released F/G controls and cast request/receiver. It removes
UI51/52 item-active reattachment, equipment re-seating and deferred load timers.
Load completion only invalidates presentation and clears stale local input/chat
state in both fresh and legacy loaders. Input no longer treats the chat edit
child's own visibility as the chat window's state: Enter/chat/Escape already
track intent. Live slot handle/type changes invalidate the dock. This input
correction is a candidate explanation, not a confirmed in-client diagnosis.

All Wave native inventory-button observers, child/name discovery and recurring
discovery timers are removed. Calculator's known origin command/E observer and
the F/G pending-state rune renderer remain. Native backpack-click preview is
deliberately deferred; do not claim it is fixed. Wave default refresh now applies
this safe recovery policy, and normal native gear refresh uses gear_recovery53.
Aqualung, Sonic Thrust, Cuts combat, job inventory transfer and object tables are
unchanged from UI51. Master and earlier playable maps remain intact.

If F/G still fail: press F/G and type `-gearcheck`. It reports key callbacks,
requests, synchronized receipts, pending state, load phase, selection/chat/key
trigger state and each live item/raw/spell. This distinguishes input gating,
unmapped equipment and cast delivery without moving or modifying inventory.
No key polling fallback or alternate item cast implementation was added.

Checks: four focused recovery regressions pass (visible edit child input,
actual chat/load reset without inventory mutation, live slot invalidation,
packaged removal of unsafe paths and preserved gameplay/object tables).
Playable/editor compilation, source pairing, startup, globals, native text,
content IDs and save compatibility pass. In-client/multiplayer acceptance pending.

## Editor recovery copy

Owner also reports SD graphics did not resolve master opening crash. New editor
crash at 05:43:22 is an access violation during loading. Editor preference still
records Misc assetMode=2/hd=1 and log still includes HD assets; this discrepancy
does not prove the crash is graphics-related. Owner subsequently confirms that a
new blank map opens successfully and UI52's F/G buttons were visible. Thus the
editor crash is specific to loading this master in the current investigation;
the F/G controls were created, with failure before entering targeting. UI53's
input/request diagnostics and the separate recovery copy still need client results.

`editor/FFERPG-Editor-Recovery01.w3x` is a separate diagnostic copy made with
tools/build_editor_recovery01.py. Only the WTG/WCT trigger containers are changed
to their older supported formats, plus a standard map-list header. All 747 trigger
source entries, trigger flags/actions, 576 variables and map header source are
checked unchanged; every other named map resource is byte-identical, including
runtime, terrain, units, doodads, objects, scenario and imports. Its full map
compile/source/startup checks pass. Opening it in World Editor remains unverified.
Original master SHA256 remains
f7108fa827f36f0c73773308b0d464c468c14a2ff3b58b5afde25f492e4a4e7e.
Do not overwrite the master with the recovery copy until it opens successfully.
Computer-use helper initialization failed in the previous turn; no direct editor
or Warcraft UI verification was performed.
