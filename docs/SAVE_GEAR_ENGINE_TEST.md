# Private real equipment and backpack diagnostic — CK

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

CF engine confirmed plan count0, actual item IDs A0MU,fGmk after pickup;
unit ability=yes, speed440, cleanup/originals/release=yes. CG initializes only
absent object-reviewed boots abilities with BlzItemAddAbility before preparation,
requires both lookups and an exact two-ID preparation plan, then retains all
equipment, stored-passive, metadata, speed and cleanup checks. This is a private
fixture initialization gate, not a general save-loader implementation.
CG:50 focused checks,96 repository tests,2,000 codec cases and mandatory build
gates PASS. Installed-library compilation PASS;517 other archive members and
original editor source preserved; output and11 private source hashes match.
CG engine failed boots initialization readback on the ground; cleanup, originals
and release passed. CH removes the attempted ground ability additions. Its private
fixture placement helper puts owned allocations directly in Boots3/bag29 on the
contained unpublished hero, then prepares readable held abilities. Shared effect
preparation additionally accepts only exact tracked bag/equipment placement,
matching owner and storage mode. Missing/extra/duplicate abilities still fail;
both fixtures must record exactly two reviewed IDs. Existing pre-prepared placement
primitives remain unchanged; this contained sequence awaits engine acceptance.
CH:51 focused checks,96 repository tests,2,000 codec cases and mandatory build
gates PASS. Installed-library compilation PASS;517 other archive members and
original editor source preserved; output and11 private source hashes match.

CH engine passed held ability/slot preparation, then failed equipped speed:
wanted420, actual440 (fresh baseline340). Cleanup/originals/release=yes.
CI measures a same-holder speed control after equipment: remove A0MU, require
exact remaining marker and metadata, yield and measure the settled passive-free
speed, then restore A0MU and require exact80 gain. Stored cargo must leave that
speed unchanged and final deletion must return to the control baseline. The cause
of the20-point recalculation is not established; no bonus formula is inferred.
CI:11 focused probe tests,96 repository tests,2,000 codec cases and mandatory
build gates PASS. Installed-library compilation PASS;517 other archive members
and original editor source preserved; output and11 private source hashes match.

CI engine passed passive removal, then failed restoration enumeration: planned
two IDs, enumeration only fGmk; the direct lookup did not report A0MU missing.
Cleanup/originals/release=yes. Restoration remains an unresolved separate gate.
CJ preserves the equipped pair's initial abilities, measures its settled equipped
speed, requires stored cargo to leave that speed unchanged, then requires an exact
80-point reduction after all owned items are deleted. Empty speed must be45..442;
equipped speed45..522. This tests the save-load allocation lifecycle without the
extra remove/re-add operation; all membership and metadata checks remain strict.
CJ:12 focused probe tests,96 repository tests,2,000 codec cases and mandatory
build gates PASS. Installed-library compilation PASS;517 other archive members
and original editor source preserved; output and11 private source hashes match.

CJ engine passed equipment preparation and speed capture, then failed stored
bag29 plan count0. Cleanup/originals/release=yes. CK prepares the stored fixture
in quick0: enumerates both reviewed IDs, removes the passive and verifies the
remaining marker, then removes that allocation from quick0 and inserts it into
bag29 with tracked fillers. Its private stored fixture checker requires exact
bag identity, ownership, metadata, ready/stored two-ID plan and no readable speed
passive. If bag enumeration is readable it also requires shared FSA_Check;
an empty enumeration uses the verified active-slot preparation history and the
independent unchanged-speed check. Shared FSA_Check is not weakened. Bag-to-active
restoration and generic opaque-bag verification remain separate open gates.
CK:34 focused checks,96 repository tests,2,000 codec cases and mandatory build
gates PASS. Installed-library compilation PASS;517 other archive members and
original editor source preserved; output and11 private source hashes match.

Use `release/Forsaken/FFERPG_0.9.7.3-r16-ForsakenCK.w3x` in a fresh Reforged game.
CB's synthetic six-slot house test is user-confirmed PASS. CK includes a separate
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
existing item/ability definitions; CK does not alter objects. Two temporary pairs
have exact life1, quantities0/120, different binding and droppable flags.

One pair retains its passive and enters Boots slot3 (zero-based). The temporary
hero's equipped speed must exceed its post-deletion empty speed by exactly80.
Fresh and final empty readings must be45..442; equipped speed must be45..522.
The other pair is prepared in quick0 before transfer to stored cargo: its speed
passive is removed and its equipment marker verified while active. Earlier empty
slots are reserved using tracked `fGap` spacers so it reaches bag slot29 (the
30th slot). Spacers are removed and exact item positions/properties rechecked.
The stored pair must add no speed. Both pairs are removed and speed must drop
by exactly80 before the temporary hero is deleted and the
original journal verified.

An unexpected bag/equipment item blocks hero disposal rather than deleting foreign
cargo. Native failures remain failures; speed diagnostics show requested/actual
values. Native getter semantics, item effects, equipment behavior and operation
limits are human engine gates, separate from simulated-source tests and compilation.

This is a narrow Boots/passive/last-bag-slot gate. Ring placement, other passive
families, full derived-stat projection, prepared profile/hero transactions,
successful commit, durable save/restart and multiplayer acceptance remain open.
