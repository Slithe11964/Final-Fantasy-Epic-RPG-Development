# Private real equipment and backpack diagnostic — CF

Historical CC SHA256: `56757f112828cf8e313f6f1cb48338870dd5d4aca6aa4f9e392f5e0abc50a534`.
Mandatory gates,96 repository tests,2,000 codec cases and61 focused checks PASS.
Finished-map compilation against installed native libraries PASS.517 other archive
members and original editor source preserved;11 private input hashes match.
CC engine failed before boots staging: requested speed200 read back250; cleanup,
originals and release passed. CD measures starting speed instead of setting it;
the equipment delta80, unchanged stored delta and return to baseline remain strict.
Native effect/equipment acceptance remains pending.
CD passed measured baseline and real item preparation, then failed after Boots
reached equipment slot3: placement ability readback; cleanup/originals/release=yes.
CE keeps strict membership checks and snapshots the missing/unexpected ability,
item enumeration, unit lookup and speed before the failed owned item is removed.
CE engine reported unexpected A0MU while actual item enumeration contained
A0MU,fGmk, with unit lookup=yes and speed440. Cleanup/originals/release passed.
CF also snapshots the prepared count and IDs before cleanup. A simulation of
abilities first appearing on pickup reproduces this failure with an empty plan;
this is a hypothesis awaiting engine evidence, not an accepted native behavior.
Strict membership and speed checks remain unchanged.49 focused checks PASS.
CF mandatory build gates,96 repository tests and2,000 codec cases PASS;
installed-library compilation PASS.517 other archive members and original editor
source preserved;11 private input hashes match the published map report.

Use `release/Forsaken/FFERPG_0.9.7.3-r16-ForsakenCF.w3x` in a fresh Reforged game.
CB's synthetic six-slot house test is user-confirmed PASS. CF includes a separate
`-savegearcheck` without replacing your hero, Gaya, house or any original item.
Full new-format character saving/loading remains disabled.

1. Select your character and load the same old save if convenient.
2. Stand still, run `-savecheck`, and wait for PASS.
3. Run `-savegearcheck` and stand still until its final Gear test PASS/FAIL.
4. Run `-saveverify`; expect PASS for unchanged original inventory.
5. Send the exact Gear test result. If it crashes, send the last visible numbered
   STEP line. If cleanup needs attention, run `-savehousecleanup` and send its result.

The test journals all57 original inventory positions and takes the existing
bounded scalar/dynamic trigger guard. It creates a separate hero of your selected
hero type at the original house position, hides/pauses/protects it, and adds the
reviewed native bag/equipment/UI abilities. Native shape must read six quick slots,
30 backpack slots and empty equipment; the temporary hero is never published in
live player references. The shared sixty-second watchdog retains failed resources
for cleanup retry and restores original trigger states.

The builder verifies real Sprint Shoes `f003` are Boots with exactly `A0MU,fGmk`,
max health1, speed ability bonus80 and a zero-stat equipment marker. These are
existing item/ability definitions; CF does not alter objects. Two temporary pairs
have exact life1, quantities0/120, different binding and droppable flags.

One pair retains its passive and enters Boots slot3 (zero-based). The temporary
hero's measured starting speed must increase by80. Starting speed must be45..442
to leave room below this map's522 maximum. The other pair is prepared as stored cargo:
its speed passive is removed, its equipment marker retained, and earlier empty
slots are reserved using tracked `fGap` spacers so it reaches bag slot29 (the
30th slot). Spacers are removed and exact item positions/properties rechecked.
The stored pair must add no speed. Both pairs are removed and speed must return
to the measured starting value before the temporary hero is deleted and the
original journal verified.

An unexpected bag/equipment item blocks hero disposal rather than deleting foreign
cargo. Native failures remain failures; speed diagnostics show requested/actual
values. Native getter semantics, item effects, equipment behavior and operation
limits are human engine gates, separate from simulated-source tests and compilation.

This is a narrow Boots/passive/last-bag-slot gate. Ring placement, other passive
families, full derived-stat projection, prepared profile/hero transactions,
successful commit, durable save/restart and multiplayer acceptance remain open.
