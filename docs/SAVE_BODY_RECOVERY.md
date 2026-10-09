# Living original hero body recovery — isolated checkpoint

2026-10-09. Forsaken-save-body.j captures and restores current health and mana,
X/Y position, facing, hidden/paused/invulnerable flags on original living heroes.
It adds no map route, serialization, replacement activation or load commit.

## Capture and identity

FSB_Begin requires ready hero/session/progression/item journals, no replacement
batch/reference plan and an idle codec writer. It captures the same 25 reference
positions as the hero journal (22 cached jobs, Freelancer, Gaya, active hero).
Aliases restore once. Its own unit/rawcode/owner/table/cache references survive
other journal release. Capture performs no native setters, rejects invalid body
values, rechecks readback and clears partial references on refusal.

Coordinates are bounded to [-32768,32768], facing to [0,360), health to
(0.405,maximum] and mana to [0,maximum]. NaN, infinity, dead heroes and unsupported
values refuse capture. Zero mana/maximum mana is supported. These are transient
same-game native real values, not exported save-code fields.

## Recovery and release

States: idle, captured, restored, blocked. FSB_Recover blocks new item/unit
staging, preparation/placement, reference planning/application and public codec
operations before attempting recovery. Its independent item-journal pending
guard prevents disposal until verified release.

Recovery checks all original references, rawcodes and owners before any setter.
Dead/destroyed/replaced originals refuse; there is no resurrection. Maximum
health/mana must exactly match capture, so progression/equipment effects must
recover before body setters. When replacement references have been published,
FSR_Reverse must first restore the originals. A failed preflight retains guards
and the journal for recovery after the prerequisite is corrected.

Each unique hero receives eight writes: SetUnitX, SetUnitY, BlzSetUnitFacingEx,
SetWidgetLife, mana via SetUnitState, invulnerability, visibility and pause state.
Facing uses the immediate native rather than an animated turn. Every field is
read back; silent rejection or drift keeps state blocked and retryable. Journal
locks exclude reentrant public operations during setters. No units are created,
removed or assigned new owners. Cooldown refresh remains permitted.

FSB_Release requires restored state, exact body readback and original item
verification. It clears only body guards/references. Other journals may release
first without clearing these guards; releasing body first does not clear theirs.
The original item journal stays pending until body release.

## Validation and limits

17 actual-source harness tests cover all 24 body-write failure positions for the
three-unique-hero fixture, retry, alias deduplication, invalid values, dead and
foreign originals, changed maxima, reentrancy, codec-writer cleanup, reference
reversal, independent guards and release readback. The maximum fixture restores
25 distinct heroes with 200 writes at player 7/index 199. These are native mocks;
Warcraft engine acceptance is still required.

All 264 prior save-system checks also pass: 281 total. Standalone, BT runtime and
BT editor compile probes pass; report:
build/save-codec-compile-0cy567c4/report.json. Compiler checks required execution
outside the sandbox because of the existing Windows DLL relocation error.

Run test_save_body.py and check_save_jass.py --body with the BT/native-library
arguments in [FORSAKEN_REAPPLICATION.md](FORSAKEN_REAPPLICATION.md).

The caller must hold synchronized gameplay exclusion and suppress gameplay
hooks, movement and regeneration throughout mutation/readback. Exact native
position/facing/HP/MP behavior and operation limits still need engine tests.
This module does not restore buffs/durations, orders, selections, fly height,
movement speed, pathing, research queues or derived combat effects. Dead-hero
loads need an explicit policy. Successful replacement ownership/activation,
prepared-state controller, scheduling, complete commit, file/restart and
multiplayer acceptance remain open.

BT/private BU unchanged; BV unused. BU remains the inventory/codec diagnostic.
Full new character saving/loading remains blocked.
