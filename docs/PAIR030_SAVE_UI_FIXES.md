# PAIR030 save comparison and UI follow-up

Build transforms use the saved editor master without changing it. Shared save,
Priest and legendary changes apply to both profiles. Native inventory/presentation
changes apply only to Forsaken.

## Save compatibility

PAIR029's final full-profile byte comparison rejected a valid older profile when
recapture added the new optional legendary-progress section. Loading does not
rewrite the source character file. Keep original character files.

Readback now compares every original non-trial section's identity, schema, required
flag and payload exactly. Only section 11 uses semantic comparison: absent old
flags default false, and already-Legendary job tiers imply completed job trials.
New flags must equal the expected set, with no missing or extra progress. The
bounded real codec tests accept seven-section saves plus valid new trial defaults
and reject independently changed inventory, jobs, core, Gaya, upgrades, titles and
armory payloads. Temporary verification contexts are cleared afterward.

A read-only check of the existing local dev.txt character file decoded all seven
sections (2,053 code characters) and accepted the same profile with the new
optional defaults. Its SHA-256 stayed unchanged. This checks codec/readback
compatibility; full engine placement and load acceptance still need play-testing.

Section 11 schema 1 now permits 61 entries: existing 1..38 meanings stay unchanged;
39..61 store the actual per-job Proof of Strength force memberships. Capture,
validation, fresh-load restore and rollback use the same IDs. -legendary shows the
solo level90+ boss proof and the Spiritual Ritual: bring a Grand Crystal into the
Spring of Life after both proofs. Ritual completion uses actual Legendary mastery.
Older saves cannot recover proof progress that was never encoded.

## Native inventory and talents

The native Backpack command and B toggle shared open intent. Programmatic clicks
used to bind/refresh the native frames are guarded so they cannot toggle intent.
Duplicate keyboard/frame notifications are suppressed. X and Escape close both
panes; item use/drop retains open intent and the Talents toggle preference.

A gear drag targeting an empty hero quick slot now creates the carried alias
straight into that slot, rather than letting UnitAddItem reroute it to the bag
before UnitDropItemSlot. The original stays intact until the destination is
verified. Ownership, charges, saved life and user data carry over; passive stats
remain suspended and active abilities/save identity remain. An occupied target is
left intact; use an empty hero slot. Actual drag event acceptance needs engine
verification; Gaya-to-hero transfer remains available.

Talent grid labels are blank: names and descriptions appear on hover. Locked and
selected icons remain hoverable while click eligibility is independently checked.
The heading shows earned tier points out of four and Novice/Master/Ultimate/
Legendary, independent of points already spent. Hover boxes align inside the panel
width with 0.018 inset and a narrower text area to keep text off the stone border.

## Tranquility / Acid Rain

Authored master data is 400 HP each 0.1 seconds. Acid Rain splits each pulse into
200 base healing and 200 base magic damage: 2,000 of each per second before target
modifiers. Lower ranks use half their own current-rank pulse. The tooltip now
states both per-pulse and per-second amounts, only while the talent is selected.

Scripted pulses use the Chaos attack type to avoid the native attack/armor-type
multiplier before map healing/magic calculations; enemy hits retain magic damage
and the map's normal defenses. A second Priest no longer restarts the shared rain
timer while it is already running. Regression tests check all ten master pulses
within one modeled second, ally/enemy/dead/immune filters and channel cleanup.
The previously reported 155-per-second observation is not reproduced by the
modeled runtime; actual engine verification remains necessary.

## Acceptance

Both paired builds and final archive audit passed. Native215 tests (one isolated
reference-only skip), classic315 (11 expected skips); all compiler/editor/startup/
content/save/armory/bazaar checks and classic conversion passed. The archive audit
checks all105 calculation ability IDs, all276 carried aliases and native save
bindings, strict original-section readback, optional proof flags, final talent
layout and toggle/placement code. Both TEST copies match their published hashes;
the editor master is unchanged.

In Warcraft test the original failing
character file, native Backpack/B/X/Escape and both panels, Holy Book/Tournesol drag
into empty hero slots (no stats, working actives), normal equipping, talent hover
and heading, and master Acid Rain against wounded allies/enemies for a measured
second. Include two Priests channeling together and multiplayer save/load.
The older legacy large-profile Warcraft menu saved-game crash remains separate.
