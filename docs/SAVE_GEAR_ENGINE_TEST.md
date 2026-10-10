# Private real equipment and backpack diagnostic — CC

SHA256: `56757f112828cf8e313f6f1cb48338870dd5d4aca6aa4f9e392f5e0abc50a534`.
Mandatory gates,96 repository tests,2,000 codec cases and61 focused checks PASS.
Finished-map compilation against installed native libraries PASS.517 other archive
members and original editor source preserved;11 private input hashes match.
Real-engine CC acceptance remains pending.

Use `release/Forsaken/FFERPG_0.9.7.3-r16-ForsakenCC.w3x` in a fresh Reforged game.
CB's synthetic six-slot house test is user-confirmed PASS. CC adds a separate
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
existing item/ability definitions; CC does not alter objects. Two temporary pairs
have exact life1, quantities0/120, different binding and droppable flags.

One pair retains its passive and enters Boots slot3 (zero-based). The temporary
hero's speed must change from200 to280. The other pair is prepared as stored cargo:
its speed passive is removed, its equipment marker retained, and earlier empty
slots are reserved using tracked `fGap` spacers so it reaches bag slot29 (the
30th slot). Spacers are removed and exact item positions/properties rechecked.
The stored pair must add no speed. Both pairs are removed and speed must return
to200 before the temporary hero is deleted and the original journal verified.

An unexpected bag/equipment item blocks hero disposal rather than deleting foreign
cargo. Native failures remain failures; speed diagnostics show requested/actual
values. Native getter semantics, item effects, equipment behavior and operation
limits are human engine gates, separate from simulated-source tests and compilation.

This is a narrow Boots/passive/last-bag-slot gate. Ring placement, other passive
families, full derived-stat projection, prepared profile/hero transactions,
successful commit, durable save/restart and multiplayer acceptance remain open.
